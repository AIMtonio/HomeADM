-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIRESUM
DELIMITER ;
DROP TABLE IF EXISTS `TARDEBCONCIRESUM`;DELIMITER $$

CREATE TABLE `TARDEBCONCIRESUM` (
  `ConciliaID` int(11) NOT NULL COMMENT 'FK de la tabla TARDEBCONCILIAHEADER ',
  `ResumenID` int(11) NOT NULL COMMENT 'Identificador del ultimo registro del arhivo de conciliacion',
  `NoTotalTransac` int(11) DEFAULT NULL COMMENT 'Total de transacciones de detalle \n( sin contar header ni trailer), valor default (1)\n',
  `NoTotalVentas` int(11) DEFAULT NULL COMMENT 'Total de transacciones (ventas)\n',
  `ImporteVtas` decimal(13,2) DEFAULT NULL COMMENT 'Importe de registro de ventas\nen Moneda Destino',
  `NoTotalDisposic` int(11) DEFAULT NULL COMMENT 'Número total de disposiciones',
  `ImporteDisposicion` decimal(13,2) DEFAULT NULL COMMENT 'Importe de disposición de efectivo en el archivo\nen Moneda Destino',
  `NoTotalTransDebito` int(11) DEFAULT NULL COMMENT 'Total de registros de transacciones débito en el archivo',
  `ImporteTransDebito` decimal(13,2) DEFAULT NULL COMMENT 'Importe total de transacciones débito en el archivo\nMoneda Destino',
  `NoTotalPagosInter` int(11) DEFAULT NULL COMMENT 'Numero total de Registros de Pagos Interbancarios\nNumero total de transacciones de cargos por tarjeta en el\narchivo.\n',
  `ImportePagosInter` decimal(13,2) DEFAULT NULL COMMENT 'Importe total de cargos por tarjeta',
  `NoTotalDevolucion` int(11) DEFAULT NULL COMMENT 'Total de devoluciones en el archivo\n',
  `ImporteTotalDevol` decimal(13,2) DEFAULT NULL COMMENT 'Importe total de devoluciones en el archivo',
  `NoTotalTransCto` int(11) DEFAULT NULL COMMENT 'Numero Total de transacciones de credito en el archivo\n',
  `ImporteTransCto` decimal(13,2) DEFAULT NULL COMMENT 'Importe total de creditos',
  `NoTotalRepresenta` int(11) DEFAULT NULL COMMENT 'Numero Total de Representaciones en el archivo',
  `ImporteRepresenta` decimal(13,2) DEFAULT NULL,
  `NoTotalContracargos` int(11) DEFAULT NULL COMMENT 'total de Contracargos en el archivo\n',
  `ImporteContracargos` decimal(13,2) DEFAULT NULL,
  `ImporteComisiones` decimal(13,2) DEFAULT NULL COMMENT 'Importe total de comisiones\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`ConciliaID`,`ResumenID`),
  KEY `fk_TARDEBCONCITRAILER_1_idx` (`ConciliaID`),
  KEY `Index_ResumenID` (`ResumenID`),
  CONSTRAINT `fk_TARDEBCONCITRAILER_1` FOREIGN KEY (`ConciliaID`) REFERENCES `TARDEBCONCIENCABEZA` (`ConciliaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$