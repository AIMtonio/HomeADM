-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOMOVS
DELIMITER ;
DROP TABLE IF EXISTS `ARRENDAMIENTOMOVS`;
DELIMITER $$


CREATE TABLE `ARRENDAMIENTOMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `ArrendaID` bigint(12) NOT NULL COMMENT 'ID del arrendamiento',
  `ArrendaAmortiID` int(4) NOT NULL COMMENT 'ID de la Amortizacion',
  `Transaccion` bigint(20) NOT NULL COMMENT 'Numero de Tranasaccion',
  `FechaOperacion` date NOT NULL COMMENT 'Fecha Real de la Operacion',
  `FechaAplicacion` date NOT NULL COMMENT 'Fecha de Aplicacion',
  `TipoMovArrendaID` int(4) NOT NULL COMMENT 'Tipo de Movimiento del arrendamiento',
  `NatMovimiento` char(1) NOT NULL COMMENT 'Naturaleza del Movimiento\nC .- Cargo\nA .- Abono',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda del Movimiento',
  `Cantidad` decimal(14,4) NOT NULL COMMENT 'Cantidad del Movimiento',
  `Descripcion` varchar(100) NOT NULL COMMENT 'Movimiento',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia del Movimiento',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de Poliza generado para el movimiento',
  `EmpresaID` int(11) NOT NULL COMMENT 'Id de la empresa (auditoria)',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario (auditoria)',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha atual del sistema(auditoria)',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Dirección IP(auditoria)',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Id del programa que graba(auditoria)',
  `Sucursal` int(11) NOT NULL COMMENT 'Id de la sucursal(auditoria)',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de transacción(auditoria)',
  KEY `INDEX_ARRENDAMIENTOMOVS_1` (`FechaAplicacion`) USING BTREE,
  KEY `INDEX_ARRENDAMIENTOMOVS_2` (`ArrendaID`,`FechaOperacion`),
  KEY `FK_ARRENDAMIENTOMOVS_1` (`FechaOperacion`,`TipoMovArrendaID`,`NatMovimiento`),
  KEY `FK_ARRENDAMIENTOS_1` (`ArrendaID`),
  KEY `FK_ARRENDAAMORTI_1` (`ArrendaAmortiID`),
  KEY `FK_PRODUCTOARRENDA_1` (`TipoMovArrendaID`),
  KEY `FK_MONEDAS_1` (`MonedaID`),
  KEY `FK_POLIZACONTABLE_1` (`PolizaID`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalle de Movimientos o Transaciones de Arrendamiento'$$
