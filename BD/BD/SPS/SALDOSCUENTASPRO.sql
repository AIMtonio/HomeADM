-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCUENTASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCUENTASPRO`;
DELIMITER $$


CREATE PROCEDURE `SALDOSCUENTASPRO`(
-- Store de Proceso para calcular el saldo final de cada una de las cuentas contables por dia
	Par_FechaIni		DATE,			-- Fecha de Inicio
	Par_FechaFin		DATE,			-- Fecha Final
 	Par_Salida			CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr   	INT,			-- Numero de Error
    INOUT Par_ErrMen   	VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)

TerminaStore: BEGIN
	-- Declaracion de variables
    DECLARE Var_FechaCiclo		DATE;
    DECLARE Var_FechaAnterior	DATE;
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
    DECLARE SalidaSI			CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
    SET Decimal_Cero			:= 0.0;
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET SalidaSI				:= 'S';
    -- Asignacion de variables
    SET Var_FechaAnterior 	:= (Par_FechaIni - INTERVAL 1 DAY);
    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-SALDOSCUENTASPRO');
		END;


        SET Var_FechaCiclo := Par_FechaIni;
        WHILE (Var_FechaCiclo <= Par_FechaFin) DO
         -- Tabla con los detalles del dia
        DROP TABLE IF EXISTS TMPDETALLESHIS;
		CREATE TEMPORARY TABLE TMPDETALLESHIS(
			`RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			CuentaCompleta	VARCHAR(25) ,
			Abonos		DECIMAL(18,2),
			Cargos		DECIMAL(18,2),
			Fecha		DATE,
			INDEX(CuentaCompleta, Fecha)
			);
		-- Tabla con la sumatoria de cargos y abonos de las cuentas
		DROP TABLE IF EXISTS TMPSALDOXCUENTA;
		CREATE TEMPORARY TABLE TMPSALDOXCUENTA(
			RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			CuentaCompleta	VARCHAR(25) ,
			SumAbonos		DECIMAL(18,2),
			SumCargos		DECIMAL(18,2),
			Fecha			DATE,
			INDEX(CuentaCompleta)
			);
        -- ********************************************
			-- Se llena la tabla temporal con los detalles de las polizas
			INSERT INTO TMPDETALLESHIS (CuentaCompleta, Abonos, Cargos, Fecha)
				(SELECT CuentaCompleta, Cargos,Abonos, Fecha FROM DETALLEPOLIZA CuentaCompleta
					WHERE Fecha BETWEEN DATE_FORMAT(Var_FechaCiclo ,'%Y-%m-01') AND LAST_DAY(Var_FechaCiclo))
				UNION ALL
				(SELECT CuentaCompleta, Cargos,Abonos, Fecha FROM `HIS-DETALLEPOL`
					WHERE Fecha BETWEEN DATE_FORMAT(Var_FechaCiclo ,'%Y-%m-01') AND LAST_DAY(Var_FechaCiclo));

			-- Se Insertan las sumatarias de los cargos y los abonos x cuenta
			INSERT INTO TMPSALDOXCUENTA(CuentaCompleta, SumAbonos, SumCargos, Fecha)
				SELECT CuentaCompleta, SUM(Cargos), SUM(Abonos), LAST_DAY(Fecha)
					FROM TMPDETALLESHIS
					GROUP BY CuentaCompleta,LAST_DAY(Fecha) ORDER BY CuentaCompleta;

            -- Insertando los saldos finales de las cuentas en la tabla historica
			INSERT INTO SALDOFINCTA(
				CuentaContable,				Fecha,					SaldoFinal,		EmpresaID,		Usuario,
				FechaActual,				DireccionIP,			ProgramaID,		Sucursal,	NumTransaccion)
				SELECT
					TMP.CuentaCompleta, 	LAST_DAY(TMP.Fecha), 		(IFNULL(SA.SaldoFinal, Decimal_Cero)+
															TMP.SumAbonos-TMP.SumCargos) as SaldoFinal,		Par_EmpresaID, Aud_Usuario,
				Aud_FechaActual, 			Aud_DireccionIP, 		Aud_ProgramaID, 	Aud_Sucursal, Aud_NumTransaccion
					FROM TMPSALDOXCUENTA AS TMP
						LEFT JOIN SALDOFINCTA AS SA ON TMP.CuentaCompleta=SA.CuentaContable
							AND TMP.Fecha=(SA.Fecha - INTERVAL 1 DAY);
			-- ******************************************

            SET Var_FechaCiclo := Var_FechaCiclo + INTERVAL 1 MONTH;

        END WHILE;

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Proceso Finalizado Exitosamente';

	END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'fechaInicio' AS Control,
				Cadena_Vacia AS Consecutivo;
	END IF;


END TerminaStore$$
