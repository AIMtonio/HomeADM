-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUBCLASIFCARTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTASUBCLASIFCARTBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTASUBCLASIFCARTBAJ`(
	Par_ConceptoCarID 		int(11),
	Par_ProducCreditoID 	int(11),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

	DELETE FROM   SUBCTASUBCLACART
	where  ConceptoCarID = Par_ConceptoCarID
	and    ClasificacionID = Par_ProducCreditoID;

select '000' as NumErr ,
	  'SubCuenta Eliminada Exitosamente' as ErrMen,
	  'subCuenta5' as control;

END TerminaStore$$