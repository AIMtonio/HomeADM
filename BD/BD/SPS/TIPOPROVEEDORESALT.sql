-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEEDORESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEEDORESALT`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEEDORESALT`(

    Par_Descripcion         VARCHAR(200),
    Par_TipoPersona         CHAR(1),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT,
    INOUT   Par_ErrMen      VARCHAR(350),

    Aud_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),

    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
    )
TerminaStore: BEGIN


DECLARE     NumTipoProvID       INT;
DECLARE     Cadena_Vacia        CHAR(1);
DECLARE     Fecha_Vacia         DATE;
DECLARE     Entero_Cero         INT;
DECLARE     Decimal_Cero        DECIMAL(14,2);
DECLARE     Salida_SI           CHAR(1);
DECLARE     Var_Control         VARCHAR(200);
DECLARE     Var_Consecutivo     INT(11);


SET NumTipoProvID       := 0;
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Salida_SI           := 'S';

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := '999';
                    SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                             'esto le ocasiona. Ref: SP-TIPOPROVEEDORESALT');
                    SET Var_Control = 'sqlException' ;
                END;

IF(IFNULL(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'La Descripcion esta Vacia.';
        SET Var_Control := 'descripcion' ;
    LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_TipoPersona,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'Tipo Persona esta Vacio.';
        SET Var_Control := 'tipoPersona' ;
    LEAVE ManejoErrores;
END IF;


SET NumTipoProvID:= (SELECT IFNULL(MAX(TipoProveedorID),Entero_Cero) + 1
FROM TIPOPROVEEDORES);

SET Aud_FechaActual := CURRENT_TIMESTAMP();

INSERT INTO TIPOPROVEEDORES (
    TipoProveedorID,    Descripcion,        TipoPersona,        EmpresaID,          Usuario,
    FechaActual,        DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)
VALUES (
    NumTipoProvID,      Par_Descripcion,    Par_TipoPersona,    Aud_EmpresaID,      Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

SET Par_NumErr := 000;
SET Par_ErrMen := CONCAT("Tipo de Proveedor Agregado Exitosamente: ", CONVERT(NumTipoProvID, CHAR));
SET Var_Control := 'tipoProveedorID' ;
SET Var_Consecutivo := NumTipoProvID;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$