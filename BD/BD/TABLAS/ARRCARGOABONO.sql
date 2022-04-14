-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRCARGOABONO
DELIMITER ;
DROP TABLE IF EXISTS `ARRCARGOABONO`;DELIMITER $$

CREATE TABLE `ARRCARGOABONO` (
  `CargoAbonoID` bigint(12) NOT NULL COMMENT 'ID del Cargo o Abono',
  `ArrendaID` bigint(12) NOT NULL COMMENT 'ID del Arrendamiento',
  `ArrendaAmortiID` int(4) NOT NULL COMMENT 'Numero consudecutivo de la amortizacion o la cuota',
  `TipoConcepto` int(11) NOT NULL COMMENT 'Tipo de concepto',
  `Naturaleza` char(1) NOT NULL COMMENT 'Naturaleza del movimiento: C=cargo, A=Abono',
  `Monto` decimal(14,2) NOT NULL COMMENT 'Monto del movimiento',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del movimiento',
  `FechaMovimiento` date NOT NULL COMMENT 'Fecha en la que se hizo el movimiento',
  `UsuarioMovimiento` int(11) NOT NULL COMMENT 'Usuario que realizo el movimiento',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`CargoAbonoID`),
  KEY `FK_ARRCARGOABONO_1` (`ArrendaID`),
  KEY `FK_ARRCARGOABONO_2` (`ArrendaAmortiID`),
  CONSTRAINT `FK_ARRCARGOABONO_1` FOREIGN KEY (`ArrendaID`) REFERENCES `ARRENDAMIENTOS` (`ArrendaID`),
  CONSTRAINT `FK_ARRCARGOABONO_2` FOREIGN KEY (`ArrendaAmortiID`) REFERENCES `ARRENDAAMORTI` (`ArrendaAmortiID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar los cargos o abonos que pueden hacerse a un arrendamiento.'$$