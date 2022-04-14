-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATRAMAFIRA
DELIMITER ;
DROP TABLE IF EXISTS `CATRAMAFIRA`;DELIMITER $$

CREATE TABLE `CATRAMAFIRA` (
  `CveRamaFIRA` int(11) NOT NULL COMMENT 'Clave de la Rama FIRA',
  `DescripcionRamaFIRA` varchar(30) NOT NULL COMMENT 'Descripción de Rama FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveRamaFIRA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Ramas FIRA'$$