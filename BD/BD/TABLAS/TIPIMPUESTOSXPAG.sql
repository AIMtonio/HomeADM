-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPIMPUESTOSXPAG
DELIMITER ;
DROP TABLE IF EXISTS `TIPIMPUESTOSXPAG`;DELIMITER $$

CREATE TABLE `TIPIMPUESTOSXPAG` (
  `TipImpuestoID` int(11) NOT NULL COMMENT 'ID Tipo de Impuesto por Pagar',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion Del Impuesto',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipImpuestoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Impuesto por Pagar'$$