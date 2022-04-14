
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTAPERSBLOQCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDLISTAPERSBLOQCON`;

DELIMITER $$
CREATE PROCEDURE `PLDLISTAPERSBLOQCON`(
/* SP DE CONSULTA EN LISTAS DE PERSONAS BLOQUEADAS
 * SI SE MODIFICA EL PROCESO DE DETECCION, TAMBIEN MODIFICARLO EN PLDDETECPERSBLOQPRO */
	Par_PersonaBloqID	BIGINT(12),			-- ID de la persona a consultar: Cliente o Usuario de Serv. o PersonaBloqueada
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de consulta
	Par_TipoPersSAFI	VARCHAR(6),			-- Solo si se trata de Cliente o de Usuario de Servicio a detectar
	Par_TipoPersona		CHAR(1),			-- Tipo de Persona F: Física M: Moral
    Par_CuentaAhoID		BIGINT(12),			-- Solo si es deteccion en la lista de personas bloq.

    Par_CreditoID		BIGINT(12),			-- Solo si es deteccion en la lista de personas bloq.
	/* Parametros de Auditoria */
	Par_EmpresaID 		INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Entero_Cero			INT;
DECLARE	ConsultaPrincipal	INT;
DECLARE	ConsultaDetec		INT;
DECLARE	Consulta_DatosLev	INT;
DECLARE	Con_DatosLevMas		INT;
DECLARE EsCliente			VARCHAR(6);
DECLARE EsUsuarioServ		VARCHAR(6);
DECLARE EsUsuarioServ2		VARCHAR(6);
DECLARE EsProveedor			VARCHAR(6);
DECLARE SiEsBloq			CHAR(1);
DECLARE NoEsBloq			CHAR(1);
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Mexico				INT;
DECLARE CatProcIntID		VARCHAR(10);
DECLARE	CatMotivInusualID	VARCHAR(15);
DECLARE	DescripOpera		VARCHAR(52);
DECLARE	Decimal_Cero		DECIMAL;
DECLARE	ClaveRegistra		CHAR(2);
DECLARE	RegistraSAFI		CHAR(4);
DECLARE	Str_No				CHAR(1);
DECLARE	Str_Si				CHAR(1);
DECLARE Par_NumErr			INT;
DECLARE Par_ErrMen			VARCHAR(400);
DECLARE Mayusculas			CHAR(2);
DECLARE	PersFisica			CHAR(1);
DECLARE	PersActEmp			CHAR(1);
DECLARE	PersMoral 			CHAR(1);
DECLARE EsProspecto			CHAR(3);
DECLARE EsAval				CHAR(3);
DECLARE EsGarante 			CHAR(3);
DECLARE EsObligadoSol 		CHAR(3);
DECLARE	Est_Activo			CHAR(1);
DECLARE Busqueda_Activa		CHAR(1);

-- Declaracion de variables
DECLARE Var_ClienteID 			INT(11);
DECLARE Var_UsuarioServicioID 	INT(11);
DECLARE Var_ProveedorID		 	INT(11);
DECLARE Var_SoloNombres			varchar(150);
DECLARE	Par_PrimerNombre		VARCHAR(50);
DECLARE	Par_SegundoNombre		VARCHAR(50);
DECLARE	Par_TercerNombre		VARCHAR(50);
DECLARE	Par_ApellidoPaterno		VARCHAR(50);
DECLARE	Par_ApellidoMaterno		VARCHAR(50);
DECLARE	Par_NombreCompleto		VARCHAR(200);
DECLARE	Par_RFC					CHAR(13);
DECLARE	Par_FechaNacimiento		DATE;
DECLARE	Par_PaisID				INT(11);
DECLARE	Par_EstadoID			INT(11);
DECLARE Coincidencia 			INT;
DECLARE Var_FechaDeteccion		DATE;
DECLARE Par_ClavePersonaInv		INT;
DECLARE Var_OpeInusualID		BIGINT(20);
DECLARE Var_TipoPersSAFI		VARCHAR(3);
DECLARE Var_TipoPersona			CHAR(1);
DECLARE Var_RazonSocial			VARCHAR(150);
DECLARE	Var_RFCpm				VARCHAR(13);
DECLARE	Var_NombrePersInv		VARCHAR(200);
DECLARE	Var_RFCOficial			VARCHAR(15);
DECLARE Var_Coincidencias		INT(11);		# Numero de coincidencias en lista pers bloq
DECLARE Var_PersonaBloqID		BIGINT(12);		-- Persona bloqueada id
DECLARE Var_ProspectoID			BIGINT(20);
DECLARE Var_BusqActivaPLD		CHAR(1);	-- Indica si esta activa la busqueda desde java.
DECLARE Var_RealizaBusqPLD		CHAR(1);	-- Indica si realiza la busqueda en listas PLD.

-- Asignacion de Constantes
SET Cadena_Vacia 		:='';			-- Cadena Vacia
SET	Entero_Cero			:= 0;			-- Entero Cero
SET Decimal_Cero		:= 0.0;			-- Decimal Cero
SET	ConsultaPrincipal	:= 1;			-- Consulta Principal
SET	ConsultaDetec		:= 2;			-- Consulta que detecta a personas en lista de bloqueados
SET	Consulta_DatosLev	:= 3;			-- Consulta lista por tipo de persona y estatus.
SET	Con_DatosLevMas		:= 4;			-- Consulta lista por para búsqueda masiva.
SET EsCliente			:='CTE';		-- La persona es Cliente
SET EsUsuarioServ		:='USS';		-- La persona es Usuario
SET EsUsuarioServ2		:='USU';		-- La persona es Usuario
SET EsProveedor			:='PRV';		-- La persona es Proveedor
SET Coincidencia 		:= 0;			-- No. Coincidencia
SET SiEsBloq			:='S';			-- Si esta bloqueado
SET NoEsBloq			:='N';			-- No esta bloqueado
SET Mexico				:=700;			-- Codigo de paÃ­s de mexico

SET	CatProcIntID		:='PR-SIS-000';						-- Clave interna
SET	CatMotivInusualID	:='LISBLOQ';						-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
SET	DescripOpera		:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
SET	ClaveRegistra		:= '3';		-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET	RegistraSAFI		:= 'SAFI';
SET	Str_No				:= 'N';
SET	Str_Si				:= 'S';
SET	Par_NumErr			:= 0;
SET	Par_ErrMen			:= '';
SET Mayusculas			:= 'MA';		-- Obtener el resultado en Mayusculas
SET	PersFisica			:= 'F';			-- Tipo de persona fisica
SET	PersActEmp			:= 'A';			-- Tipo de persona fisica con actividad empresarial
SET	PersMoral			:= 'M';			-- Tipo de persona moral
SET EsProspecto			:= 'PRO';		-- Tipo Prospecto
SET EsAval				:= 'AVA';
SET EsGarante 			:= 'GRT';		-- Tipo Garante
SET EsObligadoSol 		:= 'OBS';
SET	Est_Activo			:= 'A';			-- Estatus Activo.

-- Consulta Principal pantalla de registro de personas bloqueadas
IF(Par_NumCon = ConsultaPrincipal) THEN
	SELECT
		LPAD(PersonaBloqID, 8, 0) AS PersonaBloqID,
		IF(LENGTH(TRIM(PrimerNombre))>1,TRIM(PrimerNombre),Cadena_Vacia) AS PrimerNombre,
		IF(LENGTH(TRIM(SegundoNombre))>1,TRIM(SegundoNombre),Cadena_Vacia) AS SegundoNombre,
		IF(LENGTH(TRIM(TercerNombre))>1,TRIM(TercerNombre),Cadena_Vacia) AS TercerNombre,
		IF(LENGTH(TRIM(ApellidoPaterno))>1,TRIM(ApellidoPaterno),Cadena_Vacia) AS ApellidoPaterno,

		IF(LENGTH(TRIM(ApellidoMaterno))>1,TRIM(ApellidoMaterno),Cadena_Vacia) AS ApellidoMaterno,
		IF(LENGTH(TRIM(RFC))>1,TRIM(RFC),Cadena_Vacia) AS RFC,
		FechaNacimiento,
		IF(LENGTH(TRIM(NombresConocidos))>1,TRIM(NombresConocidos),Cadena_Vacia) AS NombresConocidos,
		PaisID,

		EstadoID,
		TipoPersona,
		IF(LENGTH(TRIM(RazonSocial))>1,TRIM(RazonSocial),Cadena_Vacia) AS RazonSocial,
		IF(LENGTH(TRIM(RFCm))>1,TRIM(RFCm),Cadena_Vacia) AS RFCm,
		TipoLista,

		FechaAlta,		FechaReactivacion,		FechaInactivacion,		Estatus,
		IF(LENGTH(TRIM(NumeroOficio))>1,TRIM(NumeroOficio),Cadena_Vacia) AS NumeroOficio
		FROM PLDLISTAPERSBLOQ
			WHERE PersonaBloqID = Par_PersonaBloqID;
END IF;

-- Consulta que detecta a personas en lista de bloqueados usada en ventanilla, desembolso credito,
--  apertura de cuenta, inversion, cuentas de ahorro, cedes y proveedores
IF(Par_NumCon = ConsultaDetec) THEN
	# SE CONSULTA PARÁMETRO ACTIVO PARA REALIZAR LA BUSQUEDA DE LISTAS PLD EN BD.
	SET Var_BusqActivaPLD	:= LEFT(TRIM(FNPARAMGENERALES('PLD_BusqListasLV')),1);
	SET Var_BusqActivaPLD	:= IFNULL(Var_BusqActivaPLD,Str_No);
	SET Var_RealizaBusqPLD	:= IF(Var_BusqActivaPLD = Str_Si,Str_No,Str_Si);

	# SI SE REALIZA LA BÚSQUEDA DE LISTAS EN BD.
	IF(Var_RealizaBusqPLD = Str_Si)THEN
		IF(Par_TipoPersSAFI=EsCliente) THEN
			SET Var_ClienteID := Par_PersonaBloqID;
	        SET Var_TipoPersSAFI := EsCliente;
	        SELECT
				PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	            RFC,				FechaNacimiento,	PaisResidencia,		EstadoID,				NombreCompleto,
	            TipoPersona,		RazonSocial,		RFCpm
			INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM CLIENTES
					WHERE ClienteID = Var_ClienteID;
	    END IF;

		IF(Par_TipoPersSAFI=EsUsuarioServ) THEN
			SET Var_UsuarioServicioID := Par_PersonaBloqID;
	        SET Var_TipoPersSAFI := EsUsuarioServ2;
	        SELECT
				PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	            RFC,				FechaNacimiento,	PaisResidencia,		EstadoID,				NombreCompleto,
	            TipoPersona,		RazonSocial,		RFCpm
			INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM USUARIOSERVICIO
					WHERE UsuarioServicioID = Var_UsuarioServicioID;
	    END IF;

		IF(Par_TipoPersSAFI=EsProveedor) THEN
			SET Var_ProveedorID := Par_PersonaBloqID;
	        SET Var_TipoPersSAFI := EsProveedor;
			SELECT
				PrimerNombre,		SegundoNombre,		Cadena_Vacia,		ApellidoPaterno,		ApellidoMaterno,
				RFC,				FechaNacimiento,	PaisNacimiento,		EstadoNacimiento,		Cadena_Vacia,
				TipoPersona,		RazonSocial,		RFCpm
			INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM PROVEEDORES
					WHERE ProveedorID = Var_ProveedorID;
	    END IF;

	    -- Consulta datos del prospecto a revisar
	    IF(Par_TipoPersSAFI=EsProspecto) THEN

			SET Var_ProspectoID := Par_PersonaBloqID;
			SELECT
				PrimerNombre,		SegundoNombre,		Cadena_Vacia,		ApellidoPaterno,		ApellidoMaterno,
				RFC,				FechaNacimiento,	LugarNacimiento,		EstadoID,			NombreCompleto,
				TipoPersona,		RazonSocial,		RFCpm
			INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM PROSPECTOS
					WHERE ProspectoID = Var_ProspectoID;
	    END IF;

	    IF Par_TipoPersSAFI = EsAval THEN
	    	SELECT
	    		PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	    		RFC,				FechaNac,			LugarNacimiento,	EstadoID,				NombreCompleto,
	    		TipoPersona,		RazonSocial,		RFCpm
	    	INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	        FROM AVALES
	        WHERE AvalID = Par_PersonaBloqID;

	    END IF;

	    IF Par_TipoPersSAFI = EsGarante THEN
	    	SELECT
	    		PrimerNombre, 	SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	    		RFC,			FechaNacimiento,	LugarNacimiento,	EstadoID,				NombreCompleto,
	    		TipoPersona,	RazonSocial,		RFCpm
	    	INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	    	FROM GARANTES
	    	WHERE GaranteID = Par_PersonaBloqID;
	    END IF;

	    IF(Par_TipoPersSAFI=EsObligadoSol) THEN
	        SELECT
	    		PrimerNombre, 	SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	    		RFC,			FechaNac,			LugarNacimiento,	EstadoID,				NombreCompleto,
	    		TipoPersona,	RazonSocial,		RFCpm
	    	INTO
				Par_PrimerNombre,	Par_SegundoNombre, 	Par_TercerNombre,	Par_ApellidoPaterno,	Par_ApellidoMaterno,
				Par_RFC,			Par_FechaNacimiento,Par_PaisID,			Par_EstadoID,			Par_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	    	FROM OBLIGADOSSOLIDARIOS
	    	WHERE OblSolidID = Par_PersonaBloqID;
	    END IF;

	    -- Datos persona fisica
		SET Par_PrimerNombre 		:=(TRIM(Par_PrimerNombre));
		SET Par_SegundoNombre 		:=(TRIM(Par_SegundoNombre));
		SET Par_TercerNombre 		:=(TRIM(Par_TercerNombre));
		SET Par_ApellidoPaterno 	:=(TRIM(Par_ApellidoPaterno));
		SET Par_ApellidoMaterno 	:=(TRIM(Par_ApellidoMaterno));
		SET Par_NombreCompleto 		:=(TRIM(Par_NombreCompleto));
		SET Par_RFC 				:=(TRIM(Par_RFC));

		-- Datos persona moral
		SET Var_RazonSocial			:=FNLIMPIACARACTERESGEN(TRIM(Var_RazonSocial),Mayusculas);
		SET Var_RFCpm 				:=(TRIM(Var_RFCpm));

		SET Par_SegundoNombre 		:= IFNULL(Par_SegundoNombre,Cadena_Vacia); 	-- si el parametro es null se asigna una cadena vacia
		SET Par_TercerNombre 		:= IFNULL(Par_TercerNombre,Cadena_Vacia); 	-- si el parametro es null se asigna una cadena vacia

	    IF(IFNULL(Aud_NumTransaccion,Entero_Cero)=Entero_Cero)THEN
			CALL TRANSACCIONESPRO(Aud_NumTransaccion);
		END IF;

		IF(IFNULL(Var_TipoPersona,PersFisica)=PersMoral)THEN
			SET Var_RFCOficial := Var_RFCpm;
		ELSE
			SET Var_RFCOficial := Par_RFC;
		END IF;

	    CALL PLDDETECPERSBLOQPRO(
			Par_PersonaBloqID,				Par_PrimerNombre,		Par_SegundoNombre,		Par_TercerNombre,			Par_ApellidoPaterno,
			Par_ApellidoMaterno,			Var_RFCOficial,			Par_FechaNacimiento,	Var_RazonSocial,			Par_CuentaAhoID,
			Par_PaisID,						Par_EstadoID,			Par_TipoPersSAFI,		Var_TipoPersona,			Str_No,
			Par_NumErr,						Par_ErrMen,				Var_Coincidencias,		Var_PersonaBloqID,			Par_EmpresaID,
			Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero) THEN
			SELECT SiEsBloq AS EstaBloqueado, Var_Coincidencias AS Coincidencia;
		ELSE
			SELECT NoEsBloq AS EstaBloqueado, Var_Coincidencias AS Coincidencia;
		END IF;
	ELSE
		SELECT NoEsBloq AS EstaBloqueado, Var_Coincidencias AS Coincidencia;
	END IF;
END IF;

-- Consulta para la busqueda de coincidencias desde java.
IF(Par_NumCon = Consulta_DatosLev) THEN
	SELECT
		PersonaBloqID,	TipoLista,
		IF(TipoPersona = PersFisica,
			CONCAT(SoloNombres, SoloApellidos),
			RazonSocialPLD) AS NombreCompleto
	FROM PLDLISTAPERSBLOQ
	WHERE TipoPersona = Par_TipoPersona
		AND Estatus = Est_Activo;
END IF;

-- Consulta para la busqueda de coincidencias masiva desde java.
IF(Par_NumCon = Con_DatosLevMas) THEN
	SELECT
		PersonaBloqID AS ListaPLDID,	TipoPersona,	TipoLista,	IDQEQ,	FechaAlta,
		NumeroOficio,
		REPLACE(IF(TipoPersona = PersFisica,
			CONCAT(SoloNombres, SoloApellidos),
			RazonSocialPLD),' ',Cadena_Vacia) AS NombreCompleto
	FROM PLDLISTAPERSBLOQ
	WHERE Estatus = Est_Activo;
END IF;

END TerminaStore$$

