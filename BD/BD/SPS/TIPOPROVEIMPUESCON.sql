-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPROVEIMPUESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPROVEIMPUESCON`;DELIMITER $$

CREATE PROCEDURE `TIPOPROVEIMPUESCON`(

    Par_TipoProveedorID INT(11),
    Par_ImpuestoID      INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(20),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
        )
TerminaStore: BEGIN


DECLARE     Con_Principal   INT;


SET Con_Principal   := 1;



IF(Par_NumCon = Con_Principal) THEN
    SELECT  TipoProveedorID, ImpuestoID, Orden
    FROM    TIPOPROVEIMPUES
    WHERE   TipoProveedorID = Par_TipoProveedorID
    AND     ImpuestoID = Par_ImpuestoID;

END IF;

END TerminaStore$$