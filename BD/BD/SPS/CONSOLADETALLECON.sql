-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLADETALLECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSOLADETALLECON`;DELIMITER $$

CREATE PROCEDURE `CONSOLADETALLECON`(
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
BEGIN

DECLARE Var_Bancos              int;
DECLARE Var_Inversiones         int;
DECLARE Var_CreditosVencidos    int;
DECLARE Var_Caja                int;
DECLARE Var_Dispersion          int;
DECLARE Var_Gastos              int;
DECLARE Var_FondeadorVencimiento int;
DECLARE Var_GastosAutorizados   int;
DECLARE Var_Interes             int;
DECLARE Var_Vence15dias         int;
DECLARE Var_Vence30dias         int;
DECLARE Var_Vence60dias         int;

DECLARE Var_Inversion15dias         int;
DECLARE Var_Inversion30dias         int;
DECLARE Var_Inversion60dias         int;


DECLARE Var_Vacio               char(1);
DECLARE Var_P                   char(1);
DECLARE Var_A                   char(1);
DECLARE Var_PlazoInf            int;
DECLARE Var_PlazoSup            int;
DECLARE Var_TipoIns             char(1);

Set Var_Bancos              := 1;
Set Var_Inversiones         := 2;
Set Var_CreditosVencidos    := 3;
Set Var_Caja                := 4;
Set Var_Dispersion          := 5;
Set Var_Gastos              := 6;
Set Var_FondeadorVencimiento := 7;
Set Var_GastosAutorizados   := 8;
Set Var_Interes             := 9;
Set Var_Vence15dias         := 10;
Set Var_Vence30dias         := 11;
Set Var_Vence60dias         := 12;

Set Var_Inversion15dias     := 13;
Set Var_Inversion30dias     := 14;
Set Var_Inversion60dias     := 15;

Set Var_Vacio               := '';
Set Var_P                   := 'P';
Set Var_A                   := 'A';


if(Par_TipoConsulta = Var_Bancos) then
select SucursalInstit, concat(NombreCorto)as Banco, NumCtaInstit,  ifnull(Saldo,0.00)as saldo
    from CUENTASAHOTESO teso, INSTITUCIONES inst
    where teso.InstitucionID = inst.InstitucionID
      and teso.Estatus = 'A';
end if;


if(Par_TipoConsulta = Var_Inversiones) then
    select inv.TipoInversion, concat(NombreCorto)as Banco, Var_Vacio as NoIntrumento, inv.FechaVencimiento, ifnull(inv.TotalRecibir,0.00) as saldo
    from INVBANCARIA inv, INSTITUCIONES inst
    where inst.InstitucionID = inv.InstitucionID
      and Estatus = 'A';
end if;

-- Detalle de vencimientos de Fondeadores y Pago de Inversiones Plazo
if(Par_TipoConsulta = Var_CreditosVencidos or Par_TipoConsulta = Var_Interes or Par_TipoConsulta = Var_FondeadorVencimiento) then

    if(Par_TipoConsulta = Var_CreditosVencidos)then
        Set Var_TipoIns := 'C';
    end if;
    if(Par_TipoConsulta = Var_Interes)then
        Set Var_TipoIns := 'P';
    end if;
    if(Par_TipoConsulta =Var_FondeadorVencimiento)then
        Set Var_TipoIns := 'I';
    end if;

    select sur.SucursalID, sur.NombreSucurs, pos.Capital, pos.Interes, pos.Moratorios, pos.Comisiones, pos.IVA,
        ifnull(sum(pos.Capital + pos.Interes + pos.Moratorios + pos.Comisiones + pos.IVA),0)as saldo
    from POSICIONTESORERIA pos, SUCURSALES sur
    where pos.TipoInstrumento = Var_TipoIns
      and pos.PlazoInf = 0
      and pos.PlazoSup= 0
      and pos.SucursalID = sur.SucursalID
   group by pos.SucursalID,	sur.SucursalID, sur.NombreSucurs,	pos.Capital,
			pos.Interes, 	pos.Moratorios, pos.Comisiones, 	pos.IVA;
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


-- Detalle de los Vencimientos de creditos
-- y detalle de Pago de Inversiones Plazo
if(Par_TipoConsulta = Var_Vence15dias or Par_TipoConsulta = Var_Vence30dias or Par_TipoConsulta = Var_Vence60dias or
   Par_TipoConsulta = Var_Inversion15dias or Par_TipoConsulta = Var_Inversion30dias or Par_TipoConsulta = Var_Inversion60dias)then

    if(Par_TipoConsulta = Var_Vence15dias or Par_TipoConsulta = Var_Inversion15dias)then
        set Var_PlazoInf := 1;
        set Var_PlazoSup := 15;
    end if;
    if(Par_TipoConsulta = Var_Vence30dias or Par_TipoConsulta = Var_Inversion30dias)then
        set Var_PlazoInf := 15;
        set Var_PlazoSup := 30;
    end if;
    if(Par_TipoConsulta = Var_Vence60dias or Par_TipoConsulta = Var_Inversion60dias)then
        set Var_PlazoInf := 30;
        set Var_PlazoSup := 60;
    end if;

    if(Par_TipoConsulta = Var_Vence15dias or Par_TipoConsulta = Var_Vence30dias or Par_TipoConsulta = Var_Vence60dias)then
         Set Var_TipoIns := 'C';
    end if;

    if(Par_TipoConsulta = Var_Inversion15dias or Par_TipoConsulta = Var_Inversion30dias or Par_TipoConsulta = Var_Inversion60dias)then
        Set Var_TipoIns := 'P';
    end if;


    select sur.SucursalID, sur.NombreSucurs, pos.Capital, pos.Interes, pos.Moratorios, pos.Comisiones, pos.IVA, ifnull(sum(pos.Capital + pos.Interes + pos.Moratorios + pos.Comisiones + pos.IVA),0)as saldo
        from POSICIONTESORERIA pos, SUCURSALES sur
        where pos.TipoInstrumento = Var_TipoIns
        and pos.PlazoInf = Var_PlazoInf
        and pos.PlazoSup = Var_PlazoSup
        and pos.SucursalID = sur.SucursalID
    group by pos.SucursalID,	sur.SucursalID,		sur.NombreSucurs,	pos.Capital,
			 pos.Interes,		pos.Moratorios, 	pos.Comisiones,		pos.IVA;

end if;

END$$