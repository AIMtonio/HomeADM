-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REMESACATALOGOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REMESACATALOGOCON`;
DELIMITER $$


CREATE PROCEDURE `REMESACATALOGOCON`(
	Par_RemesaCatalogoID	INT(11),
	Par_NumCon			int,

	Par_EmpresaID       		int,
	Aud_Usuario         		int,
	Aud_FechaActual  	   	DateTime,
	Aud_DireccionIP    	 	varchar(15),
	Aud_ProgramaID   	   	varchar(50),
	Aud_Sucursal        		int,
	Aud_NumTransaccion  	bigint
	)

TerminaStore: BEGIN

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal		int;

SET	Cadena_Vacia			:='';
SET	Fecha_Vacia			:='1900-01-01';
SET	Entero_Cero			:=0;
SET Con_Principal			:=1;

if(Par_NumCon = Con_Principal) then
	SELECT 	RemesaCatalogoID,	Nombre,	NombreCorto, 	CuentaCompleta, CCostosRemesa,
			Estatus
			from REMESACATALOGO
			WHERE 	RemesaCatalogoID =Par_RemesaCatalogoID;
end if;



END TerminaStore$$