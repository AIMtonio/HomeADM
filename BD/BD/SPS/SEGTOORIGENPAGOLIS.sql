-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOORIGENPAGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOORIGENPAGOLIS`;DELIMITER $$

CREATE PROCEDURE `SEGTOORIGENPAGOLIS`(
    Par_OrigenPago      VARCHAR(100),
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

    DECLARE     Lis_Principal   INT;
    DECLARE     Lis_Foranea     INT;
    DECLARE     Lis_Combo       INT;
    DECLARE     EstatusVigente CHAR(1);


    SET Lis_Principal   := 1;
    SET Lis_Foranea     := 2;
    SET Lis_Combo       := 3;
    SET  EstatusVigente  := 'V';

    IF(Par_NumLis = Lis_Combo) THEN
        SELECT OrigenPagoID, Descripcion
        FROM SEGTOORIGENPAGO
        WHERE Estatus = EstatusVigente;
    END IF;

END TerminaStore$$