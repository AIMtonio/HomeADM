-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOALT`;
DELIMITER $$


CREATE PROCEDURE `AMORTIZAFONDEOALT`(
	Par_CreditoFonID		bigint(20),
	Par_AmortizaID  		int(11),
	Par_FechaInicio 		date,
	Par_FechaVencim			date,
	Par_FechaExigible		date,
	Par_Capital				decimal(14,2),
	Par_Interes				decimal(14,2),
	Par_IVAInteres			decimal(14,2),

	Par_Salida				char(1),

inout Par_NumErr			INT(11),
inout Par_ErrMen			varchar(400),
inout Par_Consecutivo		bigint,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)

TerminaStore: BEGIN


DECLARE Entero_Cero       	int;
DECLARE Decimal_Cero       	decimal(12,2);
DECLARE	Fecha_Vacia			date;
DECLARE	Est_Vigente			char(1);
DECLARE	Salida_SI			char(1);
DECLARE	Nat_Cargo			char(1);




set	Entero_Cero			:= 0;
set	Decimal_Cero		:= 0.00;
set	Fecha_Vacia			:= '1900-01-01';
set	Est_Vigente			:= 'N';
Set	Salida_SI			:= 'S';
Set	Nat_Cargo			:= 'C';



Set Aud_FechaActual := CURRENT_TIMESTAMP();

if (ifnull(Par_AmortizaID,Entero_Cero) = Entero_Cero) then
	set Par_AmortizaID := (select ifnull(Max(AmortizacionID), Entero_Cero) + 1
							from AMORTIZAFONDEO
							where CreditoFondeoID	= Par_CreditoFonID);
end if;

insert into AMORTIZAFONDEO (
	CreditoFondeoID,	AmortizacionID,		FechaInicio,		FechaVencimiento,		FechaExigible,
	FechaLiquida,		Estatus,			Capital,			Interes,				IVAInteres,
	SaldoCapVigente,	SaldoCapAtrasa,		SaldoCapVencido,	SaldoCapVenNExi,		SaldoInteresOrd,
	SaldoInteresAtr,	SaldoInteresVen,	SaldoInteresPro,	SaldoIntNoConta,		SaldoIVAInteres,
	SaldoMoratorios,	SaldoIVAMorato,		SaldoComFaltaPa,	SaldoIVAComFalP,		SaldoOtrasComis,
	SaldoIVAComisi,		ProvisionAcum,		SaldoCapital,		EmpresaID,				Usuario,
	FechaActual,		DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion
)
values(
	Par_CreditoFonID,	Par_AmortizaID,		Par_FechaInicio,	Par_FechaVencim,		Par_FechaExigible,
	Fecha_Vacia,		Est_Vigent,e,		Par_Capital,		Par_Interes,			Par_IVAInteres,
	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,
	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,
	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,			Decimal_Cero,
	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Aud_EmpresaID,			Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
);



if (Par_Salida = Salida_SI) then
	select	'000' as NumErr ,
			'Amortizaciones Guardadas.' as ErrMen,
			'creditoFondeoID' as control;
else
	set	Par_NumErr := '000';
	set	Par_ErrMen := 'Amortizaciones Guardadas.';
	set	Par_Consecutivo := Par_AmortizaID;

end if;

END TerminaStore$$