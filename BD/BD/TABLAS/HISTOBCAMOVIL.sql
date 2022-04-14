-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISTOBCAMOVIL
DELIMITER ;
DROP TABLE IF EXISTS `HISTOBCAMOVIL`;DELIMITER $$

CREATE TABLE `HISTOBCAMOVIL` (
  `HistoBcaMovID` bigint(20) NOT NULL COMMENT 'Numero del registro para el Historico Banca Movil',
  `CuentasBcaMovID` bigint(20) NOT NULL COMMENT 'ID de la cuenta Banca Movil',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus del Registro: \nA) Alta \nB) Bloqueado \nD) Desbloqueado\n',
  `FechaRegistro` datetime DEFAULT NULL COMMENT 'Fecha en la Cual se efectuo dicha Operacion',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Campo de Auditoria',
  `DireccionIP` varchar(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoria',
  PRIMARY KEY (`HistoBcaMovID`),
  KEY `fk_HISTOBCAMOVIL_1` (`CuentasBcaMovID`),
  CONSTRAINT `fk_HISTOBCAMOVIL_1` FOREIGN KEY (`CuentasBcaMovID`) REFERENCES `CUENTASBCAMOVIL` (`CuentasBcaMovID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla que almacena el Historico de Banca Movil'$$