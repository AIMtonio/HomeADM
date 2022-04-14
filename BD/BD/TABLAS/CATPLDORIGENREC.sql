-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATPLDORIGENREC
DELIMITER ;
DROP TABLE IF EXISTS `CATPLDORIGENREC`;DELIMITER $$

CREATE TABLE `CATPLDORIGENREC` (
  `CatOrigenRecID` int(11) NOT NULL COMMENT 'ID de origen',
  `Descripcion` varchar(45) NOT NULL COMMENT 'Descripcion del Origen',
  `NivelRiesgo` char(1) NOT NULL COMMENT 'Nivel de Riesgo.\nA: Alto\nM: Medio\nB: Bajo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`CatOrigenRecID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Catálogo PLD para los Origenes de los Recursos.﻿'$$