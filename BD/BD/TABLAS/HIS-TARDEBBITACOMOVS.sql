-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TARDEBBITACOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `HIS-TARDEBBITACOMOVS`;DELIMITER $$

CREATE TABLE `HIS-TARDEBBITACOMOVS` (
  `Fecha` date NOT NULL,
  `TarDebMovID` int(11) NOT NULL COMMENT 'Identificador de la tabla TARDEBBITACORAMOVS',
  `TipoMensaje` char(4) NOT NULL COMMENT 'Tipo Mensaje de la Transaccion:\n1200 \n1210 Transacción Normal ATMs y POS\n1220\n1230  Transacción Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transacción Reverso ATMs\n1420\n1430 Transacción Reverso ATMs y POS (Prosa)',
  `TipoOperacionID` char(2) NOT NULL COMMENT 'Campo 2 ISO 8583 de tipo de operacion',
  `TarjetaDebID` char(16) NOT NULL COMMENT 'Numero de tarjeta a 16 posiciones',
  `MontoOpe` decimal(12,2) NOT NULL COMMENT 'Monto operacion formato 9999999999.99',
  `FechaHrOpe` varchar(20) DEFAULT NULL COMMENT 'Fecha operacion formato YYYY-MM-DD hh:mm:ss',
  `NumeroTran` bigint(20) DEFAULT NULL COMMENT 'Numero transaccion. Campo 11 ISO 8583 System Trace Audit Number',
  `GiroNegocio` varchar(5) DEFAULT NULL COMMENT 'Campo 18 ISO 8583 Merchant Type Formato 9999',
  `TerminalID` varchar(50) DEFAULT NULL COMMENT 'Campo 41 ISO 8583 codigo de la terminal o cajero que envio la transaccion',
  `NIP` varchar(256) DEFAULT NULL COMMENT 'NIP',
  `MontosAdiciona` decimal(12,2) DEFAULT NULL COMMENT 'MontosAdicionales. Monto de Cashback 999999.99',
  `MontoSurcharge` decimal(12,2) DEFAULT NULL COMMENT 'Monto de SurCharge formato 9999999999.99',
  `MontoLoyaltyfee` decimal(12,2) DEFAULT NULL,
  `Referencia` varchar(12) DEFAULT NULL COMMENT 'Código de Referencia asignado a la Transacción por la terminal o ATM origen.',
  `DatosTiempoAire` varchar(70) DEFAULT NULL COMMENT 'Datos para Transaccion de Compra de Tiempo Aire',
  `EstatusConcilia` char(1) DEFAULT NULL COMMENT 'Estatus de la Conciliacion \nC.- Conciliado\nN.- NO Conciliado',
  `FolioConcilia` bigint(20) DEFAULT NULL,
  `DetalleConciliaID` int(11) DEFAULT NULL COMMENT 'ID detalle de Conciliacion',
  `TransEnLinea` char(1) DEFAULT NULL COMMENT 'Transaccion en Linea \nS.- Si\nN.- No',
  `CheckIn` char(1) DEFAULT NULL COMMENT 'parametro que indica una preautorizacion de check in',
  `CodigoAprobacion` varchar(6) DEFAULT NULL COMMENT 'Indica el Numero de la Transaccion Original\n(generado por el SAFI)',
  `Estatus` char(1) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Programa donde se ejecuto el Store',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'NumTransaccion generado por el SAFI'
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$