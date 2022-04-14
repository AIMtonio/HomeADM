-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASTRANSFERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASTRANSFERLIS`;DELIMITER $$

CREATE PROCEDURE `CAJASTRANSFERLIS`(
	Par_SucursalID		int,
	Par_CajaID			int,
	Par_NumLis			int,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

DECLARE		Lis_Principal	int;
DECLARE		Lis_Foranea	int;

Set	Lis_Principal	:= 1;
Set	Lis_Foranea		:= 2;

if(Par_NumLis = Lis_Principal) then
	select CAJ.CajasTransferID, SUC.NombreSucurs, CAJ.CajaOrigen, upper(U.Clave) as Clave
	FROM CAJASTRANSFER CAJ
	inner join SUCURSALES SUC ON CAJ.SucursalOrigen = SUC.SucursalID
	inner join USUARIOS U ON CAJ.Usuario = U.UsuarioID
	where CAJ.CajaDestino = Par_CajaID AND CAJ.Estatus = 'A'
	group by CajasTransferID, SUC.NombreSucurs, CAJ.CajaOrigen, U.Clave;
end if;

END TerminaStore$$