-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOPERCEPCION
DELIMITER ;
DROP TABLE IF EXISTS `CATTIPOPERCEPCION`;DELIMITER $$

CREATE TABLE `CATTIPOPERCEPCION` (
  `TipoPercepcionID` int(11) NOT NULL COMMENT 'Id del Tipo de Percepcion',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion del tipo de Percepcion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria\n',
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoPercepcionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipo de Percepcion'$$