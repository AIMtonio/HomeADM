-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECTIVOSVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECTIVOSVAL`;

DELIMITER $$
CREATE PROCEDURE `DIRECTIVOSVAL`(
/** ***** STORE ENCARGADO DE VALIDAR DE ALTA/MODIFICACION DE LA TABLA DIRECTIVOS ***** */
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

	Par_ColoniaID           INT(11),        -- Campo Disponible para Accionista de Tipo Persona Moral: Colonia de la Compania del Accionista
	Par_NombreCiudad        VARCHAR(40),    -- Campo Disponible para Accionista de Tipo Persona Moral: Nombre de la Ciudad de la Compania del Accionista
	Par_CodigoPostal        VARCHAR(5),     -- Campo Disponible para Accionista de Tipo Persona Moral: Codigo Postal de la Ciudad de la Compania del Accionista
	Par_EdoExtranjero       VARCHAR(40),    -- Campo Disponible para Accionista de Tipo Persona Moral: Estado Extranjero de la Compania del Accionista
	INOUT Par_NombreCompleto  VARCHAR(200),	-- Nombre Completo

	INOUT Par_NumeroCliente BIGINT(12),		-- Numero de Participante
	INOUT Par_TipoPMoral	VARCHAR(200),	-- Tipo de Persona
	INOUT Par_Control		VARCHAR(200),	-- Control de Salida
	Par_NumeroValidacion	TINYINT UNSIGNED,-- Numero de Validacion

	Par_Salida				CHAR(1),		-- Salida SI.
	INOUT Par_NumErr 		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Fecha_Actual	DATE;		-- Fecha Actual
	DECLARE Var_PaisID			INT(11);	-- ID de Pais
	DECLARE Var_EstadoID		INT(11);	-- ID de Estado
	DECLARE Var_AnioAct			INT(11);	-- Anio Actual
	DECLARE Var_MesAct			INT(11);	-- Mes Actual

	DECLARE Var_DiaAct			INT(11);	-- Dia Actual
	DECLARE Var_AnioNac			INT(11);	-- Anio Nacimiento
	DECLARE Var_MesNac			INT(11);	-- Mes Nacimiento
	DECLARE Var_DiaNac			INT(11);	-- Dia de Nacimiento
	DECLARE Var_Anios			INT(11);	-- Numero de Anio

	DECLARE Var_MunicipioID		INT(11);	-- ID de Municipio
	DECLARE Var_ColoniaID 		INT(11);	-- ID de Colonia
	DECLARE Var_TipoPersonaCta	CHAR(1);	-- Tipo de Persona de la Cuenta de Ahorro
	DECLARE Var_CodigoPostal 	VARCHAR(15);-- Codigo de Postal
	DECLARE Var_CliProcEspecifico VARCHAR(10);-- Numero de Cliente Especifico
	DECLARE Var_EsAccionistaMoral CHAR(1);	-- Es Accionista Moral

	DECLARE Var_PorAntAcc		DECIMAL(12,4);-- Porcentaje de Accionista
	DECLARE Var_SumaPorAcc		DECIMAL(12,4);-- Sumatoria de Acciones

	-- Declaracion de Validaciones
	DECLARE Val_DirectivoAlt 	TINYINT UNSIGNED;-- Numero de Validacion 1.- Alta de Directivo
	DECLARE Val_DirectivoMod 	TINYINT UNSIGNED;-- Numero de Validacion 2.- Modificacion de Directivo

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;		-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero
	DECLARE PaisMexico			INT(11);	-- Constante Pais de Mexico
	DECLARE Decimal_Cero		DECIMAL(12,2);-- Constante Decimal Cero

	DECLARE Con_SI				CHAR(1);	-- Constante SI
	DECLARE Fisica				CHAR(1);	-- Constante Persona Fisica
	DECLARE Moral				CHAR(1);	-- Constante Persona Moral
	DECLARE FisicaAct			CHAR(1);	-- Constante Persona Fisica Con Actividad Empresarial
	DECLARE Gobierno			CHAR(1);	-- Constante Persona Gobierno

	DECLARE Extranjero			CHAR(1);	-- Constante Extranjero
	DECLARE Con_NO 				CHAR(1);	-- Constante NO
	DECLARE Cli_SofiExpress		VARCHAR(10);-- Numero de Cliente de Sofiexpress

	-- Asignacion de Validaciones
	SET Val_DirectivoAlt		:= 1;
	SET Val_DirectivoMod		:= 2;

	--  Asignacion De Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET PaisMexico				:= 700;
	SET Decimal_Cero			:= 0.0;

	SET Con_SI					:= 'S';
	SET Fisica					:= 'F';
	SET Moral					:= 'M';
	SET FisicaAct				:= 'A';
	SET Gobierno				:= 'G';

	SET Extranjero				:= 'E';
	SET Con_NO 					:= 'N';
	SET Var_SumaPorAcc			:= 0.0;
	SET Var_PorAntAcc 			:= 0.0;
	SET Cli_SofiExpress			:= '15';

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
								' esto le ocasiona. Ref: SP-DIRECTIVOSVAL');
				SET Par_Control := 'SQLEXCEPTION';
			END;

		SET Var_CliProcEspecifico := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico' LIMIT 1);

		-- /***** PARA CALCULAR LA EDAD **************
		SET Var_Fecha_Actual := (SELECT FechaSistema
								 FROM PARAMETROSSIS
								 WHERE EmpresaID = 1);

		SET Var_EsAccionistaMoral := Con_NO;

		-- Se obtiene el tipo de Persona
		IF(Par_RelacionadoID > Entero_Cero)THEN
			SET Var_TipoPersonaCta := ( SELECT Cli.TipoPersona
										FROM CLIENTES Cli
										WHERE Cli.ClienteID = Par_RelacionadoID
										LIMIT 1);
		ELSE

			SET Var_TipoPersonaCta := Fisica;
			-- Si es accionista, se asigna el valor del tipo de persona
			IF( Par_EsAccionista = Con_SI) THEN
				SET Var_TipoPersonaCta := Par_TipoAccionista;

				-- SI es Accionista y es Moral se asigna el valor a S
				IF( Par_EsAccionista = Con_SI AND Par_TipoAccionista = Moral ) THEN
					SET Var_EsAccionistaMoral := Con_SI;
				END IF;

			END IF;

		END IF;


		SET Var_AnioAct := YEAR(Var_Fecha_Actual);
		SET Var_MesAct  := MONTH(Var_Fecha_Actual);
		SET Var_DiaAct  := DAY(Var_Fecha_Actual);
		SET Var_AnioNac := YEAR(Par_FechaNac);
		SET Var_MesNac  := MONTH(Par_FechaNac);
		SET Var_DiaNac  := DAY(Par_FechaNac);
		SET Var_Anios   := Var_AnioAct-Var_AnioNac;

		IF(Var_MesAct<Var_MesNac) THEN
			SET Var_Anios := Var_Anios-1;
		END IF;

		IF(Var_MesAct = Var_MesNac)THEN
			IF(Var_DiaAct<Var_DiaNac) THEN
				SET Var_Anios := Var_Anios-1;
			END IF;
		END IF;

		-- Validacion para el Alta de un Directivo
		IF( Par_NumeroValidacion = Val_DirectivoAlt ) THEN

			IF((IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) AND (IFNULL(Par_GaranteID,Entero_Cero) = Entero_Cero) AND (IFNULL(Par_AvalID,Entero_Cero) = Entero_Cero))  THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'Capture un Aval, Garante o un Cliente';
				SET Par_Control := 'numCliente';
				LEAVE ManejoErrores;
			END IF;

			IF( IFNULL(Par_CargoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'El Cargo esta Vacio.';
				SET Par_Control := 'cargoID';
				LEAVE ManejoErrores;
			END IF;

			-- Si es Accionista Moral no se evalua
			IF( Var_EsAccionistaMoral = Con_NO ) THEN

				-- Validaciones para peronas fisicas y pfae
				IF(Var_TipoPersonaCta <> Moral) THEN
					IF( IFNULL(Par_Titulo, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 003;
						SET Par_ErrMen  := 'El Titulo esta Vacio.';
						SET Par_Control := 'titulo';
						LEAVE ManejoErrores;
					END IF;

					IF( IFNULL(Par_PrimerNom, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 004;
						SET Par_ErrMen  := 'El Primer Nombre esta Vacio.';
						SET Par_Control := 'cuentaAhoID';
						LEAVE ManejoErrores;
					END IF;

					IF( IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 005;
						SET Par_ErrMen  := 'Se requiere al menos uno de los Apellidos.';
						SET Par_Control := 'apellidoParterno';
						LEAVE ManejoErrores;
					END IF;

					IF( IFNULL(Par_FechaNac, Fecha_Vacia) = Fecha_Vacia ) THEN
						SET Par_NumErr  := 006;
						SET Par_ErrMen  := 'La fecha de Nacimiento esta Vacia.';
						SET Par_Control := 'fechaNacimiento';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF( IFNULL(Par_Nacion, Cadena_Vacia) = Cadena_Vacia ) THEN
				SET Par_NumErr  := 007;
				SET Par_ErrMen  := 'La Nacionalidad esta vacia.';
				SET Par_Control := 'Nacion';
				LEAVE ManejoErrores;
			END IF;

			-- Si es Accionista Moral no se evalua
			IF( Var_EsAccionistaMoral = Con_NO ) THEN
				IF(Var_Anios >= 18)THEN
					IF((IFNULL(Par_TipoIdentiID, Entero_Cero)= Entero_Cero) AND (IFNULL(Par_RelacionadoID , Entero_Cero) <> Entero_Cero)) THEN
						SET Par_NumErr  := 008;
						SET Par_ErrMen  := 'El Tipo de Identificacion esta Vacio';
						SET Par_Control := 'tipoIdentiID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Si es apoderado Legal, se solicitan los datos de la escritura publica.
			IF( Par_EsApoderado= Con_SI )THEN

				IF( IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 009;
					SET Par_ErrMen  := 'El Estado esta Vacio.';
					SET Par_Control := 'estadoID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_MunicipioID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 010;
					SET Par_ErrMen  := 'El Municipio esta Vacio.';
					SET Par_Control := 'municipioID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_NumEscPub, Cadena_Vacia) = Cadena_Vacia ) THEN
					SET Par_NumErr  := 011;
					SET Par_ErrMen  := 'El Numero de Escritura Publica esta Vacio.';
					SET Par_Control := 'numEscPub';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_FechaEscPub, Fecha_Vacia) = Fecha_Vacia ) THEN
					SET Par_NumErr  := 012;
					SET Par_ErrMen  := 'La Fecha de Escritura Publica esta Vacia.';
					SET Par_Control := 'fechaEscPub';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_NotariaID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 013;
					SET Par_ErrMen  := 'La Notaria esta Vacia.';
					SET Par_Control := 'notariaID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_TitularNotaria, Cadena_Vacia) = Cadena_Vacia ) THEN
					SET Par_NumErr  := 014;
					SET Par_ErrMen  := 'El Titular de Notaria esta Vacio.';
					SET Par_Control := 'titularNotaria';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_TipoPersonaCta <> Moral AND Par_OcupacionID <> 9999 AND Par_GaranteRelacion = Entero_Cero ) THEN
					IF( IFNULL(Par_PuestoA, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 015;
						SET Par_ErrMen  := 'El Puesto esta Vacio.';
						SET Par_Control := 'puestoA';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;


			IF(Var_TipoPersonaCta = Fisica) THEN
				IF( IFNULL(Par_OcupacionID, Cadena_Vacia) = Cadena_Vacia ) THEN
					SET Par_NumErr  := 016;
					SET Par_ErrMen  := 'La ocupacion esta vacia.';
					SET Par_Control := 'ocupacionID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Var_TipoPersonaCta = Fisica) THEN
				IF( IFNULL(Par_PaisNac, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 017;
					SET Par_ErrMen  := 'El Pais Especificado como el Lugar de Nacimiento esta Vacio.';
					SET Par_Control := 'paisNacimiento';
					LEAVE ManejoErrores;
				ELSE

					SELECT PaisID
					INTO Var_PaisID
					FROM PAISES
					WHERE PaisID = Par_PaisNac;

					IF( IFNULL(Var_PaisID, Entero_Cero) = Entero_Cero ) THEN
						SET Par_NumErr  := 018;
						SET Par_ErrMen  := 'El Pais Especificado como el Lugar de Nacimiento no existe.';
						SET Par_Control := 'paisNacimiento';
						LEAVE ManejoErrores;
					ELSE
						IF( Var_PaisID = PaisMexico ) THEN

							SELECT EstadoID
							INTO Var_EstadoID
							FROM ESTADOSREPUB
							WHERE EstadoID = Par_EdoNac;

							IF( IFNULL(Var_EstadoID, Entero_Cero) = Entero_Cero ) THEN
								SET Par_NumErr  := 019;
								SET Par_ErrMen  := 'El estado especificado como Entidad Federativa no existe.';
								SET Par_Control := 'edoNacimiento';
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			IF( Var_EsAccionistaMoral = Con_NO) THEN
				IF( Var_TipoPersonaCta = Moral) THEN
					SET Par_NumErr  := 020;
					SET Par_ErrMen  := 'Solo Personas Fisica';
					SET Par_Control := 'directivoID';
					LEAVE ManejoErrores;

				ELSE
					SET Par_NombreCompleto :=
						CONCAT(RTRIM(LTRIM(IFNULL(Par_PrimerNom, ''))),
						   CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_SegundoNom,  '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_SegundoNom,  '')))) ELSE '' END,
						   CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_TercerNom,   '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_TercerNom,   '')))) ELSE '' END,
						   CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApellidoPat, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApellidoPat, '')))) ELSE '' END,
						   CASE WHEN CHAR_LENGTH(RTRIM(LTRIM(IFNULL(Par_ApellidoMat, '')))) > 0 THEN CONCAT(" ", RTRIM(LTRIM(IFNULL(Par_ApellidoMat, '')))) ELSE '' END);
				END IF;
			ELSE
				SET Par_NombreCompleto := Par_NombreCompania;
			END IF;

			SET Par_NombreCompleto := IFNULL(Par_NombreCompleto, Cadena_Vacia);
			SET Par_NumeroCliente := Entero_Cero;

			-- Validacion de Cliente
			IF(IFNULL(Par_ClienteID, Entero_Cero)) <> Entero_Cero THEN

				SET Par_TipoPMoral:= 'Cliente';
				IF( IFNULL(Par_RelacionadoID, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.ClienteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND IFNULL(Dir.RelacionadoID,Entero_Cero) = IFNULL(Par_RelacionadoID,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_GaranteRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.ClienteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND IFNULL(Dir.GaranteRelacion,Entero_Cero) = IFNULL(Par_GaranteRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_AvalRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.ClienteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND IFNULL(Dir.AvalRelacion,Entero_Cero) = IFNULL(Par_AvalRelacion,Entero_Cero)
					LIMIT 1;
				END IF;
			END IF;

			-- Validacion de Garante
			IF(IFNULL(Par_GaranteID, Entero_Cero)) <> Entero_Cero THEN

				SET Par_TipoPMoral:= 'Garante';
				IF( IFNULL(Par_RelacionadoID, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.GaranteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND IFNULL(Dir.RelacionadoID,Entero_Cero) = IFNULL(Par_RelacionadoID,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_GaranteRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.GaranteID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND IFNULL(Dir.GaranteRelacion,Entero_Cero) = IFNULL(Par_GaranteRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_AvalRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.GaranteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND IFNULL(Dir.AvalRelacion,Entero_Cero) = IFNULL(Par_AvalRelacion,Entero_Cero)
					LIMIT 1;
				END IF;
			END IF;

			-- Validacion de Aval
			IF(IFNULL(Par_AvalID, Entero_Cero)) <> Entero_Cero THEN

				SET Par_TipoPMoral:= 'Aval';
				IF( IFNULL(Par_RelacionadoID, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.AvalID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND IFNULL(Dir.RelacionadoID,Entero_Cero) = IFNULL(Par_RelacionadoID,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_GaranteRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.AvalID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND IFNULL(Dir.GaranteRelacion,Entero_Cero) = IFNULL(Par_GaranteRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_AvalRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.AvalID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND IFNULL(Dir.AvalRelacion,Entero_Cero) = IFNULL(Par_AvalRelacion,Entero_Cero)
					LIMIT 1;
				END IF;
			END IF;

			IF( IFNULL(Par_NumeroCliente,Entero_Cero) != Entero_Cero) THEN
				SET Par_NumErr  := 021;
				SET Par_ErrMen  := CONCAT('El Directivo ya esta relacionado al ',Par_TipoPMoral,': ',Par_NumeroCliente);
				SET Par_Control := 'directivoID';
				LEAVE ManejoErrores;
			END IF;

			IF( IFNULL(Par_Nacion, Cadena_Vacia) = Extranjero AND Par_RelacionadoID <> Entero_Cero ) THEN
				IF(IFNULL( Par_PaisRFC, Entero_Cero) = Entero_Cero) THEN
					SET Par_NumErr  := 022;
					SET Par_ErrMen  := 'El Pais de Registro de RFC No Existe';
					SET Par_Control := 'paisRFC';
					LEAVE ManejoErrores;
				ELSE
					IF NOT EXISTS(SELECT PaisID FROM PAISES
								  WHERE PaisID = Par_PaisRFC)THEN
						SET Par_NumErr  := 023;
						SET Par_ErrMen  := 'El Pais de Registro de RFC No Existe';
						SET Par_Control := 'paisRFC';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			ELSE
				SET Par_PaisRFC := PaisMexico;
			END IF;

			IF(Par_EsAccionista = Con_SI) THEN

				IF( Par_TipoAccionista = Cadena_Vacia ) THEN
					SET Par_NumErr  := 024;
					SET Par_ErrMen  := 'El Tipo de Accionista esta Vacio.';
					SET Par_Control := 'tipoAccionista';
				END IF;

				IF( Par_TipoAccionista NOT IN (Fisica, Moral, FisicaAct, Gobierno)) THEN
					SET Par_NumErr  := 025;
					SET Par_ErrMen  := 'El Tipo de Accionista no es Valido.';
					SET Par_Control := 'tipoAccionista';
				END IF;

				IF(Par_PorcentajeAcc = Decimal_Cero OR Par_PorcentajeAcc > 100) THEN
					SET Par_NumErr  := 026;
					SET Par_ErrMen  := 'El Porcentaje de Acciones debe ser mayor a Cero y menor de 100.';
					SET Par_Control := 'porcentajeAccion';
					LEAVE ManejoErrores;
				ELSE
					SET Var_SumaPorAcc:= (SELECT (SUM(IFNULL(PorcentajeAcciones,Entero_Cero))+Par_PorcentajeAcc)
										  FROM DIRECTIVOS
										  WHERE ClienteID = Par_ClienteID AND  GaranteID=Par_GaranteID AND AvalID=Par_AvalID );

					IF(Var_SumaPorAcc > 100)THEN
						SET Par_NumErr  := 027;
						SET Par_ErrMen  := 'El Porcentaje de Acciones Excede el 100%.';
						SET Par_Control := 'porcentajeAccion';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF(Var_CliProcEspecifico = Cli_SofiExpress) THEN
					IF (Par_ValorAcciones = Decimal_Cero) THEN
						SET Par_NumErr  := 028;
						SET Par_ErrMen  := 'El valor de las acciones debe ser mayor a 0';
						SET Par_Control := 'valorAcciones';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- Validaciones Accionista Moral
				IF( Var_EsAccionistaMoral = Con_SI ) THEN

					IF( IFNULL( Par_Direccion1 , Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 030;
						SET Par_ErrMen  := 'La Direccion 1 es Requerida';
						SET Par_Control := 'direccion1';
						LEAVE ManejoErrores;
					END IF;

					IF( Par_Nacion <> Extranjero ) THEN
						IF( IFNULL( Par_EdoNac , Entero_Cero) = Entero_Cero ) THEN
							SET Par_NumErr  := 031;
							SET Par_ErrMen  := 'El Estado Esta Vacio';
							SET Par_Control := 'edoNacimiento';
							LEAVE ManejoErrores;
						END IF;

						SELECT EstadoID
						INTO Var_EstadoID
						FROM ESTADOSREPUB
						WHERE EstadoID = Par_EdoNac;

						SET Var_EstadoID := IFNULL( Var_EstadoID , Entero_Cero);
						IF( Var_EstadoID = Entero_Cero ) THEN
							SET Par_NumErr  := 031;
							SET Par_ErrMen  := 'El Estado no Existe';
							SET Par_Control := 'edoNacimiento';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_MunNacimiento , Entero_Cero) = Entero_Cero ) THEN
							SET Par_NumErr  := 032;
							SET Par_ErrMen  := 'El Municipio Esta Vacio';
							SET Par_Control := 'munNacimiento';
							LEAVE ManejoErrores;
						END IF;

						SELECT MunicipioID
						INTO Var_MunicipioID
						FROM MUNICIPIOSREPUB
						WHERE EstadoID = Par_EdoNac AND MunicipioID = Par_MunNacimiento;

						SET Var_MunicipioID := IFNULL( Var_MunicipioID , Entero_Cero);
						IF( Var_MunicipioID = Entero_Cero ) THEN
							SET Par_NumErr  := 032;
							SET Par_ErrMen  := 'El Municipio no Existe';
							SET Par_Control := 'munNacimiento';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_NombreCiudad , Cadena_Vacia) = Cadena_Vacia ) THEN
							SET Par_NumErr  := 033;
							SET Par_ErrMen  := 'El Nombre de la Ciudad Esta Vacio';
							SET Par_Control := 'nombreCiudad';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_ColoniaID , Entero_Cero) = Entero_Cero ) THEN
							SET Par_NumErr  := 034;
							SET Par_ErrMen  := 'La Colonia Esta Vacia';
							SET Par_Control := 'coloniaID';
							LEAVE ManejoErrores;
						END IF;


						SELECT ColoniaID,	CodigoPostal
						INTO Var_ColoniaID,	Var_CodigoPostal
						FROM COLONIASREPUB
						WHERE EstadoID = Par_EdoNac AND MunicipioID = Par_MunNacimiento
						  AND ColoniaID = Par_ColoniaID;

						SET Var_ColoniaID := IFNULL( Var_ColoniaID , Entero_Cero);
						IF( Var_ColoniaID = Entero_Cero ) THEN
							SET Par_NumErr  := 034;
							SET Par_ErrMen  := 'La Colonia no Existe';
							SET Par_Control := 'coloniaID';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_CodigoPostal , Cadena_Vacia) = Cadena_Vacia ) THEN
							SET Par_NumErr  := 035;
							SET Par_ErrMen  := 'El Codigo Postal Esta Vacia';
							SET Par_Control := 'codigoPostal';
							LEAVE ManejoErrores;
						END IF;

						SET Var_CodigoPostal := IFNULL( Var_CodigoPostal , Entero_Cero);
						IF( Var_CodigoPostal = Cadena_Vacia ) THEN
							SET Par_NumErr  := 036;
							SET Par_ErrMen  := 'El codigo Postal no Existe';
							SET Par_Control := 'codigoPostal';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia ) THEN
							SET Par_NumErr  := 037;
							SET Par_ErrMen  := 'El RFC esta Vacio Existe';
							SET Par_Control := 'RFC';
							LEAVE ManejoErrores;
						END IF;

						IF( Var_EsAccionistaMoral = Con_NO ) THEN
							IF( LENGTH(IFNULL(Par_RFC, Cadena_Vacia)) <> 13) THEN
								SET Par_NumErr  := 037;
								SET Par_ErrMen  := 'El RFC no es Valido';
								SET Par_Control := 'RFC';
								LEAVE ManejoErrores;
							END IF;
						ELSE
							IF( LENGTH(IFNULL(Par_RFC, Cadena_Vacia)) <> 12) THEN
								SET Par_NumErr  := 037;
								SET Par_ErrMen  := 'El RFC no es Valido';
								SET Par_Control := 'RFC';
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			IF(((IFNULL(Par_PaisRes, Entero_Cero)) = Entero_Cero) AND (IFNULL(Par_RelacionadoID,Entero_Cero) != Entero_Cero)) THEN
				SET Par_NumErr  :=  029;
				SET Par_ErrMen  := 'El Pais de Residencia esta vacio.';
				SET Par_Control := 'paisResidencia';
				LEAVE ManejoErrores;
			ELSE
				SET Par_PaisRes := 700;
			END IF;

			IF(Par_TipoPMoral = 'Cliente') THEN
				SET Par_NumeroCliente = Par_ClienteID;
			END IF;
			IF(Par_TipoPMoral = 'Aval') THEN
				SET Par_NumeroCliente = Par_AvalID;
			END IF;
			 IF(Par_TipoPMoral = 'Garante') THEN
				SET Par_NumeroCliente = Par_GaranteID;
			END IF;

			IF (Par_NumErr > Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Directivo Relacionado al ', Par_TipoPMoral,': ', CONVERT(Par_NumeroCliente, CHAR), ' Se ha Validado Correctamente.');
			SET Par_Control	:= 'directivoID';
		END IF;

		-- Validacion para la Modificacion de un Directivo
		IF( Par_NumeroValidacion = Val_DirectivoMod ) THEN

			IF((IFNULL(Par_ClienteID,Entero_Cero) = Entero_Cero) AND (IFNULL(Par_GaranteID,Entero_Cero) = Entero_Cero) AND (IFNULL(Par_AvalID,Entero_Cero) = Entero_Cero)) THEN
				SET Par_NumErr  := 001;
				SET Par_ErrMen  := 'Capture un Aval, Garante o un Cliente Moral';
				SET Par_Control := 'numCliente';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_CargoID, Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'El Cargo esta Vacio.';
				SET Par_Control := 'cargoID';
				LEAVE ManejoErrores;
			END IF;

			-- Si es Accionista Moral no se evalua
			IF( Var_EsAccionistaMoral = Con_NO ) THEN
				-- Validaciones para peronas fisicas y pfae
				IF(Var_TipoPersonaCta <> Moral) THEN
					IF( IFNULL(Par_Titulo, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 003;
						SET Par_ErrMen  := 'El Titulo esta Vacio.';
						SET Par_Control := 'titulo';
						LEAVE ManejoErrores;
					END IF;

					IF( IFNULL(Par_PrimerNom, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 004;
						SET Par_ErrMen  := 'El Primer Nombre esta Vacio.';
						SET Par_Control := 'cuentaAhoID';
						LEAVE ManejoErrores;
					END IF;

					IF( IFNULL(Par_ApellidoPat, Cadena_Vacia) = Cadena_Vacia AND IFNULL(Par_ApellidoMat, Cadena_Vacia) = Cadena_Vacia) THEN
						SET Par_NumErr  := 005;
						SET Par_ErrMen  := 'Se requiere al menos uno de los Apellidos.';
						SET Par_Control := 'apellidoParterno';
						LEAVE ManejoErrores;
					END IF;

					IF( IFNULL(Par_FechaNac, Fecha_Vacia) = Fecha_Vacia ) THEN
						SET Par_NumErr  := 006;
						SET Par_ErrMen  := 'La fecha de Nacimiento esta Vacia.';
						SET Par_Control := 'fechaNacimiento';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF( IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr  := 007;
				SET Par_ErrMen  := 'La Nacionalidad esta vacia.';
				SET Par_Control := 'nacion';
				LEAVE ManejoErrores;
			END IF;

			-- Si es Accionista Moral no se evalua
			IF( Var_EsAccionistaMoral = Con_NO ) THEN
				IF(Var_Anios >= 18)THEN
					IF( IFNULL(Par_TipoIdentiID, Entero_Cero) = Entero_Cero AND (IFNULL(Par_RelacionadoID , Entero_Cero) <> Entero_Cero)) THEN
						SET Par_NumErr  := 008;
						SET Par_ErrMen  := 'El Tipo de Identificacion esta Vacio ';
						SET Par_Control := 'tipoIdentiID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Si es apoderado Legal, se solicitan los datos de la escritura publica.
			IF( Par_EsApoderado = Con_SI )THEN

				IF( IFNULL(Par_EstadoID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 009;
					SET Par_ErrMen  := 'El Estado esta Vacio.';
					SET Par_Control := 'estadoID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_MunicipioID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 010;
					SET Par_ErrMen  := 'El Municipio esta Vacio.';
					SET Par_Control := 'municipioID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_NumEscPub, Cadena_Vacia) = Cadena_Vacia ) THEN
					SET Par_NumErr  := 011;
					SET Par_ErrMen  := 'El Numero de Escritura Publica esta Vacio.';
					SET Par_Control := 'numEscPub';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_FechaEscPub, Fecha_Vacia) = Fecha_Vacia ) THEN
					SET Par_NumErr  := 012;
					SET Par_ErrMen  := 'La Fecha de Escritura Publica esta Vacia.';
					SET Par_Control := 'fechaEscPub';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_NotariaID, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 013;
					SET Par_ErrMen  := 'La Notaria esta Vacia.';
					SET Par_Control := 'notariaID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_TitularNotaria, Cadena_Vacia) = Cadena_Vacia ) THEN
					SET Par_NumErr  := 014;
					SET Par_ErrMen  := 'El Titular de Notaria esta Vacio.';
					SET Par_Control := 'titularNotaria';
					LEAVE ManejoErrores;
				END IF;

				IF( Var_TipoPersonaCta <> Moral AND Par_OcupacionID <> 9999 AND Par_GaranteRelacion = Entero_Cero) THEN
					IF( IFNULL(Par_PuestoA, Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 015;
						SET Par_ErrMen  := 'El Puesto esta Vacio.';
						SET Par_Control := 'puestoA';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;


			IF( Var_TipoPersonaCta = Fisica ) THEN
				IF( IFNULL(Par_OcupacionID, Cadena_Vacia) = Cadena_Vacia ) THEN
					SET Par_NumErr  := 016;
					SET Par_ErrMen  := 'La ocupacion esta vacia.';
					SET Par_Control := 'ocupacionID';
					LEAVE ManejoErrores;
				END IF;

				IF( IFNULL(Par_PaisNac, Entero_Cero) = Entero_Cero ) THEN
					SET Par_NumErr  := 017;
					SET Par_ErrMen  := 'El Pais Especificado como el Lugar de Nacimiento esta Vacio.';
					SET Par_Control := 'paisNacimiento';
					LEAVE ManejoErrores;
				ELSE

					SELECT PaisID
					INTO Var_PaisID
					FROM PAISES
					WHERE PaisID = Par_PaisNac;

					IF( IFNULL(Var_PaisID, Entero_Cero) = Entero_Cero ) THEN
						SET Par_NumErr  := 018;
						SET Par_ErrMen  := 'El Pais Especificado como el Lugar de Nacimiento no existe.';
						SET Par_Control := 'paisNacimiento';
						LEAVE ManejoErrores;
					ELSE
						IF(Var_PaisID)= PaisMexico THEN

							SELECT EstadoID
							INTO Var_EstadoID
							FROM ESTADOSREPUB
							WHERE EstadoID = Par_EdoNac;

							IF(IFNULL(Var_EstadoID, Entero_Cero) = Entero_Cero ) THEN
								SET Par_NumErr  := 019;
								SET Par_ErrMen  := 'El estado especificado como Entidad Federativa no existe.';
								SET Par_Control := 'edoNacimiento';
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			IF( Var_EsAccionistaMoral = Con_NO) THEN

				IF(Var_TipoPersonaCta = Moral) THEN
					SET Par_NumErr  := 020;
					SET Par_ErrMen  := 'Solo Personas Fisica';
					SET Par_Control := 'directivoID';
					LEAVE ManejoErrores;

				ELSE
					SET Par_NombreCompleto  := FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
				END IF;

			ELSE
				SET Par_NombreCompleto := Par_NombreCompania;
			END IF;

			SET Par_NombreCompleto := IFNULL(Par_NombreCompleto, Cadena_Vacia);
			SET Par_NumeroCliente  := Entero_Cero;

			-- Validacion de Cliente
			IF( IFNULL(Par_ClienteID, Entero_Cero) <> Entero_Cero ) THEN

				SET Par_TipoPMoral := 'Cliente';
				IF( IFNULL(Par_RelacionadoID, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.ClienteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND IFNULL(Dir.RelacionadoID,Entero_Cero) = IFNULL(Par_RelacionadoID,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_GaranteRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.ClienteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND IFNULL(Dir.GaranteRelacion,Entero_Cero) = IFNULL(Par_GaranteRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_AvalRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.ClienteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND IFNULL(Dir.AvalRelacion,Entero_Cero) = IFNULL(Par_AvalRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_RelacionadoID, Entero_Cero) = Entero_Cero AND IFNULL(Par_GaranteRelacion, Entero_Cero) = Entero_Cero AND
					IFNULL(Par_AvalRelacion, Entero_Cero) = Entero_Cero ) THEN
					SELECT Dir.DirectivoID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.ClienteID = Par_ClienteID
					  AND Dir.DirectivoID = Par_DirectivoID;
				END IF;

			END IF;

			-- Validacion de Garante
			IF( IFNULL(Par_GaranteID, Entero_Cero) <> Entero_Cero ) THEN
				SET Par_TipoPMoral := 'Garante';
				IF( IFNULL(Par_RelacionadoID, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.GaranteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND IFNULL(Dir.RelacionadoID,Entero_Cero) = IFNULL(Par_RelacionadoID,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_GaranteRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.GaranteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND IFNULL(Dir.GaranteRelacion,Entero_Cero) = IFNULL(Par_GaranteRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_AvalRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.GaranteID INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND IFNULL(Dir.AvalRelacion,Entero_Cero) = IFNULL(Par_AvalRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_RelacionadoID, Entero_Cero) = Entero_Cero AND IFNULL(Par_GaranteRelacion, Entero_Cero) = Entero_Cero AND
					IFNULL(Par_AvalRelacion, Entero_Cero) = Entero_Cero ) THEN
					SELECT Dir.DirectivoID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.GaranteID = Par_GaranteID
					  AND Dir.DirectivoID = Par_DirectivoID;
				END IF;
			END IF;

			-- Validacion de Aval
			IF( IFNULL(Par_AvalID, Entero_Cero) <> Entero_Cero ) THEN
				SET Par_TipoPMoral := 'Aval';
				IF( IFNULL(Par_RelacionadoID, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.AvalID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND IFNULL(Dir.RelacionadoID,Entero_Cero) = IFNULL(Par_RelacionadoID,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_GaranteRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.AvalID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND IFNULL(Dir.GaranteRelacion,Entero_Cero) = IFNULL(Par_GaranteRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_AvalRelacion, Entero_Cero) <> Entero_Cero ) THEN
					SELECT Dir.AvalID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND IFNULL(Dir.AvalRelacion,Entero_Cero) = IFNULL(Par_AvalRelacion,Entero_Cero)
					LIMIT 1;
				END IF;

				IF( IFNULL(Par_RelacionadoID, Entero_Cero) = Entero_Cero AND IFNULL(Par_GaranteRelacion, Entero_Cero) = Entero_Cero AND
					IFNULL(Par_AvalRelacion, Entero_Cero) = Entero_Cero ) THEN
					SELECT Dir.DirectivoID  INTO Par_NumeroCliente
					FROM DIRECTIVOS Dir
					WHERE Dir.AvalID = Par_AvalID
					  AND Dir.DirectivoID = Par_DirectivoID;
				END IF;
			END IF;

			IF( IFNULL(Par_NumeroCliente,Entero_Cero) = Entero_Cero ) THEN
				SET Par_NumErr  := 021;
				SET Par_ErrMen  := 'El numero de directivo no existe ';
				SET Par_Control := 'directivoID';
				LEAVE ManejoErrores;
			END IF;

			IF( IFNULL(Par_Nacion, Cadena_Vacia) = Extranjero AND Par_RelacionadoID <> Entero_Cero ) THEN
				IF(IFNULL( Par_PaisRFC, Entero_Cero) = Entero_Cero) THEN
					SET Par_NumErr  := 022;
					SET Par_ErrMen  := 'El Pais de Registro de RFC No Existe';
					SET Par_Control := 'paisRFC';
					LEAVE ManejoErrores;
				ELSE
					IF NOT EXISTS(SELECT PaisID FROM PAISES
							WHERE PaisID = Par_PaisRFC)THEN
						SET Par_NumErr  := 023;
						SET Par_ErrMen  := 'El Pais de Registro de RFC No Existe';
						SET Par_Control := 'paisRFC';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			ELSE
				SET Par_PaisRFC := PaisMexico;
			END IF;

			IF(Par_EsAccionista = Con_SI) THEN

				IF( Par_TipoAccionista = Cadena_Vacia ) THEN
					SET Par_NumErr  := 024;
					SET Par_ErrMen  :='El Tipo de Accionista esta Vacio.';
					SET Par_Control := 'tipoAccionista';
				END IF;

				IF( Par_TipoAccionista NOT IN (Fisica, Moral, FisicaAct, Gobierno)) THEN
					SET Par_NumErr  := 025;
					SET Par_ErrMen  :='El Tipo de Accionista no es Valido.';
					SET Par_Control := 'tipoAccionista';
				END IF;

				IF( Par_PorcentajeAcc = Decimal_Cero OR Par_PorcentajeAcc > 100 ) THEN
					SET Par_NumErr  := 026;
					SET Par_ErrMen  :='El Porcentaje de Acciones debe ser mayor a Cero y menor de 100.';
					SET Par_Control := 'porcentajeAccion';
					LEAVE ManejoErrores;
				ELSE
					SET Var_PorAntAcc := (SELECT PorcentajeAcciones
										  FROM DIRECTIVOS
										  WHERE DirectivoID = Par_DirectivoID AND ClienteID = Par_ClienteID);

					SET Var_SumaPorAcc := (SELECT (SUM(IFNULL(PorcentajeAcciones,Entero_Cero))-Var_PorAntAcc)+Par_PorcentajeAcc
										   FROM DIRECTIVOS
										   WHERE ClienteID = Par_ClienteID AND  GaranteID=Par_GaranteID AND AvalID=Par_AvalID);



					IF(Var_SumaPorAcc > 100)THEN
						SET Par_NumErr  := 027;
						SET Par_ErrMen  := 'El Porcentaje de Acciones Excede el 100%.';
						SET Par_Control := 'porcentajeAccion';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF( Var_CliProcEspecifico = Cli_SofiExpress ) THEN
					IF( Par_ValorAcciones = Decimal_Cero ) THEN
						SET Par_NumErr  := 028;
						SET Par_ErrMen  :='El valor de las acciones debe ser mayor a 0';
						SET Par_Control := 'valorAcciones';
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- Validaciones Accionista Moral
				IF( Var_EsAccionistaMoral = Con_SI ) THEN

					IF( IFNULL( Par_Direccion1 , Cadena_Vacia) = Cadena_Vacia ) THEN
						SET Par_NumErr  := 030;
						SET Par_ErrMen  := 'La Direccion 1 es Requerida';
						SET Par_Control := 'direccion1';
						LEAVE ManejoErrores;
					END IF;

					IF( Par_Nacion <> Extranjero ) THEN
						IF( IFNULL( Par_EdoNac , Entero_Cero) = Entero_Cero ) THEN
							SET Par_NumErr  := 031;
							SET Par_ErrMen  := 'El Estado Esta Vacio';
							SET Par_Control := 'edoNacimiento';
							LEAVE ManejoErrores;
						END IF;

						SELECT EstadoID
						INTO Var_EstadoID
						FROM ESTADOSREPUB
						WHERE EstadoID = Par_EdoNac;

						SET Var_EstadoID := IFNULL( Var_EstadoID , Entero_Cero);
						IF( Var_EstadoID = Entero_Cero ) THEN
							SET Par_NumErr  := 031;
							SET Par_ErrMen  := 'El Estado no Existe';
							SET Par_Control := 'edoNacimiento';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_MunNacimiento , Entero_Cero) = Entero_Cero ) THEN
							SET Par_NumErr  := 032;
							SET Par_ErrMen  := 'El Municipio Esta Vacio';
							SET Par_Control := 'munNacimiento';
							LEAVE ManejoErrores;
						END IF;

						SELECT MunicipioID
						INTO Var_MunicipioID
						FROM MUNICIPIOSREPUB
						WHERE EstadoID = Par_EdoNac AND MunicipioID = Par_MunNacimiento;

						SET Var_MunicipioID := IFNULL( Var_MunicipioID , Entero_Cero);
						IF( Var_MunicipioID = Entero_Cero ) THEN
							SET Par_NumErr  := 032;
							SET Par_ErrMen  := 'El Municipio no Existe';
							SET Par_Control := 'munNacimiento';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_NombreCiudad , Cadena_Vacia) = Cadena_Vacia ) THEN
							SET Par_NumErr  := 033;
							SET Par_ErrMen  :='El Nombre de la Ciudad Esta Vacio';
							SET Par_Control := 'nombreCiudad';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_ColoniaID , Entero_Cero) = Entero_Cero ) THEN
							SET Par_NumErr  := 034;
							SET Par_ErrMen  :='La Colonia Esta Vacia';
							SET Par_Control := 'coloniaID';
							LEAVE ManejoErrores;
						END IF;


						SELECT ColoniaID,	CodigoPostal
						INTO Var_ColoniaID,	Var_CodigoPostal
						FROM COLONIASREPUB
						WHERE EstadoID = Par_EdoNac AND MunicipioID = Par_MunNacimiento
						  AND ColoniaID = Par_ColoniaID;

						SET Var_ColoniaID := IFNULL( Var_ColoniaID , Entero_Cero);
						IF( Var_ColoniaID = Entero_Cero ) THEN
							SET Par_NumErr  := 034;
							SET Par_ErrMen  := 'La Colonia no Existe';
							SET Par_Control := 'coloniaID';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL( Par_CodigoPostal , Cadena_Vacia) = Cadena_Vacia ) THEN
							SET Par_NumErr  := 035;
							SET Par_ErrMen  := 'El Codigo Postal Esta Vacia';
							SET Par_Control := 'codigoPostal';
							LEAVE ManejoErrores;
						END IF;

						SET Var_CodigoPostal := IFNULL( Var_CodigoPostal , Entero_Cero);
						IF( Var_CodigoPostal = Cadena_Vacia ) THEN
							SET Par_NumErr  := 036;
							SET Par_ErrMen  := 'El codigo Postal no Existe';
							SET Par_Control := 'codigoPostal';
							LEAVE ManejoErrores;
						END IF;

						IF( IFNULL(Par_RFC, Cadena_Vacia) = Cadena_Vacia ) THEN
							SET Par_NumErr  := 037;
							SET Par_ErrMen  := 'El RFC esta Vacio Existe';
							SET Par_Control := 'RFC';
							LEAVE ManejoErrores;
						END IF;

						IF( Var_EsAccionistaMoral = Con_NO ) THEN
							IF( LENGTH(IFNULL(Par_RFC, Cadena_Vacia)) <> 13) THEN
								SET Par_NumErr  := 037;
								SET Par_ErrMen  := 'El RFC no es Valido';
								SET Par_Control := 'RFC';
								LEAVE ManejoErrores;
							END IF;
						ELSE
							IF( LENGTH(IFNULL(Par_RFC, Cadena_Vacia)) <> 12) THEN
								SET Par_NumErr  := 037;
								SET Par_ErrMen  := 'El RFC no es Valido';
								SET Par_Control := 'RFC';
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;

			IF(IFNULL(Par_PaisRes, Entero_Cero))= Entero_Cero THEN
				SET Par_NumErr  :=  029;
				SET Par_ErrMen  := 'El Pais de Residencia esta vacio.';
				SET Par_Control := 'paisResidencia';
				LEAVE ManejoErrores;
			ELSE
				SET Par_PaisRes := 700;
			END IF;

			IF(Par_TipoPMoral = 'Cliente') THEN
				SET Par_NumeroCliente = Par_ClienteID;
			END IF;
			IF(Par_TipoPMoral = 'Aval') THEN
				SET Par_NumeroCliente = Par_AvalID;
			END IF;
			 IF(Par_TipoPMoral = 'Garante') THEN
				SET Par_NumeroCliente = Par_GaranteID;
			END IF;

			IF (Par_NumErr > Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT('Directivo Relacionado al ', Par_TipoPMoral,': ', CONVERT(Par_NumeroCliente, CHAR), ' Se ha Validado Correctamente.');
			SET Par_Control	:= 'directivoID';

		END IF;
	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF (Par_Salida = Con_SI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen,
				Par_Control AS Control;
	END IF;

END TerminaStore$$
