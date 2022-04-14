
DELIMITER ;
DROP function IF EXISTS `FUNCIONEXIGIBLEACT`;

DELIMITER $$
CREATE FUNCTION `FUNCIONEXIGIBLEACT`(
    Par_CreditoID   BIGINT(12)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

# Declaracion de variables
DECLARE Var_MontoExigible DECIMAL(14,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);

DECLARE Var_IVAIntOrd   CHAR(1);
DECLARE Var_IVAIntMor   CHAR(1);
DECLARE Var_ValIVAIntOr DECIMAL(12,2);
DECLARE Var_ValIVAIntMo DECIMAL(12,2);
DECLARE Var_ValIVAGen   DECIMAL(12,2);

DECLARE Var_LineaCreditoID  DECIMAL(14,2);
DECLARE Var_CobraComAnual CHAR(1);
DECLARE Var_SaldoComAnual   DECIMAL(14,2);
DECLARE Var_MontoComAnual   DECIMAL(14,2);

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE EstatusPagado   CHAR(1);
DECLARE SiPagaIVA       CHAR(1);

DECLARE Var_cliEsp        INT(11);
DECLARE Var_CliSFG        INT(11);
DECLARE Var_CliConfiadora INT(11);

SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET EstatusPagado   := 'P';
SET SiPagaIVA       := 'S';

SET Var_MontoExigible   := Decimal_Cero;
SET Var_CliSFG          := 29;
SET Var_CliConfiadora   := 46;
SET Var_CliEsp :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');

SELECT FechaSistema INTO Var_FecActual
  FROM PARAMETROSSIS;


SELECT  Cli.PagaIVA,            Suc.IVA,            Pro.CobraIVAInteres, Cre.Estatus,
        Pro.CobraIVAMora,   LineaCreditoID
        INTO Var_CliPagIVA, Var_IVASucurs,    Var_IVAIntOrd, Var_CreEstatus,
             Var_IVAIntMor,   Var_LineaCreditoID
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

    IF( IFNULL(Var_LineaCreditoID,Entero_Cero)>Entero_Cero )THEN
    SELECT CobraComAnual, SaldoComAnual
      INTO Var_CobraComAnual, Var_SaldoComAnual
        FROM LINEASCREDITO
        WHERE LineaCreditoID=Var_LineaCreditoID;

        IF(IFNULL(Var_CobraComAnual,Cadena_Vacia)='S' AND IFNULL(Var_SaldoComAnual,Entero_Cero)>Entero_Cero)THEN
      SET Var_MontoComAnual := Var_SaldoComAnual + IF(Var_CliPagIVA=SiPagaIVA,ROUND(Var_SaldoComAnual*Var_ValIVAGen,2),0);
        END IF;
    END IF;

    SET Var_MontoComAnual := IFNULL(Var_MontoComAnual,Entero_Cero);

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
                ROUND(SaldoOtrasComis,2) +

              CASE WHEN (Var_CliEsp = Var_CliSFG OR Var_CliEsp = Var_CliConfiadora) THEN
                IFNULL((ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2)),Decimal_Cero)
              ELSE
                ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2)
              END
      + ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
              ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2)+
                ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
                ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2) +
                                ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                                ROUND(SaldoComisionAnual,2) + ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2)),
                       Entero_Cero)
                , 2)
            INTO Var_MontoExigible

            FROM AMORTICREDITO
            WHERE FechaInicio   <= Var_FecActual
              AND Estatus       in ('V','A','B')
              AND CreditoID     =  Par_CreditoID;

    SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero) + Var_MontoComAnual;

END IF;

RETURN Var_MontoExigible;

END$$

DELIMITER ;

