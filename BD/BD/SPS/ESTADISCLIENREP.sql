-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADISCLIENREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADISCLIENREP`;DELIMITER $$

CREATE PROCEDURE `ESTADISCLIENREP`(
      Par_Sucursal		int,
      Par_Promotor		int,
      Par_Genero			char(1),
      Par_Estado			int,
      Par_Municipio		int,

      Aud_Empresa		int,
      Aud_Usuario		int,
      Aud_FechaActual		DateTime,
      Aud_DireccionIP		varchar(15),
      Aud_ProgramaID		varchar(50),
      Aud_Sucursal		int,
      Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN






DECLARE Var_SucursalIni             int;
DECLARE Var_SucursalFin             int;
DECLARE Var_PromotorIni             int;
DECLARE Var_PromotorFin             int;
DECLARE Var_Generos                 varchar(7);
DECLARE Var_EstadoIni               int;
DECLARE Var_EstadoFin               bigint;
DECLARE Var_MunicipioIni            int;
DECLARE Var_MunicipioFin            bigint;
DECLARE Var_Sentencia			varchar(18000);
DECLARE Var_SelectPrincipal		varchar(300);
DECLARE Var_FromGeneralTotal	varchar(2000);
DECLARE Var_FromGeneralPromot	varchar(2000);
DECLARE Var_FromCredito		varchar(2000);
DECLARE Var_FromInversion		varchar(2000);
DECLARE	Var_FromVista			varchar(2000);
DECLARE Var_JoinsGeneralPromot	varchar(1000);
DECLARE Var_JoinsCredito		varchar(1000);
DECLARE Var_JoinsInversiones		varchar(1000);
DECLARE	Var_JoinsVista			varchar(1000);
DECLARE Var_Where			varchar(1000);





DECLARE EnteroCero          int;
DECLARE CadenaVacia         char(1);
DECLARE FechaVacia           Date;
DECLARE GeneroAmbos         varchar(7);
DECLARE GeneroMasculino     char(1);
DECLARE GeneroFemenino      char(1);
DECLARE ClienteActivo       char(1);



Set EnteroCero              := 0;
Set CadenaVacia             := '';
Set FechaVacia              := '1900-01-01';
Set GeneroAmbos             := "'M','F'";
Set GeneroMasculino         := 'M';
Set GeneroFemenino          := 'F';
Set ClienteActivo           := 'A';



Set Var_SucursalIni         := ifnull(Par_Sucursal, EnteroCero);
Set Var_SucursalFin         := case when ifnull(Par_Sucursal, EnteroCero) = EnteroCero then 999999999
                                                                                       else Par_Sucursal
                               end;
Set Var_PromotorIni         := ifnull(Par_Promotor, EnteroCero);
Set Var_PromotorFin         := case when ifnull(Par_Promotor, EnteroCero) = EnteroCero then 999999999
                                                                                       else Par_Promotor

                               end;


Set Var_Generos             := case when ifnull(Par_Genero, CadenaVacia) = CadenaVacia
                                          or Par_Genero not in (GeneroMasculino, GeneroFemenino) then GeneroAmbos
                                                                                                 else Par_Genero
                               end;


Set Var_EstadoIni           := ifnull(Par_Estado, EnteroCero);
Set Var_EstadoFin           := case when ifnull(Par_Estado, EnteroCero) = EnteroCero then 999999999
                                                                                     else Par_Estado

                              end;

Set Var_MunicipioIni        := ifnull(Par_Municipio, EnteroCero);
Set Var_MunicipioFin        := case when ifnull(Par_Municipio, EnteroCero) = EnteroCero then 999999999
                                                                                        else Par_Municipio

                               end;

Set Var_Where               := concat(" where Cli.Estatus in ('", ClienteActivo, "') ");

if ifnull(Par_Sucursal, EnteroCero) > EnteroCero then
    Set Var_Where           :=  concat(Var_Where, " and Cli.SucursalOrigen = ", Par_Sucursal);
end if;

if ifnull(Par_Promotor, EnteroCero) > EnteroCero then
    Set Var_Where           :=  concat(Var_Where, " and Prom.PromotorID = ", Par_Promotor);
end if;


if Par_Genero not in (GeneroMasculino, GeneroFemenino) then
    Set Var_Where           :=  concat(Var_Where, " and Cli.Sexo in (", GeneroAmbos,") ");
else
    Set Var_Where           :=  concat(Var_Where, " and Cli.Sexo in ('", Par_Genero,"') ");
end if;

if ifnull(Par_Estado, EnteroCero) > EnteroCero OR ifnull(Par_Municipio, EnteroCero) > EnteroCero  then
      Set Var_JoinsGeneralPromot	:= " inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen  inner join DIRECCLIENTE Dir on Dir.ClienteID = Cli.ClienteID ";
      Set Var_JoinsCredito			:= " inner join CLIENTES Cli on Cli.ClienteID = Cre.ClienteID inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen  inner join DIRECCLIENTE Dir on Dir.ClienteID = Cli.ClienteID ";
      Set Var_JoinsInversiones		:= " inner join CLIENTES Cli on Cli.ClienteID = Inv.ClienteID inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen inner join DIRECCLIENTE Dir on Dir.ClienteID = Cli.ClienteID ";
      Set Var_JoinsVista			:= " inner join CLIENTES Cli on Cli.ClienteID = Cue.ClienteID inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen inner join DIRECCLIENTE Dir on Dir.ClienteID = Cli.ClienteID ";
      Set Var_Where				:=  concat(Var_Where, " and Dir.ClienteID = Cli.ClienteID and Dir.Oficial = 'S'  ");
else
      Set Var_JoinsGeneralPromot  	:= " inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen ";
      Set Var_JoinsCredito        		:= " inner join CLIENTES Cli on Cli.ClienteID = Cre.ClienteID inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen ";
      Set Var_JoinsInversiones		:= " inner join CLIENTES Cli on Cli.ClienteID = Inv.ClienteID inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen ";

      Set Var_JoinsVista			    := " inner join CLIENTES Cli on Cli.ClienteID = Cue.ClienteID inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen ";
end if;



if ifnull(Par_Estado, EnteroCero) > EnteroCero then
    Set Var_Where           :=  concat(Var_Where, " and Dir.EstadoID = ", Par_Estado);
end if;

if ifnull(Par_Municipio, EnteroCero) > EnteroCero then
    Set Var_Where           :=  concat(Var_Where, " and Dir.MunicipioID = ", Par_Municipio);
end if;


Set Var_SelectPrincipal     := " select SucursalOrigen, NombreSucurs, NombrePromotor, Clasificacion, Genero, Concepto, sum(CantClientes) as CantClientes  ";

Set Var_FromGeneralTotal    := concat(" from ( select 0 as ClienteID, 0 as SucursalOrigen, 'GENERAL' as NombreSucurs, 'GENERAL' as NombrePromotor,
 'GENERAL' as Clasificacion,
 'ACTIVOS'as Concepto,
 case when Cli.Sexo = 'M' then 'HOMBRES' else 'MUJERES' end as Genero,
 count(Distinct(Cli.ClienteID)) as CantClientes
 from CLIENTES Cli
 inner join PROMOTORES Prom on Prom.PromotorID = Cli.PromotorActual
 where Cli.Estatus in ('", ClienteActivo, "')
 group by Cli.Sexo, Cli.ClienteID ) as Tabla
 group by  SucursalOrigen, NombrePromotor, Clasificacion, Genero, Concepto ");






Set Var_FromGeneralPromot   := Concat(" from (  select Cli.ClienteID, Cli.SucursalOrigen, Suc.NombreSucurs, Prom.NombrePromotor,
 'GENERAL' as Clasificacion,
 'ACTIVOS'as Concepto,
  case when Cli.Sexo = 'M' then 'HOMBRES' else 'MUJERES' end as Genero,
  count(Distinct(Cli.ClienteID)) as CantClientes
  from CLIENTES Cli ", Var_JoinsGeneralPromot, Var_Where,
  " group by Cli.Sexo, Cli.ClienteID ) as Tabla group by  SucursalOrigen, NombrePromotor, Clasificacion, Genero, Concepto ");


Set Var_FromCredito         := Concat(" from (  select Cli.ClienteID, Cli.SucursalOrigen, Suc.NombreSucurs, Prom.NombrePromotor,
 'CON CREDITO' as Clasificacion,
 case when count(Cre.CreditoID) > 1 then 'RENOVADOS' else 'NUEVOS' end as Concepto,
 case when Cli.Sexo = 'M' then 'HOMBRES' else 'MUJERES' end as Genero,
 count(Distinct(Cli.ClienteID)) as CantClientes
 from CREDITOS Cre ", Var_JoinsCredito, Var_Where,
 " group by Cli.Sexo, Cli.ClienteID ) as Tabla group by  SucursalOrigen, NombrePromotor, Clasificacion, Genero, Concepto ");


Set Var_FromInversion       := Concat(" from (  select Cli.ClienteID, Cli.SucursalOrigen, Suc.NombreSucurs, Prom.NombrePromotor,
 'CON INVERSION' as Clasificacion,
 case when count(Inv.InversionID) > 1 then 'RENOVADOS' else 'NUEVOS' end as Concepto,
 case when Cli.Sexo = 'M' then 'HOMBRES' else 'MUJERES' end as Genero,
 count(Distinct(Cli.ClienteID)) as CantClientes
 from INVERSIONES Inv", Var_JoinsInversiones, Var_Where,
 " group by Cli.Sexo, Cli.ClienteID ) as Tabla group by  SucursalOrigen, NombrePromotor, Clasificacion, Genero, Concepto ");


 Set	Var_FromVista		:= Concat(" from (  select Cli.ClienteID, Cli.SucursalOrigen, Suc.NombreSucurs, Prom.NombrePromotor,
 'CON VISTA' as Clasificacion,
  case when count(Cue.CuentaAhoID) > 1 then 'RENOVADOS' else 'NUEVOS' end as Concepto,
  case when Cli.Sexo = 'M' then 'HOMBRES' else 'MUJERES' end as Genero,
  count(Distinct(Cli.ClienteID)) as CantClientes
  from CUENTASAHO Cue", Var_JoinsVista, Var_Where,
  " group by Cli.Sexo, Cli.ClienteID ) as Tabla  group by  SucursalOrigen, NombrePromotor, Clasificacion, Genero, Concepto  order by SucursalOrigen, NombrePromotor, Clasificacion, Genero, Concepto;");



Set Var_Sentencia	:= Concat(Var_SelectPrincipal, Var_FromGeneralTotal,
								 	 " union ", Var_SelectPrincipal, Var_FromGeneralPromot,
								 	 " union ", Var_SelectPrincipal, Var_FromCredito,
								 	 " union ", Var_SelectPrincipal, Var_FromInversion,
								 	 " union ", Var_SelectPrincipal, Var_FromVista
									);


Set @Var_Sentencia  := (Var_Sentencia);

PREPARE EJECUCION FROM @Var_Sentencia;

EXECUTE EJECUCION;

DEALLOCATE PREPARE EJECUCION;


END TerminaStore$$