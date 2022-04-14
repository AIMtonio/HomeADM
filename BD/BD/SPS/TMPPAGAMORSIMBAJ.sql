-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPPAGAMORSIMBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPPAGAMORSIMBAJ`;DELIMITER $$

CREATE PROCEDURE `TMPPAGAMORSIMBAJ`(
	Par_NumTranSim		bigint,
	Par_Salida			char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,

	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Estatus_Activo	char(1);
DECLARE	Salida_Si		char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;


Set	Estatus_Activo	:= 'A';
Set	Salida_Si		:= 'S';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;



if(not exists(select NumTransaccion from TMPPAGAMORSIM
				where NumTransaccion = Par_NumTranSim))then

		select '001' as NumErr ,
		"No Existen Amortizaciones para el Credito indicado, Reimprimir el Pagare." as ErrMen,
	  '' as control, '0' as consecutivo;

		LEAVE TerminaStore;
end if;

delete from TMPPAGAMORSIM
where NumTransaccion = Par_NumTranSim;

if(Par_Salida = Salida_Si)then
	select '000' as NumErr ,
		  concat("Amortizaciones con el numero de transaccion: ", convert(Par_NumTranSim, CHAR), "Eliminadas")  as ErrMen,
		  '' as control, '0' as consecutivo;
end if;

END TerminaStore$$