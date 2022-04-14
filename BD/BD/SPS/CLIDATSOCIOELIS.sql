-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOELIS`;
DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOELIS`(
	Par_LineaNeg		int,
	Par_ClienteID		int,
	Par_Prospecto		int,
	Par_TipoPersona		char(1),
	Par_Descripcion		varchar(100),

	Par_NumLis			tinyint unsigned,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 	varchar(6000);



DECLARE		Cadena_Vacia		char(1);
DECLARE		Fecha_Vacia			date;
DECLARE		Entero_Cero			int;
DECLARE		Lis_Principal		int;
DECLARE		Lis_GridDSocioe		int;
DECLARE		Lis_inforSocioe		int;
DECLARE		Lis_GastosPasivos	int;
DECLARE Var_GastosPasivos		varchar(100);
DECLARE 	GastosPasivosVacio		varchar(50);
DECLARE  	Lis_ComboEgresos 	int;
DECLARE     TipoEgresos			char(1);
DECLARE  	Lis_inforSocioeWS 	INT(11);			-- Lista de datos Socioeconomicos del cliente para ws de milagro

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	Lis_Principal		:= 1;
Set	Lis_GridDSocioe		:= 2;
Set	Lis_inforSocioe		:= 3;
set Lis_GastosPasivos	:=4;
set Lis_ComboEgresos	:=5;
set Lis_inforSocioeWS	:= 6;		-- Lista de datos Socioeconomicos del cliente para ws de milagro

set Par_ClienteID   := (ifnull(Par_ClienteID, Entero_Cero));
set Par_Prospecto   := (ifnull(Par_Prospecto, Entero_Cero));
set GastosPasivosVacio	:='0';
set TipoEgresos			:='E';


if(Par_NumLis = Lis_GridDSocioe) then
	Select	Cat.CatSocioEID,	Cat.Descripcion,	Cat.Tipo,	Entero_Cero
		from	PARAMDATSOCIOE Par,
				CATDATSOCIOE Cat
			where Par.LinNegID=Par_LineaNeg
			and Cat.CatSocioEID= Par.CatSocioEID
			and Par.TipoPersona=Par_TipoPersona;
end if;



if(Par_NumLis = Lis_inforSocioe) then

	if Par_ClienteID > Entero_Cero then
		Select 	Cli.SocioEID,		Cli.LinNegID,	Cli.ProspectoID,	Cli.ClienteID,	Cli.SolicitudCreditoID,
				Cli.CatSocioEID,	Cli.Monto,		Cli.FechaRegistro,	Cat.Tipo
		from	CLIDATSOCIOE Cli
		inner join CATDATSOCIOE Cat on Cli.CatSocioEID = Cat.CatSocioEID
		where Cli.ClienteID = Par_ClienteID
		  and Cli.LinNegID	 = Par_LineaNeg;

	else
	  Select 	Cli.SocioEID,		Cli.LinNegID,	Cli.ProspectoID,	Cli.ClienteID,	Cli.SolicitudCreditoID,
				Cli.CatSocioEID,	Cli.Monto,		Cli.FechaRegistro,	Cat.Tipo
		from	CLIDATSOCIOE Cli
		inner join CATDATSOCIOE Cat on Cli.CatSocioEID = Cat.CatSocioEID
		where Cli.ProspectoID = Par_Prospecto
		  and Cli.LinNegID	 = Par_LineaNeg;
	end if;
end if;

if(Par_NumLis = Lis_GastosPasivos) then

	SET Var_GastosPasivos :=(select GastosPasivos from PARAMETROSCAJA);
	set Var_Sentencia :=  'Select 	Cli.SocioEID,		Cli.LinNegID,	Cli.ProspectoID,	Cli.ClienteID,	Cli.SolicitudCreditoID,';
	set Var_Sentencia := CONCAT(Var_Sentencia, ' Cli.CatSocioEID,	Cli.Monto,		Cli.FechaRegistro,Cat.Descripcion,	Cat.Tipo');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' from CLIDATSOCIOE Cli ');
	set Var_Sentencia := CONCAT(Var_Sentencia, ' inner join CATDATSOCIOE Cat on Cli.CatSocioEID = Cat.CatSocioEID ');
	set Var_Sentencia := CONCAT(Var_sentencia,' where case when ', convert(Par_ClienteID, char), ' > 0  then Cli.ClienteID = ', convert(Par_ClienteID, char));
	set Var_Sentencia := CONCAT(Var_sentencia,' else Cli.ProspectoID = ', convert(Par_Prospecto, char), ' end ');
	set Var_Sentencia := CONCAT(Var_sentencia,' and Cat.CatSocioEID  in (',ifnull(Var_GastosPasivos,GastosPasivosVacio ), '); ');

	SET @Sentencia	= (Var_Sentencia);
	PREPARE STSCLIDATLIS FROM @Sentencia;
	EXECUTE STSCLIDATLIS;
    DEALLOCATE PREPARE STSCLIDATLIS;

end if;




if(Par_NumLis = Lis_Principal) then
	SELECT CatSocioEID, Descripcion
		FROM CATDATSOCIOE
			Where CatSocioEID <> Entero_Cero
			and Tipo = TipoEgresos
			and Descripcion like CONCAT('%',Par_Descripcion,'%') limit 15;

end if;


if(Par_NumLis = Lis_ComboEgresos) then
	SELECT CatSocioEID, Descripcion
		FROM CATDATSOCIOE
			Where CatSocioEID <> Entero_Cero
			and Tipo = TipoEgresos;

end if;

	-- 6.- Lista de datos Socioeconomicos del cliente para ws de milagro
	IF(Par_NumLis = Lis_inforSocioeWS) then
		SELECT	Cli.SocioEID,		Cli.LinNegID,	Cli.ProspectoID,	Cli.ClienteID,	Cli.SolicitudCreditoID,
				Cli.CatSocioEID,	Cli.Monto,		Cli.FechaRegistro,	Cat.Tipo,		Cat.Descripcion
			FROM CLIDATSOCIOE Cli
				INNER JOIN CATDATSOCIOE Cat ON Cli.CatSocioEID = Cat.CatSocioEID
		WHERE Cli.ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$