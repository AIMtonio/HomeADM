-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DENOMOVSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DENOMOVSCON`;DELIMITER $$

CREATE PROCEDURE `DENOMOVSCON`(
	Par_CajaID			int,
	Par_SucursalID		int,
	Par_Fecha			date,
	Par_Moneda			int,
	Par_Denominacion	int,
	Par_NumCon			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN
-- declaracion de constantes
DECLARE		Con_Principal	int;
DECLARE		Con_Fecha		int;

DECLARE		Entero_Cero		int;
DECLARE		CadenaVacia		char(1);
Declare		FechaVacia		date;
declare		var_fecha		date;

-- declaracion de variables
-- asignacion de constantes
Set Con_Principal		:= 1;
Set Con_Fecha			:= 2;
Set Entero_Cero 		:= 0;
Set CadenaVacia			:= "";
set FechaVacia			:= '1900-01-01';

if (Par_NumCon = Con_Principal) then
	select SucursalID, CajaID, Fecha, Transaccion, Naturaleza, DenominacionID, Cantidad, Monto, MonedaID
	from DENOMINACIONMOVS
	where CajaID = Par_CajaID and SucursalID = Par_SucursalID;
end if;
if (Par_NumCon = Con_Fecha) then
	(select Distinct Fecha  from DENOMINACIONMOVS
		where CajaID = Par_CajaID
		and SucursalID = Par_SucursalID
		and MonedaID = Par_Moneda
		and Fecha = Par_Fecha)
	union
	(select Distinct Fecha  from `HIS-DENOMMOVS`
		where CajaID = Par_CajaID
		and SucursalID = Par_SucursalID
		and MonedaID = Par_Moneda
		and Fecha = Par_Fecha);

end if;
END TerminaStore$$