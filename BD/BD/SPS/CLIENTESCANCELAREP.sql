-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELAREP`;DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELAREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_ClienteID			INT(11),
	Par_SucursalID			INT(11),

	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Rep_Principal		INT;
	DECLARE	Est_Pagado			char(1);
	DECLARE	Est_Registrado		char(1);
	DECLARE	Est_Autorizado		char(1);
	DECLARE	Est_PagadoDes		varchar(11);
	DECLARE	Est_RegistradoDes	varchar(11);
	DECLARE	Est_AutorizadoDes	varchar(11);
	DECLARE Area_Pro			varchar(5);
	DECLARE Area_Cob			varchar(5);
	DECLARE Area_Soc			varchar(5);
	DECLARE Area_Protecciones	varchar(25);
	DECLARE Area_Cobranza		varchar(25);
	DECLARE Area_Socio			varchar(25);





DECLARE Var_Sentencia	VARCHAR(50000);


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Rep_Principal		:= 1;
Set Est_Pagado			:= 'P';
Set Est_Registrado		:= 'R';
Set Est_Autorizado		:= 'A';
Set Est_PagadoDes		:= 'PAGADO';
Set Est_RegistradoDes	:= 'REGISTRADO';
Set Est_AutorizadoDes	:= 'AUTORIZADO';

IF(Par_NumRep = Rep_Principal) THEN

	SET Var_Sentencia :=  '(SELECT  Can.ClienteID, Cli.NombreCompleto AS NombreCliente, Can.ClienteCancelaID AS FolioRegistro, Can.FechaRegistro, Can.AreaCancela,
									Cli.SucursalOrigen as SucursalOrigen,Cli.ClienteID as Cliente,
									Can.Estatus,	Pro.ParteSocial, Pro.MontoPROFUN, Pro.MontoSERVIFUN, Pro.MontoProtecCre, Pro.MontoProtecAho,
								    Pro.TotalBeneAplicado AS MontoBeneficio, Pro.SaldoFavorCliente AS SaldoFavor, Suc.SucursalID, Suc.NombreSucurs,
								    Pro.TotalSaldoOriCap AS Haberes, Pro.InteresCap As InteresGenerado, Pro.InteresRetener, Pro.CobradoPROFUN, ';
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' case Can.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Registrado, '" then "',Est_RegistradoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Autorizado,'"	 then "',Est_AutorizadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Pagado,'"		 then "',Est_PagadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' else Can.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' end as EstatusCan');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CLIENTESCANCELA Can,
												 PROTECCIONES Pro,
												 CLIENTES Cli,
												 SUCURSALES Suc');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE	Can.FechaRegistro	>= "',(Par_FechaInicio),'" AND	Can.FechaRegistro	<=	"',(Par_FechaFin),'" ');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Can.ClienteCancelaID = Pro.ClienteCancelaID
												 AND Can.ClienteID = Cli.ClienteID
												 AND Cli.SucursalOrigen=Suc.SucursalID');

	IF(ifnull(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Can.ClienteID = ', Par_ClienteID);
    END IF;
	if(ifnull(Par_SucursalID,Entero_Cero) > Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cli.SucursalOrigen = ', Par_SucursalID);
    END IF;


	SET Var_Sentencia :=  CONCAT(Var_Sentencia,') UNION ');

	SET Var_Sentencia := CONCAT(Var_Sentencia,' (SELECT  Can.ClienteID, Cli.NombreCompleto AS NombreCliente, Can.ClienteCancelaID AS FolioRegistro, Can.FechaRegistro, Can.AreaCancela,
								   Cli.SucursalOrigen as SucursalOrigen,Cli.ClienteID as Cliente,
								   Can.Estatus,	His.ParteSocial, His.MontoPROFUN, His.MontoSERVIFUN, His.MontoProtecCre, His.MontoProtecAho,
								   His.TotalBeneAplicado AS MontoBeneficio, His.SaldoFavorCliente AS SaldoFavor, Suc.SucursalID, Suc.NombreSucurs,
								   His.TotalSaldoOriCap AS Haberes, His.InteresCap As InteresGenerado, His.InteresRetener, His.CobradoPROFUN, ');

	set Var_Sentencia :=  CONCAT(Var_Sentencia,' case Can.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Registrado, '" then "',Est_RegistradoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Autorizado,'"	 then "',Est_AutorizadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' when "', Est_Pagado,'"		 then "',Est_PagadoDes ,'"');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' else Can.Estatus ');
	set Var_Sentencia :=  CONCAT(Var_Sentencia,' end as EstatusCan');

	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' FROM CLIENTESCANCELA Can,
												 HISPROTECCIONES His,
												 CLIENTES Cli,
												 SUCURSALES Suc');

		SET Var_Sentencia :=  CONCAT(Var_Sentencia,' WHERE	Can.FechaRegistro	>= "',(Par_FechaInicio),'" AND	Can.FechaRegistro	<=	"',(Par_FechaFin),'" ');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Can.ClienteCancelaID = His.ClienteCancelaID
												 AND Can.ClienteID = Cli.ClienteID
												 AND Cli.SucursalOrigen=Suc.SucursalID');

	IF(ifnull(Par_ClienteID,Entero_Cero) != Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Can.ClienteID = ', Par_ClienteID);
    END IF;
	if(ifnull(Par_SucursalID,Entero_Cero) > Entero_Cero)THEN
        SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND Cli.SucursalOrigen = ', Par_SucursalID);
    END IF;
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' ORDER BY SucursalOrigen, Cliente,');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' EstatusCan="',Est_Pagado,'", EstatusCan="',Est_Autorizado,'",');
	SET Var_Sentencia :=  CONCAT(Var_Sentencia,' EstatusCan="',Est_Registrado,'")');

	SET @Sentencia	= (Var_Sentencia);


	SET @FechaIni	= Par_FechaInicio;
	SET @FechaFin	= Par_FechaFin;
	PREPARE STCLIENTESCANCELAREP FROM @Sentencia;
	EXECUTE STCLIENTESCANCELAREP;

	DEALLOCATE PREPARE STCLIENTESCANCELAREP;

END IF;




END TerminaStore$$