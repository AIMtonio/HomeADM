-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAPRODUCCARTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAPRODUCCARTBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCTAPRODUCCARTBAJ`(
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

	DELETE
	FROM 		SUBCTAPRODUCCART
	where  ConceptoCarID 	= Par_ConceptoCarID
	and 	  ProducCreditoID	= Par_ProducCreditoID;

select '000' as NumErr ,
	  'Subcuenta Eliminada Exitosamente' as ErrMen,
	  'conceptoCarID' as control;

END TerminaStore$$