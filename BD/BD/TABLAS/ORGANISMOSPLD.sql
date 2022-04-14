-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANISMOSPLD
DELIMITER ;
DROP TABLE IF EXISTS `ORGANISMOSPLD`;DELIMITER $$

CREATE TABLE `ORGANISMOSPLD` (
  `OrganismoID` char(3) NOT NULL COMMENT 'clave de organismos ',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'descripcion de organismo',
  `TipoOrganismoID` char(2) DEFAULT NULL COMMENT 'cve del tipo de organismo\nSegún catalogo de tipo de organismos ',
  `Nacionalidad` char(4) DEFAULT NULL COMMENT 'cve de nacionalidad del organismo\nSegún catalogo de nacionalidades',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`OrganismoID`),
  KEY `fk_ORGANISMOSPLD_1` (`TipoOrganismoID`),
  CONSTRAINT `fk_ORGANISMOSPLD_1` FOREIGN KEY (`TipoOrganismoID`) REFERENCES `TIPOORGANISPLD` (`TipoOrganismoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='catalogo de organismos a los que puede pertener los PEPs'$$