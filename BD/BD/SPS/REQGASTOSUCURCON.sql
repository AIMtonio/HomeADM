-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCURCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCURCON`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSUCURCON`(
	Par_NumReqGasID      int(11),
	Par_NumCon       	   int(11),

	Aud_EmpresaID        int(11),
	Aud_Usuario          int(11),
	Aud_FechaActual      datetime,
	Aud_DireccionIP      varchar(15),
	Aud_ProgramaID       varchar(60),
	Aud_Sucursal         int(11),
	Aud_NumTransaccion   int(15)
		)
TerminaStore: BEGIN


DECLARE Entero_Cero	int;
DECLARE Cadena_Vacia 	char(1);
DECLARE Con_Principal int;
DECLARE Con_CuentaAho int;
DECLARE Var_FormaPago	char(1);
DECLARE Var_Efectivo	char(1);
DECLARE Var_Principal char(1);


Set Entero_Cero	:= 0;
Set Cadena_Vacia	:='';
Set Con_Principal	:= 1;
Set Con_CuentaAho	:= 2;
Set Var_Principal	:='S';
Set Var_Efectivo	:='E';

if (Par_NumCon=Con_Principal ) then
	select	R.NumReqGasID,	R.SucursalID,		R.UsuarioID,		R.FechRequisicion,	R.FormaPago,
			R.EstatusReq, 	R.TipoGasto, 		S.NombreSucurs, 	U.Nombre
	from 	REQGASTOSUCUR R,
			SUCURSALES S,
			USUARIOS U
	where 	R.NumReqGasID 	= Par_NumReqGasID
	and 		S.SucursalID	= R.SucursalID
	and		U.UsuarioID= R.UsuarioID;
end if;

if (Par_NumCon=Con_CuentaAho ) then
	select	Par.BancoCaptacion as InstitucionID, Cta.NumCtaInstit
	 from 	PARAMETROSSIS Par,
			CUENTASAHOTESO Cta
	where 	Cta.InstitucionID = Par.BancoCaptacion
	and 		Cta.Principal= Var_Principal;

end if;

END TerminaStore$$