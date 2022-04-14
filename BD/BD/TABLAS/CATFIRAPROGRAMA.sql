-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATFIRAPROGRAMA
DELIMITER ;
DROP TABLE IF EXISTS `CATFIRAPROGRAMA`;DELIMITER $$

CREATE TABLE `CATFIRAPROGRAMA` (
  `ClaveProgramaID` int(11) NOT NULL COMMENT 'Clave del Programa ID Interno',
  `CvePrograma` varchar(10) NOT NULL COMMENT 'Clave del Programa FIRA\n',
  `Programa` varchar(60) NOT NULL COMMENT 'Descripción del Programa FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`ClaveProgramaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Programas FIRA'$$