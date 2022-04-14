-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLAZOSPORPRODUCTOS
DELIMITER ;
DROP TABLE IF EXISTS `HISPLAZOSPORPRODUCTOS`;DELIMITER $$

CREATE TABLE `HISPLAZOSPORPRODUCTOS` (
  `HisPlazoID` int(11) NOT NULL COMMENT 'ID Histórico.',
  `PlazoID` int(11) NOT NULL COMMENT 'ID de PLAZOSPORPRODUCTOS.',
  `Plazo` int(11) NOT NULL COMMENT 'Indica el plazo.',
  `TipoInstrumentoID` int(11) NOT NULL COMMENT 'ID de la tabla TIPOINSTRUMENTOS.',
  `TipoProductoID` int(11) NOT NULL COMMENT 'Indica el tipo de Producto (TIPOSCEDES, TIPOSAPORTACIONES).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`HisPlazoID`),
  KEY `INDEX_HISPLAZOSPORPRODUCTOS_1` (`TipoProductoID`),
  KEY `INDEX_HISPLAZOSPORPRODUCTOS_2` (`TipoInstrumentoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='His: Plazos que se determinen por clientes para CEDES y APORTACIONES.'$$