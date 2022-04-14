-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOTARIASMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOTARIASMOD`;DELIMITER $$

CREATE PROCEDURE `NOTARIASMOD`(

    Par_EstadoID        INT(11),
    Par_MunicipioID     INT(11),
    Par_NotariaID       INT(11),
    Par_Titular         VARCHAR(200),
    Par_Direccion       CHAR(240),

    Par_Telefono        CHAR(20),
    Par_Correo          VARCHAR(50),
    Par_ExtTelefonoPart VARCHAR(6),
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT (11),

    INOUT Par_ErrMen    VARCHAR(350),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),

    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN


DECLARE Var_Consecutivo     INT(11);
DECLARE Var_Control         VARCHAR(200);


DECLARE Estatus_Activo  CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT(11);
DECLARE Salida_SI       CHAR(1);


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

    IF(not exists(SELECT EstadoID, municipioID, NotariaID
                FROM NOTARIAS
                WHERE EstadoID = Par_EstadoID AND MunicipioID = Par_MunicipioID
                AND     NotariaID = Par_NotariaID )) THEN
        SET Par_NumErr  = 001;
        SET Par_ErrMen  = 'El Estado o Muncipio no Existe';
        SET Var_Control = 'estadoID';
        LEAVE ManejoErrores;
    END IF;


    IF(ifnull(Par_NotariaID, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  = 003;
        SET Par_ErrMen  = 'El no. de Notaria esta Vacio';
        SET Var_Control = 'notariaID';
        LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_Titular, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  = 004;
        SET Par_ErrMen  = 'El titular esta Vacio';
        SET Var_Control = 'titular';
        LEAVE ManejoErrores;
    END IF;

    IF(ifnull(Par_Direccion, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  = 005;
        SET Par_ErrMen  = 'La Direccion esta Vacia';
        SET Var_Control = 'direccion';
        LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

UPDATE NOTARIAS SET
    Titular         = Par_Titular,
    Direccion       = Par_Direccion,
    Telefono        = Par_Telefono,
    Correo          = Par_Correo,
    ExtTelefonoPart = Par_ExtTelefonoPart,
    EmpresaID       = Par_EmpresaID,

    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

WHERE EstadoID = Par_EstadoID
  AND MunicipioID = Par_MunicipioID
  AND NotariaID = Par_NotariaID;

    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT('Notaria Modificada Exitosamente: ',CAST(Par_NotariaID AS CHAR) );
    SET Var_Control     := 'notariaID';
    SET Var_Consecutivo := Par_EstadoID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;



END TerminaStore$$