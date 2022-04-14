-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPVENCIMCREREP
DELIMITER ;
DROP TABLE IF EXISTS `TMPVENCIMCREREP`;
DELIMITER $$


CREATE TABLE `TMPVENCIMCREREP` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Transaccion` bigint(20) DEFAULT NULL COMMENT 'Número de transaccion que usa como llave de todos los movimientos por consulta de reporte',
  `GrupoID` int(12) DEFAULT NULL COMMENT 'Número de grupo al que pertenece la amortizacion de credito de un credito que tiene un cliente',
  `NombreGrupo` varchar(200) DEFAULT NULL COMMENT 'Nombre del grupo si el credito es grupal ',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número de crédito ',
  `CicloGrupo` int(12) DEFAULT NULL COMMENT 'ciclo actual de grupo',
  `ClienteID` int(12) DEFAULT NULL COMMENT 'cliente relacionado con el credito',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'nombre del cliente',
  `MontoCredito` decimal(14,2) DEFAULT NULL COMMENT 'cantidad total del crédito',
  `FechaInicio` date DEFAULT NULL COMMENT 'fecha de inicio del credito',
  `FechaVencimien` date DEFAULT NULL COMMENT 'fecha vencimiento del credito',
  `FechaVencim` date DEFAULT NULL COMMENT 'fecha de vencimiento de la amortización del crédito',
  `EstatusCredito` varchar(50) DEFAULT NULL COMMENT 'estatus actual del credito',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'cantodad de capital',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'cantidad generada porinteres',
  `Moratorios` decimal(14,2) DEFAULT NULL COMMENT 'cantidad de cargos moratorios',
  `Comisiones` decimal(14,2) DEFAULT NULL COMMENT 'comisiones ',
  `Cargos` decimal(14,2) DEFAULT NULL COMMENT 'cargos',
  `AmortizacionID` int(12) DEFAULT NULL COMMENT 'identificador de la amortizacion',
  `IVATotal` decimal(14,2) DEFAULT NULL COMMENT 'cargo de iva total',
  `CobraIVAMora` char(1) DEFAULT NULL COMMENT 'cobra mora "S" .- si "N".- no',
  `CobraIVAInteres` char(1) DEFAULT NULL COMMENT 'cobra interes "S" si "N" no',
  `SucursalID` int(12) DEFAULT NULL COMMENT 'Número de la sucursal',
  `NombreSucurs` varchar(50) DEFAULT NULL COMMENT 'Nombre de la sucursal',
  `ProductoCreditoID` int(12) DEFAULT NULL COMMENT 'Número del producto de credito',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'descripcion del producto de credito',
  `PromotorActual` int(12) DEFAULT NULL COMMENT 'número de Promotor relacionado',
  `NombrePromotor` varchar(100) DEFAULT NULL COMMENT 'nombre de promotor relacionado',
  `TotalCuota` decimal(14,2) DEFAULT NULL COMMENT 'total de cuotas',
  `Pago` decimal(14,2) DEFAULT NULL COMMENT 'cantidad de pago ',
  `FechaPago` date DEFAULT NULL COMMENT 'fecha en la que hizo el pago',
  `DiasAtraso` int(12) DEFAULT NULL COMMENT 'cantidad de dias de atraso fechasistema - fechaexigible',
  `SaldoTotal` decimal(14,2) DEFAULT NULL COMMENT 'saldo total',
  `InstitNominaID` int(11) DEFAULT NULL COMMENT 'ID de la institucion de credito',
  `NombreInstit` varchar(200) DEFAULT NULL COMMENT 'ID de la institucion de credito',
  `ConvenioNominaID` bigint unsigned DEFAULT NULL COMMENT 'ID del conevnio de nomina',
  `FechaEmision` date DEFAULT NULL COMMENT 'Fecha de emisión',
  `HoraEmision` time DEFAULT NULL COMMENT 'Hora de emisión',
  KEY `idx_TMPVENCIMCREREP_1` (`CreditoID`),
  KEY `idx_TMPVENCIMCREREP_2` (`DiasAtraso`),
  KEY `idx_TMPVENCIMCREREP_3` (`Transaccion`),
  PRIMARY KEY (`RegistroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para agilizar los procesos de la consulta a r'$$

