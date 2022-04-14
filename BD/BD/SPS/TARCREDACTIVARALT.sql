-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDACTIVARALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCREDACTIVARALT`;

DELIMITER $$
CREATE PROCEDURE `TARCREDACTIVARALT`(
-- SP PARA LA ACTIVACION DE TARJETA DE CREDITO
    Par_TarjetaCredID       CHAR(16),       -- Parametro de Tarjeta Credito ID
    Par_Salida              CHAR(1),        -- Parametro de Salida
    INOUT   Par_NumErr      INT(11),        -- Parametro de Numero Error
    INOUT   Par_ErrMen      VARCHAR (350),  -- Parametro de Error Mensaje

    Aud_EmpresaID           INT(11),        -- Parametro de Auditoria
    Aud_Usuario             INT(11),        -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,       -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Parametro de Auditoria
    Aud_Sucursal            INT(11),        -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT          -- Parametro de Auditoria
            )
TerminaStore: BEGIN

    -- VARIABLES
    DECLARE Var_EstatusTar      INT(11);        -- Variable de Estatus Tarjeta
    DECLARE Var_FechaOper       DATE;           -- Variable de Fecha Operacion
    DECLARE Var_NombreCliente   VARCHAR(200);   -- Variable Nombre Cliente
    DECLARE Var_LineaTarCred    INT(20);        -- Variable Linea Tarjeta Credito

    -- CONSTANTES
    DECLARE Transaccion     CHAR(1);            -- Transaccion
    DECLARE Cadena_Vacia    CHAR(1);            -- Cadena Vacia
    DECLARE Entero_Cero     INT;                -- Entero cero
    DECLARE SalidaSI        CHAR(1);            -- salida si
    DECLARE SalidaNO        CHAR(1);            -- salida no
    DECLARE Estatus_Asig    INT;                -- estatus asignacion
    DECLARE Estatus_Act     INT;                -- estatus activo
    DECLARE Desc_Estatus    VARCHAR(100);       -- estatus leyenda
    DECLARE varControl      VARCHAR(50);        -- variable de control
    DECLARE Act_EstatusLin  INT(1);             -- numero actualizacion de linea

    -- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET SalidaSI            := 'S';
    SET SalidaNO            := 'N';
    SET Estatus_Asig        := 6; -- Estatus de Tarjeta Asignada a Cliente
    SET Desc_Estatus        := 'Tarjeta Activada'; -- Corresponde del estatus de la tarjeta en la tabla de ESTATUSTD
    SET Estatus_Act         := 7; -- Estatus de Tarjeta activada
    SET Act_EstatusLin      := 1;

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                    'esto le ocasiona. Ref: SP-TARCREDACTIVARALT');
        END;

        SET Var_EstatusTar      := (SELECT tar.Estatus FROM TARJETACREDITO tar WHERE tar.TarjetaCredID = Par_TarjetaCredID);
        SET Var_FechaOper       := (SELECT FechaSistema FROM PARAMETROSSIS);
        SET Var_NombreCliente   := (SELECT Cli.NombreCompleto FROM CLIENTES Cli
                                        INNER JOIN TARJETACREDITO Tar ON Tar.ClienteID=Cli.ClienteID
                                    WHERE Tar.TarjetaCredID=Par_TarjetaCredID);
        SET Var_LineaTarCred    :=(SELECT tar.LineaTarCredID  FROM TARJETACREDITO tar WHERE tar.TarjetaCredID = Par_TarjetaCredID);


        IF (Var_EstatusTar = Estatus_Asig ) THEN
            IF(IFNULL(Par_TarjetaCredID,Cadena_Vacia))= Cadena_Vacia THEN
                SET Par_NumErr  := 001;
                SET Par_ErrMen  := 'El Numero de Tarjeta esta Vacio';
                SET varControl  := 'tarjetaID' ;
                LEAVE ManejoErrores;
            END IF;
        END IF;

        CALL LINEATARJETACREDACT(
            Var_LineaTarCred,   Var_FechaOper,      Entero_Cero,    Act_EstatusLin,
            SalidaNO,           Par_NumErr,         Par_ErrMen,     Aud_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

        IF Par_NumErr <> Entero_Cero THEN
            LEAVE ManejoErrores;
        END IF;

        CALL TC_BITACORAALT(
            Par_TarjetaCredID,  Estatus_Act,        Entero_Cero,        Desc_Estatus,       Var_FechaOper,
            Var_NombreCliente,  SalidaNO,           Par_NumErr,         Par_ErrMen,         Aud_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF Par_NumErr <> Entero_Cero THEN
            LEAVE ManejoErrores;
        END IF;

        -- Se actualiza el Estatus en la Tabla de TARJETADEBITO
        UPDATE TARJETACREDITO SET
                FechaActivacion    = Var_FechaOper,
                Estatus            = Estatus_Act
          WHERE TarjetaCredID      = Par_TarjetaCredID;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Tarjeta: ', Par_TarjetaCredID, ' Activada Exitosamente');
        SET varControl  := 'tipoTarjetaD' ;
        LEAVE ManejoErrores;

    END ManejoErrores;

    IF(Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                varControl AS control,
                Par_TarjetaCredID AS consecutivo;
    END IF;

END TerminaStore$$