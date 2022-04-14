-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTARENDIAHOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTARENDIAHOBAJ`;


	Par_ConceptoAhoID 		int(11),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)


	DELETE
	FROM 		SUBCTARENDIAHO
	where  ConceptoAhoID 	= Par_ConceptoAhoID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoAhoID' as control;

END TerminaStore$$