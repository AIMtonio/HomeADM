DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONADOSFISCALESBAJ`;
DELIMITER $$

CREATE PROCEDURE `RELACIONADOSFISCALESBAJ`(
# =====================================================================================
# ------- STORED PARA BAJA DE RELACIONADOS FISCALES  ---------
# =====================================================================================
	Par_ClienteID			INT(11),		-- ID del cliente tabla CLIENTES
	Par_TipoBaja			INT(11),		-- Numero de baja

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
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES

    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_NO   	    	CHAR(1);      		-- Constante NO
	DECLARE Baja_Relacionados	INT(11);			-- Baja 1 : relacionados fiscales por cliente

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';
    SET Baja_Relacionados		:= 1;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-RELACIONADOSFISCALESBAJ');
			SET Var_Control = 'SQLEXCEPTION';
		END;

        -- Baja de todos los relacionados de un cliente
        IF(Par_TipoBaja = Baja_Relacionados)THEN
			DELETE FROM RELACIONADOSFISCALES
			WHERE ClienteID = Par_ClienteID;
        END IF;

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Relacionado Fiscal Eliminado Exitosamente:',CAST(Par_ClienteID AS CHAR) );
		SET Var_Control		:= 'relacionadoFiscalID';
		SET Var_Consecutivo	:= Par_ClienteID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$