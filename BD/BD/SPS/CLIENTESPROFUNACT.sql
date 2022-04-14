-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESPROFUNACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESPROFUNACT`;DELIMITER $$

CREATE PROCEDURE `CLIENTESPROFUNACT`(

	Par_ClienteID			int,
	Par_FechaCancela		date,
	Par_UsuarioCan			int(11),
	Par_SucursalCan			int(11),
	Par_NumAct				tinyint unsigned,

	Par_Salida				char(1),
	inout	Par_NumErr 		int,
	inout	Par_ErrMen  	varchar(350),
	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),

	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN


DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE Decimal_Cero		decimal(12,2);
DECLARE Salida_SI			char(1);

DECLARE Salida_NO			char(1);
DECLARE Est_Registrado		char(1);
DECLARE Est_Cancelado		char(1);
DECLARE Est_Pagado			char(1);
DECLARE Est_Inactivo		char(1);
DECLARE Var_SI				char(1);

DECLARE Act_Cancelar		int;
DECLARE Act_Aplicacion		int;
DECLARE Act_CancelaCli		int;


DECLARE Var_ClienteID		int(11);
DECLARE Var_PolizaID		bigint;
DECLARE Var_Control			char(15);
DECLARE Var_Estatus			char(1);
DECLARE Var_MontoPendiente	decimal(12,2);


set	Cadena_Vacia		:= '';
set	Fecha_Vacia			:= '1900-01-01';
set	Entero_Cero			:= 0;
set	Decimal_Cero		:= 0.0;
set Salida_SI			:= 'S';

set Salida_NO			:= 'N';
set Est_Registrado		:= 'R';
set Est_Cancelado		:= 'C';
set Est_Pagado			:= 'P';
set Est_Inactivo		:= 'I';
set Var_SI				:= 'S';

set Act_Cancelar		:= 1;
set Act_Aplicacion		:= 2;
set Act_CancelaCli		:= 3;


set Aud_FechaActual		:= now();

ManejoErrores:BEGIN

	if(ifnull(Par_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 01;
		set Par_ErrMen   := 'El Cliente esta Vacio';
		LEAVE ManejoErrores;
	end if;

	set Var_ClienteID := (select ClienteID from CLIENTES where ClienteID = Par_ClienteID);
    if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 02;
        set Par_ErrMen   := 'El Cliente no Existe';
        LEAVE ManejoErrores;
    end if;

	set Var_ClienteID := (select ClienteID from CLIENTESPROFUN where ClienteID = Par_ClienteID);
	if(ifnull(Var_ClienteID, Entero_Cero) = Entero_Cero) then
		set Par_NumErr   := 03;
        set Par_ErrMen   := 'El Cliente no esta Registrado en PROFUN';
        LEAVE ManejoErrores;
    end if;


	if (Par_NumAct = Act_Cancelar)then
		set Var_Estatus := (select Estatus from CLIENTESPROFUN where ClienteID = Par_ClienteID);
		set Var_Estatus := ifnull(Var_Estatus, Cadena_Vacia);
		if(Var_Estatus = Est_Cancelado) then
		   	set Par_NumErr   := 04;
			set Par_ErrMen   := 'El Registro ya Esta Cancelado.';
			LEAVE ManejoErrores;
		end if;

		if(Var_Estatus != Est_Registrado ) then
			if(Var_Estatus != Est_Inactivo ) then
				set Par_NumErr   := 05;
				set Par_ErrMen   := 'El Cliente no Puede Cancelar su Registro.';
				LEAVE ManejoErrores;
			end if;
		end if;

		if(ifnull(Par_FechaCancela, Fecha_Vacia) = Fecha_Vacia) then
			set Par_NumErr   := 06;
			set Par_ErrMen   := 'La Fecha de Cancelacion esta Vacia';
			LEAVE ManejoErrores;
		end if;

		if(ifnull(Par_UsuarioCan, Entero_Cero) = Entero_Cero) then
			set Par_NumErr   := 07;
			set Par_ErrMen   := 'El Usuario que Cancela esta Vacio';
			LEAVE ManejoErrores;
		end if;


		set Var_MontoPendiente := (select MontoPendiente from CLICOBROSPROFUN where ClienteID = Par_ClienteID);
		set Var_MontoPendiente := ifnull(Var_MontoPendiente, Decimal_Cero);

		if(Var_MontoPendiente > Decimal_Cero)then

			call CLICOBROSPROFUNPRO(
				Par_ClienteID,		Par_FechaCancela,	Var_MontoPendiente,		Var_SI,				Salida_NO,
				Par_NumErr,			Par_ErrMen,			Var_PolizaID,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


			if(Par_NumErr <> Entero_Cero)then
				LEAVE ManejoErrores;
			end if;

			set Var_MontoPendiente := (select MontoPendiente from CLICOBROSPROFUN where ClienteID = Par_ClienteID);
			set Var_MontoPendiente := ifnull(Var_MontoPendiente, Decimal_Cero);

			if(Var_MontoPendiente > Decimal_Cero)then
				set Par_NumErr	:= '008';
				set Par_ErrMen	:= concat('El Socio Tiene Monto Pendiente de Pago por Mutuales, <br>favor de pasar a ventanilla a realizar un abono a cuenta por: $ ',
										convert(format(Var_MontoPendiente,2),char));
				set Var_Control	:= 'clienteID' ;
				LEAVE ManejoErrores;
			end if;
		end if;

		call CLICOBROSPROFUNACT(
			Par_ClienteID,		Par_FechaCancela,	Decimal_Cero,		Act_CancelaCli,		Salida_NO,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


		if(Par_NumErr <> Entero_Cero)then
			LEAVE ManejoErrores;
		end if;


		update CLIENTESPROFUN set
			FechaCancela    = Par_FechaCancela,
			UsuarioCan      = Par_UsuarioCan,
			SucursalCan		= Par_SucursalCan,
			Estatus         = Est_Cancelado,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		where ClienteID = Par_ClienteID;

		set Par_NumErr	:= '000';
        set Par_ErrMen	:= 'Registro PROFUN Cancelado Exitosamente.';
        set Var_Control	:= 'clienteID' ;
    end if;


    if(Par_NumAct = Act_Aplicacion) then
		update CLIENTESPROFUN set
			Estatus			= Est_Pagado,
			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		where ClienteID		= Par_ClienteID;

        set Par_NumErr  := '000';
        set Par_ErrMen  := 'La Solicitud ha sido Pagada .';
        set Var_Control  := 'clienteID' ;
	end if;

END ManejoErrores;

if (Par_Salida = Salida_SI) then
	select	convert(Par_NumErr, CHAR(3)) as NumErr,
			Par_ErrMen				as ErrMen,
			Var_Control				as control,
			Par_ClienteID			as consecutivo;
end IF;

END TerminaStore$$