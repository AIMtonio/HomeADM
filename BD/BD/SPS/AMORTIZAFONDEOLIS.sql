-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOLIS`;DELIMITER $$

CREATE PROCEDURE `AMORTIZAFONDEOLIS`(
	Par_CreditoFondeoID		bigint(20),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

/* DECLARACION DE CONSTANTES */
DECLARE Lis_Principal   int;
DECLARE Lis_GridAmorInv int;
DECLARE Lis_BancaLinea  int;
DECLARE Entero_Cero     int;
DECLARE Var_Pagado      char(1);
DECLARE SIPagaIVA       char(1);
DECLARE NOPagaIVA       char(1);

/* DECLARACION DE VARIABLES  */
DECLARE totalSalCap			decimal(12,2);
DECLARE totalSalInteres		decimal(12,2);
DECLARE Var_Fecha			date;
DECLARE Var_PagaIVA			char(1);
DECLARE Var_IVA				decimal(12,2);

/* ASIGNACION  DE CONSTANTES */
Set Entero_Cero         := 0;
Set Lis_Principal       := 1;		/* Lista las amortizaciones por credito pasivo */
Set Lis_GridAmorInv     := 2;
Set Lis_BancaLinea      := 3;       -- Lista para Banca en Linea *///
Set Var_Pagado          :='P';
Set SIPagaIVA           :='S';
Set NOPagaIVA           :='N';

/* lista principal */
if( Par_NumLis  = Lis_Principal ) then
	select PagaIVA, (PorcentanjeIVA/100)  into Var_PagaIVA, Var_IVA
		from CREDITOFONDEO
		where CreditoFondeoID = Par_CreditoFondeoID;

	set Var_PagaIVA := ifnull(Var_PagaIVA, SIPagaIVA);
	set Var_IVA 	:= ifnull(Var_IVA, Entero_Cero);

	if (Var_PagaIVA = NOPagaIVA) then
		set Var_IVA := Entero_Cero;
	end if;

	select	AmortizacionID,					FechaInicio,		FechaVencimiento,		FechaExigible,
			CASE Estatus 	WHEN 'N' THEN 'VIGENTE'
							WHEN 'P' THEN 'PAGADA'
							WHEN 'A' THEN 'ATRASADA'
							ELSE Estatus END AS Estatus,
			Estatus  as EstatusAmortiza,						Capital,			ifnull(Interes,Entero_Cero) as Interes,
			ifnull(IVAInteres,Entero_Cero) as IVAInteres,		SaldoCapital,		SaldoCapVigente,
			SaldoCapAtrasad,	round(SaldoInteresPro,2) as SaldoInteresPro,round(SaldoInteresAtra,2) as SaldoInteresAtra,		round((SaldoInteresPro + SaldoInteresAtra) * Var_IVA, 2) as SaldoIVAInteres,
			SaldoMoratorios,	round(SaldoMoratorios * Var_IVA, 2) as SaldoIVAMora,	SaldoComFaltaPa,
			round(SaldoComFaltaPa * Var_IVA, 2) as SaldoIVAComFalP,
			ifnull(SaldoOtrasComis,Entero_Cero) as SaldoOtrasComis,
			round(SaldoOtrasComis * Var_IVA, 2) as SaldoIVAOtrCom,
			round(SaldoCapVigente + SaldoCapAtrasad + SaldoInteresPro + SaldoInteresAtra + SaldoMoratorios + SaldoComFaltaPa +
				SaldoOtrasComis, 2)  + round((SaldoInteresPro + SaldoInteresAtra) * Var_IVA, 2) +
				round(SaldoMoratorios * Var_IVA, 2) + round(SaldoComFaltaPa * Var_IVA, 2) +
				round(SaldoOtrasComis * Var_IVA, 2) -
				ifnull(round(round(SaldoInteresPro,2)/round(Interes,2)* round(Retencion,2),2),Entero_Cero) as TotalCuota,
			ifnull(round(Capital + Interes + IVAInteres-Retencion,2),Entero_Cero) as MontoCuota, ifnull(Retencion,Entero_Cero) as Retencion,
			ifnull(round(round(SaldoInteresPro,2)/round(Interes,2)* round(Retencion,2),2),Entero_Cero) as SaldoRetencion
		from AMORTIZAFONDEO
		 where CreditoFondeoID = Par_CreditoFondeoID;
end if;

/* lsita */
if(Par_NumLis = Lis_GridAmorInv) then
	select FechaSistema into Var_Fecha
		FROM PARAMETROSSIS;

	Select 	AmortizacionID,	FechaInicio,		FechaVencimiento,
			CASE Estatus
				 WHEN 'N' THEN 'VIGENTE'
				 WHEN 'P' THEN 'PAGADA'
				 WHEN 'V' THEN 'VENCIDA'
				 WHEN 'A' THEN 'ATRASADA'
				 END AS Estatus,
				 FORMAT(ifnull((round(SaldoCapVigente,2) + round(SaldoCapAtrasad,2)),Entero_Cero),2) as Capital,
				 FORMAT(ifnull(round(SaldoInteresAtra,2) + round(SaldoInteresPro,2),Entero_Cero),2) as Interes,
				  FORMAT(round(SaldoMoratorios,2),2) as SaldoMoratorios ,
				   FORMAT(round(SaldoComFaltaPa,2),2) as SaldoComFaltaPa,
				 FORMAT(round(SaldoOtrasComis,2),2) as SaldoOtrasComis	,
				 Estatus as EstatusAmortiza
					from AMORTIZAFONDEO
					where CreditoFondeoID = Par_CreditoFondeoID
					  and FechaInicio < Var_Fecha
					  and Estatus != Var_Pagado;
end if;

if(Par_NumLis = Lis_BancaLinea) then

    select  AmortizacionID,	FechaInicio, 	FechaVencimiento, 	FechaExigible,		Estatus,
            Capital,        Interes,        IVAInteres,    (Capital+ Interes + IVAInteres) as TotalCuota
		from AMORTIZAFONDEO
		where CreditoFondeoID = Par_CreditoFondeoID
		group by AmortizacionID, FechaInicio, 	FechaVencimiento, 	FechaExigible,
				 Estatus,		 Capital,       Interes,        	IVAInteres;

end if;



END TerminaStore$$