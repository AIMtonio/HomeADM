-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORALOTEDEBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORALOTEDEBALT`;DELIMITER $$

CREATE PROCEDURE `BITACORALOTEDEBALT`(
-- ---------------------------------------------------------------------------------
-- STORED PROCEDURE PARA CARGA DE BITACORAS DE LOTES DE TARJETAS
-- ---------------------------------------------------------------------------------
    Par_BitCargaID      INT,            -- Parametro del id de carga
    Par_ConsecutivoBit  INT,            -- Parametro del consecutivo de carga
    Par_TipoTarjeDebID  INT,            -- Parametro del tipo de tarjeta (producto)
    Par_FechaRegistro   DATETIME,       -- Parametro de la fecha de registro
    Par_UsuarioID       INT,            -- Parametro del identificador de usuario
    Par_RutaArchivo     VARCHAR(200),   -- Parametro ruta del archivo cargado
    Par_NumRegistro     INT,            -- Parametro numero de registros cargados
    Par_NumTarjeta      CHAR(16),       -- Parametro numero de tarjeta cargada
    Par_Estatus         CHAR(1),        -- Parametro estatus de la tarjeta
    Par_MotivoFallo     VARCHAR(200),   -- Parametro motivo del fallo de carga
    Par_EmpresaID       INT,            -- Parametro Auditoria
    Par_FechaVencim     CHAR(5),        -- Parametro Fecha de vencimiento del lote
    Par_NIP             VARCHAR(256),   -- Parametro NIP de la tarjeta
    Par_NombreTarjeta   VARCHAR(250),   -- Parametro Nombre del Tarjetahabiente
    Par_NumFallos       INT,            -- Parametro lleva el contador de registros fallidos
    Par_NumExitos       INT,            -- Parametro lleva el contador de registros exito

    Par_Salida          CHAR(1),        -- Parametro Salida
    INOUT Par_NumErr    INT,            -- Parametro Salida
    INOUT Par_ErrMen    VARCHAR(200),   -- Parametro Salida

    Aud_Usuario         INT,            -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,       -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Parametro de Auditoria
    Aud_Sucursal        INT,            -- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT          -- Parametro de Auditoria
    )
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_TipoTarjeta     CHAR(1);
-- Declaracion de Constantes
DECLARE Entero_Cero     INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE SalidaSI        CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Usuario_Activo  CHAR(1);
DECLARE Tar_Activa      CHAR(1);
DECLARE EstatusFallo    CHAR(1);
DECLARE TipoCredito    CHAR(1);
DECLARE TipoDebito     CHAR(1);

-- Asignacion de Constantes
SET Entero_Cero     := 0;               -- Entero en Cero
SET Cadena_Vacia    := '';              -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
SET SalidaSI        := 'S';             -- El Store SI genera una Salida
SET SalidaNO        := 'N';             -- El Store NO genera una Salida
SET Usuario_Activo  := 'A';             -- Usuario: Activo
SET Tar_Activa      := 'A';             -- Tarjeta: Activo
SET EstatusFallo    := 'F';             -- Estatus Fallo.
SET TipoCredito     := 'C';             -- Tipo de tarjeta Credito
SET TipoDebito      := 'D';             -- Tipo de tarjeta Debito

ManejoErrores: BEGIN
DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-BITACORALOTEDEBALT');
      END;


-- Inicializacion
SET Par_NumErr          := Entero_Cero;
SET Par_ErrMen          := Cadena_Vacia;
SET Par_NumTarjeta      := IFNULL(Par_NumTarjeta, Cadena_Vacia);
SET Par_UsuarioID       := IFNULL(Par_UsuarioID, Entero_Cero);
SET Par_TipoTarjeDebID  := IFNULL(Par_TipoTarjeDebID, Entero_Cero);

SET Aud_FechaActual := CURRENT_TIMESTAMP();

    IF(IFNULL(Par_FechaRegistro, Fecha_Vacia)) = Fecha_Vacia THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'La Fecha de Registro esta Vacia';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaVencim, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'La Fecha de Vencimiento esta Vacia';
        LEAVE ManejoErrores;
    END IF;

    IF (Par_NumTarjeta  = Cadena_Vacia) THEN
        SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'El Numero de Tarjeta esta Vacio';
        LEAVE ManejoErrores;
    END IF;

    IF (CHAR_LENGTH(Par_NumTarjeta)  < 16) THEN
        SET Par_NumErr  := 4;
        SET Par_ErrMen  := 'Longitud del Numero de Tarjeta Incorrecto';
        LEAVE ManejoErrores;
    END IF;

    IF (Par_UsuarioID  = Entero_Cero) THEN
        SET Par_NumErr  := 5;
        SET Par_ErrMen  := 'Usuario que Registra Incorrecto';
        LEAVE ManejoErrores;
    END IF;

    IF(NOT EXISTS(SELECT Nombre
                    FROM USUARIOS
                    WHERE UsuarioID  = Par_UsuarioID
                    AND Estatus   = Usuario_Activo)) THEN

        SET Par_NumErr  := 6;
        SET Par_ErrMen  := 'El Usuario que Registra no Existe o no Esta Activo';
        LEAVE ManejoErrores;
    END IF;

    IF(NOT EXISTS(SELECT Descripcion
                    FROM TIPOTARJETADEB
                    WHERE TipoTarjetaDebID  = Par_TipoTarjeDebID
                    AND Estatus   = Tar_Activa)) THEN

        SET Par_NumErr  := 7;
        SET Par_ErrMen  := 'El Tipo Tarjeta no Existe';
        LEAVE ManejoErrores;

    END IF;

    SELECT TipoTarjeta
        INTO Var_TipoTarjeta
        FROM TIPOTARJETADEB
        WHERE TipoTarjetaDebID  = Par_TipoTarjeDebID
        AND Estatus   = Tar_Activa;

    IF (EXISTS(SELECT TarjetaDebID
                FROM TARJETADEBITO
                WHERE TarjetaDebID=Par_NumTarjeta))  THEN
        SET Par_NumErr          := 3;
        SET Par_ErrMen          := CONCAT('El Numero de Tarjeta ya se Encuentra Registrada');
        SET Par_MotivoFallo     := CONCAT('El Numero de Tarjeta ya se Encuentra Registrada');
        SET Par_Estatus          := EstatusFallo;
        SET Par_NumFallos       := IFNULL(Par_NumFallos, Entero_Cero)+1;
        SET Par_NumExitos       := IFNULL(Par_NumExitos, Entero_Cero)-1;
    END IF;

    IF (EXISTS(SELECT TarjetaCredID
                FROM TARJETACREDITO
                WHERE TarjetaCredID=Par_NumTarjeta))  THEN
        SET Par_NumErr          := 3;
        SET Par_ErrMen          := CONCAT('El Numero de Tarjeta ya se Encuentra Registrada');
        SET Par_MotivoFallo     := CONCAT('El Numero de Tarjeta ya se Encuentra Registrada');
        SET Par_Estatus          := EstatusFallo;
        SET Par_NumFallos       := IFNULL(Par_NumFallos, Entero_Cero)+1;
        SET Par_NumExitos       := IFNULL(Par_NumExitos, Entero_Cero)-1;
    END IF;

    IF (EXISTS(SELECT TarjetaDebID
                FROM BITACORALOTEDEB
                WHERE TarjetaDebID = Par_NumTarjeta AND BitCargaID = Par_BitCargaID))  THEN
        SET Par_NumErr      := 4;
        SET Par_ErrMen      := CONCAT('El Numero de Tarjeta ya se Encuentra Duplicada en el mismo Lote');
        SET Par_MotivoFallo := CONCAT('El Numero de Tarjeta ya se Encuentra Duplicada en el mismo Lote');
        SET Par_Estatus     := EstatusFallo;
        SET Par_NumFallos   := IFNULL(Par_NumFallos, Entero_Cero)+1;
        SET Par_NumExitos   := IFNULL(Par_NumExitos, Entero_Cero)-1;
    END IF;

    INSERT INTO BITACORALOTEDEB (
        `BitCargaID`,   `ConsecutivoBit`,   `TipoTarjetaDebID`, `FechaRegistro`,    `UsuarioID`,
        `RutaArchivo`,  `NumRegistro`,      `TarjetaDebID`,     `FechaVencimiento`, `NIP`,
        `NombreTarjeta`,`Estatus`,          `MotivoFallo`,      `EmpresaID`,        `Usuario`,
        `FechaActual`,  `DireccionIP`,      `ProgramaID`,       `Sucursal`,         `NumTransaccion`)
    VALUES(
        Par_BitCargaID,         Par_ConsecutivoBit,     Par_TipoTarjeDebID,     Par_FechaRegistro,      Par_UsuarioID,
        Par_RutaArchivo,        Par_NumRegistro,        Par_NumTarjeta,         Par_FechaVencim,    Par_NIP,
        Par_NombreTarjeta,      Par_Estatus,            Par_MotivoFallo,        Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

    SET Par_NumErr := Entero_Cero;
    SET Par_ErrMen := "Bitacora Carga Lote Tarjeta, Agregado Exitosamente: ";

END ManejoErrores;  -- END del Handler de Errores

IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'FechaRegistro' AS control,
            Par_BitCargaID AS consecutivo,
            Par_NumFallos AS Fallidos,
            Par_NumExitos AS Exitos;
END IF;

END TerminaStore$$