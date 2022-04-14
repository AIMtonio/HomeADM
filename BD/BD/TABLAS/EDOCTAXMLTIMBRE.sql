-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAXMLTIMBRE
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAXMLTIMBRE`;DELIMITER $$

CREATE TABLE `EDOCTAXMLTIMBRE` (
  `AnioMes` int(11) NOT NULL COMMENT 'Fecha de generacion del estado de cuenta',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `Xml` text NOT NULL COMMENT 'Cadena Xml',
  `TipoTimbrado` char(1) NOT NULL COMMENT 'Tipo de timbrado (I=Ingreso, E=Egreso)',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`AnioMes`,`ClienteID`,`TipoTimbrado`),
  KEY `FK_EDOCTAXMLTIMBRE_1` (`ClienteID`),
  KEY `INDEX_EDOCTAXMLTIMBRE_1` (`AnioMes`,`ClienteID`,`TipoTimbrado`),
  CONSTRAINT `FK_EDOCTAXMLTIMBRE_1` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar la cadena xml del cliente'$$