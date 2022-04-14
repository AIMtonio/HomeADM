-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISAMORTIZAPAGINVER
DELIMITER ;
DROP TABLE IF EXISTS `HISAMORTIZAPAGINVER`;DELIMITER $$

CREATE TABLE `HISAMORTIZAPAGINVER` (
  `InversionID` int(11) NOT NULL COMMENT 'Parametro ID de la Inversion',
  `FechaPago` date NOT NULL COMMENT 'Parametro de Fecha de Pago de la Inversion',
  `MontoPago` decimal(16,2) DEFAULT NULL COMMENT 'Monto de Pago de la Inversion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`InversionID`,`FechaPago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el registro de Pagos periodicos de inversiones en dias preestablecidos'$$