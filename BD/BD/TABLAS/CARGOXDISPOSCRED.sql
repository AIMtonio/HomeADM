-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGOXDISPOSCRED
DELIMITER ;
DROP TABLE IF EXISTS `CARGOXDISPOSCRED`;DELIMITER $$

CREATE TABLE `CARGOXDISPOSCRED` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'ID del Crédito.',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta de Ahorro.',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del Cliente.',
  `MontoCargo` decimal(14,2) DEFAULT NULL COMMENT 'Monto del cargo por disposición.',
  `FechaCargo` date DEFAULT NULL COMMENT 'Fecha en la que se realiza el cargo por disposición.',
  `InstitucionID` int(11) NOT NULL COMMENT 'ID de INSTITUCIONES.',
  `NombInstitucion` varchar(100) NOT NULL COMMENT 'Nombre largo de la Institucion.',
  `Naturaleza` char(1) DEFAULT '' COMMENT 'Indica la Naturaleza del Movimiento\nA: Abono\nC: Cargo',
  `TipoDispersion` char(1) DEFAULT 'O' COMMENT 'Tipo de Dispersión. Corresponde a lo parámetrizado en el \nEsquema de Calendario por producto.',
  `TipoCargo` char(1) DEFAULT 'M' COMMENT 'Indica si el tipo de cargo es por monto o por porcentaje.\nM.- Monto\nP.- Porcentaje',
  `Nivel` int(11) DEFAULT '0' COMMENT 'Nivel, corresponde al catálogo NIVELCREDITO.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`CreditoID`,`NumTransaccion`),
  KEY `INDEX_CARGOXDISPOSCRED_1` (`CreditoID`),
  KEY `INDEX_CARGOXDISPOSCRED_2` (`CuentaAhoID`),
  KEY `INDEX_CARGOXDISPOSCRED_3` (`ClienteID`),
  KEY `INDEX_CARGOXDISPOSCRED_4` (`InstitucionID`),
  KEY `INDEX_CARGOXDISPOSCRED_5` (`Nivel`),
  KEY `INDEX_CARGOXDISPOSCRED_6` (`CreditoID`,`Naturaleza`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cargos por disposición de crédito.'$$