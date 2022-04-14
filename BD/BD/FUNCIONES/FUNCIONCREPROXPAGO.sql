-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCREPROXPAGO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCREPROXPAGO`;
DELIMITER $$


CREATE FUNCTION `FUNCIONCREPROXPAGO`(

    Par_CreditoID   bigint,
	Par_ProyectaMora	char(1)

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN


DECLARE Var_FecActual   	date;
DECLARE Var_TotAtrasado 	decimal(14,2);
DECLARE Var_MontoExigible	decimal(14,2);
DECLARE Var_AmortizacionID	int;
DECLARE OutMontoPag 		decimal(14,2);

DECLARE Var_SucCredito  	int;
DECLARE Var_CliPagIVA   	char(1);
DECLARE Var_IVAIntOrd   	char(1);
DECLARE Var_IVAIntMor   	char(1);
DECLARE Var_ValIVAIntOr 	decimal(12,2);
DECLARE Var_ValIVAIntMo 	decimal(12,2);
DECLARE Var_ValIVAGen   	decimal(12,2);
DECLARE Var_IVASucurs   	decimal(12,2);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	EstatusPagado		char(1);
DECLARE	Con_ProFecPag		int;
DECLARE	SiPagaIVA		char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_ProFecPag		:= 9;
Set	SiPagaIVA		:= 'S';
Set	EstatusPagado		:= 'P';
set OutMontoPag		:= 0;


select Cli.PagaIVA, Cre.SucursalID, Pro.CobraIVAInteres, Pro.CobraIVAMora into
            Var_CliPagIVA, Var_SucCredito, Var_IVAIntOrd, Var_IVAIntMor
        from CREDITOS Cre,
             PRODUCTOSCREDITO Pro,
             CLIENTES Cli
        where Cre.CreditoID     = Par_CreditoID
          and ProductoCreditoID = ProducCreditoID
          and Cre.ClienteID     = Cli.ClienteID;


Set Var_CliPagIVA   := ifnull(Var_CliPagIVA, SiPagaIVA);
Set Var_IVAIntOrd   := ifnull(Var_IVAIntOrd, SiPagaIVA);
Set Var_IVAIntMor   := ifnull(Var_IVAIntMor, SiPagaIVA);

Set Var_ValIVAIntOr := Entero_Cero;
Set Var_ValIVAIntMo := Entero_Cero;
Set Var_ValIVAGen   := Entero_Cero;


if (Var_CliPagIVA = SiPagaIVA) then
    Set	Var_IVASucurs	:= ifnull((select IVA
                                    from SUCURSALES
                                     where  SucursalID = Var_SucCredito),  Entero_Cero);


    Set Var_ValIVAGen  := Var_IVASucurs;

    if (Var_IVAIntOrd = SiPagaIVA) then
        Set Var_ValIVAIntOr  := Var_IVASucurs;
    end if;
    if (Var_IVAIntMor = SiPagaIVA) then
        Set Var_ValIVAIntMo  := Var_IVASucurs;
    end if;

end if;


select FechaSistema into Var_FecActual from PARAMETROSSIS;

select  round(sum(round(SaldoCapVigente,2) + round(SaldoCapAtrasa,2) +
			round(SaldoCapVencido,2) + round(SaldoCapVenNExi,2) +

			round(SaldoInteresOrd,2) + round(round(SaldoInteresOrd,2) * Var_ValIVAIntOr,2) +
			round(SaldoInteresAtr,2) + round(round(SaldoInteresAtr,2) * Var_ValIVAIntOr,2) +
			round(SaldoInteresVen,2) + round(round(SaldoInteresVen,2) * Var_ValIVAIntOr,2) +
			round(SaldoInteresPro,2) + round(round(SaldoInteresPro,2) * Var_ValIVAIntOr,2) +
			round(SaldoIntNoConta,2) + round(round(SaldoIntNoConta,2) * Var_ValIVAIntOr,2) +

			round(SaldoComFaltaPa,2) + round(round(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
            round(SaldoComServGar,2) + round(round(SaldoComServGar,2) * Var_ValIVAGen,2) +
			round(SaldoOtrasComis,2) + round(round(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
			round(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) +
			round(round(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen, 2) * Var_ValIVAIntMo,2) ), 2) into Var_TotAtrasado


from AMORTICREDITO
where FechaExigible <= Var_FecActual
  and Estatus <> EstatusPagado
  and CreditoID = Par_CreditoID;

Set Var_TotAtrasado = ifnull(Var_TotAtrasado, Entero_Cero);

select min(AmortizacionID) into Var_AmortizacionID
from AMORTICREDITO
where CreditoID   = Par_CreditoID
  and FechaExigible >= Var_FecActual
  and Estatus		   != EstatusPagado;

Set Var_AmortizacionID = ifnull(Var_AmortizacionID, Entero_Cero);

if Var_AmortizacionID != Entero_Cero then
select (round(Capital, 2) + round(Interes, 2) + round(IVAInteres, 2)) into
	   Var_MontoExigible
	from AMORTICREDITO
	where CreditoID      = Par_CreditoID
	  and AmortizacionID = Var_AmortizacionID
	  and Estatus		   != EstatusPagado;

Set Var_MontoExigible   = ifnull(Var_MontoExigible, Entero_Cero);
Set OutMontoPag	:= OutMontoPag+Var_MontoExigible;
Set OutMontoPag	:= ifnull(OutMontoPag,Entero_Cero);
end if;

return OutMontoPag;

END$$