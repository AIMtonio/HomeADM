-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROS
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBGIROS`;DELIMITER $$

CREATE TABLE `TARDEBGIROS` (
  `TarjetaDebID` char(16) NOT NULL COMMENT 'ID de la Tarjeta de Debito',
  `GiroID` char(4) NOT NULL DEFAULT '' COMMENT 'Codigo MerchanType Segun ISO8583 Aceptado para este tipo de Tarjeta Debito.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarjetaDebID`,`GiroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Giros Aceptados por Una Tarjeta de Debito En Partic'$$