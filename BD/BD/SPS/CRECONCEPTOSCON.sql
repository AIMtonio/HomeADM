-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONCEPTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONCEPTOSCON`;
DELIMITER $$


CREATE PROCEDURE `CRECONCEPTOSCON`(

    Par_CreditoID       BIGINT(12),
    INOUT MontoExigible DECIMAL(14,2),
    INOUT InteresOrd    DECIMAL(14,2),
    INOUT IvaIntNor     DECIMAL(14,2),
    INOUT InteresMor    DECIMAL(14,2),
    INOUT IvaIntMor     DECIMAL(14,2),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
        )

TerminaStore: BEGIN

DECLARE Var_MontoExigible   DECIMAL(14,2);
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

SET Var_MontoExigible   := Decimal_Cero;

SELECT FechaSistema INTO Var_FecActual
    FROM PARAMETROSSIS;


SELECT  Cli.PagaIVA,        Suc.IVA,        Pro.CobraIVAInteres,    Cre.Estatus,
        Pro.CobraIVAMora
INTO    Var_CliPagIVA,      Var_IVASucurs,  Var_IVAIntOrd,          Var_CreEstatus,
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

    SELECT  ROUND(IFNULL(SUM(   ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                                ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                        SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) +

                                ROUND(ROUND(SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) *
                                        Var_ValIVAIntOr, 2) +

                          ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
                          ROUND(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2)
                         ),
                       Entero_Cero)
                , 2) AS MontoExigible,


                ROUND(IFNULL(
                        SUM(ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                      SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2)),
                            Entero_Cero), 2) AS InteresOrd,
                ROUND(IFNULL(
                        SUM(ROUND(ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                      SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) * Var_ValIVAIntOr, 2) ),
                            Entero_Cero), 2) AS IvaIntNor,


                ROUND(IFNULL(
                        SUM(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2)),
                            Entero_Cero), 2) AS IvaIntMor,
                ROUND(IFNULL(
                        SUM( ROUND(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2)),
                            Entero_Cero), 2) AS InteresMor
            INTO    MontoExigible,
                    InteresOrd,
                    IvaIntNor,
                    InteresMor,
                    IvaIntMor
            FROM AMORTICREDITO
            WHERE FechaExigible <= Var_FecActual
              AND Estatus       <> EstatusPagado
              AND CreditoID     =  Par_CreditoID;

END IF;

END TerminaStore$$