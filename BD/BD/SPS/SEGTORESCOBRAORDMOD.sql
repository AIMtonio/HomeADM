-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORESCOBRAORDMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTORESCOBRAORDMOD`;DELIMITER $$

CREATE PROCEDURE `SEGTORESCOBRAORDMOD`(
    Par_SegtoPrograID   INT(11),
    Par_SegtoRealizaID  INT(11),
    Par_FechaPromPago   DATE,
    Par_MontoPromPago   DECIMAL(14,2),
    Par_ExistFlujo      CHAR(1),
    Par_FechaEstFlujo   DATE,
    Par_OrigenPagoID    INT(11),
    Par_MotivoNPID      INT(11),
    Par_NomOriRecursos  VARCHAR(200),
    Par_TelefonFijo     VARCHAR(20),
    Par_TelefonCel      VARCHAR(20),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_Empresa         INT(11),
    Par_Usuario         INT(11),
    Par_FechaActual     DATETIME,
    Par_DireccionIP     VARCHAR(15),
    Par_ProgramaID      VARCHAR(50),
    Par_SucursalID      INT(11) ,
    Par_NumTransaccion  BIGINT(20)
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


    SET Par_NumErr          := Entero_Cero;
    SET Par_ErrMen          := Cadena_Vacia;

    IF NOT EXISTS(SELECT Ser.UsuarioSegto
                    FROM SEGTOREALIZADOS Ser
                    WHERE Ser.SegtoPrograID     = Par_SegtoPrograID
                      AND Ser.SegtoRealizaID    = Par_SegtoRealizaID)   THEN

        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT("No Existe un Seguimiento para esta Captura");
        SET Var_NomControl := 'segtoRealizaIDCob' ;

        LEAVE ManejoErrores;

    END IF;

    IF NOT EXISTS(SELECT Sep.SegtoPrograID
                    FROM SEGTORESCOBRAORD Sep
                    WHERE Sep.SegtoPrograID     = Par_SegtoPrograID
                      AND Sep.SegtoRealizaID    = Par_SegtoRealizaID)   THEN

        SET Par_NumErr  := 2;
        SET Par_ErrMen  := CONCAT("No Existe Informacion para este Seguimiento Programado");
        SET Var_NomControl := 'segtoRealizaIDCob' ;

        LEAVE ManejoErrores;

    END IF;

    UPDATE SEGTORESCOBRAORD SET
        FechaPromPago   = Par_FechaPromPago,
        MontoPromPago   = Par_MontoPromPago,
        ExistFlujo      = Par_ExistFlujo,
        FechaEstFlujo   = Par_FechaEstFlujo,
        OrigenPagoID    = Par_OrigenPagoID,
        MotivoNPID      = Par_MotivoNPID,
        NombreOriRecursos   = Par_NomOriRecursos,
        TelefonoFijo    = Par_TelefonFijo,
        TelefonoCel     = Par_TelefonCel,
        EmpresaID       = Par_Empresa,
        Usuario         = Par_Usuario,
        FechaActual     = Par_FechaActual,
        DireccionIP     = Par_DireccionIP,
        ProgramaID      = Par_ProgramaID,
        Sucursal        = Par_SucursalID,
        NumTransaccion  = Par_NumTransaccion

        WHERE SegtoPrograID     = Par_SegtoPrograID
          AND SegtoRealizaID    = Par_SegtoRealizaID;

        SET Par_NumErr  := 0;
        SET Par_ErrMen  := CONCAT("Resultado del Seguimiento Modificados Exitosamente");
        SET Var_NomControl  := 'segtoRealizaIDCob';


    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_NomControl AS control,
                Entero_Cero AS consecutivo;
    END IF;

END TerminaStore$$