-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ENVCORREOCIERREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ENVCORREOCIERREALT`;
DELIMITER $$

CREATE PROCEDURE `ENVCORREOCIERREALT`(
/* =============== STORE DE ALTA DE CORREOS CIERRE ===============*/
	Par_Mensaje				TEXT,			-- Cuerpo del Correo
	Par_Asunto				VARCHAR(150),	-- Asunto del Correo
	Par_Fecha				DATETIME,		-- Fecha

	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	Par_Salida				CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No

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
	DECLARE Var_Control				VARCHAR(50);	-- ID del control de Pantalla
	DECLARE Var_ServidorCorreo		VARCHAR(30);	-- Servidor del correo
	DECLARE Var_Puerto				VARCHAR(10);	-- Numero del Puerto del Servidor del Correo
	DECLARE Var_UsuarioCorreo		VARCHAR(50);	-- Usuario de la Cuenta de Correo
	DECLARE Var_Contrasenia			VARCHAR(20);	-- Password de la Cuenta de Correo
	DECLARE Var_CorreoRemitente		VARCHAR(50);	-- Correo del Remitente
	DECLARE Var_RemitenteID			INT(11);		-- Remitente id
	DECLARE Var_Destinatario		CHAR (50);		-- Correo destinatario

	-- Declaracion de Constantes
	DECLARE Estatus			CHAR(1);
	DECLARE Entero_Cero		INT;
	DECLARE Cadena_Vacia	CHAR;
	DECLARE Str_SI			CHAR(1);
	DECLARE Fecha_Vacia		DATETIME;
	DECLARE Con_mensaje		VARCHAR(150);
	DECLARE OrigenCierre	CHAR(1);					-- Origen PLD
	DECLARE Entero_Uno		INT;
    DECLARE I				INT;
    DECLARE N				INT;

/*
	-- Declarcion del cursor
	DECLARE CURSORDESTINATARIOS CURSOR FOR
		SELECT usr.Correo
		From USUARIOS usr
		where NotificaCierre = Str_SI;
*/

	-- Asignacion de Constantes
	SET Estatus 		:='N';				-- Estatus No Enviado
	SET Entero_Cero		:=0;				-- Entero Cero
	SET Cadena_Vacia	:='';				-- Cadena_ Vacia
	SET Str_SI			:='S';				-- String SI
	SET Fecha_Vacia		:='1900-01-01';	-- Fecha Vacia
	SET OrigenCierre	:='C';
	SET Entero_Uno		:=1;
	SET I 				:=1;



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ENVIOCORREOALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;
		-- Datos del remitente
		SELECT sis.RemitenteCierreID
		INTO Var_RemitenteID
		FROM PARAMETROSSIS sis
		LIMIT Entero_Uno;

		-- Parametros del remitente
		SELECT	rem.CorreoSalida,		rem.Usuario,		rem.Contrasenia,	rem.ServidorSMTP,		rem.PuertoServerSMTP
		INTO 	Var_CorreoRemitente,	Var_UsuarioCorreo,	Var_Contrasenia,	Var_ServidorCorreo,		Var_Puerto
		FROM TARENVIOCORREOPARAM rem
		WHERE RemitenteID = Var_RemitenteID;

		SET @numero=0;
		DROP TABLE IF EXISTS CORREOS;
		CREATE TEMPORARY TABLE CORREOS
		SELECT @numero:= @numero+1 AS REGISTRO , usr.Correo AS DESTINATARIO
				From USUARIOS usr
				where NotificaCierre = Str_SI;

		select COUNT(REGISTRO) INTO N from CORREOS;
		WHILE I <= N DO

			SELECT DESTINATARIO INTO Var_Destinatario FROM CORREOS WHERE REGISTRO = I;

			IF (Var_Destinatario != Cadena_Vacia) THEN

				CALL ENVIOCORREOALT(Var_CorreoRemitente,	Var_Destinatario,	Par_Mensaje,		Par_Asunto,			Par_Fecha,
									Var_ServidorCorreo,		Var_Puerto,			Var_UsuarioCorreo,	Var_Contrasenia,	Estatus,
									Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion
						);
			END IF;
			SET I = I + 1;
		END WHILE;
	END ManejoErrores;

	IF(Par_Salida = Str_SI)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'correoID' AS control,
				Var_CorreoID AS consecutivo;
	END IF;

END TerminaStore$$