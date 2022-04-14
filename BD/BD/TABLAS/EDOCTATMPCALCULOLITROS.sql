-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATMPCALCULOLITROS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATMPCALCULOLITROS`;
DELIMITER $$

CREATE TABLE `EDOCTATMPCALCULOLITROS` (
	`CreditoID`			BIGINT(20) NOT NULL COMMENT 'ID del Credito',
	`Meta`				DECIMAL(14,2) NOT NULL COMMENT 'Litros Consumidos del Vehiculo',
	`Total`				DECIMAL(14,2) NOT NULL COMMENT 'Total de litros',
	`EmpresaID` 		INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 			INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 		DATETIME NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 		VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 		VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 			INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 	BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY(CreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar el calculo del Litros meta y Total de litros de un Credito.'$$
