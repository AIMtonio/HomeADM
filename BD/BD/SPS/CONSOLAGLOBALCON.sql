-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLAGLOBALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSOLAGLOBALCON`;DELIMITER $$

CREATE PROCEDURE `CONSOLAGLOBALCON`(
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
DECLARE saldoCuentasBanco	decimal(12,2);
DECLARE saldoInversiones	decimal(12,2);
DECLARE saldoDeseembolso	       decimal(12,2);
DECLARE saldoDeseembolsoMicro	decimal(12,2);
DECLARE saldoVentanilla	decimal(12,2);
DECLARE saldoPresupuesto decimal(12,2);
DECLARE saldoInteresPagar decimal(12,2);
DECLARE saldoVenciFonde     decimal(12,2);
DECLARE saldoCreVencido     decimal(12,2);
DECLARE saldoGastoPendiente decimal(12,2);
DECLARE saldo15dias         decimal(12,2);
DECLARE saldo30dias         decimal(12,2);
DECLARE saldo60dias         decimal(12,2);
DECLARE saldoCre15dias         decimal(12,2);
DECLARE saldoCre30dias         decimal(12,2);
DECLARE saldoCre60dias         decimal(12,2);


set Var_A := 'A';
set Var_N := 'N';
set Var_P := 'P';
set Var_V := 'V';



select ifnull(sum(Saldo),0)
	into saldoCuentas
	from CUENTASAHOTESO  where Estatus = 'A';


select ifnull(sum(MontoTotal),0)
    into saldoCuentasBanco
    from IECUENTASBANCARIAS
    where Sucursal != 'CTA BAJA';


select ifnull(sum(TotalRecibir),0)
	into saldoInversiones
	from INVBANCARIA
    where FechaVencimiento = Par_FechaDia;


select ifnull(sum(Monto),0)
	into saldoDeseembolso
	from DISPERSIONMOV mov, DISPERSION dis
	where dis.FolioOperacion = mov.DispersionID
      and ClaveDispMov not in (select ClaveDispMov from REQGASTOSUCURMOV where ClaveDispMov != 0)
		and mov.Estatus = Var_P;


select ifnull(sum(MontoTotal),0)
    into saldoDeseembolsoMicro
    from IEDESEMBOLSOSSUCURSALES;


select ifnull(sum(SaldoEfecMN) ,0)
	into saldoVentanilla
	from CAJASVENTANILLA
	where Estatus = Var_A;


select ifnull(sum(mov.Monto),0)
    into saldoPresupuesto
    from PRESUCURENC enca, PRESUCURDET mov
    where enca.FolioID = mov.EncabezadoID
      and mov.Estatus = Var_A;


select ifnull(sum(HOY),0), ifnull(sum(QUINCE),0), ifnull(sum(TREINTA),0), ifnull(sum(SESENTA),0)
into saldoVenciFonde, saldo15dias, saldo30dias, saldo60dias
from IEVENCIMIENTOSFONDEADORES;


Set saldoInteresPagar := 0;



select ifnull(sum(req.MontoAutorizado),0)
    into saldoGastoPendiente
    from DISPERSIONMOV dis, REQGASTOSUCURMOV req
    where req.ClaveDispMov = dis.ClaveDispMov
      and dis.Estatus = Var_P;


select ifnull(sum(HOY),0), ifnull(sum(QUINCE),0), ifnull(sum(TREINTA),0), ifnull(sum(SESENTA),0)
into saldoCreVencido, saldoCre15dias, saldoCre30dias, saldoCre60dias
from IEVENCIMIENTOSXSUCURSAL;



select  saldoCuentas,           saldoCuentasBanco,  saldoInversiones,   saldoDeseembolso,   saldoDeseembolsoMicro,
         saldoVentanilla,       saldoPresupuesto,   saldoInteresPagar,  saldoVenciFonde,    saldoCreVencido,
         saldoGastoPendiente,   saldo15dias,        saldo30dias,        saldo60dias,        saldoCre15dias,
         saldoCre30dias,        saldoCre60dias;



END TerminaStore$$