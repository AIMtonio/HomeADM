-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTOREXTERNOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTOREXTERNOMOD`;DELIMITER $$

CREATE PROCEDURE `PROMOTOREXTERNOMOD`(

	Par_Numero		      int(11),
    Par_Nombre		      varchar(150),
	Par_Telefono		  varchar(20),
	Par_NumCelular		  varchar(20),
    Par_Correo            varchar(50),
    Par_Estatus           char(1),
	Par_ExtTelefono			varchar(7),

	Par_Salida          	char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Aud_EmpresaID			int,
	Aud_UsuarioID				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Var_Numero          int(11);
DECLARE Var_Control         varchar(100);


DECLARE Estatus_Activo     char(1);
DECLARE Estatus_Cancelado  char(1);
DECLARE Cadena_Vacia       char(1);
DECLARE Entero_Cero        int;
DECLARE SalidaSI           char(1);


Set Estatus_Activo     := 'A';
Set Estatus_Cancelado  := 'C';
Set Cadena_Vacia       := '';
Set Entero_Cero        := 0;
Set SalidaSI           := 'S';

ManejoErrores: BEGIN




	if(ifnull(Par_Nombre,Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 001;
        set Par_ErrMen  := 'El Nombre del Promotor esta Vacio';
        set Var_Control := 'nombre';
		LEAVE ManejoErrores;
	end if;


	if(ifnull(Par_Telefono,Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 002;
        set Par_ErrMen  := 'El Telefono del Promotor esta Vacio';
        set Var_Control := 'telefono';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_NumCelular, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 003;
        set Par_ErrMen  := 'El Celular del Promotor esta Vacio';
        set Var_Control := 'numCelular';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_Correo, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 004;
		set Par_ErrMen  := 'El Correo del Promotor esta Vacio';
		set Var_Control := 'correo';
		LEAVE ManejoErrores;
	end if;

	if(ifnull(Par_Estatus, Cadena_Vacia)) = Cadena_Vacia then
		set Par_NumErr  := 005;
		set Par_ErrMen  := 'El Estatus del Promotor no fue seleccionado';
		set Var_Control := 'estatus';
		LEAVE ManejoErrores;
	end if;

	Set Aud_FechaActual := CURRENT_TIMESTAMP();


	update PROMOTOREXTERNO  set

		Numero 		    = Par_Numero,
		Nombre  		= Par_Nombre,
		Telefono		= Par_Telefono,
		NumCelular		= Par_NumCelular,
		Correo 		    = Par_Correo,
		Estatus 		= Par_Estatus,
		ExtTelefono		= Par_ExtTelefono,
		EmpresaID		= Aud_EmpresaID,
		Usuario			= Aud_UsuarioID,
		FechaActual		= Aud_FechaActual,
		DireccionIP		= Aud_DireccionIP,
		ProgramaID		= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion 	= Aud_NumTransaccion

		where Numero= Par_Numero;

		Set Par_NumErr	:= '000';
		Set Par_ErrMen	:= concat('Promotor Externo Modificado Exitosamente: ', Par_Numero);
		Set Var_Control	:= 'numero';

	END ManejoErrores;

	select
		Par_NumErr as NumErr ,
		Par_ErrMen as ErrMen,
		Var_Control as control,
		Entero_Cero as consecutivo;
END TerminaStore$$