-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCRITURAPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESCRITURAPUBLIS`;DELIMITER $$

CREATE PROCEDURE `ESCRITURAPUBLIS`(
	Par_ClienteID		int,
	Par_Tipo			varchar(10),
	Par_NumLis			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;
DECLARE		Lis_Poderes		int;
DECLARE 	Lis_PorCliente	int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_Poderes		:= 2;
set Lis_PorCliente	:= 3;
if(Par_NumLis = Lis_Principal) then
	select Consecutivo,	Esc_Tipo,	EscrituraPublic,	NomApoderado

	from ESCRITURAPUB
	where ClienteID = Par_ClienteID


	limit 0, 15;
end if;

if(Par_NumLis = Lis_Poderes) then
	select 	EscrituraPublic,	NomApoderado, FechaEsc
	from 		ESCRITURAPUB
	where 	ClienteID 	= Par_ClienteID
	and   	Esc_Tipo 	= 'P';
end if;

if(Par_NumLis = Lis_PorCliente) then
	select 	EscrituraPublic,FechaEsc,EST.Nombre
	from 		ESCRITURAPUB ESC, 	ESTADOSREPUB EST
	where 	ClienteID 	= Par_ClienteID
	and   	Esc_Tipo 	= 'P'
	and ESC.EstadoIDEsc	= EST.EstadoID ;
end if;

END TerminaStore$$