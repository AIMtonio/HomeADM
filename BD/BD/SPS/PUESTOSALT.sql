-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUESTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUESTOSALT`;DELIMITER $$

CREATE PROCEDURE `PUESTOSALT`(
    Par_ClavePuestoID       VARCHAR(10),
    Par_Descripcion         VARCHAR(100),
    Par_AtiendeSuc          CHAR(1),
    Par_AreaID              BIGINT(20),
    Par_CategoriaID         INT(11),

    Par_EsGestor            CHAR(1),
    Par_EsSupervisor        CHAR(1),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Var_Area            INT(11);
    DECLARE Var_Control                 VARCHAR(50);
    DECLARE Var_Consecutivo             VARCHAR(50);


    DECLARE Estatus_Puesto      CHAR;
    DECLARE Entero_Cero         INT(11);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE SalidaSI        CHAR(1);


    SET Estatus_Puesto      := 'V';
    SET Entero_Cero         :=0;
    SET Cadena_Vacia        := '';
    SET SalidaSI        := 'S';

    ManejoErrores:BEGIN


    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-PUESTOSALT');
        SET Var_Control = 'sqlException' ;
    END;

    IF(IFNULL(Par_ClavePuestoID,Cadena_vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := 1;
        SET Par_ErrMen      := 'La Clave del Puesto esta vacia';
        SET Var_Control     := 'clavePuestoID';
        SET Var_Consecutivo :=  Par_ClavePuestoID;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr      := 2;
        SET Par_ErrMen      := 'La Descripcion esta Vacia';
        SET Var_Control     := 'descripcion';
        SET Var_Consecutivo :=  descripcion;
        LEAVE ManejoErrores;
    END IF;

    IF(EXISTS(SELECT ClavePuestoID
                FROM PUESTOS
                WHERE ClavePuestoID = Par_ClavePuestoID)) THEN
        SET Par_NumErr      := 3;
        SET Par_ErrMen      := 'El Puesto Ya Existe con Estatus Baja';
        SET Var_Control     := 'clavePuestoID';
        SET Var_Consecutivo :=  Par_ClavePuestoID;
        LEAVE ManejoErrores;
    END IF;


    SET Aud_FechaActual := CURRENT_TIMESTAMP();

    SET Par_EsSupervisor := IFNULL(Par_EsSupervisor,Cadena_Vacia);

    IF(Par_EsGestor='N')THEN
    SET Par_EsSupervisor := '';
    END IF;

    INSERT INTO PUESTOS (ClavePuestoID,     AreaID,         CategoriaID,         Descripcion,       AtiendeSuc,
                         Estatus,           EsGestor,       EsSupervisor,        EmpresaID,         Usuario,
                         FechaActual,       DireccionIP,    ProgramaID,          Sucursal,          NumTransaccion)

     VALUES            (Par_ClavePuestoID,  Par_AreaID,     Par_CategoriaID,     Par_Descripcion,    Par_AtiendeSuc,
                       Estatus_Puesto,     Par_EsGestor,    Par_EsSupervisor,    Aud_EmpresaID,      Aud_Usuario,
                       Aud_FechaActual,  Aud_DireccionIP,   Aud_ProgramaID,      Aud_Sucursal,       Aud_NumTransaccion);


    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT("Puesto Agregado Exitosamente: ", Par_ClavePuestoID);
    SET Var_Control     := 'clavePuestoID';
    SET Var_Consecutivo := Par_ClavePuestoID;

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN

    SELECT
        Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$