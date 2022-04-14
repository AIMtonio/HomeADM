-- BITERRORCREDITOALTBATCHWS
DELIMITER ;
DROP TABLE IF EXISTS BITERRORCREDITOALTBATCHWS;

DELIMITER $$
CREATE TABLE `BITERRORCREDITOALTBATCHWS` (
  `BitacoraID` bigint(20) NOT NULL AUTO_INCREMENT,
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
  `Mensaje` varchar(500) NOT NULL COMMENT 'Mensaje del Error',
  `Codigo` int(11) NOT NULL COMMENT 'Codigo de Error',
  `SP` varchar(30) NOT NULL COMMENT 'Nombre del SP del Error',
  `IDCreditoSIERRA` char(24) DEFAULT '' COMMENT 'Numero de CREDito SIERRA',
  PRIMARY KEY (`BitacoraID`),
  KEY `CrcbCreditosWSID` (`CrcbCreditosWSID`),
  KEY `ClienteID` (`ClienteID`),
  KEY `IDCreditoSIERRA` (`IDCreditoSIERRA`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tb: Tabla para guardar el log de los errores al dar de alta un credito mediante el SP de EMERGENTECRCBCREDITOSWSPRO.'$$