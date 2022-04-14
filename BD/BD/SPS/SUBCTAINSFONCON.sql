-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAINSFONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAINSFONCON`;


	Par_ConceptoFonID 		int(11),
   Par_TipoFondeador    char(1),
	Par_institutFondID		int(11),
	Par_NumCon		tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)


DECLARE		Con_Principal	int;
DECLARE		Con_Foranea		int;

Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;

if(Par_NumCon = Con_Principal) then
	select	ConceptoFonID,TipoFondeo,InstitutFondID,SubCuenta
	from SUBCTAINSFON
	where  ConceptoFonID 	= Par_ConceptoFonID
		and institutFondID	= Par_institutFondID
      and TipoFondeo = Par_TipoFondeador;
end if;
END TerminaStore$$