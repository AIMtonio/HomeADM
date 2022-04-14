-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSPECTOSWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSWSCON`;DELIMITER $$

CREATE PROCEDURE `PROSPECTOSWSCON`(
	Par_ProspectoID			int,
	Par_InstitNominaID		int,
    Par_NegocioAfiliadoID 	int,
	Par_NumCon				tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Var_ProspectoID   	int;
DECLARE Var_NomProspecto  	varchar(40);
DECLARE	NumErr		      	int(11);
DECLARE	ErrMen		      	varchar(40);


DECLARE Entero_Cero			int;
DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE Con_Principal		int;
DECLARE Con_NombreProsIN  	int;
DECLARE Con_NombreProsNA  	int;

Set	Cadena_Vacia			:= '';
Set	Entero_Cero				:= 0;
Set	Fecha_Vacia				:= '1900-01-01';
Set	Con_Principal			:= 1;
Set Con_NombreProsIN  		:= 2;
Set Con_NombreProsNA   		:= 3;
Set Aud_FechaActual			:= now();

if(Par_NumCon = Con_Principal) then

Set Var_ProspectoID:= (select ProspectoID from PROSPECTOS where ProspectoID = Par_ProspectoID);

if(ifnull(Var_ProspectoID, Entero_Cero))= Entero_Cero then
		set 	NumErr := '001';
		set 	ErrMen := 'El Numero de Prospecto no Existe.';
 select 	Entero_Cero as ProspectoID, Cadena_Vacia as PrimerNombre,	Cadena_Vacia as SegundoNombre,
			Cadena_Vacia as TercerNombre, Cadena_Vacia as ApellidoPaterno,Cadena_Vacia as ApellidoMaterno,
			Cadena_Vacia as TipoPersona, Fecha_Vacia as FechaNacimiento,Cadena_Vacia as RFC,
			Cadena_Vacia as Sexo,Cadena_Vacia as EstadoCivil, Cadena_Vacia as Telefono,
			Cadena_Vacia as RazonSocial,Entero_Cero as EstadoID,Entero_Cero as MunicipioID,
			Entero_Cero as LocalidadID,Entero_Cero as ColoniaID,Cadena_Vacia as Calle,Cadena_Vacia as NumExterior,
			Cadena_Vacia as NumInterior,Cadena_Vacia as CP,Cadena_Vacia as Manzana,Cadena_Vacia as Lote,
			Cadena_Vacia as Latitud,Cadena_Vacia as Longitud,Entero_Cero as TipoDireccionID,Cadena_Vacia as CalificaProspecto,
			NumErr, ErrMen;
	else
		set 	NumErr := '000';
		set 	ErrMen := 'Consulta Exitosa';
        select 	Pros.ProspectoID, 	PrimerNombre,	   SegundoNombre, 	 TercerNombre, 	ApellidoPaterno,
				ApellidoMaterno,    TipoPersona, 	   FechaNacimiento,   RFC,			Sexo,
				EstadoCivil, 	    Telefono,		   RazonSocial,	     EstadoID,		MunicipioID,
				LocalidadID,	    ColoniaID,		   Calle,			 NumExterior,	NumInterior,
				CP,				    Manzana,		   Lote,			     Latitud,		Longitud,
				TipoDireccionID,    CalificaProspecto, NumErr,           ErrMen
        from PROSPECTOS Pros
        inner join NOMINAEMPLEADOS Ne
        on Ne.ProspectoID= Pros.ProspectoID
        where Pros.ProspectoID = Par_ProspectoID
        and Ne.InstitNominaID=Par_InstitNominaID;
	end if;
end if;

if(Par_NumCon = Con_NombreProsIN) then
	select  NombreCompleto, CalificaProspecto
        from PROSPECTOS Pros
        inner join NOMINAEMPLEADOS Ne
        on Ne.ProspectoID= Pros.ProspectoID
        where Pros.ProspectoID = Par_ProspectoID
        and Ne.InstitNominaID  =  Par_InstitNominaID;

end if;

if(Par_NumCon = Con_NombreProsNA) then
	select  NombreCompleto
        from PROSPECTOS Pro
        inner join NEGAFILICLIENTE Neg
        on Neg.ProspectoID= Pro.ProspectoID
        where Pro.ProspectoID = Par_ProspectoID
        and Neg.NegocioAfiliadoID=Par_NegocioAfiliadoID;
end if;

END TerminaStore$$