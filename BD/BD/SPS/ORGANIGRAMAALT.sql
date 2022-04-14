-- ORGANIGRAMAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANIGRAMAALT`;
DELIMITER $$

CREATE PROCEDURE `ORGANIGRAMAALT`(
-- =====================================================================================
-- ------- STORED PARA ALTA DE DEPENDENCIAS EN EL ORGANIGRAMA ---------
-- =====================================================================================
	Par_PuestoPadreID		BIGINT(20),		-- ID de empleado que tiene un puesto padre
	Par_PuestoHijoID		BIGINT(20),		-- ID de empleado que tiene el puesto hijo
    Par_RequiereCtaCon		CHAR(1),		-- Si el puesto padre requiere las cuentas contables de los puestos hijos: S= si, N=no
    Par_CtaContable			VARCHAR(50),	-- Numero de cuenta contable del puesto hijo
	Par_CentroCostoID		INT(11),		-- ID del centro de costos del puesto hijo

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
    
    -- DECLARACION DE CONSTANTES  
	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
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
							'esto le ocasiona. Ref: SP-ORGANIGRAMAALT');
			SET Var_Control = 'SQLEXCEPTION';  
		END;
        
        IF(Par_PuestoPadreID = Par_PuestoHijoID) THEN
			SET Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= CONCAT('El empleado: ',Par_PuestoHijoID, ' no se puede agregar como dependencia a el mismo.');
			SET Var_Control		:= 'puestoHijoID';
			LEAVE ManejoErrores;   
		END IF;
        
		IF(EXISTS(SELECT PuestoHijoID
					FROM ORGANIGRAMA
					WHERE PuestoHijoID = Par_PuestoHijoID ))THEN
			SET Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= CONCAT('El empleado: ', Par_PuestoHijoID,' ya esta asignado como dependencia.');
			SET Var_Control		:= 'puestoHijoID';
			LEAVE ManejoErrores;   
		END IF;
		
        SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO ORGANIGRAMA (
			PuestoPadreID,		PuestoHijoID,		RequiereCtaCon,		CtaContable,		CentroCostoID,		 	
            EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,		
            Sucursal,			NumTransaccion
		)VALUES(
			Par_PuestoPadreID,	Par_PuestoHijoID,	Par_RequiereCtaCon,	Par_CtaContable,	Par_CentroCostoID,
            Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,   	Aud_ProgramaID,	
			Aud_Sucursal,		Aud_NumTransaccion
		);
        
		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Empleado agregado exitosamente:',CAST(Par_PuestoHijoID AS CHAR));
		SET Var_Control		:= 'puestoHijoID';
		SET Var_Consecutivo	:= Par_PuestoHijoID;
    
	END ManejoErrores;
    
	IF (Par_Salida = Salida_SI) THEN
		SELECT 
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
  
	END IF;

END TerminaStore$$