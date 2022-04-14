-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASINVERSIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASINVERSIONBAJ`;DELIMITER $$

CREATE PROCEDURE `TASASINVERSIONBAJ`(
	Par_TasaInversionID	int,
	Par_TipoInversion	int,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


delete from TASASINVERSION
	where TipoInversionID = Par_TipoInversion ;

select '000' as NumErr,
	  'El registro a sido eliminado con exito' as ErrMen,
	  'TipoInversionID' as control;

END TerminaStore$$