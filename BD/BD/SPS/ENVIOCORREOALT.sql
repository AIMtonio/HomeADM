-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENVIOCORREOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ENVIOCORREOALT`;DELIMITER $$

CREATE PROCEDURE `ENVIOCORREOALT`(
/*PMONTERO: Modificando para PLD 2017/07/06*/
/* =============== STORE DE ALTA DE CORREOS ===============*/
	Par_Remitente			VARCHAR(50),	-- Cuenta de Correo del Remitente
	Par_DestinatarioPLD		VARCHAR(50),	-- Cuenta de Correo del Destinatario
	Par_Mensaje				TEXT,			-- Cuerpo del Correo
	Par_Asunto				VARCHAR(150),	-- Asunto del Correo
	Par_Fecha				DATETIME,		-- Fecha de Registro

	Par_ServidorCorreo		VARCHAR(30),	-- Servidor del correo
	Par_Puerto				VARCHAR(10),	-- Numero del Puerto del Servidor del Correo
	Par_UsuarioCorreo		VARCHAR(50),	-- Usuario de la Cuenta de Correo
	Par_Contrasenia			VARCHAR(20),	-- Password de la Cuenta de Correo
	Par_Salida				CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No

	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_CorreoID			INT;
	DECLARE Var_Control				VARCHAR(50);				-- ID del control de Pantalla

	-- Declaracion de Constantes
	DECLARE con_Estatus				CHAR(1);
	DECLARE Entero_Cero				INT;
	DECLARE Cadena_Vacia			CHAR;
	DECLARE Str_SI					CHAR(1);
	DECLARE Fecha_Vacia				DATETIME;
	DECLARE Con_mensaje				VARCHAR(150);
	DECLARE OrigenPLD				CHAR(1);					-- Origen PLD

	-- Asignacion de Constantes
	SET con_Estatus 	:='N';				-- Estatus No Enviado
	SET Entero_Cero		:=0;				-- Entero Cero
	SET Cadena_Vacia	:='';				-- Cadena_ Vacia
	SET Str_SI			:='S';				-- String SI
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET OrigenPLD		:= 'P';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ENVIOCORREOALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF(Par_Remitente=Cadena_Vacia)THEN
			SET	Par_NumErr := 001;
			SET	Par_ErrMen := CONCAT(" El Remitente esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_DestinatarioPLD=Cadena_Vacia)THEN
			SET	Par_NumErr := 002;
			SET	Par_ErrMen := CONCAT(" El Destinatario esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ServidorCorreo=Cadena_Vacia)THEN
			SET	Par_NumErr := 003;
			SET	Par_ErrMen := CONCAT("El Servidor de Correo esta Vacio");
			LEAVE ManejoErrores;
		END IF;


		IF(Par_Puerto=Cadena_Vacia)THEN
			SET	Par_NumErr := 004;
			SET	Par_ErrMen := CONCAT("El Puerto Esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Contrasenia=Cadena_Vacia)THEN
			SET	Par_NumErr := 005;
			SET	Par_ErrMen := CONCAT("La Contrasenia esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('ENVIOCORREO',Var_CorreoID);

		INSERT INTO ENVIOCORREO(
			CorreoID, 		Remitente,				DestinatarioPLD,		Mensaje, 			Fecha,
			Estatus,		ServidorCorreo,			Puerto, 				UsuarioCorreo,		Contrasenia,
			Origen,			Asunto, 				EmpresaID,				Usuario, 			FechaActual,
			DireccionIP,	ProgramaID, 			Sucursal, 				NumTransaccion)
		VALUES (
			Var_CorreoID,		Par_Remitente,		Par_DestinatarioPLD,	Par_Mensaje,		Par_Fecha,
			con_Estatus,		Par_ServidorCorreo,	Par_Puerto,				Par_UsuarioCorreo,	Par_Contrasenia,
			OrigenPLD,			Par_Asunto, 		Par_EmpresaID,			Aud_Usuario, 		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := CONCAT("Correo Registrado Correctamente: ", CONVERT(Var_CorreoID,CHAR));

	END ManejoErrores;  -- End del Handler de Errores.

	IF(Par_Salida = Str_SI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'correoID' AS control,
				Var_CorreoID AS consecutivo;
	END IF;

END TerminaStore$$