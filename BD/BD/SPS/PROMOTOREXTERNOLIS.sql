-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMOTOREXTERNOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMOTOREXTERNOLIS`;DELIMITER $$

CREATE PROCEDURE `PROMOTOREXTERNOLIS`(

	Par_Nombre 		VARCHAR(150),
    Par_Numero 		int,
	Par_NumLis		int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN




DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia	char(1);

DECLARE Lis_Principal	int;
DECLARE Lis_PromExtSocioMenor   int;
DECLARE Estatus_Activo          char;


Set Lis_Principal			:= 1;
Set Lis_PromExtSocioMenor	:= 7;
Set Estatus_Activo        	:= 'A';


if (Par_NumLis = Lis_Principal) then

	select Numero , Nombre
		from PROMOTOREXTERNO
		where Nombre like concat("%", Par_Nombre, "%")
		limit 0, 15;
end if;


if(Par_NumLis = Lis_PromExtSocioMenor) then
	select Numero, Nombre
		from PROMOTOREXTERNO
	    where  Estatus = Estatus_Activo;
	end if;



END TerminaStore$$