-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNPRIMERAAMORTNOCUB
DELIMITER ;
DROP FUNCTION IF EXISTS `FNPRIMERAAMORTNOCUB`;DELIMITER $$

CREATE FUNCTION `FNPRIMERAAMORTNOCUB`(
	# Funcion para que obtiene el la fecha de pago de la primer amortizacion no cubierta
		Par_CreditoID BIGINT(12),	-- Numero de Credito
		Par_Fecha DATE				-- Fecha
) RETURNS date
    DETERMINISTIC
BEGIN

	-- DECLARACION DE VARIABLES
  DECLARE Var_FechaPago DATE;
  DECLARE Var_Monto DECIMAL(13,2);

  -- DECLARACION DE CONSTANTES
  DECLARE Fecha_Vacia	DATE;
  DECLARE Est_Atrasado	CHAR(1);
  DECLARE Est_Vencido	CHAR(1);

  -- ASIGNACION DE CONSTANTES
  SET Fecha_Vacia	:= '1900-01-01';	-- Fecha Vacia
  SET Est_Atrasado	:= 'A';				-- Estatus Atrasado
  SET Est_Vencido	:= 'B';				-- Estatus Vencido

	SELECT MIN(FechaExigible) INTO Var_FechaPago
		FROM AMORTICREDITO WHERE CreditoID= Par_CreditoID
        AND ((FechaLiquida > FechaExigible) OR (FechaExigible <> Fecha_Vacia AND FechaLiquida = Fecha_Vacia AND Estatus IN(Est_Atrasado, Est_Vencido)))

		ORDER BY AmortizacionID DESC LIMIT 1;

	SET Var_FechaPago := IFNULL(Var_FechaPago,Fecha_Vacia);

  RETURN Var_FechaPago;
END$$