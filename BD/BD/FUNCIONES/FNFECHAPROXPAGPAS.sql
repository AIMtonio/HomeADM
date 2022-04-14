-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHAPROXPAGPAS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAPROXPAGPAS`;DELIMITER $$

CREATE FUNCTION `FNFECHAPROXPAGPAS`(
-- FUNCION QUE RETORNA LA FECHA MINIMA EXIGIBLE DE LA AMORTIZACIONES
    Par_CreditoID   BIGINT(12)



) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN

	DECLARE FechaVacia			DATE;
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);

	DECLARE Var_FecProxPago		VARCHAR(20);
	DECLARE Var_FecProxPago2	VARCHAR(20);
	DECLARE Var_FecActual		DATE;


	SET FechaVacia				:= '1900-01-01';
	SET Est_Pagado				:= 'P';
	SET Cadena_Vacia			:= '';

	SET Var_FecActual			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecActual			:= IFNULL(Var_FecActual, FechaVacia);


		SELECT MIN(FechaExigible)
		INTO Var_FecProxPago
		FROM AMORTIZAFONDEO
			WHERE CreditoFondeoID     =  Par_CreditoID
				AND Estatus       <> Est_Pagado;

	SET Var_FecProxPago := IFNULL(Var_FecProxPago, Cadena_Vacia);

    RETURN Var_FecProxPago;

END$$