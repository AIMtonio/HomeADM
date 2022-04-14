-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARENVIOCORREOPARAMMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARENVIOCORREOPARAMMOD`;DELIMITER $$

CREATE PROCEDURE `TARENVIOCORREOPARAMMOD`(
	-- SP para la modificacion de correos
	Par_RemitenteID			INT(11),				-- ID de la empresa
	Par_Descripcion			VARCHAR(80),			-- Nombre con el que se identifica el remitente
	Par_ServidorSMTP		VARCHAR(80),			-- Direccion del servidor SMTP
	Par_PuertoServerSMTP	VARCHAR(6),				-- Puerto del servidor SMTP
	Par_TipoSeguridad		CHAR(2),				-- Tipo de seguridad(N-Ninguna,S-SSL,T-STARTTLS )
	Par_CorreoSalida		VARCHAR(80),			-- Dirreccion correo donde saldran los correos
	Par_ConAutentificacion	CHAR(1),				-- (S-N) indica si el correo de salida requiere autentificacion
	Par_Contrasenia			VARCHAR(20),			-- Contraseña del correo de salida
	Par_Estatus				CHAR(1),				-- Estatus del remitente (A)Activo, (B)Baja
	Par_Comentario			VARCHAR(200),			-- Comentarios
	Par_AliasRemitente		VARCHAR(30),			-- Alias del correo remitente
	Par_TamanioMax			INT(11),				-- Tamanio maximo permitido de los archivos adjuntos
	Par_Tipo				CHAR(2),				-- Tipo de representacion para el campo tamanioMax MB-Megabytes y KB-Kilobytes

	Par_Salida				CHAR(1),				-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),				-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),				-- Parametro de auditoria
	Aud_Usuario				INT(11),				-- Parametro de auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal			INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria
	)
TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Var_Control			VARCHAR(50);		-- Var control
	DECLARE Entero_Cero       	INT(11);			-- Entero cero
	DECLARE	Cadena_Vacia	    CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia			DATETIME;			-- Fecha vacia
	DECLARE SalidaSi			CHAR(1);			-- Indica que si se devuelve un mensaje de salida
	DECLARE EstSI	 			CHAR(1);			-- Con Autentificacion

	-- Asignacion de Constantes
	SET Entero_Cero		 		:= 0;				-- Entero cero
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET SalidaSi				:= 'S';      		-- Si se devuelve una salida Si
	SET EstSI					:= 'S';				-- Con Autentificacion


	-- Valores por default
	SET Par_Descripcion 			:= IFNULL(Par_Descripcion,Cadena_Vacia);
	SET Par_ServidorSMTP 			:= IFNULL(Par_ServidorSMTP,Cadena_Vacia);
	SET Par_PuertoServerSMTP 		:= IFNULL(Par_PuertoServerSMTP,Cadena_Vacia);
	SET Par_TipoSeguridad 			:= IFNULL(Par_TipoSeguridad,Cadena_Vacia);
	SET Par_CorreoSalida 			:= IFNULL(Par_CorreoSalida,Cadena_Vacia);
	SET Par_ConAutentificacion		:= IFNULL(Par_ConAutentificacion,Cadena_Vacia);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TARENVIOCORREOPARAMMOD');
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

	UPDATE TARENVIOCORREOPARAM  SET
		RemitenteID			=Par_RemitenteID,
		Descripcion			=Par_Descripcion,
		ServidorSMTP		=Par_ServidorSMTP,
		PuertoServerSMTP	=Par_PuertoServerSMTP,
		TipoSeguridad		=Par_TipoSeguridad,
		CorreoSalida		=Par_CorreoSalida,
		ConAutentificacion	=Par_ConAutentificacion,
		Contrasenia			=Par_Contrasenia,
		Estatus				=Par_Estatus,
		Comentario			=Par_Comentario,
		AliasRemitente		=Par_AliasRemitente,
		TamanioMax			=Par_TamanioMax,
		Tipo				=Par_Tipo,
		EmpresaID			=Aud_EmpresaID,
		Usuario				=Aud_Usuario,
		FechaActual			=Aud_FechaActual,
		DireccionIP			=Aud_DireccionIP,
		ProgramaID			=Aud_ProgramaID,
		Sucursal			=Aud_Sucursal,
		NumTransaccion 		=Aud_NumTransaccion
		WHERE RemitenteID = Par_RemitenteID;

		SET Par_NumErr := 0;
		SET Par_ErrMen = CONCAT("Correo Modificado Exitosamente: ", Par_RemitenteID);
		SET Var_Control := 'RemitenteID' ;

END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
	SELECT Par_NumErr 		AS NumErr ,
	   Par_ErrMen 		AS ErrMen,
	   Var_Control 		AS control,
	   Par_RemitenteID  AS consecutivo;
	END IF;

END TerminaStore$$