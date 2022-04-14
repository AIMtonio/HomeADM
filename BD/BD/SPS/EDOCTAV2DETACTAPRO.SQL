-- SP EDOCTAV2DETACTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2DETACTAPRO;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2DETACTAPRO`(
	--  SP para obtener los detalles de movimientos de la cuenta
    Par_Salida			CHAR(1),				-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
	TerminaStore: BEGIN
--  Declaracion de Constantes
	DECLARE	Cadena_Vacia			VARCHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE	Moneda_Cero				DECIMAL(14,2);
	DECLARE Poliza_Cero				BIGINT(20);
	DECLARE Var_FecIniMes			DATE;
	DECLARE Var_FecFinMes			DATE;
	DECLARE Salida_SI				CHAR(1);
    DECLARE NatCargo				CHAR(1);
	DECLARE NatAbono				CHAR(1);
    DECLARE ClasMovISR      		INT(11);
    DECLARE Var_AnioMes				INT(11);
    DECLARE Par_ClienteInstitu		INT(11);
    DECLARE Orden_SalIni			INT(11);
    DECLARE Orden_Movs				INT(11);
    DECLARE Var_FolioProceso		BIGINT(20);
    DECLARE TipoInstrumCtaAho		CHAR(2);
    DECLARE Var_Control				VARCHAR(25);

	--  Asignacion de Constantes
	SET Cadena_Vacia		:= '';				--  Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	--  Fecha Vacia
	SET Entero_Cero			:= 0;				--  Entero Cero
	SET Moneda_Cero			:= 0.00;			--  Moneda Cero
	SET Poliza_Cero			:= 0;				--  Poliza Cero
	SET Salida_SI			:= 'S';
    SET NatCargo        	:= 'C';				--  Naturaleza Movimiento: CARGO
	SET NatAbono			:= 'A';				--  Naturaleza Movimiento: ABONO
	SET ClasMovISR          :=  4;              --  Clasificacion de Movimientos ISR
	SET Orden_SalIni 		:= 0;				-- Es para colocar el movimiento de Saldo Inicial al principio de todos los movimientos
	SET Orden_Movs 			:= 1;				-- Es para colocar los movimientos de la cuenta despues del Saldo Inicial
	SET TipoInstrumCtaAho	:= 'CA';			-- Tipo de Instrumento Cuenta de Ahorro

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2DETACTAPRO');
			SET Var_Control	= 'sqlException';
		END;

	SELECT MesProceso, 	ClienteInstitucion, 	FolioProceso, 		FechaInicio,		FechaFin
	INTO Var_AnioMes, 	Par_ClienteInstitu, 	Var_FolioProceso,	Var_FecIniMes,		Var_FecFinMes
	FROM EDOCTAV2PARAMS;

	DELETE FROM EDOCTAV2DETACTA
	WHERE FolioProceso = Var_FolioProceso;

	--  Se registra la informacion de la cuenta partiendo de los registros de Resumen de Captacion
	INSERT INTO EDOCTAV2DETACTA (AnioMes,				ClienteID,				SucursalID,				CuentaAhoID,			FechaMovimiento,
								Referencia,				Concepto,				Cargo,					Abono,					Orden,
								Transaccion,			FolioProceso, 			EmpresaID,				Usuario,				FechaActual,
								DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)

	SELECT 						Var_AnioMes, 			Cta.ClienteID,  		Cta.SucursalID,			Cta.InstrumentoID,		Var_FecIniMes,
								'SALDO INICIAL',		'SALDO INICIAL',		Entero_Cero,			Cta.SaldoAnterior,		Orden_SalIni,
								Entero_Cero,			Var_FolioProceso,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
	FROM  EDOCTAV2RESUMCAPTA Cta
	WHERE Cta.TipoInstrumento = TipoInstrumCtaAho;

	DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAHISCUENTASMOVS;
	CREATE TEMPORARY TABLE TMPEDOCTAHISCUENTASMOVS
	SELECT His.*
	FROM EDOCTAV2RESUMCAPTA Cta
		INNER JOIN `HIS-CUENAHOMOV` His ON Cta.InstrumentoID = His.CuentaAhoID AND His.Fecha >= Var_FecIniMes
																			 AND His.Fecha <= Var_FecFinMes
	WHERE Cta.FolioProceso = Var_FolioProceso
	ORDER BY  His.CuentaAhoID,  His.Fecha,  His.NumeroMov,  His.NatMovimiento;

	CREATE INDEX IDX_TMPEDOCTAHISCUENTASMOVS_01 ON TMPEDOCTAHISCUENTASMOVS(CuentaAhoID);
	CREATE INDEX IDX_TMPEDOCTAHISCUENTASMOVS_02 ON TMPEDOCTAHISCUENTASMOVS(Fecha);

	--  Se registra los movimientos de la cuenta
	INSERT INTO EDOCTAV2DETACTA( 	AnioMes,				ClienteID,				SucursalID,				CuentaAhoID,			FechaMovimiento,
									Referencia,				Concepto,				Cargo,					Abono,					Orden,
									Transaccion,			FolioProceso, 			EmpresaID,				Usuario,				FechaActual,
									DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)

	SELECT  						Var_AnioMes,			Entero_Cero,			Entero_Cero,			CuentaAhoID,			Fecha,
									ReferenciaMov,			DescripcionMov,
									CASE NatMovimiento 	WHEN NatCargo THEN CantidadMov
														ELSE Moneda_Cero
									END,
									CASE NatMovimiento 	WHEN NatAbono THEN CantidadMov
														ELSE Moneda_Cero
									END,
									Orden_Movs,
									NumTransaccion,
									Var_FolioProceso,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
	FROM TMPEDOCTAHISCUENTASMOVS
	ORDER BY CuentaAhoID, Fecha, NumTransaccion;

	-- Se actualiza la Sucursal Origen del Cliente
	UPDATE EDOCTAV2DETACTA Edo
		INNER JOIN CUENTASAHO Cue ON Edo.CuentaAhoID = Cue.CuentaAhoID
	SET  Edo.SucursalID = Cue.SucursalID,
		 Edo.ClienteID  = Cue.ClienteID;

	 SET Par_NumErr		:= Entero_Cero;
	 SET Par_ErrMen		:= CONCAT('Detalle de Cuentas de Ahorro Terminado exitosamente con Folio: ', CAST(Var_FolioProceso AS CHAR));
	 SET Var_Control	:= 'EDOCTAV2DETACTAPRO';

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
