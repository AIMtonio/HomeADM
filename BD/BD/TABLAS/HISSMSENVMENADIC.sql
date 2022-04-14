-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSMSENVMENADIC
DELIMITER ;
DROP TABLE IF EXISTS `HISSMSENVMENADIC`;DELIMITER $$

CREATE TABLE `HISSMSENVMENADIC` (
  `EnvioID` int(11) NOT NULL COMMENT 'ID de Envio',
  `CuentaAsociada` varchar(20) DEFAULT NULL COMMENT 'Cuenta asociada',
  `NumeroCliente` varchar(20) DEFAULT NULL COMMENT 'Numero de cliente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`EnvioID`),
  KEY `INDEX_HISSMSENVMENADIC_1` (`EnvioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Historico de Informacion Adicional de envios de SMS'$$