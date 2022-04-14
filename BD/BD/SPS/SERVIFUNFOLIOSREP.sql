-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNFOLIOSREP`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNFOLIOSREP`(
	Par_FechaInicio			date,
	Par_FechaFin 			date,
	Par_SucursalID			int(11),
	Par_Estatus				char(1),


	Par_EmpresaID			int(11),
	Aud_Usuario				int,
	Aud_FechaActual			date,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint(20)

)
TerminaStore:BEGIN

DECLARE Var_Sentencia 	varchar(60000);


DECLARE Entero_Cero			int;
DECLARE Decimal_Cero    	varchar(14);
DECLARE Cadena_Vacia		char(1);
DECLARE ServicioFamiliar	char(1);
DECLARE ServicioCliente		char(1);
DECLARE No_Menor			char(1);
DECLARE Si_Menor			char(1);
DECLARE	Fecha_Vacia			date;

declare Autorizado		char(1);
declare Pagado			char(1);
declare Rechazado		char(1);
declare Capturado		char(1);


set Entero_Cero :=0;
set Cadena_Vacia :='';
set ServicioFamiliar	:='F';
set ServicioCliente		:='C';
set Par_SucursalID 	:= ifnull(Par_SucursalID,Entero_Cero);
set Par_Estatus		:=ifnull(Par_Estatus,Cadena_Vacia);

set Autorizado		:='A';
set Pagado			:='P';
set Rechazado		:='R';
set Capturado		:='C';
Set No_Menor		:='N';
Set Si_Menor		:='S';
set	Fecha_Vacia		:= '1900-01-01';
Set Decimal_Cero    :='0.00';

set Var_Sentencia	:='Select Cli.ClienteID,Cli.NombreCompleto,Ser.ServiFunFolioID,Ser.Estatus,Ser.FechaRegistro,';
set Var_Sentencia :=  CONCAT(Var_Sentencia, ' case when Ser.FechaAutoriza= "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ELSE Ser.FechaAutoriza end as FechaAutoriza,');

set Var_Sentencia	:= CONCAT(Var_sentencia,'  Ser.TipoServicio,Ser.DifunNombreComp,Ser.NoCertificadoDefun, Ser.FechaCertifDefun,');
set Var_Sentencia	:=CONCAT(Var_sentencia,' convert(time(now()),char) as HoraEmision,Cli.SucursalOrigen,');
set Var_Sentencia	:=CONCAT(Var_sentencia,' Suc.NombreSucurs,');
set Var_Sentencia	:=CONCAT(Var_sentencia,' case when Ser.Estatus ="',Rechazado,'"or Ser.Estatus="',Capturado,'"then 0.00 else (round(Ser.MontoApoyo,2)) end as MontoApoyo,');

set Var_Sentencia :=  CONCAT(Var_Sentencia, ' case when ifnull(Ent.FechaEntrega,"',Fecha_Vacia,'")= "',Fecha_Vacia,'" then "',Cadena_Vacia,'" ELSE Ent.FechaEntrega end as FechaEntrega,');

set Var_Sentencia :=  CONCAT(Var_Sentencia, ' case when Ser.TipoServicio= "',ServicioFamiliar,'" then "FAMILIAR"');
set Var_Sentencia :=  CONCAT(Var_Sentencia, '  when Ser.TipoServicio= "',ServicioCliente,'"and Cli.EsMenorEdad="',No_Menor,'" then "SOCIO"');
set Var_Sentencia :=  CONCAT(Var_Sentencia, '  when Ser.TipoServicio= "',ServicioCliente,'"and Cli.EsMenorEdad="',Si_Menor,'" then "MENOR" end as DesTipServicio,');

set Var_Sentencia :=  CONCAT(Var_Sentencia, ' case when Ser.Estatus= "',Autorizado,'" then "AUTORIZADO"');
set Var_Sentencia :=  CONCAT(Var_Sentencia, '  when Ser.Estatus= "',Pagado,'" then "PAGADO"');
set Var_Sentencia :=  CONCAT(Var_Sentencia, '  when Ser.Estatus= "',Rechazado,'" then "RECHAZADO"');
set Var_Sentencia :=  CONCAT(Var_Sentencia, '  when Ser.Estatus= "',Capturado,'" then "CAPTURADO" end as DesEstatus');

set Var_Sentencia	:= CONCAT(Var_sentencia,'  from SERVIFUNFOLIOS Ser ');
set Var_Sentencia	:= CONCAT(Var_sentencia,'  left join SERVIFUNENTREGADO Ent on Ser.ServiFunFolioID=Ent.ServiFunFolioID');
set Var_Sentencia	:= CONCAT(Var_sentencia,'  inner join CLIENTES Cli on Cli.ClienteID = Ser.ClienteID ');
set Var_Sentencia	:= CONCAT(Var_sentencia,'  inner join SUCURSALES Suc on Suc.SucursalID = Cli.SucursalOrigen ');

set Var_Sentencia 	:=CONCAT(Var_Sentencia,' where Ser.FechaRegistro between  ? and ?');

if(Par_SucursalID != Entero_Cero)then
		set Var_Sentencia := CONCAT(Var_Sentencia,' and Cli.SucursalOrigen=', Par_SucursalID);
end if;

if(Par_Estatus != Cadena_Vacia)then
		set Var_Sentencia := CONCAT(Var_Sentencia,' and Ser.Estatus="', Par_Estatus,'"');
end if;

set Var_Sentencia 	:=CONCAT(Var_Sentencia,' order by  Cli.SucursalOrigen ,Cli.ClienteID ');

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STSERVIFUNFOLIOSREP FROM @Sentencia;
   EXECUTE STSERVIFUNFOLIOSREP  USING @FechaInicio, @FechaFin;
   DEALLOCATE PREPARE STSERVIFUNFOLIOSREP;
END TerminaStore$$