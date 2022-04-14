-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBARCHACLARAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBARCHACLARAREP`;DELIMITER $$

CREATE PROCEDURE `TARDEBARCHACLARAREP`(
    Par_ReporteID       varchar(22),
    Par_NumRep          tinyint unsigned,

    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

DECLARE Rep_AclaraArc   int(11);

Set Rep_AclaraArc   := 1;

if(Par_NumRep = Rep_AclaraArc) then
	SELECT
        FolioID,    TipoArchivo,
            convert( CONCAT(Recurso,ReporteID, '/', NombreArchivo), char) as Recurso
	FROM TARDEBARCHACLARA
	WHERE ReporteID = Par_ReporteID;
end if;

END$$