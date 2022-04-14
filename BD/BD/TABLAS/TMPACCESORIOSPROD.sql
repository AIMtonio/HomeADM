-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPACCESORIOSPROD
DELIMITER ;
DROP TABLE IF EXISTS `TMPACCESORIOSPROD`;
DELIMITER $$


CREATE TABLE `TMPACCESORIOSPROD` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo de la tabla',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito',
  `AccesorioID` int(11) NOT NULL COMMENT 'Identificador del Accesorio',
  `MontoCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto Fijo de la Cuota',
  `MontoIVACuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto del IVA de la Cuota',
  `SaldoAccesorios` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del Adeudo del Accesorio',
  `Prelacion` int(11) DEFAULT NULL COMMENT 'Monto Accesorio por Cuota',
  `Abreviatura` varchar(20) DEFAULT NULL COMMENT 'Abreviatura del Concepto',
  `CobraIVA` char(1) DEFAULT NULL COMMENT 'Indica si el accesorio cobra o no cobra IVA',
  `ConceptoCartera` int(11) DEFAULT NULL COMMENT 'Valor del Concepto de Cartera al que Corresponde',
  `MontoIntCuota` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Monto de interes del Accesorio',
  `SaldoInteres` DECIMAL(14,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de interes del Accesorio',
  `CobraIVAInteres` CHAR(1) NOT NULL DEFAULT 'N' COMMENT 'Indica si el accesorio cobra o no cobra IVA de interes',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  KEY `TMPACCESORIOSPROD_IDX` (`Consecutivo`,`CreditoID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Almacena los accesorios a pagar.'$$
