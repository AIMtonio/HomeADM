-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BONIFICACIONESPRO`;

DELIMITER $$
CREATE PROCEDURE `BONIFICACIONESPRO`(
	-- Store Procedure para el ajuste contable por concepto de bonificacion al cierre de mes
	-- Modulo Bonificaciones
	Par_Fecha 				DATE,			-- Fecha de Operacion

	Par_Salida 				CHAR(1), 		-- Salida en Pantalla
	INOUT Par_NumErr 		INT(11),		-- Parametro de numero de error
	INOUT Par_ErrMen 		VARCHAR(400),	-- Parametro de mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Parametros
	DECLARE Par_PolizaID			BIGINT(20);		-- Numero de Poliza

	-- Declaracion de Variables
	DECLARE Var_NumAmortizaciones	INT(11);		-- Numero de Amortizaciones
	DECLARE Cta_Cargo 				VARCHAR(50);	-- Cuenta Cargo
	DECLARE Cta_Abono 				VARCHAR(50);	-- Cuenta Abono
	DECLARE Var_Control				VARCHAR(50);	-- Control de Pantalla

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_SI 					CHAR(1);		-- Constante SI
	DECLARE Con_NO 					CHAR(1);		-- Constante NO
	DECLARE Est_Vigente 			CHAR(1);		-- Constante Estatus Vigente
	DECLARE Est_Pagado 				CHAR(1);		-- Constante Estatus Pagado

	DECLARE Con_Programada			CHAR(1);		-- Constante Tipo de Poliza Programada
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno 				INT(11);		-- Constante Entero uno
	DECLARE Int_CuentasAho 			INT(11);		-- Constante Instrumento de Cuentas de Ahorro

	DECLARE Con_BonificacionID 		INT(11);		-- Constante Concepto Contable
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Constante Decumal Cero
	DECLARE Con_Procedimiento 		VARCHAR(20);	-- Constante Procedimiento
	DECLARE Des_Poliza 				VARCHAR(150);	-- Constante Concepto
	DECLARE Llave_Cargo 			VARCHAR(200);	-- Constante Llave Parametro Cargo

	DECLARE Llave_Abono 			VARCHAR(200);	-- Constante Llave Parametro Abono
	DECLARE Con_CuentaContable 		VARCHAR(25);	-- Constante Cuenta Contable Vacia

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET Con_SI 						:= 'S';
	SET Con_NO 						:= 'N';
	SET Est_Vigente 				:= 'V';
	SET Est_Pagado 					:= 'P';

	SET Con_Programada 				:= 'P';
	SET Fecha_Vacia 				:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET Entero_Uno 					:= 1;
	SET Int_CuentasAho 				:= 2;

	SET Con_BonificacionID			:= 1102;
	SET	Decimal_Cero				:= 0.0;
	SET Con_Procedimiento 			:= 'BONIFICACIONESPRO';
	SET Llave_Cargo 				:= 'CtaContableResulBonificaciones';
	SET Llave_Abono 				:= 'CtaContablePteBonificaciones';

	SET Des_Poliza 					:= 'AMORTIZACION DE BONIFICACIONES';
	SET Con_CuentaContable 			:= '0000000000000000000000000';

	-- Obtengo la Cuenta de Cargo
	SELECT ValorParametro
	INTO Cta_Cargo
	FROM PARAMETROSCRCBWS
	WHERE LlaveParametro = Llave_Cargo;

	-- Obtengo la Cuenta de Abono
	SELECT ValorParametro
	INTO Cta_Abono
	FROM PARAMETROSCRCBWS
	WHERE LlaveParametro = Llave_Abono;

	-- Se validan parametros nulos
	SET Par_Fecha := IFNULL(Par_Fecha , Fecha_Vacia);
	SET Cta_Abono := IFNULL(Cta_Abono , Con_CuentaContable);
	SET Cta_Cargo := IFNULL(Cta_Cargo , Con_CuentaContable);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-BONIFICACIONESPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_Fecha := LAST_DAY(Par_Fecha);

		SELECT IFNULL(COUNT(Amo.AmortizacionID), Entero_Cero )
		INTO Var_NumAmortizaciones
		FROM AMORTIZABONICACIONES Amo
		WHERE Amo.Fecha = Par_Fecha
		  AND Amo.Estatus = Est_Vigente;

		IF( Var_NumAmortizaciones > Entero_Cero ) THEN

			IF( Par_Fecha = Fecha_Vacia ) THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'La Fecha esta Vacia.';
				SET Var_Control := 'fecha';
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual := NOW();
			CALL MAESTROPOLIZASALT(
				Par_PolizaID,		Par_EmpresaID,		Par_Fecha,			Con_Programada,		Con_BonificacionID,
				Des_Poliza,			Con_NO,				Par_NumErr, 		Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Realizo del Detalle de Abono
			INSERT INTO DETALLEPOLIZA (
				EmpresaID, 			PolizaID, 				Fecha, 					CentroCostoID, 			CuentaCompleta,
				Instrumento, 		MonedaID, 				Cargos, 				Abonos, 				Descripcion,
				Referencia, 		ProcedimientoCont, 		TipoInstrumentoID, 		RFC, 					TotalFactura,
				FolioUUID, 			Usuario, 				FechaActual,			DireccionIP, 			ProgramaID,
				Sucursal, 			NumTransaccion)
			SELECT
				Par_EmpresaID,		Par_PolizaID,			Amo.Fecha,				Suc.CentroCostoID,		Cta_Abono,
				Bon.CuentaAhoID,	Cue.MonedaID, 			Decimal_Cero,			Amo.Monto,				Des_Poliza,
				Bon.CuentaAhoID,	Con_Procedimiento,		Int_CuentasAho,			Cadena_Vacia,			Decimal_Cero,
				Cadena_Vacia,		Aud_Usuario,			NOW(),					Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM BONIFICACIONES Bon
			INNER JOIN AMORTIZABONICACIONES Amo ON Bon.BonificacionID = Amo.BonificacionID
			INNER JOIN CUENTASAHO Cue ON Bon.CuentaAhoID = Cue.CuentaAhoID
			INNER JOIN SUCURSALES Suc ON Cue.SucursalID = Suc.SucursalID
			WHERE Amo.Fecha = Par_Fecha
			  AND Amo.Estatus = Est_Vigente;

			-- Realizo del Detalle de Cargo
			INSERT INTO DETALLEPOLIZA (
				EmpresaID, 			PolizaID, 				Fecha, 					CentroCostoID, 			CuentaCompleta,
				Instrumento, 		MonedaID, 				Cargos, 				Abonos, 				Descripcion,
				Referencia, 		ProcedimientoCont, 		TipoInstrumentoID, 		RFC, 					TotalFactura,
				FolioUUID, 			Usuario, 				FechaActual,			DireccionIP, 			ProgramaID,
				Sucursal, 			NumTransaccion)
			SELECT
				Par_EmpresaID,		Par_PolizaID,			Amo.Fecha,				Suc.CentroCostoID,		Cta_Cargo,
				Bon.CuentaAhoID,	Cue.MonedaID, 			Amo.Monto,				Decimal_Cero,			Des_Poliza,
				Bon.CuentaAhoID,	Con_Procedimiento,		Int_CuentasAho,			Cadena_Vacia,			Decimal_Cero,
				Cadena_Vacia,		Aud_Usuario,			NOW(),					Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM BONIFICACIONES Bon
			INNER JOIN AMORTIZABONICACIONES Amo ON Bon.BonificacionID = Amo.BonificacionID
			INNER JOIN CUENTASAHO Cue ON Bon.CuentaAhoID = Cue.CuentaAhoID
			INNER JOIN SUCURSALES Suc ON Cue.SucursalID = Suc.SucursalID
			WHERE Amo.Fecha = Par_Fecha
			  AND Amo.Estatus = Est_Vigente;

			-- Actualizo las Amortizaciones que se pagan
			UPDATE AMORTIZABONICACIONES Amo SET
				Amo.Estatus 		= Est_Pagado,
				Amo.EmpresaID 		= Par_EmpresaID,
				Amo.Usuario 		= Aud_Usuario,
				Amo.FechaActual 	= NOW(),
				Amo.DireccionIP 	= Aud_DireccionIP,
				Amo.ProgramaID 		= Aud_ProgramaID,
				Amo.Sucursal 		= Aud_Sucursal,
				Amo.NumTransaccion = Aud_NumTransaccion
			WHERE Amo.Fecha = Par_Fecha
			  AND Amo.Estatus = Est_Vigente;

			-- Actualizo las Bonificaciones que son liquidades
			UPDATE BONIFICACIONES Bon SET
				Bon.EmpresaID 		= Par_EmpresaID,
				Bon.Usuario 		= Aud_Usuario,
				Bon.FechaActual 	= NOW(),
				Bon.DireccionIP 	= Aud_DireccionIP,
				Bon.ProgramaID 		= Aud_ProgramaID,
				Bon.Sucursal 		= Aud_Sucursal,
				Bon.NumTransaccion 	= Aud_NumTransaccion
			WHERE Bon.FechaVencimiento = Par_Fecha
			  AND Bon.Estatus = Est_Vigente;

		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Bonificaciones realizadas exitosamente.';
		SET Var_Control := Cadena_Vacia;
	END ManejoErrores;

	IF( Par_Salida = Con_SI ) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Par_Fecha 	AS consecutivo;
	END IF;

END TerminaStore$$