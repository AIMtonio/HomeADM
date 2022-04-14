-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EJECIERREXDIASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EJECIERREXDIASPRO`;DELIMITER $$

CREATE PROCEDURE `EJECIERREXDIASPRO`(
	Par_NumDias			int,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE	Contador		int;


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;




Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Contador			:= 1;


	WHILE Contador <= Par_NumDias DO


		set Aud_FechaActual := DATE_ADD(Aud_FechaActual,INTERVAL Contador DAY);

		call CIERREGENERALPRO (
			Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion);

		Set Contador = Contador + 1;

	END WHILE;


END TerminaStore$$