-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TARJETADEBITOMOVS`;DELIMITER $$

CREATE TABLE `TARJETADEBITOMOVS` (
  `TarDebMovID` int(11) NOT NULL,
  `TipoOperacionID` char(2) DEFAULT NULL COMMENT 'Campo 2 ISO 8583 de tipo de operacion',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de tarjeta a 16 posiciones',
  `MontoOpe` decimal(12,2) DEFAULT NULL COMMENT 'Monto operacion formato 9999999999.99',
  `FechaHrOpe` datetime DEFAULT NULL COMMENT 'Fecha operacion formato YYYY-MM-DD hh:mm:ss',
  `NumeroTran` bigint(20) DEFAULT NULL COMMENT 'Numero transaccion. Campo 11 ISO 8583 System Trace Audit Number',
  `TerminalID` varchar(50) DEFAULT NULL COMMENT 'Campo 41 ISO 8583 codigo de la terminal o cajero que envio la transaccion',
  `MontosAdiciona` decimal(12,2) DEFAULT NULL COMMENT 'MontosAdicionales. Monto de Cashback 999999.99',
  `MontoSurcharge` decimal(12,2) DEFAULT NULL COMMENT 'Monto de SurCharge formato 9999999999.99',
  `MontoLoyaltyfee` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Loyalty fee formato 999999999.99',
  `Referencia` varchar(12) DEFAULT NULL COMMENT 'Código de Referencia asignado a la Transacción por la terminal o ATM origen.',
  `TransEnLinea` char(1) DEFAULT NULL COMMENT 'Transaccion en Linea \nS.- Si\nN.- No',
  `FolioConcilia` bigint(20) DEFAULT NULL COMMENT 'Folio de Carga Conciliacion',
  `DetalleConciliaID` int(11) DEFAULT NULL COMMENT 'ID detalle de Conciliacion',
  `EstatusConcilia` char(1) DEFAULT NULL COMMENT 'Estatus de la Conciliacion \nC.- Conciliado\nN.- NO Conciliado\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarDebMovID`),
  KEY `Idx_TarjetaDebID` (`TarjetaDebID`),
  KEY `Idx_Referencia` (`Referencia`),
  KEY `Index_EstatusConcilia` (`EstatusConcilia`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='BITACORA PARA MOVIMIENTOS DE OPERACIONES DE TARJETAS'$$