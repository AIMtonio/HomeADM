-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIMOV
DELIMITER ;
DROP TABLE IF EXISTS `SEGUROCLIMOV`;DELIMITER $$

CREATE TABLE `SEGUROCLIMOV` (
  `SeguroCliMovID` int(11) NOT NULL,
  `SeguroClienteID` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Numero de Cliente',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto del movimiento',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Cobro C\nPago P (Siniestro)\ncancela K',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal en donde se realiza el movimiento',
  `CajaID` int(11) DEFAULT NULL COMMENT 'Numero de Caja en donde se realiza el movimiento',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha del Sistema en donde se realiza el movimiento',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'Numero de Usuario que  realiza el movimiento',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'descripcion del movimiento',
  `NumMovimiento` bigint(20) DEFAULT NULL COMMENT 'Numero de Movimiento(Transaccion)',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Numero de Moneda ',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SeguroCliMovID`),
  KEY `fk_SEGUROCLIMOV_1_idx` (`SeguroClienteID`),
  KEY `fk_SEGUROCLIMOV_2_idx` (`ClienteID`),
  CONSTRAINT `fk_SEGUROCLIMOV_1` FOREIGN KEY (`SeguroClienteID`) REFERENCES `SEGUROCLIENTE` (`SeguroClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SEGUROCLIMOV_2` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$