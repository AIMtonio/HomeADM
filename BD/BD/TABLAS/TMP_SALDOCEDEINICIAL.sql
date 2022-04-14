-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMP_SALDOCEDEINICIAL
DELIMITER ;
DROP TABLE IF EXISTS `TMP_SALDOCEDEINICIAL`;DELIMITER $$

CREATE TABLE `TMP_SALDOCEDEINICIAL` (
  `CedeID` int(11) NOT NULL COMMENT 'Identificador de CEDE',
  `MontoAjuste` decimal(16,2) DEFAULT NULL COMMENT 'Saldo a la Fecha de Migracion/implementacion del sistema SAFI',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(20) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`CedeID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Guarda el saldo de las CEDES al momento de la migracion del sistema'$$