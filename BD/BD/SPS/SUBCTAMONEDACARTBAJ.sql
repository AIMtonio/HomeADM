-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDACARTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDACARTBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDACARTBAJ`(
	Par_ConceptoCarID 	int(11),
	Par_MonedaID 		int(11),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore : BEGIN
	DELETE FROM   SUBCTAMONEDACART
	where  ConceptoCarID = Par_ConceptoCarID
	and    MonedaID = Par_MonedaID;

	select '000' as NumErr ,
	  'SubCuenta Eliminada Exitosamente' as ErrMen,
	  'subCuenta1' as control;

END TerminaStore$$