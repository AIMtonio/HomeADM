
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASPERSONAMOD`;

DELIMITER $$
CREATE PROCEDURE `CUENTASPERSONAMOD`(
/** ***** STORE ENCARGADO DE REALIZAR LA ACTUALIZACION DE LOS DATOS DE UNA PERSONA (TABLA CUENTASPERSONA) ***** **/
	Par_CuentaAhoID 		BIGINT(12),
	Par_PersonaID			INT(12),
	Par_EsApoderado			CHAR(1),
	Par_EsTitular			CHAR(1),
	Par_EsCotitular			CHAR(1),

	Par_EsBeneficiario		CHAR(1),
	Par_EsProvRecurso		CHAR(1),
	Par_EsPropReal			CHAR(1),
	Par_EsFirmante			CHAR(1),
	Par_Titulo 				VARCHAR(10),

	Par_PrimerNom 			VARCHAR(50),
	Par_SegundoNom 			VARCHAR(50),
	Par_TercerNom 			VARCHAR(50),
	Par_ApellidoPat			VARCHAR(50),
	Par_ApellidoMat 		VARCHAR(50),

	Par_FechaNac 			DATE,
	Par_PaisNac 			INT(5),
	Par_EdoNac				INT(11),
	Par_EdoCivil 			CHAR(2),
	Par_Sexo 				CHAR(1),

	Par_Nacion 				CHAR(1),
	Par_CURP 				CHAR(18),
	Par_RFC 				CHAR(13),
	Par_OcupacionID 		INT(5),
	Par_FEA					VARCHAR(250),

    Par_PaisFEA				INT(11),
	Par_PaisRFC				INT(11),
	Par_PuestoA				VARCHAR(100),
	Par_SectorGral 			INT(3),
	Par_ActBancoMX 			VARCHAR(15),

	Par_ActINEGI 			INT(5),
	Par_SecEcono			INT(3),
	Par_TipoIdentiID		INT(11),
	Par_OtraIden 			VARCHAR(20),
	Par_NumIden				VARCHAR(20),

	Par_FecExIden 			DATE,
	Par_FecVenIden 			DATE,
	Par_Domicilio 			VARCHAR(200),
	Par_TelCasa 			VARCHAR(20),
	Par_TelCel 				VARCHAR(20),

	Par_Correo 				VARCHAR(50),
	Par_PaisRes				INT(5),
	Par_DocEstLegal 		VARCHAR(3),
	Par_DocExisLegal		VARCHAR(20),
	Par_FechaVenEst			DATE,

	Par_NumEscPub 			VARCHAR(50),
	Par_FechaEscPub 		DATE,
	Par_EstadoID 			INT(11),
	Par_MunicipioID 		INT(11),
	Par_NotariaID 			INT(11),

	Par_TitularNotaria		VARCHAR(100),
	Par_RazonSocial 		VARCHAR(150),
	Par_Fax 				VARCHAR(30),
	Par_ParentescoID		INT(11),
	Par_Porcentaje 			FLOAT,

	Par_ClienteID			INT(11),
	Par_ExtTelefonoPart		VARCHAR(6),
	Par_IngreRealoRecur		DECIMAL(14,2),

    Par_CorreoPM			VARCHAR(50),			-- Correo de Persona Moral
    Par_TelefonoPM        	VARCHAR(20),			-- Telefono fijo del cliente	Persona Moral
    Par_ExtTelefonoPM       VARCHAR(6),				-- Extencion Telefono fijo del cliente	Persona Moral
    Par_DomicilioOfiPM		VARCHAR(200),			-- Domicilio oficial de Persona Moral
	Par_RazonSocialPM		VARCHAR(200),			-- Razon Social de PM

    Par_FechaRegistroPM		DATE,
    Par_PaisConstitucion	INT(5),
    Par_RFCpm               CHAR(12),
	Par_EsAccionista		CHAR(1),
	Par_PorcentajeAcc		DECIMAL(12,4),

    Par_FeaPM				VARCHAR(250),
    Par_PaisFeaPM			INT(11),

	Par_Salida    			CHAR(1),
	INOUT	Par_NumErr 		INT(11),

	INOUT	Par_ErrMen  	VARCHAR(350),
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	NumPersona			INT;
	DECLARE	Var_nombrePersona	VARCHAR(200);
	DECLARE	Var_NombreCompleto	VARCHAR(200);
	DECLARE	Var_numeroCuenta	BIGINT(12);
	DECLARE	SumaPor				FLOAT;
	DECLARE	PorAnt				FLOAT;
    DECLARE PorAntAcc			DECIMAL(12,4);
    DECLARE SumaPorAcc			DECIMAL(12,4);
	DECLARE Var_PaisID			INT(11);
	DECLARE Var_EstadoID		INT(11);
	DECLARE Var_PersonaID		INT(12);
	DECLARE varEstadoID			INT(11);
	DECLARE VarControl	   		VARCHAR(200);
	DECLARE Var_Consecutivo		INT(11);
	DECLARE Var_CampoGenerico	INT(11);
	DECLARE Var_TipoPersSAFI	VARCHAR(3);
	DECLARE Var_Control			VARCHAR(50);

	DECLARE Var_Correo			VARCHAR(50);
	DECLARE Var_Telefono		VARCHAR(20);
	DECLARE Var_ExtTelefono		VARCHAR(6);
	DECLARE Var_Domicilio		VARCHAR(200);
	DECLARE Var_PaisResID       INT(11);

    DECLARE	Var_FechaNac		DATE;
    DECLARE Var_RFC             CHAR(13);
    DECLARE Var_MunicipioID		INT(11);
    DECLARE Var_RazonSocial		VARCHAR(150);
	DECLARE Var_TipoPersonaCta	CHAR(1);

	DECLARE	Var_Fea				VARCHAR(250);
    DECLARE	Var_PaisFea			INT(11);
    DECLARE Var_TipoPers 		CHAR(3);
    DECLARE Var_IdentificadorID INT(11);
	DECLARE	Var_SoloNombres		VARCHAR(500);
	DECLARE	Var_SoloApellidos	VARCHAR(500);
	DECLARE	Var_RazonSocialPLD	VARCHAR(200);

	-- Declaracion de Constantes
	DECLARE	Estatus_Activo		CHAR(1);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Float_Vacio			FLOAT;
	DECLARE	Si					CHAR(1);
	DECLARE	Fisica				CHAR(1);
	DECLARE	Moral				CHAR(1);
	DECLARE PaisMexico			INT(11);
	DECLARE Vigente				CHAR(1);
	DECLARE Constante_No		CHAR(1);
	DECLARE Extranjero			CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE	EsCliente			VARCHAR(3);
	DECLARE	EsUsServ			VARCHAR(3);
	DECLARE	EsNA				VARCHAR(3);
	DECLARE Var_EsMenorEdad		CHAR(1);
	DECLARE EsRelacionado		VARCHAR(3);
	DECLARE Cons_Si				CHAR(1);
	DECLARE Mayusculas			CHAR(2);

	DECLARE Var_EraFirmante		CHAR(1);
    DECLARE Num_Actualizar		TINYINT;
    DECLARE DescripOpera		VARCHAR(52);
	DECLARE CatMotivInusualID	VARCHAR(15);
	DECLARE CatProcIntID		VARCHAR(10);
	DECLARE RegistraSAFI		CHAR(4);
	DECLARE ClaveRegistra		CHAR(2);
	DECLARE Var_FechaDeteccion	DATE;
	DECLARE Var_OpeInusualID	BIGINT(20);
	DECLARE Con_LPB				CHAR(3);
	DECLARE Var_SoloApellido	VARCHAR(150);
	DECLARE Var_SoloNombre		VARCHAR(150);
	DECLARE Var_OpeInusualIDSPL	BIGINT(20);
	DECLARE Var_ErrMen			VARCHAR(400);
	DECLARE Var_RFCOficial		VARCHAR(13);

	-- Asignacion de Constantes
	SET	Estatus_Activo		:= 'A';			-- Estatus activo
	SET	Cadena_Vacia		:= '';			-- string Vacio
	SET	Fecha_Vacia			:= '1900-01-01';-- Fecha DEFAULT
	SET	Si					:= 'S';			-- Si
	SET	Fisica				:= 'F';			-- Persona Fisica
	SET	Moral				:= 'M';			-- Persona Moral
	SET	Entero_Cero			:= 0;			-- Entero Cero
	SET	Float_Vacio			:= 0.0;			-- Flotante Cero
	SET Vigente				:= 'V';
	SET Constante_No		:= 'N'; 		-- Constante NO
	SET Extranjero			:= 'E';			-- Nacionalidad Extranjera
	SET Salida_SI			:= 'S';			-- Salida SI
	SET	EsCliente			:= 'CTE';		-- Se trata de un cliente
	SET	EsUsServ			:= 'USU';		-- Se trata de un usuario de servicios
	SET	EsNA				:= 'NA';		-- No se trata ni de un cliente ni de un usuario de servicios
	SET EsRelacionado		:= 'REL';		-- Es relacionado a la cuenta
	SET Cons_Si				:= 'S';
	SET Mayusculas			:= 'MA';	   	-- Obtener el resultado en Mayusculas
    SET Num_Actualizar		:= 2;			-- opcion de Actualizacion del registro de firmas

	-- Asignacion de Variables
	SET	NumPersona			:= 0;			-- Numero de Persona Cero
	SET	Var_NombreCompleto	:= '';			-- Nombre Compelto vacio
	SET	SumaPor				:= 0;			-- Suma porcentaje
    SET SumaPorAcc			:= 0;			-- Suma de porcentaje de acciones
	SET	PorAnt				:= 0;			-- porcentaje anterior
    SET PorAntAcc			:= 0;			-- Porcentaje de acciones anterior
	SET PaisMexico			:= 700;			-- valor en la tabla de paise de Mexico
	SET Par_PrimerNom       := RTRIM(LTRIM(IFNULL(Par_PrimerNom, Cadena_Vacia)));
	SET Par_SegundoNom      := RTRIM(LTRIM(IFNULL(Par_SegundoNom, Cadena_Vacia)));
	SET Par_TercerNom       := RTRIM(LTRIM(IFNULL(Par_TercerNom, Cadena_Vacia)));
	SET Par_ApellidoPat     := RTRIM(LTRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia)));
	SET Par_ApellidoMat     := RTRIM(LTRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia)));
	SET Par_TelCel			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelCel, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
	SET Var_CampoGenerico	:= 0;
	SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
	SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
	SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
	SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas
	SET Var_SoloNombre			:=  FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Cadena_Vacia,Cadena_Vacia);
	SET Var_SoloApellido		:=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApellidoPat,Par_ApellidoMat);

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-CUENTASPERSONAMOD');
			SET VarControl := 'SQLEXCEPTION';
		END;

		IF(NOT EXISTS(SELECT PersonaID
					FROM CUENTASPERSONA
					WHERE PersonaID = Par_PersonaID)) THEN
			SET	Par_NumErr	:= 1;
			SET	Par_ErrMen	:= 'El Numero de Persona No existe.';
			SET VarControl:= 'personaID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_ClienteID > Entero_Cero)THEN
			SET Var_TipoPersonaCta := (SELECT Cli.TipoPersona	FROM	CLIENTES Cli
				WHERE 	Cli.ClienteID = Par_ClienteID
				LIMIT 1);
			ELSE
				SET Var_TipoPersonaCta := Fisica;
		END IF;

		IF(Par_EsBeneficiario=Si)THEN

			SET PorAnt:= (SELECT Porcentaje
					FROM CUENTASPERSONA
					WHERE PersonaID = Par_PersonaID
					AND CuentaAhoID=Par_CuentaAhoID AND EstatusRelacion = Vigente);

			SET SumaPor:= (SELECT (SUM(Porcentaje)-PorAnt)+Par_Porcentaje
				FROM CUENTASPERSONA
				WHERE CuentaAhoID=Par_CuentaAhoID AND EstatusRelacion = Vigente);

			IF(SumaPor>100)THEN
				SET	Par_NumErr	:= 2;
				SET	Par_ErrMen	:= 'El Porcentaje se excede.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:= 3;
			SET	Par_ErrMen	:= 'El numero de Cuenta de ahorro esta Vacio.';
			SET VarControl	:='cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT EsMenorEdad INTO Var_EsMenorEdad
			FROM CLIENTES
			WHERE ClienteID  = Par_ClienteID;

		IF(Var_TipoPersonaCta <> Moral) THEN

			IF(IFNULL(Par_Titulo, Cadena_Vacia) = Cadena_Vacia AND Var_EsMenorEdad != Si) THEN
				SET	Par_NumErr	:= 4;
				SET	Par_ErrMen	:= 'El Titulo esta Vacio.';
				SET VarControl	:= 'titulo';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr	:= 5;
				SET	Par_ErrMen	:= 'El Primer Nombre esta Vacio.';
				SET VarControl:= 'primerNom';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND
					IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := 'Se requiere al menos uno de los Apellidos.';
				SET Var_Control := 'apellidoParterno';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaNac, Fecha_Vacia)) = Fecha_Vacia THEN
				SET	Par_NumErr	:= 8;
				SET	Par_ErrMen	:= 'La fecha esta Vacia.';
				SET VarControl:= 'apellidoMat';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr	:= 9;
			SET	Par_ErrMen	:= 'La Nacionalidad esta vacia.';
			SET VarControl:= 'nacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero AND Var_EsMenorEdad != Si) THEN
			SET	Par_NumErr	:= 10;
			SET	Par_ErrMen	:= 'El Tipo de Identificacion esta Vacio.';
			SET VarControl:= 'tipoIdentiID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PaisRes, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr	:= 11;
			SET	Par_ErrMen	:= 'El Pais de Residencia esta Vacio.';
			SET VarControl:= 'paisRes';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EsApoderado=Si)THEN
			IF(IFNULL(Par_NumEscPub, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr	:= 12;
				SET	Par_ErrMen	:= 'El Pais de Residencia esta Vacio.';
				SET VarControl	:= 'esApoderado';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaEscPub, Fecha_Vacia)) = Fecha_Vacia THEN
				SET	Par_NumErr	:= 13;
				SET	Par_ErrMen	:= 'La Fecha de Escritura Publica esta Vacia.';
				SET VarControl:= 'fechaEscPub';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoPersonaCta <> Moral) THEN
				IF(IFNULL(Par_EstadoID, Entero_Cero))= Entero_Cero THEN
					SET	Par_NumErr	:= 14;
					SET	Par_ErrMen	:= 'El Estado esta Vacio.';
					SET VarControl:= 'estadoID';
					LEAVE ManejoErrores;
				END IF;

				IF(IFNULL(Par_MunicipioID, Entero_Cero))= Entero_Cero THEN
					SET	Par_NumErr	:= 15;
					SET	Par_ErrMen	:= 'El Municipio esta Vacio.';
					SET VarControl	:= 'municipioID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_NotariaID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr	:= 16;
				SET	Par_ErrMen	:= 'La Notaria esta Vacia.';
				SET VarControl	:= 'notariaID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TitularNotaria, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr	:= 17;
				SET	Par_ErrMen	:= 'El Titular de Notaria esta Vacio.';
				SET VarControl	:= 'titularNotaria';
				LEAVE ManejoErrores;
			END IF;

		 	IF(Var_TipoPersonaCta <> Moral AND Par_ClienteID != Entero_Cero) THEN

				IF(IFNULL(Par_PuestoA, Cadena_Vacia)) = Cadena_Vacia THEN
					SET	Par_NumErr	:= 18;
					SET	Par_ErrMen	:= 'El Puesto esta Vacio.';
					SET VarControl	:= 'puestoA';
					LEAVE ManejoErrores;
				END IF;
		 	END IF;
		END IF;

		IF(Par_EsBeneficiario=Si)THEN
			IF(IFNULL(Par_ParentescoID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr	:= 19;
				SET	Par_ErrMen	:= 'El Parentesco esta vacio.';
				SET VarControl	:= 'esBeneficiario';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Porcentaje, Float_Vacio)) = Float_Vacio THEN
				SET	Par_NumErr	:= 20;
				SET	Par_ErrMen	:= 'El Porcentaje esta Vacio.';
				SET VarControl	:= 'porcentaje';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_TipoPersonaCta = Fisica) THEN
			IF(IFNULL(Par_OcupacionID, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr	:= 21;
				SET	Par_ErrMen	:= 'La ocupacion esta vacia.';
				SET VarControl	:= 'tipoPersona';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_PaisNac, Entero_Cero)) = Entero_Cero THEN
			SET	Par_NumErr	:= 22;
			SET	Par_ErrMen	:= 'El pais especificado como el Lugar de Nacimiento esta vacio.';
			SET VarControl	:= 'paisNac';
			LEAVE ManejoErrores;
		ELSE
			SELECT PaisID INTO Var_PaisID FROM PAISES WHERE PaisID = Par_PaisNac;
			IF(IFNULL(Var_PaisID, Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr	:= 23;
				SET	Par_ErrMen	:= 'El pais especificado como el Lugar de Nacimiento no existe.';
				SET VarControl:= 'paisID';
				LEAVE ManejoErrores;
			ELSE
				IF(Var_PaisID)= PaisMexico THEN
					SELECT EstadoID INTO Var_EstadoID FROM ESTADOSREPUB WHERE EstadoID = Par_EdoNac;
					IF(IFNULL(Var_EstadoID, Entero_Cero))= Entero_Cero THEN
						SET	Par_NumErr	:= 23;
						SET	Par_ErrMen	:= 'El estado especificado como Entidad Federativa no existe.';
						SET VarControl:= 'paisID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;
		END IF;

		IF(Var_TipoPersonaCta = Moral) THEN
			SET Var_Domicilio		:= Par_DomicilioOfiPM;
			SET Var_FechaNac		:= Par_FechaRegistroPM;
			SET Var_RFC				:= Par_RFCpm;
			SET Var_PaisID			:= Par_PaisConstitucion;
			SET Var_Correo			:= Par_CorreoPM;
			SET Var_Telefono		:= Par_TelefonoPM;
			SET Var_ExtTelefono		:= Par_ExtTelefonoPM;
			SET Var_EstadoID		:= Par_EstadoID;
			SET Var_MunicipioID		:= Par_MunicipioID;
			SET Var_RazonSocial		:= Par_RazonSocialPM;
			SET Var_NombreCompleto 	:= Par_RazonSocialPM;
			SET Var_SoloNombres		:= Cadena_Vacia;
			SET Var_SoloApellidos	:= Cadena_Vacia;
			SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocialPM,'MA'),200);
			SET Var_Fea				:= Par_FeaPM;
			SET Var_PaisFea			:= Par_PaisFeaPM;
			SET Var_Telefono		:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Var_Telefono, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		ELSE

			SET Var_NombreCompleto  := FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
			SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom, Cadena_Vacia, Cadena_Vacia),'MA'),500);
			SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia, Cadena_Vacia, Par_ApellidoPat,Par_ApellidoMat),'MA'),500);
			SET Var_RazonSocialPLD	:= Cadena_Vacia;
			SET Var_Correo			:= Par_Correo;
			SET Var_Telefono		:= Par_TelCasa;
			SET Var_ExtTelefono		:= Par_ExtTelefonoPart;
			SET Var_Domicilio		:= Par_Domicilio;
			SET Var_EstadoID		:= Par_EstadoID;
			SET Var_MunicipioID		:= Par_MunicipioID;
			SET Var_RazonSocial		:= Par_RazonSocial;
			SET Var_FechaNac		:= Par_FechaNac;
			SET Var_RFC				:= Par_RFC;
			SET Var_PaisID			:= Par_PaisNac;
			SET Var_Fea				:= Par_FEA;
			SET Var_PaisFea			:= Par_PaisFEA;
			SET Var_Telefono		:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Var_Telefono, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		END IF;

		SELECT CP.NombreCompleto, CP.CuentaAhoID,PersonaID INTO Var_nombrePersona, Var_numeroCuenta, Var_PersonaID
			FROM	CUENTASPERSONA CP
			WHERE		CP.CuentaAhoID 				= Par_CuentaAhoID
			AND			CP.NombreCompleto 			= Var_NombreCompleto
			AND 		IFNULL(CP.ClienteID,Entero_Cero)	=IFNULL(Par_ClienteID,Entero_Cero)
			AND 		PersonaID 		= Par_PersonaID ;

		SET Var_numeroCuenta	:= IFNULL(Var_numeroCuenta, Entero_Cero);
		SET Var_PersonaID		:= IFNULL(Var_PersonaID, Entero_Cero);

		IF(Var_numeroCuenta != Entero_Cero AND Var_PersonaID != Par_PersonaID)THEN
			SET Var_nombrePersona:=IFNULL(Var_nombrePersona,Cadena_Vacia);
			SET	Par_NumErr	:= 21;
			SET	Par_ErrMen	:= CONCAT('La Persona ya esta relacionada a la Cuenta:', Var_numeroCuenta);
			SET VarControl:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		 IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Extranjero THEN
			IF(IFNULL( Par_PaisRFC, Entero_Cero) = Entero_Cero) THEN
				SET	Par_NumErr	:= 22;
				SET	Par_ErrMen	:= 'El Pais de Registro de RFC Esta Vacio';
				SET VarControl:= 'paisRFC';
				LEAVE ManejoErrores;
			ELSE
				IF NOT EXISTS(SELECT PaisID FROM PAISES WHERE PaisID = Par_PaisRFC)THEN
					SET	Par_NumErr	:= 23;
					SET	Par_ErrMen	:= 'El Pais de Registro de RFC No Existe';
					SET VarControl:= 'paisID';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		ELSE
			SET Par_PaisRFC := PaisMexico;
		END IF;

		IF(Par_EsAccionista=Cons_Si )THEN
			IF(Par_PorcentajeAcc = Float_Vacio OR Par_PorcentajeAcc> 100)THEN
				SET Par_NumErr  := 24;
				SET Par_ErrMen  :='El Porcentaje de Acciones debe ser mayor a Cero y menor de 100.';
				SET Var_Control := 'porcentajeAcc';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				SET PorAntAcc:= (SELECT PorcentajeAcciones
						FROM CUENTASPERSONA
						WHERE PersonaID = Par_PersonaID
						AND CuentaAhoID = Par_CuentaAhoID AND EstatusRelacion = Vigente);

				SET SumaPorAcc:= (SELECT (SUM(IFNULL(PorcentajeAcciones,Entero_Cero))-PorAntAcc)+Par_PorcentajeAcc
					FROM CUENTASPERSONA
					WHERE CuentaAhoID = Par_CuentaAhoID AND EstatusRelacion = Vigente);

				IF(SumaPorAcc>100)THEN
					SET	Par_NumErr	:= 25;
					SET	Par_ErrMen	:= 'El Porcentaje de Acciones Excede el 100%.';
                    SET Var_Control := 'porcentajeAcc';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET Aud_FechaActual := NOW();

		IF IFNULL(Par_ClienteID,Entero_Cero) != Entero_Cero THEN
			SET Var_TipoPers := EsCliente;
			SET Var_IdentificadorID := Par_ClienteID;
		ELSE
			SET Var_TipoPers := EsRelacionado;
			SET Var_IdentificadorID := Par_PersonaID;
		END IF;
		/*SECCION PLD: Deteccion de operaciones inusuales*/
		CALL PLDDETECCIONPRO(
			Var_IdentificadorID,	Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
			Par_ApellidoMat,		Var_TipoPersonaCta,		Par_RazonSocial,		Var_RFC,				Var_RFC,
			Par_FechaNac,			Par_CuentaAhoID,		Par_PaisNac,			Par_EstadoID,			Var_NombreCompleto,
			Var_TipoPers,			Cons_Si,				Cons_Si,				Cons_Si,				Constante_No,
			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
			SET Var_Control			:= 'avalID';
			LEAVE ManejoErrores;
		END IF;
		/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

		SELECT
			CP.EsFirmante
		INTO
			Var_EraFirmante
		FROM CUENTASPERSONA CP
		WHERE CP.CuentaAhoID = Par_CuentaAhoID
		AND CP.PersonaID = Par_PersonaID;

		IF(IFNULL(Par_EsFirmante, '') != IFNULL(Var_EraFirmante, '')) THEN
			CALL FIRMASIMPRESIONFITPRO(Par_CuentaAhoID, Num_Actualizar,	Constante_No, Par_NumErr, Par_ErrMen,
				Par_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
            END IF;
		END IF;

		UPDATE CUENTASPERSONA SET
			EsApoderado 	= Par_EsApoderado,
			EsTitular 		= Par_EsTitular,
			EsCotitular 	= Par_EsCotitular,
			EsBeneficiario 	= Par_EsBeneficiario,
			EsProvRecurso 	= Par_EsProvRecurso,
			EsPropReal 		= Par_EsPropReal,
			EsFirmante 		= Par_EsFirmante,
			Titulo 			= Par_Titulo,
			PrimerNombre 	= Par_PrimerNom,
			SegundoNombre 	= Par_SegundoNom,
			TercerNombre 	= Par_TercerNom,
			ApellidoPaterno = Par_ApellidoPat,
			ApellidoMaterno = Par_ApellidoMat,
			NombreCompleto 	= Var_NombreCompleto,
			FechaNac 		= Var_FechaNac,
			PaisNacimiento	= Var_PaisID,
			EdoNacimiento	= Par_EdoNac,
			EstadoCivil 	= Par_EdoCivil,
			Sexo 			= Par_Sexo,
			Nacionalidad 	= Par_Nacion,
			CURP 			= Par_CURP,
			RFC 			= Var_RFC,
			OcupacionID		= Par_OcupacionID,
			FEA				= Var_Fea,
			PaisFEA			= Var_PaisFea,
			PaisRFC			= Par_PaisRFC,
			PuestoA			= Par_PuestoA,
			SectorGeneral 	= Par_SectorGral,
			ActividadBancoMX= Par_ActBancoMX,
			ActividadINEGI 	= Par_ActINEGI,
			SectorEconomico = Par_SecEcono,
			TipoIdentiID 	= Par_TipoIdentiID,
			OtraIdentifi 	= Par_OtraIden,
			NumIdentific 	= Par_NumIden,
			FecExIden 		= Par_FecExIden,
			FecVenIden 		= Par_FecVenIden,
			Domicilio 		= Par_Domicilio,
			TelefonoCasa 	= Var_Telefono,
			TelefonoCelular = Par_TelCel,
			Correo 			= Var_Correo,
			PaisResidencia 	= Par_PaisRes,
			DocEstanciaLegal= Par_DocEstLegal,
			DocExisLegal	= Par_DocExisLegal,
			FechaVenEst 	= Par_FechaVenEst,
			NumEscPub 		= Par_NumEscPub,
			FechaEscPub 	= Par_FechaEscPub,
			EstadoID 		= Var_EstadoID,
			MunicipioID 	= Var_MunicipioID,
			NotariaID 		= Par_NotariaID,
			TitularNotaria 	= Par_TitularNotaria,
			RazonSocial 	= Var_RazonSocial,
			Fax 			= Par_Fax,
			ParentescoID	= Par_ParentescoID,
			Porcentaje 		= Par_Porcentaje,
			ClienteID		= Par_ClienteID,
			ExtTelefonoPart = Var_ExtTelefono,
			IngresoRealoRecur	= Par_IngreRealoRecur,

			EsAccionista		= Par_EsAccionista,
			PorcentajeAcciones 	= Par_PorcentajeAcc,
			SoloNombres			= Var_SoloNombres,
			SoloApellidos		= Var_SoloApellidos,
			RazonSocialPLD		= Var_RazonSocialPLD,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE CuentaAhoID = Par_CuentaAhoID
			AND	PersonaID = Par_PersonaID;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('La Persona Relacionada a la Cuenta: ', CONVERT(Par_CuentaAhoID, CHAR), ' Modificada Exitosamente');
		SET VarControl:= 'personaID' ;
		SET Var_Consecutivo := Par_PersonaID;


	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS Control,
				Var_Consecutivo AS Consecutivo,
				Var_CampoGenerico AS CampoGenerico;
	END IF;


END TerminaStore$$

