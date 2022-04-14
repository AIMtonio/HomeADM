-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSACCIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSACCIONESPRO`;

DELIMITER $$
CREATE PROCEDURE `TRANSACCIONESPRO`(
	OUT VarNumTrans BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Transaccion		BIGINT(20);

	-- Declaracion de Constantes
	DECLARE Entero_Uno			INT(11);		-- Entero Uno

	-- Asignacion de Constantes
	SET Entero_Uno				:= 1;

	SELECT	NumeroTransaccion
	INTO Var_Transaccion
	FROM TRANSACCIONES
	FOR UPDATE;

	UPDATE TRANSACCIONES SET NumeroTransaccion = LAST_INSERT_ID(NumeroTransaccion + Entero_Uno);

	SET VarNumTrans := (SELECT LAST_INSERT_ID());

END TerminaStore$$