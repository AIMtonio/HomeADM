-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODEVGLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITODEVGLCON`;DELIMITER $$

CREATE PROCEDURE `CREDITODEVGLCON`(

    Par_CreditoID       BIGINT(12),
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


DECLARE Con_Principal   INT;


SET Con_Principal   := 1;


IF(Par_NumCon = Con_Principal) THEN
    SELECT CreditoID, ClienteID, CuentaID, Monto, CajaID,
            SucursalID, Fecha
        FROM    CREDITODEVGL
        WHERE   CreditoID = Par_CreditoID ;
END IF;

END TerminaStore$$