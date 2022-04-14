-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORMONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORMONBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORMONBAJ`(
	Par_ConceptoMonID 		int(11),

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
	FROM 		CUENTASMAYORMON
	where  ConceptoMonID 	= Par_ConceptoMonID;

select '000' as NumErr ,
	  'Cuenta Contable Eliminada' as ErrMen,
	  'conceptoMonID' as control;

END TerminaStore$$