-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REFERENCIACLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `REFERENCIACLIENTE`;
DELIMITER $$


CREATE TABLE `REFERENCIACLIENTE` (
  `ReferenciaID` int(11) NOT NULL COMMENT 'ID de la referencia',
  `SolicitudCreditoID` bigint(20) NOT NULL DEFAULT '0' COMMENT 'ID de la solicitud',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero consecutivo de las referencias por solicitud.',
  `PrimerNombre` varchar(50) NOT NULL COMMENT 'Primer Nombre de la referencia',
  `SegundoNombre` varchar(50) DEFAULT NULL COMMENT 'Segundo Nombre de la referencia',
  `TercerNombre` varchar(50) DEFAULT NULL COMMENT 'Tercer Nombre Del referencia\n',
  `ApellidoPaterno` varchar(50) NOT NULL COMMENT 'Apellido Paterno de la referencia',
  `ApellidoMaterno` varchar(50) DEFAULT NULL COMMENT 'Apellido Materno de la referencia',
  `NombreCompleto` varchar(250) DEFAULT NULL COMMENT 'Nombre completo',
  `Telefono` varchar(20) NOT NULL COMMENT 'Telefonos de la referencia\n',
  `ExtTelefonoPart` varchar(7) DEFAULT NULL COMMENT 'Contiene en número de extensión del teléfono',
  `Validado` varchar(1) NOT NULL DEFAULT 'N' COMMENT 'S: Si ya fue validado N: Si aun no esta validado',
  `Interesado` varchar(1) NOT NULL,
  `TipoRelacionID` int(11) NOT NULL COMMENT 'Tipo de Relacion ID',
  `EstadoID` int(11) NOT NULL COMMENT 'Hace referencia al ID del estado del cliente',
  `MunicipioID` int(11) NOT NULL COMMENT 'Hace referencia al ID del muncipio del cliente',
  `LocalidadID` int(11) NOT NULL COMMENT 'Numero de Localidad Correspondiente al Municipio',
  `ColoniaID` int(11) NOT NULL COMMENT 'Nombre de la colonia',
  `Calle` varchar(50) NOT NULL COMMENT 'Nombre de la calle',
  `NumeroCasa` varchar(10) NOT NULL COMMENT 'Numero de casa, depto, oficina o negocio',
  `NumInterior` varchar(10) DEFAULT NULL COMMENT 'Numero interior de la casa o edificio.',
  `Piso` char(50) DEFAULT NULL COMMENT 'Número de piso.',
  `CP` varchar(5) NOT NULL COMMENT 'Codigo Postal',
  `DireccionCompleta` varchar(500) DEFAULT NULL COMMENT 'Este campo se arma con los campos calle, numero, colonia, y CP.',
  `Usuario` int(11) DEFAULT NULL,
  `Empresa` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ReferenciaID`),
  KEY `fk_REFERENCIACLIENTE_1_idx` (`SolicitudCreditoID`),
  KEY `fk_REFERENCIACLIENTE_2_idx` (`EstadoID`),
  KEY `fk_REFERENCIACLIENTE_3_idx` (`MunicipioID`,`EstadoID`),
  KEY `fk_REFERENCIACLIENTE_4_idx` (`TipoRelacionID`),
  CONSTRAINT `fk_REFERENCIACLIENTE_1` FOREIGN KEY (`SolicitudCreditoID`) REFERENCES `SOLICITUDCREDITO` (`SolicitudCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REFERENCIACLIENTE_2` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_REFERENCIACLIENTE_4` FOREIGN KEY (`TipoRelacionID`) REFERENCES `TIPORELACIONES` (`TipoRelacionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena las referencias de las solicitudes del cliente'$$
