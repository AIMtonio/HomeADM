-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITO
DELIMITER ;
DROP TABLE IF EXISTS `RESPAGCREDITO`;
DELIMITER $$


CREATE TABLE `RESPAGCREDITO` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL,
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Credito Respaldo de Reversa',
  `MontoPagado` decimal(12,2) DEFAULT NULL COMMENT 'Monto  total pagado Respaldo Reversa',
  `FechaPago` date DEFAULT NULL COMMENT 'Fecha en que se realizo el Pago del Credito',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `CreditosID` (`CreditoID`),
  KEY `FechaAplica` (`FechaActual`),
  KEY `TranRespaldo` (`TranRespaldo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Respaldo Reversa de Pago de Credito'$$
