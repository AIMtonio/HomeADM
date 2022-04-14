-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSMOVDISP
DELIMITER ;
DROP TABLE IF EXISTS `TIPOSMOVDISP`;DELIMITER $$

CREATE TABLE `TIPOSMOVDISP` (
  `TipoMovDispID` int(11) NOT NULL COMMENT 'Llave del tipo de movimiento de dispersión',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripción del tipo de dispersión',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del motivo',
  `TipoMovAhoID` char(4) DEFAULT NULL COMMENT 'ID del Tipo de Movimiento Que se realizara en la cuenta de ahorro',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoMovDispID`),
  KEY `fk_TipoMovAhoID` (`TipoMovAhoID`),
  CONSTRAINT `fk_TipoMovAhoID` FOREIGN KEY (`TipoMovAhoID`) REFERENCES `TIPOSMOVSAHO` (`TipoMovAhoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Movimientos de Dispersión'$$