-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOALCANCEPLAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOALCANCEPLAALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOALCANCEPLAALT`(
    Par_SeguimientoID       INT(11),
    Par_PlazaID             INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(350),

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Var_Control         VARCHAR(50);
    DECLARE Var_Consecutivo     VARCHAR(50);


    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT(11);
    DECLARE Salida_SI       CHAR(1);
    DECLARE Salida_NO       CHAR(1);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Salida_SI       := 'S';
    SET Salida_NO       := 'N';


    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOALCANCEPLAALT');
        SET Var_Control = 'sqlException' ;
    END;

        INSERT INTO `SEGTOXPLAZAS`
           (`SeguimientoID`,   `PlazaID`,       `EmpresaID`,    `Usuario`,      `FechaActual`,
            `DireccionIP`,     `ProgramaID`,    `Sucursal`,     `NumTransaccion`)
        VALUES
        (   Par_SeguimientoID,  Par_PlazaID,     Aud_EmpresaID,  Aud_Usuario,   Aud_FechaActual,
            Aud_DireccionIP,    Aud_ProgramaID,  Aud_Sucursal,   Aud_NumTransaccion
        );

        SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT("Alcance Agregado Exitosamente: ", CONVERT(Par_SeguimientoID, CHAR));
        SET Var_Control     := 'seguimientoID';
        SET Var_Consecutivo := Par_SeguimientoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

    IF(Par_Salida = Salida_NO) THEN
        SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
        SET Par_ErrMen := Par_ErrMen;
    END IF;

END TerminaStore$$