-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCREPASIVORENOVACIONAGRO
DELIMITER ;
DROP function IF EXISTS `FNCREPASIVORENOVACIONAGRO`;
DELIMITER $$

CREATE  FUNCTION `FNCREPASIVORENOVACIONAGRO`(
# DEVUELVE EL ADEUDO DEL CREDITO PASIVO 
    Par_CreditoFonID   BIGINT(12)		-- ID DEL CREDITO PASIVO
								
) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

# Declaracion de variables
DECLARE Var_MontoExigible	DECIMAL(14,2);			-- Monto Exigible
DECLARE Var_FecActual       DATE;					-- Fecha Actual
DECLARE Var_PagaIva			CHAR(1);				-- Paga Iva
DECLARE Var_IVA			 	DECIMAL(12,2);			-- IVA
DECLARE Var_CapIntere       CHAR(1);				-- Capitaliza Interes
DECLARE Var_NumTotAmorti    INT;					-- Numero de Amortizaciones

	
DECLARE Cadena_Vacia    CHAR(1);					-- Constante cadena vacia
DECLARE Fecha_Vacia     DATE;						-- Constante Fecha Vacia
DECLARE Entero_Cero     INT;						-- Constante Entero Cero
DECLARE Decimal_Cero    DECIMAL(14,2);				-- Constante Decimal
DECLARE EstatusPagado   CHAR(1);					-- Constante Estatus Pagado
DECLARE SiPagaIVA       CHAR(1);					-- Constante Paga IVA
DECLARE NoPagaIVA		CHAR(1);					-- Constante No Paga IVA
DECLARE NO_Capitaliza	CHAR(1);					-- Constante No capitaliza
DECLARE SI_Capitaliza 	CHAR(1);					-- Constante SI capitaliza

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


	SELECT   ROUND(-- Saldo Total Exigible SIN CAPITAL
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