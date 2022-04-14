-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEARRENDA
DELIMITER ;
DROP TABLE IF EXISTS `DEPOSITOREFEARRENDA`;DELIMITER $$

CREATE TABLE `DEPOSITOREFEARRENDA` (
  `DepRefereID` bigint(17) NOT NULL COMMENT 'ID de Carga de deposito referenciado',
  `FolioCargaID` bigint(17) NOT NULL COMMENT 'Folio unico de Carga de Archivo es un consecutivo',
  `InstitucionID` int(11) NOT NULL COMMENT 'Id Del Banco (Institucion) de donde es la Cuenta',
  `NumCtaInstit` varchar(20) NOT NULL COMMENT 'ID de la Cuenta de ahorro',
  `NumeroMov` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de Transaccion del Movimiento (se llena al conciliar)',
  `FechaCarga` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Carga de Archivo a Conciliar',
  `FechaAplica` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Registro de la Operacion en el Banco',
  `NatMovimiento` char(1) NOT NULL DEFAULT 'N' COMMENT 'Naturaleza del Movimiento  C=Cargo, A=Abono',
  `MontoMov` decimal(12,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto del Movimiento',
  `TipoMov` char(4) NOT NULL COMMENT 'Id del Tipo de Movimiento Tabla TIPOSMOVTESO',
  `DescripcionMov` varchar(150) NOT NULL COMMENT 'Decripcion del Movimiento (la que trae en la carga)',
  `ReferenciaMov` varchar(40) NOT NULL COMMENT 'Referencia del Movimiento Debe ser el CREDITO o CUENTA',
  `Estatus` char(2) NOT NULL DEFAULT 'N' COMMENT 'Estatus de deposito \nNacen como \nN=No Aplicado\nNI = No identificado,\nA = Aplicado,\nC = Cancelado (borrado logicamente)',
  `TipoCanal` int(11) NOT NULL COMMENT 'Identifica el como ligar la referencia con ARRENDAMIENTOS = 1 o CLIENTES = 2',
  `TipoDeposito` char(1) NOT NULL COMMENT 'E = Si pago Efectivo\nT = Transferencia \nC = Cheque ',
  `PolizaID` bigint(17) NOT NULL DEFAULT '0' COMMENT 'Numero de poliza al aplicar el pago',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(20) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`DepRefereID`,`FolioCargaID`,`NumCtaInstit`,`InstitucionID`),
  KEY `FK_ DEPOSITOREFEREARRENDA_1` (`TipoMov`),
  KEY `FK_ DEPOSITOREFEREARRENDA_2` (`InstitucionID`,`NumCtaInstit`),
  CONSTRAINT `FK_ DEPOSITOREFEREARRENDA_1` FOREIGN KEY (`TipoMov`) REFERENCES `TIPOSMOVTESO` (`TipoMovTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_ DEPOSITOREFEREARRENDA_2` FOREIGN KEY (`InstitucionID`, `NumCtaInstit`) REFERENCES `CUENTASAHOTESO` (`InstitucionID`, `NumCtaInstit`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Carga de Depositos Referenciados de Arrendamientos'$$