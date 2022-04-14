-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCODIGORESPEQSAFI
DELIMITER ;
DROP TABLE IF EXISTS `CATCODIGORESPEQSAFI`;DELIMITER $$

CREATE TABLE `CATCODIGORESPEQSAFI` (
  `CodigoSAFI` varchar(3) NOT NULL DEFAULT '' COMMENT 'Codigo de respuesta SAFI',
  `Descripcion` varchar(250) DEFAULT NULL COMMENT 'Descripcion',
  `CodigoProsaID` varchar(2) DEFAULT NULL COMMENT 'Codigo de respuesta transacciones POS',
  `CodigoEnturaID` varchar(3) DEFAULT NULL COMMENT 'Codigo de respuesta transacciones ENTURA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`CodigoSAFI`),
  KEY `CodigoPosID` (`CodigoProsaID`),
  KEY `CodigoEnturaID` (`CodigoEnturaID`),
  CONSTRAINT `CATCODIGORESPEQSAFI_ibfk_1` FOREIGN KEY (`CodigoProsaID`) REFERENCES `CATCODIGORESPPROSA` (`CodigoPosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Equivalencias de Codigos SAFI PROSA - ENTURA'$$