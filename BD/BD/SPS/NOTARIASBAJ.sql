-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOTARIASBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOTARIASBAJ`;DELIMITER $$

CREATE PROCEDURE `NOTARIASBAJ`(
	Par_EstadoID		int(11),
	Par_MunicipioID		int(11),
	Par_NotariaID		int(11),
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
BEGIN
DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

delete
from NOTARIAS
where EstadoID = Par_EstadoID and MunicipioID = Par_MunicipioID
and 	NotariaID = Par_NotariaID;

select '000' as NumErr ,
	  'Notaria Eliminada' as ErrMen,
	  'estadoID' as control;

END$$