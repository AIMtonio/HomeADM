DELIMITER ;
DROP PROCEDURE IF EXISTS `HISSOLICITUDESASIGNACIONESALT`; 
DELIMITER $$

CREATE  PROCEDURE `HISSOLICITUDESASIGNACIONESALT`(

    Par_SolicitudCreditoID  INT(11),    	-- ID de la solicitud de credito
	Par_Salida				CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr		INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error
	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN


-- Declaracion de Variables
DECLARE	Var_Control     CHAR(20);        -- Control de Retorno en pantalla
DECLARE	Var_Consecutivo INT(11);         -- Id de la tabla

-- Declaracion de Constantes
DECLARE	Entero_Cero		INT(11);         -- Entero cero
DECLARE	SalidaSI        CHAR(1);         -- Salida SI
DECLARE AsignacionAuto  CHAR(1);


SET Entero_Cero			:= 0;	         -- Entero cero			
SET	SalidaSI        	:= 'S';			 -- Salida SI	
SET	AsignacionAuto      := 'S';			 -- Salida SI	

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISSOLICITUDESASIGNACIONESALT');
			SET Var_Control:= 'sqlException' ;
		END;
        
	SET Var_Consecutivo := (SELECT IFNULL(MAX(HisSolicitudAsignaID),Entero_Cero) + 1 FROM HISSOLICITUDESASIGNADAS);
    
	INSERT INTO HISSOLICITUDESASIGNADAS(
		HisSolicitudAsignaID,   SolicitudAsignaID,			UsuarioID,				SolicitudCreditoID,				TipoAsignacionID,	
        ProductoID,		        AsignacionAuto,             FechaAsignacion,        Estatus,                        EmpresaID,      
		Usuario,        	    FechaActual,	            DireccionIP,		    ProgramaID,		    	        Sucursal,
		NumTransaccion)
	SELECT
		Var_Consecutivo,        SolicitudAsignaID,	        UsuarioID,				SolicitudCreditoID,				TipoAsignacionID,	
        ProductoID,             AsignacionAuto,	        	FechaAsignacion,        Estatus,                        EmpresaID,
		Usuario,        	    FechaActual,		        DireccionIP,		    ProgramaID, 		    	    Sucursal,
        NumTransaccion
	  FROM SOLICITUDESASIGNADAS    WHERE     SolicitudCreditoID  =   Par_SolicitudCreditoID;
        
     DELETE FROM SOLICITUDESASIGNADAS WHERE SolicitudCreditoID=Par_SolicitudCreditoID; 


	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Guardado Exitosamente en el Historico.';
	SET Var_Control:= 'solicitudCreditoID' ;

END ManejoErrores;  

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$