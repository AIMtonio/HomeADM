
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERVICIOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERVICIOALT`;

DELIMITER $$
CREATE PROCEDURE `USUARIOSERVICIOALT`(
# ============ SP para realizar alta de Usuarios de Servicios =============
	Par_TipoPersona   			CHAR(1),
	Par_PrimerNombre       		VARCHAR(50),
	Par_SegundoNombre      		VARCHAR(50),
	Par_TercerNombre       		VARCHAR(50),
	Par_ApPaterno	     		VARCHAR(50),

	Par_ApMaterno	     		VARCHAR(50),
	Par_FechaNac        		DATE,
	Par_Nacion          		CHAR(1),
	Par_PaisNac	        		INT,
	Par_EstadoNac        		INT,

	Par_Sexo            		CHAR(1),
	Par_CURP            		CHAR(18),
	Par_RazonSocial     		VARCHAR(150),
	Par_TipoSocID       		INT,
	Par_RFC             		CHAR(13),

	Par_RFCpm           		CHAR(13),
	Par_FEA						VARCHAR(250),
	Par_FechaCons				DATE,
	Par_PaisRFC	        		INT,
	Par_OcupacionID     		INT,

	Par_Correo          		VARCHAR(50),
	Par_TelefonoCel     		VARCHAR(20),
	Par_Telefono        		VARCHAR(20),
	Par_ExtTelefono				VARCHAR(7),
	Par_SucursalOri				INT(11),

	Par_PaisResi        		INT(11),
	Par_TipoDirecID        		INT(11),
	Par_EstadoID				INT(11),
	Par_MunicipioID				INT(11),
	Par_LocalidadID 			INT(11),

	Par_ColoniaID 				INT(11),
	Par_Calle					VARCHAR(50),
	Par_NumeroCasa				CHAR(10),
	Par_NumInterior				CHAR(10),
	Par_CP 						CHAR(5),

	Par_Piso					VARCHAR(50),
	Par_Manzana					VARCHAR(50),
	Par_Lote					VARCHAR(50),
	Par_TipoIdentID				INT(11),
	Par_NumIdenti				VARCHAR(30),

	Par_FecExIden				DATE,
	Par_FecVenIden   			DATE,
	Par_DocEstLegal 			VARCHAR(3),
	Par_DocExisLegal			VARCHAR(20),
	Par_FechaVenEst				DATE,

	Par_NivelRiesgo				CHAR(1),		-- Nivel de Riesgo del Usuario de Servicio: B.- Bajo M.- Medio A.- Alto
	Par_Salida    				CHAR(1),
	INOUT	Par_NumErr 			INT(11),
	INOUT	Par_ErrMen  		VARCHAR(400),
	INOUT 	Par_UsuarioID  		INT(11),

	Par_EmpresaID       		INT(11),
	Aud_Usuario         		INT(11),
	Aud_FechaActual     		DATETIME,
	Aud_DireccionIP     		VARCHAR(15),
	Aud_ProgramaID      		VARCHAR(50),

	Aud_Sucursal        		INT(11),
	Aud_NumTransaccion  		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_NomCompleto			VARCHAR(200);
DECLARE Var_MaxCaracter			INT;
DECLARE Var_RFCOficial			CHAR(13);

DECLARE	Var_DirCompleta			VARCHAR(500);
DECLARE	Var_NomColonia			VARCHAR(200);
DECLARE	Var_NomMunicipio		VARCHAR(200);
DECLARE	Var_NomEstado			VARCHAR(200);
DECLARE varEstadoID				INT(11);
DECLARE Var_CampoGenerico		INT(11);
DECLARE	Var_SoloNombres			VARCHAR(500);
DECLARE	Var_SoloApellidos		VARCHAR(500);
DECLARE	Var_RazonSocialPLD		VARCHAR(200);

-- Declaracion de Constantes
DECLARE	Estatus_Activo			CHAR(1);
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT;
DECLARE	PaisMex					INT;
DECLARE Salida_SI 				CHAR(1);
DECLARE Salida_NO 				CHAR(1);
DECLARE	Per_Fisica				CHAR(1);
DECLARE	Per_ActEmp				CHAR(1);
DECLARE	Per_Moral				CHAR(1);
DECLARE nacionalidadMex			CHAR(1);
DECLARE nacionalidadExt			CHAR(1);
DECLARE MinCaracter				INT;
DECLARE MaxCaracter				INT;
DECLARE Var_FechaSis			DATE;
DECLARE	NumeroUsuario			INT;
DECLARE TipoOperaAlt			INT;
DECLARE	EsNA					VARCHAR(3);
DECLARE	Cons_Si					CHAR(1);
DECLARE	Constante_No			CHAR(1);
DECLARE Var_Control				VARCHAR(50);
DECLARE Alta_UsuariosServ		INT(11);				# Alta de Usuarios de Servicios


-- Asignacion de Constantes
SET	Estatus_Activo				:= 'A';				-- Estatus Activo
SET	Cadena_Vacia				:= '';				-- Cadena o String vacio
SET	Fecha_Vacia					:= '1900-01-01';	-- Fecha vacia
SET	Entero_Cero					:= 0;				-- Entero en Cero
SET	PaisMex						:= 700;				-- Valor PaÃ­s Mexico Tabl Paises
SET	Salida_SI 	 				:= 'S';				-- Valor Salida Si
SET	Salida_NO 	 				:= 'N';				-- Valor Salida No
SET	Per_Fisica					:= 'F';				-- Tipo de Persona: Fisica
SET	Per_ActEmp					:= 'A';				-- Tipo de Persona: Fisica con Actividad Empresarial
SET	Per_Moral					:= 'M';				-- Tipo de Persona: Moral

SET nacionalidadMex				:= 'N';				-- Nacionalidad Mexicana
SET nacionalidadExt				:= 'E';				-- Nacionalidad Extranjera

SET MinCaracter					:= 5;				-- Numero de Caracateres minimo para el Numero de IdentIFicacion (CARTILLA, LICENCIA, CEDULA)
SET MaxCaracter					:= 15;				-- Numero de Caracateres maximo para el Numero de IdentIFicacion (CARTILLA, LICENCIA, CEDULA)
SET	NumeroUsuario				:= 0;				-- Valor 0 para dar de alta nuevo cliente
SET	TipoOperaAlt				:= 10;				-- Tipo Operacion Alta
SET	EsNA						:= 'NA';			-- No se trata ni de un cliente ni de un usuario de servicios (por que no se completa el registro)
SET Var_CampoGenerico			:= 0;
SET Cons_Si						:= 'S';
SET Constante_No				:= 'N';
SET Alta_UsuariosServ			:= 5;				-- Alta de Usuarios de Servicios

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
							'esto le ocasiona. Ref: SP-USUARIOSERVICIOALT');
		SET Var_Control	:= 'sqlException';
	END;

	-- INICIALIZACION
	SET Aud_FechaActual		:= NOW();

	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

	SET NumeroUsuario := (SELECT IFNULL(MAX(UsuarioServicioID),Entero_Cero) + 1 FROM USUARIOSERVICIO);

	SET Par_PrimerNombre    := RTRIM(LTRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
	SET Par_SegundoNombre   := RTRIM(LTRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
	SET Par_TercerNombre    := RTRIM(LTRIM(IFNULL(Par_TercerNombre, Cadena_Vacia)));
	SET Par_ApPaterno     	:= RTRIM(LTRIM(IFNULL(Par_ApPaterno, Cadena_Vacia)));
	SET Par_ApMaterno	  	:= RTRIM(LTRIM(IFNULL(Par_ApMaterno, Cadena_Vacia)));

	SET Par_PrimerNombre	:= UPPER(Par_PrimerNombre);
	SET Par_SegundoNombre	:= UPPER(Par_SegundoNombre);
	SET Par_TercerNombre	:= UPPER(Par_TercerNombre);
	SET Par_ApPaterno		:= UPPER(Par_ApPaterno);
	SET Par_ApMaterno		:= UPPER(Par_ApMaterno);

	SET	Par_RFC				:= UPPER(Par_RFC);
	SET	Par_CURP			:= UPPER(Par_CURP);
	SET Par_Calle			:= UPPER(Par_Calle);
	SET Par_NumIdenti		:= UPPER(Par_NumIdenti);

	SET Par_Lote 			:= IFNULL(Par_Lote, Cadena_Vacia);
	SET Par_Manzana 		:= IFNULL(Par_Manzana, Cadena_Vacia);
	SET Par_Piso 			:= IFNULL(Par_Piso, Cadena_Vacia);

	# Validacion de Campos
	IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Tipo de Persona esta Vacio.';
		SET Var_Control	:= 'tipoPersona1';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PrimerNombre, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El Primer Nombre esta Vacio.';
		SET Var_Control	:= 'primerNombre';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ApPaterno, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Apellido Paterno esta Vacio.';
		LEAVE ManejoErrores;
		SET Var_Control	:= 'apellidoPaterno';
	END IF;

	IF(IFNULL(Par_FechaNac, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := 'La Fecha de Nacimiento esta Vacia.';
		SET Var_Control	:= 'fechaNacimiento';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 005;
		SET Par_ErrMen := 'La Nacionalidad esta Vacia.';
		SET Var_Control	:= 'nacion';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PaisNac, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := 'El Pais de Nacimiento esta Vacio.';
		SET Var_Control	:= 'paisNacimiento';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_PaisNac
							LIMIT 1)THEN
			SET Par_NumErr := 007;
			SET Par_ErrMen := 'El Valor Indicado del Pais de Nacimiento No Existe.';
			SET Var_Control	:= 'paisNacimiento';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_PaisNac, Entero_Cero)) = PaisMex THEN
		IF(IFNULL(Par_EstadoNac, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 008;
			SET Par_ErrMen := 'El Estado de Nacimiento esta Vacio.';
			SET Var_Control	:= 'estadoNac';
			LEAVE ManejoErrores;
		ELSE
			IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
							WHERE EstadoID = Par_EstadoNac
								LIMIT 1)THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'El Valor Indicado del Estado de Nacimiento No Existe.';
				SET Var_Control	:= 'estadoNac';
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 010;
		SET Par_ErrMen := 'El Sexo esta Vacio.';
		SET Var_Control	:= 'sexo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CURP, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 011;
		SET Par_ErrMen := 'La CURP esta Vacia.';
		SET Var_Control	:= 'CURP';
		LEAVE ManejoErrores;
	ELSE
		IF EXISTS(SELECT CURP FROM USUARIOSERVICIO
						WHERE CURP = Par_CURP
							LIMIT 1)THEN
			SET Par_NumErr := 012;
			SET Par_ErrMen := 'CURP Asociado a otro Usuario.';
			SET Var_Control	:= 'CURP';
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
		-- Valida RFC
		IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := 'El RFC esta Vacio.';
			SET Var_Control	:= 'RFC';
			LEAVE ManejoErrores;
		ELSE
			IF EXISTS(SELECT RFC FROM USUARIOSERVICIO
						WHERE RFC = Par_RFC
							LIMIT 1)THEN
				SET Par_NumErr := 014;
				SET Par_ErrMen := 'RFC Asociado con otro Usuario.';
				SET Var_Control	:= 'RFC';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_OcupacionID, Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'La Ocupacion esta Vacia.';
			SET Var_Control	:= 'ocupacionID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_NomCompleto		:= FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Par_ApPaterno,Par_ApMaterno);
		SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre, Par_TercerNombre, Cadena_Vacia, Cadena_Vacia),'MA'),500);
		SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia, Cadena_Vacia, Par_ApPaterno, Par_ApMaterno),'MA'),500);
		SET Var_RazonSocialPLD	:= Cadena_Vacia;
		SET Var_RFCOficial		:= Par_RFC;
	END IF;

	IF(Par_TipoPersona = Per_Moral) THEN
		-- Valida RFC
		IF(IFNULL(Par_RFCpm, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 013;
			SET Par_ErrMen := 'El RFC esta Vacio.';
			SET Var_Control	:= 'RFCpm';
			LEAVE ManejoErrores;
		ELSE
			IF EXISTS(SELECT RFC FROM USUARIOSERVICIO
						WHERE RFC = Par_RFCpm
							LIMIT 1)THEN
				SET Par_NumErr := 014;
				SET Par_ErrMen := 'RFC Asociado con otro Usuario.';
				SET Var_Control	:= 'RFCpm';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Valida RazonSocial
		IF(IFNULL(Par_RazonSocial, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 016;
			SET Par_ErrMen := 'La Razon Social esta Vacia.';
			SET Var_Control	:= 'razonSocial';
			LEAVE ManejoErrores;
		END IF;

		-- Valida Par_TipoSocID
		IF(IFNULL(Par_TipoSocID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 017;
			SET Par_ErrMen := 'El Tipo de Sociedad esta Vacio.';
			SET Var_Control	:= 'tipoSociedadID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_NomCompleto		:= Par_RazonSocial;
		SET Var_SoloNombres		:= Cadena_Vacia;
		SET Var_SoloApellidos	:= Cadena_Vacia;
		SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocial,'MA'),200);
		SET Var_RFCOficial		:= Par_RFCpm;
	END IF;

	IF((Par_TipoPersona = Per_Moral OR Par_TipoPersona = Per_ActEmp) AND (Par_Nacion = nacionalidadMex)) THEN
		IF((IFNULL(Par_FechaCons,Fecha_Vacia) = Fecha_Vacia) OR (IFNULL(Par_FechaCons,Cadena_Vacia) = Cadena_Vacia)) THEN
			SET Par_NumErr := 018;
			SET Par_ErrMen :=	'La Fecha de Constitucion esta Vacia.';
			SET Var_Control	:= 'fechaConstitucion';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_Nacion = nacionalidadExt) THEN
		IF( IFNULL(Par_PaisRFC,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 019;
			SET Par_ErrMen :=	'El Pais que Asigna el RFC esta Vacio.';
			SET Var_Control	:= 'paisRFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Por lo menos uno de los tres es requerido: Telefono de Casa, Telefono Celular o Correo Electronico
	IF((IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia) AND (IFNULL(Par_Correo,Cadena_Vacia) = Cadena_Vacia))THEN
		IF(IFNULL(Par_TelefonoCel,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_NumErr := 020;
			SET Par_ErrMen := 'El Telefono Celular es Requerido.';
			SET Var_Control	:= 'telefonoCelular';
			LEAVE ManejoErrores;
		END IF;
	ELSE
		IF((IFNULL(Par_TelefonoCel,Cadena_Vacia) = Cadena_Vacia) AND (IFNULL(Par_Correo,Cadena_Vacia) = Cadena_Vacia))THEN
			IF(IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 021;
				SET Par_ErrMen := 'El Telefono es Requerido.';
				SET Var_Control	:= 'telefonoCasa';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF((IFNULL(Par_Telefono,Cadena_Vacia) = Cadena_Vacia) AND (IFNULL(Par_TelefonoCel,Cadena_Vacia) = Cadena_Vacia))THEN
				IF(IFNULL(Par_Correo,Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr := 022;
					SET Par_ErrMen := 'El Correo Electronico es Requerido.';
					SET Var_Control	:= 'correo';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Par_SucursalOri, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr := 023;
		SET Par_ErrMen := 'La Sucursal de Origen esta vacia.';
		SET Var_Control	:= 'sucursalOrigen';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PaisResi, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 024;
		SET Par_ErrMen := 'El Pais de Residencia esta Vacio.';
		SET Var_Control	:= 'paisResidencia';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_PaisResi
						LIMIT 1)THEN
			SET Par_NumErr		:= 025;
			SET Par_ErrMen		:= 'El Valor Indicado del Pais de Residencia No Existe.';
			SET Var_Control	:= 'paisResidencia';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoDirecID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 026;
		SET Par_ErrMen := 'El Tipo de Direccion esta Vacio.';
		SET Var_Control	:= 'estadoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 027;
		SET Par_ErrMen := 'El Estado esta Vacio.';
		SET Var_Control	:= 'estadoID';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
						WHERE EstadoID = Par_EstadoID
							LIMIT 1)THEN
			SET Par_NumErr := 028;
			SET Par_ErrMen := 'El Valor Indicado del Estado No Existe.';
			SET Var_Control	:= 'estadoID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 029;
		SET Par_ErrMen := 'El Municipio esta Vacio.';
		SET Var_Control	:= 'municipioID';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
			WHERE MunicipioID = Par_MunicipioID
			AND EstadoID = Par_EstadoID
			LIMIT 1)THEN
			SET Par_NumErr := 030;
			SET Par_ErrMen := 'El Municipio Indicado No Existe.';
			SET Var_Control	:= 'municipioID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 031;
		SET Par_ErrMen := 'La Localidad esta Vacia.';
		SET Var_Control := 'localidadID';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
						WHERE LocalidadID = Par_LocalidadID
							AND EstadoID = Par_EstadoID
							AND MunicipioID = Par_MunicipioID
							LIMIT 1)THEN
			SET Par_NumErr := 032;
			SET Par_ErrMen := 'El Valor Indicado para la Localidad No Existe.';
			SET Var_Control	:= 'localidadID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 033;
		SET Par_ErrMen := 'La Colonia esta Vacia.';
		SET Var_Control	:= 'coloniaID';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
			WHERE EstadoID = Par_EstadoID
			AND MunicipioID = Par_MunicipioID
			AND ColoniaID = Par_ColoniaID
			LIMIT 1)THEN
			SET Par_NumErr	:= 034;
			SET Par_ErrMen	:= 'El Valor Indicado para la Colonia No Existe.';
			SET Var_Control	:= 'coloniaID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 035;
		SET Par_ErrMen := 'La Calle esta Vacia.';
		SET Var_Control	:= 'calle';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Lote = Cadena_Vacia AND Par_Manzana = Cadena_Vacia) THEN
		IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
			SET	Par_NumErr := 036;
			SET	Par_ErrMen := 'El Numero Exterior esta Vacio.' ;
			SET Var_Control	:= 'numExterior';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_CP, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr := 037;
		SET	Par_ErrMen := 'El Codigo Postal esta Vacio.' ;
		SET Var_Control	:= 'CP';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoIdentID, Entero_Cero)) = Entero_Cero THEN
		SET	Par_NumErr := 038;
		SET	Par_ErrMen := 'La Identificacion esta Vacia.' ;
		SET Var_Control	:= 'tipoIdentiID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NumIdenti, Cadena_Vacia)) = Cadena_Vacia THEN
		SET	Par_NumErr := 039;
		SET	Par_ErrMen := 'El Numero de Identificacion esta Vacio.' ;
		SET Var_Control	:= 'numIdentIFic';
		LEAVE ManejoErrores;
	ELSE
		SELECT NumeroCaracteres INTO Var_MaxCaracter
			FROM TIPOSIDENTI
				WHERE TipoIdentiID = Par_TipoIdentID;
		-- ELECTOR -- PASAPORTE
		IF(Par_TipoIdentID <= 2)THEN
			IF(CHARACTER_LENGTH(Par_NumIdenti) != Var_MaxCaracter)THEN
				SET Par_NumErr		:= 040;
				SET Par_ErrMen		:= CONCAT('Se requieren ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
				SET Var_Control	:= 'numIdentIFic';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			-- CARTILLA,LICENCIA,CEDULA
			IF(CHARACTER_LENGTH(Par_NumIdenti) < MinCaracter)THEN
				SET Par_NumErr		:= 041;
				SET Par_ErrMen		:= 'Se requieren Minimo 5 Caracteres para el Numero de Identificacion.';
				SET Var_Control	:= 'numIdentIFic';
				LEAVE ManejoErrores;
			ELSE
				IF(CHARACTER_LENGTH(Par_NumIdenti) > MaxCaracter)THEN
					SET Par_NumErr		:= 042;
					SET Par_ErrMen		:= 'Se requieren Maximo 15 Caracteres para el Numero de Identificacion.';
					SET Var_Control	:= 'numIdentIFic';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
	END IF;

	IF(IFNULL(Par_FecExIden, Fecha_Vacia) <> Fecha_Vacia) THEN
		IF(DATEDIFF(Var_FechaSis, Par_FecExIden) < Entero_Cero)THEN
			SET	Par_NumErr := 043;
			SET	Par_ErrMen := 'La Fecha de Expedicion es Mayor a la Fecha Actual.' ;
			SET Var_Control	:= 'fecExIden';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_FecVenIden, Fecha_Vacia) <> Fecha_Vacia) THEN
		IF(DATEDIFF(Var_FechaSis, Par_FecVenIden) > Entero_Cero)THEN
			SET	Par_NumErr := 044;
			SET	Par_ErrMen := 'La Fecha de Vencimiento es Menor a la Fecha Actual.' ;
			SET Var_Control	:= 'fecVenIden';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_NivelRiesgo, Cadena_Vacia) = Cadena_Vacia) THEN
		SET	Par_NumErr 	:= 045;
		SET	Par_ErrMen 	:= 'El Nivel de Riesgo se encuentra Vacio.';
		SET Var_Control	:= 'nivelRiesgo';
		LEAVE ManejoErrores;
	END IF;

	SELECT est.Nombre INTO Var_NomEstado
		FROM ESTADOSREPUB est
			WHERE est.EstadoID = Par_EstadoID;

	SELECT mun.Nombre INTO Var_NomMunicipio
		FROM MUNICIPIOSREPUB mun
			WHERE mun.EstadoID = Par_EstadoID
				AND mun.MunicipioID = Par_MunicipioID;

	SELECT col.Asentamiento INTO Var_NomColonia
		FROM COLONIASREPUB col
			WHERE col.EstadoID = Par_EstadoID
			AND col.MunicipioID = Par_MunicipioID
			AND col.ColoniaID = Par_ColoniaID
			LIMIT 1;

	IF(Par_Calle != Cadena_Vacia) THEN
		SET Var_DirCompleta := Par_Calle;
	END IF;

	IF(Par_NumeroCasa != Cadena_Vacia) THEN
		SET Var_DirCompleta := CONCAT(Var_DirCompleta,", No. ",Par_NumeroCasa);
	END IF;

	IF(Par_NumInterior != Cadena_Vacia) THEN
		SET Var_DirCompleta := CONCAT(Var_DirCompleta,", No. ",Par_NumInterior);
	END IF;

	IF(Par_Piso != Cadena_Vacia) THEN
		SET Var_DirCompleta := CONCAT(Var_DirCompleta,", PISO ",Par_Piso);
	END IF;

	IF(Par_Lote != Cadena_Vacia) THEN
		SET Var_DirCompleta := CONCAT(Var_DirCompleta,", LOTE ",Par_Lote);
	END IF;

	IF(Par_Manzana != Cadena_Vacia) THEN
		SET Var_DirCompleta := CONCAT(Var_DirCompleta,", MANZANA ",Par_Manzana);
	END IF;

	SET Var_DirCompleta := CONCAT(Var_DirCompleta,", COL. ",Var_NomColonia,", C.P ",Par_CP,", ",Var_NomMunicipio,", ",Var_NomEstado);

	/*SECCION PLD: Deteccion de operaciones inusuales*/
	CALL PLDDETECCIONPRO(
		Entero_Cero,			Par_PrimerNombre,			Par_SegundoNombre,			Par_TercerNombre,			Par_ApPaterno,
		Par_ApMaterno,			Par_TipoPersona,			Par_RazonSocial,			Par_RFC,					Par_RFCpm,
		Par_FechaNac,			Entero_Cero,				Par_PaisNac,				Par_EstadoID,				Var_NomCompleto,
		EsNA,					Cons_Si,					Cons_Si,					Cons_Si,					Constante_No,
		Par_NumErr,				Par_ErrMen,					Par_EmpresaID,				Aud_Usuario,				Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
		SET Par_ErrMen			:= Par_ErrMen;
		SET Var_Control			:= 'agrega';
		LEAVE ManejoErrores;
	END IF;
	/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

	INSERT INTO USUARIOSERVICIO(
		UsuarioServicioID,	TipoPersona,		PrimerNombre,		SegundoNombre,		TercerNombre,
		ApellidoPaterno,	ApellidoMaterno,	FechaNacimiento,	Nacionalidad,		PaisNacimiento,
		EstadoNacimiento,	Sexo,				CURP,				RazonSocial,		TipoSociedadID,
		RFC,				RFCpm,				RFCOficial,			FEA,				FechaConstitucion,
		PaisRFC,			OcupacionID,		Correo,				TelefonoCelular,	Telefono,
		ExtTelefonoPart,	NombreCompleto,		SucursalOrigen,		PaisResidencia,		TipoDireccionID,
		EstadoID,			MunicipioID,		LocalidadID,		ColoniaID,			Calle,
		NumExterior,		NumInterior,		CP,					Piso,				Manzana,
		Lote,				DirCompleta,		TipoIdentiID,		NumIdenti,			FecExIden,
		FecVenIden,			DocEstanciaLegal,	DocExisLegal,		FechaVenEst,		NivelRiesgo,
		SoloNombres,		SoloApellidos,		RazonSocialPLD,		EmpresaID,			Usuario,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
	VALUES (
		NumeroUsuario,		Par_TipoPersona,	Par_PrimerNombre,	Par_SegundoNombre,	Par_TercerNombre,
		Par_ApPaterno,		Par_ApMaterno,		Par_FechaNac,		Par_Nacion,			Par_PaisNac,
		Par_EstadoNac,		Par_Sexo,			Par_CURP,			Par_RazonSocial,	Par_TipoSocID,
		Par_RFC,			Par_RFCpm,			Var_RFCOficial,		Par_FEA,			Par_FechaCons,
		Par_PaisRFC,		Par_OcupacionID,	Par_Correo,			Par_TelefonoCel,	Par_Telefono,
		Par_ExtTelefono,	Var_NomCompleto,	Par_SucursalOri,	Par_PaisResi,		Par_TipoDirecID,
		Par_EstadoID,		Par_MunicipioID,	Par_LocalidadID,	Par_ColoniaID,		Par_Calle,
		Par_NumeroCasa,		Par_NumInterior,	Par_CP,				Par_Piso,			Par_Manzana,
		Par_Lote,			Var_DirCompleta,	Par_TipoIdentID,	Par_NumIdenti,		Par_FecExIden,
		Par_FecVenIden,		Par_DocEstLegal,	Par_DocExisLegal,	Par_FechaVenEst,	Par_NivelRiesgo,
		Var_SoloNombres,	Var_SoloApellidos,	Var_RazonSocialPLD,	Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
	CALL BITACORAHISTPERSALT(
		Aud_NumTransaccion,			Alta_UsuariosServ,		NumeroUsuario,				Entero_Cero,			Entero_Cero,
		Entero_Cero,				Salida_No,				Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;
	/*FIN de Respaldo de Bitacora Historica ########################################################################################### */

	SET	Par_NumErr	:= 000;
	SET	Par_ErrMen	:= CONCAT("Usuario Agregado Exitosamente: ", CONVERT(NumeroUsuario, CHAR));
	SET Var_Control	:= 'usuarioID';
	SET NumeroUsuario := NumeroUsuario;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT 	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			NumeroUsuario AS Consecutivo,
			Var_CampoGenerico AS CampoGenerico;
END IF;

IF(Par_Salida = Salida_NO) THEN
	SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
	SET Par_ErrMen := Par_ErrMen;
	SET Par_UsuarioID := NumeroUsuario;
END IF;

END TerminaStore$$

