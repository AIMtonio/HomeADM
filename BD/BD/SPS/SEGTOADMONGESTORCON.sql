-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONGESTORCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONGESTORCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONGESTORCON`(
    Par_GestorID        INT(11),
    Par_TipoGestionID   INT(11),
    Par_SupervisorID    INT(11),
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
    DECLARE Con_Principal   INT(11);


    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET Con_Principal   := 1;

    IF(Par_NumCon = Con_Principal) THEN
        SELECT
            Seg.GestorID,  Usu.NombreCompleto, Seg.TipoGestionID,
            Tip.Descripcion, Seg.SupervisorID, Usu.NombreCompleto, Seg.Ambito
        FROM SEGTOADMONGESTOR AS Seg
            INNER JOIN USUARIOS AS Usu
                ON Seg.GestorID = Usu.UsuarioID
            INNER JOIN TIPOGESTION AS Tip
                ON Seg.TipoGestionID=Tip.TipoGestionID
            WHERE Seg.GestorID = Par_GestorID
                AND Seg.TipoGestionID = Par_TipoGestionID
                AND Seg.SupervisorID = Par_SupervisorID;
    END IF;

END TerminaStore$$