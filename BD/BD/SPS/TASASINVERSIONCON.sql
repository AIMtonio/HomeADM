-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASINVERSIONCON`;DELIMITER $$

CREATE PROCEDURE `TASASINVERSIONCON`(
	Par_TipoInversion	int,
	Par_DiaInversion	int,
	Par_MontoInversion	int,
	Par_TipoConsulta	int
	)
TerminaStore: BEGIN

DECLARE	Con_Principal		int;
DECLARE	Con_Foranea		int;
DECLARE	Con_Inicio		int;

Set	Con_Principal	:= 1;
Set	Con_Foranea	:= 2;

if(Par_TipoConsulta = Con_Principal)then
	select TasaInversionID, ConceptoInversion, GatInformativo
	from TASASINVERSION
	where TipoInversionID = Par_TipoInversion
	and DiaInversionID = Par_DiaInversion
	and MontoInversionID = Par_MontoInversion ;

end if;


if(Par_TipoConsulta = Con_Foranea)then

select
	concat(convert(Catalogo.PlazoInferior,CHAR), "  a  ", convert(Catalogo.PlazoSuperior,CHAR))as Dias,
	concat(convert(format(Catalogo.MontoMin,2),CHAR), "  a  ", convert(format(Catalogo.MontoMax,2),CHAR)) as Cantidad,
	convert(coalesce(format(T.ConceptoInversion,4)," "),CHAR)as ConceptoInversion

from (

(select Dias.DiaInversionID, Montos.MontoInversionID,  Dias.PlazoInferior, Dias.PlazoSuperior, Montos.PlazoInferior as MontoMin, Montos.PlazoSuperior as MontoMax, Montos.TipoInversionID
	from (
		(select DiaInversionID, TipoInversionID, PlazoInferior, PlazoSuperior from DIASINVERSION )as Dias
		join
		(select MontoInversionID, TipoInversionID, PlazoInferior, PlazoSuperior from MONTOINVERSION )as Montos
		on Dias.TipoInversionID = Montos.TipoInversionID)
)as Catalogo
left join
	(select TipoInversionID, DiaInversionID, MontoInversionID, ConceptoInversion from TASASINVERSION) as T
	on T.TipoInversionID = Catalogo.TipoInversionID
	and T.DiaInversionID = Catalogo.DiaInversionID
	and T.MontoInversionID = Catalogo.MontoInversionID
)
where Catalogo.TipoInversionID = Par_TipoInversion
order by  convert(Dias,unsigned),Catalogo.MontoMin , Catalogo.MontoMax ASC ;
end if;


END TerminaStore$$