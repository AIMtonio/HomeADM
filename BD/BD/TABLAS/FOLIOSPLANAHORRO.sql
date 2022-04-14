-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSPLANAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `FOLIOSPLANAHORRO`;
DELIMITER $$

CREATE TABLE `FOLIOSPLANAHORRO` (
  `FolioID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del Folio',
  `ClienteID` int(11) DEFAULT '0' COMMENT 'Identificador del Cliente que adquiere el boleto',
  `CuentaAhoID` bigint(20) DEFAULT '0' COMMENT 'Identificador de la cuenta del Cliente',
  `PlanID` int(11) DEFAULT '0' COMMENT 'Identificador del Plan al que pertenece el Folio',
  `Serie` int(11) DEFAULT '0' COMMENT 'Numero de Serie por Plan de Ahorro',
  `Monto` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto del Folio. Este debe ser el monto base del Plan de Ahorro',
  `Fecha` date DEFAULT '1900-01-01' COMMENT 'Fecha en la que se realiza el registro del Folio',
  `Estatus` char(1) DEFAULT '' COMMENT 'Estatus del Folio. A:Activo, V:Vencido, C:Cancelado',
  `FechaCancela` date DEFAULT '1900-01-01' COMMENT 'Fecha en la que se canela el Folio',
  `UsuarioCancela` varchar(50) DEFAULT '' COMMENT 'Usuario que realiza la cancelacion del Folio',
  `FechaVencimiento` date  DEFAULT '1900-01-01' COMMENT 'Fecha en la que vence el bloqueo' AFTER UsuarioCancela,
  `FechaLiberacion` date  DEFAULT '1900-01-01' COMMENT 'Fecha en la que se libera el bloqueo' AFTER FechaVencimiento,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`FolioID`),
  UNIQUE KEY `FolioID` (`FolioID`),
  KEY `INDEX_FOLIOSPLANAHORRO_1` (`ClienteID`),
  KEY `INDEX_FOLIOSPLANAHORRO_2` (`PlanID`),
  KEY `INDEX_FOLIOSPLANAHORRO_3` (`FechaLiberacion`);
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=latin1 COMMENT='Tab: Almacena los Folios (Boletos) que adquiere cada cliente por Plan de Ahorro'$$