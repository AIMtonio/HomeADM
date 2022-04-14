-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CS_CONSULTANOMBRES
DELIMITER ;
DROP PROCEDURE IF EXISTS `CS_CONSULTANOMBRES`;DELIMITER $$

CREATE PROCEDURE `CS_CONSULTANOMBRES`(
Par_CuentaAhoID BIGINT,
Par_CuentaClabe VARCHAR(20))
BEGIN


DECLARE Var_NombreCompleto VARCHAR (2000);
DECLARE Var_NombreBene VARCHAR(2000);
DECLARE Var_Hora VARCHAR(20);

SELECT NombreCompleto
	INTO Var_NombreCompleto
FROM CLIENTES cl, CUENTASAHO cu
WHERE cl. ClienteID= cu.ClienteID
AND cu.CuentaAhoID= Par_CuentaAhoID;


SELECT Beneficiario
	INTO Var_NombreBene
FROM CUENTASTRANSFER WHERE Clabe LIKE Par_CuentaClabe LIMIT 1;

SET Var_Hora := (SELECT TIME_FORMAT(NOW(), "%H:%i:%s"));

SELECT Var_NombreCompleto, Var_NombreBene, Var_Hora;
END$$