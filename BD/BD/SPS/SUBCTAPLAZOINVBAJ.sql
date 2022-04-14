-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPLAZOINVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPLAZOINVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPLAZOINVBAJ`(
	Par_ConceptoInverID 		int(11),
	Par_SubCtaPlazoInvID		int(5),

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

	DELETE
	FROM 		SUBCTAPLAZOINV
	where  ConceptoInverID		= Par_ConceptoInverID
	and 	 SubCtaPlazoInvID	= Par_SubCtaPlazoInvID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoInverID' as control;

END TerminaStore$$