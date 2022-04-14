-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTE
DELIMITER ;
DROP TABLE IF EXISTS `SEGUROCLIENTE`;DELIMITER $$

CREATE TABLE `SEGUROCLIENTE` (
  `SeguroClienteID` int(11) NOT NULL COMMENT 'ID de la tabla del Seguro de Vida',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio del Seguro del Cliente',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento del Seguro del Cliente',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Seguro del Cliente (Inactivo,Vigente,Cobrado,Vencido(B), Cancelado(K) )',
  `MontoSeguro` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Poliza Seguro del Cliente en caso de Siniestro',
  `MontoSegAyuda` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la Aportacion del seguro del cliente',
  `MontoSegPagado` decimal(14,2) DEFAULT NULL COMMENT 'Monto que el cliente ya ha pagado  de la aportacion del Seguro',
  `MotivoCamEst` int(11) DEFAULT NULL COMMENT 'Es el motivo de \nCambio de Estatus, \nen el caso de \ncancelacion se usan\nlos de la tabla \nMOTIVACTIVACION si se vence automatico es un numero 88\n',
  `Observacion` varchar(200) DEFAULT NULL COMMENT 'Son las Observaciones descritas en pantalla sobre el cambio de estatus en el caso de cancelacion.',
  `ClaveAutoriza` varchar(45) DEFAULT NULL COMMENT 'Es la clave del usuario que autorizo el cambio de estatus (en este caso la cancelación)',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguroClienteID`),
  KEY `fk_SEGUROCLIENTE_1` (`ClienteID`),
  KEY `fk_ClienteIDD` (`ClienteID`),
  CONSTRAINT `fk_ClienteIDD` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla referente al seguro del Cliente'$$