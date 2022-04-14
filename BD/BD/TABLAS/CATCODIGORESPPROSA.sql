-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCODIGORESPPROSA
DELIMITER ;
DROP TABLE IF EXISTS `CATCODIGORESPPROSA`;DELIMITER $$

CREATE TABLE `CATCODIGORESPPROSA` (
  `CodigoPosID` varchar(2) NOT NULL DEFAULT '' COMMENT 'Codigo de respuesta transacciones POS',
  `Descripcion` varchar(250) DEFAULT NULL COMMENT 'Descripcion del codigo de respuesta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`CodigoPosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Codigos de Respuesta POS PROSA'$$