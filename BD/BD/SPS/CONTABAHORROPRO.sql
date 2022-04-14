-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTABAHORROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTABAHORROPRO`;
DELIMITER $$


CREATE PROCEDURE `CONTABAHORROPRO`(
/* SP para realizar la contabilidad de las cuentas de ahorro*/
	Par_CuentaAhoID		BIGINT(12),			/* ID de la cuenta*/
	Par_ClienteID		BIGINT,			/* ID del cliente*/
	Par_NumeroMov		BIGINT,			/* Mandar el numero de Transaccion */
	Par_Fecha			DATE,			/* Fecha en que se genera el movimiento*/
	Par_FechaAplicacion	DATE,			/* Fecha de Aplicacion*/

	Par_NatMovimiento	CHAR(1),		/* Naturaleza del movimiento Operativo: Cargo = C, Abono = A*/
	Par_CantidadMov		DECIMAL(12,2),	/* Cantidad del movimiento */
	Par_DescripcionMov	VARCHAR(150),	/* Descripcion del movimiento*/
	Par_ReferenciaMov	VARCHAR(50),	/* Referencia del Movimiento */
	Par_TipoMovAhoID	CHAR(4),		/* Tipo del movimiento, tabla: TIPOSMOVSAHO*/

	Par_MonedaID		INT(11),		/* ID de la Moneda*/
	Par_SucCliente		INT(11),			/* Sucursal del Cliente*/
	Par_AltaEncPoliza	CHAR(1), 		/* S= Alta encabezado de la poliza; N = no da de alta encabezado*/
	Par_ConceptoCon		INT(11),			/* Conceto contable, requerido solo si Par_AltaEncPoliza=S, tabla: CONCEPTOSCONTA*/
	INOUT Par_Poliza	BIGINT,			/* devuelve o recibe el numero de poliza usado o generado*/

	Par_AltaPoliza		CHAR(1),		/* S = alta detalle de poliza de ahorro ; N =  no inserta detalle en poliza*/
	Par_ConceptoAho		INT(11),		/* Conceto de ahorro, tabla: CONCEPTOSAHORRO*/
	Par_NatConta		CHAR(1),		/* Naturaleza del movimiento Contable; Cargo = C, Abono = A*/
    Par_Salida			CHAR(1),

	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de error
	Par_Consecutivo		BIGINT,

	-- Parametros de Auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),

	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Var_Cargos		DECIMAL(12,2);
	DECLARE	Var_Abonos		DECIMAL(12,2);
	DECLARE	Var_CuentaStr	VARCHAR(20);
	DECLARE Var_Control		VARCHAR(100);			-- Variable de control
	DECLARE Var_Consecutivo	VARCHAR(20);			-- Variable consecutivo

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(11);
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

	-- Asignacion de constantes
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
	SET	Salida_NO			:= 'N';
	SET	Salida_SI			:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
			'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTABAHORROPRO');
		END;

		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Aud_EmpresaID,		Par_FechaAplicacion,	Pol_Automatica,		Par_ConceptoCon,
				Par_DescripcionMov,	Salida_NO, 			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr > Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_AltaPoliza = AltaConta_SI	) THEN
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
				Var_CuentaStr,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr > Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		CALL CUENTASAHOMOVSALT(
			Par_CuentaAhoID,		Par_NumeroMov,		Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,
			Par_DescripcionMov,		Par_ReferenciaMov,	Par_TipoMovAhoID,	Salida_NO,			Par_NumErr,
			Par_ErrMen,				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr > Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Informacion Procesada Exitosamente.');
		SET Var_Control	:= 'cuentaAhoID' ;
		SET Var_Consecutivo := Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_Poliza AS consecutivo;
	END IF;

END TerminaStore$$
