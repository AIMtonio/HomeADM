-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATMETODOSPAGO
DELIMITER ;
DROP TABLE IF EXISTS `CATMETODOSPAGO`;DELIMITER $$

CREATE TABLE `CATMETODOSPAGO` (
  `MetodoPagoID` int(11) NOT NULL COMMENT 'Consecutivo',
  `Descripcion` varchar(50) NOT NULL COMMENT 'Descripcion del Metodo de Pago',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Ingreso\nA: Activo\nI: Inactivo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Auditoria',
  PRIMARY KEY (`MetodoPagoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$