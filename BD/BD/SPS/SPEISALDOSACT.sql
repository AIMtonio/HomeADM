-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEISALDOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEISALDOSACT`;DELIMITER $$

CREATE PROCEDURE `SPEISALDOSACT`(
    Par_EmpresaID          int(11),
	Par_SaldoActual        decimal(16,2),
    Par_SaldoReservado     decimal(16,2),
    Par_MontoDisponible    decimal(16,2),
    Par_BalanceCuenta      decimal(16,2),
    Par_NumAct			   tinyint unsigned,

	Par_Salida			   char(1),
    inout Par_NumErr 	   int,
    inout Par_ErrMen	   varchar(400),

	Aud_Usuario			   int(11),
	Aud_FechaActual		   DateTime,
	Aud_DireccionIP		   varchar(20),
	Aud_ProgramaID		   varchar(50),
	Aud_Sucursal		   int(11),
	Aud_NumTransaccion	   bigint(20)
)
TerminaStore:BEGIN

DECLARE Var_Control	        varchar(200);
DECLARE	Var_Estatus			char(1);


DECLARE Cadena_Vacia		char(1);
DECLARE Entero_Cero			int;
DECLARE Decimal_Cero		decimal;
DECLARE SalidaSI			char(1);
DECLARE	SalidaNO			char(1);
DECLARE Act_SaldoAct        int;
DECLARE Act_SaldoRes        int;
DECLARE Act_MontoDis        int;
DECLARE Act_BalanceCta      int;



Set Cadena_Vacia		:='';
Set Entero_Cero			:=0;
Set Decimal_Cero		:=0.0;
Set SalidaSI			:='S';
Set SalidaNO			:='N';
Set	Par_NumErr			:= 0;
Set	Par_ErrMen			:= '';
Set Act_SaldoAct        :=1;
Set Act_SaldoRes        :=2;
Set Act_MontoDis        :=3;
Set Act_BalanceCta      :=4;


ManejoErrores:BEGIN

if(Par_NumAct = Act_SaldoAct)then

update SPEISALDOS set
     SaldoActual        = Par_SaldoActual,

	 Usuario        	= Aud_Usuario,
	 FechaActual    	= Aud_FechaActual,
	 DireccionIP    	= Aud_DireccionIP,
	 ProgramaID     	= Aud_ProgramaID,
	 Sucursal	   		= Aud_Sucursal,
	 NumTransaccion 	= Aud_NumTransaccion
where EmpresaID         = Par_EmpresaID;

	set Par_NumErr	:= 000;
	set Par_ErrMen	:= concat("Saldo Actual Actualizado Exitosamente");
	set Var_Control	:= 'numero' ;

end if;

if(Par_NumAct = Act_SaldoRes)then

update SPEISALDOS set
     SaldoReservado     = Par_SaldoReservado,
	 Usuario        	= Aud_Usuario,
	 FechaActual    	= Aud_FechaActual,
	 DireccionIP    	= Aud_DireccionIP,
	 ProgramaID     	= Aud_ProgramaID,
	 Sucursal	   		= Aud_Sucursal,
	 NumTransaccion 	= Aud_NumTransaccion
where EmpresaID         = Par_EmpresaID;

	set Par_NumErr	:= 000;
	set Par_ErrMen	:= concat("Saldo Reservado Actualizado Exitosamente");
	set Var_Control	:= 'numero' ;

end if;

if(Par_NumAct = Act_MontoDis)then

update SPEISALDOS set
     MontoDisponible    = Par_MontoDisponible,
	 Usuario        	= Aud_Usuario,
	 FechaActual    	= Aud_FechaActual,
	 DireccionIP    	= Aud_DireccionIP,
	 ProgramaID     	= Aud_ProgramaID,
	 Sucursal	   		= Aud_Sucursal,
	 NumTransaccion 	= Aud_NumTransaccion
where EmpresaID         = Par_EmpresaID;

	set Par_NumErr	:= 000;
	set Par_ErrMen	:= concat("Monto Disponible Actualizado Exitosamente");
	set Var_Control	:= 'numero' ;

end if;

if(Par_NumAct = Act_BalanceCta)then

update SPEISALDOS set
     BalanceCuenta      = Par_BalanceCuenta,
	 Usuario        	= Aud_Usuario,
	 FechaActual    	= Aud_FechaActual,
	 DireccionIP    	= Aud_DireccionIP,
	 ProgramaID     	= Aud_ProgramaID,
	 Sucursal	   		= Aud_Sucursal,
	 NumTransaccion 	= Aud_NumTransaccion
where EmpresaID         = Par_EmpresaID;

	set Par_NumErr	:= 000;
	set Par_ErrMen	:= concat("Balance de Cuenta Actualizado Exitosamente");
	set Var_Control	:= 'numero' ;

end if;

END ManejoErrores;
if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control as control,
			Entero_Cero as consecutivo;
end if;
END  TerminaStore$$