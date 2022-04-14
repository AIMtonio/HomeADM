-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OBLSOLIDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OBLSOLIDLIS`;DELIMITER $$

CREATE PROCEDURE `OBLSOLIDLIS`(
	-- SP para el listado de Obligados Solidarios   de un Cliente para un Credito
	Par_Nombre			VARCHAR(50),			-- Nombre del Obligado Solidario
	Par_ClienteID		INT(11),				-- Identificador del cliente para sacar su lista de Obligado Solidario
	Par_NumLis			TINYINT UNSIGNED,		-- Numero de Lista

	/* Parametros de Auditoria */
	Aud_EmpresaID		INT(11),				-- Parámetros de Auditoria
	Aud_Usuario			INT(11),				-- Parámetros de Auditoria
	Aud_FechaActual		DATETIME,				-- Parámetros de Auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parámetros de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parámetros de Auditoria
	Aud_Sucursal		INT(11),				-- Parámetros de Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parámetros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);		-- Cadena vacía
	DECLARE Cadena_Espacio		VARCHAR(2);		-- Espacio en blanco
	DECLARE Fecha_Vacia     	DATE;			-- Fecha vacía
	DECLARE Entero_Cero     	INT(11);		-- Entero cero
	DECLARE Lis_Principal   	INT(11);		-- Listar principal
	DECLARE Lis_Creditos		INT(11);		-- Listar creditos
	DECLARE Lis_OblSolxCliente 	INT(11);		-- Listar Obligado solidario por cliente
	DECLARE Esta_Vigente		CHAR(1);		-- Bandera está vigente
	DECLARE Esta_Vencido		CHAR(1);		-- Bandera está vencido
	DECLARE Esta_Castigado		CHAR(1);		-- Bandera está castigado
	DECLARE CadenaSi			CHAR(1);		-- Constatnte cadena SI
	DECLARE Estatus_Vigente		VARCHAR(10);	-- Valor estatus vigente
	DECLARE Estatus_Vencido		VARCHAR(10);	-- Valor estatus vencido
	DECLARE Estatus_Castigado	VARCHAR(10);	-- Valor estatus castigado
	DECLARE EsOficial			CHAR(1);		-- Bandera es oficial

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Constante Vacio
	SET Cadena_Espacio		:= ' ';				-- Espacio en blanco
	SET Fecha_Vacia			:= '1900-01-01';	-- Constante 1900-01-01
	SET Entero_Cero			:= 0;				-- Constante Cero
	SET Lis_Principal		:= 1;				-- Lista Principal
	SET Lis_Creditos		:= 2;				-- Lista de creditos
	SET Lis_OblSolxCliente 	:= 3;				-- Lista de obligados solidarios x por cliente
	SET Esta_Vigente		:= 'V';				-- Estatus Vigente
	SET Esta_Vencido		:= 'B';				-- Estatus Vencido
    SET Esta_Castigado		:= 'K';				-- Estatus Castigado
	SET CadenaSi			:= 'S';				-- Constante S
    SET Estatus_Vigente		:= 'VIGENTE';		-- Estatus vigente
    SET Estatus_Castigado	:= 'CASTIGADO';		-- Estatus Castigado
    SET Estatus_Vencido		:= 'VENCIDO';		-- Estatus Vencido
	SET EsOficial			:= 'S';			    -- Direccion Oficial: SI

	-- Valores Default
	SET Par_Nombre			:= TRIM(IFNULL(Par_Nombre, Cadena_Vacia));
	SET Par_ClienteID		:= IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_NumLis			:= IFNULL(Par_NumLis, Entero_Cero);


    -- Lista de Ayuda para obligados solidarios
	IF (Par_NumLis = Lis_Principal) THEN
		SELECT	OblSolidID,	NombreCompleto
		FROM OBLIGADOSSOLIDARIOS
		WHERE NombreCompleto LIKE	CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
	END IF;

	-- Lista para Grid de creditos
	IF(Par_NumLis = Lis_Creditos)THEN

		DROP TABLE IF EXISTS TMPOBLSOLSEIDO;
		CREATE TEMPORARY TABLE TMPOBLSOLSEIDO(
			FechaNacimiento		DATE			NOT NULL,
			RFC					VARCHAR(13)		NOT NULL,
			DireccionCompleta	VARCHAR(500)	NOT NULL,
			CreditoID			BIGINT(12)		NOT NULL,
			ClienteID			INT(11)			NOT NULL,
			NombreCompleto		VARCHAR(200)	NOT NULL,
			MontoCredito		DECIMAL(12,2)	NOT NULL,
			INDEX(CreditoID,ClienteID)
        );

		INSERT INTO TMPOBLSOLSEIDO	(
				FechaNacimiento, 		RFC , 		DireccionCompleta,		CreditoID,		ClienteID,
				NombreCompleto,			MontoCredito)
		-- Si el obligado solidario es cliente --
		SELECT	cli.FechaNacimiento,	cli.RFC,	dir.DireccionCompleta,	cre.CreditoID,	cre.ClienteID,
				cli2.NombreCompleto,	cre.MontoCredito
		FROM CLIENTES cli
			INNER JOIN  OBLSOLIDARIOSPORSOLI OBL ON  cli.ClienteID = OBL.ClienteID
			INNER JOIN  CREDITOS cre ON OBL.SolicitudCreditoID = cre.solicitudCreditoID
				AND (cre.Estatus = Esta_Vigente or cre.Estatus = Esta_Vencido)
			INNER JOIN CLIENTES cli2 ON cre.ClienteID = cli2.ClienteID
			LEFT JOIN DIRECCLIENTE dir ON cli.ClienteID = dir.ClienteID
				AND Oficial = CadenaSi
		WHERE cli.NombreCompleto = Par_Nombre;


		INSERT INTO TMPOBLSOLSEIDO(
				FechaNacimiento , 					RFC ,		DireccionCompleta,		CreditoID,		ClienteID,
				NombreCompleto, MontoCredito)
		-- si el obligado solidario no es cliente ni prospecto --
		SELECT	OBL.FechaNac AS FechaNacimiento,	OBL.RFC,	OBL.DireccionCompleta,	cre.CreditoID,	cre.ClienteID,
				cli.NombreCompleto, 				cre.MontoCredito
		FROM  OBLIGADOSSOLIDARIOS OBL
			INNER JOIN OBLSOLIDARIOSPORSOLI OSP ON (OBL.OblSolidID = OSP.OblSolidID)
			INNER JOIN CREDITOS cre ON OSP.SolicitudCreditoID = cre.SolicitudCreditoID
				AND (cre.Estatus = Esta_Vigente or cre.Estatus=Esta_Vencido)
			INNER JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
		WHERE OBL.NombreCompleto = Par_Nombre;


		INSERT INTO TMPOBLSOLSEIDO(
				FechaNacimiento, 		RFC,		DireccionCompleta,
				CreditoID,				ClienteID,
				NombreCompleto,			MontoCredito)
		-- si el obligado solidario  es prospecto --
		SELECT	pro.FechaNacimiento,	pro.RFC,	CONCAT('CALLE ',pro.Calle,', No.',pro.NumExterior,', ',pro.Colonia,', ',mun.Nombre) AS DireccionCompleta,
				cre.CreditoID,			cre.ClienteID,
				cli.NombreCompleto,		cre.MontoCredito
		FROM PROSPECTOS pro
			INNER JOIN MUNICIPIOSREPUB mun ON pro.MunicipioID = mun.MunicipioID AND pro.EstadoID = mun.EstadoID
			INNER JOIN OBLSOLIDARIOSPORSOLI OSP ON pro.ProspectoID = OSP.ProspectoID
			INNER JOIN CREDITOS cre ON OSP.SolicitudCreditoID = cre.SolicitudCreditoID
			LEFT JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
		WHERE pro.NombreCompleto = Par_Nombre
			AND cre.Estatus IN(Esta_Vigente,Esta_Vencido);

		SELECT
			FechaNacimiento,
			IFNULL(RFC, Cadena_Vacia) AS RFC,
			IFNULL(DireccionCompleta, Cadena_Vacia) AS DireccionCompleta,
			CreditoID,
			ClienteID,
			NombreCompleto,
			FORMAT(MontoCredito, 2) AS MontoCredito
		FROM
			TMPOBLSOLSEIDO;

	END IF;

	-- Lista de obligados solidarios x cliente para la pantalla de resumen de cliente.
	IF(Par_NumLis = Lis_OblSolxCliente)THEN
		-- Tabla temporal para el registro de los obligados solidarios del cliente
		DROP TABLE IF EXISTS TMPOBLSOLIDCLIENTES;
		CREATE TEMPORARY TABLE TMPOBLSOLIDCLIENTES(
			ClienteID			INT(11)			NOT NULL,
			NombreCompleto		VARCHAR(200)	NOT NULL,
			SucursalID			INT(11)			NOT NULL,
			Telefono			VARCHAR(100)	NOT NULL,
			TelefonoCel			VARCHAR(100)	NOT NULL,
			DireccionCompleta	VARCHAR(500)	NOT NULL,
			CreditoID			BIGINT(12)		NOT NULL,
			Estatus				VARCHAR(20)		NOT NULL,
			INDEX(ClienteID,CreditoID)
		);

		-- Si el obligado solidario es Cliente
        INSERT INTO TMPOBLSOLIDCLIENTES(
				ClienteID,
				NombreCompleto,
				SucursalID,
				Telefono,
				TelefonoCel,
				DireccionCompleta,
				CreditoID,
				Estatus
			)
		SELECT	cli.ClienteID,
				cli.NombreCompleto,
				cli.SucursalOrigen,
				CASE WHEN LENGTH(cli.Telefono) > Entero_Cero THEN FNMASCARA(cli.Telefono,'(###) ###-####') ELSE IFNULL(cli.Telefono,Cadena_Vacia) END,
				CASE WHEN LENGTH(cli.TelefonoCelular) > Entero_Cero THEN FNMASCARA(cli.TelefonoCelular,'(###) ###-####') ELSE IFNULL(cli.TelefonoCelular,Cadena_Vacia) END,
				IFNULL(dir.DireccionCompleta,Cadena_Vacia),
				cre.CreditoID,
				CASE WHEN cre.Estatus = Esta_Vigente THEN Estatus_Vigente ELSE
				CASE WHEN cre.Estatus = Esta_Vencido THEN Estatus_Vencido ELSE
				CASE WHEN cre.Estatus = Esta_Castigado THEN Estatus_Castigado
				ELSE cre.Estatus END END END AS Estatus
		FROM CLIENTES cli
			INNER JOIN  OBLSOLIDARIOSPORSOLI OSP ON  cli.ClienteID = OSP.ClienteID
			INNER JOIN  CREDITOS cre ON OSP.SolicitudCreditoID = cre.solicitudCreditoID
				AND cre.Estatus IN (Esta_Vigente,Esta_Vencido,Esta_Castigado)
			INNER JOIN CLIENTES cli2 ON cre.ClienteID = cli2.ClienteID
			LEFT JOIN DIRECCLIENTE dir ON cli.ClienteID = dir.ClienteID AND Oficial = EsOficial
		WHERE cre.ClienteID = Par_ClienteID;

		-- Si el obligado solidario no es Cliente ni Prospecto
		INSERT INTO TMPOBLSOLIDCLIENTES(
				ClienteID,
				NombreCompleto,
				SucursalID,
				Telefono,
				TelefonoCel,
				DireccionCompleta,
				CreditoID,
				Estatus)
		SELECT  Entero_Cero,
				OBL.NombreCompleto,
				Entero_Cero,
				CASE WHEN LENGTH(OBL.Telefono) > Entero_Cero THEN FNMASCARA(OBL.Telefono,'(###) ###-####') ELSE IFNULL(OBL.Telefono,Cadena_Vacia) END,
				CASE WHEN LENGTH(OBL.TelefonoCel) > Entero_Cero THEN FNMASCARA(OBL.TelefonoCel,'(###) ###-####') ELSE IFNULL(OBL.TelefonoCel,Cadena_Vacia) END,
				OBL.DireccionCompleta,
				cre.CreditoID,
				CASE WHEN cre.Estatus = Esta_Vigente THEN Estatus_Vigente ELSE
				CASE WHEN cre.Estatus = Esta_Vencido THEN Estatus_Vencido ELSE
				CASE WHEN cre.Estatus = Esta_Castigado THEN Estatus_Castigado
				ELSE cre.Estatus END END END AS Estatus
		FROM  OBLIGADOSSOLIDARIOS  OBL
			INNER JOIN OBLSOLIDARIOSPORSOLI OSP  ON (OBL.OblSOlidID = OSP.OblSolidID)
			INNER JOIN CREDITOS cre ON OSP.SolicitudCreditoID = cre.SolicitudCreditoID
				AND cre.Estatus IN (Esta_Vigente,Esta_Vencido,Esta_Castigado)
			INNER JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
		WHERE cre.ClienteID = Par_ClienteID;


		-- si el obligado solidario es Prospecto
		INSERT INTO TMPOBLSOLIDCLIENTES(
				ClienteID,
				NombreCompleto,
				SucursalID,
				Telefono,
				TelefonoCel,
				DireccionCompleta,
				CreditoID,
				Estatus)
        SELECT	Entero_Cero,
				pro.NombreCompleto,
				Entero_Cero,
				CASE WHEN LENGTH(pro.Telefono) > Entero_Cero THEN FNMASCARA(pro.Telefono,'(###) ###-####') ELSE IFNULL(pro.Telefono,Cadena_Vacia) END,
				Cadena_Vacia,
				CONCAT('CALLE ',pro.Calle,', No.',pro.NumExterior,', ',pro.Colonia,', ',mun.Nombre) AS DireccionCompleta,
				cre.CreditoID,
				CASE WHEN cre.Estatus = Esta_Vigente THEN Estatus_Vigente ELSE
				CASE WHEN cre.Estatus = Esta_Vencido THEN Estatus_Vencido ELSE
				CASE WHEN cre.Estatus = Esta_Castigado THEN Estatus_Castigado
				ELSE cre.Estatus END END END AS Estatus
		FROM PROSPECTOS pro
			INNER JOIN MUNICIPIOSREPUB mun ON pro.MunicipioID = mun.MunicipioID
				AND pro.EstadoID = mun.EstadoID
			INNER JOIN OBLSOLIDARIOSPORSOLI OSP ON pro.ProspectoID = OSP.ProspectoID
			INNER JOIN CREDITOS cre ON OSP.SolicitudCreditoID = cre.SolicitudCreditoID
				AND cre.Estatus IN (Esta_Vigente,Esta_Vencido,Esta_Castigado)
			LEFT JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
		WHERE cre.ClienteID = Par_ClienteID;

		-- Se consulta los datos de los obligados solidarios del cliente
		SELECT	CASE WHEN ClienteID > Entero_Cero THEN ClienteID ELSE Cadena_Vacia END AS ClienteID,
				NombreCompleto,
				CASE WHEN SucursalID > Entero_Cero THEN SucursalID ELSE Cadena_Vacia END AS SucursalID,
				Telefono,
				TelefonoCel,
				DireccionCompleta,
				CreditoID,
				Estatus
		FROM TMPOBLSOLIDCLIENTES;

	END IF;

END TerminaStore$$