-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONGESTORBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONGESTORBAJ`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONGESTORBAJ`(
    Par_GestorID        INT(11),
    Par_TipoGestionID   INT(11),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore:BEGIN

    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT(11);
    DECLARE VarControl      VARCHAR(25);
    DECLARE Salida_SI       CHAR(1);

    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET Salida_SI       := 'S';

        DELETE FROM SEGTOADMONXPROMOTOR
            WHERE GestorID = Par_GestorID
                AND TipoGestionID = Par_TipoGestionID;
        DELETE FROM SEGTOADMONXSUCURSAL
            WHERE GestorID = Par_GestorID
                AND TipoGestionID = Par_TipoGestionID;
        DELETE FROM SEGTOADMONXZONA
            WHERE GestorID = Par_GestorID
                AND TipoGestionID = Par_TipoGestionID;
        DELETE FROM SEGTOADMONGESTOR
            WHERE GestorID = Par_GestorID
                AND TipoGestionID = Par_TipoGestionID;

        SELECT  000     AS NumErr,
            "Registros dados de baja correctamente" AS ErrMen,
           'gestorID' AS control,
            Par_GestorID AS consecutivo;

END TerminaStore$$