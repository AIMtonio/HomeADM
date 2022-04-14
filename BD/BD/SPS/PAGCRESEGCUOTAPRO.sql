-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCRESEGCUOTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRESEGCUOTAPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCRESEGCUOTAPRO`(
	-- SP PARA PAGAR EL SEGURO POR CUOTA
	Par_CreditoID			BIGINT(12),
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT(12),

	Par_ClienteID			BIGINT,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(12,2),
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
	Par_ModoPago           	CHAR(1),
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
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Cons_No				CHAR(1);

	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Mov_SeguroCuota		INT;
	DECLARE	Mov_IVASeguroCuota	INT;
	DECLARE Con_IngSeguroCuota 	INT;
	DECLARE Con_IVASegCuota 	INT;



	SET	Cadena_Vacia	  	:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;
	SET	AltaPoliza_NO		:= 'N';
	SET	Cons_No				:= 'N';

	SET	AltaPolCre_SI		:= 'S';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovAho_NO		:= 'N';
	SET Nat_Cargo			:= 'C';

	SET Nat_Abono			:= 'A';
	SET	Mov_SeguroCuota		:= 50;
	SET	Mov_IVASeguroCuota	:= 25;
	SET Con_IngSeguroCuota	:= 26;
	SET Con_IVASegCuota 	:= 55;

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
	               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCRESEGCUOTAPRO');
			SET Var_Control = 'sqlException' ;
		END;

	IF (Par_Monto > Decimal_Cero) THEN
		CALL CONTACREDITOSPRO(
			Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
			Par_FechaAplicacion,    Par_Monto,         		Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
			Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
			Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,      	AltaMovCre_SI,      	Con_IngSeguroCuota,
			Mov_SeguroCuota,    	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
			Par_OrigenPago,			Cons_No,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,
			Par_EmpresaID,      	Par_ModoPago,           Aud_Usuario,        	Aud_FechaActual,   		Aud_DireccionIP,
			Aud_ProgramaID,     	Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF (Par_IVAMonto > Decimal_Cero) THEN
		CALL CONTACREDITOSPRO(
			Par_CreditoID,      	Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
			Par_FechaAplicacion,    Par_IVAMonto,       	Par_MonedaID,			Par_ProdCreditoID, 	 	Par_Clasificacion,
			Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
			Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,     	 	AltaMovCre_SI,      	Con_IVASegCuota,
			Mov_IVASeguroCuota, 	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
			Par_OrigenPago,			Cons_No,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,
			Par_EmpresaID,      	Par_ModoPago,           Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,
			Aud_ProgramaID,     	Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Seguro de Cuota realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$