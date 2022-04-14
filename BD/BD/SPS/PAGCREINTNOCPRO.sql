
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREINTNOCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREINTNOCPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREINTNOCPRO`(
	Par_CreditoID			BIGINT,
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT,

	Par_ClienteID			BIGINT,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(14,4),
	Par_IVAMonto			DECIMAL(12,2),

	Par_MonedaID			INT,
	Par_ProdCreditoID		INT,
	Par_Clasificacion		CHAR(1),
    Par_SubClasifID			INT,
	Par_SucCliente			INT,

	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT,
	Par_DivContaIng			CHAR(1),
	Par_OrigenPago			CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
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

	-- DECLARACION DE VARIABLES
	DECLARE Var_Refinancia			CHAR(1);		# Indica si el credito refinancia los intereses
	DECLARE Var_EsAgropecuario		CHAR(1);		# Indica si el credito es agropecuario
	DECLARE Var_MontoAcumulado		DECIMAL(14,2);	# Indica el Monto Acumulado de Intereses del Credito
	DECLARE Var_MontoRefinanciar	DECIMAL(14,2);	# Indica el Monto a Refinanciar de Intereses del Credito

	DECLARE Mov_CarConta			INT(11);		-- Movimiento de contabilidad Cargo
	DECLARE Mov_AboConta			INT(11);		-- Movimiento de Contabilidad Abono
	DECLARE Var_CreEstatus			CHAR(1);		-- Estatus de Credito
	DECLARE Var_Control				CHAR(100);
	DECLARE Var_Consecutivo			INT(11);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(12, 2);

	DECLARE	AltaPoliza_NO	CHAR(1);
	DECLARE	AltaPolCre_SI	CHAR(1);
	DECLARE	AltaMovCre_SI	CHAR(1);
	DECLARE	AltaMovCre_NO	CHAR(1);
	DECLARE	AltaMovAho_NO	CHAR(1);

	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);

	DECLARE	Mov_IntNoConta	INT;
	DECLARE	Mov_IVAInteres	INT;
	DECLARE	Con_IngInteres	INT;
	DECLARE	Con_IngIntVenc	INT;
	DECLARE	Con_IVAInteres 	INT;
	DECLARE	Con_CtaOrdInt 	INT;
	DECLARE	Con_CorIntOrd 	INT;
	DECLARE	Si_DivIngInt	CHAR(1);
	DECLARE Cons_SI			CHAR(1);
	DECLARE Cons_NO			CHAR(1);

	DECLARE Con_CtaOrdIntSup	INT(11);	-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
	DECLARE Con_CorIntOrdSup	INT(11);	-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado
	DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';					-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero		:= 0;					-- Entero en Cero
	SET	Decimal_Cero	:= 0.00;				-- Decimal Cero
	SET	AltaPoliza_NO	:= 'N';					-- Alta de la Poliza: NO
	SET	AltaPolCre_SI	:= 'S';					-- Alta de la Poliza: SI
	SET	AltaMovCre_SI	:= 'S';					-- Alta de Movimiento de Credito: SI
	SET	AltaMovCre_NO	:= 'N';					-- Alta de Movimiento de Credito: NO
	SET	AltaMovAho_NO	:= 'N';					-- Alta de Movimiento de Ahorro: NO
	SET Nat_Cargo		:= 'C';					-- Naturaleza del Movimiento: Cargo
	SET Nat_Abono		:= 'A';					-- Naturaleza del Movimiento: Abono
	SET	Mov_IntNoConta	:= 13;					-- Tipo de Movimiento Credito: Interes no Contabilizado, de Cartera Vencida
	SET	Mov_IVAInteres	:= 20;					-- Tipo de Movimiento Credito: IVA de Interes
	SET Con_IngInteres	:= 5;					-- Concepto Contable: Ingreso por Interes
	SET Con_IngIntVenc 	:= 32;					-- Concepto Contable: Ingreso por Interes de Cartera Vencida
	SET Con_IVAInteres 	:= 8;					-- Concepto Contable: IVA de Interes
	SET Con_CtaOrdInt 	:= 11;					-- Concepto Contable: Cuenta de Orden de Interes
	SET Con_CorIntOrd 	:= 12;					-- Concepto Contable: Cuenta de Orden Correlativa de Interes
	SET	Si_DivIngInt	:= 'S';					-- Si divide la Contabilidad de los Ingresos por Interes Vigente y Vencido
	SET Cons_SI			:= 'S';					# Constante SI
	SET Cons_NO			:= 'N';					# Constante NO

	SET Con_CtaOrdIntSup	:= 119;		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
	SET Con_CorIntOrdSup	:= 120;		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado
	SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
		               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREINTNOCPRO');
				SET Var_Control = 'sqlException' ;
			END;

	SELECT  Refinancia,		EsAgropecuario,		InteresAcumulado,	InteresRefinanciar
	INTO 	Var_Refinancia, Var_EsAgropecuario,	Var_MontoAcumulado,	Var_MontoRefinanciar
	FROM 	CREDITOS
	WHERE 	CreditoID = Par_CreditoID;

		SELECT Estatus
			INTO Var_CreEstatus
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

		IF (Var_CreEstatus = Estatus_Suspendido) THEN
			SET Mov_AboConta	:= Con_CtaOrdIntSup;	-- No Concepto: 119
			SET Mov_CarConta	:= Con_CorIntOrdSup;	-- No Concepto: 120
		END IF;

		IF (Var_CreEstatus != Estatus_Suspendido) THEN
			SET Mov_AboConta	:= Con_CtaOrdInt;	-- No Concepto: 11
			SET Mov_CarConta	:= Con_CorIntOrd;	-- No Concepto: 12
		END IF;

	IF (Par_Monto > Decimal_Cero) THEN

		-- VALIDA SI EL CREDITO ES AGROPECUARIO Y REFINANCIA INTERESES
		IF(Var_EsAgropecuario = Cons_SI AND Var_Refinancia = Cons_SI AND Par_FechaVencim > Par_FechaOperacion) THEN
			-- VALIDA SI EL MONTO A PAGAR ES MAYOR AL MONTO BASE DE INTERES PARA EL CALCULO
			IF(Par_Monto > Var_MontoRefinanciar) THEN
				-- AL INTERES ACUMULADO SE LE RESTA LO QUE SE ESTÁ PAGANDO Y EL INTERES SE QUEDA EN CERO
				UPDATE CREDITOS
						SET	InteresAcumulado = CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
													ELSE InteresAcumulado - Par_Monto END,
							InteresRefinanciar = Decimal_Cero
						WHERE CreditoID = Par_CreditoID;

			ELSE
				-- SI EL MONTO A PAGAR NO ES MAYOR, AL INTERES ACUMULADO E INTERES A REFINANCIAR SE LE RESTA EL MONTO PAGADO
				UPDATE CREDITOS
						SET	InteresAcumulado = CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
													ELSE InteresAcumulado - Par_Monto END,
							InteresRefinanciar = InteresRefinanciar - Par_Monto
						WHERE CreditoID = Par_CreditoID;
			END IF;

	    END IF;

		-- Verifica si Separa la Contabilizacion de los Ingresos por Cartera Vigente y Vencida

		IF(Par_DivContaIng = Si_DivIngInt) THEN
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
				Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
				Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
				Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,		Entero_Cero,
				Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,		Con_IngIntVenc,
				Mov_IntNoConta,     Nat_Abono,              AltaMovAho_NO,		Cadena_Vacia,
				Cadena_Vacia,       Par_OrigenPago,			Cons_NO,			Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
				Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
				Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
				Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,		Entero_Cero,
				Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,		Con_IngInteres,
				Mov_IntNoConta,     Nat_Abono,              AltaMovAho_NO,		Cadena_Vacia,
				Cadena_Vacia,       Par_OrigenPago,			Cons_NO,			Par_NumErr,
				Par_ErrMen,			Par_Consecutivo,		Par_EmpresaID,      Par_ModoPago,
				Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		CALL  CONTACREDITOSPRO (
	        Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion,	Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
	        Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_AboConta,
	        Mov_IntNoConta,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Cons_NO,			Par_NumErr,
	        Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
	        Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		CALL  CONTACREDITOSPRO (
	        Par_CreditoID,		Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion,	Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
	        Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,		Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,		Mov_CarConta,
	        Mov_IntNoConta,     Nat_Cargo,              AltaMovAho_NO,		Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Cons_NO,			Par_NumErr,
	        Par_ErrMen,			Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
	        Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		CALL CRWPAGOINTPROVPRO (
			Par_CreditoID,		Par_FechaInicio,	Par_FechaVencim,	Par_FechaOperacion,		Par_FechaAplicacion,
			Par_Monto,			Par_MonedaID,		Par_SucCliente,		Par_Poliza,				Cons_NO,
			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;


	IF (Par_IVAMonto > Decimal_Cero) THEN
	    CALL  CONTACREDITOSPRO (
	        Par_CreditoID,		Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion,	Par_FechaAplicacion,    Par_IVAMonto,       Par_MonedaID,
	        Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,		Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI	,	Con_IVAInteres,
	        Mov_IVAInteres,     Nat_Abono,              AltaMovAho_NO,		Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Cons_NO,			Par_NumErr,
	        Par_ErrMen,			Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
	        Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Interes No Contabilizado realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$

