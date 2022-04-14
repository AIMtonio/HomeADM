-- TD_BITACORAMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_BITACORAMOVSALT`;

DELIMITER $$
CREATE PROCEDURE `TD_BITACORAMOVSALT`(
/* ----------------------------------------------------------
    Registra los datos de la transaccion en la bitacora de operaciones para tarjetas de debito
-- ---------------------------------------------------------- */
    Par_OrigenOperacion     CHAR(1),         -- Origen de la operacion
    Par_TipoMensaje         CHAR(4),         -- Tipo de mensaje pos
    Par_TipoOperacionID     CHAR(2),         -- Codigo del tipo de operacion
    Par_TarjetaDebID        CHAR(16),        -- Numero de tarjeta
    Par_MontoOperacion      DECIMAL(16,2),   -- Monto original de la transaccion

    Par_MontoCashBack       DECIMAL(16,2),   -- Monto Cashback
    Par_MontoComision       DECIMAL(16,2),   -- Monto Comision
    Par_MontoIva            DECIMAL(10,2),   -- Monto IVA
    Par_MontoAdicional      DECIMAL(16,2),   -- Monto Adicional
    Par_CodigoMonOpe        VARCHAR(10),     -- Codigo de moneda de la transaccion

    Par_MontoOperacionMx    DECIMAL(16,2),   -- Monto de operacion en pesos
    Par_MontoCashBackMx     DECIMAL(16,2),   -- Monto de cashback en pesos
    Par_MontoComisionMx     DECIMAL(16,2),   -- Monto de Comision en pesos
    Par_MontoIvaMx          DECIMAL(10,2),   -- Monto de IVA en pesos
    Par_MontoAdicionalMx    DECIMAL(4,2),    -- Monto Adicional en pesos

    Par_FechaOperacion      DATE,            -- Fecha de operacion
    Par_HoraOperacion       TIME,            -- Hora de Operacion
    Par_GiroNegocio         VARCHAR(5),      -- Giro del Negocio
    Par_IRD                 VARCHAR(4),      -- Clave de IRD
    Par_NombreComercio      VARCHAR(50),     -- Nombre del comercio

    Par_Ciudad              VARCHAR(20),     -- Ciudad del comercio
    Par_Pais                VARCHAR(6),      -- Pais del comercio
    Par_Referencia          VARCHAR(25),     -- Referencia de la operacion
    Par_DatosTiempoAire     VARCHAR(70),     -- Datos de tiempo aire
    Par_CodigoAprobacion    VARCHAR(6),      -- Codigo de aprobacion

    Par_TransEnLinea        CHAR(1),         -- Transaccion en Linea
    Par_CheckIn             CHAR(1),         -- CheckIn
    Par_Naturaleza          CHAR(1),         -- Naturaleza
    Par_TipoCambio          DECIMAL(16,2),   -- Valor del tipo de Cambio
    INOUT Par_TarDebMovID   INT(11),         -- Identificador del movimiento

    Par_Salida              CHAR(1),          -- Salida
    INOUT Par_NumErr        INT(11),          -- Salida
    INOUT Par_ErrMen        VARCHAR(400),     -- Salida

    Par_EmpresaID           INT(11),          -- Auditoria
    Aud_Usuario             INT(11),          -- Auditoria
    Aud_FechaActual         DATETIME,         -- Auditoria
    Aud_DireccionIP         VARCHAR(15),      -- Auditoria
    Aud_ProgramaID          VARCHAR(50),      -- Auditoria
    Aud_Sucursal            INT(11),          -- Auditoria
    Aud_NumTransaccion      BIGINT(20)        -- Auditoria
)
TerminaStore:BEGIN

    DECLARE Var_TarDebMovID BIGINT(12);

    DECLARE Salida_SI       CHAR(1);
    DECLARE Cons_NO         CHAR(1);
    DECLARE Est_Registrado  CHAR(1);
    DECLARE Entero_Cero     INT(11);

    SET Salida_SI       := 'S';
    SET Cons_NO         := 'N';
    SET Entero_Cero     := 0;
    SET Est_Registrado  := 'R';

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                     'Disculpe las molestias que esto le ocasiona. Ref: SP-TD_BITACORAMOVSALT');
        END;

        SET Aud_FechaActual := NOW();

        CALL FOLIOSAPLICAACT('TD_BITACORAMOVS', Var_TarDebMovID);

        SET Var_TarDebMovID := IFNULL(Var_TarDebMovID,Entero_Cero) + 1;

        INSERT INTO TD_BITACORAMOVS (
            TarDebMovID,            OrigenOperacion,        TipoMensaje,            TipoOperacionID,        TarjetaDebID,
            MontoOperacion,         MontoCashBack,          MontoComision,          MontoIva,               CodigoMonOpe,
            MontoOperacionMx,       MontoCashBackMx,        MontoComisionMx,        MontoIvaMx,             FechaOperacion,
            HoraOperacion,          GiroNegocio,            IRD,                    NombreComercio,         Ciudad,
            Pais,                   Referencia,             DatosTiempoAire,        CodigoAprobacion,       Estatus,
            TransEnLinea,           CheckIn,                EstatusConcilia,        FolioConcilia,          Naturaleza,
            TipoCambio,             MontoAdicional,         MontoAdicionalMx,
            EmpresaID,              Usuario,                FechaActual,            DireccionIP,            ProgramaID,
            Sucursal,               NumTransaccion)
        VALUES (
            Var_TarDebMovID,        Par_OrigenOperacion,    Par_TipoMensaje,        Par_TipoOperacionID,    Par_TarjetaDebID,
            Par_MontoOperacion,     Par_MontoCashBack,      Par_MontoComision,      Par_MontoIva,           Par_CodigoMonOpe,
            Par_MontoOperacionMx,   Par_MontoCashBackMx,    Par_MontoComisionMx,    Par_MontoIvaMx,         Par_FechaOperacion,
            Par_HoraOperacion,      Par_GiroNegocio,        Par_IRD,                Par_NombreComercio,     Par_Ciudad,
            Par_Pais,               Par_Referencia,         Par_DatosTiempoAire,    Par_CodigoAprobacion,   Est_Registrado,
            Par_TransEnLinea,       Par_CheckIn,            Cons_NO,                Entero_Cero,            Par_Naturaleza,
            Par_TipoCambio,         Par_MontoAdicional,     Par_MontoAdicionalMx,
            Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion);

        SET Par_NumErr:= 0;
        SET Par_ErrMen:= 'Registro Bitacora Exitoso';
        SET Par_TarDebMovID := Var_TarDebMovID;

    END ManejoErrores;

    IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$
