
-- PROSPECTOSMOD --

DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSMOD`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `PROSPECTOSMOD`(
	/*SP para modificacion del prospecto*/
	Par_ProspectoID			BIGINT(20),
	Par_PrimerNom 			VARCHAR(50),
	Par_SegundoNom 			VARCHAR(50),
	Par_TercerNom 			VARCHAR(50),
	Par_ApellidoPat	 		VARCHAR(50),

	Par_ApellidoMat	 		VARCHAR(50),
	Par_Telefono 			CHAR(13),
	Par_Calle 				VARCHAR(50),
	Par_NumExterior 		CHAR(10),
	Par_NumInterior 		CHAR(10),

	Par_Manzana	 			VARCHAR(20),
	Par_Lote		 		VARCHAR(20),
	Par_Colonia 			VARCHAR(200),
	Par_ColoniaID			INT(11),
	Par_LocalidadID			INT(11),

	Par_MunicipioID 		INT(11),
	Par_EstadoID 			INT(11),
	Par_CP 					VARCHAR(5),
	Par_TipoPersona 		CHAR(1),
	Par_RazonSocial 		VARCHAR(50),

	Par_FechaNacimiento		DATE,
	Par_RFC 				CHAR(13),
	Par_Sexo				CHAR(1),
	Par_EstadoCivil			CHAR(2),
	Par_Latitud 			VARCHAR(45),

	Par_Longitud			VARCHAR(45),
	Par_TipoDireccionID		INT(11),
	Par_OcupacionID     	INT(5),
	Par_Puesto          	VARCHAR(100),
	Par_LugarTrabajo    	VARCHAR(100),

	Par_AntiguedadTra   	DECIMAL(12,2),
	Par_TelTrabajo      	VARCHAR(20),
	Par_Clasificacion   	CHAR(1),
	Par_NoEmpleado      	VARCHAR(20),
	Par_TipoEmpleado    	CHAR(1),

	Par_RFCpm            	CHAR(13),
	Par_ExtTelefonoPart		VARCHAR(6),
	Par_ExtTelefonoTrab		VARCHAR(6),
	Par_Nacion				CHAR(1),		-- Nacionalidad del aval N.- Nacional E.- Extranjero
	Par_LugarNacimiento		INT(11),		-- Pais de Nacimiento
	Par_PaisID				INT(11),		-- Pais de Residencia

	Par_Salida          	CHAR(1),
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),
	/* Parametros de Auditoria */
	Par_EmpresaID        	INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal		  	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE Entero_Cero		INT;
DECLARE Bigint_Cero		BIGINT(20);
DECLARE Fecha_Vacia		DATE;
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Per_Fisica		CHAR(1);
DECLARE	Per_ActEmp		CHAR(1);
DECLARE	Per_Moral		CHAR(1);
DECLARE	SalidaSI		CHAR(1);
DECLARE	SalidaNO		CHAR(1);
DECLARE PaisMexico		INT(11);
DECLARE EsProspecto		CHAR(3);
DECLARE Cons_Si			CHAR(1);

-- Declaracion de Variables
DECLARE Var_NombreComp	VARCHAR(200);
DECLARE Valida_RFC		CHAR(13);
DECLARE Var_LocalidadID INT;
DECLARE Var_ColoniaID   INT;
DECLARE Var_Control 	VARCHAR(25);
DECLARE Valida_RFCpm		CHAR(12); -- agregado Aeuan Tickt 10689
DECLARE Var_DetecNoDeseada	CHAR(1);	-- Valida la activacion del proceso de personas no deseadas
DECLARE Var_RFCOficial		CHAR(13);	-- RFC de la persona
DECLARE DescripOpera		VARCHAR(52);
DECLARE CatMotivInusualID	VARCHAR(15);
DECLARE CatProcIntID		VARCHAR(10);
DECLARE RegistraSAFI		CHAR(4);
DECLARE ClaveRegistra		CHAR(2);
DECLARE Var_FechaDeteccion	DATE;
DECLARE Var_OpeInusualID	BIGINT(20);
DECLARE Con_LPB				CHAR(3);
DECLARE Var_SoloApellidos	VARCHAR(150);
DECLARE Var_SoloNombres		VARCHAR(150);
DECLARE Var_RazonSocialPLD	VARCHAR(200);
DECLARE Var_OpeInusualIDSPL	BIGINT(20);
DECLARE Var_ErrMen			VARCHAR(400);
DECLARE Var_PaisID			INT(11);
DECLARE Var_FechaNac 		DATE;

-- Asignacion de constantes
SET	Entero_Cero		:= 0;
SET	Bigint_Cero		:= 0;
SET	Fecha_Vacia		:= '1900-01-01';
SET	Cadena_Vacia	:= '';
SET	Per_Fisica		:= 'F';
SET	Per_ActEmp		:= 'A';
SET	Per_Moral		:= 'M';
SET	SalidaSI		:= 'S';
SET	SalidaNO		:= 'N';
SET PaisMexico		:= 700;				-- Pais Mexico
SET EsProspecto		:= 'PRO';			-- Tipo de persona SAFI PLD
SET Cons_Si			:= 'S';				-- Constante SI
SET Valida_RFCpm		:= Cadena_Vacia; -- agregado 

SET	Valida_RFC		:= Cadena_Vacia;
SET Par_PrimerNom	:= TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
SET Par_SegundoNom	:= TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
SET Par_TercerNom	:= TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
SET Par_ApellidoPat	:= TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
SET Par_ApellidoMat	:= TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));

SET Par_OcupacionID  :=IFNULL(Par_OcupacionID, Entero_Cero);
SET Par_Puesto       :=IFNULL(Par_Puesto, Cadena_Vacia);
SET Par_LugarTrabajo :=IFNULL(Par_LugarTrabajo, Cadena_Vacia);
SET Par_AntiguedadTra:=IFNULL(Par_AntiguedadTra, Entero_Cero);
SET Par_TelTrabajo   :=IFNULL(Par_TelTrabajo, Cadena_Vacia);
SET Par_Clasificacion:=IFNULL(Par_Clasificacion, Cadena_Vacia);
SET Par_NoEmpleado   :=IFNULL(Par_NoEmpleado, Cadena_Vacia);
SET Par_TipoEmpleado :=IFNULL(Par_TipoEmpleado, Cadena_Vacia);

SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas


IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
	SET Par_TipoPersona := Per_Fisica;
END IF;

ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PROSPECTOSMOD');
			SET Var_Control := 'sqlException';
		END;

	IF(NOT EXISTS(SELECT ProspectoID
				FROM PROSPECTOS
				WHERE ProspectoID = Par_ProspectoID)) THEN
		SET	Par_NumErr 	:= 1;
		SET	Par_ErrMen 	:= CONCAT('El Numero de Prospecto No Existe.',CONVERT(Par_ProspectoID,CHAR(20)));
		SET Var_Control := 'prospectoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr 	:= 2;
		SET	Par_ErrMen 	:= 'El Nombre esta Vacio.';
		SET Var_Control := 'primerNombre';
		LEAVE ManejoErrores;
	END IF;

    IF(Par_ApellidoPat= Cadena_Vacia AND Par_ApellidoMat = Cadena_Vacia)THEN
		SET	Par_NumErr := 3;
		SET	Par_ErrMen := 'El Apellido Paterno esta Vacio.';
		SET Var_Control := 'apellidoPaterno';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr 	:= 4;
		SET	Par_ErrMen 	:= 'La Calle esta Vacia.';
		SET Var_Control := 'calle';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_Manzana, Cadena_Vacia)) = Cadena_Vacia  OR IFNULL(Par_Lote, Cadena_Vacia) = Cadena_Vacia THEN
		IF(IFNULL(Par_NumExterior, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 5;
			SET	Par_ErrMen 	:= 'El Numero Exterior esta Vacio.';
			SET Var_Control := 'numExterior';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Colonia , Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 6;
			SET	Par_ErrMen 	:= 'La Colonia esta Vacia.';
			SET Var_Control := 'coloniaID';
			LEAVE ManejoErrores;
	END IF;
-- VALIDACION DE PARAMETROS SOLO PARA CLIENTES QUE RESIDEN EN MEXICO
	IF(Par_LugarNacimiento = PaisMexico)THEN
		IF(IFNULL(Par_MunicipioID , Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr 	:= 7;
			SET	Par_ErrMen 	:= 'El Municipio esta vacio.';
			SET Var_Control := 'municipioID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EstadoID , Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr 	:= 8;
			SET	Par_ErrMen 	:= 'El Estado esta vacio.';
			SET Var_Control := 'estadoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CP , Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 9;
			SET	Par_ErrMen 	:= 'El Codigo postal esta vacio.';
			SET Var_Control := 'CP';
			LEAVE ManejoErrores;
		END IF;
    END IF;

	IF(Par_TipoPersona = Per_Moral ) THEN
		IF(IFNULL(Par_RazonSocial  , Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr 	:= 10;
			SET	Par_ErrMen 	:= 'La Razon Social esta Vacia.';
			SET Var_Control := 'razonSocial';
			LEAVE ManejoErrores;
		ELSE
			IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr 	:= 11;
				SET	Par_ErrMen 	:= 'El RFC esta vacio.';
				SET Var_Control := 'RFC';
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona = Per_ActEmp) THEN
		SET Var_NombreComp 		:= FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
		SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom, Cadena_Vacia, Cadena_Vacia),'MA'),150);
		SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia, Cadena_Vacia, Par_ApellidoPat,Par_ApellidoMat),'MA'),150);
		SET Var_RazonSocialPLD	:= Cadena_Vacia;
	END IF;

	IF (Par_RFC = Cadena_Vacia)THEN
		SET Valida_RFC:=Cadena_Vacia;
        -- se agrega validacion para perosna fisica 
        ELSE
		SET Valida_RFC:=(SELECT  RFC FROM PROSPECTOS WHERE RFC = Par_RFC and TipoPersona = Per_Fisica AND ProspectoID != Par_ProspectoID); -- se complementa la validacion AEUAN Ticket 10689
		IF (Valida_RFC = Par_RFC)THEN
			SET	Par_NumErr := 11;
			SET	Par_ErrMen := 'RFC asociado con otro prospecto Persona Fisica';
			SET Var_Control := 'RFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;
    
    -- se agrega validacion para persona moral 
    IF (Par_RFCpm = Cadena_Vacia)THEN
		SET Valida_RFCpm:=Cadena_Vacia;
	ELSE
		SET Valida_RFC:=(SELECT  RFCpm FROM PROSPECTOS WHERE RFCpm = Par_RFCpm and TipoPersona = Per_Moral AND ProspectoID != Par_ProspectoID); 
		IF (Valida_RFC = Par_RFCpm)THEN
			SET	Par_NumErr := 11;
			SET	Par_ErrMen := 'RFC asociado con otro prospecto Persona Moral';
			SET Var_Control := 'RFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoPersona,Cadena_Vacia)) != Cadena_Vacia THEN
		IF(Par_TipoPersona != Per_Fisica
			AND Par_TipoPersona != Per_Moral
			AND Par_TipoPersona != Per_ActEmp)THEN
				SET	Par_NumErr 	:= 12;
				SET	Par_ErrMen 	:= 'El Tipo de Persona No Es Valido.';
				SET Var_Control := 'tipoPersona';
				LEAVE ManejoErrores;
		END IF;
	END IF;


	IF(Par_TipoPersona = Per_Moral) THEN
		SET Var_NombreComp		:= Par_RazonSocial;
		SET Var_SoloNombres		:= Cadena_Vacia;
		SET Var_SoloApellidos	:= Cadena_Vacia;
		SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocial,'MA'),200);
	END IF;


	SET Aud_FechaActual := NOW();

	IF(Par_FechaNacimiento >= Aud_FechaActual)  THEN
		SET	Par_NumErr 	:= 13;
		SET	Par_ErrMen 	:= 'Fecha de Nacimiento Incorrecta.';
		SET Var_Control := 'fechaNacimiento';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia  THEN
		SET	Par_NumErr 	:= 14;
		SET	Par_ErrMen 	:= 'El Sexo del Prospecto No Esta Indicado.';
		SET Var_Control := 'sexo';
		LEAVE ManejoErrores;

	END IF;

	IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) = Cadena_Vacia  THEN
		SET	Par_NumErr 	:= 15;
		SET	Par_ErrMen 	:= 'El Estado Civil del Prospecto No Esta Indicado.';
		SET Var_Control := 'estadoCivil';
		LEAVE ManejoErrores;
	END IF;

-- VALIDACION DE PARAMETROS SOLO PARA CLIENTES QUE RESIDEN EN MEXICO
	IF(Par_LugarNacimiento = PaisMexico)THEN
		IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero  THEN
			SET	Par_NumErr 	:= 16;
			SET	Par_ErrMen 	:= 'La Localidad del Prospecto No Esta Indicada.';
			SET Var_Control := 'localidadID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero  THEN
			SET	Par_NumErr 	:= 17;
			SET	Par_ErrMen 	:= 'La Colonia del Prospecto No Esta Indicada.';
			SET Var_Control := 'coloniaID';
			LEAVE ManejoErrores;
		END IF;
    END IF;

	IF(IFNULL(Par_LocalidadID, Entero_Cero))<> Entero_Cero THEN
		SELECT LocalidadID INTO Var_LocalidadID
			FROM LOCALIDADREPUB
				WHERE LocalidadID = Par_LocalidadID
					AND MunicipioID=Par_MunicipioID
					AND EstadoID=Par_EstadoID;
		IF(IFNULL(Var_LocalidadID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 18;
			SET	Par_ErrMen 	:= 'La Localidad del Prospecto No Existe.';
			SET Var_Control := 'localidadID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_ColoniaID, Entero_Cero))<> Entero_Cero THEN
		SELECT ColoniaID INTO Var_ColoniaID
			FROM COLONIASREPUB
				WHERE ColoniaID = Par_ColoniaID
					AND MunicipioID=Par_MunicipioID
					AND EstadoID=Par_EstadoID;
		IF(IFNULL(Var_ColoniaID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 19;
			SET	Par_ErrMen 	:= 'La Colonia del Prospecto No Existe.';
			SET Var_Control := 'coloniaID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_LugarNacimiento, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 20;
		SET Par_ErrMen  :='El pais de Lugar de Nacimiento esta Vacio.';
		SET Var_Control := 'lugarNacimiento';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_LugarNacimiento = PaisMexico) THEN
		  IF(IFNULL(Par_EstadoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 21;
			SET Par_ErrMen  :='El Estado esta Vacio.';
			SET Var_Control := 'estadoID ';
			LEAVE ManejoErrores;
	  END IF;
	END IF;

	IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 22;
		SET Par_ErrMen  :='La Nacionalidad esta Vacia.';
		SET Var_Control := 'nacion ';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PaisID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 23;
		SET Par_ErrMen  :='El pais de residencia esta vacio.';
		SET Var_Control := 'paisResidenciaID';
		LEAVE ManejoErrores;
	END IF;
	
    /*INICIO VALIDACION PERSONAS NO DESEADAS*/
	SELECT  PersonNoDeseadas INTO Var_DetecNoDeseada
		FROM PARAMETROSSIS LIMIT 1;
	
	SET  Var_DetecNoDeseada:= IFNULL(Var_DetecNoDeseada,SalidaNO);
	
	IF(Var_DetecNoDeseada = SalidaSI) THEN
		SET Par_RFC := IFNULL(Par_RFC, Cadena_Vacia);
		SET Par_RFCpm := IFNULL(Par_RFCpm, Cadena_Vacia);
		
		IF(Par_TipoPersona != Per_Moral)THEN
			SET Var_RFCOficial := Par_RFC;
		ELSE
			SET Var_RFCOficial := Par_RFCpm;
		END IF;
				  
		CALL PLDDETECPERSNODESEADASPRO(
			Entero_Cero,			Var_RFCOficial,			Par_TipoPersona,					SalidaNO,				Par_NumErr,
            Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			SET Par_NumErr			:= 050;
			SET Par_ErrMen			:= 'El Prospecto no cumple la politica interna de Riesgos.';	
			LEAVE ManejoErrores;
		END IF;
	END IF;
    
	/*SECCION PLD: Deteccion de operaciones inusuales*/
	CALL PLDDETECCIONPRO(
		Par_ProspectoID,		Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
		Par_ApellidoMat,		Par_TipoPersona,		Par_RazonSocial,		Par_RFC,				Par_RFCpm,
		Par_FechaNacimiento,	Entero_Cero,			Par_LugarNacimiento,	Par_EstadoID,			Var_NombreComp,
		EsProspecto,			Cons_Si,				Cons_Si,				Cons_Si,				SalidaNO,
		Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


	IF(Par_NumErr!=Entero_Cero)THEN

		SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = Var_NombreComp
											AND TipoPersonaSAFI = EsProspecto
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Par_ProspectoID LIMIT 1);

		IF (Par_TipoPersona = Per_Moral) THEN
			SET Var_NombreComp	:= FNLIMPIACARACTERESGEN(TRIM(Par_RazonSocial),'M');
			SET Var_NombreComp	:= IFNULL(Var_NombreComp,Cadena_Vacia);
			SET Var_RFCOficial := Par_RFCpm;
			SET Var_FechaNac := Fecha_Vacia;
			SET Var_PaisID := 700;
		ELSE
			SET Var_RFCOficial := Par_RFC;
			SET Var_FechaNac := Par_FechaNacimiento;
			SET Var_PaisID := Par_LugarNacimiento;
		END IF;

		SET Var_ErrMen := Par_ErrMen;
		IF IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero THEN

			SELECT OpeInusualID INTO Var_OpeInusualIDSPL
			FROM PLDSEGPERSONALISTAS
			WHERE OpeInusualID = Var_OpeInusualID;
			IF IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero THEN
				-- Damos de alta en la tabla de coincidencias de personas en listas e personas bloqueadas por el momento es para este tipo de lista
				CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,	EsProspecto,		Par_ProspectoID,		Var_NombreComp,			Var_FechaDeteccion,
											Con_LPB,			Var_SoloNombres,	Var_SoloApellidos,		Var_FechaNac,			Var_RFCOficial,
											Var_PaisID,			SalidaNO,			Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
											Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,
											Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
		SET Par_ErrMen			:= Var_ErrMen;
		SET Var_Control			:= 'prospectoID';
		LEAVE ManejoErrores;
	END IF;
	/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

	UPDATE PROSPECTOS SET
		TipoPersona 		= Par_TipoPersona,
		RazonSocial 		= Par_RazonSocial,
		PrimerNombre 		= Par_PrimerNom,
		SegundoNombre 		= Par_SegundoNom,
		TercerNombre 		= Par_TercerNom,

		ApellidoPaterno 	= Par_ApellidoPat,
		ApellidoMaterno 	= Par_ApellidoMat,
		FechaNacimiento		= Par_FechaNacimiento,
		RFC					= Par_RFC,
		Sexo				= Par_Sexo,

		EstadoCivil			= Par_EstadoCivil,
		Telefono			= Par_Telefono,
		NombreCompleto		= Var_NombreComp,
		Calle				= Par_Calle,
		NumExterior			= Par_NumExterior,

		NumInterior			= Par_NumInterior,
		Manzana				= Par_Manzana,
		Lote				= Par_Lote,
		Colonia				= Par_Colonia,
		ColoniaID			= Par_ColoniaID,

		LocalidadID			= Par_LocalidadID,
		MunicipioID			= Par_MunicipioID,
		EstadoID			= Par_EstadoID,
		CP			   		= Par_CP,
		Latitud				= Par_Latitud,

		Longitud			= Par_Longitud,
		TipoDireccionID  	= Par_TipoDireccionID,
		OcupacionID      	= Par_OcupacionID,
		Puesto           	= Par_Puesto,
		LugardeTrabajo   	= Par_LugarTrabajo,

		AntiguedadTra    	= Par_AntiguedadTra,
		TelTrabajo       	= Par_TelTrabajo,
		Clasificacion    	= Par_Clasificacion,
		NoEmpleado       	= Par_NoEmpleado,
		TipoEmpleado     	= Par_TipoEmpleado,

		RFCpm            	= Par_RFCpm,
		ExtTelefonoPart		= Par_ExtTelefonoPart,
		ExtTelefonoTrab		= Par_ExtTelefonoTrab,
		Nacion				= Par_Nacion,
		LugarNacimiento		= Par_LugarNacimiento,

		PaisID				= Par_PaisID,
		SoloNombres			= Var_SoloNombres,
		SoloApellidos		= Var_SoloApellidos,
		RazonSocialPLD		= Var_RazonSocialPLD,
		EmpresaID			= Par_EmpresaID,

		Usuario				= Aud_Usuario,
		FechaActual			= Aud_FechaActual,
		DireccionIP			= Aud_DireccionIP,
		ProgramaID			= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion 		= Aud_NumTransaccion
	WHERE ProspectoID = Par_ProspectoID;


	-- Se actualiza la antiguedad de trabajo del prospecto
	UPDATE SOCIODEMOGRAL SET
		AntiguedadLab = (Par_AntiguedadTra *12),

        EmpresaID		= Par_EmpresaID,
        Usuario			= Aud_Usuario,
        FechaActual 	= Aud_FechaActual,
        DireccionIP 	= Aud_DireccionIP,
        ProgramaID  	= Aud_ProgramaID,
        Sucursal		= Aud_Sucursal,
        NumTransaccion	= Aud_NumTransaccion
		WHERE ProspectoID =  Par_ProspectoID;

		SET	Par_NumErr 	:= Entero_Cero;
		SET	Par_ErrMen 	:= CONCAT('Prospecto Modificado Exitosamente: ',CONVERT(Par_ProspectoID,CHAR));
		SET Var_Control := 'prospectoID';

END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Par_ProspectoID AS Consecutivo;
	END IF;

END TerminaStore$$

