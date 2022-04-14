-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMAPEOCONPASCONT
DELIMITER ;
DROP TABLE IF EXISTS `CATMAPEOCONPASCONT`;DELIMITER $$

CREATE TABLE `CATMAPEOCONPASCONT` (
  `ConceptosFondID` varchar(50) NOT NULL COMMENT 'ID del concepto de fondeo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`ConceptosFondID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$