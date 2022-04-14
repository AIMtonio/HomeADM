-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADOSENVIOSPEI
DELIMITER ;
DROP TABLE IF EXISTS `ESTADOSENVIOSPEI`;DELIMITER $$

CREATE TABLE `ESTADOSENVIOSPEI` (
  `EstadoEnvioID` int(3) NOT NULL COMMENT 'ID del estado de envio',
  `Descripcion` varchar(40) NOT NULL COMMENT 'Descripcion del estado de envio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`EstadoEnvioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de estados de envio spei'$$