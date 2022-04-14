-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISFACTORAHORRO
DELIMITER ;
DROP TABLE IF EXISTS `HISFACTORAHORRO`;DELIMITER $$

CREATE TABLE `HISFACTORAHORRO` (
  `Fecha` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de Calculo',
  `ClienteID` int(11) NOT NULL DEFAULT '0' COMMENT 'ID del Cliente',
  `CuentaAhoID` bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID de Cuenta',
  `Saldo` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de la Cuenta al Cierre de Dia',
  `TotalCaptacion` decimal(14,2) DEFAULT NULL COMMENT 'Total de Captacion (Cuentas + Inversiones + Cedes)',
  `Factor` decimal(14,4) DEFAULT NULL COMMENT 'Factor a Tomar',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus C.- Calculado P.-Pendiente',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`Fecha`,`ClienteID`,`CuentaAhoID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Historico Factor ISR AHORRO.'$$