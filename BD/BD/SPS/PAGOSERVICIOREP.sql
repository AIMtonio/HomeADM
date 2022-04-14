-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSERVICIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSERVICIOREP`;DELIMITER $$

CREATE PROCEDURE `PAGOSERVICIOREP`(
	Par_FechaInicio			date,
	Par_FechaFin			date,
	Par_Sucursal			int(11),
	Par_Servicio			int(11),
	Par_OrigenPago			char(1),

	Par_EmpresaID       	int,
    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint
	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 		varchar(9000);


DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         date;
DECLARE Entero_Cero         int;
DECLARE Con_TodoOrigen		char(1);


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
set Con_TodoOrigen		:='T';


set Var_Sentencia := "select ps.SucursalID, NombreSucurs, ps.CatalogoServID, NombreServicio,
Fecha, Referencia, CajaID, ps.MontoServicio,
IvaServicio, Comision, IVAComision, Aplicado,ps.OrigenPago
from PAGOSERVICIOS ps, CATALOGOSERV cs, SUCURSALES sc
where ps.CatalogoServID = cs.CatalogoServID
and ps.SucursalID = sc.SucursalID";

set Par_FechaInicio :=ifnull(Par_FechaInicio,Fecha_Vacia);
set Par_FechaFin :=ifnull(Par_FechaFin,Fecha_Vacia);
if(Par_FechaInicio!=Fecha_Vacia) then
	if(Par_FechaFin!=Fecha_Vacia) then
			set Var_Sentencia:= 	CONCAT(Var_Sentencia, " and Fecha >= '",Par_FechaInicio,"'");
			set Var_Sentencia:= 	CONCAT(Var_Sentencia, " and Fecha <= '",Par_FechaFin,"'");
	end if;
end if;

set Par_Sucursal :=ifnull(Par_Sucursal,Entero_Cero);

	if(Par_Sucursal!= Entero_Cero) then
			set Var_Sentencia := CONCAT(Var_Sentencia,'  and ps.SucursalID = ',convert(Par_Sucursal,char));
	end if;

set Par_Servicio :=ifnull(Par_Servicio,Entero_Cero);

	if(Par_Servicio!= Entero_Cero) then
			set Var_Sentencia := CONCAT(Var_Sentencia,'  and ps.CatalogoServID = "',Par_Servicio,'"');
	end if;
	if(Par_OrigenPago<>Con_TodoOrigen) then
			set Var_Sentencia	:=CONCAT(Var_Sentencia," and ps.OrigenPago like '%",Par_OrigenPago,"%'");
	end if;



set Var_Sentencia := CONCAT(Var_Sentencia,'  order by SucursalID, CatalogoServID, Fecha ;');

SET @Sentencia	= (Var_Sentencia);


    PREPARE PAGOSERVICIOREPREP FROM @Sentencia;
    EXECUTE PAGOSERVICIOREPREP;
    DEALLOCATE PREPARE PAGOSERVICIOREPREP;


END TerminaStore$$