-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCRECAPVIGCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCRECAPVIGCONTPRO`;DELIMITER $$

CREATE PROCEDURE `PAGCRECAPVIGCONTPRO`(
/*SP para el Pago de capital atrasado Creditos contingentes*/
	Par_CreditoID			BIGINT(12),
	Par_AmortiCreID			INT(4),
	Par_FechaInicio			DATE,
	Par_FechaVencim			DATE,
	Par_CuentaAhoID			BIGINT(12),

	Par_ClienteID			BIGINT,
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,
	Par_Monto				DECIMAL(14,2),
	Par_IVAMonto			DECIMAL(12,2),

	Par_MonedaID			INT,
	Par_ProdCreditoID		INT,
	Par_Clasificacion		CHAR(1),
    Par_SubClasifID    	 	INT,
	Par_SucCliente			INT,

	Par_Descripcion			VARCHAR(100),
	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT,
	Par_Salida          	CHAR(1),

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
	-- Declaracion constantes
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
	DECLARE	Mov_CapVigente		INT;
	DECLARE	Con_CapVigente		INT;
	DECLARE Salida_NO           CHAR(1);
    DECLARE Salida_SI           CHAR(1);
	DECLARE Con_OrdCastigo      INT;
    DECLARE Con_CorCastigo      INT;
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
	SET Nat_Cargo       	:= 'C';
	SET Nat_Abono       	:= 'A';
	SET Salida_NO           := 'N';
    SET Salida_SI           := 'S';
	SET Mov_CapVigente  	:= 1;
	SET Con_CapVigente  	:= 82;			-- Resultados. Recup. Cartera Castigada
    SET Con_OrdCastigo      := 70;          -- Concepto Contable Cartera: Cta de Orden de Castigo
    SET Con_CorCastigo      := 71;          -- Concepto Contable Cartera: Correlativa de Orden de Castigo


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PAGCRECAPVIGCONTPRO');
        END;


		IF (Par_Monto > Decimal_Cero) THEN

			/*Resultados. Recup. Cartera Castigada 31*/
			CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
                Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,			Con_CapVigente,
				Mov_CapVigente,    	 	Nat_Abono,              AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,				Par_NumErr,             Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
                Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

             /*Cta. Orden Cartera Castigada 29*/
            CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
                Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,			Con_OrdCastigo,
				Mov_CapVigente,    	 	Nat_Abono,              AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,				Par_NumErr,             Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
                Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

            /*Corr. Cta. Orden Cartera Castigada 30*/
            CALL  CONTACREDITOSCONTPRO (
				Par_CreditoID,			Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
                Par_FechaAplicacion,    Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
                Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
                Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,			Con_CorCastigo,
				Mov_CapVigente,    	 	Nat_Cargo,              AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
                Salida_NO,				Par_NumErr,             Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
                Par_ModoPago,			Aud_Usuario,        	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := 'Operacion Realizada Exitosamente';

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;
    END IF;

END TerminaStore$$