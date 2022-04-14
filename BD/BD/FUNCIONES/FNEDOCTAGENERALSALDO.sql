-- FNEDOCTAGENERALSALDO

DELIMITER ;

DROP FUNCTION IF EXISTS `FNEDOCTAGENERALSALDO`;

DELIMITER $$

CREATE  FUNCTION `FNEDOCTAGENERALSALDO`(
    Par_CreditoID   BIGINT(12),
    Par_TipoSaldo   INT(11)
) RETURNS DECIMAL(16,2)
    DETERMINISTIC
BEGIN

/*
  FUNCION ESPECIAL PARA CALCULO DE SALDOS QUE SE REQUIEREN EN ESTADO DE CUENTA
  >>>> El parametro tipo de Saldo nos indica que queremos regresar  <<<<<
    1 .- Para Saldo Total de Capital
    2 .- Para saldo de Capital Exigible (Atrasado y Vencido)
    3 .- Para Saldo de Interes Ordinario Exigible (Atrasado y Vencido)
    4 .- Para Interes Moratorio
    5 .- Total de Capital para proximo pago
    6 .- Total de Interes Ordinario para Proximo Pago
    7 .- Total de IVA de Interes Ordinario para Proximo Pago
    8 .- Total de Interes Moratorio para Proximo Pago
    9 .- Total de IVA de Interes Moratorio para Proximo Pago
    10 .- Iva de Interes Exigible
    11 .- Iva de Otros Cargos
*/

-- ========= Declaracion de Variables ============
DECLARE Var_MontoSaldo          DECIMAL(16,2);
DECLARE Var_CanCuotasAtra       INT(11);
DECLARE Var_MontoExigible       DECIMAL(14,2);
DECLARE Var_IVASucurs           DECIMAL(12,2);
DECLARE Var_FecActual           DATE;
DECLARE Var_CreEstatus          CHAR(1);
DECLARE Var_CliPagIVA           CHAR(1);

DECLARE Var_IVAIntOrd           CHAR(1);
DECLARE Var_IVAIntMor           CHAR(1);
DECLARE Var_ValIVAIntOr         DECIMAL(12,2);
DECLARE Var_ValIVAIntMo         DECIMAL(12,2);
DECLARE Var_ValIVAGen           DECIMAL(12,2);
DECLARE Var_PagaIVA             CHAR(1);
DECLARE Var_ClienteID           INT(11);
DECLARE Var_ProxAmortizacionID  INT(11);

-- ========= Declaracion de Constantes ============
DECLARE Tipo_SaldoTotalCap          INT(11);             -- Saldo Total de Capital
DECLARE Tipo_SaldoCapExig           INT(11);             -- Saldo De Capital Exigible
DECLARE Tipo_SaldoIntExig           INT(11);             -- Saldo De Interes Exigible
DECLARE Tipo_SaldoIntMora           INT(11);             -- Saldo De Interes Moratorio
DECLARE Tipo_TotalCapProxPag        INT(11);             -- Total de Captial para Proximo Pago
DECLARE Tipo_TotalIntOrdProxPag     INT(11);             -- Total de Interes Ordinario para Proximo Pago
DECLARE Tipo_TotalIVAIntOrdPorxPag  INT(11);             -- Total de IVA de Interes Ordinario para Proximo Pago
DECLARE Tipo_TotalMoraPorxPag       INT(11);             -- Total de Interes Moratorio para Proximo Pago
DECLARE Tipo_TotalIVAMoraPorxPag    INT(11);             -- Total de IVA de Interes Moratorio para Proximo Pago
DECLARE Tipo_IvaIntExig             INT(11);             -- Total de IVA de Interes Intereses Ord Exigibles
DECLARE Tipo_IvaOtrosCargos         INT(11);             -- Total de IVA de Otros Cargos

DECLARE Cadena_Vacia                CHAR(1);
DECLARE Fecha_Vacia                 DATE;
DECLARE Entero_Cero                 INT;
DECLARE Decimal_Cero                DECIMAL(14,2);
DECLARE EstatusPagado               CHAR(1);
DECLARE SiPagaIVA                   CHAR(1);

