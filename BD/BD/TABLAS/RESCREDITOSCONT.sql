-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESCREDITOSCONT
DELIMITER ;
DROP TABLE IF EXISTS `RESCREDITOSCONT`;
DELIMITER $$


CREATE TABLE `RESCREDITOSCONT` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `TranRespaldo` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion de Respaldo',
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito, seguir la misma nomenclatura que para Las cuentas de ahorro\n',
  `LineaCreditoID` char(12) DEFAULT NULL COMMENT 'Linea de Credito\n',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente\n',
  `CuentaID` bigint(12) DEFAULT NULL COMMENT 'numero de cuenta',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `ProductoCreditoID` int(4) DEFAULT NULL COMMENT 'Producto de credito',
  `DestinoCreID` int(11) DEFAULT NULL COMMENT 'Destino de Credito',
  `MontoCredito` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `Relacionado` bigint(12) DEFAULT NULL COMMENT 'Credito Relacionado, Renovado o Reestructurado, puede ser vacio',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Solicitud de Credito. Sera una tabla de solicitudes\nPor el momento Es capturable, es un entero',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
  `LineaFondeo` int(11) DEFAULT NULL COMMENT 'Si escoge una institucion de fondeo, debe escoger sobre \nQue linea De fondeo (LINEAFONDEADOR)\n',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
  `FechaVencimien` date DEFAULT NULL COMMENT 'Fecha de Vencimiento\n',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Tipo de calculo de interes\n1:TasaFija\n2:TasaBase de inicio de cupon+Puntos\n3:Tasa Base de inicio de cupon+Puntos, con Piso y Techo',
  `TasaBase` int(11) DEFAULT NULL COMMENT 'Tasa base',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Tasa fija',
  `SobreTasa` float DEFAULT NULL COMMENT 'Si es formula dos (Tasa base mas puntos), aqui se definen\n Los puntosSi es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija\n',
  `PisoTasa` float DEFAULT NULL COMMENT 'Piso, Si es formula tres\n',
  `TechoTasa` float DEFAULT NULL COMMENT 'Techo, Si es formula tres',
  `FactorMora` float DEFAULT NULL COMMENT 'Factor de Moratorio\n\n',
  `FrecuenciaCap` char(1) DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Capital\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual',
  `PeriodicidadCap` int(11) DEFAULT NULL COMMENT 'Periodicidad de Capital en dias\n',
  `FrecuenciaInt` char(1) DEFAULT NULL COMMENT 'Frecuencia de Interes\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual',
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
  `SaldoComServGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision por Servicio de Garantia Agro',
  `SaldoIVAComSerGar` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision por Servicio de Garantia Agro',
  `SaldoOtrasComis` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Otras Comisiones, en el alta nace con ceros\n',
  `SaldoIVAComisi` decimal(12,2) DEFAULT NULL COMMENT 'Saldo Iva Otras Com, en el alta nace con ceros\n',
  `ProvisionAcum` decimal(14,4) DEFAULT NULL COMMENT 'Provision\nAcumulada ',
  `FechaInhabil` char(1) DEFAULT NULL COMMENT 'En Fecha Inhabil Tomar:\nS.- Siguiente\nA.- Anterior\n',
  `CalendIrregular` char(1) DEFAULT NULL COMMENT 'Calendario Irregular\nS.- Si\nN.-No\n',
  `AjusFecUlVenAmo` char(1) DEFAULT NULL COMMENT 'Ajustar la fecha de vencimiento de la ultima \namortizacion a fecha de vencimiento de credito\nS.- Si\nN.- No',
  `AjusFecExiVen` char(1) DEFAULT NULL COMMENT 'Ajustar Fecha de exigibilidad a fecha de vencimiento\nS.- Si\nN.- No\n',
  `NumTransacSim` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion en el simulador de amortizaciones\n',
  `FechaMinistrado` date DEFAULT NULL COMMENT 'Fecha de ministraci??n\ndel credito',
  `SucursalID` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta el credito',
  `ValorCAT` decimal(12,4) DEFAULT '0.0000' COMMENT 'Valor del CAT (Costo Anual Total)',
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
  `MontoComApert` decimal(12,2) DEFAULT NULL COMMENT 'Monto de comision por apertura',
  `IVAComApertura` decimal(12,2) DEFAULT NULL COMMENT 'IVA de la comision por apertura',
  `PlazoID` varchar(20) DEFAULT NULL COMMENT 'Plazo del credito\\n',
  `TipoDispersion` char(1) DEFAULT NULL COMMENT 'Tipo de Dispersion\\n\nS .- SPEI\\n\nC .- Cheque\\n\nO .- Orden de Pago\\n\nE.- Efectivo',
  `TipoCalInteres` int(11) DEFAULT NULL COMMENT '1 .- Saldos Insolutos\n2 .- Monto Original (Saldos Globales)',
  `MontoDesemb` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Credito que ya ha sido Desembolsado o Ministrado',
  `MontoPorDesemb` decimal(14,2) DEFAULT NULL COMMENT 'Monto del Credito Pendiente de Desembolso o Ministracion',
  `NumAmortInteres` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones (cuotas) de Interes',
  `ComAperPagado` decimal(12,2) DEFAULT NULL COMMENT 'Comision por Apertura Ya pagada por el Cliente',
  `ForCobroComAper` char(1) DEFAULT NULL COMMENT 'A: Anticipado, D: Deduccion, F: Financiamiento',
  `ClasiDestinCred` char(1) DEFAULT NULL COMMENT 'Clasificacion del destino dl credito',
  `CicloGrupo` int(11) DEFAULT NULL COMMENT 'Ciclo del Grupo, en Caso de un Credito Grupal',
  `GrupoID` int(11) DEFAULT NULL COMMENT 'ID del Grupo, en Caso de un Credito Grupal',
  `SaldoMoraVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `SaldoComAnual` decimal(14,2) DEFAULT NULL COMMENT 'Saldo Comision Anual',
  `ComAperCont` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de la Comisi??n por Apertura Contabilizada',
  `IVAComAperCont` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto del IVA de la Comisi??n por Apertura Contabilizada',
  `ComAperReest` decimal(14,2) DEFAULT '0.00' COMMENT 'Nuevo Monto a Contabilizar cuando se hace una Reestructura',
  `IVAComAperReest` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto del IVA de la Comision por Apertura a Contabilizar cuando se hace una Reestructura',
  `FechaAtrasoCapital` date DEFAULT '1900-01-01' COMMENT 'Fecha de Atraso de Capital',
  `FechaAtrasoInteres` date DEFAULT '1900-01-01' COMMENT 'Fecha de Atraso de Interes',
  `ManejaComAdmon` CHAR(1) NOT NULL COMMENT 'Maneja Comisi??n Administraci??n \nS.- SI \nN.- NO',
  `ComAdmonLinPrevLiq` CHAR(1) NOT NULL COMMENT 'Comisi??n de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI',
  `ForCobComAdmon` CHAR(1) NOT NULL COMMENT 'Forma de Cobro Comisi??n Administraci??n \n"".- No aplica \nD.- Disposici??n \nT.- Total en primera Disposici??n',
  `ForPagComAdmon` CHAR(1) NOT NULL COMMENT 'Forma de Pago Comisi??n por Administraci??n \n"".- No aplica \nD.- Deducci??n \nF.- Financiado',
  `PorcentajeComAdmon` DECIMAL(6,2) NOT NULL COMMENT 'permite un valor de 0% a 100%',
  `MontoPagComAdmon` DECIMAL(14,2) NOT NULL COMMENT 'Monto a Pagar por Comisi??n por Administraci??n',
  `MontoCobComAdmon` DECIMAL(14,2) NOT NULL COMMENT 'Monto Cobrado por Comisi??n por Administraci??n',
  `ManejaComGarantia` CHAR(1) NOT NULL COMMENT 'Maneja Comisi??n por Garant??a \nS.- SI \nN.- NO',
  `ComGarLinPrevLiq` CHAR(1) NOT NULL COMMENT 'Comisi??n de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI',
  `ForCobComGarantia` CHAR(1) NOT NULL COMMENT 'Forma de Cobro Comisi??n Garant??a \n"".- No aplica \nC.- Cada Cuota',
  `ForPagComGarantia` CHAR(1) NOT NULL COMMENT 'Forma de pago Comision por Garantia \n"".- No aplica \nD.- Deducci??n \nF.- Financiado',
  `PorcentajeComGarantia` DECIMAL(6,2) NOT NULL COMMENT 'permite un valor de 0% a 100%',
  `MontoPagComGarantia` DECIMAL(14,2) NOT NULL COMMENT 'Monto a Pagar por Comisi??n por Servicio de Garantia',
  `MontoCobComGarantia` DECIMAL(14,2) NOT NULL COMMENT 'Monto Cobrado por Comisi??n por Servicio de Garant??a',
  `MontoPagComGarantiaSim` DECIMAL(14,2) NOT NULL COMMENT 'Monto Simulado por Comisi??n por Servicio de Garant??a',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Usuario` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `FechaActual` datetime DEFAULT NULL COMMENT 'Parametro de auditoria',
  `DireccionIP` varchar(15) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `ProgramaID` varchar(50) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `Sucursal` int(11) DEFAULT NULL COMMENT 'Parametro de auditoria',
  `NumTransaccion` bigint(20) DEFAULT NULL COMMENT 'Parametro de auditoria',
  KEY `CreditoID` (`CreditoID`),
  KEY `TranRespaldo` (`TranRespaldo`),
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Respaldo por Reserva de Pago.Tabla de Creditos Contingentes\n'$$
