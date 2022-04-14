-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREPASCIEMOR
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREPASCIEMOR`;
DELIMITER $$

CREATE TABLE `TMPCREPASCIEMOR` (
  `RegistroID` bigint UNSIGNED AUTO_INCREMENT,
  `CreditoFondeoID` bigint(20) NOT NULL COMMENT 'Numero de Credito',
  `AmortizacionID` int(11) NOT NULL COMMENT 'Numero de Amortizacion',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio de la Cuota',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha de Vencimiento de la Cuota',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha de Exigible de la Cuota',
  `CalcInteresID` int(11) DEFAULT NULL COMMENT 'Tipo de calculo de interes\n1:TasaFija\n2:TasaBase de inicio de cupon+Puntos\n3:Tasa Base de inicio de cupon+Puntos, con Piso y Techo\n',
  `TasaFija` decimal(12,4) DEFAULT NULL COMMENT 'Valor de la Tasa\n',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'ID de la Moneda o Divisa',
  `TipoInstitID` int(11) DEFAULT NULL COMMENT 'tipo de institucion',
  `NacionalidadIns` char(1) DEFAULT NULL COMMENT 'Especifica la nacionalidad de la institucion',
  `PlazoContable` char(1) DEFAULT NULL COMMENT 'Plazo Contable C. corto plazo L.- Largo plazo ',
  `FactorMora` decimal(10,4) DEFAULT NULL COMMENT 'Factor de Mora',
  `SaldoCapital` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Capital de la Amortizacion',
  `AmoFecGraMora` date DEFAULT NULL COMMENT 'Fecha para Cobro de Moratorios, considerando dias de Gracia',
  `AmoFecGraCom` date DEFAULT NULL COMMENT 'Fecha para Cobro de comision, considerando dias de Gracia',
  `CobraFaltaPago` char(1) DEFAULT NULL COMMENT 'Indica si Cobra Comision por Falta de Pago\nS .- Si, N.-No',
  `MontoComFalPag` decimal(14,4) DEFAULT NULL COMMENT 'Monto de cobro de la comision por falta de pago',
  `CobraMora` char(1) DEFAULT NULL COMMENT 'Indica si Cobra Interes Moratorio\nS .- Si, N.-No',
  `InstitutFondID` int(11) DEFAULT NULL COMMENT 'Institucion de fondeo del credito pasivo ',
  `EstatusAmorti` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\nN .- Vigente o en Proceso\nA .- Atrasada\nP .- Pagada',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Indica el tipo de Fondeador INVERSIONISTA(I)/FONDEADOR(F)',
  `TipCobComMorato` char(1) DEFAULT NULL COMMENT 'Tipo de Comision del Moratorio(N .- N Veces la Tasa Ordinaria, T .- Tasa Fija Anualizada)',
  PRIMARY KEY (RegistroID)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal p/ Calculo de Moratorios, credito pasivo en el  cie'$$
