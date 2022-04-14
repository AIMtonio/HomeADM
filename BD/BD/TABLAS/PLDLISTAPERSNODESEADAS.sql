-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDLISTAPERSNODESEADAS
DELIMITER ;
DROP TABLE IF EXISTS `PLDLISTAPERSNODESEADAS`;
DELIMITER $$

CREATE TABLE `PLDLISTAPERSNODESEADAS` (
  `PersNoDeseadaID` bigint(11) NOT NULL COMMENT 'PersNoDeseadaID',
  `PrimerNombre` varchar(50) DEFAULT NULL COMMENT 'Primer Nombre',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre',
  `ApellidoPaterno` varchar(50) DEFAULT NULL COMMENT 'ApellidoPaterno',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'ApellidoMaterno',
  `CURP` char(18) DEFAULT NULL COMMENT 'Campo para almacenar la CURP de la persona',
  `RFC` char(13) DEFAULT NULL COMMENT 'Campo para almacena el RFC de la persona',
  `FechaNacimiento` date DEFAULT NULL COMMENT 'Fecha de nacimiento de la persona',
  `FechaAlta` date DEFAULT NULL COMMENT 'Fecha en que se dio de alta a la persona en la lista',
  `FechaBaja` date DEFAULT NULL COMMENT 'Fecha de baja del cliente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus en el que se encuentra la persona (Activo-A o Inactivo-I), este estatus inactivo es el equivalente a la baja ya que no se deberá borrar información del sistema',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PersNoDeseadaID`),
  KEY `IDX_PLDLISTAPERSNODESEADAS_01` (`RFC`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para Lista de Personas No Deseadas.'$$
