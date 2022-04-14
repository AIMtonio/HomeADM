-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOABONOCTACONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGOABONOCTACONPRO`;
DELIMITER $$

CREATE PROCEDURE `CARGOABONOCTACONPRO`(
	Par_CuentaAhoID			BIGINT(12), 		-- Cuenta de ahorro
	Par_cuentaContable		BIGINT(12), 		-- Cuenta contable a afectar
	Par_ClienteID			BIGINT,				-- ID del cliente al que le pertence la cuenta de ahorro
	Par_NumeroMov			BIGINT,				-- Numero del mov
	Par_Fecha				DATE,				-- Fecha

	Par_NatMovimiento		CHAR(1),  			-- Naturaleza del movimiento para contaAhopro C = Cargo / A = Abono
	Par_CantidadMov			DECIMAL(12,2),  	-- Cantidad a procesar
	Par_DescripcionMov		VARCHAR(150), 		-- Descripcion del mov
	Par_ReferenciaMov		VARCHAR(50), 		-- Referencia para CUENTASAHOMOVS
	Par_TipoMovAhoID		CHAR(4),

	Par_MonedaID			INT,
	Par_SucCliente			INT,
	Par_AltaEncPoliza		CHAR(1),
	Par_ConceptoCon			INT,
	INOUT Par_Poliza		BIGINT,

	Par_ConceptoAho			INT,
	Par_NatConta			CHAR(1), -- NAturaleza del mov contable C = cargo / A = abono
	Par_Consecutivo			BIGINT,

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control 		VARCHAR(100);
	DECLARE Var_Cargos          DECIMAL(14,4);
	DECLARE Var_Abonos          DECIMAL(14,4);
	DECLARE Var_CentroCostos	INT;

	-- Declaracion de Constantes
	DECLARE ClienteInactivo		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE AltaPoliza_SI		CHAR(1);
	DECLARE Var_Descripcion		VARCHAR(200);
	DECLARE Procedimiento		VARCHAR(100);
	DECLARE TipoInstrumentoID 	INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);


	SET	ClienteInactivo		:= 'I';
	SET Entero_Cero			:= 0;
	SET	Salida_NO       	:= 'N';
	SET Salida_SI           := 'S';
	SET AltaPoliza_SI		:= 'S';
	SET Var_Descripcion		:= 'MOVIMIENTO A CUENTA CONTABLE';
	SET Procedimiento		:= 'CARGOABONOCTACONPRO';
	SET TipoInstrumentoID	:= 2;
	SET Cadena_Vacia		:= '';
	SET Decimal_Cero		:= 0.0;
	SET Pol_Automatica		:= 'A';
	SET Nat_Cargo			:= 'C';

	ManejoErrores:BEGIN

		 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGOABONOCTACONPRO');
				SET Var_Control = 'sqlException';
			END;
		
		SET Var_CentroCostos = FNCENTROCOSTOS(Par_SucCliente);

		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Aud_EmpresaID,		Par_Fecha, 	Pol_Automatica,		Par_ConceptoCon,
				Par_DescripcionMov,	Salida_NO,      	Par_NumErr,				Par_ErrMen, 		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(Par_NatConta    = Nat_Cargo) THEN
			SET Var_Cargos  := Par_CantidadMov;
			SET Var_Abonos  := Entero_Cero;
		ELSE
			SET Var_Cargos  := Entero_Cero;
			SET Var_Abonos  := Par_CantidadMov;
		END IF;

		CALL DETALLEPOLIZASALT(
				Aud_EmpresaID,          Par_Poliza,         Par_Fecha,          Var_CentroCostos,   Par_cuentaContable,
				Par_cuentaAhoID,     		Par_MonedaID,       Var_Cargos,         Var_Abonos,         Var_Descripcion,
				Par_ReferenciaMov,      Procedimiento,   	TipoInstrumentoID,  Cadena_Vacia,       Decimal_Cero,
				Cadena_Vacia,           Salida_NO,          Par_NumErr,         Par_ErrMen,         Aud_Usuario ,
				Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL CONTAAHOPRO(
			Par_CuentaAhoID,		Par_ClienteID	,		Par_NumeroMov	,		Par_Fecha,				Par_Fecha,
			Par_NatMovimiento,		Par_CantidadMov,		Par_DescripcionMov,		Par_ReferenciaMov,		Par_TipoMovAhoID,
			Par_MonedaID,			Par_SucCliente,			Salida_NO,		 		Par_ConceptoCon,		Par_Poliza,
			Salida_SI,		 		Par_ConceptoAho,		Par_NatMovimiento,			Par_Consecutivo,		Salida_NO,
			Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			SET Var_Control		:= 'cuentaAhoID' ;
			SET Par_Consecutivo := Par_Poliza;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Transaccion Realizada Exitosamente: ', CONVERT(Par_Poliza, CHAR));
		SET Var_Control	:= 'cuentaAhoID' ;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_Consecutivo AS consecutivo;
		END IF;


END TerminaStore$$