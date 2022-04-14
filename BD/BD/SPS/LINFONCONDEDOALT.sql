-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDEDOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDEDOALT`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDEDOALT`(
	Par_LineaFondeoID		int(11),
	Par_EstadoID			int(11),
	Par_MunicipioID			int(11),
	Par_LocalidadID			int(11),
	Par_NumHabitantesInf  	int(11),
	Par_NumHabitantesSup  	int(11),
    Par_Salida    			char(1),
    inout	Par_NumErr 		int,
    inout	Par_ErrMen  	varchar(350),

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_ProgramaID			varchar(50),
	Aud_DireccionIP			varchar(15),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Par_Vacio			int;
DECLARE	Entero_Cero			int;
DECLARE Salida_SI 			char(1);
DECLARE Salida_NO 			char(1);
DECLARE Inserta_SI 			char(1);
DECLARE Inserta_NO 			char(1);
DECLARE Var_Localidad  		int;
DECLARE Var_Municipio  		int;
DECLARE Var_Estado     		int;

DECLARE	VarLineaFonID		int;


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:= 0;
Set   Par_Vacio     		:= 100;
set	Salida_SI 	   			:= 'S';
set	Salida_NO 	   			:= 'N';



if(not exists(select LineaFondeoID from LINEAFONDEADOR
              where LineaFondeoID = Par_LineaFondeoID)) then
	select '001' as NumErr,
		 'La Linea de Fondeo no Existe.' as ErrMen,
		 'lineaFondeoID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_EstadoID,Par_Vacio)=Par_Vacio) then
	select '001' as NumErr,
		 'El Estado Esta Vacio.' as ErrMen,
		 'estadoID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_MunicipioID,Par_Vacio)=Par_Vacio) then
	select '001' as NumErr,
		 'El Municipio Esta Vacio.' as ErrMen,
		 'municipioID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

if(ifnull(Par_LocalidadID,Par_Vacio)=Par_Vacio) then
	select '001' as NumErr,
		 'La Localidad Esta Vacia.' as ErrMen,
		 'localidadID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;

if(Par_EstadoID = Entero_Cero and Par_MunicipioID=Entero_Cero and Par_LocalidadID=Entero_Cero) then
	set   Inserta_SI    := Salida_SI;
end if;

if(Par_EstadoID != Entero_Cero and Par_MunicipioID=Entero_Cero and Par_LocalidadID=Entero_Cero) then
	if(not exists(select EstadoID from ESTADOSREPUB where EstadoID=Par_EstadoID)) then
	select '001' as NumErr,
		 'El Estado No existe.' as ErrMen,
		 'estadoID' as control,
		 '0' as consecutivo;
  	LEAVE TerminaStore;
   end if;
   set   Inserta_SI    := Salida_SI;
end if;

if(Par_EstadoID = Entero_Cero and Par_MunicipioID != Entero_Cero and Par_LocalidadID=Entero_Cero) then
	if(not exists(select MunicipioID
                    from MUNICIPIOSREPUB where MunicipioID = Par_MunicipioID and EstadoID=Par_EstadoID)) then
	select '001' as NumErr,
		 'El Municipio No existe.' as ErrMen,
		 'estadoID' as control,
		 '0' as consecutivo;
  	LEAVE TerminaStore;
   end if;
   set   Inserta_SI    := Salida_SI;
end if;

if(Par_EstadoID != Entero_Cero and Par_MunicipioID != Entero_Cero and Par_LocalidadID=Entero_Cero) then
	if(not exists(select Mu.MunicipioID,Edo.EstadoID
                    from MUNICIPIOSREPUB Mu
                         inner join ESTADOSREPUB Edo on Edo.EstadoID = Mu.EstadoID
                     where Mu.MunicipioID= Par_MunicipioID  and Edo.EstadoID=Par_EstadoID)) then
	select '001' as NumErr,
		 'El Estado o Municipio No existen.' as ErrMen,
		 'estadoID' as control,
		 '0' as consecutivo;
  	LEAVE TerminaStore;
   end if;
   set   Inserta_SI    := Salida_SI;
end if;

if(Par_EstadoID != Entero_Cero and Par_MunicipioID != Entero_Cero and Par_LocalidadID!=Entero_Cero) then
    if(not exists(select LocalidadID from LOCALIDADREPUB
                  where LocalidadID = Par_LocalidadID
					 and MunicipioID=Par_MunicipioID
					 and EstadoID=Par_EstadoID)) then
        select '001' as NumErr,
             'La Localidad No Existe.' as ErrMen,
             'localidadID' as control,
             '0' as consecutivo;
        LEAVE TerminaStore;
    end if;

     select Mu.MunicipioID,Edo.EstadoID into Var_Municipio,Var_Estado
    from LOCALIDADREPUB Loc
        inner join MUNICIPIOSREPUB Mu on Mu.MunicipioID = Loc.MunicipioID and Mu.EstadoID = Loc.EstadoID
        left join ESTADOSREPUB Edo on Edo.EstadoID = Mu.EstadoID
        where Loc.LocalidadID = Par_LocalidadID
			and Loc.EstadoID=Par_EstadoID
			and Loc.MunicipioID=Par_MunicipioID;

    if(Par_EstadoID!=Var_Estado and Par_MunicipioID!=Var_Municipio) then
        select '001' as NumErr,
             'El Estado y Municipio No Corresponden a la Localidad.' as ErrMen,
             'estadoID' as control,
             '0' as consecutivo;
        LEAVE TerminaStore;
    end if;

    if(Par_MunicipioID!=Var_Municipio) then
        select '001' as NumErr,
             'El Municipio No Corresponde a la Localidad.' as ErrMen,
             'municipioID' as control,
             '0' as consecutivo;
        LEAVE TerminaStore;
    end if;

    if(Par_EstadoID!=Var_Estado) then
        select '001' as NumErr,
             'El Estado No Corresponde a la Localidad.' as ErrMen,
             'estadoID' as control,
             '0' as consecutivo;
        LEAVE TerminaStore;
    end if;
    set   Inserta_SI    := Salida_SI;
end if;

if(exists(select * from LINFONCONDEDO
              where LineaFondeoID = Par_LineaFondeoID
              and LocalidadID = Par_LocalidadID
              and MunicipioID = Par_MunicipioID
              and EstadoID = Par_EstadoID)) then
	select '001' as NumErr,
		 'El Registro ya existe.' as ErrMen,
		 'localidadID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
   set Inserta_NO := Par_Salida_NO;
end if;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(Inserta_SI = Salida_SI)then
    insert into LINFONCONDEDO (
        LineaFondeoID,		EstadoID,			MunicipioID,		LocalidadID,		NumHabitantesInf,
        NumHabitantesSup,   EmpresaID,          Usuario,        FechaActual,    ProgramaID,
        DireccionIP,        Sucursal,           NumTransaccion)
    values (
        Par_LineaFondeoID,  Par_EstadoID,       Par_MunicipioID,    Par_LocalidadID,    Par_NumHabitantesInf,
        Par_NumHabitantesSup,Par_EmpresaID,     Aud_Usuario,        Aud_FechaActual,    Aud_ProgramaID,
        Aud_DireccionIP,    Aud_Sucursal,       Aud_NumTransaccion);


        if (Par_Salida = Salida_SI) then
        select 	'000' as NumErr,
                "Condiciones de Descuento Agregadas."  as ErrMen,
                'lineaFondeoID' as Control,
                Par_LineaFondeoID as Consecutivo;
        else
            Set Par_NumErr:=	0;
            Set Par_ErrMen:=	"Condiciones de Descuento Agregadas." ;
        end if;

end if;

END TerminaStore$$