-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRAMADOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOPROGRAMADOBAJ`;DELIMITER $$

CREATE PROCEDURE `SEGTOPROGRAMADOBAJ`(
    Par_SegtoPrograID       INT(11),
    Par_TipoBaja            TINYINT UNSIGNED,
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN


DECLARE VarControl  VARCHAR(15);
DECLARE Var_Estatus CHAR(1);


DECLARE Cancelado       CHAR(1);
DECLARE BajaSegui       INT(11);
DECLARE Salida_SI       CHAR(1);
DECLARE Entero_Cero     INT(11);
DECLARE Programado      CHAR(1);
DECLARE Cadena_Vacia    CHAR(1);


SET Cancelado       :='C';
SET BajaSegui       :=1;
SET Salida_SI       :='S';
SET Entero_Cero     :=0;
SET Programado      :='P';
SET Cadena_Vacia    :='';

ManejoErrores:BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  := 999;
                SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
                                ' esto le ocasiona. Ref: SP-SEGTOPROGRAMADOBAJ');
                SET VarControl := 'sqlException';
            END;




    IF(Par_SegtoPrograID = Entero_cero) THEN
        SET Par_NumErr   := 01;
        SET Par_ErrMen   := 'La Secuencia del Seguimiento esta Vacio';
        SET VarControl   := 'segtoPrograID';
        LEAVE ManejoErrores;
    END IF;

    SET Var_Estatus := IFNULL((SELECT Estatus
                            FROM SEGTOPROGRAMADO
                            WHERE SegtoPrograID = Par_SegtoPrograID),Cadena_Vacia);

    IF(Par_TipoBaja = BajaSegui AND Var_Estatus = Programado)THEN

        UPDATE SEGTOPROGRAMADO
        SET Estatus = Cancelado
        WHERE SegtoPrograID = Par_SegtoPrograID;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Seguimiento Eliminado Exitosamente: ', Par_SegtoPrograID);
        SET varControl  := 'segtoPrograID';
    ELSE
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := CONCAT('El Seguimiento no Puede ser Eliminado');
        SET varControl  := 'segtoPrograID';

    END IF;

    END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen   AS ErrMen,
            varControl   AS control,
            Entero_Cero  AS consecutivo;
END IF;

END TerminaStore$$