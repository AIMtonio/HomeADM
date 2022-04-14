-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSBLOQUEOS
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSBLOQUEOS`;
DELIMITER $$


CREATE TABLE `TIPOSBLOQUEOS` (
  `TiposBloqID` int(11) NOT NULL COMMENT 'Id del tipo de Bloqueo',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripcion del Bloqueo',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del bloqueo\nA = Activo\nI = Inactivo\nC = Cancelado',
  `TipoMovimiento` char(2) DEFAULT NULL COMMENT 'Identifica si el tipo de bloqueo o desbloqueo es A.- Automatico o M.- Manual',
  `NatTipoBloq` char(1) DEFAULT 'A' COMMENT 'Naturaleza del tipo de bloqueo: \nB = Bloqueo, el tipo de bloqueo solo aplica para bloquear\nD = Desbloqueo, el tipo de bloqueo solo aplica para desbloquear\nA = Ambos, el tipo de bloqueo aplica para bloquear o desbloquear',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TiposBloqID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$