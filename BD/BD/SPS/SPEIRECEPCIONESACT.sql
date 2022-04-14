-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIRECEPCIONESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIRECEPCIONESACT`;DELIMITER $$

CREATE PROCEDURE `SPEIRECEPCIONESACT`(



    Par_NumRecep           bigint(20),
	Par_ClaveRastreo	   varchar(30),
    Par_EstatusRecep       int(3),
    Par_CausaDevol         int(2),
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
DECLARE	Act_Recibida  		int;
DECLARE Act_FechaOpe        int;
DECLARE Act_Devol           int;
DECLARE Estatus_A           char(1);
DECLARE Repor_SI            char(1);


Set Cadena_Vacia		:='';
Set Entero_Cero			:=0;
Set Decimal_Cero		:=0.0;
Set SalidaSI			:='S';
Set SalidaNO			:='N';
Set	Par_NumErr			:= 0;
Set	Par_ErrMen			:= '';
Set Act_Recibida        := 1;
Set Act_FechaOpe        := 2;
Set Act_Devol           := 3;
Set Estatus_A           := 'A';
Set Repor_SI            := 'S';


ManejoErrores:BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr = '999';
					SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
											 'estamos trabajando para resolverla. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-SPEIRECEPCIONESACT');
					SET Var_Control = 'sqlException' ;
				END;



if(ifnull(Par_ClaveRastreo,Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr := 001;
	set Par_ErrMen := 'La Clave de Rastreo esta Vacia.';
	set Var_Control:=  'claveRastreo' ;
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_EstatusRecep,Entero_Cero)) = Entero_Cero then
	set Par_NumErr := 002;
	set Par_ErrMen := 'El estatus de recepcion esta Vacio.';
	set Var_Control:=  'estatusRecep' ;
	LEAVE ManejoErrores;
end if;


set Aud_FechaActual := CURRENT_TIMESTAMP();

set Var_Estatus := (select Estatus from SPEIRECEPCIONES where FolioSpeiRecID = Par_NumRecep);


if(Par_NumAct = Act_Recibida )then
	update  SPEIRECEPCIONES set
			EstatusRecep   = Par_EstatusRecep,
			Estatus        = Estatus_A,
			RepOperacion   = Repor_SI,

			EmpresaID	   = Par_EmpresaID,
			Usuario        = Aud_Usuario,
			FechaActual    = Aud_FechaActual,
			DireccionIP    = Aud_DireccionIP,
			ProgramaID     = Aud_ProgramaID,
			Sucursal	   = Aud_Sucursal,
			NumTransaccion = Aud_NumTransaccion
	where ClaveRastreo = Par_ClaveRastreo;

	set	Par_NumErr 	:= 000;
	set	Par_ErrMen	:= concat('SPEI ',Par_ClaveRastreo,' Recibido Exitosamente');
	set Var_Control	:= 'claveRastreo';

end if;





if(Par_NumAct = Act_FechaOpe )then
	update  SPEIRECEPCIONES set
			FechaRecepcion = CURRENT_TIMESTAMP(),

			EmpresaID	   = Par_EmpresaID,
			Usuario        = Aud_Usuario,
			FechaActual    = Aud_FechaActual,
			DireccionIP    = Aud_DireccionIP,
			ProgramaID     = Aud_ProgramaID,
			Sucursal	   = Aud_Sucursal,
			NumTransaccion = Aud_NumTransaccion
	where ClaveRastreo = Par_ClaveRastreo;

	set	Par_NumErr 	:= 000;
	set	Par_ErrMen	:= concat('SPEI ',Par_ClaveRastreo,' Actualizado Exitosamente');
	set Var_Control	:= 'claveRastreo';

end if;



if(Par_NumAct = Act_Devol )then
	update  SPEIRECEPCIONES set

			EstatusRecep   = Par_EstatusRecep,
			CausaDevol     = Par_CausaDevol,

			EmpresaID	   = Par_EmpresaID,
			Usuario        = Aud_Usuario,
			FechaActual    = Aud_FechaActual,
			DireccionIP    = Aud_DireccionIP,
			ProgramaID     = Aud_ProgramaID,
			Sucursal	   = Aud_Sucursal,
			NumTransaccion = Aud_NumTransaccion
	where ClaveRastreo = Par_ClaveRastreo;

	set	Par_NumErr 	:= 000;
	set	Par_ErrMen	:= concat('SPEI ',Par_ClaveRastreo,' Actualizado Exitosamente');
	set Var_Control	:= 'claveRastreo';

end if;



END ManejoErrores;
if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			Var_Control as control,
			Entero_Cero as consecutivo;
end if;
END  TerminaStore$$