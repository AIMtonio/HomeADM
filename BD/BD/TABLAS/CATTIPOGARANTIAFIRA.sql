-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOGARANTIAFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOGARANTIAFIRA`;DELIMITER $$

CREATE TABLE `CATTIPOGARANTIAFIRA` (
  `TipoGarantiaID` int(11) NOT NULL COMMENT 'Clave Tipo de Garantia',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion de la Garantia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`TipoGarantiaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipo de Garantias FIRA'$$