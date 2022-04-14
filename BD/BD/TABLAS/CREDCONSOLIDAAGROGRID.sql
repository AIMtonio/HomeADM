-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDCONSOLIDAAGROGRID
DELIMITER ;
DROP TABLE IF EXISTS `CREDCONSOLIDAAGROGRID`;
DELIMITER $$

CREATE TABLE `CREDCONSOLIDAAGROGRID` (
  `DetGridID` bigint(12) NOT NULL COMMENT 'ID o Referencia de Detalle de Consolidacion',
  `FolioConsolida` bigint(12) NOT NULL COMMENT 'ID o Referencia de Consolidacion',
  `SolicitudCreditoID` bigint(20) NOT NULL COMMENT 'Número de Solicitud',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Crédito',
  `Transaccion` BIGINT(20) NOT NULL COMMENT 'Número de Transacción de la tabla en sesión',
  `MontoCredito` decimal(14,2) NOT NULL COMMENT 'Monto del Credito',
  `MontoProyeccion` DECIMAL(14,2) NOT NULL COMMENT 'Monto del Proyección',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`DetGridID`,`FolioConsolida`,`Transaccion`),
  KEY `IDX_CREDCONSOLIDAAGROGRID_1` (`SolicitudCreditoID`),
  KEY `IDX_CREDCONSOLIDAAGROGRID_2` (`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla Espejo para el GRID de proceso de Consolidacion de Creditos'$$