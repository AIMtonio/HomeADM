-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEITRANSFERENCIAS
DELIMITER ;
DROP TABLE IF EXISTS `SPEITRANSFERENCIAS`;DELIMITER $$

CREATE TABLE `SPEITRANSFERENCIAS` (
  `SpeiTransID` bigint(20) NOT NULL COMMENT 'Numero de transferencia',
  `Corresponsal` varchar(60) NOT NULL COMMENT 'Nombre del ordenante',
  `NombreCli` varchar(150) NOT NULL COMMENT 'Nombre cliente de transferencia',
  `ClabeCli` varchar(18) NOT NULL COMMENT 'CLABE del cliente',
  `Monto` decimal(16,2) NOT NULL COMMENT 'Monto a transferir',
  `Estatus` char(1) NOT NULL DEFAULT 'P' COMMENT 'P) Pendiente,A)Autorizado',
  `Referencia` varchar(40) NOT NULL COMMENT 'Referencia',
  `FechaAlta` datetime NOT NULL COMMENT 'Fecha de alta de transferencia',
  `CausaDevol` int(2) NOT NULL DEFAULT '0' COMMENT 'Causa devolucion',
  `FechaAutoriza` datetime NOT NULL DEFAULT '1900-01-01 00:00:00' COMMENT 'Fecha de autorizacion',
  `UsuarioAutoriza` int(11) NOT NULL DEFAULT '0' COMMENT 'Usuario que autoriza la operacion, ID del usuario',
  `FechaProceso` date NOT NULL DEFAULT '1900-01-01' COMMENT 'Fecha de abono a la cuenta',
  `Transaccion` bigint(20) NOT NULL DEFAULT '0' COMMENT 'Numero de operacion con que se aplico el abono.',
  `EmpresaID` int(11) NOT NULL COMMENT 'Campo de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`SpeiTransID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Transferencias SPEI para Clientes Internos'$$