SET Cadena_Vacia                := '';
SET Fecha_Vacia                 := '1900-01-01';
SET Entero_Cero                 := 0;
SET Decimal_Cero                := 0.00;
SET EstatusPagado               := 'P';
SET SiPagaIVA                   := 'S';
SET Var_ProxAmortizacionID      := 0;
SET Var_MontoExigible           := Decimal_Cero;
SET Tipo_SaldoTotalCap          := 1;                 -- Saldo Total de Capital
SET Tipo_SaldoCapExig           := 2;                 -- Saldo De Capital Exigible
SET Tipo_SaldoIntExig           := 3;                 -- Saldo De Interes Exigible
SET Tipo_SaldoIntMora           := 4;                 -- Saldo De Interes Moratorio
SET Tipo_TotalCapProxPag        := 5;                 -- Total de Captial para Proximo Pago
SET Tipo_TotalIntOrdProxPag     := 6;                 -- Total de Interes Ordinario para Proximo Pago
SET Tipo_TotalIVAIntOrdPorxPag  := 7;                 -- Total de IVA de Interes Ordinario para Proximo Pago
SET Tipo_TotalMoraPorxPag       := 8;                 -- Total de Interes Moratorio para Proximo Pago
SET Tipo_TotalIVAMoraPorxPag    := 9;                 -- Total de IVA de Interes Moratorio para Proximo Pago
SET Tipo_IvaIntExig             := 10;                -- Monto de IVA Nominal De Interes Exigible
SET Tipo_IvaOtrosCargos         := 11;                -- Monto de IVA Nominal De Otros Cargos Exigibles

  SELECT FechaSistema
  INTO Var_FecActual
  FROM PARAMETROSSIS;

