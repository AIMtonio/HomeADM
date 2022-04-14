-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGLIBAMORACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGLIBAMORACT`;


	Par_Consecutivo		int,
	Par_Capital			decimal(12,2),

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)



declare Entero_Cero	int;


set	Entero_Cero			:= 0;


update TMPPAGAMORSIM set
	Tmp_Capital	= Par_Capital
where Tmp_Consecutivo = Par_Consecutivo
and 	 NumTransaccion = Aud_NumTransaccion;

select '000' as NumErr ,
	  'Monto Actualizado' as ErrMen,
	  'capital' as control;


END TerminaStore$$