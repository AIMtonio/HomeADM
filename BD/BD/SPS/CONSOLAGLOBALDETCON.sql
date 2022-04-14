-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLAGLOBALDETCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSOLAGLOBALDETCON`;DELIMITER $$

CREATE PROCEDURE `CONSOLAGLOBALDETCON`(
		Par_SucursalID	int,
		Par_FechaDia		date,
      Par_TipoConsulta int,

		Aud_EmpresaID			int,
		Aud_Usuario			int,
		Aud_FechaActual		DateTime,
		Aud_DireccionIP		varchar(15),
		Aud_ProgramaID		varchar(50),
		Aud_Sucursal			int,
		Aud_NumTransaccion	bigint	)
TerminaStore: BEGIN

DECLARE Var_Bancos              int;
DECLARE Var_Inversiones         int;
DECLARE Var_CreditosVencidos    int;
DECLARE Var_Caja                int;
DECLARE Var_Dispersion          int;
DECLARE Var_Gastos              int;
DECLARE Var_FondeadorVencimiento int;
DECLARE Var_GastosAutorizados   int;
DECLARE Var_Interes             int;
DECLARE Var_BancoFindasa        int;
DECLARE Var_DispersionMicro      int;

DECLARE Var_Vacio               char(1);
DECLARE Var_P                   char(1);
DECLARE Var_A                   char(1);

Set Var_Bancos              := 1;
Set Var_Inversiones         := 2;
Set Var_CreditosVencidos    := 3;
Set Var_Caja                := 4;
Set Var_Dispersion          := 5;
Set Var_Gastos              := 6;
Set Var_FondeadorVencimiento := 7;
Set Var_GastosAutorizados   := 8;
Set Var_Interes             := 9;
set Var_BancoFindasa        := 10;
set Var_DispersionMicro      := 11;

Set Var_Vacio               := '';
Set Var_P                   := 'P';
Set Var_A                   := 'A';


if(Par_TipoConsulta = Var_Bancos) then
select SucursalInstit, concat(NombreCorto)as Banco, NumCtaInstit,  ifnull(Saldo,0.00)as saldo
    from CUENTASAHOTESO teso, INSTITUCIONES inst
    where teso.InstitucionID = inst.InstitucionID
      and teso.Estatus = 'A';
end if;


if(Par_TipoConsulta = Var_CreditosVencidos) then
    select SUCURSAL, ifnull(HOY,0)as saldo
      from IEVENCIMIENTOSXSUCURSAL;
end if;


if(Par_TipoConsulta = Var_Inversiones) then
    select inv.TipoInversion, concat(NombreCorto)as Banco, Var_Vacio as NoIntrumento, inv.FechaVencimiento, ifnull(inv.TotalRecibir,0.00) as saldo
    from INVBANCARIA inv, INSTITUCIONES inst
    where inst.InstitucionID = inv.InstitucionID
      and FechaVencimiento = Par_FechaDia;
end if;


if(Par_TipoConsulta = Var_Caja) then
    select concat(convert(caj.SucursalID,char(3)),'.- ',suc.NombreSucurs)as sucursal, concat( convert(caj.CajaID,char(2)),'.- ',

        case when(caj.TipoCaja = 'CP')then
                'Caja Principal de Sucursal'
             when (caj.TipoCaja = 'BG') then
                'Boveda Central'
             when (caj.TipoCaja = 'CA') then
                'Caja de Atencion al Publico'
        end )as TipoCaja,

        ifnull(caj.SaldoEfecMN,0.00) as saldo

    from CAJASVENTANILLA caj, SUCURSALES suc
    where caj.SucursalID = suc.SucursalID;
end if;



if(Par_TipoConsulta = Var_Dispersion)then
    select concat(convert(mov.SucursalID,char(3)),'.- ', NombreSucurs)as sucursal, ifnull(sum(Monto),0)as saldo
    from DISPERSIONMOV mov, DISPERSION dis, SUCURSALES sur
     where dis.FolioOperacion = mov.DispersionID
        and sur.SucursalID = mov.SucursalID
        and mov.ClaveDispMov not in (select ClaveDispMov from REQGASTOSUCURMOV where ClaveDispMov != 0)
        and mov.Estatus = Var_P
    group by concat(convert(mov.SucursalID,char(3)),'.- ', NombreSucurs);
end if;



if(Par_TipoConsulta = Var_Gastos)then
    select concat(convert(enc.SucursalID,char(3)),'.- ',sur.NombreSucurs)as sucursal, gas.Descripcion, sum(dis.Monto)as saldo
    from DISPERSIONMOV dis, REQGASTOSUCUR enc, REQGASTOSUCURMOV req, TESOCATTIPGAS gas, SUCURSALES sur
    where enc.NumReqGasID = req.NumReqGasID
      and req.ClaveDispMov = dis.ClaveDispMov
      and gas.TipoGastoID = req.TipoGastoID
      and sur.SucursalID = enc.SucursalID
      and dis.Estatus = Var_P
    group by concat(convert(enc.SucursalID,char(3)),'.- ',sur.NombreSucurs), req.TipoGastoID, gas.Descripcion;
end if;



if(Par_TipoConsulta = Var_GastosAutorizados)then
    select concat(convert(enca.SucursalOrigen,char(3)),'.- ',sur.NombreSucurs)as sucursal, gas.Descripcion, sum(mov.Monto)as saldo
    from PRESUCURENC enca, PRESUCURDET mov, TESOCATTIPGAS gas, SUCURSALES sur
    where enca.FolioID = mov.EncabezadoID
      and gas.TipoGastoID = mov.Concepto
      and mov.Estatus = Var_A
      and sur.SucursalID = enca.SucursalOrigen
    group by concat(convert(enca.SucursalOrigen,char(3)),'.- ',sur.NombreSucurs), gas.Descripcion;
end if;



if(Par_TipoConsulta = Var_BancoFindasa) then
    select Sucursal, InstitucionCompaq, Cuenta, ifnull(MontoTotal,0)as saldo
        from IECUENTASBANCARIAS
        where Sucursal != 'CTA BAJA';
end if;


if(Par_TipoConsulta = Var_FondeadorVencimiento) then
    select Sucursal, Fuente, ifnull(HOY,0)as saldo
    from IEVENCIMIENTOSFONDEADORES;
end if;


if(Par_TipoConsulta = Var_DispersionMicro) then
    select Sucursal, ifnull(MontoTotal,0)as saldo
      from IEDESEMBOLSOSSUCURSALES;
end if;


END TerminaStore$$