SELECT  Cli.PagaIVA,            Suc.IVA,            Pro.CobraIVAInteres, Cre.Estatus,
        Pro.CobraIVAMora
        INTO Var_CliPagIVA,   Var_IVASucurs,      Var_IVAIntOrd, 		 Var_CreEstatus,
             Var_IVAIntMor
    FROM CREDITOS   Cre,
         CLIENTES   Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
    WHERE   Cre.CreditoID           = Par_CreditoID
      AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
      AND   Cre.ClienteID           = Cli.ClienteID
      AND   Cre.SucursalID          = Suc.SucursalID;

    SET Var_CliPagIVA     := IFNULL(Var_CliPagIVA, SiPagaIVA);
    SET Var_IVAIntOrd     := IFNULL(Var_IVAIntOrd, SiPagaIVA);
    SET Var_IVAIntMor     := IFNULL(Var_IVAIntMor, SiPagaIVA);
    SET Var_IVASucurs     := IFNULL(Var_IVASucurs, Decimal_Cero);

    SET Var_CreEstatus    := IFNULL(Var_CreEstatus, Cadena_Vacia);

    SET Var_ValIVAIntOr   := Entero_Cero;
    SET Var_ValIVAIntMo   := Entero_Cero;
    SET Var_ValIVAGen     := Entero_Cero;
    SET Var_MontoExigible := Entero_Cero;
    SET Var_CanCuotasAtra := Entero_Cero;

    IF (Var_CliPagIVA = SiPagaIVA) THEN

        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAIntOrd = SiPagaIVA) THEN
            SET Var_ValIVAIntOr  := Var_IVASucurs;
        END IF;

        IF (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;

    END IF;

                      --  1 .- Para Saldo Total de Capital
  CASE Par_TipoSaldo WHEN Tipo_SaldoTotalCap THEN    SELECT  SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                                        ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) )
                                            INTO Var_MontoSaldo
                                            FROM AMORTICREDITO
                                            WHERE CreditoID   =  Par_CreditoID
                                              AND Estatus     <> EstatusPagado;

                      --  2 .- Para saldo de Capital Exigible (Atrasado y Vencido)
                      WHEN Tipo_SaldoCapExig THEN   SELECT  SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                                                ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) )
                                                    INTO Var_MontoSaldo
                                                    FROM AMORTICREDITO
                                                    WHERE CreditoID   =  Par_CreditoID
                                                      AND FechaExigible   <= Var_FecActual
                                                      AND Estatus     <> EstatusPagado;

                      --  3 .- Para Saldo de Interes Ordinario Exigible (Atrasado y Vencido)
                      WHEN Tipo_SaldoIntExig THEN   SELECT  SUM(ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                                                      SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) )
                                                    INTO Var_MontoSaldo
                                                    FROM AMORTICREDITO
                                                    WHERE CreditoID   =  Par_CreditoID
                                                      AND FechaExigible   <= Var_FecActual
                                                      AND Estatus     <> EstatusPagado;
                      --  4 .- Para Interes Moratorio
                      WHEN Tipo_SaldoIntMora THEN   SELECT  SUM(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) )
                                                    INTO Var_MontoSaldo
                                                    FROM AMORTICREDITO
                                                    WHERE CreditoID   =  Par_CreditoID
                                                      AND FechaExigible   <= Var_FecActual
                                                      AND Estatus     <> EstatusPagado;

                      --  5 .- Total de Capital para proximo pago
                      WHEN Tipo_TotalCapProxPag THEN    SELECT  COUNT(CreditoID)
                                                          INTO Var_CanCuotasAtra
                                                          FROM AMORTICREDITO
                                                          WHERE CreditoID   =  Par_CreditoID
                                                            AND FechaExigible   <= Var_FecActual
                                                            AND Estatus     <> EstatusPagado;

                                                          SET Var_CanCuotasAtra   := IFNULL(Var_CanCuotasAtra, Entero_Cero);


                                                        IF (Var_CanCuotasAtra > Entero_Cero) THEN
                                                            -- Cuando hay cuotas atrasadas el capital a pagar como proximo pago es el exigible
                                                            SELECT  SUM( ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                                                                    ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) )
                                                            INTO Var_MontoSaldo
                                                            FROM AMORTICREDITO
                                                            WHERE CreditoID   =  Par_CreditoID
                                                              AND FechaExigible   <= Var_FecActual
                                                              AND Estatus     <> EstatusPagado;

                                                            SET Var_MontoSaldo  := IFNULL(Var_MontoSaldo, Entero_Cero);

                                                        ELSE
                                                            -- Cuando NO hay cuotas atrasadas el capital a pagar como proximo pago es el pactado en la siguiente cuota
                                                            SELECT MIN(AmortizacionID)
                                                            INTO Var_ProxAmortizacionID
                                                            FROM AMORTICREDITO
                                                            WHERE CreditoID   = Par_CreditoID
                                                              AND FechaExigible >= Var_FecActual
                                                              AND Estatus          != EstatusPagado;


                                                            SET Var_ProxAmortizacionID  := IFNULL(Var_ProxAmortizacionID, Entero_Cero);

                                                            SELECT ROUND(Capital, 2)
                                                            INTO Var_MontoSaldo
                                                            FROM AMORTICREDITO
                                                            WHERE CreditoID      = Par_CreditoID
                                                              AND AmortizacionID = Var_ProxAmortizacionID
                                                              AND Estatus          != EstatusPagado;

                                                        END IF;

                      --  6 .- Total de Interes Ordinario para Proximo Pago
                      WHEN Tipo_TotalIntOrdProxPag THEN   SELECT  COUNT(CreditoID)
                                                          INTO Var_CanCuotasAtra
                                                          FROM AMORTICREDITO
                                                          WHERE CreditoID   =  Par_CreditoID
                                                            AND FechaExigible   <= Var_FecActual
                                                            AND Estatus     <> EstatusPagado;

                                                          SET Var_CanCuotasAtra   := IFNULL(Var_CanCuotasAtra, Entero_Cero);


                                                        IF (Var_CanCuotasAtra > Entero_Cero) THEN
                                                              SELECT  SUM(ROUND( SaldoInteresOrd + SaldoInteresAtr +
                                                                                SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) )
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   =  Par_CreditoID
                                                                AND FechaExigible   <= Var_FecActual
                                                                AND Estatus     <> EstatusPagado;
                                                        ELSE
                                                              SELECT MIN(AmortizacionID)
                                                              INTO Var_ProxAmortizacionID
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   = Par_CreditoID
                                                                AND FechaExigible >= Var_FecActual
                                                                AND Estatus          != EstatusPagado;

                                                              SET Var_ProxAmortizacionID  := IFNULL(Var_ProxAmortizacionID, Entero_Cero);

                                                              SELECT ROUND(Interes, 2)
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID      = Par_CreditoID
                                                                AND AmortizacionID = Var_ProxAmortizacionID
                                                                AND Estatus          != EstatusPagado;
                                                        END IF;

                      --  7 .- Total de IVA de Interes Ordinario para Proximo Pago
                      WHEN Tipo_TotalIVAIntOrdPorxPag THEN
                                                        SELECT  COUNT(CreditoID)
                                                          INTO Var_CanCuotasAtra
                                                          FROM AMORTICREDITO
                                                          WHERE CreditoID   =  Par_CreditoID
                                                            AND FechaExigible   <= Var_FecActual
                                                            AND Estatus     <> EstatusPagado;

                                                          SET Var_CanCuotasAtra   := IFNULL(Var_CanCuotasAtra, Entero_Cero);


                                                        IF (Var_CanCuotasAtra > Entero_Cero) THEN
                                                              SELECT  SUM(ROUND( ROUND( SaldoInteresOrd + SaldoInteresAtr +
                                                                                        SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) * Var_ValIVAIntOr, 2) )
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   =  Par_CreditoID
                                                                AND FechaExigible   <= Var_FecActual
                                                                AND Estatus     <> EstatusPagado;
                                                        ELSE
                                                              SELECT MIN(AmortizacionID)
                                                              INTO Var_ProxAmortizacionID
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   = Par_CreditoID
                                                                AND FechaExigible >= Var_FecActual
                                                                AND Estatus          != EstatusPagado;

                                                              SET Var_ProxAmortizacionID  := IFNULL(Var_ProxAmortizacionID, Entero_Cero);

                                                              SELECT ROUND(IVAInteres, 2)
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID      = Par_CreditoID
                                                                AND AmortizacionID = Var_ProxAmortizacionID
                                                                AND Estatus          != EstatusPagado;
                                                        END IF;

                      --  8 .- Total de Interes Moratorio para Proximo Pago
                      WHEN Tipo_TotalMoraPorxPag THEN
                                                          SELECT  COUNT(CreditoID)
                                                          INTO Var_CanCuotasAtra
                                                          FROM AMORTICREDITO
                                                          WHERE CreditoID   =  Par_CreditoID
                                                            AND FechaExigible   <= Var_FecActual
                                                            AND Estatus     <> EstatusPagado;

                                                          SET Var_CanCuotasAtra   := IFNULL(Var_CanCuotasAtra, Entero_Cero);


                                                        IF (Var_CanCuotasAtra > Entero_Cero) THEN
                                                              SELECT  SUM(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) )
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   =  Par_CreditoID
                                                                AND FechaExigible   <= Var_FecActual
                                                                AND Estatus     <> EstatusPagado;
                                                        ELSE
                                                              SELECT SUM(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) )
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   =  Par_CreditoID
                                                                AND FechaExigible   > Var_FecActual
                                                                AND Estatus     <> EstatusPagado;
                                                        END IF;

                      --  9 .- Total de IVA de Interes Moratorio para Proximo Pago
                      WHEN Tipo_TotalIVAMoraPorxPag THEN
                                                          SELECT  COUNT(CreditoID)
                                                          INTO Var_CanCuotasAtra
                                                          FROM AMORTICREDITO
                                                          WHERE CreditoID   =  Par_CreditoID
                                                            AND FechaExigible   <= Var_FecActual
                                                            AND Estatus     <> EstatusPagado;

                                                          SET Var_CanCuotasAtra   := IFNULL(Var_CanCuotasAtra, Entero_Cero);


                                                        IF (Var_CanCuotasAtra > Entero_Cero) THEN
                                                              SELECT  SUM(ROUND( ROUND( SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2) )
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   =  Par_CreditoID
                                                                AND FechaExigible   <= Var_FecActual
                                                                AND Estatus     <> EstatusPagado;
                                                        ELSE
                                                              SELECT SUM(ROUND( ROUND( SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2) )
                                                              INTO Var_MontoSaldo
                                                              FROM AMORTICREDITO
                                                              WHERE CreditoID   =  Par_CreditoID
                                                                AND FechaExigible   > Var_FecActual
                                                                AND Estatus     <> EstatusPagado;
                                                        END IF;
                      WHEN Tipo_IvaIntExig THEN
                                                        SELECT SUM( ROUND( ROUND(  IFNULL(Amo.SaldoInteresOrd, Entero_Cero) + IFNULL(Amo.SaldoInteresAtr, Entero_Cero)
                                                                                 + IFNULL(Amo.SaldoInteresVen, Entero_Cero) + IFNULL(Amo.SaldoInteresPro, Entero_Cero)
                                                                                 + IFNULL(Amo.SaldoIntNoConta, Entero_Cero), 2) * Var_ValIVAIntOr , 2) )
                                                        INTO Var_MontoSaldo
                                                        FROM  AMORTICREDITO Amo
                                                        WHERE CreditoID   =  Par_CreditoID
                                                         AND FechaExigible   <= Var_FecActual
                                                         AND Estatus     <> EstatusPagado;
                      WHEN Tipo_IvaOtrosCargos THEN
                                                        SELECT SUM( ROUND( ROUND(   IFNULL(Amo.SaldoMoratorios, Entero_Cero) + IFNULL(Amo.SaldoMoraVencido, Entero_Cero)
                                                                                  + IFNULL(Amo.SaldoMoraCarVen, Entero_Cero) + IFNULL(Amo.SaldoComFaltaPa, Entero_Cero)
                                                                                  + IFNULL(Amo.SaldoOtrasComis, Entero_Cero) + IFNULL(Amo.SaldoComisionAnual, Entero_Cero), 2) *  Var_ValIVAIntMo , 2) )
                                                        INTO Var_MontoSaldo
                                                        FROM  AMORTICREDITO Amo
                                                        WHERE CreditoID   =  Par_CreditoID
                                                         AND FechaExigible   <= Var_FecActual
                                                         AND Estatus     <> EstatusPagado;

                      ELSE  SET Var_MontoSaldo  := Entero_Cero;
  END CASE;

  SET Var_MontoSaldo  := IFNULL(Var_MontoSaldo, Entero_Cero);

RETURN Var_MontoSaldo;

END$$
