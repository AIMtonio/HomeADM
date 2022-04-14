-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOINTEGRA
DELIMITER ;
DROP TABLE IF EXISTS `ORGANOINTEGRA`;DELIMITER $$

CREATE TABLE `ORGANOINTEGRA` (
  `OrganoID` int(11) NOT NULL,
  `ClavePuestoID` varchar(10) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(11) DEFAULT NULL,
  PRIMARY KEY (`OrganoID`,`ClavePuestoID`),
  KEY `fk_ORGANOINTEGRA_1` (`OrganoID`),
  KEY `fk_ORGANOINTEGRA_2` (`ClavePuestoID`),
  CONSTRAINT `fk_ORGANOINTEGRA_1` FOREIGN KEY (`OrganoID`) REFERENCES `ORGANODESICION` (`OrganoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_ORGANOINTEGRA_2` FOREIGN KEY (`ClavePuestoID`) REFERENCES `PUESTOS` (`ClavePuestoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$