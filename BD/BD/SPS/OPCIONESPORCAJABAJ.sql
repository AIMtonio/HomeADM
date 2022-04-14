-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESPORCAJABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESPORCAJABAJ`;DELIMITER $$

CREATE PROCEDURE `OPCIONESPORCAJABAJ`(
	Par_TipoCaja			char(2),

	Par_Salida		      	char(1),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion 		bigint
	)
TerminaStore: BEGIN


declare	Salida_SI			char(1);
declare Entero_Cero			int(1);
declare Par_NumErr			int(11);
declare Par_ErrMen		varchar(45);


set	Salida_SI			:= 'S';
set Entero_Cero			:= 0;

delete from OPCIONESPORCAJA
		where TipoCaja = Par_TipoCaja;

if (Par_Salida = Salida_SI) then
	select 	000 	as NumErr,
			"Opciones Eliminadas Exitosamente."	as ErrMen,
		   'tipoCaja' as control,
			Entero_Cero as consecutivo;
else
	set	Par_NumErr := 0;
	set	Par_ErrMen := "Opciones Eliminadas Exitosamente.";
end if;

END TerminaStore$$