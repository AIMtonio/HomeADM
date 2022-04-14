-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONAMORFINIQCRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONAMORFINIQCRE`;
DELIMITER $$


CREATE FUNCTION `FUNCIONAMORFINIQCRE`(

    Par_CreditoID   		BIGINT,
	Par_AmortizacionID      INT(4)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN



DECLARE Var_MontoExigible	decimal(14,2);
DECLARE Var_IVASucurs       decimal(12,2);
DECLARE Var_FecActual       date;
DECLARE Var_CreEstatus      char(1);
DECLARE Var_CliPagIVA       char(1);
DECLARE Var_IVAIntOrd       char(1);
DECLARE Var_IVAIntMor       char(1);
DECLARE Var_ValIVAIntOr     decimal(12,2);
DECLARE Var_ValIVAIntMo     decimal(12,2);
DECLARE Var_ValIVAGen       decimal(12,2);

DECLARE Var_ProyInPagAde    char(1);
DECLARE Var_PrductoCreID    int;
DECLARE Var_SaldoCapita     decimal(14,2);
DECLARE Var_DiasPermPagAnt  int;
DECLARE Var_Frecuencia      char(1);
DECLARE Var_DiasAntici      int;
DECLARE Var_CreTasa         decimal(12,4);
DECLARE Var_DiasCredito     int;
DECLARE Var_FechaVencim     date;
DECLARE Var_FecProxPago     date;

DECLARE Var_ComAntici       decimal(14,4);
DECLARE Var_PermiteLiqAnt   char(1);
DECLARE Var_CobraComLiqAnt  char(1);
DECLARE Var_TipComLiqAnt    char(1);
DECLARE Var_ComLiqAnt       decimal(14,4);
DECLARE Var_DiasGraciaLiq   int;
DECLARE Var_IntActual       decimal(14,4);



DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal(14,2);
DECLARE Decimal_Cien    decimal(14,2);
DECLARE EstatusPagado   char(1);
DECLARE SiPagaIVA       char(1);
DECLARE SI_ProyectInt   char(1);
DECLARE SI_PermiteLiqAnt    char(1);
DECLARE SI_CobraLiqAnt      char(1);
DECLARE Proyeccion_Int  char(1);
DECLARE Monto_Fijo      char(1);
DECLARE Por_Porcentaje  char(1);


SET Cadena_Vacia    	:= '';
SET Fecha_Vacia     	:= '1900-01-01';
SET Entero_Cero     	:= 0;
SET Decimal_Cero    	:= 0.00;
SET Decimal_Cien    	:= 100.0;
SET EstatusPagado   	:= 'P';
SET SiPagaIVA       	:= 'S';
SET SI_ProyectInt   	:= 'S';
SET SI_PermiteLiqAnt    := 'S';
SET SI_CobraLiqAnt      := 'S';
SET Proyeccion_Int      := 'P';
SET Monto_Fijo          := 'M';
SET Por_Porcentaje      := 'S';

SET Var_MontoExigible   := Decimal_Cero;

	SELECT FechaSistema, DiasCredito INTO Var_FecActual, Var_DiasCredito
		FROM PARAMETROSSIS;

	SELECT  Cli.PagaIVA,            Suc.IVA,                Pro.CobraIVAInteres,    Cre.Estatus,
			Pro.CobraIVAMora,       Pro.ProyInteresPagAde,  Pro.ProducCreditoID,    Cre.FrecuenciaCap,
			Cre.TasaFija,           Cre.FechaVencimien,
			(Amo.SaldoCapVigente + Amo.SaldoCapVenNExi + Amo.SaldoCapAtrasa + Amo.SaldoCapVencido)
		   INTO
			Var_CliPagIVA,          Var_IVASucurs,          Var_IVAIntOrd,          Var_CreEstatus,
			Var_IVAIntMor,          Var_ProyInPagAde,       Var_PrductoCreID,       Var_Frecuencia,
			Var_CreTasa,            Var_FecProxPago,     Var_SaldoCapita

		FROM CREDITOS   Cre,
			 AMORTICREDITO Amo,
			 CLIENTES   Cli,
			 SUCURSALES Suc,
			 PRODUCTOSCREDITO Pro
		WHERE   Cre.CreditoID           = Par_CreditoID
			AND Amo.AmortizacionID      = Par_AmortizacionID
			AND Amo.CreditoID		    = Cre.CreditoID
			AND Cre.ProductoCreditoID   = Pro.ProducCreditoID
			AND Cre.ClienteID           = Cli.ClienteID
			AND Cre.SucursalID          = Suc.SucursalID;

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


    SET Var_ComAntici   := Entero_Cero;
    SET Var_DiasAntici  := Entero_Cero;
    SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);


    SELECT  PermiteLiqAntici, CobraComLiqAntici, TipComLiqAntici,
            ComisionLiqAntici, DiasGraciaLiqAntici INTO

            Var_PermiteLiqAnt, Var_CobraComLiqAnt, Var_TipComLiqAnt,
            Var_ComLiqAnt, Var_DiasGraciaLiq

        FROM ESQUEMACOMPRECRE
        WHERE ProductoCreditoID = Var_PrductoCreID;

    SET Var_PermiteLiqAnt   := IFNULL(Var_PermiteLiqAnt, Cadena_Vacia);
    SET Var_CobraComLiqAnt  := IFNULL(Var_CobraComLiqAnt, Cadena_Vacia);
    SET Var_TipComLiqAnt    := IFNULL(Var_TipComLiqAnt, Cadena_Vacia);
    SET Var_ComLiqAnt       := IFNULL(Var_ComLiqAnt, Entero_Cero);
    SET Var_DiasGraciaLiq   := IFNULL(Var_DiasGraciaLiq, Entero_Cero);

    IF(Var_FecProxPago != Fecha_Vacia AND Var_FecProxPago >= Var_FecActual) THEN
        SET Var_DiasAntici := datediff(Var_FecProxPago, Var_FecActual);
    ELSE
        SET Var_DiasAntici := Entero_Cero;
    END IF;

    if(Var_DiasAntici > Var_DiasGraciaLiq AND Var_PermiteLiqAnt = SI_PermiteLiqAnt AND
       Var_CobraComLiqAnt = SI_CobraLiqAnt) THEN


        If(Var_TipComLiqAnt = Proyeccion_Int) THEN


            SELECT SUM(Interes) INTO Var_ComAntici
                FROM AMORTICREDITO
                WHERE CreditoID   = Par_CreditoID
                  AND FechaVencim > Var_FecActual
                  AND Estatus     != EstatusPagado;

            SET Var_ComAntici   := IFNULL(Var_ComAntici, Entero_Cero);


            SELECT ROUND(Amo.SaldoInteresPro + Amo.SaldoIntNoConta,2) INTO Var_IntActual
                FROM AMORTICREDITO Amo
                WHERE Amo.CreditoID   = Par_CreditoID
                  AND Amo.FechaVencim > Var_FecActual
                  AND Amo.FechaInicio <= Var_FecActual
                  AND Amo.Estatus     != EstatusPagado;

            SET Var_IntActual   := IFNULL(Var_IntActual, Entero_Cero);
            SET Var_ComAntici   := ROUND(Var_ComAntici - Var_IntActual,2);

        ELSEIF (Var_TipComLiqAnt = Por_Porcentaje) THEN
            SET Var_ComAntici   := ROUND(Var_SaldoCapita * Var_ComLiqAnt / Decimal_Cien,2);
        ELSE
            SET Var_ComAntici   := Var_ComLiqAnt;
        END IF;
    ELSE
        SET Var_ComAntici   := Entero_Cero;
    END IF;

    IF(Var_ComAntici < Entero_Cero) THEN
        SET Var_ComAntici   := Entero_Cero;
    END IF;

    SELECT ROUND(ifnull(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
                              ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

                              ROUND(SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen +
                                    SaldoInteresPro + SaldoIntNoConta, 2) +

                             ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
								   ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
								   ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
								   ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
								   ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2), 2) +

                              ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
                              ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) +

							  ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2) +
									ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2) +
									ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2),2)

                             ) + ROUND(Var_ComAntici,2) + ROUND(ROUND(Var_ComAntici,2) * Var_ValIVAIntOr,2),
                           Entero_Cero), 2)
            INTO Var_MontoExigible

            FROM AMORTICREDITO
            WHERE CreditoID     =  Par_CreditoID
				AND AmortizacionID = Par_AmortizacionID
				AND Estatus       <> EstatusPagado;

    SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero);
END IF;

RETURN Var_MontoExigible;

END$$