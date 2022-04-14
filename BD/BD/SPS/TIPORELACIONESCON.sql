-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPORELACIONESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPORELACIONESCON`;DELIMITER $$

CREATE PROCEDURE `TIPORELACIONESCON`(
	Par_TipoRelacionID	int,
	Par_NumCon		tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario		int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia	date;
DECLARE	Entero_Cero	int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea	int;
DECLARE Con_Parentesco  int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Con_Principal	:= 1;
Set	Con_Parentesco	:= 3;

if(Par_NumCon = Con_Principal) then
	select	`TipoRelacionID`,		`EmpresaID`,		`Descripcion`
	from		TIPORELACIONES
	where		TipoRelacionID = Par_TipoRelacionID;
end if;

if(Par_NumCon = Con_Parentesco) then
	select	`TipoRelacionID`,	`EmpresaID`,		`Descripcion`, `Tipo`, `Grado`, `Linea`
	from		TIPORELACIONES
	where		EsParentesco = 'S' AND TipoRelacionID = Par_TipoRelacionID;
end if;



END TerminaStore$$