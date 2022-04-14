-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHAULTVENC
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAULTVENC`;DELIMITER $$

CREATE FUNCTION `FNFECHAULTVENC`(
/*Función para obtener la última fecha de vencimiento.*/
    Par_CreditoID   BIGINT(12)


) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- DECLARACION DE CONSTANTES
	DECLARE FechaVacia          DATE;
	DECLARE Est_Pagado          CHAR(1);
	-- DECLARACION DE VARIABLES
	DECLARE Var_FecProxPago     VARCHAR(20);
	DECLARE Var_FecActual       DATE;

	-- ASIGNACION DE CONSTANTES
	SET FechaVacia              := '1900-01-01';
	SET Est_Pagado              := 'P';

	-- ASIGNACION DE VARIABLES
	SET Var_FecActual           := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecActual           := IFNULL(Var_FecActual, FechaVacia);

	SELECT MAX(FechaVencim)
	    INTO Var_FecProxPago
	FROM AMORTICREDITO
	WHERE CreditoID     =  Par_CreditoID
	  AND Estatus <>'V'
	 GROUP BY CreditoID;

	RETURN Var_FecProxPago;

END$$