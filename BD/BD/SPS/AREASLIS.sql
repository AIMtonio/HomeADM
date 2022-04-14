-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AREASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AREASLIS`;DELIMITER $$

CREATE PROCEDURE `AREASLIS`(
	Par_Descripcion 		varchar(100),
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Principal		int;
DECLARE	EstatusActivo		char(1);


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal			:= 1;
Set 	EstatusActivo			:='A';

if(Par_NumLis = Lis_Principal) then

select DISTINCT A.AreaID, A.Descripcion
    from AREAS A
    where A.Descripcion	LIKE	concat("%", Par_Descripcion, "%")
    limit 0, 15;

end if;

END TerminaStore$$