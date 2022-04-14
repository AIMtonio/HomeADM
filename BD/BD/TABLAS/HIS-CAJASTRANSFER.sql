-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CAJASTRANSFER
DELIMITER ;
DROP TABLE IF EXISTS `HIS-CAJASTRANSFER`;
DELIMITER $$


CREATE TABLE `HIS-CAJASTRANSFER` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `CajasTransferID` int(11) NOT NULL COMMENT 'Consecutivo de Cajas Transferencias',
  `SucursalOrigen` int(11) NOT NULL COMMENT 'Sucursal Origen para la Transferencia de Efectivo',
  `SucursalDestino` int(11) NOT NULL COMMENT 'Sucursal Destino para la Transferencia de Efectivo',
  `Fecha` datetime NOT NULL COMMENT 'Fecha de Transferencia',
  `DenominacionID` int(11) NOT NULL COMMENT 'Corresponde a la Tabla DENOMINACIONES, para definir el tipo de denominacion\\n',
  `Cantidad` decimal(14,2) NOT NULL,
  `CajaOrigen` int(11) NOT NULL COMMENT 'Caja Origen para la Transferencia',
  `CajaDestino` int(11) NOT NULL COMMENT 'Caja Destino de la Transferencia',
  `Estatus` char(1) NOT NULL COMMENT 'A : Alta\\nR: Recibido\\n',
  `MonedaID` int(11) NOT NULL COMMENT 'Corresponde a la Tabla MONEDAS',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Corresponde con la tabla\nPOLIZACONTABLE, nos ayuda a\ncuadrar la poliza cuando \ntransfiere y recibe efectivo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `idx_HISCAJASTRANSFER_1` (`FechaCorte`,`SucursalOrigen`,`CajaOrigen`),
  KEY `idx_HISCAJASTRANSFER_2` (`FechaCorte`,`SucursalDestino`,`CajaDestino`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico Transferencia entre cajas'$$
