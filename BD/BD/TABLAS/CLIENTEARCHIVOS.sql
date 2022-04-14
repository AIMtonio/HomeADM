-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEARCHIVOS
DELIMITER ;
DROP TABLE IF EXISTS `CLIENTEARCHIVOS`;DELIMITER $$

CREATE TABLE `CLIENTEARCHIVOS` (
  `ClienteArchivosID` int(11) NOT NULL COMMENT 'Consecutivo General de la Tabla',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero o ID de Cliente ',
  `ProspectoID` bigint(20) DEFAULT NULL COMMENT 'Corresponde con el ProspectoID de la tabla PROSPECTOS',
  `EmpresaID` int(11) DEFAULT NULL,
  `TipoDocumento` int(11) NOT NULL COMMENT 'Tipo de documento a digitalizar',
  `Consecutivo` int(11) NOT NULL COMMENT 'Numero consecutivo para la imagen a digitalizar\n',
  `Observacion` varchar(200) DEFAULT NULL COMMENT 'Descripcion breve referente al tipo de documento.',
  `Recurso` varchar(500) NOT NULL COMMENT 'Recurso o Nombre de la Página.',
  `Instrumento` int(11) DEFAULT NULL COMMENT 'Instrumento a Tabla a que hace Referencia el \nDocumento digitalizado\nEj: SERVIFUNFOLIOS, CLIENTESPROFUN',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se digitalizo el Archivo',
  `FechaExpira` date DEFAULT '1900-01-01' COMMENT 'Fecha en la que expira el documento',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteArchivosID`),
  KEY `fk_CLIENTEARCHIVOS_2` (`TipoDocumento`),
  KEY `index_CLIENTE` (`ClienteID`),
  KEY `index_PROSPECTO` (`ProspectoID`),
  CONSTRAINT `fk_CLIENTEARCHIVOS_2` FOREIGN KEY (`TipoDocumento`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA EN DONDE SE ALMACENAN LOS TIPOS DE ARCHIVOS DE CLIENTE'$$