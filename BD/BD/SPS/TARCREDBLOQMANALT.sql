-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDBLOQMANALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCREDBLOQMANALT`;DELIMITER $$

CREATE PROCEDURE `TARCREDBLOQMANALT`(
-- SP PARA BLOQUEO DE TARJETA DE CREDITO
    Par_NumTarjeta      CHAR(16),       -- Num de Tarjeta a bloquear
    Par_TarjetaHabiente INT,            -- Numero de Cliente asignado a la tarjeta
    Par_CorporativoID   INT,            -- Id del corporativo del cliente
    Par_MotivoBloqID    INT,            -- Motivo de Bloqueo
    Par_DescAdicional   VARCHAR(500),   -- Descripcion adicional
    Par_TipoTran        INT,            -- Corresponde con la tabla TIPOSBLOQUEOS

    Par_Salida          CHAR(1),        -- Salida
    INOUT Par_NumErr    INT,            -- Salida
    INOUT Par_ErrMen    VARCHAR(400),   -- Salida

    Aud_EmpresaID       INT(11),        -- Auditoria
    Aud_Usuario         INT,            -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT,            -- Auditoria
    Aud_NumTransaccion  BIGINT          -- Auditoria
        )
TerminaStore: BEGIN
-- DECLARACION DE VARIABLES
DECLARE VarControl      VARCHAR(50);


-- declaracion de constantes
DECLARE Entero_Cero      INT;
DECLARE Cadena_Vacia     CHAR(1);
DECLARE Salida_SI        CHAR(1);
DECLARE Salida_NO        CHAR(1);
DECLARE TranBloqueo      INT;
DECLARE Estatus_Bloq     INT;
DECLARE Estatus_Activa   INT;
DECLARE Var_Estatus      CHAR(1);
DECLARE Var_NomCliente   VARCHAR(100);
DECLARE Var_FechaSistema DATETIME;

-- asignacion de constantes
SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Salida_SI       := 'S';
SET Salida_NO       := 'N';
SET TranBloqueo     := 1;       -- Indica que la transacion es un bloqueo de tarjeta
SET Estatus_Activa  := 7;       -- Indica que el estatus es Activada, corresponde al catalogo ESTATUSTD
SET Estatus_Bloq    := 8;       -- Indica que el estatus es Bloqueado, corresponde al catalogo ESTATUSTD


SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET Var_FechaSistema:= (SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-TARCREDBLOQMANALT');
    END;


    IF (Par_TipoTran = TranBloqueo) THEN
        SELECT Estatus INTO Var_Estatus
            FROM TARJETACREDITO
            WHERE TarjetaCredID = Par_NumTarjeta ;
        SELECT NombreCompleto    INTO Var_NomCliente
            FROM CLIENTES
            WHERE ClienteID = Par_TarjetaHabiente;

        IF(IFNULL(Par_NumTarjeta,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'Especifique el numero de tarjeta';
            SET VarControl  := 'tarjetaID' ;
            LEAVE ManejoErrores;
       END IF;
       IF(IFNULL(Par_TarjetaHabiente,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'Especifique la tarjeta hambiente';
            SET VarControl  := 'tarjetaHabiente' ;
            LEAVE ManejoErrores;
       END IF;

       IF(IFNULL(Par_MotivoBloqID,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'Especifique el motivo de la cancelacion';
            SET VarControl  := 'descripcion' ;
            LEAVE ManejoErrores;
       END IF;
       IF(IFNULL(Par_DescAdicional,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'Especifique la Descripcion';
            SET VarControl  := 'descripcion' ;
            LEAVE ManejoErrores;
       END IF;

       IF (Var_Estatus = Estatus_Bloq ) THEN
           SET  Par_NumErr  := 6;
           SET  Par_ErrMen  := CONCAT('La Tarjeta se encuentra Bloqueada');
           SET VarControl  := 'tarjetaID' ;
           LEAVE ManejoErrores;
         END IF;



       IF (Var_Estatus = Estatus_Activa) THEN
            CALL TC_BITACORAALT(Par_NumTarjeta,     Estatus_Bloq,        Par_MotivoBloqID,         Par_DescAdicional,  Var_FechaSistema,
                                Var_NomCliente,     Salida_NO,           Par_NumErr,               Par_ErrMen,         Aud_EmpresaID,
                                Aud_Usuario,        Aud_FechaActual,     Aud_DireccionIP,          Aud_ProgramaID,     Aud_Sucursal,
                                Aud_NumTransaccion);

            IF Par_NumErr <> Entero_Cero THEN
                LEAVE ManejoErrores;
             END IF;

            UPDATE TARJETACREDITO SET Estatus       = Estatus_Bloq,
                                      FechaBloqueo  = Var_FechaSistema,
                                      MotivoBloqueo = Par_MotivoBloqID
                WHERE TarjetaCredID = Par_NumTarjeta
                  AND ClienteID = Par_TarjetaHabiente;
        END IF;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Tarjeta: ',Par_NumTarjeta, ' Tarjeta Bloqueada Exitosamente. ');
        SET VarControl  := 'tarjetaID' ;

    END IF;

END ManejoErrores;
    IF(Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                VarControl AS control,
                Entero_Cero AS consecutivo;
    END IF;
END TerminaStore$$