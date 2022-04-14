-- BITAERRORPLDDETOPETRANALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITAERRORPLDDETOPETRANALT`;
DELIMITER $$

CREATE PROCEDURE `BITAERRORPLDDETOPETRANALT`(
-- =====================================================================================
-- ---- STORED PARA ALTA DE BITACORA ERROR PLD DETECCION OPERACIONES TRANSACCIONES------
-- =====================================================================================
	Par_Procedimiento 		VARCHAR(50), 	-- Nombre del procedimiento
	Par_NumeroError			INT(11), 		-- Numero de error
	Par_ErrorMensaje		VARCHAR(600), 	-- Mensaje de error
	Par_TipoOperacion 		INT(11),		-- Tipo de operacion 1 = Abonos y cargos cuenta, 2= Pago de credito
	Par_ClienteID 			INT(11), 		-- id de cliente

    Par_CreditoID 			BIGINT(12),		-- id de credito
	Par_NatMovimiento 		CHAR(1),		-- Naturaleza del movimiento cargo o abono
    Par_Monto		    	DECIMAL(18,2),	-- Monto

    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;				-- Fecha de sistema

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_SI       		CHAR(1);   			-- Constante  S, valor si
	DECLARE Cons_NO       		CHAR(1); 			-- Constante  N, valor no

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_SI          		:= 'S';
	SET Cons_NO           		:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITAERRORPLDDETOPETRANALT');
			SET Var_Control = 'sqlException';
		END;

        SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
        SET Aud_FechaActual:= NOW();

        INSERT INTO BITAERRORPLDDETOPETRAN(
			Procedimiento,		NumErr,				ErrMen,					TipoOperacion,			ClienteID,
            CreditoID,			NatMovimiento,		FechaSistema,			Monto,
			EmpresaID, 			Usuario, 			FechaActual, 			DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion
        )VALUES(
			Par_Procedimiento,	Par_NumeroError,	Par_ErrorMensaje,		Par_TipoOperacion,		Par_ClienteID,
			Par_CreditoID,		Par_NatMovimiento,	Var_FechaSistema,		Par_Monto,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= 'Bitacora Registrada Exitosamente.';
		SET Var_Control		:= '';
		SET Var_Consecutivo	:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) then
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$