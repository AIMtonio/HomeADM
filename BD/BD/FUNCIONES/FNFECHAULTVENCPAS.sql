-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHAULTVENCPAS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAULTVENCPAS`;DELIMITER $$

CREATE FUNCTION `FNFECHAULTVENCPAS`(
-- FUNCION QUE RETORNA LA FECHA MAXIMA DE VENCIMIENTO DE LA AMORTIZAFONDEO
    Par_CreditoID   BIGINT(12)


) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN

	DECLARE FechaVacia          DATE;
	DECLARE Est_Pagado          CHAR(1);

	DECLARE Var_FecProxPago     VARCHAR(20);
	DECLARE Var_FecActual       DATE;


	SET FechaVacia              := '1900-01-01';
	SET Est_Pagado              := 'P';


	SET Var_FecActual           := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecActual           := IFNULL(Var_FecActual, FechaVacia);

	SELECT MAX(FechaVencimiento)
	    INTO Var_FecProxPago
	FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID     =  Par_CreditoID
	  AND Estatus <>'V'
	 GROUP BY CreditoFondeoID;

	RETURN Var_FecProxPago;

END$$