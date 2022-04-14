-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BECARGAPAGNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `BECARGAPAGNOMINA`;
DELIMITER $$

CREATE TABLE `BECARGAPAGNOMINA` (
  `FolioCargaID` int(11) NOT NULL COMMENT 'Folio consecutivo de la Carga del Archivo de pagos',
  `FolioCargaIDBE` int(11) DEFAULT NULL COMMENT 'Folio de Carga Consecutivo Generado en Banca en Linea',
  `EmpresaNominaID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente de la empresa de Nomina',
  `ClaveUsuario` varchar(20) DEFAULT NULL COMMENT 'Usuario de BE, que subio el archivo',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente de la empresa de Nomina\n',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha en que se subio el Archivo',
  `NumTotalPagos` int(11) DEFAULT NULL COMMENT 'Numero total de Pagos',
  `NumPagosExito` int(11) DEFAULT NULL COMMENT 'Numero total de Pagos subidos correctamente',
  `NumPagosError` int(11) DEFAULT NULL COMMENT 'Numero total de Pagos subidos con error',
  `MontoPagos` decimal(12,2) DEFAULT NULL COMMENT 'Monto total de los pagos que subieron correctamente\n',
  `RutaArchivoPagoNom` varchar(250) DEFAULT NULL COMMENT 'Ruta del Archivo Adjunto de Pagos de Credito',
  `Estatus` char(1) DEFAULT NULL COMMENT 'P=Procesado \nN=No Procesado',
  `FechaApliPago` date DEFAULT NULL COMMENT 'Fecha en la que se realizo la Aplicacion de Pago de todos sus registros',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`FolioCargaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Encabezado de la Carga del Layout de Pagos de Nomina'$$