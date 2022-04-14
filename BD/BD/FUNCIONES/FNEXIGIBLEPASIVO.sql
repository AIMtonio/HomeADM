-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEPASIVO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEPASIVO`;DELIMITER $$

CREATE FUNCTION `FNEXIGIBLEPASIVO`(
    Par_CreditoFonID   BIGINT(12)


) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

# Declaracion de variables
DECLARE Var_MontoExigible	DECIMAL(14,2);
DECLARE Var_FecActual       DATE;
DECLARE Var_PagaIva			CHAR(1);
DECLARE Var_IVA			 	DECIMAL(12,2);
DECLARE Var_CapIntere       CHAR(1);
DECLARE Var_NumTotAmorti    INT;


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(14,2);
DECLARE EstatusPagado   CHAR(1);
DECLARE SiPagaIVA       CHAR(1);
DECLARE NoPagaIVA		CHAR(1);
DECLARE NO_Capitaliza	CHAR(1);
DECLARE SI_Capitaliza 	CHAR(1);

SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET EstatusPagado   := 'P';
SET SiPagaIVA       := 'S';
SET NoPagaIVA		:= 'N';
SET NO_Capitaliza	:= 'N';
SET SI_Capitaliza	:= 'S';

SET Var_MontoExigible   := Decimal_Cero;

SELECT FechaSistema INTO Var_FecActual
  FROM PARAMETROSSIS;

	-- se obtienen los valores requeridos para las operaciones del sp
	SELECT	PagaIVA, IFNULL(PorcentanjeIVA/100,0), CapitalizaInteres, NumAmortInteres
		INTO Var_PagaIva, Var_IVA, Var_CapIntere,	Var_NumTotAmorti
	FROM CREDITOFONDEO
		WHERE CreditoFondeoID = Par_CreditoFonID;

	SET Var_PagaIva 	:=IFNULL(Var_PagaIva,NoPagaIVA);
    SET Var_CapIntere	:=  IFNULL(Var_CapIntere, NO_Capitaliza);
	/* se compara para saber si el credito pasivo paga o no iva*/
	IF(Var_PagaIva <> SiPagaIVA) THEN
		SET Var_IVA := Decimal_Cero;
	ELSE
		SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
	END IF;


	SELECT   ROUND(-- Saldo Total Exigible
				IFNULL(SUM(SaldoCapVigente),Entero_Cero) + IFNULL(SUM(SaldoCapAtrasad),Entero_Cero) + -- Capitales
				IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero) + IFNULL(SUM(ROUND(SaldoInteresAtra,2)),Entero_Cero) +
				ROUND(IFNULL(SUM(SaldoInteresPro + SaldoInteresAtra) * Var_IVA, 0) +
				ROUND(IFNULL(SUM(SaldoMoratorios),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) +
				ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2)
			, 2),2)
	INTO Var_MontoExigible
			FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID
		AND Estatus <> EstatusPagado
		AND FechaExigible <= Var_FecActual
      AND ( Var_CapIntere = NO_Capitaliza                       -- En un Credito con Capitalizacion de Interes, solo es exigible hasta la ultima cuota
      OR    (   Var_CapIntere = SI_Capitaliza
      AND       AmortizacionID  = Var_NumTotAmorti ));

    SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero);


RETURN Var_MontoExigible;

END$$