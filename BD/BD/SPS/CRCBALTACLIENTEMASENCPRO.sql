-- CRCBALTACLIENTEMASENCPRO
DELIMITER ;
DROP procedure IF EXISTS `CRCBALTACLIENTEMASENCPRO`;

DELIMITER $$
CREATE PROCEDURE `CRCBALTACLIENTEMASENCPRO`(
	-- Stored procedure para dar de alta clientes CRCB de forma masiva
	Par_FolioCarga			INT(11),		-- Numero de folio de la tabla CS_CRCBCLIENTESWS
    Par_FechaCarga 			DATE,

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
	DECLARE Error_Key					INT(11);									-- Codigo de error de la transaccion
    DECLARE Var_NumClien 				INT(11);									-- Numero de cliente asignado (clienteID)
    DECLARE Var_IDClienteSIERRA			CHAR(24);									-- ID CLiente de SIERRA

    DECLARE Var_PaisNacionalidad        INT(11);         						    -- Indica el País de Nacionalidad, es decir, el país al que corresponde legalmente el cliente.
	DECLARE Var_IngresosMensuales       DECIMAL(14,2);  							-- Monto de los ingresos mensuales reportados por el cliente
    DECLARE Var_TamanioAcreditado       INT(11);        							-- Clave que indica el Tamaño del Acreditado (Aplica solo para créditos comerciales)(0,1,2,3,4)
    DECLARE Var_NiveldeRiesgo           CHAR(1);        							-- Indica el Nivel de Riesgo del Cliente: A: Alto M: Medio B: Bajo


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
	SET Par_EmpresaID					:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario						:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual					:= IFNULL(Aud_FechaActual, Entero_Cero);
	SET Aud_DireccionIP					:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID					:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal					:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion				:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBALTACLIENTEMASENCPRO');
			SET Var_Control	= 'sqlException';
		END;

		IF Par_FolioCarga = Entero_Cero THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'Especifique folio de carga';
			SET Var_Control	:= 'folioCarga';
			LEAVE ManejoErrores;
		END IF;
		
		
		SET @RegistroClientesID := 0;
		
		INSERT INTO  TMPCRCBCLIENTESWS (	
						NumRegistro,						FechaCarga,				FolioCarga,				PrimerNombre,			SegundoNombre,
						TercerNombre,						ApellidoPaterno,		ApellidoMaterno,		FechaNacimiento,		CURP,
						EstadoNacimientoID,					Sexo,					Telefono,				TelefonoCelular,		Correo,
						RFC,								OcupacionID,			LugardeTrabajo,			Puesto,					TelTrabajo,
						NoEmpleado,							AntiguedadTra,			ExtTelefonoTrab,		TipoEmpleado,			TipoPuesto,
						SucursalOrigen,						TipoPersona,			Titulo,					PaisResidencia,			SectorGeneral,
						ActividadBancoMX,					EstadoCivil,			LugarNacimiento,		PromotorInicial,		PromotorActual,
						ExtTelefonoPart,					TipoDireccionID,		EstadoID,				MunicipioID,			LocalidadID,
						ColoniaID,							Calle,					Numero,					CP,						Oficial,
						Fiscal,								NumInterior,			Lote,					Manzana,				TipoIdentiID,
						NumIdentific,						FecExIden,				FecVenIden,				IDClienteSIERRA,		PaisNacionalidad,
						IngresosMensuales,					TamanioAcreditado,		NiveldeRiesgo,			EmpresaID,				Usuario,							
						FechaActual,						DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
						
		SELECT			(@RegistroClientesID := @RegistroClientesID +1),		FechaCarga,				FolioCarga,					PrimerNombre,		SegundoNombre,		
						TercerNombre,						ApellidoPaterno,		ApellidoMaterno,		FechaNacimiento,		CURP,				
						EstadoNacimientoID,					Sexo,					Telefono,				TelefonoCelular,		Correo,				
						RFC,								OcupacionID,			LugardeTrabajo,			Puesto,					TelTrabajo,			
						NoEmpleado,							AntiguedadTra,			ExtTelefonoTrab,		TipoEmpleado,			TipoPuesto,			
						SucursalOrigen,						TipoPersona,			Titulo,					PaisResidencia,			SectorGeneral,		
						ActividadBancoMX,					EstadoCivil,			LugarNacimiento,		PromotorInicial,		PromotorActual,		
						ExtTelefonoPart,					TipoDireccionID,		EstadoID,				MunicipioID,			LocalidadID,		
						ColoniaID,							Calle,					Numero,					CP,						Oficial,			
						Fiscal,								NumInterior,			Lote,					Manzana,				TipoIdentiID,		
						NumIdentific,						FecExIden,				FecVenIden,				IDClienteSIERRA,		PaisNacionalidad,
						IngresosMensuales,					TamanioAcreditado,		NiveldeRiesgo,			Par_EmpresaID,			Aud_Usuario,						
						Aud_FechaActual,					Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
		FROM	CS_CRCBCLIENTESWS
				WHERE	FolioCarga	= Par_FolioCarga
                AND 	DATE(FechaCarga) = Par_FechaCarga;
			

		SELECT		COUNT(FolioCarga)
			INTO	Var_TotalRegistros
			FROM	TMPCRCBCLIENTESWS WHERE FolioCarga = Par_FolioCarga;

		SET Var_Consecutivo	:= 1;

	

		IteraRegistros: WHILE (Var_Consecutivo <= Var_TotalRegistros) DO
		-- SE INICIALIZAN VARIABLES
		SET Var_FechaCarga	 := Fecha_Vacia;
		SET Var_FolioCarga	 := Par_FolioCarga;
		SET Var_PrimerNombre	 := Cadena_Vacia;
		SET Var_SegundoNombre	 := Cadena_Vacia;
		SET Var_TercerNombre	 := Cadena_Vacia;

		SET Var_ApellidoPaterno	 := Cadena_Vacia;
		SET Var_ApellidoMaterno	 := Cadena_Vacia;
		SET Var_FechaNacimiento	 := Fecha_Vacia;
		SET Var_CURP	 := Cadena_Vacia;
		SET Var_EstadoNacimientoID	 := Entero_Cero;

		SET Var_Sexo	 := Cadena_Vacia;
		SET Var_Telefono	 := Cadena_Vacia;
		SET Var_TelefonoCelular	 := Cadena_Vacia;
		SET Var_Correo	 := Cadena_Vacia;
		SET Var_RFC	 := Cadena_Vacia;

		SET Var_OcupacionID	 := Entero_Cero;
		SET Var_LugardeTrabajo	 := Cadena_Vacia;
		SET Var_Puesto	 := Cadena_Vacia;
		SET Var_TelTrabajo	 := Cadena_Vacia;
		SET Var_NoEmpleado	 := Cadena_Vacia;

		SET Var_AntiguedadTra	 := Entero_Cero;
		SET Var_ExtTelefonoTrab	 := Cadena_Vacia;
		SET Var_TipoEmpleado	 := Cadena_Vacia;
		SET Var_TipoPuesto	 := Entero_Cero;
		SET Var_SucursalOrigen	 := Entero_Cero;

		SET Var_TipoPersona	 := Cadena_Vacia;
		SET Var_Titulo	 := Cadena_Vacia;
		SET Var_PaisResidencia	 := Entero_Cero;
		SET Var_SectorGeneral	 := Entero_Cero;
		SET Var_ActividadBancoMX	 := Cadena_Vacia;

		SET Var_EstadoCivil	 := Cadena_Vacia;
		SET Var_LugarNacimiento	 := Entero_Cero;
		SET Var_PromotorInicial	 := Entero_Cero;
		SET Var_PromotorActual	 := Entero_Cero;
		SET Var_ExtTelefonoPart	 := Cadena_Vacia;

		SET Var_TipoDireccionID	 := Entero_Cero;
		SET Var_EstadoID	 := Entero_Cero;
		SET Var_MunicipioID	 := Entero_Cero;
		SET Var_LocalidadID	 := Entero_Cero;
		SET Var_ColoniaID	 := Entero_Cero;

		SET Var_Calle	 := Cadena_Vacia;
		SET Var_Numero	 := Cadena_Vacia;
		SET Var_CP	 := Cadena_Vacia;
		SET Var_Oficial	 := Cadena_Vacia;
		SET Var_Fiscal	 := Cadena_Vacia;

		SET Var_NumInterior	 := Cadena_Vacia;
		SET Var_Lote	 := Cadena_Vacia;
		SET Var_Manzana	 := Cadena_Vacia;
		SET Var_TipoIdentiID	 := Entero_Cero;
		SET Var_NumIdentific	 := Cadena_Vacia;

		SET Var_FecExIden	 := Fecha_Vacia;
		SET Var_FecVenIden	:= Fecha_Vacia;
		SET Var_IDClienteSIERRA := Cadena_Vacia;

		SET Var_PaisNacionalidad        := Entero_Cero;        						
		SET Var_IngresosMensuales       := Entero_Cero;  							
    	SET Var_TamanioAcreditado       := Entero_Cero;      							
    	SET Var_NiveldeRiesgo           := Cadena_Vacia;       							
		
		
			SELECT		FechaCarga,				FolioCarga,				PrimerNombre,			SegundoNombre,		TercerNombre,
						ApellidoPaterno,		ApellidoMaterno,		FechaNacimiento,		CURP,				EstadoNacimientoID,
						Sexo,					Telefono,				TelefonoCelular,		Correo,				RFC,
						OcupacionID,			LugardeTrabajo,			Puesto,					TelTrabajo,			NoEmpleado,
						AntiguedadTra,			ExtTelefonoTrab,		TipoEmpleado,			TipoPuesto,			SucursalOrigen,
						TipoPersona,			Titulo,					PaisResidencia,			SectorGeneral,		ActividadBancoMX,
						EstadoCivil,			LugarNacimiento,		PromotorInicial,		PromotorActual,		ExtTelefonoPart,
						TipoDireccionID,		EstadoID,				MunicipioID,			LocalidadID,		ColoniaID,
						Calle,					Numero,					CP,						Oficial,			Fiscal,
						NumInterior,			Lote,					Manzana,				TipoIdentiID,		NumIdentific,
						FecExIden,				FecVenIden,				IDClienteSIERRA,		PaisNacionalidad,	IngresosMensuales,					
						TamanioAcreditado,		NiveldeRiesgo

				INTO	Var_FechaCarga,			Var_FolioCarga,			Var_PrimerNombre,		Var_SegundoNombre,		Var_TercerNombre,
						Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FechaNacimiento,	Var_CURP,				Var_EstadoNacimientoID,
						Var_Sexo,				Var_Telefono,			Var_TelefonoCelular,	Var_Correo,				Var_RFC,
						Var_OcupacionID,		Var_LugardeTrabajo,		Var_Puesto,				Var_TelTrabajo,			Var_NoEmpleado,
						Var_AntiguedadTra,		Var_ExtTelefonoTrab,	Var_TipoEmpleado,		Var_TipoPuesto,			Var_SucursalOrigen,
						Var_TipoPersona,		Var_Titulo,				Var_PaisResidencia,		Var_SectorGeneral,		Var_ActividadBancoMX,
						Var_EstadoCivil,		Var_LugarNacimiento,	Var_PromotorInicial,	Var_PromotorActual,		Var_ExtTelefonoPart,
						Var_TipoDireccionID,	Var_EstadoID,			Var_MunicipioID,		Var_LocalidadID,		Var_ColoniaID,
						Var_Calle,				Var_Numero,				Var_CP,					Var_Oficial,			Var_Fiscal,
						Var_NumInterior,		Var_Lote,				Var_Manzana,			Var_TipoIdentiID,		Var_NumIdentific,
						Var_FecExIden,			Var_FecVenIden,			Var_IDClienteSIERRA,	Var_PaisNacionalidad,   Var_IngresosMensuales,
						Var_TamanioAcreditado,	Var_NiveldeRiesgo
				FROM	TMPCRCBCLIENTESWS
				WHERE	NumRegistro	= Var_Consecutivo;

				SET Var_Consecutivo	:= Var_Consecutivo + Entero_Uno;

				CALL CRCBALTACLIENTEMASENCVAL (	Var_FolioCarga,			Var_FechaCarga,			Var_PrimerNombre,		Var_SegundoNombre,		Var_TercerNombre,		
												Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FechaNacimiento,	Var_CURP,				Var_EstadoNacimientoID,	
                                            	Var_Sexo,				Var_Telefono,			Var_TelefonoCelular,	Var_Correo,				Var_RFC,				
                                            	Var_OcupacionID,		Var_LugardeTrabajo,		Var_Puesto,				Var_TelTrabajo,			Var_NoEmpleado,			
                                            	Var_AntiguedadTra,		Var_ExtTelefonoTrab,	Var_TipoEmpleado,		Var_TipoPuesto,			Var_SucursalOrigen,		
                                            	Var_TipoPersona,		Var_PaisNacionalidad,	Var_IngresosMensuales,	Var_TamanioAcreditado,	Var_NiveldeRiesgo,

                                            	Var_Titulo,				Var_PaisResidencia,		Var_SectorGeneral,		Var_ActividadBancoMX,	Var_EstadoCivil,		
                                            	Var_LugarNacimiento,	Var_PromotorInicial,	Var_PromotorActual,		Var_ExtTelefonoPart,	Var_TipoDireccionID,	
                                            	Var_EstadoID,			Var_MunicipioID,		Var_LocalidadID,		Var_ColoniaID,			Var_Calle,				
                                            	Var_Numero,				Var_CP,					Var_Oficial,			Var_Fiscal,				Var_NumInterior,		
                                            	Var_Lote,				Var_Manzana,			Var_TipoIdentiID,		Var_NumIdentific,		Var_FecExIden,			
                                            	Var_FecVenIden,			Var_SalidaNO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			
                                            	Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			
                                            	Aud_NumTransaccion);

			IF Par_NumErr <> Entero_Cero THEN
				INSERT INTO CRCBBITACORACLIENTEWS (	NumRegistro,			FechaCarga,				FolioCarga,				PrimerNombre,			SegundoNombre,
													TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		FechaNacimiento,		CURP,
													EstadoNacimientoID,		Sexo,					Telefono,				TelefonoCelular,		Correo,
													RFC,					OcupacionID,			LugardeTrabajo,			Puesto,					TelTrabajo,
													NoEmpleado,				AntiguedadTra,			ExtTelefonoTrab,		TipoEmpleado,			TipoPuesto,
													SucursalOrigen,			TipoPersona,			Titulo,					PaisResidencia,			SectorGeneral,
													ActividadBancoMX,		EstadoCivil,			LugarNacimiento,		PromotorInicial,		PromotorActual,
													ExtTelefonoPart,		TipoDireccionID,		EstadoID,				MunicipioID,			LocalidadID,
													ColoniaID,				Calle,					Numero,					CP,						Oficial,
													Fiscal,					NumInterior,			Lote,					Manzana,				TipoIdentiID,
													NumIdentific,			FecExIden,				FecVenIden,				IDClienteSIERRA,		PaisNacionalidad,	
													IngresosMensuales,		TamanioAcreditado,		NiveldeRiesgo,
													NumErr,					
													ErrMen,
													Proceso,				EmpresaID,				Usuario,				FechaActual,			DireccionIP,
													ProgramaID,				Sucursal,				NumTransaccion)
											SELECT	Var_Consecutivo-1,		Var_FechaCarga,			Var_FolioCarga,			Var_PrimerNombre,		Var_SegundoNombre,
													Var_TercerNombre,		Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FechaNacimiento,	Var_CURP,
													Var_EstadoNacimientoID,	Var_Sexo,				Var_Telefono,			Var_TelefonoCelular,	Var_Correo,
													Var_RFC,				Var_OcupacionID,		Var_LugardeTrabajo,		Var_Puesto,				Var_TelTrabajo,
													Var_NoEmpleado,			Var_AntiguedadTra,		Var_ExtTelefonoTrab,	Var_TipoEmpleado,		Var_TipoPuesto,
													Var_SucursalOrigen,		Var_TipoPersona,		Var_Titulo,				Var_PaisResidencia,		Var_SectorGeneral,
													Var_ActividadBancoMX,	Var_EstadoCivil,		Var_LugarNacimiento,	Var_PromotorInicial,	Var_PromotorActual,
													Var_ExtTelefonoPart,	Var_TipoDireccionID,	Var_EstadoID,			Var_MunicipioID,		Var_LocalidadID,
													Var_ColoniaID,			Var_Calle,				Var_Numero,				Var_CP,					Var_Oficial,
													Var_Fiscal,				Var_NumInterior,		Var_Lote,				Var_Manzana,			Var_TipoIdentiID,
													Var_NumIdentific,		Var_FecExIden,			Var_FecVenIden,			Var_IDClienteSIERRA,	Var_PaisNacionalidad,	
													Var_IngresosMensuales,	Var_TamanioAcreditado,	Var_NiveldeRiesgo,
													Par_NumErr,				
													Par_ErrMen,
													'CRCBALTACLIENTEMASENCPRO',Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion;				

				ITERATE IteraRegistros;
			END IF;

			START TRANSACTION;

			Iteraciones: BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

				SET Error_Key	:= Entero_Cero;
				SET Par_NumErr	:= Entero_Cero;
				SET Par_ErrMen	:= Cadena_Vacia;
                
		
				CALL CRCBCLIENTESWSALTCARGAMASIVA (	Var_PrimerNombre,		Var_SegundoNombre,		Var_TercerNombre,		Var_ApellidoPaterno,	Var_ApellidoMaterno,
													Var_FechaNacimiento,	Var_CURP,				Var_EstadoNacimientoID,	Var_Sexo,				Var_Telefono,
													Var_TelefonoCelular,	Var_Correo,				Var_RFC,				Var_OcupacionID,		Var_LugardeTrabajo,
													Var_Puesto,				Var_TelTrabajo,			Var_NoEmpleado,			Var_AntiguedadTra,		Var_ExtTelefonoTrab,
													Var_TipoEmpleado,		Var_TipoPuesto,			Var_SucursalOrigen,		Var_TipoPersona,		Var_PaisNacionalidad,	
													Var_IngresosMensuales,	Var_TamanioAcreditado,	Var_NiveldeRiesgo,		Var_Titulo,
													Var_PaisResidencia,		Var_SectorGeneral,		Var_ActividadBancoMX,	Var_EstadoCivil,		Var_LugarNacimiento,
													Var_PromotorInicial,	Var_PromotorActual,		Var_ExtTelefonoPart,	Var_TipoDireccionID,	Var_EstadoID,
													Var_MunicipioID,		Var_LocalidadID,		Var_ColoniaID,			Var_Calle,				Var_Numero,
													Var_CP,					Var_Oficial,			Var_Fiscal,				Var_NumInterior,		Var_Lote,
													Var_Manzana,			Var_TipoIdentiID,		Var_NumIdentific,		Var_FecExIden,			Var_FecVenIden,
													Var_SalidaNO,			Par_NumErr,				Par_ErrMen,				Var_NumClien,			Par_EmpresaID,			
                                            		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			
                                            		Aud_NumTransaccion);

			END Iteraciones;

			IF Error_Key = Entero_Cero AND Par_NumErr = Entero_Cero THEN
			
			INSERT INTO CRCBBITACORACLIENTEEXITOWS(	NumRegistro,			ClienteID,				FechaCarga,				FolioCarga,				PrimerNombre,			
													SegundoNombre,			TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		FechaNacimiento,		
                                                    CURP,					EstadoNacimientoID,		Sexo,					Telefono,				TelefonoCelular,		
                                                    Correo,					RFC,					OcupacionID,			LugardeTrabajo,			Puesto,					
                                                    TelTrabajo,				NoEmpleado,				AntiguedadTra,			ExtTelefonoTrab,		TipoEmpleado,			
                                                    TipoPuesto,				SucursalOrigen,			TipoPersona,			Titulo,					PaisResidencia,			
                                                    SectorGeneral,			ActividadBancoMX,		EstadoCivil,			LugarNacimiento,		PromotorInicial,		
                                                    PromotorActual,			ExtTelefonoPart,		TipoDireccionID,		EstadoID,				MunicipioID,			
                                                    LocalidadID,			ColoniaID,				Calle,					Numero,					CP,						
                                                    Oficial,				Fiscal,					NumInterior,			Lote,					Manzana,				
                                                    TipoIdentiID,			NumIdentific,			FecExIden,				FecVenIden,				IDClienteSIERRA,
                                                    PaisNacionalidad,		IngresosMensuales,		TamanioAcreditado,		NiveldeRiesgo,
                                                    NumErr,					
                                                    ErrMen,					Proceso,				EmpresaID,				Usuario,				FechaActual,			
                                                    DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
											SELECT	Var_Consecutivo-1,		Var_NumClien,			Var_FechaCarga,			Var_FolioCarga,			Var_PrimerNombre,		
													Var_SegundoNombre,		Var_TercerNombre,		Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FechaNacimiento,	
                                                    Var_CURP,				Var_EstadoNacimientoID,	Var_Sexo,				Var_Telefono,			Var_TelefonoCelular,	
                                                    Var_Correo,				Var_RFC,				Var_OcupacionID,		Var_LugardeTrabajo,		Var_Puesto,				
                                                    Var_TelTrabajo,			Var_NoEmpleado,			Var_AntiguedadTra,		Var_ExtTelefonoTrab,	Var_TipoEmpleado,		
                                                    Var_TipoPuesto,			Var_SucursalOrigen,		Var_TipoPersona,		Var_Titulo,				Var_PaisResidencia,		
                                                    Var_SectorGeneral,		Var_ActividadBancoMX,	Var_EstadoCivil,		Var_LugarNacimiento,	Var_PromotorInicial,	
                                                    Var_PromotorActual,		Var_ExtTelefonoPart,	Var_TipoDireccionID,	Var_EstadoID,			Var_MunicipioID,		
                                                    Var_LocalidadID,		Var_ColoniaID,			Var_Calle,				Var_Numero,				Var_CP,					
                                                    Var_Oficial,			Var_Fiscal,				Var_NumInterior,		Var_Lote,				Var_Manzana,			
                                                    Var_TipoIdentiID,		Var_NumIdentific,		Var_FecExIden,			Var_FecVenIden,			Var_IDClienteSIERRA,
                                                    Var_PaisNacionalidad,	Var_IngresosMensuales,	Var_TamanioAcreditado,	Var_NiveldeRiesgo,
                                                    @Var_NumErrMasCliCRCB,	
                                                    @Var_ErrMenMasCliCRCB,'CRCBALTACLIENTEMASENCPRO',	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		
                                                    Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion;
				COMMIT;
			ELSE
				SET @Var_NumErrMasCliCRCB	:= Par_NumErr;
				SET @Var_ErrMenMasCliCRCB	:= Par_ErrMen;
				ROLLBACK;
				INSERT INTO CRCBBITACORACLIENTEWS (	NumRegistro,			FechaCarga,				FolioCarga,				PrimerNombre,			SegundoNombre,
													TercerNombre,			ApellidoPaterno,		ApellidoMaterno,		FechaNacimiento,		CURP,
													EstadoNacimientoID,		Sexo,					Telefono,				TelefonoCelular,		Correo,
													RFC,					OcupacionID,			LugardeTrabajo,			Puesto,					TelTrabajo,
													NoEmpleado,				AntiguedadTra,			ExtTelefonoTrab,		TipoEmpleado,			TipoPuesto,
													SucursalOrigen,			TipoPersona,			Titulo,					PaisResidencia,			SectorGeneral,
													ActividadBancoMX,		EstadoCivil,			LugarNacimiento,		PromotorInicial,		PromotorActual,
													ExtTelefonoPart,		TipoDireccionID,		EstadoID,				MunicipioID,			LocalidadID,
													ColoniaID,				Calle,					Numero,					CP,						Oficial,
													Fiscal,					NumInterior,			Lote,					Manzana,				TipoIdentiID,
													NumIdentific,			FecExIden,				FecVenIden,				IDClienteSIERRA,		PaisNacionalidad,	
													IngresosMensuales,		TamanioAcreditado,		NiveldeRiesgo,
													NumErr,					
													ErrMen,
													Proceso,				EmpresaID,				Usuario,				FechaActual,			DireccionIP,
													ProgramaID,				Sucursal,				NumTransaccion)
											SELECT	Var_Consecutivo-1,		Var_FechaCarga,			Var_FolioCarga,			Var_PrimerNombre,		Var_SegundoNombre,
													Var_TercerNombre,		Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_FechaNacimiento,	Var_CURP,
													Var_EstadoNacimientoID,	Var_Sexo,				Var_Telefono,			Var_TelefonoCelular,	Var_Correo,
													Var_RFC,				Var_OcupacionID,		Var_LugardeTrabajo,		Var_Puesto,				Var_TelTrabajo,
													Var_NoEmpleado,			Var_AntiguedadTra,		Var_ExtTelefonoTrab,	Var_TipoEmpleado,		Var_TipoPuesto,
													Var_SucursalOrigen,		Var_TipoPersona,		Var_Titulo,				Var_PaisResidencia,		Var_SectorGeneral,
													Var_ActividadBancoMX,	Var_EstadoCivil,		Var_LugarNacimiento,	Var_PromotorInicial,	Var_PromotorActual,
													Var_ExtTelefonoPart,	Var_TipoDireccionID,	Var_EstadoID,			Var_MunicipioID,		Var_LocalidadID,
													Var_ColoniaID,			Var_Calle,				Var_Numero,				Var_CP,					Var_Oficial,
													Var_Fiscal,				Var_NumInterior,		Var_Lote,				Var_Manzana,			Var_TipoIdentiID,
													Var_NumIdentific,		Var_FecExIden,			Var_FecVenIden,			Var_IDClienteSIERRA,	Var_PaisNacionalidad,	
													Var_IngresosMensuales,	Var_TamanioAcreditado,	Var_NiveldeRiesgo,
													@Var_NumErrMasCliCRCB,	
													@Var_ErrMenMasCliCRCB,
													'CRCBALTACLIENTEMASENCPRO',	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
													Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion;
			END IF;

			
		END WHILE IteraRegistros;
		
		DELETE FROM TMPCRCBCLIENTESWS WHERE FolioCarga = Par_FolioCarga;
		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Proceso finalizado exitosamente';
		SET Var_Control		:= 'folioCarga';
	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS control,
				Par_FolioCarga			AS consecutivo;
	END IF;
END TerminaStore$$