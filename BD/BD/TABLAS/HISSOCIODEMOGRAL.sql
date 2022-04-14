-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISSOCIODEMOGRAL
DELIMITER ;
DROP TABLE IF EXISTS `HISSOCIODEMOGRAL`;DELIMITER $$

CREATE TABLE `HISSOCIODEMOGRAL` (
  `ProspectoID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a PROSPECTOS (sin Integridad Relacional)',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Llave Foranea a CLIENTES (Sin Integridad relacional)	',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en que se registraron los datos',
  `FechaHistorico` date DEFAULT NULL COMMENT 'Fecha del pase a Historico',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Consecutivo por Cliente o Prospecto para identificar el  registro que se fue a historico',
  `GradoEscolarID` int(11) DEFAULT NULL COMMENT 'Llave Foranea del Catalogo de Grados Escolares',
  `NumDepenEconomi` int(11) DEFAULT NULL COMMENT 'Numero de Dependientes Economicos',
  `AntiguedadLab` varchar(10) DEFAULT '1900-01-01' COMMENT 'Antiguedad laboral expresada en meses',
  `FechaIniTrabajo` date DEFAULT '1900-01-01' COMMENT 'Fecha de Inicio del trabajo actual',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  KEY `fk_HISSOCIODEMOGRAL_1_idx` (`GradoEscolarID`),
  CONSTRAINT `fk_HISSOCIODEMOGRAL_1` FOREIGN KEY (`GradoEscolarID`) REFERENCES `CATGRADOESCOLAR` (`GradoEscolarID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion Sociodemografica propia del Cliente-Prospecto'$$