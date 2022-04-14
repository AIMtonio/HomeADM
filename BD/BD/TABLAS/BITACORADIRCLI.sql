-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORADIRCLI
DELIMITER ;
DROP TABLE IF EXISTS `BITACORADIRCLI`;DELIMITER $$

CREATE TABLE `BITACORADIRCLI` (
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del cliente',
  `DireccionID` int(11) NOT NULL COMMENT 'ID de la direccion de cliente',
  `EmpresaID` int(11) DEFAULT NULL,
  `TipoDireccionID` int(11) DEFAULT NULL COMMENT 'ID de la direccion del cliente',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del estado del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Hace referencia al ID del muncipio del cliente',
  `Calle` varchar(50) DEFAULT NULL COMMENT 'Nombre de la calle',
  `NumeroCasa` char(10) DEFAULT NULL COMMENT 'Numero de casa, depto, oficina o negocio',
  `NumInterior` char(10) DEFAULT NULL COMMENT 'Numero interior de la casa o edificio.',
  `Piso` char(10) DEFAULT NULL COMMENT 'Número de piso.',
  `PrimeraEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Primer entrecalle en la que se encuentra la direccion',
  `SegundaEntreCalle` varchar(50) DEFAULT NULL COMMENT 'Segunda entrecalle en la que se encuentra la direccion',
  `Colonia` varchar(50) DEFAULT NULL COMMENT 'Nombre de la colonia',
  `CP` int(11) DEFAULT NULL COMMENT 'Codigo Postal',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Este campo se arma con los campos calle, numero, colonia, y CP.',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Breve descripcion de las caracteristicas del domicilio.',
  `Latitud` varchar(45) DEFAULT NULL COMMENT 'Latitud de \nubicacion',
  `Longitud` varchar(45) DEFAULT NULL COMMENT 'Altitud de ubicación\n',
  `Oficial` char(1) DEFAULT NULL COMMENT 'Valor de direccion oficial\nS=SI, N=No',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `NombreSP` varchar(45) DEFAULT NULL,
  `NumError` int(3) DEFAULT NULL,
  `MensajeError` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$