-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMOV
DELIMITER ;
DROP TABLE IF EXISTS `DISPERSIONMOV`;
DELIMITER $$


CREATE TABLE `DISPERSIONMOV` (
  `ClaveDispMov` int(11) NOT NULL DEFAULT '0' COMMENT 'Consecutivo de la tabla de movimientos',
  `DispersionID` int(11) NOT NULL,
  `CuentaCargo` bigint(12) DEFAULT NULL,
  `CuentaContable` varchar(25) DEFAULT NULL COMMENT 'Cuuenta Contable ',
  `Descripcion` varchar(50) DEFAULT NULL COMMENT 'Descripción del motivo.',
  `Referencia` varchar(50) DEFAULT NULL COMMENT 'Referencia de la dispersión',
  `TipoMovDIspID` char(4) DEFAULT NULL COMMENT 'ID del Tipo de Movimiento\nde Tesoreria\ntabla:\n(TIPOSMOVTESO)',
  `FormaPago` int(1) DEFAULT NULL COMMENT 'Forma de Pago:\npuede ser por\nSPEI=1\nCHEQUE=2\nBanca Electronica = 3\nTarjeta Empresarial = 4\nOrden de pago	= 5',
  `Monto` decimal(12,2) DEFAULT NULL COMMENT 'Monto a realizar ',
  `CuentaDestino` varchar(25) DEFAULT NULL COMMENT 'Referencia de Cuenta SPEI o Orden de pago',
  `Identificacion` varchar(16) DEFAULT NULL COMMENT 'Numero de identificación',
  `Estatus` varchar(2) DEFAULT NULL COMMENT 'Estatus del registro.\nN = No aplicada,\nP = Pendiente por autorizar,\nA = Autorizada\nE = Exportada\nC = Cancelada',
  `NombreBenefi` varchar(250) DEFAULT NULL COMMENT 'Nombre Beneficiario',
  `FechaEnvio` datetime DEFAULT NULL COMMENT 'Fecha en la cual se realiza el envió del registro.',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Numer de surculsal donde se origina la dispersion',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto con\nfactura\ncorresponde con\nREQGASTOSUCURMOV',
  `NombreArchivo` varchar(200) DEFAULT '' COMMENT 'Nombre del archivo por el que fue procesada la dispersion',
  `EstatusResSanta` varchar(3) DEFAULT '00' COMMENT 'Estatus de la dispersion respuesta SANTANDER. Catalogo en ralacion CATRECHRESPDISPER',
  `NomArchivoGenerado` varchar(200) DEFAULT '' COMMENT 'Nombre del archivo que se genero para enviarse al banco',
  `FechaGenArch` date DEFAULT '1900-01-01' COMMENT 'Fecha en que se genero el archivo',
  `FechaLiquidacion` date DEFAULT '1900-01-01' COMMENT 'Fecha de liquidacion',
  `FechaRechazo` date DEFAULT '1900-01-01' COMMENT 'Fecha en que se realizo el rechazo',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(20) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT '0',
  `ProveedorID` int(11) DEFAULT NULL COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto \ncorresponde con \nREQGASTOSUCURMOV',
  `FacturaProvID` varchar(20) DEFAULT NULL COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto con\nfactura\ncorresponde con\nREQGASTOSUCURMOV',
  `DetReqGasID` int(11) DEFAULT NULL COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto corresponde \ncon \nREQGASTOSUCURMOV',
  `TipoGastoID` int(11) DEFAULT NULL COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto corresponde \ncon \nTESOCATTIPGAS',
  `CatalogoServID` int(11) DEFAULT NULL COMMENT 'consecutivo de tabla pago de servicios se ocupa solo para dispersiones de pagos de servicios',
  `AnticipoFact` char(1) DEFAULT NULL COMMENT 'Si = S, No = N. Especifica si se trata de un anticipo ',
  `TipoChequera` char(2) DEFAULT '' COMMENT 'Especifica el tipo de chequera que se estará utilizando, los posibles valores son:\nE - Estandar\nP - Proforma',
  `ConceptoDispersion` int(11) DEFAULT NULL COMMENT 'Concepto de la Dispersiom. Se ocupa solo si se trata del Forma de Pago SPEI, corresponde con CATCONCEPTOSDISPERSION.',
  PRIMARY KEY (`ClaveDispMov`),
  KEY `fk_DispersionID` (`DispersionID`),
  KEY `fk_CuentaCargo` (`CuentaCargo`),
  KEY `fk_TipoMovDispID` (`TipoMovDIspID`),
  KEY `fk_DISPERSIONMOV_1` (`TipoMovDIspID`),
  CONSTRAINT `fk_DISPERSIONMOV_1` FOREIGN KEY (`TipoMovDIspID`) REFERENCES `TIPOSMOVTESO` (`TipoMovTesoID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Detalla del movimiento de Dispersión.'$$