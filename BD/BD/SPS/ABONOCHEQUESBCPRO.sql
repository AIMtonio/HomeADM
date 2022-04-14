-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCHEQUESBCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCHEQUESBCPRO`;DELIMITER $$

CREATE PROCEDURE `ABONOCHEQUESBCPRO`(

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


DECLARE SalidaNO			char(1);
DECLARE SalidaSI			char(1);
DECLARE Entero_Cero			int;
DECLARE cancelado			int;
DECLARE Cadena_Vacia		char;
DECLARE tipoMovCargoCuenta	int;
DECLARE Cargo				char(1);
DECLARE DescripcionMov		varchar(100);
DECLARE concepContaComFC	int;
DECLARE conceptoAhorro		int;
DECLARE AltaPoliza_SI		char(1);

DECLARE conceptoAhorroCom 		int;
DECLARE conceotoAhorroIVACom 	int;
DECLARE descripcionComision		varchar(100);
DECLARE descripcionIVAComision	varchar(100);



set SalidaNO				:='N';
set SalidaSI				:='S';
set Entero_Cero				:= 0;
set Cancelado				:=2;
set Cadena_Vacia			:='';

set tipoMovCargoCuenta		:= 204;
set Cargo					:='C';
set DescripcionMov			:='CARGO POR FALSO COBRO CHEQUE SBC';
set concepContaComFC		:= 41;
set conceptoAhorro 			:= 1;
set AltaPoliza_SI			:= 'S';



set conceptoAhorroCom 		:= 11;
set conceotoAhorroIVACom 	:= 12;
set descripcionComision		:='COMISION POR FALSO COBRO';
set descripcionIVAComision	:='IVA COMISION POR FALSO COBRO';

ManejoErrores: BEGIN

set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := Cadena_Vacia;
set Aud_FechaActual := now();

set Var_MontoTotalCargo:=Par_MontoComision + Par_MontoIVAComision;
set Var_MontoTotalCargo :=ifnull(Var_MontoTotalCargo,Entero_Cero);

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



call ABONOCHEQUESBCACT(
			Par_ChequeSBCID,	Var_FechaOper,		Cancelado,		SalidaNO,			Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

if (Par_NumErr <> Entero_Cero)then
	LEAVE ManejoErrores;
end if;



set Par_Poliza := Entero_Cero;
call CONTAAHORROPRO(
			Par_CuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaApl,
			Cargo,					Var_MontoTotalCargo,DescripcionMov,			Par_CuentaAhoID,	tipoMovCargoCuenta,
			Var_Monedas,			Var_SucCliente,		AltaPoliza_SI, 			concepContaComFC,	Par_Poliza,
			AltaPoliza_SI,		 	conceptoAhorro,		Cargo,					Par_NumErr,			Par_ErrMen,
			Entero_Cero,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);




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


	update CUENTASAHO set
		SaldoSBC 		= SaldoSBC - Par_MontoCheque,

		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

		where CuentaAhoID=Par_CuentaAhoID;

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'tipoOperacion' as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$