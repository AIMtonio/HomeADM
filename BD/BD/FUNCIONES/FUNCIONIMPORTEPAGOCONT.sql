-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONIMPORTEPAGOCONT
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONIMPORTEPAGOCONT`;DELIMITER $$

CREATE FUNCTION `FUNCIONIMPORTEPAGOCONT`(
    Par_CreditoID   bigint,
    Par_Fecha       date

) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN


DECLARE Var_MontoExigible			decimal(14,2);
DECLARE Var_IVA             		decimal(12,2);
DECLARE Var_PorcentajeIVA   		decimal(12,2);
DECLARE Var_FechaSiguienteCuota     date;
DECLARE Var_CreEstatus      		char(1);
DECLARE Var_CliPagIVA       		char(1);
DECLARE Var_ProCobIVA       		char(1);
DECLARE Var_SiguienteCuota  		decimal(12,2);
DECLARE Var_ExigibleActual			decimal(12,2);
DECLARE Cadena_Vacia    			char(1);
DECLARE Fecha_Vacia     			date;
DECLARE Entero_Cero     			int;
DECLARE Decimal_Cero    			decimal(14,2);
DECLARE EstatusPagado   			char(1);
DECLARE SiPagaIVA       			char(1);
DECLARE CreditoVencido  			char(1);

Set Cadena_Vacia    		:= '';
Set Fecha_Vacia     		:= '1900-01-01';
Set Entero_Cero     		:= 0;
Set Decimal_Cero    		:= 0.00;
Set EstatusPagado   		:= 'P';
Set SiPagaIVA       		:= 'S';
set CreditoVencido			:= 'B';
set Var_MontoExigible   	:= Decimal_Cero;
set Var_IVA             	:= Decimal_Cero;
set Var_PorcentajeIVA   	:= Decimal_Cero;
set Var_FechaSiguienteCuota := Par_Fecha;

set Var_CreEstatus :=(select EstatusCredito from SALDOSCREDITOSCONT where FechaCorte=Par_Fecha and CreditoID=Par_CreditoID limit 1);

set Var_CreEstatus = ifnull(Var_CreEstatus, Cadena_Vacia);

if(Var_CreEstatus != CreditoVencido) then
	-- Obtenemos la Fecha del vencimiento posterior a la Fecha de Corte
	SET Var_FechaSiguienteCuota:= (select min(FechaExigible)  from AMORTICREDITOCONT
										where FechaExigible >= Par_Fecha
										and (Estatus <> EstatusPagado
										or (Estatus =EstatusPagado
										and FechaLiquida>Par_Fecha))
										and CreditoID     =  Par_CreditoID);

	set Var_FechaSiguienteCuota = ifnull(Var_FechaSiguienteCuota, Fecha_Vacia);


	if  (Var_FechaSiguienteCuota!=Fecha_Vacia) then
		-- Obtenemos el importe de la siguiente cuota, posterior a la fecha de corte
	    set Var_SiguienteCuota:= (select  (Capital) from AMORTICREDITOCONT
										where FechaExigible = Var_FechaSiguienteCuota
										and CreditoID=Par_CreditoID
										LIMIT 1);
	end if;

	set Var_SiguienteCuota := ifnull(Var_SiguienteCuota, Decimal_Cero);




	 set Var_ExigibleActual := (select sum(Capital+Interes) from AMORTICREDITOCONT
									where FechaExigible<coalesce(Var_FechaSiguienteCuota,Par_Fecha)
									and  coalesce(FechaLiquida,Par_Fecha)>Par_Fecha
									and CreditoID=Par_CreditoID
									group by CreditoID
									order by FechaExigible );

	set Var_ExigibleActual := ifnull(Var_ExigibleActual, Decimal_Cero);

	set Var_MontoExigible := Var_ExigibleActual  +   Var_SiguienteCuota;

else -- si el credito esta vencido, el importe de pago es todo lo vencido y provisionado


 	set Var_MontoExigible:=(select sum(SalCapAtrasado+SalCapVencido+SalIntOrdinario+SalIntAtrasado+SalIntVencido+SalIntProvision+SalIntNoConta)as Monto from SALDOSCREDITOSCONT
									where FechaCorte=Par_Fecha
									and CreditoID=Par_CreditoID);
end if;



return Var_MontoExigible;

END$$