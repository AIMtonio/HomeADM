-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PSLRESPPAGOSERV
DELIMITER ;
DROP TABLE IF EXISTS `PSLRESPPAGOSERV`;DELIMITER $$

CREATE TABLE `PSLRESPPAGOSERV` (
  `CobroID` bigint(20) NOT NULL COMMENT 'Identificador del cobro',
  `CodigoRespuesta` varchar(10) NOT NULL COMMENT 'Codigo de respuesta del WS consumido',
  `MensajeRespuesta` varchar(2000) NOT NULL COMMENT 'Mensaje de respuesta del WS consumido',
  `NumTransaccionP` varchar(20) NOT NULL COMMENT 'Identificador de la transaccion del proveedor',
  `NumAutorizacion` bigint(20) NOT NULL COMMENT 'Numero de autorizacion',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto a pagar, solo para pago de servicios',
  `Comision` decimal(14,2) NOT NULL COMMENT 'Comision generada por la transaccion',
  `Referencia` varchar(70) NOT NULL COMMENT 'Referencia alfanumerica indicando en el recibo del servicio a pagar',
  `SaldoRecarga` decimal(14,2) NOT NULL COMMENT 'Saldo disponible para realizar recargas de tiempo aire',
  `SaldoServicio` decimal(14,2) NOT NULL COMMENT 'Saldo disponible para realizar para de servicios en linea',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Campo de auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Campo de auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de auditoria',
  PRIMARY KEY (`CobroID`),
  KEY `INDEX_PSLRESPPAGOSERV_1` (`CobroID`),
  KEY `INDEX_PSLRESPPAGOSERV_2` (`NumAutorizacion`),
  KEY `INDEX_PSLRESPPAGOSERV_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para registrar las respuestas de los consumos a WS de compra de tiempo aire y pago de servicios'$$