-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALPORRANGOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALPORRANGOBAJ`;DELIMITER $$

CREATE PROCEDURE `CALPORRANGOBAJ`(
	Par_TipoInstit		varchar(2),
   Par_Clasificacion  char(1),
	Par_Tipo			   char(2),

	Aud_Empresa			int,
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

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

delete
	from CALPORRANGO
	where	TipoInstitucion = Par_TipoInstit and Tipo = Par_Tipo and Clasificacion = Par_Clasificacion;

select '000' as NumErr ,
	  'Calificacion por Rangos Eliminados' as ErrMen,
	  'tipoInstitucion' as control;

END TerminaStore$$