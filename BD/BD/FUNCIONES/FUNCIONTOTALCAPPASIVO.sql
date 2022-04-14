-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONTOTALCAPPASIVO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONTOTALCAPPASIVO`;DELIMITER $$

CREATE FUNCTION `FUNCIONTOTALCAPPASIVO`(
	/* FUNCION QUE CALCULA EL TOTAL DE ADEUDO DE UN CREDITO PASIVO */
    Par_CreditoFonID   BIGINT(12)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

	# Declaracion de variables
	DECLARE Var_MontoDeuda 		DECIMAL(14,2);
	DECLARE Var_FecActual       DATE;
	DECLARE Var_PagaIva			CHAR(1);
	DECLARE Var_IVA			 	DECIMAL(12,2);
	DECLARE Var_AmortizacionID	INT(11);

	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia    	 	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero    	DECIMAL(14,2);
	DECLARE EstatusPagado   	CHAR(1);
	DECLARE SiPagaIVA       	CHAR(1);
	DECLARE NoPagaIVA			CHAR(1);

	SET Cadena_Vacia    		:= '';
	SET Fecha_Vacia     		:= '1900-01-01';
	SET Entero_Cero     		:= 0;
	SET Decimal_Cero    		:= 0.00;
	SET EstatusPagado   		:= 'P';
	SET SiPagaIVA       		:= 'S';
	SET NoPagaIVA				:= 'N';

	SET Var_MontoDeuda   := Decimal_Cero;

	SELECT FechaSistema INTO Var_FecActual
	FROM PARAMETROSSIS;


	-- se obtienen los valores requeridos para las operaciones del sp
	SELECT	PagaIVA, IFNULL(PorcentanjeIVA/100,0) INTO Var_PagaIva, Var_IVA FROM CREDITOFONDEO
		WHERE CreditoFondeoID = Par_CreditoFonID;

	SET Var_PagaIva :=IFNULL(Var_PagaIva,NoPagaIVA);
	/* se compara para saber si el credito pasivo paga o no iva*/
	IF(Var_PagaIva <> SiPagaIVA) THEN
		SET Var_IVA := Decimal_Cero;
	ELSE
		SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
	END IF;

    SELECT MIN(AmortizacionID) INTO Var_AmortizacionID
		FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID  = Par_CreditoFonID
		AND Estatus!= EstatusPagado;

	SELECT  ROUND(IFNULL(
			(ROUND(Cre.SaldoCapVigente,2)	+ ROUND(Cre.SaldoCapAtrasad,2)  )
			,Entero_Cero),2)
	INTO Var_MontoDeuda
	FROM 	CREDITOFONDEO	Cre
	LEFT OUTER JOIN AMORTIZAFONDEO	Amor  ON (Cre.CreditoFondeoID	= Amor.CreditoFondeoID
		AND Amor.Estatus <> EstatusPagado
		AND Amor.AmortizacionID = Var_AmortizacionID)
	WHERE Cre.CreditoFondeoID	= Par_CreditoFonID;

    SET Var_MontoDeuda := IFNULL(Var_MontoDeuda, Decimal_Cero);


RETURN Var_MontoDeuda;

END$$