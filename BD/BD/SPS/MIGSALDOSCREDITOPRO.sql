-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MIGSALDOSCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MIGSALDOSCREDITOPRO`;DELIMITER $$

CREATE PROCEDURE `MIGSALDOSCREDITOPRO`(
    Par_FechaCorte    Date
)
TerminaStore: BEGIN


DECLARE Var_FechaSigCorte DATE;

set Var_FechaSigCorte := (select date_add(Par_FechaCorte, INTERVAL 1 DAY));


drop table if exists MIGRA_SALDOSCREDITOS;

CREATE TABLE `MIGRA_SALDOSCREDITOS` (
  `CreditoID` int(11) NOT NULL COMMENT 'ID del Credito',
  `FechaCorte` date NOT NULL COMMENT 'Fecha de Corte',
  `SalCapVigente` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vigente',
  `SalCapAtrasado` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Atrasado',
  `SalCapVencido` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vencido',
  `SalCapVenNoExi` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Capital Vencido no Exigible',
  `SalIntOrdinario` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Ordinario',
  `SalIntAtrasado` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Atrasado',
  `SalIntVencido` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes Vencido',
  `SalIntProvision` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Provision',
  `SalIntNoConta` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo de Interes no Contabilizado',
  `SalMoratorios` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Moratorios',
  `SaldoMoraVencido` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
  `SaldoMoraCarVen` decimal(14,2) DEFAULT NULL COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
  `SalComFaltaPago` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Falta Pago',
  `SalOtrasComisi` decimal(14,2) DEFAULT '0.00' COMMENT 'Saldo Comision Otras Comisiones',
  `SalIVAInteres` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Interes',
  `SalIVAMoratorios` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Moratorios',
  `SalIVAComFalPago` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Comision Falta Pago',
  `SalIVAComisi` decimal(12,2) DEFAULT '0.00' COMMENT 'Saldo Iva Otras Comisiones',
  `PasoCapAtraDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a Atrasado dia de hoy',
  `PasoCapVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a Vencido dia de hoy',
  `PasoCapVNEDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Capital que paso a VNE dia de hoy',
  `PasoIntAtraDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Interes que paso a Atrasado dia de hoy',
  `PasoIntVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto Interes que paso a Vencido dia de hoy',
  `CapRegularizado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto del Capital Regularizado al dia',
  `IntOrdDevengado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de interes Ordinario Devengado',
  `IntMorDevengado` decimal(14,2) DEFAULT '0.00' COMMENT 'Monto de interes Moratorio Devengado',
  `ComisiDevengado` decimal(12,2) DEFAULT '0.00' COMMENT 'Monto de Comision por Falta de Pago',
  `PagoCapVigDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Vigente del Dia',
  `PagoCapAtrDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Atrasado del Dia',
  `PagoCapVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital Vencido del Dia',
  `PagoCapVenNexDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Capital VNE del Dia',
  `PagoIntOrdDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes Ordinario del Dia',
  `PagoIntVenDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes  Vencido del Dia',
  `PagoIntAtrDia` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes  Atrasado del Dia',
  `PagoIntCalNoCon` decimal(14,2) DEFAULT '0.00' COMMENT 'Pagos de Interes No Contabilizado del Dia',
  `PagoComisiDia` decimal(12,2) DEFAULT '0.00' COMMENT 'Pagos de Interes No Comisiones del Dia',
  `PagoMoratorios` decimal(14,2) DEFAULT NULL COMMENT 'Pagos de\nMoratorio del Dia',
  `PagoIvaDia` decimal(12,2) DEFAULT '0.00' COMMENT 'Pagos de IVAS del Dia',
  `IntCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Interes Codonado\nDel Dia',
  `MorCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Moratorios\nCodonados\nDel Dia',
  `DiasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Dias de Atraso Al Dia',
  `NoCuotasAtraso` int(11) DEFAULT '0' COMMENT 'Numero de Cuotas en Atraso al Dia',
  `MaximoDiasAtraso` int(11) DEFAULT NULL COMMENT 'Numero de Maximo Dias de atraso, historico',
  `LineaCreditoID` int(11) DEFAULT NULL COMMENT 'Id de linea de Credito',
  `ClienteID` int(11) DEFAULT NULL COMMENT 'Id de cliente',
  `MonedaID` int(11) DEFAULT NULL COMMENT 'Id de moneda',
  `FechaInicio` date DEFAULT NULL COMMENT 'Fecha de Inicio',
  `FechaVencimiento` date DEFAULT NULL COMMENT 'Fecha Vencimiento',
  `FechaExigible` date DEFAULT NULL COMMENT 'Fecha Exigibilidad',
  `FechaLiquida` date DEFAULT NULL COMMENT 'Fecha Liquidación',
  `ProductoCreditoID` int(11) DEFAULT NULL COMMENT 'id de producto',
  `EstatusCredito` char(1) DEFAULT NULL COMMENT 'Estatus credito al cierre de mes',
  `SaldoPromedio` decimal(14,2) DEFAULT NULL COMMENT 'Monto Original Credito',
  `MontoCredito` decimal(14,2) DEFAULT NULL,
  `FrecuenciaCap` char(1) DEFAULT NULL,
  `PeriodicidadCap` int(11) DEFAULT NULL COMMENT 'Periodicidad',
  `FrecuenciaInt` char(1) DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Interes\\nS .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo\\nB.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual',
  `PeriodicidadInt` int(11) DEFAULT NULL,
  `NumAmortizacion` int(11) DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas \\n',
  `FechTraspasVenc` date DEFAULT NULL COMMENT 'Fecha de Traspaso a Vencido',
  `FechAutoriza` date DEFAULT NULL,
  `ClasifRegID` int(11) DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
  `DestinoCreID` int(11) DEFAULT NULL,
  `Calificacion` char(2) DEFAULT NULL COMMENT 'Calificacion de Cartera',
  `PorcReserva` decimal(14,2) DEFAULT NULL COMMENT 'Porcentaje de Reserva',
  `TipoFondeo` char(1) DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
  `InstitFondeoID` int(11) DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
  `IntDevCtaOrden` decimal(14,2) DEFAULT NULL COMMENT 'Interes Devengado de Cartera Vencida, \nCuentas de Orden',
  `CapCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Capital Condonado del Dia',
  `ComAdmonPagDia` decimal(14,2) DEFAULT NULL COMMENT 'Comision por Admon, Pagad en el Dia',
  `ComCondonadoDia` decimal(14,2) DEFAULT NULL COMMENT 'Comision Condonado en el Dia',
  `DesembolsosDia` decimal(14,2) DEFAULT NULL COMMENT 'Comision Condonado en el Dia',
  `CapVigenteExi` decimal(14,2) DEFAULT NULL COMMENT 'Capital vigente exigible',
  `MontoTotalExi` decimal(14,2) DEFAULT NULL COMMENT 'Monto total exigible',
  `EmpresaID` int(11) DEFAULT NULL,
  `Usuario` int(11) DEFAULT NULL,
  `FechaActual` datetime DEFAULT NULL,
  `DireccionIP` varchar(15) DEFAULT NULL,
  `ProgramaID` varchar(20) DEFAULT NULL,
  `Sucursal` int(11) DEFAULT NULL,
  `NumTransaccion` int(15) DEFAULT NULL,
  KEY `IDXFechaAplicacion` (`FechaCorte`) USING BTREE,
  KEY `CredFechaAplica` (`CreditoID`,`FechaCorte`),
  KEY `Credito` (`CreditoID`),
  KEY `Idx_SALDOSCREDITOS_1` (`EstatusCredito`),
  KEY `Idx_SALDOSCREDITOS_2` (`FechaCorte`,`EstatusCredito`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Saldos Diarios de Credito';




insert into MIGRA_SALDOSCREDITOS
select CreditoID, Par_FechaCorte,     0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    0,        0,          0,          0,        0,
    LineaCreditoID, ClienteID,      1,          FechaInicio,  FechaVencimien,
    '1900-01-01', '1900-01-01',   ProductoCreditoID,  Estatus,    0,
    MontoCredito, FrecuenciaCap,    PeriodicidadCap,  FrecuenciaInt,  PeriodicidadInt,
    0,        FechTraspasVenc,  FechaAutoriza,    ClasifRegID,  DestinoCreID,
    '',       0,          TipoFondeo,     InstitFondeoID, 0,
    0,        0,          0,          0,        0,
    0,        1,          1,          Par_FechaCorte, '0.0.0.0',
    'MIGRACION',  1,          0
from CREDITOS;

drop temporary table if exists MIGTMP_SALDOSAMORTI;
create temporary table MIGTMP_SALDOSAMORTI as
select CreditoID
,ifnull(sum(SaldoCapVigente ), 0.0) as SaldoCapVigente
,ifnull(sum(SaldoCapAtrasa  ), 0.0) as SaldoCapAtrasa
,ifnull(sum(SaldoCapVencido ), 0.0) as SaldoCapVencido
,ifnull(sum(SaldoCapVenNExi ), 0.0) as SaldoCapVenNExi
,ifnull(sum(SaldoInteresOrd ), 0.0) as SaldoInteresOrd
,ifnull(sum(SaldoInteresAtr ), 0.0) as SaldoInteresAtr
,ifnull(sum(SaldoInteresVen ), 0.0) as SaldoInteresVen
,ifnull(sum(SaldoInteresPro ), 0.0) as SaldoInteresPro
,ifnull(sum(SaldoIntNoConta ), 0.0) as SaldoIntNoConta
,ifnull(sum(SaldoIVAInteres ), 0.0) as SaldoIVAInteres
,ifnull(sum(SaldoMoratorios ), 0.0) as SaldoMoratorios
,ifnull(sum(SaldoIVAMorato  ), 0.0) as SaldoIVAMorato
,ifnull(sum(SaldoComFaltaPa ), 0.0) as SaldoComFaltaPa
,ifnull(sum(SaldoIVAComFalP ), 0.0) as SaldoIVAComFalP
,ifnull(sum(SaldoOtrasComis ), 0.0) as SaldoOtrasComis
,ifnull(sum(SaldoIVAComisi  ), 0.0) as SaldoIVAComisi
,ifnull(sum(SaldoMoraVencido), 0.0) as SaldoMoraVencido
,ifnull(sum(SaldoMoraCarVen ), 0.0) as SaldoMoraCarVen
from AMORTICREDITO
group by CreditoID;

create index MIGTMP_SALDOSAMORTI_Credito on MIGTMP_SALDOSAMORTI(CreditoID);


update MIGRA_SALDOSCREDITOS Sal
  inner join MIGTMP_SALDOSAMORTI Amo on Sal.CreditoID = Amo.CreditoID
Set  Sal.SalCapVigente    = ifnull(Amo.SaldoCapVigente, 0.0)
  ,Sal.SalCapAtrasado   = ifnull(Amo.SaldoCapAtrasa , 0.0)
  ,Sal.SalCapVencido    = ifnull(Amo.SaldoCapVencido, 0.0)
  ,Sal.SalCapVenNoExi   = ifnull(Amo.SaldoCapVenNExi, 0.0)
  ,Sal.SalIntOrdinario  = ifnull(Amo.SaldoInteresOrd, 0.0)
  ,Sal.SalIntAtrasado   = ifnull(Amo.SaldoInteresAtr, 0.0)
  ,Sal.SalIntVencido    = ifnull(Amo.SaldoInteresVen, 0.0)
  ,Sal.SalIntProvision  = ifnull(Amo.SaldoInteresPro, 0.0)
  ,Sal.SalIntNoConta    = ifnull(Amo.SaldoIntNoConta, 0.0)
  ,Sal.SalIVAInteres    = ifnull(Amo.SaldoIVAInteres, 0.0)
  ,Sal.SalMoratorios    = ifnull(Amo.SaldoMoratorios, 0.0)
  ,Sal.SalIVAMoratorios   = ifnull(Amo.SaldoIVAMorato , 0.0)
  ,Sal.SalComFaltaPago  = ifnull(Amo.SaldoComFaltaPa, 0.0)
  ,Sal.SalIVAComFalPago   = ifnull(Amo.SaldoIVAComFalP, 0.0)
  ,Sal.SalOtrasComisi   = ifnull(Amo.SaldoOtrasComis, 0.0)
  ,Sal.SalIVAComisi   = ifnull(Amo.SaldoIVAComisi , 0.0)
  ,Sal.SaldoMoraVencido   = ifnull(Amo.SaldoMoraVencido, 0.0)
  ,Sal.SaldoMoraCarVen  = ifnull(Amo.SaldoMoraCarVen, 0.0);

drop temporary table if exists MIGTMP_SALDOSAMORTI;





drop temporary table if exists  MIGTMP_DIASATRASO;

create temporary table MIGTMP_DIASATRASO
select  CreditoID,
    min(AmortizacionID) as AmortizacionID,
    0000 as DiasAtraso,
    cast('1900-01-01' as date) as FechaExigible,
    cast('1900-01-01' as date) as FechaVencim
from AMORTICREDITO
where Estatus <> 'P'
Group by CreditoID;

update MIGTMP_DIASATRASO Atra
  inner join AMORTICREDITO Amo on Atra.CreditoID = Amo.CreditoID and Atra.AmortizacionID = Amo.AmortizacionID
Set Atra.FechaExigible = Amo.FechaExigible,
  Atra.FechaVencim = Amo.FechaVencim;

update MIGTMP_DIASATRASO
set DiasAtraso = datediff(Var_FechaSigCorte, FechaVencim)
where FechaExigible <= Par_FechaCorte;


update MIGRA_SALDOSCREDITOS Sal
  inner join MIGTMP_DIASATRASO Atraso on Sal.CreditoID = Atraso.CreditoID
Set Sal.DiasAtraso = Atraso.DiasAtraso,
  Sal.MaximoDiasAtraso = Atraso.DiasAtraso;

drop temporary table if exists  MIGTMP_DIASATRASO;






drop temporary table if exists MIGTMP_CUOTASATRASADAS;

create temporary table MIGTMP_CUOTASATRASADAS
select  CreditoID, count(AmortizacionID) as Cant
from AMORTICREDITO
where Estatus in ('A', 'B', 'K')
  and FechaExigible <= Par_FechaCorte
Group by CreditoID;


update MIGRA_SALDOSCREDITOS Sal
  inner join MIGTMP_CUOTASATRASADAS Atr on Sal.CreditoID = Atr.CreditoID
Set Sal.NoCuotasAtraso = Atr.Cant;

drop temporary table if exists MIGTMP_CUOTASATRASADAS;






drop temporary table if exists MIGTMP_CAPITALVIGEXIG;

create temporary table MIGTMP_CAPITALVIGEXIG
select  CreditoID, ifnull(sum(SaldoCapVigente), 0.0) as SaldoCapVigenteExig
from AMORTICREDITO
where Estatus <> 'P'
  and FechaExigible <= Par_FechaCorte
Group by CreditoID;


update MIGRA_SALDOSCREDITOS Sal
  inner join MIGTMP_CAPITALVIGEXIG Cap on Sal.CreditoID = Cap.CreditoID
Set Sal.CapVigenteExi = Cap.SaldoCapVigenteExig;

drop temporary table if exists MIGTMP_CAPITALVIGEXIG;







drop temporary table if exists MIGTMP_NUMEROCUOTAS;

create temporary table MIGTMP_NUMEROCUOTAS
select  CreditoID, count(CreditoID) as CantCuotas
from AMORTICREDITO
Group by CreditoID;

create index MIGTMP_NUMEROCUOTAS_CREDITO on MIGTMP_NUMEROCUOTAS(CreditoID);

update MIGRA_SALDOSCREDITOS Sal
  inner join MIGTMP_NUMEROCUOTAS Amo on Sal.CreditoID = Amo.CreditoID
Set Sal.NumAmortizacion = Amo.CantCuotas;

drop temporary table if exists MIGTMP_NUMEROCUOTAS;





update MIGRA_SALDOSCREDITOS
set MontoTotalExi = ifnull(FUNCIONDEUCRENOIVA(CreditoID), 0.0);







update MIGRA_SALDOSCREDITOS Sal
  inner join CALRESCREDITOS Res on Sal.CreditoID = Res.CreditoID
set Sal.PorcReserva = Res.PorcReserva;







drop temporary table if exists MIGTMP_DIASATRASOCUOTASPAGADAS;

create temporary table MIGTMP_DIASATRASOCUOTASPAGADAS
select CreditoID, AmortizacionID, FechaVencim,
    FechaExigible, FechaLiquida, datediff(FechaLiquida, FechaVencim) as Atraso
from AMORTICREDITO
where Estatus = 'P'
and FechaLiquida > FechaExigible;
create index MIGTMP_DIASATRASOCUOTASPAGADAS_CREDITO on MIGTMP_DIASATRASOCUOTASPAGADAS(CreditoID);

drop temporary table if exists MIGTMP_MAXIMODIASATRASO;
create temporary table MIGTMP_MAXIMODIASATRASO
select CreditoID, max(Atraso) as DiasAtraso
from MIGTMP_DIASATRASOCUOTASPAGADAS
where  Atraso > 0
GROUP BY CreditoID;
Create index MIGTMP_MAXIMODIASATRASO_CREDITO on MIGTMP_MAXIMODIASATRASO(CreditoID);


update MIGRA_SALDOSCREDITOS Sal
  inner join MIGTMP_MAXIMODIASATRASO MaxAtr on Sal.CreditoID = MaxAtr.CreditoID
set Sal.MaximoDiasAtraso = Case when Sal.DiasAtraso < MaxAtr.DiasAtraso then MaxAtr.DiasAtraso else Sal.DiasAtraso end
;


drop temporary table if exists MIGTMP_MAXIMODIASATRASO;
drop temporary table if exists MIGTMP_DIASATRASOCUOTASPAGADAS;







truncate SALDOSCREDITOS;

insert Into SALDOSCREDITOS
select  CreditoID,      FechaCorte,     SalCapVigente,    SalCapAtrasado,     SalCapVencido,
    SalCapVenNoExi,   SalIntOrdinario,  SalIntAtrasado,   SalIntVencido,      SalIntProvision,
    SalIntNoConta,    SalMoratorios,    SaldoMoraVencido, SaldoMoraCarVen,    SalComFaltaPago,
    SalOtrasComisi,   SalIVAInteres,    SalIVAMoratorios, SalIVAComFalPago,   SalIVAComisi,
    PasoCapAtraDia,   PasoCapVenDia,    PasoCapVNEDia,    PasoIntAtraDia,     PasoIntVenDia,
    CapRegularizado,  IntOrdDevengado,  IntMorDevengado,  ComisiDevengado,    PagoCapVigDia,
    PagoCapAtrDia,    PagoCapVenDia,    PagoCapVenNexDia, PagoIntOrdDia,      PagoIntVenDia,
    PagoIntAtrDia,    PagoIntCalNoCon,  PagoComisiDia,    PagoMoratorios,     PagoIvaDia,
    IntCondonadoDia,  MorCondonadoDia,  DiasAtraso,     NoCuotasAtraso,     MaximoDiasAtraso,
    LineaCreditoID,   ClienteID,      MonedaID,     FechaInicio,      FechaVencimiento,
    FechaExigible,    FechaLiquida,   ProductoCreditoID,  EstatusCredito,     SaldoPromedio,
    MontoCredito,   FrecuenciaCap,    PeriodicidadCap,  FrecuenciaInt,      PeriodicidadInt,
    NumAmortizacion,  FechTraspasVenc,  FechAutoriza,   ClasifRegID,      DestinoCreID,
    Calificacion,   PorcReserva,    TipoFondeo,     InstitFondeoID,     IntDevCtaOrden,
    CapCondonadoDia,  ComAdmonPagDia,   ComCondonadoDia,  DesembolsosDia,     CapVigenteExi,
    MontoTotalExi,    EmpresaID,      Usuario,      FechaActual,      DireccionIP,
    ProgramaID,     Sucursal,     NumTransaccion
from MIGRA_SALDOSCREDITOS;


select 'Proceso de Carga de Saldos a tabla SALDOSCREDITOS ha terminado.  ';

drop table if exists MIGRA_SALDOSCREDITOS;

END TerminaStore$$