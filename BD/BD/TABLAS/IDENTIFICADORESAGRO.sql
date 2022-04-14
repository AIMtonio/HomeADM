-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IDENTIFICADORESAGRO
DELIMITER ;
DROP TABLE IF EXISTS `IDENTIFICADORESAGRO`;DELIMITER $$

CREATE TABLE `IDENTIFICADORESAGRO` (
  `CreditoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Crédito de la Cartera Agro.',
  `IdentificadorID` varchar(18) DEFAULT NULL COMMENT 'Folio o Identificador del Acreditado.',
  `Consecutivo` int(11) NOT NULL DEFAULT '0' COMMENT 'Número Consecutivo.',
  `Anio` int(11) NOT NULL DEFAULT '0' COMMENT 'Año de registro del Crédito.',
  `TipoCredito` varchar(1) DEFAULT NULL COMMENT 'Tipo de Crédito: \nA.- Crédito Activo (CREDITOS)\nP.- Crédito Pasivo (CREDITOFONDEO).',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametros de Auditoria',
  PRIMARY KEY (`Anio`,`Consecutivo`,`CreditoID`),
  KEY `IDX_IDENTIFICADORESAGRO_1` (`CreditoID`),
  KEY `IDX_IDENTIFICADORESAGRO_2` (`CreditoID`,`Anio`),
  KEY `IDX_IDENTIFICADORESAGRO_3` (`IdentificadorID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Identificadores del acreditado para la cartera Agro (FIRA).'$$