-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRORRATEOCONTABLECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRORRATEOCONTABLECON`;DELIMITER $$

CREATE PROCEDURE `PRORRATEOCONTABLECON`(
Par_ProrrateoID 	int,
Par_NumCon			tinyint unsigned,

Aud_EmpresaID		int,
Aud_Usuario			int,
Aud_FechaActual		DateTime,
Aud_DireccionIP		varchar(15),
Aud_ProgramaID		varchar(50),
Aud_Sucursal		int,
Aud_NumTransaccion	bigint
	)
TerminaStore:BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE Con_ConPrincipal tinyint unsigned;



Set Cadena_Vacia	:= '';
Set Fecha_Vacia		:= '1900-01-01';
Set Entero_Cero		:= 0;
Set Con_ConPrincipal	:=	1;


if(Par_NumCon=Con_ConPrincipal) then
	select ProrrateoID,NombreProrrateo,Estatus,Descripcion
			from PRORRATEOCONTABLE where ProrrateoID=Par_ProrrateoID;
end if;

END TerminaStore$$