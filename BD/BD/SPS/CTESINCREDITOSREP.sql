-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CTESINCREDITOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CTESINCREDITOSREP`;DELIMITER $$

CREATE PROCEDURE `CTESINCREDITOSREP`(
	Par_SucursalID			int(11),
	Par_Periodo				decimal(12,2),
	Par_NumLista			int(11),

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			datetime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint)
TerminaStore:BEGIN


DECLARE Cadena_Vacia	char(1);
DECLARE Cadena_SI 		char(1);
DECLARE Alto	 		char(1);
DECLARE Medio			char(1);
DECLARE Bajo			char(1);
DECLARE RiesgoAlto		varchar(4);
DECLARE RiesgoMedio		varchar(5);
DECLARE RiesgoBajo		varchar(4);
DECLARE ProvRecursos	varchar(21);
DECLARE PropietReal		varchar(16);
DECLARE Est_Inactiva	char(1);
DECLARE Est_Liberada	char(1);
DECLARE Est_Autorizada	char(1);
DECLARE Ingresos		char(1);
DECLARE Entero_Cero		int(5);
DECLARE MenorEdadNo		char(1);
DECLARE Esta_Vigente	char(1);
DECLARE Esta_Vencido	char(1);
DECLARE Esta_Activo		char(1);
DECLARE Decimal_Cero	decimal(14,2);


DECLARE	Var_DiasRestar	decimal(12,2);
DECLARE Var_FechaInicio	date;
DECLARE Var_FechaSistema	date;
DECLARE Var_HoraEmision	datetime;
DECLARE Var_Sentencia	varchar(60000);


set Cadena_Vacia:='';
set Cadena_SI	:='S';
set Alto		:='A';
set Medio 		:='M';
set Bajo		:='B';
set RiesgoAlto	:='ALTO';
set RiesgoMedio:='MEDIO';
set RiesgoBajo	:='BAJO';
set ProvRecursos:='PROVEEDOR DE RECURSOS';
set PropietReal	:='PROPIETARIO REAL';
set Est_Inactiva:='I';
set Est_Liberada:='L';
set Est_Autorizada:='A';
set Ingresos	:= 'I';
set Entero_Cero	:= 0;
set MenorEdadNo	:='N';
set Esta_Vigente := 'V';
set Esta_Vencido := 'B';
set Esta_Activo	:='A';
set Decimal_Cero:= 0.00;

set Var_DiasRestar 		:= Par_Periodo * 30;
set Var_FechaSistema	:= (select FechaSistema from PARAMETROSSIS);
set Var_FechaInicio 	:= (SELECT date_sub(Var_FechaSistema, INTERVAL Var_DiasRestar DAY));

drop table if exists TMPCLIENTESINACTCRED;
create temporary table TMPCLIENTESINACTCRED ( ClienteID 			int(11),
											NombreCompleto 		varchar(200),
											SucursalID			int(11),
											OcupacionIDCli		int(11),
											ActividadBancoMX	varchar(15),
											NivelRiesgo			char(1),
											NombreSucursal		varchar(200),
											DireccionCli			varchar(200),
											OcupacionCli			varchar(400),
											TotalIngresos			decimal(14,2),
											NumCuenta				bigint(12),
											index(ClienteID,SucursalID)
														);

set Var_Sentencia :='insert into TMPCLIENTESINACTCRED(ClienteID,	NombreCompleto,	SucursalID, OcupacionIDCli,	ActividadBancoMX,
								NivelRiesgo, NombreSucursal, DireccionCli,OcupacionCli,	TotalIngresos,
								NumCuenta)
select distinct (cli.ClienteID), cli.NombreCompleto,cli.SucursalOrigen,cli.OcupacionID,cli.ActividadBancoMX, ';
set Var_Sentencia :=concat(Var_Sentencia,' cli.NivelRiesgo,"',Cadena_Vacia,'","',Cadena_Vacia,'","',Cadena_Vacia,'",',Decimal_Cero,',',Entero_Cero,'
	from CLIENTES cli
	left join CREDITOS cre  on cli.ClienteID = cre.ClienteID  and cre.Estatus not in("',Esta_Vigente,'","',Esta_Vencido,'")
    and cre.Fechainicio not between "',Var_FechaInicio,'" and "',Var_FechaSistema,'"
	where cli.EsMenorEdad = "',MenorEdadNo,'"
	and cli.Estatus = "',Esta_Activo,'"');

if(Par_SucursalID > Entero_Cero)then
	set Var_Sentencia :=concat(Var_Sentencia,'and cli.SucursalOrigen = ',Par_SucursalID,' ');
end if;
	set Var_Sentencia :=concat(Var_Sentencia,'group by cli.ClienteID, cli.NombreCompleto, cli.SucursalOrigen, cli.OcupacionID, cli.ActividadBancoMX, cli.NivelRiesgo');

	set @Sentencia	= (Var_Sentencia);
	PREPARE SPCTESINACTCREDITICIA FROM @Sentencia;
	EXECUTE SPCTESINACTCREDITICIA  ;
	DEALLOCATE PREPARE SPCTESINACTCREDITICIA;

	delete tmp from TMPCLIENTESINACTCRED tmp
	inner join CREDITOS cre ON tmp.ClienteID = cre.ClienteID and cre.Estatus in(Esta_Vigente,Esta_Vencido);



delete tmp from
		TMPCLIENTESINACTCRED tmp
	inner join  CREDITOS cre on cre.ClienteID = tmp.ClienteID
	where cre.Estatus = Est_Inactiva
	and cre.Fechainicio between Var_FechaInicio and Var_FechaSistema;

delete tmp
	from TMPCLIENTESINACTCRED tmp
	inner join  CREDITOS cre on cre.ClienteID = tmp.ClienteID
	where cre.Estatus = Est_Autorizada
	and cre.FechaAutoriza between Var_FechaInicio and Var_FechaSistema;

delete tmp
	from TMPCLIENTESINACTCRED tmp
	inner join SOLICITUDCREDITO  sol on sol.ClienteID = tmp.ClienteID
	where sol.Estatus in (Est_Inactiva,Est_Liberada,Est_Autorizada)
	and sol.CreditoID <= Entero_Cero
    or  sol.CreditoID is null;

update TMPCLIENTESINACTCRED tmp
	left join DIRECCLIENTE dir on tmp.ClienteID = dir.ClienteID and dir.Oficial =Cadena_SI
	inner join SUCURSALES suc on tmp.SucursalID = suc.SucursalID
	left join OCUPACIONES ocu on tmp.OcupacionIDCli = ocu.OcupacionID
	set tmp.DireccionCli = ifnull(dir.DireccionCompleta,Cadena_Vacia),
	 tmp.NombreSucursal = suc.NombreSucurs,
	tmp.OcupacionCli = ifnull(ocu.Descripcion,Cadena_Vacia);

drop table if exists TMPINGRESOSCLILINEA;
create temporary table TMPINGRESOSCLILINEA (ClienteID int(11),
									TotalIngreso decimal(14,2),
									index(ClienteID));
insert into TMPINGRESOSCLILINEA(ClienteID, TotalIngreso)
select Cte.ClienteID,SUM(Monto)
	from CLIDATSOCIOE Cte,
		CATDATSOCIOE	dat
		where Cte.CatSocioEID=dat.CatSocioEID
		and dat.Tipo=Ingresos
		group by Cte.ClienteID,Cte.LinNegID;


drop table if exists TMPINGRESOSCLI;
create temporary table TMPINGRESOSCLI (ClienteID int(11),
								TotalIngreso decimal(14,2),
								index(ClienteID));
insert into TMPINGRESOSCLI(ClienteID, TotalIngreso)
select distinct(Cte.ClienteID),Cte.TotalIngreso
	from TMPINGRESOSCLILINEA Cte
	group by Cte.ClienteID, Cte.TotalIngreso;


update TMPCLIENTESINACTCRED tmp
	inner join TMPINGRESOSCLI  tmp2 on tmp.ClienteID = tmp2.ClienteID
	set tmp.TotalIngresos = tmp2.TotalIngreso;

update TMPCLIENTESINACTCRED tmp
	inner join CUENTASAHO cta on tmp.ClienteID = cta.clienteID and cta.EsPrincipal = Cadena_SI
	set tmp.NumCuenta = cta.CuentaAhoID;

select tmp.ClienteID,		tmp.NombreCompleto, tmp.SucursalID, 	tmp.OcupacionIDCli, case tmp.NivelRiesgo when Alto then RiesgoAlto when Medio then RiesgoMedio when Bajo then RiesgoBajo end as NivelRiesgo,
		tmp.NombreSucursal, tmp.DireccionCli, 	tmp.OcupacionCli, 	tmp.TotalIngresos, LPAD(tmp.NumCuenta,12,0) as NumCuenta,
		if(ifnull(ctap.EsProvRecurso,Cadena_Vacia) != Cadena_Vacia and ifnull(ctap.EsPropReal,Cadena_Vacia) != Cadena_Vacia, concat(ProvRecursos,' Y ',PropietReal),
		if(ifnull(ctap.EsProvRecurso,Cadena_Vacia) != Cadena_Vacia and ifnull(ctap.EsPropReal,Cadena_Vacia) = Cadena_Vacia,ProvRecursos,
		if(ifnull(ctap.EsProvRecurso,Cadena_Vacia) = Cadena_Vacia and ifnull(ctap.EsPropReal,Cadena_Vacia)!= Cadena_Vacia,PropietReal,Cadena_Vacia))) AS TipoPersona,
		ifnull(ocu.Descripcion,Cadena_Vacia) as OcupacionPerRela,	ifnull(ctap.IngresoRealoRecur,Decimal_Cero) as IngresoRealoRecur, act.Descripcion as ActividadBancoMX, substring(now(),12) as HoraEmision, Var_FechaInicio, Var_FechaSistema,
		ctap.NombreCompleto as NombrePersonaRel
	from TMPCLIENTESINACTCRED tmp
	left join CUENTASPERSONA ctap on tmp.NumCuenta = ctap.CuentaAhoID and (ifnull(ctap.EsProvRecurso,Cadena_Vacia) =Cadena_SI or ifnull(ctap.EsPropReal,Cadena_Vacia) = Cadena_SI)
	left join OCUPACIONES ocu on ctap.OcupacionID = ocu.OcupacionID
	left join ACTIVIDADESBMX act on tmp.ActividadBancoMX = act.ActividadBMXID
	order by tmp.ClienteID,tmp.NumCuenta,ctap.EsProvRecurso, ctap.EsPropReal ;

END TerminaStore$$