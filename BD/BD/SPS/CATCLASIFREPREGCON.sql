-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCLASIFREPREGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCLASIFREPREGCON`;DELIMITER $$

CREATE PROCEDURE `CATCLASIFREPREGCON`(
	Par_ClasifRegID		int,
	Par_NumCon			tinyint unsigned,
	Par_Salida          char(1),
    inout	Par_NumErr     int,
    inout	Par_ErrMen     varchar(400),
	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia		char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Con_Principal		int;
DECLARE		Con_Foranea		int;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal		:= 1;
Set	Con_Foranea		:= 2;


if(Par_NumCon = Con_Principal) then
	select	ClasifRegID,	ReporteID,		ClaveReporte,	TipoReporte,	Descripcion,
			PrioridadConc,	TipoConcepto,	AplSector,		AplActividad,	AplProducto,
			AplTipoPersona,	Segmento
	from CATCLASIFREPREG
	where  ClasifRegID = Par_ClasifRegID;
end if;

if(Par_NumCon = Con_Foranea) then
	select	ClasifRegID,	Descripcion
	from CATCLASIFREPREG
	where  ClasifRegID = Par_ClasifRegID;
end if;

END TerminaStore$$