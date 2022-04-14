DELIMITER ;
DROP TABLE IF exists TC_PAGOTARDESCUENTO;

DELIMITER ;
CREATE TABLE `TC_PAGOTARDESCUENTO` (
   PagoTarDescuentoID int primary key comment 'Consecutivo del pago de tarjetas',
  `LineaTarCredID` int(20) NOT NULL DEFAULT '0' COMMENT 'Identificador de la Linea de Credito',
  `TarjetaCredID` char(16) DEFAULT '' COMMENT 'Numero de tarjeta titular',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Identificador del Cliente',
  `MontoPagoOriginal` decimal(16,2) DEFAULT NULL COMMENT 'Monto Original en el archivo de Pagos',
  `PorcDescuento` decimal(6,2) DEFAULT NULL COMMENT 'Porcentaje de Descuento Aplicado',
  `MontoDescuento` decimal(16,2) DEFAULT NULL COMMENT 'Monto del Descuento del pago',
  `MontoAplicadoTC` decimal(16,2) DEFAULT NULL COMMENT 'Monto real aplicado a la tarjeta de credito',
  `FechaPago`	date COMMENT 'Fecha de pago del archivo de transacciones',
  `FechaAplicacion` date COMMENT 'Fecha de Aplicacion real del pago',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Registro de los descuentos por servicio en pagos de tarjetas de credito';
