-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCAJEROSATMACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCAJEROSATMACT`;DELIMITER $$

CREATE PROCEDURE `CATCAJEROSATMACT`(
	Par_CajeroID			varchar(20),
	Par_NumAct				tinyint unsigned,

    Par_Salida				char(1),
out Par_NumErr				int,
out Par_ErrMen				varchar(200),

    Par_EmpresaID			int(11),
    Aud_Usuario				int(11),
    Aud_FechaActual			DateTime,
    Aud_DireccionIP			varchar(15),
    Aud_ProgramaID			varchar(50),
    Aud_Sucursal			int,
    Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

DECLARE Var_Control		varchar(50);


DECLARE ActualizaInativa	int;
DECLARE EstatusInactivo		char(1);
DECLARE Decimal_Cero		decimal;
DECLARE EstatusEnviado		char(1);
DECLARE SalidaSI			char(1);

set ActualizaInativa		:=1;
set EstatusInactivo			:='I';
set Decimal_Cero			:=0.0;
set EstatusEnviado			:='E';
set SalidaSI				:='S';
ManejoErrores:BEGIN


if (ActualizaInativa = Par_NumAct)then
	if exists(select CajeroID
				from CATCAJEROSATM
				where CajeroID = Par_CajeroID
				and (SaldoMN > Decimal_Cero
						or SaldoME > Decimal_Cero))then

			set Par_NumErr :=1;
			set Par_ErrMen := concat("El Cajero ",Par_CajeroID," aun tiene Saldo Disponible. ");
			set Var_Control:='cajeroID';
			LEAVE ManejoErrores;

	end if;
	if exists(select CajeroDestinoID
					from CAJEROATMTRANSF
					where CajeroDestinoID = Par_CajeroID
					and Estatus		= EstatusEnviado)then
			set Par_NumErr :=2;
			set Par_ErrMen := concat("El Cajero ",Par_CajeroID," tiene Transferencias Pendientes de Recibir. ");
			set Var_Control:='cajeroID';
			LEAVE ManejoErrores;
	end if;

	update CATCAJEROSATM set
			Estatus		= EstatusInactivo,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		where CajeroID = Par_CajeroID;

			set Par_NumErr :=0;
			set Par_ErrMen := concat("Cajero Cancelado Exitosamente ", Par_CajeroID) ;
			set Var_Control:='cajeroID';
end if;

END ManejoErrores;
	if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				Var_Control as control,
				Par_CajeroID as consecutivo;
	end if;
END TerminaStore$$