-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCOORPLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCOORPLIS`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCOORPLIS`(
	Par_ClienteID	varchar(100),
	Par_CorpRelacionado  varchar(50),



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
DECLARE 	ClasCoorp		char(1);


Set	Lis_Principal	:= 4;
set ClasCoorp		:='R';
if(Par_NumLis = Lis_Principal) then
	select ClienteID, NombreCompleto
	from CLIENTES
	where  NombreCompleto like concat("%", Par_ClienteID, "%")
		and Clasificacion=ClasCoorp
		and CorpRelacionado=Par_CorpRelacionado
	limit 0, 15;
end if;

END TerminaStore$$