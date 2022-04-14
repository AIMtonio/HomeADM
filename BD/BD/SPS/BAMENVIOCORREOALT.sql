-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMENVIOCORREOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMENVIOCORREOALT`;DELIMITER $$

CREATE PROCEDURE `BAMENVIOCORREOALT`(
	-- STORE DE ALTA DE CORREOS BANCA MOVIL
		Par_Destinatario		VARCHAR(50),	-- Cuenta de Correo del Destinatario
		Par_Mensaje				TEXT,			-- Cuerpo del Correo
		Par_Tipo				CHAR(1),		-- Tipo de Mensaje
		Par_Salida				CHAR(1),		-- Indica el tipo de Salida S.- Si N.- No

		INOUT Par_NumErr		INT(11),		-- Numero de Error
		INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

		Par_EmpresaID			INT(11),		-- Auditoria
		Aud_Usuario				INT(11),		-- Auditoria
		Aud_FechaActual			DATETIME,		-- Auditoria

		Aud_DireccionIP			VARCHAR(15),	-- Auditoria
		Aud_ProgramaID			VARCHAR(50),	-- Auditoria
		Aud_Sucursal			INT(11),		-- Auditoria
		Aud_NumTransaccion		BIGINT(20)		-- Auditoria
		)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_CorreoID			INT;			-- ID del correo
	DECLARE Par_Folio				INT;			-- Folio del correo
	DECLARE	Var_Asunto				VARCHAR(150);	-- Asunto del Correo
	DECLARE	Var_Fecha				DATETIME;		-- Fecha de Registro

	DECLARE	Var_ServidorCorreo		VARCHAR(30);	-- Servidor del correo
	DECLARE	Var_Puerto				VARCHAR(10);	-- Numero del Puerto del Servidor del Correo
	DECLARE	Var_UsuarioCorreo		VARCHAR(50);	-- Usuario de la Cuenta de Correo
	DECLARE	Var_Contrasenia			VARCHAR(20);	-- Password de la Cuenta de Correo
	DECLARE	Var_Remitente			VARCHAR(50);
	DECLARE Var_Control	    		VARCHAR(100);


	-- Declaracion de Constantes
	DECLARE Con_Estatus				CHAR(1);
	DECLARE Entero_Cero				INT;
	DECLARE Cadena_Vacia			CHAR;
	DECLARE Str_SI					CHAR(1);
	DECLARE Fecha_Vacia				DATETIME;
	DECLARE Con_mensaje				VARCHAR(150);
	DECLARE Tipo_IniSession			CHAR(1);
	DECLARE Tipo_Transferencia		CHAR(1);
	DECLARE	Tipo_PagoServicio		CHAR(1);
	DECLARE	Tipo_AltaServicio		CHAR(1);
	DECLARE	Origen_BancaMovil		CHAR(1);
	DECLARE	Tipo_CambioSeguridad	CHAR(1);
	DECLARE Tipo_AccesoBancaMovil   CHAR(1);

	-- Asignacion de Constantes
	SET Con_Estatus 			:= 'N';					-- Estatus No Enviado
	SET Entero_Cero				:= 0;					-- Entero Cero
	SET Cadena_Vacia			:= '';					-- Cadena_ Vacia
	SET Str_SI					:= 'S';					-- String SI
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET Tipo_IniSession			:= 'I';				-- Tipo de Mensaje: Inicio de Session
	SET Tipo_Transferencia		:= 'T';				-- Tranferencia entre cuentas
	SET	Tipo_PagoServicio		:= 'S';				-- Pago de Servicios
	SET	Tipo_AltaServicio		:= 'A';				-- Alta del Servicio de Banca Movil
	SET	Tipo_CambioSeguridad 	:= 'C';				-- Cambio opciones de seguridad
    SET Tipo_AccesoBancaMovil   := 'P';				-- Envia el password para iniciar BM
	SET	Origen_BancaMovil		:= 'B';				-- Origen dle Correo Banca Movil


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-BAMENVIOCORREOALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_Fecha := NOW();

		IF(Par_Tipo = Tipo_IniSession) THEN

				SELECT SubjectSessionBancaMovil INTO Var_Asunto FROM BAMPARAMETROS;

		ELSEIF(Par_Tipo = Tipo_Transferencia) THEN

				SELECT SubjectTransferBancaMovil INTO Var_Asunto FROM BAMPARAMETROS;

		ELSEIF(Par_Tipo = Tipo_PagoServicio) THEN

				SELECT SubjectPagosBancaMovil INTO Var_Asunto FROM BAMPARAMETROS;

		ELSEIF(Par_Tipo = Tipo_AltaServicio) THEN

				SELECT SubjectAltaBancaMovil INTO Var_Asunto FROM BAMPARAMETROS;

		ELSEIF(Par_Tipo = Tipo_CambioSeguridad) THEN

				SELECT SubjectCambiosBancaMovil INTO Var_Asunto FROM BAMPARAMETROS;

        ELSEIF(Par_Tipo = Tipo_AccesoBancaMovil) THEN

				SELECT SubjectAccesoBancaMovil INTO Var_Asunto FROM BAMPARAMETROS;

		END IF;


		SELECT ServidorCorreoBancaMovil  INTO Var_ServidorCorreo
			FROM BAMPARAMETROS;

		SELECT PuertoCorreoBancaMovil  INTO Var_Puerto
			FROM BAMPARAMETROS;

		SELECT UsuarioCorreoBancaMovil INTO Var_UsuarioCorreo
			FROM BAMPARAMETROS;

		SELECT PasswordCorreoBancaMovil  INTO Var_Contrasenia
			FROM BAMPARAMETROS;

		SELECT RemitenteCorreo  INTO Var_Remitente
			FROM BAMPARAMETROS;

		IF(Var_Remitente = Cadena_Vacia)THEN
			SET	Par_NumErr := '001';
			SET	Par_ErrMen := CONCAT(" El Remitente esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Destinatario = Cadena_Vacia)THEN
			SET	Par_NumErr := '002';
			SET	Par_ErrMen := CONCAT(" El Destinatario esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Var_ServidorCorreo = Cadena_Vacia)THEN
			SET	Par_NumErr := '003';
			SET	Par_ErrMen := CONCAT("El Servidor de Correo esta Vacio");
			LEAVE ManejoErrores;
		END IF;


		IF(Var_Puerto = Cadena_Vacia)THEN
			SET	Par_NumErr := '004';
			SET	Par_ErrMen := CONCAT("El Puerto Esta Vacio");
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Contrasenia = Cadena_Vacia)THEN
			SET	Par_NumErr := '005';
			SET	Par_ErrMen := CONCAT("La Contrasenia esta Vacia");
			LEAVE ManejoErrores;
		END IF;

		CALL FOLIOSAPLICAACT('ENVIOCORREO',Var_CorreoID);

		INSERT INTO ENVIOCORREO(
			CorreoID, 		Origen,		Remitente,		DestinatarioPLD,	Mensaje,
            Fecha, 			Estatus,	ServidorCorreo,	Puerto, 			UsuarioCorreo,
			Contrasenia,	Asunto, 	EmpresaID,		Usuario,			FechaActual,
			DireccionIP,	ProgramaID,	Sucursal,		NumTransaccion)
		VALUES (
			Var_CorreoID,		Origen_BancaMovil,	Var_Remitente,			Par_Destinatario,	Par_Mensaje,
			Var_Fecha,			Con_Estatus,		Var_ServidorCorreo,		Var_Puerto,			Var_UsuarioCorreo,
			Var_Contrasenia,	Var_Asunto,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := CONCAT("Correo Registrado Correctamente: ", CONVERT(Var_CorreoID,CHAR));

	END ManejoErrores;  -- END del Handler de Errores

	IF Par_Salida = Str_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'correoID' AS control,
				Var_CorreoID AS consecutivo;
	END IF;

	END TerminaStore$$