-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAVALFIRASP
DELIMITER ;
DROP TABLE IF EXISTS `TMPAVALFIRASP`;DELIMITER $$

CREATE TABLE `TMPAVALFIRASP` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID del Cliente Asociado al Aval',
  `AvalID` int(11) DEFAULT NULL COMMENT 'Numero de Aval',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo',
  `RFC` char(13) DEFAULT NULL COMMENT 'RFC',
  `AvalID2` int(11) DEFAULT NULL COMMENT 'Numero de Aval',
  `NombreCompleto2` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo',
  `RFC2` char(13) DEFAULT NULL COMMENT 'RFC',
  `AvalID3` int(11) DEFAULT NULL COMMENT 'Numero de Aval',
  `NombreCompleto3` varchar(200) DEFAULT NULL COMMENT 'Nombre Completo',
  `RFC3` char(13) DEFAULT NULL COMMENT 'RFC',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para los avales para el reporte SP FIRa'$$