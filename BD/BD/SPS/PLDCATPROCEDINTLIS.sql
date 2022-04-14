-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCATPROCEDINTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCATPROCEDINTLIS`;


	Par_Descripcion	VARCHAR(15),
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE	Lis_Foranea 		int;
DECLARE	Lis_PorContrat 	int;

Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal			:= 1;
Set	Lis_Foranea			:= 2;
Set	Lis_PorContrat		:= 3;


if(Par_NumLis = Lis_Principal) then
	select 	`CatProcedIntID`,	`Descripcion`
	from 		PLDCATPROCEDINT
	where Descripcion	LIKE	concat("%", Par_Descripcion, "%")
    limit 0, 15;
end if;

if(Par_NumLis = Lis_Foranea) then
	select 	`CatProcedIntID`,	`Descripcion`
	from 		PLDCATPROCEDINT
	where Descripcion	LIKE	concat("%", Par_Descripcion, "%")
    limit 0, 15;
end if;

END TerminaStore$$