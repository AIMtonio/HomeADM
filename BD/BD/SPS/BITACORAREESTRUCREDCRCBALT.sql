DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAREESTRUCREDCRCBALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORAREESTRUCREDCRCBALT`(
# =====================================================================================
# ------- STORED PARA ALTA DE BITACORA DE REESTRUCTURAS ---------
# =====================================================================================
	Par_ClienteID			INT(11),		-- Identificador del cliente tabla CLIENTES
	Par_ProductoCreditoID	INT(11), 		-- Numero de Producto de Credito tabla PRODUCTOSCREDITO
	Par_Frecuencia			CHAR(1),		-- Frecuencia de Pagos: Semanal, Catorcenal, Quincenal, Mensual ...... Anual
	Par_PlazoID				INT(11), 		-- Numero de Plazo
	Par_CreditoOrigen		BIGINT(20), 	-- Si es 0, indica que se generara un nuevo credito con el producto que se indique.\nSi es diferente a 0, el dato corresponda a un credito existente en SAFI ese credito se reestructurara unicamente extendiendo el plazo por default 6 meses, esto modificara unicamente la fecha de vencimiento.

    Par_PlazoExt			INT(11),		-- indica el plazo a extender del credito a reestructurar.
	Par_Descripcion			VARCHAR(600),	-- INdica la descripcion de por que no se dio de alta la reestructura.

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
    DECLARE Var_BitacoraID		INT(11);

    -- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno
	DECLARE Cons_NO   	    	CHAR(1);      		-- Constante NO

    -- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;
	SET Cons_NO		          	:= 'N';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-BITACORAREESTRUCREDCRCBALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Par_ClienteID := IFNULL(Par_ClienteID,Entero_Cero);
		SET Par_ProductoCreditoID := IFNULL(Par_ProductoCreditoID,Entero_Cero);
		SET Par_Frecuencia := IFNULL(Par_Frecuencia,Cadena_Vacia);
		SET Par_PlazoID := IFNULL(Par_PlazoID,Entero_Cero);
		SET Par_CreditoOrigen := IFNULL(Par_CreditoOrigen,Entero_Cero);

		SET Par_PlazoExt := IFNULL(Par_PlazoExt,Entero_Cero);
		SET Par_Descripcion := IFNULL(Par_Descripcion,Cadena_Vacia);

        SET Var_BitacoraID := (SELECT IFNULL(MAX(BitacoraID),Entero_Cero) + Entero_Uno FROM BITACORAREESTRUCREDCRCB);
		SET Aud_FechaActual := NOW();
		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        INSERT INTO BITACORAREESTRUCREDCRCB(
			BitacoraID, 		ClienteID, 			ProductoCreditoID, 		Frecuencia, 			PlazoID,
            CreditoOrigen, 		PlazoExt,			FechaSistema, 			Hora, 					Descripcion,
			EmpresaID, 			Usuario, 			FechaActual, 			DireccionIP, 			ProgramaID,
			Sucursal, 			NumTransaccion
        )VALUES(
			Var_BitacoraID,		Par_ClienteID,		Par_ProductoCreditoID,	Par_Frecuencia,			Par_PlazoID,
            Par_CreditoOrigen,	Par_PlazoExt,		Var_FechaSistema,		TIME(Aud_FechaActual),	Par_Descripcion,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion
        );

		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Bitacora Agregada Exitosamente:',CAST(Var_BitacoraID AS CHAR));
		SET Var_Control		:= 'bitacoraID';
		SET Var_Consecutivo	:= Var_BitacoraID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$
