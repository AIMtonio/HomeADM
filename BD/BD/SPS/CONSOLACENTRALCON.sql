-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLACENTRALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSOLACENTRALCON`;DELIMITER $$

CREATE PROCEDURE `CONSOLACENTRALCON`(
		Par_SucursalID	int,
		Par_FechaDia		date,

		Aud_EmpresaID			int,
		Aud_Usuario			int,
		Aud_FechaActual		DateTime,
		Aud_DireccionIP		varchar(15),
		Aud_ProgramaID		varchar(50),
		Aud_Sucursal			int,
		Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE Var_N char(1);
DECLARE Var_A char(1);
DECLARE Var_P char(1);
DECLARE Var_V char(1);

DECLARE saldoCuentas 		decimal(12,2);
DECLARE saldoInversiones	decimal(12,2);
DECLARE saldoDeseembolso	decimal(12,2);
DECLARE saldoVentanilla	decimal(12,2);
DECLARE saldoPresupuesto decimal(12,2);
DECLARE saldoInteresPagar decimal(12,2);
DECLARE saldoVenciFonde     decimal(12,2);
DECLARE saldoCreVencido     decimal(12,2);
DECLARE saldoGastoPendiente decimal(12,2);
DECLARE saldo15dias         decimal(12,2);
DECLARE saldo30dias         decimal(12,2);
DECLARE saldo60dias         decimal(12,2);

DECLARE credito15dias         decimal(12,2);
DECLARE credito30dias         decimal(12,2);
DECLARE credito60dias         decimal(12,2);

DECLARE inversion15dias         decimal(12,2);
DECLARE inversion30dias         decimal(12,2);
DECLARE inversion60dias         decimal(12,2);

set Var_A := 'A';
set Var_N := 'N';
set Var_P := 'P';
set Var_V := 'V';


select ifnull(sum(Saldo),0)
	into saldoCuentas
	from CUENTASAHOTESO  where Estatus = 'A';


select ifnull(sum(TotalRecibir),0)
	into saldoInversiones
	from INVBANCARIA
    where Estatus = 'A';


select ifnull(sum(Monto),0)
	into saldoDeseembolso
	from DISPERSIONMOV mov, DISPERSION dis
	where dis.FolioOperacion = mov.DispersionID
      and ClaveDispMov not in (select ClaveDispMov from REQGASTOSUCURMOV where ClaveDispMov != 0)
		and mov.Estatus = Var_P;


select ifnull(sum(SaldoEfecMN) ,0)
	into saldoVentanilla
	from CAJASVENTANILLA
	where Estatus = Var_A;


select ifnull(sum(mov.Monto),0)
    into saldoPresupuesto
    from PRESUCURENC enca, PRESUCURDET mov
    where enca.FolioID = mov.EncabezadoID
      and mov.Estatus = Var_A;


select ifnull(sum(req.MontoAutorizado),0)
    into saldoGastoPendiente
    from DISPERSIONMOV dis, REQGASTOSUCURMOV req
    where req.ClaveDispMov = dis.ClaveDispMov
      and dis.Estatus = Var_P;



select ifnull(sum(Capital + Interes + Moratorios + Comisiones + IVA),0)
    into saldoCreVencido
    from POSICIONTESORERIA
    where TipoInstrumento = 'C'
     and PlazoInf = 0
     and PlazoSup = 0;


select ifnull(sum(case when (PlazoInf = 1 and PlazoSup= 15)
                    then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                    else 0.00
                end),0.00)as vencimiento15,
        ifnull(sum(case  when (PlazoInf = 15 and PlazoSup= 30)
                    then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                    else 0.00
            end),0.00)as vencimiento30,
        ifnull(sum(case  when (PlazoInf = 30 and PlazoSup= 60)
                    then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                    else 0.00
            end),0.00)as vencimiento60
into credito15dias, credito30dias, credito60dias
from POSICIONTESORERIA
where TipoInstrumento = 'C';



select ifnull(sum(Capital + Interes + Moratorios + Comisiones + IVA),0)
    into saldoVenciFonde
    from POSICIONTESORERIA
    where TipoInstrumento = 'I'
     and PlazoInf = 0
     and PlazoSup = 0;


select ifnull(sum(case when (PlazoInf = 1 and PlazoSup= 15)
                then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                else 0.00
            end),0.00)as fondeador15,
        ifnull(sum(case  when (PlazoInf = 15 and PlazoSup= 30)
                then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                else 0.00
            end),0.00)as fondeador30,
        ifnull(sum(case  when (PlazoInf = 30 and PlazoSup= 60)
                then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                else 0.00
            end),0.00)as fondeador60
into saldo15dias, saldo30dias, saldo60dias
from POSICIONTESORERIA
where TipoInstrumento = 'I';



select ifnull(sum(Capital + Interes + Moratorios + Comisiones + IVA),0)
    into saldoInteresPagar
    from POSICIONTESORERIA
    where TipoInstrumento = 'P'
     and PlazoInf = 0
     and PlazoSup = 0;


select ifnull(sum(case when (PlazoInf = 1 and PlazoSup= 15)
                then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                else 0.00
            end),0.00)as inversion15,
        ifnull(sum(case  when (PlazoInf = 15 and PlazoSup= 30)
                then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                else 0.00
            end),0.00)as inversion30,
        ifnull(sum(case  when (PlazoInf = 30 and PlazoSup= 60)
                then ifnull((Capital+Interes+Moratorios+Comisiones+IVA),0)
                else 0.00
            end),0.00)as inversion60
into inversion15dias, inversion30dias, inversion60dias
from POSICIONTESORERIA
where TipoInstrumento = 'P';




select  saldoCuentas,       saldoInversiones,   saldoCreVencido,    credito15dias,          credito30dias,
        credito60dias,      saldoVentanilla,    saldoDeseembolso,   saldoGastoPendiente,    saldoVenciFonde,
        saldo15dias,        saldo30dias,        saldo60dias,        saldoPresupuesto,       saldoInteresPagar,
        inversion15dias,    inversion30dias,    inversion60dias;





END TerminaStore$$