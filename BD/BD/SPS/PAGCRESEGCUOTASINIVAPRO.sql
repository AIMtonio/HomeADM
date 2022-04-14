-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCRESEGCUOTASINIVAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRESEGCUOTASINIVAPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCRESEGCUOTASINIVAPRO`(
	-- SP QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES DEL SEGURO POR CUOTA CUANDO
    -- EL PRODUCTO DE CREDITO NO COBRA IVA DEL SEGURO
	Par_CreditoID			BIGINT(12),			-- Numero de Credito
	Par_AmortiCreID			INT(11),			-- Numero de Amortizacion
	Par_FechaInicio			DATE,				-- Fecha de Inicio
	Par_FechaVencim			DATE,				-- Fecha de Vencimiento
	Par_CuentaAhoID			BIGINT(12),			-- Cuenta de Ahorro

    Par_ClienteID			BIGINT(20),			-- Numero de Cliente
	Par_FechaOperacion		DATE,				-- Fecha de Operacion
	Par_FechaAplicacion		DATE,				-- Fecha de Aplicacion
	Par_MontoSegCuotaOp		DECIMAL(12,2),		-- Monto Operativo del Seguro
	Par_IVAMontoOp			DECIMAL(12,2),		-- Monto IVA Operativo Seguro

    Par_MontoSegCuotaCont	DECIMAL(14,2),		-- Monto Contable Seguro
    Par_MontoIVASegCuotaCont	DECIMAL(14,2), 	-- Monto IVA Contable Seguro

    Par_MonedaID			INT(11),			-- Moneda
	Par_ProdCreditoID		INT(11),			-- Producto de Credito
	Par_Clasificacion		CHAR(1),			-- Clasificacion
    Par_SubClasifID     	INT(11),			-- Subclasificacion
	Par_SucCliente			INT(11),			-- Sucursal del Cliente

	Par_Descripcion			VARCHAR(100),		-- Descripcion
	Par_Referencia			VARCHAR(50),		-- Referencia
	Par_Poliza				BIGINT(20),			-- Numero de Poliza
	Par_OrigenPago			CHAR(1),			-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT(20),
	-- Parametros de Auditoria
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
    DECLARE AltaPolCre_NO		CHAR(1);
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



	SET	Cadena_Vacia	  	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET	Decimal_Cero		:= 0.00;			-- Decimal Cero
	SET	AltaPoliza_NO		:= 'N';				-- Alta de Poliza: NO

	SET	AltaPolCre_SI		:= 'S';				-- Alta de Poliza: SI
    SET AltaPolCre_NO		:= 'N';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovAho_NO		:= 'N';
	SET	Cons_No				:= 'N';
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
	               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCRESEGCUOTASINIVAPRO');
			SET Var_Control = 'sqlException' ;
		END;

	-- Si el monto del Seguro por Cuota Operativo es mayor a Cero
	IF (Par_MontoSegCuotaOp > Decimal_Cero) THEN
		CALL CONTACREDITOSPRO (
			Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
            Par_FechaAplicacion,    Par_MontoSegCuotaOp,    Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
            Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
            Entero_Cero,			Par_Poliza,         	AltaPolCre_NO,      	AltaMovCre_SI,      	Con_IngSeguroCuota,
			Mov_SeguroCuota,    	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
            Par_OrigenPago,			Cons_No,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,
            Par_EmpresaID,      	Par_ModoPago,           Aud_Usuario,        	Aud_FechaActual,   		Aud_DireccionIP,
            Aud_ProgramaID,     	Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;
    -- Si el monto del Seguro por Cuota Contable es mayor a Cero
	IF (Par_MontoSegCuotaCont > Decimal_Cero) THEN
		CALL CONTACREDITOSPRO (
			Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
            Par_FechaAplicacion,    Par_MontoSegCuotaCont,  Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
            Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
            Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,      	AltaMovCre_NO,      	Con_IngSeguroCuota,
			Mov_SeguroCuota,    	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
            Par_OrigenPago,			Cons_No,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,
            Par_EmpresaID,      	Par_ModoPago,           Aud_Usuario,        	Aud_FechaActual,   		Aud_DireccionIP,
            Aud_ProgramaID,     	Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


    -- Si el monto del IVA  del Seguro por Cuota Operativo es mayor a Cero
	IF (Par_IVAMontoOp > Decimal_Cero) THEN
		CALL CONTACREDITOSPRO (
			Par_CreditoID,      	Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
            Par_FechaAplicacion,    Par_IVAMontoOp,       	Par_MonedaID,			Par_ProdCreditoID, 	 	Par_Clasificacion,
            Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
            Entero_Cero,			Par_Poliza,         	AltaPolCre_NO,     	 	AltaMovCre_SI,      	Con_IVASegCuota,
			Mov_IVASeguroCuota, 	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
            Par_OrigenPago,			Cons_No,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,
            Par_EmpresaID,      	Par_ModoPago,           Aud_Usuario,        	Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,     	Aud_Sucursal,           Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

    -- Si el monto del IVA del Seguro por Cuota Contable es mayor a Cero
    IF (Par_MontoIVASegCuotaCont > Decimal_Cero) THEN
            CALL CONTACREDITOSPRO (
			Par_CreditoID,      	Par_AmortiCreID,        	Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
            Par_FechaAplicacion,    Par_MontoIVASegCuotaCont,   Par_MonedaID,			Par_ProdCreditoID, 	 	Par_Clasificacion,
            Par_SubClasifID,    	Par_SucCliente,				Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
            Entero_Cero,			Par_Poliza,         		AltaPolCre_SI,     	 	AltaMovCre_NO,      	Con_IVASegCuota,
			Mov_IVASeguroCuota, 	Nat_Abono,              	AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
            Par_OrigenPago,			Cons_No,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,
            Par_EmpresaID,      	Par_ModoPago,	            Aud_Usuario,        	Aud_FechaActual,    		Aud_DireccionIP,
            Aud_ProgramaID,     	Aud_Sucursal,	            Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Seguro de Cuota Sin IVA realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$