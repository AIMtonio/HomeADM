-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCARBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCARBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORCARBAJ`(
	Par_ConceptoCarID 		int(11),

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
	FROM 		CUENTASMAYORCAR
	where  ConceptoCarID 	= Par_ConceptoCarID;

select '000' as NumErr ,
	  'Cuenta Eliminada Exitosamente.' as ErrMen,
	  'ConceptoCarID' as control;

END TerminaStore$$