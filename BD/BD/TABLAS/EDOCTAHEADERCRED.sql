-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERCRED
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHEADERCRED`;
DELIMITER $$

CREATE TABLE `EDOCTAHEADERCRED` (
  `AnioMes` int(11) NOT NULL COMMENT 'Anio mes',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Identificacion de credito',
  `ClienteID` int(11) NOT NULL COMMENT 'Identificador del cliente',
  `NombreProducto` varchar(100) NOT NULL COMMENT 'Referencia de ProductoCred tabla EDOCTARESUMCREDITOS',
  `MontoOtorgado` decimal(14,2) NOT NULL COMMENT 'Monto otorgado',
  `FechaVencimiento` date NOT NULL COMMENT 'Fecha de vencimiento',
  `SaldoInsoluto` decimal(14,2) NOT NULL COMMENT 'Saldo insoluto',
  `SaldoInicial` decimal(14,2) NOT NULL COMMENT 'Saldo inicial',
  `Pagos` varchar(50) NOT NULL COMMENT 'Pagos',
  `Cat` decimal(18,2) NOT NULL COMMENT 'Cat',
  `TasaFija` decimal(18,2) NOT NULL COMMENT 'Tasa ordinaria',
  `TasaMoratoria` decimal(18,2) NOT NULL COMMENT 'Tasa moratoria',
  `IntPagadoPerido` decimal(18,2) NOT NULL COMMENT 'Intereses que se pagaron en el periodo',
  `IvaIntPagadoPerido` decimal(18,2) NOT NULL COMMENT 'Iva de interes de pago en el periodo',
  `TotalComisionesPagar` decimal(14,2) NOT NULL COMMENT 'Total de comision pagada',
  `IvaComPagadoPeriodo` decimal(18,2) NOT NULL COMMENT 'Iva de comision pagado en el periodo',
  `TotalPagar` decimal(14,2) NOT NULL COMMENT 'Total a pagar',
  `CapitalApagar` decimal(14,2) NOT NULL COMMENT 'Capital a pagar',
  `InteresNormalApagar` decimal(14,2) NOT NULL COMMENT 'Interes normal a pagar',
  `IvaInteresNomalApagar` decimal(14,2) NOT NULL COMMENT 'Iva interes normal a pagar',
  `OtrosCargosApagar` decimal(14,2) NOT NULL COMMENT 'Otros cargos a pagar',
  `IvaOtrosCargosApagar` decimal(14,2) NOT NULL COMMENT 'Iva otros cargos a pagar',
  `FechaProximoPago` date NOT NULL COMMENT 'Fecha proximo de pago',
  `FechaProxPagoLeyenda` varchar(10) NOT NULL COMMENT 'Fecha proximo pago leyenda',
  `Moratorios` decimal(14,2) NOT NULL COMMENT 'Moratorios a pagar',
  `IVAMoratorios` decimal(14,2) NOT NULL COMMENT 'IVA de moratorios a pagar',
  `SalMontoAccesorio` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de accesorios',
  `SalIVAAccesorio` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de IVA de los accesorios',
  `CuoMontoAccesorio` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de IVA de los accesorios',
  `CuoIVAAccesorio` DECIMAL(12,2) NULL DEFAULT 0.00 COMMENT 'Almacena el importe de IVA de los accesorios',
  `LitrosMeta` INT(11) NOT NULL COMMENT 'Litros Consumidos del Vehiculo',
  `TotalLitros` INT(11) NOT NULL COMMENT 'Total de litros',
  `LitConsumidos` INT(11) NOT NULL COMMENT 'Consumo total de litros en un periodo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`ClienteID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar la informacion del encabezado de los creditos del cliente durante el periodo'$$