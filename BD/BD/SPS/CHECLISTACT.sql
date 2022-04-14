-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHECLISTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHECLISTACT`;DELIMITER $$

CREATE PROCEDURE `CHECLISTACT`(


	Par_Instrumento			bigint,
	Par_TipoInstrumentoID	int(11),
	Par_GrupoDocumentoID	int(11),
	Par_TipoDocumentoID		int(11),
	Par_Comentario			varchar(200),
	Par_Aceptado			char(1),

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
                                 "esto le ocasiona. Ref: SP-CHECLISTALT");
    END;


if(Par_Instrumento = Entero_Cero)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= "El Instrumento esta Vacio";
		LEAVE ManejoErrores;
end if;

SET Aud_FechaActual:=NOW();
	update CHECLIST set
		TipoDocumentoID	=Par_TipoDocumentoID,
		Comentario		=Par_Comentario,
		Aceptado		=Par_Aceptado,
		EmpresaID		=Par_EmpresaID,
		Usuario			=Aud_Usuario,
		FechaActual		=Aud_FechaActual,
		DireccionIP		=Aud_DireccionIP,
		ProgramaID		=Aud_ProgramaID,
		Sucursal		=Aud_Sucursal,
		NumTransaccion	=Aud_NumTransaccion
		where Instrumento=Par_Instrumento
		and TipoInstrumentoID=Par_TipoInstrumentoID
		and GrupoDocumentoID=Par_GrupoDocumentoID;

	set	Par_NumErr 	:= 0;
	set	Par_ErrMen	:= "Check List Grabado Exitosamente";

END ManejoErrores;

if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'clienteID' as control,
			Entero_Cero as consecutivo;
end if;


END  TerminaStore$$