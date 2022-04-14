-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBITOALT`;DELIMITER $$

CREATE PROCEDURE `TARJETADEBITOALT`(
-- ---------------------------------------------------------------------------------
-- STORED PROCEDURE PARA EL ALTA DE UNA TARJETA DE DEBITO/CREDITO
-- ---------------------------------------------------------------------------------
    Par_LoteDebitoID    INT(11),       -- Identificador del lote de carga
    Par_FechaRegistro   DATETIME,      -- Fecha de registro de la tarjeta
    Par_SucursalID      INT(11),       -- Sucursal ligada a la tarjeta
    Par_EmpresaID       INT,           -- Auditoria

    Par_Salida          CHAR(1),       -- Salida
OUT Par_NumErr          INT,           -- Salida
OUT Par_ErrMen          VARCHAR(200),  -- Salida

    Aud_Usuario         INT,            -- Parametro de Auditoria
    Aud_FechaActual     DATETIME,       -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Parametro de Auditoria
    Aud_Sucursal        INT,            -- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT          -- Parametro de Auditoria
    )
TerminaStore: BEGIN


DECLARE Var_CueCliente      INT;
DECLARE Var_TipoCuentaID    INT;
DECLARE Var_TipoTarjeta     INT(11);
DECLARE Var_NumTarjeta      CHAR(16);
DECLARE Var_NIP             VARCHAR(256);


DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(2,2);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE SalidaSI        CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Tar_Activa      CHAR(1);
DECLARE Estatus_Exito   CHAR(1);
DECLARE Estatus_Carga   INT(11);
DECLARE ProcesoInicia   INT(11);
DECLARE Var_FechaSistema    DATETIME;

DECLARE Tipo_Debito      CHAR(1);
DECLARE Tipo_Credito     CHAR(1);

SET Entero_Cero     := 0;
SET Decimal_Cero    := '0.00';
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Tar_Activa      := 'A';
SET Estatus_Exito   := 'E';
SET Estatus_Carga   := '1';
SET ProcesoInicia   := 1;
SET Tipo_Debito      := 'D';
SET Tipo_Credito     := 'C';

ManejoErrores: BEGIN


SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

IF(IFNULL(Par_FechaRegistro, Fecha_Vacia)) = Fecha_Vacia THEN
    SET Par_NumErr  := 1;
    SET Par_ErrMen  := 'La Fecha de Registro esta Vacia';
    LEAVE ManejoErrores;
END IF;


IF (NOT EXISTS(SELECT LoteDebitoID
                FROM LOTETARJETADEB
                WHERE LoteDebitoID = Par_LoteDebitoID   )  )  THEN

    SET Par_NumErr  := 2;
    SET Par_ErrMen  := 'El Lote de la Tarjeta No Existe.';


END IF;


    INSERT INTO `TARJETADEBITO`(
        `TarjetaDebID`,     `LoteDebitoID`, `FechaRegistro`,    `FechaVencimiento`, `FechaActivacion`,
        `Estatus`,          `ClienteID`,    `CuentaAhoID`,      `FechaBloqueo`,     `MotivoBloqueo`,
        `FechaCancelacion`, `MotivoCancelacion`,`FechaDesbloqueo`,`MotivoDesbloqueo`,`NIP`,
        `NombreTarjeta`,    `Relacion`,     `SucursalID`,       `TipoTarjetaDebID`, `NoDispoDiario`,
        `NoDispoMes`,       `MontoDispoDiario`,`MontoDispoMes`, `NoConsultaSaldoMes`,`NoCompraDiario`,
        `NoCompraMes`,      `MontoCompraDiario`,`MontoCompraMes`,`PagoComAnual`,    `FPagoComAnual`,
        `TipoCobro`,        `EmpresaID`,    `Usuario`,          `FechaActual`,      `DireccionIP`,
        `ProgramaID`,       `Sucursal`,     `NumTransaccion`)
    SELECT
        Bitr.TarjetaDebID,   Par_LoteDebitoID,   Par_FechaRegistro,  Bitr.FechaVencimiento,   Fecha_Vacia,
        Estatus_Carga,  Entero_Cero,        Entero_Cero,        Fecha_Vacia,        Entero_Cero,
        Fecha_Vacia,    Entero_Cero,        Fecha_Vacia,        Entero_Cero,        Bitr.NIP,
        IFNULL(Bitr.NombreTarjeta,Cadena_Vacia), Cadena_Vacia,       Par_SucursalID,     Bitr.TipoTarjetaDebID,   Entero_Cero,
        Entero_Cero,    Decimal_Cero,       Decimal_Cero,       Entero_Cero,        Entero_Cero,
        Entero_Cero,    Decimal_Cero,       Decimal_Cero,       Cadena_Vacia,       Fecha_Vacia,
        Cadena_Vacia,   Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion
        FROM BITACORALOTEDEB Bitr, TIPOTARJETADEB Tip
        WHERE Bitr.TipoTarjetaDebID = Tip.TipoTarjetaDebID
        AND Tip.TipoTarjeta = Tipo_Debito
        AND Bitr.BitCargaID = Par_LoteDebitoID
        AND Bitr.Estatus = Estatus_Exito;


    INSERT INTO `TARJETACREDITO`(
        `TarjetaCredID`,     `LoteCreditoID`, `FechaRegistro`,    `FechaVencimiento`, `FechaActivacion`,
        `Estatus`,          `ClienteID`,    `LineaTarCredID`,      `FechaBloqueo`,     `MotivoBloqueo`,
        `FechaCancelacion`, `MotivoCancelacion`,`FechaDesbloqueo`,`MotivoDesbloqueo`,`NIP`,
        `NombreTarjeta`,    `Relacion`,     `SucursalID`,       `TipoTarjetaCredID`, `NoDispoDiario`,
        `NoDispoMes`,       `MontoDispoDiario`,`MontoDispoMes`, `NoConsultaSaldoMes`,`NoCompraDiario`,
        `NoCompraMes`,      `MontoCompraDiario`,`MontoCompraMes`,`PagoComAnual`,    `FPagoComAnual`,
        `TipoCobro`,        `EmpresaID`,    `Usuario`,          `FechaActual`,      `DireccionIP`,
        `ProgramaID`,       `Sucursal`,     `NumTransaccion`)
    SELECT
        Bitr.TarjetaDebID,   Par_LoteDebitoID,   Par_FechaRegistro,  Bitr.FechaVencimiento,   Fecha_Vacia,
        Estatus_Carga,  Entero_Cero,        Entero_Cero,        Fecha_Vacia,        Entero_Cero,
        Fecha_Vacia,    Entero_Cero,        Fecha_Vacia,        Entero_Cero,        Bitr.NIP,
        IFNULL(Bitr.NombreTarjeta,Cadena_Vacia), Cadena_Vacia,       Par_SucursalID,     Bitr.TipoTarjetaDebID,   Entero_Cero,
        Entero_Cero,    Decimal_Cero,       Decimal_Cero,       Entero_Cero,        Entero_Cero,
        Entero_Cero,    Decimal_Cero,       Decimal_Cero,       Cadena_Vacia,       Fecha_Vacia,
        Cadena_Vacia,   Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion
        FROM BITACORALOTEDEB Bitr, TIPOTARJETADEB Tip
        WHERE Bitr.TipoTarjetaDebID = Tip.TipoTarjetaDebID
        AND Tip.TipoTarjeta = Tipo_Credito
        AND Bitr.BitCargaID = Par_LoteDebitoID
        AND Bitr.Estatus = Estatus_Exito;


    INSERT INTO `BITACORATARDEB`(
        `TarjetaDebID`,`TipoEvenTDID`,`MotivoBloqID`,`DescripAdicio`,`Fecha`,
        `NombreCliente`,`EmpresaID`,`Usuario`,`FechaActual`,`DireccionIP`,
        `ProgramaID`,`Sucursal`,`NumTransaccion`)
    SELECT
        Bitr.TarjetaDebID,   Estatus_Carga,  NULL,       'Tarjeta Importada de Archivo', Var_FechaSistema,
        Bitr.NombreTarjeta,  Par_EmpresaID,  Aud_Usuario,Aud_FechaActual,                Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
        FROM BITACORALOTEDEB Bitr, TIPOTARJETADEB Tip
        WHERE Bitr.TipoTarjetaDebID = Tip.TipoTarjetaDebID
        AND Tip.TipoTarjeta = Tipo_Debito
        AND Bitr.BitCargaID = Par_LoteDebitoID
        AND Bitr.Estatus = Estatus_Exito;

    INSERT INTO `BITACORATARCRED`(
        `TarjetaCredID`,`TipoEvenTDID`,`MotivoBloqID`,`DescripAdicio`,`Fecha`,
        `NombreCliente`,`EmpresaID`,`Usuario`,`FechaActual`,`DireccionIP`,
        `ProgramaID`,`Sucursal`,`NumTransaccion`)
    SELECT
        Bitr.TarjetaDebID,   Estatus_Carga,  NULL,       'Tarjeta Importada de Archivo', Var_FechaSistema,
        Bitr.NombreTarjeta,  Par_EmpresaID,  Aud_Usuario,Aud_FechaActual,                Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
        FROM BITACORALOTEDEB Bitr, TIPOTARJETADEB Tip
        WHERE Bitr.TipoTarjetaDebID = Tip.TipoTarjetaDebID
        AND Tip.TipoTarjeta = Tipo_Credito
        AND Bitr.BitCargaID = Par_LoteDebitoID
        AND Bitr.Estatus = Estatus_Exito;

    SET Par_NumErr := Entero_Cero;
    SET Par_ErrMen := "Lote Procesado Exitosamente.";

END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'TarjetaDebID' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$