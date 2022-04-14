-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RATIOSPUNTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RATIOSPUNTOSLIS`;DELIMITER $$

CREATE PROCEDURE `RATIOSPUNTOSLIS`(
	Par_RatiosPuntosID		int(11),
	Par_RatiosPorClasifID	int(11),

	Par_NumLis				TINYINT UNSIGNED,

	Par_EmpresaID           int(11),
	Aud_Usuario             int,
	Aud_FechaActual         DateTime,
	Aud_DireccionIP         varchar(15),
	Aud_ProgramaID          varchar(50),
	Aud_Sucursal            int(11),
	Aud_NumTransaccion      bigint(20)
	)
TerminaStore:BEGIN



DECLARE Lis_EstabilidadEmpleo	int;


set Lis_EstabilidadEmpleo	:=2;

if(Par_NumLis = Lis_EstabilidadEmpleo)then
select RatiosPuntosID, Descripcion
		from RATIOSPUNTOS
			where RatiosPorClasifID = Par_RatiosPorClasifID;
end if;


END TerminaStore$$