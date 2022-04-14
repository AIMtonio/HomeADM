-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONTOTALPASIVO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONTOTALPASIVO`;

DELIMITER $$
CREATE FUNCTION `FUNCIONTOTALPASIVO`(
	-- Funcion para calcular el total pasivo del credito
	-- Modulo de Fondeo
	Par_CreditoFonID	BIGINT(12)	-- ID de credito Fondeo
) RETURNS decimal(14,2)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_MontoDeuda		DECIMAL(14,2);	-- Monto de Deuda
	DECLARE Var_FecActual		DATE;			-- Fecha Actual
	DECLARE Var_PagaIva			CHAR(1);		-- Si el cliente paga IVA
	DECLARE Var_IVA				DECIMAL(12,2);	-- Monto de IVA

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constantes Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constantes Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constantes Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constantes Decimal Cero
	DECLARE EstatusPagado		CHAR(1);		-- Constantes Estatus Pagado

	DECLARE SiPagaIVA			CHAR(1);		-- Constantes SI Paga IVA
	DECLARE NoPagaIVA			CHAR(1);		-- Constantes NO Paga IVA

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET EstatusPagado		:= 'P';

	SET SiPagaIVA			:= 'S';
	SET NoPagaIVA			:= 'N';

	SET Var_MontoDeuda		:= Decimal_Cero;

	SELECT FechaSistema
	INTO Var_FecActual
	FROM PARAMETROSSIS;

	-- se obtienen los valores requeridos para las operaciones del sp
	SELECT	PagaIVA,  IFNULL(PorcentanjeIVA/100,0)
	INTO Var_PagaIva, Var_IVA
	FROM CREDITOFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID;

	SET Var_PagaIva := IFNULL(Var_PagaIva,NoPagaIVA);
	/* se compara para saber si el credito pasivo paga o no iva*/
	IF(Var_PagaIva <> SiPagaIVA) THEN
		SET Var_IVA := Decimal_Cero;
	ELSE
		SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
	END IF;

	SELECT	ROUND(
				IFNULL(
					SUM(
						ROUND(IFNULL(Amor.SaldoCapVigente, Decimal_Cero),2)	+ ROUND(IFNULL(Amor.SaldoCapAtrasad, Decimal_Cero),2) +
						ROUND(IFNULL(Amor.SaldoInteresAtra, Decimal_Cero),2)+ ROUND(IFNULL(Amor.SaldoInteresPro, Decimal_Cero),2) +
						ROUND(IFNULL(Amor.SaldoMoratorios, Decimal_Cero),2)	+ ROUND(IFNULL(Amor.SaldoComFaltaPa, Decimal_Cero),2) +
						ROUND(IFNULL(Amor.SaldoOtrasComis, Decimal_Cero),2)	+
						ROUND((
							ROUND(IFNULL(Amor.SaldoInteresAtra, Decimal_Cero),2) + ROUND(IFNULL(Amor.SaldoInteresPro, Decimal_Cero),2) +
							ROUND(IFNULL(Amor.SaldoMoratorios, Decimal_Cero),2)  + ROUND(IFNULL(Amor.SaldoComFaltaPa, Decimal_Cero),2) +
							ROUND(IFNULL(Amor.SaldoOtrasComis, Decimal_Cero),2) )* Var_IVA,2)
						),0),2)
	INTO Var_MontoDeuda
	FROM CREDITOFONDEO Cre
	LEFT OUTER JOIN AMORTIZAFONDEO Amor ON (Cre.CreditoFondeoID = Amor.CreditoFondeoID AND Amor.Estatus <> EstatusPagado)
	WHERE Cre.CreditoFondeoID = Par_CreditoFonID;

	SET Var_MontoDeuda := IFNULL(Var_MontoDeuda, Decimal_Cero);

	RETURN Var_MontoDeuda;

END$$