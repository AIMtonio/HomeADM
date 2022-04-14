-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESCANCELADOS
DELIMITER ;
DROP TABLE IF EXISTS `CHEQUESCANCELADOS`;DELIMITER $$

CREATE TABLE `CHEQUESCANCELADOS` (
  `ChequeCanceladoID` int(11) NOT NULL COMMENT 'Consecutivo de cheque cancelado.',
  `TransaccionID` bigint(20) DEFAULT NULL COMMENT 'Número de transacción a la cuál se le da Reversa. Referencia a tabla CHEQUESEMITID',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Número de caja donde se hace la cancelación.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal donde se hace la cancelación',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de cancelación',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Usuario que autoriza la cancelación.',
  `MotivoCancelacion` varchar(200) DEFAULT NULL COMMENT 'Motivo de cancelación.',
  `NumeroCheque` int(10) DEFAULT NULL COMMENT 'Numero de cheque cancelado.',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoria.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoria.',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parámetro de auditoria.',
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parámetro de auditoria.',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Parámetro de auditoria.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parámetro de auditoria.',
  PRIMARY KEY (`ChequeCanceladoID`),
  KEY `fk_CHEQUESCANCELADOS_2_idx` (`UsuarioID`),
  KEY `fk_CHEQUESCANCELADOS_Us` (`UsuarioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Contiene los datos de cheques cancelados(Módulos de Ventanil'$$