-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECTIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECTIVOSALT`;

DELIMITER $$
CREATE PROCEDURE `DIRECTIVOSALT`(
/** ***** STORE ENCARGADO DE DAR DE ALTA EN LA TABLA DIRECTIVOS ***** */
	Par_ClienteID           INT(11),        -- Numero de Cliente al que se le van a asociar los directivos
	Par_DirectivoID         INT(11),        -- Numero de directivo relacionado al cliente
	Par_RelacionadoID       INT(11),        -- Directivo (Cuando es Cliente se muestra el numero de cliente, de lo contrario se guarda 0)
	Par_GaranteID           INT(11),        -- Numero de Garante al que se le van a asociar los directivos
	Par_AvalID              INT(11),        -- Numero de Aval al que se le van a asociar los directivos

	Par_GaranteRelacion     INT(11),        -- Directivo (Cuando es Garante se muestra el numero de cliente, de lo contrario se guarda 0)
	Par_AvalRelacion        INT(11),        -- Directivo (Cuando es Garante se muestra el numero de cliente, de lo contrario se guarda 0)
	Par_CargoID             INT(11),        -- Cargo (Se obtiene del catalogo de CARGOS)
	Par_EsApoderado         CHAR(1),        -- Indica si el directivo es Apoderado. S:SI, N:No
	Par_ConsejoAdmon        CHAR(1),        -- Indica si el directivo pertenece al Consejo De Administracion S:SI, N:No

	Par_EsAccionista        CHAR(1),        -- Indica si el directivo es Accionista. S:SI, N:No
	Par_Titulo              VARCHAR(10),    -- Titulo ( Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc)
	Par_PrimerNom           VARCHAR(50),    -- Primero Nombre del Directivo
	Par_SegundoNom          VARCHAR(50),    -- Segundo Nombre del Directivo
	Par_TercerNom           VARCHAR(50),    -- Tercer Nombre del Directivo

	Par_ApellidoPat         VARCHAR(50),    -- Apellido Paterno del Directivo
	Par_ApellidoMat         VARCHAR(50),    -- Apellido Materno del Directivo
	Par_FechaNac            DATE,           -- Fecha de Nacimiento del Directivo
	Par_PaisNac             INT(5),         -- Pais de Nacimiento del Directivo
	Par_EdoNac              INT(11),        -- Estado de Nacimiento del Directiv

	Par_EdoCivil            CHAR(2),        -- Estado Civil del Directivo
	Par_Sexo                CHAR(1),        -- Sexo del Directivo: M = Masculino; F = Femenino
	Par_Nacion              CHAR(1),        -- Nacionalidad del Directivo
	Par_CURP                CHAR(18),       -- CURP del Directivo
	Par_RFC                 CHAR(13),       -- RFC del Directivo

	Par_OcupacionID         INT(5),
	Par_FEA                 VARCHAR(250),   -- Firma Electronica del Directivo
	Par_PaisFEA             INT(11),        -- Pais FEA del Directivo
	Par_PaisRFC             INT(11),        -- Pais del RFC del Directivo
	Par_PuestoA             VARCHAR(100),   -- Puesto del Directivo

	Par_SectorGral          INT(3),         -- Sector General del Directivo
	Par_ActBancoMX          VARCHAR(15),    -- Actividad BMX del Directivo
	Par_ActINEGI            INT(5),         -- Actividad del INEGI
	Par_SecEcono            INT(3),         -- Sector Economico del Directivo
	Par_TipoIdentiID        INT(11),        -- Tipo de Identificacion del Directivo

	Par_OtraIden            VARCHAR(20),    -- Otra Identificacion
	Par_NumIden             VARCHAR(20),    -- Numero de Identificacion del Directivo
	Par_FecExIden           DATE,           -- Fecha de Expedicion de la Identificacion
	Par_FecVenIden          DATE,           -- Fecha de Vencimiento de la Identificacion
	Par_Domicilio           VARCHAR(200),   -- Domicilio del Directivo

	Par_TelCasa             VARCHAR(20),    -- Telefono de Casa del Directivo
	Par_TelCel              VARCHAR(20),    -- Telefono Celular del Directivo
	Par_Correo              VARCHAR(50),    -- Correo del Directivo
	Par_PaisRes             INT(5),         -- Pais de Residencia del Directivo
	Par_DocEstLegal         VARCHAR(3),     -- Documento de Estancia Legal

	Par_DocExisLegal        VARCHAR(30),    -- Documento de Existencia Legal
	Par_FechaVenEst         DATE,           -- Fecha de Vencimiento de Estancia
	Par_NumEscPub           VARCHAR(50),    -- Numero de Escritura Publica del Directivo
	Par_FechaEscPub         DATE,           -- Fecha de la Escritura Publica del Directivo
	Par_EstadoID            INT(11),        -- Estado de la Escritura Publica del Directivo

	Par_MunicipioID         INT(11),        -- Municipio de la Escritura Publica del Directivo
	Par_NotariaID           INT(11),        -- Notaria de la Escritura Publica del Directivo
	Par_TitularNotaria      VARCHAR(100),   -- Titula de la Notaria
	Par_Fax                 VARCHAR(30),    -- Fax
	Par_ExtTelefonoPart     VARCHAR(6),     -- Extension del Telefono Particular

	Par_IngreRealoRecur     DECIMAL(14,2),  -- Ingresos Propietario REAL o Proveedor de Recursos
	Par_PorcentajeAcc       DECIMAL(12,4),  -- Porcentaje de Accionista
	Par_ValorAcciones       DECIMAL(12,2),  -- Valor de las acciones
	Par_EsPropietarioReal   CHAR(1),        -- Es Propietario REAL S > Si, N > No
	Par_FolioMercantil      VARCHAR(10),    -- Folio Mercantil Electronico

	Par_TipoAccionista      CHAR(1),        -- A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial M.- Persona Moral G.- Gobierno
	Par_NombreCompania      VARCHAR(150),   -- Campo Disponible para Accionista de Tipo Persona Moral: Nombre de la Compania del Accionista
	Par_Direccion1          VARCHAR(150),   -- Campo Disponible para Accionista de Tipo Persona Moral: Direccion Numero 1 de la Compania del Accionista
	Par_Direccion2          VARCHAR(150),   -- Campo Disponible para Accionista de Tipo Persona Moral: Direccion Numero 2 de la Compania del Accionista
	Par_MunNacimiento       INT(11),        -- Campo Disponible para Accionista de Tipo Persona Moral: Municipio de la Compania del Accionista

	Par_LocNacimiento       INT(11),        -- Campo Disponible para Accionista de Tipo Persona Moral: Localidad de la Compania del Accionista
	Par_ColoniaID           INT(11),        -- Campo Disponible para Accionista de Tipo Persona Moral: Colonia de la Compania del Accionista
	Par_NombreCiudad        VARCHAR(40),    -- Campo Disponible para Accionista de Tipo Persona Moral: Nombre de la Ciudad de la Compania del Accionista
	Par_CodigoPostal        VARCHAR(5),     -- Campo Disponible para Accionista de Tipo Persona Moral: Codigo Postal de la Ciudad de la Compania del Accionista
	Par_EdoExtranjero       VARCHAR(40),    -- Campo Disponible para Accionista de Tipo Persona Moral: Estado Extranjero de la Compania del Accionista

	Par_EsSolicitante		CHAR(1),		-- Indica que la persona adicional es quien solicita el alta  S=Si N=No
	Par_EsAutorizador		CHAR(1),		-- Indica que la persona adicional es quien autoriza el alta  S=Si N=No
	Par_EsAdministrador		CHAR(1),		-- Indica que la persona adicional es el administrador  S=Si N=No
	Par_PaisIDDom			INT(11),		-- Pais de Nacimiento para el domicilio
	Par_EstadoIDDom			INT(11),		-- Estado para el domicilio

	Par_MunicipioIDDom		INT(11),		-- Municipio para el domicilio
	Par_LocalidadIDDom		INT(11),		-- Localidad para el domicilio
	Par_ColoniaIDDom		INT(11),		-- Colonia para el domicilio
	Par_NombreColoniaDom	VARCHAR(100),	-- Nombre colonia para el domicilio
	Par_NombreCiudadDom		VARCHAR(50),	-- Ciudad para el domicilio

	Par_CalleDom			VARCHAR(50),		-- Calle para el domicilio
	Par_NumExteriorDom		VARCHAR(10),		-- Numero exterior para el domicilio
	Par_NumInteriorDom		VARCHAR(10),		-- Numero interior para el domicilio
	Par_PisoDom				VARCHAR(10),		-- Piso para el domicilio
	Par_PrimeraEntreDom		VARCHAR(50),		-- Primera entre para el domicilio

	Par_SegundaEntreDom		VARCHAR(50),		-- Segunda entre para el domicilio
	Par_CodigoPostalDom		VARCHAR(5),			-- Codigo postal para el domicilio

	Par_Salida              CHAR(1),        -- Salida SI.
	INOUT   Par_NumErr      INT(11),        -- Numero de Error
	INOUT   Par_ErrMen      VARCHAR(400),   -- Mensaje de Error

	Par_EmpresaID           INT(11),        -- Parametro de auditoria ID de la empresa
	Aud_Usuario             INT(11),        -- Parametro de auditoria ID del usuario
	Aud_FechaActual         DATETIME,       -- Parametro de auditoria Feha actual
	Aud_DireccionIP         VARCHAR(15),    -- Parametro de auditoria Direccion IP
	Aud_ProgramaID          VARCHAR(50),    -- Parametro de auditoria Programa
	Aud_Sucursal            INT(11),        -- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion      BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_PersonaID       INT(11);        -- Numero de Persona
	DECLARE Var_Consecutivo     INT(11);        -- Numero de Consecutivo
	DECLARE Var_NumeroPersona   INT(11);        -- Numero de Persona
	DECLARE Var_CampoGenerico   INT(11);        -- Campo Generico
	DECLARE Var_NumeroCliente   BIGINT(12);     -- Numero de Cliente

	DECLARE Var_CuentaAhoID     BIGINT(12);     -- Cuenta de Ahorro
	DECLARE Var_Contador        BIGINT(12);     -- Numero de Contador
	DECLARE Var_TipoPMoral      VARCHAR(200);   -- Tipo de Persona
	DECLARE Var_Control         VARCHAR(200);   -- Tipo de Control
	DECLARE Var_ControlSalida   VARCHAR(200);   -- Control de Salida

	DECLARE Par_NombreCompleto  VARCHAR(200);   -- Nombre Completo
	DECLARE Var_Titulo          VARCHAR(10);
	DECLARE Var_PrimerNom       VARCHAR(50);
	DECLARE Var_SegundoNom      VARCHAR(50);
	DECLARE Var_TercerNom       VARCHAR(50);

	DECLARE Var_ApellidoPat     VARCHAR(50);
	DECLARE Var_ApellidoMat     VARCHAR(50);
	DECLARE Var_PaisNac         INT(5);
	DECLARE Var_EdoNac          INT(11);
	DECLARE Var_EdoCivil        CHAR(2);

	DECLARE Var_Sexo            CHAR(1);
	DECLARE Var_Nacion          CHAR(1);
	DECLARE Var_CURP            CHAR(18);
	DECLARE Var_OcupacionID     INT(5);
	DECLARE Var_PaisRFC         INT(11);

	DECLARE Var_PuestoA         VARCHAR(100);
	DECLARE Var_SectorGral      INT(3);
	DECLARE Var_ActBancoMX      VARCHAR(15);
	DECLARE Var_ActINEGI        INT(5);
	DECLARE Var_SecEcono        INT(3);

	DECLARE Var_TipoIdentiID    INT(11);
	DECLARE Var_OtraIden        VARCHAR(20);
	DECLARE Var_NumIden         VARCHAR(20);
	DECLARE Var_FecExIden       DATE;
	DECLARE Var_FecVenIden      DATE;

	DECLARE Var_TelCasa         VARCHAR(20);
	DECLARE Var_TelCel          VARCHAR(20);
	DECLARE Var_PaisRes         INT(5);
	DECLARE Var_DocEstLegal     VARCHAR(3);
	DECLARE Var_DocExisLegal    VARCHAR(30);

	DECLARE Var_FechaVenEst     DATE;
	DECLARE Var_NumEscPub       VARCHAR(50);
	DECLARE Var_FechaEscPub     DATE;
	DECLARE Var_NotariaID       INT(11);
	DECLARE Var_TitularNotaria  VARCHAR(100);

	DECLARE Var_Fax             VARCHAR(30);
	DECLARE Var_ExtTelefonoPart VARCHAR(6);
	DECLARE Var_IngreRealoRecur DECIMAL(14,2);
	DECLARE Var_PorcentajeAcc   DECIMAL(12,4);
	DECLARE Var_FechaNac        DATE;

	DECLARE Var_RFC            CHAR(13);
	DECLARE Var_MunicipioID    INT(11);
	DECLARE Var_RazonSocial    VARCHAR(150);
	DECLARE Var_TipoPersonaCta CHAR(1);
	DECLARE Var_Fea             VARCHAR(250);
	DECLARE Var_Correo          VARCHAR(50);

	DECLARE Var_Domicilio       VARCHAR(200);
	DECLARE Var_PaisFea         INT(11);
	DECLARE Var_EstadoID        INT(11);
	DECLARE Var_EsPropietarioReal CHAR(1);
	DECLARE Var_ValorAcciones   DECIMAL(12,2);
	DECLARE EsNA 				CHAR(2);

	-- Declaracion de Validaciones
	DECLARE Val_DirectivoAlt    TINYINT UNSIGNED;-- Numero de Validacion 1.- Alta de Directivo

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);        -- Constante Cadena Vacia
	DECLARE Fecha_Vacia         DATE;           -- Constante Fecha Vacia
	DECLARE Entero_Cero         INT(11);        -- Constante Entero Cero
	DECLARE Decimal_Cero        DECIMAL(12,2);  -- Constante Decimal Cero
	DECLARE Con_SI              CHAR(1);        -- Constante SI

	DECLARE Constante_No        CHAR(1);        -- Constante NO
	DECLARE Moral               CHAR(1);        -- Constante Persona Moral
	DECLARE Mayusculas          CHAR(2);        -- Constante en Mayusculas

	DECLARE Var_NomPais			VARCHAR(50);
	DECLARE Var_NomEstado		VARCHAR(50);
	DECLARE Var_NomMunicipio	VARCHAR(50);
	DECLARE Var_NomLocalidad	VARCHAR(50);
	DECLARE Var_NomColonia		VARCHAR(100);
	DECLARE Var_Coma			VARCHAR(2);
	DECLARE CliProEsp 			INT(11);
	DECLARE CliCrediClub		INT(11);

	-- Asignacion de Validaciones
	SET Val_DirectivoAlt        := 1;

	--  Asignacion De Constantes
	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             := 0;
	SET Decimal_Cero            := 0.0;
	SET Con_SI                  := 'S';

	SET Constante_No            := 'N';
	SET Moral                   := 'M';
	SET Mayusculas              := 'MA';
	SET Var_CampoGenerico       := Entero_Cero;
	SET Var_Coma				:= ', ';
	SET EsNA 					:= 'NA';

	-- Eliminacion de Espacion Vacios
	SET Par_PrimerNom       := TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
	SET Par_SegundoNom      := TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
	SET Par_TercerNom       := TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
	SET Par_ApellidoPat     := TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
	SET Par_ApellidoMat     := TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));
	SET CliProEsp           := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
	SET CliCrediClub		:= '24';

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
								' esto le ocasiona. Ref: SP-DIRECTIVOSALT');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		-- Seteo de Parametros
		SET Par_EsApoderado         := IFNULL(Par_EsApoderado, Constante_No);
		SET Par_EsAccionista        := IFNULL(Par_EsAccionista, Constante_No);
		SET Par_ConsejoAdmon        := IFNULL(Par_ConsejoAdmon, Constante_No);


		SET Var_Titulo              := IFNULL(Par_Titulo, Cadena_Vacia);
		SET Var_PrimerNom           := IFNULL(Par_PrimerNom, Cadena_Vacia);
		SET Var_SegundoNom          := IFNULL(Par_SegundoNom, Cadena_Vacia);
		SET Var_TercerNom           := IFNULL(Par_TercerNom, Cadena_Vacia);
		SET Var_ApellidoPat         := IFNULL(Par_ApellidoPat, Cadena_Vacia);

		SET Var_ApellidoMat         := IFNULL(Par_ApellidoMat, Cadena_Vacia);
		SET Var_FechaNac            := IFNULL(Par_FechaNac, Fecha_Vacia);
		SET Var_PaisNac             := IFNULL(Par_PaisNac, Entero_Cero);
		SET Var_EdoNac              := IFNULL(Par_EdoNac, Entero_Cero);
		SET Var_EdoCivil            := IFNULL(Par_EdoCivil, Cadena_Vacia);

		SET Var_Sexo                := IFNULL(Par_Sexo, Cadena_Vacia);
		SET Var_Nacion              := IFNULL(Par_Nacion, Cadena_Vacia);
		SET Var_CURP                := IFNULL(Par_CURP, Cadena_Vacia);
		SET Var_RFC                 := IFNULL(Par_RFC, Cadena_Vacia);
		SET Var_OcupacionID         := IFNULL(Par_OcupacionID, Entero_Cero);
		SET Var_FEA                 := IFNULL(Par_FEA, Cadena_Vacia);

		SET Var_PaisFEA             := IFNULL(Par_PaisFEA, Entero_Cero);
		SET Var_PaisRFC             := IFNULL(Par_PaisRFC, Entero_Cero);
		SET Var_PuestoA             := IFNULL(Par_PuestoA, Cadena_Vacia);
		SET Var_SectorGral          := IFNULL(Par_SectorGral, Entero_Cero);
		SET Var_ActBancoMX          := IFNULL(Par_ActBancoMX, Cadena_Vacia);

		SET Var_ActINEGI            := IFNULL(Par_ActINEGI, Entero_Cero);
		SET Var_SecEcono            := IFNULL(Par_SecEcono, Entero_Cero);
		SET Var_TipoIdentiID        := IFNULL(Par_TipoIdentiID, Entero_Cero);
		SET Var_OtraIden            := IFNULL(Par_OtraIden, Cadena_Vacia);
		SET Var_NumIden             := IFNULL(Par_NumIden, Cadena_Vacia);

		SET Var_FecExIden           := IFNULL(Par_FecExIden, Fecha_Vacia);
		SET Var_FecVenIden          := IFNULL(Par_FecVenIden, Fecha_Vacia);
		SET Var_Domicilio           := IFNULL(Par_Domicilio, Cadena_Vacia);
		SET Var_TelCasa             := IFNULL(Par_TelCasa, Cadena_Vacia);
		SET Var_TelCel              := IFNULL(Par_TelCel, Cadena_Vacia);

		SET Var_Correo              := IFNULL(Par_Correo, Cadena_Vacia);
		SET Var_DocEstLegal         := IFNULL(Par_DocEstLegal, Cadena_Vacia);
		SET Var_DocExisLegal        := IFNULL(Par_DocExisLegal, Cadena_Vacia);
		SET Var_FechaVenEst         := IFNULL(Par_FechaVenEst, Fecha_Vacia);
		SET Var_NumEscPub           := IFNULL(Par_NumEscPub, Cadena_Vacia);

		SET Var_FechaEscPub         := IFNULL(Par_FechaEscPub, Fecha_Vacia);
		SET Var_EstadoID            := IFNULL(Par_EstadoID, Entero_Cero);
		SET Var_MunicipioID         := IFNULL(Par_MunicipioID, Entero_Cero);
		SET Var_NotariaID           := IFNULL(Par_NotariaID, Entero_Cero);
		SET Var_TitularNotaria      := IFNULL(Par_TitularNotaria, Entero_Cero);

		SET Var_Fax                 := IFNULL(Par_Fax, Cadena_Vacia);
		SET Var_ExtTelefonoPart     := IFNULL(Par_ExtTelefonoPart, Cadena_Vacia);
		SET Var_IngreRealoRecur     := IFNULL(Par_IngreRealoRecur, Decimal_Cero);
		SET Var_PorcentajeAcc       := IFNULL(Par_PorcentajeAcc, Decimal_Cero);
		SET Var_EsPropietarioReal   := IFNULL(Par_EsPropietarioReal, Constante_No);

		SET Var_ValorAcciones       := IFNULL(Par_ValorAcciones, Decimal_Cero);
		SET Par_FolioMercantil      := IFNULL(Par_FolioMercantil,   Cadena_Vacia);
		SET Par_TipoAccionista      := IFNULL(Par_TipoAccionista, Cadena_Vacia);
		SET Par_NombreCompania      := IFNULL(Par_NombreCompania, Cadena_Vacia);
		SET Par_Direccion1          := IFNULL(Par_Direccion1, Cadena_Vacia);

		SET Par_Direccion2          := IFNULL(Par_Direccion2, Cadena_Vacia);
		SET Par_MunNacimiento       := IFNULL(Par_MunNacimiento, Entero_Cero);
		SET Par_LocNacimiento       := IFNULL(Par_LocNacimiento, Entero_Cero);
		SET Par_ColoniaID           := IFNULL(Par_ColoniaID, Entero_Cero);
		SET Par_NombreCiudad        := IFNULL(Par_NombreCiudad, Cadena_Vacia);

		SET Par_CodigoPostal        := IFNULL(Par_CodigoPostal, Cadena_Vacia);
		SET Par_EdoExtranjero       := IFNULL(Par_EdoExtranjero, Cadena_Vacia);
		-- Eliminar mascara telefono
		SET Par_TelCel              := IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelCel, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
		SET Par_TelCasa             := IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelCasa, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		-- Mando a validar toda la seccion que siempre a funcionado
		CALL DIRECTIVOSVAL(
			Par_ClienteID,          Par_DirectivoID,    Par_RelacionadoID,  Par_GaranteID,          Par_AvalID,
			Par_GaranteRelacion,    Par_AvalRelacion,   Par_CargoID,        Par_EsApoderado,        Par_ConsejoAdmon,
			Par_EsAccionista,       Par_Titulo,         Par_PrimerNom,      Par_SegundoNom,         Par_TercerNom,
			Par_ApellidoPat,        Par_ApellidoMat,    Par_FechaNac,       Par_PaisNac,            Par_EdoNac,
			Par_EdoCivil,           Par_Sexo,           Par_Nacion,         Par_CURP,               Par_RFC,
			Par_OcupacionID,        Par_FEA,            Par_PaisFEA,        Par_PaisRFC,            Par_PuestoA,
			Par_SectorGral,         Par_ActBancoMX,     Par_ActINEGI,       Par_SecEcono,           Par_TipoIdentiID,
			Par_OtraIden,           Par_NumIden,        Par_FecExIden,      Par_FecVenIden,         Par_Domicilio,
			Par_TelCasa,            Par_TelCel,         Par_Correo,         Par_PaisRes,            Par_DocEstLegal,
			Par_DocExisLegal,       Par_FechaVenEst,    Par_NumEscPub,      Par_FechaEscPub,        Par_EstadoID,
			Par_MunicipioID,        Par_NotariaID,      Par_TitularNotaria, Par_Fax,                Par_ExtTelefonoPart,
			Par_IngreRealoRecur,    Par_PorcentajeAcc,  Par_ValorAcciones,  Par_EsPropietarioReal,  Par_FolioMercantil,
			Par_TipoAccionista,     Par_NombreCompania, Par_Direccion1,     Par_Direccion2,         Par_MunNacimiento,
			Par_ColoniaID,          Par_NombreCiudad,   Par_CodigoPostal,   Par_EdoExtranjero,      Par_NombreCompleto,
			Var_NumeroCliente,      Var_TipoPMoral,     Var_ControlSalida,  Val_DirectivoAlt,
			Constante_No,           Par_NumErr,         Par_ErrMen,         Par_EmpresaID,          Aud_Usuario,
			Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

		IF( Par_NumErr <> Entero_Cero ) THEN
			SET Var_Control     := Var_ControlSalida;
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_NumeroPersona := Entero_Cero;

		IF(IFNULL(Par_ClienteID, Entero_Cero)) != Entero_Cero THEN
			SET Var_NumeroPersona := ( SELECT IFNULL(MAX(DirectivoID),Entero_Cero) + 1
									   FROM DIRECTIVOS
									   WHERE ClienteID = Par_ClienteID);
		ELSE
			IF(IFNULL(Par_GaranteID, Entero_Cero)) != Entero_Cero THEN
				SET Var_NumeroPersona := ( SELECT IFNULL(MAX(DirectivoID),Entero_Cero) + 1
										   FROM DIRECTIVOS
										   WHERE GaranteID = Par_GaranteID);
			ELSE
				IF(IFNULL(Par_AvalID, Entero_Cero)) != Entero_Cero THEN
					SET Var_NumeroPersona := ( SELECT IFNULL(MAX(DirectivoID),Entero_Cero) + 1
											   FROM DIRECTIVOS
											   WHERE AvalID = Par_AvalID);
				END IF;
			END IF;
		END IF;

		SET Par_DirectivoID := Var_NumeroPersona;
		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		IF(SELECT EXISTS(SELECT * FROM PAISES WHERE PaisID = Par_PaisIDDom) = Entero_Cero) THEN
			SET Par_NumErr      := 021;
			SET Par_ErrMen      := CONCAT('No Existe el País Seleccionado: ', Par_PaisIDDom);
			SET Var_Control     := 'paisIDDom';
			LEAVE ManejoErrores;
		END IF;

		IF(SELECT EXISTS(SELECT * FROM ESTADOSREPUB WHERE EstadoID = Par_EstadoIDDom) = Entero_Cero) THEN
			SET Par_NumErr      := 022;
			SET Par_ErrMen      := CONCAT('No Existe el Estado Seleccionado: ', Par_EstadoIDDom);
			SET Var_Control     := 'estadoIDDom';
			LEAVE ManejoErrores;
		END IF;

		IF(SELECT EXISTS(SELECT * FROM MUNICIPIOSREPUB WHERE MunicipioID = Par_MunicipioIDDom) = Entero_Cero) THEN
			SET Par_NumErr      := 023;
			SET Par_ErrMen      := CONCAT('No Existe el Municipio Seleccionado: ', Par_MunicipioIDDom);
			SET Var_Control     := 'municipioIDDom';
			LEAVE ManejoErrores;
		END IF;

		IF(SELECT EXISTS(SELECT * FROM LOCALIDADREPUB WHERE LocalidadID = Par_LocalidadIDDom) = Entero_Cero) THEN
			SET Par_NumErr      := 024;
			SET Par_ErrMen      := CONCAT('No Existe la Localidad Seleccionada: ', Par_LocalidadIDDom);
			SET Var_Control     := 'localidadIDDom';
			LEAVE ManejoErrores;
		END IF;

		IF(SELECT EXISTS(SELECT * FROM COLONIASREPUB WHERE ColoniaID = Par_ColoniaIDDom) = Entero_Cero) THEN
			SET Par_NumErr      := 025;
			SET Par_ErrMen      := CONCAT('No Existe la Colonia Seleccionada: ', Par_ColoniaIDDom);
			SET Var_Control     := 'coloniaIDDom';
			LEAVE ManejoErrores;
		END IF;

		SET Var_Domicilio		:= IFNULL(Par_Domicilio, Cadena_Vacia);

		IF(Par_PaisIDDom = 700) THEN
			SELECT Nombre INTO Var_NomPais FROM PAISES WHERE PaisID = Par_PaisIDDom;

			SELECT Nombre INTO Var_NomEstado FROM ESTADOSREPUB WHERE EstadoID = Par_EstadoIDDom;

			SELECT Nombre INTO Var_NomMunicipio
				FROM MUNICIPIOSREPUB
			WHERE MunicipioID = Par_MunicipioIDDom
				AND EstadoID = Par_EstadoIDDom;

			SELECT NombreLocalidad INTO Var_NomLocalidad
				FROM LOCALIDADREPUB
			WHERE LocalidadID = Par_LocalidadIDDom
				AND MunicipioID = Par_MunicipioIDDom
				AND EstadoID = Par_EstadoIDDom;

			SELECT Asentamiento INTO Var_NomColonia
                FROM COLONIASREPUB
            WHERE ColoniaID = Par_ColoniaIDDom
                AND EstadoID = Par_EstadoIDDom
                AND MunicipioID = Par_MunicipioIDDom;

			SET Par_CalleDom		:= IFNULL(Par_CalleDom, Cadena_Vacia);
			SET Par_NumExteriorDom	:= IFNULL(Par_NumExteriorDom, Cadena_Vacia);
			SET Var_NomColonia		:= IFNULL(Var_NomColonia, Cadena_Vacia);
			SET Par_CodigoPostalDom := IFNULL(Par_CodigoPostalDom, Cadena_Vacia);
			SET Var_NomLocalidad	:= IFNULL(Var_NomLocalidad, Cadena_Vacia);
			SET Var_NomMunicipio	:= IFNULL(Var_NomMunicipio, Cadena_Vacia);
			SET Var_NomEstado		:= IFNULL(Var_NomEstado, Cadena_Vacia);
			SET Var_NomPais			:= IFNULL(Var_NomPais, Cadena_Vacia);

			SET Var_Domicilio = CONCAT(Par_CalleDom, Var_Coma, Par_NumExteriorDom, Var_Coma, Var_NomColonia, Var_Coma, Par_CodigoPostalDom, Var_Coma, Var_NomLocalidad,
									Var_Coma, Var_NomMunicipio, Var_Coma, Var_NomEstado, Var_Coma, Var_NomPais);
		END IF;

		SET Var_TipoPersonaCta := 'F';
		IF( CliProEsp <> CliCrediClub) THEN
			/*SECCION PLD: Deteccion de operaciones inusuales*/
			CALL PLDDETECCIONPRO(
				Entero_Cero,			Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
				Par_ApellidoMat,		Var_TipoPersonaCta,		Cadena_Vacia,			Par_RFC,				Cadena_Vacia,
				Par_FechaNac,			Entero_Cero,			Par_PaisNac,			Par_EstadoID,			Par_NombreCompleto,
				EsNA,					Constante_No,			Con_SI,					Constante_No,			Constante_No,
				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
	   	END IF;

		IF(Par_NumErr!=Entero_Cero)THEN
			SET Par_NumErr			:= 50; -- NO CAMBIAR ESTE NUMERO DE ERROR
			SET Var_Control			:= 'agrega';
			LEAVE ManejoErrores;
		END IF;

		-- SE INSERTA A LA TABLA DE DIRECTIVOS
		INSERT INTO DIRECTIVOS (
			ClienteID,              GaranteID,              AvalID,                 DirectivoID,            RelacionadoID,
			GaranteRelacion,        AvalRelacion,           CargoID,                EsApoderado,            ConsejoAdmon,
			EsAccionista,           EsSolicitante,			EsAutorizador,			EsAdministrador,		Titulo,
			PrimerNombre,           SegundoNombre,          TercerNombre,			ApellidoPaterno,        ApellidoMaterno,
			NombreCompleto,         FechaNac,               PaisNacimiento,			EdoNacimiento,          EstadoCivil,
			Sexo,                   Nacionalidad,           CURP,					RFC,                    OcupacionID,
			FEA,                    PaisFEA,                PaisRFC,				PuestoA,                SectorGeneral,
			ActividadBancoMX,       ActividadINEGI,         SectorEconomico,		TipoIdentiID,           OtraIdentifi,
			NumIdentific,           FecExIden,              FecVenIden,				Domicilio,              TelefonoCasa,
			TelefonoCelular,        Correo,                 PaisResidencia,			DocEstanciaLegal,       DocExisLegal,
			FechaVenEst,            NumEscPub,              FechaEscPub,			EstadoID,               MunicipioID,
			NotariaID,              TitularNotaria,         Fax,					ExtTelefonoPart,        IngresoRealoRecur,
			TipoAccionista,         PorcentajeAcciones,     EsPropietarioReal,		ValorAcciones,          FolioMercantil,
			NombreCompania,         Direccion1,             Direccion2,				MunNacimiento,          LocNacimiento,
			ColoniaID,              NombreCiudad,           CodigoPostal,			EdoExtranjero,          PaisIDDom,
			EstadoIDDom,			MunicipioIDDom,			LocalidadIDDom,			ColoniaIDDom,			NombreColoniaDom,
			NombreCiudadDom,		CalleDom,				NumExteriorDom,			NumInteriorDom,			PisoDom,
			PrimeraEntreDom,		SegundaEntreDom,		CodigoPostalDom,		EmpresaID,				Usuario,
			FechaActual,            DireccionIP,			ProgramaID,             Sucursal,				NumTransaccion)
		VALUES (
			Par_ClienteID,          Par_GaranteID,          Par_AvalID,             Par_DirectivoID,        Par_RelacionadoID,
			Par_GaranteRelacion,    Par_AvalRelacion,       Par_CargoID,            Par_EsApoderado,        Par_ConsejoAdmon,
			Par_EsAccionista,       Par_EsSolicitante,		Par_EsAutorizador,		Par_EsAdministrador,	Var_Titulo,
			Var_PrimerNom,          Var_SegundoNom,         Var_TercerNom,			Var_ApellidoPat,        Var_ApellidoMat,
			Par_NombreCompleto,     Var_FechaNac,           Var_PaisNac,			Var_EdoNac,             Var_EdoCivil,
			Var_Sexo,               Var_Nacion,             Var_CURP,				Var_RFC,                Var_OcupacionID,
			Var_FEA,                Var_PaisFEA,            Var_PaisRFC,			Var_PuestoA,            Var_SectorGral,
			Var_ActBancoMX,         Var_ActINEGI,           Var_SecEcono,			Var_TipoIdentiID,       Var_OtraIden,
			Var_NumIden,            Var_FecExIden,          Var_FecVenIden,			Var_Domicilio,          Var_TelCasa,
			Var_TelCel,             Var_Correo,             Par_PaisRes,			Var_DocEstLegal,        Var_DocExisLegal,
			Var_FechaVenEst,        Var_NumEscPub,          Var_FechaEscPub,		Var_EstadoID,           Var_MunicipioID,
			Var_NotariaID,          Var_TitularNotaria,     Var_Fax,				Var_ExtTelefonoPart,    Var_IngreRealoRecur,
			Par_TipoAccionista,     Var_PorcentajeAcc,      Var_EsPropietarioReal,	Var_ValorAcciones,      Par_FolioMercantil,
			Par_NombreCompania,     Par_Direccion1,         Par_Direccion2,			Par_MunNacimiento,      Par_LocNacimiento,
			Par_ColoniaID,          Par_NombreCiudad,       Par_CodigoPostal,		Par_EdoExtranjero,      Par_PaisIDDom,
			Par_EstadoIDDom,		Par_MunicipioIDDom,		Par_LocalidadIDDom,		Par_ColoniaIDDom,		Par_NombreColoniaDom,
			Par_NombreCiudadDom,	Par_CalleDom,			Par_NumExteriorDom,		Par_NumInteriorDom,		Par_PisoDom,
			Par_PrimeraEntreDom,	Par_SegundaEntreDom,	Par_CodigoPostalDom,	Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,        Aud_DireccionIP,		Aud_ProgramaID,         Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr > Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- SI es Accionista y es Moral no se registra como relacionado a cuenta
		IF( Par_EsAccionista = Con_SI AND Par_TipoAccionista = Moral ) THEN
			SET Par_NumErr      := 000;
			SET Par_ErrMen      := CONCAT('Directivo Relacionado al ', Var_TipoPMoral,': ', CONVERT(Var_NumeroCliente, CHAR), ' Agregado Exitosamente');
			SET Var_Control     := 'directivoID';
			SET Var_Consecutivo := Var_NumeroPersona;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_EsApoderado = Con_SI OR Par_EsAccionista = Con_SI)THEN

			SET Var_CuentaAhoID := (SELECT MAX(CuentaAhoID) FROM CUENTASAHO WHERE ClienteID = Par_ClienteID);
			SET Var_Contador    := (SELECT MIN(CuentaAhoID) FROM CUENTASAHO WHERE ClienteID = Par_ClienteID);

			WHILE (Var_Contador <= Var_CuentaAhoID) DO

				CALL `CUENTASPERSONAALT`(
					Var_Contador,           Par_EsApoderado,        Cadena_Vacia,       Cadena_Vacia,           Cadena_Vacia,
					Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,       Par_Titulo,             Par_PrimerNom,
					Par_SegundoNom,         Par_TercerNom,          Par_ApellidoPat,    Par_ApellidoMat,        Par_FechaNac,
					Par_PaisNac,            Par_EdoNac,             Par_EdoCivil,       Par_Sexo,               Par_Nacion,
					Par_CURP,               Par_RFC,                Par_OcupacionID,    Par_FEA,                Par_PaisFEA,
					Par_PaisRFC,            Par_PuestoA,            Par_SectorGral,     Par_ActBancoMX,         Par_ActINEGI,
					Par_SecEcono,           Par_TipoIdentiID,       Par_OtraIden,       Par_NumIden,            Par_FecExIden,
					Par_FecVenIden,         Par_Domicilio,          Par_TelCasa,        Par_TelCel,             Par_Correo,
					Par_PaisRes,            Par_DocEstLegal,        Par_DocExisLegal,   Par_FechaVenEst,        Par_NumEscPub,
					Par_FechaEscPub,        Par_EstadoID,           Par_MunicipioID,    Par_NotariaID,          Par_TitularNotaria,
					Cadena_Vacia,           Par_Fax,                Entero_Cero,        Entero_Cero,            Par_RelacionadoID,
					Par_ExtTelefonoPart,    Par_IngreRealoRecur,    Cadena_Vacia,       Cadena_Vacia,           Cadena_Vacia,
					Cadena_Vacia,           Cadena_Vacia,           Fecha_Vacia,        Entero_Cero,            Cadena_Vacia,
					Par_EsAccionista,       Par_PorcentajeAcc,      Cadena_Vacia,       Entero_Cero,            Constante_No,
					Par_NumErr,             Par_ErrMen,             Par_EmpresaID,      Aud_Usuario,            Aud_FechaActual,
					Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

					SET Var_PersonaID := (SELECT MAX(PersonaID) FROM CUENTASPERSONA WHERE CuentaAhoID = Var_Contador);

					UPDATE DIRECTIVOS SET
						PersonaID = Var_PersonaID
					WHERE ClienteID = Par_ClienteID
					  AND DirectivoID = Par_DirectivoID;

					IF (Par_NumErr > Entero_Cero AND Par_NumErr <> 21) THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_Contador := ( SELECT MIN(CuentaAhoID)
										  FROM CUENTASAHO
										  WHERE ClienteID = Par_ClienteID
											AND CuentaAhoID > Var_Contador);
			END WHILE;

		END IF;

		SET Par_NumErr      := 000;
		SET Par_ErrMen      := CONCAT('Directivo Relacionado al ', Var_TipoPMoral,': ', CONVERT(Var_NumeroCliente, CHAR), ' Agregado Exitosamente');
		SET Var_Control     := 'directivoID';
		SET Var_Consecutivo := Var_NumeroPersona;

	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF (Par_Salida = Con_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo,
				Var_CampoGenerico AS CampoGenerico;
	END IF;

END TerminaStore$$