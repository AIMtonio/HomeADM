DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAESTANALISTASALT`; 
DELIMITER $$

CREATE  PROCEDURE `BITACORAESTANALISTASALT`(

	Par_UsuarioID			INT(11),		-- ID del Usuario
	Par_Estatus             VARCHAR(15),		-- Parametro estatus
	

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
DECLARE	Var_Consecutivo INT(11);         -- Id de la tabla
DECLARE	Var_UsuarioID INT(11);           -- Id de la tabla
DECLARE Var_Estatus   CHAR(1);

-- Declaracion de Constantes
DECLARE	Entero_Cero		INT(11);         -- Entero cero
DECLARE	SalidaSI        CHAR(1);         -- Salida SI
DECLARE	Cadena_Vacia	CHAR(1);	     -- Cadena vacia
DECLARE Est_Activo      VARCHAR(15);     -- Estado Activo
DECLARE Est_Inactivo    VARCHAR(15);     -- Estado Inactivo
DECLARE E_Activo      CHAR(1);           -- Estado Activo
DECLARE E_Inactivo    CHAR(1);           -- Estado Inactivo




SET Entero_Cero			:= 0;	         -- Entero cero			
SET	SalidaSI        	:= 'S';			 -- Salida SI	
SET	Cadena_Vacia	    := '';           -- Cadena vacia
SET	Est_Activo	        := 'ACTIVO';     -- Estatus Activo
SET	Est_Inactivo	    := 'INACTIVO';   -- Estatus Inactivo
SET E_Activo            := 'A';          -- A de activo
SET E_Inactivo          := 'I';          -- I inactivo


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORAESTANALISTASALT');
			SET Var_Control:= 'sqlException' ;
		END;
        
		SET Var_Consecutivo := (SELECT IFNULL(MAX(BitacoraUsuarioID),Entero_Cero) + 1 FROM BITACORAESTANALISTAS);
		SET Var_UsuarioID := (SELECT IFNULL(UsuarioID,Entero_Cero) FROM USUARIOS WHERE UsuarioID=Par_UsuarioID);


		IF(IFNULL(Var_UsuarioID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'EL numero usuario no existe.';
			SET Var_Control	:= 'usuarioID';
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Estatus,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'Estatus vacio.';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Estatus <> Est_Activo) THEN
			IF(Par_Estatus <> Est_Inactivo) THEN
			SET Par_NumErr     := 003;
			SET Par_ErrMen    := 'Estatus incorrecta';
			SET Var_Control   := 'estatus';
			LEAVE ManejoErrores;
		    END IF;
		END IF;	


		IF(Par_Estatus <> Est_Inactivo) THEN
	       SET Var_Estatus  := E_Activo;
	       ELSE
	        SET Var_Estatus := E_Inactivo;
		END IF;	



		

        SET Aud_FechaActual := NOW();


	   INSERT INTO BITACORAESTANALISTAS(
			BitacoraUsuarioID,			        UsuarioID,				FechaEstatus,				Estatus,			EmpresaID,
            Usuario,        	                FechaActual,		    DireccionIP,	            ProgramaID,		    Sucursal,
            NumTransaccion)
		VALUES
			(Var_Consecutivo,	                Var_UsuarioID,			Aud_FechaActual,			Var_Estatus,		Par_EmpresaID,
	        Aud_Usuario,        	            Aud_FechaActual,		Aud_DireccionIP,		    Aud_ProgramaID,		Aud_Sucursal,       
	        Aud_NumTransaccion);


        

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;



		SET	Par_NumErr := Entero_Cero;
	    SET	Par_ErrMen :=CONCAT('Estatus Actualizado Correctamente Usuario: ',Var_UsuarioID);
	    SET Var_Control:= 'UsuarioID';



END ManejoErrores;  

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$