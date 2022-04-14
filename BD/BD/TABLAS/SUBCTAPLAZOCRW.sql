-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOCRW
DELIMITER ;
DROP TABLE IF EXISTS `SUBCTAPLAZOCRW`;

DELIMITER $$
CREATE TABLE `SUBCTAPLAZOCRW` (
  `ConceptoCRWID` int(11) NOT NULL COMMENT 'ID del Concepto y FK que corresponde con la tabla de CONCEPTOSCRW.',
  `NumRetiros` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Retiros en el Mes.',
  `Subcuenta` char(2) DEFAULT NULL COMMENT 'Numeros que corresponde a la subcuenta.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`ConceptoCRWID`,`NumRetiros`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Subcuenta de Plazos para el Módulo de Crowdfunding.'$$