-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOSACCESORIOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSACCESORIOS`;
DELIMITER $$


CREATE TABLE `TMPCREDITOSACCESORIOS` (
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo de Registros',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Numero de Amortizacion',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigible',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'TIpo de Calculo de Interes',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal de Origen del Cliente',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'Numero de Producto de Credito',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'Clasificacion del Credito',
  `SubClasifID` int(11) DEFAULT NULL COMMENT 'Subclasificacion del Destino de Credito',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal del Credito',
  `CobraAccesorios` char(1) DEFAULT NULL COMMENT 'Indica si cobra Accesorios\nS: SI\nN: NO',
  `AccesorioID` int(11) DEFAULT NULL COMMENT 'ID del Accesorio',
  `MontoAccesorio` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Accesorio',
  `IVAAccesorio` decimal(14,2) DEFAULT NULL COMMENT 'IVA del Accesorio',
  `CobraIVA` char(1) DEFAULT NULL COMMENT 'Indica si el Accesorio cobra o no cobra IVA',
  `PagaIVA` char(1) DEFAULT NULL COMMENT 'Indica si el cliente paga IVA',
  `MontoIntCuota` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto de interes del Accesorio',
  `SaldoInteres` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de interes del Accesorio',
  `CobraIVAInteres` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el accesorio cobra o no cobra IVA de interes',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Consecutivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Auxiliar para cobrar los accesorios de un credito.'$$