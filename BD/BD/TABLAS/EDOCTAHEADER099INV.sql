-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADER099INV
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHEADER099INV`;DELIMITER $$

CREATE TABLE `EDOCTAHEADER099INV` (
  `AnioMes` int(11) NOT NULL COMMENT 'Anio Mes Proceso Estado de cuenta',
  `SucursalID` int(11) NOT NULL COMMENT 'Sucursal del Cliente',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero del Cliente',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'Identificador de cuenta',
  `NombreProducto` varchar(100) NOT NULL COMMENT 'Nombre producto',
  `GatReal` decimal(14,2) NOT NULL COMMENT 'Gat real',
  `TotalComisionesCobradas` decimal(14,2) NOT NULL COMMENT 'Total de comisiones cobradas',
  `IvaComision` decimal(14,2) NOT NULL COMMENT 'Iva comision',
  `ISRretenido` decimal(14,2) NOT NULL COMMENT 'ISR retenido',
  `InversionID` bigint(11) NOT NULL COMMENT 'Numero Inversion',
  `TipoCuenta` varchar(150) NOT NULL COMMENT 'Tipo de Cuenta',
  `InvCapital` decimal(18,2) NOT NULL COMMENT 'Inversion de Capital',
  `FechaInicio` date NOT NULL COMMENT 'Fecha de Inicio de la Inversion',
  `FechaVence` date NOT NULL COMMENT 'Fecha Vencimiento de la Inversion',
  `TasaBruta` decimal(18,2) NOT NULL COMMENT 'Valor de la Tasa Bruta',
  `Plazo` int(11) NOT NULL COMMENT 'Plazo de la Inversion',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Inversion',
  `Gat` decimal(14,2) NOT NULL COMMENT 'Valor del Gat',
  `SucursalOrigen` int(11) NOT NULL COMMENT 'Sucursal origen donde se genera la inversion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de Auditoria',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de Auditoria',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de Auditoria',
  PRIMARY KEY (`AnioMes`,`SucursalID`,`InversionID`),
  KEY `INDEX_EDOCTAHEADER099INV_1` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para almacenar informacion para el encabezado de las inversiones en el reporte de estado de cuenta de clientes nuevos'$$