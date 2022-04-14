-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESWSVBCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESWSVBCALT`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESWSVBCALT`(
-- === SP para realizar alta de clientes mediante el WS de Alta de Clientes de ZAFI =====
    Par_PrimerNombre            VARCHAR(50), 	-- Primer Nombre del Cliente
    Par_SegundoNombre           VARCHAR(50),    -- Segundo Nombre del Cliente
    Par_TercerNombre            VARCHAR(50), 	-- Tercer Nombre del Cliente
	Par_ApPaterno	            VARCHAR(50), 	-- Apellido paterno del cliente
	Par_ApMaterno   			VARCHAR(50), 	-- Apellido materno del cliente

	Par_FechaNaci		  		DATE, 		 	-- Fecha de nacimiento
    Par_CURP 				    CHAR(18), 	 	-- Curp del cliente
    Par_Estado					INT(11),		-- ID Estado de Nacimiento
    Par_Sexo                    CHAR(1),     	-- Sexo del Cliente
	Par_Telefono                VARCHAR(20), 	-- Telefono oficial del cliente

    Par_Clasificacion			CHAR(1),		-- Clasificacion del Cliente - default I
    Par_TelCelular				VARCHAR(20), 	-- Telefono celular del cliente
    Par_Mail					VARCHAR(50),    -- Correo electronico del cliente
    Par_RFC     				CHAR(13), 	 	-- RFC del cliente
    Par_OcupacionID				INT(11),		-- Ocupaciones Valor Por Defecto 9999 (OTROS Trabajadores Con Ocupaciones Insuficientemente Especificadas)

	Par_LugarTrabajo			VARCHAR(150),	-- Lugar de trabajo del cliente
    Par_Puesto					varchar(150),	-- Puesto de trabajo del cliente
    Par_TelTrabajo				VARCHAR(20),	-- Telefono trabajo del cliente
    Par_ExtTelTrabajo			VARCHAR(10),	-- Extension del Telefono trabajo del cliente
    Par_NoEmpleado 				INT(11),		-- Indica el numero de empleado de la empresa de nomina a la que esta ligado el cliente

    Par_AntiguedadTra			DECIMAL(12,2), 	-- Antiguedad del Trabajo
	Par_TipoEmpleado			CHAR(1), 	 	-- Tipo de Empleado
	Par_TipoPuesto				INT(11), 	 	-- Tipo de Puesto
    Par_Usuario					VARCHAR(15),	-- USUARIO
    Par_Clave					VARCHAR(100),	-- CLAVE

   	Par_Salida					CHAR(1), 		-- SALIDA
	INOUT Par_NumErr			INT(11),		-- NUM ERROR
	INOUT Par_ErrMen			VARCHAR(400),	-- MENSAJE

	Par_EmpresaID		        INT(11),		-- AUDITORIA
	Aud_Usuario			        INT(11),		-- AUDITORIA
	Aud_FechaActual		  		DATETIME,		-- AUDITORIA
	Aud_DireccionIP				VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID				VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal				INT(11),		-- AUDITORIA
	Aud_NumTransaccion			BIGINT(20)		-- AUDITORIA
)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE Entero_Cero				INT(11);			-- ENTERO CERO
DECLARE Cadena_Vacia			CHAR(1);			-- CADENA VACIA
DECLARE Decimal_Cero	        DECIMAL(12,2);		-- DECIMAL CERO
DECLARE Estatus_Activo      	CHAR(1);			-- ESTATUS ACTIVO
DECLARE Fecha_Vacia				DATE;				-- FECHA VACIA
DECLARE MinRFC					INT;				-- RFC
DECLARE MaxRFC					INT;				-- RFC
DECLARE MinCURP					INT;				-- CURP
DECLARE CorreoValido			VARCHAR(15);		-- CORREO
DECLARE Per_Fisica     	    	CHAR(1);  			-- FISICA
DECLARE SalidaSI				CHAR(1);			-- SALIDA SI
DECLARE SalidaNO                CHAR(1);			-- SALIDA NO

DECLARE Var_NumErr				INT(11);			-- ERROR
DECLARE Var_MenErr				VARCHAR(150);		-- MENSAJE
DECLARE Var_ClienteID           INT;				-- CLIENTEID

