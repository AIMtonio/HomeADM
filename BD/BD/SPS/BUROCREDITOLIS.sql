-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUROCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUROCREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `BUROCREDITOLIS`(
/*SP PARA MOSTRAR LOS DATOS DE UNA CONSULTA POR SOLICTUD EN BURO DE CREDITO*/
	Par_SolCreditoID 		INT(11),
	Par_UsuarioID	 		INT(11),
	Par_NumLis				TINYINT UNSIGNED,

    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(12)

	)
TerminaStore: BEGIN

	/* Declaracion de variables */
	DECLARE Par_DiasVigBC	INT;
	DECLARE VarRealizaConCC	CHAR(1);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);
	DECLARE NumErr   		INT;
	DECLARE ErrMen    		VARCHAR(400);
	DECLARE Par_Titular 	INT;
	DECLARE Par_Aval 		INT;
	DECLARE Var_Oficial		CHAR(1);
	DECLARE Par_OblSolid	INT(11);
	DECLARE Par_RequiereSIC CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';
	SET	Entero_Cero		:= 0;
	SET SalidaSI		:='S';
	SET SalidaNO		:='N';
	SET NumErr   		:= 0;
	SET ErrMen 			:= '';
	SET Par_Titular 	:= 1; -- valor para titular
	SET Par_Aval		:= 2; -- Valor para Avales
	SET Var_Oficial		:='S';
	SET Par_OblSolid	:= 3; -- Valor para Obligados solidarios

	SET VarRealizaConCC	:= (SELECT RealizaConsultasCC FROM USUARIOS WHERE UsuarioID = Par_UsuarioID);
	SET VarRealizaConCC	:= IFNULL(VarRealizaConCC,Cadena_Vacia);

	SELECT DiasVigenciaBC INTO Par_DiasVigBC FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;
	SET Par_DiasVigBC:= IFNULL(Par_DiasVigBC,Entero_Cero);

	SELECT ReqConsultaSIC INTO Par_RequiereSIC
		FROM SOLICITUDCREDITO SC
		INNER JOIN  PRODUCTOSCREDITO PRC ON PRC.ProducCreditoID	= SC.ProductoCreditoID
		WHERE SC.SolicitudCreditoID = Par_SolCreditoID;


	DROP TABLE IF EXISTS TMPBUROCREDITO;
	CREATE TABLE TMPBUROCREDITO(
		Relacion				INT(11)			DEFAULT NULL,
		AvalID					BIGINT(11)		DEFAULT NULL,
		ClienteID				INT(11)			DEFAULT NULL,
		NombreCompleto			VARCHAR(200)	DEFAULT NULL,
		RFC						CHAR(13)		DEFAULT NULL,
		EstadoCivil				CHAR(2)			DEFAULT NULL,
		FolioConsulta			VARCHAR(30)		DEFAULT NULL,
		FechaConsulta			DATETIME		DEFAULT NULL,
		ProspectoID				INT(11)			DEFAULT NULL,
		DiasVigencia			INT(11)			DEFAULT NULL,
		Calle					VARCHAR(50)		DEFAULT NULL,
		EstadoID				INT(11)			DEFAULT NULL,
		MunicipioID				INT(11)			DEFAULT NULL,
		CP						VARCHAR(5)		DEFAULT NULL,
		Oficial					CHAR(1)			DEFAULT NULL,
		FolioCirculo			VARCHAR(30)		DEFAULT NULL,
		FechaCirculo			DATETIME		DEFAULT NULL,
		DiasVigenciaC			INT(11)			DEFAULT NULL,
		RealizaConsultasCC		CHAR(1)			DEFAULT NULL,
		TipoContratoCCID		VARCHAR(2)		DEFAULT NULL,
		KEY INDICE_TMPBUROCREDITO_1 (Relacion),
		KEY INDICE_TMPBUROCREDITO_2 (AvalID),
		KEY INDICE_TMPBUROCREDITO_3 (ClienteID),
		KEY INDICE_TMPBUROCREDITO_4 (ProspectoID)
	);

	INSERT INTO TMPBUROCREDITO(
			Relacion,					AvalID,					ClienteID,			NombreCompleto,			RFC,
			EstadoCivil,				FolioConsulta,			FechaConsulta,		ProspectoID,			DiasVigencia,
			Calle,						EstadoID,				MunicipioID,		CP,						Oficial,
			FolioCirculo,				FechaCirculo,			DiasVigenciaC,		RealizaConsultasCC,		TipoContratoCCID
	)
	(SELECT Par_Titular AS Relacion,	Entero_Cero AS AvalID,	IFNULL(CLI.ClienteID,Entero_Cero) AS ClienteID,
			CASE IFNULL(CLI.ClienteID,Entero_Cero)
				WHEN Entero_Cero THEN CLI.NombreCompleto
				ELSE CLI.NombreCompleto END AS NombreCompleto,
			CASE IFNULL(CLI.ClienteID,Entero_Cero)
				WHEN Entero_Cero THEN CLI.RFC
					ELSE CLI.RFC END AS RFC,
			EstadoCivil,
			SOL.FolioConsulta,
			SOL.FechaConsulta,
			IFNULL(CLI.ProspectoID,Entero_Cero) AS ProspectoID,
			IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),SOL.FechaConsulta),Entero_Cero) AS DiasVigencia,
			IFNULL(CLI.Calle,Cadena_Vacia) AS Calle,
			IFNULL(CLI.EstadoID,Entero_Cero) AS EstadoID,
			IFNULL(CLI.MunicipioID,Entero_Cero) AS MunicipioID,
			IFNULL(CLI.CP,Entero_Cero) AS CP,
			IFNULL(CLI.Oficial,Cadena_Vacia) AS Oficial,
			SOLC.FolioConsultaC AS FolioCirculo,
			SOLC.FechaConsulta AS FechaCirculo,
			IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),SOLC.FechaConsulta),Entero_Cero) AS DiasVigenciaC,
			VarRealizaConCC AS RealizaConsultasCC,
			TipoContratoCCID
	FROM
		(SELECT	IFNULL(CLI.ClienteID,Entero_Cero) AS ClienteID,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN PRO.NombreCompleto
					ELSE CLI.NombreCompleto END AS NombreCompleto,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN PRO.EstadoCivil
					ELSE CLI.EstadoCivil END AS EstadoCivil,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN CAST(PRO.RFC AS CHAR(13))
					ELSE CAST(CLI.RFC AS CHAR(13)) END AS RFC,
				IFNULL(PRO.ProspectoID,Entero_Cero) AS ProspectoID, SC.SolicitudCreditoID,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN PRO.Calle
					ELSE DIR.Calle END AS Calle,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN PRO.EstadoID
					ELSE DIR.EstadoID END AS EstadoID,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN PRO.MunicipioID
					ELSE DIR.MunicipioID END AS MunicipioID,
				CASE IFNULL(CLI.ClienteID,Entero_Cero)
					WHEN Entero_Cero THEN PRO.CP
					ELSE DIR.CP END AS CP,
				IFNULL(DIR.Oficial,'') AS Oficial, TipoContratoCCID
			FROM SOLICITUDCREDITO SC
				LEFT OUTER JOIN PROSPECTOS		PRO	ON SC.ProspectoID		= PRO.ProspectoID
				LEFT OUTER JOIN CLIENTES		CLI	ON SC.ClienteID			= CLI.ClienteID
				LEFT OUTER JOIN DIRECCLIENTE 	DIR ON CLI.ClienteID		= DIR.ClienteID AND DIR.Oficial ="S"
				INNER JOIN  PRODUCTOSCREDITO	PRC ON PRC.ProducCreditoID	= SC.ProductoCreditoID
			WHERE CASE WHEN IFNULL(SC.ClienteID,Entero_Cero) >Entero_Cero THEN SC.ClienteID		= CLI.ClienteID
				 ELSE SC.ProspectoID =  PRO.ProspectoID END
				AND SC.SolicitudCreditoID = Par_SolCreditoID)AS CLI
		LEFT OUTER JOIN SOLBUROCREDITO SOL ON CLI.RFC = SOL.RFC
			AND SOL.FechaConsulta = (SELECT FechaConsulta FROM SOLBUROCREDITO WHERE RFC = SOL.RFC
			AND IFNULL(FolioConsulta, '') <> '' ORDER BY FechaConsulta DESC LIMIT 1)
			AND CLI.SolicitudCreditoID = Par_SolCreditoID
		LEFT OUTER JOIN SOLBUROCREDITO SOLC ON CLI.RFC = SOLC.RFC
			AND SOLC.FechaConsulta = (SELECT FechaConsulta FROM SOLBUROCREDITO WHERE RFC = SOLC.RFC
			AND IFNULL(FolioConsultaC,'') <> '' ORDER BY FechaConsulta DESC LIMIT 1)
			AND CLI.SolicitudCreditoID = Par_SolCreditoID
		GROUP BY CLI.ClienteID, SOL.FolioConsulta,		SOL.FechaConsulta,	CLI.ProspectoID,
				 CLI.Calle,		CLI.EstadoID,			CLI.MunicipioID, 	CLI.CP,
                 CLI.Oficial,	SOLC.FolioConsultaC,	SOLC.FechaConsulta)
	UNION
		(SELECT		Par_Aval AS Relacion,
					CON.AvalID AS AvalID,
					CON.ClienteID AS ClienteID,
					CON.NombreCompleto,
					CON.RFC,
					EstadoCivil,
					SOL.FolioConsulta,
					SOL.FechaConsulta,
					CON.ProspectoID AS ProspectoID,
					IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),SOL.FechaConsulta),Entero_Cero) AS DiasVigencia,
					IFNULL(CON.Calle,Cadena_Vacia) AS Calle,
					IFNULL(CON.EstadoID,Entero_Cero) AS EstadoID,
					IFNULL(CON.MunicipioID,Entero_Cero) AS MunicipioID,
					IFNULL(CON.CP,Entero_Cero) AS CP,
					IFNULL(CON.Oficial,Cadena_Vacia) AS Oficial,
					SOLC.FolioConsultaC AS FolioCirculo,
					SOLC.FechaConsulta AS FechaCirculo,
					IFNULL(Par_DiasVigBC - DATEDIFF(NOW(),SOLC.FechaConsulta),Entero_Cero) AS DiasVigenciaC,
					VarRealizaConCC AS RealizaConsultasCC,
					TipoContratoCCID
		FROM	(SELECT	IFNULL(AP.AvalID,Entero_Cero) AS AvalID,	AP.ClienteID, IFNULL(PRO.ProspectoID,Entero_Cero) AS ProspectoID,
						CASE	WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero
									THEN A.NombreCompleto
								ELSE CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero
									THEN CLI.NombreCompleto
								ELSE  CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero
									THEN PRO.NombreCompleto
								ELSE CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero
									THEN  A.NombreCompleto
								ELSE CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero
									THEN A.NombreCompleto END END END END END AS NombreCompleto,

						CASE	WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero
									THEN A.EstadoCivil
								ELSE CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero
									THEN CLI.EstadoCivil
								ELSE  CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero
									THEN PRO.EstadoCivil
								ELSE CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero
									THEN  A.EstadoCivil
								ELSE CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero
									THEN A.EstadoCivil END END END END END AS EstadoCivil,

								CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  A.RFC
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  CLI.RFC
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
								  PRO.RFC
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
								  A.RFC
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
								  A.RFC END END END END END AS RFC,
								CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  A.Calle
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  DIR.Calle
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
								  PRO.Calle
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
								  A.Calle
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
								  A.Calle END END END END END AS Calle,
								CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  A.EstadoID
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  DIR.EstadoID
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
								  PRO.EstadoID
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
								  A.EstadoID
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
								  A.EstadoID END END END END END AS EstadoID,
								CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  A.MunicipioID
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  DIR.MunicipioID
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
								  PRO.MunicipioID
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
								  A.MunicipioID
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
								  A.MunicipioID END END END END END AS MunicipioID,
								CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  A.CP
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
								  DIR.CP
								  ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
								  PRO.CP
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
								  A.CP
								  ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
								  A.CP END END END END END AS CP,
								IFNULL(DIR.Oficial,Cadena_vacia) AS Oficial,
								SC.SolicitudCreditoID, TipoContratoCCID
		FROM AVALESPORSOLICI AP
			 INNER JOIN SOLICITUDCREDITO SC ON SC.SolicitudCreditoID = AP.SolicitudCreditoID
					LEFT OUTER JOIN PROSPECTOS PRO ON AP.ProspectoID =  PRO.ProspectoID
					LEFT OUTER JOIN CLIENTES CLI ON AP.ClienteID =  CLI.ClienteID
					LEFT OUTER JOIN AVALES A ON AP.AvalID = A.AvalID
					LEFT OUTER JOIN DIRECCLIENTE DIR ON AP.ClienteID=DIR.ClienteID AND DIR.Oficial ="S"
					INNER JOIN  PRODUCTOSCREDITO	PRC ON PRC.ProducCreditoID	= SC.ProductoCreditoID
		WHERE AP.SolicitudCreditoID = Par_SolCreditoID) AS CON
	LEFT JOIN
		SOLBUROCREDITO SOL ON CON.RFC = SOL.RFC AND SOL.FechaConsulta = (SELECT FechaConsulta FROM SOLBUROCREDITO WHERE RFC = SOL.RFC AND
	IFNULL(FolioConsulta, '') <> ''  ORDER BY FechaConsulta DESC LIMIT 1)
	LEFT JOIN
		SOLBUROCREDITO SOLC ON CON.RFC = SOLC.RFC AND
		SOLC.FechaConsulta = (SELECT FechaConsulta FROM SOLBUROCREDITO WHERE RFC = SOLC.RFC AND
	IFNULL(FolioConsultaC, '') <> ''  ORDER BY FechaConsulta DESC LIMIT 1)
	WHERE CON.SolicitudCreditoID= Par_SolCreditoID);

	IF (Par_RequiereSIC = SalidaSI) THEN
		INSERT INTO TMPBUROCREDITO(
			Relacion,			AvalID,				ClienteID,				NombreCompleto,			RFC,
			EstadoCivil,		FolioConsulta,		FechaConsulta,			ProspectoID,			DiasVigencia,
			Calle,				EstadoID,			MunicipioID,			CP,						Oficial,
			FolioCirculo,		FechaCirculo,		DiasVigenciaC,			RealizaConsultasCC,		TipoContratoCCID)
		SELECT	Par_OblSolid,		OP.OblSolidID,		OP.ClienteID,			OBL.NombreCompleto,		OBL.RFC,
				OBL.EstadoCivil,	Cadena_Vacia, 		Fecha_Vacia,			OP.ProspectoID,			Entero_Cero,
				OBL.Calle,			OBL.EstadoID,		OBL.MunicipioID,		OBL.CP,					Cadena_Vacia,
				Cadena_Vacia,		Fecha_Vacia,		Entero_Cero,			Cadena_Vacia,			PRC.TipoContratoCCID
			FROM OBLSOLIDARIOSPORSOLI OP
			INNER JOIN SOLICITUDCREDITO SC  ON SC.SolicitudCreditoID = OP.SolicitudCreditoID
			INNER JOIN OBLIGADOSSOLIDARIOS OBL ON OP.OblSolidID = OBL.OblSolidID
			INNER JOIN PRODUCTOSCREDITO PRC ON PRC.ProducCreditoID	= SC.ProductoCreditoID
			WHERE OP.SolicitudCreditoID = Par_SolCreditoID
			  AND OP.OblSolidID != Entero_Cero;

		INSERT INTO TMPBUROCREDITO(
				Relacion,			AvalID,				ClienteID,				ProspectoID,			NombreCompleto,
				RFC,				EstadoCivil,		FolioConsulta,			FechaConsulta,			DiasVigencia,
				Calle,				EstadoID,			MunicipioID,			CP,						Oficial,
				FolioCirculo,		FechaCirculo,		DiasVigenciaC,			RealizaConsultasCC,		TipoContratoCCID)
		SELECT	Par_OblSolid,		OP.OblSolidID,		OP.ClienteID,			OP.ProspectoID,			CLI.NombreCompleto,
				CLI.RFC,			CLI.EstadoCivil,	Cadena_Vacia, 			Fecha_Vacia,			Entero_Cero,
				DIR.Calle,			DIR.EstadoID,		DIR.MunicipioID,		DIR.CP,					DIR.Oficial,
				Cadena_Vacia,		Fecha_Vacia,		Entero_Cero,			Cadena_Vacia,			PRC.TipoContratoCCID
			FROM TMPBUROCREDITO TMP
			RIGHT JOIN OBLSOLIDARIOSPORSOLI OP ON TMP.ClienteID = OP.ClienteID
			INNER JOIN SOLICITUDCREDITO SC  ON SC.SolicitudCreditoID = OP.SolicitudCreditoID
			INNER JOIN CLIENTES CLI ON OP.ClienteID = CLI.ClienteID
			LEFT JOIN DIRECCLIENTE DIR ON CLI.ClienteID=DIR.ClienteID AND DIR.Oficial ="S"
			INNER JOIN PRODUCTOSCREDITO PRC ON PRC.ProducCreditoID	= SC.ProductoCreditoID
			WHERE OP.SolicitudCreditoID = Par_SolCreditoID
			  AND TMP.ClienteID IS NULL;

		INSERT INTO TMPBUROCREDITO(
				Relacion,			AvalID,				ClienteID,				ProspectoID,			NombreCompleto,
				RFC,				EstadoCivil,		FolioConsulta,			FechaConsulta,			DiasVigencia,
				Calle,				EstadoID,			MunicipioID,			CP,						Oficial,
				FolioCirculo,		FechaCirculo,		DiasVigenciaC,			RealizaConsultasCC,		TipoContratoCCID)
		SELECT	Par_OblSolid,		OP.OblSolidID,		OP.ClienteID,			OP.ProspectoID,			PRO.NombreCompleto,
				PRO.RFC,			PRO.EstadoCivil,	Cadena_Vacia, 			Fecha_Vacia,			Entero_Cero,
				PRO.Calle,			PRO.EstadoID,		PRO.MunicipioID,		PRO.CP,					Cadena_Vacia,
				Cadena_Vacia,		Fecha_Vacia,		Entero_Cero,			Cadena_Vacia,			PRC.TipoContratoCCID
			FROM TMPBUROCREDITO TMP
			RIGHT JOIN OBLSOLIDARIOSPORSOLI OP ON TMP.ProspectoID = OP.ProspectoID
			INNER JOIN SOLICITUDCREDITO SC  ON SC.SolicitudCreditoID = OP.SolicitudCreditoID
			INNER JOIN PROSPECTOS PRO ON OP.ProspectoID = PRO.ProspectoID
			INNER JOIN PRODUCTOSCREDITO PRC ON PRC.ProducCreditoID	= SC.ProductoCreditoID
			WHERE OP.SolicitudCreditoID = Par_SolCreditoID
			  AND TMP.ProspectoID IS NULL;
	END IF;



	UPDATE TMPBUROCREDITO TMP
		LEFT JOIN
			SOLBUROCREDITO SOL ON TMP.RFC = SOL.RFC AND
			SOL.FechaConsulta = (SELECT SOL.FechaConsulta FROM SOLBUROCREDITO WHERE TMP.RFC = SOL.RFC AND
				IFNULL(SOL.FolioConsulta, '') <> ''  ORDER BY SOL.FechaConsulta DESC LIMIT 1)
		LEFT JOIN
			SOLBUROCREDITO SOLC ON TMP.RFC = SOLC.RFC AND
			SOLC.FechaConsulta = (SELECT SOLC.FechaConsulta FROM SOLBUROCREDITO WHERE TMP.RFC = SOLC.RFC AND
				IFNULL(SOLC.FolioConsultaC, '') <> ''  ORDER BY SOLC.FechaConsulta DESC LIMIT 1)
		SET TMP.FolioConsulta = SOL.FolioConsulta,
			TMP.FechaConsulta = SOL.FechaConsulta,
			TMP.DiasVigencia = IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),SOL.FechaConsulta),Entero_Cero),
			TMP.FolioCirculo = SOLC.FolioConsultaC,
			TMP.FechaCirculo = SOLC.FechaConsulta,
			TMP.DiasVigenciaC = IFNULL(Par_DiasVigBC - DATEDIFF(NOW(),SOLC.FechaConsulta),Entero_Cero),
			TMP.RealizaConsultasCC = VarRealizaConCC;

	SELECT	Relacion,			AvalID,				ClienteID,				ProspectoID,			NombreCompleto,
			RFC,				EstadoCivil,		FolioConsulta,			FechaConsulta,			DiasVigencia,
			Calle,				EstadoID,			MunicipioID,			CP,						Oficial,
			FolioCirculo,		FechaCirculo,		DiasVigenciaC,			RealizaConsultasCC,		TipoContratoCCID
	FROM TMPBUROCREDITO;

END TerminaStore$$