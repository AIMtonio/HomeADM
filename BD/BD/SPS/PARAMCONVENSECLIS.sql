-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMCONVENSECLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMCONVENSECLIS`;DELIMITER $$

CREATE PROCEDURE `PARAMCONVENSECLIS`(
	Par_SucursalID     	int(11),
	Par_Fecha			date,
	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int(11),
    Aud_Usuario			int(11),
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(20),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)
)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int(11);
DECLARE	Decimal_Cero	decimal(12,2);
DECLARE Lis_Principal	int(11);
DECLARE Lis_ComboGral   int(11);
DECLARE Lis_ComboSecc   int(11);
DECLARE Lis_ComSucuGral	int(11);
DECLARE Lis_ComSucuSecc	int(11);
DECLARE GralSI          char(1);
DECLARE GralNo          char(1);


DECLARE Var_FechaSistema    date;


Set Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Decimal_Cero		:= 0.0;
Set Lis_Principal		:= 1;
Set Lis_ComboGral       := 2;
Set Lis_ComboSecc       := 3;
Set Lis_ComSucuGral		:= 4;
Set Lis_ComSucuSecc		:= 5;
Set GralSI              := 'S';
Set	GralNo 				:= 'N';



if(Par_NumLis = Lis_Principal) then
		select P.SucursalID, S.NombreSucurs, P.Fecha, P.CantSocio, P.EsGral
		from PARAMCONVENSEC P inner join SUCURSALES S on P.SucursalID = S.SucursalID;
end if;

Set Var_FechaSistema:= (select FechaSistema from PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);



if(Par_NumLis = Lis_ComboGral) then
		select P.Fecha
		from PARAMCONVENSEC P
		where P.EsGral= GralSI and year(P.Fecha)=year(Var_FechaSistema);
end if;



if(Par_NumLis = Lis_ComboSecc) then
		select distinct(P.Fecha)
		from PARAMCONVENSEC P
		where P.EsGral= GralNo and year(P.Fecha)=year(Var_FechaSistema);
end if;



if(Par_NumLis = Lis_ComSucuGral) then
		select P.SucursalID,S.NombreSucurs
		from PARAMCONVENSEC P inner join SUCURSALES S on P.SucursalID = S.SucursalID
	 	where P.EsGral= GralSI  and P.Fecha = Par_Fecha and year(P.Fecha)=year(Var_FechaSistema);

end if;



if(Par_NumLis = Lis_ComSucuSecc) then
		select P.SucursalID,S.NombreSucurs
		from PARAMCONVENSEC P inner join SUCURSALES S on P.SucursalID = S.SucursalID
	 	where P.EsGral= GralNo  and P.Fecha = Par_Fecha and year(P.Fecha)=year(Var_FechaSistema);

end if;


END TerminaStore$$