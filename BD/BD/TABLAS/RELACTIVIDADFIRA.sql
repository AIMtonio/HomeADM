-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACTIVIDADFIRA
DELIMITER ;
DROP TABLE IF EXISTS `RELACTIVIDADFIRA`;DELIMITER $$

CREATE TABLE `RELACTIVIDADFIRA` (
  `CveCadena` int(11) NOT NULL COMMENT 'Clave de la Cadena',
  `CveRamaFIRA` int(11) NOT NULL COMMENT 'Clave de la Rama FIRA',
  `CveSubramaFIRA` int(11) NOT NULL COMMENT 'Clave de Subrama FIRA',
  `CveActividadFIRA` int(11) NOT NULL COMMENT 'Clave de Actividad FIRA',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  KEY `fk_RELACTIVIDADFIRA_1_idx` (`CveCadena`),
  KEY `fk_RELACTIVIDADFIRA_2_idx` (`CveRamaFIRA`),
  KEY `fk_RELACTIVIDADFIRA_3_idx` (`CveActividadFIRA`),
  KEY `fk_RELACTIVIDADFIRA_4_idx` (`CveCadena`,`CveRamaFIRA`,`CveSubramaFIRA`),
  CONSTRAINT `fk_RELACTIVIDADFIRA_1` FOREIGN KEY (`CveCadena`) REFERENCES `CATCADENAPRODUCTIVA` (`CveCadena`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RELACTIVIDADFIRA_2` FOREIGN KEY (`CveRamaFIRA`) REFERENCES `CATRAMAFIRA` (`CveRamaFIRA`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_RELACTIVIDADFIRA_3` FOREIGN KEY (`CveActividadFIRA`) REFERENCES `CATACTIVIDADFIRA` (`CveActividadFIRA`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Relacion de Actividades FIRA'$$