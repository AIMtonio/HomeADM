-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLECREGARFOGAFI
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLECREGARFOGAFI`;

DELIMITER $$
CREATE FUNCTION `FNEXIGIBLECREGARFOGAFI`(
	-- Función para obtener el total de adeudo de fogafi de un Credito al Dia
	Par_CreditoID		BIGINT(12),	-- Numero de Credito
	Par_Fecha			DATE		-- Fecha de Consulta
) RETURNS DECIMAL(14,2)
	DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_MontoExigible 	DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Vacio
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal Vacio
	DECLARE Est_Pagado			CHAR(1);		-- Constante Estatus Pagado

	-- Asignacion de Contantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Est_Pagado				:= 'P';

	SET Var_MontoExigible   := Decimal_Cero;

	SELECT   SUM(ROUND(IFNULL(Det.SaldoFOGAFI, Decimal_Cero), 2))
	INTO Var_MontoExigible
	FROM DETALLEGARFOGAFI Det
	WHERE Det.CreditoID = Par_CreditoID
	  AND Det.Estatus != Est_Pagado
	  AND Det.FechaPago <= Par_Fecha;

	SET Var_MontoExigible = IFNULL(Var_MontoExigible, Decimal_Cero);

	RETURN Var_MontoExigible;

END$$