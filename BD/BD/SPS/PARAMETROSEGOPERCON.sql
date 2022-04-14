-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSEGOPERCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSEGOPERCON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSEGOPERCON`(
	Par_TipoPerson		char(1),
	Par_TipoInstrum		int,
	Par_NacCliente			char(1),
	Par_NivelSeg			int,
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


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal 	int;
DECLARE	Con_Foranea	 	int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal		:= 1;
Set	Con_Foranea		:= 2;



if(Par_NumCon = Con_Principal) then


select 	NivelSeguimien,	TipoPersona,	TipoInstrumento,	NacCliente,	MontoInferior,
		MonedaComp
	from 	PARAMETROSEGOPER
	where TipoPersona = Par_TipoPerson
	and 	 TipoInstrumento 	= Par_TipoInstrum
	and  NacCliente		= Par_NacCliente
	and	 NivelSeguimien	= Par_NivelSeg;

end if;

END TerminaStore$$