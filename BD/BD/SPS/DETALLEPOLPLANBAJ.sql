-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPOLPLANBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPOLPLANBAJ`;DELIMITER $$

CREATE PROCEDURE `DETALLEPOLPLANBAJ`(
	Par_Poliza		bigint,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore:BEGIN

DELETE
	FROM 		DETALLEPOLPLAN
	WHERE 	PolizaID = Par_Poliza;

select '000' as NumErr ,
	  'La Detalle Poliza  Plantilla Eliminado' as ErrMen,
	  'polizaID' as control,
	  Par_Poliza as consecutivo;
END TerminaStore$$