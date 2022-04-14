DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDSEGPERSONALISTASCON`;
DELIMITER $$
CREATE PROCEDURE `PLDSEGPERSONALISTASCON`(
	Par_OpeInuasualID 		BIGINT(20), 	-- Identificador de la tala PLDOPEINUSUALES,
	Par_NumRegistro			BIGINT(20),		-- Identificador de la persona a buscar
	Par_TipoPersona			CHAR(3),		-- Tipo de persona a busca
	Par_ListaDeteccion		VARCHAR(45),	-- Lista de donde se realizara la busqueda
	Par_NumConsulta			INT(11),		-- Numero de consulta a Realizar
	Par_EmpresaID 			INT(11),    	-- Parametros de auditoria,
  	Aud_Usuario 			INT(11),    	-- Parametros de auditoria,
  	Aud_FechaActual 		DATETIME,    	-- Parametros de auditoria,
  	Aud_DireccionIP 		VARCHAR(15),    -- Parametros de auditoria,
  	Aud_ProgramaID 			VARCHAR(50),    -- Parametros de auditoria,
  	Aud_Sucursal 			INT(11),    	-- Parametros de auditoria,
  	Aud_NumTransaccion 		BIGINT(20)    	-- Parametros de auditoria,
)
TerminaStore:BEGIN
	
	-- Declaracion de variables
	DECLARE Var_OpeInusualID 	BIGINT(20);
	DECLARE Var_NumRegistro 	BIGINT(20);
	DECLARE Var_PermiteOperacion CHAR(1);
	DECLARE Var_FechaDeteccion	DATE;

	DECLARE	Var_PrimerNombre		VARCHAR(50);
	DECLARE	Var_SegundoNombre		VARCHAR(50);
	DECLARE	Var_TercerNombre		VARCHAR(50);
	DECLARE	Var_ApellidoPaterno		VARCHAR(50);
	DECLARE	Var_ApellidoMaterno		VARCHAR(50);
	DECLARE	Var_NombreCompleto		VARCHAR(200);
	DECLARE	Var_RFC					CHAR(13);
	DECLARE	Var_FechaNacimiento		DATE;
	DECLARE	Var_PaisID				INT(11);
	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE Var_RazonSocial			VARCHAR(150);
	DECLARE	Var_RFCpm				VARCHAR(13);
	DECLARE Var_SoloApellidos		VARCHAR(150);
	DECLARE Var_SoloNombres			VARCHAR(150);
	DECLARE Var_OpeInusualIDSPL		BIGINT(20);
	DECLARE Par_NumErr 				INT(11);
	DECLARE Par_ErrMen				VARCHAR(400);

	-- Declaracion de constantes
	DECLARE Con_Principal	INT(11);
	DECLARE Con_Permite		INT(11);
	DECLARE Entero_Cero		INT(11);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Con_LPB			CHAR(3);
	DECLARE Con_LPBTXT		VARCHAR(45);
	DECLARE Con_CTE			CHAR(3);
	DECLARE Con_NA 			CHAR(2);
	DECLARE Con_PRO			CHAR(3);
	DECLARE Con_AVA 		CHAR(3);
	DECLARE Con_REL 		CHAR(3);
	DECLARE Con_USU			CHAR(3);
	DECLARE Con_PRV 		CHAR(3);
	DECLARE Con_OBS			CHAR(3);
	DECLARE Con_NoAplica	VARCHAR(9);
	DECLARE Con_Cliente		VARCHAR(7);
	DECLARE Con_Prospecto	VARCHAR(9);
	DECLARE Con_Aval		VARCHAR(4);
	DECLARE Con_Relacionado	VARCHAR(20);
	DECLARE Con_Usuario		VARCHAR(7);
	DECLARE Con_Proveedor	VARCHAR(9);
	DECLARE Con_ObligadoSol VARCHAR(20);
	DECLARE Con_SI 			CHAR(1);
	DECLARE ClaveRegistra	CHAR(2);
	DECLARE RegistraSAFI	CHAR(4);
	DECLARE CatProcIntID	VARCHAR(10);
	DECLARE CatMotivInusualID	VARCHAR(15);
	DECLARE DescripOpera		VARCHAR(52);
	DECLARE	Str_No				CHAR(1);
	DECLARE EsUsuarioServ		CHAR(3);



	-- Seteo de valores
	SET Con_Principal 		:= 1;
	SET Con_Permite			:= 2;
	SET Entero_Cero			:= 0;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Con_LPB 			:= 'LPB';
	SET Con_LPBTXT 			:= 'LISTA DE PERSONAS BLOQUEADAS';
	SET Con_CTE 			:= 'CTE';
	SET Con_NA 				:= 'NA';
	SET Con_PRO 			:= 'PRO';
	SET Con_AVA 			:= 'AVA';
	SET Con_REL 			:= 'REL';
	SET Con_USU 			:= 'USU';
	SET Con_PRV 			:= 'PRV';
	SET Con_OBS 			:= 'OBS';

	SET Con_Cliente			:= 'CLIENTE';
	SET Con_NoAplica		:= 'NO APLICA';
	SET Con_Prospecto		:= 'PROSPECTO';
	SET Con_Aval			:= 'AVAL';
	SET Con_Relacionado		:= 'RELACIONADO A CUENTA';
	SET Con_Usuario			:= 'USUARIO';
	SET Con_Proveedor		:= 'PROVEEDOR';
	SET Con_ObligadoSol		:= 'OBLIGADO SOLIDARIO';
	SET Con_SI 				:= 'S';
	SET Var_FechaDeteccion	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET ClaveRegistra		:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET RegistraSAFI		:= 'SAFI';			-- Clave que registra la operacion
	SET CatProcIntID		:='PR-SIS-000';		-- Clave interna
	SET CatMotivInusualID	:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET DescripOpera		:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
	SET Str_No				:='N';
	SET EsUsuarioServ		:='USS';		-- La persona es Usuario

	-- Consulta principal para la pantalla Seguimiento de personas en listas
	IF Par_NumConsulta = Con_Principal THEN
		SELECT 	SPL.OpeInusualID,		
		CASE INU.TipoPersonaSAFI 	WHEN Con_CTE THEN Con_Cliente
									WHEN Con_NA THEN Con_NoAplica
									WHEN Con_PRO THEN Con_Prospecto
									WHEN Con_AVA THEN Con_Aval
									WHEN Con_REL THEN Con_Relacionado
									WHEN Con_USU THEN Con_Usuario
									WHEN Con_PRV THEN Con_Proveedor
									WHEN Con_OBS THEN Con_ObligadoSol
									ELSE Con_NoAplica END AS TipoPersonaSAFI,	

		INU.ClavePersonaInv,	SPL.Nombre,	INU.FechaDeteccion,
			CASE SPL.ListaDeteccion WHEN Con_LPB THEN Con_LPBTXT END AS TipoDeteccion,
				SPL.NombreDet,			SPL.ApellidoDet,		SPL.FechaNacimientoDet,	SPL.RFCDet,	SPL.PaisDetID,
				SPL.PermiteOperacion,	SPL.Comentario,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.PersonaBloqID END AS ListaID,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN CATB.Descripcion END AS TipoLista,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.NombreCompleto END AS NombreCompleto,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.FechaNacimiento END AS FechaNacimiento,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.PaisID END AS PaisID,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.EstadoID END AS EstadoID,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.RazonSocial END AS RazonSocial,
				CASE SPL.ListaDeteccion WHEN Con_LPB THEN BLOQ.RFC END AS RFC
		FROM PLDSEGPERSONALISTAS SPL
		INNER JOIN PLDOPEINUSUALES INU ON SPL.OpeInusualID = INU.OpeInusualID
		INNER JOIN PLDCOINCIDENCIAS CON ON INU.OpeInusualID = CON.OpeInusualID
		LEFT JOIN PLDLISTAPERSBLOQ BLOQ ON CON.PersonaBloqID = BLOQ.PersonaBloqID
		LEFT JOIN CATTIPOLISTAPLD CATB ON BLOQ.TipoLista = CATB.TipoListaID
		WHERE INU.OpeInusualID = Par_OpeInuasualID
		AND IFNULL(SPL.Comentario,Cadena_Vacia) = Cadena_Vacia;
	END IF;

	IF Par_NumConsulta = Con_Permite THEN

		IF Par_TipoPersona = Con_CTE THEN
		 	SELECT
				PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	            RFC,				FechaNacimiento,	PaisResidencia,		NombreCompleto,			TipoPersona,
	            RazonSocial,		RFCpm
			INTO
				Var_PrimerNombre,	Var_SegundoNombre, 	Var_TercerNombre,	Var_ApellidoPaterno,	Var_ApellidoMaterno,
				Var_RFC,			Var_FechaNacimiento,Var_PaisID,			Var_NombreCompleto,		Var_TipoPersona,
				Var_RazonSocial,	Var_RFCpm
	        FROM CLIENTES
			WHERE ClienteID = Par_NumRegistro;
		END IF;

		IF(Par_TipoPersona=EsUsuarioServ) THEN

	        SELECT
				PrimerNombre,		SegundoNombre,		TercerNombre,		ApellidoPaterno,		ApellidoMaterno,
	            RFC,				FechaNacimiento,	PaisResidencia,		NombreCompleto,
	            TipoPersona,		RazonSocial,		RFCpm
			INTO
				Var_PrimerNombre,	Var_SegundoNombre, 	Var_TercerNombre,	Var_ApellidoPaterno,	Var_ApellidoMaterno,
				Var_RFC,			Var_FechaNacimiento,Var_PaisID,			Var_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM USUARIOSERVICIO
					WHERE UsuarioServicioID = Par_NumRegistro;
	    END IF;

		IF(Par_TipoPersona=Con_PRV) THEN

			SELECT
				PrimerNombre,		SegundoNombre,		Cadena_Vacia,		ApellidoPaterno,		ApellidoMaterno,
				RFC,				FechaNacimiento,	PaisNacimiento,		Cadena_Vacia,
				TipoPersona,		RazonSocial,		RFCpm
			INTO
				Var_PrimerNombre,	Var_SegundoNombre, 	Var_TercerNombre,	Var_ApellidoPaterno,	Var_ApellidoMaterno,
				Var_RFC,			Var_FechaNacimiento,Var_PaisID,			Var_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM PROVEEDORES
					WHERE ProveedorID = Par_NumRegistro;
	    END IF;

	    -- Consulta datos del prospecto a revisar
	    IF(Par_TipoPersona=Con_PRO) THEN

			SELECT
				PrimerNombre,		SegundoNombre,		Cadena_Vacia,		ApellidoPaterno,		ApellidoMaterno,
				RFC,				FechaNacimiento,	LugarNacimiento,	NombreCompleto,
				TipoPersona,		RazonSocial,		RFCpm
			INTO
				Var_PrimerNombre,	Var_SegundoNombre, 	Var_TercerNombre,	Var_ApellidoPaterno,	Var_ApellidoMaterno,
				Var_RFC,			Var_FechaNacimiento,Var_PaisID,			Var_NombreCompleto,
	            Var_TipoPersona,	Var_RazonSocial,	Var_RFCpm
	            FROM PROSPECTOS
					WHERE ProspectoID = Par_NumRegistro;
	    END IF;


		SET Var_PrimerNombre 		:=TRIM(IFNULL(Var_PrimerNombre, Cadena_Vacia));
		SET Var_SegundoNombre 		:=TRIM(IFNULL(Var_SegundoNombre, Cadena_Vacia));
		SET Var_TercerNombre 		:=TRIM(IFNULL(Var_TercerNombre, Cadena_Vacia));
		SET Var_ApellidoPaterno 	:=TRIM(IFNULL(Var_ApellidoPaterno, Cadena_Vacia));
		SET Var_ApellidoMaterno 	:=TRIM(IFNULL(Var_ApellidoMaterno, Cadena_Vacia));
		SET Var_RazonSocial			:=TRIM(IFNULL(Var_RazonSocial,Cadena_Vacia));
		SET Var_TipoPersona			:=TRIM(IFNULL(Var_TipoPersona,Cadena_Vacia));
		SET Var_PaisID				:=TRIM(IFNULL(Var_PaisID,Entero_Cero));
		SET Var_RFC 				:=TRIM(IFNULL(Var_RFC,Cadena_Vacia));
		SET Var_RFCpm				:=TRIM(IFNULL(Var_RFCpm,Cadena_Vacia));

		SET Var_SoloNombres			:=  FNGENNOMBRECOMPLETO(Var_PrimerNombre, Var_SegundoNombre,Var_TercerNombre,Cadena_Vacia,Cadena_Vacia);
		SET Var_SoloApellidos		:=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Var_ApellidoPaterno,Var_ApellidoMaterno);
		SET Var_NombreCompleto 		:=  FNGENNOMBRECOMPLETO(Var_PrimerNombre, Var_SegundoNombre,Var_TercerNombre,Var_ApellidoPaterno,Var_ApellidoMaterno);

		IF Var_TipoPersona = 'M' THEN
			SET Var_NombreCompleto	:= FNLIMPIACARACTERESGEN(TRIM(Var_RazonSocial),'M');
			SET Var_NombreCompleto	:= IFNULL(Var_NombreCompleto,Cadena_Vacia);
			SET Var_RFC := Var_RFCpm;
		END IF;

		SET Var_SoloApellidos := IFNULL(Var_SoloApellidos,Cadena_Vacia);
		SET Var_SoloNombres	:= IFNULL(Var_Solonombres,Cadena_Vacia);

		SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = Var_NombreCompleto
											AND TipoPersonaSAFI = Par_TipoPersona
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Par_NumRegistro LIMIT 1);

		IF IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero THEN

			SELECT OpeInusualID,PermiteOperacion INTO Var_OpeInusualIDSPL,Var_PermiteOperacion
			FROM PLDSEGPERSONALISTAS
			WHERE OpeInusualID = Var_OpeInusualID;

			IF IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero THEN
				SET Aud_FechaActual := NOW();
				 IF(IFNULL(Aud_NumTransaccion,Entero_Cero)=Entero_Cero)THEN
					CALL TRANSACCIONESPRO(Aud_NumTransaccion);
				END IF;

				-- Damos de alta en la tabla de coincidencias de personas en listas de personas bloqueadas por el momento es para este tipo de lista
				CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,	Par_TipoPersona,	Par_NumRegistro,		Var_NombreCompleto,		Var_FechaDeteccion,
											Con_LPB,			Var_SoloNombres,	Var_SoloApellidos,		Var_FechaNacimiento,	Var_RFC,
											Var_PaisID,			Str_No,				Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,
											Aud_NumTransaccion);


			END IF;
		END IF;


		SELECT 	OpeInusualID, NumRegistro, PermiteOperacion,FechaDeteccion
		INTO	Var_OpeInusualID, Var_NumRegistro, Var_PermiteOperacion, Var_FechaDeteccion
		FROM PLDSEGPERSONALISTAS
		WHERE NumRegistro = Par_NumRegistro
			AND ListaDeteccion = Par_ListaDeteccion
		ORDER BY FechaDeteccion DESC LIMIT 1;

		SET Var_OpeInusualID := IFNULL(Var_OpeInusualID,Entero_Cero);
		SET Var_NumRegistro := IFNULL(Var_NumRegistro,Entero_Cero);
		SET Var_PermiteOperacion := IFNULL(Var_PermiteOperacion,Con_SI);
		SET Var_FechaDeteccion := IFNULL(Var_FechaDeteccion,Fecha_Vacia);

		SELECT Var_OpeInusualID AS OpeInusualID, Var_NumRegistro AS NumRegistro, Var_PermiteOperacion AS PermiteOperacion, Var_FechaDeteccion AS FechaDeteccion;

	END IF;

END TerminaStore$$