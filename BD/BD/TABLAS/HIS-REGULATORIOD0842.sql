-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-REGULATORIOD0842
DELIMITER ;
DROP TABLE IF EXISTS `HIS-REGULATORIOD0842`;DELIMITER $$

CREATE TABLE `HIS-REGULATORIOD0842` (
  `Anio` int(6) NOT NULL COMMENT 'Año del periodo',
  `Mes` int(6) NOT NULL COMMENT 'Mes del Periodo',
  `Periodo` varchar(6) NOT NULL COMMENT 'Perido Concatenado',
  `ClaveEntidad` varchar(6) NOT NULL COMMENT 'Clave de la Entidad',
  `Formulario` int(4) NOT NULL COMMENT 'Número de Subreporte',
  `NumeroIden` varchar(12) NOT NULL COMMENT 'Número de Identificación',
  `TipoPrestamista` int(3) NOT NULL COMMENT 'Tipo de orgáno prestamista',
  `ClavePrestamista` varchar(20) NOT NULL COMMENT 'Clave de prestamista',
  `NumeroContrato` varchar(12) NOT NULL COMMENT 'Número de contrato',
  `NumeroCuenta` varchar(12) NOT NULL COMMENT 'Número de cuenta',
  `FechaContra` varchar(12) NOT NULL COMMENT 'Fecha de Contratación',
  `FechaVencim` varchar(12) NOT NULL COMMENT 'Fecha de Vencimiento',
  `TasaAnual` decimal(6,2) NOT NULL COMMENT 'Valor de la tasa anual',
  `Plazo` int(4) NOT NULL COMMENT 'Plazo ',
  `PeriodoPago` int(3) NOT NULL COMMENT 'Periodicidad del plan de pagos',
  `MontoRecibido` double NOT NULL COMMENT 'Monto Original Recibido',
  `TipoCRedito` int(3) NOT NULL COMMENT 'Tipo de crédito',
  `Destino` int(3) NOT NULL COMMENT 'Destino del crédito',
  `TipoGarantia` int(3) NOT NULL COMMENT 'Tipo de garantía del crédito',
  `MontoGarantia` double NOT NULL COMMENT 'Monto o valor de garantía',
  `FechaPago` varchar(12) NOT NULL COMMENT 'Fecha del pago inmediato',
  `MontoPago` double NOT NULL COMMENT 'Monto del pago inmediato',
  `ClasificaCortLarg` int(3) NOT NULL COMMENT 'Clasificación corto o largo',
  `SalInsoluto` double NOT NULL COMMENT 'Saldo insoluto del préstamo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  `Consecutivo` int(11) DEFAULT NULL,
  KEY `INDEX_HIS-REGULATORIO0842` (`Anio`,`Mes`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar los datos del RegulatorioD0842'$$