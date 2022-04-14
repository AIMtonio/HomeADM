-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATALOGONIVELES
DELIMITER ;
DROP TABLE IF EXISTS `CATALOGONIVELES`;DELIMITER $$

CREATE TABLE `CATALOGONIVELES` (
  `NivelID` int(11) NOT NULL COMMENT 'ID y PK de la tabla ',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Concepto o descripcion de nivel',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de auditoria',
  PRIMARY KEY (`NivelID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de niveles de Cuenta'$$