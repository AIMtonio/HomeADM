-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDCIEMORAAGRO
DELIMITER ;
DROP TABLE IF EXISTS `TMPCREDCIEMORAAGRO`;DELIMITER $$

CREATE TABLE `TMPCREDCIEMORAAGRO` (
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
  `AmoEstatus` char(1) DEFAULT NULL COMMENT 'Estatus de la Amortizacion\n',
  `AmoSaldoInteresPro` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Provisionado de la Amortizacion',
  `AmoSaldoInteresAtr` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Atrasado de la Amortizacion',
  `AmoSaldoInteresVen` decimal(14,4) DEFAULT NULL COMMENT 'Saldo de Interes Vencido de la Amortizacion',
  `AmoFecGraMora` date DEFAULT NULL COMMENT 'Fecha para Cobro de Moratorios, considerando dias de Gracia',
  `CobraMora` char(1) DEFAULT NULL COMMENT 'Indica si Cobra Interes Moratorio\nS .- Si, N.-No',
  `TipCobComMorato` char(1) DEFAULT NULL COMMENT 'Tipo de Comision del Moratorio\nN .- N Veces la Tasa Ordinaria\nT .- Tasa Fija Anualizada',
  `SolicitudCreditoID` bigint(20) DEFAULT NULL COMMENT 'Numero de la Solicitud de Credito',
  `SubClasifID` int(11) DEFAULT NULL COMMENT 'ID de Sub Clasificacion de Cartera',
  `SucursalCredito` int(11) DEFAULT NULL COMMENT 'Sucursal donde se dio de alta el credito'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Temporal para Calculo de Moratorios en ministraciones de Credito Agro'$$