-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERINV
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTAHEADERINV`;
DELIMITER $$


CREATE TABLE `EDOCTAHEADERINV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `AnioMes` int(11) DEFAULT NULL COMMENT 'Anio Mes Proceso Estado de cuenta',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal del Cliente',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero del Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `InversionID` int(11) DEFAULT NULL COMMENT 'Numero Inversion',
  `TipoCuenta` varchar(150) DEFAULT NULL COMMENT 'Tipo de Cuenta',
  `InvCapital` decimal(18,2) DEFAULT NULL COMMENT 'Inversion de Capital',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Inversion',
  `FechaVence` date DEFAULT NULL COMMENT 'Fecha Vencimiento de la Inversion',
  `TasaBruta` decimal(18,2) DEFAULT NULL COMMENT 'Valor de la Tasa Bruta',
  `Plazo` int(11) DEFAULT NULL COMMENT 'Plazo de la Inversion',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Inversion',
  `Gat` float DEFAULT NULL COMMENT 'Valor del Gat',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para almacenar informacion para el encabezado de las inversiones en el reporte de estado de cuenta'$$
