-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSDIOT
DELIMITER ;
DROP TABLE IF EXISTS `PARAMETROSDIOT`;DELIMITER $$

CREATE TABLE `PARAMETROSDIOT` (
  `ImpuestoID` int(11) NOT NULL COMMENT 'Clave',
  `IVA` int(11) DEFAULT NULL COMMENT 'Numero de Impuesto asignado al IVA',
  `RetIVA` int(11) DEFAULT NULL COMMENT 'Numero de Impuesto asignado a la Retecion de IVA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ImpuestoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los impuestos de la DIOT'$$