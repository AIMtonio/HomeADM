-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MOVSANTGASTOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MOVSANTGASTOSREP`;DELIMITER $$

CREATE PROCEDURE `MOVSANTGASTOSREP`(
	Par_FechaInicial	    date,
	Par_FechaFinal		    date,
	Par_TipoOperacion	 	bigint,
	Par_Naturaleza		    char,
	Par_Sucursal          	bigint,
	Par_CajaID				bigint,

	Par_EmpresaID			int,
    Aud_Usuario		    	int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID		    varchar(50),
	Aud_Sucursal		    int,
	Aud_NumTransaccion		bigint


	)
TerminaStore: BEGIN

DECLARE	Var_Sentencia		varchar(8000);
DECLARE	Var_SentenUnion		varchar(8000);


DECLARE Entero_Cero     	int;
DECLARE EstatusVigente   	char(1);
DECLARE EstatusVencido   	char(1);
DECLARE EstatusActivas   	char(1);
DECLARE EstatusBloqueadas   char(1);
DECLARE Cadena_Vacia		char(1);

SET Entero_Cero      		:= 0;
SET EstatusVigente   		:='V';
SET EstatusVencido   		:='B';
SET EstatusActivas   		:='A';
SET EstatusBloqueadas   	:='B';
SET Cadena_Vacia			:='';

set Var_Sentencia := CONCAT('select	Mov.Fecha, Mov.SucursalID,Suc.NombreSucurs,Mov.CajaID,Us.Clave,Tip.Descripcion, Mov.EmpleadoID,Emp.NombreCompleto,
								    Mov.MontoOpe, case Mov.Naturaleza when "S" then "SALIDA" when "E" then "ENTRADA" end as Naturaleza,
									(select ifnull(sum(MontoOpe),0.00) from MOVSANTGASTOS	where Fecha  between ? and ? and Naturaleza="S"');
if Par_TipoOperacion != Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and TipoOperacion = ',Par_TipoOperacion);
end if;
if Par_Sucursal!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and SucursalID= ',Par_Sucursal);
end if;

if Par_CajaID!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and CajaID= ',Par_CajaID);
end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia, ') as sumSal,(select ifnull(sum(MontoOpe),0.00) from MOVSANTGASTOS	where Fecha  between  ? and ?
													 and Naturaleza="E"');

if Par_TipoOperacion != Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and TipoOperacion = ',Par_TipoOperacion);
end if;
if Par_Sucursal!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and SucursalID= ',Par_Sucursal);
end if;
if Par_CajaID!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and CajaID= ',Par_CajaID);
end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia, ') as sumEnt ');

set Var_Sentencia :=  CONCAT(Var_Sentencia, ' from MOVSANTGASTOS Mov
									inner join SUCURSALES Suc on Suc.SucursalID=Mov.SucursalID
									inner join CAJASVENTANILLA CV on CV.CajaID=Mov.CajaID
									inner join USUARIOS Us on Us.UsuarioID=CV.UsuarioID
									left outer join EMPLEADOS Emp on Emp.EmpleadoID=Mov.EmpleadoID
									inner join TIPOSANTGASTOS Tip on Tip.TipoAntGastoID=Mov.TipoOperacion
										where Mov.Fecha  between ? and ?  ');

if Par_TipoOperacion != Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Mov.TipoOperacion = ',Par_TipoOperacion);

end if;

if Par_Naturaleza != Cadena_Vacia then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and  Mov.Naturaleza= "',Par_Naturaleza,'"');
end if;

if Par_Sucursal!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Mov.SucursalID= ',Par_Sucursal);
end if;

if Par_CajaID!=Entero_Cero then
		set Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Mov.CajaID= ',Par_CajaID);
end if;

set Var_Sentencia :=  CONCAT(Var_Sentencia, '; ');



SET @Sentencia	= (Var_Sentencia);
SET @FechaInicio	= Par_FechaInicial;
SET @FechaFin		= Par_FechaFinal;


PREPARE STMOVSANTGASTOSREP FROM @Sentencia;
EXECUTE STMOVSANTGASTOSREP USING @FechaInicio,@FechaFin,@FechaInicio,@FechaFin,@FechaInicio,@FechaFin;
DEALLOCATE PREPARE STMOVSANTGASTOSREP;


END TerminaStore$$