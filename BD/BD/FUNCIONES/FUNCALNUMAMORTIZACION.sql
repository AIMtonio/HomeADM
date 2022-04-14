-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCALNUMAMORTIZACION
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCALNUMAMORTIZACION`;
DELIMITER $$

CREATE FUNCTION `FUNCALNUMAMORTIZACION`(
# =========================================================
# ----- FUNCION QUE REALIZA EL CALCULAR LAS AMORTIZACIONES PAGADAS Y POR FALTA DE PAGAR
# =========================================================
	Par_CreditoID		BIGINT(12),			-- ID del credito
	Par_NumPro			INT(11)				-- Par numero de proceso

) RETURNS INT
	DETERMINISTIC
BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(3);
	DECLARE	Decimal_Cero			DECIMAL(12,4);
	DECLARE	EstatusPagado			CHAR(1);
	DECLARE Num_ConAmorPorPagar		INT(11);			-- Numero de proceso para calcular las amortizaciones por pagar
	DECLARE Num_ConAmorPagado		INT(11);			-- Numero de proceso para calcular las amortizaciones Pagadas

	-- Declaracion de Variables
	DECLARE Var_ConAmortPagado		INT(11);			-- Variable para guardar las amortizacion pagadas
	DECLARE Var_ConAmorPorPagar		INT(11);			-- Variable para guardar las amortizaciones por pagar
	DECLARE Var_NumAmortizacion		INT(11);			-- Variable para guardar los numeros de amortizaciones


	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Decimal_Cero			:= 0;
	SET	EstatusPagado			:= 'P';			-- Constante de estatus pagado
	SET Num_ConAmorPorPagar		:= 1;			-- Numero de proceso para calcular las amortizaciones por pagar
	SET Num_ConAmorPagado		:= 2;			-- Numero de proceso para calcular las amortizaciones Pagadas

	-- Consulta del total de las amortizaciones Pagadas
	IF(Par_NumPro = Num_ConAmorPagado) THEN
		SELECT COUNT(CreditoID)
			INTO Var_ConAmortPagado
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
				AND Estatus = EstatusPagado;

		SET Var_NumAmortizacion		:= Var_ConAmortPagado;
	END IF;

	-- Consultas de los total de amortizaciones por falta de pagar
	IF(Par_NumPro = Num_ConAmorPorPagar) THEN
		SELECT COUNT(CreditoID)
			INTO Var_ConAmorPorPagar
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
				AND Estatus != EstatusPagado;

		SET Var_NumAmortizacion		:= Var_ConAmorPorPagar;
	END IF;


	RETURN Var_NumAmortizacion;
END$$