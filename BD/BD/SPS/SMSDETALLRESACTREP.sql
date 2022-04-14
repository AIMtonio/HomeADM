-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSDETALLRESACTREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSDETALLRESACTREP`;DELIMITER $$

CREATE PROCEDURE `SMSDETALLRESACTREP`(
-- SP  detalle de resumen de actividad SMS
	Par_CampaniaID		int,
	Par_CodigoResID		varchar(10),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE		NomCampania		varchar(20);
DECLARE		NombreCliente	varchar(250);
DECLARE		NumCliente		int;
DECLARE		VarFechSistema	date;
DECLARE		VarHoraSistema	time;
DECLARE		NombreUsuario	varchar(250);

-- Declaracion de Constantes
DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		DigIniLadaDF	char(2);  -- Digitos iniciales para lada del DF
DECLARE		DigIniLadaGDL	char(2);  -- Digitos iniciales para lada de Guadalajara
DECLARE		DigIniLadaMTY	char(2);  -- Digitos iniciales para lada de Monterrey

-- Asignacion de Constantes
Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	DigIniLadaDF	:= '55';
Set	DigIniLadaGDL	:= '33';
Set	DigIniLadaMTY	:= '81';

DROP TEMPORARY TABLE IF EXISTS TMPSMSENVIO;
	CREATE TEMPORARY TABLE TMPSMSENVIO(
		`SmsEnvioID`		INT(11) NOT NULL AUTO_INCREMENT,
		`Receptor`			VARCHAR(45),
		`NumCliente` 		INT(11) NOT NULL,
		`NombreCliente`		VARCHAR(200),
		`FechaRespuesta`	DATETIME,
		`FechaLimiteRes`	DATE,
		`NomCampania` 		VARCHAR(20),
		`VarFechSistema` 	DATE,
		`VarHoraSistema` 	TIME,
		`NombreUsuario` 	VARCHAR(250),
		PRIMARY KEY(`SmsEnvioID`),
		KEY `INDEX_TMPSMSENVIO_1` (`NumCliente`)
		);

Set NomCampania := (Select Nombre
						from SMSCAMPANIAS
						where CampaniaID = Par_CampaniaID);

set VarFechSistema:= (Select FechaSistema
						from PARAMETROSSIS);

set VarHoraSistema := (select CURRENT_TIME());

set NombreUsuario :=(select NombreCompleto from USUARIOS where UsuarioID= Aud_Usuario);

if(ifnull(Par_CodigoResID,Cadena_Vacia)= Cadena_Vacia)then
	-- INSERTA LOS REGISTROS DE LA TABLA SMSENVIOMENSAJE
	INSERT INTO TMPSMSENVIO(Receptor,		NumCliente,		NombreCliente,	FechaRespuesta,	FechaLimiteRes,
							NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario)
		Select  if(SUBSTRING(Receptor,1,2)=DigIniLadaDF or SUBSTRING(Receptor,1,2)=DigIniLadaGDL or SUBSTRING(Receptor,1,2)=DigIniLadaMTY,
					concat(SUBSTRING(Receptor,1,2),"-",SUBSTRING(Receptor,3)),
					concat(SUBSTRING(Receptor,1,3),"-",SUBSTRING(Receptor,4))) AS Receptor,
					c.ClienteID as NumCliente,	c.NombreCompleto as NombreCliente,	FechaRespuesta, 	FechaLimiteRes,
				NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario
				from 	SMSENVIOMENSAJE Env
				INNER JOIN SMSCAMPANIAS  Cam ON Cam.CampaniaID = Env.CampaniaID
				 LEFT OUTER JOIN CLIENTES c ON c.TelefonoCelular = Env.Receptor
				where Env.CampaniaID 	= Par_CampaniaID
				and Env.CodigoRespuesta NOT IN (select CodigoRespID from  SMSCODIGOSRESP
				 						where   CampaniaID = Par_CampaniaID );

	-- INSERTA LOS REGISTROS DE LA TABLA HISSMSENVIOMENSAJE

	INSERT INTO TMPSMSENVIO(Receptor,		NumCliente,		NombreCliente,	FechaRespuesta,	FechaLimiteRes,
							NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario)
		SELECT  if(SUBSTRING(Receptor,1,2)=DigIniLadaDF OR SUBSTRING(Receptor,1,2)=DigIniLadaGDL OR SUBSTRING(Receptor,1,2)=DigIniLadaMTY,
					concat(SUBSTRING(Receptor,1,2),"-",SUBSTRING(Receptor,3)),
					concat(SUBSTRING(Receptor,1,3),"-",SUBSTRING(Receptor,4))) AS Receptor,
					c.ClienteID AS NumCliente,	c.NombreCompleto AS NombreCliente,	FechaRespuesta, 	FechaLimiteRes,
				NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario
				FROM 	HISSMSENVIOMENSAJE Env
				INNER JOIN SMSCAMPANIAS  Cam ON Cam.CampaniaID = Env.CampaniaID
				 LEFT OUTER JOIN CLIENTES c ON c.TelefonoCelular = Env.Receptor
				WHERE Env.CampaniaID 	= Par_CampaniaID
				  AND IFNULL(Env.CodigoRespuesta,Cadena_Vacia) = Cadena_Vacia;
else
	-- INSERTA LOS REGISTROS DE LA TABLA SMSENVIOMENSAJE
	INSERT INTO TMPSMSENVIO(Receptor,		NumCliente,		NombreCliente,	FechaRespuesta,	FechaLimiteRes,
							NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario)
		Select  if(SUBSTRING(Receptor,1,2)=DigIniLadaDF or SUBSTRING(Receptor,1,2)=DigIniLadaGDL or SUBSTRING(Receptor,1,2)=DigIniLadaMTY,
					concat(SUBSTRING(Receptor,1,2),"-",SUBSTRING(Receptor,3)),
					concat(SUBSTRING(Receptor,1,3),"-",SUBSTRING(Receptor,4))) AS Receptor,
					c.ClienteID as NumCliente,	c.NombreCompleto as NombreCliente,	FechaRespuesta, 	FechaLimiteRes,
				NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario
				from 	SMSENVIOMENSAJE Env
				INNER JOIN SMSCAMPANIAS  Cam ON Cam.CampaniaID = Env.CampaniaID
				 LEFT OUTER JOIN CLIENTES c ON c.TelefonoCelular = Env.Receptor
				where CodigoRespuesta 	= Par_CodigoResID
				and   Env.CampaniaID 	= Par_CampaniaID;

	-- INSERTA LOS REGISTROS DE LA TABLA HISSMSENVIOMENSAJE
	INSERT INTO TMPSMSENVIO(Receptor,		NumCliente,		NombreCliente,	FechaRespuesta,	FechaLimiteRes,
							NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario)
		SELECT  if(SUBSTRING(Receptor,1,2)=DigIniLadaDF OR SUBSTRING(Receptor,1,2)=DigIniLadaGDL OR SUBSTRING(Receptor,1,2)=DigIniLadaMTY,
					concat(SUBSTRING(Receptor,1,2),"-",SUBSTRING(Receptor,3)),
					concat(SUBSTRING(Receptor,1,3),"-",SUBSTRING(Receptor,4))) AS Receptor,
					c.ClienteID AS NumCliente,	c.NombreCompleto AS NombreCliente,	FechaRespuesta, 	FechaLimiteRes,
				NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario
				FROM 	HISSMSENVIOMENSAJE Env
				INNER JOIN SMSCAMPANIAS  Cam ON Cam.CampaniaID = Env.CampaniaID
				 LEFT OUTER JOIN CLIENTES c ON c.TelefonoCelular = Env.Receptor
				WHERE CodigoRespuesta 	= Par_CodigoResID
				  AND Env.CampaniaID 	= Par_CampaniaID;
end if;

SELECT 	Receptor,		NumCliente,		NombreCliente,	FechaRespuesta,	FechaLimiteRes,
		NomCampania,	VarFechSistema,	VarHoraSistema,	NombreUsuario
FROM TMPSMSENVIO;
DROP TEMPORARY TABLE IF EXISTS TMPSMSENVIO;

END TerminaStore$$