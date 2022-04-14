--
-- Table structure for table `TICKET7150DETALLEPOLIZAABRIL`
--
DELIMITER ;
DROP TABLE IF EXISTS `TICKET7150DETALLEPOLIZAABRIL`;
DELIMITER $$


CREATE TABLE `TICKET7150DETALLEPOLIZAABRIL` (
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
  `Descripcion` varchar(150) NOT NULL COMMENT 'Descripcion del\nMovimiento',
  `Referencia` varchar(250) NOT NULL COMMENT 'Referencia',
  `ProcedimientoCont` varchar(30) DEFAULT NULL COMMENT 'Procedimiento\nContable que\nArma la Cuenta\nContable',
  `TipoInstrumentoID` int(11) DEFAULT NULL COMMENT 'ID del tipo de Instrumento que genera el movimiento.',
  `RFC` char(13) DEFAULT NULL COMMENT 'Registro Federal de Contribuyentes del Cliente',
  `TotalFactura` decimal(14,2) DEFAULT NULL COMMENT 'Monto Total Neto a Pagar de la Factura',
  `FolioUUID` varchar(100) DEFAULT NULL COMMENT 'Folio Fiscal o UUID del CFDI',
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$
