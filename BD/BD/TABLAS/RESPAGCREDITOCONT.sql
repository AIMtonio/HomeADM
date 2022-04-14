-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITOCONT
DELIMITER ;
DROP TABLE IF EXISTS `RESPAGCREDITOCONT`;
DELIMITER $$


CREATE TABLE `RESPAGCREDITOCONT` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Credito Respaldo de Reversa',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Credito Respaldo de Reversa',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Credito Respaldo de Reversa',
  `MontoPagado` decimal(12,2) DEFAULT NULL COMMENT 'Monto  total pagado Respaldo Reversa',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se realizo el Pago del Credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `CreditosID` (`CreditoID`),
  KEY `FechaAplica` (`FechaActual`),
  KEY `TranRespaldo` (`TranRespaldo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Respaldo Reversa de Pago de Credito Contingente'$$
