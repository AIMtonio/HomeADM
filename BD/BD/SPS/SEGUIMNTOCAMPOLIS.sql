-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMNTOCAMPOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMNTOCAMPOLIS`;DELIMITER $$

CREATE PROCEDURE `SEGUIMNTOCAMPOLIS`(
    Par_Seguimiento     VARCHAR(100),
    Par_CategoriaID     INT(11),
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


    DECLARE Lis_Principal       INT(11);
    DECLARE Lis_Foranea         INT(11);
    DECLARE Lis_GestorCategoria INT(11);
    DECLARE Lis_SupervGestor    INT(11);


    SET Lis_Principal       := 1;
    SET Lis_Foranea         := 2;
    SET Lis_GestorCategoria := 3;


    IF(Par_NumLis = Lis_Foranea) THEN
        SELECT  SeguimientoID, DescripcionSegto
        FROM SEGUIMIENTOCAMPO
        WHERE DescripcionSegto LIKE CONCAT("%", Par_Seguimiento, "%")
        LIMIT 0, 15;
    END IF;

    IF (Par_NumLis = Lis_GestorCategoria) THEN
        SELECT Usu.UsuarioID, Usu.NombreCompleto
        FROM SEGTOCATEGORIAS Cat
            INNER JOIN TIPOGESTION Tip ON Tip.TipoGestionID = Cat.TipoGestionID
            INNER JOIN SEGTOADMONGESTOR Adm ON Adm.TipoGestionID = Cat.TipoGestionID
            INNER JOIN USUARIOS Usu ON Adm.GestorID = Usu.UsuarioID
        WHERE Usu.NombreCompleto LIKE CONCAT("%", Par_Seguimiento, "%")
            AND Cat.CategoriaID = Par_CategoriaID
        LIMIT 0, 15;
    END IF;

END TerminaStore$$