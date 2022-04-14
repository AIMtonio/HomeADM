
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITPLDOPEINTPREO
DELIMITER ;
DROP TABLE IF EXISTS `BITPLDOPEINTPREO`;

DELIMITER $$
CREATE TABLE `BITPLDOPEINTPREO` (
  `RegistroID` bigint(20) UNSIGNED AUTO_INCREMENT COMMENT 'ID de la Bitácora.',
  `FechaGeneracion` date DEFAULT NULL COMMENT 'Fecha de Generación del Reporte.',
  `NombreReporte` varchar(200) DEFAULT NULL COMMENT 'Nombre del Reporte Generado.',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que Genera el Reporte.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria.',
  PRIMARY KEY (`RegistroID`),
  KEY `IDX_BITPLDOPEINTPREO_001` (`FechaGeneracion`),
  KEY `IDX_BITPLDOPEINTPREO_002` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bit: Bitácora de Generación del Reporte de Operaciones Internas preocupantes reportadas.'$$

