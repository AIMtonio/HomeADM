-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARENVIOCORREOPARAMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARENVIOCORREOPARAMALT`;DELIMITER $$

CREATE PROCEDURE `TARENVIOCORREOPARAMALT`(
	-- SP para la alta de envio correos
	Par_Descripcion					VARCHAR(80),		-- Nombre con el que se identifica el remitente
	Par_ServidorSMTP				VARCHAR(80),		-- Direccion del servidor STMP
	Par_PuertoServerSMTP			VARCHAR(6),			-- Puerto del servidor STMP
	Par_TipoSeguridad				CHAR(2),			-- Tipo de seguridad(N-Ninguna,S-SSL,T-STARTTLS )
	Par_CorreoSalida				VARCHAR(80),		-- Dirreccion correo donde saldran los correos
	Par_ConAutentificacion			CHAR(1),			-- (S-N) indica si el correo de salida requiere autentificacion
	Par_Contrasenia					VARCHAR(20),		-- Contraseña del correo de salida
	Par_Estatus						CHAR(1),			-- Estatus del remitente (A-B)
	Par_Comentario					VARCHAR(200),		-- Comentarios
	Par_AliasRemitente				VARCHAR(30),		-- Alias del correo remitente
	Par_TamanioMax					INT(11),			-- Tamanio maximo permitido de los archivos adjuntos
	Par_Tipo						CHAR(2),			-- Tipo de representacion para el campo tamanioMax MB-Megabytes y KB-Kilobytes

	Par_Salida						CHAR(1),			-- Indica el tipo de Salida S.- Si N.- No
	INOUT Par_NumErr				INT(11),			-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),			-- Parametro de auditoria
	Aud_Usuario						INT(11),			-- Parametro de auditoria
	Aud_FechaActual					DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal					INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_RemitenteID			INT(11);			-- Identificador de la tabla
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control

	-- Declaracion de Constantes
	DECLARE con_Estatus				CHAR(1);			-- Estatus
	DECLARE Entero_Cero				INT(1);				-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE SalidaSI				CHAR(1);			-- Salida si
    DECLARE SalidaNO				CHAR(1);			-- Salida no
	DECLARE Fecha_Vacia				DATETIME;			-- Fecha vacia
	DECLARE EstSI	 				CHAR(1);			-- Con Autentificacion

	-- Asignacion de Constantes
	SET Entero_Cero					:=0;				-- Entero Cero
	SET Cadena_Vacia				:='';				-- Cadena_ Vacia
	SET SalidaSI					:='S';				-- String SI
	SET SalidaNO					:='N';				-- String NO
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET EstSI						:='S';				-- Con Autentificacion

	-- Valores por default
	SET Par_Descripcion 			:= IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_ServidorSMTP 			:= IFNULL(Par_ServidorSMTP,Cadena_Vacia);
	SET Par_PuertoServerSMTP 		:= IFNULL(Par_PuertoServerSMTP,Cadena_Vacia);
	SET Par_TipoSeguridad 			:= IFNULL(Par_TipoSeguridad,Cadena_Vacia);
	SET Par_CorreoSalida 			:= IFNULL(Par_CorreoSalida,Cadena_Vacia);
	SET Par_ConAutentificacion		:= IFNULL(Par_ConAutentificacion,Cadena_Vacia);
	SET Aud_EmpresaID				:= IFNULL(Aud_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TARENVIOCORREOPARAMALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF(Par_Descripcion=Cadena_Vacia)THEN
			SET	Par_NumErr := 001;
			SET	Par_ErrMen := CONCAT("La descripcion esta vacia");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ServidorSMTP=Cadena_Vacia)THEN
			SET	Par_NumErr := 002;
			SET	Par_ErrMen := CONCAT(" El Servidor SMTP esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_PuertoServerSMTP=Entero_Cero)THEN
			SET	Par_NumErr := 003;
			SET	Par_ErrMen := CONCAT("El Puerto Server SMTP esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoSeguridad=Cadena_Vacia)THEN
			SET	Par_NumErr := 004;
			SET	Par_ErrMen := CONCAT("El Tipo de Seguriad esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_CorreoSalida=Cadena_Vacia)THEN
			SET	Par_NumErr := 005;
			SET	Par_ErrMen := CONCAT("El Correo de salida esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ConAutentificacion=EstSI) AND (Par_Contrasenia=Cadena_Vacia) THEN
			SET Par_NumErr	:= 006;
			SET Par_ErrMen	:= CONCAT("Requiere una Contraseña");
			LEAVE ManejoErrores;
		END IF;

			IF(Par_TamanioMax=Entero_Cero) THEN
			SET Par_NumErr	:= 007;
			SET Par_ErrMen	:= CONCAT("Requiere tamaño maximo");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_AliasRemitente=Cadena_Vacia) THEN
			SET Par_NumErr	:= 008;
			SET Par_ErrMen	:= CONCAT("Requiere alias");
			LEAVE ManejoErrores;
		END IF;

		CALL	FOLIOSAPLICAACT('TARENVIOCORREOPARAM',Var_RemitenteID);

		INSERT INTO TARENVIOCORREOPARAM(
			RemitenteID, 	Descripcion,			ServidorSMTP,		PuertoServerSMTP, 	TipoSeguridad,
			CorreoSalida,	ConAutentificacion,		Contrasenia,		Estatus,			Comentario,
			AliasRemitente,	TamanioMax,				Tipo,				EmpresaID,			Usuario,
			FechaActual,	DireccionIP,			ProgramaID, 		Sucursal,			NumTransaccion)
		VALUES (
			Var_RemitenteID,	Par_Descripcion,			Par_ServidorSMTP,	Par_PuertoServerSMTP,	Par_TipoSeguridad,
			Par_CorreoSalida,	Par_ConAutentificacion,		Par_Contrasenia,	Par_Estatus,			Par_Comentario,
			Par_AliasRemitente,	Par_TamanioMax,				Par_Tipo,			Aud_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := CONCAT("Correo Registrado Correctamente: ", CONVERT(Var_RemitenteID,CHAR));

	END ManejoErrores;  -- End del Handler de Errores.

	IF(Par_Salida = SalidaSI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'RemitenteID' AS control,
				Var_RemitenteID AS consecutivo;
	END IF;

END TerminaStore$$