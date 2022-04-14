-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASTRANSFERALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASTRANSFERALT`;DELIMITER $$

CREATE PROCEDURE `CAJASTRANSFERALT`(

    VarTransferID           BIGINT,
    Par_SucOrigen           INT,
    Par_SucDestino          INT,
    Par_Fecha               DATETIME,
    Par_DenominacionID      INT,

    Par_Cantidad            VARCHAR(15),
    Par_CajaOrigen          INT,
    Par_CajaDestino         INT,
    Par_Estatus             CHAR(1),
    Par_MonedaID            INT,

    Par_PolizaID            BIGINT(20),
    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Aud_EmpresaID           INT(11),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(11)
    )
TerminaStore: BEGIN

    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Consecutivo     VARCHAR(20);


    DECLARE  Entero_Cero        INT;
    DECLARE  SalidaSI           CHAR(1);
    DECLARE  SalidaNO           CHAR(1);
    DECLARE  Cadena_Vacia       CHAR(1);
    DECLARE  EstatusA           CHAR(1);


    SET Entero_Cero     := 0;
    SET SalidaSI        :='S';
    SET SalidaNO        :='N';
    SET Cadena_Vacia    := '';
    SET EstatusA        :='A';

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-CAJASTRANSFERALT');
            SET Var_Consecutivo := Entero_Cero;
            SET Var_Control := 'sqlException' ;
        END;
        SET Aud_FechaActual := NOW();

        IF(IFNULL(Par_SucOrigen,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr          := 001;
            SET Par_ErrMen          := CONCAT('La Sucursal Origen No Fue Seleccionada.');
            SET Var_Control         := 'sucursalDestino' ;
            SET Var_Consecutivo     := VarTransferID;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_SucDestino, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr          := 002;
            SET Par_ErrMen          := CONCAT('La Sucursal Destino No Fue Seleccionada.');
            SET Var_Control         := 'sucursalDestino' ;
            SET Var_Consecutivo     := VarTransferID;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CajaOrigen, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr          := 003;
            SET Par_ErrMen          := CONCAT('La Caja Origen Esta Vacia.');
            SET Var_Control         := 'cajaDestino' ;
            SET Var_Consecutivo     := VarTransferID;
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CajaDestino, Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr          := 004;
            SET Par_ErrMen          := CONCAT('La Caja Destino Esta Vacia.');
            SET Var_Control         := 'cajaDestino' ;
            SET Var_Consecutivo     := VarTransferID;
            LEAVE ManejoErrores;
        END IF;
        IF (Par_Estatus = Cadena_Vacia) THEN
            SET Par_Estatus := EstatusA;
        END IF;

        IF(Par_CajaOrigen = Par_CajaDestino )THEN
            SET Par_NumErr          := 006;
            SET Par_ErrMen          := CONCAT('La Caja Origen es la misma que la Caja Destino. Por tal motivo no se puede realizar la Transferencia.');
            SET Var_Control         := 'cajaDestino' ;
            SET Var_Consecutivo     := VarTransferID;
            LEAVE ManejoErrores;
        END IF;

        SET Aud_FechaActual := NOW();

        INSERT INTO CAJASTRANSFER(
            CajasTransferID,    SucursalOrigen,         SucursalDestino,    Fecha,              DenominacionID,
            Cantidad,           CajaOrigen,             CajaDestino,        Estatus,            MonedaID,
            EmpresaID,          Usuario,                FechaActual,        DireccionIP,        ProgramaID,
            Sucursal,           NumTransaccion,         PolizaID)
            VALUES(
            VarTransferID,      Par_SucOrigen,          Par_SucDestino,     Par_Fecha,          Par_DenominacionID,
            Par_Cantidad,       Par_CajaOrigen,         Par_CajaDestino,    Par_Estatus,        Par_MonedaID,
            Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion,     Par_PolizaID);

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Transferencia Realizada Exitosamente.');
        SET Var_Control := 'sucursalDestino' ;
        SET Var_Consecutivo := VarTransferID;

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;
END TerminaStore$$