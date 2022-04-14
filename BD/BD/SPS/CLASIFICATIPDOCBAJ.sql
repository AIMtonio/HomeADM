-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICATIPDOCBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICATIPDOCBAJ`;DELIMITER $$

CREATE PROCEDURE `CLASIFICATIPDOCBAJ`(
	Par_ClasTipDocID		int(11),
	Par_ClasificaDesc		varchar(50),
	Par_TipoBaja			int(11),

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



DECLARE Var_Control			char(18);


DECLARE Entero_Cero			int(11);
DECLARE SalidaSI				char(1);
DECLARE SalidaNO				char(1);
DECLARE Baja_Principal			int(11);


set Entero_Cero			:= 0;
set SalidaSI				:='S';
set SalidaNO				:='N';
set Baja_Principal			:=1;
set Aud_FechaActual			:= CURRENT_TIMESTAMP();


set var_Control				:= 'clasificaTipDocID' ;




ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		set Par_NumErr = 999;
		set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
			"estamos trabajando para resolverla. Disculpe las molestias que ",
			"esto le ocasiona. Ref: SP-CLASIFICATIPDOCBAJ");
        END;


	if not exists(select ClasificaTipDocID
					from CLASIFICATIPDOC
					where ClasificaTipDocID = Par_ClasTipDocID
					) then
		set Par_NumErr  := '001';
		set Par_ErrMen  := 'El Tipo de Documento que intenta Eliminar no Existe';
		LEAVE ManejoErrores;
	end if;

if(exists(select ClasificaTipDocID
		from SOLICIDOCREQ
		where ClasificaTipDocID = Par_ClasTipDocID)) then
		set Par_NumErr		:= '002';
		set Par_ErrMen			:= concat("El Tipo de Documento '",Par_ClasTipDocID,"' es usado actualmente, en documentos por producto.");
		set var_Control			:= 'clasificaTipDocID' ;
		LEAVE ManejoErrores;

end if;

if(exists(select ClasificaTipDocID
                    from CLASIFICAGRPDOC
                    where ClasificaTipDocID = Par_ClasTipDocID)) then
	set Par_NumErr		:= '003';
	set Par_ErrMen			:= concat("El tipo de Documento '",Par_ClasTipDocID,"' es usado actualmente, en documentos por Clasificacion.");
	set var_Control			:= 'clasificaTipDocID' ;
	LEAVE ManejoErrores;

end if;


if(Par_TipoBaja=Baja_Principal)then
	delete from CLASIFICATIPDOC
			where ClasificaTipDocID = Par_ClasTipDocID;

	set Par_NumErr	:= '000';
	set Par_ErrMen		:= concat("El Tipo de Documento '",Par_ClasTipDocID,"' fue Eliminado.");
	set var_Control		:= 'clasificaTipDocID' ;

end if;

END ManejoErrores;

	if (Par_Salida = SalidaSI) then
	select  convert(Par_NumErr, char(3)) as NumErr,
			Par_ErrMen as ErrMen,
			var_Control as control,
			Par_ClasTipDocID as consecutivo;
	end if;


END TerminaStore$$