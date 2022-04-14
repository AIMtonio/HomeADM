-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDAINVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDAINVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDAINVBAJ`(
	Par_ConceptoInverID 		int(5),
	Par_MonedaID 			int(11),

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
	FROM 		SUBCTAMONEDAINV
	where  ConceptoInverID 	= Par_ConceptoInverID
	and 	 MonedaID			= Par_MonedaID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoInverID' as control;

END TerminaStore$$