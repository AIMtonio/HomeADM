-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCONTAMOVS
DELIMITER ;
DROP TABLE IF EXISTS `TMPCONTAMOVS`;
DELIMITER $$


CREATE TABLE `TMPCONTAMOVS` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Empresa ID',
  `PolizaID` bigint(20) NOT NULL COMMENT 'Numero de la \nPoliza',
  `Fecha` date NOT NULL COMMENT 'Fecha de la \nPoliza',
  `CentroCostoID` int(11) NOT NULL COMMENT 'Centro de \nCostos',
  `CuentaCompleta` varchar(50) NOT NULL COMMENT 'Cuenta Contable\nCompleta',
  `Instrumento` varchar(20) NOT NULL COMMENT 'Instrumento\nque origino el\nmovimiento',
  `MonedaID` int(11) NOT NULL COMMENT 'Moneda',
  `Cargos` decimal(14,4) DEFAULT NULL,
  `Abonos` decimal(14,4) DEFAULT NULL,
  `Descripcion` varchar(100) NOT NULL COMMENT 'Descripcion del\nMovimiento',
  `Referencia` varchar(50) NOT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(30) DEFAULT NULL COMMENT 'Procedimiento\nContable que\nArma la Cuenta\nContable',
  `ClienteID` int(11) NOT NULL COMMENT 'Numero de Cliente',
  `TipoPersona` char(1) DEFAULT NULL COMMENT 'Tipo de Personalidad del Cliente M.- Persona Moral A.- Persona Fisica Con Actividad Empresarial F.- Persona Fisica Sin Actividad Empresarial\n',
  `SucursalOrigen` int(5) DEFAULT NULL COMMENT 'No de Sucursal a la que pertenece el cliente, Llave Foranea Hacia Tabla SUCURSALES\n',
  `CuentaAhoID` bigint(12) DEFAULT NULL,
  `TipoCuentaID` int(11) NOT NULL COMMENT 'Numero de Tipo de Cuenta',
  `GeneraInteres` char(1) DEFAULT NULL COMMENT 'Si la cuenta genera o no interes. S Si genera, N no genera ',
  `Cuenta` char(4) DEFAULT NULL COMMENT 'Capital de la cuenta de\nAhorro',
  `Nomenclatura` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura de la cuenta',
  `NomenclaturaCR` varchar(30) DEFAULT NULL COMMENT 'Nomenclatura del centro de costos',
  `TipoMovAhoID` varchar(4) DEFAULT NULL COMMENT 'Tipo Mov de Ahorro',
  `NatMovimiento` char(1) DEFAULT NULL COMMENT 'Naturaleza del mov. C - Cargo \n A - Abono',
  `SubCtaTipProAho` char(6) DEFAULT NULL COMMENT 'SubCuenta tip prod ahorro',
  `SubCtaMonAho` char(6) DEFAULT NULL COMMENT 'SubCuenta Moneda ahorro',
  `SubCtaTipRenAho` char(6) DEFAULT NULL COMMENT 'Tipo Rendimiento de ahorro ',
  `SubCtaTipPerAho` char(6) DEFAULT NULL COMMENT 'Tipo De persona de ahorro ',
  `SubCtaClasifAho` char(6) DEFAULT NULL,
  `SucursalCta` int(11) DEFAULT NULL COMMENT 'Sucursal de la cuenta de ahorro',
  `ClasificacionConta` char(1) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  KEY `index1` (`CuentaAhoID`),
  KEY `index2` (`TipoCuentaID`),
  KEY `index3` (`GeneraInteres`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='contiene temporalmente los movs contables d cierre d mes'$$
