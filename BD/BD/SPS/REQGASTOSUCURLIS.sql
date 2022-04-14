-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCURLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCURLIS`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSUCURLIS`(
	Par_SucursalID 		int(11),
	Par_DesSucursal 		varchar(50),
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID 		int(11),
	Aud_Usuario       	int(11),
	Aud_FechaActual     	datetime,
	Aud_DireccionIP     	varchar(20),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
		)
TerminaStore: BEGIN


DECLARE	Entero_Cero		int;
DECLARE	Lis_EstAlta		int;
DECLARE	Lis_EstProc		int;
DECLARE	Est_Alta			char(1);
DECLARE	Est_Proc			char(1);


Set	Entero_Cero		:= 0;
Set	Lis_EstAlta		:= 1;
Set	Lis_EstProc		:= 2;
Set	Est_Alta			:= 'A';
Set	Est_Proc			:= 'P';


if(Par_NumLis = Lis_EstAlta) then
	select NumReqGasID, FechRequisicion
		from REQGASTOSUCUR
		where (EstatusReq = Est_Proc
		or 	EstatusReq = Est_Alta)
		and	SucursalID = Par_SucursalID
		limit 0, 15;
end if;



if(Par_NumLis = Lis_EstProc) then
	select Re.NumReqGasID, Re.FechRequisicion
		from REQGASTOSUCUR Re,
			 SUCURSALES	 Su
		where	Re.EstatusReq = Est_Proc
		and		Su.SucursalID = Re.SucursalID
		and 		Su.NombreSucurs like concat("%",Par_DesSucursal,"%")
		limit 0, 15;
end if;

END TerminaStore$$