-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEAFONDEADOR
DELIMITER ;
DROP TABLE IF EXISTS `LINEAFONDEADOR`;
DELIMITER $$


CREATE TABLE `LINEAFONDEADOR` (
  `LineaFondeoID` int(11) NOT NULL COMMENT 'ID de la linea de Fondeo, Consecutivo de linea por Institucion de Fondeo (InstitutFondID)\n',
  `InstitutFondID` int(11) NOT NULL COMMENT 'ID de Instituciones de Fondeo\n',
  `DescripLinea` varchar(200) DEFAULT NULL COMMENT 'Descripcion de la linea\n',
  `FechInicLinea` date DEFAULT NULL,
  `FechaFinLinea` date DEFAULT NULL,
  `TipoLinFondeaID` int(4) NOT NULL COMMENT 'Tipo de linea',
  `MontoOtorgado` decimal(12,2) DEFAULT NULL COMMENT 'Monto Otorgado\n',
  `SaldoLinea` decimal(12,2) DEFAULT NULL COMMENT 'Saldo de la linea, nace con valor\nIgual al monto otorgado',
  `TasaPasiva` decimal(14,4) DEFAULT NULL COMMENT 'Tasa Pasiva',
  `FactorMora` decimal(12,2) DEFAULT NULL COMMENT 'Factor de Mora',
  `DiasGraciaMora` int(11) DEFAULT NULL COMMENT 'Dias de Gracia Moratorios',
  `PagoAutoVenci` char(1) DEFAULT NULL COMMENT 'Pago Automatico de Vencimientos',
  `FechaMaxVenci` date DEFAULT NULL COMMENT 'Fecha Maxima de Vencimientos',
  `CobraMoratorios` char(1) DEFAULT NULL COMMENT 'Si cobra = "S"\nNo Cobra = "N"',
  `CobraFaltaPago` char(1) DEFAULT NULL COMMENT 'Si Cobra = "S"\nNo Cobra = "N"',
  `DiasGraFaltaPag` int(11) DEFAULT NULL COMMENT 'Dias de Gracia Falta Pago',
  `MontoComFalPag` decimal(12,2) DEFAULT NULL COMMENT 'Monto del cobro de la comision por Falta de pago',
  `EsRevolvente` char(1) DEFAULT NULL COMMENT 'Si es Revolvente = "S"\nNo es Revolvente = "N"',
  `TipoRevolvencia` char(1) DEFAULT NULL COMMENT 'Tipo de Revolvencia, valores: \nEn cada pago de cuota = "P"\nAl liquidar el credito = "L"\nNo Aplica = "N"',
  `InstitucionID` int(11) DEFAULT NULL COMMENT 'hace referencia con el id de la tabla INSTITUCIONES, Se hereda del fondeador pero puede modificarse.',
  `NumCtaInstit` varchar(20) DEFAULT NULL,
  `CuentaClabe` varchar(18) DEFAULT NULL COMMENT 'Cuenta Clabe, hereda del fondeador pero puede modificarse\n',
  `AfectacionConta` char(1) DEFAULT NULL COMMENT 'Si Afectaciones Contables  = "S"\nNo Afectaciones Contables  =  "N"',
  `ReqIntegracion` char(1) DEFAULT NULL COMMENT 'indica si se requiere integracion "S"=SI "N"=NO ',
  `TipoCobroMora` char(1) DEFAULT NULL COMMENT 'Registra N veces Tasa Ordinaria o  T Tasa Fija Anualizada',
  `FolioFondeo` varchar(45) DEFAULT '' COMMENT 'Folio de Fondeo.',
  `Refinancia` char(1) DEFAULT 'N' COMMENT 'Indica si los intereses serán refinanciados\nS: Si\nN: No',
  `CalcInteresID` int(11) DEFAULT '1',
  `TasaBase` int(11) DEFAULT NULL,
  `MonedaID` INT(11) COMMENT 'hace referencia a la tabla MONEDAS',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`LineaFondeoID`),
  KEY `InstituFondID` (`InstitutFondID`),
  CONSTRAINT `InstituFondID` FOREIGN KEY (`InstitutFondID`) REFERENCES `INSTITUTFONDEO` (`InstitutFondID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Lineas de Credito Por Fondeadores\n'$$
