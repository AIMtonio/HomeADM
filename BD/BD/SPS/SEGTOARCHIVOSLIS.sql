-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOARCHIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTOARCHIVOSLIS`(
    Par_SegtoPrograID   INT(11),
    Par_SecuenciaID     INT(11),
    Par_NumLis          INT(11),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN

    DECLARE Lis_Principal   INT(11);
    DECLARE Lis_Archivos    INT(11);

    SET Lis_Principal   := 1;
    SET Lis_Archivos    := 2;

    IF(Par_NumLis = Lis_Archivos)THEN
        SELECT
            Seg.SegtoPrograID, Seg.NumSecuencia, Seg.FolioID, Seg.Fecha, Seg.RutaArchivo,
            Seg.NombreArchivo, Seg.TipoDocumentoID, Seg.Comentarios, Tip.Descripcion
        FROM SEGTOARCHIVOS Seg
        INNER JOIN TIPOSDOCUMENTOS Tip ON Seg.TipoDocumentoID = Tip.TipoDocumentoID
        WHERE Seg.SegtoPrograID = Par_SegtoPrograID AND Seg.NumSecuencia = Par_SecuenciaID;

    END IF;

END TerminaStore$$