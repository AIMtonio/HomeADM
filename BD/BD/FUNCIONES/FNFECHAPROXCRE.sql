-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNFECHAPROXCRE
DELIMITER ;
DROP FUNCTION IF EXISTS `FNFECHAPROXCRE`;DELIMITER $$

CREATE FUNCTION `FNFECHAPROXCRE`(
/*FUNCION PARA CALCULAR LAS FECHAS DE VENCIMIENTO DEL ANALITICO AGRO*/
    Par_CreditoID   BIGINT(12), -- CreditoID
    Par_Fecha 		DATE        -- Fecha
) RETURNS varchar(20) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion de Constantes
	DECLARE FechaVacia			DATE;
	DECLARE Est_Pagado			CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	-- Declaracion de Variables
	DECLARE Var_FecProxPago		VARCHAR(20); -- Fecha Proximo Pago
	DECLARE Var_FecProxPago2	VARCHAR(20); -- Fecha Proximo Pago
	DECLARE Var_FecActual		DATE;		 -- Fecha Actual

	-- Asignacion de Constanes
	SET FechaVacia				:= '1900-01-01'; -- Fecha Vacia
	SET Est_Pagado				:= 'P';			 -- Estatus de Pago
	SET Cadena_Vacia			:= '';			 -- Cadena Vacia

	-- Asignacion de Variables
	SET Var_FecActual			:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FecActual			:= IFNULL(Var_FecActual, FechaVacia);

	SET Var_FecProxPago := IFNULL(Var_FecProxPago, Cadena_Vacia);
	/*CONSULTA PARA CALCULAR LA PROXIMA FECHA DE PAGO*/
    IF(Var_FecProxPago = Cadena_Vacia) THEN
		SELECT MIN(FechaVencim)
		INTO Var_FecProxPago
		FROM AMORTICREDITO
			WHERE CreditoID     =  Par_CreditoID
				AND Estatus       <> Est_Pagado;

	END IF;

    RETURN Var_FecProxPago;

END$$