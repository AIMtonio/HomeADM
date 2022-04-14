-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONFECHAEXIGIBLECRED
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONFECHAEXIGIBLECRED`;
DELIMITER $$

CREATE FUNCTION `FUNCIONFECHAEXIGIBLECRED`(
# =========================================================
# ----- FUNCION QUE REALIZA EL CALCULO DEL LA FECHA  EXIFIBLE DEL CREDITO
# =========================================================
	Par_CreditoID		BIGINT(12) -- ID del credito

) RETURNS DATE
	DETERMINISTIC
BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,4);
	DECLARE	EstatusPagado	CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_FechaExigible		DATE;

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0;
	SET	EstatusPagado		:= 'P';

	-- Asignacion de Variables consultando la fecha del sistema
	SELECT FechaSistema INTO Var_FechaSistema
		FROM PARAMETROSSIS;

	SELECT MIN(FechaExigible)
		INTO Var_FechaExigible
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID
			AND FechaExigible >= Var_FechaSistema
			AND Estatus != EstatusPagado;

	RETURN Var_FechaExigible;
END$$