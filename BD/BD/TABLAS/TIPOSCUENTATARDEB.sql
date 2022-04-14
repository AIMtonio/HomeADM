-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCUENTATARDEB
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSCUENTATARDEB`;DELIMITER $$

CREATE TABLE `TIPOSCUENTATARDEB` (
  `TipoTarjetaDebID` int(11) NOT NULL COMMENT 'ID del Tipo de Tarjeta de Debito',
  `TipoCuentaID` int(12) NOT NULL COMMENT 'ID del Tipo de Cuenta de Ahorro',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoTarjetaDebID`,`TipoCuentaID`),
  KEY `fk_TIPOSCUENTATARDEB_1_idx` (`TipoTarjetaDebID`),
  KEY `fk_TIPOSCUENTATARDEB_2_idx` (`TipoCuentaID`),
  CONSTRAINT `fk_TIPOSCUENTATARDEB_1` FOREIGN KEY (`TipoTarjetaDebID`) REFERENCES `TIPOTARJETADEB` (`TipoTarjetaDebID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TIPOSCUENTATARDEB_2` FOREIGN KEY (`TipoCuentaID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Cuenta por Tipo de Tarjeta de Debito'$$