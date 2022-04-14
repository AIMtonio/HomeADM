-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPODIVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPODIVBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPODIVBAJ`(
	Par_ConceptoMonID 		int(11),

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
	FROM 		SUBCTATIPODIV
	where  ConceptoMonID 	= Par_ConceptoMonID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'billetes' as control;

END TerminaStore$$