-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUM015INV
DELIMITER ;
DROP TABLE IF EXISTS `EDOCTARESUM015INV`;
DELIMITER $$


CREATE TABLE `EDOCTARESUM015INV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `InversionID` int(11) DEFAULT NULL COMMENT 'Numero de Inversion',
  `Descripcion` varchar(70) DEFAULT NULL COMMENT 'Descripcion de la Inversion',
  `Apertura` decimal(14,2) DEFAULT NULL COMMENT 'Monto de Apertura de la Inversion',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `Interes` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Interes',
  `Provision` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Provision',
  `ISR` decimal(14,2) DEFAULT NULL COMMENT 'Monto ISR',
  `Penalizacion` decimal(14,2) DEFAULT NULL COMMENT 'Monto Penalizacion',
  `IVAPenalizacion` decimal(14,2) DEFAULT NULL COMMENT 'Monto de IVA de la Penalizacion',
  `Deposito` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Deposito',
  `Retiro` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Retiro',
  `Orden` int(11) DEFAULT NULL COMMENT 'Orden',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del Proceso',
  `Referencia` bigint(20) DEFAULT NULL COMMENT 'Referencia de la Inversion',
  `TipoMovAhoID` char(4) DEFAULT NULL COMMENT 'Tipo de Movimiento',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT COMMENT='Resumen de las inversiones del Cliente Sofi Express'$$
