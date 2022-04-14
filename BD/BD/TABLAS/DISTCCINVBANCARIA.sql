-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISTCCINVBANCARIA
DELIMITER ;
DROP TABLE IF EXISTS `DISTCCINVBANCARIA`;DELIMITER $$

CREATE TABLE `DISTCCINVBANCARIA` (
  `InversionID` int(11) NOT NULL COMMENT 'Número de la Inversión Bancaria',
  `CentroCosto` int(11) NOT NULL COMMENT 'Id del Centro de Costos',
  `Monto` decimal(12,2) NOT NULL COMMENT 'Monto de la Inversión Bancaria asignado al centro de costos',
  `InteresGenerado` decimal(12,4) NOT NULL COMMENT 'Interes Generado',
  `ISR` decimal(12,4) NOT NULL COMMENT 'Impuesto sobre la Renta\n',
  `TotalRecibir` decimal(12,4) NOT NULL COMMENT 'Total a Recibir por la inversión',
  `SalIntProvisionCC` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Provisionado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Id  de la empresa',
  `Usuario` varchar(45) DEFAULT NULL COMMENT 'Auditoria\n',
  `FechaActual` varchar(45) DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`InversionID`,`CentroCosto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$