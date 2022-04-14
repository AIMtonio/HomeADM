-- UNIFICACREACLIENTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `UNIFICACREACLIENTEPRO`;

DELIMITER $$

CREATE PROCEDURE UNIFICACREACLIENTEPRO (
# =====================================================================================
# ------- STORE UNIFICA PARA CREAR CLIENTES ---------
# =====================================================================================

	Par_Salida					CHAR(1), 		-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Descripcion de Error
/* Parametros de Auditoria */
	Par_EmpresaID 				INT(11),		-- Parametro de Auditoria
	Aud_Usuario 				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual 			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

 -- Declaracion de Variables
	DECLARE Var_Control 			VARCHAR(30);		-- Var Control del Manejo de Errores
	DECLARE Var_ClienteID 			INT(11);			-- Variable para obtener el Ciente a consultar
	DECLARE Var_ClienteIDUpd		INT(11);			-- Variable para consultar el cliente que se dio de alta
	DECLARE Var_Sentencia			VARCHAR(5000); 		-- Variable para la sentencia dinamica
	DECLARE Var_Bitacora			VARCHAR(5000); 		-- Variable para la sentencia dimanica
	DECLARE Var_NombreTabla			VARCHAR(40);		-- Nombre de la tabla
	DECLARE Var_Consecutivo			INT(11);			-- Consecutivo
	DECLARE Var_TotalRegistros		INT(11);			-- Variable para el total de registros a iterar


	DECLARE Var_Clasificacion		CHAR(1);			-- Clasificacion del Cliente
	DECLARE Var_Nacionalidad 		VARCHAR(4);			-- Nacionalidad del Cliente
	DECLARE Var_MotivoApertura		VARCHAR(4);			-- Motivo de Apertura
	DECLARE Var_PagaISR				CHAR(1);			-- Paga ISR

	DECLARE Var_PagaIVA				CHAR(1);			-- Paga IVA
	DECLARE Var_PagaIDE				CHAR(1);			-- Paga IDE

	DECLARE Var_ActINEGI			INT(11);			-- Numero de la Actividad INEGI
	DECLARE Var_ActFR 				BIGINT;				-- Numero de la Actividad FR
	DECLARE Var_ActFOMUR			INT(11);			-- Numero de la Actividad FOMUR
	DECLARE Var_SectorEco			INT(11);			-- Numero del Sector Economico

	DECLARE Var_CorpRelacionado		INT(11);			-- Es el dato de corporativo relacionado a el cliente
	DECLARE Var_EsMenorEdad			CHAR(1);			-- El cliente es menor de edad S; N
	DECLARE Var_CalificaCredito 	CHAR (1);			-- Constante para Calificacion
	DECLARE Var_Observaciones		VARCHAR(500);		-- Observaciones
	DECLARE Var_EjecutivoCap		CHAR(5);			-- Ejecutivo de captacion 0 No Asignado
	DECLARE Var_PromotorExtInv		CHAR(5);			-- Promotor Extreno de inversion 0 No Asignado
	DECLARE Var_FechaIniTrabajo		DATE;				-- Fecha de inicio en el trabajo actual
	DECLARE Var_UbicaNegocioID		INT(11);			-- ID de la ubicacion del negocio; relacion con CATUBICANEGOCIO
	DECLARE Var_FechaCons			DATE;				-- Fecha constitucion RFC
	DECLARE Var_FEA					VARCHAR(250);		-- Pais Asignado FEA
	DECLARE Var_PaisFEA				INT(11);			-- ID Pais Asignado FEA
	DECLARE Var_PaisConstitucionID	INT(11);			-- Pais de constitucion campo para Personas Morales

	DECLARE Var_CorreoAlterPM		VARCHAR(50);		-- Correo alternativo para Persona Moral
	DECLARE Var_NombreNotario		VARCHAR(150);		-- Nombre del notario campo para Persona Morales
	DECLARE Var_NumNotario			INT(11);			-- Numero del notario campo para Personas Morales
	DECLARE Var_InscripcionReg		VARCHAR(50);		-- Numero de inscripcion en el registro publico campo para Personas Morales
	DECLARE Var_EscrituraPubPM		VARCHAR(20);		-- Escritura Publica Persona Moral
	DECLARE Var_DomicilioTrabajo	VARCHAR(500);		-- Domicilio de trabajo del cliente

	DECLARE Var_EmpresaID			INT(11);			-- Empresa ID
	DECLARE Var_Estatus				CHAR(1);			-- Estatus del Cliente


	DECLARE Var_RazonSocial			VARCHAR(150);		-- Razon social del cliente
	DECLARE Var_TipoSocID			INT(11);			-- Tipo de sociedad
	DECLARE Var_RFCpm				CHAR(13);			-- RFC
	DECLARE Var_GrupoEmp			INT(11);			-- Grupo
	DECLARE Var_Fax					VARCHAR(30);		-- Fax de contacto del cliente
	DECLARE Var_Piso				CHAR(50);			-- PISO de la Direccion
	DECLARE Var_DirDescripcion		VARCHAR(500);		-- DESCRIPCION de la Direccion
	DECLARE Var_PrimECalle			VARCHAR(50);		-- CALLE
	DECLARE Var_SegECalle			VARCHAR(50);		-- SEGUNDA CALLE
	DECLARE Var_Latitud				VARCHAR(45);		-- LATITUD de Direccion
	DECLARE Var_Longitud			VARCHAR(45);		-- LONGITUD de Direccion
	DECLARE Var_RegistroHacienda	CHAR(1);			-- Esta registrado en hacienda

	DECLARE Var_PrimerNombre		VARCHAR(50); 	-- Primer Nombre del Cliente
	DECLARE Var_SegundoNombre		VARCHAR(50);	-- Segundo Nombre del Cliente
	DECLARE Var_TercerNombre		VARCHAR(50); 	-- Tercer Nombre del Cliente
	DECLARE Var_ApellidoPaterno		VARCHAR(50); 	-- Apellido Paterno del Cliente
	DECLARE Var_ApellidoMaterno		VARCHAR(50); 	-- Apellido Materno del Cliente

	DECLARE Var_FechaNacimiento		DATE; 		 	-- Fecha de Nacimiento del Cliente
	DECLARE Var_CURP				CHAR(18); 	 	-- CURP del Cliente
	DECLARE Var_EstadoNacimientoID	INT(11);		-- ID Estado de Nacimiento
	DECLARE Var_Sexo				CHAR(1);     	-- Sexo del Cliente
	DECLARE Var_Telefono			VARCHAR(20); 	-- Telefono Oficial del Cliente

	DECLARE Var_TelefonoCelular		VARCHAR(20); 	-- Telefono Celular del Cliente
	DECLARE Var_Correo				VARCHAR(50); 	-- Correo Electronico del Cliente
	DECLARE Var_RFC					CHAR(13); 	 	-- RFC del Cliente
	DECLARE Var_OcupacionID			INT(11);		-- Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)
	DECLARE Var_LugardeTrabajo		VARCHAR(150);	-- Lugar de Trabajo del Cliente

	DECLARE Var_Puesto				VARCHAR(150);	-- Puesto de Trabajo del Cliente
	DECLARE Var_TelTrabajo			VARCHAR(20);	-- Telefono Trabajo del Cliente
	DECLARE Var_NoEmpleado			VARCHAR(20);	-- Indica el Numero de Empleado de la Empresa de Nomina a la que esta ligado el Cliente
	DECLARE Var_AntiguedadTra		DECIMAL(12,2); 	-- Antiguedad del Trabajo
	DECLARE Var_ExtTelefonoTrab		VARCHAR(10);	-- Extension del Telefono Trabajo del Cliente

	DECLARE Var_TipoEmpleado		CHAR(1); 	 	-- Tipo de Empleado
	DECLARE Var_TipoPuesto			INT(11); 	 	-- Tipo de Puesto
	DECLARE Var_SucursalOrigen		INT(5);		 	-- ID Sucursal del Cliente
	DECLARE Var_TipoPersona			CHAR(1);		-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial
	DECLARE Var_PaisNacionalidad	INT(11);		-- Indica el País de Nacionalidad; es decir, el país al que corresponde legalmente el cliente.

	DECLARE Var_IngresosMensuales	DECIMAL(14,2);  -- Monto de los ingresos mensuales reportados por el cliente
	DECLARE Var_TamanioAcreditado	INT(11);		-- Clave que indica el Tamaño del Acreditado (Aplica solo para créditos comerciales)(0,1,2,3,4)
	DECLARE Var_NiveldeRiesgo		CHAR(1);		-- Indica el Nivel de Riesgo del Cliente: A: Alto M: Medio B: Bajo
	DECLARE Var_Titulo				VARCHAR(10);	-- Titulo del Cliente, Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc

	DECLARE Var_PaisResidencia		INT(5);			-- ID Pais de Residencia del Cliente
	DECLARE Var_SectorGeneral		INT(3);			-- ID Sector General
	DECLARE Var_ActividadBancoMX	VARCHAR(15); 	-- ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX
	DECLARE Var_EstadoCivil			CHAR(2); 	 	-- Estado Cividl del Cliente
	DECLARE Var_LugarNacimiento		INT(11);		-- Pais Lugar de Nacimiento

	DECLARE Var_PromotorInicial		INT(6);			-- ID Promotor Inicial
	DECLARE Var_PromotorActual		INT(6);			-- ID Promotor Actual
	DECLARE Var_ExtTelefonoPart		VARCHAR(7);		-- Extension del Telefono Particular
	DECLARE Var_TipoDireccionID		INT(11);		-- Tipo de Direccion
	DECLARE Var_EstadoID			INT(11);		-- ID Estado del Cliente

	DECLARE Var_MunicipioID			INT(11);		-- ID Municipio del Cliente
	DECLARE Var_LocalidadID			INT(11);		-- ID Localidad del Cliente
	DECLARE Var_ColoniaID			INT(11);		-- ID Colonia del Cliente
	DECLARE Var_Calle				VARCHAR(50); 	-- Nombre de la Calle
	DECLARE Var_Numero				CHAR(10);		-- Numero de la Vivienda del Cliente

	DECLARE Var_CP					CHAR(5);		-- Codigo Postal Direccion del Cliente
	DECLARE Var_Oficial				CHAR(1);		-- Valor de direccion Oficial S=SI; N=No
	DECLARE Var_Fiscal				CHAR(1);		-- Valor de direccion Fiscal S=SI, N=No
	DECLARE Var_NumInterior			CHAR(10);		-- Numero Interior de la Casa o Edificio
	DECLARE Var_Lote				CHAR(50);		-- Numero de Lote la Vivienda del Cliente

	DECLARE Var_Manzana				CHAR(50);		-- Numero de Manzana de la Vivienda del Cliente
	DECLARE Var_TipoIdentiID		INT(11);		-- Tipo de Identificacion del Cliente
	DECLARE Var_NumIdentific		VARCHAR(30);	-- Numero de Identificacion del Documento del Cliente
	DECLARE Var_FecExIden			DATE;			-- Fecha de Expedicion de la Identificacion
	DECLARE Var_FecVenIden			DATE;			-- Fecha de vencimiento de la Identificacion
	DECLARE Var_FechaBaja			DATE;			-- Fecha de Baja

 -- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Decimal_Cero			DECIMAL(12,2);
	DECLARE Fecha_Vacia				DATE;
	DECLARE SalidaSI				CHAR(1);

	DECLARE SalidaNO 				CHAR(1);
	DECLARE Var_TipoDirOficial		INT(11);
	DECLARE Var_No 					CHAR(1);
	DECLARE Var_Creado 				CHAR(1);

 -- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero		:= 0.00;				-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET SalidaSI			:= 'S';        			-- El Store SI genera una Salida
	SET SalidaNO			:= 'N';					-- Salida no

	SET Var_TipoDirOficial 	:= 1;					-- Tipo de Direccion Oficial
	SET Var_ClienteID 		:= 0;					-- Inicializa el ID en cero
	SET Var_No 				:= 'N';					-- Constante No
	SET Var_Creado 			:= 'C';					-- Constante para indicar que se Creo el Cliente

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 	:= '999';
				SET Par_ErrMen 	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-UNIFICACREACLIENTEPRO');
				SET Var_Control := 'sqlException';

			END;

		-- Truncar la tabla tempora para crear los clientes
		TRUNCATE TABLE TMPUNICREACLIENTE;

		SET @RegistroClientesID := 0;

		INSERT INTO TMPUNICREACLIENTE(
			NumRegistro, ClienteID)
		SELECT (@RegistroClientesID := @RegistroClientesID +1),
				Bus.ClienteID
			FROM TMPUNIFICABUSQUEDACLI Bus
			WHERE Bus.Existe = Var_No
			GROUP BY Bus.ClienteID;

		SET Var_TotalRegistros := 0;

		SELECT	COUNT(ClienteID)
			INTO Var_TotalRegistros
			FROM TMPUNICREACLIENTE;

		SET Var_Consecutivo 	:= 1;

		IteraCreaCliente: WHILE (Var_Consecutivo <= Var_TotalRegistros) DO
		-- SE INICIALIZAN VARIABLES
			SET Var_ClienteIDUpd 		:= Entero_Cero;
			SET Par_NumErr 				:= Entero_Cero;
			SET Par_ErrMen 				:= Cadena_Vacia;

			SET Var_PrimerNombre		:= Cadena_Vacia;
			SET Var_SegundoNombre		:= Cadena_Vacia;
			SET Var_TercerNombre		:= Cadena_Vacia;
			SET Var_ApellidoPaterno		:= Cadena_Vacia;
			SET Var_ApellidoMaterno		:= Cadena_Vacia;
			SET Var_FechaNacimiento		:= Fecha_Vacia;
			SET Var_CURP				:= Cadena_Vacia;
			SET Var_Nacionalidad		:= Cadena_Vacia;
			SET Var_PaisResidencia		:= Entero_Cero;
			SET Var_GrupoEmp			:= Entero_Cero;
			SET Var_RazonSocial			:= Cadena_Vacia;
			SET Var_TipoSocID			:= Entero_Cero;
			SET Var_Fax					:= Cadena_Vacia;
			SET Var_Correo				:= Cadena_Vacia;
			SET Var_RFC					:= Cadena_Vacia;
			SET Var_RFCpm				:= Cadena_Vacia;
			SET Var_SectorGeneral		:= Entero_Cero;
			SET Var_ActividadBancoMX	:= Cadena_Vacia;
			SET Var_ActINEGI			:= Entero_Cero;
			SET Var_SectorEco			:= Entero_Cero;
			SET Var_Sexo				:= Cadena_Vacia;
			SET Var_EstadoCivil			:= Cadena_Vacia;
			SET Var_LugarNacimiento		:= Entero_Cero;
			SET Var_EstadoID			:= Entero_Cero;
			SET Var_OcupacionID			:= Entero_Cero;
			SET Var_LugardeTrabajo		:= Cadena_Vacia;
			SET Var_Puesto				:= Cadena_Vacia;
			SET Var_TelTrabajo			:= Cadena_Vacia;
			SET Var_AntiguedadTra		:= Decimal_Cero;
			SET Var_TelefonoCelular		:= Cadena_Vacia;
			SET Var_Telefono			:= Cadena_Vacia;
			SET Var_Clasificacion		:= Cadena_Vacia;
			SET Var_MotivoApertura		:= Cadena_Vacia;
			SET Var_PagaISR				:= Cadena_Vacia;
			SET Var_PagaIVA				:= Cadena_Vacia;
			SET Var_PagaIDE				:= Cadena_Vacia;
			SET Var_NiveldeRiesgo		:= Cadena_Vacia;
			SET Var_PromotorInicial		:= Entero_Cero;
			SET Var_PromotorActual		:= Entero_Cero;
			SET Var_Estatus				:= Cadena_Vacia;
			SET Var_CorpRelacionado		:= Entero_Cero;
			SET Var_FechaBaja			:= Fecha_Vacia;
			SET Var_ActFR				:= Entero_Cero;
			SET Var_ActFOMUR			:= Entero_Cero;
			SET Var_EsMenorEdad			:= Cadena_Vacia;
			SET Var_CalificaCredito		:= Cadena_Vacia;
			SET Var_Observaciones		:= Cadena_Vacia;
			SET Var_NoEmpleado			:= Cadena_Vacia;
			SET Var_TipoEmpleado		:= Cadena_Vacia;
			SET Var_ExtTelefonoPart		:= Cadena_Vacia;
			SET Var_ExtTelefonoTrab		:= Cadena_Vacia;
			SET Var_EjecutivoCap		:= Cadena_Vacia;
			SET Var_PromotorExtInv		:= Cadena_Vacia;
			SET Var_TipoPuesto			:= Entero_Cero;
			SET Var_FechaIniTrabajo		:= Fecha_Vacia;
			SET Var_UbicaNegocioID		:= Entero_Cero;
			SET Var_FechaCons			:= Fecha_Vacia;
			SET Var_FEA					:= Cadena_Vacia;
			SET Var_PaisFEA				:= Entero_Cero;
			SET Var_PaisConstitucionID	:= Entero_Cero;
			SET Var_CorreoAlterPM		:= Cadena_Vacia;
			SET Var_NombreNotario		:= Cadena_Vacia;
			SET Var_NumNotario			:= Entero_Cero;
			SET Var_InscripcionReg		:= Cadena_Vacia;
			SET Var_EscrituraPubPM		:= Cadena_Vacia;
			SET Var_DomicilioTrabajo	:= Cadena_Vacia;
			SET Var_PaisNacionalidad	:= Entero_Cero;
			SET Var_EmpresaID			:= Entero_Cero;
			SET Var_SucursalOrigen		:= Entero_Cero;
			SET Var_TipoPersona			:= Cadena_Vacia;
			SET Var_Titulo				:= Cadena_Vacia;


			SELECT ClienteID
				INTO Var_ClienteID
			FROM TMPUNICREACLIENTE
			WHERE NumRegistro = Var_Consecutivo;

			/* Obtener Datos del Cliente a dar de Alta */

			SELECT
			PrimerNombre,		SegundoNombre,			TercerNombre,			ApellidoPaterno,		ApellidoMaterno,
			FechaNacimiento,	CURP,					Nacion,					PaisResidencia,			GrupoEmpresarial,
			RazonSocial,		TipoSociedadID,			Fax,					Correo,					RFC,
			RFCpm,				SectorGeneral,			ActividadBancoMX,		ActividadINEGI,			SectorEconomico,
			Sexo,				EstadoCivil,			LugarNacimiento,		EstadoID,				OcupacionID,
			LugardeTrabajo,		Puesto,					TelTrabajo,				AntiguedadTra,			TelefonoCelular,
			Telefono,			Clasificacion,			MotivoApertura,			PagaISR,				PagaIVA,
			PagaIDE,			NivelRiesgo,			PromotorInicial,		PromotorActual,			Estatus,
			CorpRelacionado,	FechaBaja,				ActividadFR,			ActividadFOMURID,		EsMenorEdad,
			CalificaCredito,	Observaciones,			NoEmpleado,				TipoEmpleado,			ExtTelefonoPart,
			ExtTelefonoTrab,	EjecutivoCap,			PromotorExtInv,			TipoPuesto,				FechaIniTrabajo,
			UbicaNegocioID,		FechaConstitucion,		FEA,					PaisFEA,				PaisConstitucionID,
			CorreoAlterPM,		NombreNotario,			NumNotario,				InscripcionReg,			EscrituraPubPM,
			DomicilioTrabajo,	PaisNacionalidad,		EmpresaID,				SucursalOrigen,			TipoPersona,
			Titulo,				TamanioAcreditado,		RegistroHacienda

			INTO
			Var_PrimerNombre,		Var_SegundoNombre, 		Var_TercerNombre,		Var_ApellidoPaterno,	Var_ApellidoMaterno,
			Var_FechaNacimiento,	Var_CURP, 				Var_Nacionalidad, 		Var_PaisResidencia,		Var_GrupoEmp,
			Var_RazonSocial,		Var_TipoSocID,			Var_Fax,				Var_Correo,				Var_RFC,
			Var_RFCpm,				Var_SectorGeneral,		Var_ActividadBancoMX,	Var_ActINEGI,			Var_SectorEco,
			Var_Sexo,				Var_EstadoCivil,		Var_LugarNacimiento,	Var_EstadoNacimientoID,	Var_OcupacionID,
			Var_LugardeTrabajo,		Var_Puesto,				Var_TelTrabajo,			Var_AntiguedadTra,		Var_TelefonoCelular,
			Var_Telefono,			Var_Clasificacion,		Var_MotivoApertura,		Var_PagaISR,			Var_PagaIVA,
			Var_PagaIDE,			Var_NiveldeRiesgo,		Var_PromotorInicial,	Var_PromotorActual,		Var_Estatus,
			Var_CorpRelacionado,	Var_FechaBaja,			Var_ActFR,				Var_ActFOMUR,			Var_EsMenorEdad,
			Var_CalificaCredito,	Var_Observaciones,		Var_NoEmpleado,			Var_TipoEmpleado,		Var_ExtTelefonoPart,
			Var_ExtTelefonoTrab,	Var_EjecutivoCap,		Var_PromotorExtInv,		Var_TipoPuesto,			Var_FechaIniTrabajo,
			Var_UbicaNegocioID,		Var_FechaCons,			Var_FEA,				Var_PaisFEA,			Var_PaisConstitucionID,
			Var_CorreoAlterPM,		Var_NombreNotario,		Var_NumNotario,			Var_InscripcionReg,		Var_EscrituraPubPM,
			Var_DomicilioTrabajo,	Var_PaisNacionalidad,	Var_EmpresaID, 			Var_SucursalOrigen, 	Var_TipoPersona,
			Var_Titulo,				Var_TamanioAcreditado,	Var_RegistroHacienda
			FROM CLIENTES
			WHERE ClienteID = Var_ClienteID;


			SELECT
					TipoDireccionID,	EstadoID,			MunicipioID,		LocalidadID,		ColoniaID,
					Calle,				NumeroCasa,			NumInterior,		Piso,
					PrimeraEntreCalle,	SegundaEntreCalle,	CP,					Descripcion,		Latitud,
					Longitud,			Oficial,			Fiscal,				Lote,				Manzana
			INTO 	Var_TipoDireccionID, 	Var_EstadoID,	Var_MunicipioID,	Var_LocalidadID,	Var_ColoniaID,
					Var_Calle,				Var_Numero,		Var_NumInterior,	Var_Piso,
					Var_PrimECalle,			Var_SegECalle,	Var_CP,				Var_DirDescripcion,	Var_Latitud,
					Var_Longitud,			Var_Oficial,	Var_Fiscal,			Var_Lote,			Var_Manzana
			FROM DIRECCLIENTE
			WHERE ClienteID 		= Var_ClienteID
			  AND TipoDireccionID 	= Var_TipoDirOficial
			LIMIT 1;

			SELECT 	TipoIdentiID,		NumIdentific,		FecExIden,		FecVenIden
			INTO 	Var_TipoIdentiID,	Var_NumIdentific,	Var_FecExIden,	Var_FecVenIden
			FROM IDENTIFICLIENTE
			WHERE ClienteID = Var_ClienteID
			LIMIT 1;

			SELECT 	Monto
				INTO Var_IngresosMensuales
			FROM CLIDATSOCIOE
			WHERE ClienteID = Var_ClienteID
			LIMIT 1;

			-- Modificar con el nombre de la Base
			CALL microfinCred.UNIFICACLIENTESALT(
				Var_PrimerNombre,		Var_SegundoNombre, 		Var_TercerNombre,		Var_ApellidoPaterno,	Var_ApellidoMaterno,
				Var_FechaNacimiento,	Var_CURP, 				Var_EstadoNacimientoID,	Var_Sexo,				Var_Telefono,
				Var_TelefonoCelular,	Var_Correo,				Var_RFC,				Var_OcupacionID,		Var_LugardeTrabajo,
				Var_Puesto,				Var_TelTrabajo,			Var_NoEmpleado,			Var_AntiguedadTra,		Var_ExtTelefonoTrab,
				Var_TipoEmpleado,		Var_TipoPuesto,			Var_SucursalOrigen,		Var_TipoPersona,		Var_PaisNacionalidad,
				Var_IngresosMensuales,	Var_TamanioAcreditado,	Var_NiveldeRiesgo,		Var_Titulo,				Var_Piso,
				Var_PaisResidencia,		Var_SectorGeneral,		Var_ActividadBancoMX,	Var_EstadoCivil,		Var_LugarNacimiento,
				Var_PromotorInicial,	Var_PromotorActual,		Var_ExtTelefonoPart,	Var_TipoDireccionID,	Var_EstadoID,
				Var_MunicipioID,		Var_LocalidadID,		Var_ColoniaID,			Var_Calle,				Var_Numero,
				Var_CP,					Var_Oficial,			Var_Fiscal,				Var_NumInterior,		Var_Lote,
				Var_Manzana,			Var_TipoIdentiID,		Var_NumIdentific,		Var_FecExIden,			Var_FecVenIden,
				Var_FEA,				Var_PaisFEA,			Var_FechaCons,			Var_PaisConstitucionID, Var_CorreoAlterPM,
				Var_NombreNotario,		Var_NumNotario,			Var_InscripcionReg,		Var_EscrituraPubPM,		Var_DirDescripcion,
				Var_RazonSocial,		Var_TipoSocID,			Var_RFCpm,				Var_GrupoEmp,			Var_Fax,
				Var_Clasificacion,		Var_MotivoApertura,		Var_PagaISR,			Var_PagaIVA,			Var_PagaIDE,
				Var_Observaciones,		Var_EjecutivoCap,		Var_PromotorExtInv,		Var_FechaIniTrabajo,	Var_UbicaNegocioID,
				Var_EsMenorEdad,		Var_CorpRelacionado,	Var_DomicilioTrabajo,	Var_ActINEGI,			Var_SectorEco,
				Var_ActFR,				Var_ActFOMUR,			Var_Nacionalidad,		Var_PrimECalle,			Var_SegECalle,
				Var_Latitud,			Var_Longitud,			Var_RegistroHacienda,	Var_ClienteIDUpd,		SalidaNO,
				Par_NumErr, 			Par_ErrMen, 			Par_EmpresaID,			Aud_Usuario, 			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


			IF Var_ClienteIDUpd != Entero_Cero THEN
				/* Actualizar datos que no se envian el SP de alta*/
				-- Modificar con el nombre de la Base
				UPDATE microfinCred.CLIENTES SET
					FechaBaja 			= Var_FechaBaja,
					Estatus 			= Var_Estatus,
					CalificaCredito 	= Var_CalificaCredito,
					TamanioAcreditado 	= Var_TamanioAcreditado
				WHERE ClienteID = Var_ClienteIDUpd;

				UPDATE TMPUNIFICABUSQUEDACLI SET
					ClienteIDUpd 		= Var_ClienteIDUpd,
					Existe 				= Var_Creado
				WHERE ClienteID 	= Var_ClienteID
				  AND Existe 		= Var_No;

			ELSE
				UPDATE TMPUNIFICABUSQUEDACLI SET
						Existe 		= Var_No,
						NumErr 		= Par_NumErr,
						ErrMen 		= Par_ErrMen
				WHERE ClienteID = Var_ClienteID;
			END IF;

			SET Var_Consecutivo := Var_Consecutivo +1;

		END WHILE IteraCreaCliente;

		/* Actualizar el Cliente que se dio de alta en CLIENTESCAPTACION */
		UPDATE CLIENTESCAPTACION C, TMPUNIFICABUSQUEDACLI T SET
			C.ClienteIDUpd = T.ClienteIDUpd
		WHERE C.ClienteID = T.ClienteID
		  AND (T.ClienteIDUpd IS NOT NULl
			OR T.ClienteIDUpd != Entero_Cero);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Proceso Unifica Crear Clientes Termino Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen		AS mensajeRespuesta;
	END IF;

END TerminaStore$$