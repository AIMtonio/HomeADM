-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCIONCTEWSVBCALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCIONCTEWSVBCALT`;DELIMITER $$

CREATE PROCEDURE `DIRECCIONCTEWSVBCALT`(
    /*SP para Alta de Direcciones del Clientes para Web Service de ZAFI*/
    Par_ClienteID           INT(11),            -- CLIENTE
    Par_DireccionID         INT(11),            -- DIRECCION
    Par_EstadoID            INT(11),            -- ESTADO
    Par_MunicipioID         INT(11),            -- MUNICIPIO
    Par_LocalidadID         INT(11),            -- LOCALIDAD

    Par_ColoniaID           INT(11),            -- COLONIA
    Par_Calle               VARCHAR(100),       -- CALLE
    Par_NumeroCasa          CHAR(10),           -- NUM CASA
    Par_CP                  VARCHAR(15),        -- CP
    Par_Oficial             CHAR(5),            -- OFICIAL

    Par_Fiscal              CHAR(5),            -- FISCAL
    Par_NumInterior         CHAR(10),           -- NUM INTERIOR
    Par_Lote                CHAR(50),           -- LOTE
    Par_Manzana             CHAR(50),           -- MANZANA
    Par_Usuario             VARCHAR(15),        -- USUARIO

    Par_Clave               VARCHAR(100),       -- CLAVE
    Par_Salida              CHAR(1),            -- SALIDA
    INOUT Par_NumErr        INT(11),            -- NUM ERR
    INOUT Par_ErrMen        VARCHAR(400),       -- ERR MEN

    Par_EmpresaID           INT(11),            -- AUDITORIA
    Aud_Usuario             INT(11),            -- AUDITORIA
    Aud_FechaActual         DATETIME,           -- AUDITORIA
    Aud_DireccionIP         VARCHAR(15),        -- AUDITORIA
    Aud_ProgramaID          VARCHAR(50),        -- AUDITORIA
    Aud_Sucursal            INT(11),            -- AUDITORIA
    Aud_NumTransaccion      BIGINT(20)          -- AUDITORIA
    )
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Estatus_Activo      CHAR(1);            -- ESTATUS ACTIVO
DECLARE Cadena_Vacia        CHAR(1);            -- CADENA VACIA
DECLARE Fecha_Vacia         DATE;               -- FECHA VACIA
DECLARE Entero_Cero         INT;                -- ENTERO CERO
DECLARE SiOficial           CHAR(1);            -- SI
DECLARE Salida_SI           CHAR(1);            -- SALIDA SI
DECLARE Salida_No           CHAR(1);            -- SALIDA NO
DECLARE Var_SI              CHAR(1);            -- SI
DECLARE Var_NO              CHAR(1);            -- NO
DECLARE Inactivo            CHAR(1);            -- INACTIVO
DECLARE TipoDirecID         INT(11);            -- TIPO DIREC
--
-- Declaracion de Variables
DECLARE Var_DirID           CHAR(1);            -- DIR ID
DECLARE Var_DirIDF          CHAR(1);            -- DIR OF
DECLARE Var_Estatus         CHAR(1);            -- ESTATUS
DECLARE Var_Control         VARCHAR(25);        -- CONTROL
DECLARE Var_NombreColonia   VARCHAR(150);       -- NOMBRE COLONIA

DECLARE Var_NumErr          INT(11);            -- Numero de Error
DECLARE Var_MenErr          VARCHAR(400);       -- Mensaje de Error
DECLARE Var_DirecID         INT(11);            -- DIR ID
DECLARE Var_CodigoResp      VARCHAR(5);         -- CODIGO RES
DECLARE Var_MensajeResp     VARCHAR(150);       -- MENSAJE RESP

DECLARE NumeroDireccion     INT(11);            -- NUM DIR
DECLARE DirecCompleta       VARCHAR(500);       -- DIR COMPLETA
DECLARE NombEstado          VARCHAR(50);        -- NOMBRE ESTADO
DECLARE NombMunicipio       VARCHAR(50);        -- NOMBRE MUNICIPIO
DECLARE SimbInterrogacion   CHAR(1);            -- SIM INTERROGA
DECLARE Var_PerfilWsVbc     INT(11);            -- PERFIL OPERACIONES VBC
DECLARE MinCP               INT(11);            -- Caracteres para CP
DECLARE MaxCalle            INT(11);            -- Maximo de Caracteres

-- Asignacion de Constantes
SET Estatus_Activo    := 'A';           -- Estatus Activo
SET Cadena_Vacia    := '';              -- Cadena vacia
SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero     := 0;               -- Entero Cero
SET Salida_SI     := 'S';               -- Salida SI
SET Salida_No     := 'N';               -- Salida No
SET Var_SI        := 'S';               -- Si
SET Var_NO        := 'N';               -- Si
SET Inactivo      := 'I';               -- Estatus inactivo del cliente
SET TipoDirecID     := 1;               -- Tipo de Direccion Oficial

SET NumeroDireccion   := 0;             -- Numero de Direccion para dar de alta una nueva
SET DirecCompleta   := '';              -- DireccionCompleta
SET NombEstado      := '';              -- NombEstado
SET NombMunicipio   := '';              -- NombMunicipio
SET SimbInterrogacion   := '?';         -- Simbolo de interrogación
SET MinCP               := 5;           -- Caracteres para CP
SET MaxCalle            := 50;          -- Longitud de 50 caracteres

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := '999';
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-DIRECCIONCTEWSVBCALT');
    END;


    SET Par_Calle       := REPLACE(Par_Calle, SimbInterrogacion, Cadena_Vacia);
    SET Par_Calle       := RTRIM(LTRIM(IFNULL(Par_Calle, Cadena_Vacia)));
    SET Par_Calle       := UPPER(Par_Calle);
    SET Par_NumeroCasa  := REPLACE(Par_NumeroCasa, SimbInterrogacion, Cadena_Vacia);
    SET Par_NumeroCasa  := RTRIM(LTRIM(IFNULL(Par_NumeroCasa, Cadena_Vacia)));
    SET Par_NumeroCasa  := UPPER(Par_NumeroCasa);
    SET Par_CP          := REPLACE(Par_CP, SimbInterrogacion, Cadena_Vacia);
    SET Par_CP          := RTRIM(LTRIM(IFNULL(Par_CP, Cadena_Vacia)));
    SET Par_Oficial     := REPLACE(Par_Oficial, SimbInterrogacion, Cadena_Vacia);
    SET Par_Oficial     := RTRIM(LTRIM(IFNULL(Par_Oficial, Cadena_Vacia)));
    SET Par_Oficial     := UPPER(Par_Oficial);
    SET Par_Fiscal      := REPLACE(Par_Fiscal, SimbInterrogacion, Cadena_Vacia);
    SET Par_Fiscal      := RTRIM(LTRIM(IFNULL(Par_Fiscal, Cadena_Vacia)));
    SET Par_Fiscal      := UPPER(Par_Fiscal);
    SET Par_NumInterior := REPLACE(Par_NumInterior, SimbInterrogacion, Cadena_Vacia);
    SET Par_NumInterior := RTRIM(LTRIM(IFNULL(Par_NumInterior, Cadena_Vacia)));
    SET Par_NumInterior := UPPER(Par_NumInterior);
    SET Par_Lote        := REPLACE(Par_Lote, SimbInterrogacion, Cadena_Vacia);
    SET Par_Lote        := RTRIM(LTRIM(IFNULL(Par_Lote, Cadena_Vacia)));
    SET Par_Lote        := UPPER(Par_Lote);
    SET Par_Manzana     := REPLACE(Par_Manzana, SimbInterrogacion, Cadena_Vacia);
    SET Par_Manzana     := RTRIM(LTRIM(IFNULL(Par_Manzana, Cadena_Vacia)));
    SET Par_Manzana     := UPPER(Par_Manzana);
    SET Par_Usuario     := REPLACE(Par_Usuario, SimbInterrogacion, Cadena_Vacia);
    SET Par_Clave       := REPLACE(Par_Clave, SimbInterrogacion, Cadena_Vacia);

    SET Var_PerfilWsVbc     := (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc     := IFNULL(Var_PerfilWsVbc,Entero_Cero);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
        SET Par_NumErr      := '60';
        SET Par_ErrMen      := 'No existe perfil definido para el usuario.';
        LEAVE ManejoErrores;
    END IF;

    IF IFNULL(Par_Usuario, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '25';
        SET Par_ErrMen      := 'El Usuario esta Vacio.';
        LEAVE ManejoErrores;
    END IF;
    IF IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '26';
        SET Par_ErrMen      := 'La Clave del Usuario esta Vacia.';
        LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS (SELECT Clave
                    FROM USUARIOS
                    WHERE Clave = Par_Usuario AND Contrasenia = Par_Clave And Estatus = Estatus_Activo AND RolID = Var_PerfilWsVbc) THEN
        SET Par_NumErr      := '27';
        SET Par_ErrMen      := 'El Usuario o la Clave Son Incorrectos.';
        LEAVE ManejoErrores;
    END IF;


    IF NOT EXISTS(SELECT ClienteID FROM CLIENTES
                       WHERE ClienteID = Par_ClienteID) THEN
        SET Par_NumErr      := '14';
        SET Par_ErrMen     := 'El Cliente Especificado No Existe.';
        LEAVE ManejoErrores;
    END IF;

    SELECT Estatus INTO Var_Estatus
        FROM CLIENTES
        WHERE ClienteID=Par_ClienteID;

    IF(Var_Estatus=Inactivo)THEN
        SET Par_NumErr      := '01';
        SET Par_ErrMen      := 'El Cliente se Encuentra Inactivo.';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_DireccionID, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := '16';
        SET Par_ErrMen      :=  'La Direccion ID esta Vacio.' ;
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr      := '02';
        SET Par_ErrMen      := 'El Estado esta Vacio.';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
                       WHERE EstadoID = Par_EstadoID
                       LIMIT 1)THEN
        SET Par_NumErr      := '15';
        SET Par_ErrMen     := 'El Estado No Existe.';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_MunicipioID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr      := '03';
        SET Par_ErrMen     := 'El Municipio esta Vacio.';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
                       WHERE EstadoID = Par_EstadoID AND MunicipioID = Par_MunicipioID)THEN
        SET Par_NumErr      := '16';
        SET Par_ErrMen     := 'El Municipio Especificado No Existe.';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_LocalidadID,Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr      := '08';
        SET Par_ErrMen     := 'La Localidad esta Vacia.';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
                       WHERE EstadoID = Par_EstadoID AND MunicipioID = Par_MunicipioID AND LocalidadID = Par_LocalidadID)THEN
        SET Par_NumErr      := '17';
        SET Par_ErrMen     := 'La Localidad Especificada No Existe.';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_ColoniaID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr      := '06';
        SET Par_ErrMen     := 'La Colonia Esta Vacia.';
        LEAVE ManejoErrores;
    END IF;
    IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
                       WHERE EstadoID = Par_EstadoID AND MunicipioID = Par_MunicipioID AND ColoniaID = Par_ColoniaID)THEN
        SET Par_NumErr      := '18';
        SET Par_ErrMen     := 'La Colonia Especificada No Existe.';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := '04';
        SET Par_ErrMen     := 'La Calle esta Vacia.';
        LEAVE ManejoErrores;
    END IF;
     IF(CHARACTER_LENGTH(Par_Calle) > MaxCalle)THEN
        SET Par_NumErr := '04';
        SET Par_ErrMen := 'La Calle debe ser Maximo 50 Caracteres.' ;
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_NumeroCasa, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := '05';
        SET Par_ErrMen     := 'El Numero de Casa esta Vacia.';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_CP, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr      := '07';
        SET Par_ErrMen     := 'El Codigo Postal esta Vacio.';
        LEAVE ManejoErrores;
    END IF;
    IF(CHARACTER_LENGTH(Par_CP) != MinCP)THEN
        SET Par_NumErr := '07';
        SET Par_ErrMen := 'Se requieren 05 Digitos para el Codigo Postal.' ;
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_Oficial, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := '19';
        SET Par_ErrMen     := 'Especifique si la Direccion es Oficial.';
        LEAVE ManejoErrores;
    END IF;
    IF Par_Oficial NOT IN (Var_SI, Var_NO) THEN
        SET Par_NumErr      := '20';
        SET Par_ErrMen     := 'Caracter Incorrecto para Direccion Oficial.';
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_Fiscal, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := '21';
        SET Par_ErrMen     := 'Especifique si la Direccion es Fiscal.';
        LEAVE ManejoErrores;
    END IF;
    IF Par_Fiscal NOT IN (Var_SI, Var_NO) THEN
        SET Par_NumErr      := '22';
        SET Par_ErrMen     := 'Caracter Incorrecto para Direccion Fiscal.';
        LEAVE ManejoErrores;
    END IF;
    SET Par_Lote := IFNULL(Par_Lote, Cadena_Vacia);
    SET Par_Manzana := IFNULL(Par_Manzana, Cadena_Vacia);

    SET Var_DirID := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Oficial=Var_SI);

    IF(IFNULL(Var_DirID,Entero_Cero) <> Entero_Cero AND  Par_Oficial = Var_SI ) THEN
        SET Par_NumErr      := '09';
        SET Par_ErrMen     := 'El cliente ya tiene una Direccion Oficial.';
        LEAVE ManejoErrores;
    END IF;

    SET Var_DirIDF := (SELECT DireccionID FROM DIRECCLIENTE WHERE ClienteID= Par_ClienteID AND Fiscal=Var_SI);

    IF(IFNULL(Var_DirIDF,Entero_Cero) <> Entero_Cero AND  Par_Fiscal = Var_SI ) THEN
        SET Par_NumErr      := '10';
        SET Par_ErrMen     := 'El Cliente ya tiene una Direccion Fiscal.';
        LEAVE ManejoErrores;
    END IF;

    SET Var_NombreColonia := (SELECT Asentamiento
        FROM COLONIASREPUB
        WHERE EstadoID= Par_EstadoID and MunicipioID = Par_MunicipioID and ColoniaID = Par_ColoniaID );

    SET Aud_FechaActual = NOW();

    CALL DIRECCIONCTEALT(
            Par_ClienteID,  TipoDirecID,    Par_EstadoID,   Par_MunicipioID,    Par_LocalidadID,
            Par_ColoniaID,  Var_NombreColonia,  Par_Calle,  Par_NumeroCasa,     Par_NumInterior ,
            Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Par_CP,             Cadena_Vacia,
            Cadena_Vacia,   Cadena_Vacia,   Par_Oficial,    Par_Fiscal,         Par_Lote,
            Par_Manzana,    Salida_No,      Var_NumErr,     Var_MenErr,         Var_DirecID,
            Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion);

    IF(IFNULL(CAST(Var_NumErr AS UNSIGNED),Entero_Cero) != Entero_Cero) THEN
        SET Var_DirecID     := 00;
        SET Par_NumErr      := CAST(Var_NumErr AS CHAR);
        SET Par_ErrMen      := Var_MenErr;
        LEAVE ManejoErrores;
    ELSE
        SET Par_NumErr      := '00';
        SET Par_ErrMen      := 'Direcion Agregada Exitosamente.';
    END IF;

END ManejoErrores;

    IF Par_Salida = Salida_SI THEN
        SELECT
        Par_NumErr      AS codigoRespuesta,
        Par_ErrMen     AS mensajeRespuesta,
        Var_DirecID  AS direccionID;
    END IF;
END TerminaStore$$