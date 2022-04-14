-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASINVERSIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASINVERSIONBAJ`;DELIMITER $$

CREATE PROCEDURE `DIASINVERSIONBAJ`(
	Par_DiaInversionID	int(11),
	Par_TipoInversionID	int(11),
	Par_Empresa			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
BEGIN

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

delete
	from DIASINVERSION
	where	TipoInversionID	= Par_TipoInversionID;

select '000' as NumErr ,
	  'Dias de Inversion Eliminados' as ErrMen,
	  'TipoInversionID' as control;

END$$