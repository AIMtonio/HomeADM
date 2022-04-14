-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDTASAPASIVAAGRO
DELIMITER ;
DROP TABLE IF EXISTS `CREDTASAPASIVAAGRO`;DELIMITER $$

CREATE TABLE `CREDTASAPASIVAAGRO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Número del Crédito.',
  `SolicitudCreditoID` bigint(12) NOT NULL COMMENT 'Número de la Solicitud de Crédito.',
  `TasaPasiva` decimal(14,4) DEFAULT NULL COMMENT 'Valor de la Tasa Pasiva modificada por el usuario desde pantalla de alta de sol. de créd. y alta de crédito.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CreditoID`,`SolicitudCreditoID`),
  KEY `CREDTASAPASIVAAGRO_IDX_1` (`CreditoID`),
  KEY `CREDTASAPASIVAAGRO_IDX_2` (`SolicitudCreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene el valor de la Tasa Pasiva de la Solicitud y del Crédito.'$$