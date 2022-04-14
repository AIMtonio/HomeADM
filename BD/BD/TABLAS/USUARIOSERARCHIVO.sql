-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERARCHIVO
DELIMITER ;
DROP TABLE IF EXISTS `USUARIOSERARCHIVO`;DELIMITER $$

CREATE TABLE `USUARIOSERARCHIVO` (
  `UsuarioSerArchiID` int(11) NOT NULL COMMENT 'Consecutivo General de la Tabla',
  `UsuarioServicioID` int(11) DEFAULT NULL COMMENT 'Numero ID del Usuario de Servicios',
  `TipoDocumento` int(11) DEFAULT NULL COMMENT 'Tipo de Documento, Identificacion',
  `Consecutivo` int(11) DEFAULT NULL COMMENT 'Numero consecutivo para la imagen a digitalizar',
  `Observacion` varchar(200) DEFAULT NULL COMMENT 'Observacion del Documento',
  `Recurso` varchar(500) DEFAULT NULL COMMENT 'Recurso o Nombre de la Página.',
  `FechaRegistro` date DEFAULT NULL COMMENT 'Fecha en la que se digitalizo el Archivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`UsuarioSerArchiID`),
  KEY `fk_USUARIOSERARCHIVO_1` (`UsuarioServicioID`),
  KEY `fk_USUARIOSERARCHIVO_2` (`TipoDocumento`),
  CONSTRAINT `fk_USUARIOSERARCHIVO_2` FOREIGN KEY (`TipoDocumento`) REFERENCES `TIPOSDOCUMENTOS` (`TipoDocumentoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TABLA EN DONDE SE ALMACENAN LOS ARCHIVOS DEL USUARIO DE SERVICIOS'$$