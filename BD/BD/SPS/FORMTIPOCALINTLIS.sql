-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMTIPOCALINTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FORMTIPOCALINTLIS`;
DELIMITER $$


CREATE PROCEDURE `FORMTIPOCALINTLIS`(
	Par_Nombre	    varchar(20),
	Par_NumLis		tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
)

TerminaStore: BEGIN

DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE	Cadena_Vacia 	varchar(1);
DECLARE Lis_ComboCalInt	INT(11);

Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set Cadena_Vacia    := '';
SET Lis_ComboCalInt	:= 2;

if(Par_NumLis = Lis_Principal) then
	select	`FormInteresID`,		`Formula`
	from FORMTIPOCALINT
	where  Formula like concat("%", ifnull(Par_Nombre,Cadena_Vacia), "%")
	limit 0, 15;
end if;

IF(Par_NumLis = Lis_ComboCalInt) THEN
	SELECT FormInteresID, Formula 
		FROM FORMTIPOCALINT
		WHERE Formula LIKE CONCAT("%", IFNULL(Par_Nombre,Cadena_Vacia), "%") 
			AND FormInteresID IN (1,2,4)
		LIMIT 0,15;
END IF; 

END TerminaStore$$
