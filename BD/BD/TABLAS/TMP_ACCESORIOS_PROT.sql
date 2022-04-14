-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_ACCESORIOS_PROT
DELIMITER ;
DROP TABLE IF EXISTS `TMP_ACCESORIOS_PROT`;DELIMITER $$

CREATE TABLE `TMP_ACCESORIOS_PROT` (
  `AccesorioID` int(11) DEFAULT NULL COMMENT 'ID del Accesorio',
  `NombreCorto` varchar(20) DEFAULT NULL COMMENT 'Nombre del Accesorio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `TMP_ACCESORIOS_PROT_IDX` (`AccesorioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Almacena los accesorios que ya están en uso y no pueden ser eliminados.'$$