
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREINTATRPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREINTATRPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREINTATRPRO`(
	Par_CreditoID			BIGINT(12),
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
	Par_SubClasifID     	INT,
	Par_SucCliente			INT,

	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT,
	Par_OrigenPago			CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	INOUT Par_NumErr		INT(11),

	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	Par_EmpresaID			INT(11),
	Par_ModoPago			CHAR(1),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_Control			CHAR(100);
	DECLARE Var_Consecutivo		INT(11);

	DECLARE	Cadena_Vacia	  	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Decimal_Cero		DECIMAL(12, 2);

	DECLARE	AltaPoliza_NO		CHAR(1);
	DECLARE	AltaPolCre_SI		CHAR(1);
	DECLARE	AltaMovCre_SI		CHAR(1);
	DECLARE	AltaMovCre_NO		CHAR(1);
	DECLARE	AltaMovAho_NO		CHAR(1);
	DECLARE	Str_SI				CHAR(1);
	DECLARE	Str_NO				CHAR(1);

	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);

	DECLARE	Mov_IntAtrasado	INT;
	DECLARE	Mov_IVAInteres	INT;
	DECLARE	Con_IntAtrasado 	INT;
	DECLARE	Con_IVAInteres 	INT;

	DECLARE Con_IntAtrasadoSup	INT(11);	-- Concepto Contable: Interes Atrasado Suspendido
	DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido

	-- Declaracion de Variable
	DECLARE Mov_AboConta	INT(11);	-- Movimiento de Contabilidad Abono
	DECLARE Var_CreEstatus	CHAR(1);	-- Estatus de Credito

	SET	Cadena_Vacia	  	:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;

	SET	AltaPoliza_NO		:= 'N';
	SET	AltaPolCre_SI		:= 'S';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovAho_NO		:= 'N';
	SET	Str_SI				:= 'S';
	SET	Str_NO				:= 'N';

	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';


	SET	Mov_IntAtrasado		:= 11;
	SET	Mov_IVAInteres		:= 20;


	SET 	Con_IntAtrasado := 20;
	SET 	Con_IVAInteres 	:= 8;

	SET Con_IntAtrasadoSup	:= 115;		-- Concepto Contable: Interes Atrasado Suspendido
	SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
	               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREINTATRPRO');
			SET Var_Control = 'sqlException' ;
		END;

	SELECT Estatus
		INTO Var_CreEstatus
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

	IF (Var_CreEstatus = Estatus_Suspendido) THEN
		SET Mov_AboConta	:= Con_IntAtrasadoSup;	-- No Concepto: 115
	END IF;

	IF (Var_CreEstatus != Estatus_Suspendido) THEN
		SET Mov_AboConta	:= Con_IntAtrasado;	-- No Concepto: 20
	END IF;

	IF (Par_Monto > Decimal_Cero) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      	Par_AmortiCreID,    	Par_CuentaAhoID,    Par_ClienteID,			Par_FechaOperacion,
			Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,       Par_ProdCreditoID,  	Par_Clasificacion,
			Par_SubClasifID,		Par_SucCliente,     	Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,
			Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,      AltaMovCre_SI,	        Mov_AboConta,
			Mov_IntAtrasado,    	Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,	        Cadena_Vacia,
			Par_OrigenPago,			Str_NO, 				Par_NumErr,         Par_ErrMen,         	Par_Consecutivo,
			Par_EmpresaID,      	Par_ModoPago,			Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,     	Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL CRWPAGOINTPROVPRO (
			Par_CreditoID,		Par_FechaInicio,	Par_FechaVencim,	Par_FechaOperacion,	Par_FechaAplicacion,
			Par_Monto,			Par_MonedaID,		Par_SucCliente,		Par_Poliza,			Str_NO,
			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;


	IF (Par_IVAMonto > Decimal_Cero) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      	Par_AmortiCreID,    Par_CuentaAhoID,    Par_ClienteID,		Par_FechaOperacion,
			Par_FechaAplicacion,    Par_IVAMonto,       Par_MonedaID,		Par_ProdCreditoID,  Par_Clasificacion,
			Par_SubClasifID,    	Par_SucCliente,		Par_Descripcion,    Par_Referencia,     AltaPoliza_NO,
			Entero_Cero,			Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Con_IVAInteres,
			Mov_IVAInteres,     	Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			Par_OrigenPago,			Str_NO, 			Par_NumErr,     	Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,      	Par_ModoPago,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,     	Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Interes Atrasado realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$

