-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RENDIMIENTOSCTASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RENDIMIENTOSCTASPRO`;
DELIMITER $$


CREATE PROCEDURE `RENDIMIENTOSCTASPRO`(
# ===============================================================================================
# --- PROCESO PARA OBTENER EL RENDIMIENTO DE LAS CUENTAS PARA EL CALCULO DEL INTERES REAL -------
# ===============================================================================================
	Par_Fecha				DATE,				-- Fecha de Operacion
    Par_Tipo				INT(11),			-- Tipo de Operacion: Rendimiento o Cancelacion de Cuentas

	Par_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaInicio		DATE;
    DECLARE Var_FechaFin		DATE;
    DECLARE Var_CuentaStr       VARCHAR(20);
	DECLARE Var_ClienteID       INT(11);
	DECLARE Var_CuentaAhoID     BIGINT(12);

	DECLARE Var_Monto           DECIMAL(14,2);
    DECLARE Var_InteresGenerado DECIMAL(14,2);
	DECLARE Var_ErrorKey      	INT DEFAULT 0;
    DECLARE Var_FechaApertura	DATE;
    DECLARE Var_TasaInteres	    DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE InstrumentoCta		INT(11);

    DECLARE	Var_Si				CHAR(1);
	DECLARE	Var_No				CHAR(1);
	DECLARE RendimientoCta		INT(11);		-- Tipo: Rendimiento de la Cuenta
    DECLARE CancelaCta			INT(11);		-- Tipo: Cancelacion de la Cuenta

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.00; 			-- Decimal Cero
	SET InstrumentoCta		:= 2;				-- Tipo de Instrumento: Cuentas

	SET	Var_Si				:= 'S'; 			-- Valor: Si
	SET	Var_No				:= 'N'; 			-- Valor: No
	SET RendimientoCta		:= 1;				-- Tipo: Rendimiento de la Cuenta
	SET CancelaCta			:= 2;				-- Tipo: Cancelacion de la Cuenta

	SET Var_FechaInicio  := (SELECT Par_Fecha - INTERVAL (DAY(Par_Fecha)-1) DAY);
	SET Var_FechaFin	 := (SELECT LAST_DAY(Par_Fecha));

    IF(Par_Tipo = RendimientoCta)THEN
		INSERT INTO CALCULOINTERESREAL(
			Fecha,				Anio,				Mes,					ClienteID, 			TipoInstrumentoID,
			InstrumentoID, 		Monto,				FechaInicio,			FechaFin,			InteresGenerado,
			ISR,				TasaInteres,		Ajuste,					InteresReal,		Estatus,
			FechaCalculo,
			EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion
		)SELECT
			Par_Fecha,			YEAR(Par_Fecha),	MONTH(Par_Fecha),		TMP.ClienteID,		InstrumentoCta,
			TMP.CuentaAhoID,  	TMP.SaldoProm,		CASE WHEN CUE.FechaApertura >= Var_FechaInicio AND CUE.FechaApertura <= Var_FechaFin
													THEN CUE.FechaApertura ELSE
													Var_FechaInicio END,	Var_FechaFin,		TMP.InteresesGen,
			TMP.ISR,			TMP.TasaInteres,	Decimal_Cero,			Decimal_Cero,		Var_No,
			Fecha_Vacia,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		FROM TMPCUENTASAHOCI TMP
			INNER JOIN CUENTASAHO CUE
				ON TMP.CuentaAhoID = CUE.CuentaAhoID
		WHERE TMP.InteresesGen > Entero_Cero;

    END IF;

	IF(Par_Tipo = CancelaCta)THEN
		INSERT INTO CALCULOINTERESREAL(
			Fecha,				Anio,				Mes,					ClienteID, 			TipoInstrumentoID,
			InstrumentoID, 		Monto,				FechaInicio,			FechaFin,			InteresGenerado,
			ISR,				TasaInteres,		Ajuste,					InteresReal,		Estatus,
			FechaCalculo,
			EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		SELECT
			Par_Fecha,			YEAR(Par_Fecha),	MONTH(Par_Fecha),		TMP.ClienteID,		InstrumentoCta,
			TMP.CuentaAhoID,  	TMP.SaldoProm,		CASE WHEN CUE.FechaApertura >= Var_FechaInicio AND CUE.FechaApertura <= Var_FechaFin
													THEN CUE.FechaApertura ELSE
													Var_FechaInicio END,	Var_FechaFin,		TMP.InteresesGen,
			TMP.ISR,			TMP.TasaInteres,	Decimal_Cero,			Decimal_Cero,		Var_No,
			Fecha_Vacia,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		FROM TMPCUENTASCANCELCLI TMP
			INNER JOIN CUENTASAHO CUE
				ON TMP.CuentaAhoID = CUE.CuentaAhoID
		WHERE TMP.InteresesGen > Entero_Cero;
    END IF;

END TerminaStore$$