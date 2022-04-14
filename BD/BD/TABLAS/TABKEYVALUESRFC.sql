-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TABKEYVALUESRFC
DELIMITER ;
DROP TABLE IF EXISTS `TABKEYVALUESRFC`;DELIMITER $$

CREATE TABLE `TABKEYVALUESRFC` (
  `KeyTab` varchar(2) CHARACTER SET latin1 COLLATE latin1_bin DEFAULT NULL COMMENT 'Id  de la empresa',
  `ValorAsc` varchar(2) DEFAULT NULL COMMENT 'Id  de la empresa',
  `Tipo` int(11) DEFAULT NULL COMMENT 'Id  de la empresa',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Id  de la empresa',
  `Usuario` varchar(45) DEFAULT NULL COMMENT 'Auditoria\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  KEY `INDEX_TABKEYVALUESRFC_1` (`KeyTab`,`ValorAsc`,`Tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para reemplazar valores AL GENERAR LA HOMOCLAVE'$$