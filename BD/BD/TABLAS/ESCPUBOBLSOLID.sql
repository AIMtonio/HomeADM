-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCPUBOBLSOLID
DELIMITER ;
DROP TABLE IF EXISTS `ESCPUBOBLSOLID`;DELIMITER $$

CREATE TABLE `ESCPUBOBLSOLID` (
  `OblSolidID` int(11) NOT NULL COMMENT 'Identificador de obligados solidarios',
  `Esc_Tipo` char(1) NOT NULL COMMENT 'Tipo de Acta\nC. Constitutiva\nP. De Poderes   ',
  `NomApoderado` varchar(150) NOT NULL COMMENT 'Nombre del apoderado',
  `RFC_Apoderado` varchar(13) NOT NULL COMMENT 'RFC del Apoderado',
  `EscrituraPublic` varchar(50) NOT NULL COMMENT 'Numero Publico de\n la Escritura Publica',
  `LibroEscritura` varchar(50) NOT NULL COMMENT 'Libro en que se encuentra \nla E.P',
  `FechaEsc` date NOT NULL COMMENT 'Fecha de Escritura\nPublica',
  `VolumenEsc` varchar(20) NOT NULL COMMENT 'Volumen de la EP',
  `EstadoIDEsc` int(11) NOT NULL COMMENT 'Identificacion del estado de la escritura',
  `LocalidadEsc` int(11) NOT NULL COMMENT 'Localidad o Municipio\n(FK)',
  `Notaria` int(11) NOT NULL COMMENT 'Numero de Notari­a\nPublica (FK)\n',
  `DirecNotaria` varchar(240) NOT NULL COMMENT 'Direcc de Notaria\nPublica',
  `NomNotario` varchar(100) NOT NULL COMMENT 'Nombre del \nNotario ',
  `RegistroPub` varchar(10) NOT NULL COMMENT 'Numero de Registro\nPublico',
  `FolioRegPub` varchar(10) NOT NULL COMMENT 'Folio de Registro Publico',
  `VolumenRegPub` varchar(20) NOT NULL COMMENT 'Volumen de Registro Publico',
  `LibroRegPub` varchar(10) NOT NULL COMMENT 'Libro de Registro\nPublico',
  `AuxiliarRegPub` varchar(20) NOT NULL COMMENT 'Auxiliar del registro publico',
  `FechaRegPub` date NOT NULL COMMENT 'Fecha de Registro\n Publico',
  `EstadoIDReg` int(11) NOT NULL COMMENT 'Identificador del estado de registro publico',
  `LocalidadRegPub` int(11) NOT NULL COMMENT 'Localidad de Registro\nPublico (FK)\n',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`OblSolidID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Datos de Escritura Publica de los Obligados Solidarios'$$