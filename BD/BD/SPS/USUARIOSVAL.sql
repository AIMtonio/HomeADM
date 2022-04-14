-- USUARIOSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSVAL`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSVAL`(
-- ----- STORE DE VALIDACION DE LA CONTASEÑA DEL USUARIO ---------
	Par_NumUsuario		INT(11),			-- ID del usuario
	Par_Contrasenia		VARCHAR(45),		-- Contrasenia del usuario
    Par_ConfirmarContra	VARCHAR(45),		-- Confirmacion contraseña

    Par_NumVal			TINYINT UNSIGNED,	-- Numero de actualizacion que realizara
	Par_Salida			CHAR(1),			-- Campo a la que hace referencia
    INOUT Par_NumErr	INT,				-- Parametro del numero de Error
    INOUT Par_ErrMen	VARCHAR(400),		-- Parametro del Mensaje de Error

    Par_EmpresaID      	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario        	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual    	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP    	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID     	VARCHAR(50),		-- Parametro de auditoria Programa

    Aud_Sucursal       	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion 	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_Contrasenia			VARCHAR(100);	-- Variable para guardar contrasenia
	DECLARE Var_ConfirmarCon		VARCHAR(100);	-- Variable para guardar contrasenia

	-- Declaracion de Constantes
	DECLARE Con_Consulta 			TINYINT UNSIGNED;
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE HabilitaConfPass		VARCHAR(100);	-- Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Con_SalidaSI			CHAR(1);


	-- Asignacion de Constantes
	SET Con_Consulta			:= 1;				-- numero de consulta
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET HabilitaConfPass		:= "HabilitaConfPass";		-- Llave Parametro: Indica si la contrasenia requiere configuracion
	SET Con_SalidaSI			:= 'S';

		-- Asignacion valores default
	SET Par_Contrasenia	 := IFNULL(Par_Contrasenia, Cadena_Vacia);
	SET Par_ConfirmarContra := IFNULL(Par_ConfirmarContra, Cadena_Vacia);



	ManejoErrores:BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-USUARIOSVAL');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	IF(Par_NumVal = Con_Consulta ) THEN

		-- si las contrasenia no coinciden desplegar el error
		IF(Par_Contrasenia = Cadena_Vacia) THEN
			SET Par_NumErr		:=	1;
			SET Par_ErrMen		:=	'La contrase&ntilde;a ingresada se encuenta vacia';
			LEAVE ManejoErrores; -- el manejador de error se pone cuando se hace una transaccion o una actualizacion
		END IF;

		IF(Par_ConfirmarContra = Cadena_Vacia) THEN
			SET Par_NumErr		:=	2;
			SET Par_ErrMen		:=	'La confirmacion de la contrase&ntilde;a ingresada se encuenta vacia';
			LEAVE ManejoErrores; -- el manejador de error se pone cuando se hace una transaccion o una actualizacion
		END IF;

		-- si las contrasenia no coinciden desplegar el error
		IF(Par_Contrasenia <> Par_ConfirmarContra) THEN
			SET Par_NumErr		:=	3;
			SET Par_ErrMen		:=	'La contrase&ntilde;a y la confirmacion de la contrase&ntilde;a no coinciden, vuelva a intentarlo';
			LEAVE ManejoErrores; -- el manejador de error se pone cuando se hace una transaccion o una actualizacion
		END IF;

	SET Par_NumErr		:=	Entero_Cero;
	SET Par_ErrMen		:=	'Las contrasenia fueron validadas con Exito';
	SET Var_Control		:= 'usuarioID';

	END IF;







 END ManejoErrores;

	IF (Par_Salida = Con_SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
                Par_NumUsuario	AS Consecutivo;
    END IF;

END TerminaStore$$
