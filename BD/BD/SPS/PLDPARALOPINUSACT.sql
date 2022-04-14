-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPARALOPINUSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPARALOPINUSACT`;DELIMITER $$

CREATE PROCEDURE `PLDPARALOPINUSACT`(


	Par_FolioID				int,

	Aud_EmpresaID				int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal				int,
	Aud_NumTransaccion		bigint

)
TerminaStore: BEGIN

DECLARE CompEstatus		int;

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
Declare	Estatus_B		char(1);
Declare	Fecha_Vig		Date;


Set	Cadena_Vacia			:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set Estatus_B				:= 'B';

if(not exists(select FolioID
			from PLDPARALEOPINUS
			where FolioID = Par_FolioID)) then
	select '001' as NumErr,
		 'No existen Parametros para el folio.' as ErrMen,
		 'folioID' as control;
	LEAVE TerminaStore;
end if;

set Fecha_Vig := (select FechaSistema from PARAMETROSSIS);

			update PLDPARALEOPINUS set
			Estatus 			= Estatus_B,
			FechaVigencia		= Fecha_Vig
			where FolioID		= Par_FolioID;

	select '0' as NumErr,
		   concat('El Folio ',Par_FolioID, ' se ha dado de Baja Exitosamente.')as ErrMen,
		   'folioID' as control;

END TerminaStore$$