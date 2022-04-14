-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSIDENTICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSIDENTICON`;DELIMITER $$

CREATE PROCEDURE `TIPOSIDENTICON`(
	Par_TipoIdentID	int,
	Par_NumCon		tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;


if(Par_NumCon = Con_Principal) then
	select	`TipoIdentiID`, 	`EmpresaID`, 	`Nombre`, `NumeroCaracteres`	,
			`Oficial`
	from TIPOSIDENTI
	where  TipoIdentiID = Par_TipoIdentID;
end if;

if(Par_NumCon = Con_Foranea) then
	select	`TipoIdentiID`,		`Nombre`
	from TIPOSIDENTI
	where  TipoIdentiID = Par_TipoIdentID;
end if;


END TerminaStore$$