-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONTOSINVERSIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONTOSINVERSIONBAJ`;DELIMITER $$

CREATE PROCEDURE `MONTOSINVERSIONBAJ`(
	Par_MontoInversionID	int(11),
	Par_TipoInversionID	int(11),
	Par_Empresa			int,

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
	from MONTOINVERSION
	where	TipoInversionID	= Par_TipoInversionID;

select '000' as NumErr ,
	  'Montos de Inversion Eliminados' as ErrMen,
	  'TipoInversionID' as control;

END TerminaStore$$