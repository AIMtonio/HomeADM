-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPREGCREDITOS
DELIMITER ;
DROP TABLE IF EXISTS `TMPREGCREDITOS`;DELIMITER $$

CREATE TABLE `TMPREGCREDITOS` (
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'ID del credito',
  `Monto` decimal(14,2) DEFAULT NULL COMMENT 'Monto del credito',
  `GarantiaLiq` decimal(12,2) DEFAULT NULL COMMENT 'Monto en garantia liquida para el credito',
  `NumCreditos` int(11) DEFAULT NULL COMMENT 'Total de creditos',
  `Clasificacion` char(1) DEFAULT NULL COMMENT 'clasificacion del credito C : Comercial O : Consumo H : Hipotecario',
  `SubClasif` int(11) DEFAULT NULL COMMENT 'Subclasificacion del credito, microcredito, tarjeta de credito, vivienda, etc',
  `SalCapVigente` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del capital vigente',
  `SalCapVencido` decimal(12,2) DEFAULT NULL COMMENT 'Saldo del capital vencido',
  `EstadoID` int(11) DEFAULT NULL COMMENT 'ID del estado de la direccion del cliente',
  `MunicipioID` int(11) DEFAULT NULL COMMENT 'ID del municipio de la direccion del cliente',
  `ColoniaID` int(11) DEFAULT NULL,
  `CodigoPostal` varchar(5) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion que genera el reporte',
  KEY `idxCreID` (`CreditoID`),
  KEY `idxCretmp` (`Clasificacion`),
  KEY `idxClasitmp` (`SubClasif`),
  KEY `idxSubClasitmp` (`EstadoID`),
  KEY `idxEstmp` (`EstadoID`),
  KEY `idxMuniTmp` (`MunicipioID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla temporal para reportes regulatorios, Almacena datos de'$$