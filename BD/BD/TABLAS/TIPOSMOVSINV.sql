-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSINV
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSINV`;DELIMITER $$

CREATE TABLE `TIPOSMOVSINV` (
  `TipoMovInvID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de \nInversion\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento\nDe Inversion',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoMovInvID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Movimientos del Modulo de  Inversiones'$$