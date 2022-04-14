-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `SOLBUROCREDITO`;DELIMITER $$

CREATE TABLE `SOLBUROCREDITO` (
  `RFC` varchar(13) NOT NULL COMMENT 'RFC ',
  `FechaConsulta` datetime NOT NULL COMMENT 'Fecha de Consulta\\n',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre\\n',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre\\n',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Paterno',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Estado FK con tabla ESTADOSREPUB',
  `LocalidadID` int(11) DEFAULT NULL,
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'ID del Municipio ',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroExterior` char(10) DEFAULT NULL COMMENT 'Numero exterior',
  `NumeroInterior` char(10) DEFAULT NULL COMMENT 'Numero Interior',
  `Piso` char(10) DEFAULT NULL COMMENT 'Numero de piso',
  `Colonia` varchar(80) DEFAULT NULL COMMENT 'Nombre de la colonia',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `Lote` char(10) DEFAULT NULL COMMENT 'Lote',
  `Manzana` char(10) DEFAULT NULL COMMENT 'Manzana',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha de Nacimiento',
  `FolioConsulta` varchar(30) DEFAULT NULL COMMENT 'Folio de Consulta que devuelve buro',
  `FolioConsultaC` varchar(30) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`RFC`,`NumTransaccion`),
  KEY `fk_SOLBUROCREDITODESTADOS_1_idx` (`EstadoID`),
  CONSTRAINT `fk_SOLBUROCREDITOESTADOS_1` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Solicitud Buro de Credito\n'$$