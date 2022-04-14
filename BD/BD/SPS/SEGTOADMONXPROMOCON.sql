-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXPROMOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONXPROMOCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONXPROMOCON`(
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
    DECLARE Con_Promotor    INT(11);


    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET Con_Promotor    := 4;

    IF(Par_NumCon = Con_Promotor) THEN
        SELECT
            Seg.PromotorID,  Prom.NombrePromotor
        FROM SEGTOADMONXPROMOTOR AS Seg
            INNER JOIN  PROMOTORES AS Prom
                ON Seg.PromotorID = Prom.PromotorID
            WHERE Seg.GestorID = Par_GestorID
                AND Seg.TipoGestionID = Par_TipoGestionID;
    END IF;

END TerminaStore$$