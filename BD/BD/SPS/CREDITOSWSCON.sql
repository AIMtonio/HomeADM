-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSWSCON`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSWSCON`(
	Par_ClienteID			int,
	Par_NumCon			tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN

declare	Cadena_Vacia		char(1);
declare	Fecha_Vacia		date;
declare	Entero_Cero		int;
declare	Decimal_Cero		decimal(12,2);
declare	Con_ActCred		int;
declare 	Est_Pagado		char(1);
declare 	Est_Inactivo		char(1);
declare 	Est_Cancelado		char(1);
declare 	Var_SI			char(1);


declare 	Var_PagaIVA		char(1);
declare 	Var_SucursalO		int;
declare 	Var_IVA			decimal(12,2);
declare	NumErr		 	int(11);
declare	ErrMen			varchar(40);
declare	MoraMayor		decimal(12,2);
declare	MoraMenor30Dias	decimal(12,2);
declare	MoraMayor30Dias	decimal(12,2);
declare	SaldoActual	decimal(12,2);
declare	PesosEnMora	decimal(12,2);
declare	Var_PagosPun		int;
declare	Var_PagosReali	int;
declare	DiasAtraso		int;
declare	Var_FechaActual	date;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Decimal_Cero		:= 0.0;
Set	Con_ActCred		:= 1;
Set 	Est_Pagado		:= 'P';
Set 	Est_Inactivo		:= 'I';
Set 	Est_Cancelado		:= 'C';
Set 	Var_SI			:= 'S';


select ifnull(FechaSistema,Fecha_Vacia) into Var_FechaActual from PARAMETROSSIS;


select  ifnull(SucursalOrigen,Entero_Cero), ifnull(PagaIVA,Cadena_Vacia) into Var_SucursalO, Var_PagaIVA
	from CLIENTES
	where  ClienteID = Par_ClienteID;


select ifnull(IVA,Entero_Cero) into Var_IVA from SUCURSALES where SucursalID = Var_SucursalO;


if (Var_PagaIVA <> Var_SI) then
	set Var_IVA := Entero_Cero;
else
	select ifnull(IVA,Entero_Cero) into Var_IVA from SUCURSALES where SucursalID = Var_SucursalO;
end if;


set MoraMayor := (
	select ifnull(max(datediff(
			(case when A.FechaLiquida != Fecha_Vacia then A.FechaLiquida
								else Var_FechaActual end), A.FechaExigible)),Entero_Cero) as MoraMayor
	from AMORTICREDITO  A,
		CREDITOS C,
		PRODUCTOSCREDITO P
	where A.ClienteID = Par_ClienteID
		and A.ClienteID = C.ClienteID
		and A.CreditoID = C.CreditoID
		and P.ProducCreditoID = C.ProductoCreditoID
		and A.FechaExigible <= Var_FechaActual
		and A.Estatus <> Est_Inactivo
		and A.Estatus <> Est_Cancelado
		and (ifnull(DATEDIFF(CASE A.FechaLiquida when A.FechaLiquida != Fecha_Vacia 	then A.FechaLiquida
						else Var_FechaActual end ,A.FechaExigible),Entero_Cero) >= P.GraciaFaltaPago)
);

select case
	when max(datediff(Var_FechaActual, FechaExigible)) > 30
		and  max(datediff(Var_FechaActual, FechaExigible))  >= P.GraciaFaltaPago then
		sum(	round(A.SaldoCapAtrasa,2) +
			round(A.SaldoCapVencido,2) +
			round(A.SaldoInteresAtr,2) +
			round(A.SaldoInteresVen,2) +
			round(A.SaldoIntNoConta,2) +
			round(round(A.SaldoIntNoConta,2)* Var_IVA,2)+
			round(round(A.SaldoInteresAtr,2)* Var_IVA,2) +
			round(round(A.SaldoInteresVen,2)* Var_IVA,2)+
			round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen,2)+
			round(A.SaldoComFaltaPa,2)+
			round(A.SaldoComServGar,2)+
			round(A.SaldoOtrasComis,2)+
			round(round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen,2) * Var_IVA,2)+
			round(round(A.SaldoComFaltaPa,2) * Var_IVA,2)+
			round(round(A.SaldoComServGar,2) * Var_IVA,2)+
			round(round(A.SaldoOtrasComis,2) * Var_IVA,2))
	else 	Decimal_Cero		end as SaldoMyor30,
	case
	when max(datediff(Var_FechaActual, FechaExigible)) <= 30
		and  max(datediff(Var_FechaActual, FechaExigible))  >= P.GraciaFaltaPago  then
			sum(	round(A.SaldoCapAtrasa,2) +
				round(A.SaldoCapVencido,2) +
				round(A.SaldoInteresAtr,2) +
				round(A.SaldoInteresVen,2) +
				round(A.SaldoIntNoConta,2) +
				round(round(A.SaldoIntNoConta,2)* Var_IVA,2)+
				round(round(A.SaldoInteresAtr,2)* Var_IVA,2) +
				round(round(A.SaldoInteresVen,2)* Var_IVA,2)+
				round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen,2)+
				round(A.SaldoComFaltaPa,2)+
				round(A.SaldoComServGar,2)+
				round(A.SaldoOtrasComis,2)+
				round(round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen ,2) * Var_IVA,2)+
				round(round(A.SaldoComFaltaPa,2) * Var_IVA,2)+
				round(round(A.SaldoComServGar,2) * Var_IVA,2)+
				round(round(A.SaldoOtrasComis,2) * Var_IVA,2))
    else	Decimal_Cero	end as SaldoMnor30,
	sum(	round(A.SaldoCapAtrasa,2) +
		round(A.SaldoCapVencido,2) +
		round(A.SaldoInteresAtr,2) +
		round(A.SaldoInteresVen,2) +
		round(A.SaldoIntNoConta,2) +
		round(round(A.SaldoIntNoConta,2)* Var_IVA,2)+
		round(round(A.SaldoInteresAtr,2)* Var_IVA,2) +
		round(round(A.SaldoInteresVen,2)* Var_IVA,2)+
		round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen, 2)+
		round(A.SaldoComFaltaPa,2)+
		round(A.SaldoComServGar,2)+
		round(A.SaldoOtrasComis,2)+
		round(round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen, 2) * Var_IVA,2)+
		round(round(A.SaldoComFaltaPa,2) * Var_IVA,2)+
		round(round(A.SaldoComServGar,2) * Var_IVA,2)+
		round(round(A.SaldoOtrasComis,2) * Var_IVA,2))
	into MoraMayor30Dias, MoraMenor30Dias , PesosEnMora
