-- Creacion de tabla TMPCARGAFACTURAS

DELIMITER ;
DROP TABLE IF EXISTS `TMPCARGAFACTURAS`;

DELIMITER $$
CREATE TABLE `TMPCARGAFACTURAS` (
	`ID` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Identificador de la tabla',
    `FechaSistema` DATE DEFAULT '1900-01-01' COMMENT 'Fecha del Sistema',
    `MesSubirFact` INT(11) DEFAULT '0' COMMENT 'Mes seleccionado para subir las facturas, 1 - 12 ',
	`UUID` VARCHAR(1000) DEFAULT '' COMMENT 'Folio UUID de la factura',
	`Estatus` VARCHAR(100) DEFAULT '' COMMENT 'Estatus de la factura',
	`EsCancelable` VARCHAR(500) DEFAULT '' COMMENT 'Descripcion si es cancelable o no',
	`EstatusCancelacion` VARCHAR(100) DEFAULT '' COMMENT 'Estatus de la cancelacion',
	`Tipo` VARCHAR(100) DEFAULT '' COMMENT 'I-INGRESO, P-PAGO ',
	`Anio` INT(11) DEFAULT '0' COMMENT 'Anio de la factura',
	`Mes` INT(11) DEFAULT '0' COMMENT 'Mes de la factura',
	`Dia` INT(11) DEFAULT '0' COMMENT 'Dia de la factura ',
	`FechaEmision` DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha emision de la factura',
    `FechaTimbrado` DATETIME DEFAULT '1900-01-01' COMMENT 'Fecha timbrado de la factura',
	`Serie` VARCHAR(100) DEFAULT '' COMMENT 'Serie de la factura',
    `Folio` BIGINT(20) DEFAULT 0 COMMENT 'Folio de la factura',
    `LugarExpedicion` BIGINT(20) DEFAULT 0 COMMENT 'Lugar de expedicion de la factura',
	`Confirmacion` VARCHAR(1000) DEFAULT '' COMMENT 'Confirmacion de la factura',
    `CfdiRelacionados` VARCHAR(1000) DEFAULT '' COMMENT 'CFDI relacionados de la factura',
	`FormaPago` VARCHAR(500) DEFAULT '' COMMENT 'Forma de pago de la factura',
	`MetodoPago` VARCHAR(500) DEFAULT '' COMMENT 'Metodo de pago de la factura',
    `CondicionesPago` VARCHAR(500) DEFAULT '' COMMENT 'Condiciones de pago de la factura',
    `TipoCambio` INT(11) DEFAULT '0' COMMENT 'Tipo de cambio de la factura',
    `Moneda` VARCHAR(500) DEFAULT '' COMMENT 'Moneda de la factura',
    `SubTotal` VARCHAR(20) DEFAULT '0.00' COMMENT 'Subtotal de la factura',
    `Descuento` VARCHAR(20) DEFAULT '0.00' COMMENT 'Descuento de la factura',
    `Total` VARCHAR(20) DEFAULT '0.00' COMMENT 'Total de la factura',
    `ISRRetenido` VARCHAR(20) DEFAULT '0.00' COMMENT 'ISR Retenido de la factura',
    `ISRTrasladado` VARCHAR(20) DEFAULT '0.00' COMMENT 'ISR Trasladado de la factura',
    `IVARetenidoGlobal` VARCHAR(20) DEFAULT '0.00' COMMENT 'IVA Retenido Global de la factura',
    `IVARetenido6` VARCHAR(20) DEFAULT '0.00' COMMENT 'IVA Retenido 6 de la factura',
    `IVATrasladado16` VARCHAR(20) DEFAULT '0.00' COMMENT 'IVA Trasladado 16 de la factura',
    `IVATrasladado8` VARCHAR(20) DEFAULT '0.00' COMMENT 'IVA Trasladado 8 de la factura',
    `IVAExento` VARCHAR(10) DEFAULT '' COMMENT 'IVA Exento de la factura',
    `BaseIVAExento` VARCHAR(20) DEFAULT '0.00' COMMENT 'Base IVA Exento de la factura',
    `IVATasaCero` VARCHAR(10) DEFAULT '' COMMENT 'IVA Tasa cero de la factura',
    `BaseIVATasaCero` VARCHAR(20) DEFAULT '0.00' COMMENT 'Base IVA Tasa cero de la factura',
    `IEPSRetenidoTasa` VARCHAR(20) DEFAULT '0.00' COMMENT 'IEPS Retenido Tasa de la factura',
    `IEPSTrasladadoTasa` VARCHAR(20) DEFAULT '0.00' COMMENT 'IEPS Trasladado Tasa de la factura',
    `IEPSRetenidoCuota` VARCHAR(20) DEFAULT '0.00' COMMENT 'IEPS Retenido Cuota de la factura',
    `IEPSTrasladadoCuota` VARCHAR(20) DEFAULT '0.00' COMMENT 'IEPS Trasladado Cuota de la factura',
    `TotalImpuestosRetenidos` VARCHAR(20) DEFAULT '0.00' COMMENT 'Total de impuestos retenidos de la factura',
    `TotalImpuestosTrasladados` VARCHAR(20) DEFAULT '0.00' COMMENT 'Total de impuestos trasladados de la factura',
    `TotalRetencionesLocales` VARCHAR(20) DEFAULT '0.00' COMMENT 'Total retenciones locales de la factura',
    `TotalTrasladosLocales` VARCHAR(20) DEFAULT '0.00' COMMENT 'Total traslados locales de la factura',
    `ImpuestoLocalRetenido` VARCHAR(20) DEFAULT '0.00' COMMENT 'Impuesto local retenido de la factura',
    `TasadeRetencionLocal` VARCHAR(20) DEFAULT '0.00' COMMENT 'Tasa de Retencion Local de la factura',
    `ImportedeRetencionLocal` VARCHAR(20) DEFAULT '0.00' COMMENT 'Importe de Retencion Local de la factura',
    `ImpuestoLocalTrasladado` VARCHAR(20) DEFAULT '0.00' COMMENT 'Impuesto Local Trasladado de la factura',
    `TasadeTrasladoLocal` VARCHAR(20) DEFAULT '0.00' COMMENT 'Tasa de Traslado Local de la factura',
    `ImportedeTrasladoLocal` VARCHAR(20) DEFAULT '0.00' COMMENT 'Importe de Traslado Local de la factura',
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
	PRIMARY KEY (`ID`),
	KEY `IDX_TMPCARGAFACTURAS_1` (`UUID`),
	KEY `IDX_TMPCARGAFACTURAS_2` (`Folio`),
	KEY `IDX_TMPCARGAFACTURAS_3` (`MesSubirFact`),
	KEY `IDX_TMPCARGAFACTURAS_4` (`Estatus`),
	KEY `IDX_TMPCARGAFACTURAS_5` (`Tipo`)    
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para almacenar las facturas cargadas de un archivo excel con un ETL'$$
