-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARACION
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBACLARACION`;DELIMITER $$

CREATE TABLE `TARDEBACLARACION` (
  `ReporteID` bigint(20) NOT NULL COMMENT 'Llave Primaria para el registro de las aclaraciones',
  `TipoAclaraID` int(11) DEFAULT NULL COMMENT 'Tipo de Aclaración que se registro',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta a la cual se le genera el registro de la aclaración',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Institución donde se tuvo el problema',
  `OpeAclaraID` int(11) DEFAULT NULL COMMENT 'Operación que se va a aclarar',
  `Comercio` varchar(150) DEFAULT NULL COMMENT 'Nombre o descripción de la Tienda, lugar o comercio  donde se presento el problema',
  `NoCajero` varchar(10) DEFAULT NULL COMMENT 'Numero de Cajero en el que se presento el problema',
  `FechaOperacion` date DEFAULT NULL,
  `MontoOperacion` decimal(12,2) DEFAULT NULL,
  `TransaccionRep` bigint(20) DEFAULT NULL COMMENT 'Transacción de la operación de la tarjeta que se esta reportando para aclarar',
  `UsuarioRegistra` int(11) DEFAULT NULL COMMENT 'Usuario que levanto el registro de la Aclaración',
  `FechaAclaracion` date DEFAULT NULL COMMENT 'Fecha en la que se registra la Aclaración',
  `NoAutorizacion` bigint(20) DEFAULT NULL COMMENT 'Numero de Autorizacion de la Transaccion ATM o POS',
  `DetalleReporte` varchar(2000) DEFAULT NULL COMMENT 'Descripción detallada el problema ocurrido para facilitar la resolución de la aclaración',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Aclaración\nA = Alta\nS = Seguimiento\nR = Resuelta',
  `UsuarioResolucion` varchar(10) DEFAULT NULL COMMENT 'Puesto que finaliza o marca como resuelta la aclaración',
  `FechaResolucion` date DEFAULT NULL COMMENT 'Fecha en la que se finaliza la aclaración',
  `DetalleResolucion` varchar(2000) DEFAULT NULL COMMENT 'Descripción de la Resulción del Reporte',
  `TipoTarjeta` char(1) DEFAULT NULL COMMENT 'Tipo de Tarjeta :\nC = Credito\nD = Debito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) CHARACTER SET dec8 DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ReporteID`),
  KEY `fk_TARDEBACLARACION_1_idx` (`TipoAclaraID`),
  KEY `fk_TARDEBACLARACION_3_idx` (`InstitucionID`),
  KEY `fk_TARDEBACLARACION_4_idx` (`UsuarioRegistra`),
  KEY `fk_TARDEBACLARACION_5_idx` (`OpeAclaraID`),
  KEY `fk_TARDEBACLARACION` (`UsuarioResolucion`),
  CONSTRAINT `fk_TARDEBACLARACION_1` FOREIGN KEY (`TipoAclaraID`) REFERENCES `TARDEBOPEACLARA` (`TipoAclaraID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TARDEBACLARACION_3` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TARDEBACLARACION_5` FOREIGN KEY (`OpeAclaraID`) REFERENCES `TARDEBOPEACLARA` (`OpeAclaraID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Registro de las Aclaraciones Generadas'$$