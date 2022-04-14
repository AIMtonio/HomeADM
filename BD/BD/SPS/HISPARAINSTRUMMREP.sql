-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAINSTRUMMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPARAINSTRUMMREP`;



	Par_TipoRep			tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Rep_Principal		int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Rep_Principal		:= 1;


if(Par_TipoRep = Rep_Principal) then
	SELECT 	ConsecutivoID,	InstrumentMonID,	TipoInstruMonID,	FechaInicio,	FechaFin
			from HISPARAINSTRUMM;


end if;

END TerminaStore$$