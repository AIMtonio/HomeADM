-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOREQGASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOREQGASCON`;DELIMITER $$

CREATE PROCEDURE `TESOREQGASCON`(
	Par_RequisicionID   int,
	Par_NoFactura     	varchar(20),
	Par_ProvedorID    	int,
	Par_TipoConsulta    int,

	Aud_EmpresaID       int,
	Aud_Usuario         int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal		      int,
	Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE	NumTipoGastos	int;
DECLARE	Contador		int;
DECLARE	TipoGasto		int;
DECLARE	Var_FolioID		int(11);
DECLARE	FechaSistem		date;
DECLARE	Var_Folio		int;
DECLARE	Var_Monto		decimal(13,2);
DECLARE	Var_MontoDispon	decimal(13,2);
DECLARE	Var_TotMonto	decimal(13,2);
DECLARE	Var_TotMontoDis	decimal(13,2);
DECLARE	Var_CadFolios	varchar(100);
DECLARE	Var_MontPartFac	decimal(12,4);
DECLARE	Var_MontNoPresu	decimal(12,4);


DECLARE Entero_Cero		int;
DECLARE FechaActual		date;
DECLARE Error				int;
DECLARE ConsultaPrincipal	int;
DECLARE EstatusActivo		char(1);
DECLARE Con_PorFactura		int;
DECLARE Var_Aprobado  		char(1);
DECLARE Con_PresupGasto	int;


Set Entero_Cero		:= 0;
Set FechaActual		:= (SELECT FechaSistema FROM PARAMETROSSIS where EmpresaID=1);
Set Error			:= 0;
Set ConsultaPrincipal	:= 1;
Set EstatusActivo	:='A';
Set	Con_PorFactura	:= 2;
Set Var_Aprobado	:='A';
Set Con_PresupGasto:= 3;
Set	Var_CadFolios	:='';

Set FechaSistem :=(select FechaSistema
						from PARAMETROSSIS);

if(Par_TipoConsulta = ConsultaPrincipal)then

    select  RequisicionID, SucursalID,     UsuarioID,  TipoGastoID,     Descripcion,
            Monto,  TipoPago, NumCtaInstit,   CentroCostoID,  FechaSolicitada, CuentaAhoID,
            case Status when "N"
                then "Alta"
            when "C" then "Cancelado"
            when "A" then "Autorizada"
            when "P" then "Procesada"
            end
	from TESOREQGAS
	where RequisicionID = Par_RequisicionID;

end if;




if(Par_TipoConsulta = Con_PorFactura) then
	Set	NumTipoGastos	:= (select count(TipoGastoID)
								from DETALLEFACTPROV
								where NoFactura = Par_NoFactura
								and ProveedorID = Par_ProvedorID);
	Set Contador := 1;
	while Contador <= NumTipoGastos Do
		set Var_Folio := 0;
		set TipoGasto := (select TipoGastoID
							from DETALLEFACTPROV
							where NoFactura = Par_NoFactura
							and ProveedorID = Par_ProvedorID
							and NoPartidaID= Contador);

		Set Var_FolioID := (	select FolioID
									from PRESUCURENC
										where MesPresupuesto =(month(FechaSistem))
										and AnioPresupuesto=(year(FechaSistem))
										and SucursalOrigen = Aud_Sucursal);

		select FolioID,	Monto,		MontoDispon
				into
				Var_Folio,	Var_Monto,	Var_MontoDispon
			from PRESUCURDET
			where Estatus = Var_Aprobado
			and Concepto = TipoGasto
			and EncabezadoID = Var_FolioID ;


		Set	Var_TotMonto	:= ifnull(Var_TotMonto,Entero_Cero) + ifnull(Var_Monto,Entero_Cero);
		Set	Var_TotMontoDis	:= ifnull(Var_TotMontoDis,Entero_Cero) +ifnull(Var_MontoDispon,Entero_Cero);
		if(Var_Folio != Entero_Cero )then
			Set	Var_CadFolios	:= concat(Var_CadFolios,',',convert(Var_Folio,char(15)),',');
		end if;

		Set Contador := Contador+1;

	end	while;

	select Var_CadFolios,	ifnull(Var_TotMonto,Entero_Cero),	ifnull(Var_TotMontoDis,Entero_Cero);

end if;


if(Par_TipoConsulta = Con_PresupGasto) then
	Set	NumTipoGastos	:= (select count(TipoGastoID)
								from DETALLEFACTPROV
								where NoFactura = Par_NoFactura
								and ProveedorID = Par_ProvedorID);

	Set Contador := 1;

	while Contador <= NumTipoGastos Do
		set Var_Folio 		:= 0;
		set Var_MontPartFac	:= 0.0;
		set Var_Monto 		:= 0.0;
		set Var_MontoDispon := 0.0;

		select TipoGastoID,	Importe
				into
				TipoGasto,		Var_MontPartFac
					from DETALLEFACTPROV
					where NoFactura = Par_NoFactura
					and ProveedorID = Par_ProvedorID
					and NoPartidaID	= Contador;

		Set Var_FolioID := (	select FolioID
									from PRESUCURENC
										where MesPresupuesto =(month(FechaSistem))
										and AnioPresupuesto=(year(FechaSistem))
										and SucursalOrigen = Aud_Sucursal);



		select FolioID,	ifnull(Monto,Entero_Cero),		ifnull(MontoDispon,Entero_Cero)
				into
				Var_Folio,	Var_Monto,	Var_MontoDispon
			from PRESUCURDET
			where Estatus = Var_Aprobado
			and Concepto = TipoGasto
			and EncabezadoID = Var_FolioID;


		if(Var_MontPartFac > Var_MontoDispon) then
			set Var_MontNoPresu := (Var_MontoDispon - Var_MontPartFac)*-1;
			Set	Var_CadFolios	:= concat(TipoGasto,',',convert(Var_MontNoPresu,char(15)),',');
			select concat('Monto Fuera de Presupuesto del Tipo de Gasto: ',convert(TipoGasto,char(15))),
					Var_MontNoPresu;

			 LEAVE TerminaStore;
		end if;
		Set Contador := Contador+1;
	end while;


	select '0',0;

end if;


END TerminaStore$$