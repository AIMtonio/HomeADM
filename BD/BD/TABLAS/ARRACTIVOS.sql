-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRACTIVOS
DELIMITER ;
DROP TABLE IF EXISTS `ARRACTIVOS`;DELIMITER $$

CREATE TABLE `ARRACTIVOS` (
  `ActivoID` int(11) NOT NULL COMMENT 'ID del Activo',
  `Descripcion` varchar(150) NOT NULL COMMENT 'Nombre del Activo',
  `TipoActivo` int(11) NOT NULL COMMENT 'Tipo de Activo:1=Autos, 2=Muebles',
  `SubtipoActivoID` int(11) NOT NULL COMMENT 'Id de la categoria a la que pertenece el Activo, llave primaria de ARRCSUBTIPOACTIVO',
  `Modelo` varchar(50) NOT NULL COMMENT 'Modelo del Activo',
  `MarcaID` int(11) NOT NULL COMMENT 'ID del catalogo de marcas, llave primaria de la tabla: ARRMARCAACTIVO',
  `NumeroSerie` varchar(45) NOT NULL COMMENT 'Numero de serie del activo',
  `NumeroFactura` varchar(10) NOT NULL COMMENT 'Numero o folio de la factura del activo',
  `ValorFactura` decimal(14,2) NOT NULL COMMENT 'Valor de la factura del activo',
  `CostosAdicionales` decimal(14,2) NOT NULL COMMENT 'Costos adicionales que pudiera tener el activo',
  `FechaAdquisicion` date NOT NULL COMMENT 'Fecha en la que se adquirio o compro el activo',
  `VidaUtil` int(11) NOT NULL COMMENT 'Vida util del activo en meses',
  `PorcentDepreFis` decimal(5,2) NOT NULL COMMENT 'Porcentaje de depreciacion fiscal',
  `PorcentDepreAjus` decimal(5,2) NOT NULL COMMENT 'Porcentaje de depreciacion ajustada',
  `PlazoMaximo` int(11) NOT NULL COMMENT 'Plazo maximo',
  `PorcentResidMax` decimal(5,2) NOT NULL COMMENT 'Porcentaje residual maximo',
  `EstadoID` int(11) NOT NULL COMMENT 'ID del estado, llave primaria de la tabla: ESTADOSREPUB',
  `MunicipioID` int(11) NOT NULL COMMENT 'ID del municipio, llave primaria de la tabla: MUNICIPIOSREPUB',
  `LocalidadID` int(11) NOT NULL COMMENT 'ID de la localidad, llave primaria de la tabla: LOCALIDADREPUB',
  `ColoniaID` int(11) NOT NULL COMMENT 'ID de la colonia, llave primaria de la tabla: COLONIASREPUB',
  `Calle` varchar(50) NOT NULL COMMENT 'Calle del domicilio',
  `NumeroCasa` char(10) NOT NULL COMMENT 'Numero del domicilio',
  `NumeroInterior` char(10) NOT NULL COMMENT 'Numero interior del domicilio',
  `Piso` char(50) NOT NULL COMMENT 'Piso',
  `PrimerEntrecalle` varchar(50) NOT NULL COMMENT 'Primer crusamiento del domicilio',
  `SegundaEntreCalle` varchar(50) NOT NULL COMMENT 'Segundo crusamiento del domicilio',
  `CP` char(5) NOT NULL COMMENT 'Codigo Postal',
  `DireccionCompleta` varchar(500) NOT NULL COMMENT 'Direccion completa del domicilio',
  `Latitud` varchar(45) NOT NULL COMMENT 'Latitud',
  `Longitud` varchar(45) NOT NULL COMMENT 'Longitud',
  `Lote` varchar(50) NOT NULL COMMENT 'Lote',
  `Manzana` varchar(50) NOT NULL COMMENT 'Manzana',
  `DescripcionDom` varchar(200) NOT NULL COMMENT 'Descripcion del domicilio',
  `AseguradoraID` int(11) DEFAULT NULL COMMENT 'ID de la aseguradora, llave primaria de la tabla: ARRASEGURADORA',
  `EstaAsegurado` char(1) NOT NULL COMMENT 'Indica si el activo esta asgurado o no: S=Si, N=No',
  `NumPolizaSeguro` varchar(20) NOT NULL COMMENT 'Numero de poliza',
  `FechaAdquiSeguro` date NOT NULL COMMENT 'Fecha en la que se adquirio el seguro',
  `InicioCoberSeguro` date NOT NULL COMMENT 'Fecha en la que inica la cobertura del seguro',
  `FinCoberSeguro` date NOT NULL COMMENT 'Fecha en la que finaliza la cobertura del seguro',
  `SumaAseguradora` decimal(14,2) NOT NULL COMMENT 'Monto total de la suma del seguro',
  `ValorDeduciSeguro` decimal(14,2) NOT NULL COMMENT 'Deducible del seguro',
  `Observaciones` varchar(200) NOT NULL COMMENT 'Comentarios u observaciones',
  `Estatus` char(1) NOT NULL DEFAULT 'A' COMMENT 'Estatus de activos:A=Activo, B=Baja, L=Ligado o asociado, I=Inactivo',
  `EmpresaID` int(11) NOT NULL COMMENT 'Empresa ID',
  `Usuario` int(11) NOT NULL COMMENT 'Usuario ID',
  `FechaActual` datetime NOT NULL COMMENT 'Fecha Actual',
  `DireccionIP` varchar(15) NOT NULL COMMENT 'Direccion IP',
  `ProgramaID` varchar(50) NOT NULL COMMENT 'Programa de Auditoria',
  `Sucursal` int(11) NOT NULL COMMENT 'Sucursal ID',
  `NumTransaccion` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  PRIMARY KEY (`ActivoID`),
  KEY `FK_ARRACTIVOS_1` (`SubtipoActivoID`),
  KEY `FK_ARRACTIVOS_2` (`MarcaID`),
  KEY `FK_ARRACTIVOS_3` (`EstadoID`),
  KEY `FK_ARRACTIVOS_4` (`MunicipioID`),
  KEY `FK_ARRACTIVOS_5` (`LocalidadID`),
  KEY `FK_ARRACTIVOS_6` (`ColoniaID`),
  KEY `FK_ARRACTIVOS_7` (`AseguradoraID`),
  CONSTRAINT `FK_ARRACTIVOS_1` FOREIGN KEY (`SubtipoActivoID`) REFERENCES `ARRCSUBTIPOACTIVO` (`SubtipoActivoID`),
  CONSTRAINT `FK_ARRACTIVOS_2` FOREIGN KEY (`MarcaID`) REFERENCES `ARRMARCAACTIVO` (`MarcaID`),
  CONSTRAINT `FK_ARRACTIVOS_3` FOREIGN KEY (`EstadoID`) REFERENCES `ESTADOSREPUB` (`EstadoID`),
  CONSTRAINT `FK_ARRACTIVOS_4` FOREIGN KEY (`MunicipioID`) REFERENCES `MUNICIPIOSREPUB` (`MunicipioID`),
  CONSTRAINT `FK_ARRACTIVOS_5` FOREIGN KEY (`LocalidadID`) REFERENCES `LOCALIDADREPUB` (`LocalidadID`),
  CONSTRAINT `FK_ARRACTIVOS_6` FOREIGN KEY (`ColoniaID`) REFERENCES `COLONIASREPUB` (`ColoniaID`),
  CONSTRAINT `FK_ARRACTIVOS_7` FOREIGN KEY (`AseguradoraID`) REFERENCES `ARRASEGURADORA` (`AseguradoraID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla para registrar los activos que se pueden ligar a un arrendamiento.'$$