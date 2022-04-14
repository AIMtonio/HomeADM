-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_ACCESORIOS_BAJ
DELIMITER ;
DROP TABLE IF EXISTS `TMP_ACCESORIOS_BAJ`;DELIMITER $$

CREATE TABLE `TMP_ACCESORIOS_BAJ` (
  `AccesorioID` int(11) DEFAULT NULL COMMENT 'ID del Accesorio',
  `ConceptoCarID` int(11) DEFAULT NULL COMMENT 'ID del Concepto de Cartera',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `TMP_ACCESORIOS_BAJ_IDX` (`AccesorioID`,`ConceptoCarID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: guarda el respaldo de DETALLEACCESORIOS. Utilizado para la reversa de pago de accesorios.'$$