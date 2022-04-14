-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOMOD`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDEOMOD`(
	Par_CreditoFondeoID		bigint(20),
	Par_LineaFondeoID   	int(11),
	Par_InstitutFondID		int(11),
	Par_Folio		   		varchar(150),
	Par_TipoCalInteres		int(11),

	Par_CalcInteresID		int(11),
	Par_TasaBase			int(11),
	Par_SobreTasa			decimal(12,4),
	Par_TasaFija			decimal(12,4),
	Par_PisoTasa			decimal(12,4),

	Par_TechoTasa			decimal(12,4),
	Par_FactorMora			decimal(12,4),
	Par_Monto				decimal(14,2),
	Par_MonedaID			int(11),
	Par_FechaInicio			date,

	Par_FechaVencim			date,
	Par_TipoPagoCap			char(1),
	Par_FrecuenciaCap		char(1),
	Par_PeriodicidadCap		int(11),
	Par_NumAmortizacion		int(11),

	Par_FrecuenciaInt		char(1),
	Par_PeriodicidadInt		int(11),
	Par_NumAmortInteres		int(11),
	Par_MontoCuota			decimal(12,2),
	Par_FechaInhabil		char(1),

	Par_CalendIrregular		char(1),
	Par_DiaPagoCapital		char(1),
	Par_DiaPagoInteres 		char(1),
	Par_DiaMesInteres   	int,
	Par_DiaMesCapital   	int,

	Par_AjusFecUlVenAmo 	char(1),
	Par_AjusFecExiVen   	char(1),
	Par_NumTransacSim   	bigint(20),
	Par_PlazoID				varchar(20),
	Par_PagaIVA				char(1),

	Par_IVA					decimal(12,4),
	Par_MargenPag			decimal(12,2),
	Par_InstitucionID		int(11),
	Par_CuentaClabe			varchar(18),
	Par_NumCtaInstit		varchar(20),

	Par_PlazoContable		char(1),
	Par_CapitalizaInteres	char(1),
	Par_Salida		      	char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(350),
	inout Par_Consecutivo	bigint,

	Par_EmpresaID			int(11),
	Aud_Usuario			   	int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),

	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero			int;
DECLARE	Decimal_Cero		decimal(12,2);
DECLARE	Fecha_Vacia			date;
DECLARE	Salida_SI			char(1);
DECLARE	Salida_NO			char(1);
DECLARE	Est_Vigente			char(1);
DECLARE	Nat_Cargo			char(1);
DECLARE	Nat_Abono			char(1);


DECLARE Var_CreFondeo    	int;
DECLARE Var_MontoAnt		decimal(14,2);
DECLARE Var_Monto			decimal(14,2);
DECLARE Var_NumTransacSim	bigint(20);
DECLARE	Nat_Movimiento		char(1);


Set	Entero_Cero			:= 0;
set	Salida_SI			:= 'S';
set	Salida_NO			:= 'N';
set	Decimal_Cero		:= 0.00;
set	Fecha_Vacia			:= '1900-01-01';
set	Est_Vigente			:= 'N';
set	Nat_Cargo			:= 'C';
set	Nat_Abono			:= 'A';


Set Var_CreFondeo		:= 0;
Set Par_NumErr			:= 0;


select CreditoFondeoID , Monto , NumTransacSim into Var_CreFondeo, 	Var_MontoAnt, Var_NumTransacSim
						from CREDITOFONDEO
						where CreditoFondeoID = Par_CreditoFondeoID;

Set Var_MontoAnt 		:= ifnull(Var_MontoAnt,Decimal_Cero );
Set Var_NumTransacSim 	:= ifnull(Var_NumTransacSim,Entero_Cero );

