-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASINVERSIONLIS`;DELIMITER $$

CREATE PROCEDURE `TASASINVERSIONLIS`(
	Par_TasaInversion	int,
	Par_NumLis		int
	)
TerminaStore: BEGIN

DECLARE Lis_TasaIversion	int;

Set	Lis_TasaIversion	:= 5;


if(Par_NumLis = Lis_MontoIversion) then
	select MontoInversionID, CONCAT('De ', PlazoInferior, ' a ', PlazoSuperior, ' Pesos')as MontosPlazo
	from MONTOINVERSION
	where  Par_TipoInversionID = TipoInversionID;
end if;


END TerminaStore$$