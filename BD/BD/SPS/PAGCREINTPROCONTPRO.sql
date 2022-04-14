-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREINTPROCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREINTPROCONTPRO`;DELIMITER $$

CREATE PROCEDURE `PAGCREINTPROCONTPRO`(
/*SP para el Pago de interes Provisionado Creditos contingentes*/
    Par_CreditoID       	BIGINT(12),
    Par_AmortiCreID     	INT(4),
    Par_FechaInicio     	DATE,
    Par_FechaVencim     	DATE,
    Par_CuentaAhoID     	BIGINT,

    Par_ClienteID       	INT,
    Par_FechaOperacion  	DATE,
    Par_FechaAplicacion 	DATE,
    Par_Monto          	 	DECIMAL(14,4),
    Par_IVAMonto        	DECIMAL(14,2),

    Par_MonedaID        	INT,
    Par_ProdCreditoID   	INT,
    Par_Clasificacion   	CHAR(1),
    Par_SubClasifID     	INT,
    Par_SucCliente      	INT,

    Par_Descripcion     	VARCHAR(100),
    Par_Referencia			VARCHAR(50),
    Par_Poliza          	BIGINT,
	Par_Salida          	CHAR(1),

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,

    Par_EmpresaID       	INT(11),
    Par_ModoPago        	CHAR(1),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	# DECLARACION DE VARIABLES
	DECLARE Var_Refinancia			CHAR(1);		# Indica si el credito refinancia los intereses
	DECLARE Var_MontoAcumulado		DECIMAL(14,2);	# Indica el Monto Acumulado de Intereses del Credito
	DECLARE Var_MontoRefinanciar	DECIMAL(14,2);	# Indica el Monto a Refinanciar de Intereses del Credito

	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero    	DECIMAL(12, 2);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Mov_IntProvis   	INT;
	DECLARE Mov_IVAInteres  	INT;
	DECLARE Con_IntProvis   	INT;
	DECLARE Con_IVAInteres  	INT;
	DECLARE SalidaSI 			CHAR(1);
	DECLARE Salida_NO           CHAR(1);
	DECLARE	Con_OrdCasInt 		INT;
	DECLARE	Con_IntAtrasado 	INT;
    DECLARE Cons_SI				CHAR(1);


	/* Asignacion de Constantes */
	SET Cadena_Vacia    	:= '';                   -- Cadena o String Vacio
	SET Fecha_Vacia     	:= '1900-01-01';         -- Fecha Vacia
	SET Entero_Cero     	:= 0;                    -- Entero en Cero
	SET Decimal_Cero    	:= 0.00;                 -- Decimal en Cero
	SET AltaPoliza_NO   	:= 'N';                  -- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI   	:= 'S';	                 -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_SI   	:= 'S';                  -- Alta del Movimiento de Credito: SI
	SET AltaMovCre_NO   	:= 'N';	                 -- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO   	:= 'N';                  -- Alta del Movimiento de Ahorro: NO
	SET Nat_Cargo       	:= 'C';                  -- Naturaleza del Movimiento: Cargo
	SET Nat_Abono       	:= 'A';                  -- Naturaleza del Movimiento: Abono
	SET Mov_IntProvis   	:= 14;	                 -- Movimiento Operativo de Credito: Interes Provisionado
	SET Mov_IVAInteres  	:= 20;                   -- Movimiento Operativo de Credito: IVA de Interes
	SET Con_IntProvis   	:= 78;                   -- Concepto de cartera: Resultados. Recup. Interes Cartera Castigada
	SET Con_IVAInteres  	:= 81;                    -- Concepto Contable: IVA Recuperacion C.Castigada
	SET SalidaSI			:= 'S';         		 -- Salida SI
	SET Salida_NO       	:= 'N';
	SET	Con_OrdCasInt 		:= 72;					/* Cta. Orden Interes Cartera Castigada */
	SET Con_IntAtrasado 	:= 73;			/*Cuenta de orden interes atrasado*/
	SET Cons_SI				:= 'S';					# Constante SI

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PAGCREINTPROCONTPRO');
        END;


		SELECT  Refinancia,		InteresAcumulado,	InteresRefinanciar
		INTO 	Var_Refinancia,	Var_MontoAcumulado,	Var_MontoRefinanciar
		FROM 	CREDITOSCONT
		WHERE 	CreditoID = Par_CreditoID;

		SET Var_Refinancia 			:= IFNULL(Var_Refinancia, Cadena_Vacia);
		SET Var_MontoAcumulado		:= IFNULL(Var_MontoAcumulado, Decimal_Cero);
		SET Var_MontoRefinanciar	:= IFNULL(Var_MontoRefinanciar, Decimal_Cero);


		IF (Par_Monto > Decimal_Cero) THEN

			# VALIDA SI EL CREDITO ES AGROPECUARIO Y REFINANCIA INTERESES
			IF(Var_Refinancia = Cons_SI) THEN

				# VALIDA SI EL MONTO A PAGAR ES MAYOR AL MONTO BASE DE INTERES PARA EL CALCULO
				IF(Par_Monto > Var_MontoRefinanciar) THEN
					# AL INTERES ACUMULADO SE LE RESTA LO QUE SE ESTÁ PAGANDO Y EL INTERES SE QUEDA EN CERO
					UPDATE CREDITOSCONT
							SET	InteresAcumulado = CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
														ELSE InteresAcumulado - Par_Monto END,
								InteresRefinanciar = Decimal_Cero
							WHERE CreditoID = Par_CreditoID;

				ELSE
					# SI EL MONTO A PAGAR NO ES MAYOR, AL INTERES ACUMULADO E INTERES A REFINANCIAR SE LE RESTA EL MONTO PAGADO
                    UPDATE CREDITOSCONT
					SET	InteresAcumulado = CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
												ELSE InteresAcumulado - Par_Monto END,
						InteresRefinanciar = InteresRefinanciar - Par_Monto
					WHERE CreditoID = Par_CreditoID;

				END IF;

			END IF;

		   /* Contabilidad del Pago del Interes Provisionado Resultados. Recup. Interes Cartera Castigada 46*/
			CALL  CONTACREDITOSCONTPRO (
		        Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,   		Par_ClienteID,			Par_FechaOperacion,
		        Par_FechaAplicacion,    	Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
		        Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
		        Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,      	Con_IntProvis,
		        Mov_IntProvis,      		Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
		        Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
		        Par_ModoPago,           	Aud_Usuario,            Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,
		        Aud_Sucursal,           	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

			/*Cta. Orden Interes Cartera Castigada Num 40*/
			CALL  CONTACREDITOSCONTPRO (
		        Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,   		Par_ClienteID,			Par_FechaOperacion,
		        Par_FechaAplicacion,    	Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
		        Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
		        Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,      	Con_OrdCasInt,
		        Mov_IntProvis,      		Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
		        Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
		        Par_ModoPago,           	Aud_Usuario,            Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,
		        Aud_Sucursal,           	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

             /*	Cuentas de orden cargo*/
            CALL  CONTACREDITOSCONTPRO (
		        Par_CreditoID,      		Par_AmortiCreID,        Par_CuentaAhoID,   		Par_ClienteID,			Par_FechaOperacion,
		        Par_FechaAplicacion,    	Par_Monto,          	Par_MonedaID,			Par_ProdCreditoID,  	Par_Clasificacion,
		        Par_SubClasifID,    		Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
		        Entero_Cero,				Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_NO,      	Con_IntAtrasado,
		        Mov_IntProvis,      		Nat_Cargo,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
		        Salida_NO,					Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
		        Par_ModoPago,           	Aud_Usuario,            Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID,
		        Aud_Sucursal,           	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

		END IF;

		IF (Par_IVAMonto > Decimal_Cero) THEN
		    CALL  CONTACREDITOSCONTPRO (
		        Par_CreditoID,      	Par_AmortiCreID,        Par_CuentaAhoID,    	Par_ClienteID,			Par_FechaOperacion,
		        Par_FechaAplicacion,    Par_IVAMonto,       	Par_MonedaID,			Par_ProdCreditoID,		Par_Clasificacion,
		        Par_SubClasifID,    	Par_SucCliente,			Par_Descripcion,    	Par_Referencia,         AltaPoliza_NO,
		        Entero_Cero,			Par_Poliza,         	AltaPolCre_SI,          AltaMovCre_SI,      	Con_IVAInteres,
		        Mov_IVAInteres,     	Nat_Abono,              AltaMovAho_NO,      	Cadena_Vacia,			Cadena_Vacia,
		        Salida_NO,				Par_NumErr,             Par_ErrMen,         	Par_Consecutivo,		Par_EmpresaID,
		        Par_ModoPago,           Aud_Usuario,        	Aud_FechaActual,   		Aud_DireccionIP,		Aud_ProgramaID,
		        Aud_Sucursal,       	Aud_NumTransaccion);

		    IF(Par_NumErr != Entero_Cero)THEN
	            LEAVE ManejoErrores;
	        END IF;

		END IF;

		SET Par_NumErr := Entero_Cero;
        SET Par_ErrMen := 'Operacion Realizada Exitosamente';

END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;
    END IF;

END TerminaStore$$