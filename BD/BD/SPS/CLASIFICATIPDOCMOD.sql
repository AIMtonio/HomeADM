-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICATIPDOCMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICATIPDOCMOD`;DELIMITER $$

CREATE PROCEDURE `CLASIFICATIPDOCMOD`(
	Par_ClasTipDocID		int(11),
	Par_ClasificaDesc		varchar(50),
	Par_ClasificaTipo		char(1),
	Par_TipoGrupInd		char(1),
	Par_GrupoAplica		int(11),
	Par_EsGarantia			char(1),

	Par_Salida				char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID			int(11) ,
	Aud_Usuario			int(11) ,
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11) ,
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore:BEGIN



DECLARE var_Control			char(20);


DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia		char(1);
DECLARE SalidaSI			char(1);
DECLARE SalidaNO			char(1);


set Entero_Cero	:= 0;
set Cadena_Vacia	:= '';
set SalidaSI		:= 'S';
set SalidaNO		:= 'N';


set var_Control		:='clasificaTipDocID' ;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-CLASIFICATIPDOCMOD");
				END;


if(not exists(select ClasificaTipDocID
	from CLASIFICATIPDOC
		where ClasificaTipDocID = Par_ClasTipDocID)) then
	set Par_NumErr	:= '001';
	set Par_ErrMen		:= concat('El Tipo de Documento ',convert(Par_ClasTipDocID, CHAR),' no Existe');
	set var_Control		:= 'clasificaTipDocID' ;
	LEAVE ManejoErrores;

end if;


if(ifnull(Par_ClasificaDesc,Cadena_Vacia)=Cadena_Vacia)then
	set Par_NumErr	:= '002';
	set Par_ErrMen		:= concat('La Descripcion del Tipo de Documento : ',convert(Par_ClasTipDocID, CHAR), ' esta Vacia');
	set var_Control		:= 'clasificaTipDocID' ;
	LEAVE ManejoErrores;
end if;


UPDATE  CLASIFICATIPDOC SET

	ClasificaTipDocID	=Par_ClasTipDocID,
	ClasificaDesc	 	=Par_ClasificaDesc,
	ClasificaTipo 		= Par_ClasificaTipo,
	TipoGrupInd 		=Par_TipoGrupInd,
	GrupoAplica		=Par_GrupoAplica,
	EsGarantia 		=Par_EsGarantia,
	EmpresaID		=Par_EmpresaID,
	Usuario			=Aud_Usuario,
	FechaActual		=Aud_FechaActual,
	DireccionIP		=Aud_DireccionIP,
	ProgramaID		=Aud_ProgramaID,
	Sucursal		=Aud_Sucursal,
	NumTransaccion	=Aud_NumTransaccion

	where ClasificaTipDocID=Par_ClasTipDocID;


set Par_NumErr := 0;
set Par_ErrMen := concat("Tipo de Documento: ", convert(Par_ClasTipDocID, CHAR), "  Modificado Correctamente");

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
	select  convert(Par_NumErr, char(3)) as NumErr,
		Par_ErrMen as ErrMen,
		var_Control as control,
		Par_ClasTipDocID as consecutivo;
end if;



 END TerminaStore$$