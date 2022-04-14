-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSACREDPAGNOMINA
DELIMITER ;
DROP TABLE IF EXISTS `REVERSACREDPAGNOMINA`;
DELIMITER $$

CREATE TABLE `REVERSACREDPAGNOMINA` (
  `ReversaID` bigint(12) NOT NULL COMMENT 'ID de la Tabla',
  `CuentaAhoID` bigint(12) NOT NULL COMMENT 'ID de la Cuenta de Ahorro ligado al Credito',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del Credito',
  `MontoPagado`  decimal(12,2) DEFAULT NULL COMMENT 'Monto total de los pagos que subieron correctamente',
  `BloqueoID` int(11) NOT NULL COMMENT 'ID del bloqueo',
  `MontoBloq` decimal(12,2) DEFAULT NULL COMMENT 'Monto Bloqueado',
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion de Pago',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) NOT NULL,
  PRIMARY KEY (`ReversaID`,`NumTransaccion`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tab: Tabla que inserta los registros de Credito Nomina para realizar el proceso de Reversa'$$