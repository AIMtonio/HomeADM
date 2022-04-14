-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDTARDEBREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDTARDEBREP`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDTARDEBREP`(
 Par_FechaInicio		date,
	Par_FechaFin		date,
	Par_Estatus			char(1),

    Aud_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 	varchar(9000);


DECLARE Cadena_Vacia	char(1);
DECLARE Fecha_Vacia		date;
DECLARE Entero_Cero		int;
DECLARE FechaSist		date;
DECLARE Est_Solicitada	char(1);
DECLARE Est_Cancelada	char(1);
DECLARE Est_Generada	char(1);
DECLARE Est_Recibida	char(1);
DECLARE IdentSocio	    char(1);


Set Cadena_Vacia		:= '';
Set Fecha_Vacia			:= '1900-01-01';
Set Entero_Cero			:= 0;
Set Est_Solicitada		:= 'S';
Set Est_Cancelada		:= 'C';
Set Est_Generada		:= 'G';
Set Est_Recibida		:= 'R';
Set IdentSocio          := 'S';


set FechaSist := (Select FechaSistema from PARAMETROSSIS);

	set Var_Sentencia := ' select Sol.FolioSolicitudID, ';
	set Var_Sentencia := CONCAT(Var_Sentencia, 'CASE Sol.TipoSolicitud WHEN "R" THEN "REPOSICIÓN" ');
	set Var_Sentencia := CONCAT(Var_Sentencia, 'WHEN "N" THEN "NUEVA" END AS TipoSolicitud, ' );
	set Var_Sentencia := CONCAT(Var_Sentencia, 'Sol.TarjetaDebAntID, ' );
	set Var_Sentencia := CONCAT(Var_Sentencia, 'CASE Sol.Relacion WHEN "T" THEN "TITULAR" ');
	set Var_Sentencia := CONCAT(Var_Sentencia, 'WHEN "A" THEN "ADICIONAL" END AS Relacion, ');
	set Var_Sentencia := CONCAT(Var_Sentencia, 'date(Sol.FechaSolicitud) as FechaSolicitud,Cli.ClienteID,UPPER(Cli.NombreCompleto) as NombreCompleto,Sol.CorpRelacionadoID, LPAD(convert(Cta.CuentaAhoID, CHAR),11,"0") as CuentaAhoID ,Tip.Descripcion,UPPER(Sol.NombreTarjeta) as NombreTarjeta,');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' case when Sol.Estatus="S" then "SOLICITADA" ');
	set Var_Sentencia := CONCAT(Var_Sentencia, '		 when Sol.Estatus="C" then "CANCELADA" ');
	set Var_Sentencia := CONCAT(Var_Sentencia, '      when Sol.Estatus="G" then "GENERADA" ');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' 	 when Sol.Estatus="R" then "RECIBIDA"');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' 		end as Estatus,');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' case when Sol.CorpRelacionadoID');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' then(select C.NombreCompleto from CLIENTES C where C.ClienteID=Sol.CorpRelacionadoID ) ');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' end  as ClienteCorporativo');
    set Var_Sentencia := CONCAT(Var_Sentencia, ' from SOLICITUDTARDEB AS Sol left join  TIPOTARJETADEB AS Tip on Sol.TipoTarjetaDebID=Tip.TipoTarjetaDebID');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' and Tip.IdentificacionSocio != "', IdentSocio, '" ');
    set Var_Sentencia := CONCAT(Var_Sentencia, ' left join  CUENTASAHO AS Cta on Sol.CuentaAhoID=Cta.CuentaAhoID');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' left join  CLIENTES AS Cli on Sol.ClienteID=Cli.ClienteID WHERE ');
    set Var_Sentencia := CONCAT(Var_Sentencia,' Sol.FechaSolicitud >= ? and Sol.FechaSolicitud <= ? ');

	set Par_Estatus := ifnull(Par_Estatus,Cadena_Vacia);
    if(Par_Estatus!=Cadena_Vacia)then
        set Var_Sentencia := CONCAT(Var_sentencia,' and Sol.Estatus="',Par_Estatus,'"');
    end if;



	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STSESTATUSREP FROM @Sentencia;
      EXECUTE STSESTATUSREP USING @FechaInicio, @FechaFin;
      DEALLOCATE PREPARE STSESTATUSREP;

END TerminaStore$$