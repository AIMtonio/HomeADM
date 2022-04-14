-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAPACIDADPAGO
DELIMITER ;
DROP TABLE IF EXISTS `CAPACIDADPAGO`;DELIMITER $$

CREATE TABLE `CAPACIDADPAGO` (
  `CapacidadPagoID` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Cliente al que se le realizó la estimación',
  `UsuarioID` int(11) NOT NULL DEFAULT '0' COMMENT 'Usuario que registra la estimación de capacidad de pago',
  `SucursalID` int(11) NOT NULL DEFAULT '0' COMMENT 'Sucursal en la que se registra la estimación',
  `ProducCredito1` int(11) NOT NULL DEFAULT '0' COMMENT 'Producto de credito 1',
  `ProducCredito2` int(11) NOT NULL DEFAULT '0' COMMENT 'Producto de credito 2',
  `ProducCredito3` int(11) NOT NULL DEFAULT '0' COMMENT 'Producto de credito 3',
  `TasaInteres1` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Es la tasa periodica, expresada mensualmente. Utilizada para el cálculo del producto de crédito 1',
  `TasaInteres2` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Es la tasa periodica, expresada mensualmente. Utilizada para el cálculo del producto de crédito 2',
  `TasaInteres3` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Es la tasa periodica, expresada mensualmente. Utilizada para el cálculo del producto de crédito 3',
  `IngresoMensual` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Ingreso mensula del cliente',
  `GastoMensual` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'gasto mensual del cliente',
  `MontoSolicitado` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto del credito solicitado',
  `AbonoPropuesto` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Abono propuesto por el cliente',
  `Plazo` varchar(750) NOT NULL DEFAULT '' COMMENT 'ID de los Plazos en meses',
  `AbonoEstimado` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Abono propuesto por el cliente menos la cuota mayor calculada por el simulador',
  `IngresosGastos` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Ingreso mensual menos gasto mensual',
  `Cobertura` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT '(ingresos - egresos ) / cuota mayor simulador',
  `CobSinPrestamo` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Cobertura sin prestamo  = Gasto mensual mas el 10% del gasto mensual, divido el ingreso mensual',
  `CobConPrestamo` decimal(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Cobertura con prestamo = (gasto mensual mas el 0.1 + cuota mas alta del simulador ) / ingreso mensual',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en la que se calculó la capacidad de pago para el cliente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de la empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`CapacidadPagoID`),
  KEY `FK_ClienteID_5` (`ClienteID`),
  KEY `FK_UsuarioID_3` (`UsuarioID`),
  KEY `FK_SucursalID_3` (`SucursalID`),
  KEY `FK_ProducCreditoID_1` (`ProducCredito1`),
  KEY `FK_ProducCreditoID_2` (`ProducCredito2`),
  KEY `FK_ProducCreditoID_3` (`ProducCredito3`),
  CONSTRAINT `FK_ClienteID_5` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`),
  CONSTRAINT `FK_ProducCreditoID_1` FOREIGN KEY (`ProducCredito1`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`),
  CONSTRAINT `FK_ProducCreditoID_2` FOREIGN KEY (`ProducCredito2`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`),
  CONSTRAINT `FK_ProducCreditoID_3` FOREIGN KEY (`ProducCredito3`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_SucursalID_3` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`),
  CONSTRAINT `FK_UsuarioID_3` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Almacena la ultima estimación de capacidad de pago calculada'$$