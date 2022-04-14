-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONMONTOGARLIQ
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONMONTOGARLIQ`;DELIMITER $$

CREATE FUNCTION `FUNCIONMONTOGARLIQ`(
    Par_CreditoID   BIGINT(12)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN


DECLARE Mon_Inversion   DECIMAL(14,2);
DECLARE montoGarLiq     DECIMAL(14,2);


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE Est_Bloq        CHAR(1);
DECLARE tipMovGL        INT;


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Est_Bloq        := 'B';
SET tipMovGL        := 8;


SET montoGarLiq := Entero_Cero;
SET Mon_Inversion := Entero_Cero;


SET montoGarLiq := IFNULL((SELECT SUM(MontoBloq)
                            FROM    BLOQUEOS
                            WHERE   TiposBloqID = tipMovGL
                            AND Referencia  = Par_CreditoID
                            AND NatMovimiento = Est_Bloq
                            AND IFNULL(FolioBloq,Entero_Cero) = Entero_Cero),Decimal_Cero);

SET montoGarLiq := IFNULL(montoGarLiq, Entero_Cero);


SELECT SUM(Inc.MontoEnGar) INTO Mon_Inversion
    FROM CREDITOINVGAR Inc,
         INVERSIONES Inv
    WHERE Inc.CreditoID = Par_CreditoID
      AND Inc.InversionID = Inv.InversionID;

SET Mon_Inversion := IFNULL(Mon_Inversion, Entero_Cero);

SET montoGarLiq := montoGarLiq + Mon_Inversion;

RETURN montoGarLiq;
END$$