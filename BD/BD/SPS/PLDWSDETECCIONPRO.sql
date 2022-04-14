-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDWSDETECCIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDWSDETECCIONPRO`;
DELIMITER $$


CREATE PROCEDURE `PLDWSDETECCIONPRO`(
/*SP PARA LA DETECCION DE PERSONAS BLOQUEADAS,LISTAS NEGRA*/
	Par_ClavePersonaInv		INT(11),		-- Numero de Cliente, Usuario de Servicios , Aval, Prospecto, o Relacionado a la cuenta, cero si es en el alta
	Par_PrimerNombre		VARCHAR(50),	-- Primer Nombre
	Par_SegundoNombre		VARCHAR(50),	-- Segundo Nombre
	Par_TercerNombre		VARCHAR(50),	-- Tercer Nombre
	Par_ApellidoPaterno		VARCHAR(50),	-- Apellido Paterno

	Par_ApellidoMaterno		VARCHAR(50),	-- Apellido Materno
	Par_TipoPersona			CHAR(1),		-- F. Fisica A. Fisica con Act Empresarial M. Moral
	Par_RazonSocial			VARCHAR(150),	-- Razon social
	Par_RFC					CHAR(13),		-- RFC de la persona fisica
	Par_RFCpm				CHAR(13),		-- RFC de la persona moral

	Par_FechaNacimiento		DATE,			-- Fecha de nacimiento
	Par_CuentaAhoID			BIGINT(12),		-- Numero de la Cuenta de Ahorro
	Par_PaisID				INT(11),		-- ID del Pais
	Par_EstadoID			INT(11),		-- ID del Estado (si aplica)
	Par_NombresConocidos	VARCHAR(500),	-- Nombres conocidos

	Par_TipoPersSAFI		VARCHAR(3),		-- CTE. Cliente USU. Usuario de Servicios AVA Aval PRO Prosepecto REL Relacionado a la cuenta, NA. No Aplica
	Par_DetectaLisNeg		CHAR(1),		-- Detecta por listas negras S:Si N:No
	Par_DetectaLisBloq		CHAR(1),		-- Detecta por listas personas bloqueadas S:Si N:No
	Par_Salida				CHAR(1),		-- Tipo de Salida S. Si N. No

	INOUT	Par_NumErr 		INT(11),		-- Numero de Error
	INOUT	Par_ErrMen  	VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),        -- Auditoria
	Aud_Usuario				INT(11),        -- Auditoria
	Aud_FechaActual			DATETIME,       -- Auditoria

	Aud_DireccionIP			VARCHAR(15),   	-- Auditoria
	Aud_ProgramaID			VARCHAR(50),   	-- Auditoria
	Aud_Sucursal			INT(11),       	-- Auditoria
	Aud_NumTransaccion		BIGINT(20)     	-- Auditoria
		)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT;			-- entero cero
	DECLARE Fecha_Vacia			DATE;			-- fecha vacia
	DECLARE	Cadena_Vacia		CHAR(1);		-- cadena vacia
	DECLARE	Per_Fisica			CHAR(1);		-- persona fisica
	DECLARE	Per_ActEmp			CHAR(1);		-- persona con actividad empresarial
	DECLARE	Per_Moral			CHAR(1);		-- persona moral
	DECLARE SalidaSI			CHAR(1);		-- salida si
	DECLARE Salida_NO			CHAR(1);		-- salida no
	DECLARE PaisMexico			INT(11);		-- id del pais de mexico
	DECLARE TipoOperaAlt		INT;			-- tipo opera alta
	DECLARE ReportarSi			CHAR(1);		-- reportado si
	DECLARE ReportarNo			CHAR(1);		-- reportado no
	DECLARE EsNA				VARCHAR(3);		-- es NA
	DECLARE Cons_Si				CHAR(1);		-- Constante si

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_Consecutivo		VARCHAR(50);	-- Consecutivo
	DECLARE Var_RFCOficial		CHAR(13);		-- Rfc oficial del cliente
	DECLARE Var_Coincidencias	INT(11);		-- Numero de coincidencias en lista pers bloq
	DECLARE Var_PersonaBloqID	BIGINT(12);		-- Persona bloqueada id
	DECLARE Var_IDQeq			VARCHAR(50);	-- ID del catalogo de Quien es Quien
	DECLARE Var_TipoLista		VARCHAR(50);	-- Tipo de lista en la que se encuentra la persona detectada en la lista (LN=listas negras o LB=listas de personas bloqueadas)
	DECLARE Var_ListaNegra		VARCHAR(2);		-- Lista negra LN
	DECLARE Var_ListaBloqueada	VARCHAR(2);		-- Lista persona bloqueada LB
	DECLARE Var_NombreTipoLista	VARCHAR(200);	-- Nombre tipo lista
	DECLARE Var_Estatus			CHAR(1);		-- Estatus del cliente en la  lista



	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;				-- entero cero
	SET	Fecha_Vacia				:= '1900-01-01';	-- fecha vacia
	SET	Cadena_Vacia			:= '';				-- cadena vacia
	SET	Per_Fisica				:= 'F';				-- persona fisica
	SET	Per_ActEmp				:= 'A';				-- persona fisica con actividad empresarial
	SET	Per_Moral				:= 'M';				-- persona moral
	SET SalidaSI				:= 'S';				-- salida si
	SET Salida_NO				:= 'N';				-- salida no
	SET PaisMexico				:= 700;				-- Pais Mexico
	SET TipoOperaAlt			:= 10;				-- Tipo de operacion de alta para verificar en la lista negra
	SET ReportarSi				:= 'S';				-- Reporta operacion inusual PLD
	SET ReportarNo				:= 'N';				-- Reporta operacion inusual PLD
	SET EsNA					:= 'NA';			-- No se trata ni de un cliente ni de un usuario de servicios, ni prospecto, aval, o relacionado
	SET Cons_Si					:= 'S';				-- constante SI
	-- Asignacion de variables
	SET Var_PersonaBloqID		:= Entero_Cero;		-- Persona bloqueada id
	SET Var_ListaNegra			:= 'LN';			-- Lista negra LN
	SET Var_ListaBloqueada		:= 'LB';			-- Lista persona bloqueada LB
	SET	Var_TipoLista			:= Cadena_Vacia;	-- Tipo de lista

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PLDWSDETECCIONPRO');
			SET Var_Control 	:= 'sqlException' ;
		END;

		IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
			SET Var_RFCOficial := Par_RFC;
		  ELSE
			SET Var_RFCOficial := Par_RFCpm;
		END IF;

		-- PROCESO DE DETECCION EN LISTAS DE PERSONAS BLOQUEADAS
		IF (Par_PaisID	<>	PaisMexico)THEN
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

			IF(Par_NumErr != Entero_Cero AND Var_PersonaBloqID = Entero_Cero )THEN

				SET Par_NumErr			:= 001;
				SET Par_ErrMen			:= Par_ErrMen;
				SET Var_Control			:= 'primerNombre';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_PersonaBloqID  > Entero_Cero) THEN
				SET Par_NumErr			:= Entero_Cero;
				SET Var_TipoLista		:= Var_ListaBloqueada;

				SELECT 	BLOQ.IDQEQ,		CAT.Descripcion,		BLOQ.Estatus
				INTO	Var_IDQeq,		Var_NombreTipoLista,	Var_Estatus
				FROM PLDLISTAPERSBLOQ BLOQ
				INNER JOIN CATTIPOLISTAPLD CAT ON CAT.TipoListaID = BLOQ.TipoLista
				WHERE BLOQ.PersonaBloqID = Var_PersonaBloqID;

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

			IF(Par_NumErr != Entero_Cero AND Var_PersonaBloqID = Entero_Cero) THEN

				SET Par_NumErr			:= 002;
				SET Var_Control			:= 'agrega';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_PersonaBloqID > Entero_Cero) THEN
				SET Par_NumErr			:= Entero_Cero;
				SET Var_TipoLista		:= Var_ListaNegra;

				SELECT 	LNEG.IDQEQ,		CAT.Descripcion,		LNEG.Estatus
				INTO	Var_IDQeq,		Var_NombreTipoLista,	Var_Estatus
				FROM PLDLISTANEGRAS LNEG
				INNER JOIN CATTIPOLISTAPLD CAT ON CAT.TipoListaID = LNEG.TipoLista
				WHERE LNEG.ListaNegraID = Var_PersonaBloqID;

				LEAVE ManejoErrores;

			END IF;

		END IF;

		SET Par_NumErr			:= Entero_Cero;
		SET Par_ErrMen			:= CONCAT('Puede Continuar con el Proceso.');
		SET Var_Control			:= 'agrega';
		SET Var_Consecutivo		:= Entero_Cero;
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
			SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo,
			Var_PersonaBloqID AS PersonaBloqID,
			Var_IDQeq	AS IDQEQ,
			Var_NombreTipoLista	AS NomLista,
			Var_Estatus	AS Estatus,
			Var_TipoLista AS Lista;

	END IF;

END TerminaStore$$