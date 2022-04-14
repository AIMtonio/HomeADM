-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGRODET
DELIMITER ;
DROP TABLE IF EXISTS `CRECONSOLIDAAGRODET`;
DELIMITER $$

CREATE TABLE `CRECONSOLIDAAGRODET`(
  `DetConsolidaID` bigint(12) NOT NULL COMMENT 'ID o Referencia de Detalle de Consolidacion',
  `FolioConsolida` bigint(12) NOT NULL COMMENT 'ID o Referencia de Consolidacion',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Número de Solicitud',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Crédito',
  `MontoCredito` decimal(14,2) NOT NULL COMMENT 'Monto del Crédito',
  `MontoProyeccion` DECIMAL(14,2) NOT NULL COMMENT 'Monto del Proyección',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Consolidacion.\nN = No Autorizada,\nA = Autorizada \nC = Cancelada',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`DetConsolidaID`,`FolioConsolida`),
  KEY `IDX_CRECONSOLIDAAGRODET_1` (`SolicitudCreditoID`),
  KEY `IDX_CRECONSOLIDAAGRODET_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla de Detalla para el proceso de Consolidacion de Creditos'$$