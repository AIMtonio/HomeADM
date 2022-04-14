-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPROINVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPROINVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPROINVBAJ`(
	Par_ConceptoInverID 		int(11),
	Par_TipoProductoID		int(11),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

	DELETE
	FROM 		SUBCTATIPROINV
	where  ConceptoInverID	= Par_ConceptoInverID
	and 	 TipoProductoID	= Par_TipoProductoID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoInverID' as control;

END TerminaStore$$