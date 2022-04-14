-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNTOTALADEUDO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNTOTALADEUDO`;
DELIMITER $$


CREATE FUNCTION `FNTOTALADEUDO`(
    Par_CreditoID   BIGINT(12)


) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN


DECLARE Var_TotAdeudo       DECIMAL(16,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);

DECLARE Var_IVAIntOrd       CHAR(1);
DECLARE Var_IVAIntMor       CHAR(1);
DECLARE Var_ValIVAIntOr     DECIMAL(12,2);
DECLARE Var_ValIVAIntMo     DECIMAL(12,2);
DECLARE Var_ValIVAGen       DECIMAL(12,2);



DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE EstatusPagado   CHAR(1);
DECLARE SiPagaIVA       CHAR(1);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET EstatusPagado   := 'P';
SET SiPagaIVA       := 'S';

SET Var_TotAdeudo   := Decimal_Cero;

SELECT FechaSistema INTO Var_FecActual
    FROM PARAMETROSSIS;


SELECT  Cli.PagaIVA,            Suc.IVA,            Pro.CobraIVAInteres, Cre.Estatus,
        Pro.CobraIVAMora
        INTO Var_CliPagIVA, Var_IVASucurs,    Var_IVAIntOrd, Var_CreEstatus,
             Var_IVAIntMor
    FROM CREDITOS   Cre,
         CLIENTES   Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
    WHERE   Cre.CreditoID           = Par_CreditoID
      AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
      AND   Cre.ClienteID           = Cli.ClienteID
      AND   Cre.SucursalID          = Suc.SucursalID;

SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

SET Var_CreEstatus = IFNULL(Var_CreEstatus, Cadena_Vacia);

SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;

IF(Var_CreEstatus != Cadena_Vacia) THEN


    IF (Var_CliPagIVA = SiPagaIVA) THEN

        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAIntOrd = SiPagaIVA) THEN
            SET Var_ValIVAIntOr  := Var_IVASucurs;
        END IF;

        IF (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;

    END IF;


SELECT  ROUND(IFNULL(SaldoCapVigent,  Entero_Cero), 2) +
              ROUND(IFNULL(SaldoCapAtrasad, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoCapVencido, Entero_Cero), 2) +
              ROUND(IFNULL(SaldCapVenNoExi, Entero_Cero), 2) +

              ROUND(IFNULL(SaldoInterOrdin, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoInterAtras, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoInterVenc, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoInterProvi, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoIntNoConta, Entero_Cero), 2) +

              ROUND(IFNULL(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, Entero_Cero), 2) +
              ROUND(IFNULL(SaldComFaltPago, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoComServGar, Entero_Cero), 2) +
              ROUND(IFNULL(SaldoOtrasComis, Entero_Cero), 2) +

              ROUND( (ROUND(IFNULL(SaldoInterOrdin, Entero_Cero), 2) +
                      ROUND(IFNULL(SaldoInterAtras, Entero_Cero), 2) +
                      ROUND(IFNULL(SaldoInterVenc, Entero_Cero), 2) +
                      ROUND(IFNULL(SaldoInterProvi, Entero_Cero), 2) +
                      ROUND(IFNULL(SaldoIntNoConta, Entero_Cero), 2)) * Var_ValIVAIntOr, 2) +

              ROUND(ROUND(IFNULL(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, Entero_Cero), 2) * Var_ValIVAIntMo, 2) +

              ROUND( (ROUND(IFNULL(SaldComFaltPago, Entero_Cero), 2) +
                      ROUND(IFNULL(SaldoComServGar, Entero_Cero), 2) +
                      ROUND(IFNULL(SaldoOtrasComis, Entero_Cero), 2)) * Var_ValIVAGen, 2) INTO

             Var_TotAdeudo

                FROM CREDITOS
                WHERE CreditoID = Par_CreditoID;



    SET Var_TotAdeudo = IFNULL(Var_TotAdeudo, Decimal_Cero);

END IF;

RETURN Var_TotAdeudo;

END$$