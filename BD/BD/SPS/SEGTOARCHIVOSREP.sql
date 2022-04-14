-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOARCHIVOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOARCHIVOSREP`;DELIMITER $$

CREATE PROCEDURE `SEGTOARCHIVOSREP`(
    Par_SegtoPrograID   INT(11),
    Par_NumSecuencia    INT(11),
    Par_NumRep          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore:BEGIN

    DECLARE Rep_ArchivosSegto INT;

    SET Rep_ArchivosSegto   := 1;

    IF (Par_NumRep = Rep_ArchivosSegto) THEN
        SELECT
                Seg.SegtoPrograID, Seg.NumSecuencia, Cat.Descripcion AS Categoria,
                Pro.CreditoID, Pro.GrupoID,
                CASE WHEN Pro.CreditoID != 0 THEN Pro.CreditoID
                    WHEN Pro.GrupoID != 0 THEN Pro.GrupoID
                END AS Tipo,
                CASE WHEN Pro.CreditoID != 0 THEN Cli.NombreCompleto
                    WHEN Pro.GrupoID != 0 THEN Gru.NombreGrupo
                END AS NombreCompleto,
                Res.NombreCompleto AS Gestor, Sup.NombreCompleto AS Supervisor,
                Seg.FolioID, CONCAT(Seg.RutaArchivo, '/', Seg.SegtoPrograID, '/',Seg.NombreArchivo) AS Recurso,
                Seg.Comentarios, Tip.Descripcion AS DescTipoDocumento
            FROM SEGTOARCHIVOS Seg
            INNER JOIN SEGTOPROGRAMADO Pro ON Seg.SegtoPrograID = Pro.SegtoPrograID
            INNER JOIN SEGTOCATEGORIAS Cat ON Pro.CategoriaID = Cat.CategoriaID
            INNER JOIN TIPOSDOCUMENTOS Tip ON Seg.TipoDocumentoID = Tip.TipoDocumentoID
            LEFT JOIN CREDITOS Cre ON Pro.CreditoID = Cre.CreditoID
            LEFT JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
            LEFT JOIN GRUPOSCREDITO Gru ON Pro.GrupoID = Gru.GrupoID
            INNER JOIN USUARIOS Res ON Pro.PuestoResponsableID = Res.UsuarioID
            INNER JOIN USUARIOS Sup ON Pro.PuestoSupervisorID = Sup.UsuarioID
            WHERE Seg.SegtoPrograID = Par_SegtoPrograID AND Seg.NumSecuencia = Par_NumSecuencia;
    END IF;

END TerminaStore$$