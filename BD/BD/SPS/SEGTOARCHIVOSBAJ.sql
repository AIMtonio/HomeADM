-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOARCHIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOARCHIVOSBAJ`;DELIMITER $$

CREATE PROCEDURE `SEGTOARCHIVOSBAJ`(
    Par_SegtoPrograID   INT(11),
    Par_SecuenciaID     INT(11),

    Aud_Empresa         INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN

    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT(11);

    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;

    DELETE
        FROM SEGTOARCHIVOS
        WHERE SegtoPrograID = Par_SegtoPrograID AND NumSecuencia = Par_SecuenciaID;

    SELECT '000' AS NumErr ,
        'Archivos Adjuntos Eliminados Correctamente' AS ErrMen,
        Cadena_Vacia AS control,
        Entero_Cero AS consecutivo;

END TerminaStore$$