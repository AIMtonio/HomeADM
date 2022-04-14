-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNSALDOINSOLUTOCAL
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSALDOINSOLUTOCAL`;DELIMITER $$

CREATE FUNCTION `FNSALDOINSOLUTOCAL`(
	Par_CreditoID		BIGINT(12),
	Par_FechaCorte		DATE

) RETURNS decimal(18,4)
    DETERMINISTIC
BEGIN

	DECLARE Var_CapitalInsoluto		DECIMAL(18,4);

	SELECT
		SUM(
			IFNULL(SalCapVigente,0) +
			IFNULL(SalCapAtrasado,0) +
			IFNULL(SalCapVencido,0) +
			IFNULL(SalCapVenNoExi,0))
		INTO Var_CapitalInsoluto
	FROM SALDOSCREDITOS
		WHERE CreditoID = Par_CreditoID
			AND FechaCorte <= Par_FechaCorte
		GROUP BY CreditoID;

	SET Var_CapitalInsoluto := IFNULL(Var_CapitalInsoluto, 0.0);

	RETURN Var_CapitalInsoluto;
END$$