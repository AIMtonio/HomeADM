-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCEDESVENCIMIENTOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCEDESVENCIMIENTOS`;
DELIMITER $$

CREATE TABLE `TMPCEDESVENCIMIENTOS` (
  `CedeID` int(11) NOT NULL COMMENT 'id de la tabla',
  `TipoCedeID` int(11) DEFAULT NULL COMMENT 'Tipo de CEDE',
  `DescripCede` varchar(200) DEFAULT NULL COMMENT 'Descripcion ',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente ID',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `TasaFija` decimal(14,4) DEFAULT NULL COMMENT 'tasa fija',
  `TasaISR` decimal(12,4) DEFAULT NULL COMMENT 'tasa ISR',
  `TasaNeta` decimal(12,4) DEFAULT NULL COMMENT 'tasa Neta',
  `Monto` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la CEDE',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la CEDE',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha en que se pagan los intereses, mientras no sea la fecha en que se paga capital se refiere a un dia habil antes\n',
  `InteresRetener` decimal(18,2) DEFAULT NULL COMMENT 'Interes a Retener ISR',
  `InteresGenerado` decimal(18,2) DEFAULT NULL COMMENT 'Saldo provision de la amortizacion',
  `InteresRecibir` decimal(19,2) DEFAULT NULL COMMENT 'Interes a Recibir',
  `TotalRecibir` decimal(20,2) DEFAULT NULL COMMENT 'Intereres Total',
  `MonedaId` int(11) NOT NULL COMMENT 'Numero de Moneda',
  `Descripcion` varchar(80) NOT NULL COMMENT 'Descripcion de la \nMoneda\n',
  `SucursalID` int(11) NOT NULL COMMENT 'Numero de Sucursal',
  `NombreSucurs` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Sucursal',
  `PromotorID` int(11) NOT NULL COMMENT 'Numero de Promotor',
  `NombrePromotor` varchar(100) NOT NULL COMMENT 'Nombre del Promotor',
  `Estatus` varchar(7) CHARACTER SET utf8 DEFAULT NULL COMMENT 'Estatus de la aportacion.',
  `EstatusAmortizacion` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\nN .- Vigente o en Proceso\nP .- Pagada',
  `Interes` decimal(18,2) DEFAULT NULL COMMENT 'Interes'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Temporal para el reporte de Vencimientos de CEDES.'$$