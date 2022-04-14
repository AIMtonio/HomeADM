-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTORINVERSION
DELIMITER ;
DROP TABLE IF EXISTS `FACTORINVERSION`;DELIMITER $$

CREATE TABLE `FACTORINVERSION` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del Cliente',
  `InversionID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID de Inversion',
  `Capital` decimal(18,2) DEFAULT NULL COMMENT 'Monto de la Inversion',
  `TotalCaptacion` decimal(18,2) DEFAULT NULL COMMENT 'Total de Captacion (Cuentas + Inversiones + Cedes)',
  `Factor` decimal(18,4) DEFAULT NULL COMMENT 'Factor a Tomar',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus C.- Calculado P.-Pendiente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`,`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Factor ISR Inversiones.'$$