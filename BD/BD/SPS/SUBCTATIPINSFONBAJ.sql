-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTATIPINSFONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTATIPINSFONBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTATIPINSFONBAJ`(
	Par_ConceptoFonID		int(11),
   Par_TipoFondeador     char(1),
	Par_tipoInstitID		int(11),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



DECLARE	SalidaNO	char(1);
DECLARE	SalidaSI	char(1);


Set	SalidaNO 		:='N';
set	SalidaSI		:= 'S';


  DELETE FROM SUBCTATIPINSFON where ConceptoFonID = Par_ConceptoFonID
								and tipoInstitID=Par_tipoInstitID and TipoFondeo=Par_TipoFondeador;



select '000' as NumErr ,
	  'SubCuenta  Eliminada' as ErrMen,
	  'subCuenta' as control;

END TerminaStore$$