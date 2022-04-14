-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHAPROXPAGAGRO
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAPROXPAGAGRO`;DELIMITER $$

CREATE FUNCTION `FNFECHAPROXPAGAGRO`(
    Par_CreditoID   BIGINT(12)




) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Constantes
	DECLARE FechaVacia			DATE;
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	-- Declaracion de Variables
	DECLARE Var_FecProxPago		VARCHAR(20);
	DECLARE Var_FecProxPago2	VARCHAR(20);
	DECLARE Var_FecActual		DATE;

	-- Asignacion de Constanes
	SET FechaVacia				:= '1900-01-01';
	SET Est_Pagado				:= 'P';
	SET Cadena_Vacia			:= '';
	-- Asignacion de Variables
	SET Var_FecActual			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecActual			:= IFNULL(Var_FecActual, FechaVacia);

	SELECT MIN(FechaExigible)
		INTO Var_FecProxPago
		FROM AMORTICREDITOAGRO
			WHERE CreditoID     =  Par_CreditoID
				AND FechaInicio > Var_FecActual
				AND EstatusDesembolso!='C';

	SET Var_FecProxPago := IFNULL(Var_FecProxPago, Cadena_Vacia);
	IF(Var_FecProxPago = Cadena_Vacia) THEN
		SELECT MIN(FechaExigible)
		INTO Var_FecProxPago
		FROM AMORTICREDITO
			WHERE CreditoID     =  Par_CreditoID
				AND Estatus       <> Est_Pagado;
	END IF;

    RETURN Var_FecProxPago;

END$$