-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COLORTARJETAS
DELIMITER ;
DROP TABLE IF EXISTS `COLORTARJETAS`;DELIMITER $$

CREATE TABLE `COLORTARJETAS` (
  `ColorTarjeta` char(2) NOT NULL COMMENT 'ID del Color de Tarjeta de Debito',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Color de Tarjeta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'DireccionIP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'ProgramaID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ColorTarjeta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Colores de Tarjeta de Debito'$$