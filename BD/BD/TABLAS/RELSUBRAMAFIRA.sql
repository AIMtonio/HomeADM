-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELSUBRAMAFIRA
DELIMITER ;
DROP TABLE IF EXISTS `RELSUBRAMAFIRA`;DELIMITER $$

CREATE TABLE `RELSUBRAMAFIRA` (
  `CveCadena` int(11) NOT NULL COMMENT 'Clave de la Cadena',
  `CveRamaFIRA` int(11) NOT NULL COMMENT 'Clave de la Rama FIRA',
  `CveSubramaFIRA` int(11) NOT NULL COMMENT 'Clave de Subrama FIRA',
  `DescSubramaFIRA` varchar(100) NOT NULL COMMENT 'Descripcion de la Subrama FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveSubramaFIRA`,`CveRamaFIRA`,`CveCadena`),
  KEY `FK_RELSUBRAMAFIRA_1_idx` (`CveCadena`),
  KEY `FK_RELSUBRAMAFIRA_2_idx` (`CveRamaFIRA`),
  CONSTRAINT `FK_RELSUBRAMAFIRA_1` FOREIGN KEY (`CveCadena`) REFERENCES `CATCADENAPRODUCTIVA` (`CveCadena`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_RELSUBRAMAFIRA_2` FOREIGN KEY (`CveRamaFIRA`) REFERENCES `CATRAMAFIRA` (`CveRamaFIRA`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Relacion de Cadena Productiva, Rama FIRA y Subrama FIRA'$$