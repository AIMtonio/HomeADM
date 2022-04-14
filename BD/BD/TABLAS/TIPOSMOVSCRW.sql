-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVSCRW
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVSCRW`;

DELIMITER $$
CREATE TABLE `TIPOSMOVSCRW` (
  `TipoMovCRWID` int(4) NOT NULL COMMENT 'ID del Movimiento.',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del tipo de Movimiento',
  `PrealacionPago` int(2) DEFAULT NULL COMMENT 'Orden o Prelacion de Pago',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `FechaActual` datetime NOT NULL COMMENT 'Campo de Auditoría.',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Campo de Auditoría.',
  PRIMARY KEY (`TipoMovCRWID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Cat: Tipos de Movimientos del Módulo Crowdfunding.'$$