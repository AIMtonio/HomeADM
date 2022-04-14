-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDETALLEPOL
DELIMITER ;
DROP TABLE IF EXISTS `TMPDETALLEPOL`;DELIMITER $$

CREATE TABLE `TMPDETALLEPOL` (
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `PolizaID` bigint(20) DEFAULT NULL COMMENT 'Numero de la \nPoliza',
  `Fecha` date DEFAULT NULL COMMENT 'Fecha de la \nPoliza',
  `CentroCostoID` int(11) DEFAULT NULL COMMENT 'Centro de \nCostos',
  `CuentaCompleta` varchar(50) DEFAULT NULL COMMENT 'Cuenta Contable\nCompleta',
  `Instrumento` varchar(20) DEFAULT NULL COMMENT 'Instrumento\nque origino el\nmovimiento',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `Cargos` float DEFAULT NULL COMMENT 'Monto De Cargo\ndel Movimiento\n',
  `Abonos` float DEFAULT NULL COMMENT 'Monto De Abono\ndel Movimiento\n\n',
  `Descripcion` varchar(100) DEFAULT NULL COMMENT 'Descripcion del\nMovimiento',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(30) DEFAULT NULL COMMENT 'Procedimiento\nContable que\nArma la Cuenta\nContable',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `TipoCuentaID` int(11) DEFAULT NULL COMMENT 'Numero de Tipo de Cuenta',
  `GeneraInteres` char(1) DEFAULT NULL COMMENT 'Si la cuenta genera o no interes. S Si genera, N no genera ',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numero de Sucursal',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Persona'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal de Poliza Contable del Dia'$$