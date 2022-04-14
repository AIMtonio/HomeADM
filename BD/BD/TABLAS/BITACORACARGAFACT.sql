-- Creacion de tabla BITACORACARGAFACT

DELIMITER ;
DROP TABLE IF EXISTS `BITACORACARGAFACT`;

DELIMITER $$
CREATE TABLE `BITACORACARGAFACT` (
	`FolioFacturaID` INT(11) NOT NULL COMMENT 'Folio consecutivo de las facturas cargadas',
	`FolioCargaID` INT(11) NOT NULL	COMMENT 'Folio del archivo cargado',
    `FechaCarga` DATE DEFAULT NULL COMMENT 'Fecha del Sistema',
    `MesSubirFact` INT(11) DEFAULT '0' COMMENT 'Mes seleccionado para subir las facturas, 1 - 12 ',
	`UUID` VARCHAR(1000) NOT NULL COMMENT 'Folio UUID de la factura',
	`Estatus` VARCHAR(100) DEFAULT '' COMMENT 'Estatus de la factura',
	`EsCancelable` VARCHAR(500) DEFAULT '' COMMENT 'Descripcion si es cancelable o no',
	`EstatusCancelacion` VARCHAR(100) DEFAULT '' COMMENT 'Estatus de la cancelacion',
	`Tipo` VARCHAR(100) DEFAULT '' COMMENT 'I-INGRESO, P-PAGO ',
	`Anio` INT(11) DEFAULT '0' COMMENT 'Anio de la factura',
	`Mes` INT(11) DEFAULT '0' COMMENT 'Mes de la factura',
	`Dia` INT(11) DEFAULT '0' COMMENT 'Dia de la factura ',
	`FechaEmision` DATETIME DEFAULT NULL COMMENT 'Fecha emision de la factura',
    `FechaTimbrado` DATETIME DEFAULT NULL COMMENT 'Fecha timbrado de la factura',
	`Serie` VARCHAR(100) DEFAULT '' COMMENT 'Serie de la factura',
    `Folio` BIGINT(20) DEFAULT 0 COMMENT 'Folio de la factura',
    `LugarExpedicion` BIGINT(20) DEFAULT 0 COMMENT 'Lugar de expedicion de la factura',
	`Confirmacion` VARCHAR(1000) DEFAULT '' COMMENT 'Confirmacion de la factura',
    `CfdiRelacionados` VARCHAR(1000) DEFAULT '' COMMENT 'CFDI relacionados de la factura',
	`FormaPago` VARCHAR(500) DEFAULT '' COMMENT 'Forma de pago de la factura',
	`MetodoPago` VARCHAR(500) DEFAULT '' COMMENT 'Metodo de pago de la factura',
    `CondicionesPago` VARCHAR(500) DEFAULT '' COMMENT 'Condiciones de pago de la factura',
    `TipoCambio` INT(11) DEFAULT NULL COMMENT 'Tipo de cambio de la factura',
    `Moneda` VARCHAR(500) DEFAULT '' COMMENT 'Moneda de la factura',
    `SubTotal` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Subtotal de la factura',
    `Descuento` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Descuento de la factura',
    `Total` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Total de la factura',
    `ISRRetenido` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'ISR Retenido de la factura',
    `ISRTrasladado` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'ISR Trasladado de la factura',
    `IVARetenidoGlobal` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IVA Retenido Global de la factura',
    `IVARetenido6` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IVA Retenido 6 de la factura',
    `IVATrasladado16` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IVA Trasladado 16 de la factura',
    `IVATrasladado8` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IVA Trasladado 8 de la factura',
    `IVAExento` VARCHAR(10) DEFAULT '' COMMENT 'IVA Exento de la factura',
    `BaseIVAExento` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Base IVA Exento de la factura',
    `IVATasaCero` VARCHAR(10) DEFAULT '' COMMENT 'IVA Tasa cero de la factura',
    `BaseIVATasaCero` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Base IVA Tasa cero de la factura',
    `IEPSRetenidoTasa` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IEPS Retenido Tasa de la factura',
    `IEPSTrasladadoTasa` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IEPS Trasladado Tasa de la factura',
    `IEPSRetenidoCuota` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IEPS Retenido Cuota de la factura',
    `IEPSTrasladadoCuota` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'IEPS Trasladado Cuota de la factura',
    `TotalImpuestosRetenidos` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Total de impuestos retenidos de la factura',
    `TotalImpuestosTrasladados` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Total de impuestos trasladados de la factura',
    `TotalRetencionesLocales` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Total retenciones locales de la factura',
    `TotalTrasladosLocales` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Total traslados locales de la factura',
    `ImpuestoLocalRetenido` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Impuesto local retenido de la factura',
    `TasadeRetencionLocal` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Tasa de Retencion Local de la factura',
    `ImportedeRetencionLocal` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Importe de Retencion Local de la factura',
    `ImpuestoLocalTrasladado` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Impuesto Local Trasladado de la factura',
    `TasadeTrasladoLocal` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Tasa de Traslado Local de la factura',
    `ImportedeTrasladoLocal` DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Importe de Traslado Local de la factura',
	`RfcEmisor` VARCHAR(20) DEFAULT '' COMMENT 'RFC del emisor de la factura',
	`NombreEmisor` VARCHAR(500) DEFAULT '' COMMENT 'Nombre del emisor de la factura',
	`RegimenFiscalEmisor` VARCHAR(500) DEFAULT '' COMMENT 'Regimen Fiscal Emisor de la factura',
	`RfcReceptor` VARCHAR(20) DEFAULT '' COMMENT 'Rfc Receptor de la factura',
	`NombreReceptor` VARCHAR(500) DEFAULT '' COMMENT 'Nombre Receptor de la factura',
	`UsoCFDIReceptor` VARCHAR(200) DEFAULT '' COMMENT 'Uso CFDI Receptor de la factura',
	`ResidenciaFiscal` VARCHAR(500) DEFAULT '' COMMENT 'Residencia Fisal receptor de la factura',
	`NumRegIdTrib` VARCHAR(200) DEFAULT '' COMMENT 'Numero Regimen Tributario CFDI Receptorde la factura',
	`ListaNegra` VARCHAR(500) DEFAULT '' COMMENT 'Nombre Receptor de la factura',
	`Conceptos` TEXT COMMENT 'Uso CFDI Receptor de la factura',
	`PACCertifico` VARCHAR(500) DEFAULT '' COMMENT 'Residencia Fisal receptor de la factura',
	`RutadelXML` VARCHAR(1000) DEFAULT '' COMMENT 'Uso CFDI Receptorde la factura',
	`EstatusPro` CHAR(1) DEFAULT NULL COMMENT 'P=Procesado \nN=No Procesado \nB=Baja',
    `EsExitoso` CHAR(1) DEFAULT NULL COMMENT 'S- Registro exitoso N- Registro erroneo',
    `TipoError` INT(11) DEFAULT NULL COMMENT 'Numero de error 1- informacion vacia, 2 meses diferentes, 3 proveedor no existe ',
    `DescripcionError` varchar(200) DEFAULT NULL COMMENT 'Descripcion del error en la carga de archivo de Facturas',
	`EmpresaID` INT(11) DEFAULT NULL,
	`Usuario` INT(11) DEFAULT NULL,
	`FechaActual` DATETIME DEFAULT NULL,
	`DireccionIP` VARCHAR(15) DEFAULT NULL,
	`ProgramaID` VARCHAR(50) DEFAULT NULL,
	`Sucursal` INT(11) DEFAULT NULL,
	`NumTransaccion` BIGINT(20) DEFAULT NULL,
    PRIMARY KEY (`FolioFacturaID`),
	KEY `IDX_BITACORACARGAFACT_1_idx` (`FolioCargaID`),
	KEY `IDX_BITACORACARGAFACT_2_idx` (`FechaCarga`),
	KEY `IDX_BITACORACARGAFACT_3_idx` (`MesSubirFact`),
	KEY `IDX_BITACORACARGAFACT_4_idx` (`Tipo`),
	KEY `IDX_BITACORACARGAFACT_5_idx` (`Anio`),
	KEY `IDX_BITACORACARGAFACT_6_idx` (`Mes`),
	KEY `IDX_BITACORACARGAFACT_7_idx` (`FechaTimbrado`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TAB: Bitacora de carga masiva de facturas'$$