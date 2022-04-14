-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSDIRECCIONLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSDIRECCIONLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOSDIRECCIONLIS`(
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

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal	int;
DECLARE	Lis_Direccion	int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_Direccion	:= 3;








if(Par_NumLis = Lis_Direccion) then
	select TipoDireccionID, Descripcion
	from TIPOSDIRECCION;

end if;

END TerminaStore$$