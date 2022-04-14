-- TMP_CS_CRCBCREDITOSWS
DELIMITER ;
DROP TABLE IF EXISTS TMP_CS_CRCBCREDITOSWS;

DELIMITER $$
CREATE TABLE `TMP_CS_CRCBCREDITOSWS` (
  `NumRegistro` bigint(20) NOT NULL,
  `CrcbCreditosWSID` bigint(20) DEFAULT '0' COMMENT 'ID del la tabla de carga masiva de creditos',
  `FechaCarga` datetime DEFAULT NULL,
  `FolioCarga` int(11) DEFAULT NULL,
  `ClienteID` int(11) DEFAULT '0' COMMENT 'Numero de Cliente',
  `ProductoCreditoID` int(11) DEFAULT '0' COMMENT 'Numero de Producto de Credito',
  `Monto` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto del Credito',
  `TasaFija` decimal(12,4) DEFAULT '0.0000' COMMENT 'Tasa Fija',
  `Frecuencia` char(1) DEFAULT '' COMMENT 'Frecuencia de Pagos: Semanal, Catorcenal, Quincenal, Mensual ...... Anual',
  `DiaPago` char(1) DEFAULT '' COMMENT 'Dia de Pago: Aniversario, Fin de Mes',
  `DiaMesPago` int(11) DEFAULT '0' COMMENT 'Dia del mes en que se realizaran los Pagos',
  `PlazoID` int(11) DEFAULT '0' COMMENT 'Numero de Plazo',
  `DestinoCreID` int(11) DEFAULT '0' COMMENT 'Destino de Credito',
  `TipoIntegrante` int(11) DEFAULT '0' COMMENT 'Tipo Integrante: 1.- Presidente 2.- Tesorero 3.- Secretario 4.- Integrante',
  `GrupoID` int(11) DEFAULT '0' COMMENT 'Numero de Grupo',
  `TipoDispersion` char(1) DEFAULT '' COMMENT 'Tipo de Dispersion',
  `MontoPorComAper` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de Comision por Apertura de Credito',
  `PromotorID` int(11) DEFAULT '0' COMMENT 'Numero de Promotor',
  `CuentaClabe` char(18) DEFAULT '' COMMENT 'Numero de Cuenta CLABE',
  `FechaIniPrimAmor` date DEFAULT '1900-01-01' COMMENT 'Fecha de Inicio de la Primera Amortizacion',
  `TipoConsultaSIC` char(2) DEFAULT '' COMMENT 'consulta fue Buro de Credito o Circulo de credito',
  `FolioConsultaSIC` varchar(30) DEFAULT '' COMMENT 'campo correspondiente segun el tipo de Consulta SIC ( BC o CC)',
  `ReferenciaPago` varchar(20) DEFAULT '' COMMENT 'Referencia de Pago',
  `IDCreditoSIERRA` char(24) DEFAULT '' COMMENT 'Numero de CREDito SIERRA',
  `CreditoOrigen` bigint(20) DEFAULT '0' COMMENT 'Si es 0, indica que se generara un nuevo credito con el producto que se indique.\nSi es diferente a 0, el dato corresponda a un credito existente en SAFI ese credito se reestructurara unicamente extendiendo el plazo por default 6 meses, esto modificara unicamente la fecha de vencimiento.',
  PRIMARY KEY (`NumRegistro`),
  KEY `CrcbCreditosWSID` (`CrcbCreditosWSID`),
  KEY `ClienteID` (`ClienteID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$