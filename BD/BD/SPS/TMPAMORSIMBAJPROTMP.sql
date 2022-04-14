-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPAMORSIMBAJPROTMP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPAMORSIMBAJPROTMP`;DELIMITER $$

CREATE PROCEDURE `TMPAMORSIMBAJPROTMP`(
	Par_NumTranSim	bigint,
	out	NumErr		char(3),
	out	ErrMen		varchar(100)
	)
TerminaStore: BEGIN

DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;

Set	Estatus_Activo	:= 'A';
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;



if(not exists(select NumTransaccion from TMPPAGAMORSIM
				where NumTransaccion = Par_NumTranSim))then
		set NumErr :=  1 ;
		set ErrMen := 	'No existe el Temporal' ;
		LEAVE TerminaStore;
end if;

delete from TMPPAGAMORSIM
where NumTransaccion = Par_NumTranSim;

	set NumErr :=  0;
	set ErrMen :=   concat("Amortizaciones con el numero de transaccion: ", convert(Par_NumTranSim, CHAR), "Eliminadas") ;

END TerminaStore$$