-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCATPASIVOSFONDEOAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCATPASIVOSFONDEOAGRO`;
DELIMITER $$

CREATE TABLE `TMPCATPASIVOSFONDEOAGRO` (
  `TipoID` int(11) NOT NULL COMMENT 'Tipo ID',
  `Tipo` varchar(100) NOT NULL COMMENT 'Descripcion del Pasivo',
  `Secuencial` varchar(45) NOT NULL DEFAULT '0' COMMENT 'Numero de Orden',
  `NombreInstitFon` varchar(200) NOT NULL DEFAULT '' COMMENT 'Nombre Corto Institucion Fondeo\\\\n',
  `LineaFondeoID` varchar(20) NOT NULL DEFAULT '' COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\\\\n',
  `FechaFinLinea` varchar(12) NOT NULL DEFAULT '' COMMENT 'Fecha de Vencimiento de la Linea de Crédito',
  `SaldoTotalPasivo` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente',
  `SaldoCapVigente` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente',
  `FinanAdicionalVig` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Financiamiento adicional vigente',
  `SaldoIntDevVig` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de los Intereses Devengados Vigentes',
  `SaldoCapVencido` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de Capital Vencido',
  `FinanAdicionalVenc` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Financiamiento adicional vencidos',
  `SaldoIntDevVenc` decimal(18,2) NOT NULL DEFAULT '0.00' COMMENT 'Saldo de los Intereses Devengados Vencidos',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TipoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Catalogo de Pasivos de Fondeo para el Reporte Pasivos de Fondeo.'$$