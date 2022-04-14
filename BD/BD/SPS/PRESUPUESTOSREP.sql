-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRESUPUESTOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRESUPUESTOSREP`;DELIMITER $$

CREATE PROCEDURE `PRESUPUESTOSREP`(

	Par_AnioInicio			int,
	Par_MesInicio 			int,
	Par_AnioFin				int,
	Par_MesFin 				int,
	Par_Estatus  			char(1),
	Par_EstatusDet 			char(1),
	Par_Sucursal			int,

	Par_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			date,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint

		)
TerminaStore :BEGIN



DECLARE Var_Sentencia 	varchar(5000);
DECLARE Var_Cadvacia 	char(1);
DECLARE Entero_Cero	INT;
DECLARE Mes_Enero 		INT;
DECLARE Mes_Diciembre  INT;

Set Var_Cadvacia 	:= '';
Set Entero_Cero 	:=0;
Set Mes_Enero 		:=1;
Set Mes_Diciembre 	:=12;

set Par_AnioInicio 	:= ifnull(Par_AnioInicio,Entero_Cero);
set Par_MesInicio  	:= ifnull(Par_MesInicio,Entero_Cero);
set Par_AnioFin    	:= ifnull(Par_AnioFin,Entero_Cero);
set Par_MesFin    	:= ifnull(Par_MesFin,Entero_Cero);
set Par_Sucursal	:= ifnull(Par_Sucursal,Entero_Cero);
set Par_Estatus 	:= ifnull(Par_Estatus,Var_Cadvacia);
set Par_EstatusDet	:= ifnull(Par_EstatusDet,Var_Cadvacia);




set Var_Sentencia := 	'Select convert(LPAD(Enc.FolioID, 8,"0"), char)  as  FolioEncID, ';
set Var_Sentencia :=CONCAT(Var_Sentencia,'   case 	when Enc.MesPresupuesto=1	then "ENERO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=2	then "FEBRERO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=3	then "MARZO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=4	then "ABRIL"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=5	then "MAYO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=6	then "JUNIO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=7	then "JULIO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=8	then "AGOSTO"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=9 	then "SEPTIEMBRE"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=10	then "OCTUBRE"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=11  then "NOVIEMBRE"');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 		when Enc.MesPresupuesto=12  then "DICIEMBRE"');
set Var_Sentencia :=CONCAT(Var_Sentencia,'   END  as NombreMes, Enc.MesPresupuesto, 	Enc.AnioPresupuesto,');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' Enc.Fecha, Enc.SucursalOrigen,Suc.NombreSucurs, Enc.UsuarioElaboro, ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' Usu.NombreCompleto, ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' case when Enc.Estatus="C" then "CERRADO" when Enc.Estatus="P" then "PENDIENTE" ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' end as EstatusEnc , Det.FolioID,');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' Det.Concepto, Tip.Descripcion as NombreConcep, Det.Descripcion, Det.Monto, Det.MontoDispon,');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' case when Det.Estatus="A" then "AUTORIZADO"	');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' when Det.Estatus="S" then "SOLICITADO" ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' when Det.Estatus="C" then "CANCELADO"	');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' when Det.Estatus="E" then "ELIMINADO" ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' end  as EstatusDet ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' from PRESUCURENC Enc ' );
set Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join  PRESUCURDET Det on Enc.FolioID = Det.EncabezadoID ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join SUCURSALES Suc ON Suc.SucursalID =  Enc.SucursalOrigen ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join USUARIOS Usu on Usu.UsuarioID=Enc.UsuarioElaboro ');
set Var_Sentencia := 	CONCAT(Var_Sentencia,' inner join TESOCATTIPGAS Tip on Det.Concepto=Tip.TipoGastoID ');

set Var_Sentencia :=CONCAT(Var_Sentencia,' 	where Enc.AnioPresupuesto	>=',   convert(Par_AnioInicio,char));
set Var_Sentencia :=CONCAT(Var_Sentencia,' 	  and Enc.AnioPresupuesto	<=',   convert(Par_AnioFin,char));
set Var_Sentencia :=CONCAT(Var_Sentencia,' 	and case when 	Enc.AnioPresupuesto	>',  convert(Par_AnioInicio,char));
set Var_Sentencia :=CONCAT(Var_Sentencia,' 			   and 	Enc.AnioPresupuesto	< ', convert(Par_AnioFin,char) , ' then ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 					Enc.MesPresupuesto	>= ',convert(Mes_Enero,char),' and  Enc.MesPresupuesto <=	',convert(Mes_Diciembre ,char));
set Var_Sentencia :=CONCAT(Var_Sentencia,' 			  when 	Enc.AnioPresupuesto =',  convert(Par_AnioInicio,char) , ' and ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 			    	Enc.AnioPresupuesto =',  convert(Par_AnioFin,char) , ' then ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 					Enc.MesPresupuesto	>=', convert(Par_MesInicio,char));
set Var_Sentencia :=CONCAT(Var_Sentencia,' 					and Enc.MesPresupuesto	<=', convert(Par_MesFin,char));
set Var_Sentencia :=CONCAT(Var_Sentencia,' 			  when 	Enc.AnioPresupuesto =',  convert(Par_AnioInicio,char) , ' and ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 			    	Enc.AnioPresupuesto !=',  convert(Par_AnioFin,char) , ' then ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 					Enc.MesPresupuesto	>=', convert(Par_MesInicio,char));

set Var_Sentencia :=CONCAT(Var_Sentencia,' 			  when 	Enc.AnioPresupuesto !=',  convert(Par_AnioInicio,char) , ' and ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 			    	Enc.AnioPresupuesto =',  convert(Par_AnioFin,char) , ' then ');
set Var_Sentencia :=CONCAT(Var_Sentencia,' 				 	Enc.MesPresupuesto	<=', convert(Par_MesFin,char));

set Var_Sentencia :=CONCAT(Var_Sentencia,' 		end');

if(Par_Sucursal!=Entero_Cero)then
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' and Enc.SucursalOrigen=',convert(Par_Sucursal,char));
end if;

if(Par_Estatus!=Var_Cadvacia)then
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' and Enc.Estatus="',convert(Par_Estatus,char),'"');
end if;

if(Par_EstatusDet!=Var_Cadvacia)then
	set Var_Sentencia := 	CONCAT(Var_Sentencia,' and Det.Estatus="',convert(Par_EstatusDet,char),'"');
end if;

set Var_Sentencia := 	CONCAT(Var_Sentencia,' order by Enc.SucursalOrigen, Enc.AnioPresupuesto,Enc.MesPresupuesto,  Enc.Fecha , Enc.FolioID, Det.FolioID asc;;');



SET @Sentencia	= (Var_Sentencia);

   PREPARE STFPRESUPUESTOSREP FROM @Sentencia;
   EXECUTE STFPRESUPUESTOSREP ;
   DEALLOCATE PREPARE STFPRESUPUESTOSREP;


END TerminaStore$$