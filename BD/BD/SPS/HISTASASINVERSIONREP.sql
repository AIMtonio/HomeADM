-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISTASASINVERSIONREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISTASASINVERSIONREP`;DELIMITER $$

CREATE PROCEDURE `HISTASASINVERSIONREP`(
	Par_TipoInversionID	int,
	Par_Fecha			date,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Var_Fecha		date;

DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;

Set Aud_FechaActual	:= NOW();

set Var_Fecha := (select ifnull(Max(His.Fecha), Fecha_Vacia)
			  from `HIS-TASASINVERSION` His
			  where His.Fecha <=  Par_Fecha
			    and His.TipoInversionID =  Par_TipoInversionID);

select Fecha, 		TipoInversionID,		PlazoInferior, PlazoSuperior, MontoInferior,
	MontoSuperior, 	ConceptoInversion,	FechaActual
	from `HIS-TASASINVERSION` His
	 where His.Fecha =  Var_Fecha
	   and His.TipoInversionID =  Par_TipoInversionID
	order by PlazoInferior, PlazoSuperior, MontoInferior, MontoSuperior;


END TerminaStore$$