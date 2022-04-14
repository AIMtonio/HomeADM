-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSNIVELRIESGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSNIVELRIESGOLIS`;DELIMITER $$

CREATE PROCEDURE `RATIOSNIVELRIESGOLIS`(
Par_RatiosPuntosID		int(11),
	Par_RatiosPorClasifID	int(11),
	Par_NumLis				tinyint  unsigned,

	Par_EmpresaID           int(11),
	Aud_Usuario             int,
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int(11),
	Aud_NumTransaccion      bigint(20)


	)
TerminaStore:BEGIN



DECLARE Lis_Combo		int;

set Lis_Combo			:=2;




END TerminaStore$$