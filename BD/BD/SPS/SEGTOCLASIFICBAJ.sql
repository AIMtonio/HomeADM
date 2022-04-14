-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCLASIFICBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOCLASIFICBAJ`;DELIMITER $$

CREATE PROCEDURE `SEGTOCLASIFICBAJ`(
    Par_SeguimientoID       INT(11),
    Par_TipoBaja            TINYINT UNSIGNED,

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Salida_SI           CHAR(1);


    SET Salida_SI           := 'S';

       DELETE FROM SEGTOCLASIFSEGTO
        WHERE SeguimientoID = Par_SeguimientoID;


    SELECT  000     AS NumErr,
                "Clasificaciones Eliminadas Exitosamente"   AS ErrMen,
               'seguimientoID' AS control,
                Par_SeguimientoID AS consecutivo;


END TerminaStore$$