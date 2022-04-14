-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TC_BITACORAMOVS`;
DELIMITER $$

CREATE TABLE `TC_BITACORAMOVS` (
  `TarCredMovID` int(11) NOT NULL COMMENT 'Consecutivo',
  `OrigenOperacion` char(1) DEFAULT NULL COMMENT 'Origen de la Operacion\nA: Archivo \nS: Safi \nE: Archivo Emi \nT: Stats \nW:Web Service',
  `TipoMensaje` char(4) DEFAULT NULL COMMENT 'Tipo Mensaje de la Transaccion:\n1200 \n1210 Transaccion Normal ATMs y POS\n1220\n1230  Transaccion Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transaccion Reverso ATMs\n1420\n1430 Transaccion Reverso ATMs y POS (Prosa)',
  `TipoOperacionID` char(2) DEFAULT NULL COMMENT 'Campo 2 ISO 8583 de tipo de operacion',
  `TarjetaCredID` char(16) DEFAULT NULL COMMENT 'Numero de tarjeta a 16 posiciones',
  `MontoOperacion` decimal(12,2) DEFAULT NULL COMMENT 'Monto operacion formato 9999999999.99',
  `MontoCashBack` decimal(12,2) DEFAULT NULL COMMENT 'MontosAdicionales. Monto de Cashback 999999.99',
  `MontoComision` decimal(12,2) DEFAULT NULL COMMENT 'Monto de comision por transaccion',
  `MontoIva` decimal(10,2) DEFAULT NULL COMMENT 'Monto de Iva de la comision',
  `MontoAdicional` decimal(12,2) NOT NULL COMMENT 'Monto Adicional por Transaccion',
  `CodigoMonOpe` varchar(10) DEFAULT NULL COMMENT 'Codigo Moneda Operacion. Campo 49 ISO 8583 ',
  `TipoCambio` decimal(14,6) DEFAULT '0.000000' COMMENT 'Valor del Tipo de Cambio a la fecha de transacion',
  `MontoOperacionMx` decimal(12,2) DEFAULT NULL COMMENT 'Monto operacion formato 9999999999.99 en pesos',
  `MontoCashBackMx` decimal(12,2) DEFAULT NULL COMMENT 'MontosAdicionales. Monto de Cashback 999999.99  en pesos',
  `MontoComisionMx` decimal(12,2) DEFAULT NULL COMMENT 'Monto de comision por transaccion  en pesos',
  `MontoIvaMx` decimal(10,2) DEFAULT NULL COMMENT 'Monto de Iva de la comision  en pesos',
  `MontoAdicionalMx` decimal(12,2) NOT NULL COMMENT 'Monto Adicional por transaccion en pesos',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha de Operacion',
  `HoraOperacion` time DEFAULT NULL COMMENT 'Hora de la Operacion',
  `GiroNegocio` varchar(5) DEFAULT NULL COMMENT 'Campo 18 ISO 8583 Merchant Type Formato 9999 (MCC)',
  `IRD` varchar(4) DEFAULT NULL COMMENT 'Interchange Rate Designator, corresponde a la familia asociada al MCC',
  `NombreComercio` varchar(50) DEFAULT NULL COMMENT 'Nombre del Comercio',
  `Ciudad` varchar(20) DEFAULT NULL COMMENT 'Nombre de la Ciudad',
  `Pais` varchar(6) DEFAULT NULL COMMENT 'Nombre del pais',
  `Referencia` varchar(25) DEFAULT NULL COMMENT 'Referencia (ARN)',
  `DatosTiempoAire` varchar(70) DEFAULT NULL COMMENT 'Datos para Transaccion de Compra de Tiempo Aire',
  `CodigoAprobacion` varchar(6) DEFAULT NULL COMMENT 'Indica el Numero de la Transaccion Original de Autorizacion',
  `Naturaleza` char(1) DEFAULT NULL COMMENT 'Naturaleza del movimiento "C - Cargos", "A - Abonos"\\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de los movimientos realizados con las tarjetas\nR = Registrado\nP = Procesado',
  `TransEnLinea` char(1) DEFAULT NULL COMMENT 'Transaccion en Linea \nS.- Si\nN.- No',
  `CheckIn` char(1) DEFAULT NULL COMMENT 'parametro que indica una preautorizacion de check in',
  `EstatusConcilia` char(1) DEFAULT NULL COMMENT 'Estatus de la Conciliacion \nC.- Conciliado\nN.- NO Conciliado\n',
  `FolioConcilia` bigint(20) DEFAULT NULL COMMENT 'Folio de Carga Conciliacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`TarCredMovID`),
  KEY `TarjetaCredID` (`TarjetaCredID`),
  KEY `FechaOperacion` (`FechaOperacion`),
  KEY `FechaOperacion_2` (`FechaOperacion`,`TarjetaCredID`,`TipoOperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Lleva el registro de las transacciones de tarjetas de Credito'$$