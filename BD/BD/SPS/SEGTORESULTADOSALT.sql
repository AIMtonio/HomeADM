-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORESULTADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTORESULTADOSALT`;DELIMITER $$

CREATE PROCEDURE `SEGTORESULTADOSALT`(

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
    DECLARE Var_ResultadoSegtoID        INT(11);


    DECLARE Entero_Cero                 INT;
    DECLARE Cadena_Vacia                CHAR(1);
    DECLARE Salida_SI                   CHAR(1);

    SET Entero_Cero     := 0;
    SET Cadena_Vacia    := '';
    SET Salida_SI       := 'S';


    ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTORESULTADOSALT');
        SET Var_Control = 'sqlException' ;
    END;


    IF IFNULL(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '01';
        SET Par_ErrMen      := 'Especifique la DescripciÃ³n';
        SET Var_Control     := 'descripcion';
        SET Var_Consecutivo := Par_Descripcion;
    END IF;

    IF IFNULL(Par_Alcance, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '02';
        SET Par_ErrMen      := 'Especifique el Alcance';
        SET Var_Control     := 'alcance';
        SET Var_Consecutivo := Par_Alcance;
    END IF;

    IF IFNULL(Par_ReqSupervisor, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '03';
        SET Par_ErrMen      := 'Especifique el Supervisor';
        SET Var_Control     := 'reqSupervisor';
        SET Var_Consecutivo := Par_ReqSupervisor;
    END IF;


    IF IFNULL(Par_Estatus, Cadena_Vacia) = Cadena_Vacia THEN
        SET Par_NumErr      := '04';
        SET Par_ErrMen      := 'Especifique el Estatus';
        SET Var_Control     := 'estatus';
        SET Var_Consecutivo := Par_Estatus;
    END IF;

    CALL FOLIOSAPLICAACT('SEGTORESULTADOS', Var_ResultadoSegtoID);
    SET Aud_FechaActual := NOW();

    INSERT INTO `SEGTORESULTADOS`(
        `ResultadoSegtoID`, `Descripcion`,  `Alcance`,  `ReqSupervisor`,     `Estatus`,
        `EmpresaID`,            `Usuario`,  `FechaActual`,  `DireccionIP`,  `ProgramaID`,
        `Sucursal`,`NumTransaccion`)
    VALUES(
        Var_ResultadoSegtoID,   Par_Descripcion,    Par_Alcance,        Par_ReqSupervisor,  Par_Estatus,
        Aud_EmpresaID,      Aud_Usuario,Aud_FechaActual,    Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,
        Aud_NumTransaccion  );

    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT('Resultado Agregado Exitosamente: ', Var_ResultadoSegtoID );
    SET Var_Control     := 'resultadoSegtoID';
    SET Var_Consecutivo := Var_ResultadoSegtoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN

    SELECT
        Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$