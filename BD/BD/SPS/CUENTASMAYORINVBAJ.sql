-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORINVBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORINVBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORINVBAJ`(
	Par_ConceptoInvID 		int(11),

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
	FROM 		CUENTASMAYORINV
	where  ConceptoInvID 	= Par_ConceptoInvID;

select '000' as NumErr ,
	  'Cuenta Contable Eliminada' as ErrMen,
	  'conceptoInvID' as control;

END TerminaStore$$