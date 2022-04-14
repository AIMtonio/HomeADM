-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIASPASOVENCIDOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIASPASOVENCIDOLIS`;DELIMITER $$

CREATE PROCEDURE `DIASPASOVENCIDOLIS`(
	Par_ProducCreditoID int(11),
	Par_NumLis		    tinyint unsigned,

	Par_EmpresaID       int(11),
	Aud_Usuario         int(11),
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int(11),
	Aud_NumTransaccion  bigint(20)
	)
TerminaStore:BEGIN


DECLARE listaProducto	int;

set listaProducto		:=1;


if(Par_NumLis=listaProducto)then
	select ProducCreditoID,Frecuencia, DiasPasoVencido
		from DIASPASOVENCIDO
		where ProducCreditoID=Par_ProducCreditoID;
end if;

END TerminaStore$$