-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBLIMITESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBLIMITESALT`;

DELIMITER $$
CREATE PROCEDURE `TARDEBLIMITESALT`(
    -- Store Procedure para el Alta de Limites por Tarjeta de Debito
    -- Pantalla: Modulo Tarjetas --> Taller de Productos --> Limites de Tarjeta de Debito
    Par_TarjetaDebID            CHAR(16),       -- Numero de Tarjeta de Debito
    Par_DisposicionesDia        INT(11),        -- numero de Disposiciones al Dia
    Par_MontoMaxDia             DECIMAL(12,2),  -- Monto Maximo Diario
    Par_MontoMaxMes             DECIMAL(12,2),  -- Monto Maximo Mes
    Par_MontoMaxCompraDia       DECIMAL(12,2),  -- Monto Maximo Compra

    Par_MontoMaxComprasMensual  DECIMAL(12,2),  -- Monto Maximo Compra Mensual
    Par_BloqueoATM              CHAR(2),        -- Bloquo ATM
    Par_BloqueoPOS              CHAR(2),        -- Bloqueo Pos
    Par_BloqueoCashback         CHAR(2),        -- Bloqueo Cash Back
    Par_Vigencia                DATE,           -- Vigencia de Limite

    Par_OperacionesMOTO         CHAR(2),        -- Operaciones MOTO
    Par_NumConsultaMes          INT(11),        -- Numero de Consultas Mensuales

    Par_Salida                  CHAR(1),        -- Parametro de Salida
    INOUT Par_NumErr            INT(11),        -- Numero de Error
    INOUT Par_ErrMen            VARCHAR(400),   -- Mensaje de Error

    Aud_EmpresaID               INT(11),        -- Parametro de auditoria ID de la empresa
    Aud_Usuario                 INT(11),        -- Parametro de auditoria ID del usuario
    Aud_FechaActual             DATETIME,       -- Parametro de auditoria Feha actual
    Aud_DireccionIP             VARCHAR(15),    -- Parametro de auditoria Direccion IP
    Aud_ProgramaID              VARCHAR(50),    -- Parametro de auditoria Programa
    Aud_Sucursal                INT(11),        -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion          BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control         VARCHAR(50);        --  Control de Salida

    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT(11);            -- Constante Entero cero
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Entero cero
    DECLARE Salida_SI           CHAR(1);            -- Constante Entero cero
    DECLARE Decimal_Cero        DECIMAL(12,2);      -- Constante Entero cero


    SET Entero_Cero             := 0;
    SET Decimal_Cero            := 0.00;
    SET Cadena_Vacia            := '';
    SET Salida_SI               := 'S';

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

    -- Bloque para manejar los posibles errores
    ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                     'Disculpe las molestias que esto le ocasiona. Ref: SP-TARDEBLIMITESALT');
            SET Var_Control = 'SQLEXCEPTION';
        END;

        IF NOT EXISTS(  SELECT TarjetaDebID
                        FROM TARJETADEBITO
                        WHERE TarjetaDebID = Par_TarjetaDebID ) THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  :='Tarjeta Debito no Existe.';
            SET Var_Control := 'tarjetaDebID';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_TarjetaDebID, Cadena_Vacia) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  :='Especifique el N??mero de Tarjeta';
            SET Var_Control := 'tarjetaDebID';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_DisposicionesDia, Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  :='Especifique el Numero de Disposiones al d??a';
            SET Var_Control := 'disposicionesDia';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_MontoMaxDia, Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  :='Especifique el Monto Max. al D??a';
            SET Var_Control := 'montoMaxDia';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_MontoMaxMes, Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  :='Especifique el Motivo de Max del Mes';
            SET Var_Control := 'montoMaxMes';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_MontoMaxCompraDia,  Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  :='Especifique la Monto Max. de Compra al D??a';
            SET Var_Control := 'montoMaxComprasMensual';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_MontoMaxComprasMensual, Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 7;
            SET Par_ErrMen  :='Especifique el Monto Max. Compras Mensual';
            SET Var_Control := 'montoMaxCompraDia';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_BloqueoATM , Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 8;
            SET Par_ErrMen  :='Especifique Bloqueo  de ATM';
            SET Var_Control := 'bloqueoATM';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_BloqueoPOS , Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 9;
            SET Par_ErrMen  :='Especifique Bloqueo  de POS';
            SET Var_Control := 'bloqueoPOS';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_BloqueoCashback , Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 10;
            SET Par_ErrMen  :='Especifique el Bloqueo Cashback';
            SET Var_Control := 'bloqueoCashback';
            LEAVE ManejoErrores;
        END IF;

        IF( Par_Vigencia < DATE(NOW()) ) THEN
            SET Par_NumErr  := 11;
            SET Par_ErrMen  :='La Vigencia No Debe Ser Menor a la Fecha Actual.';
            SET Var_Control := 'vigencia';
            LEAVE ManejoErrores;
        END IF;

        IF( IFNULL(Par_OperacionesMOTO , Cadena_Vacia ) = Cadena_Vacia ) THEN
            SET Par_NumErr  := 12;
            SET Par_ErrMen  :='Especifique Operaciones MOTO';
            SET Var_Control := 'operacionesMOTO';
            LEAVE ManejoErrores;
        END IF;

        INSERT INTO `TARDEBLIMITES` (
            TarjetaDebID,           NoDisposiDia,               NumConsultaMes,     DisposiDiaNac,      DisposiMesNac,
            ComprasDiaNac,          ComprasMesNac,              BloquearATM,        BloquearPOS,        BloquearCashBack,
            Vigencia,               AceptaOpeMoto,              EmpresaID,          Usuario,            FechaActual,
            DireccionIP,            ProgramaID,                 Sucursal,           NumTransaccion)
        VALUES(
            Par_TarjetaDebID,       Par_DisposicionesDia,       Par_NumConsultaMes, Par_MontoMaxDia,    Par_MontoMaxMes,
            Par_MontoMaxCompraDia,  Par_MontoMaxComprasMensual, Par_BloqueoATM,     Par_BloqueoPOS,     Par_BloqueoCashback,
            Par_Vigencia,           Par_OperacionesMOTO,        Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
            Aud_DireccionIP,        Aud_ProgramaID,             Aud_Sucursal,       Aud_NumTransaccion);

        SET Par_NumErr  :=  Entero_Cero;
        SET Par_ErrMen  := 'Limites Agregados Exitosamente.';
        SET Var_Control := 'tarjetaDebID';

    END ManejoErrores;
    -- Fin del manejador de errores.

    IF(Par_Salida =  Salida_SI) THEN
        SELECT  Par_NumErr AS CodigoRespuesta,
                Par_ErrMen AS MensajeRespuesta,
                Var_Control AS LimiteRegistrado,
                Par_TarjetaDebID AS NumeroTransaccion;
    END IF;

END TerminaStore$$