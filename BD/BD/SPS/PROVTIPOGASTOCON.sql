-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVTIPOGASTOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVTIPOGASTOCON`;DELIMITER $$

CREATE PROCEDURE `PROVTIPOGASTOCON`(

	Par_ProveedorID	int(11),
	Par_TipoGastoID	int(11),
	Par_SucursalID	int(11),
	Par_TipoCon		int,

	Aud_Empresa	int(11),
	Aud_Usuario	int(11),
	Aud_FechaActual	datetime,
	Aud_DireccionIP	varchar(50),
	Aud_ProgramaID varchar(70),
	Aud_Sucursal	int(11),
	Aud_NumTransaccion	varchar(45)
	)
TerminaStore : BEGIN

DECLARE Entero_Cero int;
DECLARE Salida_SI char(1);
DECLARE Con_Sucursales int;

	Set Entero_Cero :=0;
	Set Salida_SI:='S';
	Set Con_Sucursales:= 2;

	if(Par_TipoCon = Con_Sucursales) then

		select ProveedorID,TipoGastoID,SucursalID from PROVTIPOGASTO where ProveedorID=Par_ProveedorID and TipoGastoID=Par_TipoGastoID;

	end if;


END TerminaStore$$