-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCALCRECLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `TMPCALCRECLIENTE`;DELIMITER $$

CREATE TABLE `TMPCALCRECLIENTE` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de cliente',
  `NumCreditos` int(11) DEFAULT NULL COMMENT 'Numero de creditos liquidados de un cliente',
  `PagoCredAntes` decimal(12,2) DEFAULT NULL COMMENT ' % de creditos pagados antes de la fecha de vencimiento',
  `PagoCredEn` decimal(12,2) DEFAULT NULL COMMENT ' % de creditos pagados en la fecha de vencimiento',
  `PagoCredDesp` decimal(12,2) DEFAULT NULL COMMENT ' % de creditos pagados despues de la fecha de vencimiento',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena datos temporales para calcular numeros de credito p'$$