-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESOLWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESOLWSALT`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESOLWSALT`(
-- === SP para realizar alta de clientes mediante el WS de Alta de Clientes de Sana tus FinanzAS =====
    Par_PrimerNombre            VARCHAR(50), 	-- Primer Nombre del Cliente
    Par_SegundoNombre           VARCHAR(50),    -- Segundo Nombre del Cliente
    Par_TercerNombre            VARCHAR(50), 	-- Tercer Nombre del Cliente
	Par_ApPaterno	            VARCHAR(50), 	-- Apellido paterno del cliente
	Par_ApMaterno   			VARCHAR(50), 	-- Apellido materno del cliente

	Par_FechaNaci		  		DATE, 		 	-- Fecha de nacimiento
	Par_Titulo					VARCHAR(10), 	-- Titulo de Persona, SR. SRA. SRITA. PROF. CP. LIC. ING. DR.
	Par_RFC     				CHAR(13), 	 	-- RFC del cliente
	Par_CURP 				    CHAR(18), 	 	-- Curp del cliente
	Par_EstadoCivil 			CHAR(2), 	 	-- Curp del cliente

	Par_SucursalOrigen			INT(5),		 	-- ID Sucursal del Cliente
	Par_Mail      			    VARCHAR(50), 	-- Correo electrónico del cliente
	Par_PaisNaci				INT(11),		-- ID Lugar de nacimiento
	Par_EstadoNaci				INT(11),		-- ID Estado de Nacimiento
    Par_Nacionalidad            CHAR(1),     	-- Nacionalidad

	Par_PaisResidencia          INT(5),     	-- ID Pais de residencia del cliente
    Par_Sexo                    CHAR(1),     	-- Sexo del Cliente
	Par_Telefono                VARCHAR(20), 	-- Telefono oficial del cliente
	Par_SectorGral     		    INT(3),      	-- ID Sector General
	Par_ActividadBMX  			VARCHAR(15), 	-- ID Actividad BMX hace referencia a la tabla ACTIVIDADESBMX

	Par_ActividadFR  			BIGINT(20),  	-- ID Actividad FR hace referencia a la tabla ACTIVIDADESFR
	Par_PromotorIni		        INT(6),      	-- ID Promotor Actual
	Par_PromotorAct 			INT(6),      	-- ID Promotor Inicial
	Par_Numero 					INT, 	 		-- Numero -- Por le momento sin funcionalidad Se recibe Cero
	Par_TipoDireccion       	INT(11),     	-- Tipo de direccion

	Par_Estado	 				INT(11),     	-- ID Municipio donde vive el cliente
	Par_Municipio 				INT(11),     	-- ID Municipio donde vive el cliente
	Par_CodigoPostal 			CHAR(5),     	-- Codigo postal
	Par_Localidad 				INT(11),     	-- ID Localidad donde vive el vliente
	Par_Colonia 				INT(11),     	-- ID Colonia donde vive el cliente

	Par_Calle 					VARCHAR(50), 	-- Nombre de la calle
	Par_NumDireccion 		    CHAR(10),    	-- Numero de la vivienda del cliente
	Par_DirOficial 				VARCHAR(1),  	-- Si la direccion es la oficial
	Par_NumIdenti	 	     	VARCHAR(30), 	-- Folio de la Identificación proporcionada
	Par_TipoIdenti	 		    INT(11),     	-- Tipo de identificación

	Par_EsOficial 				VARCHAR(1),  	-- Si la identificación es oficial
	Par_FechaExp                DATE,        	-- Fecha de Expedicion de la identificación
	Par_FechaVen                DATE,        	-- Fecha de vencimiento de la identificación
	Par_PriNombreConyu			VARCHAR(25), 	-- Primer Nombre del Conyuge
	Par_SegNombreConyu			VARCHAR(25), 	-- Primer Nombre del Conyuge

	Par_TerNombreConyu			VARCHAR(25), 	-- Primer Nombre del Conyuge
	Par_ApPaternoConyu          VARCHAR(30), 	-- Apellido paterno del cliente
	Par_ApMaternoConyu 			VARCHAR(30), 	-- Apellido materno del cliente
	Par_NacionConyu				CHAR(1),     	-- Nacionalidad del Conyuge
	Par_PaisNacConyu			INT(11),		-- Lugar de nacimiento del Conyuge

	Par_EstadoNacConyu			INT(11),		-- Estado de Nacimiento del Conyuge
	Par_FecNacConyu				DATE, 		 	-- Fecha de nacimiento del Conyuge
	Par_RFCConyu				VARCHAR(13), 	-- RFC del Conyuge
	Par_TipoIdentiConyu			INT(11),     	-- Tipo de identificación
	Par_NumIdentiConyu			VARCHAR(25), 	-- Folio de la Identificación proporcionada

    Par_Folio			        VARCHAR(20), 	-- Folio generado por el dispositivo
	Par_ClaveUsuario			VARCHAR(50), 	-- Clave del Usuario en SAFI
	Par_Dispositivo		        VARCHAR(40), 	-- Dispositivo del que se genera el movimiento (Por ahora no utilizado)

	Par_EmpresaID		        INT(11),
	Aud_Usuario			        INT(11),
	Aud_FechaActual		  		DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
		)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CodigoResp			VARCHAR(5);		-- Numero de Respuesta
	DECLARE Var_MensajeResp			VARCHAR(400);	-- Mensaje de Respuesta
	DECLARE Var_ActINEGI            INT;      		-- Numero de la Actividad INEGI
	DECLARE Var_ActFR            	BIGINT;  		-- Numero de la Actividad FR
	DECLARE Var_ActFOMUR            INT;  			-- Numero de la Actividad FOMUR
	DECLARE Var_SectorEco           INT;  			-- Numero del Sector Economico
	DECLARE Var_NumErr		        INT(11);		-- Numero de Error
	DECLARE Var_MenErr		        VARCHAR(400);	-- Mensaje de Error
	DECLARE Var_NomColonia          VARCHAR(200);	-- Nombre de la Colonia (domicilio)
	DECLARE Var_MaxCaracter			INT;			-- Numero maximo de carateres (identificaciones)
	DECLARE Var_FechaSis			DATE;			-- Fecha del Sistema

	-- Declaracion de Constantes
	DECLARE EmpresaID 				INT;
	DECLARE Aportacion				DECIMAL(14,2);
	DECLARE EsMenor					CHAR(1);
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Entero_Cero             INT;
	DECLARE Entero_Dos				INT;
	DECLARE Decimal_Cero	        DECIMAL(12,2);
	DECLARE Bigint_Cero     		BIGINT;
	DECLARE Fecha_Vacia             DATE;
	DECLARE Estatus_Activo	        CHAR(1);
	DECLARE Soltero 				CHAR(2);
	DECLARE CasadoBS 				CHAR(2);
	DECLARE CasadoBM 				CHAR(2);
	DECLARE CasadoBMC 				CHAR(2);
	DECLARE Viudo 					CHAR(2);
	DECLARE Divorciado 				CHAR(2);
	DECLARE Separado 				CHAR(2);
	DECLARE UnionLibre 				CHAR(2);
	DECLARE Per_Fisica     	    	CHAR(1);
	DECLARE Clasificacion           CHAR(1);
	DECLARE MotAper		            CHAR(1);
	DECLARE PagaISR                 CHAR(1);
	DECLARE PagaIVA                 CHAR(1);
	DECLARE PagaIDE                 CHAR(1);
	DECLARE NivelRiesgo             CHAR(1);
	DECLARE RegHacien           	CHAR(1);
	DECLARE SalidaSI                CHAR(1);
	DECLARE SalidaNO                CHAR(1);
	DECLARE Var_ClienteID           INT;
	DECLARE CorreoValido			VARCHAR(15);
	DECLARE MinRFC					INT;
	DECLARE MaxRFC					INT;
	DECLARE MinCURP					INT;
	DECLARE OcupacionOtros			INT;
	DECLARE MinCaracter				INT;
	DECLARE MaxCaracter				INT;
	DECLARE SimbInterrogacion		VARCHAR(1);
	DECLARE CodigoCliente			INT;
	DECLARE CodigoIdenti			INT;
	DECLARE CodigoDirec				INT;
	DECLARE CodigoConyuge			INT;
	DECLARE SiEsOficial				CHAR(1);
	DECLARE ConstanteNo				CHAR(1);
	DECLARE ERROR_PLD				INT(11);		# NUMERO DE ERROR DE PLD LISTAS NEGRAS, PAIS, PERS BLOQ
	DECLARE Var_PaisIDDom			INT(11);		-- País ID de la dirección
	DECLARE Var_AniosRes			INT(11);		-- Años de residencia

	-- Asignacion de Constantes
	SET EmpresaID			:= 1;			-- EmpresaID Valor por Default 1
	SET Aportacion			:= 0.0;			-- Aportacion del Socio	 Valor por Default 0.0
	SET EsMenor             := 'N'; 	    -- Socio es menor de edad, Valor por Default N
	SET Estatus_Activo	  	:= 'A';        	-- Estatud del usuario cuando está activo
	SET Cadena_Vacia        := ''; 			-- Cadena o String Vacio
	SET Entero_Cero         :=  0;			-- Entero en Cero
	SET Entero_Dos			:=  2;			-- Entero en Dos
	SET Decimal_Cero	    :=  0.00;   	-- Decimal en Cero
	SET	Fecha_Vacia		    := '1900-01-01';-- Fecha Vacia
	SET Bigint_Cero         :=  0;         	-- BigInt en Cero

	SET Soltero 			:= 'S';			-- Valor SOltero
	SET CasadoBS 			:= 'CS';		-- Casado Bienes Separados
	SET CasadoBM 			:= 'CM';		-- Casado Bienes Mancomunados
	SET CasadoBMC 			:= 'CC';		-- Casdo Bienes Mancomunados con Capitulacion
	SET Viudo 				:= 'V';			-- Valor Viudo
	SET Divorciado 			:= 'D';			-- Valor Divorciado
	SET Separado 			:= 'SE';		-- Valor Separado
	SET UnionLibre 			:= 'U';			-- Valor Unión Libre

	SET Per_Fisica			:= 'F';        	-- Tipo de persona FISICA por Default
	SET Clasificacion       := 'I';        	-- Clasificación
	SET MotAper        		:= '1';        	-- Motivo de apertura
	SET PagaISR             := 'N';        	-- Valor No paga ISR
	SET PagaIVA            	:= 'S';        	-- Valor si el cliente para IVA
	SET PagaIDE            	:= 'N';        	-- Valor No paga IDE
	SET NivelRiesgo        	:= 'B';        	-- Valor del riesgo
	SET RegHacien      		:= 'N';        	-- Valor si el cliente no está registrado en hacienda
	SET SalidaSI           	:= 'S';        	-- El Store SI genera una Salida
	SET	SalidaNO 	   	   	:= 'N';	      	-- El Store NO genera una Salida
	SET	Var_ClienteID     	:=  0;         	-- Valor que toma el ID del cliente para insertar en tabla direccliente e identificliente

	SET CorreoValido		:= '(.*)@(.*)\\.(.*)';	-- Expresion Regular, para Validar Email
	SET MinRFC				:= 10;			-- Numero de Caracateres minimo RFC Personas Fisicas (SIN HOMOCLAVE)
	SET MaxRFC				:= 13;			-- Numero de Caracateres maximo RFC Personas Fisicas (CON HOMOCLAVE)
	SET MinCURP				:= 18;			-- Numero de Caracateres para la CURP
	SET MinCaracter			:= 5;			-- Numero de Caracateres minimo para el Numero de Identificacion (CARTILLA, LICENCIA, CEDULA)
	SET MaxCaracter			:= 15;			-- Numero de Caracateres maximo para el Numero de Identificacion (CARTILLA, LICENCIA, CEDULA)

	SET CodigoCliente		:= 100;			-- SUFIJO para Codigo de Respuesa CLIENTESALT
	SET CodigoDirec			:= 200;			-- SUFIJO para Codigo de Respuesa DIRECCLIENTEALT
	SET CodigoIdenti		:= 300;			-- SUFIJO para Codigo de Respuesa IDENTIFICLIENTEALT
	SET CodigoConyuge		:= 400;			-- SUFIJO para Codigo de Respuesa SOCIODEMOCONYUGALT
	SET OcupacionOtros		:= 9999;		-- Tabla de OCUPACIONES: OTROS TRABAJADORES CON OCUPACIONES INSUFICIENTEMENTE ESPECIFICADAS
	SET SimbInterrogacion	:= '?';			-- Simbolo de interrogación
	SET SiEsOficial			:= 'S';			-- La direccion Si es oficial
	SET ConstanteNo			:= 'N';			-- Constante NO

	-- Asignacion de variables
	SET	Var_CodigoResp	   :=  '999';
	SET	Var_MensajeResp	   :=  'Transaccion Rechazada.';
	SET ERROR_PLD			:= 50;
	SET Var_PaisIDDom		:= 0;			-- Valor asignado por defecto
	SET Var_AniosRes		:= 0;			-- Valor asignado por defecto

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Var_CodigoResp  = '999';
			SET Var_MensajeResp = 'Error en la Base de Datos.';
		END;

	-- Validar Rol de Usuario
	IF(IFNULL(Par_ClaveUsuario, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '01';
		SET Var_MensajeResp		:= 'El Usuario que realiza la Operacion esta Vacio.';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT Usu.RolID
							FROM USUARIOS Usu,
								 PARAMETROSCAJA Par
								WHERE Usu.Clave = Par_ClaveUsuario
									AND Usu.RolID = Par.EjecutivoFR
									AND Usu.Estatus = Estatus_Activo
								LIMIT 1)THEN
			SET Var_CodigoResp		:= '02';
			SET Var_MensajeResp		:= 'El Usuario que realiza la Operacion no es Correcto.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Folio, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '03';
		SET Var_MensajeResp		:= 'El Folio de la Operacion esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Dispositivo, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '04';
		SET Var_MensajeResp		:= 'El Campo Dispositivo esta Vacio.';
		LEAVE ManejoErrores;
	END IF;

	-- ObtenciÃ³n Parametros Auditoria
	SET Aud_FechaActual		:= NOW();
	SET Aud_ProgramaID		:= CONCAT(Par_Folio," ",Par_Dispositivo);

	SELECT UsuarioID, 	SucursalUsuario
	  INTO Aud_Usuario, Aud_Sucursal
		FROM USUARIOS
			WHERE Clave = Par_ClaveUsuario
				AND Estatus = Estatus_Activo;

	SET Par_SegundoNombre   := REPLACE(Par_SegundoNombre, SimbInterrogacion, Cadena_Vacia);
	SET Par_TercerNombre    := REPLACE(Par_TercerNombre, SimbInterrogacion, Cadena_Vacia);
	SET Par_ApMaterno	  	:= REPLACE(Par_ApMaterno, SimbInterrogacion, Cadena_Vacia);
	SET Par_PrimerNombre    := RTRIM(LTRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia)));
	SET Par_SegundoNombre   := RTRIM(LTRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia)));
	SET Par_TercerNombre    := RTRIM(LTRIM(IFNULL(Par_TercerNombre, Cadena_Vacia)));
	SET Par_ApPaterno     	:= RTRIM(LTRIM(IFNULL(Par_ApPaterno, Cadena_Vacia)));
	SET Par_ApMaterno	  	:= RTRIM(LTRIM(IFNULL(Par_ApMaterno, Cadena_Vacia)));

	SET Par_PriNombreConyu  := RTRIM(LTRIM(IFNULL(Par_PriNombreConyu, Cadena_Vacia)));
	SET Par_SegNombreConyu  := RTRIM(LTRIM(IFNULL(Par_SegNombreConyu, Cadena_Vacia)));
	SET Par_TerNombreConyu  := RTRIM(LTRIM(IFNULL(Par_TerNombreConyu, Cadena_Vacia)));
	SET Par_ApPaternoConyu  := RTRIM(LTRIM(IFNULL(Par_ApPaternoConyu, Cadena_Vacia)));
	SET Par_ApMaternoConyu	:= RTRIM(LTRIM(IFNULL(Par_ApMaternoConyu, Cadena_Vacia)));

	SET Par_PrimerNombre	:= UPPER(Par_PrimerNombre);
	SET Par_SegundoNombre	:= UPPER(Par_SegundoNombre);
	SET Par_TercerNombre	:= UPPER(Par_TercerNombre);
	SET Par_ApPaterno		:= UPPER(Par_ApPaterno);
	SET Par_ApMaterno		:= UPPER(Par_ApMaterno);

	SET	Par_RFC				:= UPPER(Par_RFC);
	SET	Par_CURP			:= UPPER(Par_CURP);
	SET Par_Calle			:= UPPER(Par_Calle);
	SET Par_DirOficial		:= UPPER(Par_DirOficial);
	SET Par_NumIdenti		:= UPPER(Par_NumIdenti);
	SET	Par_Nacionalidad	:= UPPER(Par_Nacionalidad);
	SET Par_Sexo			:= UPPER(Par_Sexo);
	SET Par_EstadoCivil		:= UPPER(Par_EstadoCivil);
	SET Par_Titulo			:= UPPER(Par_Titulo);

	SET Par_PriNombreConyu	:= UPPER(Par_PriNombreConyu);
	SET Par_SegNombreConyu	:= UPPER(Par_SegNombreConyu);
	SET Par_TerNombreConyu	:= UPPER(Par_TerNombreConyu);
	SET Par_ApPaternoConyu	:= UPPER(Par_ApPaternoConyu);
	SET Par_ApMaternoConyu	:= UPPER(Par_ApMaternoConyu);

	SET Par_RFCConyu		:= UPPER(Par_RFCConyu);
	SET Par_NumIdentiConyu	:= UPPER(Par_NumIdentiConyu);

	SET Par_FechaExp 		:= IFNULL(Par_FechaExp, Fecha_Vacia);
	SET Par_FechaVen 		:= IFNULL(Par_FechaVen, Fecha_Vacia);
	SET Par_FecNacConyu 	:= IFNULL(Par_FecNacConyu, Fecha_Vacia);

	-- Fecha Actual
	SELECT FechaSistema INTO Var_FechaSis
		FROM PARAMETROSSIS;

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

	IF(IFNULL(Par_FechaNaci, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Var_CodigoResp		:= '138';
		SET Var_MensajeResp		:= 'La Fecha de Nacimiento esta Vaci­a.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CURP, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '139';
		SET Var_MensajeResp		:= 'La CURP del Cliente esta Vaci­a.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '140';
		SET Var_MensajeResp		:= 'El Estado Civil del Cliente esta Vaci­o.';
		LEAVE ManejoErrores;
	ELSE
		IF( Par_EstadoCivil != Soltero AND Par_EstadoCivil != CasadoBS AND
			Par_EstadoCivil != CasadoBM AND Par_EstadoCivil != CasadoBMC AND
			Par_EstadoCivil != Viudo AND Par_EstadoCivil != Divorciado AND
			Par_EstadoCivil != Separado AND Par_EstadoCivil != UnionLibre)THEN

			SET Var_CodigoResp		:= '141';
			SET Var_MensajeResp		:= 'El Estado Civil del Cliente No Corresponde a los Valores Esperados.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_PaisResidencia, Entero_Cero)) = Entero_Cero THEN
		SET Var_CodigoResp		:= '142';
		SET Var_MensajeResp		:= 'El Pais de Residencia esta Vaci­o.';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT PaisID FROM PAISES
						WHERE PaisID = Par_PaisResidencia
						LIMIT 1)THEN
			SET Var_CodigoResp		:= '144';
			SET Var_MensajeResp		:= 'El Valor Indicado del Pais de Residencia No Existe.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoDireccion, Entero_Cero)) = Entero_Cero THEN
		SET Var_CodigoResp		:= '145';
		SET Var_MensajeResp		:= 'El Tipo de Direccion esta Vacio.';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT TipoDireccionID
						FROM TIPOSDIRECCION
							WHERE TipoDireccionID = Par_TipoDireccion
							LIMIT 1)THEN
			SET Var_CodigoResp		:= '146';
			SET Var_MensajeResp		:= 'El Tipo de Direccion Indicado No Existe.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
					   WHERE EstadoID = Par_Estado
					   LIMIT 1)THEN
	  SET Var_CodigoResp      := '147';
	  SET Var_MensajeResp     := 'El Valor Indicado para el Estado No Existe.';
	  LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
					   WHERE MunicipioID = Par_Municipio
						   AND EstadoID = Par_Estado
						   LIMIT 1)THEN
	  SET Var_CodigoResp      := '148';
	  SET Var_MensajeResp     := 'El Municipio Indicado No Existe.';
	  LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Localidad, Entero_Cero)) = Entero_Cero THEN
		SET Var_CodigoResp		:= '149';
		SET Var_MensajeResp		:= 'La Localidad esta Vaci­a.';
		LEAVE ManejoErrores;
	ELSE
		IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
						WHERE LocalidadID = Par_Localidad
							AND EstadoID = Par_Estado
							AND MunicipioID = Par_Municipio
							LIMIT 1)THEN
			SET Var_CodigoResp		:= '150';
			SET Var_MensajeResp		:= 'El Valor Indicado para la Localidad No Existe.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
			   WHERE EstadoID = Par_Estado
				   AND MunicipioID = Par_Municipio
				   AND ColoniaID = Par_Colonia
				   LIMIT 1)THEN
	  SET Var_CodigoResp      := '151';
	  SET Var_MensajeResp     := 'El Valor Indicado para la Colonia No Existe.';
	  LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_DirOficial, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '152';
		SET Var_MensajeResp		:= 'El Campo Oficial esta Vaci­o.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_DirOficial, Cadena_Vacia)) != Cadena_Vacia THEN
		IF(Par_DirOficial != SiEsOficial AND Par_DirOficial != ConstanteNo)THEN
			SET Var_CodigoResp		:= '152';
			SET Var_MensajeResp		:= 'El Campo Oficial esta Vacio o no es valido.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoIdenti, Entero_Cero)) = Entero_Cero THEN
		SET Var_CodigoResp		:= '153';
		SET Var_MensajeResp		:= 'El Tipo de Identificacion esta Vaci­o.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EsOficial, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Var_CodigoResp		:= '154';
		SET Var_MensajeResp		:= 'El Campo EsOficial esta Vaci­o.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Titulo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Var_CodigoResp		:= '155';
			SET Var_MensajeResp		:= 'El Titulo esta Vaci­o.';
			LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_PromotorIni, Entero_Cero)) = Entero_Cero THEN
		  SET Var_CodigoResp      := '156';
		  SET Var_MensajeResp     := 'El Promotor Inicial esta Vacio.';
		  LEAVE ManejoErrores;
	ELSE
	   IF NOT EXISTS(SELECT pro.PromotorID
					   FROM PROMOTORES pro,
							 SUCURSALES su
						   WHERE pro.PromotorID = Par_PromotorIni
							   AND pro.Estatus = Estatus_Activo
							   AND pro.SucursalID = su.SucursalID
						   LIMIT 1)THEN
		  SET Var_CodigoResp      := '157';
		  SET Var_MensajeResp     := 'El Promotor Inicial Indicado No Existe.';
		  LEAVE ManejoErrores;
	   END IF;
	END IF;

	IF(IFNULL(Par_PromotorAct, Entero_Cero)) = Entero_Cero THEN
	   SET Var_CodigoResp      := '158';
	   SET Var_MensajeResp     := 'El Promotor Actual esta Vaci­o.';
	   LEAVE ManejoErrores;
	ELSE
	   IF NOT EXISTS(SELECT pro.PromotorID
					   FROM PROMOTORES pro,
							 SUCURSALES su
						   WHERE pro.PromotorID = Par_PromotorAct
							   AND pro.Estatus = Estatus_Activo
							   AND pro.SucursalID = su.SucursalID
						   LIMIT 1)THEN
		  SET Var_CodigoResp      := '159';
		  SET Var_MensajeResp     := 'El Promotor Actual Indicado No Existe.';
		  LEAVE ManejoErrores;
	   END IF;
	END IF;

	-- FECHA EXPEDICION (controlada IDENTIFICLIENTEALT)
	SELECT NumeroCaracteres,Oficial INTO Var_MaxCaracter, Par_EsOficial
		FROM TIPOSIDENTI
			WHERE TipoIdentiID = Par_TipoIdenti;

	-- ELECTOR -- PASAPORTE
	IF(Par_TipoIdenti <= Entero_Dos)THEN
		IF(CHARACTER_LENGTH(Par_NumIdenti) != Var_MaxCaracter)THEN
			SET Var_CodigoResp		:= '160';
			SET Var_MensajeResp		:= CONCAT('Se requieren ',Var_MaxCaracter, ' Caracteres para el Numero de Identificacion.');
			LEAVE ManejoErrores;
		END IF;
	ELSE
		-- CARTILLA,LICENCIA,CEDULA
		IF(CHARACTER_LENGTH(Par_NumIdenti) < MinCaracter)THEN
			SET Var_CodigoResp		:= '161';
			SET Var_MensajeResp		:= 'Se requieren Minimo 5 Caracteres para el Numero de Identificacion.';
			LEAVE ManejoErrores;
		ELSE
			IF(CHARACTER_LENGTH(Par_NumIdenti) > MaxCaracter)THEN
				SET Var_CodigoResp		:= '162';
				SET Var_MensajeResp		:= 'Se requieren Maximo 15 Caracteres para el Numero de Identificacion.';
				LEAVE ManejoErrores;
			END IF;
		END IF;

	END IF;

	IF(DATEDIFF(Var_FechaSis, Par_FechaNaci) < Entero_Cero)THEN
			SET Var_CodigoResp		:= '163';
			SET Var_MensajeResp		:= 'La Fecha de Nacimiento es Mayor a la Fecha Actual.';
			LEAVE ManejoErrores;
	END IF;

	IF(CHARACTER_LENGTH(Par_CURP) != MinCURP)THEN
			SET Var_CodigoResp		:= '164';
			SET Var_MensajeResp		:= 'Se requieren 18 Caracteres para la CURP.';
			LEAVE ManejoErrores;
		END IF;

	-- VALIDA LONGITUD RFC
	IF(IFNULL(Par_RFC, Cadena_Vacia)) <> Cadena_Vacia THEN
		IF(CHARACTER_LENGTH(Par_RFC) != MinRFC AND CHARACTER_LENGTH(Par_RFC) != MaxRFC)THEN
			SET Var_CodigoResp		:= '165';
			SET Var_MensajeResp		:= 'La Longitud del RFC es incorrecta';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- VALIDACION DE CORREO
	IF(IFNULL(Par_Mail, Cadena_Vacia)) <> Cadena_Vacia THEN
		IF(Par_Mail NOT REGEXP CorreoValido)THEN
			SET Var_CodigoResp		:= '166';
			SET Var_MensajeResp		:= 'La Direccion de Correo es Invalida';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- USO DE CLIENTESALT PARA INSERTAR NUEVO CLIENTE. Se modifica el llamado para incluir un parametro de entrada. Cardinal Sistemas Inteligentes
	CALL CLIENTESALT(
		 Par_SucursalOrigen,	Per_Fisica,			Par_Titulo,			Par_PrimerNombre,		Par_SegundoNombre,
		 Par_TercerNombre,		Par_ApPaterno,		Par_ApMaterno,		Par_FechaNaci,			Par_PaisNaci,
		 Par_EstadoNaci,		Par_Nacionalidad,	Par_PaisResidencia,	Par_Sexo,				Par_CURP,
		 Par_RFC,				Par_EstadoCivil, 	Cadena_Vacia,		Par_Telefono,			Par_Mail,
		 Cadena_Vacia,			Entero_Cero,		Cadena_Vacia,		Entero_Cero,			Cadena_Vacia,
		 OcupacionOtros,		Cadena_Vacia,		Cadena_Vacia,		Decimal_Cero,			Cadena_Vacia,
		 Cadena_Vacia,			Clasificacion,		MotAper,			PagaISR,				PagaIVA,
		 PagaIDE,				NivelRiesgo,		Par_SectorGral,		Par_ActividadBMX,		Var_ActINEGI,
		 Var_SectorEco,			Var_ActFR,			Var_ActFOMUR,		Par_PromotorIni,		Par_PromotorAct,
		 Entero_Cero,			EsMenor,			Entero_Cero,		RegHacien,				Entero_Cero,
		 Entero_Cero,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,
		 Cadena_Vacia,			Entero_Cero,		Entero_Cero,		Entero_Cero,			Fecha_Vacia,
		 Entero_Cero,			Cadena_Vacia,		Entero_Cero,		Fecha_Vacia,			Entero_Cero,
		 Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,
		 Par_PaisNaci,			EmpresaID,			SalidaNO,			Var_NumErr,				Var_MenErr,
		 Var_ClienteID,			Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
		 Aud_Sucursal,			Aud_NumTransaccion
	);
	-- Fin de modificacion del llamado a CLIENTESALT. Cardinal Sistemas Inteligentes

	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) = ERROR_PLD) THEN
		SET Var_ClienteID		:= 00;
		SET Var_CodigoResp		:= (Var_NumErr);
		SET Var_MensajeResp		:= Var_MenErr;
		LEAVE ManejoErrores;
	ELSEIF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_ClienteID		:= 00;
		SET Var_CodigoResp		:= (CodigoCliente +Var_NumErr);
		SET Var_MensajeResp		:= Var_MenErr;
		LEAVE ManejoErrores;
	END IF;

	SET Var_NomColonia := (SELECT Asentamiento FROM COLONIASREPUB
				WHERE EstadoID = Par_Estado
				AND MunicipioID = Par_Municipio
				AND ColoniaID = Par_Colonia
				LIMIT 1);

	SET Par_Calle	:= UPPER(Par_Calle);

	CALL DIRECCLIENTEALT(
		 Var_ClienteID,    Par_TipoDireccion,	Par_Estado,			Par_Municipio,       Par_Localidad,
		 Par_Colonia,      Var_NomColonia,		Par_Calle,			Par_NumDireccion,    Cadena_Vacia,
		 Cadena_Vacia,     Cadena_Vacia,		Cadena_Vacia,		Par_CodigoPostal,	 Cadena_Vacia,
		 Cadena_Vacia,		Cadena_Vacia,		Par_DirOficial,		ConstanteNo,		 EmpresaID,
		 Cadena_Vacia,     Cadena_Vacia,		Cadena_Vacia,		Var_PaisIDDom,		Var_AniosRes,
		 SalidaNO,			Var_NumErr,			Var_MenErr,			Aud_Usuario,      	Aud_FechaActual,
		 Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_ClienteID		:= 00;
		SET Var_CodigoResp		:= (CodigoDirec +Var_NumErr);
		SET Var_MensajeResp		:= Var_MenErr;
		LEAVE ManejoErrores;
	END IF;

	-- USO DE IDENTIFICLIENTEALT PARA INSERTAR NUEVA IDENTIFICACION
	CALL IDENTIFICLIENTEALT(
		Var_ClienteID,         Par_TipoIdenti,      Par_EsOficial,         Par_NumIdenti,   Par_FechaExp,
		Par_FechaVen,          EmpresaID,        	SalidaNO,              Var_NumErr,      Var_MenErr,
		Aud_Usuario,           Aud_FechaActual,     Aud_DireccionIP,       Aud_ProgramaID,  Aud_Sucursal,
		Aud_NumTransaccion);

	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_ClienteID		:= 00;
		SET Var_CodigoResp		:= (CodigoIdenti +Var_NumErr);
		SET Var_MensajeResp		:= Var_MenErr;
		LEAVE ManejoErrores;
	END IF;

	-- ALTA DE DATOS DE CONYUGE
	-- SOLO SI EL CLIENTE ES CASADO O VIVE EN UNION LIBRE
	IF( (Par_EstadoCivil = CasadoBS) OR (Par_EstadoCivil = CasadoBM) OR
		(Par_EstadoCivil = CasadoBMC) OR (Par_EstadoCivil = UnionLibre) )THEN

		SELECT NumeroCaracteres INTO Var_MaxCaracter
			FROM TIPOSIDENTI
				WHERE TipoIdentiID = Par_TipoIdentiConyu;

		-- ELECTOR -- PASAPORTE
		IF(Par_TipoIdentiConyu <= Entero_Dos)THEN
			IF(CHARACTER_LENGTH(Par_NumIdentiConyu) != Var_MaxCaracter)THEN
				SET Var_CodigoResp		:= '167';
				SET Var_MensajeResp		:= CONCAT('Se requieren ',Var_MaxCaracter, ' Caracteres para el Nomero de Identificacion del Conyuge.');
				LEAVE ManejoErrores;
			END IF;
		ELSE
			-- CARTILLA,LICENCIA,CEDULA
			IF(CHARACTER_LENGTH(Par_NumIdentiConyu) < MinCaracter)THEN
				SET Var_CodigoResp		:= '168';
				SET Var_MensajeResp		:= 'Se requieren Minimo 5 Caracteres para el Numero de Identificacion del Conyuge.';
				LEAVE ManejoErrores;
			ELSE
				IF(CHARACTER_LENGTH(Par_NumIdentiConyu) > MaxCaracter)THEN
					SET Var_CodigoResp		:= '169';
					SET Var_MensajeResp		:= 'Se requieren Maximo 15 Caracteres para el Numero de Identificacion del Conyuge.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;

		IF(DATEDIFF(Var_FechaSis, Par_FecNacConyu) < Entero_Cero)THEN
				SET Var_CodigoResp		:= '170';
				SET Var_MensajeResp		:= 'La Fecha de Nacimiento del Conyuge es Mayor a la Fecha Actual.';
				LEAVE ManejoErrores;
		END IF;

		CALL SOCIODEMOCONYUGALT(
			Entero_Cero,			Var_ClienteID,		Entero_Cero,		Par_PriNombreConyu,		Par_SegNombreConyu,
			Par_TerNombreConyu,		Par_ApPaternoConyu,	Par_ApMaternoConyu,	Par_NacionConyu,		Par_PaisNacConyu,
			Par_EstadoNacConyu, 	Par_FecNacConyu, 	Par_RFCConyu, 		Par_TipoIdentiConyu, 	Par_NumIdentiConyu,
			Fecha_Vacia,			Fecha_Vacia,		Cadena_Vacia,		Entero_Cero,			Cadena_Vacia,
			Entero_Cero,			Entero_Cero,		Entero_Cero,		Entero_Cero,			Cadena_Vacia,
			Cadena_Vacia,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,
			Cadena_Vacia,			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,			Fecha_Vacia,
			SalidaNO,				Var_NumErr,			Var_MenErr,			EmpresaID,				Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
			SET Var_ClienteID		:= 00;
			SET Var_CodigoResp		:= (CodigoConyuge +Var_NumErr);
			SET Var_MensajeResp		:= Var_MenErr;
			LEAVE ManejoErrores;
		END IF;

	END IF;

	IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
		SET Var_ClienteID		:= 00;
		SET Var_CodigoResp		:= CAST(Var_NumErr AS CHAR);
		SET Var_MensajeResp		:= Var_MenErr;
		LEAVE ManejoErrores;
	ELSE
		SET Var_CodigoResp		:= '00';
		SET Var_MensajeResp		:= 'Cliente Agregado.';
	END IF;

END ManejoErrores;

# =========================== LANZA VALORES DE RESPUESTA ===========================
SELECT
	 Var_CodigoResp 	  	    AS codigoRespuesta,
	 Var_MensajeResp         	AS mensajeRespuesta,
	 Var_ClienteID              AS clienteID;

END TerminaStore$$