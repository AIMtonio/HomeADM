-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPLDPERFILTRANMOV
DELIMITER ;
DROP TABLE IF EXISTS `TMPPLDPERFILTRANMOV`;
DELIMITER $$


CREATE TABLE `TMPPLDPERFILTRANMOV` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `NumeroMov` bigint(20) NOT NULL COMMENT 'Numero de transaccion',
  `Fecha` date NOT NULL COMMENT 'fecha del movimiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento C cargo A abono',
  `CantidadMov` decimal(12,2) DEFAULT NULL COMMENT 'Cantidad de Movimient0',
  `Mes` int(11) DEFAULT NULL COMMENT 'Mes',
  `Anio` int(11) DEFAULT NULL COMMENT 'Año',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `TransaccionID` varchar(45) DEFAULT NULL COMMENT 'Transaccion ID',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena los movimientos del periodo indificado en el perfil transaccional'$$
