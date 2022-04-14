-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRAMAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOPROGRAMAALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOPROGRAMAALT`(
    Par_SeguimientoID       INT(11),
    Par_Periodicidad        CHAR(1),
    Par_Avance              INT(11),
    Par_DiasPostOtorga      INT(11),
    Par_DiasAnteLiquida     INT(11),
    Par_DiasAntePagCuota    INT(11),
    Par_PlazoMinUltSegto    INT(11),
    Par_PlazoMaxUltSegto    INT(11),
    Par_PlazoMaxEventos     INT(11),
    Par_DiaFijoMes          INT(11),
    Par_DiaFijoSem          CHAR(2),
    Par_DiaHabil            CHAR(1),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(350),

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
    DECLARE VarProgramaID       INT(11);


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
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOPROGRAMAALT');
        SET Var_Control = 'sqlException' ;
    END;

    SET VarProgramaID := (SELECT IFNULL(MAX(ProgramacionID),Entero_Cero)+ 1 FROM SEGTOPROGRASEGTO);

    INSERT INTO `SEGTOPROGRASEGTO`
        (`SeguimientoID`,   `ProgramacionID`,   `Periodicidad`,     `Avance`,           `DiasPostOtorga`,
         `DiasAnteLiquida`, `DiasAntePagCuota`, `PlazoMinUltSegto`, `PlazoMaxUltSegto`, `PlazoMaxEventos`,
         `DiaFijoMes`,      `DiaFijoSem`,       `DiaHabil`,         `EmpresaID`,        `Usuario`,
         `FechaActual`,     `DireccionIP`,      `ProgramaID`,       `Sucursal`,         `NumTransaccion`)
    VALUES
        (Par_SeguimientoID,     VarProgramaID,          Par_Periodicidad,       Par_Avance,             Par_DiasPostOtorga,
         Par_DiasAnteLiquida,   Par_DiasAntePagCuota,   Par_PlazoMinUltSegto,   Par_PlazoMaxUltSegto,   Par_PlazoMaxEventos,
         Par_DiaFijoMes,        Par_DiaFijoSem,         Par_DiaHabil,           Aud_EmpresaID,          Aud_Usuario,
         Aud_FechaActual,       Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    SET Par_NumErr      := 0;
    SET Par_ErrMen      := CONCAT("Programacion de Seguimiento Agregado Exitosamente: ", CONVERT(VarProgramaID, CHAR));
    SET Var_Control     := 'seguimientoID';
    SET Var_Consecutivo := VarProgramaID;

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