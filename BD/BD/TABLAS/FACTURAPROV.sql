-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FACTURAPROV
DELIMITER ;
DROP TABLE IF EXISTS `FACTURAPROV`;
DELIMITER $$


CREATE TABLE `FACTURAPROV` (
  `FacturaProvID` int(11) NOT NULL COMMENT 'Numero Consecutivo Interno de control',
  `ProveedorID` int(11) NOT NULL COMMENT 'Numero de Proveedor ',
  `NoFactura` varchar(20) NOT NULL DEFAULT '' COMMENT 'Numero de factura entregada por el proveedor',
  `FechaFactura` date DEFAULT NULL COMMENT 'Fecha de la factura',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus de la \nfactura\nA=Alta\nC=Cancelada\nP=Parcialmente \nPagada\nL=Liquidada\nV=Vencida \nR=En proceso de \n requisiciónI= Importada/Guardada',
  `CondicionesPago` int(11) DEFAULT NULL COMMENT 'Condiciones de pago de la factura',
  `FechaProgPago` datetime DEFAULT NULL COMMENT 'Fecha Programada de pago, depende de las condiciones de pago',
  `FechaVencimient` datetime DEFAULT NULL COMMENT 'Fecha Maxima de pago, Se considera vencida en antiguedad de saldos despues de esta fecha.',
  `SaldoFactura` decimal(13,2) DEFAULT NULL COMMENT 'Saldo de la factura por su hubo pagos parciales',
  `TotalGravable` decimal(13,2) DEFAULT NULL COMMENT 'Monto para tomar como base calculo IVA',
  `TotalFactura` decimal(13,2) DEFAULT NULL COMMENT 'Monto Total Neto a Pagar de la Factura',
  `SubTotal` decimal(13,2) DEFAULT NULL COMMENT 'Subtotal antes de impuestos',
  `CenCostoManualID` int(11) DEFAULT NULL COMMENT 'Centro de Costo al que se aplicara a Tipo de Pago',
  `CenCostoAntID` int(11) DEFAULT NULL COMMENT 'Centro de Costo al que se aplicara a Tipo de Pago',
  `PagoAnticipado` char(1) DEFAULT NULL COMMENT 'Campo para validar si es campo anticipado o no\\nS = SI\\nN = NO',
  `ProrrateaImp` char(1) DEFAULT NULL COMMENT 'Campo para identificar si se prorratea impuesto',
  `TipoPagoAnt` char(1) DEFAULT NULL COMMENT 'Se refiere al Tipo de Pago anticipado:\\nA = Anticipo a Proveedores\\n\r\n								  G = Gastos por Comprobar\\nT = Tarjeta de Débito',
  `EmpleadoID` int(11) DEFAULT NULL,
  `RutaImagenFact` varchar(150) DEFAULT NULL COMMENT 'Ruta donde se almacena la imagen de la factura.',
  `RutaXMLFact` varchar(150) DEFAULT NULL COMMENT 'Ruta donde se almacena el archivo XML de la factura.',
  `FechaCancelacion` date DEFAULT NULL,
  `MotivoCancela` varchar(150) DEFAULT NULL,
  `PolizaID` bigint(20) DEFAULT '0' COMMENT 'Numero de Poliza relacionados con DetallePoliza, se asigna el valor al dar de alta la Factura',
  `FolioUUID` varchar(100) DEFAULT '0' COMMENT 'Folio Fiscal o UUID del CFDI',
  `OrigenFactura` varchar(2) DEFAULT 'FP' COMMENT 'Origen de la factura\nFM.-CARGA MASIVA\nFP.-PANTALLA DE FACTURA DE PROVEEDOR',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'ID de Instituciones de Fondeo',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Usuario que Registro el Movimiento',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Fecha de Sistema con Hora',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Direccion de IP de la Maquina que realizo el Registro',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Programa ID',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Sucursal que realizo el registro',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero Unico de Transaccion del Movimiento Registrado',
  PRIMARY KEY (`ProveedorID`,`NoFactura`),
  KEY `fk_FACTURAPROV_proveedor_idx` (`ProveedorID`),
  KEY `INDEX_01FCTRPRV` (`NumTransaccion`),
  KEY `INDEX_02FCTRPRV` (`PolizaID`),
  KEY `INDEX_03FCTRPRV` (`ProveedorID`),
  CONSTRAINT `fk_FACTURAPROV_proveedor` FOREIGN KEY (`ProveedorID`) REFERENCES `PROVEEDORES` (`ProveedorID`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para las facturas de Provedor PASIVOS'$$