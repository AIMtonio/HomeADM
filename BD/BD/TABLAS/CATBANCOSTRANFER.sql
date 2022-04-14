-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATBANCOSTRANFER
DELIMITER ;
DROP TABLE IF EXISTS `CATBANCOSTRANFER`;
DELIMITER $$

CREATE TABLE `CATBANCOSTRANFER` (
	`BancoID`				BIGINT(20) COMMENT 'ID del banco',
	`NombreBanco`			VARCHAR(100) COMMENT 'Nombre del Banco',
    `ClaveTransfer`			VARCHAR(50) COMMENT 'Clave de tranferenia del banco',
    `EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`Usuario` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`FechaActual` 			DATETIME DEFAULT NULL COMMENT 'AUDITORIA',
	`DireccionIP` 			VARCHAR(15) DEFAULT NULL COMMENT 'AUDITORIA',
	`ProgramaID` 			VARCHAR(50) DEFAULT NULL COMMENT 'AUDITORIA',
	`Sucursal` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
	`NumTransaccion` 		BIGINT(20) DEFAULT NULL COMMENT 'AUDITORIA',
	PRIMARY KEY (`BancoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='CAT: Catalogo de los bancos para realizar tranferencias'$$
