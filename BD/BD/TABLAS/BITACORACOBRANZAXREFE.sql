-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACOBRANZAXREFE
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACOBRANZAXREFE`;DELIMITER $$

CREATE TABLE `BITACORACOBRANZAXREFE` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de Ejecucion',
  `Hora` time DEFAULT NULL COMMENT 'Hora de Ejecucion',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Número de Credito',
  `NumErr` int(11) DEFAULT NULL COMMENT 'Numero de Error',
  `ErrMen` varchar(400) DEFAULT NULL COMMENT 'Mensaje de Error',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla : Tabla Bitacora para la Cobranza x Referencia'$$