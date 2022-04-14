-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCILIADETA
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCILIADETA`;DELIMITER $$

CREATE TABLE `TARDEBCONCILIADETA` (
  `ConciliaID` int(11) NOT NULL COMMENT 'Numero de Conciliacion',
  `DetalleID` int(11) NOT NULL COMMENT 'Consecutivo',
  `BancoEmisor` int(11) DEFAULT NULL COMMENT 'Numero de Banco emisor de la tarjeta rellenado con ceros a la izquierda\n',
  `NumCuenta` varchar(19) DEFAULT NULL COMMENT 'Numero de tarjeta del tarjetahabiente justificado a la izquierda',
  `NaturalezaConta` char(1) DEFAULT NULL COMMENT 'Naturaleza Contable C.-Credito D.-Debito',
  `MarcaProducto` char(1) DEFAULT NULL COMMENT '1.- Master Card\n2.- Visa\n3.- Privada',
  `FechaConsumo` date DEFAULT NULL COMMENT 'Fecha de consumo,',
  `FechaProceso` date DEFAULT NULL COMMENT 'Fecha de proceso de la transaccion',
  `TipoTransaccion` char(2) DEFAULT NULL COMMENT 'Tipo de transaccion  01.- Ventas  20 pagos 18.-Cash-back 21.-Devoluciones',
  `NumLiquidacion` int(11) DEFAULT NULL COMMENT 'Codigo del Tipo de Liquidacion',
  `ImporteOrigenTrans` decimal(12,2) DEFAULT NULL COMMENT 'Importe total de la Transaccion (compra + monto 2)',
  `ImporteOrigenCon` decimal(12,2) DEFAULT NULL COMMENT 'Importe del consumo para Tx con propina o importe de\nefectivo para transacciones cashback',
  `CodigoMonedaOrigen` int(11) DEFAULT NULL COMMENT 'Codigo de Moneda con la que fue hecha la transaccion\n',
  `ImporteDestinoTotal` decimal(12,2) DEFAULT NULL COMMENT 'Importe Total (compra + monto2) destino de la\ntransaccion',
  `ImporteDestinoCon` decimal(12,2) DEFAULT NULL COMMENT 'Importe del consumo para Tx con propina o importe de\nefectivo para transacciones cashback\n',
  `ClaveMonedaDestino` int(11) DEFAULT NULL COMMENT 'Moneda a la que fue convertido el importe origen para solicitar la autorizacion.',
  `ImporteLiquidado` decimal(12,2) DEFAULT NULL COMMENT 'Importe Total liquidado\nImporte para aplicar o conciliar el saldo del TarjetaHabiente\n	',
  `ImporteLiquidadoCon` decimal(12,2) DEFAULT NULL COMMENT 'Importe del consumo para Tx con propina o importe de\nefectivo para transacciones cashback',
  `ClaveMonedaLiqui` int(11) DEFAULT NULL COMMENT 'Moneda a la que fue dconvertido el importe origen para\nla liquidacion\n',
  `ClaveComercio` varchar(15) DEFAULT NULL COMMENT 'Numero de afiliacion del comercio\n',
  `GiroNegocio` varchar(5) DEFAULT NULL COMMENT 'Numero de giro internacional, valor por default (00000)\n',
  `NombreComercio` varchar(30) DEFAULT NULL COMMENT 'Nombre del comercio\n',
  `PaisOrigen` varchar(3) DEFAULT NULL COMMENT 'Codigo del pais donde fue realizada la transaccion (ISO)',
  `RFCComercio` varchar(13) DEFAULT NULL COMMENT 'RFC del comercio Adquiriente',
  `NumeroFuente` int(11) DEFAULT NULL COMMENT 'Numero de fuente, indica el adquirente especifico\n',
  `NumAutorizacion` varchar(6) DEFAULT NULL COMMENT 'Numero de autorizacion',
  `BancoReceptor` int(11) DEFAULT NULL COMMENT 'Numero del Banco adquiriente rellenado con ceros a la\nizquierda',
  `ReferenciaTrans` varchar(23) DEFAULT NULL COMMENT 'Referencia de la transaccion\n',
  `FIIDEmisor` varchar(4) DEFAULT NULL COMMENT 'FIID Emisor',
  `FIIDAdquiriente` varchar(4) DEFAULT NULL COMMENT 'FIID Adquiriente',
  `FolioConcilia` bigint(20) DEFAULT NULL COMMENT 'Folio de Conciliacion que hace referencia \nal movimiento con que se concilio',
  `EstatusConci` char(1) DEFAULT NULL COMMENT 'Estatus del Registro \nC.- Conciliado \nN.- No Conciliado\n',
  `TipoOperacion` varchar(50) DEFAULT '' COMMENT 'Tipo de la Operacion.\nPago Corresponsales: Corresponden al Tipo de Transaccion “20-Pagos” y el movimiento no existe en TARDEBBITACORAMOVS.\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`ConciliaID`,`DetalleID`),
  KEY `fk_TARDEBCONCILIADETA_1_idx` (`ConciliaID`),
  KEY `index3` (`NumCuenta`),
  CONSTRAINT `fk_TARDEBCONCILIADETA_1` FOREIGN KEY (`ConciliaID`) REFERENCES `TARDEBCONCIENCABEZA` (`ConciliaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar detalle de archivo de conciliacion'$$