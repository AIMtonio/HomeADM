-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEPROXPAGEDOCTA
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEPROXPAGEDOCTA`;
DELIMITER $$

CREATE FUNCTION `FNEXIGIBLEPROXPAGEDOCTA`(
	Par_CreditoID		BIGINT(12),
	Par_FechaCorte		DATE,
	Par_Devuelve		VARCHAR(2)


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

DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE EstatusPagado		CHAR(1);
DECLARE SiPagaIVA			CHAR(1);
DECLARE Var_ProxAmortizacionID  INT;
DECLARE Var_IVANotaCargo	DECIMAL(14,2);		-- Variable para el porcentaje que se cobra por nota de cargo

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


SELECT  Cli.PagaIVA,			Suc.IVA,			Pro.CobraIVAInteres, Cre.Estatus,
		Pro.CobraIVAMora
		INTO Var_CliPagIVA,		Var_IVASucurs,		Var_IVAIntOrd, Var_CreEstatus,
			 Var_IVAIntMor
	FROM CREDITOS	Cre,
		 CLIENTES	Cli,
		 SUCURSALES Suc,
		 PRODUCTOSCREDITO Pro
	WHERE	Cre.CreditoID			= Par_CreditoID
	  AND	Cre.ProductoCreditoID	= Pro.ProducCreditoID
	  AND	Cre.ClienteID			= Cli.ClienteID
	  AND	Cre.SucursalID			= Suc.SucursalID;

SET Var_CliPagIVA := IFNULL(Var_CliPagIVA, SiPagaIVA);
SET Var_IVAIntOrd := IFNULL(Var_IVAIntOrd, SiPagaIVA);
SET Var_IVAIntMor := IFNULL(Var_IVAIntMor, SiPagaIVA);
SET Var_IVASucurs := IFNULL(Var_IVASucurs, Decimal_Cero);

SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);

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

	SELECT  ROUND(IFNULL(
					SUM(IF( FIND_IN_SET('C',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
								ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
								ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2),
								0
						)
						+
						IF( FIND_IN_SET('IN',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
								ROUND(SaldoInteresOrd + SaldoInteresAtr +
								SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2),
								0
						)
						+
						IF( FIND_IN_SET('IV',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
								ROUND(ROUND(SaldoInteresOrd + SaldoInteresAtr +
								SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) *
								Var_ValIVAIntOr, 2),
								0
						)
						+
						IF( FIND_IN_SET('T',Par_Devuelve) > 0,
								ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
								ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
								ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
								IFNULL(ROUND(MontoSeguroCuota, 2),0) + IFNULL(ROUND(IVASeguroCuota, 2),0) +
								ROUND(SaldoComisionAnual, 2) + ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2) +
								ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) +
								ROUND(SaldoNotCargoConIVA,2) + ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_IVANotaCargo,2),
								0
						)
						+
						IF( FIND_IN_SET('MN',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
								ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2),
								0
						)
						+
						IF( FIND_IN_SET('MV',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
								ROUND(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) * Var_ValIVAIntMo,2),
								0
						) ),
					   Entero_Cero)
				, 2)
			INTO Var_MontoExigible

			FROM AMORTICREDITO
			WHERE FechaExigible <= Par_FechaCorte
			  AND Estatus       <> EstatusPagado
			  AND CreditoID     =  Par_CreditoID;

	SET Var_MontoExigible := IFNULL(Var_MontoExigible, Decimal_Cero);

  IF(Var_MontoExigible = Decimal_Cero)THEN
	 SELECT MIN(AmortizacionID) INTO Var_ProxAmortizacionID
				FROM AMORTICREDITO
				WHERE CreditoID   = Par_CreditoID
				  AND FechaExigible >= Par_FechaCorte
				  AND Estatus      != EstatusPagado;

			SET Var_ProxAmortizacionID := IFNULL(Var_ProxAmortizacionID, Entero_Cero);
			SET Var_MontoExigible  := IFNULL(Var_MontoExigible, Entero_Cero);
			IF(Var_ProxAmortizacionID != Entero_Cero)THEN
				SELECT (
					IF( FIND_IN_SET('C',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
							ROUND(Capital, 2),
							0
					)
					+
					IF( FIND_IN_SET('IN',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
							ROUND(Interes, 2),
							0
					)
					+
					IF( FIND_IN_SET('IV',Par_Devuelve) > 0 || FIND_IN_SET('T',Par_Devuelve) > 0,
							ROUND(IVAInteres, 2),
							0
					)
					+
					IF( FIND_IN_SET('T',Par_Devuelve) > 0,
							IFNULL(ROUND(MontoSeguroCuota, 2),0) + IFNULL(ROUND(IVASeguroCuota, 2),0) +
							ROUND(SaldoComisionAnual, 2) + ROUND(SaldoComisionAnualIVA, 2) +
							ROUND(SaldoNotCargoRev,2) + ROUND(SaldoNotCargoSinIVA,2) +
							ROUND(SaldoNotCargoConIVA,2) + ROUND(ROUND(SaldoNotCargoConIVA,2) * Var_ValIVAGen,2),
							0
					)
				)
				INTO Var_MontoExigible
					FROM AMORTICREDITO
					WHERE CreditoID      = Par_CreditoID
					  AND AmortizacionID = Var_ProxAmortizacionID
					  AND Estatus      != EstatusPagado;

				SET Var_MontoExigible   := IFNULL(Var_MontoExigible, Entero_Cero);

			END IF;

  END IF;


 END IF;

RETURN Var_MontoExigible;

END$$