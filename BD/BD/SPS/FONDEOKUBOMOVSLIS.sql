-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOKUBOMOVSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOKUBOMOVSLIS`;DELIMITER $$

CREATE PROCEDURE `FONDEOKUBOMOVSLIS`(
	Par_FondeoKuboID			int,
	Par_NumLista			tinyint unsigned,
	Par_EmpresaID			int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Lis_Princip		int;



Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Princip		:= 1;




if(Par_NumLista = Lis_Princip)then

	select	Mov.AmortizacionID,	Mov.FechaOperacion,	Mov.Descripcion,	Tip.Descripcion as TipoMovCreID,	Mov.NatMovimiento,
			Mov.Cantidad
			from		FONDEOKUBOMOVS Mov,
					TIPOSMOVSKUBO Tip
			where	Mov.FondeoKuboID 	= Par_FondeoKuboID
			and		Mov.TipoMovKuboID 	= Tip.TipoMovKuboID;
end if;


END TerminaStore$$