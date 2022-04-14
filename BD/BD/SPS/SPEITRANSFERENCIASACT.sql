-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEITRANSFERENCIASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEITRANSFERENCIASACT`;DELIMITER $$

CREATE PROCEDURE `SPEITRANSFERENCIASACT`(
    Par_SpeiTransID        bigint(20),
	Par_UsuarioAutoriza    int(11),
    Par_Transaccion        bigint(20),
    Par_NumAct			   tinyint unsigned,

	Par_Salida			   char(1),
    inout Par_NumErr 	   int,
    inout Par_ErrMen	   varchar(400),

	Par_EmpresaID		   int(11),
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
DECLARE Estatus_Reg         char(1);
DECLARE Estatus_Aut         char(1);
DECLARE Estatus_Pro         char(1);
DECLARE	Act_Autoriza  		int;


Set Cadena_Vacia		:='';
Set Entero_Cero			:=0;
Set Decimal_Cero		:=0.0;
Set SalidaSI			:='S';
Set SalidaNO			:='N';
Set	Par_NumErr			:= 0;
Set	Par_ErrMen			:= '';
Set Estatus_Reg         := 'P';
Set Estatus_Aut         := 'A';
Set Act_Autoriza        := 1;

ManejoErrores:BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = '999';
					SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
											 'estamos trabajando para resolverla. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-SPEITRANSFERENCIASACT');
					SET Var_Control = 'sqlException' ;
				END;



if(ifnull(Par_SpeiTransID,Entero_Cero)) = Entero_Cero then
	set Par_NumErr := 001;
	set Par_ErrMen := 'El numero de transferencia esta vacio';
	set Var_Control:=  'speiTransID' ;
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_Transaccion,Entero_Cero)) = Entero_Cero then
	set Par_NumErr := 002;
	set Par_ErrMen := 'El numero de transaccion esta Vacio.';
	set Var_Control:=  'transaccion' ;
	LEAVE ManejoErrores;
end if;

if not exists(select SpeiTransID
		from SPEITRANSFERENCIAS
		where SpeiTransID = Par_SpeiTransID)then
		set	Par_NumErr 	:= 003;
		set	Par_ErrMen	:= concat('La transferencia spei no existe.');
		set Var_Control	:= 'speiTransID';
		LEAVE ManejoErrores;
end if;

set Aud_FechaActual := CURRENT_TIMESTAMP();

set Var_Estatus := (select Estatus from SPEITRANSFERENCIAS where SpeiTransID = Par_SpeiTransID);



if(Par_NumAct = Act_Autoriza )then
	if(Var_Estatus = Estatus_Reg )then
		update  SPEITRANSFERENCIAS set
		Estatus        = Estatus_Aut,
        FechaAutoriza  = CURRENT_TIMESTAMP(),
		FechaProceso   = CURRENT_TIMESTAMP(),
		UsuarioAutoriza= Par_UsuarioAutoriza,
		Transaccion    = Par_Transaccion,

		EmpresaID	   = Par_EmpresaID,
		Usuario        = Aud_Usuario,
		FechaActual    = Aud_FechaActual,
		DireccionIP    = Aud_DireccionIP,
		ProgramaID     = Aud_ProgramaID,
		Sucursal	   = Aud_Sucursal,
		NumTransaccion = Aud_NumTransaccion

		where SpeiTransID = Par_SpeiTransID;

		set	Par_NumErr 	:= 000;
		set	Par_ErrMen	:= concat('Transferencia ',Par_SpeiTransID,' Autorizada Exitosamente');
		set Var_Control	:= 'SpeiTransID';
	else

		set	Par_NumErr 	:= 003;
		set	Par_ErrMen	:= concat('La transferencia esta en estatus:',Var_Estatus,' no puedo ser autorizada.');
		set Var_Control	:= 'SpeiTransID';

	end if;
end if;


END ManejoErrores;

if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control as control,
			Entero_Cero as consecutivo;
end if;
END  TerminaStore$$