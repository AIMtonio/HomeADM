-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSACTIVIDADSMSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSACTIVIDADSMSREP`;

DELIMITER $$
CREATE PROCEDURE `SMSACTIVIDADSMSREP`(
	/*SP para el reporte de envio de mensajes*/
	Par_CampaniaID		INT(11),		-- campania del mensaje
	Par_Estatus        	VARCHAR(10),	-- estatus enviado o no enviados
	Par_FechaInicio    	DATE,			-- fecha inicial de busqueda
	Par_FechaFin       	DATE,			-- fecha final de busqueda

	/*parametos de auditoria*/
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	NomCampania		VARCHAR(20);	-- Nombre de Compania
	DECLARE	NombreCliente	VARCHAR(250);	-- Nombre de Cliente
	DECLARE	NumCliente		INT(11);		-- Numero de Cliente
	DECLARE	VarFechSistema	DATE;			-- Fecha de Sistema
	DECLARE	VarHoraSistema	TIME;			-- Hora de Sistema
	DECLARE	NombreUsuario	VARCHAR(250);	-- Nombre de Usuario

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);	-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;		-- Constante Fecha Vacia
	DECLARE	Entero_Cero		INT(11);	-- Constante Entero Cero
	DECLARE	DigIniLadaDF	CHAR(2);	-- Digitos iniciales para lada del DF
	DECLARE	DigIniLadaGDL	CHAR(2);	-- Digitos iniciales para lada de Guadalajara
	DECLARE	DigIniLadaMTY	CHAR(2);	-- Digitos iniciales para lada de Monterrey
	DECLARE EstatusMenE		CHAR(1);	-- Estatus del mensaje enviado
	DECLARE EstatusMenNE	CHAR(1);	-- Estatus del mensaje no enviado
	DECLARE EstatusMenC		CHAR(1);	-- Estatus del mensaje  cacelado
	DECLARE MenMostarE		CHAR(10);	-- Mostar del mensaje  cacelado
	DECLARE MenMostarNE		CHAR(10);	-- Mostar  del mensaje  cacelado
	DECLARE MenMostarC		CHAR(10);	-- Mostar  del mensaje  cacelado
	DECLARE	EstatusCli		CHAR(1);	-- Estatus Activo de Cliente

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Constante Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Constante Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Constante Entero Cero
	SET	DigIniLadaDF	:= '55';			-- lada del mensaje
	SET	DigIniLadaGDL	:= '33';			-- lada
	SET	DigIniLadaMTY	:= '81';			-- lada
	SET EstatusMenC		:= 'C';				-- C cancelado
	SET EstatusMenE		:= 'E';				-- E enviado
	SET EstatusMenNE	:= 'N';				-- N no enviado
	SET MenMostarE		:= 'ENVIADO';		-- Mensaje Enviado
	SET MenMostarNE		:= 'NO ENVIADO';	-- Mensaje No Enviado
	SET MenMostarC		:= 'CANCELADO';		-- Mensaje Cancelado
	SET EstatusCli		:= 'A';				--

	DROP TEMPORARY TABLE IF EXISTS TMPSMSENVIO;
	CREATE TEMPORARY TABLE TMPSMSENVIO(
		`SmsEnvioID`		INT(11) NOT NULL AUTO_INCREMENT,
		`EnvioID` 			INT(11) NOT NULL,
		`Estatus`			CHAR(10),
		`Remitente`			VARCHAR(45),
		`Receptor`			VARCHAR(45),
		`FechaRealEnvio`	VARCHAR(20),
		`Mensaje`			VARCHAR(160),
		`CampaniaID` 		INT(11) NOT NULL,
		`NombreCampania` 	VARCHAR(50),
		`Clasificacion`		CHAR(1),
		`Categoria`			CHAR(1),
		`Tipo`				INT(11),
		`FechaLimiteRes`	DATE,
		`CodigoRespuesta`	VARCHAR(10),
		`Descripcion`		VARCHAR(50),
		`FechaRespuesta`	DATE,
		`CuentaAsociada`	VARCHAR(20),
		`NumeroCliente`		VARCHAR(20),
		`NombreCompleto`	VARCHAR(200),
	PRIMARY KEY(`SmsEnvioID`),
	KEY `INDEX_TMPSMSENVIO_1` (`EnvioID`),
	KEY `INDEX_TMPSMSENVIO_2` (`CampaniaID`),
	KEY `INDEX_TMPSMSENVIO_3` (`CodigoRespuesta`),
	KEY `INDEX_TMPSMSENVIO_4` (`CuentaAsociada`),
	KEY `INDEX_TMPSMSENVIO_5` (`NumeroCliente`),
	KEY `INDEX_TMPSMSENVIO_6` (`NumeroCliente`,`Receptor`));

	SET NomCampania := (SELECT Nombre
							FROM SMSCAMPANIAS
								WHERE CampaniaID = Par_CampaniaID);

	SET VarFechSistema:= (SELECT FechaSistema
							FROM PARAMETROSSIS);

	SET VarHoraSistema := (SELECT CURRENT_TIME());

	SET NombreUsuario :=(SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID= Aud_Usuario);


	IF(Par_CampaniaID = Entero_Cero)THEN

		-- INSERTA LOS REGISTROS DE LA TABLA SMSENVIOMENSAJE
		INSERT INTO TMPSMSENVIO(
			EnvioID,		Estatus,		Remitente,			Receptor,		FechaRealEnvio,
			Mensaje,		CampaniaID,		NombreCampania,		Clasificacion,	Categoria,
			Tipo,			FechaLimiteRes,	CodigoRespuesta,	Descripcion,	FechaRespuesta,
			CuentaAsociada,	NumeroCliente,	NombreCompleto)
		(SELECT	sms.EnvioID,
				CASE WHEN sms.Estatus = EstatusMenE  THEN MenMostarE
					 WHEN sms.Estatus = EstatusMenNE THEN MenMostarNE
					 WHEN sms.Estatus = EstatusMenC  THEN MenMostarC
				END AS Estatus,
				sms.Remitente, sms.Receptor,
				CASE WHEN sms.Estatus = EstatusMenE  THEN CONVERT(DATE(sms.FechaRealEnvio), CHAR)
					 WHEN sms.Estatus = EstatusMenNE THEN Cadena_Vacia
					 WHEN sms.Estatus = EstatusMenC  THEN Cadena_Vacia
				END AS FechaRealEnvio,
				sms.Mensaje,				sms.CampaniaID,
				camp.Nombre AS NomCampania, camp.Clasificacion, camp.Categoria,	camp.Tipo,		camp.FechaLimiteRes,
				sms.CodigoRespuesta,		Cadena_Vacia, 		DATE(sms.FechaRespuesta) AS FechaRespuesta,
				Cadena_Vacia,				Cadena_Vacia,		Cadena_Vacia
		FROM SMSENVIOMENSAJE sms
		INNER JOIN SMSCAMPANIAS camp ON sms.CampaniaID = camp.CampaniaID
		WHERE DATE(sms.FechaProgEnvio) BETWEEN DATE(Par_FechaInicio) AND DATE(Par_FechaFin)
		  AND sms.Estatus = Par_Estatus
		  AND CAST( REPLACE(REPLACE(REPLACE(REPLACE( sms.Receptor, '(', ''), ')', ''), '-',''), ' ', '')  AS UNSIGNED) > Entero_Cero)
		UNION
		(SELECT	his.EnvioID,
				CASE WHEN his.Estatus = EstatusMenE  THEN MenMostarE
					 WHEN his.Estatus = EstatusMenNE THEN MenMostarNE
					 WHEN his.Estatus = EstatusMenC  THEN MenMostarC
				END AS Estatus,
				his.Remitente, his.Receptor,
				CASE WHEN his.Estatus = EstatusMenE  THEN CONVERT(DATE(his.FechaRealEnvio), CHAR)
					 WHEN his.Estatus = EstatusMenNE THEN Cadena_Vacia
					 WHEN his.Estatus = EstatusMenC  THEN Cadena_Vacia
				END AS FechaRealEnvio,
				his.Mensaje,				his.CampaniaID,
				camp.Nombre AS NomCampania, camp.Clasificacion, camp.Categoria, camp.Tipo,		camp.FechaLimiteRes,
				his.CodigoRespuesta,		Cadena_Vacia,		DATE(his.FechaRespuesta) AS FechaRespuesta,
				Cadena_Vacia,				Cadena_Vacia,		Cadena_Vacia
		FROM HISSMSENVIOMENSAJE his
		INNER JOIN SMSCAMPANIAS camp ON his.CampaniaID = camp.CampaniaID
		WHERE DATE(his.FechaProgEnvio) BETWEEN DATE(Par_FechaInicio) AND DATE(Par_FechaFin)
		  AND his.Estatus = Par_Estatus
		  AND CAST( REPLACE(REPLACE(REPLACE(REPLACE( his.Receptor, '(', ''), ')', ''), '-',''), ' ', '') AS UNSIGNED) >  Entero_Cero);

	ELSE
		-- INSERTA LOS REGISTROS DE LA TABLA SMSENVIOMENSAJE
		INSERT INTO TMPSMSENVIO(
			EnvioID,		Estatus,		Remitente,			Receptor,		FechaRealEnvio,
			Mensaje,		CampaniaID,		NombreCampania,		Clasificacion,	Categoria,
			Tipo,			FechaLimiteRes,	CodigoRespuesta,	Descripcion,	FechaRespuesta,
			CuentaAsociada,	NumeroCliente,	NombreCompleto)
		(SELECT	sms.EnvioID,
				CASE WHEN sms.Estatus = EstatusMenE  THEN MenMostarE
					 WHEN sms.Estatus = EstatusMenNE THEN MenMostarNE
					 WHEN sms.Estatus = EstatusMenC  THEN MenMostarC
				END AS Estatus,
				sms.Remitente, sms.Receptor,
				CASE WHEN sms.Estatus = EstatusMenE  THEN CONVERT(DATE(sms.FechaRealEnvio),  char)
					 WHEN sms.Estatus = EstatusMenNE THEN Cadena_Vacia
					 WHEN sms.Estatus = EstatusMenC  THEN Cadena_Vacia
				END AS FechaRealEnvio,
				sms.Mensaje,				sms.CampaniaID,
				camp.Nombre AS NomCampania, camp.Clasificacion, camp.Categoria, camp.Tipo, 		camp.FechaLimiteRes,
				sms.CodigoRespuesta,		Cadena_Vacia,		DATE(sms.FechaRespuesta) AS FechaRespuesta,
				Cadena_Vacia,				Cadena_Vacia,		Cadena_Vacia
		FROM SMSENVIOMENSAJE sms
		INNER JOIN SMSCAMPANIAS camp ON sms.CampaniaID = camp.CampaniaID
		WHERE sms.CampaniaID = Par_CampaniaID
		  AND DATE(sms.FechaProgEnvio) BETWEEN DATE(Par_FechaInicio) AND DATE(Par_FechaFin)
		  AND sms.Estatus= Par_Estatus
		  AND CAST( REPLACE(REPLACE(REPLACE(REPLACE( sms.Receptor, '(', ''), ')', ''), '-',''), ' ', '') AS UNSIGNED) >  Entero_Cero)
		UNION
		(SELECT	his.EnvioID,
				CASE WHEN his.Estatus = EstatusMenE  THEN MenMostarE
					 WHEN his.Estatus = EstatusMenNE THEN MenMostarNE
					 WHEN his.Estatus = EstatusMenC  THEN MenMostarC
				END AS Estatus,
				his.Remitente, his.Receptor,
				CASE WHEN his.Estatus = EstatusMenE  THEN CONVERT(DATE(his.FechaRealEnvio),  char)
					 WHEN his.Estatus = EstatusMenNE THEN Cadena_Vacia
					 WHEN his.Estatus = EstatusMenC  THEN Cadena_Vacia
				END AS FechaRealEnvio,
				his.Mensaje,				his.CampaniaID,
				camp.Nombre AS NomCampania, camp.Clasificacion,	camp.Categoria, camp.Tipo, 		camp.FechaLimiteRes,
				his.CodigoRespuesta,		Cadena_Vacia,		DATE(his.FechaRespuesta) AS FechaRespuesta,
				Cadena_Vacia,				Cadena_Vacia,		Cadena_Vacia
		FROM HISSMSENVIOMENSAJE his
		INNER JOIN SMSCAMPANIAS camp ON his.CampaniaID = camp.CampaniaID
		WHERE  his.CampaniaID = Par_CampaniaID
		  AND DATE(his.FechaProgEnvio) BETWEEN DATE(Par_FechaInicio) AND DATE(Par_FechaFin)
		  AND his.Estatus= Par_Estatus
		  AND CAST(  REPLACE(REPLACE(REPLACE(REPLACE( his.Receptor, '(', ''), ')', ''), '-',''), ' ', '') AS UNSIGNED) >  Entero_Cero);

	END IF;

	-- Actualizo el al descripcion de codigo de respuesta
	UPDATE TMPSMSENVIO Tmp, SMSCODIGOSRESP Cod SET
		Tmp.Descripcion = Cod.Descripcion
	WHERE Tmp.CodigoRespuesta = Cod.CodigoRespID;

	-- Actualizo el numero de Cuenta y Cliente Actual
	UPDATE TMPSMSENVIO Tmp, SMSENVMENADIC Sms SET
		Tmp.CuentaAsociada = Sms.CuentaAsociada,
		Tmp.NumeroCliente  = Sms.NumeroCliente
	WHERE Tmp.EnvioID = Sms.EnvioID;

	-- Actualizo el numero de Cuenta y Cliente Historico
	UPDATE TMPSMSENVIO Tmp, HISSMSENVMENADIC Sms SET
		Tmp.CuentaAsociada = Sms.CuentaAsociada,
		Tmp.NumeroCliente  = Sms.NumeroCliente
	WHERE Tmp.EnvioID = Sms.EnvioID;

	/* Se actualiza la Cuenta de Ahorro y el Numero de Cliente contra el numero de telefono de la cuenta */
	UPDATE TMPSMSENVIO Tmp, CUENTASAHO Cue SET
		Tmp.CuentaAsociada = Cue.CuentaAhoID,
		Tmp.NumeroCliente  = Cue.ClienteID
	WHERE Tmp.NumeroCliente = Cadena_Vacia
	  AND Tmp.Receptor = Cue.TelefonoCelular;

	/* Si no se registraron Cuentas y Clientes se actualiza el numero de telefono contra el cliente */
	UPDATE TMPSMSENVIO Tmp, CLIENTES Cli SET
		Tmp.NumeroCliente  = Cli.ClienteID
	WHERE Tmp.NumeroCliente = Cadena_Vacia
	  AND Tmp.Receptor = Cli.TelefonoCelular;

	-- Actualizo el Nombre del Cliente
	UPDATE TMPSMSENVIO Tmp, CLIENTES Cli SET
		Tmp.NombreCompleto = Cli.NombreCompleto
	WHERE Tmp.NumeroCliente = Cli.ClienteID;

	-- Salida
	SELECT  EnvioID,		Estatus,		Remitente, 			Receptor, 		FechaRealEnvio,
			Mensaje,		CampaniaID,		NombreCampania,		Clasificacion,	Categoria,
			Tipo,			FechaLimiteRes,	CodigoRespuesta,	Descripcion,	FechaRespuesta,
			CuentaAsociada,	NumeroCliente,	NombreCompleto
		FROM TMPSMSENVIO ORDER BY EnvioID;

	DROP TEMPORARY TABLE IF EXISTS TMPSMSENVIO;


END TerminaStore$$