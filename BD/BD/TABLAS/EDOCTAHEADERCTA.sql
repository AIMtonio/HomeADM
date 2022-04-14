-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERCTA
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHEADERCTA`;DELIMITER $$

CREATE TABLE `EDOCTAHEADERCTA` (
  `AnioMes` int(11) NOT NULL COMMENT 'Anio mes',
  `SucursalID` int(11) NOT NULL COMMENT 'Identificador de la Sucursal',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador de la cuenta',
  `ProductoDesc` varchar(60) NOT NULL COMMENT 'Descripcion del producto',
  `Clabe` varchar(18) NOT NULL COMMENT 'Clabe',
  `SaldoMesAnterior` decimal(14,2) NOT NULL COMMENT 'Saldo del mes anterior',
  `SaldoActual` decimal(14,2) NOT NULL COMMENT 'Saldo actual',
  `SaldoPromedio` decimal(14,2) NOT NULL COMMENT 'Saldo promedio',
  `SaldoMinimo` decimal(14,2) NOT NULL COMMENT 'Saldo minimo',
  `ISRRetenido` decimal(14,2) NOT NULL COMMENT 'ISR retenido',
  `GatNominal` decimal(5,2) NOT NULL COMMENT 'Gat nominal',
  `GatReal` decimal(5,2) NOT NULL COMMENT 'Gat real',
  `TasaBruta` decimal(5,2) NOT NULL COMMENT 'Tasa Bruta',
  `InteresPerido` decimal(14,2) NOT NULL COMMENT 'Interes periodo',
  `MontoComision` decimal(14,2) NOT NULL COMMENT 'Monto de la comision',
  `IvaComision` decimal(14,2) NOT NULL COMMENT 'Iva de la comision',
  `MonedaID` int(11) NOT NULL COMMENT 'Identificador de la comision',
  `MonedaDescri` varchar(45) NOT NULL COMMENT 'Descripcion de la moneda',
  `Etiqueta` varchar(60) NOT NULL COMMENT 'Etiqueta',
  `Depositos` decimal(14,2) NOT NULL COMMENT 'Deposito',
  `Retiros` decimal(14,2) NOT NULL COMMENT 'Retiros',
  `Estatus` varchar(25) NOT NULL COMMENT 'Estatus',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`SucursalID`,`CuentaAhoID`),
  KEY `INDEX_EDCTAHEADERCTA_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que representa la cabecera del detalle de cuentas de ahorro en el estado de cuenta'$$