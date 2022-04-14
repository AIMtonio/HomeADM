-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDCIEMORA
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDCIEMORA`;
DELIMITER $$


CREATE TABLE `TMPCREDCIEMORA` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CreditoID` bigint(20) NOT NULL COMMENT 'Numero de Credito',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Numero de Amortizacion',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Cuota',
  `FechaVencim` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Cuota',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha de Exigible de la Cuota',
  `EmpresaID` int(11) DEFAULT NULL COMMENT 'Numero o ID de la Empresa',
  `SaldoCapVigent` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente del Credito ',
  `SaldoCapVenNExi` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vencido no Exigible de la Amortizacion\n',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Tipo de calculo de interes\n1:TasaFija\n2:TasaBase de inicio de cupon+Puntos\n3:Tasa Base de inicio de cupon+Puntos, con Piso y Techo\n',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa\n',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'ID de la Moneda o Divisa',
  `CreEstatus` char(1) DEFAULT NULL COMMENT 'Estatus del Credito, no se pide en el alta. Nace inactivo\nI .- Inactivo\nA.- Autorizado\nV.- Vigente\nP .- Pagado\nC .- Cancelado\nB.- Vencido\nK.- Castigado',
  `SucursalOrigen` int(11) DEFAULT NULL COMMENT 'Sucursal Origen del Cliente',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'ID del Producto de Credito',
  `TipoProduc` char(1) DEFAULT NULL COMMENT 'Tipo de Clasificacion\nC . Comercial\nO .- Consumo\nH .- Hipotecario',
  `FactorMora` decimal(10,4) DEFAULT NULL COMMENT 'Factor de Mora',
  `SaldoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital de la Amortizacion',
  `CapitalVigente` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital Vigente de la Amortizacion',
  `AmoEstatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\n',
  `AmoSaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Provisionado de la Amortizacion',
  `AmoSaldoInteresAtr` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado de la Amortizacion',
  `AmoSaldoInteresVen` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Vencido de la Amortizacion',
  `AmoFecGraMora` date DEFAULT NULL COMMENT 'Fecha para Cobro de Moratorios, considerando dias de Gracia',
  `AmoFecGraCom` date DEFAULT NULL COMMENT 'Fecha para Cobro de comision, considerando dias de Gracia',
  `AmoFecGraAtr` date DEFAULT NULL COMMENT 'Fecha para Paso a Atrasado',
  `EsReestructura` char(1) DEFAULT NULL COMMENT 'El credito es Reestructura',
  `ReestEstCreacion` char(1) DEFAULT NULL COMMENT 'Esttaus de Creacion de la Reestructura',
  `ReestRegularizado` char(1) DEFAULT NULL COMMENT 'La Reestructura ya fue Regularizada',
  `CriterioComFalPag` char(1) DEFAULT NULL COMMENT 'C .- Monto Original de la Cuota (Capital)\nT .- Monto Original de la Cuota (Capital + Int + IVA)\nS .- Saldo de la Cuota',
  `MontoMinComFalPag` decimal(12,2) DEFAULT NULL COMMENT 'Monto minimo para \ngenerar comision com Falta de Pago\n',
  `AmoTotCuota` decimal(14,2) DEFAULT NULL COMMENT 'Total de la Cuota Original\n',
  `AmoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Monto Original de la Cuota de Capital',
  `AmoSaldoIntNoConta` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes no Contabilizado de la Cuota',
  `CobraFaltaPago` char(1) DEFAULT NULL COMMENT 'Indica si Cobra Comision por Falta de Pago\nS .- Si	 N.-No',
  `CobraMora` char(1) DEFAULT NULL COMMENT 'Indica si Cobra Interes Moratorio\nS .- Si	 N.-No',
  `TipCobComMorato` char(1) DEFAULT NULL COMMENT 'Tipo de Comision del Moratorio\nN .- N Veces la Tasa Ordinaria\nT .- Tasa Fija Anualizada',
  `TipCobComFalPago` char(1) DEFAULT NULL COMMENT 'Tipo de Comision por Falta de Pago\nA .- Por Amortizacion\nC .- Por Credito',
  `PerCobComFalPag` char(1) DEFAULT NULL COMMENT 'Periodicidad en la Comision por Falta de Pago\nD .- Diariamente mientras la cuota esta en atraso\nI .- Por Incumplimiento (1 sola vez en la Fecha de Exigibilidad)',
  `ProrrateoComFalPag` char(1) DEFAULT NULL COMMENT 'Prorrateo en la Comision por Falta de Pago\nS .- SiN .- No',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de la Solicitud de Credito',
  `GrupoID` int(11) DEFAULT NULL COMMENT 'ID del Grupo de Credito',
  `Ciclo` int(11) DEFAULT NULL COMMENT 'Numero de Ciclo del Grupo',
  `SubClasifID` int(11) DEFAULT NULL COMMENT 'ID de Sub Clasificacion de Cartera',
  `SucursalCredito` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta el credito',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para Calculo de Moratorios en el Cierre de Dia de C'$$
