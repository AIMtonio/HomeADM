-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCLASCONTAC0922
DELIMITER ;
DROP TABLE IF EXISTS `CATCLASCONTAC0922`;DELIMITER $$

CREATE TABLE `CATCLASCONTAC0922` (
  `ClasContableID` varchar(20) NOT NULL COMMENT 'Id del Tipo de la clasificacion contable',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion de la clasificacion contable',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClasContableID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Clasificacion contable Regulatorio C0922 Gastos de Adminisracion'$$