-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDETECCIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDETECCIONPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDDETECCIONPRO`(
/*SP PARA LA DETECCION DE PERSONAS BLOQUEADAS,LISTAS NEGRA, PAISES DE LA GAFI*/
	Par_ClavePersonaInv		INT(11),		# Numero de Cliente, Usuario de Servicios , Aval, Prospecto, o Relacionado a la cuenta, cero si es en el alta
	Par_PrimerNombre		VARCHAR(50),	# Primer Nombre
	Par_SegundoNombre		VARCHAR(50),	# Segundo Nombre
	Par_TercerNombre		VARCHAR(50),	# Tercer Nombre
	Par_ApellidoPaterno		VARCHAR(50),	# Apellido Paterno

	Par_ApellidoMaterno		VARCHAR(50),	# Apellido Materno
	Par_TipoPersona			CHAR(1),		# F. Fisica A. Fisica con Act Empresarial M. Moral
	Par_RazonSocial			VARCHAR(150),	# Razon social
	Par_RFC					CHAR(13),		# RFC de la persona fisica
	Par_RFCpm				CHAR(13),		# RFC de la persona moral

	Par_FechaNacimiento		DATE,			# Fecha de nacimiento
	Par_CuentaAhoID			BIGINT(12),		# Numero de la Cuenta de Ahorro
	Par_PaisID				INT(11),		# ID del Pais
	Par_EstadoID			INT(11),		# ID del Estado (si aplica)
	Par_NombresConocidos	VARCHAR(500),	# Nombres conocidos

	Par_TipoPersSAFI		VARCHAR(3),		# CTE. Cliente USU. Usuario de Servicios AVA Aval PRO Prosepecto REL Relacionado a la cuenta, NA. No Aplica
	Par_DetectaLisNeg		CHAR(1),		# Detecta por listas negras S:Si N:No
	Par_DetectaLisBloq		CHAR(1),		# Detecta por listas personas bloqueadas S:Si N:No
	Par_DetectaGAFI			CHAR(1),		# Detecta por lista de paises de la GAFI S:Si N:No
	Par_Salida				CHAR(1),		# Tipo de Salida S. Si N. No

	INOUT	Par_NumErr 		INT(11),		# Numero de Error
	INOUT	Par_ErrMen  	VARCHAR(400),	# Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
		)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;
	DECLARE Fecha_Vacia			DATE;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Per_Fisica			CHAR(1);
	DECLARE	Per_ActEmp			CHAR(1);
	DECLARE	Per_Moral			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Salida_NO			CHAR(1);
	DECLARE PaisMexico			INT(11);
	DECLARE TipoOperaAlt		INT;
	DECLARE ReportarSi			CHAR(1);
	DECLARE ReportarNo			CHAR(1);
	DECLARE EsNA				VARCHAR(3);
	DECLARE Cons_Si				CHAR(1);

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_RFCOficial		CHAR(13);
	DECLARE Var_Coincidencias	INT(11);		# Numero de coincidencias en lista pers bloq
    DECLARE Var_DetecNoDeseada	CHAR(1);		# Valida el proceso de personas No Deseadas S:Si N:No
    DECLARE Var_PersonaBloqID	BIGINT(12);		-- Persona bloqueada id

	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Cadena_Vacia			:= '';
	SET	Per_Fisica				:= 'F';
	SET	Per_ActEmp				:= 'A';
	SET	Per_Moral				:= 'M';
	SET SalidaSI				:= 'S';
	SET Salida_NO				:= 'N';
	SET PaisMexico				:= 700;				-- Pais Mexico
	SET TipoOperaAlt			:= 10;				-- Tipo de operacion de alta para verificar en la lista negra
	SET ReportarSi				:= 'S';				-- Reporta operacion inusual PLD
	SET ReportarNo				:= 'N';				-- Reporta operacion inusual PLD
	SET EsNA					:= 'NA';			-- No se trata ni de un cliente ni de un usuario de servicios, ni prospecto, aval, o relacionado
	SET Cons_Si					:= 'S';				-- constante SI
	SET Var_PersonaBloqID		:= Entero_Cero;		-- Persona bloqueada id

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PLDDETECCIONPRO');
			SET Var_Control 	:= 'sqlException' ;
		END;

		IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
			SET Var_RFCOficial := Par_RFC;
		  ELSE
			SET Var_RFCOficial := Par_RFCpm;
		END IF;

		IF(Par_DetectaGAFI = Cons_Si) THEN
			CALL PLDDETECGAFIPRO(
				Par_ClavePersonaInv,		Par_PaisID,					Par_PrimerNombre,			Par_SegundoNombre,			Par_TercerNombre,
				Par_ApellidoPaterno,		Par_ApellidoMaterno,		Par_TipoPersona,			Par_RazonSocial,			Par_TipoPersSAFI,
				Salida_NO,					Par_NumErr,					Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 50;
				SET Par_ErrMen			:= Par_ErrMen;
				SET Var_Control			:= 'agrega';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- PROCESO DE DETECCION EN LISTAS DE PERSONAS BLOQUEADAS
		IF (Par_PaisID<>PaisMexico)THEN
			SET Par_EstadoID := Entero_Cero;
		ELSE
			SET Par_EstadoID := Par_EstadoID;
		END IF;

		IF(Par_DetectaLisBloq = Cons_Si) THEN
			CALL PLDDETECPERSBLOQPRO(
				Par_ClavePersonaInv,			Par_PrimerNombre,		Par_SegundoNombre,		Par_TercerNombre,			Par_ApellidoPaterno,
				Par_ApellidoMaterno,			Var_RFCOficial,			Par_FechaNacimiento,	Par_NombresConocidos,		Par_CuentaAhoID,
				Par_PaisID,						Par_EstadoID,			Par_TipoPersSAFI,		Par_TipoPersona,			Salida_NO,
				Par_NumErr,						Par_ErrMen,				Var_Coincidencias,		Var_PersonaBloqID,			Par_EmpresaID,
				Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;
				SET Var_Control			:= 'primerNombre';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_DetectaLisNeg = Cons_Si) THEN
			CALL PLDDETECLISNEGPRO(
				Par_ClavePersonaInv,				Par_PrimerNombre,			Par_SegundoNombre,			Par_TercerNombre,		Par_ApellidoPaterno,
				Par_ApellidoMaterno,				Var_RFCOficial,				Par_FechaNacimiento,		Par_NombresConocidos,	Par_CuentaAhoID,
                Par_PaisID,							Par_EstadoID,				TipoOperaAlt,				ReportarSi,				Par_TipoPersSAFI,
                Par_TipoPersona,					Salida_NO,					Par_NumErr,					Par_ErrMen,				Var_PersonaBloqID,
                Par_EmpresaID,						Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
                Aud_Sucursal,						Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero) THEN
				SET Par_NumErr			:= 0;
				SET Var_Control			:= 'agrega';
				LEAVE ManejoErrores;
			END IF;
		END IF;
        -- INICIO PROCESO DE PERSONAS NO DESEADAS
        SET Var_DetecNoDeseada := IFNULL((SELECT  PersonNoDeseadas FROM PARAMETROSSIS LIMIT 1),'N');
        IF(Var_DetecNoDeseada = Cons_Si) THEN
            CALL PLDDETECPERSNODESEADASPRO(
				Par_ClavePersonaInv,	Var_RFCOficial,	Par_TipoPersona,	Salida_NO,	Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,	Aud_FechaActual,
                Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;
				LEAVE ManejoErrores;
			END IF;
		END IF;
        -- FIN PROCESO DE PERSONAS NO DESEADAS

		SET Par_NumErr			:= Entero_Cero;
		SET Par_ErrMen			:= CONCAT('Puede Continuar con el Proceso.');
		SET Var_Control			:= 'agrega';
		SET Var_Consecutivo		:= Entero_Cero;
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			CONCAT(Par_ErrMen,' ',Par_Salida) AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo,
			Var_PersonaBloqID AS PersonaBloqID;
	END IF;

END TerminaStore$$
