-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIAPOS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCILIAPOS`;DELIMITER $$

CREATE TABLE `TARDEBCONCILIAPOS` (
  `TarDebConciliaID` int(11) NOT NULL COMMENT 'Identificador de la tabla',
  `TipoTransaccion` char(2) DEFAULT NULL COMMENT 'Tipo de transacción(01 ventas, 20 pagos, 18 Cash-back, 21 devoluciones)\n',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de tarjeta a 16 posiciones',
  `FechaProceso` date DEFAULT NULL COMMENT 'Fecha de proceso de la transacción',
  `MarcaTarjeta` int(11) DEFAULT NULL COMMENT 'Marca de la Tarjeta 1.- Master Card, 2.-Visa, 3.-Privada',
  `MontoTransaccion` decimal(12,2) DEFAULT NULL COMMENT 'Importe total de la Transaccion ',
  `CodigoMonOpe` char(4) DEFAULT NULL COMMENT 'Codigo de Móneda con la que fue hecha la transacción\n',
  `GiroNegocio` varchar(5) DEFAULT NULL COMMENT 'Número de afiliación del comercio',
  `NumTransOpe` int(11) DEFAULT NULL COMMENT 'Referencia de la transacción',
  `NumTransDetalle` int(11) DEFAULT NULL COMMENT 'Total de transacciones de detalle ( sin contar header ni trailer), valor default (1)\n',
  `NumVentas` int(11) DEFAULT NULL COMMENT 'Total de transacciones (ventas)',
  `MontoTotalVtas` decimal(12,2) DEFAULT NULL COMMENT 'Importe de registro de ventas\n',
  `NumDisposiciones` int(11) DEFAULT NULL COMMENT 'Número total de disposiciones',
  `MontoTotalDispos` decimal(12,2) DEFAULT NULL COMMENT 'Importe de disposición de efectivo en el archivo\n',
  `TotalTransDebito` int(11) DEFAULT NULL COMMENT 'Total de registros de transacciones débito en el archivo',
  `MontoTransDebito` decimal(12,2) DEFAULT NULL COMMENT 'Importe total de transacciones débito en el archivo\n',
  `TotalDevoluciones` varchar(45) DEFAULT NULL COMMENT 'Total de devoluciones en el archivo\n',
  `MontoTotalDevolucion` decimal(12,2) DEFAULT NULL COMMENT 'Importe total de devoluciones en el archivo',
  `RutaArchivo` varchar(150) DEFAULT NULL COMMENT 'Ruta del archivo ',
  `FechaCarga` datetime DEFAULT NULL COMMENT 'fecha de carga del archivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarDebConciliaID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Informacion correspondiente con el archivo de Conciliacion d'$$