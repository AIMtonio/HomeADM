-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TRANSACCIONESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TRANSACCIONESALT`;

DELIMITER $$
CREATE PROCEDURE `TRANSACCIONESALT`(
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_NumTransaccion	BIGINT(20);	-- Numero de Transaccion

	-- Declaracion de Constantes
	DECLARE Entero_Uno			INT(11);	-- Entero Uno

	-- Asignacion de Constantes
	SET Entero_Uno				:= 1;

	SELECT	NumeroTransaccion INTO Var_NumTransaccion
	FROM TRANSACCIONES
	FOR UPDATE;

	UPDATE TRANSACCIONES SET NumeroTransaccion = LAST_INSERT_ID(NumeroTransaccion + Entero_Uno);

	SELECT LAST_INSERT_ID() AS NumeroTransaccion;

END TerminaStore$$