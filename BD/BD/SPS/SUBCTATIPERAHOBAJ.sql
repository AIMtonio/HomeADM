-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPERAHOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPERAHOBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPERAHOBAJ`(
	Par_ConceptoAhoID 		int(11),

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
	FROM 		SUBCTATIPERAHO
	where  ConceptoAhoID 	= Par_ConceptoAhoID;

select '000' as NumErr ,
	  'SubCuenta Contable Eliminada' as ErrMen,
	  'conceptoAhoID' as control;

END TerminaStore$$