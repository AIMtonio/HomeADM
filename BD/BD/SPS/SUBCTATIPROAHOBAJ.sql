-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROAHOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPROAHOBAJ`;


	Par_ConceptoAhoID 		int(11),
	Par_TipoProductoID		int(11),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)


	DELETE
	FROM 		SUBCTATIPROAHO
	where  ConceptoAhoID 	= Par_ConceptoAhoID
	and 	 TipoProductoID	= Par_TipoProductoID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoAhoID' as control;

END TerminaStore$$