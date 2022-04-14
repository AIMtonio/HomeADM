-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBESQUEMACOM
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBESQUEMACOM`;DELIMITER $$

CREATE TABLE `TARDEBESQUEMACOM` (
  `TarDebEsquemaID` int(11) NOT NULL COMMENT 'Id del Esquema de Comisiones',
  `TipoTarjetaDebID` int(11) NOT NULL COMMENT 'Tipo de tarjeta de debito FK de la tabla TARJETADEBITO',
  `TipoCuentaID` int(11) DEFAULT NULL COMMENT 'Tipo de Cuenta, FK TIPOSCUENTAS',
  `TarDebComisionID` int(11) DEFAULT NULL COMMENT 'Identificador del Catalogo de Comisiones, FK TARDEBCATCOMISIONES',
  `TipoComision` int(11) DEFAULT NULL COMMENT 'Tipo de Comision, 1-Monto Fijo, 2.- Por Transaccion',
  `LimiteTransacc` int(11) DEFAULT NULL COMMENT 'Numero de Transacciones permitidas para cada comision',
  `MontoComision` decimal(12,2) DEFAULT NULL COMMENT 'Importe de la comision',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del registro A.-Activo, C.-Cancelado',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TarDebEsquemaID`),
  KEY `fk_TARDEBESQUEMACOM_1` (`TipoTarjetaDebID`),
  KEY `fk_TARDEBESQUEMACOM_2` (`TipoCuentaID`),
  KEY `fk_TARDEBESQUEMACOM_3` (`TarDebComisionID`),
  CONSTRAINT `fk_TARDEBESQUEMACOM_1` FOREIGN KEY (`TipoTarjetaDebID`) REFERENCES `TIPOTARJETADEB` (`TipoTarjetaDebID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TARDEBESQUEMACOM_2` FOREIGN KEY (`TipoCuentaID`) REFERENCES `TIPOSCUENTAS` (`TipoCuentaID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_TARDEBESQUEMACOM_3` FOREIGN KEY (`TarDebComisionID`) REFERENCES `TARDEBCATCOMISIONES` (`TarDebComisionID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Esquema de Comisiones de la Tarjeta de Debito'$$