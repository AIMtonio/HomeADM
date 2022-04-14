-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOAJUSTEINPCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOAJUSTEINPCPRO`;
DELIMITER $$


CREATE PROCEDURE `CALCULOAJUSTEINPCPRO`(
# ============================================================================
# --- PROCESO PARA EL CALCULO DE AJUSTES DE CUENTAS, INVERSIONES Y CEDES ----
# ============================================================================
	Par_Fecha				DATE,			-- Fecha Registro informacion para el calculo del Interes Real
    Par_ClienteID			INT(11),		-- Numero de Cliente
	Par_TipoInstrumentoID	INT(11),		-- Tipo de Instrumento: 2 = Cuentas 13 = Inversiones 28 = Cedes
	Par_InstrumentoID		BIGINT(12),		-- Numero de Instrumento: Numero de Cuenta, Inversion o CEDE
	Par_Monto				DECIMAL(18,2),	-- Valor del Monto
	Par_FechaInicio			DATE,			-- Fecha de Inicio
    Par_FechaFin			DATE,			-- Fecha Final

	Par_Salida				CHAR(1),		-- Indica si espera un SELECT de salida
	INOUT Par_NumErr 		INT(11),		-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400), 	-- Descripcion de Error

    Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
    )

TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Fecha 		DATE;
	DECLARE Var_INPC		DECIMAL(18,4);
    DECLARE	Var_Ajuste 		DECIMAL(18,4);
	DECLARE Var_Inicio		INT(11);
    DECLARE Var_Anio1		INT(11);

    DECLARE Var_Anio2		INT(11);
    DECLARE Var_Mes1		INT(11);
    DECLARE Var_Mes2		INT(11);
    DECLARE Var_NumMes		INT(11);
    DECLARE Var_NumAnio		INT(11);

    DECLARE Var_PenultNumMes	INT(11);
    DECLARE Var_ValorINPC	DECIMAL(18,4);
    DECLARE Var_Control 	VARCHAR(100);
    DECLARE Var_Mes			CHAR(2);

    DECLARE Var_Anio		CHAR(4);
    DECLARE Var_MesAnio		CHAR(10);

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);
    DECLARE Decimal_Cero	DECIMAL(12,2);
    DECLARE Est_NoCalculado	CHAR(1);
    DECLARE Salida_NO		CHAR(1);
	DECLARE Salida_SI		CHAR(1);

	DECLARE InstrumentoCta	INT(11);

    -- Asignacion de Constantes
    SET Entero_Cero			:= 0;				-- Entero Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal Cero
    SET Est_NoCalculado		:= 'N';				-- Estatus del Calculo de Interes Real: No calculado
    SET Salida_NO 			:= 'N';				-- Salida No
	SET Salida_SI        	:= 'S';				-- Salida Si

    SET InstrumentoCta		:= 2;				-- Tipo de Instrumento: Cuentas

	-- Asignacion de Variables
	SET Var_Anio1 		:= YEAR(Par_FechaInicio);
	SET Var_Anio2 		:= YEAR(Par_FechaFin);
	SET Var_Mes1 		:= MONTH(Par_FechaInicio);
	SET Var_Mes2 		:= MONTH(Par_FechaFin);
	SET Var_Ajuste 		:= Decimal_Cero;

    SET Var_Inicio 		:= Entero_Cero;
	SET Var_NumAnio 	:= Var_Anio2-Var_Anio1;


	 ManejoErrores:BEGIN     #bloque para manejar los posibles errores
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		  SET Par_NumErr  = 999;
		  SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CALCULOAJUSTEINPCPRO');
		  SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Se compara el Anio Inicial y Final
		IF (Var_Anio1 = Var_Anio2) THEN
			SET Var_NumMes := Var_Mes2 - Var_Mes1;
		END IF;

		CASE Var_NumAnio
			WHEN Entero_Cero THEN
				SET Var_NumMes := Var_NumMes + 1;
			ELSE
				BEGIN
					SET Var_NumMes := Var_NumAnio * (12) - Var_Mes1 + Var_Mes2 + 1;
				END;
		END CASE;

		-- Se obtiene el valor de las fechas y el valor del INPC
		SET Var_Fecha 	:= (SELECT LAST_DAY(Par_FechaInicio - INTERVAL 1 MONTH));
		SET Var_INPC 	:= (SELECT ValorINPC FROM INDICENAPRECONS WHERE FechaFinMes = Var_Fecha);

		-- Se obtiene el valor del penultimo mes
		SET Var_PenultNumMes := Var_NumMes - 1;

		-- Se obtiene el valor del Ajuste
		WHILE (Var_Inicio < Var_NumMes) DO

			IF (Var_Inicio = Var_NumMes) THEN
				SET Var_Fecha	:= Par_FechaInicio;
			END IF;

			IF(Var_NumMes < 3)THEN
				IF(Var_NumMes = 1) THEN
					IF (Var_Mes1 = Var_Mes2 AND Var_Anio1 = Var_Anio2 AND Par_TipoInstrumentoID = InstrumentoCta) THEN
						SET Var_Ajuste := Var_Ajuste +(SELECT
							IF(Var_Mes1 = Var_Mes2,DATEDIFF(Par_FechaFin,Par_FechaInicio)+1,DATEDIFF(FechaFinMes, Par_FechaInicio)+1)*((TRUNCATE((ValorINPC/Var_INPC),4)-1)/DAY(FechaFinMes)) * Par_Monto AS Ajuste
								FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
					ELSE
                        SET Var_Ajuste := Var_Ajuste +(SELECT
							IF(Var_Mes1 = Var_Mes2,DATEDIFF(Par_FechaFin,Par_FechaInicio),DATEDIFF(FechaFinMes, Par_FechaInicio))*((TRUNCATE((ValorINPC/Var_INPC),4)-1)/DAY(FechaFinMes)) * Par_Monto AS Ajuste
								FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
					END IF;
				END IF;

                IF(Var_NumMes = 2)THEN
					 SET Var_Ajuste := Var_Ajuste + (SELECT
						IF(Var_Inicio = Var_NumMes-1,DAY(Par_FechaFin)-1,DATEDIFF(FechaFinMes, Par_FechaInicio)+1)*((TRUNCATE((ValorINPC/Var_INPC),4)-1)/DAY(FechaFinMes)) * Par_Monto AS Ajuste
							FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
                END IF;

				SET Var_INPC := (SELECT ValorINPC FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);

				SET Var_Inicio 	:= Var_Inicio + 1;
				SET Par_FechaInicio := (SELECT FechaFinMes FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
				SET Var_Fecha := Par_FechaInicio;

			END IF;


			IF(Var_NumMes >= 3)THEN
			  IF(Var_Inicio = Entero_Cero)THEN
				SET Var_ValorINPC := (SELECT ValorINPC FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
				SET Var_Ajuste := Var_Ajuste + (SELECT
				IF(Var_Inicio = Var_NumMes-1,DAY(Par_FechaFin),DATEDIFF(FechaFinMes, Par_FechaInicio)+1)*((TRUNCATE((ValorINPC/Var_INPC),4)-1)/DAY(FechaFinMes)) * Par_Monto AS Ajuste
					FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
			  END IF;

			  IF((Var_Inicio + 1) = Var_PenultNumMes)THEN
				 SET Var_Ajuste := Var_Ajuste + (SELECT ((TRUNCATE((ValorINPC/Var_ValorINPC),4)-1)) * Par_Monto AS Ajuste
					FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
			  END IF;

			  IF((Var_Inicio + 1) = Var_NumMes)THEN
				SET Var_Ajuste := Var_Ajuste + (SELECT
				IF(Var_Inicio = Var_NumMes-1,DAY(Par_FechaFin)-1,DATEDIFF(FechaFinMes, Par_FechaInicio))*((TRUNCATE((ValorINPC/Var_INPC),4)-1)/DAY(FechaFinMes)) * Par_Monto AS Ajuste
					FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
			  END IF;

			  SET Var_INPC := (SELECT ValorINPC FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);

			  SET Var_Inicio 	:= Var_Inicio + 1;
			  SET Par_FechaInicio := (SELECT FechaFinMes FROM INDICENAPRECONS WHERE FechaFinMes > Var_Fecha ORDER BY FechaFinMes LIMIT 1);
			  SET Var_Fecha := Par_FechaInicio;

			END IF;

		END WHILE;

        -- Se obtiene el valor del mes y anio de la fecha de vencimiento que aun no se haya calculado el Interes Real
		SET Var_Mes		:= (SELECT SUBSTRING(Par_FechaFin,6,2));
		SET Var_Anio	:= (SELECT SUBSTRING(Par_FechaFin,1,4));
		SET Var_MesAnio	:= (SELECT CONCAT(Var_Mes,Var_Anio));

		-- Se actualiza el valor del Ajuste
		UPDATE CALCULOINTERESREAL SET
			Ajuste = IFNULL(ROUND(Var_Ajuste,2),Decimal_Cero)
		WHERE Fecha = Par_Fecha
			AND ClienteID = Par_ClienteID 
			AND TipoInstrumentoID = Par_TipoInstrumentoID
			AND InstrumentoID = Par_InstrumentoID;

        SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Calculo de Ajuste Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen	AS ErrMen;
	END IF;

END TerminaStore$$