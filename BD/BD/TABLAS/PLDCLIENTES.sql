-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCLIENTES
DELIMITER ;
DROP TABLE IF EXISTS `PLDCLIENTES`;DELIMITER $$

CREATE TABLE `PLDCLIENTES` (
  `ClienteIDExt` varchar(20) NOT NULL COMMENT 'Identificador del cliente externo',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente en el SAFI',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ClienteIDExt`),
  KEY `FK_PLDCLIENTES_1` (`ClienteID`),
  CONSTRAINT `FK_PLDCLIENTES_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla alterna a CLIENTES para referencias a los clientes externos al SAFI'$$