-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPLINEASCREDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPLINEASCREDACT`;DELIMITER $$

CREATE PROCEDURE `TMPLINEASCREDACT`(


	Par_LineaCreditoID 	char(12),
	Par_Autorizado		decimal(12,2),
	Par_Fecha			date,
	Par_Usuario			int,
	Par_Motivo			text,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint,
	out NumErr			int,
	out ErrMen			varchar(100)
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Act_Autoriza			int;
DECLARE	Act_Bloqueo			int;
DECLARE	Act_Desbloqueo		int;
DECLARE	Act_Cancelacion		int;
DECLARE	Estatus_Autorizada	char(1);
DECLARE	Estatus_Inactiva		char(1);
DECLARE	Estatus_Bloqueada		char(1);
DECLARE Estatus_Cancelada		char(1);
DECLARE 	Var_Estatus			char(1);
DECLARE	Var_SaldoDispuesto	decimal(12,2);

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Act_Autoriza		:= 1;
Set Act_Bloqueo		:= 2;
Set Act_Desbloqueo	:= 3;
Set Act_Cancelacion	:= 4;
Set	Estatus_Autorizada	:= 'A';
Set	Estatus_Inactiva		:= 'I';
Set	Estatus_Bloqueada		:= 'B';
Set	Estatus_Cancelada		:= 'C';
Set Aud_FechaActual := CURRENT_TIMESTAMP();


if(not exists(select LineaCreditoID
			from LINEASCREDITO
			where LineaCreditoID = Par_LineaCreditoID)) then
	set NumErr := 1 ;
	set ErrMen := 'El Numero de Linea de credito no existe.' ;
	LEAVE TerminaStore;
end if;

set Var_Estatus := (select Estatus from LINEASCREDITO where LineaCreditoID = Par_LineaCreditoID);


if(Var_Estatus = Estatus_Autorizada) then
set NumErr := 2 ;
set ErrMen :=  'La Cuenta ya estaba Autorizada.' ;
LEAVE TerminaStore;
end if;

if(Var_Estatus = Estatus_Inactiva) then
	update LINEASCREDITO set
		Autorizado		= Par_Autorizado,
		FechaAutoriza		= Par_Fecha,
		UsuarioAutoriza	= Par_Usuario,
		Estatus			= Estatus_Autorizada,
		SaldoDisponible	= Par_Autorizado,

		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 		= Aud_FechaActual,
		DireccionIP 		= Aud_DireccionIP,
		ProgramaID  		= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	where LineaCreditoID 	= Par_LineaCreditoID;
	set NumErr :=  0 ;
	set ErrMen := 'Linea de credito Autorizada' ;
else
set NumErr := 2 ;
set ErrMen :=  'La Cuenta no se puede Autorizar.' ;
end if;


END TerminaStore$$