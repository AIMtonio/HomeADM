-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSTEMP
DELIMITER ;
DROP TABLE IF EXISTS `CREDITOSTEMP`;DELIMITER $$

CREATE TABLE `CREDITOSTEMP` (
  `CreditoID` int(11) NOT NULL COMMENT 'Numero de Credito, seguir la misma nomenclatura que para Las cuentas de ahorro\n',
  `LineaCreditoID` char(12) DEFAULT NULL COMMENT 'Linea de Credito\n',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente\n',
  `CuentaID` int(11) DEFAULT NULL COMMENT 'Cuenta',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `ProductoCreditoID` int(4) DEFAULT NULL,
  `DestinoCreID` int(11) DEFAULT NULL,
  `MontoCredito` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `Relacionado` int(11) DEFAULT NULL COMMENT 'Credito Relacionado, Renovado o Reestructurado, puede ser vacio',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Solicitud de Credito. Sera una tabla de solicitudes\nPor el momento Es capturable, es un entero',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
  `LineaFondeo` int(11) DEFAULT NULL COMMENT 'Si escoge una institucion de fondeo, debe escoger sobre \nQue linea De fondeo (LINEAFONDEADOR)\n',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
  `FechaVencimien` date DEFAULT NULL COMMENT 'Fecha de Vencimiento\n',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Tipo de calculo de interes\n1:TasaFija\n2:TasaBase de inicio de cupon+Puntos\n3:Tasa Base de inicio de cupon+Puntos, con Piso y Techo',
  `TasaBase` int(11) DEFAULT NULL,
  `TasaFija` decimal(12,4) DEFAULT NULL,
  `SobreTasa` float DEFAULT NULL COMMENT 'Si es formula dos (Tasa base mas puntos), aqui se definen\n Los puntosSi es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija\n',
  `PisoTasa` float DEFAULT NULL COMMENT 'Piso, Si es formula tres\n',
  `TechoTasa` float DEFAULT NULL COMMENT 'Techo, Si es formula tres',
  `FactorMora` float DEFAULT NULL COMMENT 'Factor de Moratorio\n\n',
  `FrecuenciaCap` char(1) DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Capital\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual\nL.- Libres',
  `PeriodicidadCap` int(11) DEFAULT NULL COMMENT 'Periodicidad de Capital en dias\n',
  `FrecuenciaInt` char(1) DEFAULT NULL COMMENT 'Frecuencia de Interes\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual\nL.-Libres',
  `PeriodicidadInt` int(11) DEFAULT NULL COMMENT 'Periodicidad de Interes en dias',
  `TipoPagoCapital` char(1) DEFAULT NULL COMMENT 'Tipo de Pago de Capital\nC .-Crecientes\nI .- Iguales\nL .-Libres\n',
  `NumAmortizacion` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas (de Capital)\\n',
  `MontoCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Cuota\n',
  `FechTraspasVenc` date DEFAULT NULL COMMENT 'Fecha de Traspaso a Vencido, nace con fecha vacia\n',
  `FechTerminacion` date DEFAULT NULL COMMENT 'Fecha de Pago del Credito, nace con fecha vacia\n',
  `IVAInteres` decimal(12,2) DEFAULT NULL COMMENT 'Tasa de Iva a Cobrar por los Intereses, o Cero si es Exento\n',
  `IVAComisiones` decimal(12,2) DEFAULT NULL COMMENT 'Tasa de Iva a Cobrar por las Comisiones, o Cero si es Exento\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha de \nAutorizacion o \nLiberacion',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Usuairo que autoriza\nel Credito',
  `SaldoCapVigent` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente, en el alta nace con ceros\n',
  `SaldoCapAtrasad` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Atrasado, en el alta nace con ceros\n',
  `SaldoCapVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido, en el alta nace con ceros\n',
  `SaldCapVenNoExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible, en el alta nace con ceros\n',
  `SaldoInterOrdin` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Ordinario, en el alta nace con ceros\n',
  `SaldoInterAtras` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado, en el alta nace con ceros\n',
  `SaldoInterVenc` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Vencido, en el alta nace con ceros\n',
  `SaldoInterProvi` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Provision, en el alta nace con ceros\n',
  `SaldoIntNoConta` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes\nNo Contabilizado',
  `SaldoIVAInteres` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Iva Interes, en el alta nace con ceros\n',
  `SaldoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Moratorios, en el alta nace con ceros\n',
  `SaldoIVAMorator` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Iva Mora, en el alta nace con ceros\n',
  `SaldComFaltPago` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Comision Falta Pago, en el alta nace con ceros\n',
  `SalIVAComFalPag` decimal(12,2) DEFAULT NULL COMMENT 'Saldo IVA Com Falta Pago, en el alta nace con ceros\n',
  `SaldoOtrasComis` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros\n',
  `SaldoIVAComisi` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Iva Otras Com, en el alta nace con ceros\n',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `PagareImpreso` char(1) DEFAULT NULL COMMENT 'Pagaré impreso\nN=No,S=Si',
  `FechaInhabil` char(1) DEFAULT NULL COMMENT 'En Fecha Inhabil Tomar:\nS.- Siguiente\nA.- Anterior\n',
  `CalendIrregular` char(1) DEFAULT NULL COMMENT 'Calendario Irregular\nS.- Si\nN.-No\n',
  `DiaPagoInteres` char(1) DEFAULT NULL COMMENT 'Dia de Pago Interes\nF.-Pago  final del mes \nA.- Por aniversario\nD.- Dia del mes\nI.- Indistinto\n',
  `DiaPagoCapital` char(1) DEFAULT NULL COMMENT 'Dia de Pago Capital\nF.-Pago  final del mes \nA.- Por aniversario\nD.- Dia del mes\nI.- Indistinto\n\n',
  `DiaMesInteres` int(11) DEFAULT NULL COMMENT 'Dia del Mes interes',
  `DiaMesCapital` int(11) DEFAULT NULL COMMENT 'Dia del Mes capital\n',
  `AjusFecUlVenAmo` char(1) DEFAULT NULL COMMENT 'Ajustar la fecha de vencimiento de la ultima \namortizacion a fecha de vencimiento de credito\nS.- Si\nN.- No',
  `AjusFecExiVen` char(1) DEFAULT NULL COMMENT 'Ajustar Fecha de exigibilidad a fecha de vencimiento\nS.- Si\nN.- No\n',
  `NumTransacSim` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion en el simulador de amortizaciones\n',
  `FechaMinistrado` date DEFAULT NULL COMMENT 'Fecha de ministración\ndel credito',
  `FolioDispersion` int(11) DEFAULT NULL,
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta el credito',
  `ValorCAT` decimal(12,4) DEFAULT '0.0000' COMMENT 'Valor del CAT (Costo Anual Total)',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
  `MontoComApert` decimal(12,2) DEFAULT NULL COMMENT 'Monto de comision por apertura',
  `IVAComApertura` decimal(12,2) DEFAULT NULL COMMENT 'IVA de la comision por apertura',
  `PlazoID` varchar(20) DEFAULT NULL COMMENT 'Plazo del credito\\n',
  `TipoDispersion` char(1) DEFAULT NULL COMMENT 'Tipo de Dispersion\\n	S .- SPEI\\n	C .- Cheque\\n	O .- Orden de Pago\\n	E.- Efectivo',
  `CuentaCLABE` char(18) DEFAULT NULL,
  `TipoCalInteres` int(11) DEFAULT NULL COMMENT '1 .- Saldos Insolutos\n2 .- Monto Original (Saldos Globales)',
  `MontoDesemb` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Credito que ya ha sido Desembolsado o Ministrado',
  `MontoPorDesemb` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Credito Pendiente de Desembolso o Ministracion',
  `NumAmortInteres` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones (cuotas) de Interes',
  `AporteCliente` decimal(12,2) DEFAULT NULL COMMENT 'Aporte del Cliente de la \nGarantia Liquida',
  `MontoSeguroVida` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Seguro de Vida',
  `SeguroVidaPagado` decimal(12,2) DEFAULT NULL COMMENT 'Monto que el cliente ya ha pagado del Seguro de Vida',
  `ForCobroSegVida` char(1) DEFAULT NULL COMMENT 'A: Anticipado, D: Deduccion, F: Financiamiento',
  `ComAperPagado` decimal(12,2) DEFAULT NULL COMMENT 'Comision por Apertura Ya pagada por el Cliente',
  `ForCobroComAper` char(1) DEFAULT NULL COMMENT 'A: Anticipado, D: Deduccion, F: Financiamiento',
  `ClasiDestinCred` char(1) DEFAULT NULL,
  `CicloGrupo` int(11) DEFAULT NULL COMMENT 'Ciclo del Grupo, en Caso de un Credito Grupal',
  `GrupoID` int(11) DEFAULT NULL COMMENT 'Numero o ID del Grupo, en caso de ser un Credito Grupal',
  `TipoPrepago` char(1) DEFAULT NULL COMMENT 'Tipo de prepago a aplicar\nU-Pago de capital a ultimas cuotas\nI-A las cuotas siguientes inmediatas\nV-Prorrateo de pago en cuotas vivas',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1$$