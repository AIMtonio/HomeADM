-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORKUBOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORKUBOBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORKUBOBAJ`(
	Par_ConceptoKuboID 		int(11),

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
	FROM 		CUENTASMAYORKUBO
	where  ConceptoKuboID 	= Par_ConceptoKuboID;

select '000' as NumErr ,
	  'Cuenta Contable Eliminada' as ErrMen,
	  'ConceptoKuboID' as control;

END TerminaStore$$