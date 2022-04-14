-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPOCARTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPOCARTBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPOCARTBAJ`(
	Par_ConceptoCarID 		int(11),

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
	FROM 		SUBCTATIPOCART
	where  ConceptoCarID 	= Par_ConceptoCarID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoCarID' as control;

END TerminaStore$$