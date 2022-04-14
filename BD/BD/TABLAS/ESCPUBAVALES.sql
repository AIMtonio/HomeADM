-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCPUBAVALES
DELIMITER ;
DROP TABLE IF EXISTS `ESCPUBAVALES`;DELIMITER $$

CREATE TABLE `ESCPUBAVALES` (
  `AvalID` int(11) NOT NULL,
  `Esc_Tipo` char(1) DEFAULT NULL COMMENT 'Tipo de Acta\nC. Constitutiva\nP. De Poderes   ',
  `NomApoderado` varchar(150) DEFAULT NULL,
  `RFC_Apoderado` varchar(13) DEFAULT NULL COMMENT 'RFC del Apoderado',
  `EscrituraPublic` varchar(50) DEFAULT NULL COMMENT 'Numero Publico de\n la Escritura Publica',
  `LibroEscritura` varchar(50) DEFAULT NULL COMMENT 'Libro en que se encuentra \nla E.P',
  `FechaEsc` date DEFAULT NULL COMMENT 'Fecha de Escritura\nPública',
  `VolumenEsc` varchar(20) DEFAULT NULL COMMENT 'Volumen de la EP',
  `EstadoIDEsc` int(11) DEFAULT NULL,
  `LocalidadEsc` int(11) DEFAULT NULL COMMENT 'Localidad o Municipio\n(FK)',
  `Notaria` int(11) DEFAULT NULL COMMENT 'Número de Notaría\nPública (FK)\n',
  `DirecNotaria` varchar(150) DEFAULT NULL COMMENT 'Direcc de Notaría\nPública',
  `NomNotario` varchar(100) DEFAULT NULL COMMENT 'Nombre del \nNotario ',
  `RegistroPub` varchar(10) DEFAULT NULL COMMENT 'Número de Registro\nPúblico',
  `FolioRegPub` varchar(10) DEFAULT NULL COMMENT 'Folio de Registro Público',
  `VolumenRegPub` varchar(20) DEFAULT NULL COMMENT 'Volumen de Registro Público',
  `LibroRegPub` varchar(10) DEFAULT NULL COMMENT 'Libro de Registro\nPúblico',
  `AuxiliarRegPub` varchar(20) DEFAULT NULL,
  `FechaRegPub` date DEFAULT NULL COMMENT 'Fecha de Registro\n Público',
  `EstadoIDReg` int(11) DEFAULT NULL,
  `LocalidadRegPub` int(11) DEFAULT NULL COMMENT 'Localidad de Registro\nPúblico (FK)\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`AvalID`),
  KEY `fk_ESCPUBAVALES_1` (`Notaria`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Datos de Escritura Publica de los Avales'$$