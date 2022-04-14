-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXSUCURSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONXSUCURSCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONXSUCURSCON`(
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
DECLARE Con_Sucursal    INT(11);


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Con_Sucursal    := 2;

IF(Par_NumCon = Con_Sucursal) THEN
    SELECT
        Seg.SucursalID,  Suc.NombreSucurs
    FROM SEGTOADMONXSUCURSAL AS Seg
        INNER JOIN  SUCURSALES AS Suc
            ON Seg.SucursalID = Suc.SucursalID
        WHERE GestorID = Par_GestorID
            AND TipoGestionID = Par_TipoGestionID;
END IF;

END TerminaStore$$