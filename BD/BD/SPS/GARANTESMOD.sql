-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `GARANTESMOD`;DELIMITER $$

CREATE PROCEDURE `GARANTESMOD`(
  # ========== SP PARA ALTA DE GARANTES =============================================
  	Par_GaranteID           INT(11),          	-- Numero del Garante
	Par_TipoPersona         CHAR(1),      		-- Tipo de persona
	Par_Titulo              VARCHAR(10),    	-- Titulo de la persona
	Par_PrimerNombre        VARCHAR(50),    	-- Primer Nombre del Garante
	Par_SegundoNombre       VARCHAR(50),    	-- Segundo Nombre del Garante
	Par_TercerNombre        VARCHAR(50),    	-- Tercer Nombre del Garante

	Par_ApellidoPaterno     VARCHAR(50),    	-- Apellido Paterno del Garante
	Par_ApellidoMaterno     VARCHAR(50),    	-- Apellido Materno del Garante
	Par_FechaNacimiento     DATE,       		-- Fecha de Nacimiento del Garante
	Par_Nacionalidad        CHAR(1),      		-- Pais de Nacionalidad
	Par_LugarNacimiento     INT(11),       		-- Lugar de Nacimiento (Pais)

	Par_EstadoID            INT(11),        	-- Estado del Garante
	Par_PaisResidencia      INT(11),        	-- Pais de Residencia del Garante
	Par_Sexo                CHAR(1),     		-- Sexo del Garante
	Par_CURP                CHAR(18),     		-- CURP del Garante
	Par_RegistroHacienda    CHAR(1),      		-- Indica si esta registrado en hacienda

	Par_RFC                 CHAR(13),     		-- RFC del Garante
	Par_FechaConstitucion   DATE,				-- Fecha de constitucion del RFC
	Par_EstadoCivil         CHAR(2),     		-- Estado Civil del Garante
	Par_TelefonoCel         VARCHAR(20) ,   	-- Telefono Celular del Garante
	Par_Telefono            VARCHAR(20) ,   	-- Telefono Fijo del Garante

	Par_ExtTelefonoPart     VARCHAR(7),     	-- Extension del Telefono Particular del Garante
	Par_Correo              VARCHAR(50),    	-- Correo Electronico del Garante
	Par_Fax                 VARCHAR(30),    	-- Fax de contacto del Garante
	Par_Observaciones       VARCHAR(500),   	-- Observaciones
	Par_RazonSocial         VARCHAR(150),   	-- Razon social del Garante

	Par_RFCpm               CHAR(13),     		-- RFC para el Garante si es Persona Moral
	Par_PaisConstitucionID  INT(11),			-- Pais de Constitucion. (Campo para Personas Morales)
	Par_CorreoAlterPM       VARCHAR(50),		-- Correo alternativo. (Campo para Personas Morales)
	Par_TipoSocID           INT(11),        	-- Tipo de Sociedad
	Par_GrupoEmp            INT(11),        	-- Grupo Empresarial

	Par_FEA                 VARCHAR(250),		-- Pais Asignado FEA

	Par_PaisFEA             INT(11),			-- ID Pais Asignado FEA
    Par_TipoIdentID			INT(11),			-- Tipo de Identificacion del Garante
	Par_NumIndentif			VARCHAR(30),		-- Numero de Identificacion del Garante
	Par_FecExIden			DATE,				-- Fecha de Expedicion del Garante

	Par_FecVenIden   		DATE,				-- Fecha de Vencimiento del Garante
    Par_EstadoIDCli			INT(11),			-- Direccion: Estado del Garante
	Par_MunicipioID			INT(11),			-- Direccion: Municipio del Garante
	Par_LocalidadID			INT(11),			-- Direccion: Localidad del Garante
	Par_ColoniaID			INT(11),			-- Direccion: Colonia del Garante

	Par_Calle				VARCHAR(350),		-- Direccion: Calle del Garante
	Par_NumeroCasa			CHAR(10),			-- Direccion: Numero de Casa del Garante
	Par_NumInterior			CHAR(10),			-- Direccion: Numero Interior de Casa del Garante
	Par_CP					CHAR(5),			-- Direccion: Codigo Postal del Garante
	Par_Lote				CHAR(50),			-- Direccion: Lote del Garante

	Par_Manzana				CHAR(50),			-- Direccion: Manzana del Garante
    Par_Esc_Tipo			CHAR(1),			-- Tipo de Escritura Publica (Constitutiva o de Poderes)
	Par_EscriPub			VARCHAR(50),		-- Numero de Escritura Publica
	Par_LibroEscr			VARCHAR(50),		-- Libro en que se encuentra registrada la Escritura Publica
	Par_VolumenEsc			VARCHAR(10),		-- Volumen de la Escritura Publica

    Par_FechaEsc			DATE,				-- Fecha de la Escritura Publica
	Par_EstadoIDEsc			INT(11),			-- Estado de la Escritura Publica
	Par_MunicipioEsc		INT(11),			-- Localidad de la Escritura Publica
	Par_Notaria				INT(11),			-- Numero de la Notaria donde se encuentra registrada la Escritura Publica

	Par_NomApoder			VARCHAR(150),		-- Nombre del Apoderado Legal
	Par_RFC_Apoder			VARCHAR(13),		-- RFC del Apoderado Legal
	Par_RegistroPub			VARCHAR(10),		-- Numero de Registro Publico
	Par_FolioRegPub			VARCHAR(10),		-- Folio de Registro Publico

    Par_VolRegPub			VARCHAR(10),		-- Volumen del Registro Publico
	Par_LibroRegPub			VARCHAR(10),		-- Libro en que se encuentra el Registro Publico
	Par_AuxiRegPub			VARCHAR(20),		-- Auxiliar de Registro Publico
	Par_FechaRegPub			DATE,				-- Fecha del Registro Publico
	Par_EstadoIDReg			INT(11),			-- Estado del Registro Publico

	Par_MunicipioRegPub		INT(11),			-- Localidad del Registro Publico

	Par_Salida              CHAR(1),            -- Indica la Salida
	INOUT Par_NumErr        INT(11),            -- Numero de Error
	INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de Error

  /* Parametros de Auditoria */
  	Par_EmpresaID           INT(11),
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia      	CHAR(1);		-- Constante para Cadena Vacia
	DECLARE Fecha_Vacia       	DATE;			-- Constante para Fecha Vacia.
	DECLARE Entero_Cero       	INT;			-- Constante para valor 0
	DECLARE Estatus_Activo      CHAR(1);		-- Constante para estatus Activo.
	DECLARE PaisMex         	INT;			-- Constante para el pais mexico

	DECLARE Salida_SI         	CHAR(1);		-- Constante para el valor SI
	DECLARE Salida_NO         	CHAR(1);		-- Constante para el valor NO
	DECLARE Per_Fisica        	CHAR(1);		-- Constante para Persona Fisica
	DECLARE Per_ActEmp        	CHAR(1);		-- Constante para Persona con Actividad empresarial
	DECLARE Per_Moral       	CHAR(1);		-- Constante para Persona Moral

	DECLARE nacionalidadMex     CHAR(1);		-- Constante para Nacionalidad Mexicana
	DECLARE nacionalidadExt     CHAR(1);		-- Constante para Nacionalidad Extranjeta
	DECLARE Var_CampoGenerico   INT(11);		-- Constante para Campo generico
	DECLARE Cons_Si				CHAR(1);		-- Constante para valor SI
	DECLARE IDPaisNoEsp			INT(11);		-- Constante para identificador de paos no especificado

	DECLARE Tip_ConCliPM		CHAR(1);		-- Constante para conciliacion del Garante
	DECLARE Mayusculas			CHAR(2);		-- Constante para las Mayusculas
	DECLARE EscTipo_Poderes		CHAR(1);

	-- Declaracion de varibles.
	DECLARE NombreComplet     	VARCHAR(200);	-- Variable nombre completo
	DECLARE Valida_RFC        	CHAR(13);		-- Variable RFC
	DECLARE Valida_CURP       	CHAR(18);		-- variable CURP
	DECLARE Var_RFCOficial      CHAR(13);		-- Variable RFC Oficial
	DECLARE Var_PaisID        	INT(11);		-- Variable para almancenar el valor del Pais

    DECLARE NumeroGarante     	INT(11);		-- Variable numero de cliente
	DECLARE Var_EstadoID 		INT(2);			-- Variable para almancenar el valor del Estado
    DECLARE Var_Control       	VARCHAR(20);	-- Variable de control
    DECLARE Var_NombreEstado	VARCHAR(100);	-- Nombre del Estado
    DECLARE Var_NombreMunicipio	VARCHAR(150);	-- Nombre del Municipio
    DECLARE Var_NombreColonia	VARCHAR(500);	-- Nombre de la Colonia
	DECLARE DirecCompleta		VARCHAR(500);	-- Direccion Completa del Garante
    DECLARE Var_FechaSis		DATE;			-- Fecha del sistema
    DECLARE CURPCli           	CHAR(18);

	-- Varialbes para personas morales
	DECLARE Var_Nacionalidad	CHAR(1);		-- Variable Nacionalidad
	DECLARE Var_Consecutivo		INT(11);		-- Variable Valor Consecutivo

	-- Asiganacion de constantes
	SET Cadena_Vacia        := '';        	-- Cadena vacia
	SET Fecha_Vacia         := '1900-01-01';  -- FEcha vacia
    SET Entero_Cero         := 0;      	 	-- Entero cero
	SET Estatus_Activo      := 'A';       	-- Estatus activo
	SET PaisMex           	:= 700;       	-- ID Pais Mexico
	SET Per_Fisica          := 'F';       	-- Persona fisica
	SET Per_ActEmp          := 'A';      	-- Actividad empresarial
	SET Per_Moral         	:= 'M';       	-- Persona moral
	SET Salida_SI           := 'S';       	-- Salida SI
	SET Salida_NO           := 'N';       	-- Salida NO
	SET nacionalidadMex     := 'N';       	-- Nacionalida mexicana
	SET nacionalidadExt     := 'E';       	-- nacionalidad extranjera
	SET Cons_Si				:= 'S';		   	-- Constante si
	SET IDPaisNoEsp			:= 999;		   	-- Pais no Especificado en la tabla Paises
	SET Tip_ConCliPM		:= '2';		   	-- Tipo de consulta de Caracteres Validos para persona Moral
	SET Mayusculas			:= 'MA';	   	-- Obtener el resultado en Mayusculas
	SET EscTipo_Poderes		:='P';			-- Escritura tipo Poderes

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-GARANTESMOD');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

		SET Par_PrimerNombre			:= TRIM(IFNULL(Par_PrimerNombre, Cadena_Vacia));
		SET Par_SegundoNombre			:= TRIM(IFNULL(Par_SegundoNombre, Cadena_Vacia));
		SET Par_TercerNombre			:= TRIM(IFNULL(Par_TercerNombre, Cadena_Vacia));
		SET Par_ApellidoPaterno			:= TRIM(IFNULL(Par_ApellidoPaterno, Cadena_Vacia));
		SET Par_ApellidoMaterno			:= TRIM(IFNULL(Par_ApellidoMaterno, Cadena_Vacia));
		SET Par_FechaConstitucion	:= IFNULL(Par_FechaConstitucion,Fecha_Vacia);

		SET Par_TelefonoCel			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_TelefonoCel, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);
		SET Par_Telefono			:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_Telefono," ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

		SELECT FechaSistema INTO Var_FechaSis
			FROM PARAMETROSSIS;

		SET CURPCli:= (SELECT CURP FROM GARANTES WHERE GaranteID=Par_GaranteID);

		IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
			IF (Par_CURP  != CURPCli )THEN
				IF EXISTS(SELECT *FROM GARANTES WHERE CURP=Par_CURP  AND TipoPersona <> 'M')THEN
					SET Par_NumErr  := 3;
					SET Par_ErrMen  := 'CURP Asociada a otro Garante';
					SET Var_Control := 'CURP ';
					SET Var_Consecutivo := Entero_Cero;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El Tipo de Persona esta vacio.';
			SET Var_Control := 'tipoPersona1';
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones Personas fisicas o fisicas con actividad empresarial
		IF(Par_TipoPersona <> Per_Moral) THEN

            SET NombreComplet  := FNGENNOMBRECOMPLETO(Par_PrimerNombre, Par_SegundoNombre,Par_TercerNombre,Par_ApellidoPaterno,Par_ApellidoMaterno);
			SET Var_RFCOficial := Par_RFC;

            -- Si no es una persona moral el Campo Pais de Constitucion debe llevar el id de pais no especificado
			SET Par_PaisConstitucionID := IDPaisNoEsp;

			IF(IFNULL(Par_PrimerNombre, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 003;
				SET Par_ErrMen := 'El Primer Nombre esta vacio.';
				SET Var_Control := 'primerNombre';
				LEAVE ManejoErrores;
			END IF;


			IF(IFNULL(Par_ApellidoPaterno, Cadena_Vacia) = Cadena_Vacia AND
					IFNULL(Par_ApellidoMaterno, Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr := 004;
				SET Par_ErrMen := 'Se requiere al menos uno de los Apellidos.';
				SET Var_Control := 'apellidoParterno';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_LugarNacimiento = PaisMex) THEN
				IF(IFNULL(Par_EstadoID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr := 005;
					SET Par_ErrMen := 'El Estado esta vacio.';
					SET Var_Control := 'estadoID';
					LEAVE ManejoErrores;
				END IF;

                SELECT EstadoID INTO Var_EstadoID FROM ESTADOSREPUB WHERE EstadoID = Par_EstadoID;
				IF(IFNULL(Var_EstadoID, Entero_Cero))= Entero_Cero THEN
					SET Par_NumErr  := 100;
					SET Par_ErrMen  := 'El Estado No Existe.';
					SET Var_Control := 'Estadoid';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Par_LugarNacimiento, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 007;
				SET Par_ErrMen := 'El Pais de Lugar de Nacimiento esta vacio.';
				SET Var_Control := 'lugarNacimiento';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_PaisResidencia, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'El Pais de Residencia esta vacio.';
				SET Var_Control := 'paisResidencia';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoPersona=Per_Fisica) THEN
				IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 010;
					SET Par_ErrMen := 'El Sexo esta vacio.';
					SET Var_Control := 'sexo';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_TipoPersona = Per_Fisica) THEN
				IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 011;
					SET Par_ErrMen := 'El RFC esta vacio.';
					SET Var_Control := 'RFC';
					LEAVE ManejoErrores;
				END IF;
			END IF;

             IF (Par_RFC = Cadena_Vacia)THEN
                SET Valida_RFC:=Cadena_Vacia;
            ELSE
                SET Valida_RFC:=(SELECT  RFCOficial FROM GARANTES WHERE GaranteID <> Par_GaranteID AND RFCOficial = Par_RFC);
                IF (Valida_RFC = Par_RFC)THEN
                    SET Par_NumErr :=   036;
                    SET Par_ErrMen := 'RFC asociado con otro Garante .';
                    SET Var_Control := 'RFC';
                    LEAVE ManejoErrores;
                END IF;
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
			IF(IFNULL(Par_FechaNacimiento, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr := 033;
				SET Par_ErrMen := 'Se Requiere la Fecha de Nacimiento.';
				SET Var_Control := 'fechaNacimiento';
				LEAVE ManejoErrores;
			END IF;

			-- VALIDACIONES DE LA IDENTIFICACION DEL GARANTE
			IF (IFNULL(Par_TipoIdentID, Cadena_Vacia) = Cadena_Vacia) THEN
				SET	Par_NumErr := 4;
				SET	Par_ErrMen := 'El Tipo de Identificacion esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(NOT EXISTS(SELECT TipoIdentiID FROM TIPOSIDENTI WHERE TipoIdentiID =  Par_TipoIdentID)) THEN
				SET	Par_NumErr := 3;
				SET	Par_ErrMen := 'El Tipo de Identificacion No Existe' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumIndentif, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr := 3;
				SET	Par_ErrMen := 'El Numero de Identificacion esta Vacio.' ;
				LEAVE ManejoErrores;
			END IF;

            IF(IFNULL(Par_FecExIden, Fecha_Vacia) = Fecha_Vacia) THEN
				SET	Par_NumErr := 4;
				SET	Par_ErrMen := 'La Fecha de Expedicion esta Vacia.' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FecExIden, Fecha_Vacia) <> Fecha_Vacia) THEN
				IF(DATEDIFF(Var_FechaSis, Par_FecExIden) < Entero_Cero)THEN
					SET	Par_NumErr := 4;
					SET	Par_ErrMen := 'La Fecha de Expedicion es Mayor a la Fecha Actual.' ;
					LEAVE ManejoErrores;
				END IF;
			END IF;

            -- FIN VALIDACIONES IDENTIFICACION GARANTE

            -- VALIDACIONES DIRECCION GARANTE
			IF(IFNULL(Par_EstadoIDCli,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'El Estado esta Vacio.' ;
				SET Var_Control := 'estadoIDCli';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'El Municipio esta Vacio.' ;
				SET Var_Control := 'municipioID';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_LocalidadID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 8;
				SET Par_ErrMen := 'La Localidad esta Vacia.' ;
				SET Var_Control := 'localidadID';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := 'La Colonia Esta Vacia.' ;
				SET Var_Control := 'coloniaID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 4;
				SET Par_ErrMen := 'La Calle esta Vacia.' ;
				SET Var_Control := 'calle';
				LEAVE ManejoErrores;
			END IF;

			SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
			SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

			IF(Par_Lote = Cadena_Vacia AND Par_Manzana = Cadena_Vacia) THEN
				IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 5;
					SET Par_ErrMen := 'El Numero esta Vacio.' ;
					SET Var_Control := 'numeroCasa';
					LEAVE ManejoErrores;
				END IF;
			END IF;


			IF(IFNULL(Par_CP, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 7;
				SET Par_ErrMen := 'El Codigo Postal esta Vacio.' ;
				SET Var_Control := 'CP';
				LEAVE ManejoErrores;
			END IF;




		ELSE
			-- Si es una persona moral el Campo Lugar de Nacimiento y Pais de Residencia debe llevar el id de pais no especificado
			SET Par_LugarNacimiento := IDPaisNoEsp;
			SET Par_PaisResidencia := IDPaisNoEsp;

			IF(SELECT FNCLIENTESCARACTERESESP(Par_RazonSocial,Tip_ConCliPM)!= Entero_Cero )THEN
				SET Par_NumErr  := 060;
				SET Par_ErrMen  := CONCAT('Ingreso un Caracter Invalido - ', Par_RazonSocial);
				SET Var_Control := 'razonSocial';
				LEAVE   ManejoErrores;
			END IF;

		END IF; -- fin validaciones para personas fisicas y fisicas con actividad empresarial

		IF(Par_TipoPersona = Per_Moral) THEN

			SET NombreComplet  := Par_RazonSocial;
			SET Var_RFCOficial := Par_RFCpm;
			IF (Par_RFCpm = Cadena_Vacia)THEN
				SET Valida_RFC:=Cadena_Vacia;
			ELSE
				SET Valida_RFC:=(SELECT  RFCOficial FROM GARANTES WHERE GaranteID <> Par_GaranteID AND RFCOficial = Par_RFCpm);
				IF (Valida_RFC = Par_RFCpm)THEN
					SET Par_NumErr := 036;
					SET Par_ErrMen :=   'RFC asociado con otro Garante .';
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

			IF(IFNULL(Par_FechaConstitucion, Cadena_Vacia) = Cadena_Vacia) THEN
				SET Par_NumErr  := 051;
				SET Par_ErrMen  := 'Se Requiere la Fecha de Constitucion.';
				SET Var_Control := 'fechaRegistro';
				LEAVE ManejoErrores;
			END IF;



			IF(IFNULL(Par_PaisConstitucionID,Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr  := 049;
				SET Par_ErrMen  := 'Se requiere el Pais de Constitucion.';
				SET Var_Control := 'paisConstitucionID';
				LEAVE ManejoErrores;
			END IF;

            -- VALIDACIONES ESCRITURA PUBLICA
            IF(IFNULL(Par_Esc_Tipo,Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 001;
				SET Par_ErrMen := 'El Tipo  de Acta esta Vacio';
				SET Var_Control := 'esc_Tipo';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_EscriPub, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := 'El no. de Escritura Publica esta Vacio';
				SET Var_Control := 'escrituraPub';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaEsc, Fecha_Vacia)) = Fecha_Vacia THEN
					SET Par_NumErr := 003;
					SET Par_ErrMen := 'La Fecha de la Escritura Publica esta Vacia';
					SET Var_Control := 'fechaEsc';
					LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_EstadoIDEsc, Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 004;
					SET Par_ErrMen := 'El Estado esta Vacio';
					SET Var_Control := 'estadoIDEsc';
					LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MunicipioEsc, Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 005;
					SET Par_ErrMen := 'El Municipio esta Vacio';
					SET Var_Control := 'localidadEsc';
					LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Notaria, Entero_Cero)) = Entero_Cero THEN
					SET Par_NumErr := 006;
					SET Par_ErrMen := 'La notaria esta Vacia';
					SET Var_Control := 'notaria';
					LEAVE ManejoErrores;
			END IF;

			IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
				IF(IFNULL(Par_NomApoder, Cadena_Vacia)) = Cadena_Vacia THEN
						SET Par_NumErr := 007;
						SET Par_ErrMen := 'El nombre del Apoderado esta Vacio';
						SET Var_Control := 'nomApoderado';
						LEAVE ManejoErrores;
				END IF;
            END IF;

			IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
				IF(IFNULL(Par_RFC_Apoder, Cadena_Vacia)) = Cadena_Vacia THEN
					SET Par_NumErr := 008;
					SET Par_ErrMen := 'El RFC del Apoderado esta Vacio';
					SET Var_Control := 'RFC_Apoderado';
					LEAVE ManejoErrores;
				END IF;
            END IF;

			IF(IFNULL(Par_RegistroPub, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 009;
				SET Par_ErrMen := 'El Registro esta Vacio';
				SET Var_Control := 'registroPub';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FolioRegPub, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 010;
				SET Par_ErrMen := 'El Folio esta Vacio';
				SET Var_Control := 'folioRegPub';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_FechaRegPub, Fecha_Vacia)) = Fecha_Vacia THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen := 'La Fecha esta Vacia';
				SET Var_Control := 'fechaRegPub';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_EstadoIDReg, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 012;
				SET Par_ErrMen := 'La Entidad Federativa de Registro Pub esta Vacio.';
				SET Var_Control := 'estadoIDReg' ;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_MunicipioRegPub, Entero_Cero)) = Entero_Cero THEN
				SET Par_NumErr := 013;
				SET Par_ErrMen := 'El Municipio de Registro Pub esta Vacio.';
				SET Var_Control := 'localidadRegPub';
				LEAVE ManejoErrores;
			END IF;



		END IF; -- FIN VALIDACIONES PERSONA MORAL

        IF(IFNULL(Par_Nacionalidad, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 006;
			SET Par_ErrMen := 'La Nacionalidad esta vacia.';
			SET Var_Control := 'nacion';
			LEAVE ManejoErrores;
		ELSE
			SET Var_Nacionalidad := Par_Nacionalidad;
		END IF;

		IF(IFNULL(Par_LugarNacimiento, Entero_Cero))<> Entero_Cero THEN
				SELECT PaisID INTO Var_PaisID FROM PAISES WHERE PaisID = Par_LugarNacimiento;
			IF(IFNULL(Var_PaisID, Entero_Cero))= Entero_Cero THEN
			  SET Par_NumErr := 008;
			  SET Par_ErrMen := 'El Pais especificado como el Lugar de Nacimiento No Existe.';
			  SET Var_Control := 'lugarNAcimiento';
				LEAVE ManejoErrores;
			END IF;
		END IF;


		SET Par_GrupoEmp 	:= IFNULL(Par_GrupoEmp, Entero_Cero);

		IF(IFNULL(Par_RegistroHacienda, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr :=  028;
			SET Par_ErrMen :=  'El campo Registro Hacienda esta vacio.';
			SET Var_Control := 'registroHaciENDaSi';
			LEAVE ManejoErrores;
		END IF;

		IF((Par_TipoPersona = Per_Moral OR Par_TipoPersona= Per_ActEmp) AND (Par_Nacionalidad=nacionalidadMex)) THEN
			IF((IFNULL(Par_FechaConstitucion,Fecha_Vacia)=Fecha_Vacia) OR (IFNULL(Par_FechaConstitucion,Cadena_Vacia)=Cadena_Vacia)) THEN
				SET Par_NumErr := 048;
				SET Par_ErrMen := 'La Fecha de Constitucion es requerida.';
				SET Var_Control := 'fechaConstitucion';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Par_TipoPersona =  Per_Moral )THEN
			SET Par_RegistroHacienda :='S';
		END IF;

        IF(Par_TipoPersona=Per_Fisica OR Par_TipoPersona= Per_ActEmp) THEN
			SET Var_NombreEstado := (SELECT Nombre
				FROM ESTADOSREPUB
				WHERE EstadoID = Par_EstadoIDCli);

			SET Var_NombreMunicipio := (SELECT M.Nombre
				FROM MUNICIPIOSREPUB M,ESTADOSREPUB E
				WHERE E.EstadoID = M.EstadoID AND E.EstadoID = Par_EstadoIDCli AND M.MunicipioID=Par_MunicipioID);

			SET Var_NombreColonia := (SELECT CONCAT(Col.TipoAsenta,' ',Col.Asentamiento)
										FROM COLONIASREPUB Col
                                        WHERE Col.EstadoID = Par_EstadoIDCli AND Col.MunicipioID = Par_MunicipioID
                                        AND Col.ColoniaID = Par_ColoniaID);

			SET Par_NumeroCasa := IFNULL(Par_NumeroCasa, Cadena_Vacia);
			SET Par_NumInterior := IFNULL(Par_NumInterior, Cadena_Vacia);
			SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
			SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

			SET DirecCompleta := Par_Calle;

			IF(Par_NumeroCasa != Cadena_Vacia) THEN
				SET DirecCompleta := CONCAT(DirecCompleta,", No. ",Par_NumeroCasa);
			END IF;

			IF(Par_NumInterior != Cadena_Vacia) THEN
				SET DirecCompleta := CONCAT(DirecCompleta,", INTERIOR ",Par_NumInterior);
			END IF;

			IF(Par_Lote != Cadena_Vacia) THEN
				SET DirecCompleta := CONCAT(DirecCompleta,", LOTE ",Par_Lote);
			END IF;

			IF(Par_Manzana != Cadena_Vacia) THEN
				SET DirecCompleta := CONCAT(DirecCompleta,", MANZANA ",Par_Manzana);
			END IF;

			SET DirecCompleta := UPPER(CONCAT(DirecCompleta,", COL. ",Var_NombreColonia,", C.P ",Par_CP,", ",Var_NombreMunicipio,", ",Var_NombreEstado,"."));
        END IF;

		SET Aud_FechaActual := NOW();


		UPDATE  GARANTES
        SET	TipoPersona	 		=	Par_TipoPersona,
			Titulo				=	Par_Titulo,
            PrimerNombre 		= Par_PrimerNombre,
            SegundoNombre 		= Par_SegundoNombre,
            TercerNombre 		= Par_TercerNombre,
            ApellidoPaterno		= Par_ApellidoPaterno,
            ApellidoMaterno		= Par_ApellidoMaterno,
            FechaNacimiento 	= Par_FechaNacimiento,
            Nacion 				= Par_Nacionalidad,
            LugarNacimiento 	= Par_LugarNacimiento,
            EstadoID 			= Par_EstadoID,
            PaisResidencia 		= Par_PaisResidencia,
            Sexo 				= Par_Sexo,
            CURP 				= Par_CURP,
            RegistroHacienda 	= Par_RegistroHacienda,
            RFC 				= Par_RFC,
            FechaConstitucion	= Par_FechaConstitucion,
            EstadoCivil 		= Par_EstadoCivil,
            TelefonoCelular 	= Par_TelefonoCel,
            Telefono 			= Par_Telefono,
            ExtTelefonoPart 	= Par_ExtTelefonoPart,
            Correo 				= Par_Correo,
            Fax 				= Par_Fax,
            Observaciones 		= Par_Observaciones,
            RazonSocial	 		= Par_RazonSocial,
            RFCpm 				= Par_RFCpm,
            RFCOficial 			= Var_RFCOficial,
            PaisConstitucionID	= Par_PaisConstitucionID,
            CorreoAlterPM	 	= Par_CorreoAlterPM,
            TipoSociedadID 		= Par_TipoSocID,
		    GrupoEmpresarial 	= Par_GrupoEmp,
            FEA 				= Par_FEA,
            PaisFEA 			= Par_PaisFEA,
            NombreCompleto 		= NombreComplet,
            TipoIdentiID		= Par_TipoIdentID,
            NumIdentific		= Par_NumIndentif,
            FecExIden			= Par_FecExIden,
            FecVenIden			= Par_FecVenIden,
            EstadoIDDir			= Par_EstadoIDCli,
            MunicipioID			= Par_MunicipioID,
            LocalidadID			= Par_LocalidadID,
            ColoniaID			= Par_ColoniaID,
            Calle				= Par_Calle,
            NumeroCasa			= Par_NumeroCasa,
            NumInterior			= Par_NumInterior,
            CP					= Par_CP,
            Lote				= Par_Lote,
            Manzana				= Par_Manzana,
            DireccionCompleta	= DirecCompleta,
            Esc_Tipo			= Par_Esc_Tipo,
            EscrituraPublic		= Par_EscriPub,
            LibroEscritura		= Par_LibroEscr,
            VolumenEsc			= Par_VolumenEsc,
            FechaEsc			= Par_FechaEsc,
            EstadoIDEsc			= Par_EstadoIDEsc,
            MunicipioEsc		= Par_MunicipioEsc,
            Notaria				= Par_Notaria,
            NomApoderado		= Par_NomApoder,
            RFC_Apoderado		= Par_RFC_Apoder,
            RegistroPub			= Par_RegistroPub,
            FolioRegPub			= Par_FolioRegPub,
            VolumenRegPub		= Par_VolRegPub,
            LibroRegPub			= Par_LibroRegPub,
            AuxiliarRegPub		= Par_AuxiRegPub,
            FechaRegPub			= Par_FechaRegPub,
            EstadoIDReg			= Par_EstadoIDReg,
            MunicipioRegPub		= Par_MunicipioRegPub,

	        EmpresaID 			= Par_EmpresaID,
			Usuario 			= Aud_Usuario,
            FechaActual 		= Aud_FechaActual,
		    DireccionIP 		= Aud_DireccionIP,
		    ProgramaID 			= Aud_ProgramaID,
            Sucursal 			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion

		WHERE GaranteID = Par_GaranteID;

		SET Par_NumErr  	:= 0;
		SET Par_ErrMen  	:= CONCAT("Garante Modificado Exitosamente: ", CONVERT(Par_GaranteID, CHAR));
		SET Var_Control 	:= 'numero';
		SET Var_Consecutivo := LPAD(Par_GaranteID, 10, 0);

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo,
				Var_CampoGenerico AS CampoGenerico;
	END IF;


END TerminaStore$$