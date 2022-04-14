-- SP REMITENTESUSUARIOSERVALT

DELIMITER ;

DROP PROCEDURE IF EXISTS `REMITENTESUSUARIOSERVALT`;

DELIMITER $$

CREATE PROCEDURE `REMITENTESUSUARIOSERVALT` (
-- ==================================================================
-- ---- STORE PARA DAR DE ALTA REMITENTES DE USUARIO DE SERVICIO ----
-- ==================================================================
	Par_UsuarioServicioID	INT(11),		-- Numero de Usuario de Servicio
	Par_Titulo				VARCHAR(10),	-- Titulo del Remitente  Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc
	Par_TipoPersona			CHAR(2),		-- Tipo de Persona del Remitente, corresponde a la tabla CATTIPOSPERSONA
	Par_NombreCompleto		VARCHAR(200),	-- Nombre Completo del Remitente
	Par_FechaNacimiento		DATE,			-- Fecha de Nacimiento del Remitente

	Par_PaisNacimiento		INT(11),		-- Pais de Nacimiento del Remitente, corresponde a la tabla PAISES
	Par_EdoNacimiento		INT(11), 		-- Estado de nacimiento del Remitente,corresponde a la tabla ESTADOSREPUB
	Par_EstadoCivil			CHAR(2),		-- Clave Estado Civil del Remitente
	Par_Sexo 				CHAR(1),		-- Codigo de sexo del Remitent: M = Masculino F  = Femenino
	Par_CURP				CHAR(18),		-- Clave Unica de Registro de Poblacion

	Par_RFC					CHAR(13),		-- Registro Federal de Contribuyente
	Par_FEA 				VARCHAR(250),	-- Firma Electrónica Avanzada, en caso de contar con ella
	Par_PaisFEA				INT(11),		-- Pais que Asigna la Firma Electrónica Avanzada
    Par_OcupacionID			INT(11),		-- Ocupacion del Remitente, corrresponde a la tabla OCUPACIONES
	Par_Puesto				VARCHAR(100),	-- Puesto del Remitente

	Par_SectorID 			INT(11),		-- Sector General del Remitente, corresponde a la tabla SECTORES
	Par_ActividadBMXID		VARCHAR(15),	-- Actividad Principal del Remitente, segun Banco de Mexico, corresponde a la tabla ACTIVIDADESBMX
	Par_ActividadINEGIID	INT(11),		-- Actividad Principal del Remitente, segun INEGI, corresponde a la tabla ACTIVIDADESINEGI
	Par_SectorEcoID			INT(11),		-- Sector Economico Segun INEGI,Llave Foranea Hacia tabla SECTORESECONOM
	Par_TipoIdentiID		INT(11),		-- Tipo de identificacion que usa el Remitente, corresponde a la tabla TIPOSIDENTI

	Par_NumIdentific		VARCHAR(20), 	-- Numero de Identificacion del Remitente
	Par_FecExIden			DATE,			-- Fecha de expedicion de la identificacion
	Par_FecVenIden			DATE,			-- Fecha de vencimiento de la identificacion
	Par_TelefonoCasa		VARCHAR(20),	-- Telefono de casa del Remitente
	Par_ExtTelefonoPart		VARCHAR(6), 	-- Contiene el número de extensión del teléfono

	Par_TelefonoCelular		VARCHAR(20),	-- Telefono de celular del Remitente
	Par_Correo				VARCHAR(50),	-- Correo electronico de Remitente
	Par_Domicilio			VARCHAR(200), 	-- Domicilio del Remitente
	Par_Nacionalidad		CHAR(1),		-- Nacionalidad del Remitente\nN = Nacional\nE = Extranjero
	Par_PaisResidencia		INT(11),		-- Pais de Nacimiento del Remitente, corresponde a la tabla PAISES

	Par_Salida				CHAR(1),		-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de entrada/salida de mensaje de control de respuesta

	Par_EmpresaID       	INT(11),		-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),		-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de Auditoria Numero de la Transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Variable de control
	DECLARE	Var_RemitenteID			BIGINT(12);			-- Variable para almacenar el Numero Consecutivo del Remitente
    DECLARE Var_FechaSistema		DATE;				-- Fecha de sistema
    DECLARE Var_Estatus				CHAR(1);			-- Estatus del Usuario de Servicio

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);			-- Constante Cadena Vacia
	DECLARE Entero_Cero				INT(1);				-- Entero Cero
	DECLARE Decimal_Cero			DECIMAL(12,2);		-- Decimal Cero
	DECLARE Fecha_Vacia				DATE;				-- Constante para fecha vacia
    DECLARE Salida_SI				CHAR(1);			-- Salida: SI

    DECLARE Salida_NO				CHAR(1);			-- Salida: NO
    DECLARE ConstanteNO				CHAR(1);			-- Constante: NO
    DECLARE ConstanteSI				CHAR(1);			-- Constante: SI
    DECLARE DefaultPais 			INT(11);			-- Pais de Nacimiento del Remitente, corresponde a la tabla PAISES
    DECLARE DefaultOcupacion		INT(11);			-- Ocupacion del Remitente, corrresponde a la tabla OCUPACIONES

	DECLARE DefaultActividadBMX		VARCHAR(15);		-- Actividad Principal del Remitente, segun Banco de Mexico, corresponde a la tabla ACTIVIDADESBMX
	DECLARE DefaultActividadINEGI	INT(11);			-- Actividad Principal del Remitente, segun INEGI, corresponde a la tabla ACTIVIDADESINEGI
	DECLARE DefaultSector			INT(11);			-- Sector General, corresponde a la tabla SECTORES
	DECLARE Est_Inactivo			CHAR(1);			-- Estatus: INACTIVO

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';				-- Constante Cadena Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Decimal_Cero				:= 0.0;				-- Decimal Cero
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
    SET Salida_SI					:= 'S';				-- Salida: SI

    SET Salida_NO					:= 'N';				-- Salida: NO
    SET ConstanteNO					:= 'N';				-- Constante: NO
    SET ConstanteSI					:= 'S';				-- Constante: SI
    SET DefaultPais					:= 999;				-- Pais de Nacimiento del Remitente, corresponde a la tabla PAISES
    SET DefaultOcupacion			:= 9999;			-- Ocupacion del Remitente, corrresponde a la tabla OCUPACIONES

    SET DefaultActividadBMX			:= '9999999999';	-- Actividad Principal del Remitente, segun Banco de Mexico, corresponde a la tabla ACTIVIDADESBMX
    SET DefaultActividadINEGI		:= 99999;			-- Actividad Principal del Remitente, segun INEGI, corresponde a la tabla ACTIVIDADESINEGI
    SET DefaultSector				:= 998;				-- Sector General, corresponde a la tabla SECTORES
    SET Est_Inactivo				:='I';				-- Estatus: INACTIVO


	-- Valores por default
	IF (Par_PaisNacimiento = Entero_Cero OR Par_PaisNacimiento = NULL)THEN
		SET Par_PaisNacimiento		:= DefaultPais;
	END IF;
	IF (Par_PaisFEA = Entero_Cero OR Par_PaisFEA = NULL)THEN
		SET Par_PaisFEA				:= DefaultPais;
	END IF;
	IF (Par_PaisResidencia = Entero_Cero OR Par_PaisResidencia = NULL)THEN
		SET Par_PaisResidencia		:= DefaultPais;
	END IF;
	IF (Par_OcupacionID	 = Entero_Cero OR Par_OcupacionID = NULL)THEN
		SET Par_OcupacionID			:= DefaultOcupacion;
	END IF;
	IF (Par_SectorID = Entero_Cero OR Par_SectorID = NULL)THEN
		SET Par_SectorID			:= DefaultSector;
	END IF;
	IF (Par_ActividadBMXID = Entero_Cero OR Par_ActividadBMXID = NULL)THEN
		SET Par_ActividadBMXID		:= DefaultActividadBMX;
	END IF;
	IF (Par_ActividadINEGIID = Entero_Cero OR Par_ActividadINEGIID = NULL)THEN
		SET Par_ActividadINEGIID	:= DefaultActividadINEGI;
	END IF;
	
	SET Par_EmpresaID				:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario					:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual				:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP				:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID				:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal				:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion			:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-REMITENTESUSUARIOSERVALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SELECT Estatus INTO Var_Estatus
		FROM USUARIOSERVICIO
		WHERE UsuarioServicioID = Par_UsuarioServicioID;

		SET Var_Estatus := IFNULL(Var_Estatus,Cadena_Vacia);

		SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        IF(Par_UsuarioServicioID = Entero_Cero)THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen	:= 'El Numero de Usuario se encuentra Vacio.';
			SET Var_Control := 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus = Est_Inactivo)THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen	:= 'El Usuario de Servicio se encuentra Inactivo.';
			SET Var_Control := 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NombreCompleto = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen	:= 'El Nombre Completo del Usuario esta Vacio.';
			SET Var_Control := 'nombreCompletoRem';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoPersona = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen	:= 'El Tipo de Persona esta Vacio.';
			SET Var_Control := 'tipoPersonaRem';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Sexo = Cadena_Vacia)THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen	:= 'El Genero esta Vacio.';
			SET Var_Control := 'sexoRem';
			LEAVE ManejoErrores;
		END IF;

        -- Se obtiene el valor consecutivo del Remitente para el registro en la tabla REMITENTESUSUARIOSERV
		SET Var_RemitenteID := (SELECT IFNULL(MAX(RemitenteID),Entero_Cero)+1 FROM REMITENTESUSUARIOSERV WHERE UsuarioServicioID = Par_UsuarioServicioID);

		-- Se obtiene la Fecha Actual
        SET Aud_FechaActual  := NOW();

        -- Se registra la informacion en la tabla REMITENTESUSUARIOSERV
		INSERT INTO REMITENTESUSUARIOSERV(
			UsuarioServicioID,		Fecha,					RemitenteID,			Titulo,					TipoPersona,
			NombreCompleto,			FechaNacimiento,		PaisNacimiento,			EdoNacimiento,			EstadoCivil,
			Sexo,					CURP,					RFC,					FEA,					PaisFEA,
			OcupacionID,			Puesto,					SectorID,				ActividadBMXID,			ActividadINEGIID,
			SectorEcoID,			TipoIdentiID,			NumIdentific,			FecExIden,				FecVenIden,
			TelefonoCasa,			ExtTelefonoPart,		TelefonoCelular,		Correo,					Domicilio,
			Nacionalidad,			PaisResidencia,			EmpresaID,				Usuario,				FechaActual,
			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
		VALUES(
			Par_UsuarioServicioID,	Var_FechaSistema,		Var_RemitenteID,		Par_Titulo,				Par_TipoPersona,
			Par_NombreCompleto,		Par_FechaNacimiento,	Par_PaisNacimiento,		Par_EdoNacimiento,		Par_EstadoCivil,
			Par_Sexo,				Par_CURP,				Par_RFC,				Par_FEA,				Par_PaisFEA,
			Par_OcupacionID,		Par_Puesto,				Par_SectorID,			Par_ActividadBMXID,		Par_ActividadINEGIID,
			Par_SectorEcoID,		Par_TipoIdentiID,		Par_NumIdentific,		Par_FecExIden,			Par_FecVenIden,
			Par_TelefonoCasa,		Par_ExtTelefonoPart,	Par_TelefonoCelular,	Par_Correo,				Par_Domicilio,
			Par_Nacionalidad,		Par_PaisResidencia,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Remitente Agregado Exitosamente: ', CONVERT(Var_RemitenteID, CHAR));
		SET Var_Control	:= 'remitenteID';

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_Control			AS Control,
				Var_RemitenteID		AS Consecutivo;
	END IF;
-- Fin del SP
END TerminaStore$$
