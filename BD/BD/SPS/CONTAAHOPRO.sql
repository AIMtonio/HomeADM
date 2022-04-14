-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTAAHOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTAAHOPRO`;
DELIMITER $$

CREATE PROCEDURE `CONTAAHOPRO`(



	Par_CuentaAhoID		BIGINT,
	Par_ClienteID		BIGINT,
	Par_NumeroMov		BIGINT,
	Par_Fecha			DATE,
	Par_FechaAplicacion	DATE,

	Par_NatMovimiento	CHAR(1),
	Par_CantidadMov		DECIMAL(12,2),
	Par_DescripcionMov	VARCHAR(150),
	Par_ReferenciaMov	VARCHAR(50),
	Par_TipoMovAhoID	CHAR(4),

	Par_MonedaID		INT,
	Par_SucCliente		INT,
	Par_AltaEncPoliza	CHAR(1),
	Par_ConceptoCon		INT,
	INOUT Par_Poliza	BIGINT,

	Par_AltaPoliza		CHAR(1),
	Par_ConceptoAho		INT,
	Par_NatConta		CHAR(1),
	Par_Consecutivo		BIGINT,

	Par_Salida			CHAR(1),
	INOUT	Par_NumErr	INT,
	INOUT	Par_ErrMen	VARCHAR(400),

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE	AltaPoliza_SI	CHAR(1);
	DECLARE	AltaConta_SI	CHAR(1);
	DECLARE	Pol_Automatica	CHAR(1);
	DECLARE	EstatusActivo	CHAR(1);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Salida_NO		CHAR(1);
	DECLARE	Salida_SI		CHAR(1);


	DECLARE Var_Control	    VARCHAR(100);
	DECLARE Var_Consecutivo	BIGINT(20);
	DECLARE	Var_Cargos		DECIMAL(12,2);
	DECLARE	Var_Abonos		DECIMAL(12,2);
	DECLARE Var_CuentaStr	VARCHAR(20);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET	AltaPoliza_SI		:= 'S';
	SET	AltaConta_SI		:= 'S';
	SET	Pol_Automatica		:= 'A';
	SET	EstatusActivo		:= 'A';
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';
	SET	Salida_NO       	:= 'N';
	SET Salida_SI           := 'S';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTAAHOPRO');
				SET Var_Control = 'sqlException';
			END;


		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Aud_EmpresaID,		Par_FechaAplicacion, 	Pol_Automatica,		Par_ConceptoCon,
				Par_DescripcionMov,	Salida_NO,      	Par_NumErr,				Par_ErrMen, 		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		IF (Par_AltaPoliza = AltaConta_SI) THEN
			IF(Par_NatConta = Nat_Cargo) THEN
				SET	Var_Cargos	:= Par_CantidadMov;
				SET	Var_Abonos	:= Decimal_Cero;
			ELSE
				SET	Var_Cargos	:= Decimal_Cero;
				SET	Var_Abonos	:= Par_CantidadMov;
			END IF;

			SET Var_CuentaStr 	:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));

			CALL POLIZASAHORROPRO(
				Par_Poliza,			Aud_EmpresaID,		Par_FechaAplicacion,	Par_ClienteID,		Par_ConceptoAho,
				Par_CuentaAhoID,	Par_MonedaID,		Var_Cargos,				Var_Abonos,			Par_DescripcionMov,
				Var_CuentaStr,		Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		CALL CUENTASAHORROMOVALT(
			Par_CuentaAhoID,		Par_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
			Par_DescripcionMov,		Par_ReferenciaMov,	Par_TipoMovAhoID,	Salida_NO, 			Par_NumErr,
			Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Transacción Realizada Exitosamente: ', CONVERT(Par_Poliza, CHAR));
		SET Var_Control	:= 'cuentaAhoID' ;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$