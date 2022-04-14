-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOKUBOLIS`;DELIMITER $$

CREATE PROCEDURE `FONDEOKUBOLIS`(
	Par_NumLis		tinyint unsigned,
	Par_FondeoKuboID  BIGINT(20),
	Par_CreditoID     int(11),
	Par_SolicitudID   bigint(20),
	Par_EmpresaID   int(11),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



DECLARE    	Var_CLiente  	 	int;
DECLARE    	Var_Credito   	int;
DECLARE    	Var_Solicitud 	int;
DECLARE		diasFaltaPago		int;
DECLARE  	totalSaldos		decimal(12,2);
DECLARE  	totalrecibido		decimal(12,2);
DECLARE  	totalRetenido		decimal(12,2);


DECLARE		Entero_Cero		int;
DECLARE		Lis_Cliente	  	int;
DECLARE		Lis_Credito  		int;
DECLARE		Lis_Solicitud		int;
DECLARE		Lis_SalyPagos		int;
DECLARE		EstatusVigente	char(1);
DECLARE		EstatusAtras		char(1);
DECLARE		EstatusVencido	char(1);
DECLARE		EstatusPagado		char(1);


Set	Entero_Cero		:= 0;
Set	Lis_Cliente	:= 1;
Set	Lis_Credito	:= 2;
Set Lis_Solicitud	:= 3;
Set Lis_SalyPagos	:= 4;

Set	EstatusVigente	:= 'V';
Set	EstatusAtras		:= 'A';
Set	EstatusPagado		:= 'P';
Set	EstatusVencido	:= 'B';


if(Par_NumLis = Lis_Cliente) then
set Var_CLiente:=(select distinct(ClienteID)
                  from FONDEOKUBO
                  where FondeoKuboID=Par_FondeoKuboID);
select F.ClienteID,     C.NombreCompleto,  F.CreditoID,    F.SolicitudCreditoID, F.Consecutivo,
       F.Folio,         F.CalcInteresID,   F.TasaBaseID,   F.SobreTasa,          F.TasaFija,
       F.PisoTasa,      F.TechoTasa,       F.MontoFondeo,  F.PorcentajeFondeo,   F.MonedaID,
       F.FechaInicio,   F.FechaVencimiento,F.TipoFondeo,   F.NumCuotas,          F.PorcentajeMora,
       PorcentajeComisi,F.Estatus,         F.EmpresaID,    F.Usuario,            F.FechaActual,
       F.DireccionIP,	   F.ProgramaID,	    F.Sucursal,	    F.NumTransaccion
	from FONDEOKUBO F, CLIENTES C
	where F.ClienteID=Var_Cliente	and C.ClienteID=F.ClienteID limit 0, 15;
end if;

if(Par_NumLis = Lis_Credito) then

select   Fon.FondeoKuboID,   Fon.ClienteID,  	   Cli.NombreCompleto,
         Fon.MontoFondeo,    Fon.PorcentajeFondeo
		from FONDEOKUBO Fon,
			 CLIENTES Cli
		where Fon.CreditoID=Par_CreditoID
		and	  Fon.ClienteID = Cli.ClienteID
		limit 0, 15;
end if;

if(Par_NumLis = Lis_Solicitud) then

select   Fon.FondeoKuboID,   Fon.ClienteID,  	   Cli.NombreCompleto,
         Fon.MontoFondeo,    Fon.PorcentajeFondeo
		from FONDEOKUBO Fon,
			 CLIENTES Cli
		where Fon.SolicitudCreditoID=Par_SolicitudID
		and	  Fon.ClienteID = Cli.ClienteID
		limit 0, 15;
end if;



if(Par_NumLis = Lis_SalyPagos) then

Set diasFaltaPago := (datediff( Aud_FechaActual,(select MIN(FechaExigible)
											from AMORTIZAFONDEO
											where FondeoKuboID	= Par_FondeoKuboID
											and FechaExigible		<= Aud_FechaActual
											and Estatus			!= EstatusPagado)));

Set diasFaltaPago := ifnull(diasFaltaPago,Entero_Cero);

set totalSaldos := ifnull((select SaldoCapVigente + SaldoCapExigible + SaldoInteres
						From FONDEOKUBO
						where FondeoKuboID = Par_FondeoKuboID),Entero_Cero);

set totalrecibido := (select (ifnull((MontoFondeo),Entero_Cero)- ifnull((SaldoCapVigente + SaldoCapExigible),0)) +
					ifnull((ProvisionAcum-SaldoInteres),Entero_Cero)+ MoratorioPagado +	ComFalPagPagada
						From FONDEOKUBO
						where FondeoKuboID = Par_FondeoKuboID);

set  totalRetenido := (select IntOrdRetenido + IntMorRetenido + ComFalPagRetenido
							From FONDEOKUBO
							where FondeoKuboID = Par_FondeoKuboID);

		select	diasFaltaPago,				CONCAT(FORMAT(SaldoCapVigente,2)),	CONCAT(FORMAT(SaldoCapExigible,2)),
				CONCAT(FORMAT(SaldoInteres,2)),CONCAT(FORMAT(totalSaldos,2)),
				(ifnull((MontoFondeo),0)- ifnull((SaldoCapVigente + SaldoCapExigible),0)) as CapRecibido	,
				ifnull((ProvisionAcum-SaldoInteres),Entero_Cero) as InteresRecibido,
				MoratorioPagado,		ComFalPagPagada,	CONCAT(FORMAT(totalrecibido,2)),	IntOrdRetenido,	IntMorRetenido,
				ComFalPagRetenido,	CONCAT(FORMAT(totalRetenido,2))

				From FONDEOKUBO
				where FondeoKuboID = Par_FondeoKuboID;

end if;


END TerminaStore$$