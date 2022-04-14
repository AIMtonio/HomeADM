-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOBAJ`;DELIMITER $$

CREATE PROCEDURE `AMORTIZAFONDEOBAJ`(
	Par_CreditoFondeoID		bigint(20),
	Par_NumBaj				tinyint unsigned,
	Par_Salida		      	char(1),
	inout Par_NumErr		int(11),
	inout Par_ErrMen		varchar(350),

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion 		bigint
	)
TerminaStore: BEGIN


DECLARE	Salida_SI			char(1);


set	Salida_SI			:= 'S';

delete from AMORTIZAFONDEO
	where CreditoFondeoID = Par_CreditoFondeoID;


if (Par_Salida = Salida_SI) then
	select 	000 	as NumErr,
			"Amortizaciones Eliminadas."	as ErrMen,
		   'creditoFondeoID' as control,
			Par_CreditoFondeoID as consecutivo;
else
	set	Par_NumErr := 0;
	set	Par_ErrMen := "Amortizaciones Eliminadas.";
end if;

END TerminaStore$$