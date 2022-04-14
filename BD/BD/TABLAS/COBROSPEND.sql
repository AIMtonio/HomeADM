-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPEND
DELIMITER ;
DROP TABLE IF EXISTS `COBROSPEND`;DELIMITER $$

CREATE TABLE `COBROSPEND` (
  `ClienteID` int(11) NOT NULL COMMENT 'Id del cliente',
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0',
  `Fecha` date NOT NULL COMMENT 'Fecha en que se genero el cobro pendiente',
  `CantPenOri` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad Pendiente Original',
  `CantPenAct` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad Pendiente Actual',
  `IVA` decimal(12,2) DEFAULT NULL COMMENT 'iva del cobro pendiente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'P -  pendiente, (VALOR INICIAL)\nC  - cobrada, \nD -  Cancelado',
  `TipoMovAhoID` char(4) NOT NULL COMMENT 'Tipo de movimiento de ahorro',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se pago el cobro pendiente',
  `Descripcion` varchar(300) DEFAULT NULL COMMENT 'Descripcion del movimiento ',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de transaccion del Cobro pendiente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ClienteID`,`CuentaAhoID`,`Fecha`,`TipoMovAhoID`,`Transaccion`),
  KEY `index1` (`ClienteID`),
  KEY `index3` (`Fecha`),
  KEY `fk_COBROSPEND_1` (`TipoMovAhoID`),
  KEY `fk_COBROSPEND_3_idx` (`CuentaAhoID`),
  CONSTRAINT `fk_COBROSPEND_1` FOREIGN KEY (`TipoMovAhoID`) REFERENCES `TIPOSMOVSAHO` (`TipoMovAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_COBROSPEND_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_COBROSPEND_3` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$