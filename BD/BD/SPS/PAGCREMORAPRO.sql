-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREMORAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREMORAPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREMORAPRO`(
    -- no cambiar las  asignaciones ya que este  se manda a llamar dentro de un cursor
	-- y no puede tener ninguna asignacion con INTO, de lo contrario podria no concluir con exito
	-- el procedimiento
	Par_CreditoID			BIGINT,
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT,

	Par_ClienteID			BIGINT,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(16,2),
	Par_IVAMonto			DECIMAL(16,2),

	Par_MonedaID			INT,
	Par_ProdCreditoID		INT,
	Par_Clasificacion		CHAR(1),
	Par_SubClasifID			INT,
	Par_SucCliente			INT,

	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_SaldoMora			DECIMAL(14,4),
	Par_Poliza				BIGINT,
	Par_OrigenPago			CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
INOUT	Par_NumErr			INT(11),

INOUT	Par_ErrMen			VARCHAR(400),
INOUT	Par_Consecutivo		BIGINT,
	Par_EmpresaID			INT,
	Par_ModoPago			CHAR(1),
	Aud_Usuario				INT,

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_TipoContaMora	CHAR(1);
	DECLARE Mov_CarConta		INT(11);		-- Movimiento de contabilidad Cargo
	DECLARE Mov_AboConta		INT(11);		-- Movimiento de Contabilidad Abono
	DECLARE Var_CreEstatus		CHAR(1);		-- Estatus de Credito
	DECLARE Var_Control			CHAR(100);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(16, 2);
	DECLARE	AltaPoliza_NO		CHAR(1);
	DECLARE	AltaPolCre_SI		CHAR(1);
	DECLARE	AltaMovCre_SI		CHAR(1);
	DECLARE	AltaMovCre_NO		CHAR(1);
	DECLARE	AltaMovAho_NO		CHAR(1);
	DECLARE	Str_NO				CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Mov_Moratorio		INT;
	DECLARE	Mov_IVAIntMora		INT;
	DECLARE	Con_IngIntMora		INT;
	DECLARE	Con_IVAMora			INT;
	DECLARE	Con_CtaOrdMor 		INT;
	DECLARE	Con_CorIntMor 		INT;
	DECLARE	Con_MorDevenga		INT;
	DECLARE Mora_CtaOrden		CHAR(1);

	DECLARE Con_MoraDevenSup	INT(11);	-- Concepto Contable: Interes Moratorio Devengado Suspendido
	DECLARE	Con_CtaOrdMorSup	INT(11);	-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
	DECLARE	Con_CorIntMorSup	INT(11);	-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido
	DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;
	SET	AltaPoliza_NO		:= 'N';
	SET	AltaPolCre_SI		:= 'S';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovAho_NO		:= 'N';
	SET	Str_NO				:= 'N';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET	Mov_Moratorio		:= 15;		-- Movimiento Operativo de Credito: Interes Moratorio
	SET	Mov_IVAIntMora		:= 21;		-- Movimiento Operativo de Credito: IVA de Interes Moratorio
	SET	Con_IngIntMora		:= 6;		-- Concepto Contable: Ingreso por Interes Moratorio
	SET	Con_IVAMora			:= 9;		-- Concepto Contable: IVA de Interes Moratorio
	SET	Con_CtaOrdMor		:= 13;		-- Concepto Contable: Cuenta de Orden de Interes Moratorio
	SET	Con_CorIntMor		:= 14;		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio
	SET	Con_MorDevenga		:= 33;		-- Concepto Contable: Interes Moratorio Devengado
	SET Mora_CtaOrden		:= 'C';		-- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden

	SET Con_MoraDevenSup	:= 117;		-- Concepto Contable: Interes Moratorio Devengado Suspendido
	SET	Con_CtaOrdMorSup	:= 121;		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
	SET	Con_CorIntMorSup	:= 122;		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido
	SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido

	SET Var_TipoContaMora	:= (SELECT TipoContaMora from PARAMETROSSIS);
	SET	Var_TipoContaMora	:= IFNULL(Var_TipoContaMora, Cadena_Vacia);

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
	               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREMORAPRO');
			SET Var_Control = 'sqlException' ;
		END;

		SELECT Estatus
			INTO Var_CreEstatus
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

	IF(Par_Monto > Decimal_Cero) THEN

		-- Verificamos como Registrar Operativa y Contablemente los moratorios, dependiendo lo que especifique en la parametrizacion
		-- Si se contabiliza en cuentas de orden o en cuentas de ingresos
		IF(Var_TipoContaMora = Mora_CtaOrden) THEN

			IF (Var_CreEstatus = Estatus_Suspendido) THEN
				SET Mov_AboConta	:= Con_CtaOrdMorSup;	-- No Concepto: 121
				SET Mov_CarConta	:= Con_CorIntMorSup;	-- No Concepto: 122
			END IF;

			IF (Var_CreEstatus != Estatus_Suspendido) THEN
				SET Mov_AboConta	:= Con_CtaOrdMor;	-- No Concepto: 13
				SET Mov_CarConta	:= Con_CorIntMor;	-- No Concepto: 14
			END IF;

			CALL CONTACREDITOSPRO (
				Par_CreditoID,		Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
				Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
				Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
				Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,		Entero_Cero,
				Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,		Con_IngIntMora,
				Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,		Cadena_Vacia,
				Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,		Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
				Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
				Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
				Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
				Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_AboConta,
				Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
				Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
				Par_ErrMen,         Par_Consecutivo,		Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
				Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
				Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
				Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
				Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_CarConta,
				Mov_Moratorio,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
				Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
				Par_ErrMen,         Par_Consecutivo,		Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE -- end del Var_TipoContaMora = Mora_CtaOrden

			IF (Var_CreEstatus = Estatus_Suspendido) THEN
				SET Mov_AboConta	:= Con_MoraDevenSup;	-- No Concepto: 117
			END IF;

			IF (Var_CreEstatus != Estatus_Suspendido) THEN
				SET Mov_AboConta	:= Con_MorDevenga;	-- No Concepto: 33
			END IF;

			-- Los moratorios se generaron en moratorio devengado vs ingreso por ineteres moratorio
			-- Por esto, en el pago del cliente del moratorio unicamente cancelamos el interes devengado
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
				Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
				Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
				Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
				Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Mov_AboConta,
				Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
				Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
				Par_ErrMen,         Par_Consecutivo,		Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Pago de moratoris a inversionistas
		CALL CRWPAGOINTMORPRO(
			Par_CreditoID,	Par_FechaInicio,	Par_FechaVencim,	Par_FechaOperacion,	Par_FechaAplicacion,
			Par_Monto,		Par_MonedaID,		Par_SucCliente,		Par_SaldoMora,		Par_Poliza,
			Str_NO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF (Par_IVAMonto > Decimal_Cero) THEN
		CALL  CONTACREDITOSPRO (
	        Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion, Par_FechaAplicacion,    Par_IVAMonto,       Par_MonedaID,
	        Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Con_IVAMora,
	        Mov_IVAIntMora,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
			Par_ErrMen,         Par_Consecutivo,       	Par_EmpresaID,      Par_ModoPago,
			Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Moratorio de Cartera Vigente realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$