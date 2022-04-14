-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AREASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AREASALT`;DELIMITER $$

CREATE PROCEDURE `AREASALT`(
	Par_Descripcion		varchar(200),
	out Par_AreaID		bigint,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint


	)
TerminaStore: BEGIN

DECLARE	Area			bigint;


DECLARE  Entero_Cero       int;
DECLARE  Decimal_Cero      decimal(12,2);
DECLARE	Cadena_Vacia		char(1);



set Entero_Cero 			:=0;
Set Cadena_Vacia			:= '';
set Decimal_Cero 			:=0.00;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

set Area := (select ifnull(Max(AreaID),Entero_Cero) + 1
from AREAS);
set Par_AreaID := Area;
insert into AREAS (AreaID,			Descripcion,			EmpresaID,	 	Usuario,				FechaActual,
				 DireccionIP,		ProgramaID,			Sucursal,	 	NumTransaccion)

 values			(Area,			Par_Descripcion,		Aud_EmpresaID,	 Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,  Aud_ProgramaID,		Aud_Sucursal,		 Aud_NumTransaccion);


select '000' as NumErr ,
		  'Area Guardada.' as ErrMen,
		  'areaID' as control;

END TerminaStore$$