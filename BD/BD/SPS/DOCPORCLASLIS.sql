-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DOCPORCLASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DOCPORCLASLIS`;DELIMITER $$

CREATE PROCEDURE `DOCPORCLASLIS`(
-- ==========================================================
-- SP PARA LISTAR LOS TIPOS DE DOCUMENTOS
-- ==========================================================

    Par_ClasificaDocID  INT(11),        -- Parametro del ID del tipo de Documento
	Par_NumLis			INT(11),        -- Parametro num de lista

	Par_EmpresaID       INT(11),        -- Parametro de Auditoria
    Aud_Usuario         INT(11),        -- Parametro de Auditoria
    Aud_FechaActual     DATE,           -- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Parametro de Auditoria
    Aud_Sucursal        INT(11),        -- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)      -- Parametro de Auditoria

	)
TerminaStore:BEGIN
-- Declaracion constantes
DECLARE Lis_Principal		INT(11);

-- Asignacion de constantes
SET Lis_Principal			:=1;		-- Lista Principal

 IF( Par_NumLis = Lis_Principal) THEN
	SELECT  Clas.ClasificaTipDocID, Doc.TipoDocumentoID, Doc.Descripcion
		FROM	CLASIFICAGRPDOC Clas INNER JOIN TIPOSDOCUMENTOS Doc ON Clas.TipoDocumentoID = Doc.TipoDocumentoID
		WHERE   ClasificaTipDocID = Par_ClasificaDocID
		ORDER BY TipoDocumentoID ASC;
END IF;

END TerminaStore$$