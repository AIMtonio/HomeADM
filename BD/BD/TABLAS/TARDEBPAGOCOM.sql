-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPAGOCOM
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBPAGOCOM`;DELIMITER $$

CREATE TABLE `TARDEBPAGOCOM` (
  `TarDebPagoComID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID consecutivo de la tabla',
  `TarjetaDebID` char(16) DEFAULT NULL COMMENT 'ID de la tarjeta de credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente al que pertenece la tarjeta de debito',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `MontoComision` int(11) DEFAULT NULL COMMENT 'Monto de la comision anual',
  `MontoIVA` decimal(14,2) DEFAULT NULL COMMENT 'Monto de iva cobrada por el monto de comision anual',
  `MontoTotal` decimal(14,2) DEFAULT NULL COMMENT 'Monto total = MontoComision + IVA',
  `FormaPago` char(1) DEFAULT NULL COMMENT 'Forma en que paga la comision, V = Ventanilla, A = proceso Automatico',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Caja en la que se realiza el pago (solo para pago en ventanilla)',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal en la que se realiza el pago (solo para pago en ventanilla)',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en la que se realizó el pago de comision anual',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`TarDebPagoComID`),
  KEY `Index_Fecha` (`Fecha`),
  KEY `FK_ClienteID_11` (`ClienteID`),
  KEY `FK_TarjetaDebID_1` (`TarjetaDebID`),
  KEY `FK_CuentaAhoID_1` (`CuentaAhoID`),
  CONSTRAINT `FK_ClienteID_11` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_TarjetaDebID_1` FOREIGN KEY (`TarjetaDebID`) REFERENCES `TARJETADEBITO` (`TarjetaDebID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena los pagos de comisión anual que se le realizó a las'$$