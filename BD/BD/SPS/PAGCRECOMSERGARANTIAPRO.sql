-- PAGCRECOMSERGARANTIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRECOMSERGARANTIAPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGCRECOMSERGARANTIAPRO`(
	-- SP para realizar el pago por los conceptos de comision por Garantia
	-- Modulo Cartera
	Par_CreditoID				BIGINT(12),		-- Numero de credito
	Par_AmortiCreID				INT(4),			-- Numero de amortizacion
	Par_FechaInicio				DATE,			-- Fecha de inicio
	Par_FechaVencim				DATE,			-- Fecha de Vencimiento
	Par_CuentaAhoID				BIGINT(12),		-- NUmero de cuenta de ahorro

	Par_ClienteID				BIGINT(12),		-- Numero de cliente
	Par_FechaOperacion			DATE,			-- Fecha de operacion
	Par_FechaAplicacion			DATE,			-- Fecha de aplicacion
	Par_Monto					DECIMAL(14,4),	-- Monto de operacion
	Par_IVAMonto				DECIMAL(12,2),	-- MOnto Iva de operacion

	Par_MonedaID				INT(11),		-- Tipo de moneda
	Par_ProdCreditoID			INT(11),		-- Producto de credito
	Par_Clasificacion			CHAR(1),		-- Clasificacion
	Par_SubClasifID				INT(11),		-- Subclasificacion
	Par_SucCliente				INT(11),		-- SubCliente

	Par_Descripcion				VARCHAR(100),	-- Variable de descripcion
	Par_Referencia				VARCHAR(50),	-- Referencia
	Par_PolizaID				BIGINT,			-- Numero de poliza
	Par_OrigenPago				CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_ModoPago				CHAR(1),		-- Modo de Pago de la operacion

	INOUT Par_Consecutivo		BIGINT,			-- parametro consecutivo

	Par_Salida					CHAR(1),		-- Parametro de salida Si
	INOUT Par_NumErr			INT(11),		-- Parametro de salida Numero de error
	INOUT Par_ErrMen			VARCHAR(400),	-- parametro de salida  mensaje de error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- Declaracion de Variable
	DECLARE Var_Control				CHAR(100);		-- Variable de control

	-- Declaracion de constante
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Decimal_Cero			DECIMAL(12, 2);	-- Decimal cero
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE	AltaPoliza_NO			CHAR(1);		-- Alta Poliza S = Si
	DECLARE	AltaPolCre_SI			CHAR(1);		-- Alta Poliza N = No

	DECLARE	AltaMovCre_SI			CHAR(1);		-- Alta Movimiento del credito S = Si
	DECLARE	AltaMovCre_NO			CHAR(1);		-- Alta Movimiento del credito N = No
	DECLARE	AltaMovAho_NO			CHAR(1);		-- Alta Moviento Ahorro N = No
	DECLARE Salida_SI				CHAR(1);		-- Salida SI
	DECLARE Salida_NO				CHAR(1);		-- Salida NO

	DECLARE	Con_SI					CHAR(1);		-- Constante SI
	DECLARE	Con_NO					CHAR(1);		-- Constante NO
	DECLARE	Nat_Cargo				CHAR(1);		-- Naturaleza del Movimiento C= Cargo
	DECLARE	Nat_Abono				CHAR(1);		-- Naturaleza del Movimiento A= Abono
	DECLARE	Entero_Cero				INT(11);		-- Entero cero

	DECLARE	Mov_ComSerGarantia		INT(11);		-- Movimiento de Comision de Servicio de Garantia
	DECLARE	Mov_IVAComSerGarantia	INT(11);		-- Movimiento de IVA Comision de Servicio de Garantia
	DECLARE	Con_ComSerGarantia		INT(11);		-- Concepto de Cartera de Comision de Servicio de Garantia
	DECLARE	Con_IVAComSerGarantia	INT(11);		-- Concepto de Cartera de IVA Comision de Servicio de Garantia

	-- Asignacion de constante
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Decimal_Cero			:= 0.00;
	SET	Cadena_Vacia			:= '';
	SET	AltaPoliza_NO			:= 'N';
	SET	AltaPolCre_SI			:= 'S';

	SET	AltaMovCre_SI			:= 'S';
	SET	AltaMovCre_NO			:= 'N';
	SET	AltaMovAho_NO			:= 'N';
	SET	Salida_SI				:= 'S';
	SET	Salida_NO				:= 'N';

	SET	Con_SI					:= 'S';
	SET	Con_NO					:= 'N';
	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';
	SET	Entero_Cero				:= 0;

	SET	Mov_ComSerGarantia		:= 59;
	SET	Mov_IVAComSerGarantia	:= 60;
	SET	Con_ComSerGarantia		:= 142;
	SET	Con_IVAComSerGarantia	:= 145;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: PAGCRECOMSERGARANTIAPRO');
			SET Var_Control	= 'sqlException' ;
		END;

		-- Realizamos el cobro por el concepto de Comision por Servicio de Garantia
		IF( Par_Monto > Entero_Cero ) THEN

			-- Realizamos el abono a la cuenta de ingreso por Comision por Servicio de Garantia
			CALL CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,	Par_Monto,				Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
				Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
				Entero_Cero,			Par_PolizaID,			AltaPolCre_SI,			AltaMovCre_SI,			Con_ComSerGarantia,
				Mov_ComSerGarantia,		Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Par_OrigenPago,			Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Realizamos el cobro por el concepto de IVA Comision por Servicio de Garantia
		IF( Par_IVAMonto > Entero_Cero ) THEN

			-- Realizamos el abono a la cuenta de ingreso por IVA Comision por Servicio de Garantia
			CALL CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,		Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,	Par_IVAMonto,			Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
				Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,		Par_Referencia,			AltaPoliza_NO,
				Entero_Cero,			Par_PolizaID,			AltaPolCre_SI,			AltaMovCre_SI,			Con_IVAComSerGarantia,
				Mov_IVAComSerGarantia,	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Par_OrigenPago,			Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,			Par_ModoPago,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Comision de Servicio de Garantia.';
		SET Var_Control	:= 'creditoID' ;
		LEAVE ManejoErrores;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3))	AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_Control			AS control,
				Par_CreditoID		AS consecutivo;
	END IF;

END TerminaStore$$
