-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-TASASAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `HIS-TASASAHORRO`;DELIMITER $$

CREATE TABLE `HIS-TASASAHORRO` (
  `Fecha` datetime NOT NULL COMMENT 'Fecha en que se inserto',
  `TasaAhorroID` int(11) NOT NULL COMMENT 'Numero de Tasa de Ahorro',
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuentas',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de persona: Fisica / Moral',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda del Tipo de Cuenta',
  `MontoInferior` decimal(12,2) DEFAULT NULL,
  `MontoSuperior` decimal(12,2) DEFAULT NULL,
  `Tasa` decimal(12,2) DEFAULT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historial de Tasas de Ahorro eliminadas'$$