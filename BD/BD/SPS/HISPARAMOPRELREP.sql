-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPARAMOPRELREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPARAMOPRELREP`;DELIMITER $$

CREATE PROCEDURE `HISPARAMOPRELREP`(

	Par_TipoRep			tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Rep_Principal		int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Rep_Principal		:= 1;


if(Par_TipoRep = Rep_Principal) then
	select	ConsecutivoID,	MonedaLimOPR,		LimiteInferior, 	FechaInicioVig, 	FechaFinVig,
			LimMensualMicro,	MonedaLimMicro
	from HISPARAMOPREL
	order by FechaInicioVig DESC, ConsecutivoID DESC;


end if;

END TerminaStore$$