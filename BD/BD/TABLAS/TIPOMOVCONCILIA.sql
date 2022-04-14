-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOMOVCONCILIA
DELIMITER ;
DROP TABLE IF EXISTS `TIPOMOVCONCILIA`;DELIMITER $$

CREATE TABLE `TIPOMOVCONCILIA` (
  `TipMovConciliaID` char(4) NOT NULL COMMENT 'Id del Tipo de Movimiento de Conciliacion',
  `Descripcion` varchar(200) DEFAULT NULL COMMENT 'Descripcion del Tipo de Movimiento',
  `CuentaContable` char(25) DEFAULT NULL COMMENT 'Cuenta Contable que afecta',
  `CuentaMayor` char(4) DEFAULT NULL COMMENT 'Cuenta Contable de Mayor',
  `CuentaEditable` char(1) DEFAULT NULL COMMENT 'S .- Si es editables o Capturable\nN .- No es Editable',
  `NaturaContable` char(1) DEFAULT NULL COMMENT 'C .- Cargo\nA .- Abono',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha Registro',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa Origen',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal Origen',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`TipMovConciliaID`),
  KEY `fk_TIPMOVCONCILIA_1` (`CuentaContable`),
  CONSTRAINT `fk_TIPMOVCONCILIA_1` FOREIGN KEY (`CuentaContable`) REFERENCES `CUENTASCONTABLES` (`CuentaCompleta`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Movimientos de Conciliacion, Tesoreria'$$