-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASBASELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASBASELIS`;DELIMITER $$

CREATE PROCEDURE `TASASBASELIS`(
	Par_Nombre	varchar(20),
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


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal 	int;
DECLARE	Lis_Combo	 	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
	select	`TasaBaseID`,		`Nombre`
	from TASASBASE
	where  Nombre like concat("%", Par_Nombre, "%")
	limit 0, 15;
end if;

END TerminaStore$$