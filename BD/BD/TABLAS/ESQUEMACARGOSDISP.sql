-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMACARGOSDISP
DELIMITER ;
DROP TABLE IF EXISTS `ESQUEMACARGOSDISP`;DELIMITER $$

CREATE TABLE `ESQUEMACARGOSDISP` (
  `ProductoCreditoID` int(11) NOT NULL COMMENT 'ID del producto de Crédito.',
  `InstitucionID` int(11) NOT NULL COMMENT 'ID de INSTITUCIONES.',
  `NombInstitucion` varchar(100) NOT NULL COMMENT 'Nombre largo de la Institucion.',
  `TipoDispersion` char(1) NOT NULL DEFAULT 'O' COMMENT 'Tipo de Dispersión. Corresponde a lo parámetrizado en el \nEsquema de Calendario por producto.',
  `TipoCargo` char(1) NOT NULL DEFAULT 'M' COMMENT 'Indica si el tipo de cargo es por monto o por porcentaje.\nM.- Monto\nP.- Porcentaje',
  `Nivel` int(11) NOT NULL DEFAULT '0' COMMENT 'Nivel, corresponde al catálogo NIVELCREDITO.',
  `MontoCargo` decimal(14,2) DEFAULT NULL COMMENT 'Monto o porcentaje del cargo por disposición.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`ProductoCreditoID`,`InstitucionID`,`TipoDispersion`,`TipoCargo`,`Nivel`),
  KEY `INDEX_ESQUEMACARGOSDISP_1` (`ProductoCreditoID`),
  KEY `INDEX_ESQUEMACARGOSDISP_2` (`InstitucionID`),
  KEY `INDEX_ESQUEMACARGOSDISP_3` (`Nivel`),
  KEY `INDEX_ESQUEMACARGOSDISP_4` (`ProductoCreditoID`,`InstitucionID`,`TipoDispersion`,`Nivel`),
  CONSTRAINT `FK_ESQUEMACARGOSDISP_1` FOREIGN KEY (`ProductoCreditoID`) REFERENCES `PRODUCTOSCREDITO` (`ProducCreditoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Esquema de cargos por disposición de créditos por producto de crédito.'$$