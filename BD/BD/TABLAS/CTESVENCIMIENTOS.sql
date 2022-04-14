-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTESVENCIMIENTOS
DELIMITER ;
DROP TABLE IF EXISTS `CTESVENCIMIENTOS`;DELIMITER $$

CREATE TABLE `CTESVENCIMIENTOS` (
  `Fecha` date NOT NULL DEFAULT '1990-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'Cliente con Vencimiento de algun Instrumento',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla Auxiliar para Determinar los Clientes con Vencimientos'$$