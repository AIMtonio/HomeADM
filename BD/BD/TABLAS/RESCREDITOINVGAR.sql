-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESCREDITOINVGAR
DELIMITER ;
DROP TABLE IF EXISTS `RESCREDITOINVGAR`;
DELIMITER $$


CREATE TABLE `RESCREDITOINVGAR` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL,
  `CreditoInvGarID` bigint(12) NOT NULL COMMENT 'Consecutivo de la tabla CREDITOINVGAR',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Credito relacionado',
  `InversionID` int(11) DEFAULT NULL COMMENT 'Inversion usada como Garantia para el credito',
  `MontoEnGar` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la inversion que se esta dejando como garantia',
  `FechaAsignaGar` date DEFAULT NULL COMMENT 'Fecha en que se asigna la Garantia',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `FechaActual` date DEFAULT NULL COMMENT 'Parametros de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de auditoria',
  KEY `CreditoInvGarID` (`CreditoInvGarID`) USING BTREE,
  KEY `TranRespaldo` (`TranRespaldo`)
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Respaldo para reversa de pago de credito'$$
