-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSPLANAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSPLANAHORRO`;
DELIMITER $$

CREATE TABLE `TIPOSPLANAHORRO` (
  `PlanID` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identificador del Plan de Ahorro',
  `Nombre` varchar(100) DEFAULT '' COMMENT 'Nombre del Plan de Ahorro',
  `FechaInicio` date DEFAULT '1900-01-01' COMMENT 'Fecha de Inicio del Plan de Ahorro',
  `FechaVencimiento` date DEFAULT '1900-01-01' COMMENT 'Fecha de Vencimiento del Plan de Ahorro',
  `FechaLiberacion` date DEFAULT '1900-01-01' COMMENT 'Fecha de Liberacion del Plan de Ahorro',
  `DepositoBase` decimal(12,2) DEFAULT '0.00' COMMENT 'Deposito Base para el Plan de ahorro (Costo del Boleto)',
  `MaxDep` int(11) DEFAULT '0' COMMENT 'Numero maximo de Depositos por Cuenta-Cliente',
  `Prefijo` varchar(25) DEFAULT '' COMMENT 'Prefijo del Plan de Ahorro',
  `Serie` int(11) DEFAULT '0' COMMENT 'Numero maximo de Boletos por Plan de Ahorro',
  `LeyendaBloqueo` varchar(100) DEFAULT '' COMMENT 'Descripcion para los registros al momento del bloquear el saldo',
  `LeyendaTicket` varchar(250) DEFAULT '' COMMENT 'Descripcion para la impresion de tickets',
  `DiasDesbloqueo` INT NOT NULL DEFAULT 0 COMMENT 'Dias de desbloqueo para el folio',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  PRIMARY KEY (`PlanID`),
  UNIQUE KEY `PlanID` (`PlanID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que almacena los tipos de plan de ahorro'$$