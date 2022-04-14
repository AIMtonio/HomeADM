-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSINVBAN
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSINVBAN`;DELIMITER $$

CREATE TABLE `TIPOSMOVSINVBAN` (
  `TipoMovInbID` char(4) NOT NULL COMMENT 'ID del Tipo de \nMovimiento de \nInversion Bancaria\n',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del\nTipo de Movimiento',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Numero de usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha ultimo cambio',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP ultimo cambio',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa ultimo cambio',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`TipoMovInbID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Catalogo de Tipos de Movimientos de Inv.Bancarias'$$