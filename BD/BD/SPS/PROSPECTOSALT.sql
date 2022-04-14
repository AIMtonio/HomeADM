
-- PROSPECTOSALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSALT`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `PROSPECTOSALT`(
	/*SP para el alta de prospectos*/
	Par_ProspectoIDExt		BIGINT(20),
	Par_PrimerNom 			VARCHAR(50),
	Par_SegundoNom			VARCHAR(50),
	Par_TercerNom 			VARCHAR(50),
	Par_ApellidoPat	 		VARCHAR(50),

	Par_ApellidoMat	 		VARCHAR(50),
	Par_Telefono 			CHAR(13),
	Par_Calle 				VARCHAR(50),
	Par_NumExterior 		CHAR(10),
	Par_NumInterior 		CHAR(10),

	Par_Colonia				VARCHAR(200),
	Par_Manzana	 			VARCHAR(20),
	Par_Lote		 		VARCHAR(20),
	Par_LocalidadID			INT(11),
	Par_ColoniaID 			INT(11),

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
	Par_TipoDireccionID		INT,
	Par_OcupacionID			INT(5),
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
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
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

-- Declaracion de Constantes
DECLARE Entero_Cero		INT;
DECLARE Bigint_Cero		BIGINT(20);
DECLARE Fecha_Vacia		DATE;
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Per_Fisica		CHAR(1);
DECLARE	Per_ActEmp		CHAR(1);
DECLARE	Per_Moral		CHAR(1);
DECLARE Var_ProspectoID INT;
DECLARE Var_NombreComp	VARCHAR(200);
DECLARE Var_LocalidadID INT;
DECLARE Var_ColoniaID   INT;
DECLARE Valida_RFC		CHAR(13);
DECLARE Valida_IDExt	BIGINT(20);
DECLARE varControl		VARCHAR(100);
DECLARE varConsecutivo	VARCHAR(50);
DECLARE SalidaSI		CHAR(1);
DECLARE Salida_NO		CHAR(1);
DECLARE PaisMexico		INT(11);
DECLARE CalificPros		CHAR(1);
DECLARE Var_Control		VARCHAR(50);
DECLARE Cons_Si			CHAR(1);
DECLARE EsNA			CHAR(3);
DECLARE Valida_RFCpm	CHAR(12); -- agregado Aeuan Tickt 10689
DECLARE Var_DetecNoDeseada	    CHAR(1);	-- Valida la activacion del proceso de personas no deseadas
DECLARE Var_RFCOficial			CHAR(13);	-- RFC de la persona
DECLARE Cons_No			CHAR(1);
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

-- Asignacion de Constantes
SET	Entero_Cero			:= 0;
SET	Bigint_Cero			:= 0;
SET	Fecha_Vacia    		:= '1900-01-01';
SET	Cadena_Vacia  		:= '';
SET	Per_Fisica	      	:= 'F';
SET	Per_ActEmp   		:= 'A';
SET	Per_Moral	      	:= 'M';
SET CalificPros			:= 'N';
SET SalidaSI			:= 'S';
SET Salida_NO			:= 'N';
SET	Var_ProspectoID 	:= 0;
SET	Valida_RFC			:= Cadena_Vacia;
SET	Valida_IDExt		:= 0;
SET varConsecutivo		:= 0;
SET PaisMexico			:= 700;				-- Pais Mexico
SET Cons_Si				:= 'S';
SET Valida_RFCpm		:= Cadena_Vacia; -- agregado

SET Par_PrimerNom		:= TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
SET Par_SegundoNom		:= TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
SET Par_TercerNom		:= TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
SET Par_ApellidoPat		:= TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
SET Par_ApellidoMat		:= TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));

SET Par_OcupacionID		:= IFNULL(Par_OcupacionID, Entero_Cero);
SET Par_Puesto			:= IFNULL(Par_Puesto, Cadena_Vacia);
SET Par_LugarTrabajo	:= IFNULL(Par_LugarTrabajo, Cadena_Vacia);
SET Par_AntiguedadTra	:= IFNULL(Par_AntiguedadTra, Entero_Cero);
SET Par_TelTrabajo		:= IFNULL(Par_TelTrabajo, Cadena_Vacia);
SET Par_Clasificacion	:= IFNULL(Par_Clasificacion, Cadena_Vacia);
SET Par_NoEmpleado		:= IFNULL(Par_NoEmpleado, Cadena_Vacia);
SET Par_TipoEmpleado 	:= IFNULL(Par_TipoEmpleado, Cadena_Vacia);
SET EsNA				:= 'NA';
SET Cons_No 			:= 'N';
SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PROSPECTOSALT');
		SET varControl := 'sqlException' ;
	END;

	IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_TipoPersona := Per_Fisica;
	END IF;

	IF(IFNULL(Par_ProspectoIDExt, Entero_Cero))!= Entero_Cero THEN
		SET Valida_IDExt := (SELECT ProspectoIDExt FROM PROSPECTOS WHERE ProspectoIDExt = Par_ProspectoIDExt);
	END IF;

	IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr := 1;
		SET	Par_ErrMen := 'El Nombre esta Vacio.';
		SET varControl := 'primerNombre';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND
					IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'Se requiere al menos uno de los Apellidos.';
				SET Var_Control := 'apellidoPaterno';
				LEAVE ManejoErrores;
			END IF;

	IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr := 3;
		SET	Par_ErrMen := 'La Calle esta Vacia.';
		SET varControl := 'calle';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Manzana, Cadena_Vacia)) = Cadena_Vacia  OR IFNULL(Par_Lote, Cadena_Vacia) = Cadena_Vacia THEN
		IF(IFNULL(Par_NumExterior, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr := 4;
			SET	Par_ErrMen := 'El Numero Exterior esta Vacio.';
			SET varControl := 'numExterior';
			LEAVE ManejoErrores;
		END IF;
	END IF;

    -- VALIDACION DE PARAMETROS SOLO PARA CLIENTES QUE RESIDEN EN MEXICO
	IF(Par_LugarNacimiento = PaisMexico)THEN
		IF(IFNULL(Par_ColoniaID , Entero_Cero)) = Entero_Cero  THEN
			SET	Par_NumErr := 5;
			SET	Par_ErrMen := 'La Colonia esta Vacia.';
			SET varControl := 'colonia';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MunicipioID , Entero_Cero)) = Entero_Cero  THEN
			SET	Par_NumErr := 6;
			SET	Par_ErrMen := 'El Municipio esta vacio.';
			SET varControl := 'municipioID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EstadoID , Entero_Cero)) = Entero_Cero  THEN
			SET	Par_NumErr := 7;
			SET	Par_ErrMen := 'El Estado esta vacio.';
			SET varControl := 'estadoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CP , Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr := 8;
			SET	Par_ErrMen := 'El Codigo postal esta vacio.';
			SET varControl := 'CP';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_TipoPersona = Per_Moral ) THEN
		IF(IFNULL(Par_RazonSocial  , Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr := 9;
			SET	Par_ErrMen := 'La Razon Social esta Vacia.';
			SET varControl := 'razonSocial';
			LEAVE ManejoErrores;
		ELSE IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr := 10;
			SET	Par_ErrMen := 'El RFC esta vacio.';
			SET varControl := 'RFC';
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
	ELSE
		SET Valida_RFC:=(SELECT  RFC FROM PROSPECTOS WHERE RFC = Par_RFC and TipoPersona = Per_Fisica); -- se complementa la validacion AEUAN Ticket 10689
		IF (Valida_RFC = Par_RFC)THEN
			SET	Par_NumErr := 11;
			SET	Par_ErrMen := 'RFC asociado con otro prospecto Persona Fisica';
			SET varControl := 'RFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;

-- if para valiacion para persona morales
-- se agrega la validacion para persona moral AEUAN Ticket 10689
	IF (Par_RFCpm = Cadena_Vacia)THEN
		SET Valida_RFCpm:=Cadena_Vacia;
	ELSE
		SET Valida_RFC:=(SELECT  RFCpm FROM PROSPECTOS WHERE RFCpm = Par_RFCpm and TipoPersona = Per_Moral);
		IF (Valida_RFC = Par_RFC)THEN
			SET	Par_NumErr := 11;
			SET	Par_ErrMen := 'RFC asociado con otro prospecto Persona Moral';
			SET varControl := 'RFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoPersona,Cadena_Vacia)) != Cadena_Vacia THEN
		IF(Par_TipoPersona != Per_Fisica
			AND Par_TipoPersona != Per_Moral
			AND Par_TipoPersona != Per_ActEmp)THEN
				SET	Par_NumErr := 12;
				SET	Par_ErrMen := 'Valor invalido para Tipo de Persona.';
				SET varControl := 'tipoPersona';
		LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Valida_IDExt,Bigint_Cero)) != Bigint_Cero THEN
				SET	Par_NumErr := 13;
				SET	Par_ErrMen := 'ID Prospecto Relacionado con otro Registro.';
				SET varControl := 'prospectoIDExt';
			LEAVE ManejoErrores;
	END IF;

	IF(Par_TipoPersona = Per_Moral) THEN
		SET Var_NombreComp		:= Par_RazonSocial;
		SET Var_SoloNombres		:= Cadena_Vacia;
		SET Var_SoloApellidos	:= Cadena_Vacia;
		SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocial,'MA'),200);
	END IF;

	SET Var_ProspectoID:= (SELECT IFNULL(MAX(ProspectoID),Entero_Cero) + 1
							FROM PROSPECTOS);

	SET Aud_FechaActual := NOW();

	IF(Par_FechaNacimiento >= Aud_FechaActual)  THEN
		SET	Par_NumErr := 14;
		SET	Par_ErrMen := 'Fecha de Nacimiento Incorrecta.';
		SET varControl := 'fechaNacimiento';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia  THEN
		SET	Par_NumErr := 15;
		SET	Par_ErrMen := 'El Sexo del Prospecto No Esta Indicado.';
		SET varControl := 'sexo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) = Cadena_Vacia  THEN
		SET	Par_NumErr := 16;
		SET	Par_ErrMen := 'El Estado Civil del Prospecto No Esta Indicado.';
		SET varControl := 'estadoCivil';
		LEAVE ManejoErrores;
	END IF;

-- VALIDACION DE PARAMETROS SOLO PARA CLIENTES QUE RESIDEN EN MEXICO
	IF(Par_LugarNacimiento = PaisMexico)THEN
		IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero  THEN
			SET	Par_NumErr := 17;
			SET	Par_ErrMen := 'La Localidad del Prospecto No Esta Indicado.';
			SET varControl := 'localidadID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero   THEN
			SET	Par_NumErr := 18;
			SET	Par_ErrMen := 'La Colonia del Prospecto no esta indicada.';
			SET varControl := 'colonia';
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
			SET	Par_NumErr := 19;
			SET	Par_ErrMen := 'La Localidad del Prospecto No Existe.';
			SET varControl := 'localidadID';
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
			SET	Par_NumErr := 20;
			SET	Par_ErrMen := 'La Colonia del Prospecto No Existe.';
			SET varControl := 'colonia';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_LugarNacimiento, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 21;
		SET Par_ErrMen  :='El pais de Lugar de Nacimiento esta Vacio.';
		SET varControl := 'lugarNacimiento';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 22;
		SET Par_ErrMen  :='La Nacionalidad esta Vacia.';
		SET varControl := 'nacion ';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PaisID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr	:= 23;
		SET Par_ErrMen	:='El pais de residencia esta vacio';
		SET varControl	:= 'paisResidenciaID';
		LEAVE ManejoErrores;
	END IF;

	/*INICIO VALIDACION PERSONAS NO DESEADAS*/
	SELECT  PersonNoDeseadas INTO Var_DetecNoDeseada
		FROM PARAMETROSSIS LIMIT 1;
	
	SET  Var_DetecNoDeseada:= IFNULL(Var_DetecNoDeseada,Salida_NO);
	
	IF(Var_DetecNoDeseada = SalidaSI) THEN
		SET Par_RFC := IFNULL(Par_RFC, Cadena_Vacia);
		SET Par_RFCpm := IFNULL(Par_RFCpm, Cadena_Vacia);
		
		IF(Par_TipoPersona != Per_Moral)THEN
			SET Var_RFCOficial := Par_RFC;
		ELSE
			SET Var_RFCOficial := Par_RFCpm;
		END IF;
				  
		CALL PLDDETECPERSNODESEADASPRO(
			Entero_Cero,			Var_RFCOficial,			Par_TipoPersona,					Salida_NO,				Par_NumErr,
            Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,
            Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			SET Par_NumErr			:= 050;
			SET Par_ErrMen			:= 'El Prospecto no cumple la politica interna de Riesgos.';
			LEAVE ManejoErrores;
		END IF;
	END IF;
	/*FIN VALIDACION PERSONAS NO DESEADAS*/
        
	/*SECCION PLD: Deteccion de operaciones inusuales*/
	CALL PLDDETECCIONPRO(
		Var_ProspectoID,		Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
		Par_ApellidoMat,		Par_TipoPersona,		Par_RazonSocial,		Par_RFC,				Par_RFCpm,
		Par_FechaNacimiento,	Entero_Cero,			Par_LugarNacimiento,	Par_EstadoID,			Var_NombreComp,
		EsNA,					Cons_Si,				Cons_Si,				Cons_Si,				Salida_NO,
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
											AND TipoPersonaSAFI = EsNA
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Var_ProspectoID LIMIT 1);

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
				CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,	EsNA,				Var_ProspectoID,		Var_NombreComp,			Var_FechaDeteccion,
											Con_LPB,			Var_SoloNombres,	Var_SoloApellidos,		Var_FechaNac,			Var_RFCOficial,
											Var_PaisID,			Cons_No,			Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
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

	INSERT INTO PROSPECTOS(
		ProspectoID,		ProspectoIDExt,	    	TipoPersona,			RazonSocial,			PrimerNombre,
		SegundoNombre, 		TercerNombre, 	    	ApellidoPaterno, 		ApellidoMaterno, 		FechaNacimiento,
		RFC,				Sexo,			    	EstadoCivil,			TipoDireccionID,		Telefono,
		NombreCompleto,		Calle, 			    	NumExterior, 			NumInterior, 			Manzana,
		Lote,				Colonia, 		    	ColoniaID,				LocalidadID, 			MunicipioID,
		EstadoID,			CP, 			    	Latitud,     	   		Longitud,				CalificaProspecto,
		OcupacionID,    	LugardeTrabajo,    		Puesto,           		TelTrabajo,        		AntiguedadTra,
		Clasificacion, 		NoEmpleado,        		TipoEmpleado,      		RFCpm,  				ExtTelefonoPart,
		ExtTelefonoTrab,    Nacion, 				LugarNacimiento,		PaisID,					SoloNombres,
		SoloApellidos,		RazonSocialPLD,			EmpresaID,				Usuario,				FechaActual,
		DireccionIP,		ProgramaID,				Sucursal,				NumTransaccion)
	VALUES(
		Var_ProspectoID,  	Par_ProspectoIDExt,		Par_TipoPersona,		Par_RazonSocial,	    Par_PrimerNom,
		Par_SegundoNom, 	Par_TercerNom, 	     	Par_ApellidoPat, 		Par_ApellidoMat, 	    Par_FechaNacimiento,
		Par_RFC,			Par_Sexo,	            Par_EstadoCivil,		Par_TipoDireccionID,	Par_Telefono,
		Var_NombreComp, 	Par_Calle, 			   	Par_NumExterior, 		Par_NumInterior, 	    Par_Manzana,
		Par_Lote,			Par_Colonia, 			Par_ColoniaID,			Par_LocalidadID,	    Par_MunicipioID,
		Par_EstadoID, 		Par_CP, 			    Par_Latitud,			Par_Longitud,		    CalificPros,
		Par_OcupacionID,   	Par_LugarTrabajo,  		Par_Puesto,        		Par_TelTrabajo,        	Par_AntiguedadTra,
		Par_Clasificacion, 	Par_NoEmpleado,      	Par_TipoEmpleado,  		Par_RFCpm,				Par_ExtTelefonoPart,
		Par_ExtTelefonotrab,Par_Nacion, 			Par_LugarNacimiento,	Par_PaisID,				Var_SoloNombres,
		Var_SoloApellidos,	Var_RazonSocialPLD,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	-- Se actualiza la antiguedad de trabajo del Prospectos
	UPDATE SOCIODEMOGRAL SET
		AntiguedadLab = (Par_AntiguedadTra *12),

        EmpresaID		= Par_EmpresaID,
        Usuario			= Aud_Usuario,
        FechaActual 	= Aud_FechaActual,
        DireccionIP 	= Aud_DireccionIP,
        ProgramaID  	= Aud_ProgramaID,
        Sucursal		= Aud_Sucursal,
        NumTransaccion	= Aud_NumTransaccion
	WHERE ProspectoID =  Var_ProspectoID;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Prospecto Agregado Exitosamente: ',CONVERT(Var_ProspectoID,CHAR));
	SET varControl := 'prospectoID';
	SET varConsecutivo := Var_ProspectoID;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            varControl AS Control,
            VarConsecutivo AS Consecutivo;
END IF;

END TerminaStore$$

