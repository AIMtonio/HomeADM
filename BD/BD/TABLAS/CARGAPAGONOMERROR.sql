-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAPAGONOMERROR
DELIMITER ;
DROP TABLE IF EXISTS `CARGAPAGONOMERROR`;DELIMITER $$

CREATE TABLE `CARGAPAGONOMERROR` (
  `FolioErrorID` int(11) NOT NULL COMMENT 'ID o consecutivo',
  `FolioCargaID` int(11) DEFAULT NULL COMMENT 'Folio de carga del Archivo',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de credito erroneo',
  `EmpresaNominaID` int(11) DEFAULT NULL COMMENT 'Numero de la Empresa de Nomina',
  `DescripcionError` varchar(200) DEFAULT NULL COMMENT 'Descripcion del error en la carga de archivo de pagos de nomina',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioErrorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Errores en la carga de archivos de Pagos de Nomina'$$