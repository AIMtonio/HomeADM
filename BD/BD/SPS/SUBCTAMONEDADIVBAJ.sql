-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDADIVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDADIVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDADIVBAJ`(
	Par_ConceptoMonID 		int(11),
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
	FROM 		SUBCTAMONEDADIV
	where  ConceptoMonID 	= Par_ConceptoMonID
	and 	 MonedaID			= Par_MonedaID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'monedaID' as control;

END TerminaStore$$