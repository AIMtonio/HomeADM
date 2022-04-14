-- USUARIOSERARCHIVOACT

DELIMITER ;

DROP PROCEDURE IF EXISTS `USUARIOSERARCHIVOACT`;

DELIMITER $$

CREATE PROCEDURE `USUARIOSERARCHIVOACT`(
-- ===========================================================================
-- ------- STORED PARA ACTUALIZAR EL ARCHIVO DEL USUARIO DE SERVICIO ---------
-- ===========================================================================
    Par_UsuarioServicioID   INT(11),            -- Numero de Usuario de servicio
    Par_TipoDocumentoID     INT(11),            -- Tipo de ocumento
    Par_Observacion         VARCHAR(200),       -- Observacion del Archivo
    Par_Recurso             VARCHAR(500),       -- Recurso del Archivo
    Par_Extension           VARCHAR(50),        -- Extension del Archivo

    Par_Salida              CHAR(1),            -- Parametro de salida S= si, N= no
    INOUT Par_NumErr        INT(11),            -- Parametro de salida numero de error
    INOUT Par_ErrMen        VARCHAR(400),       -- Parametro de salida mensaje de error

    Par_EmpresaID           INT(11),            -- Parametro de auditoria ID de la empresa
    Aud_Usuario             INT(11),            -- Parametro de auditoria ID del usuario
    Aud_FechaActual         DATETIME,           -- Parametro de auditoria Fecha actual
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de auditoria Direccion IP
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de auditoria Programa
    Aud_Sucursal            INT(11),            -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo         VARCHAR(100);       -- Variable consecutivo
    DECLARE Var_Control             VARCHAR(100);       -- Variable de Control
    DECLARE Var_Fechasistema        DATE;               -- Fecha del Sistema
    DECLARE Var_UsuarioServicioID   INT(11);            -- Almacena el Numero de Usuario
    DECLARE Var_TipoDocumentoID     INT(11);            -- Almacena el Tipo de Documento

    DECLARE Var_DesTipDoc           VARCHAR(60);        -- Almacena la Descripcion del Tipo de Documento

    -- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Cadena Vacia ''
    DECLARE Fecha_Vacia         DATE;               -- Constante Fecha Vacia 1900-01-01
    DECLARE Entero_Cero         INT(1);             -- Constante Entero Cero 0
    DECLARE Decimal_Cero        DECIMAL(14,2);      -- Decimal Cero
    DECLARE Salida_SI           CHAR(1);            -- Parametro de Salida SI

    DECLARE Salida_NO           CHAR(1);            -- Parametro de Salida NO
    DECLARE Cons_SI             CHAR(1);            -- Constante  S, valor si
    DECLARE Cons_NO             CHAR(1);            -- Constante  N, valor no

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia            := '';
    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Cero             := 0;
    SET Decimal_Cero            := 0.0;
    SET Salida_SI               := 'S';

    SET Salida_NO               := 'N';
    SET Cons_SI                 := 'S';
    SET Cons_NO                 := 'N';

    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            GET DIAGNOSTICS condition 1
            @Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
            SET Par_NumErr = 999;
            SET Par_ErrMen = LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                 'esto le ocasiona. Ref: SP-USUARIOSERARCHIVOACT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
            SET Var_Control = 'SQLEXCEPTION';
        END;

        -- SE OBTIENE LA FECHA DEL SISTEMA
        SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

        SELECT UsuarioServicioID
        INTO Var_UsuarioServicioID
        FROM USUARIOSERVICIO
        WHERE UsuarioServicioID = Par_UsuarioServicioID;

        SET Var_UsuarioServicioID   := IFNULL(Var_UsuarioServicioID, Entero_Cero);

        IF(Var_UsuarioServicioID = Entero_Cero) THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El Numero de Usuario No Existe.';
            SET Var_Control := 'usuarioID';
            LEAVE ManejoErrores;
        END IF;

        SELECT TipoDocumentoID
        INTO Var_TipoDocumentoID
        FROM TIPOSDOCUMENTOS
        WHERE TipoDocumentoID = Par_TipoDocumentoID;

        SET Var_TipoDocumentoID   := IFNULL(Var_TipoDocumentoID, Entero_Cero);

        IF(Var_TipoDocumentoID = Entero_Cero) THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'El Tipo de documento no Existe.';
            SET Var_Control := 'usuarioID';
            LEAVE ManejoErrores;
        END IF;

        SELECT Descripcion
        INTO Var_DesTipDoc
        FROM TIPOSDOCUMENTOS
        WHERE TipoDocumentoID = Par_TipoDocumentoID;

        SET Par_Extension   := IFNULL(Par_Extension,Cadena_Vacia);

        SET Aud_FechaActual := NOW();

        UPDATE USUARIOSERARCHIVO
        SET Observacion     = Par_Observacion,
            Recurso         = CONCAT(Par_Recurso,Var_DesTipDoc,"/Archivo", RIGHT(CONCAT("00000",CONVERT(Consecutivo, char)), 5),Par_Extension),
            FechaRegistro   = Var_FechaSistema,
            EmpresaID       = Par_EmpresaID,
            Usuario         = Aud_Usuario,
            FechaActual     = Aud_FechaActual,
            DireccionIP     = Aud_DireccionIP,
            ProgramaID      = Aud_ProgramaID,
            Sucursal        = Aud_Sucursal,
            NumTransaccion  = Aud_NumTransaccion
        WHERE UsuarioServicioID = Par_UsuarioServicioID
        AND TipoDocumento   = Par_TipoDocumentoID;

        SET Par_NumErr      := 0;
        SET Par_ErrMen      := CONCAT("El archivo se ha Actualizado Exitosamente; ", CONVERT(Par_TipoDocumentoID, CHAR));
        SET Var_Control     := 'usuarioID';
        SET Var_Consecutivo := Par_TipoDocumentoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) then
        SELECT
            Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$