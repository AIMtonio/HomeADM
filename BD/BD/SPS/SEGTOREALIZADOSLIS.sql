-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOREALIZADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOREALIZADOSLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTOREALIZADOSLIS`(
    Par_SegtoPrograID   INT(11),
    Par_NumLis          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT(11);
    DECLARE Lis_Principal       INT(11);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Lis_Principal   := 1;

    IF(Par_NumLis = Lis_Principal) THEN
        SELECT SegtoRealizaID, FechaCaptura, SUBSTRING(Comentario,1,20) AS Comentario
            FROM SEGTOREALIZADOS
                WHERE SegtoPrograID = Par_SegtoPrograID
            ORDER BY SegtoRealizaID DESC;

    END IF;

END TerminaStore$$