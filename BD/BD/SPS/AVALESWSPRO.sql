-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESWSPRO`;DELIMITER $$

CREATE PROCEDURE `AVALESWSPRO`(
    -- SP PARA DAR DE ALTA LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
    Par_AvalID              BIGINT(20),     -- ID del Aval
    Par_TipoPersona         CHAR(1),        -- Tipo de persona F.- Fisica M.- Moral A.- Fisica con act empresarial
    Par_PrimerNom         VARCHAR(50),      -- Primer nombre del aval
    Par_SegundoNom          VARCHAR(50),    -- Segundo nombre del aval
    Par_TercerNom           VARCHAR(50),    -- Tercer nombre del aval

    Par_ApellidoPat         VARCHAR(50),    -- Apellido paterno
    Par_ApellidoMat         VARCHAR(50),    -- Apellido MAterno
    Par_FechaNac            DATE,           -- Fecha de nacimiento
    Par_RFC                 CHAR(13),       -- Numero del RFC
    Par_Telefono            CHAR(13),       -- Telefono de casa

    Par_TelefonoCel         VARCHAR(13),    -- Numero de telefono celular
    Par_Calle               VARCHAR(50),    -- Nombre de la calle
    Par_NumExterior         CHAR(10),       -- Numero exterior
    Par_NumInterior         CHAR(10),       -- Numero Interior
    Par_MunicipioID         INT(11),        -- Numero del municipio

    Par_EstadoID            INT(11),        -- Numero del estado
    Par_CP                  VARCHAR(5),     -- Codigo postal
    Par_LocalidadID         INT(11),        -- Numero de la localidad
    Par_ColoniaID           INT(11),        -- Numero de la colonia
    Par_Sexo                CHAR(1),        -- Sexo

    Par_Usuario             VARCHAR(400),   -- USUARIO
    Par_Clave               VARCHAR(400),   -- CLAVE
    Par_Salida              CHAR(1),        -- Indica el tipo de salida del sp
    INOUT Par_NumErr        INT,            -- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),   -- Mensaje de error

    Aud_EmpresaID           INT(11),        -- Parametro de Auditoria
    Aud_Usuario             INT(11),        -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,       -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Parametro de Auditoria

    Aud_Sucursal            INT(11),        -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Parametro de Auditoria
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control             VARCHAR(50);
DECLARE Var_PerfilWsVbc			INT(11);		-- PERFIL OPERACIONES VBC


-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATE;
DECLARE Entero_Cero             INT;
DECLARE Var_SI                  CHAR(1);
DECLARE Var_NO                  CHAR(1);

DECLARE Var_OpAlta              INT;            -- Operacion de Alta
DECLARE Var_OpMod               INT;            -- Operacion de Alta
DECLARE Est_Activo              CHAR(1);        -- Estatus Activo
DECLARE Var_Soltero             CHAR(1);        -- Soltero
DECLARE Par_Manzana             VARCHAR(20);    -- Manzana
DECLARE Par_Lote                VARCHAR(20);    -- Lote del domicilio
DECLARE Par_Colonia             VARCHAR(200);   -- Nombre de la colonia
DECLARE Per_Fisica              CHAR(1);        -- Persona Fisica
DECLARE Per_ActEmp              CHAR(1);        -- Persona Fisica con Actividad Empresaria
DECLARE Per_Moral               CHAR(1);        -- Persona Moral
DECLARE Var_ValidaRFC           CHAR(13);       -- RFC del aval
DECLARE Par_LugarNacimiento     INT(11);        -- Pais de Nacimiento
DECLARE Par_Nacion              CHAR(1);        -- Nacionalidad del aval N.- Nacional E.- Extranjero
DECLARE Par_RazonSocial         VARCHAR(50);    -- Nombre de la razon social
DECLARE Par_Latitud             VARCHAR(45);    -- Latitud del domicilio
DECLARE Par_Longitud            VARCHAR(45);    -- Longitud del domicilio
DECLARE Par_RFCpm               VARCHAR(12);    -- RFC de una persona Moral
DECLARE Par_ExtTelefonoPart     VARCHAR(6);     -- Numero de extension del telefonO
DECLARE Var_LocalidadID         INT;            -- Numero de la localidad
DECLARE Var_ColoniaID           INT;            -- Numero de la colonia
DECLARE Par_EstadoCivil         CHAR(2);        /* Estado civil del aval S.-soltero, CS.-casado b. separados, CM.-casado b.
                                                mancomunados, CC.-casado b. man. con capitulacion, V.-viudo, D.-divorciado,
                                                SE.-separado, U.-union libre */
DECLARE Var_ClienteID           INT(11);        -- Numero de cliente (validacion rfc)
DECLARE Var_Ocupacion			INT(11);		-- OTROS TRABAJADORES CON OCUPACIONES INSUFICIENTEMENTE ESPECIFICADAS


-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia            := '';              -- Cadena Vacia
SET Fecha_Vacia             := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero             := 0;               -- Entero en Cero
SET Var_SI                  := 'S';             -- Permite Salida SI
SET Var_NO                  := 'N';             -- Permite Salida NO
SET Var_Soltero             := 'S';             -- Valor de Soltero
SET Var_OpAlta              := 1;               -- Opcion de Alta
SET Var_OpMod               := 2;               -- Opcion de Modifica
SET Est_Activo              := 'A';             -- Estatus Activo
SET Per_Fisica              := 'F';             -- Tipo de Persona fisica
SET Per_ActEmp              := 'A';             -- Tipo de Persona fisica con act empresarial
SET Per_Moral               := 'M';             -- Tipo de Persona moral
SET Var_Ocupacion			:= 9999;			-- OTROS TRABAJADORES CON OCUPACIONES INSUFICIENTEMENTE ESPECIFICADAS

-- ASIGNACION DE VARIABLES
SET Aud_FechaActual         := NOW();           -- FECHA ACTUAL

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-AVALESWSPRO');
            SET Var_Control = 'sqlException';
        END;


    -- **************************************************************************************
    -- SE VALIDA EL USUARIO   *******************
    -- **************************************************************************************
    SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
    	SET Par_NumErr		:= '60';
		SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
		LEAVE ManejoErrores;
    END IF;


    SET Aud_Usuario := (SELECT UsuarioID
                            FROM USUARIOS
                            WHERE Clave = Par_Usuario
                                AND Contrasenia = Par_Clave
                                AND Estatus = Est_Activo  AND RolID = Var_PerfilWsVbc);

    SET Aud_Usuario := IFNULL(Aud_Usuario, Entero_Cero);
    IF(Aud_Usuario = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "Usuario o Password no valido";
        LEAVE ManejoErrores;
    END IF;


    /** VALIDACIONES *************************************************************/
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

    IF(IFNULL(Par_NumExterior, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 005;
        SET Par_ErrMen := CONCAT('El Numero Exterior esta Vacio.');
        SET Var_Control := 'numExterior';
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

     IF(Par_TipoPersona != Per_Fisica) THEN
        SET Par_NumErr  := 010;
        SET Par_ErrMen  := CONCAT('Valor invalido para Tipo de Persona.');
        SET Var_Control := 'razonSocial';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia  THEN
        SET Par_NumErr := 020;
        SET Par_ErrMen := CONCAT('El sexo del Aval no esta indicado.');
        SET Var_Control := 'sexo';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaNac, Fecha_Vacia) = Fecha_Vacia )  THEN
        SET Par_NumErr := 020;
        SET Par_ErrMen := CONCAT('La Fecha de Nacimiento esta Vacia.');
        SET Var_Control := 'sexo';
        LEAVE ManejoErrores;
    END IF;


    IF(IFNULL(Par_LocalidadID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr := 022;
        SET Par_ErrMen := CONCAT('La localidad del Aval no esta indicado.');
        SET Var_Control := 'localidadID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr := 023;
        SET Par_ErrMen := CONCAT('La colonia del Aval no esta indicada.');
        SET Var_Control := 'coloniaID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LocalidadID, Entero_Cero))<> Entero_Cero THEN
        SELECT LocalidadID INTO Var_LocalidadID
            FROM LOCALIDADREPUB
                WHERE LocalidadID = Par_LocalidadID
                    AND MunicipioID =Par_MunicipioID
                    AND EstadoID=Par_EstadoID;
        IF(IFNULL(Var_LocalidadID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 024;
            SET Par_ErrMen := CONCAT('La localidad especificada no existe.');
            SET Var_Control := 'localidadID';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_ColoniaID, Entero_Cero))<> Entero_Cero THEN
        SELECT ColoniaID INTO Var_ColoniaID
            FROM COLONIASREPUB
                WHERE ColoniaID = Par_ColoniaID
                    AND MunicipioID =Par_MunicipioID
                    AND EstadoID=Par_EstadoID;
        IF(IFNULL(Var_ColoniaID, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr := 025;
            SET Par_ErrMen := CONCAT('La colonia especificada no existe.');
            SET Var_Control := 'coloniaID';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SET Par_LugarNacimiento := Par_EstadoID;
    SET Par_Nacion          := 'N';
    SET Par_NumExterior     := IFNULL(Par_NumExterior,Cadena_Vacia);
    SET Par_CP              := IFNULL(Par_CP,Cadena_Vacia);
    SET Par_Lote            := IFNULL(Par_Lote, Cadena_Vacia);
    SET Par_Manzana         := IFNULL(Par_Manzana, Cadena_Vacia);
    SET Par_RazonSocial     := IFNULL(Par_RazonSocial, Cadena_Vacia);
    SET Par_Latitud         := IFNULL(Par_Latitud, Cadena_Vacia);
    SET Par_RFCpm           := IFNULL(Par_RFCpm, Cadena_Vacia);
    SET Par_ExtTelefonoPart := IFNULL(Par_ExtTelefonoPart, Cadena_Vacia);
    SET Par_EstadoCivil     := Var_Soltero;


    SET Aud_FechaActual     := NOW();

    SET Par_Colonia         := (SELECT Asentamiento FROM COLONIASREPUB
                                    WHERE   ColoniaID   = Par_ColoniaID
                                        AND MunicipioID = Par_MunicipioID
                                        AND EstadoID    = Par_EstadoID);

    IF(IFNULL(Par_RFC, Cadena_Vacia)) = Cadena_Vacia THEN
        CALL CLIENTEWSRFCCAL(   /*SP Para generar el RFC del cliente*/
            CONCAT(Par_PrimerNom,' ',Par_SegundoNom,' ',Par_TercerNom),         Par_ApellidoPat,        Par_ApellidoMat,
            Par_FechaNac,           Par_Usuario,        Par_Clave,              Var_NO,                 Par_NumErr,
            Par_ErrMen,             Par_RFC,            Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,
            Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion
        );
    END IF;

    SET Var_ValidaRFC:=(SELECT  RFC FROM AVALES WHERE RFC = Par_RFC LIMIT 1);
    IF (Var_ValidaRFC = Par_RFC)THEN
        SET Par_NumErr := 014;
        SET Par_ErrMen := CONCAT('Existe Otro Aval con el Mismo RFC.');
        SET Var_Control := 'RFC';
        LEAVE ManejoErrores;
    END IF;

    SELECT  ClienteID,      RFC
      INTO  Var_ClienteID,  Var_ValidaRFC
        FROM CLIENTES
            WHERE RFC = Par_RFC LIMIT 1;

    IF(Var_ValidaRFC = Par_RFC)THEN
        SET Par_NumErr := 027;
        SET Par_ErrMen := CONCAT('El RFC ',Par_RFC,
            ' esta registrado con el safilocale.cliente ', LPAD(Var_ClienteID,10,'0'),
            ', favor de utilizar la pantalla de Asignacion Aval.');
        SET Var_Control := 'RFC';
        LEAVE ManejoErrores;
    END IF;
            SELECT  ProspectoID, RFC
        INTO    Var_ClienteID,  Var_ValidaRFC
            FROM PROSPECTOS WHERE RFC = Par_RFC;

   IF(Var_ValidaRFC = Par_RFC)THEN
        SET Par_NumErr := 028;
        SET Par_ErrMen := CONCAT('El RFC ',Par_RFC,
            ' esta registrado con el Prospecto ', LPAD(Var_ClienteID,10,'0'),
            ', favor de utilizar la pantalla de Asignacion Aval.');
        SET Var_Control := 'RFC';
        LEAVE ManejoErrores;
    END IF;




    /* =================== SP DE ALTA DE AVALES ======================= */
	-- Se modifica el llamado para incluir parametros de entrada. Cardinal Sistemas Inteligentes
	CALL AVALESALT(
			Par_PrimerNom,		Par_SegundoNom,		Par_TercerNom,			Par_ApellidoPat,		Par_ApellidoMat,
			Par_Telefono,		Par_Calle,			Par_NumExterior,		Par_NumInterior,		Par_Manzana,
			Par_Lote,			Par_Colonia,		Par_LocalidadID,		Par_ColoniaID,			Par_MunicipioID,
			Par_EstadoID,		Par_CP,				Par_TipoPersona,		Par_RazonSocial,		Par_RFC,
			Par_Latitud,		Par_Longitud,		Par_FechaNac,			Par_TelefonoCel,		Par_RFCpm,
			Par_Sexo,			Par_EstadoCivil,	Par_ExtTelefonoPart,	Cadena_Vacia,			Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Fecha_Vacia,
			Entero_Cero,		Entero_Cero,		Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,
			Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
			Fecha_Vacia,		Entero_Cero,		Entero_Cero,			Par_Nacion,				Par_LugarNacimiento,
			Var_Ocupacion,		Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,
            Cadena_Vacia,		Fecha_Vacia,		Fecha_Vacia,			Var_NO,					Par_NumErr,
			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
    );
	-- Fin de modificacion del llamado a AVALESALT. Cardinal Sistemas Inteligentes

    IF(Par_NumErr != Entero_Cero )THEN
        LEAVE ManejoErrores;
    END IF;

    SET Par_NumErr      := 0;
    SET Par_ErrMen      := CONCAT(Par_ErrMen);

END ManejoErrores;

IF(Par_Salida = Var_SI)THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$