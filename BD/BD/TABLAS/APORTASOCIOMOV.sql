-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTASOCIOMOV
DELIMITER ;
DROP TABLE IF EXISTS `APORTASOCIOMOV`;DELIMITER $$

CREATE TABLE `APORTASOCIOMOV` (
  `AportaSocMovID` int(11) NOT NULL COMMENT 'ID de la tabla',
  `ClienteID` int(11) NOT NULL COMMENT 'ID del cliente',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto de la aportacion',
  `Tipo` char(1) DEFAULT NULL COMMENT 'Indica si es aportacion o devolucion',
  `SucursalID` int(11) NOT NULL COMMENT 'ID de la sucursal en donde se realiza la operacion  (Retiro o deposito)',
  `CajaID` int(11) NOT NULL COMMENT 'ID de la caja',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha en que se realiza la aportación',
  `UsuarioID` int(11) DEFAULT NULL COMMENT 'ID del usuario',
  `DescripcionMov` varchar(150) DEFAULT NULL COMMENT 'Descripcion del Movimiento',
  `NumMovimiento` bigint(20) DEFAULT NULL COMMENT 'Numero de Movimiento',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'ID de la Moneda',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`AportaSocMovID`),
  KEY `fk_SucursalIDD` (`SucursalID`),
  KEY `fk_ClientesIDD` (`ClienteID`),
  KEY `fk_CajaIDD` (`SucursalID`,`CajaID`),
  CONSTRAINT `fk_ClientesIDD` FOREIGN KEY (`ClienteID`) REFERENCES `CLIENTES` (`ClienteID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_SucursalIDD` FOREIGN KEY (`SucursalID`) REFERENCES `SUCURSALES` (`SucursalID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de movimientos de las aportaciones de los Socios'$$