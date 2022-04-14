-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAARCHIVOS
DELIMITER ;
DROP TABLE IF EXISTS `POLIZAARCHIVOS`;DELIMITER $$

CREATE TABLE `POLIZAARCHIVOS` (
  `PolizaArchivosID` int(11) NOT NULL COMMENT 'Consecutivo General de la Tabla',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Corresponde con el ID de la tabla POLIZACONTABLE',
  `ArchivoPolID` int(11) DEFAULT NULL COMMENT 'Consecutivo Archivo por num de Poliza',
  `TipoDocumento` int(11) NOT NULL COMMENT 'Tipo de documento a digitalizar',
  `Observacion` varchar(200) DEFAULT NULL COMMENT 'Descripcion breve referente al tipo de documento.',
  `Recurso` varchar(100) NOT NULL COMMENT 'Recurso o Nombre del archivo.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`PolizaArchivosID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='GUARDA ARCHIVOS DE LA POLIZA CONTABLE'$$