DECLARE Var_FechaSis			DATE;				-- Fecha del Sistema0
DECLARE Var_ActINEGI            INT;      			-- Numero de la Actividad INEGI
DECLARE Var_ActFR            	BIGINT;  			-- Numero de la Actividad FR
DECLARE Var_ActFOMUR            INT;  				-- Numero de la Actividad FOMUR
DECLARE Var_SectorEco           INT;  				-- Numero del Sector Economico
DECLARE Var_FechaSistema        DATE;				-- FECHA SISTEMA


-- DECLARACION DE VARIABLES
DECLARE Var_CodigoResp			VARCHAR(5);			-- CODIGO RESPUES
DECLARE Var_MensajeResp			VARCHAR(150);		-- MENSAJE RESPUESTA
DECLARE SimbInterrogacion		VARCHAR(1);			-- SIGNO INTERROGACION
DECLARE OcupacionOtros 			INT(11);			-- OCUPACION
DECLARE Clasificacion       	VARCHAR(1);			-- CLSIFICACION
DECLARE MotAper        			VARCHAR(1);			-- MOT APERTURA
DECLARE PagaISR             	VARCHAR(1);			-- ISR
DECLARE PagaIVA            		VARCHAR(1);			-- IVA
DECLARE PagaIDE            		VARCHAR(1);			-- IDE
DECLARE NivelRiesgo        		VARCHAR(1);			-- RIESGO
DECLARE EsMenor             	VARCHAR(1);			-- MENOR
DECLARE RegHacien				VARCHAR(1);			-- REG HACIENDA
DECLARE Par_Titulo				VARCHAR(5);			-- TITULO
DECLARE Par_SucursalOrigen		INT(11);			-- SUC ORIGEN
DECLARE Par_EstadoCivil			VARCHAR(15);		-- ESTADO CIVIL
DECLARE Par_PaisResidencia		INT(11);			-- PAIS RESIDENCIA
DECLARE Par_PaisNaci			INT(11);			-- PAIS NAC
DECLARE Par_Nacionalidad		VARCHAR(4);			-- NACIONALIDAD
DECLARE Par_SectorGral			INT(11);			-- SECTOR GRAL
DECLARE Var_SectorGral			INT(11);			-- SECTOR GRAL
DECLARE Par_ActividadBMX		BIGINT(11);			-- ACTIVIDAD BMX
DECLARE Par_PromotorIni			INT(11);			-- PROMOTOR INO
DECLARE Par_PromotorAct			INT(11);			-- PROMOTOR ACT
DECLARE Soltero 				CHAR(2);			-- SOLTERO
DECLARE CasadoBS 				CHAR(2);			-- CASADO BS
DECLARE CasadoBM 				CHAR(2);			-- CASADO BM
DECLARE CasadoBMC 				CHAR(2);			-- CASADO BMC
DECLARE Viudo 					CHAR(2);			-- VIUDO
DECLARE Divorciado 				CHAR(2);			-- DIVORCIADO
DECLARE Separado 				CHAR(2);			-- SEPARADO
DECLARE UnionLibre 				CHAR(2);			-- UNION LIBRE
DECLARE Par_TipoPersona			CHAR(2);			-- TIPO DE PERSONA
DECLARE Valida_RFC        		CHAR(13);			-- RFC
DECLARE Valida_CURP       		CHAR(18);			-- CURP
DECLARE Per_Moral       		CHAR(1);			-- MORAL
DECLARE Per_MenorEdad       	CHAR(1);			-- MENOR EDAD
DECLARE MenorEdadNO         	CHAR(1);			-- MENOR EDAD NO
DECLARE Masculino				CHAR(1);			-- MASCULINO
DECLARE Femenino				CHAR(1);			-- FEMENINO
DECLARE EmpleadoNomina			CHAR(1);			-- EMPLEADO NOMINA
DECLARE Par_MonedaID 			INT(11);			-- MONEDA
DECLARE Par_TipoCuentaID 		INT(11);			-- TIPO DE CTA
DECLARE Par_Etiqueta 			VARCHAR(50);		-- ETIQUETA
DECLARE	Par_EdoCta 			    CHAR(1);			-- ESTADO CUENTA
DECLARE Par_EsPrincipal			CHAR(1);			-- PRINCIPAL
DECLARE Par_CuentaAho  			BIGINT(12);			-- CUENTA AHO
DECLARE Var_PerfilWsVbc			INT(11);			-- PERFIL OPERACIONES VBC


