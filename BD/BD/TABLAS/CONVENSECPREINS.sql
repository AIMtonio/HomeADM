-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONVENSECPREINS
DELIMITER ;
DROP TABLE IF EXISTS `CONVENSECPREINS`;DELIMITER $$

CREATE TABLE `CONVENSECPREINS` (
  `ConvenPreID` bigint(20) NOT NULL COMMENT 'ID de las preinscripciones seccionales',
  `NoTarjeta` char(16) NOT NULL COMMENT 'Número de tarjeta de debito',
  `NoSocio` int(11) NOT NULL COMMENT 'Número de socio',
  `NombreCompleto` varchar(200) NOT NULL COMMENT 'Nombre completo del cliente',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha del registro',
  `FechaAsamblea` date NOT NULL COMMENT 'Fecha de la asamblea',
  `TipoRegistro` varchar(30) NOT NULL COMMENT 'PAG(Preinscripcion asamblea general), PAS(preinscripcion asamblea seccional)',
  `SucursalID` int(11) NOT NULL COMMENT 'El ID de la sucursal',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConvenPreID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los socios preinscritos a las asambleas.'$$