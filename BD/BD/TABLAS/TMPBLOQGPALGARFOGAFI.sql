-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBLOQGPALGARFOGAFI
DELIMITER ;
DROP TABLE IF EXISTS `TMPBLOQGPALGARFOGAFI`;DELIMITER $$

CREATE TABLE `TMPBLOQGPALGARFOGAFI` (
  `Consecutivo` int(11) NOT NULL COMMENT 'Identificador Consecutivo',
  `CreditoID` bigint(20) DEFAULT NULL COMMENT 'Identificador del Crédito',
  `AmortizacionID` int(11) DEFAULT NULL COMMENT 'Número de Amortización',
  `MontoExigible` decimal(14,2) DEFAULT NULL COMMENT 'Monto de Adeudo de la Amortización',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Indica el Numero de Transacción',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `IDX_GRUPOGARFOGAFI_1` (`Consecutivo`),
  KEY `IDX_GRUPOGARFOGAFI_2` (`CreditoID`),
  KEY `IDX_GRUPOGARFOGAFI_3` (`AmortizacionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tmp: Tabla temporal para almacenar las amortizaciones de FOGAFI exigibles de un grupo'$$