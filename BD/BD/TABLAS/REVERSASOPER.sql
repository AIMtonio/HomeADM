-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSASOPER
DELIMITER ;
DROP TABLE IF EXISTS `REVERSASOPER`;DELIMITER $$

CREATE TABLE `REVERSASOPER` (
  `TransaccionID` int(11) NOT NULL,
  `Motivo` varchar(200) DEFAULT NULL COMMENT 'Motivo de la Reversa',
  `DescripcionOper` varchar(100) DEFAULT NULL COMMENT 'Descripción del tipo de operación de ventanilla',
  `TipoOperacion` int(11) DEFAULT NULL COMMENT 'ID del tipo de operacion correspondiente con la tabla CAJATIPOSOPERA',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Operacion ',
  `CajaID` int(11) DEFAULT NULL COMMENT 'ID de la caja desde la cual se realiza la reversa',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de sucursal',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se realiza la Transacción',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del Usuario que autoriza',
  `ClaveUsuarioAut` varchar(45) DEFAULT NULL COMMENT 'Clave del usuario que autoriza',
  `ContraseniaAut` varchar(45) DEFAULT NULL COMMENT 'Contraseña del usuario que autoriza',
  `Efectivo` decimal(14,2) DEFAULT NULL COMMENT 'Monto total Entregado o recibido',
  `Cambio` decimal(14,2) DEFAULT NULL COMMENT 'Total Cambio sobre el monto recibido',
  `Hora` time DEFAULT NULL COMMENT 'hora de la operación',
  `SaldoActualCta` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Actual de la cuenta, Para deposito a cta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TransaccionID`),
  KEY `fk_REVERSASTRAN_1_idx` (`CajaID`),
  KEY `fk_REVERSASTRAN_1_idx1` (`SucursalID`,`CajaID`),
  KEY `fk_Sucursal_2_idx` (`SucursalID`),
  KEY `fk_Usuario_2_idx` (`UsuarioID`),
  KEY `fk_TipoOperacion_2_idx` (`TipoOperacion`),
  CONSTRAINT `fk_REVERSASTRAN_1` FOREIGN KEY (`SucursalID`, `CajaID`) REFERENCES `CAJASVENTANILLA` (`SucursalID`, `CajaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Sucursal_2` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TipoOperacion_2` FOREIGN KEY (`TipoOperacion`) REFERENCES `CAJATIPOSOPERA` (`Numero`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuario_2` FOREIGN KEY (`UsuarioID`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='REVERSAS DE TRANSACCIONES DE OPERACIONES DE VENTANILLA'$$