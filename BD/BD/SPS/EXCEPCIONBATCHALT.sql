-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EXCEPCIONBATCHALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `EXCEPCIONBATCHALT`;DELIMITER $$

CREATE PROCEDURE `EXCEPCIONBATCHALT`(
	Par_ProcesoBatchID	int,
	Par_Fecha			date,
	Par_Instrumento		varchar(45),
	Par_Descripcion		varchar(100),
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint

	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;


Set Aud_FechaActual	:= now();


insert into EXCEPCIONBATCH (
	ProcesoBatchID,		Fecha,				Instrumento,		Descripcion,		EmpresaID,
	Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
	NumTransaccion)
values (
	Par_ProcesoBatchID,	Par_Fecha,			Par_Instrumento,	Par_Descripcion,	Par_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	Aud_NumTransaccion);

END TerminaStore$$