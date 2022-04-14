-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCAJEROSATMLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCAJEROSATMLIS`;DELIMITER $$

CREATE PROCEDURE `CATCAJEROSATMLIS`(
	Par_CajeroID			varchar(20),
	Par_Nombre				varchar(50),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint
	)
TerminaStore:BEGIN



DECLARE Lis_Usuario		int;
DECLARE Lis_PorUSuario	int;
DECLARE EstatusActivo	char(1);


set Lis_Usuario			:=1;
set Lis_PorUSuario		:=2;
set EstatusActivo		:='A';

if (Lis_Usuario = Par_NumLis)then
	select CajeroID,U.NombreCompleto, S.NombreSucurs
		from 	CATCAJEROSATM C
		left join	USUARIOS U	on U.UsuarioID=C.UsuarioID
		left join SUCURSALES S	on S.SucursalID = C.SucursalID
		where U.NombreCompleto like concat("%", Par_Nombre, "%")
		limit 0, 15 ;
end if;

if (Lis_PorUSuario = Par_NumLis)then
	select CajeroID,U.Clave, S.NombreSucurs,substring(C.Ubicacion,1,30) as Ubicacion
		from 	CATCAJEROSATM C
		left join	USUARIOS U	on U.UsuarioID=C.UsuarioID
		left join SUCURSALES S	on S.SucursalID = C.SucursalID
		where ( U.NombreCompleto like concat("%", Par_Nombre, "%")
				or C.CajeroID	like concat("%", Par_Nombre, "%") )

		limit 0, 15;

end if;

END TerminaStore$$