-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACLIENTEEMPLEABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACLIENTEEMPLEABAJ`;DELIMITER $$

CREATE PROCEDURE `RELACLIENTEEMPLEABAJ`(
	Par_ClienteID	int,

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

delete from RELACIONCLIEMPLEADO
WHERE ClienteID = Par_ClienteID;

select '000' as NumErr ,
	  'Relaciones del Cliente Eliminados' as ErrMen,
	  'clienteID' as control;

END TerminaStore$$