-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROTIPOCONT
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBGIROTIPOCONT`;DELIMITER $$

CREATE TABLE `TARDEBGIROTIPOCONT` (
  `TipoTarjetaDebID` int(11) NOT NULL,
  `ClienteID` int(11) NOT NULL,
  `GiroID` char(4) NOT NULL,
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoTarjetaDebID`,`ClienteID`,`GiroID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Giros Aceptados por Tipo de Tarjeta de Debito y Con'$$