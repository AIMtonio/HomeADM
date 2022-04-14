-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIATMDET
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCIATMDET`;DELIMITER $$

CREATE TABLE `TARDEBCONCIATMDET` (
  `ConciliaATMID` int(11) NOT NULL COMMENT 'FK del Encabezado de Conciliacion ATM\n',
  `DetalleATMID` int(11) NOT NULL DEFAULT '0' COMMENT 'PK del Detalle de Conciliacion ATM\n',
  `Emisor` char(20) DEFAULT NULL COMMENT 'Codigo del Emisor\n',
  `TerminalID` varchar(50) DEFAULT NULL COMMENT 'Campo 41 ISO 8583 codigo de la terminal o cajero que envio la transaccion',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'Numero de Tarjeta de Debito',
  `CuentaOrigen` varchar(25) DEFAULT NULL COMMENT 'Cuenta Origen',
  `Descripcion` varchar(20) DEFAULT NULL COMMENT 'Descripcion del Movimiento',
  `CodigoRespuesta` char(5) DEFAULT NULL COMMENT 'Codigo de Respuesta',
  `Secuencia` char(7) DEFAULT NULL COMMENT 'Secuencia',
  `FechaTransac` date DEFAULT NULL COMMENT 'Fecha de la transaccion',
  `HoraTransac` time DEFAULT NULL COMMENT 'Hora de la Transaccion',
  `Red` varchar(10) DEFAULT NULL,
  `MontoTransac` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Trnasaccion',
  `Comision` decimal(12,2) DEFAULT NULL COMMENT 'Comision por la Transaccion',
  `NumAutorizacion` char(7) DEFAULT NULL COMMENT 'Numero de Autorizacion de la Transaccion',
  `EstatusConci` char(1) DEFAULT 'N' COMMENT 'Estatus conciliado:\nN.- No conciliado\nC.- Conciliado\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConciliaATMID`,`DetalleATMID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$