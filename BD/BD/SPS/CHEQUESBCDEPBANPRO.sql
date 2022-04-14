-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESBCDEPBANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESBCDEPBANPRO`;
DELIMITER $$

CREATE PROCEDURE `CHEQUESBCDEPBANPRO`(
	Par_ChequeSBCID		int(11),
	Par_SucOperacion    int,
    Par_InstitucionID   int,
    Par_CuentaBancos    varchar(12),

	Par_Salida          char(1),
inout	Par_NumErr		int,
inout	Par_ErrMen		varchar(350),

    Par_EmpresaID         int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
		)
TerminaStore:BEGIN


DECLARE Var_FechaOper			date;
DECLARE Var_FechaApl			date;
DECLARE Var_EsHabil				char(1);
DECLARE Var_Poliza				int;
DECLARE Var_CuentaBancos		varchar(25);
DECLARE Var_CuentaTesoAhoID     int(12);
DECLARE Var_CentroCosto     	int;
DECLARE Var_CuentaInst			varchar(20);
DECLARE Var_Monto				decimal(14,2);
DECLARE Var_CuentaAhoID			bigint(12);
DECLARE Var_ClienteID			int(11);
DECLARE Var_MonedaID			int(11);
DECLARE Var_Numcheque			int(10);
DECLARE Var_CuentaBancosA		bigint(12);
DECLARE	Var_Control 			varchar(50);
DECLARE	Var_CtaContaDocSBCD		varchar(25);
DECLARE	Var_CtaContaDocSBCA		varchar(25);
DECLARE	Var_MonedaBaseID		int(11);
DECLARE Var_AfectaContaRecSBC	char(1);
DECLARE Var_CentroCostos		varchar(30);
DECLARE Var_SucCliente			int(11);


DECLARE Entero_Cero				int;
DECLARE Decimal_Cero        	decimal(12,2);
DECLARE DesContableBanco		varchar(50);
DECLARE AltaEncPolizaSI			char(1);
DECLARE concepContaDepBancos	int;
DECLARE NatContaCargo			char(1);
DECLARE AltaMovAhorroSI			char(1);
DECLARE tipoMovAbonoCuenta		int;
DECLARE NatContaAhorro			char(1);
DECLARE Abono					char(1);
DECLARE SalidaSI				char(1);
DECLARE SalidaNO				char(1);

DECLARE DesMovCuentaBanco		varchar(100);
DECLARE NoConciliado			char(1);
DECLARE RegistroPantalla		char(1);
DECLARE Act_AplicaCheque		int;
DECLARE Cadena_Vacia			char(1);
DECLARE TipoMovTeso				int;
DECLARE Est_Aplicado			char(1);
DECLARE Est_Cancelado			char(1);
DECLARE Est_Activa				char(1);
DECLARE FormaAplicacion			char(1);
DECLARE DescripconCargo			varchar(100);
DECLARE DescripconAbono			varchar(100);
DECLARE Procedimiento			varchar(200);
DECLARE ConsecutivoCero			int;
DECLARE SI						char(1);
DECLARE TipoInstrumentoID		int(11);
DECLARE For_SucOrigen			CHAR(3);
DECLARE For_SucCliente			CHAR(3);
DECLARE Var_CentroCostosID		INT(11);


set Entero_Cero				:= 0;
set Decimal_Cero    		:= 0.00;
set DesContableBanco		:= 'DEPOSITO  CHEQUE SBC';
set AltaEncPolizaSI			:= 'S';
set concepContaDepBancos	:= 42;
set NatContaCargo			:='C';
set AltaMovAhorroSI			:= 'S';
set tipoMovAbonoCuenta		:= 23;
set NatContaAhorro			:='A';
set Abono					:='A';
set SalidaSI				:='S';
set SalidaNO				:='N';

set DesMovCuentaBanco		:='DEPOSITO CHEQUE SBC';
set NoConciliado			:='N';
set RegistroPantalla		:='P';

set Act_AplicaCheque		:=1;
set Cadena_Vacia			:='';
set TipoMovTeso				:= 132;

set Est_Aplicado			:='A';
set Est_Cancelado			:='C'  ;
set Est_Activa				:='A';
set FormaAplicacion			:='D';
set DescripconCargo			:='DCTOS  DE COBRO INMEDIATO SALVO BUEN COBRO COD';
set DescripconAbono			:='DCTOS  DE COBRO INMEDIATO SALVO BUEN COBRO COA';
set Procedimiento			:='CHEQUESBCDEPBANPRO';
set ConsecutivoCero			:=0;
set SI						:='S';
Set TipoInstrumentoID		:= 9;
Set For_SucOrigen			:='&SO';
Set For_SucCliente			:='&SC';
set Var_CentroCostosID		:=0;


ManejoErrores: BEGIN

	set Aud_FechaActual := now();
	set Par_NumErr  := Entero_Cero;
	set Par_ErrMen  := Cadena_Vacia;

	set Var_FechaOper   := (select FechaSistema
                            from PARAMETROSSIS);
	call DIASFESTIVOSCAL(
				Var_FechaOper,	Entero_Cero,		    Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
				Aud_Usuario,	Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);


	if exists(select ChequeSBCID
					from ABONOCHEQUESBC
					where ChequeSBCID=Par_ChequeSBCID
						and Estatus=Est_Aplicado)then
			set Par_NumErr :=1;
			set Par_ErrMen := concat('El Cheque fue depositado en una operacion anterior ');
			set Var_Control :='chequeSBCID';
			LEAVE ManejoErrores;
	end if;

	if exists(select ChequeSBCID
					from ABONOCHEQUESBC
					where ChequeSBCID=Par_ChequeSBCID
						and Estatus=Est_Cancelado)then
			set Par_NumErr :=2;
			set Par_ErrMen := concat('El Cheque se encuentra cancelado ');
			set Var_Control :='chequeSBCID';
			LEAVE ManejoErrores;
	end if;


select Monto, CuentaAhoID,ClienteID,NumCheque
		into Var_Monto,Var_CuentaAhoID, Var_ClienteID, Var_Numcheque
			from ABONOCHEQUESBC
				where ChequeSBCID = Par_ChequeSBCID;

	if(ifnull(Par_ChequeSBCID,Entero_Cero) = Entero_Cero )then
			set Par_NumErr :=3;
			set Par_ErrMen := concat('El numero de cheque esta vacio ');
			set Var_Control :='chequeSBCID';
			LEAVE ManejoErrores;

	end if;
	if(ifnull(Var_Monto,Entero_Cero) <= Entero_Cero )then
			set Par_NumErr :=4;
			set Par_ErrMen := concat('El monto del cheque esta vacio ');
			set Var_Control :='cuentaAhoID';
			LEAVE ManejoErrores;

	end if;

	if(ifnull(Par_InstitucionID,Entero_Cero) <= Entero_Cero )then
			set Par_NumErr :=5;
			set Par_ErrMen := concat('La institucion esta vacia ');
			set Var_Control :='bancoAplica';
			LEAVE ManejoErrores;

	end if;
	if(ifnull(Par_CuentaBancos,Cadena_Vacia) = Cadena_Vacia )then
			set Par_NumErr :=6;
			set Par_ErrMen := concat('La Cuenta de Banco esta vacia ');
			set Var_Control :='cuentaBancoAplica';
			LEAVE ManejoErrores;

	end if;

	if(ifnull(Var_CuentaAhoID,Entero_Cero) = Entero_Cero )then
			set Par_NumErr :=7;
			set Par_ErrMen := concat('La cuenta de Ahorro esta vacia ');
			set Var_Control :='cuentaAhoID';
			LEAVE ManejoErrores;

	end if;
	if(ifnull(Var_ClienteID,Entero_Cero) = Entero_Cero )then
			set Par_NumErr :=8;
			set Par_ErrMen := concat('El numero de cliente esta vacio ');
			set Var_Control :='cuentaAhoID';
			LEAVE ManejoErrores;

	end if;


	if exists(select Estatus
			from CUENTASAHOTESO
				where Estatus != Est_Activa
					and CuentaAhoID = Par_CuentaBancos)then
			set Par_NumErr :=9;
			set Par_ErrMen := concat('La cuenta ',Par_CuentaBancos, ' no se encuentra activa');
			set Var_Control :='cuentaBancoAplica';
			LEAVE ManejoErrores;
	end if;

	if exists(select Estatus
				from CUENTASAHO
					where Estatus != Est_Activa
						and CuentaAhoID=Var_CuentaAhoID)then
				set Par_NumErr :=10;
				set Par_ErrMen := concat('La cuenta ',Var_CuentaAhoID, ' no se encuentra activa');
			set Var_Control :='cuentaAhoID';
				LEAVE ManejoErrores;
		end if;


	if not exists(select NumCtaInstit
					from CUENTASAHOTESO
					where InstitucionID = Par_InstitucionID
						and NumCtaInstit = Par_CuentaBancos)then
				set Par_NumErr :=11;
				set Par_ErrMen := concat('La cuenta no pertenece a la institucion especificada ');
				set Var_Control :='cuentaBancoAplica';
				LEAVE ManejoErrores;
	end if;

	select MonedaID into Var_MonedaID
		from CUENTASAHO
			where CuentaAhoID = Var_CuentaAhoID;

set Var_MonedaID := ifnull(Var_MonedaID,Entero_Cero);


	update CUENTASAHO set
			SaldoSBC = SaldoSBC - Var_Monto,

			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

			where CuentaAhoID=Var_CuentaAhoID;


	call ABONOCHEQUESBCACT(
					Par_ChequeSBCID,	Var_FechaOper,	Par_InstitucionID, FormaAplicacion,		Par_CuentaBancos,
					Act_AplicaCheque,	SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);



	select  CuentaCompletaID, CuentaAhoID, CentroCostoID into
				Var_CuentaBancos, Var_CuentaTesoAhoID, Var_CentroCosto
		from CUENTASAHOTESO
		where InstitucionID = Par_InstitucionID
		  and NumCtaInstit  = Par_CuentaBancos;

	 call TESORERIAMOVSALT(
			Var_CuentaTesoAhoID,	Var_FechaOper,		Var_Monto,			DesMovCuentaBanco,	concat("CHEQUE:",Var_Numcheque),
			NoConciliado,			NatContaAhorro,		RegistroPantalla,	TipoMovTeso,		Aud_NumTransaccion,
			SalidaNO,				Par_NumErr,         Par_ErrMen,			Entero_Cero,		Par_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);


	set Var_Poliza := 0;
	set Entero_Cero	:=0;
	call CONTATESORERIAPRO(
		Par_SucOperacion,	Var_MonedaID,		Par_InstitucionID,  Par_CuentaBancos,		Entero_Cero,
		Entero_Cero,        Entero_Cero,        Var_FechaOper,		Var_FechaApl,       	Var_Monto,
		DesContableBanco,	Var_Numcheque,		Par_CuentaBancos,	AltaEncPolizaSI,     	Var_Poliza,
		concepContaDepBancos,Entero_Cero,		NatContaCargo,		AltaMovAhorroSI,     	Var_CuentaAhoID,
		Var_ClienteID,      tipoMovAbonoCuenta,	NatContaAhorro,		Par_NumErr,				Par_ErrMen,
		Entero_Cero,        Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,   		Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);


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
			where ClienteID = Var_ClienteID
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

	if(Var_AfectaContaRecSBC = SI)then


		call DETALLEPOLIZAALT (
			Par_EmpresaID,			Var_Poliza,			Var_FechaOper,		Var_CentroCostosID,	Var_CtaContaDocSBCD,
			Var_Numcheque,			Var_MonedaBaseID,	Entero_Cero,		Var_Monto,			DescripconCargo,
			Par_CuentaBancos, 		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia, 			SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
		);

		call DETALLEPOLIZAALT (
			Par_EmpresaID,		Var_Poliza,			Var_FechaOper,		Var_CentroCostosID,	Var_CtaContaDocSBCA,
			Var_Numcheque,		Var_MonedaBaseID,	Var_Monto,			Entero_Cero,		DescripconAbono,
			Par_CuentaBancos,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia, 		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);
	end if;

	set Entero_Cero:=0;
	call SALDOSCTATESOACT(
		Par_CuentaBancos,	Par_InstitucionID,	Var_Monto,			Abono,			SalidaNO,
		Par_NumErr,         Par_ErrMen,         ConsecutivoCero,		Par_EmpresaID,  Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

	set Par_NumErr :=0;
	set Par_ErrMen := "Cheque abonado correctamente:";
	set Var_Control :='cuentaAhoID';

END ManejoErrores;
 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Var_CuentaAhoID as consecutivo;
end if;

END TerminaStore$$