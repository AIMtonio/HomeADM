-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEIMPUESMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEIMPUESMOD`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEIMPUESMOD`(

    Par_TipoProveedorID     INT(11),
    Par_ImpuestoID          INT(11),
    Par_Orden               INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(350),

    Aud_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(20),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT

    )
TerminaStore: BEGIN


DECLARE  Entero_Cero       INT;
DECLARE  Decimal_Cero      DECIMAL(12,2);
DECLARE  Cadena_Vacia      CHAR(1);
DECLARE  Salida_SI         CHAR(1);
DECLARE  Var_Control       VARCHAR(200);
DECLARE  Var_Consecutivo   INT(11);


SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Salida_SI           := 'S';

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := '999';
                    SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                             'esto le ocasiona. Ref: SP-TIPOPROVEIMPUESMOD');
                    SET Var_Control := 'sqlException' ;
                END;

SET Aud_FechaActual := CURRENT_TIMESTAMP();

UPDATE TIPOPROVEIMPUES SET
    Orden           = Par_Orden,

    EmpresaID       = Aud_EmpresaID,
    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

WHERE TipoProveedorID = Par_TipoProveedorID
AND    ImpuestoID = Par_ImpuestoID;

    SET Par_NumErr := 000;
    SET Par_ErrMen := 'Impuesto de Proveedor Modificado Exitosamente';
    SET Var_Control:= 'tipoProveedorID' ;
    SET Var_Consecutivo := Par_TipoProveedorID;

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$