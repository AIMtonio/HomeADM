DELIMITER ;
DROP FUNCTION IF EXISTS FNFECHAPROXPAGO;

DELIMITER $$
CREATE FUNCTION `FNFECHAPROXPAGO`(
	-- Fuction: Que Retorna la fecha proximo pago de un credito utilizado en el SP-CRECALCULOSALDOSPRO
	-- Modulo Extraccion Proceso Batch Nocturno
	Par_CreditoID   BIGINT(12)	-- ID Del Credito

) RETURNS DATE
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_FecProxPago		DATE;			-- Fecha Proximo Pago
	DECLARE Var_FecActual		DATE;			-- Fecha Actual del Sistema

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;			-- Fecha Vacia
	DECLARE Est_Pagado			CHAR(1);		-- Estatus Pagado
	DECLARE Entero_Cero			INT(11);		-- Entero Cero

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Est_Pagado				:= 'P';
	SET Var_FecActual			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecActual			:= IFNULL(Var_FecActual, Fecha_Vacia);

	SELECT	MIN(FechaExigible)
	INTO Var_FecProxPago
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoID
	  AND Estatus  <> Est_Pagado
      AND FechaExigible >= Var_FecActual;

	SET Var_FecProxPago := IFNULL(Var_FecProxPago, Fecha_Vacia);

	RETURN Var_FecProxPago;

END$$