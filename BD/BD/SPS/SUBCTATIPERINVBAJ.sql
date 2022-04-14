-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERINVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERINVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERINVBAJ`(
	Par_ConceptoInverID 		int(11),

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
	FROM 		SUBCTATIPERINV
	where  ConceptoInverID 	= Par_ConceptoInverID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoInverID' as control;

END TerminaStore$$