-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAARCHIVOS
DELIMITER ;
DROP TABLE IF EXISTS `CUENTAARCHIVOS`;DELIMITER $$

CREATE TABLE `CUENTAARCHIVOS` (
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `ArchivoCtaID` int(11) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `TipoDocumento` int(11) NOT NULL COMMENT 'Tipo de documento a digitalizar',
  `Consecutivo` int(11) NOT NULL COMMENT 'Numero consecutivo para la imagen a digitalizar\n',
  `Observacion` varchar(200) DEFAULT NULL COMMENT 'Descripcion breve \nreferente al tipo \nde documento.',
  `Recurso` varchar(500) NOT NULL COMMENT 'Recurso o Nombre de la Página.',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CuentaAhoID`,`ArchivoCtaID`),
  KEY `fk_CUENTAARCHIVOS_1` (`CuentaAhoID`),
  KEY `fk_CUENTAARCHIVOS_2` (`TipoDocumento`),
  CONSTRAINT `fk_CUENTAARCHIVOS_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CUENTAARCHIVOS_2` FOREIGN KEY (`TipoDocumento`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA EN DONDE SE ALMACENAN LOS TIPOS DE ARCHIVOS DE CLIENTE'$$