from AMORTICREDITO  A,
	CREDITOS C,
	PRODUCTOSCREDITO P
where A.Estatus <> Est_Inactivo
and A.Estatus <> Est_Cancelado
and A.Estatus <> Est_Pagado
and A.ClienteID = Par_ClienteID
and A.FechaExigible <= Var_FechaActual
and A.ClienteID = C.ClienteID
and A.CreditoID = C.CreditoID
and P.ProducCreditoID = C.ProductoCreditoID
and (datediff(Var_FechaActual, FechaExigible))  >= P.GraciaFaltaPago ;

set Var_PagosPun := (select ifnull(count(A.AmortizacionID),Entero_Cero)  as PagosPuntuales
					from AMORTICREDITO A,
						PRODUCTOSCREDITO P,
						CREDITOS C
					where A.ClienteID = Par_ClienteID
					and A.ClienteID = C.ClienteID
					and A.CreditoID = C.CreditoID
					and P.ProducCreditoID = C.ProductoCreditoID
					and (ifnull(DATEDIFF(A.FechaLiquida,A.FechaExigible),Entero_Cero) <= P.GraciaFaltaPago)
					and A.Estatus = Est_Pagado
					group by A.ClienteID);

set SaldoActual :=
	(select
	round(sum(
		round(A.SaldoCapVigente,2)+
		round(A.SaldoCapVenNExi,2)+
		round(A.SaldoInteresOrd,2) +
		round(A.SaldoInteresPro,2) +
		round((round(A.SaldoInteresOrd,2)* Var_IVA),2) +
		round((round(A.SaldoInteresPro,2)* Var_IVA),2) +
		round(A.SaldoCapAtrasa,2) +
		round(A.SaldoCapVencido,2) +
		round(A.SaldoInteresAtr,2) +
		round(A.SaldoInteresVen,2) +
		round(A.SaldoIntNoConta,2) +
		round((round(A.SaldoIntNoConta,2)* Var_IVA),2)+
		round((round(A.SaldoInteresAtr,2)* Var_IVA),2) +
		round((round(A.SaldoInteresVen,2)* Var_IVA),2)+
		round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen,2)+
		round(A.SaldoComFaltaPa,2)+
		round(A.SaldoComServGar,2)+
		round(A.SaldoOtrasComis,2)+
		round((round(A.SaldoMoratorios + A.SaldoMoraVencido + A.SaldoMoraCarVen ,2) * Var_IVA),2)+
		round((round(A.SaldoComFaltaPa,2) * Var_IVA),2)+
		round((round(A.SaldoComServGar,2) * Var_IVA),2)+
		round((round(A.SaldoOtrasComis,2) * Var_IVA),2)
	),2) as saldo
		from AMORTICREDITO A
		where A.ClienteID = Par_ClienteID
		and A.Estatus <> Est_Inactivo
		group by A.ClienteID
);

set Var_PagosReali := (select ifnull(count(A.AmortizacionID),Entero_Cero)  as PagosRealizados
						from AMORTICREDITO A,
							PRODUCTOSCREDITO P,
							CREDITOS C
						where A.ClienteID = Par_ClienteID
						and A.ClienteID = C.ClienteID
						and A.CreditoID = C.CreditoID
						and P.ProducCreditoID = C.ProductoCreditoID
						and A.Estatus = Est_Pagado
						group by A.ClienteID
					);

if(Par_NumCon = Con_ActCred) then

	if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
		set 	NumErr := '001';
		set 	ErrMen := 'El numero de Cliente esta Vacio.';
		select 	Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,
				Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,
				NumErr,		ErrMen;
	else
		set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';
		select 	count(CR.CreditoID) as ActivosTotal,
				FORMAT(sum(CR.MontoCredito),2) as TotalPrestado,
				FORMAT(ifnull(SaldoActual,Entero_Cero),2) as SaldoActual,
				FORMAT(ifnull(PesosEnMora,Entero_Cero),2) as PesosenMora,
				ifnull(MoraMayor,Entero_Cero) as MoraMayor,
				Entero_Cero as Quebrantos,
				ifnull(Var_PagosPun,Entero_Cero) as PagosPuntuales,
				ifnull(Var_PagosReali,Entero_Cero) as PagosRealizados,
				FORMAT(ifnull(MoraMenor30Dias,Decimal_Cero),2) as MoraMenor30Dias,
				FORMAT(ifnull(MoraMayor30Dias,Decimal_Cero),2)  as MoraMayor30Dias,
				NumErr,
				ErrMen
		from 	CREDITOS CR
		where 	CR.ClienteID = Par_ClienteID
		and CR.Estatus <> Est_Pagado
		and CR.Estatus <> Est_Inactivo
		group by CR.ClienteID;
	end if;
end if;

END TerminaStore$$