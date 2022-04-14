-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CENTROCOSTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CENTROCOSTOSLIS`;DELIMITER $$

CREATE PROCEDURE `CENTROCOSTOSLIS`(
	Par_Descripcion		varchar(100),
	Par_NumLis			tinyint unsigned,
    Par_ProrrateoID		int(11),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Lis_Principal 		int;
DECLARE Lis_gridCajas		int;
DECLARE Lis_gridConCajas	int;
DECLARE Estatus_Activo		char(1);

DECLARE Var_EmpresaID 		int;


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal		:= 1;
Set Lis_gridCajas		:= 2;
Set Lis_gridConCajas	:= 3;
Set Estatus_Activo		:= 'A';


Set Var_EmpresaID	:= 0;

if(Par_NumLis = Lis_Principal) then
	select	CentroCostoID,		Descripcion,	Responsable,	PlazaID
	from CENTROCOSTOS
	where Descripcion like concat("%", Par_Descripcion, "%")
	limit 0, 15;
end if;

if(Par_NumLis = Lis_gridCajas) then
	set Var_EmpresaID := (select EmpresaID from PARAMETROSSIS);
		select CC.CentroCostoID, CC.Descripcion,
		ifnull(CP.ProrrateoID,0) as ProrrateoID, ifnull(CP.Porcentaje,0) as Porcentaje
			from CENTROCOSTOS CC LEFT JOIN CENTROSPRORRATEO CP
				on CC.CentroCostoID = CP.CentroCostoID and CP.ProrrateoID=Par_ProrrateoID
					where CC.EmpresaID=Var_EmpresaID;
end if;

if(Par_NumLis = Lis_gridConCajas) then
	set Var_EmpresaID := (select EmpresaID from PARAMETROSSIS);
		select CC.CentroCostoID, CC.Descripcion,
		ifnull(CP.ProrrateoID,0) as ProrrateoID, ifnull(CP.Porcentaje,0) as Porcentaje
			from CENTROCOSTOS CC INNER JOIN CENTROSPRORRATEO CP
				on CC.CentroCostoID = CP.CentroCostoID
						and CP.ProrrateoID=Par_ProrrateoID
									INNER JOIN PRORRATEOCONTABLE PC on PC.ProrrateoID=Par_ProrrateoID
										and PC.Estatus=Estatus_Activo
											where CC.EmpresaID=Var_EmpresaID;
end if;

END TerminaStore$$