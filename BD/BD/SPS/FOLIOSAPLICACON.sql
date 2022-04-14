-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FOLIOSAPLICACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `FOLIOSAPLICACON`;DELIMITER $$

CREATE PROCEDURE `FOLIOSAPLICACON`(
	Par_NombreTabla		varchar(100),
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE		Con_Principal	int;


DECLARE 	var_Folio		bigint;

Set	Con_Principal		:= 1;


if(Par_NumCon = Con_Principal) then
	call FOLIOSAPLICAACT(Par_NombreTabla,	var_Folio);
	select var_Folio;
end if;

END TerminaStore$$