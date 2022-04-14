-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISDISPERSIONMOV
DELIMITER ;
DROP TABLE IF EXISTS `HISDISPERSIONMOV`;
DELIMITER $$


CREATE TABLE `HISDISPERSIONMOV` (
  `ClaveDispMov` 		INT(11) DEFAULT '0' COMMENT 'Consecutivo de la tabla de movimientos',
  `DispersionID` 		INT(11) DEFAULT '0',
  `CuentaCargo`	 		BIGINT(12) DEFAULT '0',
  `CuentaContable` 		VARCHAR(25) DEFAULT '' COMMENT 'Cuuenta Contable ',
  `Descripcion` 		VARCHAR(50) DEFAULT '' COMMENT 'Descripción del motivo.',
  `Referencia` 			VARCHAR(50) DEFAULT '' COMMENT 'Referencia de la dispersión',
  `TipoMovDIspID` 		CHAR(4) DEFAULT '' COMMENT 'ID del Tipo de Movimiento\nde Tesoreria\ntabla:\n(TIPOSMOVTESO)',
  `FormaPago` 			INT(1) DEFAULT '0' COMMENT'Forma de Pago:\npuede ser por\nSPEI=1\nCHEQUE=2\nBanca Electronica = 3\nTarjeta Empresarial = 4\nOrden de pago	= 5',
  `Monto` 				DECIMAL(12,2) DEFAULT '0.0' COMMENT 'Monto a realizar ',
  `CuentaDestino` 		VARCHAR(25) DEFAULT '' COMMENT 'Referencia de Cuenta SPEI o Orden de pago',
  `Identificacion` 		VARCHAR(16) DEFAULT '' COMMENT 'Numero de identificación',
  `Estatus` 			VARCHAR(2) DEFAULT '' COMMENT 'Estatus del registro.\nN = No aplicada,\nP = Pendiente por autorizar,\nA = Autorizada\nE = Exportada',
  `NombreBenefi` 		VARCHAR(250) DEFAULT '' COMMENT 'Nombre Beneficiario',
  `FechaEnvio` 			DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha en la cual se realiza el envió del registro.',
  `SucursalID` 			INT(11) DEFAULT '0' COMMENT 'Numer de surculsal donde se origina la dispersion',
  `CreditoID` 			BIGINT(12) DEFAULT '0' COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto con\nfactura\ncorresponde con\nREQGASTOSUCURMOV',
  `NombreArchivo` 		VARCHAR(100) DEFAULT '' COMMENT 'Nombre del archivo por el que fue procesada la dispersion',
  `EstatusResSanta` 	VARCHAR(3) DEFAULT '00' COMMENT 'Estatus de la dispersion respuesta SANTANDER. Catalogo en ralacion CATRECHRESPDISPER',
  `NomArchivoGenerado` 	VARCHAR(100) DEFAULT '' COMMENT 'Nombre del archivo que se genero para enviarse al banco',
  `FechaGenArch` 		DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que se genero el archivo',
  `FechaLiquidacion` 	DATE DEFAULT '1900-01-01' COMMENT 'Fecha de liquidacion',
  `FechaRechazo` 		DATE DEFAULT '1900-01-01' COMMENT 'Fecha en que se realizo el rechazo',
  `ProveedorID` 		INT(11) DEFAULT '0' COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto \ncorresponde con \nREQGASTOSUCURMOV',
  `FacturaProvID` 		VARCHAR(20) DEFAULT '' COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto con\nfactura\ncorresponde con\nREQGASTOSUCURMOV',
  `DetReqGasID` 		INT(11) DEFAULT '0' COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto corresponde \ncon \nREQGASTOSUCURMOV',
  `TipoGastoID` 		INT(11) DEFAULT '0' COMMENT 'Se ocupa solo si se \ntrata de una\nrequisicion de\ngasto corresponde \ncon \nTESOCATTIPGAS',
  `CatalogoServID` 		INT(11) DEFAULT '0' COMMENT 'consecutivo de tabla pago de servicios se ocupa solo para dispersiones de pagos de servicios',
  `AnticipoFact` 		CHAR(1) DEFAULT '' COMMENT 'Si = S, No = N. Especifica si se trata de un anticipo ',
  `TipoChequera` 		CHAR(2) DEFAULT '' COMMENT 'Especifica el tipo de chequera que se estará utilizando, los posibles valores son:\nE - Estandar\nP - Proforma',
  `ConceptoDispersion`  INT(11) DEFAULT '0' COMMENT 'Concepto de la Dispersiom. Se ocupa solo si se trata del Forma de Pago SPEI, corresponde con CATCONCEPTOSDISPERSION.',
  `FechaCancela` 		DATE DEFAULT '1900-01-01' COMMENT 'FECHA CANCELACION',
  `NumeroTrans` 		BIGINT(20) DEFAULT '0' COMMENT 'Numero de transaccion con la que se realiza la operacion',
  `EmpresaID` 			INT(11) DEFAULT '0',
  `Usuario` 			INT(11) DEFAULT '0',
  `FechaActual` 		DATETIME DEFAULT '1900-01-01',
  `DireccionIP` 		VARCHAR(20) DEFAULT '',
  `ProgramaID` 			VARCHAR(50) DEFAULT '',
  `Sucursal` 			INT(11) DEFAULT '0',
  `NumTransaccion` 		BIGINT(20) DEFAULT '0',
  INDEX (ClaveDispMov, DispersionID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Contiene el Historico de la tabla de DISPERSIONMOV'$$
