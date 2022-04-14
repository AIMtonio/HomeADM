-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIENTEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIENTEACT`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIENTEACT`(
	Par_SeguroClienteID	int(11),
	Par_ClienteID       	int(11),
	Par_MontoSeguro     	decimal(14,2),

	Par_NumAct          tinyint unsigned,
	Par_MotivoCamEst			int(11),

	Par_Observacion		varchar(200),
	Par_ClaveAutoriza				varchar(45),

	Par_Salida          char(1),
	out Par_NumErr          int,
	out Par_ErrMen          varchar(200),

	Par_EmpresaID       int(11),
	Aud_Usuario         int(11),
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int,
	Aud_NumTransaccion  bigint
	)
Terminastore:BEGIN

DECLARE Var_MontoSeguroA	decimal;
DECLARE Var_MontoSegPagado	decimal;
DECLARE Var_EstatusSeguro		char(1);


DECLARE Cadena_Vacia        char(1);
DECLARE Entero_Cero         int;
DECLARE SalidaSI        	char(1);
DECLARE SalidaNO        	char(1);
DECLARE Sta_Vigente         char(1);
DECLARE Sta_Cobrado			char(1);
DECLARE Sta_Cancelado			char(1);
DECLARE Sta_Vencido			char(1);
DECLARE Act_Siniest         int;
DECLARE Act_CancSeg         int;
DECLARE Act_VenCli         int;
DECLARE Decimal_Cero		decimal;


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
set SalidaSI        := 'S';
set SalidaNO        := 'N';
set Sta_Vigente     := 'V';
set Sta_Cobrado     := 'C';
set Sta_Cancelado     := 'K';
set Sta_Vencido     := 'B';

set Act_Siniest     := 2;
set Decimal_Cero	:=0.0;
set Act_VenCli     := 3;
set Act_CancSeg     := 4;

	ManejoErrores:BEGIN

	set Par_NumErr  := Entero_Cero;
	set Par_ErrMen  := Cadena_Vacia;


	set Aud_FechaActual := CURRENT_TIMESTAMP();

	if(Par_NumAct = Act_Siniest)then
		if exists(select ClienteID
					from SEGUROCLIENTE
					where ClienteID		=	Par_ClienteID
					and SeguroClienteID	=	Par_SeguroClienteID
					and Estatus=Sta_Cobrado)then
				set Par_NumErr :=1;
				set Par_ErrMen := "Seguro de Ayuda ya fue Cobrado .";
				LEAVE ManejoErrores;
		end if;
		update SEGUROCLIENTE set
			Estatus			=Sta_Cobrado,

			EmpresaID       = Par_EmpresaID,
			Usuario         =  Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
			where ClienteID = Par_ClienteID;

			set Par_NumErr :=0;
			set Par_ErrMen := "Seguro de Ayuda actualizado correctamente .";
	end if;

	if(Par_NumAct = Act_VenCli)then
		if exists(select ClienteID
					from SEGUROCLIENTE
					where ClienteID		=	Par_ClienteID
					and SeguroClienteID	=	Par_SeguroClienteID
					and Estatus=Sta_Vencido)then
				set Par_NumErr :=1;
				set Par_ErrMen := "Seguro de Ayuda ya Esta Vencido .";
				LEAVE ManejoErrores;
		end if;
		update SEGUROCLIENTE set
			Estatus			=Sta_Vencido,

			EmpresaID       = Par_EmpresaID,
			Usuario         =  Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
			where ClienteID = Par_ClienteID
			and SeguroClienteID	=	Par_SeguroClienteID;

			set Par_NumErr :=0;
			set Par_ErrMen := "Seguro de Ayuda actualizado correctamente .";
	end if;

	if(Par_NumAct = Act_CancSeg)then
	select Estatus into Var_EstatusSeguro
					from SEGUROCLIENTE
					where ClienteID		=	Par_ClienteID
					and SeguroClienteID	=	Par_SeguroClienteID;

	set Var_EstatusSeguro := ifnull(Var_EstatusSeguro,Cadena_Vacia);



		if (Var_EstatusSeguro = Sta_Cancelado)then
				set Par_NumErr :=1;
				set Par_ErrMen := "Seguro de Ayuda ya Esta Cancelado .";
				LEAVE ManejoErrores;
		end if;

		if (Var_EstatusSeguro != Sta_Vigente) then
				set Par_NumErr :=2;
				set Par_ErrMen := "Solo se puede Cancelar Seguros de Vida Vigentes.";
				LEAVE ManejoErrores;
		end if;

		update SEGUROCLIENTE set
			Estatus			=Sta_Cancelado,
			MotivoCamEst		=Par_MotivoCamEst,
			Observacion		=Par_Observacion,
			ClaveAutoriza		=Par_ClaveAutoriza,

			EmpresaID       = Par_EmpresaID,
			Usuario         =  Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
			where ClienteID = Par_ClienteID
			and SeguroClienteID	=	Par_SeguroClienteID;

			set Par_NumErr :=0;
			set Par_ErrMen := "Seguro de Ayuda actualizado correctamente .";
	end if;

	END ManejoErrores;
		if (Par_Salida = SalidaSI) then
			select  Par_NumErr as NumErr,
					Par_ErrMen as ErrMen,
					'seguroClienteID' as control,
					Entero_Cero as consecutivo;
		end if;
END TerminaStore$$