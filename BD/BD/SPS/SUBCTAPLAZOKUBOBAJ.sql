-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOKUBOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOKUBOBAJ`;


	Par_ConceptoKuboID 		int(11),
	Par_NumRetiros 			int(11),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)


	DELETE
	FROM 		SUBCTAPLAZOKUBO
	where  ConceptoKuboID 	= Par_ConceptoKuboID
	and 	  NumRetiros			  = Par_NumRetiros;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'ConceptoKuboID' as control;

END TerminaStore$$