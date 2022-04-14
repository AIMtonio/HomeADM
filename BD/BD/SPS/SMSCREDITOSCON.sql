-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCREDITOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCREDITOSCON`;DELIMITER $$

CREATE PROCEDURE `SMSCREDITOSCON`(
    Par_CreditoID       BIGINT(12),
    Par_Telefono        VARCHAR(20),
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


DECLARE Con_TelCelular          INT;


SET Con_TelCelular  := 1;

IF(Par_NumCon = Con_TelCelular)THEN
    SELECT Cre.CreditoID,Cli.TelefonoCelular
        FROM CLIENTES Cli
        INNER JOIN CREDITOS Cre
            ON Cli.ClienteID = Cre.ClienteID
        WHERE CreditoID = Par_CreditoID
            AND TelefonoCelular = Par_Telefono;
END IF;

END TerminaStore$$