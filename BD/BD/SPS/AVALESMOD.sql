
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------

-- AVALESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESMOD`;

DELIMITER $$
CREATE PROCEDURE `AVALESMOD`(
/* =================== SP DE MODIFICACION DE AVALES ======================= */
	Par_AvalID      		BIGINT(20),		-- ID del Aval
    Par_PrimerNom       	VARCHAR(50),	-- Primer nombre del aval
    Par_SegundoNom      	VARCHAR(50),	-- Segundo nombre del aval
    Par_TercerNom       	VARCHAR(50),	-- Tercer nombre del aval
    Par_ApellidoPat     	VARCHAR(50),	-- Apellido paterno

    Par_ApellidoMat     	VARCHAR(50),	-- Apellido MAterno
    Par_Telefono        	CHAR(13),		-- Telefono de casa
    Par_Calle           	VARCHAR(50),	-- Nombre de la calle
    Par_NumExterior     	CHAR(10),		-- Numero exterior
    Par_NumInterior     	CHAR(10),		-- Numero Interior

    Par_Manzana         	VARCHAR(20),	-- Manzana del domicilio
    Par_Lote            	VARCHAR(20),	-- Lote del domicilio
    Par_Colonia         	VARCHAR(200),	-- Nombre de la colonia
    Par_ColoniaID 			INT(11),		-- Numero de la colonia
    Par_LocalidadID			INT(11),		-- Numero de la localidad

    Par_MunicipioID     	INT(11),		-- Numero del municipio
    Par_EstadoID        	INT(11),		-- Numero del estado
    Par_CP              	VARCHAR(5),		-- Codigo postal
    Par_TipoPersona     	CHAR(1),		-- Tipo de persona F.- Fisica M.- Moral A.- Fisica con act empresarial
    Par_RazonSocial     	VARCHAR(50),	-- Nombre de la razon social

    Par_RFC             	CHAR(13),		-- Numero del RFC
    Par_Latitud         	VARCHAR(45),	-- Latitud del domicilio
    Par_Longitud        	VARCHAR(45),	-- Longitud del domicilio
    Par_FechaNac		  	DATE,			-- Fecha de nacimiento
	Par_TelefonoCel	  		VARCHAR(13),	-- Numero de telefono celular

	Par_RFCpm		 	 	VARCHAR(13),	-- RFC de una persona Moral
	Par_Sexo				CHAR(1),		-- Sexo
	Par_EstadoCivil			CHAR(2),		/* Estado civil del aval S.-soltero, CS.-casado b. separados, CM.-casado b.
												mancomunados, CC.-casado b. man. con capitulacion, V.-viudo, D.-divorciado,
                                                SE.-separado, U.-union libre */
	Par_ExtTelefonoPart		VARCHAR(6),		-- Numero de extension del telefono
    -- ESCRITURA PUBLICA
    Par_Esc_Tipo			CHAR(2),		-- Tipo de Acta C.-Constitutiva, P.- Poderes

    Par_NomApoder			VARCHAR(150),	-- Nombre del Apoderado
	Par_RFC_Apoder			VARCHAR(13),	-- RFC del Apoderado
	Par_EscriPub			VARCHAR(50),	-- Numero Publico de la Escritura Publica
	Par_LibroEscr			VARCHAR(50),	-- Libro en que se encuentra la Escritura Publica
	Par_VolumenEsc			VARCHAR(20),	-- Volumen de la Escritura Publica

    Par_FechaEsc			DATE,			-- Fecha de la Escritura Publica
	Par_EstadoIDEsc			INT(11),		-- Estado de Escritura Publica
	Par_LocalEsc			INT(11),		-- Municipio de Escritura Publica
	Par_Notaria				INT(11), 		-- Numero de la Notaria Publica
    Par_DirecNotar			VARCHAR(150),   -- Direccion de Notaria Publica

	Par_NomNotario			VARCHAR(100),	-- Nombre del Notario
	Par_RegistroPub			VARCHAR(10),	-- Numero de Registro Publico
	Par_FolioRegPub			VARCHAR(10),	-- Folio de Registro Publico
    Par_VolRegPub			VARCHAR(20),	-- Volumen de Registro Publico
    Par_LibroRegPub	 		VARCHAR(10), 	-- Libro de Registro Publico

	Par_AuxiRegPub			VARCHAR(20), 	-- Auxiliar de Registro Publico
	Par_FechaRegPub			DATE,  			-- Fecha de Registro Publico
	Par_EstadoIDReg			INT(11),    	-- Estado de Registro Publico
	Par_LocalRegPub			INT(11),		-- Localidad de Registro Publico
	Par_Nacion				CHAR(1),		-- Nacionalidad del aval N.- Nacional E.- Extranjero

	Par_LugarNacimiento		INT(11),		-- Pais de Nacimiento
	Par_OcupacionID			INT(11),		-- Identificador de la ocupacion
	Par_Puesto				VARCHAR(100),	-- Puesto que ocupa el aval
	Par_DomicilioTrabajo	VARCHAR(500),	-- Lugar de trabajo del aval
	Par_TelefonoTrabajo		VARCHAR(13),	-- Telefono de trabajo del aval
	Par_ExtTelTrabajo		VARCHAR(4),		-- Extension del telefono de trabajo del aval

    Par_NumIdentificacion	VARCHAR(18),	-- Numero de Identificacion del Aval
    Par_FechaExpIdentif		DATE,			-- Fecha de Expedicion de la Identificacion del Aval
    Par_FechaVencIdentif	DATE,			-- Fecha de Vencimiento de la Identificacion del Aval


	Par_Salida      		CHAR(1),		-- Indica el tipo de salida del sp
	INOUT Par_NumErr		INT,			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de error
    /* Parametros de Auditoria */
	Aud_EmpresaID       	INT(11),

    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),

    Aud_NumTransaccion 	 	BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT;
	DECLARE Fecha_Vacia			DATE;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	SalidaNO			CHAR(1);
	DECLARE FechaSis			DATE;
    DECLARE Tipo_Agregar		CHAR(1);
    DECLARE Tipo_Modificar		CHAR(1);
    DECLARE PaisMexico			INT(11);
	DECLARE EsAVAL				CHAR(3);
	DECLARE Cons_Si				CHAR(1);

	-- Declaracion de Variables
	DECLARE	Per_Fisica			CHAR(1);
	DECLARE	Per_ActEmp			CHAR(1);
	DECLARE	Per_Moral			CHAR(1);
	DECLARE Var_NombreComp		VARCHAR(200);
	DECLARE Var_ValidaRFC		CHAR(13);
	DECLARE Var_LocalidadID 	INT;
	DECLARE Var_ColoniaID   	INT;
	DECLARE	Var_NombEstado		VARCHAR(100);
	DECLARE	Var_NombMunicipio	VARCHAR(150);
	DECLARE	Var_DirecCompl		VARCHAR(500);
	DECLARE Var_DirecComplCte	VARCHAR(500);
	DECLARE Var_AvalID			INT(11);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_Edad			INT;
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_NumRegistros	INT(11);
	DECLARE Var_OcupacionID		INT(11);		-- Variable para obtener la ocupacion de la tabla OCUPACIONES
	DECLARE	Var_SoloNombres		VARCHAR(500);	-- Solo Nombres del Aval.
	DECLARE	Var_SoloApellidos	VARCHAR(500);	-- Solo Apellidos del Aval.
	DECLARE	Var_RazonSocialPLD	VARCHAR(200);	-- Razon Social del Aval.

	-- Asignacion de Constantes
	SET Entero_Cero     		:= 0;    			-- Entero Cero
	SET Fecha_Vacia    			:= '1900-01-01';	-- Fecha vacia
	SET Cadena_Vacia    		:= '';				-- Cadena vacia
	SET Per_Fisica      		:= 'F';				-- Tipo de Persona fisica
	SET Per_ActEmp      		:= 'A';				-- Tipo de Persona fisica con act empresarial
	SET Per_Moral       		:= 'M';				-- Tipo de Persona moral
	SET SalidaSI        		:= 'S';				-- Salida si
	SET SalidaNO        		:= 'N';				-- Salida no
    SET Tipo_Agregar			:= 'A';				-- Tipo Consulta Alta
    SET Tipo_Modificar			:= 'M';				-- Tipo Consulta Modifica
	SET PaisMexico				:= 700;				-- Pais Mexico
	SET EsAVAL 					:= 'AVA';
	SET Cons_Si					:= 'S';

	SET	Var_ValidaRFC			:= Cadena_Vacia;
	SET Par_PrimerNom       := TRIM(IFNULL(Par_PrimerNom, Cadena_Vacia));
	SET Par_SegundoNom      := TRIM(IFNULL(Par_SegundoNom, Cadena_Vacia));
	SET Par_TercerNom       := TRIM(IFNULL(Par_TercerNom, Cadena_Vacia));
	SET Par_ApellidoPat     := TRIM(IFNULL(Par_ApellidoPat, Cadena_Vacia));
	SET Par_ApellidoMat     := TRIM(IFNULL(Par_ApellidoMat, Cadena_Vacia));

	SELECT FechaSistema INTO FechaSis
		FROM PARAMETROSSIS;

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-AVALESMOD');
    END;

	IF(IFNULL(Par_TipoPersona, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_TipoPersona := Per_Fisica;
	END IF;

	IF(IFNULL(Par_PrimerNom, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := CONCAT('El Nombre esta Vacio.');
		SET Var_Control := 'primerNombre';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ApellidoPat, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := CONCAT('El Apellido Paterno esta Vacio.');
		SET Var_Control := 'apellidoPaterno';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen := CONCAT('La Calle esta Vacia.');
		SET Var_Control := 'calle';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Manzana, Cadena_Vacia)) = Cadena_Vacia  OR IFNULL(Par_Lote, Cadena_Vacia) = Cadena_Vacia THEN
		IF(IFNULL(Par_NumExterior, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 005;
			SET Par_ErrMen := CONCAT('El Numero Exterior esta Vacio.');
			SET Var_Control := 'numExterior';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Colonia , Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 006;
		SET Par_ErrMen := CONCAT('La Colonia esta Vacia.');
		SET Var_Control := 'coloniaID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_MunicipioID , Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 007;
		SET Par_ErrMen := CONCAT('El Municipio esta vacio.');
		SET Var_Control := 'municipioID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoID , Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 008;
		SET Par_ErrMen := CONCAT('El Estado esta vacio.');
		SET Var_Control := 'estadoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_CP , Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr := 009;
		SET Par_ErrMen := CONCAT('El Codigo postal esta vacio.');
		SET Var_Control := 'CP';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_TipoPersona = Per_Moral OR Par_TipoPersona = Per_ActEmp) THEN
		IF(IFNULL(Par_RazonSocial  , Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 010;
			SET Par_ErrMen := CONCAT('La Razon Social esta Vacia.');
			SET Var_Control := 'razonSocial';
			LEAVE ManejoErrores;
		ELSE
			IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr := 011;
				SET Par_ErrMen := CONCAT('El RFC esta vacio.');
				SET Var_Control := 'RFC';
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

	IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona = Per_ActEmp) THEN
		SET Var_NombreComp 		:= FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom,Par_ApellidoPat,Par_ApellidoMat);
		SET Var_SoloNombres		:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Par_PrimerNom, Par_SegundoNom,Par_TercerNom, Cadena_Vacia, Cadena_Vacia),'MA'),500);
		SET Var_SoloApellidos	:= LEFT(FNLIMPIACARACTERESGEN(FNGENNOMBRECOMPLETO(Cadena_Vacia, Cadena_Vacia, Cadena_Vacia, Par_ApellidoPat,Par_ApellidoMat),'MA'),500);
		SET Var_RazonSocialPLD	:= Cadena_Vacia;
	END IF;

	IF(Par_RFC = Cadena_Vacia)THEN
		SET Var_ValidaRFC:=Cadena_Vacia;
	ELSE
		SET Var_ValidaRFC:=(SELECT  RFC FROM AVALES WHERE RFC = Par_RFC);
		IF(Var_ValidaRFC = Par_RFC)THEN

			SET Var_AvalID = (SELECT AvalID FROM AVALES WHERE RFC = Par_RFC);

            IF(IFNULL(Var_AvalID,Entero_Cero)!=Par_AvalID)THEN
				SET Par_NumErr := 015;
				SET Par_ErrMen := CONCAT('Existe Otro Aval con el Mismo RFC.');
				SET Var_Control := 'RFC';
				LEAVE ManejoErrores;
            END IF;
		END IF;

		SET Var_ValidaRFC:=Cadena_Vacia;

		SELECT  ClienteID,		RFC
		  INTO 	Var_ClienteID,	Var_ValidaRFC
			FROM CLIENTES
				WHERE RFC = Par_RFC;

		IF(Var_ValidaRFC = Par_RFC)THEN
			SET Par_NumErr := 027;
			SET Par_ErrMen := CONCAT('El RFC ',Par_RFC,
				' esta registrado con el safilocale.cliente ', LPAD(Var_ClienteID,10,'0'),
				', favor de utilizar la pantalla de Asignacion Aval.');
			SET Var_Control := 'RFC';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_TipoPersona,Cadena_Vacia)) != Cadena_Vacia THEN
		IF(Par_TipoPersona != Per_Fisica
			AND Par_TipoPersona != Per_Moral
			AND Par_TipoPersona != Per_ActEmp)THEN

			SET Par_NumErr := 012;
			SET Par_ErrMen := CONCAT('Valor invalido para Tipo de Persona.');
			SET Var_Control := 'tipoPersona';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_FechaNac , Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr := 013;
		SET Par_ErrMen := CONCAT('La Fecha de Nacimiento esta vacia.');
		SET Var_Control := 'fechaNac';
		LEAVE ManejoErrores;
	ELSE

		SET Var_Edad := TIMESTAMPDIFF(YEAR, Par_FechaNac, FechaSis);

		IF(Var_Edad < 18)THEN
			SET Par_NumErr := 014;
			SET Par_ErrMen := CONCAT('El Aval Debe de Ser Mayor de Edad.');
			SET Var_Control := 'fechaNac';
			LEAVE ManejoErrores;
		END IF;

	END IF;

	IF(Par_TipoPersona = Per_Moral) THEN
		SET Var_NombreComp		:= Par_RazonSocial;
		SET Var_SoloNombres		:= Cadena_Vacia;
		SET Var_SoloApellidos	:= Cadena_Vacia;
		SET Var_RazonSocialPLD	:= LEFT(FNLIMPIACARACTERESGEN(Par_RazonSocial,'MA'),200);
	END IF;

	IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia  THEN
		SET Par_NumErr := 016;
		SET Par_ErrMen := CONCAT('El sexo del Aval no esta indicado.');
		SET Var_Control := 'sexo';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_EstadoCivil, Cadena_Vacia)) = Cadena_Vacia  THEN
		SET Par_NumErr := 017;
		SET Par_ErrMen := CONCAT('El estado civil del Aval no esta indicado.');
		SET Var_Control := 'estadoCivil';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero  THEN
		SET Par_NumErr := 018;
		SET Par_ErrMen := CONCAT('La localidad del Aval no esta indicado.');
		SET Var_Control := 'localidadID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero  THEN
		SET Par_NumErr := 019;
		SET Par_ErrMen := CONCAT('La colonia del Aval no esta indicada.');
		SET Var_Control := 'coloniaID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_LocalidadID, Entero_Cero))<> Entero_Cero THEN
		SELECT LocalidadID INTO Var_LocalidadID
			FROM LOCALIDADREPUB
				WHERE LocalidadID = Par_LocalidadID
					AND MunicipioID=Par_MunicipioID
					AND EstadoID=Par_EstadoID;
		IF(IFNULL(Var_LocalidadID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 020;
			SET Par_ErrMen := CONCAT('La localidad especificada no existe.');
			SET Var_Control := 'localidadID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_ColoniaID, Entero_Cero))<> Entero_Cero THEN
		SELECT ColoniaID INTO Var_ColoniaID
			FROM COLONIASREPUB
				WHERE ColoniaID = Par_ColoniaID
					AND MunicipioID=Par_MunicipioID
					AND EstadoID=Par_EstadoID;
		IF(IFNULL(Var_ColoniaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 021;
			SET Par_ErrMen := CONCAT('La colonia especificada no existe.');
			SET Var_Control := 'coloniaID';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_LugarNacimiento, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr  := 22;
		SET Par_ErrMen  :='El pais de Lugar de Nacimiento esta Vacio.';
		SET Var_Control := 'lugarNacimiento';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_LugarNacimiento = PaisMexico) THEN
		  IF(IFNULL(Par_EstadoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr  := 23;
			SET Par_ErrMen  :='El Estado esta Vacio.';
			SET Var_Control := 'estadoID ';
			LEAVE ManejoErrores;
	  END IF;
	END IF;

	IF(IFNULL(Par_Nacion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr  := 24;
		SET Par_ErrMen  :='La Nacionalidad esta Vacia.';
		SET Var_Control := 'nacion ';
		LEAVE ManejoErrores;
	END IF;

	-- Se valida que el parametro para la ocupacion no venga vacio y que este exista en la tabla OCUPACIONES. Cardinal Sistemas Inteligentes
	IF(IFNULL(Par_OcupacionID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr	:= 25;
		SET Par_ErrMen	:='La ocupacion esta vacia';
		SET Var_Control	:= 'ocupacion';
		LEAVE ManejoErrores;
	END IF;

	SELECT OcupacionID
		INTO Var_OcupacionID
		FROM OCUPACIONES
		WHERE OcupacionID = Par_OcupacionID;

	SET Var_OcupacionID := IFNULL(Var_OcupacionID, Entero_Cero);

	IF (Var_OcupacionID = Entero_Cero) THEN
		SET Par_NumErr	:= 26;
		SET Par_ErrMen	:='La ocupacion especificada no existe en la base de datos';
		SET Var_Control	:= 'ocupacion';
		LEAVE ManejoErrores;
	END IF;
	-- Fin de validaciones del campo de ocupacion. Cardinal Sistemas Inteligentes

	SET Var_NombEstado := (SELECT Nombre
						  FROM ESTADOSREPUB
							WHERE EstadoID=Par_EstadoID);

	SET Var_NombMunicipio := (SELECT M.Nombre
							 FROM MUNICIPIOSREPUB M,ESTADOSREPUB E
								WHERE E.EstadoID=M.EstadoID
									AND E.EstadoID=Par_EstadoID AND M.MunicipioID=Par_MunicipioID);

	SET Par_NumExteriOR := IFNULL(Par_NumExterior,Cadena_Vacia);
	SET Par_NumInteriOR := IFNULL(Par_NumInterior, Cadena_Vacia);
	SET Par_CP  		:= IFNULL(Par_CP,Cadena_Vacia);
	SET Par_Lote 		:= IFNULL(Par_Lote, Cadena_Vacia);
	SET Par_Manzana 	:= IFNULL(Par_Manzana, Cadena_Vacia);

	SET Var_DirecCompl := Par_Calle;

	IF(Par_NumExteriOR != Cadena_Vacia) THEN
		SET Var_DirecCompl := CONCAT(Var_DirecCompl,", No. ",Par_NumExterior);
	END IF;

	IF(Par_NumInteriOR != Cadena_Vacia) THEN
		SET Var_DirecCompl := CONCAT(Var_DirecCompl,", INTERIOR ",Par_NumInterior);
	END IF;

	IF(Par_Colonia != Cadena_Vacia OR Par_ColoniaID != Entero_Cero) THEN
		SET Var_DirecCompl := CONCAT(Var_DirecCompl,", COL. ",Par_Colonia);
	END IF;

	IF(Par_CP != Cadena_Vacia) THEN
		SET Var_DirecCompl := CONCAT(Var_DirecCompl,", C.P. ",Par_CP);
	END IF;

	IF(Par_Lote != Cadena_Vacia) THEN
		SET Var_DirecCompl := CONCAT(Var_DirecCompl,", LOTE ",Par_Lote);
	END IF;

	IF(Par_Manzana != Cadena_Vacia) THEN
		SET Var_DirecCompl := CONCAT(Var_DirecCompl,", MANZANA ",Par_Manzana);
	END IF;

	SET Var_DirecCompl := UPPER(CONCAT(Var_DirecCompl,", ",Var_NombMunicipio,", ",Var_NombEstado));

	SET Aud_FechaActual := NOW();


    IF(Par_TipoPersona = Per_Fisica OR Par_TipoPersona = Per_ActEmp) THEN
		IF(Par_Esc_Tipo = '-1') THEN
			SET Par_Esc_Tipo :=	Cadena_Vacia;
        END IF;

		SELECT COUNT(AvalID)	INTO Var_NumRegistros
			FROM ESCPUBAVALES
			WHERE AvalID = Par_AvalID;

		IF(Var_NumRegistros > Entero_Cero) THEN
			DELETE FROM ESCPUBAVALES
			WHERE AvalID = Par_AvalID;
		END IF;
	END IF;

	/*SECCION PLD: Deteccion de operaciones inusuales*/
	CALL PLDDETECCIONPRO(
		Par_AvalID,				Par_PrimerNom,			Par_SegundoNom,			Par_TercerNom,			Par_ApellidoPat,
		Par_ApellidoMat,		Par_TipoPersona,		Par_RazonSocial,		Par_RFC,				Par_RFCpm,
		Par_FechaNac,			Entero_Cero,			Par_LugarNacimiento,	Par_EstadoID,			Var_NombreComp,
		EsAVAL,					Cons_Si,				Cons_Si,				Cons_Si,				SalidaNO,
		Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF(Par_NumErr!=Entero_Cero)THEN
		SET Par_NumErr			:= 50; # NO CAMBIAR ESTE NUMERO DE ERROR
		SET Par_ErrMen			:= Par_ErrMen;
		SET Var_Control			:= 'avalID';
		LEAVE ManejoErrores;
	END IF;
	/*FIN SECCION PLD: Deteccion de operaciones inusuales*/

    SET Par_NumIdentificacion 	:= IFNULL(Par_NumIdentificacion, Cadena_Vacia);
    SET Par_FechaExpIdentif		:= IFNULL(Par_FechaExpIdentif, 	Fecha_Vacia);
    SET Par_FechaVencIdentif	:= IFNULL(Par_FechaVencIdentif, Fecha_Vacia);


	UPDATE AVALES SET
		TipoPersona     	= Par_TipoPersona,
		RazonSocial     	= Par_RazonSocial,
		PrimerNombre    	= Par_PrimerNom,
		SegundoNombre   	= Par_SegundoNom,
		TercerNombre    	= Par_TercerNom,

		ApellidoPaterno 	= Par_ApellidoPat,
		ApellidoMaterno 	= Par_ApellidoMat,
		FechaNac			= Par_FechaNac,
		RFC             	= Par_RFC,
		Telefono        	= Par_Telefono,

		TelefonoCel	  		= Par_TelefonoCel,
		NombreCompleto  	= Var_NombreComp,
		Calle           	= Par_Calle,
		NumExteriOR     	= Par_NumExterior,
		NumInteriOR     	= Par_NumInterior,

		Manzana         	= Par_Manzana,
		Lote            	= Par_Lote,
		Colonia         	= Par_Colonia,
		MunicipioID     	= Par_MunicipioID,
		EstadoID        	= Par_EstadoID,

		CP              	= Par_CP,
		Latitud         	= Par_Latitud,
		Longitud        	= Par_Longitud,
		RFCpm		 		= Par_RFCpm,
		ColoniaID			= Par_ColoniaID,

		LocalidadID			= Par_LocalidadID,
		Sexo				= Par_Sexo,
		EstadoCivil			= Par_EstadoCivil,
		DireccionCompleta	= Var_DirecCompl,
		ExtTelefonoPart 	= Par_ExtTelefonoPart,

		Nacion				= Par_Nacion,
		LugarNacimiento		= Par_LugarNacimiento,
		OcupacionID			= Par_OcupacionID,
		Puesto				= Par_Puesto,
		DomicilioTrabajo	= Par_DomicilioTrabajo,

		TelefonoTrabajo		= Par_TelefonoTrabajo,
		ExtTelTrabajo		= Par_ExtTelTrabajo,
		NumIdentific		= Par_NumIdentificacion,
        FecExIden			= Par_FechaExpIdentif,
        FecVenIden			= Par_FechaVencIdentif,

		SoloNombres			= Var_SoloNombres,
		SoloApellidos		= Var_SoloApellidos,
		RazonSocialPLD		= Var_RazonSocialPLD,
		EmpresaID       	= Aud_EmpresaID,
		Usuario         	= Aud_Usuario,

		FechaActual     	= Aud_FechaActual,
		DireccionIP     	= Aud_DireccionIP,
		ProgramaID      	= Aud_ProgramaID,
		Sucursal        	= Aud_Sucursal,
		NumTransaccion  	= Aud_NumTransaccion
	WHERE AvalID  		= Par_AvalID;

    IF(Par_TipoPersona = Per_Moral) THEN
		SELECT COUNT(AvalID)
		 INTO Var_NumRegistros
			FROM ESCPUBAVALES
			WHERE AvalID = Par_AvalID;

		IF(Var_NumRegistros > Entero_Cero) THEN
			CALL ESCPUBAVALESMOD(
				Var_AvalID,			Par_Esc_Tipo,		Par_NomApoder,		Par_RFC_Apoder,		Par_EscriPub,
				Par_LibroEscr,		Par_VolumenEsc,  	Par_FechaEsc,		Par_EstadoIDEsc,	Par_LocalEsc,
				Par_Notaria,		Par_DirecNotar,    	Par_NomNotario,		Par_RegistroPub,	Par_FolioRegPub,
				Par_VolRegPub,		Par_LibroRegPub,	Par_AuxiRegPub,		Par_FechaRegPub,	Par_EstadoIDReg,
				Par_LocalRegPub,	SalidaNO, 			Par_NumErr,	        Par_ErrMen,         Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);

			IF(IFNULL(Par_NumErr,Entero_Cero) != Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;
		ELSE
			 CALL ESCPUBAVALESALT(
				Var_AvalID,			Par_Esc_Tipo,		Par_NomApoder,		Par_RFC_Apoder,		Par_EscriPub,
				Par_LibroEscr,		Par_VolumenEsc,  	Par_FechaEsc,		Par_EstadoIDEsc,	Par_LocalEsc,
				Par_Notaria,		Par_DirecNotar,    	Par_NomNotario,		Par_RegistroPub,	Par_FolioRegPub,
				Par_VolRegPub,		Par_LibroRegPub,	Par_AuxiRegPub,		Par_FechaRegPub,	Par_EstadoIDReg,
				Par_LocalRegPub,	SalidaNO, 			Par_NumErr,			Par_ErrMen,         Tipo_Modificar,
				Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(IFNULL(Par_NumErr,Entero_Cero) != Entero_Cero)THEN
				LEAVE ManejoErrores;
            END IF;
		END IF;
	END IF;

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Aval Modificado Exitosamente: ',Par_AvalID);
	SET Var_Control := 'avalID';

END ManejoErrores;

IF(Par_Salida = SalidaSI)THEN
    SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS control,
        Par_AvalID AS consecutivo;
END IF;

END TerminaStore$$

