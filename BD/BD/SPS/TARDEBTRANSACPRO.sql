-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBTRANSACPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBTRANSACPRO`;


	INOUT VarNumTrans BIGINT
	)


SELECT (NumeroTransaccion + 1) INTO VarNumTrans
	FROM TARDEBTRANSACCIONES;

UPDATE TARDEBTRANSACCIONES SET
	NumeroTransaccion = NumeroTransaccion + 1;

END TerminaStore$$