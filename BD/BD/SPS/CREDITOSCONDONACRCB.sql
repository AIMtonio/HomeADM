DELIMITER ;

DROP PROCEDURE IF EXISTS `CREDITOSCONDONACRCB`;

DELIMITER $$

CREATE PROCEDURE `CREDITOSCONDONACRCB`(
	 Par_CreditoID					BIGINT(20),			-- Numero de Credito
    INOUT Par_SaldoMoratorios		DECIMAL (14,2),
    INOUT Par_totalCapital			DECIMAL (14,2),
    INOUT Par_totalInteres			DECIMAL (14,2),
    INOUT Par_totalComisi			DECIMAL (14,2),

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
BEGIN

DECLARE Entero_Cero     	INT(11);
DECLARE EstatusPagado   	CHAR(1);
DECLARE SiPagaIVA       	CHAR(1);

DECLARE Var_ValIVAIntOr 	DECIMAL(12,2);
DECLARE Var_ValIVAIntMo 	DECIMAL(12,2);
DECLARE Var_ValIVAGen   	DECIMAL(12,2);
DECLARE Var_CliPagIVA   	CHAR(1);
DECLARE Var_IVASucurs   	DECIMAL(12,2);
DECLARE Var_SucCredito      INT(11);
DECLARE Var_IVAIntOrd   	CHAR(1);
DECLARE Var_IVAIntMor   	CHAR(1);

SET EstatusPagado   	:= 'P';
SET Entero_Cero         := 0;
SET SiPagaIVA       	:= 'S';

SET Var_ValIVAIntOr := Entero_Cero;
SET Var_ValIVAIntMo := Entero_Cero;
SET Var_ValIVAGen   := Entero_Cero;

		SELECT  Cli.PagaIVA,		Cre.SucursalID,		Pro.CobraIVAInteres, 	Pro.CobraIVAMora
			INTO
				Var_CliPagIVA,		Var_SucCredito,		Var_IVAIntOrd,  		Var_IVAIntMor
			FROM CREDITOS Cre,
				 PRODUCTOSCREDITO Pro,
				 CLIENTES Cli
			WHERE Cre.CreditoID     = Par_CreditoID
			  AND Cre.ProductoCreditoID = Pro.ProducCreditoID
			  AND Cre.ClienteID     = Cli.ClienteID;

		  IF (Var_CliPagIVA = SiPagaIVA) THEN
			SET	Var_IVASucurs	:= IFNULL((SELECT IVA
											FROM SUCURSALES
											 WHERE  SucursalID = Var_SucCredito),  Entero_Cero);

			-- IVA General (Comisiones y Otro Cargos)
			SET Var_ValIVAGen  := Var_IVASucurs;
					-- Verificamos si Paga IVA de Interes Ordinario
			IF (Var_IVAIntOrd = SiPagaIVA) THEN
				SET Var_ValIVAIntOr  := Var_IVASucurs;
			END IF;

			IF (Var_IVAIntMor = SiPagaIVA) THEN
				SET Var_ValIVAIntMo  := Var_IVASucurs;
			END IF;
		END IF;

SELECT			IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero) AS SaldoMoratorios,
				IFNULL(SUM(ROUND(SaldoCapVigente,2)	+
								  ROUND(SaldoCapAtrasa,2)	+
								  ROUND(SaldoCapVencido,2)	+
								  ROUND(SaldoCapVenNExi,2)),Entero_Cero) AS totalCapital,
				ROUND(IFNULL(SUM(ROUND(SaldoInteresOrd +
											  SaldoInteresAtr +
											  SaldoInteresVen +
											  SaldoInteresPro +
											  SaldoIntNoConta
											  ,2)),Entero_Cero), 2) AS totalInteres,
				ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2) +
											ROUND(SaldoSeguroCuota,2)),Entero_Cero),2) AS totalComisi
				INTO
							Par_SaldoMoratorios,	 	  	Par_totalCapital,			Par_totalInteres,
							Par_totalComisi
				FROM AMORTICREDITO Amo
				WHERE Amo.CreditoID = Par_CreditoID
				 AND Amo.Estatus <> EstatusPagado;

END$$