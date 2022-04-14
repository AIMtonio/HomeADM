-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTAPERSBLOQMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDLISTAPERSBLOQMOD`;
DELIMITER $$

CREATE PROCEDURE `PLDLISTAPERSBLOQMOD`(
/* SP DE MODIFICACION DE UNA PERSONA EN LISTA DE BLOQUEADOS PLD*/
	Par_PersonaBloqID		BIGINT(12),
	Par_PrimerNom			VARCHAR(50),
	Par_SegundoNom			VARCHAR(50),
	Par_TercerNom			VARCHAR(50),
	Par_ApPat				VARCHAR(50),

	Par_ApMat				VARCHAR(50),
	Par_RFC 				CHAR(13),
	Par_FechaNac			DATE,
	Par_NombresCon			VARCHAR(500),
	Par_PaisID 				INT(11),

	Par_EstadoID 			INT(11),
	Par_TipoPersona			CHAR(1),
	Par_RazonSocial			VARCHAR(150),
	Par_RFCm				VARCHAR(13),
	Par_TipoLista			VARCHAR(45),		# Tipo de lista, este viene del catalogo que se sube

	Par_FechaAlta			DATE,				# Fecha de Alta
	Par_FechaReactivacion	DATE,				# Fecha de Reactivación (Se debe actualizar siempre que se reactive a la persona)
	Par_FechaInactivacion	DATE,				# Fecha de Inactivación (Se debe actualizar siempre que se inactive a la persona)
	Par_Estatus				CHAR(1),			# Estatus A: Activo I:Inactivo
	Par_NumeroOficio		VARCHAR(50),		# Numero de oficio

	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID 			INT(11),
	Aud_Usuario         	INT(11),

	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE Salida_SI 			CHAR(1);
	DECLARE EstatusActivo		CHAR(1);
	DECLARE EstatusInactivo		CHAR(1);
	DECLARE CListaPersBloq		CHAR(1);
	DECLARE Cons_No				CHAR(1);
	DECLARE OrigenPantalla		CHAR(1);
	DECLARE Mayusculas			CHAR(2);
	DECLARE PersMoral			CHAR(1);

	-- Declaracion de variables
	DECLARE	Var_PersonaBloqID	BIGINT(12);
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_NombreCompleto	VARCHAR(300);
	DECLARE Var_SoloNombres		VARCHAR(500);		-- Nombres de la persona
	DECLARE Var_SoloApellidos	VARCHAR(500);		-- Apellidos de la persona
	DECLARE Var_RazonSocial		VARCHAR(150);		-- razon social limpio de caracteres especiales.
	DECLARE Var_RFC				VARCHAR(15);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET Salida_SI 	   			:= 'S';				-- Salida Si
	SET EstatusActivo			:= 'A';				-- Estatus Activo
	SET EstatusInactivo			:= 'I';				-- Estatus Inactivo
	SET CListaPersBloq			:= 'B';				-- Lista Pers Bloqueadas
	SET Cons_No					:= 'N';				-- Constante No
	SET OrigenPantalla			:= 'P';				-- Deteccion originada desde pantalla
	SET Mayusculas				:= 'MA';			-- Tipo de resultado en mayusculas
	SET PersMoral				:= 'M';				-- Tipo de persona moral

	-- Asignacion de Variables
	SET Var_Control 			:= 'personaBloqID';
	SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDLISTAPERSBLOQMOD');
		SET Var_Control:= 'sqlException';
	END;

	SET Var_PersonaBloqID := (SELECT PersonaBloqID FROM PLDLISTAPERSBLOQ WHERE PersonaBloqID = Par_PersonaBloqID) ;
	IF(IFNULL(Var_PersonaBloqID,Entero_Cero) = Entero_Cero ) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'La Persona Bloqueada no Existe.';
		SET Var_Control := 'PersonaBloqID';
		LEAVE ManejoErrores;
	END IF;

		SET Par_PrimerNom				:= TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
		SET Par_SegundoNom				:= TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
		SET Par_TercerNom				:= TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
		SET Par_ApPat					:= TRIM(IFNULL(Par_ApPat, Cadena_Vacia));
		SET Par_ApMat					:= TRIM(IFNULL(Par_ApMat, Cadena_Vacia));
		SET Par_RFC						:= TRIM(IFNULL(Par_RFC, Cadena_Vacia));
		SET Par_NombresCon				:= TRIM(IFNULL(Par_NombresCon, Cadena_Vacia));
		SET Par_PaisID					:= IFNULL(Par_PaisID, Entero_Cero);
		SET Par_TipoLista				:= TRIM(IFNULL(Par_TipoLista, Cadena_Vacia));
		SET Par_Estatus					:= IFNULL(Par_Estatus, Cadena_Vacia);
		SET Par_NumeroOficio			:= IFNULL(Par_NumeroOficio, Cadena_Vacia);
		SET Par_RazonSocial				:= IFNULL(Par_RazonSocial, Cadena_Vacia);
		SET Par_RFCm					:= IFNULL(Par_RFCm, Cadena_Vacia);

		SET Var_NombreCompleto			:= FNGENNOMBRECOMPCARGALIS(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApPat,Par_ApMat);
		SET Var_SoloNombres				:= FNGENNOMBRECOMPCARGALIS(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Cadena_Vacia,Cadena_Vacia);
		SET Var_SoloApellidos			:= FNGENNOMBRECOMPCARGALIS(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApPat,Par_ApMat);

		IF(Par_Estatus =  EstatusActivo) THEN
			SET Par_FechaReactivacion := NOW();
		END IF;

		IF(Par_Estatus =  EstatusInactivo) THEN
			SET Par_FechaInactivacion := NOW();
		END IF;

		IF(Par_TipoPersona=PersMoral)THEN
			SET Var_RazonSocial		:= FNLIMPIACARACTERESGEN(Par_RazonSocial,Mayusculas);
		ELSE
			SET Var_RazonSocial		:= Cadena_Vacia;
		END IF;

	# Persona Fisica
	IF(Par_TipoPersona != PersMoral)THEN
		SET Var_RFC := (SELECT P.RFC FROM PLDLISTAPERSBLOQ P WHERE P.PersonaBloqID = Par_PersonaBloqID);
		IF EXISTS(SELECT * FROM PLDLISTAPERSBLOQ P
			WHERE P.RFC = Par_RFC AND P.TipoPersona != PersMoral
				AND P.NumeroOficio = Par_NumeroOficio
				AND P.PersonaBloqID != Var_PersonaBloqID)THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := CONCAT('Existe una persona registrada con el mismo RFC Y Numero de Oficio.');
			SET Var_Control := 'RFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	# Persona Moral
	IF(Par_TipoPersona = PersMoral)THEN
		SET Var_RFC := (SELECT P.RFCm FROM PLDLISTAPERSBLOQ P WHERE P.PersonaBloqID = Par_PersonaBloqID);
		IF EXISTS(SELECT * FROM PLDLISTAPERSBLOQ P
			WHERE P.RFCm = Par_RFCm AND P.TipoPersona = PersMoral
				AND P.NumeroOficio = Par_NumeroOficio
				AND P.PersonaBloqID != Var_PersonaBloqID)THEN
			SET Par_NumErr := 003;
			SET Par_ErrMen := CONCAT('Existe una persona registrada con el mismo RFC Y Numero de Oficio.');
			SET Var_Control := 'RFCm';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF EXISTS(SELECT PrimerNombre FROM PLDLISTAPERSBLOQ
				WHERE SoloNombres		= Var_SoloNombres
				AND SoloApellidos		= Var_SoloApellidos
				AND RFC					= Par_RFC
				AND NombresConocidos	= Par_NombresCon
				AND PaisID				= Par_PaisID
				AND EstadoID			= Par_EstadoID
				AND FechaNacimiento		= Par_FechaNac
				AND TipoPersona 		= Par_TipoPersona
				AND RazonSocialPLD 		= Var_RazonSocial
				AND RFCm				= Par_RFCm
				AND NumeroOficio 		= Par_NumeroOficio
				AND PersonaBloqID != Par_PersonaBloqID) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'La Persona Ya se Encuentra Registrada.';
			SET Var_Control := 'graba';
			LEAVE ManejoErrores;
	END IF;

	UPDATE PLDLISTAPERSBLOQ SET
		PrimerNombre		= Par_PrimerNom,
		SegundoNombre		= Par_SegundoNom,
		TercerNombre		= Par_TercerNom,
		ApellidoPaterno		= Par_ApPat,
		ApellidoMaterno		= Par_ApMat,

		NombreCompleto		= Var_NombreCompleto,
		RFC					= Par_RFC,
		FechaNacimiento		= Par_FechaNac,
		NombresConocidos	= Par_NombresCon,
		PaisID				= Par_PaisID,

		EstadoID			= Par_EstadoID,
		TipoPersona			= Par_TipoPersona,
		RazonSocial			= Par_RazonSocial,
		RFCm				= Par_RFCm,
		TipoLista			= Par_TipoLista,

		FechaReactivacion	= Par_FechaReactivacion,
		FechaInactivacion	= Par_FechaInactivacion,
		Estatus				= Par_Estatus,
		SoloNombres 		= Var_SoloNombres,
		SoloApellidos 		= Var_SoloApellidos,

		NumeroOficio 		= Par_NumeroOficio,
		RazonSocialPLD 		= Var_RazonSocial,
		EmpresaID 			= Par_EmpresaID,
		Usuario 			= Aud_Usuario,
		FechaActual			= Aud_FechaActual,
		DireccionIP 		= Aud_DireccionIP,

		ProgramaID			= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion		= Aud_NumTransaccion

		WHERE PersonaBloqID = Par_PersonaBloqID;

	CALL PLDDETECPERSPRO(
		CListaPersBloq,		Cons_No,			Var_SoloNombres,	Var_SoloApellidos,		Par_NombresCon,
		Par_RFC,			Par_RFCm,			Par_TipoPersona,	Par_RazonSocial,		Par_FechaNac,
		Par_PaisID,			Par_PersonaBloqID,	Cadena_Vacia,		Par_NumeroOficio,		Par_EstadoID,
		OrigenPantalla,		Par_TipoLista,		Par_FechaAlta,		Cons_No,				Par_NumErr,
		Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

	SET	Par_ErrMen := IFNULL(Par_ErrMen,Cadena_Vacia);
	SET	Par_NumErr := 0;
	SET	Par_ErrMen := CONCAT('Persona Modificada Exitosamente: ', CONVERT(Par_PersonaBloqID, CHAR), Par_ErrMen);

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			(SELECT LPAD(Var_PersonaBloqID, 8, 0)) AS Consecutivo;
END IF;

END TerminaStore$$