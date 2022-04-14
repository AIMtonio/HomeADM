-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATDIASPAGINV
DELIMITER ;
DROP TABLE IF EXISTS `CATDIASPAGINV`;DELIMITER $$

CREATE TABLE `CATDIASPAGINV` (
  `TipoInversionID` int(11) NOT NULL COMMENT 'Tipo de Inversion',
  `PeriodicidadPago` int(11) DEFAULT NULL COMMENT 'Periocidad de Pago para el Tipo de Inversion',
  `EmpresaID` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la empresa',
  `Usuario` int(11) NOT NULL COMMENT 'Parametro de auditoria ID del usuario',
  `FechaActual` datetime NOT NULL COMMENT 'Parametro de auditoria Fecha actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Parametro de auditoria Direccion IP ',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Parametro de auditoria Programa ',
  `Sucursal` int(11) NOT NULL COMMENT 'Parametro de auditoria ID de la sucursal',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Parametro de auditoria Numero de la transaccion',
  PRIMARY KEY (`TipoInversionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla para el control de Periocidad de cada tipo de Inversion'$$