-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPEXCENDERIESGOFIRA
DELIMITER ;
DROP TABLE IF EXISTS `TMPEXCENDERIESGOFIRA`;DELIMITER $$

CREATE TABLE `TMPEXCENDERIESGOFIRA` (
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion\n',
  `GrupoID` int(11) DEFAULT NULL COMMENT 'Numero o ID del Grupo',
  `CicloGrupo` int(11) DEFAULT NULL COMMENT 'Ciclo del Grupo, en Caso de un Credito Grupal',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `MontoCredito` decimal(18,2) NOT NULL COMMENT 'Monto Solicitado por el Grupo',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Transaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Paso para la generacion del reporte de Excedentes riesgo comun'$$