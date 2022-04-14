-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPODOCUMENTOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPODOCUMENTOSMOD`;DELIMITER $$

CREATE PROCEDURE `GRUPODOCUMENTOSMOD`(
	Par_GrupoDocumentoID	int(11),
	Par_Descripcion			varchar(100),
	Par_RequeridoEn			varchar(50),
	Par_TipoPersona			varchar(10),

	Par_EmpresaID			int(11),
	Par_Salida				char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),
	Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint
)
TerminaStore:BEGIN

DECLARE Entero_Cero			int(11);
DECLARE Cadena_Vacia		char(1);
DECLARE SalidaSI			char(1);

SET Entero_Cero				:=0;
SET Cadena_Vacia			:='';
SET SalidaSI				:='S';

ManejoErrores:BEGIN



DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-GRUPODOCUMENTOSMOD");
    END;


if(Par_Descripcion = Cadena_Vacia)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= "La Descripcion esta vacia";
		LEAVE ManejoErrores;
end if;

if Par_RequeridoEn	=Cadena_Vacia then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= "El Campo Requerido En esta Vacio";
		LEAVE ManejoErrores;

end if;
if Par_TipoPersona=Cadena_Vacia then
		set	Par_NumErr 	:= 3;
		set	Par_ErrMen	:= "Seleccione Tipo de Persona";
		LEAVE ManejoErrores;
end if;

set Aud_FechaActual:=now();
	update GRUPODOCUMENTOS set
		   Descripcion		= Par_Descripcion,
		   RequeridoEn		= Par_RequeridoEn,
		   TipoPersona		= Par_TipoPersona,
		   EmpresaID		= Par_EmpresaID,
		   Usuario			= Aud_Usuario,
		   FechaActual		= Aud_FechaActual,
		   DireccionIP		= Aud_DireccionIP,
		   ProgramaID		= Aud_ProgramaID,
		   Sucursal  		= Aud_Sucursal,
		   NumTransaccion	= Aud_NumTransaccion
		where GrupoDocumentoID=Par_GrupoDocumentoID;

	set	Par_NumErr 	:= 0;
	set	Par_ErrMen	:= concat("Grupo de Documento Modificado Exitosamente:",Par_GrupoDocumentoID);

END ManejoErrores;

if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'grupoDocumentoID' as control,
			Par_GrupoDocumentoID as consecutivo;
end if;
END  TerminaStore$$