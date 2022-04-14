-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONEXIAMORCRESINCOM
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONEXIAMORCRESINCOM`;DELIMITER $$

CREATE FUNCTION `FUNCIONEXIAMORCRESINCOM`(

    Par_CreditoID   		BIGINT,
	Par_AmortizacionID      INT(4)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN



DECLARE Var_MontoExigible	DECIMAL(14,2);
DECLARE Var_IVASucurs       DECIMAL(12,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);
DECLARE Var_IVAINTOrd       CHAR(1);
DECLARE Var_IVAIntMor       CHAR(1);
DECLARE Var_ValIVAINTOr     DECIMAL(12,2);
DECLARE Var_ValIVAIntMo     DECIMAL(12,2);
DECLARE Var_ValIVAGen       DECIMAL(12,2);

DECLARE Var_ProyInPagAde    CHAR(1);
DECLARE Var_PrductoCreID    INT;
DECLARE Var_DiasPermPagAnt  INT;
DECLARE Var_Frecuencia      CHAR(1);
DECLARE Var_DiasAntici      INT;
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_DiasCredito     INT;
DECLARE Var_IntAntici       DECIMAL(14,4);
DECLARE Var_FecProxPago     DATE;
DECLARE Var_FecDiasProPag   DATE;
DECLARE Var_ProxAmorti      INT;
DECLARE Var_NumProyInteres  INT;
DECLARE Var_IntProActual    DECIMAL(14,4);
DECLARE Var_Interes    		DECIMAL(14,4);


DECLARE Cadena_Vacia      	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(14,2);
DECLARE Decimal_Cien   	 	DECIMAL(14,2);
DECLARE EstatusPagado    	CHAR(1);
DECLARE SiPagaIVA           CHAR(1);
DECLARE SI_ProyectInt       CHAR(1);
DECLARE Tol_DifPago     	DECIMAL(10,4);



SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Decimal_Cien    := 100.0;
SET EstatusPagado   := 'P';
SET SiPagaIVA       := 'S';
SET SI_ProyectInt   := 'S';
SET Tol_DifPago     := 0.02;

SET Var_MontoExigible   := Decimal_Cero;

SELECT FechaSistema, DiasCredito INTO Var_FecActual, Var_DiasCredito
	FROM PARAMETROSSIS;

SELECT  Cli.PagaIVA,            Suc.IVA,                Pro.CobraIVAInteres,    Cre.Estatus,
        Pro.CobraIVAMora,       Pro.ProyInteresPagAde,  Pro.ProducCreditoID,    Cre.FrecuenciaCap,
        Cre.TasaFija INTO
        Var_CliPagIVA,          Var_IVASucurs,          Var_IVAINTOrd,          Var_CreEstatus,
        Var_IVAIntMor,          Var_ProyInPagAde,       Var_PrductoCreID,       Var_Frecuencia,
        Var_CreTasa

    FROM CREDITOS   Cre,
		 AMORTICREDITO Amo,
         CLIENTES   Cli,
         SUCURSALES Suc,
         PRODUCTOSCREDITO Pro
    WHERE   Cre.CreditoID           = Par_CreditoID
	  AND Amo.AmortizacionID        = Par_AmortizacionID
	  AND Amo.CreditoID			    = Cre.CreditoID
      AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
      AND   Cre.ClienteID           = Cli.ClienteID
      AND   Cre.SucursalID          = Suc.SucursalID;

SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
SET Var_IVAINTOrd   := IFNULL(Var_IVAINTOrd, SiPagaIVA);
SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

SET Var_CreEstatus = IFNULL(Var_CreEstatus, Cadena_Vacia);

SET Var_ValIVAINTOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;

IF(Var_CreEstatus != Cadena_Vacia) THEN

    IF (Var_CliPagIVA = SiPagaIVA) THEN

        SET Var_ValIVAGen  := Var_IVASucurs;

        IF (Var_IVAINTOrd = SiPagaIVA) THEN
            SET Var_ValIVAINTOr  := Var_IVASucurs;
        END IF;

        if (Var_IVAIntMor = SiPagaIVA) THEN
            SET Var_ValIVAIntMo  := Var_IVASucurs;
        END IF;
    END IF;


    SET Var_DiasPermPagAnt  := Entero_Cero;
    SET Var_IntAntici       := Entero_Cero;
    SET Var_NumProyInteres  := Entero_Cero;



    SELECT Dpa.NumDias INTO Var_DiasPermPagAnt
        FROM CREDDIASPAGANT Dpa
        WHERE Dpa.ProducCreditoID = Var_PrductoCreID
          AND Dpa.Frecuencia = Var_Frecuencia;

    SET Var_DiasPermPagAnt  := IFNULL(Var_DiasPermPagAnt, Entero_Cero);

    IF(Var_DiasPermPagAnt > Entero_Cero) THEN


        SELECT min(FechaExigible), min(FechaVencim), min(AmortizacionID) INTO
               Var_FecProxPago, Var_FecDiasProPag, Var_ProxAmorti
            FROM AMORTICREDITO
            WHERE CreditoID   = Par_CreditoID
              AND FechaVencim > Var_FecActual
              AND Estatus     != EstatusPagado;

        SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);
        SET Var_FecDiasProPag := IFNULL(Var_FecDiasProPag, Fecha_Vacia);
        SET Var_ProxAmorti  := IFNULL(Var_ProxAmorti, Entero_Cero);

        IF(Var_FecProxPago != Fecha_Vacia) THEN
            SET Var_DiasAntici := datediff(Var_FecProxPago, Var_FecActual);
        ELSE
            SET Var_DiasAntici := Entero_Cero;
        END IF;


        SELECT Amo.NumProyInteres, Amo.Interes,
			  IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero) INTO
			Var_NumProyInteres, Var_Interes, Var_IntProActual
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID     = Par_CreditoID
              AND Amo.AmortizacionID = Var_ProxAmorti
              AND Amo.Estatus     != EstatusPagado;

        SET Var_NumProyInteres  := IFNULL(Var_NumProyInteres, Entero_Cero);
		SET	Var_Interes	:= IFNULL(Var_Interes, Entero_Cero);
        SET Var_IntProActual := IFNULL(Var_IntProActual, Entero_Cero);

        IF(Var_NumProyInteres = Entero_Cero) THEN


            IF(Var_DiasAntici <= Var_DiasPermPagAnt AND Var_ProyInPagAde = SI_ProyectInt) THEN

				SET Var_IntAntici = ROUND(Var_Interes - Var_IntProActual,2);

                IF(Var_IntAntici < Entero_Cero) THEN
                    SET Var_IntAntici := Entero_Cero;
                END IF;
            END IF;
        END IF;
    END IF;

    SELECT   ROUND(IFNULL(
                    sum(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                        ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                          ROUND(SaldoInteresOrd + SaldoInteresAtr +
                                SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta +
                                CASE WHEN AmortizacionID = Var_ProxAmorti THEN
                                    Var_IntAntici
                                ELSE Entero_Cero END, 2) +

                              ROUND(ROUND(SaldoInteresOrd * Var_ValIVAINTOr, 2) +
								ROUND(SaldoInteresAtr * Var_ValIVAINTOr, 2) +
                                ROUND(SaldoInteresVen * Var_ValIVAINTOr, 2) +
								(CASE WHEN AmortizacionID = Var_ProxAmorti THEN Entero_Cero
									ELSE
									ROUND(SaldoInteresPro * Var_ValIVAINTOr,2)
								END ) +

								ROUND(SaldoIntNoConta * Var_ValIVAINTOr, 2) +
                                      CASE WHEN AmortizacionID = Var_ProxAmorti THEN
                                            ROUND(ROUND(Var_IntAntici + SaldoInteresPro ,2) * Var_ValIVAINTOr, 2)
                                      ELSE Entero_Cero END,
                                      2) +

                          ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                          ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +

						  ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
								ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
								ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)),
                       Entero_Cero)
                , 2)
            INTO Var_MontoExigible

            FROM AMORTICREDITO
            WHERE CreditoID     =  Par_CreditoID
				AND AmortizacionID = Par_AmortizacionID
				AND Estatus       <> EstatusPagado;

    SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero);

END IF;

RETURN Var_MontoExigible;

END$$