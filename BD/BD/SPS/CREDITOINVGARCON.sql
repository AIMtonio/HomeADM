-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINVGARCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOINVGARCON`;DELIMITER $$

CREATE PROCEDURE `CREDITOINVGARCON`(
    Par_CreditoID           BIGINT(12),
    Par_InversionID         INT(11),
    Par_NumCon              TINYINT UNSIGNED,
    Par_EmpresaID           INT(11),
    Par_Usuario             INT(11),

    Par_FechaActual         DATE,
    Par_DireccionIP         VARCHAR(15),
    Par_ProgramaID          VARCHAR(50),
    Par_Sucursal            INT(11),
    Par_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Con_Principal   INT;
DECLARE Con_GarCred     INT;
DECLARE Con_GarInv      INT;
DECLARE Con_Cred        INT;
DECLARE Con_Inv         INT;
DECLARE Con_CredEstatus INT;


DECLARE Var_Creditos        VARCHAR(8000);
DECLARE Var_CreditoInvGarID BIGINT(12);


SET Decimal_Cero        := 0.0;
SET Con_Principal       := 1;
SET Con_GarCred         := 2;
SET Con_GarInv          := 3;
SET Con_Cred            := 4;
SET Con_Inv             := 5;
SET Con_CredEstatus     := 6;


IF(Par_NumCon = Con_GarCred)    THEN
    SELECT IFNULL(SUM(MontoEnGar),Decimal_Cero) AS TotalCred
        FROM CREDITOINVGAR
        WHERE CreditoID = Par_CreditoID;
END IF;


IF(Par_NumCon = Con_GarInv) THEN
    SELECT IFNULL(SUM(MontoEnGar),Decimal_Cero) AS TotalInv
        FROM CREDITOINVGAR
        WHERE InversionID = Par_InversionID;
END IF;


IF(Par_NumCon = Con_Cred)   THEN
    SELECT IFNULL(MAX(CreditoInvGarID),0) AS CreditoInvGarID
        FROM CREDITOINVGAR
        WHERE CreditoID = Par_CreditoID;
END IF;


IF(Par_NumCon = Con_Inv)    THEN
    SET @varCreditos = "";
    SELECT  MAX(CreditoInvGarID) AS CreditoInvGarID,    @varCreditos := CONCAT(CreditoID,', ',@varCreditos)
     INTO   Var_CreditoInvGarID,                        Var_Creditos
            FROM CREDITOINVGAR
            WHERE InversionID = Par_InversionID
        GROUP BY CreditoID ORDER BY CreditoInvGarID DESC
        LIMIT 1;
    IF(Var_CreditoInvGarID > 0)THEN
        SET Var_Creditos    :=  CONCAT(SUBSTRING(@varCreditos,1,LENGTH(@varCreditos)-2),'.');
    END IF;

    SELECT  Var_CreditoInvGarID AS CreditoInvGarID,         Var_Creditos AS CreditosRelacionados;
END IF;


IF(Par_NumCon = Con_CredEstatus)    THEN
    SELECT CreditoID, Estatus,  EstCreAltInvGar
        FROM    CREDITOS,
                PARAMETROSSIS
        WHERE   (SELECT EstCreAltInvGar FROM PARAMETROSSIS) LIKE  CONCAT("%",Estatus ,"%")
         AND    CreditoID = Par_CreditoID;
END IF;

END TerminaStore$$