-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWUSUARIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWUSUARIOSACT`;

DELIMITER $$
CREATE PROCEDURE `APPWUSUARIOSACT`(



	Par_ClienteID		INT(11),
	Par_Clave			VARCHAR(45),
	Par_IMEI			VARCHAR(45),

	Par_NumAct			TINYINT UNSIGNED,

    Par_Salida			CHAR(1),
    INOUT Par_NumErr	INT,
    INOUT Par_ErrMen	VARCHAR(400),

    Aud_EmpresaID      	INT(11),
    Aud_Usuario        	INT(11),
    Aud_FechaActual    	DATETIME,
    Aud_DireccionIP    	VARCHAR(15),
    Aud_ProgramaID     	VARCHAR(50),

    Aud_Sucursal       	INT(11),
    Aud_NumTransaccion 	BIGINT(20)
)

TerminaStore: BEGIN


    DECLARE Var_Control		VARCHAR(50);
    DECLARE Var_IMEI		VARCHAR(45);
    DECLARE Var_UsuarioID	INT(11);


    DECLARE Con_SalidaSI		CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(1);
    DECLARE Act_UsaAplicacion	INT(11);


	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET Con_SalidaSI			:= 'S';
	SET Act_UsaAplicacion		:= 1;

	SET Aud_EmpresaID	:= IFNULL(Aud_EmpresaID, Entero_Cero);
	SET Par_Clave		:= IFNULL(Par_Clave, Cadena_Vacia);
	SET Par_IMEI		:= IFNULL(Par_IMEI, Cadena_Vacia);

	IF(Aud_EmpresaID = Entero_Cero) THEN
		SET Aud_EmpresaID = 1;
	END IF;

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-APPWUSUARIOSACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;


	IF(Par_NumAct = Act_UsaAplicacion) THEN

		IF (Par_Clave = Cadena_Vacia ) THEN
            SET Par_NumErr		:=	001;
			SET Par_ErrMen		:=	'La clave del usuario se encuentra vacia';
			SET Var_Control		:=	'clave';

			LEAVE ManejoErrores;
		END IF;
		IF (Par_IMEI = Cadena_Vacia ) THEN

			SET Par_NumErr		:=	002;
			SET Par_ErrMen		:=	'El IMEI del usuario se encuentra vacio';
			SET Var_Control		:=	'IMEI';

			LEAVE ManejoErrores;
		END IF;

		IF(CHAR_LENGTH(Par_IMEI) < 1) THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= 'El IMEI contiene menos caracteres de lo requerido. Minimo admitido: 1';
			SET Var_Control	:= 'IMEI';
			LEAVE ManejoErrores;
		END IF;

		IF(CHAR_LENGTH(Par_IMEI) > 32) THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen 	:= 'El IMEI contiene mas caracteres de lo requerido. Maximo admitido: 32';
			SET Var_Control	:= 'IMEI';
			LEAVE ManejoErrores;
		END IF;


		SELECT IMEI, UsuarioID
		INTO Var_IMEI, Var_UsuarioID
		FROM USUARIOS WHERE Clave = Par_Clave;

		SET Var_IMEI := IFNULL(Var_IMEI, Cadena_Vacia);
		SET Var_UsuarioID := IFNULL(Var_UsuarioID, Entero_Cero);

		IF(Var_IMEI != Cadena_Vacia) THEN
			SET Par_NumErr		:=	003;
			SET Par_ErrMen		:=	'El IMEI para este usuario ha sido registrado anteriomente.';
			SET Var_Control		:=	'IMEI';

			LEAVE ManejoErrores;
		END IF;
		IF(Var_UsuarioID = Entero_Cero) THEN
			SET Par_NumErr		:=	004;
			SET Par_ErrMen		:=	'El usuario no existe';
			SET Var_Control		:=	'usuarioID';

			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE USUARIOS SET
				IMEI			   = Par_IMEI,
				EmpresaID	 	= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
		WHERE UsuarioID = Var_UsuarioID;

		SET Par_NumErr		:=	0;
		SET Par_ErrMen		:=	CONCAT( 'Usuario Actualizado ',CONVERT(Var_UsuarioID, CHAR));
		SET Var_Control		:=	'usuarioID';

        LEAVE ManejoErrores;
	END IF;
 END ManejoErrores;

	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
                Var_UsuarioID	AS Consecutivo;
    END IF;

END TerminaStore$$