-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRAAMORAFEC
DELIMITER ;
DROP TABLE IF EXISTS `MINISTRAAMORAFEC`;DELIMITER $$

CREATE TABLE `MINISTRAAMORAFEC` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Número de Crédito',
  `AmortizacionID` int(4) NOT NULL COMMENT 'Número de Amortización',
  `NumeroMinistracion` int(11) NOT NULL COMMENT 'Número Consecutivo de la Ministración.',
  `Capital` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Capital',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`AmortizacionID`,`NumeroMinistracion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para guardar las amortizaciones que fueron afectadas por las ministraciones.'$$