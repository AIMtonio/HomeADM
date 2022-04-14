-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BLOQUEOS
DELIMITER ;
DROP TABLE IF EXISTS `BLOQUEOS`;DELIMITER $$

CREATE TABLE `BLOQUEOS` (
  `BloqueoID` int(11) NOT NULL COMMENT 'ID del bloqueo',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del Movimiento\nB --> Bloquear\nD --> Desbloquear',
  `FechaMov` datetime DEFAULT NULL COMMENT 'Fecha de movimiento',
  `MontoBloq` decimal(12,2) DEFAULT NULL COMMENT 'Monto Bloqueado',
  `FechaDesbloq` datetime DEFAULT NULL COMMENT 'Fecha para desbloquear',
  `TiposBloqID` int(11) DEFAULT NULL COMMENT 'Tipo de bloqueo u Origen del Bloqueo',
  `Descripcion` varchar(150) DEFAULT NULL,
  `Referencia` bigint(20) DEFAULT NULL COMMENT 'Referencia del origen del bloqueo',
  `FolioBloq` int(11) DEFAULT NULL COMMENT 'Nace con valor cero, cuando se hace un desbloqueo su numero corresponde con el folio de desbloqueo/bloqueo',
  `UsuarioIDAuto` int(11) DEFAULT NULL COMMENT 'Id del usuario que autoriza el desbloqueo de Saldo.\n',
  `ClaveUsuAuto` varchar(45) DEFAULT NULL COMMENT 'Clave del usuario que autoriza el desbloqueo de saldo.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`BloqueoID`),
  KEY `fk_TipoBloqueo` (`TiposBloqID`),
  KEY `fk_CtaAhorro` (`CuentaAhoID`),
  KEY `fk_BLOQUEOS_2` (`UsuarioIDAuto`),
  KEY `idx_BLOQUEOS_3` (`CuentaAhoID`,`Referencia`),
  KEY `idx_BLOQUEOS_4` (`Referencia`),
  CONSTRAINT `fk_BLOQUEOS_1` FOREIGN KEY (`TiposBloqID`) REFERENCES `TIPOSBLOQUEOS` (`TiposBloqID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_BLOQUEOS_2` FOREIGN KEY (`UsuarioIDAuto`) REFERENCES `USUARIOS` (`UsuarioID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$