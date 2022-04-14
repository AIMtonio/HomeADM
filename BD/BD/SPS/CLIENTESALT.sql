
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESALT`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESALT`(
 # ========== SP PARA ALTA DE CLIENTES =============================================
	Par_SucursalOri         INT(11),        	-- Sucursal de Origen del cliente
	Par_TipoPersona         CHAR(1),      		-- Tipo de persona
	Par_Titulo              VARCHAR(10),    	-- Titulo de la persona SR SRA SRITA
	Par_PrimerNom           VARCHAR(50),    	-- Primer nombre del cliente
	Par_SegundoNom          VARCHAR(50),    	-- Segundo nombre del cliente

	Par_TercerNom           VARCHAR(50),    	-- Tercer nombre del cliente
	Par_ApellidoPat         VARCHAR(50),    	-- Apellido paterno del cliente
	Par_ApellidoMat         VARCHAR(50),    	-- Apellido materno del cliente
	Par_FechaNac            DATE,       		-- Fecha de nacimiento de cliente
	Par_LugarNac            INT(11),       		-- Pais lugar de nacimiento

	Par_estadoID            INT(11),        	-- Estado del cliente
	Par_Nacion              CHAR(1),      		-- Pais nacionalidad
	Par_PaisResi            INT(11),        	-- Pais de residencia del cliente
	Par_Sexo                CHAR(1),     		-- Sexo del cliente
	Par_CURP                CHAR(18),     		-- CURP del cliente

	Par_RFC                 CHAR(13),     		-- RFC del Cliente
	Par_EstadoCivil         CHAR(2),     		-- Estado civil del cliente
	Par_TelefonoCel         VARCHAR(20) ,   	-- Telefono celular del cliente
	Par_Telefono            VARCHAR(20) ,   	-- Telefono fijo del cliente
	Par_Correo              VARCHAR(50),    	-- Correo electronico del cliente

	Par_RazonSocial         VARCHAR(150),   	-- Razon social del cliente
	Par_TipoSocID           INT(11),        	-- Tipo de sociedad
	Par_RFCpm               CHAR(13),     		-- RFC
	Par_GrupoEmp            INT(11),        	-- Grupo
	Par_Fax                 VARCHAR(30),    	-- Fax de contacto del cliente

	Par_OcupacionID         INT(11),        	-- Ocupacion ID del cliente
	Par_Puesto              VARCHAR(100),   	-- Puesto que ocupa el cliente
	Par_LugardeTrab         VARCHAR(100),   	-- Nombre de la empresa en la que trabaja el cliente
	Par_AntTra              FLOAT,        		-- Fecha y mes de antiguedad de trabajo del cliente
	Par_DomicilioTrabajo	VARCHAR(500),		-- Domicilio de trabajo del cliente
	Par_TelTrabajo          VARCHAR(20),    	-- Telefono de contacto de cliente

	Par_Clasific            CHAR(1),      		-- Clasificacion
	Par_MotivoApert         CHAR(1),      		-- Motivo de apertura de cuenta
	Par_PagaISR             CHAR(1),      		-- Paga ISR S:N
	Par_PagaIVA             CHAR(1),      		-- Paga IVA
	Par_PagaIDE             CHAR(1),      		-- Especifica si Cobra Impuesto de Depositos En Efectivo N=No S= Si

	Par_NivelRiesgo         CHAR(1),      		-- Nivel de riesgo
	Par_SecGeneral          INT(11),        	-- ID del sector general
	Par_ActBancoMX          VARCHAR(15),    	-- Actividad
	Par_ActINEGI            INT(11),        	-- Clave de la actividad economiva segun INEGI
	Par_SecEconomic         INT(11),        	-- Sector economico al que pertenece el cliente

	Par_ActFR         		BIGINT,       		-- Actividad Principal del Cte, segun la ACTIVIDADESFR
	Par_ActFOMUR        	INT(11),        	-- Actividad Fomur del Cte, segun la ACTIVIDADESFOMUR
	Par_PromotorIni         INT(11),        	-- ID del promotos Inicio
	Par_PromotorActual      INT(11),        	-- ID del promotor actual
	Par_ProspectoID       	INT(11),        	-- Id de prospecto del cliente en caso de serlo

	Par_EsMenorEdad         CHAR(1),      		-- El cliente es menor de edad S, N
	Par_CorpRelacionado     INT(11),        	-- Es el dato de corporativo relacionado a el cliente
	Par_RegistroHacienda    CHAR(1),      		-- Esta registrado en hacienda
	Par_NegocioAfiliadoID   INT(11),        	-- ID del negocio afiliado
	Par_InstitNominaID      INT(11),        	-- ID de la nomina afiliado

	Par_Observaciones       VARCHAR(500),   	-- Observaciones
	Par_NoEmpleado          VARCHAR(20),    	-- ID del empleado que dio de alta
	Par_TipoEmpleado        VARCHAR(1),     	-- Tipo de empleado que dio la alta
	Par_ExtTelefonoPart     VARCHAR(7),     	-- Extension del telefono particular
	Par_ExtTelefonoTrab     VARCHAR(7),     	-- Extencion del telefono de trabajo

	Par_EjecutivoCap        CHAR(5),      		-- Ejecutivo de captacion 0 No Asignado
	Par_PromotorExtInv      CHAR(5),      		-- Promotor Extreno de inversion 0 No Asignado
	Par_TipoPuesto          INT(11),       		-- Tipo de Puesto de Empleados Nomina
	Par_FechaIniTrabajo     DATE,       		-- Fecha de inicio en el trabajo actual
	Par_UbicaNegocioID      INT(11),      		-- ID de la ubicacion del negocio, relacion con CATUBICANEGOCIO

	Par_FEA           		VARCHAR(250),		-- Pais Asignado FEA
	Par_PaisFEA         	INT(11),			-- ID Pais Asignado FEA
	Par_FechaCons       	DATE,				-- Fecha constitucion RFC
	Par_PaisConstitucionID	INT(11),			-- Pais de constitucion campo para Personas Morales

	Par_CorreoAlterPM		VARCHAR(50),		-- Correo alternativo para Persona Moral
	Par_NombreNotario		VARCHAR(150),		-- Nombre del notario campo para Persona Morales
	Par_NumNotario			INT(11),			-- Numero del notario campo para Personas Morales
	Par_InscripcionReg		VARCHAR(50),		-- Numero de inscripcion en el registro publico campo para Personas Morales
	Par_EscrituraPubPM		VARCHAR(20),		-- Escritura Publica Persona Moral
	Par_PaisNacionalidad	INT(11),			-- Pais de nacionalidad del cliente

	Par_EmpresaID           INT(11),        	-- Empresa ID
	Par_Salida            	CHAR(1),      		-- Sucursal salida
	INOUT Par_NumErr      	INT(11),        	-- Numero de error
	INOUT Par_ErrMen      	VARCHAR(400),   	-- Mensaje de error

	INOUT   Par_ClienteID   INT(11),        	-- ClienteID que genero error
  /* Parametros de Auditoria */
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN
	-- Declaracion de varibles.
	DECLARE varOficial        	  CHAR(1);		-- varable Oficial
	DECLARE varFiscal       	  CHAR(1);		-- Variable fiscal
	DECLARE numActCliente     	  INT;			-- variable activiad del cliente
	DECLARE Var_Estatus_Ins       CHAR(1);		-- variable estatus institucion
	DECLARE Var_Estatus_Neg       CHAR(1);		-- variable estatus negocio
	DECLARE NumeroCliente     	  INT;			-- Variable numero de cliente
	DECLARE NombreComplet     	  VARCHAR(200);	-- Variable nombre completo
	DECLARE Fecha_Alta        	  DATE;			-- Variable Fecha de registro
	DECLARE Valida_RFC        	  CHAR(13);		-- Variable RFC
	DECLARE Valida_CURP       	  CHAR(18);		-- variable CURP
	DECLARE Var_RFCOficial        CHAR(13);		-- Variable RFC Oficial
	DECLARE Var_ActBMX        	  VARCHAR(15);	-- Variable Actividad BMX
	DECLARE Var_AnioAct       	  INT;			-- Variable anio actividad
	DECLARE Var_MesAct        	  INT;			-- Variable mes Actividad
	DECLARE Var_DiaAct        	  INT;			-- Variable dia actividad
	DECLARE Var_AnioNac       	  INT;			-- Variable Anio nacimiento
	DECLARE Var_MesNac        	  INT;			-- Variable Mes nacimiento
	DECLARE Var_DiaNac        	  INT;			-- Variable Dia nacimiento
	DECLARE Var_Anios         	  INT;			-- Variable Anios
	DECLARE Var_ChecListCte       CHAR(1);		-- Variable Checklist cliente
	DECLARE varTipoDirecID        INT(11);		-- Variable Tipo direccion cliente
	DECLARE varEstadoID       	  INT(11);		-- Variable Estado(Entidad federativa)
	DECLARE varMunicipioID        INT(11);		-- Variable Municipio
	DECLARE varCalle        	  VARCHAR(50);	-- Variable Calle
	DECLARE varNumeroExt      	  CHAR(10);		-- Variable Numero Exterior
	DECLARE varNumInterior        CHAR(10);		-- Variable Numero Interior
	DECLARE varColonia        	  VARCHAR(100);	-- Variable Colonia
	DECLARE varCP           	  CHAR(5);		-- Variable Codigo Postal
	DECLARE varLatitud        	  VARCHAR(45);	-- Variable Latitud
	DECLARE varLongitud       	  VARCHAR(45);	-- Variable Longitud
	DECLARE varManzana        	  CHAR(10);		-- Variable Manzana
	DECLARE Var_AnioActChar       CHAR(4);		-- Variable año actividad en caracteres
	DECLARE Var_MesActChar        CHAR(3);		-- Variable mes actividad en caracteres
	DECLARE Var_DiaActChar        CHAR(3);		-- Variable dia actividad en caracteres
	DECLARE Var_Fecha18			  DATE;			-- Variable Fecha 18
	-- Varialbes para personas morales
	DECLARE Var_Nacionalidad	CHAR(1);		-- Variable Nacionalidad
	DECLARE Var_Consecutivo		INT(11);		-- Variable Valor Consecutivo
	DECLARE Var_SoloNombres		VARCHAR(500);	-- Variable para solo nombre
	DECLARE Var_SoloApellidos	VARCHAR(500);	-- Variable solo apellidos
	DECLARE Var_PromIncial		INT;			-- Variable Promotor Inicial para validacion
    DECLARE Var_PromActual		INT;			-- Variable Promotor Actual Para validaciones
	DECLARE RFC_Generico		VARCHAR(15);
	DECLARE Var_CliRocktech		INT(11);		-- Numero Cliente Rocktech
	DECLARE Var_LlaveCliProEsp	VARCHAR(50);	-- Llave para filtrar el cliente parametrizado
	DECLARE Var_CliProcEspecifico	INT(11);	-- Almacena el numero del cliente parametrizado
	DECLARE Var_BusqActivaPLD		CHAR(1);	-- Indica si esta activa la busqueda desde java.
	DECLARE Var_RealizaBusqPLD		CHAR(1);	-- Indica si realiza la busqueda en listas PLD.
	DECLARE Var_RazonSocialPLD		VARCHAR(150);-- Razon social limpio de caracteres especiales.

	-- Declaracion de Constantes
	DECLARE Estatus_Activo      CHAR(1);		-- Constante para estatus Activo.
	DECLARE Cadena_Vacia      	CHAR(1);		-- Constante para Cadena Vacia
	DECLARE Fecha_Vacia       	DATE;			-- Constante para Fecha Vacia.
	DECLARE Entero_Cero       	INT;			-- Constante para valor 0
	DECLARE PaisMex         	INT;			-- Constante para el pais mexico
	DECLARE Salida_SI         	CHAR(1);		-- Constante para el valor SI
	DECLARE Salida_NO         	CHAR(1);		-- Constante para el valor NO
	DECLARE Per_Fisica        	CHAR(1);		-- Constante para Persona Fisica
	DECLARE Per_ActEmp        	CHAR(1);		-- Constante para Persona con Actividad empresarial
	DECLARE Per_Moral       	CHAR(1);		-- Constante para Persona Moral
	DECLARE Per_MenorEdad       CHAR(1);		-- Constante para Clinete Menor de edad
	DECLARE TipoOperaAlt      	INT;			-- Constante para la operacion de alta
	DECLARE Var_PaisID        	INT;			-- Constante para identificacion de pais
	DECLARE Var_LocalidadID     INT;			-- Constante para localidad
	DECLARE Var_ColoniaID     	INT;			-- Constante para Colonia
	DECLARE MenorEdadNO         CHAR(1);		-- Constante para Menor de edad NO
	DECLARE CalIFicacion        CHAR (1);		-- Constante para Calificacion
	DECLARE Act_ClienteNA     	INT;			-- Constante para ClienteNA
	DECLARE Act_ClienteEN     	INT;			-- Constante para ClienteEN
	DECLARE Moral         		CHAR(1);		-- Constante para valor Moral
	DECLARE Baja          		CHAR(1);		-- Constante para valor Baja
	DECLARE NoEsMenor       	CHAR(1);		-- Constante para No es menor
	DECLARE EsMenor         	CHAR(1);		-- Constante para Es menor
	DECLARE EmpNomina           CHAR(1);		-- Constante para empresa de nomina
	DECLARE TipoInstrumento     INT(11);		-- Constante para el tipo de instrumento
	DECLARE RequeridoEn       	CHAR(1);		-- Constante para Requerido en
	DECLARE Fecha_AltaCHAR      CHAR(10);		-- Constante para Fecha de alta en caracteres
	DECLARE esCopRelacionado    CHAR(1);		-- Constante para Si esta RElacionado
	DECLARE esCorporativo     	CHAR(1);		-- Constante para si es Corporativo
	DECLARE esEmpresaNomina     CHAR(1);		-- Constante para Si es empresa de nomina
	DECLARE esNegocioAfilia     CHAR(1);		-- Constante para si es empresa afilial
	DECLARE nacionalidadMex     CHAR(1);		-- Constante para Nacionalidad Mexicana
	DECLARE nacionalidadExt     CHAR(1);		-- Constante para Nacionalidad Extranjeta
	DECLARE Var_Control       	VARCHAR(20);	-- Constante para la variable de control
	DECLARE Var_CampoGenerico   INT(11);		-- Constante para Campo generico
	DECLARE ReportarSi        	CHAR(1);		-- Constante para reportar SI
	DECLARE ReportarNo        	CHAR(1);		-- Constante pata reportar NO
	DECLARE EsNA          		VARCHAR(3);		-- Constante para saber si es NA
	DECLARE Es_Cliente			VARCHAR(3);
	DECLARE Cons_Si				CHAR(1);		-- Constante para valor SI
	DECLARE IDPaisNoEsp			INT(11);		-- Constante para identificador de paos no especificado
	DECLARE Tip_ConCliPM		CHAR(1);		-- Constante para conciliacion del cliente
	DECLARE Mayusculas			CHAR(2);		-- Constante para las Mayusculas
	DECLARE Alt_Clientes		INT(11);		-- Constante para alta de cliente
	DECLARE DirecCompleta		VARCHAR(500);	-- DIREC COMPLETA
	DECLARE Var_Lote			CHAR(50);		-- LOTE
	DECLARE CliCrediClub		INT(11);
	DECLARE CliProEsp			INT(11);
	DECLARE Var_UnificaCI           VARCHAR(1);
	DECLARE Var_PaisIDDom		INT(11);		-- País ID de la dirección
	DECLARE Var_AniosRes		INT(11);		-- Años de residencia
	DECLARE Var_PaisDef			INT(11);		-- País 999 INSUFICIENTEMENTE ESPECIFICADO
    DECLARE Var_DetecNoDeseada	CHAR(1);		-- Valida la activacion del proceso de personas no deseadas
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
	DECLARE Var_FechaNac 		DATE;
    
	-- Asiganacion de constantes
	SET Estatus_Activo      := 'A';       -- Estatus activo
	SET Cadena_Vacia        := '';        -- Cadena vacia
	SET Fecha_Vacia         := '1900-01-01';  -- FEcha vacia
	SET Entero_Cero         := 0;       -- Entero cero
	SET PaisMex           	:= 700;       -- ID Pais Mexico
	SET Salida_SI           := 'S';       -- Salida SI
	SET Salida_NO           := 'N';       -- Salida NO
	SET varOficial          := 'S';       -- La direccion del cliente es la oficial
	SET varFiscal         	:= '';        -- La direccion fiscal del cliente
	SET numActCliente       :=  1;        -- Numero de cliente prospecto
	SET TipoOperaAlt        :=  10;       -- Tipo de operacion de alta para verificar en la lista negra
	SET var_PaisID          :=  0;        -- Identificador del pais
	SET MenorEdadNO         := 'N';       -- No es Menor de edad
	SET esCopRelacionado    := 'R';       -- Es corporativo relacionado al cliente
	SET esCorporativo       := 'C';       -- Es corporativo
	SET esEmpresaNomina     := 'N';       -- No es empresa de nomina
	SET esNegocioAfilia     := 'F';       -- Es negocio afiliado

	SET NumeroCliente       :=  0;        -- Numero de cliente
	SET NombreComplet       := '';        -- Nombre completo
	SET Per_Fisica          := 'F';       -- Persona fisica
	SET Per_ActEmp          := 'A';       -- Actividad empresarial
	SET Per_Moral         	:= 'M';       -- Persona moral
	SET Per_MenorEdad       := 'E';       -- Persona menor de edad
	SET Var_ActBMX          := '';        -- Actividad BMX
	SET Calificacion        := 'N';       -- Calificacion del cliente
	SET Act_ClienteNA       :=  2;        -- Numero de actualizacion de cliente 2: alta
	SET Act_ClienteEN       :=  2;        -- Numero de actualizacion de institucion de nomina 2 alta
	SET Moral           	:= 'M';       -- Persona moral
	SET Baja            	:= 'B';       -- Estatus de baja
	SET EsMenor           	:= 'S';       -- Es menor
	SET NoEsMenor         	:= 'N';       -- No es menor
	SET EmpNomina           := 'M';       -- Empleado de nomida
	SET TipoInstrumento     := 4;		  -- tipo de instrumento
	SET RequeridoEn         := "C";       -- Es Requerido en
	SET nacionalidadMex     := 'N';       -- Nacionalida mexicana
	SET nacionalidadExt     := 'E';       -- nacionalidad extranjera
	SET Var_Control         := '';		  -- variable de control
	SET ReportarSi          := 'S';       -- Se reporta
	SET ReportarNo          := 'N';       -- No se reporta
	SET Var_CampoGenerico   := 0;         -- Campo generico
	SET EsNA            	:= 'NA';       -- No se trata ni de un cliente ni de un usuario de servicios
	SET Es_Cliente			:= 'CTE';		-- Tipo de Persona Cliente.
	SET Cons_Si				:= 'S';		   -- Constante si
	SET IDPaisNoEsp			:= 999;		   -- Pais no Especificado en la tabla Paises
	SET Tip_ConCliPM		:= '2';		   -- Tipo de consulta de Caracteres Validos para persona Moral
	SET Mayusculas			:= 'MA';	   -- Obtener el resultado en Mayusculas
	SET Fecha_Alta 			:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);
	SET Var_Fecha18 := DATE_SUB(Fecha_Alta,INTERVAL 18 YEAR);
	SET Alt_Clientes			:= 1;			-- alta de clientes
    SET Par_PagaIDE				:= 'S';		-- todos los clientes pagan IDE
    SET CliCrediClub			:= '24';
	SET RFC_Generico		:= 'XEXX010101000';
    SET CliProEsp 			:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
    SET Var_PromIncial		:= (SELECT PromotorID FROM PROMOTORES WHERE PromotorID = Par_PromotorIni); -- seteo de la varible promotor inicial
    SET Var_PromActual		:= (SELECT PromotorID FROM PROMOTORES WHERE PromotorID = Par_PromotorActual); -- seteo de la variable promotor actual
    SET Var_LlaveCliProEsp	:=	'CliProcEspecifico';	-- Llave para filtrar el cliente parametrizado
    SET Var_CliRocktech		:= 44;						-- Numero de cliente registrado en el SAFI
    SET Var_PaisIDDom		:= 0;			-- Valor asignado por defecto
    SET Var_AniosRes		:= 0;			-- Valor asignado por defecto
    SET Var_PaisDef			:= 999;			-- INSUFICIENTEMENTE ESPECIFICADO
    SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
	SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
	SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
	SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas
	

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-CLIENTESALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

		SET Par_PrimerNom			:= TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
		SET Par_SegundoNom			:= TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
		SET Par_TercerNom			:= TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
		SET Par_ApellidoPat			:= TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
		SET Par_ApellidoMat			:= TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));
		SET Par_NegocioAfiliadoID	:= IFNULL(Par_NegocioAfiliadoID, Entero_Cero);
		SET Par_InstitNominaID		:= IFNULL(Par_InstitNominaID, Entero_Cero);
		SET Par_FechaCons			:= IFNULL(Par_FechaCons,Fecha_Vacia);

		SET Par_TelefonoCel			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelefonoCel, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
		SET Par_Telefono			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_Telefono," ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
		SET Par_TelTrabajo			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelTrabajo," ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

			IF Par_EsMenorEdad =Cadena_Vacia THEN
				SET Par_EsMenorEdad=NoEsMenor;
			END IF;

		SELECT 	ValorParametro
		INTO	Var_CliProcEspecifico
		FROM PARAMGENERALES
		WHERE LlaveParametro = Var_LlaveCliProEsp;

		SET Var_CliProcEspecifico := IFNULL(Var_CliProcEspecifico, Entero_Cero);

		IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
			IF (Par_RFC = Cadena_Vacia)THEN
				SET Valida_RFC:=Cadena_Vacia;
			ELSE
				SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFC AND RFCOficial != RFC_Generico);
				IF (Valida_RFC = Par_RFC)THEN
					SET Par_NumErr :=   036;
					SET Par_ErrMen := 'RFC asociado con otro safilocale.cliente .';
					SET Var_Control := 'RFC';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF (Par_CURP != Cadena_Vacia)THEN
			SET Valida_CURP:=(SELECT  CURP FROM CLIENTES WHERE CURP = Par_CURP  AND EsMenorEdad= MenorEdadNO
							AND  TipoPersona != Per_Moral AND Par_TipoPersona != Per_Moral);
			IF (Valida_CURP = Par_CURP)THEN
				SET Par_NumErr := 037;
				SET Par_ErrMen :=   'CURP asociada a otro safilocale.cliente .';
				SET Var_Control := 'CURP';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_CURP != Cadena_Vacia)THEN
			SET Valida_CURP:=(SELECT  CURP FROM CLIENTES WHERE CURP = Par_CURP  AND EsMenorEdad=EsMenor AND Estatus =Estatus_Activo);
			IF (Valida_CURP = Par_CURP)THEN
				SET Par_NumErr := 038;
				SET Par_ErrMen := 'CURP asociada a un safilocale.cliente Menor Activo.';
				SET Var_Control := 'CURP';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_SucursalOri, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'La sucursal esta vacia.';
			SET Var_Control := 'sucursalOrigen';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Tipo de Persona esta vacio.';
			SET Var_Control := 'tipoPersona1';
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones Personas fisicas o fisicas con actividad empresarial
		IF(Par_TipoPersona <> Per_Moral) THEN

			IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Primer Nombre esta vacio.';
				SET Var_Control := 'primerNombre';
				LEAVE ManejoErrores;
			END IF;


			IF(IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND
					IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'Se requiere al menos uno de los Apellidos.';
				SET Var_Control := 'apellidoParterno';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_LugarNac = PaisMex) THEN
				IF(IFNULL(Par_estadoID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 005;
					SET Par_ErrMen := 'El Estado esta vacio.';
					SET Var_Control := 'estadoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_LugarNac, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 007;
				SET Par_ErrMen := 'El Pais de Lugar de Nacimiento esta vacio.';
				SET Var_Control := 'lugarNacimiento';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PaisResi, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'El Pais de Residencia esta vacio.';
				SET Var_Control := 'paisResidencia';
				LEAVE ManejoErrores;
			END IF;

			SELECT PaisID INTO Var_PaisID FROM PAISES WHERE PaisID = Par_PaisResi;
			IF(IFNULL(Var_PaisID, Entero_Cero))= Entero_Cero THEN
			  SET Par_NumErr := 009;
			  SET Par_ErrMen := 'El Pais de residencia especificado No Existe.';
			  SET Var_Control := 'lugarNAcimiento';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoPersona=Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
				IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 010;
					SET Par_ErrMen := 'El Sexo esta vacio.';
					SET Var_Control := 'sexo';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF((Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) AND (Par_EsMenorEdad = MenorEdadNO)) THEN
				IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 011;
					SET Par_ErrMen := 'El RFC esta vacio.';
					SET Var_Control := 'RFC';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_AntTra = NULL) THEN
				SET Par_NumErr := 013;
				SET Par_ErrMen :='La antiguedad de Trabajo esta vacia.';
				SET Var_Control := 'antiguedadTra';
				LEAVE ManejoErrores;
			END IF;

			IF((IFNULL(Par_Telefono,Cadena_Vacia)=Cadena_Vacia) AND (IFNULL(Par_Correo,Cadena_Vacia)=Cadena_Vacia))THEN
				IF(IFNULL(Par_TelefonoCel,Cadena_Vacia)=Cadena_Vacia)THEN
					SET Par_NumErr := 044;
					SET Par_ErrMen := 'El Telefono Celular es requerido.';
					SET Var_Control := 'telefonoCelular';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF((IFNULL(Par_TelefonoCel,Cadena_Vacia)=Cadena_Vacia) AND (IFNULL(Par_Correo,Cadena_Vacia)=Cadena_Vacia))THEN
					IF(IFNULL(Par_Telefono,Cadena_Vacia)=Cadena_Vacia)THEN
						SET Par_NumErr := 045;
						SET Par_ErrMen := 'El Telefono es requerido.';
						SET Var_Control := 'telefonoCasa';
						LEAVE ManejoErrores;
					END IF;
				ELSE
					IF((IFNULL(Par_Telefono,Cadena_Vacia)=Cadena_Vacia) AND (IFNULL(Par_TelefonoCel,Cadena_Vacia)=Cadena_Vacia))THEN
						IF(IFNULL(Par_Correo,Cadena_Vacia)=Cadena_Vacia)THEN
							SET Par_NumErr := 046;
							SET Par_ErrMen := 'El Correo Electronico es requerido.';
							SET Var_Control := 'correo';
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;
			END IF;


			IF(IFNULL(Par_FechaNac, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr := 033;
				SET Par_ErrMen := 'Se Requiere la Fecha de Nacimiento.';
				SET Var_Control := 'fechaNacimiento';
				LEAVE ManejoErrores;
			ELSE

				IF (Par_EsMenorEdad =MenorEdadNO && Par_TipoPersona != Moral) THEN

					SET Var_AnioAct := YEAR(Fecha_Alta);
					SET Var_MesAct  := MONTH(Fecha_Alta);
					SET Var_DiaAct  := DAY(Fecha_Alta);
					SET Var_AnioNac := YEAR(Par_FechaNac);
					SET Var_MesNac  := MONTH(Par_FechaNac);
					SET Var_DiaNac  := DAY(Par_FechaNac);
					SET Var_Anios := Var_AnioAct-Var_AnioNac;


					IF(Var_MesAct<Var_MesNac) THEN
						SET Var_Anios := Var_Anios-1;
					END IF;

					IF(Var_MesAct = Var_MesNac)THEN
						IF(Var_DiaAct<Var_DiaNac) THEN
							SET Var_Anios := Var_Anios-1;
						END IF;
					END IF;

					IF( CliProEsp <> CliCrediClub) THEN
						IF (Var_Anios <18) THEN
							SET Par_NumErr := 034;
							SET Par_ErrMen := 'El safilocale.cliente es Menor de Edad, Registrarlo en la Pantalla Correspondiente';
							SET Var_Control  := 'fechaNacimiento';
							SET NumeroCliente := Entero_Cero;
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;
			END IF;

		ELSE
			-- Si es una persona moral el Campo Lugar de Nacimiento y Pais de Residencia debe llevar el id de pais no especificado
			SET Par_LugarNac := IDPaisNoEsp;
			SET Par_PaisResi := Par_PaisConstitucionID;

			IF(SELECT FNCLIENTESCARACTERESESP(Par_RazonSocial,Tip_ConCliPM)!= Entero_Cero )THEN
				SET Par_NumErr  := 060;
				SET Par_ErrMen  := CONCAT('Ingreso un Caracter Invalido - ', Par_RazonSocial);
				SET Var_Control := 'razonSocial';
				LEAVE   ManejoErrores;
			END IF;

		END IF; -- fin validaciones para personas fisicas y fisicas con actividad empresarial

		IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La Nacionalidad esta vacia.';
			SET Var_Control := 'nacion';
			LEAVE ManejoErrores;
		ELSE
			SET Var_Nacionalidad := Par_Nacion;
		END IF;

		IF(IFNULL(Par_LugarNac, Entero_Cero))<> Entero_Cero THEN
				SELECT PaisID INTO Var_PaisID FROM PAISES WHERE PaisID = Par_LugarNac;
			IF(IFNULL(Var_PaisID, Entero_Cero))= Entero_Cero THEN
			  SET Par_NumErr := 008;
			  SET Par_ErrMen := 'El Pais especificado como el Lugar de Nacimiento No Existe.';
			  SET Var_Control := 'lugarNAcimiento';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Clasific, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := 'La Clasificacion esta vacia.';
			SET Var_Control := 'clasificacion';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MotivoApert, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 015;
			SET Par_ErrMen := 'EL motivo de Apertura esta vacio.';
			SET Var_Control := 'motivoApertura';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PagaISR, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 016;
			SET Par_ErrMen := 'El ISR esta vacio.';
			SET Var_Control := 'pagaISR';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PagaIVA, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 017;
			SET Par_ErrMen := 'El IVA esta vacio.';
			SET Var_Control := 'pagaIVA';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PagaIDE, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 018;
			SET Par_ErrMen := 'El IDE esta vacio.';
			SET Var_Control := 'pagaIDE';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NivelRiesgo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 019;
			SET Par_ErrMen := 'El Nivel de Riesgo esta vacio.';
			SET Var_Control := 'nivelRiesgo';
			LEAVE ManejoErrores;
		END IF;

		SET Par_GrupoEmp 	:= IFNULL(Par_GrupoEmp, Entero_Cero);
		SET Par_OcupacionID := IFNULL(Par_OcupacionID, Entero_Cero);

		IF(IFNULL(Par_SecGeneral, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 020;
			SET Par_ErrMen := 'El sector General esta vacio.';
			SET Var_Control := 'sectorGeneral';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActBancoMX, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 021;
			SET Par_ErrMen := 'La Actividad BMX esta vacia.';
			SET Var_Control := 'actividadBancoMX';
			LEAVE ManejoErrores;
		ELSE
			SET Var_ActBMX := ( SELECT  ActividadBMXID FROM ACTIVIDADESBMX WHERE ActividadBMXID = Par_ActBancoMX);
			IF(IFNULL(Var_ActBMX, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 021;
				SET Par_ErrMen := 'Especifique una Actividad BMX valida.';
				SET Var_Control := 'actividadBancoMX';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_PromotorIni, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 022;
			SET Par_ErrMen := 'El Promotor Inicial esta vacio.';
			SET Var_Control := 'promotorInicial';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PromotorActual, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 023;
			SET Par_ErrMen := 'El Promotor Actual esta vacio.';
			SET Var_Control := 'promotorActual';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActFR, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 025;
			SET Par_ErrMen := 'La Actividad FR esta vacia.';
			SET Var_Control := 'descripcionActFR2';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActFOMUR, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 025;
			SET Par_ErrMen := 'La Actividad FOMUR esta vacia.';
			SET Var_Control := 'desActFomur2';
			LEAVE ManejoErrores;
		END IF;

		IF Par_Clasific = esCopRelacionado THEN
			IF  (IFNULL(Par_CorpRelacionado, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 026 ;
				SET Par_ErrMen := 'El Corporativo Relacionado al safilocale.cliente esta vacio.';
				SET Var_Control := 'corpRelacionado';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF  Par_Clasific = esCorporativo THEN
			IF  (Par_TipoPersona) != Per_Moral THEN
				SET Par_NumErr := 027;
				SET Par_ErrMen := 'El Corporativo debe ser una Persona Moral.';
				SET Var_Control := 'corpRelacionado';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_RegistroHacienda, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr :=  028;
			SET Par_ErrMen :=  'El campo Registro Hacienda esta vacio.';
			SET Var_Control := 'registroHaciENDaSi';
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Clasific = esNegocioAfilia) THEN
			SELECT Estatus INTO Var_Estatus_Neg
				FROM NEGOCIOAFILIADO
					WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID;
			IF NOT EXISTS(SELECT NegocioAfiliadoID FROM NEGOCIOAFILIADO WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID ) THEN
				SET Par_NumErr := 029;
				SET Par_ErrMen := 'El Negocio Afiliado no Existe.';
				SET Var_Control := 'negocioAfiliadoID';
				LEAVE ManejoErrores;
			END IF;

			IF (Var_Estatus_Neg=Baja)THEN
				SET Par_NumErr := 029;
				SET Par_ErrMen :=  CONCAT('El Negocio Afiliado se Encuentra Cancelado: ',CONVERT(Par_NegocioAfiliadoID,CHAR));
				SET Var_Control := 'negocioAfiliadoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_Clasific = esEmpresaNomina) THEN
			SELECT Estatus INTO Var_Estatus_Ins
				FROM INSTITNOMINA
					WHERE InstitNominaID = Par_InstitNominaID;
			IF NOT EXISTS(SELECT InstitNominaID FROM INSTITNOMINA WHERE InstitNominaID = Par_InstitNominaID ) THEN
				SET Par_NumErr := 030;
				SET Par_ErrMen := 'La Institucion de Nomina no Existe.';
				SET Var_Control := 'institNominaID';
				LEAVE ManejoErrores;
			END IF;
			IF (Var_Estatus_Ins=Baja)THEN
				SET Par_NumErr := 030;
				SET Par_ErrMen :=  CONCAT('La Institucion de Nomina se Encuentra Cancelada: ',CONVERT(Par_NegocioAfiliadoID,CHAR));
				SET Var_Control := 'institNominaID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_Clasific = esNegocioAfilia) THEN
			IF(Par_TipoPersona!=Moral) THEN
				SET Par_NumErr := 031;
				SET Par_ErrMen := 'Para ser Negocio Afiliado se requiere una Persona Moral.';
				SET Var_Control := 'tipoPersona2';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_Clasific = esEmpresaNomina) THEN
			IF(Par_TipoPersona!=Moral)THEN
				SET Par_NumErr := 032;
				SET Par_ErrMen := 'Para ser Corporativo Nomina se requiere una Persona Moral';
				SET Var_Control := 'tipoPersona2';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp OR Par_TipoPersona = Per_MenorEdad) THEN
			SET NombreComplet		:= FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
			SET Var_RFCOficial		:= Par_RFC;
			SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNom,Par_SegundoNom,Par_TercerNom,Cadena_Vacia,Cadena_Vacia),Mayusculas),500);
			SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia,Cadena_Vacia,Cadena_Vacia,Par_ApellidoPat,Par_ApellidoMat),Mayusculas),500);
			SET Var_RazonSocialPLD	:= Cadena_Vacia;
		END IF;

        SET Var_UnificaCI       :=  (SELECT IFNULL(UnificaCI,'N') FROM PARAMETROSSIS WHERE EmpresaID = 1);

		SET NumeroCliente 	:= (SELECT IFNULL(MAX(ClienteID),Entero_Cero) + 1 FROM CLIENTES);

		IF(Var_UnificaCI = 'S' AND IFNULL(Par_ClienteID,0)>0 ) THEN
            SET NumeroCliente 	:= Par_ClienteID;
		    SET Par_ClienteID 	:= LPAD(NumeroCliente, 10, 0);
        END IF;

       SET Par_ClienteID 	:= LPAD(NumeroCliente, 10, 0);

		SET Aud_FechaActual := NOW();

		IF (Par_Clasific = EmpNomina) THEN
			IF (Par_TipoPuesto = Entero_Cero) THEN
				SET Par_NumErr := 043;
				SET Par_ErrMen := 'El Tipo de Puesto esta vacio.';
				SET Var_Control := 'tipoPuestoID';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT TipoPuestoID FROM TIPOSPUESTOS
				WHERE TipoPuestoID = Par_TipoPuesto) THEN
				SET Par_NumErr := 043;
				SET Par_ErrMen := 'El Tipo de Puesto no Existe.';
				SET Var_Control := 'tipoPuestoID';
			END IF;
		END IF;

		IF((Par_TipoPersona = Per_Moral OR Par_TipoPersona= Per_ActEmp) AND (Par_Nacion=nacionalidadMex)) THEN
			IF((IFNULL(Par_FechaCons,Fecha_Vacia)=Fecha_Vacia) OR (IFNULL(Par_FechaCons,Cadena_Vacia)=Cadena_Vacia)) THEN
				SET Par_NumErr := 048;
				SET Par_ErrMen := 'La Fecha de Constitucion es requerida.';
				SET Var_Control := 'fechaConstitucion';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_OcupacionID, Entero_Cero)=Entero_Cero)THEN
			IF (Par_TipoPersona != Per_Moral AND Par_EsMenorEdad = MenorEdadNO) THEN
				SET Par_NumErr := 049;
				SET Par_ErrMen := 'La Ocupacion es requerida.';
				SET Var_Control := 'ocupacionID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_TipoPersona = Per_Moral) THEN
			SET NombreComplet		:= Par_RazonSocial;
			SET Var_RFCOficial		:= Par_RFCpm;
			SET Par_EsMenorEdad		:= NoEsMenor;
			SET Var_SoloNombres		:= Cadena_Vacia;
			SET Var_SoloApellidos	:= Cadena_Vacia;
			SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(TRIM(Par_RazonSocial),Mayusculas),150);

			IF (Par_RFCpm = Cadena_Vacia)THEN
				SET Valida_RFC:=Cadena_Vacia;
			ELSE
				SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFCpm);
				IF (Valida_RFC = Par_RFCpm)THEN
					SET Par_NumErr := 036;
					SET Par_ErrMen :=   'RFC asociado con otro safilocale.cliente .';
					SET Var_Control := 'RFC';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_RFCpm, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 024;
				SET Par_ErrMen := 'El RFC esta vacio.';
				SET Var_Control := 'RFCpm';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaCons, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 051;
				SET Par_ErrMen  := 'Se Requiere la Fecha de Constitucion.';
				SET Var_Control := 'fechaRegistro';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NombreNotario, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 052;
				SET Par_ErrMen  := 'Se Requiere Nombre del Notario.';
				SET Var_Control := 'nombreNotario';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumNotario,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 053;
				SET Par_ErrMen  := 'Se requiere el Numero de Notario.';
				SET Var_Control := 'numNotario';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_InscripcionReg, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 054;
				SET Par_ErrMen  := 'Se Requiere el Numero de Inscripcion en el Registro Publico.';
				SET Var_Control := 'inscripcionReg';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PaisConstitucionID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 049;
				SET Par_ErrMen  := 'Se requiere el Pais de Constitucion.';
				SET Var_Control := 'paisConstitucionID';
				LEAVE ManejoErrores;
			END IF;

			-- Rocktech no necesita la validacion de Escritura
			IF(Var_CliProcEspecifico <> Var_CliRocktech) THEN
				IF(IFNULL(Par_EscrituraPubPM, Cadena_Vacia) = Cadena_Vacia) THEN
					SET Par_NumErr  := 056;
					SET Par_ErrMen  := 'Se Requiere la Escritura Publica.';
					SET Var_Control := 'escrituraPubPM';
					LEAVE ManejoErrores;
				END IF;
			END IF;

		ELSE
			-- Si no es una persona moral el Campo Pais de Constiucion debe llevar el id de pais no especificado
			SET Par_PaisConstitucionID := IDPaisNoEsp;

		END IF; -- FIN VALIDACIONES PERSONA MORAL

		IF (Par_TipoPersona =  Per_Moral )THEN
			SET Par_RegistroHacienda :='S';
		END IF;

		IF (IFNULL(Var_PromIncial,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 057;
			SET Par_ErrMen  := 'El Promotor Inicial no Existe';
			SET Var_Control := 'promotorInicial';
			LEAVE ManejoErrores;
        END IF;

    	IF (IFNULL(Var_PromActual,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 057;
			SET Par_ErrMen  := 'El Promotor Actual no Existe';
			SET Var_Control := 'promotorActual';
			LEAVE ManejoErrores;
        END IF;


        IF IFNULL(Par_PaisNacionalidad,Entero_Cero) = Entero_Cero AND Par_TipoPersona != Per_Moral THEN
       		SET Par_NumErr  := 058;
			SET Par_ErrMen  := 'El Pais de Nacionalidad no Existe';
			SET Var_Control := 'paisNacionalidad';
			LEAVE ManejoErrores;
        END IF;
		
        /*INICIO VALIDACION PERSONAS NO DESEADAS*/
		SELECT  PersonNoDeseadas INTO Var_DetecNoDeseada
			FROM PARAMETROSSIS LIMIT 1;
		
		SET  Var_DetecNoDeseada:= IFNULL(Var_DetecNoDeseada,Salida_NO);
		
		IF(Var_DetecNoDeseada = Salida_SI) THEN

			CALL PLDDETECPERSNODESEADASPRO(
				Entero_Cero,			Var_RFCOficial,			Par_TipoPersona,					Salida_NO,				Par_NumErr,
				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,						Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
				SET Par_NumErr			:= 050;
				SET Par_ErrMen			:= Par_ErrMen;	
				LEAVE ManejoErrores;
			END IF;

		END IF;
		/*FIN VALIDACION PERSONAS NO DESEADAS*/
    
		# SE CONSULTA PARÁMETRO ACTIVO PARA REALIZAR LA BUSQUEDA DE LISTAS PLD EN BD.
		SET Var_BusqActivaPLD	:= LEFT(TRIM(FNPARAMGENERALES('PLD_BusqListasLV')),1);
		SET Var_BusqActivaPLD	:= IFNULL(Var_BusqActivaPLD,Salida_NO);
		SET Var_RealizaBusqPLD	:= IF(Var_BusqActivaPLD = Cons_Si,Salida_NO,Cons_Si);

		/*SECCION PLD: Deteccion de operaciones inusuales*/
		CALL PLDDETECCIONPRO(
			Entero_Cero,			Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
			Par_ApellidoMat,		Par_TipoPersona,		Par_RazonSocial,		Par_RFC,				Par_RFCpm,
			Par_FechaNac,			Entero_Cero,			Par_LugarNac,			Par_EstadoID,			NombreComplet,
			EsNA,					Salida_NO,				Var_RealizaBusqPLD,		Cons_Si,				Salida_NO,
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
											AND NomPersonaInv = NombreComplet
											AND TipoPersonaSAFI = EsNA
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Entero_Cero LIMIT 1);

			IF (Par_TipoPersona = Per_Moral) THEN
				SET NombreComplet	:= FNLIMPIACARACTERESGEN(TRIM(Par_RazonSocial),'M');
				SET NombreComplet	:= IFNULL(NombreComplet,Cadena_Vacia);
				SET Var_RFCOficial := Par_RFCpm;
				SET Var_FechaNac := Fecha_Vacia;
				SET Var_PaisID := Par_PaisConstitucionID;
				SET Var_SoloNombre := Cadena_Vacia;
				SET Var_SoloApellido := Cadena_Vacia;
			ELSE
				SET Var_RFCOficial := Par_RFC;
				SET Var_FechaNac := Par_FechaNac;
				SET Var_PaisID := Par_LugarNac;
				SET Var_SoloNombre			:=  FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Cadena_Vacia,Cadena_Vacia);
				SET Var_SoloApellido		:=  FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApellidoPat,Par_ApellidoMat);
			END IF;

			SET Var_ErrMen := Par_ErrMen;
			IF IFNULL(Var_OpeInusualID,Entero_Cero) != Entero_Cero THEN

				SELECT OpeInusualID INTO Var_OpeInusualIDSPL
				FROM PLDSEGPERSONALISTAS
				WHERE OpeInusualID = Var_OpeInusualID;

				IF IFNULL(Var_OpeInusualIDSPL,Entero_Cero) = Entero_Cero THEN

					-- Damos de alta en la tabla de coincidencias de personas en listas e personas bloqueadas por el momento es para este tipo de lista
					CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,	EsNA,				Entero_Cero,			NombreComplet,			Var_FechaDeteccion,
												Con_LPB,			Var_SoloNombre,		Var_SoloApellido,		Var_FechaNac,			Var_RFCOficial,
												Var_PaisID,			Salida_NO,			Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
												Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,
												Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			SET Par_NumErr			:= 50; -- NO CAMBIAR ESTE NUMERO DE ERROR
			SET Par_ErrMen			:= Var_ErrMen;
			SET Var_Control			:= 'agrega';
			LEAVE ManejoErrores;
		END IF;

		/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

		INSERT INTO CLIENTES (
			ClienteID,				EmpresaID,				SucursalOrigen,			TipoPersona,			Titulo,
			PrimerNombre,			SegundoNombre,			TercerNombre,			ApellidoPaterno,		ApellidoMaterno,
			FechaNacimiento,		CURP,					Nacion,					PaisResidencia,			GrupoEmpresarial,
			RazonSocial,			TipoSociedadID,			Fax,					Correo,					RFC,
			RFCpm,					SectorGeneral,			ActividadBancoMX,		ActividadINEGI,			SectorEconomico,
			Sexo,					EstadoCivil,			LugarNacimiento,		EstadoID,				OcupacionID,
			LugardeTrabajo,			Puesto,					TelTrabajo,				AntiguedadTra,			TelefonoCelular,
			Telefono,				Clasificacion,			MotivoApertura,			PagaISR,				PagaIVA,
			PagaIDE,				NivelRiesgo,			PromotorInicial,		PromotorActual,			FechaAlta,
			Estatus,				NombreCompleto,			RFCOficial,				CorpRelacionado,		FechaBaja,
			ActividadFR,			ActividadFOMURID,		EsMenorEdad,			CalificaCredito,		RegistroHacienda,
			Observaciones,			NoEmpleado,				TipoEmpleado,			ExtTelefonoPart,		ExtTelefonoTrab,
			EjecutivoCap,			PromotorExtInv ,		TipoPuesto,				FechaIniTrabajo,		UbicaNegocioID,
			FechaConstitucion,		FEA,					PaisFEA,				PaisConstitucionID,		CorreoAlterPM,
			NombreNotario,			NumNotario,				InscripcionReg,			EscrituraPubPM,			SoloNombres,
			SoloApellidos,			DomicilioTrabajo,		PaisNacionalidad,		RazonSocialPLD,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)
		VALUES (
			NumeroCliente,			Par_EmpresaID,			Par_SucursalOri,		Par_TipoPersona,		Par_Titulo,
			Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,		Par_ApellidoMat,
			Par_FechaNac,			Par_CURP,				Var_Nacionalidad,		Par_PaisResi,			Par_GrupoEmp,
			Par_RazonSocial,		Par_TipoSocID,			Par_Fax,				Par_Correo,				Par_RFC,
			Par_RFCpm,				Par_SecGeneral,			Par_ActBancoMX,			Par_ActINEGI,			Par_SecEconomic,
			Par_Sexo,				Par_EstadoCivil,		Par_LugarNac,			Par_estadoID,			Par_OcupacionID,
			Par_LugardeTrab,		Par_Puesto,				Par_TelTrabajo,			Par_AntTra,				Par_TelefonoCel,
			Par_Telefono,			Par_Clasific,			Par_MotivoApert,		Par_PagaISR,			Par_PagaIVA,
			Par_PagaIDE,			Par_NivelRiesgo,		Par_PromotorIni,		Par_PromotorActual,		Fecha_Alta,
			Estatus_Activo,			NombreComplet,			Var_RFCOficial,			Par_CorpRelacionado,	Fecha_Vacia,
			Par_ActFR,				Par_ActFOMUR,			Par_EsMenorEdad,		Calificacion,			Par_RegistroHacienda,
			Par_Observaciones,		Par_NoEmpleado,			Par_TipoEmpleado,		Par_ExtTelefonoPart,	Par_ExtTelefonoTrab,
			Par_EjecutivoCap,		Par_PromotorExtInv,		Par_TipoPuesto,			Par_FechaIniTrabajo,	Par_UbicaNegocioID,
			Par_FechaCons,			Par_FEA,				Par_PaisFEA,			Par_PaisConstitucionID,	Par_CorreoAlterPM,
			Par_NombreNotario,		Par_NumNotario,			Par_InscripcionReg,		Par_EscrituraPubPM,		Var_SoloNombres,
			Var_SoloApellidos,		Par_DomicilioTrabajo,	Par_PaisNacionalidad,	Var_RazonSocialPLD,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
		/*
		****************************************************************
		*  Se inserta en la tabla de control de creditos por cliente
		****************************************************************
		*/
		INSERT INTO CREDITOSCLIENTES (
			ClienteID,		NumeroCreditos,		FechaUltCre,		EmpresaID,		Usuario,
			FechaActual, 	DireccionIP, 		ProgramaID, 		Sucursal, 		NumTransaccion)

			VALUES (
			NumeroCliente,	Entero_Cero,		Fecha_vacia,		Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion
		);

		IF(IFNULL(Par_ProspectoID, Entero_Cero)) <> Entero_Cero THEN
			SELECT  TipoDireccionID,	EstadoID,   		MunicipioID,  	Calle,      	NumExterior,
					NumInterior,    	Colonia,      		CP,       		Latitud,    	Longitud,
					Manzana,     		LocalidadID,   		ColoniaID,		Lote, 			PaisID
			INTO  	varTipoDirecID,   	varEstadoID,    	varMunicipioID,	varCalle,		varNumeroExt,
					varNumInterior,   	varColonia,     	varCP,      	varLatitud,		varLongitud,
					varManzana,			Var_LocalidadID,	Var_ColoniaID,	Var_Lote,		Var_PaisIDDom
				FROM PROSPECTOS
					WHERE ProspectoID = Par_ProspectoID;

			IF(IFNULL(Var_PaisIDDom, Entero_Cero) = Entero_Cero) THEN
				SET Var_PaisIDDom := Var_PaisDef;
			END IF;
			-- Se arma la direccion completa cuando este es extranjero
			SET DirecCompleta := Cadena_Vacia;
			IF(Par_Nacion = nacionalidadExt)THEN
				SET DirecCompleta := varCalle;
				IF(varNumeroExt != Cadena_Vacia) THEN
					SET DirecCompleta := CONCAT(DirecCompleta,", No. ",varNumeroExt);
				END IF;

				IF(varNumInterior != Cadena_Vacia) THEN
					SET DirecCompleta := CONCAT(DirecCompleta,", INTERIOR ",varNumInterior);
				END IF;

				IF(Var_Lote != Cadena_Vacia) THEN
					SET DirecCompleta := CONCAT(DirecCompleta,", LOTE ",Var_Lote);
				END IF;

				IF(varManzana != Cadena_Vacia) THEN
					SET DirecCompleta := CONCAT(DirecCompleta,", MANZANA ",varManzana);
				END IF;

				SET DirecCompleta := UPPER(CONCAT(DirecCompleta,", C.P ",varCP,"."));
			END IF;

			CALL DIRECCLIENTEALT(
				NumeroCliente,    	varTipoDirecID,   	varEstadoID,    	varMunicipioID,   	Var_LocalidadID,
				Var_ColoniaID,    	varColonia,     	varCalle,     		varNumeroExt,   	varNumInterior,
				Cadena_Vacia,   	Cadena_Vacia,   	Cadena_Vacia,   	varCP,        		Cadena_Vacia,
				varLatitud,     	varLongitud,    	varOficial,     	varFiscal,      	Par_EmpresaID,
				Cadena_Vacia,   	varManzana,     	DirecCompleta,		Var_PaisIDDom,		Var_AniosRes,
				Salida_NO,      	Par_NumErr,			Par_ErrMen,			Aud_Usuario,    	Aud_FechaActual,
				Aud_DireccionIP,  	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL PROSPECTOSACT(
				Par_ProspectoID,  	NumeroCliente,    	numActCliente,      Salida_NO,      	Par_NumErr,
				Par_ErrMen,     	Par_EmpresaID,    	Aud_Usuario,      	Aud_FechaActual,  	Aud_DireccionIP,
				Aud_ProgramaID,   	Aud_Sucursal,   	Aud_NumTransaccion);

			IF (Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT * FROM SOLICITUDCREDITO
				WHERE ProspectoID=Par_ProspectoID) THEN
					UPDATE SOLICITUDCREDITO SET PromotorID=Par_PromotorActual  WHERE ProspectoID=Par_ProspectoID;
			END IF;

		END IF;

		UPDATE SOCIODEMOGRAL SET
			AntiguedadLab 	= (Par_AntTra * 12),
			FechaIniTrabajo = Par_FechaIniTrabajo,

			EmpresaID   	= Par_EmpresaID,
			Usuario     	= Aud_Usuario,
			FechaActual   	= Aud_FechaActual,
			DireccionIP   	= Aud_DireccionIP,
			ProgramaID    	= Aud_ProgramaID,
			Sucursal    	= Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

		WHERE ClienteID    = NumeroCliente;


		SELECT IFNULL(ChecListCte,"N") INTO Var_ChecListCte
			FROM PARAMETROSSIS;

		IF (Var_ChecListCte="S" AND Par_EsMenorEdad="N") THEN
			CALL CHECLISTALT(
				NumeroCliente,  TipoInstrumento,  	Par_TipoPersona,  	RequeridoEn,
				Salida_NO,    	Par_NumErr,     	Par_ErrMen,     	Par_EmpresaID,
				Aud_Usuario,    Aud_FechaActual,  	Aud_DireccionIP,  	Aud_ProgramaID,
				Aud_Sucursal,   Aud_NumTransaccion);

			IF (Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_NegocioAfiliadoID != Entero_Cero) THEN
			CALL NEGOCIOAFILIADOACT(
				Par_NegocioAfiliadoID,  NumeroCliente,  Act_ClienteNA,  Salida_NO,      Par_NumErr,
				Par_ErrMen,       		Par_EmpresaID,  Aud_Usuario,  	Aud_FechaActual,
				Aud_DireccionIP,    	Aud_ProgramaID, Aud_Sucursal, 	Aud_NumTransaccion);

			IF (Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_InstitNominaID != Entero_Cero) THEN
			CALL INSTITNOMINAACT(
				Par_InstitNominaID, NumeroCliente,  Act_ClienteEN,    Salida_NO,      Par_NumErr,
				Par_ErrMen,     	Par_EmpresaID,  Aud_Usuario,      Aud_FechaActual,
				Aud_DireccionIP,  	Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);

			IF (Par_NumErr!=Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		CALL CLIENTEEXPEDIENTEALT(
			NumeroCliente,    	Salida_NO,    		Par_NumErr,     	Par_ErrMen,       Par_EmpresaID,
			Aud_Usuario,    	Aud_FechaActual,	Aud_DireccionIP,  	Aud_ProgramaID,   Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr!=Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		/*Se calcula el Nivel de Riesgo del Nuevo Cliente ################################################################################# */
		IF( CliProEsp <> CliCrediClub) THEN
			CALL RIESGOPLDCTEPRO(
				NumeroCliente,      Salida_NO,        	Par_NumErr,       	Par_ErrMen,   Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

			IF(Par_NumErr!=Entero_Cero)THEN
			  LEAVE ManejoErrores;
			END IF;
		END IF;
		/*FIN de Calculo de Nivel de Riesgo del Nuevo Cliente ############################################################################# */

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alt_Clientes,		NumeroCliente,				Entero_Cero,			Entero_Cero,
			Entero_Cero,				Salida_NO,			Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */

		# BÚSQUEDA DEL NUEVO CLIENTE EN LISTAS NEGRAS.
		CALL PLDDETECCIONPRO(
			NumeroCliente,			Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
			Par_ApellidoMat,		Par_TipoPersona,		Par_RazonSocial,		Par_RFC,				Par_RFCpm,
			Par_FechaNac,			Entero_Cero,			Par_LugarNac,			Par_EstadoID,			NombreComplet,
			Es_Cliente,				Var_RealizaBusqPLD,		Salida_NO,				Salida_NO,				Salida_NO,
			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr  	:= 0;
		SET Par_ErrMen  	:= CONCAT("safilocale.cliente Agregado Exitosamente: ", CONVERT(NumeroCliente, CHAR));
		SET Var_Control 	:= 'numero';
		SET Var_Consecutivo := LPAD(NumeroCliente, 10, 0);

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo,
				Var_CampoGenerico AS CampoGenerico;
	END IF;

	IF(Par_Salida = Salida_NO) THEN
			SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
			SET Par_ErrMen := Par_ErrMen;
			SET Par_ClienteID := LPAD(NumeroCliente, 10, 0);
	END IF;
END TerminaStore$$

