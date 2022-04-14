-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTORESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTORESMOD`;DELIMITER $$

CREATE PROCEDURE `PROMOTORESMOD`(

    Par_PromotorID          INT(11),
    Par_NomPromotor         VARCHAR(100),
    Par_NombCoordin         VARCHAR(100),
    Par_Telefono            VARCHAR(20),
    Par_Correo              VARCHAR(50),

    Par_Celular             VARCHAR(20),
    Par_SucursalID          INT(11),
    Par_UsuarioID           INT(11),
    Par_NumEmpleado         VARCHAR(20),
    Par_Estatus             CHAR (1),

    Par_ExtTelefonoPart     VARCHAR(6),
    Par_EmpresaID           INT(11),
    Par_AplicaPromotor      VARCHAR(35),

    Par_GestorID            INT(11),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT (11),

    INOUT   Par_ErrMen      VARCHAR(350),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),

    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT
    )
TerminaStore: BEGIN


DECLARE Var_Consecutivo     INT(11);
DECLARE Var_Control         VARCHAR(200);


DECLARE NumeroEmpresa   INT(11);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT(11);
DECLARE Salida_SI       CHAR(1);


SET NumeroEmpresa   := 1;
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

    IF(NOT EXISTS (SELECT PromotorID
                FROM PROMOTORES
                WHERE PromotorID = Par_PromotorID)) THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'El Numero de Promotor no existe';
        SET Var_Control := 'promotorID';
        LEAVE ManejoErrores;
    END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();

UPDATE PROMOTORES SET
    NombrePromotor      = Par_NomPromotor,
    NombreCoordinador   = Par_NombCoordin,
    Telefono            = Par_Telefono,
    Correo              = Par_Correo,
    Celular             = Par_Celular,

    SucursalID          = Par_SucursalID,
    UsuarioID           = Par_UsuarioID,
    NumeroEmpleado      = Par_NumEmpleado,
    Estatus             = Par_Estatus,
    ExtTelefonoPart     = Par_ExtTelefonoPart,

    EmpresaID           = Par_EmpresaID,
    AplicaPromotor      = Par_AplicaPromotor,
    GestorID            = Par_GestorID,
    Usuario             = Aud_Usuario,
    FechaActual         = Aud_FechaActual,
    DireccionIP         = Aud_DireccionIP,

    ProgramaID          = Aud_ProgramaID,
    Sucursal            = Aud_Sucursal,
    NumTransaccion      = Aud_NumTransaccion

WHERE PromotorID        = Par_PromotorID;

    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT('Promotor Modificado Exitosamente: ',CAST(Par_PromotorID AS CHAR) );
    SET Var_Control     := 'promotorID';
    SET Var_Consecutivo := Par_PromotorID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;



END TerminaStore$$