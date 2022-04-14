-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASAHORROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASAHORROLIS`;DELIMITER $$

CREATE PROCEDURE `TASASAHORROLIS`(
	Par_TipoCuentaID	int,
	Par_MonedaID 	int,
	Par_TipoPersona	CHAR(1),
	Par_NumLis		tinyint unsigned,

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
DECLARE		Lis_Foranea	int;
DECLARE		Lis_PortadaContrat	int;

Set	Lis_Principal	:= 1;
Set	Lis_Foranea	:= 2;
Set	Lis_PortadaContrat	:= 3;

if(Par_NumLis = Lis_Principal) then
	select	TasaAhorroID, CONCAT(FORMAT(MontoInferior,2)) as MontoInferior,	CONCAT(FORMAT(MontoSuperior,2)) as MontoSuperior,
			CONCAT(FORMAT(Tasa,4)) as Tasa
	from 		TASASAHORRO
	where  	TipoCuentaID    = Par_TipoCuentaID
	and    	MonedaID        = Par_MonedaID
	and    	TipoPersona     = Par_TipoPersona;
end if;

if(Par_NumLis = Lis_Foranea) then
    SELECT TasaAhorroID, CONCAT(FORMAT(MontoInferior,2)) as MontoInferior,	CONCAT(FORMAT(MontoSuperior,2)) as MontoSuperior,
			CONCAT(FORMAT(Tasa,4)) as Tasa
        FROM TASASAHORRO
        where TipoPersona = Par_TipoPersona
        limit 0, 15;

end if;

if(Par_NumLis = Lis_PortadaContrat) then
	select	TasaAhorroID, MontoInferior,	MontoSuperior,	Tasa
        from 		TASASAHORRO
        where  	TipoCuentaID    = Par_TipoCuentaID
        and    	MonedaID        = Par_MonedaID
        and    	TipoPersona     = Par_TipoPersona
        order by MontoInferior ASC;

end if;

END TerminaStore$$