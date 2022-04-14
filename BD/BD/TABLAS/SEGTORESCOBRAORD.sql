-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTORESCOBRAORD
DELIMITER ;
DROP TABLE IF EXISTS `SEGTORESCOBRAORD`;DELIMITER $$

CREATE TABLE `SEGTORESCOBRAORD` (
  `SegtoPrograID` int(11) NOT NULL,
  `SegtoRealizaID` int(11) NOT NULL,
  `FechaPromPago` date DEFAULT NULL COMMENT 'Fecha Promesa de Pago',
  `MontoPromPago` decimal(14,2) DEFAULT NULL COMMENT 'Monto Promesa de Pago',
  `ExistFlujo` char(1) DEFAULT NULL COMMENT 'Existira Flujo de Efectivo\nS.-Si\nN.-No\n',
  `FechaEstFlujo` date DEFAULT NULL COMMENT 'Fecha Estimada de Flujo',
  `OrigenPagoID` int(11) DEFAULT NULL COMMENT 'ID de Origen de Pago, FK SEGTOORIGENPAGO',
  `MotivoNPID` int(11) DEFAULT NULL COMMENT 'ID del Motivo de No Pago, FK SEGTOMOTIVNOPAGO',
  `NombreOriRecursos` varchar(200) DEFAULT NULL COMMENT 'Nombre persona de Origen de los Recursos',
  `TelefonoFijo` varchar(25) DEFAULT NULL COMMENT 'Telefono Fijo del Cliente',
  `TelefonoCel` varchar(25) DEFAULT NULL COMMENT 'Telefono Celular del Cliente',
  `EmpresaID` int(11) unsigned DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SegtoPrograID`,`SegtoRealizaID`),
  KEY `fk_SEGTORESCOBRAORD_1_idx` (`OrigenPagoID`),
  KEY `fk_SEGTORESCOBRAORD_2_idx` (`MotivoNPID`),
  CONSTRAINT `fk_SEGTORESCOBRAORD_2` FOREIGN KEY (`MotivoNPID`) REFERENCES `SEGTOMOTIVNOPAGO` (`MotivoNPID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar campos para \nSeguimiento de Cobranza Administrativa'$$