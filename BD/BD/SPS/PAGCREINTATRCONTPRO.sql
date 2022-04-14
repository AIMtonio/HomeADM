-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREINTATRCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREINTATRCONTPRO`;DELIMITER $$

CREATE PROCEDURE `PAGCREINTATRCONTPRO`(
/*SP para el Pago de interes atrasaso Creditos contingentes*/
	Par_CreditoID			BIGINT(12),
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT,

	Par_ClienteID			INT,
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

    Par_Salida              CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,

	Par_EmpresaID		INT(11),
	Par_ModoPago		CHAR(1),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	-- declaracion de constantes
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
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE Salida_NO           CHAR(1);
    DECLARE Salida_SI           CHAR(1);
	DECLARE	Mov_IntAtrasado		INT;
	DECLARE	Mov_IVAInteres		INT;
	DECLARE	Con_IntAtrasado 	INT;
	DECLARE	Con_IVAInteres 		INT;
    DECLARE Con_RecuInteres		INT;
	DECLARE	Con_OrdCasInt 		INT;
	-- asignacion de constantes
	SET	Cadena_Vacia	  	:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;
	SET	AltaPoliza_NO		:= 'N';
	SET	AltaPolCre_SI		:= 'S';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovCre_NO		:= 'N';
	SET	AltaMovAho_NO		:= 'N';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET Salida_NO           := 'N';
    SET Salida_SI           := 'S';
	SET	Mov_IntAtrasado		:= 11;
	SET	Mov_IVAInteres		:= 20;
	SET Con_IntAtrasado 	:= 73;			/*Cuenta de orden interes atrasado*/
	SET Con_IVAInteres 		:= 81;			/*Concepto IVA Recuperacion C.Castigada*/
    SET Con_RecuInteres		:= 78;			/* Concepto Contable: Resultados. Recup. Interes Cartera Castigada*/
    SET	Con_OrdCasInt 		:= 72;			/* Cta. Orden Interes Cartera Castigada */

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PAGCREINTATRCONTPRO');
        END;

		IF (Par_Monto > Decimal_Cero) THEN

            /*Resultados. Recup. Interes Cartera Castigada concepto Num 46*/
			CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    	Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
                Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,      	Con_RecuInteres,
				Mov_IntAtrasado,    		Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
                Par_ModoPago,				Aud_Usuario,        	Aud_FechaActual,  		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,          	 	Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

			 /*Cta. Orden Interes Cartera Castigada Num 40*/
			CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    	Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
                Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,      	Con_OrdCasInt,
				Mov_IntAtrasado,    		Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
                Par_ModoPago,				Aud_Usuario,        	Aud_FechaActual,  		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,          	 	Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            /*	Cuentas de orden cargo*/
            CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    	Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
                Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,      	Con_IntAtrasado,
				Mov_IntAtrasado,    		Nat_Cargo,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
                Par_ModoPago,				Aud_Usuario,        	Aud_FechaActual,  		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,          	 	Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

		END IF;

		IF (Par_IVAMonto > Decimal_Cero) THEN

			CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    	Par_IVAMonto,       	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
                Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,      	Con_IVAInteres,
				Mov_IVAInteres,     		Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
				Par_ModoPago,				Aud_Usuario,        	Aud_FechaActual, 		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,           	Aud_NumTransaccion);

			 IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr      := Entero_Cero;
        SET Par_ErrMen      := 'Operacion Realizada Exitosamente';

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;

    END IF;

END TerminaStore$$