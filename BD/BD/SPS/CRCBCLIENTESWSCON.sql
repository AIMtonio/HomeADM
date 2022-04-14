-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCLIENTESWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCLIENTESWSCON`;

DELIMITER $$
CREATE PROCEDURE `CRCBCLIENTESWSCON`(
	Par_ClienteID				INT(11),		-- Identificador del cliente a consultar	
	
	Par_Salida					CHAR(1), 		-- Indica mensaje de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Descripcion de Error
	

    Par_EmpresaID		        INT(11),		-- Parametro de Auditoria
	Aud_Usuario			        INT(11),		-- Parametro de Auditoria
	Aud_FechaActual		  		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)

TerminaStore:BEGIN
	-- Declaracion de Constantes
	DECLARE Entero_Cero             INT(11);
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Decimal_Cero	        DECIMAL(12,2);
	DECLARE Fecha_Vacia             DATE;
	DECLARE SalidaSI				CHAR(1);
	
	-- Declaracion de variables
	DECLARE Var_LastID				INT(11);
	
	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero	    :=  0.00;   	 		-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET SalidaSI			:= 'S';					-- Salida Si

	-- Tabla temporal de clientes
	DROP TABLE IF EXISTS TMPCLIENTEWS;
	CREATE TEMPORARY TABLE TMPCLIENTEWS (
		ClienteId               INT(11),    		-- Numero de cliente que proviene de cartera
		PrimerNombre            VARCHAR(50), 	-- Primer Nombre del Cliente
		SegundoNombre           VARCHAR(50),    -- Segundo Nombre del Cliente
		TercerNombre            VARCHAR(50), 	-- Tercer Nombre del Cliente
		ApellidoPaterno	        VARCHAR(50), 	-- Apellido Paterno del Cliente
		ApellidoMaterno   		VARCHAR(50), 	-- Apellido Materno del Cliente

		FechaNacimiento			DATE, 		 	-- Fecha de Nacimiento del Cliente
		CURP 				    CHAR(18), 	 	-- CURP del Cliente
		EstadoNacimientoID		INT(11),		-- ID Estado de Nacimiento
		Sexo					CHAR(1),     	-- Sexo del Cliente
		Telefono				VARCHAR(20), 	-- Telefono Oficial del Cliente

		TelefonoCelular			VARCHAR(20), 	-- Telefono Celular del Cliente
		Correo					VARCHAR(50), 	-- Correo Electronico del Cliente
		RFC						CHAR(13), 	 	-- RFC del Cliente
		OcupacionID				INT(11),		-- Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)
		LugardeTrabajo			VARCHAR(150),	-- Lugar de Trabajo del Cliente

		Puesto					VARCHAR(150),	-- Puesto de Trabajo del Cliente
		TelTrabajo				VARCHAR(20),	-- Telefono Trabajo del Cliente
		NoEmpleado				VARCHAR(20),	-- Indica el Numero de Empleado de la Empresa de Nomina a la que esta ligado el Cliente
		AntiguedadTra			DECIMAL(12,2), 	-- Antiguedad del Trabajo
		ExtTelefonoTrab			VARCHAR(10),	-- Extension del Telefono Trabajo del Cliente

		TipoEmpleado			CHAR(1), 	 	-- Tipo de Empleado
		TipoPuesto				INT(11), 	 	-- Tipo de Puesto
		SucursalOrigen			INT(5),		 	-- ID Sucursal del Cliente
		TipoPersona				CHAR(1),		-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial
		PaisNacionalidad        INT(11),         -- Indica el País de Nacionalidad, es decir, el país al que corresponde legalmente el cliente.

		IngresosMensuales       DECIMAL(14,2),  -- Monto de los ingresos mensuales reportados por el cliente
		TamanioAcreditado       INT(11),        -- Clave que indica el Tamaño del Acreditado (Aplica solo para créditos comerciales)(0,1,2,3,4)
		NiveldeRiesgo           CHAR(1),        -- Indica el Nivel de Riesgo del Cliente: A: Alto M: Medio B: Bajo
		Titulo					VARCHAR(10),	-- Titulo del Cliente, Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc
		PaisResidencia			INT(5),     	-- ID Pais de Residencia del Cliente

		SectorGeneral			INT(3),      	-- ID Sector General
		ActividadBancoMX		VARCHAR(15), 	-- ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX
		EstadoCivil				CHAR(2), 	 	-- Estado Cividl del Cliente
		LugarNacimiento			INT(11),       	-- Pais Lugar de Nacimiento
		PromotorInicial			INT(6),      	-- ID Promotor Inicial

		PromotorActual			INT(6),      	-- ID Promotor Actual
		ExtTelefonoPart			VARCHAR(7),     -- Extension del Telefono Particular
		TipoDireccionID			INT(11),     	-- Tipo de Direccion
		EstadoID				INT(11),     	-- ID Estado del Cliente
		MunicipioID				INT(11),     	-- ID Municipio del Cliente

		LocalidadID				INT(11),     	-- ID Localidad del Cliente
		ColoniaID				INT(11),     	-- ID Colonia del Cliente
		Calle					VARCHAR(50), 	-- Nombre de la Calle
		Numero					CHAR(10),    	-- Numero de la Vivienda del Cliente
		CP						CHAR(5),		-- Codigo Postal Direccion del Cliente

		Oficial					CHAR(1),		-- Valor de direccion Oficial S=SI, N=No
		Fiscal					CHAR(1),		-- Valor de direccion Fiscal S=SI, N=No
		NumInterior				CHAR(10),		-- Numero Interior de la Casa o Edificio
		Lote					CHAR(50),		-- Numero de Lote la Vivienda del Cliente
		Manzana					CHAR(50),		-- Numero de Manzana de la Vivienda del Cliente

		TipoIdentiID			INT(11),		-- Tipo de Identificacion del Cliente
		NumIdentific			VARCHAR(30),	-- Numero de Identificacion del Documento del Cliente
		FecExIden				DATE,			-- Fecha de Expedicion de la Identificacion
		FecVenIden				DATE,			-- Fecha de vencimiento de la Identificacion

		Piso 					VARCHAR(50),	-- Numero de piso
		PrimeraEntreCalle		VARCHAR(50),	-- Calle uno de interseccion
		SegundaEntreCalle		VARCHAR(50)		-- Calle dos de interseccion
	);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION	BEGIN
				SET Par_NumErr   := 999;
				SET Par_ErrMen   := CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-CRCBCLIENTESWSCON.sql');
		END;
	
		SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
		IF Par_ClienteID = Entero_Cero THEN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := "El Cliente a consultar esta Vacío";
			LEAVE ManejoErrores;
		END IF; 

		INSERT INTO TMPCLIENTEWS(
				ClienteID,				PrimerNombre,			SegundoNombre,			TercerNombre,           ApellidoPaterno,
				ApellidoMaterno,		FechaNacimiento,		CURP,					EstadoNacimientoID,		Sexo,
				Telefono,				TelefonoCelular,		Correo,					RFC,					OcupacionID,
				LugardeTrabajo,			Puesto,					TelTrabajo,				NoEmpleado,				AntiguedadTra,
				ExtTelefonoTrab,		TipoEmpleado,			TipoPuesto,				SucursalOrigen,			TipoPersona,
				PaisNacionalidad,      	IngresosMensuales,     	TamanioAcreditado,		NiveldeRiesgo,			Titulo,
				PaisResidencia,			SectorGeneral,			ActividadBancoMX,		EstadoCivil,			LugarNacimiento,
				PromotorInicial,		PromotorActual,			ExtTelefonoPart,		TipoDireccionID,		EstadoID,
				MunicipioID,			LocalidadID,			ColoniaID,				Calle,					Numero,
				CP,						Oficial,				Fiscal,					NumInterior,			Lote,
				Manzana,				TipoIdentiID,			NumIdentific,			FecExIden,				FecVenIden,
				Piso, 					PrimeraEntreCalle,		SegundaEntreCalle) 
		SELECT 	Cli.ClienteID,			Cli.PrimerNombre,		Cli.SegundoNombre,		Cli.TercerNombre,		Cli.ApellidoPaterno,
				Cli.ApellidoMaterno,	Cli.FechaNacimiento,	Cli.CURP,				Cli.EstadoID,			Cli.Sexo,
				Cli.Telefono,			Cli.TelefonoCelular,	Cli.Correo,				Cli.RFC,				Cli.OcupacionID,
				Cli.LugardeTrabajo,		Cli.Puesto,				Cli.TelTrabajo,			Cli.NoEmpleado,			Cli.AntiguedadTra,
				Cli.ExtTelefonoTrab,	Cli.TipoEmpleado,		Cli.TipoPuesto,			Cli.SucursalOrigen,		Cli.TipoPersona,
				Cli.PaisNacionalidad,	Entero_Cero,			Cli.TamanioAcreditado,	Cli.NivelRiesgo,		Cli.Titulo,
				Cli.PaisResidencia,		Cli.SectorGeneral,		Cli.ActividadBancoMX,	Cli.EstadoCivil,		Cli.LugarNacimiento,
				Cli.PromotorInicial,	Cli.PromotorActual,		Cli.ExtTelefonoPart,	Entero_Cero,			Entero_Cero,
				Entero_Cero,			Entero_Cero,			Entero_Cero,			Cadena_Vacia,			Entero_Cero,
				Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,			Entero_Cero,
				Cadena_Vacia,			Entero_Cero,			Cadena_Vacia,			Fecha_Vacia,			Fecha_Vacia,
				Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia
		FROM 	CLIENTES Cli
		WHERE 	Cli.ClienteID 	= Par_ClienteID
		LIMIT 1;

		-- Ingresas los datos de la direccion Oficial

		UPDATE TMPCLIENTEWS Tmp
		INNER JOIN DIRECCLIENTE Dir ON Tmp.ClienteID = Dir.ClienteID
			SET 	Tmp.TipoDireccionID = Dir.TipoDireccionID,		
					Tmp.EstadoID 		= Dir.EstadoID,
					Tmp.MunicipioID		= Dir.MunicipioID,				
					Tmp.LocalidadID		= Dir.LocalidadID,			
					Tmp.ColoniaID		= Dir.ColoniaID,
					Tmp.Calle			= Dir.Calle,
					Tmp.Numero			= Dir.NumeroCasa,
					Tmp.CP 				= Dir.CP,
					Tmp.Oficial			= Dir.Oficial,
					Tmp.Fiscal			= Dir.Fiscal,
					Tmp.Lote			= Dir.Lote,
					Tmp.Manzana			= Dir.Manzana,
					Tmp.Piso 			= Dir.Piso,
					Tmp.NumInterior		= Dir.NumInterior,
					Tmp.PrimeraEntreCalle	= Dir.PrimeraEntreCalle,
					Tmp.SegundaEntreCalle	= Dir.SegundaEntreCalle
		WHERE Dir.Oficial = SalidaSI;

		UPDATE TMPCLIENTEWS Tmp
		INNER JOIN IDENTIFICLIENTE Iden ON Tmp.ClienteID = Iden.ClienteID
			SET 	Tmp.TipoIdentiID	= Iden.TipoIdentiID,
					Tmp.NumIdentific	= Iden.NumIdentific,
					Tmp.FecExIden		= Iden.FecExIden,
					Tmp.FecVenIden		= Iden.FecVenIden;

		SELECT 	MAX(SocioEID)
		INTO 	Var_LastID	
		FROM 	CLIDATSOCIOE
		WHERE 	ClienteID  = Par_ClienteID;

		SET Var_LastID = IFNULL(Var_LastID, Entero_Cero);

		IF Var_LastID <> Entero_Cero THEN
			UPDATE TMPCLIENTEWS Tmp
			INNER JOIN CLIDATSOCIOE Cli ON Tmp.ClienteID = Cli.ClienteID
				SET Tmp.IngresosMensuales = Cli.Monto
			Where Cli.SocioEID = Var_LastID;
		END IF;


		SELECT *
		FROM TMPCLIENTEWS;
		DROP TABLE IF EXISTS TMPCLIENTEWS;


	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen     	AS mensajeRespuesta,
				Par_ClienteID  	AS clienteID;
	END IF;

END TerminaStore$$