-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASBASEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASBASEACT`;DELIMITER $$

CREATE PROCEDURE `TASASBASEACT`(
	Par_TasaBaseID		int,
	Par_Valor			decimal(12,4),
	Par_FechaValor		date,
	Aud_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;

DECLARE VarFechaSis			date;
DECLARE VarFechaValorMax	date;
DECLARE	VarFechaMax			datetime;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set Aud_FechaActual := CURRENT_TIMESTAMP();


if(not exists(select TasaBaseID
			from TASASBASE
			where TasaBaseID = Par_TasaBaseID)) then
	select '001' as NumErr,
		 'El Numero de Tasa Base no existe.' as ErrMen,
		 'tasasBaseID' as control;
	LEAVE TerminaStore;
end if;

set VarFechaValorMax := (select max(Fecha)
						from `HIS-TASASBASE`
						where TasaBaseID = Par_TasaBaseID);

set VarFechaMax	:= (select max(FechaActual)
						from `HIS-TASASBASE`
						where TasaBaseID = Par_TasaBaseID and Fecha = VarFechaValorMax);

set VarFechaSis := (select FechaSistema from PARAMETROSSIS);

if (Par_FechaValor >= VarFechaValorMax) then

	update TASASBASE
		set	Valor = Par_Valor,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
	where TasaBaseID = Par_TasaBaseID;

end if;

call `HIS-TASASBASEALT`(
	Par_FechaValor,		Par_TasaBaseID,		Par_Valor, 			Aud_EmpresaID,		Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


	select '0' as NumErr,
		   'Valor de la Tasa Cambiado Exitosamente.' as ErrMen,
		   'tasaBaseID' as control;

END TerminaStore$$