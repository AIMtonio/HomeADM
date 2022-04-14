-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOFORMDESPROYALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOFORMDESPROYALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOFORMDESPROYALT`(
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
    DECLARE Entero_Cero         INT(11);
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
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOFORMDESPROYALT');
        SET Var_NomControl = 'sqlException' ;
    END;


    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := Cadena_Vacia;

    IF NOT EXISTS(SELECT Ser.UsuarioSegto
                    FROM SEGTOREALIZADOS Ser
                    WHERE Ser.SegtoPrograID     = Par_SegtoPrograID
                      AND Ser.SegtoRealizaID    = Par_SegtoRealizaID)   THEN

        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT("No Existe un Seguimiento para esta Captura");
        SET Var_NomControl := 'segtoRealizaID' ;

        LEAVE ManejoErrores;

    END IF;


    INSERT INTO `SEGTOFORMDESPROY`(
        `SegtoPrograID`,    `SegtoRealizaID`,   `AsistenciaGpo`,    `AvanceProy`,           `MontoEstProd`,
        `UnidEstProd`,      `PrecioEstUni`,     `MontoEspVtas`,     `FechaComercializa`,    `ReconoceAdeudo`,
        `ConoceMtosFechas`, `TelefonoFijo`,     `TelefonoCel`,      `EmpresaID`,            `Usuario`,
        `FechaActual`,      `DireccionIP`,      `ProgramaID`,       `Sucursal`,             `NumTransaccion`)
    VALUES(
        Par_SegtoPrograID,      Par_SegtoRealizaID, Par_AsistenciaGpo,  Par_AvanceProy,         Par_MontoEstProd,
        Par_UnidEstProd,        Par_PrecioEstUni,   Par_MontoEspVtas,   Par_FechaComercializa,  Par_ReconoceAdeudo,
        Par_ConoceMtosFechas,   Par_TelefonoFijo,   Par_TelefonoCel,    Aud_Empresa,            Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_SucursalID,         Aud_NumTransaccion );

    SET Par_NumErr  := 0;
    SET Par_ErrMen  := CONCAT("Resultado del Seguimiento Registrado Exitosamente.");
    SET Var_NomControl  := 'segtoRealizaID';


END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_NomControl AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$