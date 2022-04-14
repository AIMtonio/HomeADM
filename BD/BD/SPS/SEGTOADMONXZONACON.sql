-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXZONACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONXZONACON`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONXZONACON`(
    Par_GestorID        INT(11),
    Par_TipoGestionID   INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT;
    DECLARE Con_ZonaGeo     INT(11);


    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET Con_ZonaGeo     := 3;

    IF(Par_NumCon = Con_ZonaGeo) THEN
      SELECT
            Seg.EstadoID, Est.Nombre,
           Seg.MunicipioID,
        CASE WHEN Seg.MunicipioID = Entero_Cero THEN
                CONCAT('TODOS')
        ELSE CASE WHEN Seg.MunicipioID != Entero_Cero THEN
                CONCAT(Mun.Nombre)
        END
        END AS NombreMunicipio,Seg.LocalidadID,
        CASE WHEN Seg.LocalidadID = Entero_Cero THEN
                CONCAT('TODOS')
        ELSE CASE WHEN Seg.LocalidadID != Entero_Cero THEN
                CONCAT(NombreLocalidad)
        END
        END AS NombreLocalidad,Seg.ColoniaID,
        CASE WHEN Seg.ColoniaID = Entero_Cero THEN
                CONCAT('TODOS')
        ELSE CASE WHEN Seg.ColoniaID != Entero_Cero THEN
            CONCAT(TipoAsenta," ", Asentamiento)
        END
        END AS NombreColonia
        FROM SEGTOADMONXZONA Seg
            INNER JOIN ESTADOSREPUB AS Est
                ON Seg.EstadoID = Est.EstadoID
            LEFT JOIN MUNICIPIOSREPUB Mun
                ON Seg.MunicipioID = Mun.MunicipioID AND Mun.EstadoID=Est.EstadoID
            LEFT JOIN LOCALIDADREPUB AS Loc
                ON Mun.MunicipioID = Loc.MunicipioID  AND Loc.EstadoID=Est.EstadoID AND Seg.LocalidadID=Loc.LocalidadID
            LEFT JOIN COLONIASREPUB AS Col
                ON Mun.MunicipioID = Col.MunicipioID  AND Col.EstadoID=Est.EstadoID AND Seg.ColoniaID=Col.ColoniaID
            WHERE GestorID = Par_GestorID
                AND TipoGestionID = Par_TipoGestionID;
    END IF;

END TerminaStore$$