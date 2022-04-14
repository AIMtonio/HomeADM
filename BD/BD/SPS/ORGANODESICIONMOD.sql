-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANODESICIONMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANODESICIONMOD`;DELIMITER $$

CREATE PROCEDURE `ORGANODESICIONMOD`(
	Par_OrganoID			int(11),
	Par_Descripcion		varchar(100),

	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID			int(11) ,
	Aud_Usuario			int(11) ,
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int(11) ,
	Aud_NumTransaccion	bigint(20)
	)
TerminaStore:BEGIN



DECLARE varControl			char(15);


DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia		char(1);
DECLARE SalidaSI			char(1);
Declare SalidaNO			char(1);


set Entero_Cero 		 := 0;
Set Cadena_Vacia		:= '';
set SalidaSI			:= 'S';
Set SalidaNO			:= 'N';
set varControl			:='organoID' ;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-ORGANODESICIONMOD");
				END;


if(not exists(select OrganoID
                    from ORGANODESICION
                    where OrganoID = Par_OrganoID)) then
	set Par_NumErr  := '001';
	set Par_ErrMen  := concat('El Facultado: ',convert(Par_OrganoID, CHAR),' no Existe');
	set varControl  := 'organoID' ;
	LEAVE ManejoErrores;

end if;


if(ifnull(Par_OrganoID,Entero_Cero)) = Entero_Cero then
	set Par_NumErr  := '002';
	set Par_ErrMen  := 'El Numero de Facultado esta Vacio';
	set varControl  := 'organoID' ;
	LEAVE ManejoErrores;
end if;

if(ifnull(Par_Descripcion,Cadena_Vacia)) = Cadena_Vacia then
	set Par_NumErr  := '003';
	set Par_ErrMen  := concat('La Descripcion del Facultado: ', convert(Par_OrganoID, CHAR),' esta vacia');
	set varControl  := 'organoID' ;
	LEAVE ManejoErrores;
end if;

UPDATE  ORGANODESICION SET
			Descripcion		= Par_Descripcion,
			EmpresaID		= Par_EmpresaID,
			Usuario			=Aud_Usuario,
			FechaActual		=Aud_FechaActual,
			DireccionIP		=Aud_DireccionIP,
			ProgramaID		=Aud_ProgramaID,
			Sucursal			=Aud_Sucursal,
			NumTransaccion	=Aud_NumTransaccion
		WHERE OrganoID = Par_OrganoID;

set Par_NumErr := 0;
set Par_ErrMen := concat("Facultado: ", convert(Par_OrganoID, CHAR), "  Modificado Correctamente");


END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            'organoID' as control,
            Par_OrganoID as consecutivo;
end if;



END TerminaStore$$