-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OCUPACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OCUPACIONESLIS`;DELIMITER $$

CREATE PROCEDURE `OCUPACIONESLIS`(
	Par_Descripcion	varchar(100),
	Par_NumLis		int,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;

if(Par_NumLis = Lis_Principal) then
	select	`OcupacionID`,		`Descripcion`
	from OCUPACIONES
	where  Descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;

END TerminaStore$$