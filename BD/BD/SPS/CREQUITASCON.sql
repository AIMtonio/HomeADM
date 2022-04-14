-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREQUITASCON`;DELIMITER $$

CREATE PROCEDURE `CREQUITASCON`(
    Par_CreditoID       BIGINT(12),
    Par_UsuarioID       INT(11),
    Par_PuestoID        VARCHAR(10),
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
DECLARE Con_Principal   INT;
DECLARE Con_NoQuiXCre   INT;


SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET Con_Principal       := 1;
SET Con_NoQuiXCre       := 2;



IF(Par_NumCon = Con_Principal) THEN
    SELECT  CreditoID,          Consecutivo,        UsuarioID,          PuestoID,           FechaRegistro,
            MontoComisiones,    PorceComisiones,    MontoMoratorios,    PorceMoratorios,    MontoInteres,
            PorceInteres,       MontoCapital,       PorceCapital,       SaldoCapital,       SaldoInteres,
            SaldoMoratorios,    SaldoAccesorios
        FROM CREQUITAS
        WHERE   CreditoID   = Par_CreditoID
         AND    UsuarioID   = Par_UsuarioID
         AND    PuestoID    = Par_PuestoID;
END IF;


IF(Par_NumCon = Con_NoQuiXCre) THEN
    SELECT IFNULL(COUNT(CreditoID),Entero_Cero) AS NumQuitas
        FROM CREQUITAS
        WHERE CreditoID = Par_CreditoID;
END IF;



END TerminaStore$$