-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJEROATMTRANSF
DELIMITER ;
DROP TABLE IF EXISTS `CAJEROATMTRANSF`;DELIMITER $$

CREATE TABLE `CAJEROATMTRANSF` (
  `CajeroTransfID` int(11) NOT NULL COMMENT 'Clave primaria de la tabla',
  `CajeroOrigenID` varchar(20) DEFAULT NULL COMMENT 'Cajero Origen de la transferencia	',
  `CajeroDestinoID` varchar(20) DEFAULT NULL COMMENT 'Cajero Destino  de la Transferencia',
  `Fecha` date DEFAULT NULL,
  `Cantidad` decimal(14,2) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Transferencia\nE: Enviada\nR: Recibido',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Numero de Moneda',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'sucursal origen de la transferencia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`CajeroTransfID`),
  KEY `fk_CAJEROSTRANSFER_2_idx` (`CajeroDestinoID`),
  KEY `fk_CAJEROSTRANSFER_3_idx` (`MonedaID`),
  CONSTRAINT `fk_CAJEROSTRANSFER_2` FOREIGN KEY (`CajeroDestinoID`) REFERENCES `CATCAJEROSATM` (`CajeroID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_CAJEROSTRANSFER_3` FOREIGN KEY (`MonedaID`) REFERENCES `MONEDAS` (`MonedaId`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$