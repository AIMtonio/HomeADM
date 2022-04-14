-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEAFONDEAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEAFONDEAMOD`;DELIMITER $$

CREATE PROCEDURE `TIPOSLINEAFONDEAMOD`(
	Par_TipoLinFondeaID	int(11),
	Par_DescTipoLin		varchar(50),
	Par_InstitutFondID	int(11),

    Par_Salida    			char(1),
    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	v_Fecha_Vacia	date;
DECLARE	Entero_Cero		int;
DECLARE Salida_SI 		char(1);
DECLARE Salida_NO		char(1);


Set	Cadena_Vacia		:= '';
Set	v_Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero			:= 0;
set	Salida_SI 	   		:= 'S';


if(ifnull(Par_TipoLinFondeaID, Entero_Cero))= Entero_Cero then
		if(Par_Salida = Salida_SI)then
			select '001' as NumErr,
				'El tipo de Linea Fondea esta vaci0.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = Salida_NO)then
			set	 Par_NumErr := 1;
			set  Par_ErrMen := 'El tipo de Linea Fondea esta vaci0.';
		end if;
	end if;


if(ifnull(Par_DescTipoLin, Cadena_Vacia))= Cadena_Vacia then
		if(Par_Salida = Salida_SI)then
			select '002' as NumErr,
				'La descripcion del Tipo de Linea esta Vacia.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = Salida_NO)then
			set	 Par_NumErr := 2;
			set  Par_ErrMen := 'La descripcion del Tipo de Linea esta Vacia.';
		end if;
	end if;

	if(ifnull(Par_institutFondID, Entero_Cero))= Entero_Cero then
		if(Par_Salida = Salida_SI)then
			select '003' as NumErr,
				'El Número de Institución esta vacio.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = Salida_NO)then
			set	 Par_NumErr := 3;
			set  Par_ErrMen :='El Número de Institución esta vacio.';
		end if;
	end if;
	if not exists (select InstitutFondID from INSTITUTFONDEO
						where InstitutFondID=Par_InstitutFondID)then
		if(Par_Salida = Salida_SI)then
			select '004' as NumErr,
				'El Número de Institución no existe.' as ErrMen,
				'TipoLinFondeaID'  as control,
				Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = Salida_NO)then
			set	 Par_NumErr := 3;
			set  Par_ErrMen :='El Número de Institución no existe.';
		end if;
	end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

update TIPOSLINEAFONDEA set
    TipoLinFondeaID  = Par_TipoLinFondeaID,
    InstitutFondID   = Par_InstitutFondID,
    Descripcion		 = Par_DescTipoLin,

    EmpresaID        = Par_empresaID,
	Usuario          = Aud_Usuario,
    FechaActual      = Aud_FechaActual,
    DireccionIP    	 = Aud_DireccionIP,
    ProgramaID       = Aud_ProgramaID,
    Sucursal       	 = Aud_Sucursal,
    NumTransaccion   = Aud_NumTransaccion

    where   TipoLinFondeaID  = Par_TipoLinFondeaID;

if (Par_Salida = Salida_SI) then
	select 	'000' as NumErr,
			"Tipo de Linea de Fondeo Modificada."  as ErrMen,
			'tipoLinFondeaID' as Control,
			Par_TipoLinFondeaID as Consecutivo;
else
	Set Par_NumErr:=	0;
	Set Par_ErrMen:="Tipo de Linea de Fondeo Modificada." ;
end if;

END TerminaStore$$