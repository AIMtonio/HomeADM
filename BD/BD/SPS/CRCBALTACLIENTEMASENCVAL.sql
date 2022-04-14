-- CRCBALTACLIENTEMASENCVAL
DELIMITER ;
DROP procedure IF EXISTS `CRCBALTACLIENTEMASENCVAL`;

DELIMITER $$
CREATE PROCEDURE `CRCBALTACLIENTEMASENCVAL`(
	-- Stored procedure para dar de alta clientes CRCB de forma masiva
	Par_FolioCarga			INT(11),		-- Numero de folio de la tabla CS_CRCBCLIENTESWS
    Par_FechaCarga			DATE,			-- Fecha en la que se dara de alta los clientes
	Par_PrimerNombre		VARCHAR(50),	-- Primer Nombre del Cliente
	Par_SegundoNombre		VARCHAR(50),	-- Segundo Nombre del Cliente
	Par_TercerNombre		VARCHAR(50),	-- Tercer Nombre del Cliente
	Par_ApellidoPaterno		VARCHAR(50),	-- Apellido Paterno del Cliente

	Par_ApellidoMaterno		VARCHAR(50),	-- Apellido Materno del Cliente
	Par_FechaNacimiento		DATE,			-- Fecha de Nacimiento del Cliente
	Par_CURP				CHAR(18),		-- CURP del Cliente
	Par_EstadoNacimientoID	INT(11),		-- ID Estado de Nacimiento
	Par_Sexo				CHAR(1),		-- Sexo del Cliente

	Par_Telefono			VARCHAR(20),	-- Telefono Oficial del Cliente
	Par_TelefonoCelular		VARCHAR(20),	-- Telefono Celular del Cliente
	Par_Correo				VARCHAR(50),	-- Correo Electronico del Cliente
	Par_RFC					CHAR(13),		-- RFC del Cliente
	Par_OcupacionID			INT(11),		-- Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)

	Par_LugardeTrabajo		VARCHAR(150),	-- Lugar de Trabajo del Cliente
	Par_Puesto				VARCHAR(150),	-- Puesto de Trabajo del Cliente
	Par_TelTrabajo			VARCHAR(20),	-- Telefono Trabajo del Cliente
	Par_NoEmpleado			VARCHAR(20),	-- Indica el Numero de Empleado de la Empresa de Nomina a la que esta ligado el Cliente
	Par_AntiguedadTra		DECIMAL(12,2),	-- Antiguedad del Trabajo

	Par_ExtTelefonoTrab		VARCHAR(10),	-- Extension del Telefono Trabajo del Cliente
	Par_TipoEmpleado		CHAR(1),		-- Tipo de Empleado
	Par_TipoPuesto			INT(11),		-- Tipo de Puesto
	Par_SucursalOrigen		INT(5),			-- ID Sucursal del Cliente
	Par_TipoPersona			CHAR(1),		-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial

	Par_PaisNacionalidad        INT(11),         -- Indica el País de Nacionalidad, es decir, el país al que corresponde legalmente el cliente.
	Par_IngresosMensuales       DECIMAL(14,2),  -- Monto de los ingresos mensuales reportados por el cliente
    Par_TamanioAcreditado       INT(11),        -- Clave que indica el Tamaño del Acreditado (Aplica solo para créditos comerciales)(0,1,2,3,4)
    Par_NiveldeRiesgo           CHAR(1),        -- Indica el Nivel de Riesgo del Cliente: A: Alto M: Medio B: Bajo


	Par_Titulo				VARCHAR(10),	-- Titulo del Cliente
	Par_PaisResidencia		INT(5),			-- ID Pais de Residencia del Cliente
	Par_SectorGeneral		INT(3),			-- ID Sector General
	Par_ActividadBancoMX	VARCHAR(15),	-- ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX
	Par_EstadoCivil			CHAR(2),		-- Estado Cividl del Cliente

	Par_LugarNacimiento		INT(11),		-- Pais Lugar de Nacimiento
	Par_PromotorInicial		INT(6),			-- ID Promotor Inicial
	Par_PromotorActual		INT(6),			-- ID Promotor Actual
	Par_ExtTelefonoPart		VARCHAR(7),		-- Extension del Telefono Particular
	Par_TipoDireccionID		INT(11),		-- Tipo de Direccion

	Par_EstadoID			INT(11),		-- ID Estado del Cliente
	Par_MunicipioID			INT(11),		-- ID Municipio del Cliente
	Par_LocalidadID			INT(11),		-- ID Localidad del Cliente
	Par_ColoniaID			INT(11),		-- ID Colonia del Cliente
	Par_Calle				VARCHAR(50),	-- Nombre de la Calle

	Par_Numero				CHAR(10),		-- Numero de la Vivienda del Cliente
	Par_CP					CHAR(5),		-- Codigo Postal Direccion del Cliente
	Par_Oficial				CHAR(1),		-- Valor de direccion Oficial S=SI N=No
	Par_Fiscal				CHAR(1),		-- Valor de direccion Fiscal S=SI N=No
	Par_NumInterior			CHAR(10),		-- Numero Interior de la Casa o Edificio

	Par_Lote				CHAR(50),		-- Numero de Lote la Vivienda del Cliente
	Par_Manzana				CHAR(50),		-- Numero de Manzana de la Vivienda del Cliente
	Par_TipoIdentiID		INT(11),		-- Tipo de Identificacion del Cliente
	Par_NumIdentific		VARCHAR(30),	-- Numero de Identificacion del Documento del Cliente
	Par_FecExIden			DATE,			-- Fecha de Expedicion de la Identificacion

	Par_FecVenIden			DATE,			-- Fecha de vencimiento de la Identificacion

	Par_Salida				CHAR(1),		-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID			INT(11),		-- Parametro de auditoria
	Aud_Usuario				INT(11),		-- Parametro de auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria
	Aud_Sucursal			INT(11),		-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);								-- Variable de control
	DECLARE Var_Consecutivo				BIGINT(20);									-- Consecutivo
	DECLARE Var_RegistroActual			INT(11);									-- Variable del registro actual para el iterador
	DECLARE Var_TotalRegistros			INT(11);									-- Variable para el total de registros a iterar
	DECLARE Var_CodigoError				INT(11);									-- Codigo de error
	DECLARE Var_DescError				VARCHAR(400);								-- Descripcion del error
	DECLARE Var_FechaCarga				DATETIME;									-- Fecha de carga del registro de acuerdo a la tabla CS_CRCBCLIENTESWS
	DECLARE Var_FolioCarga				INT(11);									-- Folio de carga del registro de acuerdo a la tabla CS_CRCBCLIENTESWS
	DECLARE Var_PrimerNombre			VARCHAR(50);								-- Primer Nombre del Cliente
	DECLARE Var_SegundoNombre			VARCHAR(50);								-- Segundo Nombre del Cliente
	DECLARE Var_TercerNombre			VARCHAR(50);								-- Tercer Nombre del Cliente
	DECLARE Var_ApellidoPaterno			VARCHAR(50);								-- Apellido Paterno del Cliente
	DECLARE Var_ApellidoMaterno			VARCHAR(50);								-- Apellido Materno del Cliente
	DECLARE Var_FechaNacimiento			DATE;										-- Fecha de Nacimiento del Cliente
	DECLARE Var_CURP					CHAR(18);									-- CURP del Cliente
	DECLARE Var_EstadoNacimientoID		INT(11);									-- ID Estado de Nacimiento
	DECLARE Var_Sexo					CHAR(1);									-- Sexo del Cliente
	DECLARE Var_Telefono				VARCHAR(20);								-- Telefono Oficial del Cliente
	DECLARE Var_TelefonoCelular			VARCHAR(20);								-- Telefono Celular del Cliente
	DECLARE Var_Correo					VARCHAR(50);								-- Correo Electronico del Cliente
	DECLARE Var_RFC						CHAR(13);									-- RFC del Cliente
	DECLARE Var_OcupacionID				INT(11);									-- Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)
	DECLARE Var_LugardeTrabajo			VARCHAR(150);								-- Lugar de Trabajo del Cliente
	DECLARE Var_Puesto					VARCHAR(150);								-- Puesto de Trabajo del Cliente
	DECLARE Var_TelTrabajo				VARCHAR(20);								-- Telefono Trabajo del Cliente
	DECLARE Var_NoEmpleado				VARCHAR(20);								-- Indica el Numero de Empleado de la Empresa de Nomina a la que esta ligado el Cliente
	DECLARE Var_AntiguedadTra			DECIMAL(12,2);								-- Antiguedad del Trabajo
	DECLARE Var_ExtTelefonoTrab			VARCHAR(10);								-- Extension del Telefono Trabajo del Cliente
	DECLARE Var_TipoEmpleado			CHAR(1);									-- Tipo de Empleado
	DECLARE Var_TipoPuesto				INT(11);									-- Tipo de Puesto
	DECLARE Var_SucursalOrigen			INT(5);										-- ID Sucursal del Cliente
	DECLARE Var_TipoPersona				CHAR(1);									-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial
	DECLARE Var_Titulo					VARCHAR(10);								-- Titulo del Cliente
	DECLARE Var_PaisResidencia			INT(5);										-- ID Pais de Residencia del Cliente
	DECLARE Var_SectorGeneral			INT(3);										-- ID Sector General
	DECLARE Var_ActividadBancoMX		VARCHAR(15);								-- ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX
	DECLARE Var_EstadoCivil				CHAR(2);									-- Estado Cividl del Cliente
	DECLARE Var_LugarNacimiento			INT(11);									-- Pais Lugar de Nacimiento
	DECLARE Var_PromotorInicial			INT(6);										-- ID Promotor Inicial
	DECLARE Var_PromotorActual			INT(6);										-- ID Promotor Actual
	DECLARE Var_ExtTelefonoPart			VARCHAR(7);									-- Extension del Telefono Particular
	DECLARE Var_TipoDireccionID			INT(11);									-- Tipo de Direccion
	DECLARE Var_EstadoID				INT(11);									-- ID Estado del Cliente
	DECLARE Var_MunicipioID				INT(11);									-- ID Municipio del Cliente
	DECLARE Var_LocalidadID				INT(11);									-- ID Localidad del Cliente
	DECLARE Var_ColoniaID				INT(11);									-- ID Colonia del Cliente
	DECLARE Var_Calle					VARCHAR(50);								-- Nombre de la Calle
	DECLARE Var_Numero					CHAR(10);									-- Numero de la Vivienda del Cliente
	DECLARE Var_CP						CHAR(5);									-- Codigo Postal Direccion del Cliente
	DECLARE Var_Oficial					CHAR(1);									-- Valor de direccion Oficial S=SI N=No
	DECLARE Var_Fiscal					CHAR(1);									-- Valor de direccion Fiscal S=SI N=No
	DECLARE Var_NumInterior				CHAR(10);									-- Numero Interior de la Casa o Edificio
	DECLARE Var_Lote					CHAR(50);									-- Numero de Lote la Vivienda del Cliente
	DECLARE Var_Manzana					CHAR(50);									-- Numero de Manzana de la Vivienda del Cliente
	DECLARE Var_TipoIdentiID			INT(11);									-- Tipo de Identificacion del Cliente
	DECLARE Var_NumIdentific			VARCHAR(30);								-- Numero de Identificacion del Documento del Cliente
	DECLARE Var_FecExIden				DATE;										-- Fecha de Expedicion de la Identificacion
	DECLARE Var_FecVenIden				DATE;										-- Fecha de vencimiento de la Identificacion
	DECLARE Var_FechaSistema			DATE;
    DECLARE FechaCargada				DATE;
    DECLARE FolioCargado				INT(11);
	-- Declaracion de constantes
	DECLARE Cadena_Vacia				CHAR(1);									-- Cadena vacia
	DECLARE Fecha_Vacia					DATE;										-- Fecha vacia
	DECLARE Entero_Cero					INT(11);									-- Entero cero
	DECLARE Decimal_Cero				DECIMAL(14,2);								-- Decimal cero
	DECLARE Entero_Uno					INT(11);									-- Entero uno
	DECLARE Var_SalidaSI				CHAR(1);									-- Salida si
	DECLARE Var_SalidaNO				CHAR(1);									-- Salida no

	-- Asignacion de constantes
	SET Cadena_Vacia					:= '';										-- Cadena vacia
	SET Fecha_Vacia						:= '1900-01-01';							-- Fecha vacia
	SET Entero_Cero						:= 0;										-- Entero cero
	SET Decimal_Cero					:= 0.0;										-- Decimal cero
	SET Entero_Uno						:= 1;										-- Entero uno
	SET Var_SalidaSI					:= 'S';										-- Salida si
	SET Var_SalidaNO					:= 'N';										-- Salida no

	-- Valores por default
	SET Par_FolioCarga					:= IFNULL(Par_FolioCarga, Entero_Cero);
	SET Par_FechaCarga					:= IFNULL(Par_FechaCarga, Fecha_Vacia);
	SET Par_PrimerNombre				:= IFNULL(Par_PrimerNombre, Cadena_Vacia);
	SET Par_SegundoNombre				:= IFNULL(Par_SegundoNombre, Cadena_Vacia);
	SET Par_TercerNombre				:= IFNULL(Par_TercerNombre, Cadena_Vacia);
	SET Par_ApellidoPaterno				:= IFNULL(Par_ApellidoPaterno, Cadena_Vacia);
	SET Par_ApellidoMaterno				:= IFNULL(Par_ApellidoMaterno, Cadena_Vacia);
	SET Par_FechaNacimiento				:= IFNULL(Par_FechaNacimiento, Fecha_Vacia);
	SET Par_CURP						:= IFNULL(Par_CURP, Cadena_Vacia);
	SET Par_EstadoNacimientoID			:= IFNULL(Par_EstadoNacimientoID, Entero_Cero);
	SET Par_Sexo						:= IFNULL(Par_Sexo, Cadena_Vacia);
	SET Par_Telefono					:= IFNULL(Par_Telefono, Cadena_Vacia);
	SET Par_TelefonoCelular				:= IFNULL(Par_TelefonoCelular, Cadena_Vacia);
	SET Par_Correo						:= IFNULL(Par_Correo, Cadena_Vacia);
	SET Par_RFC							:= IFNULL(Par_RFC, Cadena_Vacia);
	SET Par_OcupacionID					:= IFNULL(Par_OcupacionID, Entero_Cero);
	SET Par_LugardeTrabajo				:= IFNULL(Par_LugardeTrabajo, Cadena_Vacia);
	SET Par_Puesto						:= IFNULL(Par_Puesto, Cadena_Vacia);
	SET Par_TelTrabajo					:= IFNULL(Par_TelTrabajo, Cadena_Vacia);
	SET Par_NoEmpleado					:= IFNULL(Par_NoEmpleado, Cadena_Vacia);
	SET Par_AntiguedadTra				:= IFNULL(Par_AntiguedadTra, Decimal_Cero);
	SET Par_ExtTelefonoTrab				:= IFNULL(Par_ExtTelefonoTrab, Cadena_Vacia);
	SET Par_TipoEmpleado				:= IFNULL(Par_TipoEmpleado, Cadena_Vacia);
	SET Par_TipoPuesto					:= IFNULL(Par_TipoPuesto, Entero_Cero);
	SET Par_SucursalOrigen				:= IFNULL(Par_SucursalOrigen, Entero_Cero);
	SET Par_TipoPersona					:= IFNULL(Par_TipoPersona, Cadena_Vacia);

	SET	Par_PaisNacionalidad        	:= IFNULL(Par_PaisNacionalidad,Entero_Cero);     
	SET Par_IngresosMensuales       	:= IFNULL(Par_IngresosMensuales,Entero_Cero);       
    SET Par_NiveldeRiesgo           	:= IFNULL(Par_NiveldeRiesgo, Cadena_Vacia);        


	SET Par_Titulo						:= IFNULL(Par_Titulo, Cadena_Vacia);
	SET Par_PaisResidencia				:= IFNULL(Par_PaisResidencia, Entero_Cero);
	SET Par_SectorGeneral				:= IFNULL(Par_SectorGeneral, Entero_Cero);
	SET Par_ActividadBancoMX			:= IFNULL(Par_ActividadBancoMX, Cadena_Vacia);
	SET Par_EstadoCivil					:= IFNULL(Par_EstadoCivil, Cadena_Vacia);
	SET Par_LugarNacimiento				:= IFNULL(Par_LugarNacimiento, Entero_Cero);
	SET Par_PromotorInicial				:= IFNULL(Par_PromotorInicial, Entero_Cero);
	SET Par_PromotorActual				:= IFNULL(Par_PromotorActual, Entero_Cero);
	SET Par_ExtTelefonoPart				:= IFNULL(Par_ExtTelefonoPart, Cadena_Vacia);
	SET Par_TipoDireccionID				:= IFNULL(Par_TipoDireccionID, Entero_Cero);
	SET Par_EstadoID					:= IFNULL(Par_EstadoID, Entero_Cero);
	SET Par_MunicipioID					:= IFNULL(Par_MunicipioID, Entero_Cero);
	SET Par_LocalidadID					:= IFNULL(Par_LocalidadID, Entero_Cero);
	SET Par_ColoniaID					:= IFNULL(Par_ColoniaID, Entero_Cero);
	SET Par_Calle						:= IFNULL(Par_Calle, Cadena_Vacia);
	SET Par_Numero						:= IFNULL(Par_Numero, Cadena_Vacia);
	SET Par_CP							:= IFNULL(Par_CP, Cadena_Vacia);
	SET Par_Oficial						:= IFNULL(Par_Oficial, Cadena_Vacia);
	SET Par_Fiscal						:= IFNULL(Par_Fiscal, Cadena_Vacia);
	SET Par_NumInterior					:= IFNULL(Par_NumInterior, Cadena_Vacia);
	SET Par_Lote						:= IFNULL(Par_Lote, Cadena_Vacia);
	SET Par_Manzana						:= IFNULL(Par_Manzana, Cadena_Vacia);
	SET Par_TipoIdentiID				:= IFNULL(Par_TipoIdentiID, Entero_Cero);
	SET Par_NumIdentific				:= IFNULL(Par_NumIdentific, Cadena_Vacia);
	SET Par_FecExIden					:= IFNULL(Par_FecExIden, Fecha_Vacia);
	SET Par_FecVenIden					:= IFNULL(Par_FecVenIden, Fecha_Vacia);
	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= IFNULL(Aud_FechaActual, Entero_Cero);
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);
    
    SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS;
    
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBALTACLIENTEMASENCVAL');
			SET Var_Control	= 'sqlException';
		END;

		IF Par_FolioCarga = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'Especifique folio de carga';
			SET Var_Control	:= 'folioCarga';
			LEAVE ManejoErrores;
		END IF;
        
        IF Par_FechaCarga <> Var_FechaSistema THEN
			SET Par_NumErr := 2;
            SET Par_ErrMen := 'La Fecha de Carga es diferente a la fecha del sistema';
            SET Var_control := 'FechaCarga';
            LEAVE ManejoErrores;
		END IF;
        
		IF Par_PrimerNombre = Cadena_Vacia THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Primer Nombre esta Vacio.';
			SET Var_Control	:= 'primerNombre';
			LEAVE ManejoErrores;
		END IF;

		IF Par_ApellidoPaterno = Cadena_Vacia THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Apellido Paterno esta Vacio.';
			SET Var_Control	:= 'apellidoPaterno';
			LEAVE ManejoErrores;
		END IF;

		IF Par_FechaNacimiento = Fecha_Vacia THEN
			SET Par_NumErr	:= 30;
			SET Par_ErrMen	:= 'La Fecha de Nacimiento esta Vacia.';
			SET Var_Control	:= 'fechaNacimiento';
			LEAVE ManejoErrores;
		END IF;

		IF Par_CURP = Cadena_Vacia THEN
			SET Par_NumErr	:= 31;
			SET Par_ErrMen	:= 'La CURP esta Vacia.';
			SET Var_Control	:= 'curp';
			LEAVE ManejoErrores;
		END IF;

		IF Par_EstadoNacimientoID = Entero_Cero THEN
			SET Par_NumErr	:= 32;
			SET Par_ErrMen	:= 'El Estado de Nacimiento esta Vacio.';
			SET Var_Control	:= 'estadoNacimientoID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Sexo = Cadena_Vacia THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'El Sexo esta Vacio.';
			SET Var_Control	:= 'sexo';
			LEAVE ManejoErrores;
		END IF;

		IF Par_TelefonoCelular = Cadena_Vacia THEN
			SET Par_NumErr	:= 33;
			SET Par_ErrMen	:= 'El Telefono Celular esta Vacio.';
			SET Var_Control	:= 'telefonoCelular';
			LEAVE ManejoErrores;
		END IF;

		IF Par_RFC = Cadena_Vacia THEN
			SET Par_NumErr	:= 34;
			SET Par_ErrMen	:= 'El RFC esta Vacio.';
			SET Var_Control	:= 'rfc';
			LEAVE ManejoErrores;
		END IF;

		IF Par_OcupacionID = Entero_Cero THEN
			SET Par_NumErr	:= 35;
			SET Par_ErrMen	:= 'La Ocupacion esta Vacia.';
			SET Var_Control	:= 'ocupacionID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_LugardeTrabajo = Cadena_Vacia THEN
			SET Par_NumErr	:= 36;
			SET Par_ErrMen	:= 'El Lugar de Trabajo esta Vacio.';
			SET Var_Control	:= 'lugardeTrabajo';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Puesto = Cadena_Vacia THEN
			SET Par_NumErr	:= 10;
			SET Par_ErrMen	:= 'El Puesto esta Vacio.';
			SET Var_Control	:= 'puesto';
			LEAVE ManejoErrores;
		END IF;

		IF Par_AntiguedadTra = Decimal_Cero THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= 'La Antiguedad de Trabajo esta Vacia.';
			SET Var_Control	:= 'antiguedadTra';
			LEAVE ManejoErrores;
		END IF;

		IF Par_SucursalOrigen = Entero_Cero THEN
			SET Par_NumErr	:= 37;
			SET Par_ErrMen	:= 'La Sucursal de Origen esta Vacia.';
			SET Var_Control	:= 'sucursalOrigen';
			LEAVE ManejoErrores;
		END IF;

		IF Par_TipoPersona = Cadena_Vacia THEN
			SET Par_NumErr	:= 38;
			SET Par_ErrMen	:= 'El Tipo de Persona esta Vacio.';
			SET Var_Control	:= 'tipoPersona';
			LEAVE ManejoErrores;
		END IF;
     
    	IF Par_PaisNacionalidad = Entero_Cero THEN
			SET Par_NumErr	:= 39;
			SET Par_ErrMen	:= 'La Nacionalidad esta Vacia.';
			SET Var_Control	:= 'paisNacionalidad';
			LEAVE ManejoErrores;
		END IF;


    	IF Par_IngresosMensuales = Entero_Cero THEN
			SET Par_NumErr	:= 40;
			SET Par_ErrMen	:= 'Los Ingresos estan vacios.';
			SET Var_Control	:= 'ingresosMensuales';
			LEAVE ManejoErrores;
		END IF;


		IF Par_NiveldeRiesgo = Cadena_Vacia THEN
			SET Par_NumErr	:= 42;
			SET Par_ErrMen	:= 'El nivel de Riesgo esta Vacio.';
			SET Var_Control	:= 'niveldeRiesto';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Titulo = Cadena_Vacia THEN
			SET Par_NumErr	:= 43;
			SET Par_ErrMen	:= 'El Titulo esta Vacio.';
			SET Var_Control	:= 'titulo';
			LEAVE ManejoErrores;
		END IF;

		IF Par_PaisResidencia = Entero_Cero THEN
			SET Par_NumErr	:= 44;
			SET Par_ErrMen	:= 'El Pais de Residencia esta Vacio.';
			SET Var_Control	:= 'paisResidencia';
			LEAVE ManejoErrores;
		END IF;

		IF Par_SectorGeneral = Entero_Cero THEN
			SET Par_NumErr	:= 45;
			SET Par_ErrMen	:= 'El Sector General esta Vacio.';
			SET Var_Control	:= 'sectorGeneral';
			LEAVE ManejoErrores;
		END IF;

		IF Par_ActividadBancoMX = Cadena_Vacia THEN
			SET Par_NumErr	:= 46;
			SET Par_ErrMen	:= 'La Actividad esta Vacia.';
			SET Var_Control	:= 'actividadBancoMX';
			LEAVE ManejoErrores;
		END IF;

		IF Par_EstadoCivil = Cadena_Vacia THEN
			SET Par_NumErr	:= 47;
			SET Par_ErrMen	:= 'El Estado Civil esta Vacio.';
			SET Var_Control	:= 'estadoCivil';
			LEAVE ManejoErrores;
		END IF;

		IF Par_LugarNacimiento = Entero_Cero THEN
			SET Par_NumErr	:= 48;
			SET Par_ErrMen	:= 'El Lugar de Nacimiento esta Vacio.';
			SET Var_Control	:= 'lugarNacimiento';
			LEAVE ManejoErrores;
		END IF;

		IF Par_PromotorInicial = Entero_Cero THEN
			SET Par_NumErr	:= 49;
			SET Par_ErrMen	:= 'El Promotor Inicial esta Vacio.';
			SET Var_Control	:= 'promotorInicial';
			LEAVE ManejoErrores;
		END IF;

		IF Par_PromotorActual = Entero_Cero THEN
			SET Par_NumErr	:= 50;
			SET Par_ErrMen	:= 'El Promotor Actual esta Vacio.';
			SET Var_Control	:= 'promotorActual';
			LEAVE ManejoErrores;
		END IF;

		IF Par_TipoDireccionID = Entero_Cero THEN
			SET Par_NumErr	:= 51;
			SET Par_ErrMen	:= 'El Tipo de Direccion esta Vacio.';
			SET Var_Control	:= 'tipoDireccionID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_EstadoID = Entero_Cero THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'El Estado esta Vacio.';
			SET Var_Control	:= 'estadoID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_MunicipioID = Entero_Cero THEN
			SET Par_NumErr	:= 14;
			SET Par_ErrMen	:= 'El Municipio esta Vacio.';
			SET Var_Control	:= 'municipioID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_LocalidadID = Entero_Cero THEN
			SET Par_NumErr	:= 19;
			SET Par_ErrMen	:= 'La Localidad esta Vacia.';
			SET Var_Control	:= 'localidadID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_ColoniaID = Entero_Cero THEN
			SET Par_NumErr	:= 17;
			SET Par_ErrMen	:= 'La Colonia esta Vacia.';
			SET Var_Control	:= 'coloniaID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Calle = Cadena_Vacia THEN
			SET Par_NumErr	:= 15;
			SET Par_ErrMen	:= 'La Calle esta Vacia.';
			SET Var_Control	:= 'calle';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Numero = Cadena_Vacia THEN
			SET Par_NumErr	:= 16;
			SET Par_ErrMen	:= 'El Numero esta Vacio.';
			SET Var_Control	:= 'numero';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Oficial = Cadena_Vacia THEN
			SET Par_NumErr	:= 52;
			SET Par_ErrMen	:= 'Indique si es Direccion Oficial.';
			SET Var_Control	:= 'oficial';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Fiscal = Cadena_Vacia THEN
			SET Par_NumErr	:= 53;
			SET Par_ErrMen	:= 'Indique si es Direccion Fiscal.';
			SET Var_Control	:= 'fiscal';
			LEAVE ManejoErrores;
		END IF;

		IF Par_TipoIdentiID = Entero_Cero THEN
			SET Par_NumErr	:= 54;
			SET Par_ErrMen	:= 'Indique el Tipo de Identificacion.';
			SET Var_Control	:= 'tipoIdentiID';
			LEAVE ManejoErrores;
		END IF;

		IF Par_NumIdentific = Cadena_Vacia THEN
			SET Par_NumErr	:= 55;
			SET Par_ErrMen	:= 'Indique el Numero del Documento de Identificacion.';
			SET Var_Control	:= 'numIdentific';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Validaciones finalizadas exitosamente';
		SET Var_Control		:= 'folioCarga';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF Par_Salida = Var_SalidaSI THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_FolioCarga			AS consecutivo;
	END IF;
END TerminaStore$$