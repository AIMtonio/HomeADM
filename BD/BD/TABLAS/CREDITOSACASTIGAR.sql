-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSACASTIGAR
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSACASTIGAR`;DELIMITER $$

CREATE TABLE `CREDITOSACASTIGAR` (
  `TransaccionID` int(11) NOT NULL DEFAULT '0' COMMENT 'Numero de Transaccion de la Carga del Archivo Excel',
  `FechaCarga` date DEFAULT '1900-01-01' COMMENT 'Fecha del sistema en la que se hace la carga',
  `Hora` time DEFAULT '00:00:01' COMMENT 'Hora de la carga',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Crédito',
  `MotivoCastigoID` int(11) DEFAULT NULL COMMENT 'Motivo de Castigo corresponde a la tabla MOTIVOSCASTIGO',
  `CobranzaID` int(11) DEFAULT NULL COMMENT 'Corresponde a la tabla OPCIONESMENUREG MenuID 18',
  `Observaciones` varchar(500) DEFAULT NULL COMMENT 'Observaciones',
  `CreditoIDCte` varchar(45) DEFAULT NULL COMMENT 'Informativo',
  `FechaCorte` date DEFAULT NULL COMMENT 'Informativo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de aplicación.\nN: No Aplicado\nA: Aplicado',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`,`CreditoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para el proceso de castigo masivo'$$