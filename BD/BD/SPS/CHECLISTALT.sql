-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHECLISTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHECLISTALT`;DELIMITER $$

CREATE PROCEDURE `CHECLISTALT`(
Par_Instrumento			bigint,
	Par_TipoInstrumentoID	int(11),
	Par_TipoPersona			char(1),
	Par_RequeridoEn			char(1),

	Par_Salida				char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(400),
	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN

DECLARE Entero_Cero			int(11);
DECLARE Cadena_Vacia		char(1);
DECLARE SalidaSI			char(1);
DECLARE No_Aplica			int(11);

SET Entero_Cero				:=0;
SET Cadena_Vacia			:='';
SET SalidaSI				:='S';
SET @Var_Folio				:=(select max(CheckListCteID) from CHECLIST);
SET No_Aplica				:=9999;
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

SET @Var_Folio := ifnull(@Var_Folio,Entero_Cero);

INSERT INTO CHECLIST (CheckListCteID,GrupoDocumentoID,TipoDocumentoID,Instrumento,TipoInstrumentoID,
					  EmpresaID,	 Usuario,		  FechaActual,    DireccionIP,ProgramaID,
					  Sucursal,  	 NumTransaccion)
		SELECT  @Var_Folio := @Var_Folio+1,Grp.GrupoDocumentoID,	   No_Aplica,	Par_Instrumento,Par_TipoInstrumentoID,
				Par_EmpresaID,       Aud_Usuario,	  Aud_FechaActual, Aud_DireccionIP,Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion
			FROM GRUPODOCUMENTOS Grp
				inner join DOCTOPORGRUPO Doc on Doc.GrupoDocumentoID=Grp.GrupoDocumentoID
			where Grp.TipoPersona like concat("%",Par_TipoPersona,"%") and Grp.RequeridoEn like concat("%",Par_RequeridoEn,"%")
			GROUP BY Grp.GrupoDocumentoID;

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