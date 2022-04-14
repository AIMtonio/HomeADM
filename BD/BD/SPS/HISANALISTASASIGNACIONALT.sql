
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISANALISTASASIGNACIONALT`; 
DELIMITER $$

CREATE  PROCEDURE `HISANALISTASASIGNACIONALT`(

	Par_TipoAsignacionID	INT(11),        -- Parametro de tipo asignacion Analista A/analista E/ejecutivo		
    Par_ProductoID          INT(11),        -- ID de producto

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
DECLARE	Var_Control     CHAR(15);        -- Control de Retorno en pantalla
-- Declaracion de Constantes
DECLARE	Entero_Cero		INT(11);         -- Entero cero
DECLARE	SalidaSI        CHAR(1);         -- Salida SI
DECLARE SalidaNO        CHAR(1);         -- Salida NO


SET Entero_Cero			:= 0;	         -- Entero cero			
SET	SalidaSI        	:= 'S';			 -- Salida SI	
SET	SalidaNO        	:= 'S';			 -- Salida SI

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISANALISTASASIGNACIONALT');
			SET Var_Control:= 'sqlException' ;
		END;

	INSERT INTO HISANALISTASASIG (
	AnalistasAsigID,	        UsuarioID,                  TipoAsignacionID,		   ProductoID,                FechaAsignacion,           
	EmpresaID,			    	Usuario,					FechaActual,			   DireccionIP,		          ProgramaID,		            
	Sucursal,				    NumTransaccion		)
    SELECT
	AnalistasAsigID,		    UsuarioID,				    TipoAsignacionID ,          Par_ProductoID,           Aud_FechaActual ,
	Par_EmpresaID,			    Aud_Usuario,		    	Aud_FechaActual,			Aud_DireccionIP,		  Aud_ProgramaID,	
	Aud_Sucursal,			    Aud_NumTransaccion
    FROM ANALISTASASIGNACION WHERE	TipoAsignacionID=Par_TipoAsignacionID AND ProductoID=Par_ProductoID;  
        
	-- llamar al sp de baja
	call ANALISTASASIGNACIONBAJ(Par_ProductoID,          Par_TipoAsignacionID,         SalidaNO,         Par_NumErr,         Par_ErrMen,
		                        Par_EmpresaID,           Aud_Usuario,                   Aud_FechaActual, Aud_DireccionIP,    Aud_ProgramaID,
		                        Aud_Sucursal,            Aud_NumTransaccion);


	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Catalogo Guardado Exitosamente en el Historico.';
	SET Var_Control:= 'analistasAsigID' ;

END ManejoErrores;  

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control;
END IF;

END TerminaStore$$