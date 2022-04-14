-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCUENTASAHOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCUENTASAHOACT`;DELIMITER $$

CREATE PROCEDURE `TMPCUENTASAHOACT`(
	Par_CuentaAhoID		bigint(12),
	Par_UsuarioID		int,
	Par_Fecha			date,
	Par_Motivo			varchar(100),
	Par_NumAct			tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Act_Apertura		int;
DECLARE	Act_Bloqueo			int;
DECLARE	Act_Cancelacion		int;
DECLARE	Act_Desbloqueo		int;
DECLARE	Estatus_Activa		char(1);
DECLARE	Estatus_Bloqueada	char(1);
DECLARE	Estatus_Cancelada	char(1);
DECLARE	Estatus_Desbloqueada	char(1);
DECLARE	Estatus_Registrada	char(1);
DECLARE 	Var_Estatus			char(1);

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Act_Apertura		:= 1;
Set	Act_Bloqueo			:= 2;
Set	Act_Desbloqueo		:= 3;
Set	Act_Cancelacion		:= 4;
Set	Estatus_Activa		:= 'A';
Set	Estatus_Bloqueada	:= 'B';
Set	Estatus_Desbloqueada	:= 'A';
Set	Estatus_Cancelada	:= 'C';
Set	Estatus_Registrada	:= 'R';
Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(not exists(select CuentaAhoID
			from CUENTASAHO
			where CuentaAhoID = Par_CuentaAhoID)) then
	select '001' as NumErr,
		 'El Numero de Cuenta no existe.' as ErrMen,
		 'cuentaAhoID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_CuentaAhoID, Entero_Cero))= Entero_Cero then
	select '002' as NumErr,
		 'El numero de Cuenta de Ahorro esta Vacio.' as ErrMen,
		 'cuentaAhoID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_UsuarioID, Entero_Cero))= Entero_Cero then
	select '003' as NumErr,
		 'El numero de Usuario esta Vacio.' as ErrMen,
		 'usuarioID' as control;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_Fecha,Fecha_Vacia)) = Fecha_Vacia then
	select '004' as NumErr,
		 'La Fecha esta Vacia.' as ErrMen,
		 'fechaApertura' as control;
	LEAVE TerminaStore;
end if;



set Var_Estatus := (select Estatus from CUENTASAHO where CuentaAhoID = Par_CuentaAhoID);

if(Par_NumAct = Act_Apertura) then
	if(Var_Estatus = Estatus_Activa) then
	select '005' as NumErr,
		 'La Cuenta ya estaba Activada.' as ErrMen,
		 'cuentaAhoID' as control;
	LEAVE TerminaStore;
	end if;

	if(Var_Estatus = Estatus_Registrada) then
		update CUENTASAHO set
			UsuarioApeID	= Par_UsuarioID,
			FechaApertura	= Par_Fecha,
			Estatus		= Estatus_Activa,

			EmpresaID		= Aud_EmpresaID,
			Usuario		= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		where CuentaAhoID 	= Par_CuentaAhoID;
	end if;
end if;


END TerminaStore$$