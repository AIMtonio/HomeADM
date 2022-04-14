-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCUENTASAHOWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCUENTASAHOWSPRO`;DELIMITER $$

CREATE PROCEDURE `CRCBCUENTASAHOWSPRO`(
# =====================================================================================
# ------- STORE PARA CONSULTAR LAS CUENTAS DE AHORRO POR WS PARA CREDICLUB ---------
# =====================================================================================
	Par_CuentaAhoID		BIGINT(12),			-- Numero de Cuenta
	Par_Anio			INT(11),			-- Numero de Anio
	Par_Mes				INT(11),			-- Numero de Mes

    Par_Salida			CHAR(1), 			-- Indica mensaje de Salida
	INOUT Par_NumErr	INT(11),			-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),		-- Descripcion de Error

    Par_EmpresaID		INT(11),			-- Paramatro de Auditoria
	Aud_Usuario			INT(11),			-- Paramatro de Auditoria
	Aud_FechaActual		DATETIME,			-- Paramatro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Paramatro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Paramatro de Auditoria
	Aud_Sucursal		INT(11),			-- Paramatro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Paramatro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
    DECLARE Var_CuentaAhoID 		BIGINT(12);			-- Numero de Cuenta
    DECLARE Var_SaldoDisponible		DECIMAL(14,2);		-- Saldo Disponible de la Cuenta
    DECLARE Var_FechaSistema		DATE;				-- Fecha de Sistema
    DECLARE Var_SaldoInicialMes		DECIMAL(14,2);		-- Saldo Inicial del Mes
    DECLARE Var_AbonosMes			DECIMAL(14,2);		-- Abonos del Mes

    DECLARE Var_CargosMes			DECIMAL(14,2);		-- Cargos del Mes
    DECLARE Var_EjecutaCierre		CHAR(1);			-- indica si se esta realizando el cierre de dia

    -- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
    DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Decimal_Cero	    DECIMAL(12,2);
	DECLARE Fecha_Vacia         DATE;
	DECLARE SimbInterrogacion	VARCHAR(1);

    DECLARE Entero_Uno			INT(11);
	DECLARE Entero_Doce			INT(11);
    DECLARE SalidaSI            CHAR(1);
    DECLARE ValorCierre			VARCHAR(30);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero	    :=  0.00;   			-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
    SET SimbInterrogacion	:= '?';					-- Simbolo de interrogacion

    SET Entero_Uno			:= 1;					-- Entero Uno
	SET Entero_Doce			:= 12;					-- Entero Doce
	SET SalidaSI           	:= 'S';        			-- El Store SI genera una Salida
	SET ValorCierre			:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.

    -- Asignacion de Variables
	SET Par_NumErr			:= Entero_Cero;

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCUENTASAHOWSPRO');
			END;

		-- Se obtiene la Fecha del Sistema
		SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
		-- Se obtiene el Numero de la Cuenta
		SET Var_CuentaAhoID 	:= (SELECT CuentaAhoID	FROM CUENTASAHO	WHERE CuentaAhoID = Par_CuentaAhoID);
		SET Var_CuentaAhoID		:= IFNULL(Var_CuentaAhoID,Entero_Cero);

		SET Par_CuentaAhoID		:= REPLACE(Par_CuentaAhoID, SimbInterrogacion, Entero_Cero);
		SET Par_Anio			:= REPLACE(Par_Anio, SimbInterrogacion, Entero_Cero);
		SET Par_Mes				:= REPLACE(Par_Mes, SimbInterrogacion, Entero_Cero);

		SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

		-- Validamos que no se este ejecutando el cierre de dia
		IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=SalidaSI)THEN
			SET Par_NumErr  := 800;
			SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'La Cuenta no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Anio, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Anio esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Mes, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := 'El Mes esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Mes,Entero_Cero)) !=  Entero_Cero THEN
			IF(Par_Mes < Entero_Uno OR Par_Mes > Entero_Doce)THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'El Valor del Mes es Incorrecto.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Realiza la Consulta de Saldos si la Cuenta Existe
		IF (Var_CuentaAhoID > Entero_Cero)THEN
			-- Se compara si el Anio y el Mes es la misma que la Fecha del Sistema
			IF(Par_Anio = YEAR(Var_FechaSistema) AND Par_Mes = MONTH(Var_FechaSistema) AND Par_NumErr = Entero_Cero) THEN
					SELECT IFNULL(SaldoDispon,Decimal_Cero) INTO Var_SaldoDisponible
					FROM CUENTASAHO
					WHERE CuentaAhoID = Par_CuentaAhoID;

					SELECT	IFNULL(SaldoIniMes,Decimal_Cero) AS SaldoInicialMes,
							IFNULL(AbonosMes,Decimal_Cero) AS AbonosMes,
							IFNULL(CargosMes,Decimal_Cero) AS CargosMes
					INTO    Var_SaldoInicialMes,	Var_AbonosMes,		Var_CargosMes
					FROM CUENTASAHO
					WHERE CuentaAhoID = Par_CuentaAhoID;
			 ELSE

					SELECT 	IFNULL(SaldoDispon,Entero_Cero) INTO Var_SaldoDisponible
					FROM `HIS-CUENTASAHO`
					WHERE CuentaAhoID =	Par_CuentaAhoID
					AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
					AND Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));

					SELECT 	IFNULL(SaldoIniMes,Entero_Cero) AS SaldoInicialMes,
							IFNULL(AbonosMes,Entero_Cero) AS AbonosMes,
							IFNULL(CargosMes,Entero_Cero) AS CargosMes
					INTO    Var_SaldoInicialMes,	Var_AbonosMes,		Var_CargosMes
					FROM `HIS-CUENTASAHO`
					WHERE CuentaAhoID =	Par_CuentaAhoID
					AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
					AND Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));
			END IF;
		END IF;

	END ManejoErrores;

    IF (Par_NumErr = Entero_Cero)THEN
		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Consulta Realizada Exitosamente.';
	END IF;

    IF(Par_Salida = SalidaSI)THEN
		SELECT 	FORMAT(IFNULL(Var_SaldoInicialMes,Decimal_Cero),2) AS SaldoInicialMes,
				FORMAT(IFNULL(Var_AbonosMes,Decimal_Cero),2) AS AbonosMes,
				FORMAT(IFNULL(Var_CargosMes,Decimal_Cero),2) AS CargosMes,
				FORMAT(IFNULL(Var_SaldoDisponible,Decimal_Cero),2) AS SaldoDisponible,
                Par_NumErr	AS NumErr,
				Par_ErrMen  AS ErrMen;
	END IF;

END TerminaStore$$