-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPANALITICOCONT
DELIMITER ;
DROP TABLE IF EXISTS `TMPANALITICOCONT`;DELIMITER $$

CREATE TABLE `TMPANALITICOCONT` (
  `TransaccionID` bigint(20) NOT NULL COMMENT 'Numero de Transaccion',
  `Consecutivo` int(11) NOT NULL COMMENT 'Numero Consecutivo',
  `CreditoFondeoID` bigint(20) DEFAULT NULL COMMENT 'Numero o ID de Fondeo, consecutivo',
  `CreditoID` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `CreditoIDCont` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `AcreditadoIDFIRA` bigint(20) DEFAULT NULL COMMENT 'Numero de Acreditado FIRA',
  `CreditoIDFIRA` bigint(20) DEFAULT NULL COMMENT 'Numero de Credito FIRA',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente\n',
  `NombreCompleto` varchar(200) DEFAULT NULL COMMENT 'Este campo no se captura, se forma en base a los nombres y apellidos\n',
  `CreditoIDSinFon` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `CreditoIDPagoFira` bigint(12) DEFAULT NULL COMMENT 'Numero de Credito, sigue la misma nomenclatura que usa las cuentas de ahorro\n',
  `FechaOtorgamiento` date DEFAULT NULL COMMENT 'Fecha de ministración\ndel credito',
  `MontoGarAfec` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `FechaProxVenc` varchar(20) DEFAULT NULL COMMENT 'Fecha del Prox vencimient',
  `MontoProxVenc` decimal(16,2) DEFAULT NULL COMMENT 'Monto del prox vencimiento',
  `FechaUltVenc` date DEFAULT NULL COMMENT 'Fecha del Ultimo Venc',
  `Estatus` varchar(9) CHARACTER SET utf8 DEFAULT '' COMMENT 'Estatus del credito',
  `SalCapVigente` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente',
  `SalCapAtrasado` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Atrasado',
  `SalIntProvision` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Provision',
  `SalIntVencido` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Vencido',
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros\n',
  `SaldoInterVenc` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Vencido, en el alta nace con ceros\n',
  `SalComFaltaPago` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Falta Pago',
  `SalOtrasComisi` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Otras Comisiones',
  `IVAInteresPagado` decimal(14,2) DEFAULT NULL COMMENT 'Se agrega el IVA del interés pagado',
  `IVAInteresVenc` decimal(14,2) DEFAULT NULL COMMENT 'Se agrega el IVA del Interés Vencido',
  `IVAMoraPag` decimal(14,2) DEFAULT NULL COMMENT 'Se agrega el iva de moratorio pagado.',
  `IVAComFaltaPago` decimal(14,2) DEFAULT NULL COMMENT 'IVA com falta de pago',
  `IVAOtrasCom` decimal(14,2) DEFAULT NULL COMMENT 'IVA otras com',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NombreSucurs` varchar(50) DEFAULT NULL COMMENT 'Nombre de la Sucursal',
  `TipoGarantiaFIRAID` int(11) DEFAULT NULL COMMENT 'ID de la Tabla CATTIPOGARANTIAFIRA',
  `GarantiaDes` varchar(45) DEFAULT '' COMMENT 'Descripcion de la Garantia',
  `DestinoCreID` int(11) DEFAULT NULL COMMENT 'ID del Destino de Credito',
  `ClasificacionCred` varchar(100) DEFAULT NULL COMMENT 'Descripcion',
  `RamaFIRAID` int(11) DEFAULT NULL COMMENT 'ID de la Tabla CATRAMAFIRA',
  `RamaFiraDes` varchar(30) DEFAULT NULL COMMENT 'Descripción de Rama FIRA',
  `ActividadFIRAID` int(11) DEFAULT NULL COMMENT 'ID de la Tabla CATACTIVIDADESFIRA',
  `ActividadDes` varchar(45) DEFAULT NULL COMMENT 'Descripción de Actividad FIRA',
  `CadenaProductivaID` int(11) DEFAULT NULL COMMENT 'ID del Catalogo CATCADENAPRODUCTIVA',
  `CadenaProDes` varchar(45) DEFAULT NULL COMMENT 'Nombre de la Cadena',
  `ProgEspecialFIRAID` varchar(10) DEFAULT NULL COMMENT 'ID de la TABLA CATFIRAPROGESP',
  `ProgEspecialDes` varchar(100) DEFAULT NULL COMMENT 'Descripción del Programa FIRA',
  `TipoPersona` varchar(27) CHARACTER SET utf8 DEFAULT '' COMMENT 'Tipo de Persona',
  `ConceptoInversion` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT 'Concepto de Inversion',
  `Unidades` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT 'Unidades de Inv',
  `ConceptoUnidades` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT 'Concepto de Unidades',
  `TipoUnidades` varchar(50) CHARACTER SET utf8 DEFAULT '' COMMENT 'Tipo de Unidades',
  `TasaPasiva` decimal(12,4) DEFAULT NULL COMMENT 'Si es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija',
  `NumSocios` int(1) DEFAULT '0' COMMENT 'Numero de Socios del credito Fondeo',
  PRIMARY KEY (`TransaccionID`,`Consecutivo`),
  KEY `IDX_TMPANALITICOCONT_1` (`TransaccionID`,`ClienteID`),
  KEY `IDX_TMPANALITICOCONT_2` (`TransaccionID`,`TipoGarantiaFIRAID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='TMP: Tabla temporal para el reporte analitico contingente'$$