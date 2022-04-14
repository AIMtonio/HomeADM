-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNMONTOPAGOCREDITO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNMONTOPAGOCREDITO`;
DELIMITER $$

CREATE FUNCTION `FNMONTOPAGOCREDITO`(
	# Funcion que devuelve el monto pagado del credito de Capital e Interes
	Par_CreditoID 	BIGINT(12),			-- Numero de Credito
	Par_Fecha 		DATE				-- Fecha
) RETURNS DECIMAL(18,4)
		DETERMINISTIC
BEGIN

	DECLARE Var_FechaPago DATE;
	DECLARE Var_Monto DECIMAL(18,2);

	DECLARE Decimal_Cero DECIMAL(18,2);
	DECLARE Est_Pagado 	CHAR(1);

	SET Decimal_Cero 	:= 0.0;
	SET Est_Pagado 		:= 'A';

	SELECT IFNULL(SUM(MontoCapOrd+MontoCapAtr+MontoCapVen+MontoIntOrd+MontoIntAtr+MontoIntVen),Decimal_Cero)
			INTO Var_Monto
		FROM DETALLEPAGCRE
		WHERE CreditoID 	= Par_CreditoID
		  AND FechaPago 	<= Par_Fecha;

	IF IFNULL(Var_Monto,Decimal_Cero)= Decimal_Cero THEN
	BEGIN
		SELECT SUM(Capital+Interes)
			INTO Var_Monto
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			  AND Estatus	= Est_Pagado;
	END;
	END IF;

	RETURN Var_Monto;
END$$