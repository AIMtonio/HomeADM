-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOCON`;DELIMITER $$

CREATE PROCEDURE `AMORTIZAFONDEOCON`(
	Par_FondeoKuboID		int,
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	Con_Principal		int;
DECLARE	Con_Foranea		int;


Set	Con_Principal		:= 1;
Set	Con_Foranea		:= 2;


if(Par_NumCon = Con_Principal) then
	select  FondeoKuboID,		AmortizacionID,	FechaInicio,		FechaVencimiento,	FechaExigible,
		   InteresGenerado, 	InteresRetener,  	PorcentajeInteres,Estatus,			SaldoProvision,
		   SaldInterPagado,	SaldInterReten,	EmpresaID,		Usuario,			FechaActual,
		   DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion
	from AMORTIZAFONDEO
	where FondeoKuboID = Par_FondeoKuboID;
end if;


END TerminaStore$$