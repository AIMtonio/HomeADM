-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDESCALASOLCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDESCALASOLCON`;DELIMITER $$

CREATE PROCEDURE `PLDESCALASOLCON`(
	Par_FolioID         int(11),
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN


DECLARE MaxFolioID      int(11);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;
DECLARE Con_Folio       int;
DECLARE Est_Vigente     char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set Con_Folio       := 3;
set Est_Vigente     :='V';


set MaxFolioID  = (select max(FolioID) from PLDESCALASOL);


if(Par_NumCon = Con_Principal) then
	select	FolioID,	NivelRiesgoID,	Peps,			ActuaCuenTer,	DudasAutDoc,
			RolTitular,	RolSuplente,	FechaVigencia, 	Estatus
	from PLDESCALASOL
	where FolioID = MaxFolioID;
end if;

if(Par_NumCon = Con_Folio) then
	select	FolioID,	NivelRiesgoID,	Peps,			ActuaCuenTer,	DudasAutDoc,
			RolTitular,	RolSuplente,	FechaVigencia, 	Estatus
		from PLDESCALASOL
		where FolioID = Par_FolioID;
end if;

END TerminaStore$$