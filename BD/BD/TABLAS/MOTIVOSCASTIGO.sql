-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOTIVOSCASTIGO
DELIMITER ;
DROP TABLE IF EXISTS `MOTIVOSCASTIGO`;DELIMITER $$

CREATE TABLE `MOTIVOSCASTIGO` (
  `MotivoCastigoID` int(11) NOT NULL COMMENT 'ID y PK de Motivos Castigo',
  `Descricpion` varchar(150) DEFAULT NULL COMMENT 'La descripcion del catigo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'campos de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campos de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campos de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campos de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campos de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campos de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campos de auditoria',
  PRIMARY KEY (`MotivoCastigoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Motivos de Castigos de Credito'$$