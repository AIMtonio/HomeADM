-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONELECDETCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONELECDETCREPRO`;
DELIMITER $$


CREATE PROCEDURE `CONELECDETCREPRO`(
    Par_AnioMes     int(11),
    Par_SucursalID  int(11),
    Par_FecIniMes   DATE,
    Par_FecFinMes   DATE
	)

TerminaStore: BEGIN


DECLARE Var_FechaCorte        DATE;
DECLARE Var_TipoCapital         INT(11);
DECLARE Var_TipoInteres         INT(11);
DECLARE Var_TipoMoratorio       INT(11);
DECLARE Var_TipoComFaltaPago    INT(11);
DECLARE Var_TipoOtrasComisiones INT(11);
DECLARE Var_TipoIVAs            INT(11);


DECLARE Con_Cadena_Vacia    varchar(1);
DECLARE Con_Fecha_Vacia     Date;
DECLARE Con_Entero_Cero     int(11);
DECLARE Con_Moneda_Cero     Decimal(14,2);
DECLARE Con_StaVigente      char(1);
DECLARE Con_StaVencido      char(1);
DECLARE Con_PolizaCero		int(1);


set Con_Cadena_Vacia  = '';
set Con_Fecha_Vacia = '1900-01-01';
set Con_Entero_Cero = 0;
set Con_Moneda_Cero = 0.00;
set Con_StaVigente     = 'N';
set Con_StaVencido    = 'V';
set Con_PolizaCero		=	0;


SET SQL_SAFE_UPDATES=0;

set Var_TipoCapital = 1;
set Var_TipoInteres = 2;
set Var_TipoMoratorio = 3;
set Var_TipoComFaltaPago = 4;
set Var_TipoOtrasComisiones = 5;
set Var_TipoIVAs = 6;












insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,            Con_Entero_Cero,    Mov.CreditoID,        Amo.FechaVencim ,
        Var_TipoInteres,    'VTO.CREDITO.INTERES',   round(Mov.Cantidad,2),      Con_Moneda_Cero, ifnull(Mov.PolizaID,Con_PolizaCero)
from CREDITOSMOVS Mov
inner join AMORTICREDITO Amo on Amo.CreditoID = Mov.CreditoID and Amo.AmortizacionID = Mov.AmortiCreID and Amo.FechaVencim <= Par_FecFinMes
where Mov.FechaOperacion >= Par_FecIniMes
  and Mov.FechaOperacion <= Par_FecFinMes
  and Amo.FechaVencim <= Par_FecFinMes
  and Mov.TipoMovCreID in (10,13, 14)
  and Mov.NatMovimiento = 'C'
  and (Mov.Descripcion = 'CIERRE DIARO CARTERA');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,            Con_Entero_Cero,    Mov.CreditoID,       Mov.FechaOperacion,
        Var_TipoInteres,    'DEVENGUE.CREDITO.INTERES',   round(Mov.Cantidad,2),      Con_Moneda_Cero,  ifnull(Mov.PolizaID,Con_PolizaCero)
from CREDITOSMOVS Mov
inner join AMORTICREDITO Amo on Amo.CreditoID = Mov.CreditoID and Amo.AmortizacionID = Mov.AmortiCreID and Amo.FechaVencim > Par_FecFinMes
where Mov.FechaOperacion >= Par_FecIniMes
  and Mov.FechaOperacion <= Par_FecFinMes
  and Amo.FechaVencim > Par_FecFinMes
  and Mov.TipoMovCreID in (10,13, 14)
  and Mov.NatMovimiento = 'C'
  and (Mov.Descripcion = 'CIERRE DIARO CARTERA');







insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,            Con_Entero_Cero,    CreditoID,       FechaOperacion,
        Var_TipoInteres,    'INTERES MORATORIO',   round(Cantidad, 2),      Con_Moneda_Cero,  ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in (15, 16, 17)
  and NatMovimiento = 'C'
  and (Descripcion = 'CIERRE DIARO CARTERA'  and Referencia ='GENERACION INTERES MORATORIO');







insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,            Con_Entero_Cero,    CreditoID,       FechaOperacion,
        Var_TipoInteres,    'COM.FAL.PAGO',   round(Cantidad, 2),      Con_Moneda_Cero,  ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in (40)
  and NatMovimiento = 'C'
  and (Descripcion = 'CIERRE DIARO CARTERA');




insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,            Con_Entero_Cero,    CreditoID,       FechaOperacion,
        Var_TipoInteres,    'COM.APERTURA',   round(Cantidad, 2),      Con_Moneda_Cero,  ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in (41)
  and NatMovimiento = 'C'
  and (Descripcion = 'CIERRE DIARO CARTERA');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,            Con_Entero_Cero,    CreditoID,       FechaOperacion,
        Var_TipoInteres,    'COM.GAST.ADMINISTRACION',  round( Cantidad, 2),      Con_Moneda_Cero,  ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in (42)
  and NatMovimiento = 'C'
  and (Descripcion = 'CIERRE DIARO CARTERA');






delete from CONELECDETACRE where Cargos = 0 and Abonos = 0;






insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,     Con_Entero_Cero, Mov.CreditoID,     Mov.FechaOperacion,
        Var_TipoCapital,    concat('PAGO (CAPITAL) CUOTA ',Amo.AmortizacionID,'/',Cre.NumAmortizacion),   Con_Moneda_Cero, round(Mov.Cantidad, 2)
		, ifnull(Mov.PolizaID,Con_PolizaCero)
from CREDITOSMOVS Mov
inner join AMORTICREDITO Amo on Mov.CreditoID = Amo.CreditoID and Mov.AmortiCreID = Amo.AmortizacionID
inner join CREDITOS Cre on Mov.CreditoID=Cre.CreditoID and Amo.CreditoID=Cre.CreditoID
where Mov.FechaOperacion >= Par_FecIniMes
  and Mov.FechaOperacion <= Par_FecFinMes
  and Amo.FechaExigible <= Par_FecFinMes
  and Mov.TipoMovCreID in (1,2,3,4)
  and Mov.NatMovimiento = 'A'
  and (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,     Con_Entero_Cero, Mov.CreditoID,     Mov.FechaOperacion,
        Var_TipoCapital,   concat('PRE-PAGO (CAPITAL) CUOTA ',Amo.AmortizacionID,'/',Cre.NumAmortizacion),  Con_Moneda_Cero, round(Mov.Cantidad, 2)
		,  ifnull(Mov.PolizaID,Con_PolizaCero)
from CREDITOSMOVS Mov
inner join AMORTICREDITO Amo on Mov.CreditoID = Amo.CreditoID and Mov.AmortiCreID = Amo.AmortizacionID
inner join CREDITOS Cre on Mov.CreditoID=Cre.CreditoID and Amo.CreditoID=Cre.CreditoID
where Mov.FechaOperacion >= Par_FecIniMes
  and Mov.FechaOperacion <= Par_FecFinMes
  and Amo.FechaExigible > Par_FecFinMes
  and Mov.TipoMovCreID in (1,2,3,4)
  and Mov.NatMovimiento = 'A'
  and (Mov.Descripcion = 'PAGO DE CREDITO' OR Mov.Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,     Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoCapital,    'CONDONACION (CAPITAL)',   Con_Moneda_Cero, round(Cantidad, 2)
		, ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in (1,2,3,4)
  and NatMovimiento = 'A'
  and Descripcion like '%CONDONACION%';



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,     Con_Entero_Cero, Cmov.CreditoID,     Cmov.FechaOperacion,
        Var_TipoInteres,    concat('PAGO (INTERES) CUOTA ',Cmov.AmortiCreID,'/',Cre.NumAmortizacion),   Con_Moneda_Cero, round(Cmov.Cantidad, 2)
		, ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS Cmov
inner join CREDITOS Cre on Cmov.CreditoID=Cre.CreditoID
where Cmov.FechaOperacion >= Par_FecIniMes
  and Cmov.FechaOperacion <= Par_FecFinMes
  and Cmov.TipoMovCreID in (10,11,12,13,14)
  and Cmov.NatMovimiento = 'A'
  and (Cmov.Descripcion = 'PAGO DE CREDITO' OR Cmov.Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,     Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoInteres,    'CONDONACION (INTERES)',   Con_Moneda_Cero, round(Cantidad, 2)
		, ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in (10,11,12,13,14)
  and NatMovimiento = 'A'
  and Descripcion like '%CONDONACION%';



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,        Con_Entero_Cero, Cmov.CreditoID,     Cmov.FechaOperacion,
        Var_TipoMoratorio,
    concat('PAGO (MORATORIOS) CUOTA ',Cmov.AmortiCreID,'/',Cre.NumAmortizacion),
    Con_Moneda_Cero, round(Cmov.Cantidad, 2), ifnull(Cmov.PolizaID,Con_PolizaCero)
from CREDITOSMOVS Cmov
inner join CREDITOS Cre on Cmov.CreditoID=Cre.CreditoID
where Cmov.FechaOperacion >= Par_FecIniMes
  and Cmov.FechaOperacion <= Par_FecFinMes
  and Cmov.TipoMovCreID in  (15, 16, 17)
  and Cmov.NatMovimiento = 'A'
  and (Cmov.Descripcion = 'PAGO DE CREDITO' OR Cmov.Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoMoratorio,
    'CONDONACION (MORATORIOS)',
    Con_Moneda_Cero,
    round(Cantidad, 2)
	, ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (15, 16, 17)
  and NatMovimiento = 'A'
  and Descripcion like '%CONDONACION%';



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoComFaltaPago,
    'PAGO (COM.FAL.PAGO)',
    Con_Moneda_Cero, round(Cantidad, 2), ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (40)
  and NatMovimiento = 'A'
  and (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoComFaltaPago,
    'CONDONACION (COM.FAL.PAGO)',
    Con_Moneda_Cero, round(Cantidad, 2), ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (40)
  and NatMovimiento = 'A'
  and Descripcion like '%CONDONACION%' ;



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoOtrasComisiones,
    'PAGO (COM.APERTURA)',
    Con_Moneda_Cero, round(Cantidad, 2), ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (41)
  and NatMovimiento = 'A'
  and (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoOtrasComisiones,
    'CONDONACION (COM.APERTURA)',
    Con_Moneda_Cero, round(Cantidad, 2), ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (41)
  and NatMovimiento = 'A'
  and Descripcion like '%CONDONACION%' ;



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoOtrasComisiones,
    'PAGO (COM.GAST.ADMINISTRACION)',
    Con_Moneda_Cero, round(Cantidad, 2),  ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (42)
  and NatMovimiento = 'A'
  and (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION');



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,            Par_SucursalID,        Con_Entero_Cero, CreditoID,     FechaOperacion,
        Var_TipoOtrasComisiones,
    'CONDONACION (COM.GAST.ADMINISTRACION)',
    Con_Moneda_Cero, round(Cantidad, 2),  ifnull(PolizaID,Con_PolizaCero)
from CREDITOSMOVS
where FechaOperacion >= Par_FecIniMes
  and FechaOperacion <= Par_FecFinMes
  and TipoMovCreID in  (42)
  and NatMovimiento = 'A'
  and Descripcion like '%CONDONACION%';



insert into CONELECDETACRE (
				`AnioMes`,					`SucursalID`,					`ClienteID`,					`CreditoID`,					`FechaOperacion`,
				`TipoMovimi`,				`Descripcion`,					`Cargos`,						`Abonos`,						`PolizaID`)
select  Par_AnioMes,        Par_SucursalID,     Con_Entero_Cero, Cmov.CreditoID,     Cmov.FechaOperacion,
        Var_TipoIVAs,    concat('PAGO (IVA) CUOTA ',Cmov.AmortiCreID,'/',Cre.NumAmortizacion),   Con_Moneda_Cero, round(Cmov.Cantidad, 2)
		, ifnull(Cmov.PolizaID,Con_PolizaCero)
from CREDITOSMOVS Cmov
inner join CREDITOS Cre on Cmov.CreditoID=Cre.CreditoID
where Cmov.FechaOperacion >= Par_FecIniMes
  and Cmov.FechaOperacion <= Par_FecFinMes
  and Cmov.TipoMovCreID in  (20,21,22,23,24)
  and Cmov.NatMovimiento = 'A'
  and (Cmov.Descripcion = 'PAGO DE CREDITO' OR Cmov.Descripcion = 'BONIFICACION');




update CONELECDETACRE Edo, CREDITOS Cre
set Edo.ClienteID = Cre.ClienteID
where Edo.CreditoID = Cre.CreditoID;


update CONELECDETACRE Edo, CLIENTES Cli
set Edo.SucursalID = Cli.SucursalOrigen
where Edo.ClienteID = Cli.ClienteID;



END TerminaStore$$
