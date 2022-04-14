-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AUTSOLCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AUTSOLCREDITOREP`;DELIMITER $$

CREATE PROCEDURE `AUTSOLCREDITOREP`(
	Par_SucursalID 		int(11),

	Par_EmpresaID		int,
    Aud_Usuario			int,
    Aud_FechaActual		DateTime,
    Aud_DireccionIP		varchar(15),
    Aud_ProgramaID		varchar(50),
    Aud_Sucursal		int,
    Aud_NumTransaccion	bigint
 )
TerminaStore:BEGIN

declare Var_EstadoID 		int(11);
declare Var_MunicipioID		int(11);
declare Var_NombreEstado	varchar(100);
declare Var_NombreMunicipio	varchar(100);
declare Var_NombreInsti		varchar(200);
declare Var_InstitucionID   int(11);

select InstitucionID
	into Var_InstitucionID
	from PARAMETROSSIS;

select Nombre
	into Var_NombreInsti
	from  INSTITUCIONES
	where InstitucionID = Var_InstitucionID;

Select suc.EstadoID, suc.MunicipioID
	into Var_EstadoID, Var_MunicipioID
	from SUCURSALES suc
	where suc.SucursalID = Par_SucursalID;

SELECT
	CONCAT(UPPER(LEFT(Nombre, 1)), LOWER(MID(Nombre,2)))
	into Var_NombreEstado
	FROM ESTADOSREPUB
	where EstadoID = Var_EstadoID;

Select CONCAT(UPPER(LEFT(Nombre, 1)), LOWER(MID(Nombre,2)))
	into Var_NombreMunicipio
	from MUNICIPIOSREPUB
	where EstadoID = Var_EstadoID
	and MunicipioID = Var_MunicipioID;

Select FUNCIONLETRASFECHA(FechaSistema) as Fecha,Var_NombreEstado, Var_NombreMunicipio, Var_NombreInsti
	from PARAMETROSSIS;


END Terminastore$$