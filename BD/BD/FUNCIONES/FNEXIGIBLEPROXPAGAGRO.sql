-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEPROXPAGAGRO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEPROXPAGAGRO`;
DELIMITER $$


CREATE FUNCTION `FNEXIGIBLEPROXPAGAGRO`(
	/*Función para obtener el exigible del pŕoximo pago agro*/
	Par_CreditoID   BIGINT(12)


) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN
-- Declaracion de Variables
DECLARE Var_MontoExigible	DECIMAL(14,2);
DECLARE Var_IVASucurs		DECIMAL(12,2);
DECLARE Var_FecActual		DATE;
DECLARE Var_CreEstatus		CHAR(1);
DECLARE Var_CliPagIVA		CHAR(1);
DECLARE Var_IVAIntOrd		CHAR(1);
DECLARE Var_IVAIntMor		CHAR(1);
DECLARE Var_ValIVAIntOr		DECIMAL(12,2);
DECLARE Var_ValIVAIntMo		DECIMAL(12,2);
DECLARE Var_ValIVAGen		DECIMAL(12,2);
DECLARE Var_FechaProxVenc	VARCHAR(20);
-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE EstatusPagado		CHAR(1);
DECLARE SiPagaIVA			CHAR(1);
DECLARE Var_ProxAmortizacionID  INT;

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';
SET Fecha_Vacia				:= '1900-01-01';
SET Entero_Cero				:= 0;
SET Decimal_Cero			:= 0.00;
SET EstatusPagado			:= 'P';
SET SiPagaIVA				:= 'S';
SET Var_ProxAmortizacionID	:= 0;
SET Var_MontoExigible		:= Decimal_Cero;


SELECT FechaSistema INTO Var_FecActual
FROM PARAMETROSSIS;

SET Var_FechaProxVenc := FNFECHAPROXPAGAGRO(Par_CreditoID);


SELECT  Cli.PagaIVA,            Suc.IVA,            Pro.CobraIVAInteres, Cre.Estatus,
		Pro.CobraIVAMora
		INTO Var_CliPagIVA,   Var_IVASucurs,      Var_IVAIntOrd, Var_CreEstatus,
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

SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

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
		IF EXISTS (SELECT CreditoID FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID AND FechaExigible = Var_FechaProxVenc) THEN
			SELECT  ROUND(IFNULL(
						SUM(ROUND(SaldoCapVigente,2)
							+ ROUND(IFNULL(SaldoCapAtrasa,0),2)
							+ ROUND(IFNULL(SaldoCapVencido,0),2)
							+ ROUND(IFNULL(SaldoCapVenNExi,0),2)
							+ ROUND(IFNULL(SaldoInteresOrd,0)
								+ IFNULL(SaldoInteresAtr,0)
								+ IFNULL(SaldoInteresVen,0)
								+ IFNULL(SaldoInteresPro,0)
								+ IFNULL(SaldoIntNoConta,0), 2)
							+ ROUND(
								ROUND(IFNULL(SaldoInteresOrd,0)
									+ IFNULL(SaldoInteresAtr,0)
									+ IFNULL(SaldoInteresVen,0)
									+ IFNULL(SaldoInteresPro,0)
									+ IFNULL(SaldoIntNoConta,0), 2) * Var_ValIVAIntOr, 2)
							+ ROUND(IFNULL(SaldoComFaltaPa,0),2)
							+ ROUND(ROUND(IFNULL(SaldoComFaltaPa,0),2) * Var_ValIVAGen,2)
							+ ROUND(IFNULL(SaldoComServGar,0),2)
							+ ROUND(ROUND(IFNULL(SaldoComServGar,0),2) * Var_ValIVAGen,2)
							+ ROUND(IFNULL(SaldoOtrasComis,0),2)
							+ ROUND(ROUND(IFNULL(SaldoOtrasComis,0),2) * Var_ValIVAGen,2)
							+ ROUND(
								IFNULL(SaldoMoratorios,0) +
								IFNULL(SaldoMoraVencido,0) +
								IFNULL(SaldoMoraCarVen,0),2) +
							ROUND(ROUND(
								IFNULL(SaldoMoratorios,0) +
								IFNULL(SaldoMoraVencido,0) +
								IFNULL(SaldoMoraCarVen,0),2) * Var_ValIVAIntMo,2)+
							ROUND(IFNULL(MontoSeguroCuota,0), 2) +
							ROUND(IFNULL(IVASeguroCuota,0), 2) +
							ROUND(IFNULL(SaldoComisionAnual,0), 2) +
							ROUND(ROUND(IFNULL(SaldoComisionAnual,0),2) * Var_ValIVAGen,2) ), Entero_Cero)
							, 2)
							INTO Var_MontoExigible
				FROM AMORTICREDITO
					WHERE FechaExigible = Var_FechaProxVenc
					  AND CreditoID     =  Par_CreditoID;
		ELSE
			SELECT  ROUND(IFNULL(
						SUM(ROUND(SaldoCapVigente,2)
							+ ROUND(IFNULL(SaldoCapAtrasa,0),2)
							+ ROUND(IFNULL(SaldoCapVencido,0),2)
							+ ROUND(IFNULL(SaldoCapVenNExi,0),2)
							+ ROUND(IFNULL(SaldoInteresOrd,0)
								+ IFNULL(SaldoInteresAtr,0)
								+ IFNULL(SaldoInteresVen,0)
								+ IFNULL(SaldoInteresPro,0)
								+ IFNULL(SaldoIntNoConta,0), 2)
							+ ROUND(
								ROUND(IFNULL(SaldoInteresOrd,0)
									+ IFNULL(SaldoInteresAtr,0)
									+ IFNULL(SaldoInteresVen,0)
									+ IFNULL(SaldoInteresPro,0)
									+ IFNULL(SaldoIntNoConta,0), 2) * Var_ValIVAIntOr, 2)
							+ ROUND(IFNULL(SaldoComFaltaPa,0),2)
							+ ROUND(ROUND(IFNULL(SaldoComFaltaPa,0),2) * Var_ValIVAGen,2)
							+ ROUND(IFNULL(SaldoComServGar,0),2)
							+ ROUND(ROUND(IFNULL(SaldoComServGar,0),2) * Var_ValIVAGen,2)
							+ ROUND(IFNULL(SaldoOtrasComis,0),2)
							+ ROUND(ROUND(IFNULL(SaldoOtrasComis,0),2) * Var_ValIVAGen,2)
							+ ROUND(
								IFNULL(SaldoMoratorios,0) +
								IFNULL(SaldoMoraVencido,0) +
								IFNULL(SaldoMoraCarVen,0),2) +
							ROUND(ROUND(
								IFNULL(SaldoMoratorios,0) +
								IFNULL(SaldoMoraVencido,0) +
								IFNULL(SaldoMoraCarVen,0),2) * Var_ValIVAIntMo,2)+
							ROUND(IFNULL(MontoSeguroCuota,0), 2) +
							ROUND(IFNULL(IVASeguroCuota,0), 2) +
							ROUND(IFNULL(SaldoComisionAnual,0), 2) +
							ROUND(ROUND(IFNULL(SaldoComisionAnual,0),2) * Var_ValIVAGen,2) ), Entero_Cero)
							, 2)
							INTO Var_MontoExigible
				FROM AMORTICREDITO
					WHERE FechaExigible = Var_FechaProxVenc
					  AND CreditoID     =  Par_CreditoID;
		END IF;
		SET Var_MontoExigible := IFNULL(Var_MontoExigible, Decimal_Cero);


	END IF;-- FIN Valdacion Var_CreEstatus

	RETURN Var_MontoExigible;
END$$