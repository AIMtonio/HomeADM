-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCOLARSOLREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APOYOESCOLARSOLREP`;DELIMITER $$

CREATE PROCEDURE `APOYOESCOLARSOLREP`(

	Par_FechaInicio			date,
	Par_FechaFin			date,
	Par_Estatus				char(1),
	Par_SucursalRegistroID	int(11),

	Par_NumRep			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		datetime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		char(1);
	DECLARE	Fecha_Vacia			date;
	DECLARE	Entero_Cero			int;
	DECLARE	Est_Pagado			char(1);
	DECLARE Est_Rechazado	    char(1);
	DECLARE	Est_Registrado		char(1);
	DECLARE	Est_Autorizado		char(1);
	DECLARE	Est_PagadoDes		varchar(11);
	DECLARE Est_RechazadoDes    varchar(11);
	DECLARE	Est_RegistradoDes	varchar(11);
	DECLARE	Est_AutorizadoDes	varchar(11);
	DECLARE	Rep_Principal		int;





DECLARE Var_Sentencia	varchar(9000);


Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Rep_Principal		:= 1;
Set Est_Pagado			:= 'P';
Set Est_Registrado		:= 'R';
Set Est_Autorizado		:= 'A';
Set Est_Rechazado   	:= 'X';
Set Est_PagadoDes		:= 'PAGADO';
Set Est_RegistradoDes	:= 'REGISTRADO';
Set Est_AutorizadoDes	:= 'AUTORIZADO';
Set Est_RechazadoDes	:= 'RECHAZADO';

if(Par_NumRep = Rep_Principal) then

	set Var_Sentencia :=  'select Sol.SucursalRegistroID, Suc.NombreSucurs,   Sol.ClienteID, Cli.NombreCompleto, Sol.ApoyoEscSolID, Sol.FechaRegistro, Usu.Nombrecompleto as UsuarioRegistra,
								  Gra.Descripcion as NivelEscolar, Sol.GradoEscolar, Sol.PromedioEscolar, Sol.EdadCliente, Sol.Monto, Sol.CicloEscolar, convert(time(now()),char) as HoraEmision,';
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' case Sol.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Registrado, '" then "',Est_RegistradoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Autorizado,'"	 then "',Est_AutorizadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Pagado,'"		 then "',Est_PagadoDes ,'"');
    set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Rechazado,'"	 then "',Est_RechazadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' else Sol.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' end as EstatusDes');

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' from APOYOESCOLARSOL Sol,
												 APOYOESCCICLO Gra,
												 CLIENTES Cli,
												 SUCURSALES Suc,
												 USUARIOS Usu ');

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' where	Sol.FechaRegistro	>=	?');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' and	Sol.FechaRegistro	<=	?');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' and Gra.ApoyoEscCicloID = Sol.ApoyoEscCicloID
												 and Sol.ClienteID = Cli.ClienteID
												 and Sol.SucursalRegistroID = Suc.SucursalID
												 and Sol.UsuarioRegistra=Usu.UsuarioID ');

	if(ifnull(Par_Estatus,Cadena_Vacia) != Cadena_Vacia)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and Sol.Estatus = "', Par_Estatus,'"');
    end if;
	if(ifnull(Par_SucursalRegistroID,Entero_Cero) > Entero_Cero)then
        set Var_Sentencia :=  CONCAT(Var_Sentencia,' and Sol.SucursalRegistroID = ', Par_SucursalRegistroID);
    end if;

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' order by Sol.SucursalRegistroID, Sol.ClienteID;');

	set @Sentencia	= (Var_Sentencia);

	SET @FechaIni	= Par_FechaInicio;
	SET @FechaFin	= Par_FechaFin;
	PREPARE STAPOYOESCOLARSOLREP FROM @Sentencia;
	EXECUTE STAPOYOESCOLARSOLREP USING @FechaIni, @FechaFin;

	DEALLOCATE PREPARE STAPOYOESCOLARSOLREP;

end if;



END TerminaStore$$