-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBCLIENTESWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBCLIENTESWSALT`;
DELIMITER $$

CREATE PROCEDURE `CRCBCLIENTESWSALT`(
	-- === SP para realizar alta de clientes mediante el WS de Alta de Clientes de CREDICLUB =====
	Par_PrimerNombre            VARCHAR(50), 	-- Primer Nombre del Cliente
	Par_SegundoNombre           VARCHAR(50),    -- Segundo Nombre del Cliente
	Par_TercerNombre            VARCHAR(50), 	-- Tercer Nombre del Cliente
	Par_ApellidoPaterno	        VARCHAR(50), 	-- Apellido Paterno del Cliente
	Par_ApellidoMaterno   		VARCHAR(50), 	-- Apellido Materno del Cliente

	Par_FechaNacimiento			DATE, 		 	-- Fecha de Nacimiento del Cliente
	Par_CURP 				    CHAR(18), 	 	-- CURP del Cliente
	Par_EstadoNacimientoID		INT(11),		-- ID Estado de Nacimiento
	Par_Sexo					CHAR(1),     	-- Sexo del Cliente
	Par_Telefono				VARCHAR(20), 	-- Telefono Oficial del Cliente

	Par_TelefonoCelular			VARCHAR(20), 	-- Telefono Celular del Cliente
	Par_Correo					VARCHAR(50), 	-- Correo Electronico del Cliente
	Par_RFC						CHAR(13), 	 	-- RFC del Cliente
	Par_OcupacionID				INT(11),		-- Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)
	Par_LugardeTrabajo			VARCHAR(150),	-- Lugar de Trabajo del Cliente

	Par_Puesto					VARCHAR(150),	-- Puesto de Trabajo del Cliente
	Par_TelTrabajo				VARCHAR(20),	-- Telefono Trabajo del Cliente
	Par_NoEmpleado				VARCHAR(20),	-- Indica el Numero de Empleado de la Empresa de Nomina a la que esta ligado el Cliente
	Par_AntiguedadTra			DECIMAL(12,2), 	-- Antiguedad del Trabajo
	Par_ExtTelefonoTrab			VARCHAR(10),	-- Extension del Telefono Trabajo del Cliente

	Par_TipoEmpleado			CHAR(1), 	 	-- Tipo de Empleado
	Par_TipoPuesto				INT(11), 	 	-- Tipo de Puesto
	Par_SucursalOrigen			INT(5),		 	-- ID Sucursal del Cliente
	Par_TipoPersona				CHAR(1),		-- Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial
	Par_PaisNacionalidad        INT(11),        -- Indica el País de Nacionalidad, es decir, el país al que corresponde legalmente el cliente.

	Par_IngresosMensuales       DECIMAL(14,2),  -- Monto de los ingresos mensuales reportados por el cliente
	Par_TamanioAcreditado       INT(11),        -- Clave que indica el Tamaño del Acreditado (Aplica solo para créditos comerciales)(0,1,2,3,4)
	Par_NiveldeRiesgo           CHAR(1),        -- Indica el Nivel de Riesgo del Cliente: A: Alto M: Medio B: Bajo
	Par_Titulo					VARCHAR(10),	-- Titulo del Cliente, Ej. Sr., Sra, Srita, Lic, Dr. Ing, Prof.,CP, etc
	Par_PaisResidencia			INT(5),     	-- ID Pais de Residencia del Cliente

	Par_SectorGeneral			INT(3),      	-- ID Sector General
	Par_ActividadBancoMX		VARCHAR(15), 	-- ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX
	Par_EstadoCivil				CHAR(2), 	 	-- Estado Cividl del Cliente
	Par_LugarNacimiento			INT(11),       	-- Pais Lugar de Nacimiento
	Par_PromotorInicial			INT(6),      	-- ID Promotor Inicial

	Par_PromotorActual			INT(6),      	-- ID Promotor Actual
	Par_ExtTelefonoPart			VARCHAR(7),     -- Extension del Telefono Particular
	Par_TipoDireccionID			INT(11),     	-- Tipo de Direccion
	Par_EstadoID				INT(11),     	-- ID Estado del Cliente
	Par_MunicipioID				INT(11),     	-- ID Municipio del Cliente

	Par_LocalidadID				INT(11),     	-- ID Localidad del Cliente
	Par_ColoniaID				INT(11),     	-- ID Colonia del Cliente
	Par_Calle					VARCHAR(50), 	-- Nombre de la Calle
	Par_Numero					CHAR(10),    	-- Numero de la Vivienda del Cliente
	Par_CP						CHAR(5),		-- Codigo Postal Direccion del Cliente

	Par_Oficial					CHAR(1),		-- Valor de direccion Oficial S=SI, N=No
	Par_Fiscal					CHAR(1),		-- Valor de direccion Fiscal S=SI, N=No
	Par_NumInterior				CHAR(10),		-- Numero Interior de la Casa o Edificio
	Par_Lote					CHAR(50),		-- Numero de Lote la Vivienda del Cliente
	Par_Manzana					CHAR(50),		-- Numero de Manzana de la Vivienda del Cliente

	Par_TipoIdentiID			INT(11),		-- Tipo de Identificacion del Cliente
	Par_NumIdentific			VARCHAR(30),	-- Numero de Identificacion del Documento del Cliente
	Par_FecExIden				DATE,			-- Fecha de Expedicion de la Identificacion
	Par_FecVenIden				DATE,			-- Fecha de vencimiento de la Identificacion
	Par_ClienteId               INT(11),        -- Numero de cliente que proviene de cartera

	Par_Piso 					VARCHAR(50),	-- Numero de piso
	Par_PrimeraEntreCalle		VARCHAR(50),	-- Calle uno de interseccion
	Par_SegundaEntreCalle		VARCHAR(50),	-- Calle dos de interseccion

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

	-- Declaracion de Variables
	DECLARE Var_CodigoResp			VARCHAR(5);			-- Codigo de Respuesta
	DECLARE Var_MensajeResp			VARCHAR(150);		-- Mensaje de Respuesta
	DECLARE Var_ClienteID           INT;				-- Numero de Cliente
	DECLARE Valida_RFC        		CHAR(13);			-- Valida RFC
	DECLARE Valida_CURP       		CHAR(18);			-- Valida CURP

	DECLARE Var_LongRFC				INT(11);			-- Longitud RFC
	DECLARE Par_Clasificacion		CHAR(1);			-- Clasificacion del Cliente
	DECLARE Par_Nacionalidad		VARCHAR(4);			-- Nacionalidad del Cliente
	DECLARE Par_MotivoApertura		VARCHAR(4);			-- Motivo de Apertura
	DECLARE Par_PagaISR             CHAR(1);			-- Paga ISR

	DECLARE Par_PagaIVA            	CHAR(1);			-- Paga IVA
	DECLARE Par_PagaIDE            	CHAR(1);			-- Paga IDE
	DECLARE Var_ActBMX        		VARCHAR(15);		-- Actividad BMX
	DECLARE Var_ActINEGI            INT(11);      		-- Numero de la Actividad INEGI
	DECLARE Var_ActFR            	BIGINT;  			-- Numero de la Actividad FR

	DECLARE Var_ActFOMUR            INT(11);  			-- Numero de la Actividad FOMUR
	DECLARE Var_SectorEco           INT(11);  			-- Numero del Sector Economico
	DECLARE Var_MaxCaracter			INT(11);			-- Numero Maximo de carateres (identificaciones)
	DECLARE Var_EsOficial 			VARCHAR(1);  		-- Si la Identificacion es Oficial
	DECLARE Var_NumErr				INT(11);			-- Numero de Error

	DECLARE Var_MenErr				VARCHAR(150);		-- Mensaje de Error
	DECLARE Var_NomColonia          VARCHAR(200);		-- Nombre de la Colonia (domicilio Cliente)
	DECLARE Var_EjecutaCierre		CHAR(1);			-- indica si se esta realizando el cierre de dia
	DECLARE Var_FechaSis            DATE;               -- Fecha del sistema

	-- Declaracion de Constantes
	DECLARE Entero_Cero             INT(11);
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Decimal_Cero	        DECIMAL(12,2);
	DECLARE Fecha_Vacia             DATE;
	DECLARE SalidaSI                CHAR(1);

	DECLARE SalidaNO                CHAR(1);
	DECLARE SimbInterrogacion		VARCHAR(1);
	DECLARE Per_Fisica     	    	CHAR(1);
	DECLARE Per_ActEmp        		CHAR(1);
	DECLARE Per_Moral       		CHAR(1);

	DECLARE MinCURP					INT(11);
	DECLARE MinRFC					INT(11);
	DECLARE MaxRFC					INT(11);
	DECLARE Long_PerFisica			INT(11);
	DECLARE Long_PerMoral			INT(11);

	DECLARE Masculino				CHAR(1);
	DECLARE Femenino				CHAR(1);
	DECLARE CorreoValido			VARCHAR(15);
	DECLARE EmpleadoNomina			CHAR(1);
	DECLARE Empleado_Temporal		CHAR(1);

	DECLARE Empleado_Confianza		CHAR(1);
	DECLARE Empleado_Sindical		CHAR(1);
	DECLARE Empleado_Base			CHAR(1);
	DECLARE Empleado_BaseSindical	CHAR(1);
	DECLARE Empleado_PensionJub		CHAR(1);

	DECLARE Soltero					CHAR(1);
	DECLARE CasadoBienSep			CHAR(2);
	DECLARE CasadoBienManc          CHAR(2);
	DECLARE CasadoBienManCap		CHAR(2);
	DECLARE Viudo					CHAR(1);

	DECLARE Divorciado				CHAR(1);
	DECLARE Separado				CHAR(2);
	DECLARE UnionLibre				CHAR(1);
	DECLARE PaisMex         		INT(11);
	DECLARE Nac_Mexicana			CHAR(1);

	DECLARE SiEsOficial				CHAR(1);
	DECLARE ConstanteNo				CHAR(1);
	DECLARE ConstanteSi				CHAR(1);
	DECLARE Ident_Elector			INT(11);
	DECLARE Ident_Pasaporte			INT(11);

	DECLARE MinCaracElector			INT(11);
	DECLARE MinCaracPasaporte		INT(11);
	DECLARE Ident_Cartilla			INT(11);
	DECLARE Ident_Licencia			INT(11);
	DECLARE Ident_Cedula			INT(11);

	DECLARE MinCaracter				INT(11);
	DECLARE MenorEdadNO         	CHAR(1);
	DECLARE NivelRiesgo        		VARCHAR(1);
	DECLARE EsMenor             	VARCHAR(1);
	DECLARE RegHacien				VARCHAR(1);

	DECLARE ERROR_PLD				INT(11);
	DECLARE CodigoCliente			INT(11);
	DECLARE CodigoIdenti			INT(11);
	DECLARE CodigoDirec				INT(11);
	DECLARE ValorCierre				VARCHAR(30);

	DECLARE Con_EnteroUno           INT(11);
	DECLARE Con_OtrosIngresos       INT(11);
	DECLARE Var_UnificaCI           VARCHAR(1);
	DECLARE Var_PaisIDDom			INT(11);        -- País ID de la dirección
	DECLARE Var_AniosRes			INT(11);        -- Años de residencia

	DECLARE Loc_NoCatalogada		INT(11);		-- Constante Localidad no catalogada 999999999

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET Decimal_Cero	    :=  0.00;   			-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET SalidaSI           	:= 'S';        			-- El Store SI genera una Salida

	SET	SalidaNO 	   	   	:= 'N';	      			-- El Store NO genera una Salida
	SET SimbInterrogacion	:= '?';					-- Simbolo de interrogacion
	SET Per_Fisica			:= 'F';        			-- Tipo de Persona: Fisica
	SET Per_ActEmp          := 'A';       			-- Tipo de Persona: Fisica con Actividad Empresarial
	SET Per_Moral         	:= 'M';      			-- Tipo de Persona: Persona Moral

	SET MinCURP				:= 18;					-- Numero de Caracateres para la CURP
	SET MinRFC				:= 10;					-- Numero de Caracateres minimo RFC Personas Fisicas (SIN HOMOCLAVE)
	SET MaxRFC				:= 13;					-- Numero de Caracateres maximo RFC Personas Fisicas (CON HOMOCLAVE)
	SET Long_PerFisica		:= 13;					-- Longitud RFC Persona Fisica: 13
	SET Long_PerMoral		:= 12;					-- Longitud RFC Persona Moral: 12

	SET Masculino			:= 'M';					-- Sexo Masculino: M
	SET Femenino			:= 'F';					-- Sexo Femenino: F
	SET CorreoValido		:= '(.*)@(.*)\\.(.*)';	-- Expresion Regular, para Validar Correo
	SET EmpleadoNomina		:= 'M';					-- Clasificacion: Empleado de Nomina
	SET Empleado_Temporal	:= 'T';

	SET Empleado_Confianza		:= 'C';				-- Empleado de Confianza
	SET Empleado_Sindical		:= 'S';				-- Empleado Sindical
	SET Empleado_Base			:= 'E';				-- Empleado Base
	SET Empleado_BaseSindical	:= 'B';				-- Empleado Base Sindical
	SET Empleado_PensionJub		:= 'P';				-- Empleado Pension Jubilado

	SET Soltero					:= 'S';				-- Estado Civil: Soltero
	SET CasadoBienSep			:= 'CS';			-- Estado Civil: Casado Bienes Separados
	SET CasadoBienManc          := 'CM';			-- Estado Civil: Casado Bienes Mancomunados
	SET CasadoBienManCap		:= 'CC';			-- Estado Civil: Casado Bienes Mancomunados con Capitulacion
	SET Viudo					:= 'V';				-- Estado Civil: Viudo

	SET Divorciado				:= 'D';				-- Estado Civil: Divorciado
	SET Separado				:= 'SE';			-- Estado Civil: Separado
	SET UnionLibre				:= 'U';				-- Estado Civil: UNION Libre
	SET PaisMex           		:= 700;       		-- ID Pais Mexico
	SET Nac_Mexicana			:= 'M';				-- Nacionalidad: Mexicana

	SET SiEsOficial				:= 'S';				-- La Direccion Si es Oficial
	SET ConstanteNo				:= 'N';				-- Constante NO
	SET ConstanteSi				:= 'S';				-- Constante NO
	SET Ident_Elector			:= 1;				-- Tipo Identificacion: ELECTOR
	SET Ident_Pasaporte			:= 2;				-- Tipo Identificacion: PASAPORTE

	SET MinCaracElector			:= 13;				-- Numero de Caracateres minimo para el Numero de Identificacion: ELECTOR
	SET MinCaracPasaporte		:= 9;				-- Numero de Caracateres minimo para el Numero de Identificacion: PASAPORTE
	SET Ident_Cartilla			:= 3;				-- Tipo Identificacion: CARTILLA MILITAR
	SET Ident_Licencia			:= 4;				-- Tipo Identificacion: LICENCIA DE MANEJO
	SET Ident_Cedula			:= 5;				-- Tipo Identificacion: CEDULA PROFESIONAL

	SET MinCaracter				:= 5;				-- Numero de Caracateres minimo para el Numero de Identificacion (CARTILLA, LICENCIA, CEDULA)
	SET MenorEdadNO         	:= 'N';       		-- No es Menor de edad
	SET NivelRiesgo        		:= 'B';        		-- Valor del riesgo
	SET EsMenor             	:= 'N'; 	    	-- Socio es menor de edad, Valor por DEFAULT N
	SET RegHacien      			:= 'N';        		-- Valor si el cliente no esta registrado en hacienda

	SET ERROR_PLD				:= 50;				-- Numero de Error de PLD Listas Negras, Pais, Personas Bloquedas
	SET CodigoCliente			:= 100;				-- SUFIJO para Codigo de Respuesa CLIENTESALT
	SET CodigoDirec				:= 200;				-- SUFIJO para Codigo de Respuesa DIRECCLIENTEALT
	SET CodigoIdenti			:= 300;				-- SUFIJO para Codigo de Respuesa IDENTIFICLIENTEALT
	SET ValorCierre				:= 'EjecucionCierreDia'; -- INDICA SI SE REALIZA EL CIERRE DE DIA.

	SET Loc_NoCatalogada		:= 999999999;

	-- Asignacion de Variables
	SET	Var_ClienteID     	:=  0;         			-- Valor que toma el ID del cliente para insertar en tabla direccliente e identificliente
	SET Var_LongRFC	 		:= (SELECT LENGTH(Par_RFC));		-- Longitud RFC
	SET Con_EnteroUno       :=  1;                  -- Constante Entero uno
	SET Con_OtrosIngresos   :=  6;                  -- ID de la tabla CATDATSOCIOE para otros ingresos
	SET Var_PaisIDDom		:= 	0;			-- Valor asignado por defecto
	SET Var_AniosRes		:= 	0;			-- Valor asignado por defecto

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRCBCLIENTESWSALT');
			END;

			SET Var_EjecutaCierre 		:= (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

			-- Validamos que no se este ejecutando el cierre de dia
			IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=SalidaSI)THEN
				SET Par_NumErr  := 800;
				SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
				LEAVE ManejoErrores;
			END IF;

			-- Validamos que el id del cliente no este dado de alta ya en clientes
			IF(Par_ClienteId > Entero_Cero) THEN
				IF EXISTS (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteId) THEN
					SET Par_NumErr  := 035;
					SET Par_ErrMen  := CONCAT('El Cliente que se esta Intentando Replicar Ya esta  Dado de Alta');
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_Piso 				:= IFNULL(Par_Piso, Cadena_Vacia);
			SET Par_PrimeraEntreCalle	:= IFNULL(Par_PrimeraEntreCalle, Cadena_Vacia);
			SET Par_SegundaEntreCalle	:= IFNULL(Par_SegundaEntreCalle, Cadena_Vacia);

			SET Par_PrimerNombre		:= REPLACE(Par_PrimerNombre, SimbInterrogacion, Cadena_Vacia);
			SET Par_SegundoNombre   	:= REPLACE(Par_SegundoNombre, SimbInterrogacion, Cadena_Vacia);
			SET Par_TercerNombre    	:= REPLACE(Par_TercerNombre, SimbInterrogacion, Cadena_Vacia);
			SET Par_ApellidoPaterno		:= REPLACE(Par_ApellidoPaterno, SimbInterrogacion, Cadena_Vacia);
			SET Par_ApellidoMaterno		:= REPLACE(Par_ApellidoMaterno, SimbInterrogacion, Cadena_Vacia);

			SET Par_FechaNacimiento		:= REPLACE(Par_FechaNacimiento, SimbInterrogacion, Fecha_Vacia);
			SET Par_CURP 				:= REPLACE(Par_CURP, SimbInterrogacion, Cadena_Vacia);
			SET Par_EstadoNacimientoID	:= REPLACE(Par_EstadoNacimientoID, SimbInterrogacion, Entero_Cero);
			SET Par_Sexo				:= REPLACE(Par_Sexo, SimbInterrogacion, Cadena_Vacia);
			SET Par_Telefono			:= REPLACE(Par_Telefono, SimbInterrogacion, Cadena_Vacia);

			SET Par_TelefonoCelular		:= REPLACE(Par_TelefonoCelular, SimbInterrogacion, Cadena_Vacia);
			SET Par_Correo				:= REPLACE(Par_Correo, SimbInterrogacion, Cadena_Vacia);
			SET Par_RFC					:= REPLACE(Par_RFC, SimbInterrogacion, Cadena_Vacia);
			SET Par_LugardeTrabajo		:= REPLACE(Par_LugardeTrabajo, SimbInterrogacion, Cadena_Vacia);

			SET Par_Puesto				:= REPLACE(Par_Puesto, SimbInterrogacion, Cadena_Vacia);
			SET Par_TelTrabajo			:= REPLACE(Par_TelTrabajo, SimbInterrogacion, Cadena_Vacia);
			SET Par_NoEmpleado			:= REPLACE(Par_NoEmpleado, SimbInterrogacion, Cadena_Vacia);
			SET Par_AntiguedadTra		:= REPLACE(Par_AntiguedadTra, SimbInterrogacion, Decimal_Cero);
			SET Par_ExtTelefonoTrab		:= REPLACE(Par_ExtTelefonoTrab, SimbInterrogacion, Cadena_Vacia);

			SET Par_TipoEmpleado		:= REPLACE(Par_TipoEmpleado, SimbInterrogacion, Cadena_Vacia);
			SET Par_TipoPuesto			:= REPLACE(Par_TipoPuesto, SimbInterrogacion, Entero_Cero);
			SET Par_SucursalOrigen		:= REPLACE(Par_SucursalOrigen, SimbInterrogacion, Entero_Cero);
			SET Par_TipoPersona			:= REPLACE(Par_TipoPersona, SimbInterrogacion, Cadena_Vacia);
			SET Par_Titulo				:= REPLACE(Par_Titulo, SimbInterrogacion, Cadena_Vacia);

			SET Par_PaisResidencia		:= REPLACE(Par_PaisResidencia, SimbInterrogacion, Entero_Cero);
			SET Par_SectorGeneral		:= REPLACE(Par_SectorGeneral, SimbInterrogacion, Entero_Cero);
			SET Par_ActividadBancoMX	:= REPLACE(Par_ActividadBancoMX, SimbInterrogacion, Cadena_Vacia);
			SET Par_EstadoCivil			:= REPLACE(Par_EstadoCivil, SimbInterrogacion, Cadena_Vacia);
			SET Par_LugarNacimiento		:= REPLACE(Par_LugarNacimiento, SimbInterrogacion, Entero_Cero);

			SET Par_PromotorInicial		:= REPLACE(Par_PromotorInicial, SimbInterrogacion, Entero_Cero);
			SET Par_PromotorActual		:= REPLACE(Par_PromotorInicial, SimbInterrogacion, Entero_Cero);
			SET Par_ExtTelefonoPart		:= REPLACE(Par_ExtTelefonoPart, SimbInterrogacion, Cadena_Vacia);
			SET Par_TipoDireccionID		:= REPLACE(Par_TipoDireccionID, SimbInterrogacion, Entero_Cero);

			SET Par_Calle				:= REPLACE(Par_Calle, SimbInterrogacion, Cadena_Vacia);
			SET Par_Numero				:= REPLACE(Par_Numero, SimbInterrogacion, Cadena_Vacia);

			SET Par_Oficial				:= REPLACE(Par_Oficial, SimbInterrogacion, Cadena_Vacia);
			SET Par_Fiscal				:= REPLACE(Par_Fiscal, SimbInterrogacion, Cadena_Vacia);
			SET Par_NumInterior			:= REPLACE(Par_NumInterior, SimbInterrogacion, Cadena_Vacia);
			SET Par_Lote				:= REPLACE(Par_Lote, SimbInterrogacion, Cadena_Vacia);

			SET Par_Manzana				:= REPLACE(Par_Manzana, SimbInterrogacion, Cadena_Vacia);
			SET Par_NumIdentific		:= REPLACE(Par_NumIdentific, SimbInterrogacion, Cadena_Vacia);
			SET Par_FecExIden			:= REPLACE(Par_FecExIden, SimbInterrogacion, Fecha_Vacia);
			SET Par_FecVenIden			:= REPLACE(Par_FecVenIden, SimbInterrogacion, Fecha_Vacia);

			SET Aud_Usuario				:= REPLACE(Aud_Usuario, SimbInterrogacion, Entero_Cero);
			SET Aud_Sucursal			:= REPLACE(Aud_Sucursal, SimbInterrogacion, Entero_Cero);

			SET Par_PaisNacionalidad    := REPLACE(Par_PaisNacionalidad,SimbInterrogacion,Entero_Cero);
			SET Par_IngresosMensuales   := REPLACE(Par_IngresosMensuales,SimbInterrogacion,Entero_Cero);
			SET Par_TamanioAcreditado   := REPLACE(Par_TamanioAcreditado,SimbInterrogacion,Entero_Cero);
			SET Par_NiveldeRiesgo       := REPLACE(Par_NiveldeRiesgo,SimbInterrogacion,Cadena_Vacia);

			SET Par_PrimerNombre    := RTRIM(LTRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
			SET Par_SegundoNombre   := RTRIM(LTRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
			SET Par_TercerNombre    := RTRIM(LTRIM(IFNULL(Par_TercerNombre, Cadena_Vacia)));
			SET Par_ApellidoPaterno := RTRIM(LTRIM(IFNULL(Par_ApellidoPaterno, Cadena_Vacia)));
			SET Par_ApellidoMaterno	:= RTRIM(LTRIM(IFNULL(Par_ApellidoMaterno, Cadena_Vacia)));

			SET Par_RFC    			:= RTRIM(LTRIM(IFNULL(Par_RFC, Cadena_Vacia)));
			SET Par_CURP    		:= RTRIM(LTRIM(IFNULL(Par_CURP, Cadena_Vacia)));
			SET Par_Sexo    		:= RTRIM(LTRIM(IFNULL(Par_Sexo, Cadena_Vacia)));
			SET Par_Correo    		:= RTRIM(LTRIM(IFNULL(Par_Correo, Cadena_Vacia)));
			SET Par_NiveldeRiesgo   := RTRIM(LTRIM(IFNULL(Par_NiveldeRiesgo, Cadena_Vacia)));

			SET Par_PrimerNombre	:= UPPER(Par_PrimerNombre);
			SET Par_SegundoNombre	:= UPPER(Par_SegundoNombre);
			SET Par_TercerNombre	:= UPPER(Par_TercerNombre);
			SET Par_ApellidoPaterno	:= UPPER(Par_ApellidoPaterno);
			SET Par_ApellidoMaterno	:= UPPER(Par_ApellidoMaterno);

			SET	Par_CURP			:= UPPER(Par_CURP);
			SET Par_Sexo			:= UPPER(Par_Sexo);
			SET	Par_RFC				:= UPPER(Par_RFC);
			SET	Par_LugardeTrabajo	:= UPPER(Par_LugardeTrabajo);
			SET Par_Puesto			:= UPPER(Par_Puesto);

			SET Par_TipoEmpleado	:= UPPER(Par_TipoEmpleado);
			SET Par_TipoPersona		:= UPPER(Par_TipoPersona);
			SET Par_Titulo			:= UPPER(Par_Titulo);
			SET Par_EstadoCivil		:= UPPER(Par_EstadoCivil);
			SET Par_Calle			:= UPPER(Par_Calle);

			SET Par_Oficial			:= UPPER(Par_Oficial);
			SET Par_Fiscal			:= UPPER(Par_Fiscal);

			SET Par_NiveldeRiesgo   := UPPER(Par_NiveldeRiesgo);

			SET Par_FecExIden 		:= IFNULL(Par_FecExIden, Fecha_Vacia);
			SET Par_FecVenIden 		:= IFNULL(Par_FecVenIden, Fecha_Vacia);

			-- Consulta de Valores parametrizables
			SELECT ValorParametro INTO Par_Clasificacion 	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'Clasificacion';
			SELECT ValorParametro INTO Par_Nacionalidad 	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'Nacionalidad';
			SELECT ValorParametro INTO Par_MotivoApertura 	FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'MotivoApertura';
			SELECT ValorParametro INTO Par_PagaISR 			FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'PagaISR';
			SELECT ValorParametro INTO Par_PagaIVA 			FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'PagaIVA';
			SELECT ValorParametro INTO Par_PagaIDE 			FROM PARAMETROSCRCBWS WHERE LlaveParametro = 'PagaIDE';

			  -- Se obtiene el Numero de Empresa
			SET Par_EmpresaID := (SELECT EmpresaDefault FROM PARAMETROSSIS LIMIT 1);

			IF(IFNULL(Par_OcupacionID, Entero_Cero)) = Entero_Cero THEN
				SET Par_OcupacionID := 9999;
			END IF;

			IF(IFNULL(Par_CP,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_CP	:=   (SELECT CodigoPostal FROM COLONIASREPUB
									WHERE EstadoID = Par_EstadoID
									AND MunicipioID = Par_MunicipioID
									AND ColoniaID = Par_ColoniaID);
			END IF;
				-- Obtencion de Actividades
			SELECT	INE.ActividadINEGIID,	FR.ActividadFRID,	FOM.ActividadFOMURID,	SEC.SectorEcoID
			INTO 	Var_ActINEGI,			Var_ActFR,			Var_ActFOMUR, 			Var_SectorEco
				FROM ACTIVIDADESBMX	BMX
					LEFT OUTER JOIN ACTIVIDADESFR AS FR  ON BMX.ActividadFR = FR.ActividadFRID
					LEFT OUTER JOIN ACTIVIDADESINEGI AS INE  ON  BMX.ActividadINEGIID	= INE.ActividadINEGIID
					LEFT OUTER JOIN SECTORESECONOM AS SEC  ON INE.SectorEcoID		= SEC.SectorEcoID
					LEFT OUTER JOIN ACTIVIDADESFOMUR AS FOM ON BMX.ActividadFOMUR = FOM.ActividadFOMURID
				WHERE BMX.ActividadBMXID = Par_ActividadBancoMX LIMIT 1;

			SET Var_ActFR := IFNULL(Var_ActFR,'999999999999');

			IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp OR Par_TipoPersona = Per_Moral) THEN
				IF (Par_RFC = Cadena_Vacia)THEN
					SET Valida_RFC	:=	Cadena_Vacia;
				ELSE
					SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFC LIMIT 1);
					IF (Valida_RFC = Par_RFC)THEN
						SET Par_NumErr := 01;
						SET Par_ErrMen := 'RFC Asociado con otro Cliente.';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF (Par_CURP != Cadena_Vacia)THEN
				SET Valida_CURP:=(SELECT  CURP FROM CLIENTES WHERE CURP = Par_CURP  AND EsMenorEdad= MenorEdadNO
								AND  TipoPersona != Per_Moral AND Par_TipoPersona != Per_Moral);
				IF (Valida_CURP = Par_CURP)THEN
					SET Par_NumErr := 02;
					SET Par_ErrMen := 'CURP Asociado con otro Cliente.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_PrimerNombre, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 03;
				SET Par_ErrMen := 'El Primer Nombre esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ApellidoPaterno, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 04;
				SET Par_ErrMen := 'El Apellido Paterno esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_EstadoID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 08;
				SET Par_ErrMen := 'El Estado esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 09;
				SET Par_ErrMen := 'El Sexo esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Puesto, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen := 'El Puesto esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_AntiguedadTra, Decimal_Cero)) = Decimal_Cero THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen :='La Antiguedad de Trabajo esta Vacia.';
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 014;
				SET Par_ErrMen := 'El Municipio esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 015;
				SET Par_ErrMen := 'La Calle esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_Numero, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 016;
				SET Par_ErrMen := 'El Numero esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 017;
				SET Par_ErrMen := 'La Colonia esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 018;
				SET Par_ErrMen := 'La Localidad esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaNacimiento, Fecha_Vacia)) = Fecha_Vacia THEN
				SET Par_NumErr := 030;
				SET Par_ErrMen := 'La Fecha de Nacimiento esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_EstadoNacimientoID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 032;
				SET Par_ErrMen := 'El Estado de Nacimiento esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_CURP, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 031;
				SET Par_ErrMen := 'La CURP esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF (IFNULL(Par_TelefonoCelular, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 033;
				SET Par_ErrMen := 'El Telefono Celular esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 034;
				SET Par_ErrMen := 'El RFC del Cliente esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_OcupacionID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 035;
				SET Par_ErrMen := 'La Ocupacion del Cliente esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_LugardeTrabajo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 036;
				SET Par_ErrMen := 'El Lugar de Trabajo del Cliente esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_SucursalOrigen, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 037;
				SET Par_ErrMen := 'La Sucursal de Origen esta Vacia.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 038;
				SET Par_ErrMen := 'El Tipo de Persona esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Titulo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:= 039;
				SET Par_ErrMen	:= 'El Titulo esta Vaci­o.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PaisResidencia, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 040;
				SET Par_ErrMen := 'El Pais de Residencia esta vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_SectorGeneral, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 041;
				SET Par_ErrMen := 'El Sector General esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ActividadBancoMX, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 042;
				SET Par_ErrMen := 'La Actividad BMX esta vacia.';
				LEAVE ManejoErrores;
			ELSE
				SET Var_ActBMX := ( SELECT  ActividadBMXID FROM ACTIVIDADESBMX WHERE ActividadBMXID = Par_ActividadBancoMX);
				IF(IFNULL(Var_ActBMX, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 042;
					SET Par_ErrMen := 'Especifique una Actividad BMX Valida.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 043;
				SET Par_ErrMen := 'El Estado Civil esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_LugarNacimiento, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 044;
				SET Par_ErrMen := 'El Lugar de Nacimiento esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PromotorInicial, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 045;
				SET Par_ErrMen := 'El Promotor Inicial esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PromotorActual, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 046;
				SET Par_ErrMen := 'El Promotor Actual esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoDireccionID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 047;
				SET Par_ErrMen := 'El Tipo de Direccion esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Oficial, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 048;
				SET Par_ErrMen := 'Indique si es Direccion Oficial.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Fiscal, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 049;
				SET Par_ErrMen := 'Indique si es Direccion Fiscal.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoIdentiID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr	:= 050;
				SET Par_ErrMen	:= 'El Tipo de Identificacion esta Vaci­o.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumIdentific, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr	:= 051;
				SET Par_ErrMen	:= 'Indique el Numero del Documento de Identificacion.';
				LEAVE ManejoErrores;
			END IF;

			IF(CHARACTER_LENGTH(Par_CURP) != MinCURP)THEN
				SET Par_NumErr := 052;
				SET Par_ErrMen := 'Se Requieren 18 Caracteres para la CURP.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_RFC, Cadena_Vacia)) <> Cadena_Vacia THEN
				IF(CHARACTER_LENGTH(Par_RFC) != MinRFC AND CHARACTER_LENGTH(Par_RFC) != MaxRFC)THEN
					SET Par_NumErr := 053;
					SET Par_ErrMen := 'La Longitud del RFC es Incorrecta.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPersona = Per_Fisica OR Par_TipoPersona = Per_ActEmp)THEN
				IF (IFNULL(Var_LongRFC, Entero_Cero) != Long_PerFisica )THEN
					SET Par_NumErr := 054;
					SET Par_ErrMen := 'La Longitud del RFC debe ser 13 Caracteres.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF (Par_TipoPersona = Per_Moral)THEN
				IF (IFNULL(Var_LongRFC, Entero_Cero) != Long_PerMoral )THEN
					SET Par_NumErr := 055;
					SET Par_ErrMen := 'La Longitud del RFC debe ser 12 Caracteres.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_Sexo,Cadena_Vacia)) != Cadena_Vacia THEN
				IF (Par_Sexo NOT IN (Masculino, Femenino)) THEN
					SET Par_NumErr := 056;
					SET Par_ErrMen := 'Caracter Incorrecto para el Sexo del Cliente.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_Correo, Cadena_Vacia)) != Cadena_Vacia THEN
				IF(Par_Correo NOT REGEXP CorreoValido)THEN
					SET Par_NumErr	:= 057;
					SET Par_ErrMen	:= 'La Direccion de Correo es Invalida';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_Clasificacion = EmpleadoNomina) THEN
				IF IFNULL(Par_NoEmpleado, Cadena_Vacia) = Cadena_Vacia THEN
					SET Par_NumErr := 058;
					SET Par_ErrMen := 'El Numero de Empleado esta Vacio.' ;
					LEAVE ManejoErrores;
				END IF;

				IF IFNULL(Par_TipoEmpleado, Cadena_Vacia) = Cadena_Vacia THEN
					SET Par_NumErr := 059;
					SET Par_ErrMen := 'El Tipo de Empleado esta Vacio.' ;
					LEAVE ManejoErrores;
				END IF;

				IF (Par_TipoEmpleado NOT IN(Empleado_Temporal,Empleado_Confianza,
											Empleado_Sindical,Empleado_Base,
											Empleado_BaseSindical,Empleado_PensionJub)) THEN
					SET Par_NumErr := 060;
					SET Par_ErrMen := 'El Valor de Tipo de Empleado es Incorrecto.' ;
					LEAVE ManejoErrores;
				END IF;

				IF IFNULL(Par_TipoPuesto, Entero_Cero)= Entero_Cero THEN
					SET Par_NumErr := 061;
					SET Par_ErrMen := 'El Tipo de Puesto esta Vacio.' ;
					LEAVE ManejoErrores;
				END IF;

				IF NOT EXISTS(SELECT TipoPuestoID FROM TIPOSPUESTOS
					WHERE TipoPuestoID = Par_TipoPuesto) THEN
					SET Par_NumErr := 062;
					SET Par_ErrMen := 'El Tipo de Puesto no Existe.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF NOT EXISTS(SELECT SucursalID FROM SUCURSALES
				WHERE SucursalID = Par_SucursalOrigen) THEN
				SET Par_NumErr := 063;
				SET Par_ErrMen := 'El Numero de Sucursal no Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) != Cadena_Vacia THEN
				IF(Par_TipoPersona NOT IN(Per_Fisica,Per_ActEmp,Per_Moral))THEN
					SET Par_NumErr := 064;
					SET Par_ErrMen := 'El Valor de Tipo Persona es Incorrecto.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) != Cadena_Vacia THEN
				IF(Par_EstadoCivil NOT IN(Soltero,CasadoBienSep,CasadoBienManc,CasadoBienManCap,
											Viudo,Divorciado,Separado,UnionLibre))THEN
					SET Par_NumErr := 065;
					SET Par_ErrMen := 'El Valor del Estado Civil es Incorrecto.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_Nacionalidad = Nac_Mexicana) THEN
				IF(Par_LugarNacimiento != PaisMex)THEN
					SET Par_NumErr := 066;
					SET Par_ErrMen := 'El Lugar de Nacimiento es Incorrecto.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF NOT EXISTS (SELECT PromotorID FROM PROMOTORES
				WHERE PromotorID = Par_PromotorInicial)THEN
				SET Par_NumErr := 067;
				SET Par_ErrMen := 'El Numero de Promotor Inicial no Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS (SELECT PromotorID FROM PROMOTORES
				WHERE PromotorID = Par_PromotorActual)THEN
				SET Par_NumErr := 068;
				SET Par_ErrMen := 'El Numero de Promotor Actual no Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS (SELECT TipoDireccionID FROM TIPOSDIRECCION
				WHERE TipoDireccionID = Par_TipoDireccionID)THEN
				SET Par_NumErr := 069;
				SET Par_ErrMen := 'El Tipo de Direccion no Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_PaisResidencia)THEN
				SET Par_NumErr	:= 070;
				SET Par_ErrMen	:= 'El Pais de Residencia No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Nacionalidad != Nac_Mexicana) THEN
				IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_LugarNacimiento)THEN
					SET Par_NumErr := 071;
					SET Par_ErrMen := 'El Lugar de Nacimiento No Existe.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
					   WHERE EstadoID = Par_EstadoID)THEN
				SET Par_NumErr	:= 072;
				SET Par_ErrMen  := 'El Valor Indicado para la Estado No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
					   WHERE MunicipioID = Par_MunicipioID
						   AND EstadoID = Par_EstadoID)THEN
				SET Par_NumErr	:= 073;
				SET Par_ErrMen  := 'El Valor Indicado para la Municipio No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
						WHERE LocalidadID = Par_LocalidadID
							AND EstadoID = Par_EstadoID
							AND MunicipioID = Par_MunicipioID)THEN
				SET Par_NumErr	:= 074;
				SET Par_ErrMen	:= 'El Valor Indicado para la Localidad No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF (Par_LocalidadID = Loc_NoCatalogada) THEN
				SELECT LocalidadID INTO Par_LocalidadID
				FROM LOCALIDADREPUB
				WHERE EstadoID = Par_EstadoID
				AND MunicipioID = Par_MunicipioID LIMIT 1;

				SET Par_LocalidadID := IFNULL(Par_LocalidadID, Entero_Cero);
			END IF;

			IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
			   WHERE EstadoID = Par_EstadoID
				   AND MunicipioID = Par_MunicipioID
				   AND ColoniaID = Par_ColoniaID)THEN
				SET Par_NumErr	:= 075;
				SET Par_ErrMen  := 'El Valor Indicado para la Colonia No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Oficial, Cadena_Vacia)) != Cadena_Vacia THEN
				IF(Par_Oficial NOT IN(SiEsOficial,ConstanteNo))THEN
					SET Par_NumErr	:= 076;
					SET Par_ErrMen	:= 'El Valor Indicado en Oficial No es Valido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_Fiscal, Cadena_Vacia)) != Cadena_Vacia THEN
				IF(Par_Fiscal NOT IN(ConstanteSi,ConstanteNo))THEN
					SET Par_NumErr	:= 077;
					SET Par_ErrMen	:= 'El Valor Indicado en Fiscal No es Valido.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF NOT EXISTS(SELECT TipoIdentiID FROM TIPOSIDENTI
				WHERE TipoIdentiID = Par_TipoIdentiID)THEN
				SET Par_NumErr	:= 078;
				SET Par_ErrMen  := 'El Valor Indicado para el Tipo de Identificacion No Existe.';
				LEAVE ManejoErrores;
			END IF;

			SELECT NumeroCaracteres,Oficial INTO Var_MaxCaracter, Var_EsOficial
				FROM TIPOSIDENTI
			WHERE TipoIdentiID = Par_TipoIdentiID;

			IF(Par_TipoIdentiID = Ident_Elector)THEN
				IF(CHARACTER_LENGTH(Par_NumIdentific) < MinCaracElector)THEN
					SET Par_NumErr	:= 079;
					SET Par_ErrMen	:= CONCAT('Se Requieren Minimo ',MinCaracElector, ' Caracteres para el Numero de Identificacion.');
					LEAVE ManejoErrores;
				ELSE
					IF(CHARACTER_LENGTH(Par_NumIdentific) > Var_MaxCaracter)THEN
						SET Par_NumErr	:= 080;
						SET Par_ErrMen	:= CONCAT('Se requieren Maximo ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Par_TipoIdentiID = Ident_Pasaporte)THEN
				IF(CHARACTER_LENGTH(Par_NumIdentific) < MinCaracPasaporte)THEN
					SET Par_NumErr	:= 081;
					SET Par_ErrMen	:= CONCAT('Se Requieren Minimo ',MinCaracPasaporte, ' Caracteres para el Numero de Identificacion.');
					LEAVE ManejoErrores;
				ELSE
					IF(CHARACTER_LENGTH(Par_NumIdentific) > Var_MaxCaracter)THEN
						SET Par_NumErr	:= 082;
						SET Par_ErrMen	:= CONCAT('Se requieren Maximo ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Par_TipoIdentiID = Ident_Cartilla)THEN
				IF(CHARACTER_LENGTH(Par_NumIdentific) < MinCaracter)THEN
					SET Par_NumErr	:= 083;
					SET Par_ErrMen	:=  CONCAT('Se Requieren Minimo ',MinCaracter, ' Caracteres para el Numero de Identificacion.');
					LEAVE ManejoErrores;
				ELSE
					IF(CHARACTER_LENGTH(Par_NumIdentific) > Var_MaxCaracter)THEN
						SET Par_NumErr	:= 084;
						SET Par_ErrMen	:= CONCAT('Se requieren Maximo ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Par_TipoIdentiID = Ident_Licencia)THEN
				IF(CHARACTER_LENGTH(Par_NumIdentific) < MinCaracter)THEN
					SET Par_NumErr	:= 085;
					SET Par_ErrMen	:= CONCAT('Se Requieren Minimo ',MinCaracter, ' Caracteres para el Numero de Identificacion.');
					LEAVE ManejoErrores;
				ELSE
					IF(CHARACTER_LENGTH(Par_NumIdentific) > Var_MaxCaracter)THEN
						SET Par_NumErr	:= 086;
						SET Par_ErrMen	:= CONCAT('Se requieren Maximo ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Par_TipoIdentiID = Ident_Cedula)THEN
				IF(CHARACTER_LENGTH(Par_NumIdentific) < MinCaracter)THEN
					SET Par_NumErr	:= 087;
					SET Par_ErrMen	:= CONCAT('Se Requieren Minimo ',MinCaracter, ' Caracteres para el Numero de Identificacion.');
					LEAVE ManejoErrores;
				ELSE
					IF(CHARACTER_LENGTH(Par_NumIdentific) > Var_MaxCaracter)THEN
						SET Par_NumErr		:= 088;
						SET Par_ErrMen		:= CONCAT('Se requieren Maximo ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF(Aud_Usuario = Entero_Cero)THEN
				SET Par_NumErr	:= 089;
				SET Par_ErrMen  := 'El Usuario esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS (SELECT UsuarioID FROM USUARIOS
							WHERE UsuarioID = Aud_Usuario) THEN
				SET Par_NumErr	:= 090;
				SET Par_ErrMen  := 'El Usuario No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF(Aud_Sucursal = Entero_Cero)THEN
				SET Par_NumErr	:= 091;
				SET Par_ErrMen  := 'La Sucursal esta Vacia.';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS (SELECT SucursalID FROM SUCURSALES
							WHERE SucursalID = Aud_Sucursal) THEN
				SET Par_NumErr	:= 092;
				SET Par_ErrMen  := 'La Sucursal No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF IFNULL(Par_PaisNacionalidad,Entero_Cero) = Entero_Cero THEN
				SET Par_NumErr := 093;
				SET Par_ErrMen := 'El Pais de Nacionalidad esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF IFNULL(Par_IngresosMensuales,Entero_Cero) = Entero_Cero THEN
				SET Par_NumErr := 094;
				SET Par_ErrMen := 'El Ingreso Mensual esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			IF IFNULL(Par_PaisNacionalidad,Cadena_Vacia) = Cadena_Vacia THEN
				SET Par_NumErr := 095;
				SET Par_ErrMen := 'El Nivel de Riesgo esta Vacio.';
				LEAVE ManejoErrores;
			END IF;

			SET Var_UnificaCI := (SELECT IFNULL(UnificaCI, 'N') FROM PARAMETROSSIS WHERE EmpresaID = 1);
			IF(Var_UnificaCI = 'S') THEN
				SET Var_ClienteID := Par_ClienteID;
			END IF;

			-- LLamada a CLIENTESALT para registrar un Cliente. Se modifica el llamado para incluir un parametro de entrada. Cardinal Sistemas Inteligentes
			CALL CLIENTESALT(
				Par_SucursalOrigen,			Par_TipoPersona,			Par_Titulo,					Par_PrimerNombre,		Par_SegundoNombre,
				Par_TercerNombre,			Par_ApellidoPaterno,		Par_ApellidoMaterno,		Par_FechaNacimiento,	Par_LugarNacimiento,
				Par_EstadoNacimientoID,		Par_Nacionalidad,			Par_PaisResidencia,			Par_Sexo,				Par_CURP,
				Par_RFC,					Par_EstadoCivil, 			Par_TelefonoCelular,		Par_Telefono,			Par_Correo,
				Cadena_Vacia,				Entero_Cero,				Cadena_Vacia,				Entero_Cero,			Cadena_Vacia,
				Par_OcupacionID,			Par_Puesto,					Par_LugardeTrabajo,			Par_AntiguedadTra,		Cadena_Vacia,
				Par_TelTrabajo,				Par_Clasificacion,			Par_MotivoApertura,  		Par_PagaISR,			Par_PagaIVA,
				Par_PagaIDE,				Par_NiveldeRiesgo,			Par_SectorGeneral,			Par_ActividadBancoMX,	Var_ActINEGI,
				Var_SectorEco,				Var_ActFR,					Var_ActFOMUR,				Par_PromotorInicial,	Par_PromotorActual,
				Entero_Cero,				EsMenor,					Entero_Cero,				RegHacien,				Entero_Cero,
				Entero_Cero,				Cadena_Vacia,				Par_NoEmpleado,				Par_TipoEmpleado,		Cadena_Vacia,
				Par_ExtTelefonoTrab,		Entero_Cero,				Entero_Cero,				Par_TipoPuesto,			Fecha_Vacia,
				Entero_Cero,				Cadena_Vacia,				Entero_Cero,				Fecha_Vacia,			Entero_Cero,
				Cadena_Vacia,				Cadena_Vacia,				Entero_Cero,				Cadena_Vacia,			Cadena_Vacia,
				Par_PaisNacionalidad,		Par_EmpresaID,				SalidaNO,					Var_NumErr,				Var_MenErr,
				Var_ClienteID,              Aud_Usuario, 				Aud_FechaActual,			Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion
			);
			-- Fin de modificacion del llamado a CLIENTESALT. Cardinal Sistemas Inteligentes


			IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) = ERROR_PLD) THEN
				SET Var_ClienteID	:= Entero_Cero;
				SET Par_NumErr		:= (Var_NumErr);
				SET Par_ErrMen		:= Var_MenErr;
				LEAVE ManejoErrores;
			ELSEIF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
				SET Var_ClienteID	:= Entero_Cero;
				SET Par_NumErr		:= (CodigoCliente +Var_NumErr);
				SET Par_ErrMen		:= Var_MenErr;
				LEAVE ManejoErrores;
			END IF;

			UPDATE CLIENTES SET
			TamanioAcreditado = Par_TamanioAcreditado
			WHERE ClienteID = Var_ClienteID;

			-- Se obtiene el nombre del Asentamiento
			SELECT Asentamiento INTO Var_NomColonia
				FROM COLONIASREPUB
				WHERE EstadoID = Par_EstadoID
				AND MunicipioID = Par_MunicipioID
				AND ColoniaID = Par_ColoniaID;


			-- LLamada a DIRECCLIENTEALT para registrar una Direccion del Cliente

			CALL DIRECCLIENTEALT(
				Var_ClienteID,    			Par_TipoDireccionID,		Par_EstadoID,			Par_MunicipioID,       	Par_LocalidadID,
				Par_ColoniaID,    			Var_NomColonia,				Par_Calle,				Par_Numero,    			Par_NumInterior,
				Par_Piso,     				Par_PrimeraEntreCalle,		Par_SegundaEntreCalle,	Par_CP,	 				Cadena_Vacia,
				Cadena_Vacia,				Cadena_Vacia,				Par_Oficial,			Par_Fiscal,		 		Par_EmpresaID,
				Cadena_Vacia,     			Cadena_Vacia,				Cadena_Vacia,           Var_PaisIDDom,			Var_AniosRes,
				SalidaNO,					Var_NumErr,					Var_MenErr,        		Aud_Usuario,            Aud_FechaActual,
				Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,      		Aud_NumTransaccion);

			IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
				SET Var_ClienteID	:= Entero_Cero;
				SET Par_NumErr		:= (CodigoDirec +Var_NumErr);
				SET Par_ErrMen		:= Var_MenErr;
				LEAVE ManejoErrores;
			END IF;

			-- Llamada a IDENTIFICLIENTEALT para registrar una Identificacion del Cliente
			CALL IDENTIFICLIENTEALT(
				Var_ClienteID,         Par_TipoIdentiID,    	Var_EsOficial,         Par_NumIdentific,   		Par_FecExIden,
				Par_FecVenIden,        Par_EmpresaID,       	SalidaNO,              Var_NumErr,      		Var_MenErr,
				Aud_Usuario,           Aud_FechaActual,     	Aud_DireccionIP,       Aud_ProgramaID,  		Aud_Sucursal,
				Aud_NumTransaccion);

			IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
				SET Var_ClienteID	:= Entero_Cero;
				SET Par_NumErr		:= (CodigoIdenti +Var_NumErr);
				SET Par_ErrMen		:= Var_MenErr;
				LEAVE ManejoErrores;
			END IF;

			/*Alta en socieconomicos para los ingresos mensuales del cliente en otros ingresos*/
			SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

			CALL CLIDATSOCIOEPRO(Con_EnteroUno,			Entero_Cero,    Var_ClienteID,      Entero_Cero,        Con_OtrosIngresos,
								Par_IngresosMensuales,  Var_FechaSis,   Entero_Cero,        SalidaNO,           Var_NumErr,
								Var_MenErr,				Par_EmpresaID,	Aud_Usuario,   		Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF Var_NumErr != Entero_Cero THEN
				SET Var_ClienteID	:= Entero_Cero;
				SET Par_NumErr		:= (CodigoIdenti +Var_NumErr);
				SET Par_ErrMen		:= Var_MenErr;
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= 'Cliente Agregado Exitosamente.';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT 	Par_NumErr		AS codigoRespuesta,
				Par_ErrMen     	AS mensajeRespuesta,
				Var_ClienteID  	AS clienteID;
	END IF;

END TerminaStore$$