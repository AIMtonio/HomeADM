-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMITESOPERCLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `LIMITESOPERCLIENTE`;DELIMITER $$

CREATE TABLE `LIMITESOPERCLIENTE` (
  `LimiteOperID` int(11) NOT NULL COMMENT 'ID del Limite del Cliente',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente',
  `BancaMovil` char(1) NOT NULL COMMENT 'Campo para saber si el Cliente tiene limites de efectivo en Banca Movil o no\nS = SI (tiene limite en Banca Movil)\nN = NO (No tiene Limites)',
  `MonMaxBcaMovil` decimal(18,2) NOT NULL COMMENT 'Monto Maximo permitido desde Banca Movil',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`LimiteOperID`,`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los limites de opereciones por Cliente'$$