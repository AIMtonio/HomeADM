-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEIMPUESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEIMPUESBAJ`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEIMPUESBAJ`(

    Par_TipoProveedorID     INT(11),

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
DECLARE  Decimal_Cero      DECIMAL(14,2);
DECLARE  Cadena_Vacia      CHAR(1);
DECLARE  Salida_SI         CHAR(1);



DECLARE  Var_TipProvID     INT(12);
DECLARE  Var_Control       VARCHAR(200);
DECLARE  Var_Consecutivo   INT(11);
DECLARE  Var_TipImpID      INT(11);


SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Salida_SI           := 'S';


ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := '999';
                    SET Par_ErrMen := concat('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                             'esto le ocasiona. Ref: SP-TIPOPROVEIMPUESBAJ');
                    SET Var_Control := 'sqlException' ;
                END;


    DELETE FROM TIPOPROVEIMPUES
    WHERE   TipoProveedorID = Par_TipoProveedorID;


    SET Par_NumErr := 000;
    SET Par_ErrMen := "Impuestos por Proveedor Grabados Exitosamente";
    SET Var_Control := 'tipoProveedorID';


END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$