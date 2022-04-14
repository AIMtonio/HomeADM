-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATMPLITROSCONSUMIDOS
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTATMPLITROSCONSUMIDOS`;
DELIMITER $$

CREATE TABLE `EDOCTATMPLITROSCONSUMIDOS` (
	`CreditoID`			BIGINT(20) NOT NULL COMMENT 'ID del Credito',
	`Consumidos`		DECIMAL(14,2) NOT NULL COMMENT 'Consumo total de litros en un periodo',
	`EmpresaID` 		INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	`Usuario` 			INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	`FechaActual` 		DATETIME NOT NULL COMMENT 'Parametro de Auditoria',
	`DireccionIP` 		VARCHAR(15) NOT NULL COMMENT 'Parametro de Auditoria',
	`ProgramaID` 		VARCHAR(50) NOT NULL COMMENT 'Parametro de Auditoria',
	`Sucursal` 			INT(11) NOT NULL COMMENT 'Parametro de Auditoria',
	`NumTransaccion` 	BIGINT(20) NOT NULL COMMENT 'Parametro de Auditoria',
	PRIMARY KEY(CreditoID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar el Litros consumidos en el periodo de un Credito.'$$