if(ifnull(Var_CreFondeo, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '001' as NumErr,
			'El numero de Credito Indicado no existe.' as ErrMen,
            'creditoFondeoID' as control,
            '0' as consecutivo;
	else
		set	Par_NumErr := 1;
		set	Par_ErrMen := 'El numero de Credito Indicado no existe.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_InstitutFondID, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '001' as NumErr,
			'La Institucion de Fondeo esta Vacia.' as ErrMen,
            'institutFondID' as control,
            '0' as consecutivo;
	else
		set	Par_NumErr := 1;
		set	Par_ErrMen := 'La Institucion de Fondeo esta Vacia.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_LineaFondeoID, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '002' as NumErr,
			'La Linea de Fondeo esta Vacia.' as ErrMen,
            'lineaFondeoID' as control,
            '0' as consecutivo;
	else
		set	Par_NumErr := 2;
		set	Par_ErrMen := 'La Linea de Fondeo esta Vacia.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Folio, Cadena_Vacia))= Cadena_Vacia then
	if (Par_Salida = Salida_SI) then
		select '003' as NumErr,
			'El Folio Esta Vacio.' as ErrMen,
            'folio' as control,
            '0' as consecutivo;
	else
		set	Par_NumErr := 3;
		set	Par_ErrMen := 'El Folio Esta Vacio.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_TipoCalInteres, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '004' as NumErr,
			'El Tipo Cal. Interes esta Vacio.' as ErrMen,
            'tipoCalInteres' as control,
            '0' as consecutivo;
	else
		set	Par_NumErr := 4;
		set	Par_ErrMen := 'El Tipo Cal. Interes esta Vacio.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Monto, Decimal_Cero)) <= Decimal_Cero then
	if (Par_Salida = Salida_SI) then
		select '005' as NumErr,
			'El Monto esta Vacio.' as ErrMen,
            'monto' as control,
            '0' as consecutivo;
	else
		set	Par_NumErr := 5;
		set	Par_ErrMen := 'El Monto esta Vacio.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;


if(ifnull(Par_MonedaID, Entero_Cero))= Entero_Cero then
	if (Par_Salida = Salida_SI) then
		select '006' as NumErr,
			'El numero de moneda esta vacio.' as ErrMen,
			'monedaID' as control,
			'0' as consecutivo;
	else
		set	Par_NumErr := 6;
		set	Par_ErrMen := 'El Monto esta Vacio.';
		set	Par_Consecutivo := Var_CreFondeo;
	end if;
	LEAVE TerminaStore;
end if;


	update  CREDITOFONDEO set
		LineaFondeoID	= Par_LineaFondeoID,
		InstitutFondID	= Par_InstitutFondID,
		Folio			= Par_Folio,
		TipoCalInteres	= Par_TipoCalInteres,
		CalcInteresID	= Par_CalcInteresID,
		TasaBase		= Par_TasaBase,
		SobreTasa		= Par_SobreTasa,
		TasaFija		= Par_TasaFija,
		PisoTasa		= Par_PisoTasa,
		TechoTasa		= Par_TechoTasa,
		FactorMora		= Par_FactorMora,
		Monto			= Par_Monto,
		MonedaID		= Par_MonedaID,
		FechaInicio		= Par_FechaInicio,
		FechaVencimien	= Par_FechaVencim,
		TipoPagoCapital	= Par_TipoPagoCap,
		FrecuenciaCap	= Par_FrecuenciaCap,
		PeriodicidadCap	= Par_PeriodicidadCap,
		NumAmortizacion	= Par_NumAmortizacion,
		FrecuenciaInt	= Par_FrecuenciaInt,
		PeriodicidadInt	= Par_PeriodicidadInt,
		NumAmortInteres	= Par_NumAmortInteres,
		MontoCuota		= Par_MontoCuota,
		FechaInhabil	= Par_FechaInhabil,
		CalendIrregular	= Par_CalendIrregular,
		DiaPagoInteres	= Par_DiaPagoInteres,
		DiaPagoCapital	= Par_DiaPagoCapital,
		DiaMesInteres	= Par_DiaMesInteres,
		DiaMesCapital	= Par_DiaMesCapital,
		AjusFecUlVenAmo	= Par_AjusFecUlVenAmo,
		AjusFecExiVen	= Par_AjusFecExiVen,
		NumTransacSim	= Par_NumTransacSim,
		PlazoID			= Par_PlazoID,
		PagaIva			= Par_PagaIVA,
		PorcentanjeIVA	= Par_IVA,
		MargenPagIgual	= Par_MargenPag,
		InstitucionID	= Par_InstitucionID,
		CuentaClabe		= Par_CuentaClabe,
		NumCtaInstit	= Par_NumCtaInstit,
		PlazoContable	= Par_PlazoContable,
		CapitalizaInteres=Par_CapitalizaInteres,
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where CreditoFondeoID = Par_CreditoFondeoID;





	if(Var_MontoAnt <> Par_Monto) then
		if(Var_MontoAnt > Par_Monto) then
			Set Nat_Movimiento 	:= Nat_Abono;
			Set Var_Monto		:= Var_MontoAnt - Par_Monto;
		else
			Set Nat_Movimiento	:= Nat_Cargo;
			Set Var_Monto		:= Par_Monto - Var_MontoAnt;
		end if;


		call SALDOSLINEAFONACT(
			Par_LineaFondeoID,	Nat_Movimiento,		Var_Monto,			Salida_NO,				Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
	end if;

	if(Par_NumErr = Entero_Cero) then
		set Par_NumErr	:= 0;
		set Par_ErrMen	:= concat('El Credito ha sido Modificado: ',convert(Var_CreFondeo,char));
	else
		set Var_CreFondeo := Entero_Cero;
		LEAVE TerminaStore;
	end if;



if (Par_Salida = Salida_SI) then
	select 	Par_NumErr 	as NumErr,
			Par_ErrMen	as ErrMen,
		   'creditoFondeoID' as control,
			Var_CreFondeo as consecutivo;
else
	set	Par_NumErr := 0;
	set	Par_ErrMen := concat('El Credito ha sido Modificado: ',convert(Var_CreFondeo,char));
	set	Par_Consecutivo := Var_CreFondeo;
end if;

END TerminaStore$$