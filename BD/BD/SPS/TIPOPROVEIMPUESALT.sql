-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEIMPUESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEIMPUESALT`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEIMPUESALT`(

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
                                             'esto le ocasiona. Ref: SP-TIPOPROVEIMPUESALT');
                    SET Var_Control := 'sqlException' ;
                END;




    SET Var_TipProvID := (SELECT TipoProveedorID FROM TIPOPROVEEDORES WHERE TipoProveedorID = Par_TipoProveedorID);

    IF(IFNULL(Var_TipProvID, Entero_Cero))= Entero_Cero then
            SET Par_NumErr  := 001;
            SET Par_ErrMen  :='El tipo de Proveedor especificado no Existe.';
            SET Var_Control := 'tipoProveedorID' ;
        LEAVE ManejoErrores;
    END IF;

    SET Var_TipImpID := (SELECT ImpuestoID FROM IMPUESTOS WHERE ImpuestoID = Par_ImpuestoID);

    IF(IFNULL(Var_TipImpID, Entero_Cero))= Entero_Cero then
            SET Par_NumErr  := 002;
            SET Par_ErrMen  :='El tipo de Impuesto Especificado no Existe';
            SET Var_Control := 'impuestoID' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Orden, Entero_Cero))= Entero_Cero then
            SET Par_NumErr  := 003;
            SET Par_ErrMen  :='El Orden no Puede ser Vacio';
            SET Var_Control := 'orden' ;
        LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

    INSERT INTO TIPOPROVEIMPUES(
        TipoProveedorID,        ImpuestoID,         Orden,          EmpresaID,      Usuario,
        FechaActual,            DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
    VALUES (
        Par_TipoProveedorID,    Par_ImpuestoID,     Par_Orden,      Aud_EmpresaID,   Aud_Usuario,
        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,    Aud_NumTransaccion);


            SET Par_NumErr := 000;
            SET Par_ErrMen := "Impuestos por Proveedor Grabados Exitosamente";
            SET Var_Control := 'tipoProveedorID';
            SET Var_Consecutivo := Par_TipoProveedorID;

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$