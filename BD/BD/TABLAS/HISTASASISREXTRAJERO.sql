-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISTASASISREXTRAJERO
DELIMITER ;
DROP TABLE IF EXISTS `HISTASASISREXTRAJERO`;DELIMITER $$

CREATE TABLE `HISTASASISREXTRAJERO` (
  `Fecha` date NOT NULL COMMENT 'Fecha de la Tasa ISR.',
  `PaisID` int(11) NOT NULL COMMENT 'ID del País (TASASISREXTRAJERO).',
  `Valor` decimal(12,2) DEFAULT NULL COMMENT 'Valor Actual de la Tasa.',
  `ValorAnterior` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Valor de la tasa anterior al cambio de tasa.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoría Actual.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoría',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoría.',
  PRIMARY KEY (`Fecha`,`PaisID`),
  KEY `INDEX_HISTASASISREXTRAJERO_1` (`PaisID`),
  KEY `INDEX_HISTASASISREXTRAJERO_2` (`Valor`),
  KEY `INDEX_HISTASASISREXTRAJERO_3` (`Fecha`,`PaisID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Cambios de tasa para el cálculo de ISR para Residentes en el Extranjero.'$$