-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCALENDARIOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCALENDARIOBAJ`;DELIMITER $$

CREATE PROCEDURE `SMSCALENDARIOBAJ`(
	Par_ArchCargaID		char(1),
	Par_Campania		int,

	Par_Salida			char(1),

	inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),
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
DECLARE  		SalidaSI			char(1);
DECLARE  		SalidaNO			char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';

delete from SMSCALENDARIO
		where 	ArchivoCargaID = Par_ArchCargaID
		and 	CampaniaID = Par_Campania;

if(Par_Salida = SalidaSI)then
	select	'000' as NumErr ,
		  "Fechas Eliminadas"  as ErrMen,
		'' as control,
		 Entero_Cero as consecutivo;
else
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 0;
		set  Par_ErrMen :=   "Fechas Eliminadas";
	end if;
end if;



END TerminaStore$$