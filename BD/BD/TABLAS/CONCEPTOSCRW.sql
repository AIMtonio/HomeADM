-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCRW
DELIMITER ;
DROP TABLE IF EXISTS `CONCEPTOSCRW`;
DELIMITER $$

CREATE TABLE `CONCEPTOSCRW` (
  `ConceptoCRWID` int(11) NOT NULL COMMENT 'ID del Concepto Contable.' ,
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripción del Concepto Contable.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`ConceptoCRWID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Conceptos Contables Crowdfunding.'$$