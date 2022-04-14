-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `DIRECCLIENTE`;
DELIMITER $$

CREATE TABLE `DIRECCLIENTE` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `DireccionID` int(11) NOT NULL COMMENT 'ID de la direccion de cliente',
  `EmpresaID` int(11) DEFAULT NULL,
  `TipoDireccionID` int(11) DEFAULT NULL COMMENT 'ID de la direccion del cliente',
  `PaisID`    INT(11) DEFAULT 0 COMMENT 'ID del pais',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del estado del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio del cliente',
  `LocalidadID` int(11) DEFAULT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio',
  `ColoniaID` int(11) DEFAULT NULL COMMENT 'Nombre de la colonia',
  `Colonia` varchar(200) DEFAULT NULL,
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroCasa` char(10) DEFAULT NULL COMMENT 'Numero de casa, depto, oficina o negocio',
  `NumInterior` char(15) DEFAULT NULL COMMENT 'Numero interior de la casa o edificio.',
  `Piso` char(50) DEFAULT NULL COMMENT 'Número de piso.',
  `PrimeraEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Primer entrecalle en la que se encuentra la direccion',
  `SegundaEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Segunda entrecalle en la que se encuentra la direccion',
  `CP` char(5) DEFAULT NULL COMMENT 'Codigo Postal',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Este campo se arma con los campos calle, numero, colonia, y CP.',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Breve descripcion de las caracteristicas del domicilio.',
  `Latitud` varchar(45) DEFAULT NULL COMMENT 'Latitud de \nubicacion',
  `Longitud` varchar(45) DEFAULT NULL COMMENT 'Altitud de ubicación\n',
  `Oficial` char(1) DEFAULT NULL COMMENT 'Valor de direccion oficial\nS=SI, N=No',
  `Fiscal` char(1) DEFAULT NULL,
  `Lote` char(50) DEFAULT NULL COMMENT 'Lote',
  `Manzana` char(50) DEFAULT NULL COMMENT 'Manzana',
  `AniosRes`  INT(11) DEFAULT 0 COMMENT 'Años de residencia',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`DireccionID`),
  KEY `fk_DIRECCLIENTE_1` (`TipoDireccionID`),
  KEY `fk_DIRECCLIENTE_2` (`EstadoID`),
  CONSTRAINT `fk_DIRECCLIENTE_1` FOREIGN KEY (`TipoDireccionID`) REFERENCES `TIPOSDIRECCION` (`TipoDireccionID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_DIRECCLIENTE_2` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$