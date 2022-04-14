-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROSXTIPO
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBGIROSXTIPO`;DELIMITER $$

CREATE TABLE `TARDEBGIROSXTIPO` (
  `TipoTarjetaDebID` int(11) NOT NULL COMMENT 'ID del Tipo de Tarjeta de Debito',
  `GiroID` char(4) NOT NULL COMMENT 'Codigo MerchanType Segun ISO8583 Aceptado para este tipo de Tarjeta Debito.',
  `EmpresaID` int(11) DEFAULT NULL,
  `UsuarioID` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoTarjetaDebID`,`GiroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Giros Aceptados por Tipo de Tarjeta de Debito.'$$