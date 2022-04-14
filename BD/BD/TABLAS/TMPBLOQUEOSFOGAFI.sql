-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPBLOQUEOSFOGAFI
DELIMITER ;
DROP TABLE IF EXISTS `TMPBLOQUEOSFOGAFI`;DELIMITER $$

CREATE TABLE `TMPBLOQUEOSFOGAFI` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion del Bloqueo',
  `Consecutivo` int(11) NOT NULL COMMENT 'Consecutivo del Registro',
  `BloqueoID` int(11) NOT NULL COMMENT 'ID del bloqueo',
  `MontoBloq` decimal(12,2) DEFAULT NULL COMMENT 'Monto Bloqueado',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `CuentaAhoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Cuenta',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`TransaccionID`,`Consecutivo`),
  KEY `IDX_TMPBLOQUEOSFOGAFI_1` (`TransaccionID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para almacenar los bloqueos de Garantia FOGAFI'$$