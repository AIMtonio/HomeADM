-- TD_BITACORARESP
DELIMITER ;
DROP TABLE IF EXISTS `TD_BITACORARESP`;
DELIMITER $$


CREATE TABLE `TD_BITACORARESP` (
  `RespID` int(11) NOT NULL COMMENT 'ID de la Respuesta de Transaccion',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta de Debito',
  `TipoMensaje` char(4) DEFAULT NULL COMMENT 'Tipo Mensaje de la Transaccion:\n1200 \n1210 Transaccion Normal ATMs y POS\n1220\n1230  Transaccion Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transaccion Reverso ATMs\n1420\n1430 Transaccion Reverso ATMs y POS (Prosa)',
  `TipoOperacionID` varchar(45) DEFAULT NULL COMMENT 'Campo 2 ISO 8583 de tipo de operacion',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha de Operacion',
  `HoraOperacion` time DEFAULT NULL COMMENT 'Hora de Operacion',
  `MontoTransaccion` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Transaccion',
  `Referencia` varchar(25) DEFAULT NULL COMMENT 'Numero de Referencia de la Transaccion ',
  `FechaHrRespuesta` datetime DEFAULT NULL COMMENT 'Fecha y Hora de Respuesta de Transaccion',
  `NumTransResp` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion generado por el core',
  `SaldoContableAct` decimal(16,2) DEFAULT NULL COMMENT 'Saldo Contable de la Cuenta de Ahorro',
  `SaldoDisponibleAct` decimal(16,2) DEFAULT NULL COMMENT 'Saldo Disponible de la Cuenta de Ahorro',
  `CodigoRespuesta` varchar(3) DEFAULT NULL COMMENT 'Codigo de Respuesta que se envia a PROSA',
  `MensajeRespuesta` varchar(400) DEFAULT NULL COMMENT 'Mensaje de Respuesta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(45) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Indica el Numero de la Transaccion generado por el SAFI',
  PRIMARY KEY (`RespID`),
  KEY `Index_TarjetaDeb` (`TarjetaDebID`),
  KEY `Index_TipoOperacion` (`TipoOperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Bitacora de respuestas de transacciones'$$