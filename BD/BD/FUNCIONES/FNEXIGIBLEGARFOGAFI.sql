-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEGARFOGAFI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEGARFOGAFI`;DELIMITER $$

CREATE FUNCTION `FNEXIGIBLEGARFOGAFI`(
  # FUNCION QUE OBTIENE EL EXIGIBLE DE GARANTÍA POR AMORTIZACION Y CRÉDITO
    Par_CreditoID		BIGINT(18),		# Número de Crédito
  Par_AmortizacionID	INT(11)			# Número de Amortización

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN
# Declaracion de Variables
DECLARE Var_MontoExigible 	DECIMAL(14,2);
DECLARE Var_CreEstatus      CHAR(1);

# Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL(14,2);
DECLARE EstatusVigente		CHAR(1);


# Asignacion de Constantes.
SET Cadena_Vacia    := '';              # Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    # Fecha Vacia
SET Entero_Cero     := 0;               # Entero en Cero
SET Decimal_Cero    := 0.00;            # Moneda en Cero
SET EstatusVigente   := 'V';             # Estatus Pagado

SET Var_MontoExigible   := Decimal_Cero;

	# Se obtiene el monto exigible de Garantía FOGAFI de acuerdo a la amortización y al crédito.
    SELECT   ROUND(IFNULL(SaldoFOGAFI, Decimal_Cero), 2)
            INTO Var_MontoExigible
            FROM DETALLEGARFOGAFI
            WHERE CreditoID	=  Par_CreditoID
        AND AmortizacionID 	= Par_AmortizacionID
        AND Estatus      	= EstatusVigente;

    SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero);


RETURN Var_MontoExigible;

END$$