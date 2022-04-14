-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSFONDEO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSFONDEO`;DELIMITER $$

CREATE TABLE `TIPOSMOVSFONDEO` (
  `TipoMovFonID` int(4) NOT NULL COMMENT 'ID',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del tipo de Movimiento',
  `PrealacionPago` int(2) DEFAULT NULL COMMENT 'Orden o Prelacion de Pago',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  PRIMARY KEY (`TipoMovFonID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de movimiento de Fondeo'$$