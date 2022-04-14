-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOKUBOALT`;
DELIMITER $$


CREATE PROCEDURE `FONDEOKUBOALT`(
	Par_ClienteID			bigint,
	Par_CreditoID			bigint,
	Par_CuentaAhoID		bigint,
	Par_SoliciCredID		bigint,
	Par_ConsecSolici		int,
	Par_Folio			varchar(20),
	Par_CalcInteresID		int,
	Par_TasaBaseID		int,
	Par_SobreTasa			decimal(8,4),
	Par_TasaFija			decimal(8,4),
	Par_PisoTasa			decimal(8,4),
	Par_TechoTasa			decimal(8,4),
	Par_MontoFondeo		decimal(12,2),
	Par_PorcenFondeo		decimal(8,4),
	Par_MonedaID			int(11),
	Par_FechaInicio		date,
	Par_FechaVencim		date,
	Par_TipoFondeo		char(1),
	Par_NumCuotas			int,
	Par_NumRetirosMes		int,
	Par_PorcenMora		decimal(8,4),
	Par_PorcenComisi		decimal(8,4),
	Par_EmpresaID			int(11),

	Par_SucCliente		int,
	Par_FechaOper			date,
	Par_FechaApl			date,
	Par_Referencia		varchar(50),
	Par_NumRetMes			int,
	Par_Poliza			bigint,

	Par_Salida		char(1),

inout Par_NumErr			int(11),
inout Par_ErrMen			varchar(400),
inout Par_Consecutivo		bigint,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)

TerminaStore: BEGIN


DECLARE  FondeoKubo    	int;

DECLARE 	Var_InterGene	   	decimal(12,2);
DECLARE  Var_InterRet	  	decimal(12,2);
DECLARE  Var_PorcentInt  	decimal(8,6);
DECLARE  Var_AcumCap		decimal(12,2);
DECLARE  Var_SaldoInsol	decimal(12,2);
DECLARE  Var_DiasIntere	int;
DECLARE  Var_Ciclo		int;
DECLARE  Var_DiasCredito	decimal(12,2);
DECLARE  Var_TasaISR		decimal(8,4);
DECLARE	Var_PagaISR		char(1);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);



DECLARE  Var_AmortiID		int;
DECLARE  Var_FechaInicio	date;
DECLARE  Var_FechaVencim	date;
DECLARE  Var_FechaExi		date;
DECLARE  Var_Capital		decimal(12,2);
DECLARE  Var_Interes		decimal(12,2);



DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero		int;
DECLARE	Por_Cien			decimal(12,2);
DECLARE	Nace_Estatus  	char(1);
DECLARE	Salida_SI		char(1);
DECLARE  NO_PagaISR		char(1);
DECLARE  Des_AltaInv		varchar(100);
DECLARE  EstatusVigen		char(1);

DECLARE  AltaPoliza_NO	char(1);
DECLARE  AltaPolKubo_SI	char(1);
DECLARE  AltaMovKubo_NO	char(1);
DECLARE  AltaMovAho_SI	char(1);
DECLARE  Con_KuboCapita 	int;
DECLARE  Mov_AhoApeInv 	char(3);


DECLARE CURSORAMORTICRE CURSOR FOR
	select	AmortizacionID, FechaInicio, FechaVencim, FechaExigible,	Capital,
			Interes
		from AMORTICREDITO Amo
		where Amo.CreditoID	= Par_CreditoID
		  and Estatus			= 'V';


set	Cadena_Vacia	:= '';
set	Entero_Cero	:= 0;
set	Por_Cien		:= 100.00;
set 	Nace_Estatus	:= 'N';
set	Salida_SI	:= 'S';
set 	NO_PagaISR	:= 'N';
set 	EstatusVigen	:= 'N';

Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';

set 	AltaPoliza_NO		:= 'N';
set 	AltaPolKubo_SI	:= 'S';
set 	AltaMovKubo_NO	:= 'N';
set 	AltaMovAho_SI		:= 'S';
set 	Con_KuboCapita 	:= 1;
set 	Mov_AhoApeInv 	:= '70';

Set 	Des_AltaInv	:= 'FONDEO DE CREDITO';

set	FondeoKubo	:= 0;
set Var_Ciclo		:= 1;

if(ifnull(Par_ClienteID, Entero_Cero))= Entero_Cero then
        select '001' as NumErr,
                 'El numero de Cliente esta Vacio.' as ErrMen,
                 'ClienteID' as control, FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_CreditoID, Entero_Cero))= Entero_Cero then
        select '002' as NumErr,
                 'El numero de Credito esta Vacio.' as ErrMen,
                 'CreditoID' as control, FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_SoliciCredID, Entero_Cero))= Entero_Cero then
        select '003' as NumErr,
                 'La Solicitud de Credito esta vacia.' as ErrMen,
                 'SolicitudCreditoID' as control, FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_ConsecSolici, Entero_Cero))= Entero_Cero then
        select '004' as NumErr,
                 'El numero consecutivo esta vacio.' as ErrMen,
                 'Consecutivo' as control, FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_MontoFondeo, Entero_Cero)) <= Entero_Cero then
        select '005' as NumErr,
               'El Monto de Fondeo esta vacio.' as ErrMen,
               'MontoFondeo' as control,
			  FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;


if(ifnull(Par_PorcenFondeo, Entero_Cero)) <= Entero_Cero then
        select '006' as NumErr,
			  'El procentaje de fondeo esta vacio.' as ErrMen,
			  'PorcentajeFondeo' as control,
			  FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_MonedaID, Entero_Cero))= Entero_Cero then
        select '007' as NumErr,
                 'El numero de moneda esta vacio.' as ErrMen,
                 'MonedaID' as control, FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_NumCuotas, Entero_Cero))= Entero_Cero then
        select '008' as NumErr,
                 'El numero de cuotas esta vacio.' as ErrMen,
                 'NumCuotas' as control, FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_PorcenMora, Entero_Cero)) < Entero_Cero then
        select '009' as NumErr,
               'Porcentaje Participacion en Mora Incorrecto.' as ErrMen,
               'PorcentajeMora' as control,
			  FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

if(ifnull(Par_PorcenComisi, Entero_Cero)) < Entero_Cero then
        select '010' as NumErr,
               'Porcentaje Participacion en Comisiones esta vacio.' as ErrMen,
               'PorcentajeComisi' as control,
			  FondeoKubo as consecutivo;
        LEAVE TerminaStore;
end if;

set FondeoKubo	:= (select ifnull(max(FondeoKuboID),Entero_Cero) + 1
					from FONDEOKUBO);

insert into FONDEOKUBO(
	FondeoKuboID, 		ClienteID,   			CreditoID,			CuentaAhoID,		SolicitudCreditoID,
	Consecutivo,			Folio, 				CalcInteresID,  		TasaBaseID,		SobreTasa,
	TasaFija,			PisoTasa,			TechoTasa, 			MontoFondeo,		PorcentajeFondeo,
	MonedaID,			FechaInicio,  		FechaVencimiento,		TipoFondeo,		NumCuotas,
	NumRetirosMes,		PorcentajeMora,		PorcentajeComisi,		Estatus,     		SaldoCapVigente,
	SaldoCapExigible,		SaldoInteres,			ProvisionAcum,		MoratorioPagado,	ComFalPagPagada,
	IntOrdRetenido,		IntMorRetenido,		ComFalPagRetenido,	EmpresaID,		Usuario,
	FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
  values (
	FondeoKubo,			Par_ClienteID,    Par_CreditoID,		Par_CuentaAhoID,	Par_SoliciCredID,
	Par_ConsecSolici,		Par_Folio,	 	Par_CalcInteresID,	Par_TasaBaseID,   Par_SobreTasa,
	Par_TasaFija,			Par_PisoTasa,		Par_TechoTasa,		Par_MontoFondeo,	Par_PorcenFondeo,
	Par_MonedaID,			Par_FechaInicio,	Par_FechaVencim,   	Par_TipoFondeo,   Par_NumCuotas,
	Par_NumRetirosMes,	Par_PorcenMora,	Par_PorcenComisi,		Nace_Estatus,		Entero_Cero,
	Entero_Cero,			Entero_Cero,		Entero_Cero,			Entero_Cero,		Entero_Cero,
	Entero_Cero,			Entero_Cero,		Entero_Cero,			Par_EmpresaID,	Aud_Usuario,
	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


update FONDEOSOLICITUD set
	FondeoKuboID	= FondeoKubo,
	Estatus		= EstatusVigen

	where SolicitudCreditoID 	= Par_SoliciCredID
	  and Consecutivo			= Par_ConsecSolici;


call  CONTAINVKUBOPRO (
	FondeoKubo,			Entero_Cero,		Par_CuentaAhoID,	Par_ClienteID,	Par_FechaOper,
	Par_FechaApl,			Par_MontoFondeo,	Par_MonedaID,		Par_NumRetMes,	Par_SucCliente,
	Des_AltaInv,			Par_Referencia,	AltaPoliza_NO,	Entero_Cero,		Par_Poliza,
	AltaPolKubo_SI,		AltaMovKubo_NO,	Con_KuboCapita,	Entero_Cero,		Nat_Abono,
	Cadena_Vacia,			AltaMovAho_SI,	Mov_AhoApeInv,	Nat_Cargo,		Par_NumErr,
	Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

set Var_AcumCap		:= 0.00;
set Var_SaldoInsol	:= Par_MontoFondeo;


select	DiasCredito,	TasaISR into Var_DiasCredito, Var_TasaISR
	from PARAMETROSSIS;


select	PagaISR into Var_PagaISR
	from CLIENTES
	where ClienteID = Par_ClienteID;

if (Var_PagaISR = NO_PagaISR) then
	set	Var_TasaISR = 0.00;
end if;

OPEN CURSORAMORTICRE;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	LOOP

	FETCH CURSORAMORTICRE into
		Var_AmortiID,	Var_FechaInicio,	Var_FechaVencim,	Var_FechaExi,	Var_Capital,
		Var_Interes;


		set Var_InterGene		:= 0.00;
		set Var_InterRet		:= 0.00;
		set Var_DiasIntere	:= 0.00;
		set Var_PorcentInt	:= 0.000000;

		if (Var_Ciclo = Par_NumCuotas) then
			set Var_Capital	:= Par_MontoFondeo - Var_AcumCap;
		else
			set Var_Capital	:= round((Var_Capital * Par_PorcenFondeo)/Por_Cien, 2);
			set Var_AcumCap	:= Var_AcumCap + Var_Capital;
		end if;

		set	Var_DiasIntere	:= datediff(Var_FechaVencim, Var_FechaInicio);



		set Var_InterGene		:= round((Var_SaldoInsol * Var_DiasIntere * Par_TasaFija) /
									(Por_Cien * Var_DiasCredito), 2);


		if (Var_TasaISR > 0.00) then
			set Var_InterRet		:= round((Var_SaldoInsol * Var_DiasIntere * Var_TasaISR) /
										(Por_Cien * Var_DiasCredito), 2);
		end if;

		set Var_PorcentInt	:= round(Var_InterGene / Var_Interes, 6);


		call  AMORTIZAFONDEOALT (
			FondeoKubo,		Var_AmortiID,		Var_FechaInicio,	Var_FechaVencim,	Var_FechaExi,
			Var_Capital,		Var_InterGene	,	Var_InterRet,		Var_PorcentInt,	Par_FechaOper,
			Par_FechaApl,		Par_MonedaID,		Par_Referencia,	Par_Salida,		Par_NumErr,
			Par_ErrMen,		Par_Consecutivo,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion );

		set Var_Ciclo			:= Var_Ciclo + 1;
		set Var_SaldoInsol	:= Var_SaldoInsol - Var_Capital;

	End LOOP;
END;

CLOSE CURSORAMORTICRE;

if (Par_Salida = Salida_SI) then
	select '000' as NumErr,
  		   'El Fondeo Kubo ha sido Agregado.' as ErrMen,
		   'FondeoKuboID' as control,
			FondeoKubo as consecutivo;
else
	set	Par_NumErr := '000';
	set	Par_ErrMen := 'El Fondeo Kubo ha sido Agregado.';
	set	Par_Consecutivo := FondeoKubo;

end if;

END TerminaStore$$