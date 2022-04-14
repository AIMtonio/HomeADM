
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESMOD`;
DELIMITER $$


CREATE PROCEDURE `CLIENTESMOD`(
/* ========== SP PARA MODIFICACION DE CLIENTES ============== */
	Par_ClienteID           INT(11),          -- ID del Cliente
	Par_SucursalOri         INT(11),          -- Sucursal de Origen del cliente
	Par_TipoPersona         CHAR(1),          -- Tipo de persona
	Par_Titulo              VARCHAR(10),      -- Titulo de la persona SR. SRA. SRITA.
	Par_PrimerNom           VARCHAR(50),      -- Primer nombre del cliente

	Par_SegundoNom          VARCHAR(50),      -- Segundo nombre del cliente
	Par_TercerNom           VARCHAR(50),      -- Tercer nombre del cliente
	Par_ApellidoPat         VARCHAR(50),      -- Apellido paterno del cliente
	Par_ApellidoMat         VARCHAR(50),      -- Apellido materno del cliente
	Par_FechaNac            DATE,             -- Fecha de nacimiento de cliente

	Par_LugarNac            INT(11),          -- Pais de nacimiento
	Par_EstadoID            INT(11),          -- Estado del cliente
	Par_Nacion              CHAR(1),          -- Tipo de Nacionalidad
	Par_PaisResi            INT(11),          -- Pais de residencia del cliente
	Par_Sexo                CHAR(1),          -- Sexo del cliente

	Par_CURP                CHAR(18),         -- CURP del cliente
	Par_RFC                 CHAR(13),         -- RFC del Cliente
	Par_EstadoCivil         CHAR(2),          -- Estado civil del cliente
	Par_TelefonoCel         VARCHAR(20),      -- Telefono celular del cliente
	Par_Telefono            VARCHAR(20),      -- Telefono fijo del cliente

	Par_Correo              VARCHAR(50),      -- Correo electronico del cliente
	Par_RazonSocial         VARCHAR(150),     -- Razon social del cliente
	Par_TipoSocID           INT(11),          -- Tipo de sociedad
	Par_RFCpm               CHAR(13),         -- RFC de Persona Moral
	Par_GrupoEmp            INT(11),          -- Grupo

	Par_Fax                 VARCHAR(30),      -- Fax de contacto del cliente
	Par_OcupacionID         INT(11),          -- Ocupacion ID del cliente
	Par_Puesto              VARCHAR(100),     -- Puesto que ocupa el cliente
	Par_LugardeTrab         VARCHAR(100),     -- Nombre de la empresa en la que trabaja el cliente
	Par_AntTra              FLOAT,            -- Fecha y mes de antiguedad de trabajo del cliente
	Par_DomicilioTrabajo	VARCHAR(500),	  -- Domicilio de trabajo del cliente

	Par_TelTrabajo          VARCHAR(20),      -- Telefono de contacto de cliente
	Par_Clasific            CHAR(1),          -- Clasificacion
	Par_MotivoApert         CHAR(1),          -- Motivo de apertura de cuenta
	Par_PagaISR             CHAR(1),          -- Paga ISR S: Si N: No
	Par_PagaIVA             CHAR(1),          -- Paga IVA S: Si N: No

	Par_PagaIDE             CHAR(1),          -- Especifica si Cobra Impuesto de Depositos En Efectivo N=No S= Si
	Par_NivelRiesgo         CHAR(1),          -- Nivel de riesgo
	Par_SecGeneral          INT(11),          -- ID del sector general
	Par_ActBancoMX          VARCHAR(15),      -- Actividad BMX de ACTIVIDADESBMX
	Par_ActINEGI            INT(11),          -- Clave de la actividad economiva segun INEGI

	Par_ActFR               BIGINT,           -- Actividad Principal del Cte, segun la ACTIVIDADESFR
	Par_ActFOMUR            INT(11),          -- Actividad Fomur del Cte, segun la ACTIVIDADESFOMUR
	Par_SecEconomic         INT(11),          -- Sector economico al que pertenece el cliente
	Par_PromotorIni         INT(11),          -- ID del promotor inicial
	Par_PromotorAct         INT(11),          -- ID del promotor actual

	Par_EsMenorEdad         CHAR(1),          -- El cliente es menor de edad S: SI, N: NO
	Par_CorpRelacionado     INT(11),          -- Es el dato de corporativo relacionado a el cliente
	Par_RegistroHacienda    CHAR(1),          -- Esta registrado en hacienda
	Par_NegocioAfiliadoID   INT(11),          -- ID del negocio afiliado
	Par_InstitNominaID      INT(11),          -- ID de la nomina afiliado

	Par_Observaciones       VARCHAR(500),     -- Observaciones
	Par_NoEmpleado          VARCHAR(20),      -- ID del empleado que dio de alta
	Par_TipoEmpleado        VARCHAR(1),       -- Tipo de empleado que dio la alta
	Par_ExtTelefonoPart     VARCHAR(7),       -- Extension del telefono particular
	Par_ExtTelefonoTrab     VARCHAR(7),       -- Extension del telefono del trabajo

	Par_EjecutivoCap        INT(11),          -- Ejecutivo de captacion 0 No Asignado
	Par_PromotorExtInv      INT(11),          -- Promotor Extreno de inversion 0 No Asignado
	Par_TipoPuesto          INT(11),          -- Tipo de Puesto de Empleados Nomina
	Par_FechaIniTrabajo     DATE,             -- Fecha de inicio en el trabajo actual
	Par_UbicaNegocioID      INT(11),          -- ID de la ubicacion del negocio, relacion con CATUBICANEGOCIO

	Par_FEA                 VARCHAR(250),     -- Numero de Firma Electronica Avanzada
	Par_PaisFEA             INT(11),          -- Pasi que asigna la FEA
	Par_FechaCons           DATE,             -- Fecha de Cosntitucion
	Par_PaisConstitucionID  INT(11),          -- Pais de constitucion campo para Personas Morales
	Par_CorreoAlterPM       VARCHAR(50),      -- Correo alternativo para Persona Moral

	Par_NombreNotario       VARCHAR(150),     -- Nombre del notario campo para Persona Morales
	Par_NumNotario          INT(11),          -- Numero del notario campo para Personas Morales
	Par_InscripcionReg      VARCHAR(50),      -- Numero de inscripcion en el registro publico campo para Personas Morales
	Par_EscrituraPubPM      VARCHAR(20),      -- Escritura Publica Persona Moral
	Par_PaisNacionalidad	INT(11),		 -- PAis de nacionalidad del Cliente

	Par_Salida              CHAR(1),          -- Tipo salida
	INOUT Par_NumErr        INT(11),          -- Numero de error
	INOUT Par_ErrMen        VARCHAR(400),     -- Mensaje de error
	/* Parametros de Auditoria */
	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,
	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)

TerminaStore:BEGIN
	-- Declaracion de  Variables
	DECLARE NumeroEmpresa     INT;
	DECLARE NombreComplet     VARCHAR(200);
	DECLARE Var_PaisID        INT;
	DECLARE Valida_RFC        CHAR(13);
	DECLARE Var_RFCOficial    CHAR(13);
	DECLARE Var_ClienteID     INT;
	DECLARE Var_NumErr        INT(11);
	DECLARE Var_ErrMen        VARCHAR(350);
	DECLARE Var_InsNominaAnt  INT;
	DECLARE Var_InsNegAfiAnt  INT;
	DECLARE Var_ClasAnterior  CHAR(1);
	DECLARE Var_cuentaCNUno   BIGINT(12);

	DECLARE Var_Fecha_Actual  DATE;
	DECLARE Var_AnioAct       INT;
	DECLARE Var_MesAct        INT;
	DECLARE Var_DiaAct        INT;
	DECLARE Var_AnioNac       INT;
	DECLARE Var_MesNac        INT;
	DECLARE Var_DiaNac        INT;
	DECLARE Var_Anios         INT;

	DECLARE Var_TipoIdentiID  INT(11);
	DECLARE Var_NumIden       VARCHAR(20);
	DECLARE Var_FecExIden     DATE;
	DECLARE Var_FecVenIden    DATE;

	DECLARE Var_Domicilio     VARCHAR(200);
	DECLARE Var_ClieInstNom   INT(11);
	DECLARE Var_ClieNegAfi    INT(11);
	DECLARE Var_Estatus_Neg   CHAR(1);
	DECLARE Var_Estatus_Ins   CHAR(1);
	DECLARE Var_Estatus       CHAR(1);
	DECLARE Var_PEP           CHAR(1);
	DECLARE varEstadoID       INT(11);
	DECLARE Var_Control       VARCHAR(200);
	DECLARE Var_Consecutivo   INT(11);
	DECLARE Var_CampoGenerico INT(11);
	DECLARE Var_Nacionalidad  CHAR(1);
	DECLARE Var_DiaActChar    CHAR(3);
	DECLARE Var_SoloNombres		VARCHAR(500);
	DECLARE Var_SoloApellidos	VARCHAR(500);
	DECLARE Fecha_Alta			DATE;
	DECLARE Var_Fecha18		 	DATE;
    DECLARE Var_DetecNoDeseada	CHAR(1);		-- Valida la activacion del proceso de personas no deseadas
	DECLARE Var_RazonSocialPLD	VARCHAR(150);-- Razon social limpio de caracteres especiales.

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia      CHAR(1);
	DECLARE Fecha_Vacia       DATE;
	DECLARE Entero_Cero       INT;
	DECLARE Pais              INT;
	DECLARE Per_Fisica        CHAR(1);
	DECLARE Per_ActEmp        CHAR(1);
	DECLARE Per_Moral         CHAR(1);
	DECLARE Per_MenorEdad     CHAR(1);
	DECLARE MenorEdadNO       CHAR(1);
	DECLARE esCorpRelacionado CHAR(1);
	DECLARE esCorporativo     CHAR(1);
	DECLARE esTarjetaHabNUno  CHAR(1);
	DECLARE esEmpresaNomina   CHAR(1);
	DECLARE esNegocioAfilia   CHAR(1);
	DECLARE Con_Salida        CHAR(1);
	DECLARE Var_EsTitular     CHAR(1);
	DECLARE Var_EsFirmante    CHAR(1);
	DECLARE Cons_esOficial    CHAR(1);
	DECLARE Salida_NO         CHAR(1);
	DECLARE Act_ClienteNA     INT;
	DECLARE Act_ClienteEN     INT;
	DECLARE Moral             CHAR(1);
	DECLARE Baja              CHAR(1);
	DECLARE Inactivo          CHAR(1);
	DECLARE CURPCli           CHAR(18);
	DECLARE EmpNomina         CHAR(1);
	DECLARE nacionalidadMex   CHAR(1);
	DECLARE nacionalidadExt   CHAR(1);
	DECLARE PEP_Si            CHAR(1);
	DECLARE PEP_No            CHAR(1);
	DECLARE NivelRiesgoAlto   CHAR(1);
	DECLARE ReportarSi        CHAR(1);
	DECLARE ReportarNo        CHAR(1);
	DECLARE Str_SI            CHAR(1);
	DECLARE Str_NO            CHAR(1);
	DECLARE EsCliente         VARCHAR(3);
	DECLARE IDPaisNoEsp       INT(11);
	DECLARE Tip_ConCliPM		CHAR(1);
	DECLARE Mayusculas			CHAR(2);
	DECLARE EsMenor				CHAR(1);
	DECLARE Alt_Clientes		INT(11);				# Alta de Clientes BITACORA HISTORICA DE ACTUALIZACIONES
	DECLARE RFC_Generico		VARCHAR(15);
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
	DECLARE Var_FechaNac 		DATE;
	DECLARE Var_BusqActivaPLD		CHAR(1);	-- Indica si esta activa la busqueda desde java.
	DECLARE Var_RealizaBusqPLD		CHAR(1);	-- Indica si realiza la busqueda en listas PLD.

 -- JQUINTAL
	DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
	DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
	DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES

-- MMARTINEZ  MEXI
    DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
    DECLARE Var_RolA                INT(11);
    DECLARE Var_RolUsuario          INT(11);

	-- Asigancion de Constantes
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET Entero_Cero         := 0;
	SET Pais                := 700;
	SET Per_Fisica          := 'F';
	SET Per_ActEmp          := 'A';
	SET Per_Moral           := 'M';
	SET Per_MenorEdad       := 'E';
	SET MenorEdadNO         := 'N';
	SET esCorpRelacionado   := 'R';   -- Clasificacion del Cliente: Relacionado a Corporativo
	SET esCorporativo       := 'C';   -- Clasificacion del Cliente: Corporativo
	SET esTarjetaHabNUno    := 'L';   -- Clasificacion del Cliente: TarjetaHabiente Nivel Uno
	SET esEmpresaNomina     := 'N';   -- Clasificacion del Cliente: Empresa de Nomina
	SET esNegocioAfilia     := 'F';   -- Clasificacion del Cliente: Negocio Afiliado
	SET Con_Salida          := 'N';   -- Para consulta de Validaciones si el cliente viende de ser tarjetahabiente nivel 1
	SET Var_EsTitular       := 'S';
	SET Var_EsFirmante      := 'S';
	SET Cons_esOficial      := 'S';
	SET Salida_NO           := 'N';   -- El Store no Regresa ningun Resultado
	SET Act_ClienteNA       := 2;     -- Tipo de Actualizacion en Negocio Afiliado: No de Cliente
	SET Act_ClienteEN       := 2;     -- Tipo de Actualizacion en Empresa de Nomina: No de Cliente
	SET Moral               :='M';
	SET Inactivo            :='I';    -- Estatus incativo de socio
	SET EmpNomina           :='M';    -- Si la ClasificaciÃ³n es Empleado de NÃ³mina
	SET PEP_Si              := 'S';   -- Si es PEP
	SET PEP_No              := 'N';   -- No es PEP
	SET NivelRiesgoAlto     := 'A';   -- Nivel de Riesgo del Cliente ALTO
	SET ReportarSi          :='S';    -- Si reportar como 24 hrs
	SET ReportarNo          :='N';    -- No reportar como 24 hrs
	SET Str_SI              :='S';    -- Constante SI
	SET Str_NO              :='N';    -- Constante NO
	SET EsCliente           := 'CTE'; -- Se trata de un cliente
	SET EsMenor 			:='S';
	SET Fecha_Alta 			:= (SELECT FechaSistema  FROM PARAMETROSSIS WHERE EmpresaID=1);
	SET Var_Fecha18 := DATE_SUB(Fecha_Alta,INTERVAL 18 YEAR);

	SET NumeroEmpresa         := 1;
	SET NombreComplet         := Cadena_Vacia;
	SET Var_PaisID            := 0;
	SET Par_PrimerNom         := TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
	SET Par_SegundoNom        := TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
	SET Par_TercerNom         := TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
	SET Par_ApellidoPat       := TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
	SET Par_ApellidoMat       := TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));
	SET Par_NegocioAfiliadoID := IFNULL(Par_NegocioAfiliadoID, Entero_Cero);
	SET Par_InstitNominaID    := IFNULL(Par_InstitNominaID, Entero_Cero);
	SET Baja                  :="B";
	SET nacionalidadMex       :='N';
	SET nacionalidadExt       :='E';
	SET Par_FechaCons         := IFNULL(Par_FechaCons,Fecha_Vacia);
	SET Var_CampoGenerico     := 0;
	SET IDPaisNoEsp           := 999;       -- Pais no Especificado en la tabla Paises
	SET Tip_ConCliPM          := '2';       -- Tipo de consulta de Caracteres Validos para persona Moral
	SET Mayusculas			  := 'MA';	   -- Obtener el resultado en Mayusculas
	SET Alt_Clientes			:= 1;					# Alta de Clientes BITACORA HISTORICA DE ACTUALIZACIONES
	SET Par_PagaIDE			  := 'S';	-- Todos los Clientes tienen IDE
	SET RFC_Generico		  := 'XEXX010101000';
	SET Cliente_Vigua_Serv_Pat	:=38;
    SET Var_ParamCli			:='CliProcEspecifico';

    -- MMARTINEZ  MEXI
    SET Var_RolPerf             :='RolActPerfil';
    SET DescripOpera			:='LISTA DE PERSONAS BLOQUEADAS';	-- Comentario en operaciones de alta o modificacion de clientes
	SET CatMotivInusualID		:='LISBLOQ';		-- Clave interna motivo Tabla catalogo PLDCATMOTIVINU: LISTAS PERSONAS BLOQUEADAS
	SET CatProcIntID			:='PR-SIS-000';		-- Clave interna
	SET RegistraSAFI			:= 'SAFI';			-- Clave que registra la operacion
	SET ClaveRegistra			:= '3';				-- Clave del tipo de persona que detecta la operacion  (1.-personal interno  2.-personal externo  3.-sistema automatico)
	SET Var_FechaDeteccion		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Con_LPB					:= 'LPB';			-- Inidica que es de lista de personas bloqueadas



	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CLIENTESMOD');
			SET Var_Control := 'sqlException';
		END;

		SET Par_TelefonoCel		  := IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelefonoCel, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
		SET Par_Telefono		  := IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_Telefono," ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
		SET Par_TelTrabajo		  := IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelTrabajo," ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);


		IF Par_EsMenorEdad =Cadena_Vacia THEN
			SET Par_EsMenorEdad=MenorEdadNO;
		END IF;

		SELECT Estatus INTO Var_Estatus
			FROM CLIENTES
			WHERE ClienteID=Par_ClienteID;

		IF(Var_Estatus=Inactivo)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El safilocale.cliente se Encuentra Inactivo.';
			SET Var_Control := 'numero';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        -- JQuintal NARRATIVA 0010 MEXI
        SELECT ValorParametro
			INTO Var_CliEsp
			FROM PARAMGENERALES
				WHERE LlaveParametro = Var_ParamCli;
        SELECT ValorParametro
			INTO Var_RolA
			FROM PARAMGENERALES
				WHERE LlaveParametro = Var_RolPerf;

        SELECT RolID INTO Var_RolUsuario FROM USUARIOS WHERE  UsuarioID = Aud_Usuario;

			SET Var_CliEsp:=IFNULL(Var_CliEsp,Entero_Cero);

            SET Var_RolUsuario:=IFNULL(Var_RolUsuario,Entero_Cero);

			IF (Var_CliEsp=Cliente_Vigua_Serv_Pat) THEN

			   IF(Var_RolA != Var_RolUsuario)THEN

                    CALL VALIDADATOSCTEVAL(
                            Par_ClienteID,			Str_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
                            Aud_Usuario ,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                            Aud_NumTransaccion);

                            IF( Par_NumErr<>Entero_Cero) THEN
                                SET Par_NumErr  := Par_NumErr;
                                SET Par_ErrMen  := Par_ErrMen;
                                SET Var_Control := 'clienteID ';
                                SET Var_Consecutivo := Entero_Cero;
                                LEAVE ManejoErrores;
                            END IF;
                    END IF;
			END IF;




		IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
			IF (Par_RFC = Cadena_Vacia)THEN
				SET Valida_RFC:=Cadena_Vacia;
			ELSE
				SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFC AND ClienteID <> Par_ClienteID AND RFCOficial != RFC_Generico LIMIT 1);
				IF (Valida_RFC = Par_RFC)THEN
					SET Par_NumErr  := 1;
					SET Par_ErrMen  := 'RFC Asociado con otro safilocale.cliente';
					SET Var_Control := 'RFC ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SET CURPCli:= (SELECT CURP FROM CLIENTES WHERE ClienteID=Par_ClienteID);

		IF (Par_CURP  != CURPCli )THEN
			IF EXISTS(SELECT *FROM CLIENTES WHERE CURP=Par_CURP AND EsMenorEdad='N' AND TipoPersona <> 'M')THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'CURP Asociada a otro safilocale.cliente';
				SET Var_Control := 'CURP ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT *FROM CLIENTES WHERE CURP=Par_CURP AND EsMenorEdad='S' AND Estatus ='A')THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  :='CURP Asociada a otro safilocale.cliente';
				SET Var_Control := 'CURP ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT ClienteID, Clasificacion INTO Var_ClienteID, Var_ClasAnterior
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		SET Var_ClienteID  		:= IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_ClasAnterior    := IFNULL(Var_ClasAnterior, Cadena_Vacia);

		IF(Var_ClienteID = Entero_Cero) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Numero de Cliente no existe.';
			SET Var_Control := 'numero ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF ((Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) AND (Par_EsMenorEdad = MenorEdadNO ) ) THEN
			IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'El RFC esta Vacio.';
				SET Var_Control := 'RFC ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_SucursalOri, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 6;
			SET Par_ErrMen  := 'La sucursal esta Vacia.';
			SET Var_Control := 'sucursalOrigen ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;
		-- validacion personas fisicas o fisicas con actividad empresarial
		IF(Par_TipoPersona <> Per_Moral) THEN
			IF(IFNULL(Par_Titulo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 7;
				SET Par_ErrMen  :='El Titulo esta Vacio.';
				SET Var_Control := 'titulo ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 8;
				SET Par_ErrMen  :='El Primer Nombre esta Vacio.';
				SET Var_Control := 'primerNombre ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND
					IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'Se requiere al menos uno de los Apellidos.';
				SET Var_Control := 'apellidoParterno';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_LugarNac = Pais) THEN
				IF(IFNULL(Par_EstadoID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr  := 11;
					SET Par_ErrMen  :='El Estado esta Vacio.';
					SET Var_Control := 'estadoID ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_PaisResi, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 13;
				SET Par_ErrMen  :='El pais de Residencia esta Vacio.';
				SET Var_Control := 'paisResidencia ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 14;
				SET Par_ErrMen  :='El Sexo esta Vacio.';
				SET Var_Control := 'sexo ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CURP, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 15;
				SET Par_ErrMen  :='La CURP esta Vacia.';
				SET Var_Control := 'CURP ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_LugarNac, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 32;
				SET Par_ErrMen  :='El pais de Lugar de nacimiento esta Vacio.';
				SET Var_Control := 'lugarNac ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_LugarNac, Entero_Cero))<> Entero_Cero THEN
				SELECT PaisID INTO Var_PaisID FROM PAISES WHERE PaisID = Par_LugarNac;
				IF(IFNULL(Var_PaisID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr  := 33;
					SET Par_ErrMen  := 'El pais especificado como el Lugar de Nacimiento no existe.';
					SET Var_Control := 'lugarNac ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_FechaNac, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 44;
				SET Par_ErrMen  := 'Se Requiere la Fecha de Nacimiento';
				SET Var_Control := 'fechaNacimiento ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			ELSE
				SET Var_Fecha_Actual  := (SELECT FechaSistema FROM PARAMETROSSIS  WHERE EmpresaID=1);
				SET Var_AnioAct       := YEAR(Var_Fecha_Actual);
				SET Var_MesAct        := MONTH(Var_Fecha_Actual);
				SET Var_DiaAct        := DAY(Var_Fecha_Actual);
				SET Var_AnioNac       := YEAR(Par_FechaNac);
				SET Var_MesNac        := MONTH(Par_FechaNac);
				SET Var_DiaNac        :=  DAY(Par_FechaNac);
				SET Var_Anios         := Var_AnioAct-Var_AnioNac;

				IF(Var_MesAct<Var_MesNac) THEN
					SET Var_Anios := Var_Anios-1;
				END IF;

				IF(Var_MesAct = Var_MesNac)THEN
					IF(Var_DiaAct<Var_DiaNac) THEN
						SET Var_Anios := Var_Anios-1;
					END IF;
				END IF;

				IF (Par_EsMenorEdad =MenorEdadNO && Par_TipoPersona != Moral) THEN
					IF (Var_Anios <18) THEN
						SET Par_NumErr  := 45;
						SET Par_ErrMen  :='El safilocale.cliente es Menor de Edad, Registrarlo en la Pantalla Correspondiente';
						SET Var_Control := 'fechaNacimiento ';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				ELSE
					IF (Var_Anios >=18) THEN
						SET Par_NumErr  := 45;
						SET Par_ErrMen  :='El safilocale.cliente es Mayor de Edad, Registrarlo en la Pantalla Correspondiente';
						SET Var_Control := 'fechaNacimiento ';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF((IFNULL(Par_Telefono,Cadena_Vacia)=Cadena_Vacia) AND (IFNULL(Par_Correo,Cadena_Vacia)=Cadena_Vacia))THEN
				IF(IFNULL(Par_TelefonoCel,Cadena_Vacia)=Cadena_Vacia)THEN
					SET Par_NumErr  := 46;
					SET Par_ErrMen  :='El Telefono Celular es requerido.';
					SET Var_Control := 'telefonoCelular ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF((IFNULL(Par_TelefonoCel,Cadena_Vacia)=Cadena_Vacia) AND (IFNULL(Par_Correo,Cadena_Vacia)=Cadena_Vacia))THEN
					IF(IFNULL(Par_Telefono,Cadena_Vacia)=Cadena_Vacia)THEN
						SET Par_NumErr  := 47;
						SET Par_ErrMen  :='El Telefono es requerido.';
						SET Var_Control := 'telefonoCasa ';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				ELSE
					IF((IFNULL(Par_Telefono,Cadena_Vacia)=Cadena_Vacia) AND (IFNULL(Par_TelefonoCel,Cadena_Vacia)=Cadena_Vacia))THEN
						IF(IFNULL(Par_Correo,Cadena_Vacia)=Cadena_Vacia)THEN
							SET Par_NumErr  := 48;
							SET Par_ErrMen  :='El Correo Electronico es requerido.';
							SET Var_Control := 'correo ';
							SET Var_Consecutivo := Entero_Cero;
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;
			END IF;
		ELSE
			-- Si es una persona moral el Campo Lugar de Nacimiento y Pais de Residencia debe llevar el id de pais no especificado
			SET Par_PaisResi = Par_PaisConstitucionID;
			SET Par_LugarNac = IDPaisNoEsp;

			IF(SELECT FNCLIENTESCARACTERESESP(Par_RazonSocial,Tip_ConCliPM)!= Entero_Cero )THEN
				SET Par_NumErr  := 049;
				SET Par_ErrMen  := CONCAT('Ingreso un Caracter Invalido - ', Par_RazonSocial);
				SET Var_Control := 'razonSocial';
				LEAVE   ManejoErrores;
			END IF;
		END IF;-- fin validaciones persona Fisicas y PFAE

		IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 12;
			SET Par_ErrMen  :='La Nacionalidad esta Vacia.';
			SET Var_Control := 'nacion ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		ELSE
			SET Var_Nacionalidad := Par_Nacion;
		END IF;

		IF(IFNULL(Par_RegistroHacienda, cadena_vacia)=cadena_vacia) THEN
			SET Par_NumErr  := 28;
			SET Par_ErrMen  := 'El campo Registro de Alta en Hacienda esta vacio.';
			SET Var_Control := 'RegistroHacienda ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Clasific, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 21;
			SET Par_ErrMen  :='La Clasificacion esta Vacia.';
			SET Var_Control := 'clasificacion ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MotivoApert, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 22;
			SET Par_ErrMen  :='EL motivo de Apertura esta Vacio.';
			SET Var_Control := 'motivoApertura ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PagaISR, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 23;
			SET Par_ErrMen  :='El ISR esta Vacio.';
			SET Var_Control := 'pagaISR ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PagaIVA, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 24;
			SET Par_ErrMen  :='El IVA esta Vacio.';
			SET Var_Control := 'pagaIVA ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PagaIDE, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 25;
			SET Par_ErrMen  :='El IDE esta Vacio.';
			SET Var_Control := 'pagaIDE ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NivelRiesgo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 26;
			SET Par_ErrMen  :='El Nivel de Riesgo esta Vacio.';
			SET Var_Control := 'nivelRiesgo ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_GrupoEmp    := IFNULL(Par_GrupoEmp, Entero_Cero);
		SET Par_OcupacionID := IFNULL(Par_OcupacionID, Entero_Cero);

		IF(IFNULL(Par_SecGeneral, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 27;
			SET Par_ErrMen  :='El sector General esta Vacio.';
			SET Var_Control := 'sectorGeneral ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActBancoMX, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 28;
			SET Par_ErrMen  :='La Actividad esta Vacia.';
			SET Var_Control := 'actividadBancoMX ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PromotorIni, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 29;
			SET Par_ErrMen  := 'El Promotor Inicial esta Vacio.';
			SET Var_Control := 'promotorInicial ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PromotorAct, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 30;
			SET Par_ErrMen  :='El Promotor Actual esta Vacio.';
			SET Var_Control := 'promotorActual ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActFR, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 31;
			SET Par_ErrMen  :='La Actividad FR esta Vacia.';
			SET Var_Control := 'actividadFRID ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ActFOMUR, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 31;
			SET Par_ErrMen  :='La Actividad FOMUR esta Vacia.';
			SET Var_Control := 'actividadFOMURID ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF  Par_Clasific = esCorpRelacionado THEN
			IF  (IFNULL(Par_CorpRelacionado, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 34;
				SET Par_ErrMen  :='El Corporativo Relacionado al Cliente esta vacio.';
				SET Var_Control := 'CorporativoRelacionado ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF  Par_Clasific = esCorporativo THEN
			IF  Par_TipoPersona != Per_Moral THEN
				SET Par_NumErr  := 35;
				SET Par_ErrMen  :='El Corporativo debe ser una Persona Moral.';
				SET Var_Control := 'CorporativoMoral ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_Clasific = esEmpresaNomina) THEN
			SELECT Estatus INTO Var_Estatus_Ins
				FROM INSTITNOMINA
				WHERE InstitNominaID = Par_InstitNominaID;
			IF NOT EXISTS(SELECT InstitNominaID FROM INSTITNOMINA WHERE InstitNominaID = Par_InstitNominaID ) THEN
				SET Par_NumErr  := 40;
				SET Par_ErrMen  :='La Institucion de Nomina no Existe';
				SET Var_Control := 'institNominaID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF (Var_Estatus_Ins=Baja)THEN
				SET Par_NumErr  := 40;
				SET Par_ErrMen  :=CONCAT('La Institucion de Nomina se Encuentra Cancelada: ',CONVERT(Par_InstitNominaID,CHAR));
				SET Var_Control := 'institNominaID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_Clasific = esEmpresaNomina) THEN
			IF(Par_TipoPersona!=Moral)THEN
				SET Par_NumErr  := 42;
				SET Par_ErrMen  :='Para ser Corporativo Nomina se requiere una Persona Moral';
				SET Var_Control := 'tipoPersona2 ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Validacion de Clasificiacion de Empresa de Nomina
		-- Validacion de TipoPuesto
		IF (Par_Clasific = EmpNomina) THEN
			IF (Par_TipoPuesto = Entero_Cero) THEN
				SET Par_NumErr  := 43;
				SET Par_ErrMen  :='El Tipo de Puesto esta Vacio.';
				SET Var_Control := 'tipoPuestoID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS(SELECT TipoPuestoID FROM TIPOSPUESTOS WHERE TipoPuestoID = Par_TipoPuesto) THEN
				SET Par_NumErr  := 43;
				SET Par_ErrMen  :='El Tipo de Puesto no Existe.';
				SET Var_Control := 'tipoPuestoID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_PromotorExtInv, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 17;
			SET Par_ErrMen  :='El Promotor Externo de Inversion.';
			SET Var_Control := 'promotorExtInv ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EjecutivoCap, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr  := 17;
			SET Par_ErrMen  :='El Ejecutivo de Captacion esta vacio.';
			SET Var_Control := 'ejecutivoCap ';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoPersona=Per_Fisica OR Par_TipoPersona= Per_ActEmp OR Par_TipoPersona= Per_MenorEdad) THEN
			SET NombreComplet		:= FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
			SET Var_RFCOficial		:= Par_RFC;
			SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Cadena_Vacia,Cadena_Vacia),Mayusculas),500);
			SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia,Cadena_Vacia,Par_ApellidoPat,Par_ApellidoMat),Mayusculas),500);
			SET Var_RazonSocialPLD	:= Cadena_Vacia;
		END IF;

		-- Validacion campos para Persona Moral
		IF(Par_TipoPersona = Per_Moral) THEN
				SET Par_EsMenorEdad= MenorEdadNO;
			IF(IFNULL(Par_RazonSocial, Cadena_Vacia))= Cadena_Vacia THEN
				SET Par_NumErr  := 20;
				SET Par_ErrMen  := 'La razon Social esta Vacia.';
				SET Var_Control := 'razonSocial ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SET NombreComplet		:= LTRIM(RTRIM(Par_RazonSocial));
			SET Var_RFCOficial		:= Par_RFCpm;
			SET Var_SoloNombres		:= Cadena_Vacia;
			SET Var_SoloApellidos	:= Cadena_Vacia;
			SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(TRIM(Par_RazonSocial),Mayusculas),150);

			IF (Par_RFCpm = Cadena_Vacia)THEN
				SET Valida_RFC:=Cadena_Vacia;
			ELSE
				SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFCpm AND ClienteID <> Par_ClienteID LIMIT 1);
				IF (Valida_RFC = Par_RFCpm)THEN
					SET Par_NumErr  := 2;
					SET Par_ErrMen  := 'RFC Asociado con otro safilocale.cliente';
					SET Var_Control := 'RFCpm ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_NombreNotario, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 063;
				SET Par_ErrMen  :='Se Requiere Nombre del Notario.';
				SET Var_Control := 'nombreNotario';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumNotario,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 064;
				SET Par_ErrMen  :='Se requiere el Numero de Notario.';
				SET Var_Control := 'numNotario';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_InscripcionReg, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 065;
				SET Par_ErrMen  :='Se Requiere el Numero de Inscripcion en el Registro Publico.';
				SET Var_Control := 'inscripcionReg ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PaisConstitucionID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 060;
				SET Par_ErrMen  :='Se Requiere el Pais de Constitucion.';
				SET Var_Control := 'paisConstitucionID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_EscrituraPubPM, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 067;
				SET Par_ErrMen  :='Se Requiere la Escritura Publica.';
				SET Var_Control := 'escrituraPubPM ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

		ELSE
			-- Si no es una persona moral el Campo Pais de Constiucion debe llevar el id de pais no especificado
			SET Par_PaisConstitucionID = IDPaisNoEsp;

		END IF;-- FIN validaciones persona morales

		IF IFNULL(Par_PaisNacionalidad,Entero_Cero) = Entero_Cero AND Par_TipoPersona != Per_Moral THEN
       		SET Par_NumErr  := 058;
			SET Par_ErrMen  := 'El Pais de Nacionalidad no Existe';
			SET Var_Control := 'paisNacionalidad';
			LEAVE ManejoErrores;
        END IF;

		SET Aud_FechaActual := NOW();

        /*INICIO VALIDACION PERSONAS NO DESEADAS*/
		SELECT  PersonNoDeseadas INTO Var_DetecNoDeseada
			FROM PARAMETROSSIS LIMIT 1;

		SET  Var_DetecNoDeseada:= IFNULL(Var_DetecNoDeseada,Salida_NO);

		IF(Var_DetecNoDeseada = Str_SI) THEN

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
		SET Var_BusqActivaPLD	:= IFNULL(Var_BusqActivaPLD,Str_NO);
		SET Var_RealizaBusqPLD	:= IF(Var_BusqActivaPLD = Str_SI,Str_NO,Str_SI);

		/*SECCION PLD: Deteccion de operaciones inusuales*/
		CALL PLDDETECCIONPRO(
			Par_ClienteID,      Par_PrimerNom,      Par_SegundoNom,     Par_TercerNom,      Par_ApellidoPat,
			Par_ApellidoMat,    Par_TipoPersona,    Par_RazonSocial,    Par_RFC,            Par_RFCpm,
			Par_FechaNac,       Entero_Cero,        Par_LugarNac,       Par_EstadoID,       NombreComplet,
			EsCliente,          Var_RealizaBusqPLD,	Var_RealizaBusqPLD, Str_SI,             Salida_NO,
			Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,
			Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN

			SET Var_OpeInusualID :=(SELECT OpeInusualID FROM PLDOPEINUSUALES
										WHERE Fecha=Var_FechaDeteccion
											AND FechaDeteccion = Var_FechaDeteccion
											AND ClaveRegistra=ClaveRegistra
											AND NombreReg = RegistraSAFI
											AND CatProcedIntID = CatProcIntID
											AND CatMotivInuID = CatMotivInusualID
											AND NomPersonaInv = NombreComplet
											AND TipoPersonaSAFI = EsCliente
											AND DesOperacion = DescripOpera
											AND ClavePersonaInv = Par_ClienteID LIMIT 1);
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
					CALL PLDSEGPERSONALISTASALT(Var_OpeInusualID,	EsCliente,			Par_ClienteID,			NombreComplet,			Var_FechaDeteccion,
												Con_LPB,			Var_SoloNombre,		Var_SoloApellido,		Var_FechaNac,			Var_RFCOficial,
												Var_PaisID,			Salida_NO,			Par_NumErr, 			Par_ErrMen,				Par_EmpresaID,
												Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,			Aud_Sucursal,
												Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;



			SET Par_NumErr      := 50; # NO CAMBIAR ESTE NUMERO DE ERROR
			SET Par_ErrMen		:= Var_ErrMen;
			SET Var_Control     := 'agrega';
			LEAVE ManejoErrores;
		END IF;
		/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

		-- Si la clasificacion anterior era de IN(Institucion de Nomina), busco la institucion a la que estaba relacioando
		-- si esta institucion de nomina es diferente ahora, entonces actualizo la IN encontrada con un cte en cero
		-- Actualizamos la IN nueva si es dif a cero, con el Cte nuevo

		IF (Par_Clasific = esEmpresaNomina ) THEN

			IF EXISTS(SELECT ClienteID FROM INSTITNOMINA WHERE ClienteID=Par_ClienteID)THEN

				SELECT Inn.InstitNominaID INTO Var_InsNominaAnt
					FROM INSTITNOMINA Inn
					WHERE Inn.ClienteID = Par_ClienteID;

				SET  Var_InsNominaAnt := IFNULL(Var_InsNominaAnt, Entero_Cero);

				IF(Var_InsNominaAnt != Par_InstitNominaID AND Par_InstitNominaID!=Entero_Cero AND Var_InsNominaAnt!=Entero_Cero ) THEN
					SELECT  IFNULL(ClienteID,Entero_Cero) INTO Var_ClieInstNom
					FROM INSTITNOMINA
					WHERE InstitNominaID = Par_InstitNominaID;

					IF (Var_ClieInstNom = Entero_Cero)THEN

						CALL INSTITNOMINAACT(
							Par_InstitNominaID, Par_ClienteID,  Act_ClienteEN,    Salida_NO,      Var_NumErr,
							Var_ErrMen,         Par_EmpresaID,  Aud_Usuario,      Aud_FechaActual,
							Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);

						IF (Var_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						CALL INSTITNOMINAACT(
							Var_InsNominaAnt,   Entero_Cero,    Act_ClienteEN,    Salida_NO,       Var_NumErr,
							Var_ErrMen,         Par_EmpresaID,  Aud_Usuario,      Aud_FechaActual,
							Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);

						IF (Var_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

					ELSE
						SET Par_NumErr  := 41;
						SET Par_ErrMen  :=CONCAT('Ya Existe un Cliente Asignado a esta Institucion de Nomina: ',CONVERT(Par_InstitNominaID,CHAR));
						SET Var_Control := 'institNominaID ';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				END IF;
			ELSE
				SELECT  IFNULL(ClienteID,Entero_Cero) INTO Var_ClieInstNom
					FROM INSTITNOMINA
					WHERE InstitNominaID = Par_InstitNominaID;

				IF (Var_ClieInstNom = Entero_Cero)THEN
					CALL INSTITNOMINAACT(
						Par_InstitNominaID, Par_ClienteID,  Act_ClienteEN,    Salida_NO,      Var_NumErr,
						Var_ErrMen,         Par_EmpresaID,  Aud_Usuario,      Aud_FechaActual,
						Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);

					IF (Var_NumErr!=Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					SET Par_NumErr  := 41;
					SET Par_ErrMen  :=CONCAT('Ya Existe un Cliente ASignado a esta Institucion de Nomina: ',CONVERT(Par_InstitNominaID,CHAR));
					SET Var_Control := 'institNominaID ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- Consideraciones si la Clasificion es Empresa de Nomina
		IF(Par_Clasific = esNegocioAfilia) THEN
			SELECT Estatus INTO Var_Estatus_Neg
				FROM NEGOCIOAFILIADO
				WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID;

			IF NOT EXISTS(SELECT NegocioAfiliadoID
				FROM NEGOCIOAFILIADO
				WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID ) THEN
				SET Par_NumErr  := 40;
				SET Par_ErrMen  :='El Negocio Afiliado no Existe';
				SET Var_Control := 'negocioAfiliadoID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF (Var_Estatus_Neg=Baja)THEN
				SET Par_NumErr  := 40;
				SET Par_ErrMen  :=CONCAT('El Negocio Afiliado se Encuentra Cancelado: ',CONVERT(Par_NegocioAfiliadoID,CHAR));
				SET Var_Control := 'negocioAfiliadoID ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Validacion de Clasificiacion de Negocio Afiliado
		IF (Par_Clasific = esNegocioAfilia) THEN
			IF(Par_TipoPersona!=Moral) THEN
				SET Par_NumErr  := 42;
				SET Par_ErrMen  :='Para ser Negocio Afiliado se requiere una Persona Moral';
				SET Var_Control := 'tipoPersona2 ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Si la clasificacion anterior era de NE(Negocio Afiliado), busco la institucion a la que estaba relacioando
		-- si esta institucion de Negocio Afiliado es diferente ahora,
		-- Entonces actualizo el NE encontradao con un cte en cero
		-- Actualizamos el NE si es dif a cero, con el Cte nuevo
		IF (Par_Clasific = esNegocioAfilia) THEN

			IF EXISTS(SELECT ClienteID 	FROM NEGOCIOAFILIADO WHERE ClienteID=Par_ClienteID)THEN

				SELECT Nga.NegocioAfiliadoID INTO Var_InsNegAfiAnt
				  FROM NEGOCIOAFILIADO Nga
					WHERE Nga.ClienteID = Par_ClienteID;

				SET  Var_InsNegAfiAnt := IFNULL(Var_InsNegAfiAnt, Entero_Cero);

				IF(Var_InsNegAfiAnt != Par_NegocioAfiliadoID AND Par_NegocioAfiliadoID!=Entero_Cero AND Var_InsNegAfiAnt!=Entero_Cero) THEN

					SELECT  IFNULL(ClienteID,Entero_Cero) INTO Var_ClieNegAfi
						FROM NEGOCIOAFILIADO
						WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID;

					IF (Var_ClieNegAfi = Entero_Cero)THEN

						CALL NEGOCIOAFILIADOACT(
							Par_NegocioAfiliadoID,  Par_ClienteID,  Act_ClienteNA,  Salida_NO,        Par_NumErr,
							Par_ErrMen,             Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
							Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);

						IF (Par_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

						CALL NEGOCIOAFILIADOACT(
							Var_InsNegAfiAnt,   Entero_Cero,    Act_ClienteNA,  Salida_NO,        Par_NumErr,
							Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
							Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

						IF (Par_NumErr!=Entero_Cero) THEN
							LEAVE ManejoErrores;
						END IF;

					ELSE
						SET Par_NumErr  := 42;
						SET Par_ErrMen  :=CONCAT('Ya Existe un Cliente Asignado a este Negocio Afiliado: ',CONVERT(Par_NegocioAfiliadoID,CHAR));
						SET Var_Control := 'negocioAfiliadoID ';
						SET Var_Consecutivo := Entero_Cero;
						LEAVE ManejoErrores;
					END IF;
				END IF;

			ELSE

				SELECT  IFNULL(ClienteID,Entero_Cero) INTO Var_ClieNegAfi
					FROM NEGOCIOAFILIADO
					WHERE NegocioAfiliadoID = Par_NegocioAfiliadoID;

				IF (Var_ClieNegAfi = Entero_Cero)THEN

					CALL NEGOCIOAFILIADOACT(
						Par_NegocioAfiliadoID,  Par_ClienteID,  Act_ClienteNA,  Salida_NO,        Par_NumErr,
						Par_ErrMen,             Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
						Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);

					IF (Par_NumErr!=Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					SET Par_NumErr  := 43;
					SET Par_ErrMen  :=CONCAT('Ya Existe un Cliente Asignado a este Negocio Afiliado: ',CONVERT(Par_NegocioAfiliadoID,CHAR));
					SET Var_Control := 'negocioAfiliadoID ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(Par_Clasific != Var_ClasAnterior)THEN
			IF(Var_ClasAnterior=esEmpresaNomina)THEN
				SELECT Inn.InstitNominaID INTO Var_InsNominaAnt
					FROM INSTITNOMINA Inn
					WHERE Inn.ClienteID = Par_ClienteID;

				CALL INSTITNOMINAACT(
					Var_InsNominaAnt, Entero_Cero,    Act_ClienteEN,    Salida_NO,      Var_NumErr,
					Var_ErrMen,       Par_EmpresaID,  Aud_Usuario,      Aud_FechaActual,
					Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);

				IF (Var_NumErr!=Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Var_ClasAnterior=esNegocioAfilia)THEN

				SELECT Nga.NegocioAfiliadoID INTO Var_InsNegAfiAnt
					FROM NEGOCIOAFILIADO Nga
					WHERE Nga.ClienteID = Par_ClienteID;

				CALL NEGOCIOAFILIADOACT(
					Var_InsNegAfiAnt,   Entero_Cero,    Act_ClienteNA,  Salida_NO,        Par_NumErr,
					Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

				IF (Var_NumErr!=Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF  IFNULL(Var_ClasAnterior,Cadena_Vacia ) = esTarjetaHabNUno THEN
			SET   Var_NumErr  := Entero_Cero;
			SET   Var_ErrMen  := Cadena_Vacia;

			CALL TARDEBNIVUNOVAL(
				Par_ClienteID,    Con_Salida,       Var_NumErr,       Var_ErrMen,       Par_EmpresaID,
				Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Var_NumErr != Entero_Cero)THEN
				SET Par_NumErr  := 36;
				SET Par_ErrMen  :='';
				SET Var_Control := 'ValidaCTENuno ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SELECT CuentaAhoID INTO Var_cuentaCNUno
				FROM CUENTASAHO ca, CLIENTES cli
				WHERE   ca.ClienteID = Par_ClienteID
					AND   cli.ClienteID = ca.ClienteID;

			IF(IFNULL(Var_cuentaCNUno, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  := 37;
				SET Par_ErrMen  :='La Cuenta de Ahorro Relacionado al Cliente No existe';
				SET Var_Control := 'ValidaCTENuno ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS (SELECT CuentaAhoID FROM CUENTASPERSONA WHERE CuentaAhoID = Var_cuentaCNUno))THEN

				SELECT  TipoIdentiID, NumIdentific,  FecExIden, FecVenIden
				INTO  Var_TipoIdentiID, Var_NumIden, Var_FecExIden, Var_FecVenIden
					FROM  IDENTIFICLIENTE
					WHERE   Oficial   = Cons_esOficial
						AND   ClienteID   = Par_ClienteID LIMIT 1;

				IF( IFNULL(Var_TipoIdentiID, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr  := 38;
					SET Par_ErrMen  :=CONVERT(CONCAT('No existe la IdentIFicacion Oficial del Cliente ' ,Par_ClienteID,'.'),CHAR);
					SET Var_Control := 'clienteOficial ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				SELECT SUBSTRING(DireccionCompleta,1, 200) INTO Var_Domicilio
					FROM DIRECCLIENTE dir, TIPOSDIRECCION tdir
					WHERE dir.TipoDireccionID = tdir.TipoDireccionID
						AND tdir.Oficial = Cons_esOficial
						AND ClienteID = Par_ClienteID LIMIT 1;

				IF( IFNULL(Var_Domicilio, Cadena_Vacia) = Cadena_Vacia)THEN
					SET Par_NumErr  := 39;
					SET Par_ErrMen  := CONVERT(CONCAT('No existe la Direccion Oficial del Cliente ' ,Par_ClienteID,'.'),CHAR);
					SET Var_Control := 'direccionOficial ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;

				CALL `CUENTASPERSONAALT`(
					Var_cuentaCNUno,      Cadena_Vacia,         Var_EsTitular,    	Cadena_Vacia,     		Cadena_Vacia,
					Cadena_Vacia,         Cadena_Vacia,         Var_EsFirmante,   	Par_Titulo,       		Par_PrimerNom,
					Par_SegundoNom,       Cadena_Vacia,         Par_ApellidoPat,  	Par_ApellidoMat,  		Par_FechaNac,
					Par_LugarNac,         Par_EstadoID,         Par_EstadoCivil,  	Par_Sexo,				Par_Nacion,
					Par_CURP,             Par_RFC,              Par_OcupacionID,  	Par_FEA,          		Par_PaisFEA,
					Par_PaisResi,         Par_Puesto,           Par_SecGeneral,   	Par_ActBancoMX,   		Par_ActINEGI,
					Par_SecEconomic,      Var_TipoIdentiID,     Cadena_Vacia,     	Var_NumIden,      		Var_FecExIden,
					Var_FecVenIden,       Var_Domicilio,        Par_Telefono,     	Par_TelefonoCel,  		Par_Correo,
					Par_PaisResi,         Cadena_Vacia,         Cadena_Vacia,     	Fecha_Vacia,      		Cadena_Vacia,
					Fecha_Vacia,          Entero_Cero,          Entero_Cero,      	Entero_Cero,      		Cadena_Vacia,
					Par_RazonSocial,      Par_Fax,              Entero_Cero,      	Entero_Cero,      		Par_ClienteID,
					Par_ExtTelefonoPart,  Entero_Cero, 			Par_CorreoPM, 		Par_TelefonoPM, 		Par_ExtTelefonoPM,
					Var_Domicilio,		  Par_RazonSocial,		Par_FechaRegistro,	Par_PaisConstitucionID, Par_RFCpm,
					Cadena_Vacia,	  	  Entero_Cero,     		Par_FEA,			Par_PaisFEA,			Con_Salida,
					Par_NumErr,       	  Par_ErrMen,     	  	Par_EmpresaID,      Aud_Usuario,        	Aud_FechaActual,
					Aud_DireccionIP,  		Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				IF (Par_NumErr !=  Entero_Cero) THEN
					SET Par_NumErr  := 39;
					SET Var_Control := 'CUENTASPERSONAALT ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- Validar la Fecha de Constitucion del RFC
		IF(Par_TipoPersona = Per_ActEmp)AND(Par_Nacion=nacionalidadMex) THEN
			IF((IFNULL(Par_FechaCons,Fecha_Vacia)=Fecha_Vacia) OR (IFNULL(Par_FechaCons,Cadena_Vacia)=Cadena_Vacia)) THEN
				SET Par_NumErr  := 51;
				SET Par_ErrMen  :='La Fecha de Constitucion es requerida.';
				SET Var_Control := 'fechaConstitucion ';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_OcupacionID, Entero_Cero)=Entero_Cero)THEN
			IF (Par_TipoPersona != Per_Moral AND Par_EsMenorEdad = MenorEdadNO) THEN
				SET Par_NumErr  := 52;
				SET Par_ErrMen  :='La Ocupacion es requerida.';
				SET Var_Control := 'ocupacionID';
				SET Var_Consecutivo := Entero_Cero;
			END IF;
		END IF;


		SELECT PEPs INTO Var_PEP
			FROM CONOCIMIENTOCTE
			WHERE ClienteID = Par_ClienteID;

		IF(Par_Nacion=nacionalidadExt AND IFNULL(Var_PEP,PEP_No)=PEP_Si) THEN
			IF(Par_NivelRiesgo!=NivelRiesgoAlto)THEN
				SET Par_NivelRiesgo := NivelRiesgoAlto;
			END IF;
		END IF;

		SET Aud_FechaActual := NOW();

		IF (Par_TipoPersona =  Per_Moral )THEN
			SET Par_RegistroHacienda :='S';
		END IF;






		UPDATE CLIENTES SET
			SucursalOrigen    = Par_SucursalOri,
			TipoPersona       = Par_TipoPersona,
			Titulo            = Par_Titulo,
			PrimerNombre      = Par_PrimerNom,
			SegundoNombre     = Par_SegundoNom,
			TercerNombre      = Par_TercerNom,
			ApellidoPaterno   = Par_ApellidoPat,
			ApellidoMaterno   = Par_ApellidoMat,
			FechaNacimiento   = Par_FechaNac,
			LugarNacimiento   = Par_LugarNac,

			EstadoID          = Par_EstadoID,
			Nacion            = Var_Nacionalidad,
			PaisResidencia    = Par_PaisResi,
			Sexo              = Par_Sexo,
			CURP              = Par_CURP,
			RFC               = Par_RFC,
			EstadoCivil       = Par_EstadoCivil,
			TelefonoCelular   = Par_TelefonoCel,
			Telefono          = Par_Telefono,
			Correo            = Par_Correo,

			RazonSocial       = Par_RazonSocial,
			TipoSociedadID    = Par_TipoSocID,
			RFCpm             = Par_RFCpm,
			RFCOficial        = Var_RFCOficial,
			GrupoEmpresarial  = Par_GrupoEmp,
			Fax               = Par_Fax,
			OcupacionID       = Par_OcupacionID,
			Puesto            = Par_Puesto,
			LugardeTrabajo    = Par_LugardeTrab,
			AntiguedadTra     = Par_AntTra,
			DomicilioTrabajo  = Par_DomicilioTrabajo,

			TelTrabajo        = Par_TelTrabajo,
			Clasificacion     = Par_Clasific,
			MotivoApertura    = Par_MotivoApert,
		-- 	PagaISR           = Par_PagaISR,
		-- 	PagaIVA           = Par_PagaIVA,
			PagaIDE           = Par_PagaIDE,
			NivelRiesgo       = Par_NivelRiesgo,
			SectorGeneral     = Par_SecGeneral,
			actividadBancoMX  = Par_ActBancoMX,
			ActividadINEGI    = Par_ActINEGI,

			ActividadFR       = Par_ActFR,
			actividadFOMURID  = Par_ActFOMUR,
			SectorEconomico   = Par_SecEconomic,
			PromotorInicial   = Par_PromotorIni,
			PromotorActual    = Par_PromotorAct,
			NombreCompleto    = NombreComplet,
			EsMenorEdad       = Par_EsMenorEdad,
			EmpresaID         = Par_EmpresaID,
			CorpRelacionado   = Par_CorpRelacionado ,
			RegistroHacienda  = Par_RegistroHacienda,

			Observaciones     = Par_Observaciones,
			NoEmpleado        = Par_NoEmpleado,
			TipoEmpleado      = Par_TipoEmpleado,
			ExtTelefonoPart   = Par_ExtTelefonoPart,
			ExtTelefonoTrab   = Par_ExtTelefonoTrab,
			EjecutivoCap      = Par_EjecutivoCap,
			PromotorExtInv    = Par_PromotorExtInv,
			TipoPuesto        = Par_TipoPuesto,
			FechaIniTrabajo   = Par_FechaIniTrabajo,
			UbicaNegocioID    = Par_UbicaNegocioID,

			FEA               = Par_FEA,
			PaisFEA           = Par_PaisFEA,
			FechaConstitucion = Par_FechaCons,

			PaisConstitucionID  = Par_PaisConstitucionID,
			CorreoAlterPM       = Par_CorreoAlterPM,
			NombreNotario       = Par_NombreNotario,
			NumNotario          = Par_NumNotario,
			InscripcionReg      = Par_InscripcionReg,
			EscrituraPubPM      = Par_EscrituraPubPM,
			SoloNombres			= Var_SoloNombres,
			SoloApellidos		= Var_SoloApellidos,
			PaisNacionalidad 	= Par_PaisNacionalidad,
			RazonSocialPLD		= Var_RazonSocialPLD,

			Usuario           = Aud_Usuario,
			FechaActual       = Aud_FechaActual,
			DireccionIP       = Aud_DireccionIP,
			ProgramaID        = Aud_ProgramaID,
			Sucursal          = Aud_Sucursal,
			NumTransaccion    = Aud_NumTransaccion

		WHERE ClienteID = Par_ClienteID;


		UPDATE SOCIODEMOGRAL SET
			AntiguedadLab   = (Par_AntTra *12),
			FechaIniTrabajo = Par_FechaIniTrabajo,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

		WHERE ClienteID    = Par_ClienteID;

		CALL RIESGOPLDCTEPRO(
			Par_ClienteID,        Salida_NO,          Par_NumErr,         Par_ErrMen,   Par_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,			Alt_Clientes,		Par_ClienteID,				Entero_Cero,			Entero_Cero,
			Entero_Cero,				Salida_NO,			Par_NumErr,					Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,				Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */
		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := CONCAT("safilocale.cliente Modificado Exitosamente: ", CONVERT(Par_ClienteID, CHAR));
		SET Var_Control := 'numero';
		SET Var_Consecutivo:=LPAD(Par_ClienteID,10,'0');
END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo,
			Var_CampoGenerico AS CampoGenerico;
END IF;

END TerminaStore$$

