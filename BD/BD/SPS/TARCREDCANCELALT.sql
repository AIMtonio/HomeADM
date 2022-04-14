-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDCANCELALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCREDCANCELALT`;DELIMITER $$

CREATE PROCEDURE `TARCREDCANCELALT`(
-- SP PARA CANCELAR TARJETA DE CREDITO
    Par_NumTarjeta      CHAR(16),       -- Num de Tarjeta a bloquear
    Par_TarjetaHabiente INT,            -- Numero de Cliente asignado a la tarjeta
    Par_CorporativoID   INT,            -- Id del corporativo del cliente
    Par_MotivoBloqID    INT,            -- Motivo de Bloqueo
    Par_DescAdicional   VARCHAR(500),   -- Descripcion adicional
    Par_TipoTran        INT,            -- Corresponde con la tabla TIPOSBLOQUEOS

    Par_Salida          CHAR(1),        -- indca una salida
    INOUT Par_NumErr    INT,            -- indca una salida
    INOUT Par_ErrMen    VARCHAR(400),   -- indca una salida

    Aud_EmpresaID       INT(11),        -- Auditoria
    Aud_Usuario         INT,            -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT,            -- Auditoria
    Aud_NumTransaccion  BIGINT          -- Auditoria
        )
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES
DECLARE varControl      VARCHAR(50);
DECLARE TranCancel      INT;            -- Indica que la transaccion es un bloqueo de tarjeta
DECLARE Var_NumLinea    INT(20);        -- Numero de la linea
DECLARE Var_ClienteID   INT(11);        -- ID del cliente
DECLARE Var_AdeudoActual   DECIMAL(16,2); -- Total de la deuda actual del clinete
DECLARE Var_Estatus     CHAR(1);        -- Estatus de la tarjeta
DECLARE Var_NomCliente  VARCHAR(100);   -- Nombre del cliente

-- declaracion de constantes
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(1,1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Salida_SI       CHAR(1);
DECLARE Salida_NO       CHAR(1);
DECLARE EstatusCanc     INT;            -- Estatus de cancelacion
DECLARE EstatusActiva   INT;            -- Estatus activo
DECLARE Est_Expirada    INT;            -- Estatus Expirado
DECLARE MotivoBloq      CHAR(1);        -- Motivo de cancelacion

-- asignacion de constantes
SET Entero_Cero     := 0;
SET Decimal_Cero    := '0.0';
SET Cadena_Vacia    := '';
SET Salida_SI       := 'S';
SET Salida_NO       := 'N';
SET TranCancel      := 3;
SET EstatusCanc     := 9;
SET Est_Expirada    := 10;
SET EstatusActiva   := 7;
SET MotivoBloq      := 1;
SET Aud_FechaActual := CURRENT_TIMESTAMP();


ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-TARCREDCANCELALT');
    END;
    IF (Par_TipoTran = TranCancel) THEN
        SELECT Estatus, LineaTarCredID, ClienteID INTO Var_Estatus, Var_NumLinea, Var_ClienteID
            FROM TARJETACREDITO
            WHERE TarjetaCredID = Par_NumTarjeta ;
        SET Var_AdeudoActual :=(SELECT FNTCADEUDOLINEA(Var_ClienteID,Var_NumLinea));

       IF(IFNULL(Par_NumTarjeta,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'Especifique el numero de tarjeta';
            SET varControl  := 'tarjetaID' ;
            LEAVE ManejoErrores;
       END IF;
       IF(IFNULL(Par_TarjetaHabiente,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'Especifique la tarjeta hambiente';
            SET varControl  := 'tarjetaHabiente' ;
            LEAVE ManejoErrores;
       END IF;

       IF(IFNULL(Par_MotivoBloqID,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'Especifique el motivo de la cancelacion';
            SET varControl  := 'descripcion' ;
            LEAVE ManejoErrores;
       END IF;
       IF(IFNULL(Par_DescAdicional,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'Especifique la Descripcion';
            SET varControl  := 'descripcion' ;
            LEAVE ManejoErrores;
       END IF;
       IF (Var_Estatus = EstatusCanc) THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  := 'La Tarjeta se encuentra Cancelada';
            SET varControl  := 'estatus' ;
            LEAVE ManejoErrores;
        END IF;

        IF (Var_Estatus = EstatusActiva) THEN
            SET Par_NumErr  := 7;
            SET Par_ErrMen  := 'La Tarjeta se encuentra Activada';
            SET varControl  := 'estatus' ;
            LEAVE ManejoErrores;
        END IF;

       IF(Var_AdeudoActual != Decimal_Cero AND Par_MotivoBloqID=MotivoBloq) THEN
            SET Par_NumErr  := 8;
            SET Par_ErrMen  := CONCAT('No se puede cancelar la tarjeta, el cliente cuenta con una deuda de:',' ',Var_AdeudoActual);
            SET varControl  := 'tarjetaID' ;
            LEAVE ManejoErrores;
        END IF;

        IF (Var_Estatus != EstatusCanc AND Var_Estatus != Est_Expirada) THEN
            SELECT NombreCompleto    INTO Var_NomCliente
                FROM CLIENTES
                WHERE ClienteID = Par_TarjetaHabiente;


           CALL TC_BITACORAALT( Par_NumTarjeta,      EstatusCanc,      Par_MotivoBloqID,  Par_DescAdicional,  Aud_FechaActual,
                                Var_NomCliente,     Salida_NO,         Par_NumErr,        Par_ErrMen,         Aud_EmpresaID,
                                Aud_Usuario,        Aud_FechaActual,   Aud_DireccionIP,   Aud_ProgramaID,     Aud_Sucursal,
                                Aud_NumTransaccion);

          IF Par_NumErr <> Entero_Cero THEN
            LEAVE ManejoErrores;
          END IF;

            UPDATE TARJETACREDITO
               SET  Estatus           = EstatusCanc,
                    FechaCancelacion  = Aud_FechaActual,
                    MotivoCancelacion = Par_MotivoBloqID
             WHERE TarjetaCredID = Par_NumTarjeta;

            SET Par_NumErr  := 000;
            SET Par_ErrMen  := CONCAT('Tarjeta: ',Par_NumTarjeta, ' Cancelada Exitosamente. ');
            SET varControl  := 'tarjetaID' ;

        END IF;
    END IF;

END ManejoErrores;
    IF(Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                varControl AS control,
                Entero_Cero AS consecutivo;
    END IF;

END TerminaStore$$