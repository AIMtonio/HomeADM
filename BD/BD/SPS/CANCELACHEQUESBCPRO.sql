-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACHEQUESBCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACHEQUESBCPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELACHEQUESBCPRO`(
	Par_CuentaAhoID			bigint(12),
	Par_ClienteID			int(11),
	Par_MontoComision		decimal(14,2),
	Par_MontoIVAComision	decimal(14,2),
	Par_MontoCheque			decimal(14,2),

	Par_BancoEmisor			int(11),
	Par_CuentaEmisor		varchar(12),
	Par_ChequeSBCID			int(10),
	Par_NombreEmisor		varchar(200),

	Par_Salida				char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)

		)
TerminaStore:BEGIN

DECLARE Var_FechaOper		date;
DECLARE Var_FechaApl		date;
DECLARE Var_EsHabil			char(1);
DECLARE Var_Monedas			int;
DECLARE Var_SucCliente		int(11);
DECLARE Var_MontoTotalCargo	decimal(14,2);
DECLARE Par_Poliza			int;
DECLARE	Var_CtaContaDocSBCD		varchar(25);
DECLARE	Var_CtaContaDocSBCA		varchar(25);
DECLARE	Var_MonedaBaseID		int(11);
DECLARE Var_AfectaContaRecSBC	char(1);
DECLARE Var_CentroCostos		varchar(30);



DECLARE Var_CueClienteID		bigint;
DECLARE Var_Cue_Saldo			decimal(12,2);
DECLARE Var_CueMoneda			int;
DECLARE Var_CueEstatus			char(1);
DECLARE Var_EsGrupal		    char(1);
DECLARE Var_SolCreditoID    bigint;
DECLARE Var_GrupoID         int;
DECLARE Var_CicloActual     int;
DECLARE Var_CicloGrupo      int;
DECLARE Var_GrupoCtaID      int;


DECLARE SalidaNO			char(1);
DECLARE SalidaSI			char(1);
DECLARE Entero_Cero			int;
DECLARE cancelado			int;
DECLARE Cadena_Vacia		char;
DECLARE tipoMovCargoCuenta	int;
DECLARE Cargo				char(1);
DECLARE DescripcionMov		varchar(100);
DECLARE DescripcionMovIVA   varchar(100);
DECLARE concepContaComFC	int;
DECLARE conceptoAhorro		int;
DECLARE AltaPoliza_SI		char(1);

DECLARE conceptoAhorroCom 		int;
DECLARE conceotoAhorroIVACom 	int;
DECLARE descripcionComision		varchar(100);
DECLARE descripcionIVAComision	varchar(100);
DECLARE AltaPoliza_NO			char(1);
DECLARE Pol_Automatica			char(1);
DECLARE ConceptoCon				int;
DECLARE DescripcionMovSBC		varchar(200);
DECLARE DescripconCargo			varchar(100);
DECLARE DescripconAbono			varchar(100);
DECLARE Procedimiento			varchar(200);
DECLARE SI						char(1);
DECLARE For_SucOrigen			CHAR(3);
DECLARE For_SucCliente			CHAR(3);

DECLARE Esta_Activo     char(1);
DECLARE NO_EsGrupal     char(1);
DECLARE Decimal_Cero    decimal(12, 2);
DECLARE TipoInstrumentoID	int(11);
DECLARE Var_CentroCostosID		int(11);



set SalidaNO				:='N';
set SalidaSI				:='S';
set Entero_Cero				:= 0;
set Cancelado				:=2;
set Cadena_Vacia			:='';

set tipoMovCargoCuenta		:= 204;
set Cargo					:='C';
set DescripcionMov			:='COMISION FALSO COBRO CHEQUE SBC';
set DescripcionMovIVA		:='IVA COMISION FALSO COBRO CHEQUE SBC';
set concepContaComFC		:= 41;
set conceptoAhorro 			:= 1;
set AltaPoliza_SI			:= 'S';


Set Esta_Activo    			:= 'A';
set NO_EsGrupal     		:= 'N';
Set Decimal_Cero    		:= 0.0;
set AltaPoliza_NO			:='N';


set conceptoAhorroCom 		:= 11;
set conceotoAhorroIVACom 	:= 12;
set descripcionComision		:='COMISION POR FALSO COBRO';
set descripcionIVAComision	:='IVA COMISION POR FALSO COBRO';
set Pol_Automatica			:='A';
set ConceptoCon				:=42;
set DescripcionMovSBC		:='CANCELACION DE DOCTOS. SALVO BUEN COBRO SBC';
set DescripconCargo			:='CANCELACION DE DOCTOS. DE COBRO INMEDIATO SBC';
set DescripconAbono			:='CANCELACION DE DOCTOS. DE COBRO INMEDIATO SBC';
set Procedimiento			:='CANCELACHEQUESBCPRO';
set SI						:='S';
Set TipoInstrumentoID		:= 9;
Set For_SucOrigen			:='&SO';
Set For_SucCliente			:='&SC';
set Var_CentroCostosID		:=0;


ManejoErrores: BEGIN

set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;
set Aud_FechaActual := now();

 set Var_MontoTotalCargo:=Par_MontoComision + Par_MontoIVAComision;


set Var_FechaOper   := (select FechaSistema
                            from PARAMETROSSIS);


call DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);


select  Cli.SucursalOrigen into Var_SucCliente
	from  CLIENTES Cli
	where Cli.ClienteID   = Par_ClienteID;

set Var_SucCliente :=ifnull(Var_SucCliente,Entero_Cero);
set Var_Monedas  := (select MonedaID from CUENTASAHO where CuentaAhoID=Par_CuentaAhoID );
set Var_Monedas :=ifnull(Var_Monedas, Entero_Cero);


CALL SALDOSAHORROCON(
	Var_CueClienteID, Var_Cue_Saldo, Var_CueMoneda, Var_CueEstatus, Par_CuentaAhoID);



if(ifnull(Var_CueEstatus, Cadena_Vacia)) != Esta_Activo then
	if(Par_Salida = SalidaSI) then
		select '01' as NumErr,
            'La Cuenta  no Existe o no Esta Activa ' as ErrMen,
            'cuentaAhoID' as control,
			 0 as consecutivo;
	else
		Set Par_NumErr		:= '01';
		Set Par_ErrMen		:= 'La Cuenta no Existe o no Esta Activa ';

	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Var_CueMoneda, Entero_Cero)) != Var_Monedas then
	if(Par_Salida = SalidaSI) then
		select '02' as NumErr,
			 'La Moneda no corresponde con la Cuenta' as ErrMen,
			 'monto' as control,
			 0 as consecutivo;
	else
		Set Par_NumErr		:= '02';
		Set Par_ErrMen		:= 'La Moneda no corresponde con la Cuenta';

	end if;
	LEAVE TerminaStore;
end if;

if(ifnull(Var_Cue_Saldo, Decimal_Cero)) < Var_MontoTotalCargo then
	if(Par_Salida = SalidaSI) then
		select '03' as NumErr,
			 'Saldo Insuficiente en la Cuenta del Cliente' as ErrMen,
			 'monto' as control,
				0  as consecutivo;
	else
		Set Par_NumErr		:= '03';
		Set Par_ErrMen		:= 'Saldo Insuficiente en la Cuenta del Cliente';
	end if;
	LEAVE TerminaStore;
end if;



call ABONOCHEQUESBCACT(
			Par_ChequeSBCID,	Var_FechaOper,		Entero_Cero,	Cadena_Vacia,		Entero_Cero,
			Cancelado,		SalidaNO,				Par_NumErr,		Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

if (Par_NumErr <> Entero_Cero)then
	LEAVE ManejoErrores;
end if;


	update CUENTASAHO set
		SaldoSBC 		= SaldoSBC - Par_MontoCheque,

		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

		where CuentaAhoID=Par_CuentaAhoID;


if (Par_MontoComision != Entero_Cero||Par_MontoIVAComision != Entero_Cero)then
	set Par_Poliza := Entero_Cero;
	if (Par_MontoComision != Entero_Cero)then
		call CONTAAHORROPRO(
					Par_CuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaApl,
					Cargo,					Par_MontoComision,  DescripcionMov,			Par_CuentaAhoID,	tipoMovCargoCuenta,
					Var_Monedas,			Var_SucCliente,		AltaPoliza_SI, 			concepContaComFC,	Par_Poliza,
					AltaPoliza_SI,		 	conceptoAhorro,		Cargo,					Par_NumErr,			Par_ErrMen,
					Entero_Cero,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
	end if;
	if (Par_MontoIVAComision != Entero_Cero)then
		call CONTAAHORROPRO(
					Par_CuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaApl,
					Cargo,					Par_MontoIVAComision,  DescripcionMovIVA,	Par_CuentaAhoID,	tipoMovCargoCuenta,
					Var_Monedas,			Var_SucCliente,		AltaPoliza_NO, 			concepContaComFC,	Par_Poliza,
					AltaPoliza_SI,		 	conceptoAhorro,		Cargo,					Par_NumErr,			Par_ErrMen,
					Entero_Cero,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
		end if;



	call DETALLEPOLIZAPRO(
				Par_Poliza,			Par_EmpresaID,	Var_FechaOper,		Par_ClienteID,		conceptoAhorroCom,
				Par_CuentaAhoID,	Var_Monedas,	Entero_Cero,		Par_MontoComision,	descripcionComision,
				Par_ClienteID,		SalidaNO,		Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	call DETALLEPOLIZAPRO(
				Par_Poliza,		Par_EmpresaID,		Var_FechaOper,		Par_ClienteID,		conceotoAhorroIVACom,
				Par_CuentaAhoID,Var_Monedas,		Entero_Cero,		Par_MontoIVAComision,descripcionIVAComision,
				Par_ClienteID,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
end IF;


	select CtaContaDocSBCD, CtaContaDocSBCA, MonedaBaseID, AfectaContaRecSBC
		into Var_CtaContaDocSBCD, Var_CtaContaDocSBCA, Var_MonedaBaseID, Var_AfectaContaRecSBC
		from PARAMETROSSIS
			where EmpresaID =Par_EmpresaID
			limit 1;
	set Var_CtaContaDocSBCD 	:= ifnull(Var_CtaContaDocSBCD, Cadena_Vacia);
	set Var_CtaContaDocSBCA		:=ifnull(Var_CtaContaDocSBCA,Cadena_Vacia );
	set Var_MonedaBaseID		:=ifnull(Var_MonedaBaseID,Entero_Cero );
	set Var_AfectaContaRecSBC	:= ifnull(Var_AfectaContaRecSBC, Cadena_Vacia);


		select CenCostosChequeSBC
			into Var_CentroCostos
			from PARAMETROSSIS
			where EmpresaID= Par_EmpresaID
			limit 1;

		select SucursalOrigen
			into Var_SucCliente
			from CLIENTES
			where ClienteID = Par_ClienteID
			limit 1;


	if LOCATE(For_SucOrigen, Var_CentroCostos) > 0 then
				set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
			else
				if LOCATE(For_SucCliente, Var_CentroCostos) > 0 then
						if (Var_SucCliente > 0) then
							set Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
						else
							set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						end if;
			end if;
	end if;



if(Var_AfectaContaRecSBC =SI)then
	if(Par_MontoComision <= Decimal_Cero || Par_MontoIVAComision <= Decimal_Cero)then
		CALL MAESTROPOLIZAALT(
			Par_Poliza,			Par_EmpresaID,	Var_FechaOper, 			Pol_Automatica,		ConceptoCon,
			DescripcionMovSBC,	SalidaNO, 		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
	end if;

	call DETALLEPOLIZAALT (
		Par_EmpresaID,		Par_Poliza,			Var_FechaOper,		Var_CentroCostosID,		Var_CtaContaDocSBCD,
		Par_ChequeSBCID,	Var_Monedas,		Entero_Cero,		Par_MontoCheque,		DescripconCargo,
		Par_CuentaEmisor,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,			Decimal_Cero,
		Cadena_Vacia,		SalidaNO, 			Par_NumErr,			Par_ErrMen,				Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
	);

	call DETALLEPOLIZAALT (
		Par_EmpresaID,		Par_Poliza,			Var_FechaOper,		Var_CentroCostosID,	Var_CtaContaDocSBCA,
		Par_ChequeSBCID,	Var_Monedas,		Par_MontoCheque,	Entero_Cero,		DescripconAbono,
		Par_CuentaEmisor,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
		Cadena_Vacia,		SalidaNO, 			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
	);


end IF;




END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'tipoOperacion' as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$