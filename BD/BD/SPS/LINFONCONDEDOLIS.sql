-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDEDOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDEDOLIS`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDEDOLIS`(
	Par_LineaFondeoID	int(11),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE		Lis_Principal	int;


Set	Lis_Principal	:= 1;


if(Par_NumLis = Lis_Principal) then
	SELECT	LineaFondeoID,	EstadoID,	MunicipioID,	LocalidadID,NumHabitantesInf,NumHabitantesSup
		FROM LINFONCONDEDO
		WHERE LineaFondeoID = Par_LineaFondeoID;
end if;

END TerminaStore$$