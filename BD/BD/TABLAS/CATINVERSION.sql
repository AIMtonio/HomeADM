-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `CATINVERSION`;
DELIMITER $$


CREATE TABLE `CATINVERSION` (
  `TipoInversionID` int(11) NOT NULL COMMENT 'LLave primaria',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion de la inversion',
  `FechaCreacion` datetime NOT NULL COMMENT 'fecha de la creacion',
  `Estatus` CHAR(2) NOT NULL DEFAULT 'A' COMMENT 'Estatus del Tipo de Inversion\nA.-  Activo\nC.- Inactivo\n',
  `Reinversion` char(1) DEFAULT NULL COMMENT 'Se indica \nS .- si se hace en automatico la reinversion y una \nN .- si no quiere hacer el Tipo de Inversion en automatico',
  `Reinvertir` varchar(5) CHARACTER SET big5 NOT NULL COMMENT 'Tipo de Reinversion Automatica \nC = Capital \nCI = Capital mas interes \nI  =  Indistinto\nN = Ninguna.',
  `MonedaId` int(11) DEFAULT NULL COMMENT 'Tipo de moneda especificada para cada tipo de inversion',
  `NumRegistroRECA` varchar(100) DEFAULT '' COMMENT 'Se guardara el numero de registro RECA.',
  `FechaInscripcion` date DEFAULT '1900-01-01' COMMENT 'guarda la fecha de registro del RECA.',
  `NombreComercial` varchar(100) DEFAULT '' COMMENT 'Guarda el nombre comercial del RECA.',
  `ClaveCNBV` varchar(10) DEFAULT NULL COMMENT 'Clave CNBV del Producto de Inversion',
  `ClaveCNBVAmpCred` varchar(10) DEFAULT NULL COMMENT 'Clave Producto que Ampara credito',
  `PagoPeriodico` char(1) DEFAULT 'N' COMMENT 'S.- Las Inversiones se pagan Periodicamente N.- Las inversiones no se pagan Periodicamente',
  `EmpresaID` varchar(45) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(15) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoInversionID`),
  KEY `FK_MONEDAID` (`MonedaId`),
  CONSTRAINT `FK_MONEDAID` FOREIGN KEY (`MonedaId`) REFERENCES `MONEDAS` (`MonedaId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Inversiones'$$