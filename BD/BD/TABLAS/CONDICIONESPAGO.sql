-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONDICIONESPAGO
DELIMITER ;
DROP TABLE IF EXISTS `CONDICIONESPAGO`;DELIMITER $$

CREATE TABLE `CONDICIONESPAGO` (
  `CondicionPagoID` int(11) NOT NULL COMMENT 'Indentificador Condicion Pago',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion Condicion Pago',
  `NumeroDias` int(11) DEFAULT NULL COMMENT 'Numero de dias para pagar.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CondicionPagoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para definir las condiciones de pago'$$