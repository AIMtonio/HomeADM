DELIMITER ;
DROP TABLE IF EXISTS `SISLIBERACIONES`;
DELIMITER $$
CREATE TABLE `SISLIBERACIONES` (
  `Folio` bigint(20) NOT NULL COMMENT 'Folio SISLIBERACIONES que se pide a QA',
  `FolDes` bigint(20) NOT NULL COMMENT 'Folio del Desarrollo que se toma del control de Folios',
  `Responsable` varchar(150) NOT NULL COMMENT 'Nombre del líder de la liberacion, Primer Nombre y Primer Apellido',
  `NombreDesarrollo` varchar(300) NOT NULL COMMENT 'Nombre de la carta, numero de ticket(s) o correcciones de la liberacion',
  `Version` varchar(100) NOT NULL COMMENT 'Version para la que va a ser instalada(Ejemplo: 1.72.0), preguntar a QA)',
  `FechaEntregaQA` datetime NOT NULL COMMENT 'Fecha en la que se realizo la mezcla de la liberacion',
  `FechaInstalacion` datetime NOT NULL COMMENT 'Fecha en la que se realizo la instalacion de la liberacion poner NOW',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Folio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el historial de las liberaciones realizadas para el ambiente Principal.'$$