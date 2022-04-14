-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TOTALPRODUCTOS
DELIMITER ;
DROP TABLE IF EXISTS `TOTALPRODUCTOS`;
DELIMITER $$


CREATE TABLE `TOTALPRODUCTOS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ClienteID',
  `InstrumentoID` int(1) DEFAULT NULL COMMENT 'InstrumentoID 2.-Ahorro, 13.-Inversiones, 28.-CEDES',
  `Total` decimal(14,2) DEFAULT NULL COMMENT 'Total Producto',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `Fecha` (`Fecha`),
  KEY `ClienteID` (`ClienteID`),
  KEY `InstrumentoID` (`InstrumentoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP Totales Productos.'$$
