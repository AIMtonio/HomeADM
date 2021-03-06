-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GARANTIAS
DELIMITER ;
DROP TABLE IF EXISTS `GARANTIAS`;DELIMITER $$

CREATE TABLE `GARANTIAS` (
  `GarantiaID` int(11) NOT NULL COMMENT 'ID de la Garantia',
  `ProspectoID` bigint(20) DEFAULT NULL COMMENT 'ProspectoID del titular de la Garantia',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ClienteID del titular de la Garantia',
  `AvalID` int(11) DEFAULT NULL COMMENT 'AvalID del titular de la Garantia',
  `GaranteID` int(11) DEFAULT NULL COMMENT 'GaranteID del titular de la Garantia',
  `GaranteNombre` varchar(75) DEFAULT NULL,
  `TipoGarantiaID` int(11) DEFAULT NULL COMMENT 'Id del Tipo de Garantia',
  `ClasifGarantiaID` int(11) DEFAULT NULL COMMENT 'Id de la Clasificacion de la Garantia',
  `ValorComercial` decimal(14,2) DEFAULT NULL COMMENT 'Valor comercial. Es el valor de la Garantia',
  `Observaciones` varchar(1200) DEFAULT NULL COMMENT 'Descripción u Observacion de la Garantia\n',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'Estado donde se Encuentra la Garantia',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'Municipio donde se Encuentra la Garantia\n\n',
  `Calle` varchar(100) DEFAULT NULL COMMENT 'calle',
  `Numero` varchar(10) DEFAULT NULL COMMENT 'Numero de la Calle\n	',
  `NumeroInt` varchar(10) DEFAULT NULL COMMENT 'Numero Interior de la Calle\n',
  `Lote` varchar(10) DEFAULT NULL COMMENT 'lote',
  `Manzana` varchar(100) DEFAULT NULL COMMENT 'manzana',
  `Colonia` varchar(100) DEFAULT NULL COMMENT 'colonia',
  `CodigoPostal` varchar(10) DEFAULT NULL COMMENT 'Codigo Postal\n',
  `M2Construccion` decimal(12,2) DEFAULT NULL COMMENT 'Metros Cuadrados de construccion\n',
  `M2Terreno` decimal(12,2) DEFAULT NULL COMMENT 'Metros Cuadrados de Terreno\n',
  `Asegurado` char(1) DEFAULT NULL COMMENT 'La garantia se encuentra Asegurada\nS .- Si esta Asegurada\nN .- No esta Asegurada	\n',
  `VencimientoPoliza` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Poliza\n',
  `FechaValuacion` date DEFAULT NULL COMMENT 'Fecha de la Valuacion\n',
  `NumAvaluo` varchar(10) DEFAULT NULL COMMENT 'Numero de Avaluo\n',
  `MontoAvaluo` decimal(21,2) DEFAULT NULL COMMENT 'Monto de la valuacion de la garantia',
  `NombreValuador` varchar(100) DEFAULT NULL COMMENT 'Nombre del Valuador\n',
  `Verificada` char(1) DEFAULT NULL COMMENT '	Indica si la garantia se encuentra Verificada\n\nS .- Si Verificada\nN .- No Verificada',
  `FechaVerificacion` date DEFAULT NULL COMMENT '\nFecha de Verificación\n',
  `TipoGravemen` char(2) DEFAULT NULL COMMENT 'L .- Libre\nG .- Gravado\n\nEstatus del Gravamen\n',
  `TipoInsCaptacion` char(1) DEFAULT NULL COMMENT 'C .- Cuenta\nI .-  Inversion Plazo\nK .- Inv.Kubo\nN.- No Aplica	\nTipo del Instrumento de Captacion\n',
  `InsCaptacionID` int(11) DEFAULT NULL COMMENT 'Id del Instrumento de Captacion\n',
  `MontoAsignado` decimal(14,2) DEFAULT NULL COMMENT 'Monto Asignado o que esta Cubriendo la Garantia, en los Creditos',
  `NoIdentificacion` varchar(45) DEFAULT NULL,
  `Estatus` char(1) DEFAULT NULL COMMENT 'A .- Alta	Estatus de la Garantia\nU .- Autorizada',
  `TipoDocumentoID` int(11) DEFAULT NULL COMMENT 'Tipo de Documento\nque valida la garantia\nde la tabla\nTIPOSDOCUMENTOS',
  `Asegurador` varchar(45) DEFAULT NULL COMMENT 'Nombre del Asegurador',
  `NombreAutoridad` varchar(45) DEFAULT NULL COMMENT 'Nombre de Autoridad',
  `CargoAutoridad` varchar(45) DEFAULT NULL COMMENT 'Cargo de la Autoridad',
  `FechaCompFactura` date DEFAULT NULL COMMENT 'Fecha de  compra de factura',
  `FechaGrevemen` date DEFAULT NULL COMMENT 'Fecha de Gravemen',
  `FolioRegistro` varchar(45) DEFAULT NULL COMMENT 'Folio de registro ',
  `MontoGravemen` decimal(14,2) DEFAULT NULL COMMENT 'Monto de Gravemen',
  `NombBenefiGravem` varchar(75) DEFAULT NULL COMMENT 'Nombre del beneficiario de Gravemen',
  `NotarioID` int(11) DEFAULT NULL COMMENT 'ID del Notario ',
  `NumPoliza` bigint(12) DEFAULT NULL COMMENT 'Numero de Poliza',
  `ReferenFactura` varchar(45) DEFAULT NULL COMMENT 'Referencia de la factuea',
  `RFCEmisor` varchar(45) DEFAULT NULL COMMENT 'RFC del Emisor',
  `SerieFactura` varchar(45) DEFAULT NULL COMMENT 'Serie de la Factura',
  `ValorFactura` varchar(45) DEFAULT NULL COMMENT 'Valor de la Factura',
  `FechaRegistro` date DEFAULT NULL COMMENT ' Fecha de Registro',
  `CalleGarante` varchar(70) DEFAULT NULL COMMENT 'Direccion de Garante: Calle',
  `NumIntGarante` varchar(45) DEFAULT NULL COMMENT 'Direccion Garante: Numero Interior ',
  `NumExtGarante` varchar(45) DEFAULT NULL COMMENT 'Direccion Garante: Numero Exterior',
  `ColoniaGarante` varchar(65) DEFAULT NULL COMMENT 'Direccion Garante: Colonia\\n',
  `CodPostalGarante` varchar(45) DEFAULT NULL COMMENT 'Direccion garante: Codigo Postal',
  `EstadoIDGarante` int(11) DEFAULT NULL COMMENT 'Direccion Garante: Estado de la Republica',
  `MunicipioGarante` int(11) DEFAULT NULL COMMENT 'Direccion Garante: Municipio ',
  `LocalidadID` int(11) DEFAULT NULL,
  `ColoniaID` int(11) DEFAULT NULL,
  `Proporcion` decimal(14,2) DEFAULT NULL COMMENT 'Es para llevar el control de la proporciòn',
  `Usufructuaria` char(1) DEFAULT NULL COMMENT 'Este campo, guarda si la garantìa tiene o no usufructuraria.\nS=Sì.\nN= No.',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(70) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`GarantiaID`),
  KEY `fk_GARANTIAS_1` (`ProspectoID`),
  KEY `fk_GARANTIAS_2` (`ClienteID`),
  KEY `fk_GARANTIAS_3` (`TipoGarantiaID`),
  KEY `fk_GARANTIAS_4` (`ClasifGarantiaID`),
  CONSTRAINT `fk_GARANTIAS_3` FOREIGN KEY (`TipoGarantiaID`) REFERENCES `TIPOGARANTIAS` (`TipoGarantiasID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_GARANTIAS_4` FOREIGN KEY (`ClasifGarantiaID`) REFERENCES `CLASIFGARANTIAS` (`ClasifGarantiaID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Lleva el registro de los bienes que se dejan como garantía e'$$