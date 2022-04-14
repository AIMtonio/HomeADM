-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASIMPUESTOS
DELIMITER ;
DROP TABLE IF EXISTS `TASASIMPUESTOS`;DELIMITER $$

CREATE TABLE `TASASIMPUESTOS` (
  `TasaImpuestoID` int(11) NOT NULL COMMENT 'ID de la Tabla Tasa Impuestos ISR',
  `Nombre` varchar(45) DEFAULT NULL COMMENT 'Nombre de la Tasa',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion de la Tasa ISR',
  `Valor` decimal(12,2) DEFAULT NULL COMMENT 'Valor de la Tasa',
  `TipoTasa` char(1) DEFAULT 'N' COMMENT 'Indica el Tipo de Tasa ISR.\nN.- Nacional.\nE.- Para Residentes en el Extranjero.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria EmpresaID',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria DireccionIP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria NumTransaccion',
  PRIMARY KEY (`TasaImpuestoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena el Valor de los Impuestos.'$$