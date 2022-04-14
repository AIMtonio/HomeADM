-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEIVAACCESORIOS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEIVAACCESORIOS`;DELIMITER $$

CREATE FUNCTION `FNEXIGIBLEIVAACCESORIOS`(
-- ===================================================================================
-- FUNCION QUE DEVUELVE EL ADEUDO DE IVA DE LOS ACCESORIOS DE UN CREDITO
-- ===================================================================================
Par_CreditoID 		BIGINT(12),			# Numero de Credito
    Par_AmortizacionID	INT(11),			# Numero de Amortizacion
    Par_MontoIVA		DECIMAL(12,2),		# Monto de IVA
    Par_PagaIVA			CHAR(1)				# Indica si el cliente paga IVA
  ) RETURNS decimal(12,2)
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_Monto DECIMAL(12,2);

	-- Declaracion de Constantes
    DECLARE Decimal_Cero	DECIMAL(12,2);
    DECLARE Cons_SI			CHAR(1);

    -- Asignacion de Constantes
    SET Decimal_Cero 	:= 0.00;	-- Constantes DECIMAL Cero
    SET Cons_SI			:= 'S';		-- Constante SI

	IF(Par_PagaIVA = Cons_SI)THEN
		SELECT SUM(CASE WHEN CobraIVA =Cons_SI THEN ROUND((SaldoVigente + SaldoAtrasado)*Par_MontoIVA,2) ELSE Decimal_Cero END)
			INTO Var_Monto
		FROM DETALLEACCESORIOS Det
		WHERE Det.CreditoID = Par_CreditoID
		AND Det.AmortizacionID = Par_AmortizacionID
		GROUP BY Det.AmortizacionID;

		SET Var_Monto := IFNULL(Var_Monto, Decimal_Cero);

	ELSE
		SET Var_Monto := Decimal_Cero;
    END IF;


  RETURN Var_Monto;
  END$$