-- Asignacion de variables
SET Entero_Cero			:= 0;			-- ENTERO CERO
SET Cadena_Vacia		:= '';			-- CADENA VACIA
SET Estatus_Activo      := 'A';			-- ESTATUS ACTIVO
SET Decimal_Cero	    :=  0.00;   	-- Decimal en Cero
SET Fecha_Vacia			:= '1900-01-01';-- FECHA VACIA
SET Par_EmpresaID		:= 1;			-- EmpresaID Valor por Default 1
SET SalidaSI			:= 'S';			-- SALIDA SI
SET	SalidaNO 	   	   	:= 'N';	      	-- El Store NO genera una Salida

SET	Var_ClienteID     	:=  0;         	-- Valor que toma el ID del cliente para insertar en tabla direccliente e identificliente
SET SimbInterrogacion	:= '?';			-- Simbolo de interrogación
SET MinRFC				:= 10;			-- Numero de Caracateres minimo RFC Personas Fisicas (SIN HOMOCLAVE)
SET MaxRFC				:= 13;			-- Numero de Caracateres maximo RFC Personas Fisicas (CON HOMOCLAVE)
SET MinCURP				:= 18;			-- Numero de Caracateres para la CURP
SET CorreoValido		:= '(.*)@(.*)\\.(.*)';	-- Expresion Regular, para Validar Email
SET Per_Fisica			:= 'F';        	-- Tipo de persona FISICA por Default
SET OcupacionOtros		:= 9999;		-- Tabla de OCUPACIONES: OTROS TRABAJADORES CON OCUPACIONES INSUFICIENTEMENTE ESPECIFICADAS
SET Clasificacion       := 'I';        	-- Clasificación
SET MotAper        		:= '1';        	-- Motivo de apertura
SET PagaISR             := 'N';        	-- Valor No paga ISR
SET PagaIVA            	:= 'S';        	-- Valor si el cliente para IVA
SET PagaIDE            	:= 'N';        	-- Valor No paga IDE
SET NivelRiesgo        	:= 'B';        	-- Valor del riesgo
SET EsMenor             := 'N'; 	    -- Socio es menor de edad, Valor por Default N
SET RegHacien      		:= 'N';        	-- Valor si el cliente no está registrado en hacienda

SET Soltero 			:= 'S';			-- Valor SOltero
SET CasadoBS 			:= 'CS';		-- Casado Bienes Separados
SET CasadoBM 			:= 'CM';		-- Casado Bienes Mancomunados
SET CasadoBMC 			:= 'CC';		-- Casdo Bienes Mancomunados con Capitulacion
SET Viudo 				:= 'V';			-- Valor Viudo
SET Divorciado 			:= 'D';			-- Valor Divorciado
SET Separado 			:= 'SE';		-- Valor Separado
SET UnionLibre 			:= 'U';			-- Valor Unión Libre
SET Masculino			:= 'M';			-- Valor Masculino
SET Femenino			:= 'F';			-- Femenino
SET Per_Moral         	:= 'M';      	-- Persona moral
SET Per_MenorEdad       := 'E';       	-- Persona menor de edad
SET MenorEdadNO         := 'N';       	-- No es Menor de edad
SET EmpleadoNomina		:= 'M';			-- Clasificacion Empleado de Nomina
SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);

SET	Var_CodigoResp	   :=  '999';
SET	Var_MensajeResp	   :=  'Transaccion Rechazada.';

