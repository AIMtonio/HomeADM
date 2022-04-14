-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACLAVEPDFALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACLAVEPDFALT`;DELIMITER $$

CREATE PROCEDURE `EDOCTACLAVEPDFALT`(
	-- STORED PROCEDURE PARA REALIZAR EL ALTA A LA TABLA EDOCTACLAVEPDF CON LA CLAVE QUE EL CLIENTE DESEA PARA SU ENVIO POR CORREO
	Par_ClienteID			INT(11),		-- ID de Cliente
	Par_Contrasenia			VARCHAR(80),	-- Clave encriptada del cliente para el estado de cuenta que se enviara por correo

	Par_Salida				CHAR(1),		-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),		-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro que corresponde a un mensaje de exito o error

	Par_EmpresaID			INT(11),		-- Parametros de Auditoria
	Aud_Usuario				INT(11),		-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal			INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);			-- Variable de Control
	DECLARE Var_FechaActualiza			DATETIME;				-- Cliente ID consultado de la tabla
	DECLARE Var_Contrasenia				VARCHAR(80);			-- Contraseña decodificada
	DECLARE Var_ValidaContrasenia		VARCHAR(100);			-- Contraseña decodificada


	-- Declaracion de Constantes.
	DECLARE Var_SalidaSi				CHAR(1);				-- Indica que si se devuelve un mensaje de salida
	DECLARE Cadena_Vacia				CHAR(1);				-- Cadena Vacia
	DECLARE Fecha_Vacia					DATE;					-- Fecha Vacia
	DECLARE Entero_Cero					INT(11);				-- Entero Cero
	DECLARE Var_Exito					CHAR(5);				-- Texto de Exito para la Validacion de  la clave


	-- Asignacion de Constantes
	SET	Var_SalidaSi					:= 'S';					-- El SP si genera una salida
	SET Cadena_Vacia					:= '';					-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero						:= 0;					-- Entero Cero
	SET	Var_Exito						:= 'EXITO';				-- Texto de Exito para la Validacion de  la clave

	ManejoErrores: BEGIN

			DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
											'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTACLAVEPDFALT');
				SET Var_Control = 'sqlException';
			END;


			SET Var_Contrasenia		:= (SELECT FROM_BASE64(Par_Contrasenia) );

			SET	Var_Contrasenia		:= (IFNULL(Var_Contrasenia, Cadena_Vacia) );

			IF (Par_ClienteID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'El Numero de Cliente esta vacio';
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;

			SELECT	FechaActualiza
				INTO Var_FechaActualiza
				FROM EDOCTACLAVEPDF
				WHERE	ClienteID = Par_ClienteID;


			SET	Var_FechaActualiza		:=	IFNULL(Var_FechaActualiza, Fecha_Vacia);


			IF (Var_FechaActualiza <> Fecha_Vacia) THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= CONCAT('El cliente ya fue previamente registrado el dia ',  DATE_FORMAT(Var_FechaActualiza, '%d/%m/%Y') );
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;


			IF (Par_Contrasenia = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 003;
				SET	Par_ErrMen	:= 'Favor de especificar una clave valida.';
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;


			SET	Var_ValidaContrasenia := FNVALIDACONTRASENIA(Var_Contrasenia);

			IF (Var_ValidaContrasenia <> Var_Exito) THEN
				SET	Par_NumErr 	:= 004;
				SET	Par_ErrMen	:= Var_ValidaContrasenia;
				SET Var_Control := 'ClienteID';
				LEAVE ManejoErrores;
			END IF;


			INSERT INTO EDOCTACLAVEPDF (	ClienteID,				Contrasenia,			CorreoEnvio,			FechaActualiza,			EmpresaID,
											Usuario,				FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
											NumTransaccion	)
							VALUES		(	Par_ClienteID,			Par_Contrasenia,		Cadena_Vacia,			Aud_FechaActual,		Par_EmpresaID,
											Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
											Aud_NumTransaccion	);
			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'El Cliente Registro con exito su clave para los estados de cuenta';
			SET Var_Control := 'ClienteID';
			LEAVE ManejoErrores;


	END ManejoErrores; -- Fin del bloque manejo de errores



	IF (Par_Salida = Var_SalidaSi) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;
END TerminaStore$$