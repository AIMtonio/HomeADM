-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCONDONACIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCONDONACIONLIS`;
DELIMITER $$

CREATE PROCEDURE `TIPOSCONDONACIONLIS`(
    -- SP PARA LISTAR LOS TIPOS DE CONDONACIONES
    Par_Descripcion                 VARCHAR(100),           -- DESCRIPCION
    Par_NumLis                      TINYINT UNSIGNED,       -- NUMERO DE LISTA

    Aud_EmpresaID                   INT(11),                -- AUDITORIA
    Aud_Usuario                     INT(11),                -- AUDITORIA
    Aud_FechaActual                 DATETIME,               -- AUDITORIA
    Aud_DireccionIP                 VARCHAR(15),            -- AUDITORIA
    Aud_ProgramaID                  VARCHAR(50),            -- AUDITORIA
    Aud_Sucursal                    INT(11),                -- AUDITORIA
    Aud_NumTransaccion              BIGINT(20)              -- AUDITORIA
)
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
    DECLARE Lis_Principal           INT(11);

    -- ASIGNACION DE CONSTANTES
    SET Lis_Principal               := 1;

	IF(Par_NumLis = Lis_Principal) THEN
        SELECT	T.TipoCondonacionID,    T.Descripcion,      T.Estatus
            FROM TIPOSCONDONACION T
        WHERE T.Estatus="A";

	END IF;


END TerminaStore$$