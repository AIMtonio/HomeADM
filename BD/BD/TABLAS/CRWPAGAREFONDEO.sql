-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWPAGAREFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `CRWPAGAREFONDEO`;
DELIMITER $$


CREATE TABLE `CRWPAGAREFONDEO` (
  `AmortizacionID` INT(4) NOT NULL COMMENT 'Numero de la amortizacion',
  `SolFondeoID` BIGINT(20) NOT NULL COMMENT 'Numero de Fondeo',
  `FechaInicio` DATE DEFAULT NULL COMMENT 'Fecha de Inicio de la cuota',
  `FechaVencim` DATE DEFAULT NULL COMMENT 'Fecha de Vencimiento de la cuota',
  `FechaExigible` DATE DEFAULT NULL COMMENT 'Fecha exigible de Pago de la cuota',
  `Capital` DECIMAL(14,2) DEFAULT NULL COMMENT 'Capital',
  `InteresGenerado` DECIMAL(14,2) DEFAULT NULL COMMENT 'Interes a Generar',
  `InteresRetener` DECIMAL(10,2) DEFAULT NULL COMMENT 'Interes a Retener',
  `EmpresaID` INT(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` INT(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` DATETIME DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` VARCHAR(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` VARCHAR(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` INT(11) DEFAULT NULL,
  `NumTransaccion` BIGINT(20) DEFAULT NULL,
  PRIMARY KEY (`AmortizacionID`,`SolFondeoID`),
  KEY `fk_PAGAREFONDEO_1_idx` (`SolFondeoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Table que guarda la tabla de Amortizacion Original del Fondeo de Crowdfounding'$$
