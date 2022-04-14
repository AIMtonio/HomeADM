-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANFNEXIGIBLEALDIA
DELIMITER ;
DROP FUNCTION IF EXISTS `BANFNEXIGIBLEALDIA`;
DELIMITER $$


CREATE FUNCTION `BANFNEXIGIBLEALDIA`(
	-- Funcion que realiza el calculo del monto exigible de un credito al inicio del dia
    Par_CreditoID   BIGINT(12) -- ID del credito
) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN

-- Declaracion de variables
DECLARE Var_MontoExigible DECIMAL(14,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);
DECLARE Var_MontoPagado 	DECIMAL(14,2);

DECLARE Var_IVAIntOrd   CHAR(1);
DECLARE Var_IVAIntMor   CHAR(1);
DECLARE Var_ValIVAIntOr DECIMAL(12,2);
DECLARE Var_ValIVAIntMo DECIMAL(12,2);
DECLARE Var_ValIVAGen   DECIMAL(12,2);

-- Declaracion de constantes
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

SET Var_MontoExigible   := Decimal_Cero;

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

	-- Consultamos el IVA del Cliente
    IF (Var_CliPagIVA = SiPagaIVA) THEN
        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAIntOrd = SiPagaIVA) THEN
            SET Var_ValIVAIntOr  := Var_IVASucurs;
        END IF;

        IF (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;
    END IF;

	-- Calculamos el monto exigible sin pagar
    SELECT  ROUND(IFNULL(
                    SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                        ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                          ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) +

                          ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
                ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
                ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
                ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
                ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2),2)+

                          ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
              ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2)+
                ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
                ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2) +
                                ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                                ROUND(SaldoComisionAnual,2) + ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2)),
                       Entero_Cero)
                , 2)
            INTO Var_MontoExigible
            FROM AMORTICREDITO
            WHERE FechaExigible <= Var_FecActual
              AND Estatus       <> EstatusPagado
              AND CreditoID     =  Par_CreditoID;

	-- Calculamos el monto exigible ya pagado pero que fue exigible el dia actual
    SELECT SUM(MontoTotPago)
        INTO Var_MontoPagado
        FROM DETALLEPAGCRE PAG
        INNER JOIN AMORTICREDITO AMO ON AMO.CreditoID = PAG.CreditoID AND PAG.AmortizacionID = AMO.AmortizacionID
        WHERE PAG.CreditoID = Par_CreditoID
        AND PAG.FechaPago = Var_FecActual
        AND AMO.FechaExigible <= Var_FecActual;

	-- Devolvemos la totalidad del monto exigible y el monto ya pagado del dia
    SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero) + IFNULL(Var_MontoPagado, Decimal_Cero);
END IF;

RETURN Var_MontoExigible;

END$$
