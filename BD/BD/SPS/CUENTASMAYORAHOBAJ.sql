-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORAHOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORAHOBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORAHOBAJ`(
	Par_ConceptoAhoID 		int(11),

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
	FROM 		CUENTASMAYORAHO
	where  ConceptoAhoID 	= Par_ConceptoAhoID;

select '000' as NumErr ,
	  'Cuenta Contable Eliminada Exitosamente.' as ErrMen,
	  'conceptoAhoID' as control;

END TerminaStore$$