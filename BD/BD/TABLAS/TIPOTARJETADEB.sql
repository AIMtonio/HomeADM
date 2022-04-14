-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOTARJETADEB
DELIMITER ;
DROP TABLE IF EXISTS `TIPOTARJETADEB`;
DELIMITER $$

CREATE TABLE `TIPOTARJETADEB` (
  `TipoTarjetaDebID` int(11) NOT NULL COMMENT 'ID del Tipo de Tarjeta de Debito',
  `Descripcion` varchar(150) DEFAULT NULL COMMENT 'Descripcion el Tipo de Tarjeta',
  `CompraPOSLinea` char(1) DEFAULT NULL COMMENT 'Indica si el cargo se hara en Linea\nS.- Si \nN.- No',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Tipo de Tarjeta \nA .- Activa\nC .- Cancelada',
  `IdentificacionSocio` char(1) DEFAULT NULL COMMENT 'Indica si el tipo de tarjeta es para identificar el socio/Cliente',
  `TipoProsaID` char(4) DEFAULT NULL,
  `VigenciaMeses` int(11) DEFAULT NULL,
  `ColorTarjeta` char(2) DEFAULT NULL,
  `TipoTarjeta` char(1) DEFAULT NULL COMMENT 'Tipo de Tarjeta:\nD = Debito\nC = Credito',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Monto de la Tasa Anual (Tasa fija)',
  `MontoAnualidad` decimal(12,2) DEFAULT NULL COMMENT 'Monto de anualidad',
  `CobraMora` char(1) DEFAULT NULL COMMENT 'Indica si cobra Moratorios por Falta de Pago \nS .- Si cobra\r\n\nN .- No cobra',
  `TipCobComMorato` char(1) DEFAULT NULL COMMENT 'Tipo de Cobro del Moratorio\nN .- N Veces la Tasa Ordinaria\nT .- Tasa Fija Anualizada\n',
  `FactorMora` decimal(12,4) DEFAULT NULL COMMENT 'Factor Moratorio',
  `CobraFaltaPago` char(1) DEFAULT NULL COMMENT 'Indica si cobra Comision por Falta de Pago \nS .- Si cobra\r\n\nN .- No cobra',
  `TipCobComFalPago` char(1) DEFAULT NULL COMMENT 'Tipo de Cobro por Falta de Pago\nP .- Porcentaje\nM .- Monto Fijo',
  `FactorFaltaPago` decimal(12,4) DEFAULT NULL COMMENT 'Factor Falta Pago',
  `PorcPagoMin` decimal(10,4) DEFAULT NULL COMMENT 'Porcentaje de Pago Minimo',
  `MontoCredito` decimal(12,2) DEFAULT NULL COMMENT 'Monto de Credito',
  `ProductoCredito` int(11) DEFAULT NULL COMMENT 'El id del producto de credito',
  `CobComisionAper` char(1) DEFAULT NULL COMMENT 'Indica si cobra Comision por Apertura\nS .- Si cobra\nN .- No cobra',
  `TipoCobComAper` char(1) DEFAULT NULL COMMENT 'Tipo de Cobro por Apertura\nP .- Porcentaje\nM .- Monto Fijo',
  `FacComisionAper` decimal(12,4) DEFAULT NULL COMMENT 'Factor por Apertura',
  `TarBinParamsID`  INT(11)       NOT NULL DEFAULT '0' COMMENT 'Identificador de la tabla TARBINPARAMS',
  `NumSubBIN`       CHAR(2)       NOT NULL DEFAULT '' COMMENT 'parametro de SubBin',
  `PatrocinadorID`  INT(11)       NOT NULL COMMENT 'Identificador del patrocinador a quien pertenede el SubBin',
  `TipoCore`        INT(11)       NOT NULL DEFAULT '0' COMMENT 'Tipo de Core 1-Core Externo, 2-SAFI Externo, 3-SAFI (Copayment)',
  `UrlCore`         VARCHAR(100)  NOT NULL DEFAULT '' COMMENT 'La cadena de la url del core',
  `TipoMaquilador`  INT(11)       NOT NULL DEFAULT '1' COMMENT 'Tipo de maquilador 1-ISS, 2-TGS',
  `ImagenFonTar` mediumblob COMMENT 'Imagen de fondo de la tarjeta',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`TipoTarjetaDebID`),
  KEY `INDEX_TIPOTARJETADEB_2` (`ProductoCredito`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tipos de Tarjeta de Debito'$$
