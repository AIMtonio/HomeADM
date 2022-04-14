-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLCREPROSPECTO
DELIMITER ;
DROP TABLE IF EXISTS `SOLCREPROSPECTO`;DELIMITER $$

CREATE TABLE `SOLCREPROSPECTO` (
  `SolCredProsID` bigint(20) NOT NULL COMMENT 'Número de Solicitud',
  `ProspectoID` bigint(20) DEFAULT NULL COMMENT 'ID o Número de Prospecto',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'ID o Número de Cliente',
  `FechaRegistro` date NOT NULL COMMENT 'Fecha de Registro de la Solicitud',
  `FechaAutoriza` date NOT NULL COMMENT 'Fecha de Formalización',
  `MontoSolici` decimal(12,4) DEFAULT NULL COMMENT 'Monto Solicitado',
  `MontoAutorizado` decimal(12,4) DEFAULT NULL COMMENT 'Monto Autorizado',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'ID del Producto o Tipo de Credito',
  `PlazoID` varchar(20) NOT NULL COMMENT 'Plazo en meses para el Vencimiento de Crédito.\\n',
  `Estatus` char(1) NOT NULL COMMENT 'Estatus de la Solicitud\\\\n	I .- Inactiva\\\\n	A .- Autorizada\\\\n	C .- Cancelada\\nR.- Rechazada\\nD.- Desembolsada',
  `TipoDispersion` char(1) NOT NULL COMMENT '	S .- SPEI\n	C .- Cheque\n	O .- Orden de Pago',
  `CuentaCLABE` char(18) DEFAULT NULL COMMENT 'Cuenta CLABE para realizar SPEIS',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta la solicitud del credito',
  `ForCobroComAper` char(1) DEFAULT NULL COMMENT 'Forma de cobro de la comision por apertura',
  `MontoPorComAper` decimal(12,4) DEFAULT NULL COMMENT 'Monto de la comision por apertura',
  `IVAComAper` decimal(12,4) DEFAULT NULL COMMENT 'IVA de comision por apertura',
  `DestinoCreID` int(11) DEFAULT NULL COMMENT 'Destino de credito',
  `PromotorID` int(11) DEFAULT NULL COMMENT 'Promotor',
  `CalcInteresID` int(11) DEFAULT NULL,
  `TasaFija` decimal(8,4) DEFAULT NULL,
  `TasaBase` decimal(8,4) DEFAULT NULL,
  `SobreTasa` decimal(8,4) DEFAULT NULL,
  `PisoTasa` decimal(8,4) DEFAULT NULL,
  `TechoTasa` decimal(8,4) DEFAULT NULL,
  `FactorMora` decimal(8,4) DEFAULT NULL,
  `FrecuenciaCap` char(1) DEFAULT NULL,
  `PeriodicidadCap` int(11) DEFAULT NULL,
  `FrecuenciaInt` char(1) DEFAULT NULL,
  `PeriodicidadInt` int(11) DEFAULT NULL,
  `TipoPagoCapital` char(1) DEFAULT NULL,
  `NumAmortizacion` int(11) DEFAULT NULL COMMENT 'numero de amortizaciones',
  `CalendIrregular` char(1) DEFAULT NULL,
  `DiaPagoInteres` char(1) DEFAULT NULL,
  `DiaPagoCapital` char(1) DEFAULT NULL,
  `DiaMesInteres` int(11) DEFAULT NULL,
  `DiaMesCapital` int(11) DEFAULT NULL,
  `AjusFecUlVenAmo` char(1) DEFAULT NULL,
  `AjusFecExiVen` char(1) DEFAULT NULL,
  `NumTransacSim` bigint(20) DEFAULT NULL,
  `ValorCAT` decimal(12,4) DEFAULT NULL,
  `FechaInhabil` char(1) CHARACTER SET big5 COLLATE big5_bin DEFAULT NULL,
  `AporteCliente` decimal(12,4) DEFAULT NULL COMMENT 'Aporte del Cliente (Deposito)',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Usuario que Autoriza\\n',
  `FechaRechazo` datetime DEFAULT NULL COMMENT 'Fecha de Rechazo\\n',
  `UsuarioRechazo` int(11) DEFAULT NULL COMMENT 'Usuario que Rechaza\\n',
  `ComentarioRech` varchar(500) DEFAULT NULL COMMENT 'Comentario de Rechazo\\n',
  `MotivoRechazo` int(11) DEFAULT NULL COMMENT 'Motivo Rechazo\\n',
  `TipoCredito` char(1) DEFAULT NULL COMMENT 'N.- Nuevo\\nR.- Renovado',
  `NumCreditos` int(11) DEFAULT NULL COMMENT 'Numero de Creditos en caso de ser tipo de credito Renovado',
  `Relacionado` bigint(12) DEFAULT NULL COMMENT 'Credito Relalcionado\\n',
  `Proyecto` varchar(500) DEFAULT NULL COMMENT 'Descripcion del proyecto ',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` date DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`SolCredProsID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Tabla de Solicitud de Credito por Prospecto'$$