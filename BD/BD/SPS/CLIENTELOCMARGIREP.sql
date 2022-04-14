-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTELOCMARGIREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTELOCMARGIREP`;DELIMITER $$

CREATE PROCEDURE `CLIENTELOCMARGIREP`(
    Par_FechaInicio     date,
    Par_FechaFin        date,
    Par_EstadoID        int(11),
    Par_MunicipioID     int(11),
    Par_LocalidadID     int(11),
    Par_TipoRep         int(11),

    Par_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     date,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)
)
TerminaStore: BEGIN
-- Declaracion de Variables --
Declare Var_Sentencia varchar(60000);

-- Declaracion de Constantes --
Declare Entero_Cero     int;
Declare Cadena_Vacia    char(1);
Declare Marginada       char(1);
Declare Edo_Soltero     char(1);
Declare Edo_CasadoBS    char(2);
Declare Edo_CasadoBM    char(2);
Declare Edo_CasadoBMC   char(2);
Declare Edo_Viudo       char(1);
Declare Edo_Divorciado  char(1);
Declare Edo_Separado    char(2);
Declare Edo_UnionLibre  char(1);
Declare Edo_Casado      char(1);
Declare EsMenorSi       char(1);
Declare EsMenorNo       char(1);
Declare Est_Activo      char(1);
Declare Est_Inactivo    char(1);
Declare EsOficial       char(1);

-- Asignacion de constantes --

Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Marginada       := 'S';
Set Edo_Soltero     :='S'; -- Soltero
Set Edo_CasadoBS    :='CS'; -- Casado bienes separados
Set Edo_CasadoBM    :='CM'; -- Casado bienes mancomunados
Set Edo_CasadoBMC   :='CC'; -- Casado bienes mancomunados con capitulacion
Set Edo_Viudo       :='V'; -- Estado civil viudo
Set Edo_Divorciado  :='D';  -- Estado civil divorciado
Set Edo_Separado    :='SE'; -- Estado civil separado
Set Edo_UnionLibre  :='U'; -- Estado civil union libre
Set Edo_Casado      :='C'; -- Casado
Set EsMenorNo       :='N'; -- NO es menor de edad
Set EsMenorSi       :='S';
Set Est_Activo      :='A';
Set Est_Inactivo    :='I';
Set EsOficial       :='S';
Set Par_EstadoID    := ifnull(Par_EstadoID,Entero_Cero);
Set Par_MunicipioID := ifnull(Par_MunicipioID,Entero_Cero);
Set Par_LocalidadID := ifnull(Par_LocalidadID,Entero_Cero);
Set Par_TipoRep     := ifnull(Par_TipoRep, Entero_Cero);

    Set Var_Sentencia :='select Cli.ClienteID, Cli.NombreCompleto, Dir.DireccionCompleta, Cli.CURP, Cli.FechaAlta, Cli.Estatus, Cli.SucursalOrigen,Suc.NombreSucurs, Inte.GrupoID, ';
    Set Var_Sentencia := CONCAT(Var_Sentencia,' Loc.LocalidadID, Loc.NombreLocalidad, Cli.EstadoCivil, Cli.EsMenorEdad, time(now()) as HoraEmision, max(Inte.FechaRegistro), ');

    Set Var_Sentencia := CONCAT(Var_Sentencia, ' case when Cli.EstadoCivil= "',Edo_Soltero,'" then "SOLTERO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, '  when Cli.EstadoCivil= "',Edo_CasadoBS,'" then "CASADO BIENES SEPARADOS" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_CasadoBM, '" then "CASADO BIENES MANCOMUNADOS" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_CasadoBMC, '"then "CASADO BIENES MANCOMUNADOS CON CAPITULACION" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_Viudo,'"then "VIUDO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_Divorciado,'"then "DIVORCIADO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_Separado,'"then "SEPARADO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_Casado,'"then "CASADO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EstadoCivil= "',Edo_UnionLibre,'"then "UNION LIBRE" end as DesEstadoCivil, ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' case when Cli.EsMenorEdad= "',EsMenorNo,'" then "NO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.EsMenorEdad= "',EsMenorSi,'" then "SI" end as DesEsMenorEdad,');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' case when Cli.Estatus= "',Est_Activo,'" then "ACTIVO" ');
    Set Var_Sentencia := CONCAT(Var_Sentencia, ' when Cli.Estatus= "',Est_Inactivo,'" then "INACTIVO" end as DesEstatus');

    set Var_Sentencia	:= CONCAT(Var_Sentencia,'  from CLIENTES Cli  inner join DIRECCLIENTE Dir on Cli.ClienteID = Dir.ClienteID ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' inner join    ESTADOSREPUB Edo on Dir.EstadoID = Edo.EstadoID ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' inner join MUNICIPIOSREPUB Mun on Mun.EstadoID = Edo.EstadoID ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' inner join LOCALIDADREPUB Loc  on Loc.MunicipioID = Mun.MunicipioID ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' left join INTEGRAGRUPOSCRE Inte on Inte.ClienteID = Cli.ClienteID ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' inner join	SUCURSALES Suc on Suc.SucursalID	= Cli.SucursalOrigen ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' where Loc.EsMarginada  =  "', Marginada,'"' );
    set Var_Sentencia :=CONCAT(Var_Sentencia,' and Cli.FechaAlta between  ? and ? ');
    set Var_Sentencia :=CONCAT(Var_Sentencia,' and Dir.Oficial =  "', EsOficial,'" ');
    set Var_Sentencia :=CONCAT(Var_Sentencia,' and Dir.MunicipioID=Mun.MunicipioID ');
    set Var_Sentencia :=CONCAT(Var_Sentencia,' and Dir.LocalidadID=Loc.LocalidadID ');

    if(Par_EstadoID != Entero_Cero)then
        set Var_Sentencia := CONCAT(Var_Sentencia,' and Edo.EstadoID = ' , Par_EstadoID);
    end if;

    if(Par_MunicipioID != Entero_Cero)then
        set Var_sentencia := CONCAT(Var_Sentencia, ' and Mun.MunicipioID = ', Par_MunicipioID);
    end if;

    if(Par_LocalidadID != Entero_Cero)then
        set Var_Sentencia := CONCAT(Var_Sentencia,' and Loc.LocalidadID = ', Par_LocalidadID);
    end if;

    set Var_Sentencia := CONCAT(Var_Sentencia,' group by Cli.ClienteID, Cli.NombreCompleto, Dir.DireccionCompleta, Cli.CURP,
														 Inte.GrupoID,	Loc.LocalidadID,	Loc.NombreLocalidad ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' Order by Loc.LocalidadID,Cli.SucursalOrigen, Cli.Estatus ');

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STCLILOCMARGINADASREP FROM @Sentencia;
   EXECUTE STCLILOCMARGINADASREP  USING @FechaInicio, @FechaFin;
   DEALLOCATE PREPARE STCLILOCMARGINADASREP;


END TerminaStore$$