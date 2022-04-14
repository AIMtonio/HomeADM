-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPODOCUMENTOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPODOCUMENTOSBAJ`;DELIMITER $$

CREATE PROCEDURE `GRUPODOCUMENTOSBAJ`(
	Par_GrupoDocumentoID	int(11),

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
DECLARE Var_Grupos			int(11);

SET Entero_Cero				:=0;
SET Cadena_Vacia			:='';
SET SalidaSI				:='S';

ManejoErrores:BEGIN



DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-GRUPODOCUMENTOSBAJ");
    END;

Select count(GrupoDocumentoID) into Var_Grupos from DOCTOPORGRUPO where GrupoDocumentoID=Par_GrupoDocumentoID;

if Var_Grupos>Entero_Cero then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= "El Grupo tiene Tipos de Documentos Asignado.";
		LEAVE ManejoErrores;

end if;

Delete from  GRUPODOCUMENTOS where GrupoDocumentoID=Par_GrupoDocumentoID;

	set	Par_NumErr 	:= 0;
	set	Par_ErrMen	:= concat("Grupo de Documento Eliminado Exitosamente:",Par_GrupoDocumentoID);

END ManejoErrores;

if (Par_Salida = SalidaSI) then
	select  Par_NumErr as NumErr,
			Par_ErrMen as ErrMen,
			'grupoDocumentoID' as control,
			Entero_Cero as consecutivo;
end if;

END  TerminaStore$$