-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOARCHIVOSLIS`;DELIMITER $$

CREATE PROCEDURE `CREDITOARCHIVOSLIS`(
    Par_CreditoID       BIGINT(12),
    Par_TipoDocumento   INT(11),
    Par_Comentario      VARCHAR(200),
    Par_Recurso         VARCHAR(200),
    Par_Fecha           DATE,

    Par_NumLis          TINYINT UNSIGNED,
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE     Cadena_Vacia    CHAR(1);
DECLARE     Fecha_Vacia     DATE;
DECLARE     Entero_Cero     INT;
DECLARE     PrincipalCredLis    INT;
DECLARE     LisPorTipoDoc       INT;




SET     Cadena_Vacia        := '';
SET     Fecha_Vacia         := '1900-01-01';
SET     Entero_Cero         := 0;
SET     PrincipalCredLis    := 1;
SET     LisPorTipoDoc       := 2;



IF(Par_NumLis = PrincipalCredLis) THEN
    SELECT  Arch.DigCreaID,  Arch.CreditoID,        Arch.TipoDocumentoID,   Doc.Descripcion,    Arch.Comentario,
            Arch.Recurso
    FROM CREDITOARCHIVOS Arch,
         TIPOSDOCUMENTOS Doc
    WHERE Arch.CreditoID        = Par_CreditoID
      AND Arch.TipoDocumentoID  = Doc.TipoDocumentoID
    ORDER BY Arch.TipoDocumentoID ASC, Arch.DigCreaID DESC;

END IF;



IF(Par_NumLis = LisPorTipoDoc) THEN
    SELECT  Arch.DigCreaID,  Arch.CreditoID,        Arch.TipoDocumentoID,   Doc.Descripcion,    Arch.Comentario,
            Arch.Recurso
    FROM CREDITOARCHIVOS Arch,
         TIPOSDOCUMENTOS Doc
    WHERE Arch.CreditoID        = Par_CreditoID
      AND Arch.TipoDocumentoID  = Par_TipoDocumento
      AND Arch.TipoDocumentoID  = Doc.TipoDocumentoID
    ORDER BY  Arch.DigCreaID DESC;

END IF;

END TerminaStore$$