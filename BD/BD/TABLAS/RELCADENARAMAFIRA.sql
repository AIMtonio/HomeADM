-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELCADENARAMAFIRA
DELIMITER ;
DROP TABLE IF EXISTS `RELCADENARAMAFIRA`;DELIMITER $$

CREATE TABLE `RELCADENARAMAFIRA` (
  `CveCadena` int(11) NOT NULL COMMENT 'Clave de la Cadena',
  `CveRamaFIRA` int(11) NOT NULL COMMENT 'Clave de la Rama FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CveCadena`,`CveRamaFIRA`),
  KEY `INDEX_RELCADENARAMAFIRA_1` (`CveCadena`),
  KEY `INDEX_RELCADENARAMAFIRA_2` (`CveRamaFIRA`),
  CONSTRAINT `FK_RELCADENARAMAFIRA_1` FOREIGN KEY (`CveCadena`) REFERENCES `CATCADENAPRODUCTIVA` (`CveCadena`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_RELCADENARAMAFIRA_2` FOREIGN KEY (`CveRamaFIRA`) REFERENCES `CATRAMAFIRA` (`CveRamaFIRA`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Relacion de Cadena con la Rama Fira'$$