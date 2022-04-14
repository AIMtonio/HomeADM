-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACREDITO
DELIMITER ;
DROP TABLE IF EXISTS `BITACORACREDITO`;DELIMITER $$

CREATE TABLE `BITACORACREDITO` (
  `CreditoID` bigint(12) NOT NULL COMMENT 'Numero de Credito, seguir la misma nomenclatura que para Las cuentas de ahorro\n',
  `LineaCreditoID` int(11) DEFAULT NULL COMMENT 'Linea de Credito\n',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Cliente\n',
  `CuentaID` bigint(12) DEFAULT NULL,
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Moneda',
  `ProductoCreditoID` int(4) DEFAULT NULL,
  `DestinoCreID` int(4) DEFAULT NULL,
  `MontoCredito` decimal(12,2) DEFAULT NULL COMMENT 'Monto del Credito',
  `Relacionado` int(11) DEFAULT NULL COMMENT 'Credito Relacionado, Renovado o Reestructurado, puede ser vacio',
  `SolicitudCreditoID` int(11) DEFAULT NULL COMMENT 'Solicitud de Credito. Sera una tabla de solicitudes\nPor el momento Es capturable, es un entero',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
  `LineaFondeo` int(11) DEFAULT NULL COMMENT 'Si escoge una institucion de fondeo, debe escoger sobre \nQue linea De fondeo (LINEAFONDEADOR)\n',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio del Credito',
  `FechaVencimien` date DEFAULT NULL COMMENT 'Fecha de Vencimiento\n',
  `CalcInteresID` int(11) DEFAULT NULL,
  `TasaBase` int(11) DEFAULT NULL,
  `TasaFija` float DEFAULT NULL,
  `SobreTasa` float DEFAULT NULL COMMENT 'Si es formula dos (Tasa base mas puntos), aqui se definen\n Los puntosSi es formula uno (Tasa Fija), aqui se especifica el valor de dicha\ntasa fija\n',
  `PisoTasa` float DEFAULT NULL COMMENT 'Piso, Si es formula tres\n',
  `TechoTasa` float DEFAULT NULL COMMENT 'Techo, Si es formula tres',
  `FactorMora` float DEFAULT NULL COMMENT 'Factor de Moratorio\n\n',
  `FrecuenciaCap` char(1) DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Capital\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual',
  `PeriodicidadCap` int(11) DEFAULT NULL COMMENT 'Periodicidad de Capital en dias\n',
  `FrecuenciaInt` char(1) DEFAULT NULL COMMENT 'Frecuencia de Interes\nS .- Semanal,\nC .- Catorcenal\nQ .- Quincenal\nM .- Mensual\nP .- Periodo\nB.-Bimestral \nT.-Trimestral \nR.-TetraMestral\nE.-Semestral \nA.-Anual',
  `PeriodicidadInt` int(11) DEFAULT NULL COMMENT 'Periodicidad de Interes en dias',
  `TipoPagoCapital` varchar(10) DEFAULT NULL COMMENT 'Tipo de Pago de Capital\nC .-Crecientes\nI .- Iguales\nL .-Libres\n',
  `NumAmortizacion` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas\n',
  `MontoCuota` decimal(12,2) DEFAULT NULL COMMENT 'Monto de la Cuota\n',
  `FechTraspasVenc` date DEFAULT NULL COMMENT 'Fecha de Traspaso a Vencido, nace con fecha vacia\n',
  `FechTerminacion` date DEFAULT NULL COMMENT 'Fecha de Pago del Credito, nace con fecha vacia\n',
  `IVAInteres` decimal(12,2) DEFAULT NULL COMMENT 'Tasa de Iva a Cobrar por los Intereses, o Cero si es Exento\n',
  `IVAComisiones` decimal(12,2) DEFAULT NULL COMMENT 'Tasa de Iva a Cobrar por las Comisiones, o Cero si es Exento\n',
  `Estatus` char(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado',
  `FechaAutoriza` date DEFAULT NULL COMMENT 'Fecha de \nAutorizacion o \nLiberacion',
  `UsuarioAutoriza` int(11) DEFAULT NULL COMMENT 'Usuairo que autoriza\nel Credito',
  `PagareImpreso` char(1) DEFAULT NULL COMMENT 'Pagaré impreso\nN=No,S=Si',
  `FechaInhabil` char(1) DEFAULT NULL COMMENT 'En Fecha Inhabil Tomar:\nS.- Siguiente\nA.- Anterior\n',
  `CalendIrregular` char(1) DEFAULT NULL COMMENT 'Calendario Irregular\nS.- Si\nN.-No\n',
  `DiaPagoInteres` char(1) DEFAULT NULL COMMENT 'Dia de Pago Interes\nF.-Pago  final del mes \nA.- Por aniversario\n',
  `DiaPagoCapital` char(1) DEFAULT NULL COMMENT 'Dia de Pago Capital\nF.-Pago  final del mes \nA.- Por aniversario\n',
  `DiaMesInteres` int(11) DEFAULT NULL COMMENT 'Dia del Mes interes',
  `DiaMesCapital` int(11) DEFAULT NULL COMMENT 'Dia del Mes capital\n',
  `AjusFecUlVenAmo` char(1) DEFAULT NULL COMMENT 'Ajustar la fecha de vencimiento de la ultima \namortizacion a fecha de vencimiento de credito\nS.- Si\nN.- No',
  `AjusFecExiVen` char(1) DEFAULT NULL COMMENT 'Ajustar Fecha de exigibilidad a fecha de vencimiento\nS.- Si\nN.- No\n',
  `NumTransacSim` bigint(20) DEFAULT NULL COMMENT 'Numero de transaccion en el simulador de amortizaciones\n',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(50) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` bigint(20) DEFAULT NULL,
  `NumError` int(11) DEFAULT NULL,
  `ErrorMen` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Bitacora de creditos'$$