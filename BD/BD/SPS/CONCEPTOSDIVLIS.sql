-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSDIVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSDIVLIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSDIVLIS`(
	Par_NumLis		tinyint unsigned,

	Aud_EmpresaID			int,
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
DECLARE	Lis_Conceptos 	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Conceptos	:= 1;

if(Par_NumLis = Lis_Conceptos) then
	select 	`ConceptoMonID`,	`Descripcion`
	from 		CONCEPTOSDIVISA;
end if;

END TerminaStore$$