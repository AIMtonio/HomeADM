-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAMOVSTAR
DELIMITER ;
DROP TABLE IF EXISTS `BITACORAMOVSTAR`;DELIMITER $$

CREATE TABLE `BITACORAMOVSTAR` (
  `TipoOperacionID` char(2) DEFAULT NULL COMMENT 'Campo 2 ISO 8583 de tipo de operacion',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de tarjeta a 16 posiciones',
  `OrigenInst` char(2) DEFAULT NULL COMMENT 'Origen instrumento. Campo 3 Subcampo 3 ISO 8583 MSG',
  `MontoOpe` decimal(12,2) DEFAULT NULL COMMENT 'Monto operacion formato 9999999999.99',
  `FechaHrOpe` datetime DEFAULT NULL COMMENT 'Fecha operacion formato YYYY-MM-DD hh:mm:ss',
  `NumeroTran` bigint(20) DEFAULT NULL COMMENT 'Numero transaccion. Campo 11 ISO 8583 System Trace Audit Number',
  `GiroNegocio` varchar(5) DEFAULT NULL COMMENT 'Campo 18 ISO 8583 Merchant Type Formato 9999',
  `PuntoEntrada` char(2) DEFAULT NULL COMMENT 'Campo 22 ISO 8583 Punto de entrada ',
  `TerminalID` varchar(50) DEFAULT NULL COMMENT 'Campo 41 ISO 8583 codigo de la terminal o cajero que envio la transaccion',
  `NombreUbicaTer` varchar(50) DEFAULT NULL COMMENT 'Nombre ubicacion terminal. Campo 43 ISO 8583 codigo de ubicacion de la terminal',
  `NIP` varchar(256) DEFAULT NULL COMMENT 'NIP',
  `CodigoMonOpe` varchar(10) DEFAULT NULL COMMENT 'Codigo Moneda Operacion. Campo 49 ISO 8583 ',
  `MontosAdiciona` decimal(12,2) DEFAULT NULL COMMENT 'MontosAdicionales. Monto de Cashback 999999.99',
  `MontoSurcharge` decimal(12,2) DEFAULT NULL COMMENT 'Monto de SurCharge formato 9999999999.99',
  `MontoLoyaltyfee` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Loyalty fee formato 999999999.99',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='BITACORA PARA MOVIMIENTOS DE OPERACIONES DE TARJETAS'$$