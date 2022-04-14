-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDITOSGRUPALESAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDITOSGRUPALESAGRO`;DELIMITER $$

CREATE TABLE `TMPCREDITOSGRUPALESAGRO` (
  `CreditoGrupID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID CRedito grupal',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'CreditoID Individual',
  `GrupoID` int(11) DEFAULT NULL COMMENT 'ID del Grupo',
  `ProductoCred` int(11) DEFAULT NULL COMMENT 'ID del producto de credito',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del credito',
  `TipoPrepago` char(1) DEFAULT NULL COMMENT 'Tipo de prepago del credito',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`CreditoGrupID`,`NumTransaccion`),
  KEY `IDX_CREDGRUP_1` (`CreditoID`),
  KEY `IDX_CREDGRUP_2` (`GrupoID`),
  KEY `IDX_CREDGRUP_3` (`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Temporal para la Ministracion de los creditos grupales'$$