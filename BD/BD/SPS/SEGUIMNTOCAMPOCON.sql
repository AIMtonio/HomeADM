-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMNTOCAMPOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMNTOCAMPOCON`;DELIMITER $$

CREATE PROCEDURE `SEGUIMNTOCAMPOCON`(
    Par_SeguimientoID   INT(11),
    Par_CategoriaID     INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
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
    DECLARE Con_Principal       INT(11);
    DECLARE Con_Foranea         INT(11);
    DECLARE Con_GestorCategoria INT(11);
    DECLARE Con_SupervGestor    INT(11);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Con_Principal       := 1;
    SET Con_Foranea         := 2;
    SET Con_GestorCategoria := 10;
    SET Con_SupervGestor    := 11;


    IF(Par_NumCon = Con_Principal) THEN
        SELECT
            SeguimientoID,          DescripcionSegto,       CategoriaSegtoID,       CicloInicioCte,
            CicloFinCte,            EjecutorID,             NivelAplicaVentas,      AplicaCarteraVigente,
            AplicaCarteraAtrasada,  AplicaCarteraVencida,   CarteraNoAplica,        PermiteManual,
            BaseGeneracion,         ValorBase,              Alcance,                RecPropios,
            Estatus
        FROM SEGUIMIENTOCAMPO
        WHERE SeguimientoID = Par_SeguimientoID;
    END IF;

    IF (Par_NumCon = Con_GestorCategoria) THEN
        SELECT Usu.UsuarioID, Usu.NombreCompleto
            FROM SEGTOCATEGORIAS Cat
            INNER JOIN TIPOGESTION Tip ON Tip.TipoGestionID = Cat.TipoGestionID
            INNER JOIN SEGTOADMONGESTOR Adm ON Adm.TipoGestionID = Cat.TipoGestionID
            INNER JOIN USUARIOS Usu ON Adm.GestorID = Usu.UsuarioID
            WHERE Cat.CategoriaID = Par_CategoriaID AND Usu.UsuarioID = Par_SeguimientoID;
    END IF;

    IF (Par_NumCon = Con_SupervGestor) THEN
        SELECT Usu.UsuarioID, Usu.NombreCompleto
            FROM SEGTOCATEGORIAS Cat
            INNER JOIN SEGTOADMONGESTOR Adm ON Adm.TipoGestionID = Cat.TipoGestionID
            INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Adm.SupervisorID
            WHERE Cat.CategoriaID = Par_CategoriaID
                AND Adm.GestorID = Par_SeguimientoID;
    END IF;
END TerminaStore$$