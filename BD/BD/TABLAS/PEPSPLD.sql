-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PEPSPLD
DELIMITER ;
DROP TABLE IF EXISTS `PEPSPLD`;DELIMITER $$

CREATE TABLE `PEPSPLD` (
  `PEPsID` int(11) NOT NULL COMMENT 'Clave de peps',
  `Nombre` varchar(40) DEFAULT NULL COMMENT 'Nombre(s) del peps',
  `Apaterno` varchar(40) DEFAULT NULL COMMENT 'Apellido paterno del peps',
  `Amaterno` varchar(40) DEFAULT NULL COMMENT 'Apellido materno del peps',
  `RFC` varchar(13) DEFAULT NULL COMMENT 'RFC  del peps ( cve de poblacion según pais)',
  `Puesto` varchar(40) DEFAULT NULL COMMENT 'descripcion del puesto de peps, no  es catalogo',
  `Nacionalidad` char(4) DEFAULT NULL COMMENT 'nacionalidad del peps\nSegún catalogo de nacionalidades',
  `OrganismoID` char(3) DEFAULT NULL COMMENT 'Organismo al que pertenece el  peps (SHCP,SE,SEGOB,etc)\nSegún catalogo de organismos',
  `FechaBaja` date DEFAULT NULL COMMENT 'fecha de baja del peps en dicho organismo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'V=Vigente, B=Baja',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PEPsID`),
  KEY `fk_PEPSPLD_2` (`OrganismoID`),
  KEY `fk_PEPSPLD_1` (`OrganismoID`),
  CONSTRAINT `fk_PEPSPLD_1` FOREIGN KEY (`OrganismoID`) REFERENCES `ORGANISMOSPLD` (`OrganismoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de personas politicamente expuestas'$$