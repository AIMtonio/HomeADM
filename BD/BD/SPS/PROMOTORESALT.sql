-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTORESALT`;DELIMITER $$

CREATE PROCEDURE `PROMOTORESALT`(

    Par_NombrPromot     VARCHAR(100),
    Par_NombrCoordi     VARCHAR(100),
    Par_Telefono        VARCHAR(20),
    Par_Correo          VARCHAR(50),
    Par_Celular         VARCHAR(20),

    Par_SucursalID      INT(11),
    Par_UsuarioID       INT(11),
    Par_NumEmpleado     VARCHAR(20),
    Par_ExtTelefonoPart VARCHAR(6),
    Par_AplicaPromotor  CHAR(2),

    Par_GestorID        INT(11),

    Par_Salida          CHAR(1),
    INOUT   Par_NumErr  INT (11),
    INOUT   Par_ErrMen  VARCHAR(350),
    Par_EmpresaID       INT,
    Aud_Usuario         INT,

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN


DECLARE Var_Consecutivo     INT(11);
DECLARE Var_Control         VARCHAR(200);


DECLARE NumeroPromotor  INT;
DECLARE Estatus_Activo  CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Salida_SI       CHAR(1);


SET NumeroPromotor  := 0;
SET Estatus_Activo  := 'A';
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Salida_SI       :='S';



ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                    'esto le ocasiona. Ref: SP-ESCRITURAPUBMOD');
            SET Var_Control = 'sqlException';
        END;

    IF(EXISTS(SELECT PromotorID FROM PROMOTORES
                WHERE UsuarioID = Par_UsuarioID AND Estatus = Estatus_Activo)) THEN
        SET Par_NumErr := 001;
        SET Par_ErrMen := 'El usuario ya tiene un promotor activo';
        SET Var_Control := 'PromotorID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NombrPromot, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 001;
        SET Par_ErrMen := 'El Nombre de promotor esta Vacio';
        SET Var_Control := 'nombrePromotor';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NombrCoordi, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 002;
        SET Par_ErrMen := 'El Nombre de coordinador esta Vacio';
        SET Var_Control := 'nombreCorrdinador';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_SucursalID, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 003;
        SET Par_ErrMen := 'El numero de sucursal Vacio';
        SET Var_Control := 'sucursalID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_UsuarioID, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 004;
        SET Par_ErrMen := 'El numero de usuario Vacio';
        SET Var_Control := 'usuarioID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_NumEmpleado, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 005;
        SET Par_ErrMen := 'El numero de empleado Vacio';
        SET Var_Control := 'numeroEmpleado';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_AplicaPromotor, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 006;
        SET Par_ErrMen :='El Campo Aplica Promotor esta vaci­o';
        SET Var_Control := 'aplicaPromotor';
        LEAVE ManejoErrores;
    END IF;

SET NumeroPromotor := (SELECT IFNULL(MAX(PromotorID),Entero_Cero) + 1
FROM PROMOTORES);
SET Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO `PROMOTORES`(
        `PromotorID`,   `EmpresaID`,        `NombrePromotor`,   `NombreCoordinador`,    `Telefono`,
        `Correo`,       `Celular`,          `SucursalID`,       `UsuarioID`,            `NumeroEmpleado`,
        `Estatus`,      `ExtTelefonoPart`,  `AplicaPromotor`,   `GestorID`,             `Usuario`,
        `FechaActual`,  `DireccionIP`,      `ProgramaID`,       `Sucursal`,             `NumTransaccion`)
    VALUES(
        NumeroPromotor,     Par_EmpresaID,      Par_NombrPromot,    Par_NombrCoordi,    Par_Telefono,
        Par_Correo,         Par_Celular,        Par_SucursalID,     Par_UsuarioID,      Par_NumEmpleado,
        Estatus_Activo,     Par_ExtTelefonoPart,Par_AplicaPromotor, Par_GestorID,       Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT('Promotor Agregado Exitosamente: ',CAST(NumeroPromotor AS CHAR) );
    SET Var_Control     := 'promotorID';
    SET Var_Consecutivo := NumeroPromotor;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$