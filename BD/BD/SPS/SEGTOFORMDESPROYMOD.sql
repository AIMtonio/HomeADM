-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOFORMDESPROYMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOFORMDESPROYMOD`;DELIMITER $$

CREATE PROCEDURE `SEGTOFORMDESPROYMOD`(
    Par_SegtoPrograID       INT(11),
    Par_SegtoRealizaID      INT(11),
    Par_AsistenciaGpo       INT(11),
    Par_AvanceProy          INT(11),
    Par_MontoEstProd        DECIMAL(12,2),

    Par_UnidEstProd         BIGINT(20),
    Par_PrecioEstUni        DECIMAL(12,2),
    Par_MontoEspVtas        DECIMAL(12,2),
    Par_FechaComercializa   DATE,
    Par_ReconoceAdeudo      CHAR(1),

    Par_ConoceMtosFechas    CHAR(1),
    Par_TelefonoFijo        VARCHAR(20),
    Par_TelefonoCel         VARCHAR(20),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Aud_Empresa             INT(11) ,
    Aud_Usuario             INT(11) ,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_SucursalID          INT(11) ,
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Var_NomControl      VARCHAR(50);


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Fecha_Vacia         DATE;
    DECLARE SalidaSI            CHAR(1);
    DECLARE SalidaNO            CHAR(1);

    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Fecha_Vacia         := '1900-01-01';
    SET SalidaSI            := 'S';
    SET SalidaNO            := 'N';

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOFORMDESPROYMOD');
        SET Var_NomControl = 'sqlException' ;
    END;


    SET Par_NumErr          := Entero_Cero;
    SET Par_ErrMen          := Cadena_Vacia;

    IF NOT EXISTS(SELECT Ser.UsuarioSegto
                    FROM SEGTOREALIZADOS Ser
                    WHERE Ser.SegtoPrograID     = Par_SegtoPrograID
                      AND Ser.SegtoRealizaID    = Par_SegtoRealizaID)   THEN

        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT("No Existe un Seguimiento para esta Captura");
        SET Var_NomControl := 'segtoRealizaID' ;

        LEAVE ManejoErrores;

    END IF;

    IF NOT EXISTS(SELECT Sep.SegtoPrograID
                    FROM SEGTOFORMDESPROY Sep
                    WHERE Sep.SegtoPrograID     = Par_SegtoPrograID
                      AND Sep.SegtoRealizaID    = Par_SegtoRealizaID)   THEN

        SET Par_NumErr  := 2;
        SET Par_ErrMen  := CONCAT("No Existe Informacion para este Seguimiento Programado");
        SET Var_NomControl := 'segtoRealizaID' ;

        LEAVE ManejoErrores;

    END IF;

        UPDATE `SEGTOFORMDESPROY` SET
            `SegtoPrograID`     = Par_SegtoPrograID,
            `SegtoRealizaID`    = Par_SegtoRealizaID,
            `AsistenciaGpo`     = Par_AsistenciaGpo,
            `AvanceProy`        = Par_AvanceProy,
            `MontoEstProd`      = Par_MontoEstProd,
            `UnidEstProd`       = Par_UnidEstProd,
            `PrecioEstUni`      = Par_PrecioEstUni,
            `MontoEspVtas`      = Par_MontoEspVtas,
            `FechaComercializa` = Par_FechaComercializa,
            `ReconoceAdeudo`    = Par_ReconoceAdeudo,
            `ConoceMtosFechas`  = Par_ConoceMtosFechas,
            `TelefonoFijo`      = Par_TelefonoFijo,
            `TelefonoCel`       = Par_TelefonoCel,
            `EmpresaID`         = Aud_Empresa,
            `Usuario`           = Aud_Usuario,
            `FechaActual`       = Aud_FechaActual,
            `DireccionIP`       = Aud_DireccionIP,
            `ProgramaID`        = Aud_ProgramaID,
            `Sucursal`          = Aud_SucursalID,
            `NumTransaccion`    = Aud_NumTransaccion
            WHERE   SegtoPrograID     = Par_SegtoPrograID
                AND SegtoRealizaID    = Par_SegtoRealizaID;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT("Resultado del Seguimiento Modificado Exitosamente");
        SET Var_NomControl  := 'segtoRealizaID';

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_NomControl AS control,
                Par_SegtoRealizaID AS consecutivo;
    END IF;

END TerminaStore$$