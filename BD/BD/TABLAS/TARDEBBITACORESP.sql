-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBITACORESP
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBBITACORESP`;
DELIMITER $$


CREATE TABLE `TARDEBBITACORESP` (
  `RespID` int(11) NOT NULL,
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta de Debito',
  `TipoMensaje` char(4) DEFAULT NULL COMMENT 'Tipo Mensaje de la Transaccion:\n1200 \n1210 Transacción Normal ATMs y POS\n1220\n1230  Transacción Forzada POS (se debe aplicar el cobro)\n1400\n1410 Transacción Reverso ATMs\n1420\n1430 Transacción Reverso ATMs y POS (Prosa)',
  `TipoOperacionID` varchar(45) DEFAULT NULL COMMENT 'Campo 2 ISO 8583 de tipo de operacion',
  `FechaOperacion` datetime DEFAULT NULL COMMENT 'Monto operacion formato 9999999999.99',
  `MontoTransaccion` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Transaccion',
  `TerminalID` varchar(50) DEFAULT NULL COMMENT 'Num Cajero ATM ',
  `Referencia` varchar(15) DEFAULT NULL COMMENT 'Numero de Referencia de la Transaccion ',
  `FechaHrRespuesta` datetime DEFAULT NULL COMMENT 'Fecha y Hora de Respuesta de Transaccion',
  `NumTransResp` varchar(20) DEFAULT NULL COMMENT 'Numero de Transaccion generado por el core',
  `SaldoContableAct` varchar(13) DEFAULT NULL COMMENT 'Saldo Contable de la Cuenta de Ahorro',
  `SaldoDisponibleAct` varchar(13) DEFAULT NULL COMMENT 'Saldo Disponible de la Cuenta de Ahorro',
  `CodigoRespuesta` varchar(10) DEFAULT NULL COMMENT 'Codigo de Respuesta que se envia a PROSA',
  `MensajeRespuesta` VARCHAR(400) NULL DEFAULT '' COMMENT 'Mensaje de respuesta del ws de ISOTRX',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Indica el Numero de la Transaccion generado por el SAFI',
  PRIMARY KEY (`RespID`),
  KEY `Index_TarjetaDeb` (`TarjetaDebID`),
  KEY `Index_TipoOperacion` (`TipoOperacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$