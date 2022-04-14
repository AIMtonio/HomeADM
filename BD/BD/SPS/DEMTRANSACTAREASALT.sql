-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMTRANSACTAREASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMTRANSACTAREASALT`;DELIMITER $$

CREATE PROCEDURE `DEMTRANSACTAREASALT`(
	-- SP para actualizar el identificador de ejecucion de una tarea ejecutada por el Demonio
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_NumTran 			CHAR(20);	-- NUMERO DE TRANSACCION QUE PROVIENE DE LA TABLA DEMTRANSACTAREAS
	DECLARE Var_IncNum				CHAR(12);	-- EL NUMERO INCREMENTAL DE LA TRANSACCION (LOS ULTIMOS 12 DIGITOS)
	DECLARE Var_FechaTran			CHAR(8);	-- FECHA DE LA TRANSACCION (PRIMEROS 8 DIGITOS DEL NUMERO DE TRANSACCION)
	DECLARE Var_SigNumTran			CHAR(20);	-- NUEVO NÚMERO DE TRANSACCION

	SET	Var_IncNum	= '000000000001';

	START TRANSACTION;

		SET Var_NumTran := (SELECT Transacciones FROM DEMTRANSACTAREAS);
		SET Var_FechaTran := (SUBSTRING(Var_NumTran,1,8));

		IF(ISNULL(Var_NumTran))THEN
			INSERT INTO DEMTRANSACTAREAS VALUES(CONCAT(CURDATE()+0,LPAD(Var_IncNum,12,'0')));
		END IF;

		IF(Var_FechaTran != curdate()+0) THEN
			SET Var_SigNumTran = CONCAT(CURDATE()+0,LPAD(Var_IncNum,12,'0'));
			UPDATE DEMTRANSACTAREAS SET Transacciones = Var_SigNumTran;
		END IF;

		IF(Var_FechaTran = curdate()+0) THEN
			SET Var_IncNum = (CAST(CAST(SUBSTRING(Var_NumTran,9,20) AS SIGNED)+1 AS CHAR));
			SET Var_SigNumTran = CONCAT(CURDATE()+0,LPAD(Var_IncNum,12,'0'));
			UPDATE DEMTRANSACTAREAS SET Transacciones = Var_SigNumTran;
		END IF;

		SELECT Transacciones FROM	DEMTRANSACTAREAS;

	COMMIT;

END TerminaStore$$