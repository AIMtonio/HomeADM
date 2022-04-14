-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOMOVSCONCILIA
DELIMITER ;
DROP TABLE IF EXISTS `TESOMOVSCONCILIA`;
DELIMITER $$


CREATE TABLE `TESOMOVSCONCILIA` (
  `FolioCargaID` bigint(17) DEFAULT NULL COMMENT 'Folio unico de Carga de Archivo a Conciliar',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NumeroMov` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion del Movimiento (se llena al conciliar)',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `NumCtaInstit` varchar(20) DEFAULT NULL COMMENT 'Numero de Cuenta En el Banco(Institucion)',
  `FechaCarga` date DEFAULT NULL COMMENT 'Fecha de Carga de Archivo a Conciliar',
  `FechaOperacion` date DEFAULT NULL COMMENT 'Fecha de Registro de la Operacion en el Banco',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento  C=Cargo, A=Abono',
  `MontoMov` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Movimiento',
  `TipoMov` char(4) DEFAULT NULL COMMENT 'Id del Tipo de Movimiento (se llena al conciliar)',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Decripcion del Movimiento (la que trae en la carga)',
  `ReferenciaMov` varchar(150) DEFAULT NULL COMMENT 'Referencia del Movimiento (se llena al Conciliar)',
  `Status` char(1) DEFAULT NULL COMMENT 'Estatus de\nConciliacion \nNacen como\n N=No Conciliado\n C=Conciliado',
  `EstatusConciliaIN` char(1) DEFAULT NULL COMMENT 'N= No aplicado (Indica que no se utilizado para la aplicación de pagos nómina de creditos)\nA= Aplicado ',
  `EstAplicaInst` char(1) DEFAULT 'N' COMMENT 'Indica si se aplico el pago institucion A:APLICADO/N:NO_APLICADO',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `fk_TESOMOVSCONCILIA_2` (`InstitucionID`),
  KEY `fk_TESOMOVSCONCILIA_3` (`TipoMov`),
  KEY `Index_NumCtaInstit` (`NumCtaInstit`),
  KEY `fk_TESOMOVSCONCILIA_1` (`CuentaAhoID`),
  CONSTRAINT `fk_TESOMOVSCONCILIA_1` FOREIGN KEY (`CuentaAhoID`) REFERENCES `CUENTASAHOTESO` (`CuentaAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TESOMOVSCONCILIA_2` FOREIGN KEY (`InstitucionID`) REFERENCES `INSTITUCIONES` (`InstitucionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Carga de Movimientos a Conciliar'$$