-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONESDIAPAG
DELIMITER ;
DROP TABLE IF EXISTS `INVERSIONESDIAPAG`;DELIMITER $$

CREATE TABLE `INVERSIONESDIAPAG` (
  `InversionID` int(11) NOT NULL COMMENT 'Parametro ID de la Inversion',
  `FechaUltimoPago` date DEFAULT NULL COMMENT 'Parametro de Fecha del Ultimo Pago de la Inversion',
  `FechaProximoPago` date DEFAULT NULL COMMENT 'Parametro de la Proxima Fecha de Pago de la Inversion',
  `PeriodicidadPago` int(11) DEFAULT NULL COMMENT 'Parametro de la periocidad de pago',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`InversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el control de inversiones que pagan en dias preestablecidos'$$