SET Par_NumErr := '999';
SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIENTESWSVBCALT');


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIENTESWSVBCALT');
		END;

	-- Consulta de Valores parametrizables
    SELECT ValorParametro INTO Par_Titulo
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'Titulo';
	SELECT ValorParametro INTO Par_SucursalOrigen
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'SucursalOrigen';
	SELECT ValorParametro INTO Par_EstadoCivil
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'EstadoCivil';
	SELECT ValorParametro INTO Par_PaisResidencia
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'PaisNac';
	SELECT ValorParametro INTO Par_PaisNaci
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'PaisNac';
	SELECT ValorParametro INTO Par_Nacionalidad
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'Nacionalidad';
	SELECT ValorParametro INTO Par_SectorGral
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'SectorGral';
    SELECT ValorParametro INTO Par_ActividadBMX
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'ActividadBMX';
	SELECT ValorParametro INTO Par_PromotorIni
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'PromotorInicial';
	SELECT ValorParametro INTO Par_PromotorAct
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'PromotorActual';
	SELECT ValorParametro INTO Par_TipoPersona
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'TipoPersona';

	SELECT ValorParametro INTO Par_MonedaID
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'MonedaIDCta';
	SELECT ValorParametro INTO Par_TipoCuentaID
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'TipoCuentaID';
	SELECT ValorParametro INTO Par_Etiqueta
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'Etiqueta';
	SELECT ValorParametro INTO Par_EdoCta
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'EdoCta';
	SELECT ValorParametro INTO Par_EsPrincipal
		FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'EsPrincipal';


	SET Par_PrimerNombre   	:= REPLACE(Par_PrimerNombre, SimbInterrogacion, Cadena_Vacia);
    SET Par_PrimerNombre    := RTRIM(LTRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
	SET Par_SegundoNombre   := REPLACE(Par_SegundoNombre, SimbInterrogacion, Cadena_Vacia);
	SET Par_TercerNombre    := REPLACE(Par_TercerNombre, SimbInterrogacion, Cadena_Vacia);
    SET Par_ApPaterno	  	:= REPLACE(Par_ApPaterno, SimbInterrogacion, Cadena_Vacia);
	SET Par_ApMaterno	  	:= REPLACE(Par_ApMaterno, SimbInterrogacion, Cadena_Vacia);

	SET Par_SegundoNombre   := RTRIM(LTRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
	SET Par_TercerNombre    := RTRIM(LTRIM(IFNULL(Par_TercerNombre, Cadena_Vacia)));
	SET Par_ApPaterno     	:= RTRIM(LTRIM(IFNULL(Par_ApPaterno, Cadena_Vacia)));
	SET Par_ApMaterno	  	:= RTRIM(LTRIM(IFNULL(Par_ApMaterno, Cadena_Vacia)));


	SET Par_PrimerNombre	:= UPPER(Par_PrimerNombre);
	SET Par_SegundoNombre	:= UPPER(Par_SegundoNombre);
	SET Par_TercerNombre	:= UPPER(Par_TercerNombre);
	SET Par_ApPaterno		:= UPPER(Par_ApPaterno);
	SET Par_ApMaterno		:= UPPER(Par_ApMaterno);

	SET Par_RFC	  			:= REPLACE(Par_RFC, SimbInterrogacion, Cadena_Vacia);
    SET Par_RFC    			:= RTRIM(LTRIM(IFNULL(Par_RFC, Cadena_Vacia)));
	SET	Par_RFC				:= UPPER(Par_RFC);
    SET Par_CURP	  		:= REPLACE(Par_CURP, SimbInterrogacion, Cadena_Vacia);
    SET Par_CURP    		:= RTRIM(LTRIM(IFNULL(Par_CURP, Cadena_Vacia)));
	SET	Par_CURP			:= UPPER(Par_CURP);

	SET Par_Sexo	  		:= REPLACE(Par_Sexo, SimbInterrogacion, Cadena_Vacia);
    SET Par_Sexo    		:= RTRIM(LTRIM(IFNULL(Par_Sexo, Cadena_Vacia)));
	SET Par_Sexo			:= UPPER(Par_Sexo);
	SET Par_EstadoCivil		:= UPPER(Par_EstadoCivil);
	SET Par_Titulo			:= UPPER(Par_Titulo);
	SET Par_Telefono	  	:= REPLACE(Par_Telefono, SimbInterrogacion, Cadena_Vacia);
    SET Par_Clasificacion	:= REPLACE(Par_Clasificacion, SimbInterrogacion, Cadena_Vacia);
    SET Par_Clasificacion	:= UPPER(Par_Clasificacion);
    SET Par_TelCelular		:= REPLACE(Par_TelCelular, SimbInterrogacion, Cadena_Vacia);

    SET Par_Mail	  		:= REPLACE(Par_Mail, SimbInterrogacion, Cadena_Vacia);
    SET Par_Mail    		:= RTRIM(LTRIM(IFNULL(Par_Mail, Cadena_Vacia)));
    SET Par_AntiguedadTra	:= REPLACE(Par_AntiguedadTra, SimbInterrogacion, Entero_Cero);
    SET Par_LugarTrabajo	:= REPLACE(Par_LugarTrabajo, SimbInterrogacion, Cadena_Vacia);
	SET Par_Puesto			:= REPLACE(Par_Puesto, SimbInterrogacion, Cadena_Vacia);
    SET Par_TelTrabajo		:= REPLACE(Par_TelTrabajo, SimbInterrogacion, Cadena_Vacia);
    SET Par_ExtTelTrabajo	:= REPLACE(Par_ExtTelTrabajo, SimbInterrogacion, Cadena_Vacia);
	SET Par_NoEmpleado		:= REPLACE(Par_NoEmpleado, SimbInterrogacion, Entero_Cero);
	SET Par_TipoEmpleado	:= REPLACE(Par_TipoEmpleado, SimbInterrogacion, Cadena_Vacia);
	SET Par_TipoPuesto		:= REPLACE(Par_TipoPuesto, SimbInterrogacion, Entero_Cero);
    SET Par_Usuario			:= REPLACE(Par_Usuario, SimbInterrogacion, Cadena_Vacia);
    SET Par_Clave			:= REPLACE(Par_Clave, SimbInterrogacion, Cadena_Vacia);

    SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
    	SET Par_NumErr		:= '60';
		SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
		LEAVE ManejoErrores;
    END IF;

	IF IFNULL(Par_Usuario, Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr := 25;
		SET Par_ErrMen := 'El Usuario esta Vacio.' ;
		LEAVE ManejoErrores;
	END IF;
	IF IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia THEN
		SET Par_NumErr := 26;
		SET Par_ErrMen := 'La Clave del Usuario esta Vacia.' ;
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT Clave
					FROM USUARIOS
					WHERE Clave = Par_Usuario AND Contrasenia = Par_Clave And Estatus = Estatus_Activo AND RolID = Var_PerfilWsVbc) THEN
		SET Par_NumErr := 27;
		SET Par_ErrMen := 'El Usuario o la Clave Son Incorrectos.' ;
		LEAVE ManejoErrores;
	END IF;
	-- Fecha Actual
	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

	SET Var_SectorGral := 	(SELECT  SectorID FROM  SECTORES WHERE SectorID = Par_SectorGral);
	IF(IFNULL(Var_SectorGral, Entero_Cero) = Entero_Cero)THEN
		SET Par_NumErr := 28;
		SET Par_ErrMen := 'El Sector General no existe.' ;
		LEAVE ManejoErrores;
	END IF;


	-- Obtencion de Actividades
	SELECT	INE.ActividadINEGIID,	FR.ActividadFRID,	FOM.ActividadFOMURID,	SEC.SectorEcoID
		INTO Var_ActINEGI,			Var_ActFR,			Var_ActFOMUR, 			Var_SectorEco
			FROM ACTIVIDADESBMX	BMX
				LEFT OUTER JOIN ACTIVIDADESFR AS FR  ON BMX.ActividadFR = FR.ActividadFRID
				LEFT OUTER JOIN ACTIVIDADESINEGI AS INE  ON  BMX.ActividadINEGIID	= INE.ActividadINEGIID
				LEFT OUTER JOIN SECTORESECONOM AS SEC  ON INE.SectorEcoID		= SEC.SectorEcoID
				LEFT OUTER JOIN ACTIVIDADESFOMUR AS FOM ON BMX.ActividadFOMUR = FOM.ActividadFOMURID
			WHERE BMX.ActividadBMXID = Par_ActividadBMX
			LIMIT 1;

	IF(IFNULL(Par_PrimerNombre, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 03;
		SET Par_ErrMen := 'El Primer Nombre esta Vacio.' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_ApPaterno, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 04;
		SET Par_ErrMen := 'El Apellido Paterno esta Vacio.' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_FechaNaci, Fecha_Vacia)) = Fecha_Vacia THEN
    	SET Par_NumErr := 14;
		SET Par_ErrMen := 'La Fecha de Nacimiento esta Vacia.' ;
		LEAVE ManejoErrores;
	END IF;
    IF(DATEDIFF(Var_FechaSis, Par_FechaNaci) < Entero_Cero)THEN
    	SET Par_NumErr := 163;
		SET Par_ErrMen := 'La Fecha de Nacimiento es Mayor a la Fecha Actual.' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_CURP, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 15;
		SET Par_ErrMen := 'La CURP del Cliente esta Vaci­a.' ;
		LEAVE ManejoErrores;
	END IF;
    IF(CHARACTER_LENGTH(Par_CURP) != MinCURP)THEN
    	SET Par_NumErr := 164;
		SET Par_ErrMen := 'Se requieren 18 Caracteres para la CURP.' ;
		LEAVE ManejoErrores;
	END IF;
    IF (Par_CURP != Cadena_Vacia)THEN
		SET Valida_CURP:=(SELECT  CURP FROM CLIENTES WHERE CURP = Par_CURP  AND EsMenorEdad= MenorEdadNO
		AND  TipoPersona != Per_Moral AND Par_TipoPersona != Per_Moral LIMIT 1);
		IF (Valida_CURP = Par_CURP)THEN
        	SET Par_NumErr := 02;
			SET Par_ErrMen := 'CURP asociada a otro Cliente.' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;
	IF (Par_CURP != Cadena_Vacia)THEN
		SET Valida_CURP:=(SELECT  CURP FROM CLIENTES WHERE CURP = Par_CURP  AND EsMenorEdad=EsMenor AND Estatus =Estatus_Activo LIMIT 1);
		IF (Valida_CURP = Par_CURP)THEN
        	SET Par_NumErr := 02;
			SET Par_ErrMen := 'CURP asociada a otro Cliente.' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;
	IF (IFNULL(Par_Estado, Entero_Cero)) = Entero_Cero THEN
    	SET Par_NumErr := 08;
		SET Par_ErrMen := 'El Estado esta Vacio.' ;
		LEAVE ManejoErrores;
    END IF;

	IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
					   WHERE EstadoID = Par_Estado
					   LIMIT 1)THEN
		SET Par_NumErr := 16;
		SET Par_ErrMen := 'El Valor Indicado para el Estado No Existe.' ;
		LEAVE ManejoErrores;
	END IF;

	IF (IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 09;
		SET Par_ErrMen := 'El Sexo esta Vacio.' ;
		LEAVE ManejoErrores;

    END IF;
    IF (Par_Sexo NOT IN (Masculino, Femenino)) THEN
    	SET Par_NumErr := 18;
		SET Par_ErrMen := 'Caracter Incorrecto para el Sexo del Cliente.' ;
		LEAVE ManejoErrores;
	END IF;
    IF (IFNULL(Par_Telefono, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 06;
		SET Par_ErrMen := 'El Telefono esta Vacio.' ;
		LEAVE ManejoErrores;
    END IF;
    IF (IFNULL(Par_Clasificacion, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 19;
		SET Par_ErrMen := 'La Clasificacion del Cliente esta Vacia.' ;
		LEAVE ManejoErrores;
    END IF;
    IF (IFNULL(Par_TelCelular, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 05;
		SET Par_ErrMen := 'El Telefono Celular esta Vacio.' ;
		LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 17;
		SET Par_ErrMen := 'El RFC del Cliente esta Vacio.' ;
		LEAVE ManejoErrores;
	END IF;
    -- VALIDA LONGITUD RFC
	IF(IFNULL(Par_RFC, Cadena_Vacia)) <> Cadena_Vacia THEN
		IF(CHARACTER_LENGTH(Par_RFC) != MinRFC AND CHARACTER_LENGTH(Par_RFC) != MaxRFC)THEN
        	SET Par_NumErr := 165;
			SET Par_ErrMen := 'La Longitud del RFC es incorrecta.' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;
	IF(Par_TipoPersona = Per_Fisica) THEN
		IF (Par_RFC = Cadena_Vacia)THEN
		  SET Valida_RFC:=Cadena_Vacia;
		ELSE
			SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFC LIMIT 1);
			IF (Valida_RFC = Par_RFC)THEN
            	SET Par_NumErr := 01;
				SET Par_ErrMen := 'RFC asociado con otro Cliente.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(Par_TipoPersona =  Per_Moral) THEN
		IF (Par_RFC = Cadena_Vacia)THEN
		  SET Valida_RFC:=Cadena_Vacia;
		ELSE
			SET Valida_RFC:=(SELECT  RFCOficial FROM CLIENTES WHERE RFCOficial = Par_RFC LIMIT 1);
			IF (Valida_RFC = Par_RFC)THEN
				SET Par_NumErr := 01;
				SET Par_ErrMen := 'RFC asociado con otro Cliente.' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;
    IF(IFNULL(Par_OcupacionID, Entero_Cero)) = Entero_Cero THEN
    	SET Par_NumErr := 20;
		SET Par_ErrMen := 'La Ocupacion del Cliente esta Vacia.' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_LugarTrabajo, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 21;
		SET Par_ErrMen := 'El Lugar de Trabajo del Cliente esta vacia.' ;
		LEAVE ManejoErrores;
	END IF;
    IF(IFNULL(Par_Puesto, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 10;
		SET Par_ErrMen := 'El Puesto esta Vacio.' ;
		LEAVE ManejoErrores;
	END IF;
	IF(IFNULL(Par_TelTrabajo, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 22;
		SET Par_ErrMen := 'El Telefono del Trabajo esta Vacio.' ;
		LEAVE ManejoErrores;
	END IF;
    IF (Par_Clasificacion = EmpleadoNomina) THEN
		IF IFNULL(Par_NoEmpleado, Entero_Cero)= Entero_Cero THEN
        	SET Par_NumErr := 23;
			SET Par_ErrMen := 'El Numero de Empleado esta Vacio.' ;
			LEAVE ManejoErrores;
		END IF;
	ELSE
		SET Par_NoEmpleado	:= Entero_Cero;
	END IF;
    IF (Par_Clasificacion = EmpleadoNomina) THEN
		IF IFNULL(Par_TipoEmpleado, Cadena_Vacia)= Cadena_Vacia THEN
        	SET Par_NumErr := 23;
			SET Par_ErrMen := 'El Tipo de Empleado esta Vacio.' ;
			LEAVE ManejoErrores;
        END IF;
	ELSE
		SET Par_TipoEmpleado	:= Cadena_Vacia;
	END IF;
    IF (Par_Clasificacion = EmpleadoNomina) THEN
		IF IFNULL(Par_TipoPuesto, Entero_Cero)= Entero_Cero THEN
			SET Par_NumErr := 23;
			SET Par_ErrMen := 'El Tipo de Puesto esta Vacio.' ;
			LEAVE ManejoErrores;
        END IF;
	ELSE
		SET Par_TipoPuesto	:= Entero_Cero;
	END IF;

	IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 140;
		SET Par_ErrMen := 'El Estado Civil del Cliente esta Vacio.' ;
		LEAVE ManejoErrores;
	ELSE
		IF( Par_EstadoCivil != Soltero AND Par_EstadoCivil != CasadoBS AND
			Par_EstadoCivil != CasadoBM AND Par_EstadoCivil != CasadoBMC AND
			Par_EstadoCivil != Viudo AND Par_EstadoCivil != Divorciado AND
			Par_EstadoCivil != Separado AND Par_EstadoCivil != UnionLibre)THEN
			SET Par_NumErr := 141;
			SET Par_ErrMen := 'El Estado Civil del Cliente No Corresponde a los Valores Esperados.' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_PaisResidencia, Entero_Cero)) = Entero_Cero THEN
    	SET Par_NumErr := 142;
		SET Par_ErrMen := 'El Pais de Residencia esta Vacio.' ;
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_PaisResidencia
						LIMIT 1)THEN
			SET Par_NumErr := 144;
			SET Par_ErrMen := 'El Valor Indicado del Pais de Residencia No Existe.' ;
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Titulo, Cadena_Vacia)) = Cadena_Vacia THEN
    	SET Par_NumErr := 155;
		SET Par_ErrMen := 'El Titulo esta  Vacio.' ;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PromotorIni, Entero_Cero)) = Entero_Cero THEN
    	SET Par_NumErr := 156;
		SET Par_ErrMen := 'El Promotor Inicial esta Vacio.' ;
		LEAVE ManejoErrores;
	ELSE
	   IF NOT EXISTS(SELECT pro.PromotorID
					   FROM PROMOTORES pro,
							 SUCURSALES su
						   WHERE pro.PromotorID = Par_PromotorIni
							   AND pro.Estatus = Estatus_Activo
							   AND pro.SucursalID = su.SucursalID
						   LIMIT 1)THEN
			SET Par_NumErr := 157;
			SET Par_ErrMen := 'El Promotor Inicial Indicado No Existe.' ;
			LEAVE ManejoErrores;
	   END IF;
	END IF;

	IF(IFNULL(Par_PromotorAct, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 158;
		SET Par_ErrMen := 'El Promotor Actual esta Vacio.' ;
		LEAVE ManejoErrores;
	ELSE
	   IF NOT EXISTS(SELECT pro.PromotorID
					   FROM PROMOTORES pro,
							 SUCURSALES su
						   WHERE pro.PromotorID = Par_PromotorAct
							   AND pro.Estatus = Estatus_Activo
							   AND pro.SucursalID = su.SucursalID
						   LIMIT 1)THEN
			SET Par_NumErr := 159;
			SET Par_ErrMen := 'El Promotor Actual Indicado No Existe.' ;
			LEAVE ManejoErrores;
	   END IF;
	END IF;

	-- USO DE CLIENTESALT PARA INSERTAR NUEVO CLIENTE. Se modifica el llamado para incluir un parametro de entrada. Cardinal Sistemas Inteligentes
	CALL CLIENTESALT(
		 Par_SucursalOrigen,	Per_Fisica,			Par_Titulo,			Par_PrimerNombre,		Par_SegundoNombre,
		 Par_TercerNombre,		Par_ApPaterno,		Par_ApMaterno,		Par_FechaNaci,			Par_PaisNaci,
		 Par_Estado,			Par_Nacionalidad,	Par_PaisResidencia,	Par_Sexo,				Par_CURP,
		 Par_RFC,				Par_EstadoCivil, 	Par_TelCelular,		Par_Telefono,			Par_Mail,
		 Cadena_Vacia,			Entero_Cero,		Cadena_Vacia,		Entero_Cero,			Cadena_Vacia,
		 Par_OcupacionID,		Par_Puesto,			Par_LugarTrabajo,	Par_AntiguedadTra,		Cadena_Vacia,
		 Par_TelTrabajo,		Par_Clasificacion,	MotAper,			PagaISR,				PagaIVA,
		 PagaIDE,				NivelRiesgo,		Par_SectorGral,		Par_ActividadBMX,		Var_ActINEGI,
		 Var_SectorEco,			Var_ActFR,			Var_ActFOMUR,		Par_PromotorIni,		Par_PromotorAct,
		 Entero_Cero,			EsMenor,			Entero_Cero,		RegHacien,				Entero_Cero,
		 Entero_Cero,			Cadena_Vacia,		Par_NoEmpleado,		Par_TipoEmpleado,		Cadena_Vacia,
		 Par_ExtTelTrabajo,		Entero_Cero,		Entero_Cero,		Par_TipoPuesto,			Fecha_Vacia,
		 Entero_Cero,			Cadena_Vacia,		Entero_Cero,		Fecha_Vacia,			Entero_Cero,
		 Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,
		 Par_PaisNaci,			Par_EmpresaID,		SalidaNO,			Var_NumErr,				Var_MenErr,
		Var_ClienteID,			Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion
	);
	-- Fin de modificacion del llamado a CLIENTESALT. Cardinal Sistemas Inteligentes

	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_ClienteID	:= 00;
		SET Par_NumErr		:= CAST(Var_NumErr AS CHAR);
		SET Par_ErrMen 		:= Var_MenErr;
		LEAVE ManejoErrores;
	ELSE
		SET Par_NumErr		:= '00';
		SET Par_ErrMen		:= 'Cliente Agregado.';
	END IF;

	-- SE MANDA A LLAMAR A SP QUE CREA LA CUENTA DE AHORRO
	CALL CUENTASAHOALT(
		Par_SucursalOrigen,		Var_ClienteID, 		Cadena_Vacia,		Par_MonedaID,			Par_TipoCuentaID,
		Var_FechaSistema,		Par_Etiqueta,		Par_EdoCta,			Entero_Cero,			Par_EsPrincipal,
    	Cadena_Vacia,			Par_CuentaAho,		SalidaNO,			Var_NumErr,				Var_MenErr,
		Par_EmpresaID,			Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,    	Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion
	);
	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_ClienteID	:= 00;
		SET Par_NumErr		:= CAST(Var_NumErr AS CHAR);
		SET Par_ErrMen		:= Var_MenErr;
		LEAVE ManejoErrores;
	ELSE
		SET Par_NumErr	:= '00';
		SET Par_ErrMen	:= CONCAT('Cliente Agregado Exitosamente: ',Var_ClienteID) ;
	END IF;

END ManejoErrores;

IF Par_Salida = SalidaSI THEN
	SELECT
	 Par_NumErr		AS codigoRespuesta,
	 Par_ErrMen     AS mensajeRespuesta,
	 Var_ClienteID  AS clienteID;

END IF;

END TerminaStore$$