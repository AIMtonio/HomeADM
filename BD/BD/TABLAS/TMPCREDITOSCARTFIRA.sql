-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOSCARTFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSCARTFIRA`;
DELIMITER $$


CREATE TABLE `TMPCREDITOSCARTFIRA` (
  `ClienteID` int(11) NOT NULL COMMENT 'Numer de Cliente ID',
  `SiTiene` char(1) DEFAULT 'N' COMMENT 'Si tiene Creditos Vencidos',
  `SaldoCreditos` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente + Saldo Cartera Venc',
  `SaldoCarteraVenc` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Cartera Venc',
  `SaldoFondeo` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo total fondeado',
  `DiasAtraso12` int(11) NULL COMMENT 'Numero de Dias de atraso',
  `DiasAtraso` int(11) DEFAULT NULL COMMENT 'Numero de Dias de atraso',
  `NumGaranPers` int(11) DEFAULT NULL COMMENT 'Numero de Garantias Personales',
  `TotalGarantia` decimal(14,2) DEFAULT '0.00' COMMENT 'Total de las Garantias ',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para saber que Clientes tienen Creditos conCartera FIRA'$$