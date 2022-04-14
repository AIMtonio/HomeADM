-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTOREXTERNOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTOREXTERNOALT`;DELIMITER $$

CREATE PROCEDURE `PROMOTOREXTERNOALT`(

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
	Aud_Usuario				int,
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
DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				set Par_NumErr = 999;
				set Par_ErrMen = concat('Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
							 "estamos trabajando para resolverla. Disculpe las molestias que ",
							 "esto le ocasiona. Ref: SP-PROMOTOREXTERNOALT');
						SET Var_Control = 'sqlException' ;
			END;



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

	if(Par_Estatus=Cadena_Vacia) = Cadena_Vacia then
		set Par_NumErr  := 005;
        set Par_ErrMen  := 'El Estatus del Promotor no fue seleccionado';
        set Var_Control := 'estatus';
end if;


call FOLIOSAPLICAACT('PROMOTOREXTERNO', Var_Numero);

Set Aud_FechaActual := now();


INSERT INTO PROMOTOREXTERNO (
		Numero,			Nombre,			Telefono,		NumCelular,		Correo,
		Estatus,    	ExtTelefono,	EmpresaID,		Usuario,     	FechaActual,
		DireccionIP,	ProgramaID,   	Sucursal,		NumTransaccion)
	VALUES(
        Var_Numero,    		Par_Nombre,			Par_Telefono,		    Par_NumCelular,	  Par_Correo,
        Par_Estatus,   		Par_ExtTelefono,	Aud_EmpresaID,   		Aud_Usuario,      Aud_FechaActual,
		Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		set Par_NumErr  := 000;
        set Par_ErrMen  :=  concat("Promotor Externo Agregado Exitosamente: ", convert(Var_Numero, CHAR));
        set Var_Control := 'numero';
		set Entero_Cero := Var_Numero;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr  as NumErr,
            Par_ErrMen  as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$