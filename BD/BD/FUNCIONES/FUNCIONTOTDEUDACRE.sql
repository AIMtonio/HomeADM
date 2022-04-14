-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONTOTDEUDACRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONTOTDEUDACRE`;

DELIMITER $$
CREATE FUNCTION `FUNCIONTOTDEUDACRE`(
    Par_CreditoID   BIGINT(12)


) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

-- Declaracion de variables
DECLARE Var_MontoDeuda      DECIMAL(14,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);

DECLARE Var_IVAIntOrd   	CHAR(1);
DECLARE Var_IVAIntMor   	CHAR(1);
DECLARE Var_ValIVAIntOr 	DECIMAL(12,2);
DECLARE Var_ValIVAIntMo 	DECIMAL(12,2);
DECLARE Var_ValIVAGen   	DECIMAL(12,2);
DECLARE Var_IVANotaCargo	DECIMAL(14,2);		-- Variable para el porcentaje que se cobra por nota de cargo

-- Declaracion de constantes
DECLARE Cadena_Vacia      CHAR(1);
DECLARE Fecha_Vacia       DATE;
DECLARE Entero_Cero       INT;
DECLARE Decimal_Cero      DECIMAL(14,2);
DECLARE EstatusPagado     CHAR(1);
DECLARE SiPagaIVA         CHAR(1);
DECLARE Var_CliConfiadora INT(11);
DECLARE Var_CliATE		  INT(11);

DECLARE Var_cliEsp      INT(11);
DECLARE Var_CliSFG      INT(11);

DECLARE Var_TipoCalInteres  INT(11);
DECLARE Int_SalInsol    INT(11);
DECLARE Int_SalGlobal   INT(11);

-- Asignacion de constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET EstatusPagado   := 'P';
SET SiPagaIVA       := 'S';
SET Var_CliSFG      := 29;
SET Var_CliConfiadora   := 46;
SET Var_CliATE			:= 49;
SET Var_CliEsp :=(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');

SET Int_SalInsol        := 1;
SET Int_SalGlobal       := 2;

-- Inicializacion de valores
SET Var_MontoDeuda   := Decimal_Cero;

-- Se obtiene la fecha del sistema
SELECT FechaSistema INTO Var_FecActual
  FROM PARAMETROSSIS;

-- Se obtiene los datos necesarios del credito
SELECT  Cli.PagaIVA,            Suc.IVA,              Pro.CobraIVAInteres,    Cre.Estatus,
        Pro.CobraIVAInteres,    Pro.CobraIVAMora,     Cre.TipoCalInteres
INTO    Var_CliPagIVA,          Var_IVASucurs,        Var_IVAIntOrd,          Var_CreEstatus,
        Var_IVAIntOrd,          Var_IVAIntMor,        Var_TipoCalInteres
    FROM CREDITOS   Cre,
         CLIENTES   Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
    WHERE   Cre.CreditoID           = Par_CreditoID
      AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
      AND   Cre.ClienteID           = Cli.ClienteID
      AND   Cre.SucursalID          = Suc.SucursalID;

SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, Cadena_Vacia);
SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
 SET Var_TipoCalInteres := IFNULL(Var_TipoCalInteres, Int_SalInsol);-- RLAVIDA T_12448

SET Var_CreEstatus = IFNULL(Var_CreEstatus, Cadena_Vacia);

SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;
SET Var_IVANotaCargo := Entero_Cero;

IF(Var_CreEstatus != Cadena_Vacia) THEN

	SET Var_IVANotaCargo := Var_IVASucurs;

    IF (Var_CliPagIVA = SiPagaIVA) THEN

        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAIntOrd = SiPagaIVA) THEN
            SET Var_ValIVAIntOr  := Var_IVASucurs;
        END IF;

        IF (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;

    END IF;


    SELECT   ROUND( IFNULL(
                    SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                        ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                          ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta,2) +

                -- Se calcula el IVA de Interes como lo realiza el SP CALCIVAINTERESPROVCON el cual se ejecuat en la consulta no. 17 del CREDITOSCON
                CASE Var_TipoCalInteres
                      WHEN Int_SalInsol THEN
                          ROUND(ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) + ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
                          ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) + ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2)
                      WHEN Int_SalGlobal THEN
                          ROUND(
                              IF((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2)) = Interes, IVAInteres,
                                ((ROUND(SaldoInteresPro,2)+ROUND(SaldoInteresAtr,2)+ROUND(SaldoInteresVen,2)+ROUND(SaldoIntNoConta,2)) * Var_ValIVAIntOr)), 2)
                END + /* ========== FIN AJUSTE RLAVIDA =========== */
                ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
                ROUND(SaldoOtrasComis,2) +

                CASE WHEN (Var_CliEsp = Var_CliSFG OR Var_CliEsp = Var_CliConfiadora OR Var_cliEsp = Var_CliATE) THEN
                  IFNULL(ROUND(FNEXIGIBLEIVAACCESORIOS(Par_CreditoID, AmortizacionID,Var_ValIVAGen, Var_CliPagIVA),2),Entero_Cero)
                ELSE
                  ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2)
                END +
                ROUND(SaldoIntOtrasComis, 2) +
                CASE WHEN (Var_cliEsp = Var_CliATE) THEN
                  IFNULL(ROUND(FNEXIGIBLEIVAINTERESACCESORIOS(Par_CreditoID, AmortizacionID, Var_ValIVAGen, Var_CliPagIVA), 2), Entero_Cero)
                ELSE
                  Entero_Cero
                END
                + ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
              ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
                ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
                ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2), 2) +
                ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2) +
                ROUND(SaldoComisionAnual,2) + ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2) +

				ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) +
				ROUND(SaldoNotCargoConIVA,2) + ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2)),
                       Entero_Cero)
                , 2)
            INTO Var_MontoDeuda
            FROM AMORTICREDITO
            WHERE CreditoID     =  Par_CreditoID
              AND Estatus       <> EstatusPagado;


    SET Var_MontoDeuda = IFNULL(Var_MontoDeuda, Decimal_Cero);

END IF;

RETURN Var_MontoDeuda;

END$$