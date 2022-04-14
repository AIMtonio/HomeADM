-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORECOMENDASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTORECOMENDASALT`;DELIMITER $$

CREATE PROCEDURE `SEGTORECOMENDASALT`(

    Par_Descripcion     VARCHAR(200),
    Par_Alcance         CHAR(1),
    Par_ReqSupervisor   CHAR(1),
    Par_Estatus         CHAR(1),

    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(150),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN


    DECLARE Var_Control                 VARCHAR(50);
    DECLARE Var_Consecutivo             VARCHAR(50);
    DECLARE Var_RecomendacionSegtoID    INT(11);


    DECLARE Entero_Cero                 INT(11);
    DECLARE Cadena_Vacia                CHAR(1);
    DECLARE Salida_SI                   CHAR(1);


    SET Entero_Cero     := 0;
    SET Cadena_Vacia    := '';
    SET Salida_SI       := 'S';

    ManejoErrores:BEGIN


    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTORECOMENDASALT');
        SET Var_Control = 'sqlException' ;
    END;

    IF IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '01';
        SET Par_ErrMen      := 'Especifique la Descripcion';
        SET Var_Control     := 'descripcion';
        SET Var_Consecutivo := Par_Descripcion;
        LEAVE ManejoErrores;
    END IF;

    IF IFNULL(Par_Alcance, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '02';
        SET Par_ErrMen      := 'Especifique el Alcance';
        SET Var_Control     := 'alcance';
        SET Var_Consecutivo := Par_Alcance;
        LEAVE ManejoErrores;
    END IF;

    IF IFNULL(Par_ReqSupervisor, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '03';
        SET Par_ErrMen      := 'Especifique el Supervisor';
        SET Var_Control     := 'reqSupervisor';
        SET Var_Consecutivo := Par_ReqSupervisor;
        LEAVE ManejoErrores;
    END IF;


    IF IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '04';
        SET Par_ErrMen      := 'Especifique el Estatus';
        SET Var_Control     := 'estatus';
        SET Var_Consecutivo := Par_Estatus;
        LEAVE ManejoErrores;
    END IF;

    CALL FOLIOSAPLICAACT('SEGTORECOMENDAS', Var_RecomendacionSegtoID);
    SET Aud_FechaActual := NOW();

    INSERT INTO `SEGTORECOMENDAS`(
        `RecomendacionSegtoID`, `Descripcion`,      `Alcance`,      `ReqSupervisor`,        `Estatus`,
        `EmpresaID`,            `Usuario`,          `FechaActual`,  `DireccionIP`,          `ProgramaID`,
        `Sucursal`,             `NumTransaccion`)
    VALUES(
        Var_RecomendacionSegtoID,   Par_Descripcion,    Par_Alcance,        Par_ReqSupervisor,  Par_Estatus,
        Aud_EmpresaID,              Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,               Aud_NumTransaccion
    );

    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT('Recomendacion Agregada Exitosamente: ', Var_RecomendacionSegtoID );
    SET Var_Control     := 'recomendacionSegtoID';
    SET Var_Consecutivo := Var_RecomendacionSegtoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN

    SELECT
        Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$