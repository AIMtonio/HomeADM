-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMAREPLEGALLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRMAREPLEGALLIS`;DELIMITER $$

CREATE PROCEDURE `FIRMAREPLEGALLIS`(
	Par_RepresentLegal	char(70),
	Par_NumLista		tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

DECLARE Con_ListaGrid 	tinyint unsigned;


Set Con_ListaGrid 		:=1;

if(Par_NumLista=Con_ListaGrid) then
	select RepresentLegal,		Consecutivo,	 Observacion,		Recurso
					from FIRMAREPLEGAL
						where RepresentLegal=Par_RepresentLegal order by Consecutivo;
end if;

END TerminaStore$$