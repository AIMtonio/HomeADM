-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCARGALISTASPLD
DELIMITER ;
DROP TABLE IF EXISTS `TMPCARGALISTASPLD`;DELIMITER $$

CREATE TABLE `TMPCARGALISTASPLD` (
  `IdListaNegraTemp` bigint(11) NOT NULL AUTO_INCREMENT,
  `Idqeq` varchar(250) DEFAULT NULL COMMENT 'ID de QUIEN ES QUIEN',
  `Nombre` varchar(250) DEFAULT NULL COMMENT 'Nombre completo',
  `Paterno` varchar(250) DEFAULT NULL COMMENT 'Apellido paterno',
  `Materno` varchar(250) DEFAULT NULL COMMENT 'Apellido materno',
  `Curp` varchar(250) DEFAULT NULL COMMENT 'CURP',
  `Rfc` varchar(250) DEFAULT NULL COMMENT 'RFC (Persona fisica)',
  `Fecnac` varchar(250) DEFAULT NULL COMMENT 'Fecha de Nacimiento',
  `Lista` varchar(250) DEFAULT NULL COMMENT 'Tipo de Lista de acuero de Quien es Quien',
  `Estatus` varchar(250) DEFAULT NULL COMMENT 'Estatus de la persona',
  `Dependencia` varchar(250) DEFAULT NULL COMMENT 'Dependencia (Pais, Municipio)',
  `Puesto` varchar(250) DEFAULT NULL COMMENT 'Puesto',
  `Iddispo` varchar(250) DEFAULT NULL COMMENT 'ID',
  `Curpok` varchar(250) DEFAULT NULL COMMENT 'Curp',
  `Idrel` varchar(250) DEFAULT NULL COMMENT 'Id del relacionado',
  `Parentesco` varchar(250) DEFAULT NULL COMMENT 'Parentesco',
  `Razonsoc` varchar(250) DEFAULT NULL COMMENT 'Razón social',
  `Rfcmoral` varchar(250) DEFAULT NULL COMMENT 'RFC de la persona Moral',
  `Issste` varchar(250) DEFAULT NULL COMMENT 'Clave del ISSTE',
  `Imss` varchar(250) DEFAULT NULL COMMENT 'Clave del IMSS',
  `Ingresos` varchar(250) DEFAULT NULL COMMENT 'Ingresos',
  `Nomcomp` varchar(250) DEFAULT NULL COMMENT 'Nombre Completo',
  `Apellidos` varchar(250) DEFAULT NULL COMMENT 'Apellidos del cliente',
  `Entidad` varchar(250) DEFAULT NULL COMMENT 'Entidad de la persona (aplica cuando son del pais Mexico)',
  `Genero` varchar(250) DEFAULT NULL COMMENT 'Genero de la persona',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`IdListaNegraTemp`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para la carga de la información de listas de PLD (Listas Negras y Listas de Personas Bloqueadas)'$$