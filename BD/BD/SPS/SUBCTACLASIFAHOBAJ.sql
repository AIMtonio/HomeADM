-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTACLASIFAHOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTACLASIFAHOBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTACLASIFAHOBAJ`(
	Par_ConceptoAhoID	int(5),
	Par_Clasificacion	char(1),
	Par_EmpresaID 		int(11),

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia		char(1);
DECLARE		Entero_Cero			int;
DECLARE		Float_Cero			float;
DECLARE		NumSubCuenta			int;

Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Float_Cero			:= 0.0;
Set 	NumSubCuenta			:= 0;

Set Aud_FechaActual := CURRENT_TIMESTAMP();

DELETE
	FROM 		SUBCTACLASIFAHO
	where	ConceptoAhoID 	= Par_ConceptoAhoID
	and		Clasificacion	= Par_Clasificacion;

select '000' as NumErr,
	  concat("Subcuenta Eliminada Exitosamente: ", convert(Par_ConceptoAhoID, CHAR))  as ErrMen,
	  'conceptoAhoID' as control;
END TerminaStore$$