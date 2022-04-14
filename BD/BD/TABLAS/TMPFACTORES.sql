-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPFACTORES
DELIMITER ;
DROP TABLE IF EXISTS `TMPFACTORES`;
DELIMITER $$


CREATE TABLE `TMPFACTORES` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Fecha` date DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente',
  `InstrumentoID` int(11) DEFAULT NULL COMMENT 'ID del Instrumento',
  `ProductoID` bigint(12) DEFAULT NULL COMMENT 'ID del Producto',
  `Factor` decimal(14,2) DEFAULT NULL COMMENT 'Factor a Tomar',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Auxiliar para el Calculo del Factor Total de Productos de Captación'$$
