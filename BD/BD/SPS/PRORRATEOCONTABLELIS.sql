-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRORRATEOCONTABLELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRORRATEOCONTABLELIS`;DELIMITER $$

CREATE PROCEDURE `PRORRATEOCONTABLELIS`(
Par_NombreProrrateo		char(50),
Par_NumLis				int(11),

Aud_EmpresaID			int,
Aud_Usuario				int,
Aud_FechaActual			datetime,
Aud_DireccionIP			varchar(15),
Aud_ProgramaID			varchar(50),
Aud_Sucursal			int,
Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN

DECLARE Cadena_Vacia	char(1);
DECLARE Entero_Cero		char(1);
DECLARE Lis_Principal	tinyint unsigned;



Set 	Cadena_Vacia	:= '';
Set		Entero_Cero		:= 0;
Set 	Lis_Principal	:= 1;


if(Par_NumLis=Lis_Principal) then
	select ProrrateoID, NombreProrrateo from PRORRATEOCONTABLE
					where NombreProrrateo like concat("%",Par_NombreProrrateo,"%") limit 0,15;
end if;


END TerminaStore$$