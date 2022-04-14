-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDCREDITOLIS;

DELIMITER $$
CREATE PROCEDURE SOLICITUDCREDITOLIS(
	# =============================================================================================================
	# ----------------------------------- LISTA DE SOLICITUDES DE CREDITO -----------------------------------------
	# =============================================================================================================
	Par_ClienteID		VARCHAR(50),		-- Numero de Cliente
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	-- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


/* Declaracion de Variables */
DECLARE Var_AtiendeSucursales   CHAR(1);
DECLARE Var_SucursalUsuario     INT(11);
DECLARE Var_SucursalMatrizID	INT(11);		-- Variable de la Sucursal Matriz


-- Declaracion de constantes
DECLARE	Cadena_Vacia			CHAR(1);
DECLARE	Fecha_Vacia				DATE;
DECLARE	Entero_Cero				INT;
DECLARE	Lis_Principal			INT;
DECLARE	Lis_AltaCred			INT;
DECLARE	Lis_DetalleKubo			INT;
DECLARE	EstatDesembol			CHAR(1);
DECLARE	EstatInact				CHAR(1);
DECLARE EstatLiberada			CHAR(1);
DECLARE	Cte						INT;
DECLARE	Lis_IntGrupo			INT;
DECLARE	Lis_IntAvales			INT;
DECLARE	Lis_SolInactiva			INT;
DECLARE	Lis_SolAutoriza			INT;
DECLARE	Lis_SolInacDocPen		INT;
DECLARE Lis_SolLiberadaPromot   INT;
DECLARE Lis_SolicitudesBE		INT;
DECLARE Lis_SolicitudRatios		INT;
DECLARE Lis_SolicitudRenova		INT(11);
DECLARE Lis_SolicitudReest		INT(11);
DECLARE Lis_Agropecuarios		INT(11);
DECLARE Lis_SolRiesgoComun		INT(11);
DECLARE Lis_Reacredita			INT(11);
DECLARE	EstatusAutor			CHAR(1);
DECLARE	Sol_esAutorizada		CHAR(1);
DECLARE	Sol_esInactiva			CHAR(1);
DECLARE	Pro_EsGrupal			CHAR(1);
DECLARE	Pro_ReqAval				CHAR(1);
DECLARE Con_Str_SI	   			CHAR(1);
DECLARE	Con_Str_NO	   			CHAR(1);
DECLARE EstatusCancelada		CHAR(1);
DECLARE Constante_SI			CHAR(1);
DECLARE CreRenovacion			CHAR(1);
DECLARE CreReestructura			CHAR(1);
DECLARE	Lis_GuardaValores		TINYINT UNSIGNED;		-- Numero de Lista 28 Guarda Valores
DECLARE Lis_SolicitudRenovaAgro	INT(11);
DECLARE Lis_SolCredInstConv		INT(11);				-- Numero de Listado de las Solicitudes de Creditos de Nomina y que el convenio que se encuentra LIgado maneja Capacidad de Pago
DECLARE Lis_SolCredNOLibCan		INT(11);				-- Número de listado de las Solicitudes de Crédito NO liberadas o Conceladas.
DECLARE Lis_SolConsolidadaAgro	INT(11);				-- Número de Lista 21.- Solicitudes de Credito Consolidadas Agro
DECLARE Lis_SolConsolidada		INT(11);				-- Número de Lista 22 Solicitudes de crédito consolidadas
DECLARE Con_FlujoConsolida		CHAR(1);				-- Flujo origen para solicitudes consolidadas

-- Asignacion de constantes
SET	Cadena_Vacia	        := '';
SET	Fecha_Vacia		   	    := '1900-01-01';
SET	Entero_Cero		        := 0;
SET	Lis_Principal	        := 1;
SET Lis_AltaCred 	        := 2;
SET	Lis_DetalleKubo         := 3;
SET	Lis_IntGrupo	        := 4;
SET	Lis_IntAvales	        := 5;
SET Lis_SolInactiva	    	:= 6;	-- lista filtrada por estatus inactivo
SET	Lis_SolAutoriza	        := 7;  	-- lista filtrada por estatus autorizado
SET	Lis_SolInacDocPen	    := 8;  	--  Solicitudes Inactivas con Documentacion Pendiente
SET Lis_SolLiberadaPromot   := 9; 	--  9.- Lista de solicitudes de credito Liberadas  Filtradas por el Promotor si es que atiende a sucursal */
SET Lis_SolicitudesBE		:= 10;
SET Lis_SolicitudRatios		:= 11;
SET Lis_SolicitudRenova		:= 12;
SET Lis_SolicitudReest		:= 13;
SET Lis_Agropecuarios		:= 14;	-- Lista las solicitudes de creditos agropecuarios
SET Lis_SolRiesgoComun		:= 15;	-- Lista de Solicitudes que presentan un posible riesgo comun
SET Lis_Reacredita			:= 16;	-- Lista de Solicitudes de Reacreditamiento
SET Lis_GuardaValores		:= 17;	-- Lista de Guarda Valores
SET Lis_SolicitudRenovaAgro	:= 18;	-- Lista de Guarda Valores
SET Lis_SolCredInstConv		:= 19;	-- Numero de Listado de las Solicitudes de Creditos de Nomina y que el convenio que se encuentra LIgado maneja Capacidad de Pago
SET Lis_SolCredNOLibCan		:= 20;	-- Número de listado de las Solicitudes de Crédito NO liberadas o Conceladas.
SET Lis_SolConsolidadaAgro	:= 21;
SET Lis_SolConsolidada		:= 22;

SET EstatDesembol   	    := 'D';
SET EstatInact 		        := 'I';
SET EstatLiberada           := 'L';   -- Estatus de Solicitud Liberada
SET	Sol_esAutorizada        :='A';
SET	Sol_esInactiva	        :='I';
SET	Pro_EsGrupal	        :='S';
SET	Pro_ReqAval		        :='S';
SET EstatusAutor	        := 'A';
SET	Con_Str_SI		        := 'S';
SET	Con_Str_NO		        := 'N';
SET EstatusCancelada		:='C';
SET Constante_SI			:= 'S';
SET CreRenovacion			:= 'O';
SET CreReestructura			:= 'R';
SET Con_FlujoConsolida		:= 'C';

# 1.-  Lista principal de solicitudes de credito
IF(Par_NumLis = Lis_Principal) THEN
			(SELECT    sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	sol.Estatus,        sol.MontoAutorizado,        sol.FechaRegistro
			FROM SOLICITUDCREDITO sol,
				 CLIENTES Cli
			WHERE sol.ClienteID = Cli.ClienteID
				AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50)
		UNION
			(SELECT    sol.SolicitudCreditoID, 	Pros.NombreCompleto,	sol.Estatus,        sol.MontoAutorizado,        sol.FechaRegistro
			FROM SOLICITUDCREDITO sol,
				 PROSPECTOS Pros
			WHERE sol.ProspectoID = Pros.ProspectoID
				AND IFNULL(Pros.ClienteID, Entero_Cero) <= Entero_Cero
				AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50);
END IF;


# 4.- Lista solicitudes grupales
IF(Par_NumLis = Lis_IntGrupo) THEN
			(SELECT	sol.SolicitudCreditoID, 	Cli.NombreCompleto,	sol.Estatus,		sol.MontoAutorizado,		sol.FechaRegistro
			FROM 	SOLICITUDCREDITO sol,
					CLIENTES Cli,
					PRODUCTOSCREDITO Pro
			WHERE 	sol.ClienteID = Cli.ClienteID AND sol.ProductoCreditoID= Pro.ProducCreditoID
			AND 		Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND 		(sol.Estatus=Sol_esAutorizada OR sol.Estatus=Sol_esInactiva OR sol.Estatus=EstatLiberada)
			AND 		sol.SucursalID=Aud_Sucursal
			AND 		Pro.EsGrupal=Pro_EsGrupal
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50)
		UNION
			(SELECT   sol.SolicitudCreditoID, 	Pros.NombreCompleto,	sol.Estatus,		sol.MontoAutorizado,		sol.FechaRegistro
			FROM 	SOLICITUDCREDITO sol,
					PROSPECTOS Pros,
					PRODUCTOSCREDITO Pro
			WHERE 	sol.ProspectoID = Pros.ProspectoID AND sol.ProductoCreditoID= Pro.ProducCreditoID
			AND 		Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND 		(sol.Estatus=Sol_esAutorizada OR sol.Estatus=Sol_esInactiva OR sol.Estatus=EstatLiberada)
			AND 		sol.SucursalID=Aud_Sucursal
			AND 		Pro.EsGrupal=Pro_EsGrupal
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50);
END IF;


# 5.- lista solicitudes de credito que requieren avales
IF(Par_NumLis = Lis_IntAvales) THEN
			(SELECT	sol.SolicitudCreditoID, 	Cli.NombreCompleto,	sol.Estatus,		sol.MontoAutorizado,		sol.FechaRegistro
			FROM 	SOLICITUDCREDITO sol,
					CLIENTES Cli,
					PRODUCTOSCREDITO Pro
			WHERE 	sol.ClienteID = Cli.ClienteID AND sol.ProductoCreditoID= Pro.ProducCreditoID
			AND 		Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND 		sol.SucursalID=Aud_Sucursal
			AND 		Pro.RequiereAvales=Pro_ReqAval
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50)
		UNION
			(SELECT   sol.SolicitudCreditoID, 	Pros.NombreCompleto,	sol.Estatus,		sol.MontoAutorizado,		sol.FechaRegistro
			FROM 	SOLICITUDCREDITO sol,
					PROSPECTOS Pros,
					PRODUCTOSCREDITO Pro
			WHERE 	sol.ProspectoID = Pros.ProspectoID AND sol.ProductoCreditoID= Pro.ProducCreditoID
			AND 		Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND 		sol.SucursalID=Aud_Sucursal
			AND 		Pro.RequiereAvales=Pro_ReqAval
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50);
END IF;


# 6.- Lista de solicitudes de credito inactivas
IF(Par_NumLis = Lis_SolInactiva) THEN
		SELECT    sol.SolicitudCreditoID,	Cli.NombreCompleto,	 sol.Estatus,        format(sol.MontoAutorizado,2),        sol.FechaRegistro
			FROM SOLICITUDCREDITO sol,
				 CLIENTES Cli
			WHERE sol.ClienteID = Cli.ClienteID
			AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND sol.Estatus = EstatInact
		ORDER BY sol.FechaActual DESC
			LIMIT 0, 50;

END IF;


# 7.- Lista de solicitudes de credito autorizadas
IF(Par_NumLis = Lis_SolAutoriza) THEN

	(SELECT    sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	sol.Estatus,        sol.MontoAutorizado,        sol.FechaRegistro
			FROM SOLICITUDCREDITO sol,
				 CLIENTES Cli
			WHERE sol.ClienteID = Cli.ClienteID
			AND sol.Estatus = EstatusAutor
				AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
				ORDER BY sol.FechaActual DESC
				LIMIT 0, 50)
		UNION
			(SELECT    sol.SolicitudCreditoID, 	Pros.NombreCompleto,	sol.Estatus,        sol.MontoAutorizado,        sol.FechaRegistro
			FROM SOLICITUDCREDITO sol,
				 PROSPECTOS Pros
			WHERE sol.ProspectoID = Pros.ProspectoID
				AND IFNULL(Pros.ClienteID, Entero_Cero) <= Entero_Cero
				AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
				AND sol.Estatus = EstatusAutor
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50);
END IF;



# 8.- Lista de solicitudes de credito inactivas con Checklist pendiente
IF(Par_NumLis = Lis_SolInacDocPen) THEN
	SELECT    Sol.SolicitudCreditoID, Sol.Estatus,    format(Sol.MontoSolici,2),  Sol.FechaRegistro
			  , CASE WHEN Sol.ClienteID > 0 THEN Cli.NombreCompleto
											ELSE Pro.NombreCompleto
				END AS NombreCompleto
	FROM SOLICITUDCREDITO Sol
	LEFT JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID
	WHERE Sol.Estatus = EstatInact
	 AND Sol.SolicitudCreditoID IN (SELECT DISTINCT SolicitudCreditoID FROM SOLICIDOCENT WHERE DocRecibido = Con_Str_NO)
	AND (Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")||Pro.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%"))
	ORDER BY Sol.FechaRegistro, Sol.SolicitudCreditoID
	  LIMIT 0, 15;

END IF;



#9.- Lista de solicitudes de credito Liberadas Filtradas por el Usuario si es que atiende a sucursal
IF(Par_NumLis = Lis_SolLiberadaPromot) THEN
	SELECT  Pue.AtiendeSuc,         Usu.SucursalUsuario
	INTO    Var_AtiendeSucursales,  Var_SucursalUsuario
	FROM USUARIOS Usu
	INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID = Usu.ClavePuestoID
	WHERE Usu.UsuarioID = Aud_Usuario;

	SELECT   Sol.SolicitudCreditoID,	Sol.Estatus
			,format(Sol.MontoSolici, 2) AS MontoSolici
			,format(Sol.MontoAutorizado, 2) AS MontoAutorizado
			,Sol.FechaRegistro
			,CASE WHEN Sol.ClienteID > Entero_Cero THEN Cli.NombreCompleto
												   ELSE Pro.NombreCompleto
			  END AS NombreCompleto
			,IFNULL(SolGrp.GrupoID, Entero_Cero) AS Grupo
			,IFNULL(Grp.NombreGrupo, Cadena_Vacia) AS NombreGrupo
	FROM SOLICITUDCREDITO Sol
	LEFT JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID
	LEFT JOIN INTEGRAGRUPOSCRE SolGrp ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID
	LEFT JOIN GRUPOSCREDITO Grp       ON SolGrp.GrupoID = Grp.GrupoID
	WHERE Sol.Estatus = EstatLiberada
	  AND ( (Var_AtiendeSucursales = Con_Str_SI AND Var_SucursalUsuario = Sol.SucursalID)
			OR Var_AtiendeSucursales = Con_Str_NO)
	  AND ( Cli.NombreCompleto  LIKE CONCAT("%",Par_ClienteID,"%")  OR Pro.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%"))
	ORDER BY Sol.FechaRegistro, Sol.SolicitudCreditoID
	 LIMIT 0, 15;

END IF;


# 10.- Lista solicitudes de credito que sean de nomina
IF(Par_NumLis = Lis_SolicitudesBE) THEN
		(SELECT    sol.SolicitudCreditoID,	Cli.NombreCompleto
		FROM SOLICITUDCREDITO sol INNER JOIN SOLICITUDCREDITOBE solbe ON sol.SolicitudCreditoID= solbe.SolicitudCreditoID ,
			 CLIENTES Cli
		WHERE sol.ClienteID = Cli.ClienteID
		AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
		ORDER BY sol.FechaActual DESC
		LIMIT 0, 50)
	UNION
		(SELECT    sol.SolicitudCreditoID, Pros.NombreCompleto
		FROM SOLICITUDCREDITO sol INNER JOIN SOLICITUDCREDITOBE solbe ON sol.SolicitudCreditoID= solbe.SolicitudCreditoID,
			 PROSPECTOS Pros
		WHERE sol.ProspectoID = Pros.ProspectoID
		AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
		ORDER BY sol.FechaActual DESC
		LIMIT 0, 50);

END IF;


# 11.- Lista solicitudes de credito que requieren ratios
IF(Par_NumLis = Lis_SolicitudRatios) THEN
	SELECT    sol.SolicitudCreditoID,	coalesce(Cli.NombreCompleto,ros.NombreCompleto),	 sol.Estatus,        format(sol.MontoAutorizado,2),        sol.FechaRegistro
	FROM SOLICITUDCREDITO sol
			LEFT JOIN CLIENTES Cli ON sol.ClienteID = Cli.ClienteID
			LEFT JOIN PROSPECTOS ros ON sol.ProspectoID = ros.ProspectoID
			INNER JOIN PRODUCTOSCREDITO pro ON pro.ProducCreditoID = sol.ProductoCreditoID
	WHERE pro.CalculoRatios = Constante_SI
		AND (Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%") OR ros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%"))
		AND (sol.Estatus = EstatInact OR
			sol.Estatus =EstatDesembol OR
			sol.Estatus	= EstatLiberada OR
			sol.Estatus	= EstatusAutor OR
			sol.Estatus	= EstatusCancelada)
		ORDER BY  sol.Estatus =EstatDesembol, sol.Estatus = EstatusCancelada, sol.Estatus = EstatusAutor,sol.Estatus	= EstatLiberada, sol.Estatus = EstatInact
	LIMIT 0, 15;
END IF;



# 12.-  Lista solicitudes de credito renovacion
IF(Par_NumLis = Lis_SolicitudRenova) THEN
	SELECT    Sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	Sol.Estatus,        Sol.MontoAutorizado,        Sol.FechaRegistro
	FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	WHERE Sol.TipoCredito = CreRenovacion
	AND Sol.EsAgropecuario = Con_Str_NO
		AND Cli.NombreCompleto LIKE CONCAT('%',Par_ClienteID,'%')
	ORDER BY Sol.FechaActual DESC
	LIMIT 0, 50;
END IF;

# 13.-  Lista solicitudes de credito reestructura
IF(Par_NumLis = Lis_SolicitudReest) THEN
	SELECT    Sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	Sol.Estatus,        Sol.MontoAutorizado,        Sol.FechaRegistro
	FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	WHERE Sol.TipoCredito = CreReestructura
		AND Cli.NombreCompleto LIKE CONCAT('%',Par_ClienteID,'%')
	ORDER BY Sol.FechaActual DESC
	LIMIT 0, 50;
END IF;

# 14.-  Lista principal de solicitudes de credito
IF(Par_NumLis = Lis_Agropecuarios) THEN
	(SELECT
		sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	sol.Estatus,		sol.MontoAutorizado,		sol.FechaRegistro
		FROM SOLICITUDCREDITO sol, CLIENTES Cli
			WHERE sol.ClienteID = Cli.ClienteID
				AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
				AND sol.EsAgropecuario = 'S'
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50)
		UNION
			(SELECT    sol.SolicitudCreditoID, 	Pros.NombreCompleto,	sol.Estatus,        sol.MontoAutorizado,        sol.FechaRegistro
			FROM SOLICITUDCREDITO sol, PROSPECTOS Pros
			WHERE sol.ProspectoID = Pros.ProspectoID
				AND IFNULL(Pros.ClienteID, Entero_Cero) <= Entero_Cero
				AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
				AND sol.EsAgropecuario = 'S'
			ORDER BY sol.FechaActual DESC
			LIMIT 0, 50);
END IF;

# 15.- Lista de solicitudes de credito inactivas que presentan riesgo comun
IF(Par_NumLis = Lis_SolRiesgoComun) THEN
		(SELECT DISTINCT   Sol.SolicitudCreditoID,	Cli.NombreCompleto AS NombreCompletoCli, Cadena_Vacia AS NombreCompletoPros,	Sol.ClienteID, Sol.ProspectoID,Sol.Estatus,        FORMAT(Sol.MontoAutorizado,2) AS MontoAutorizado,        Sol.FechaRegistro
			FROM SOLICITUDCREDITO Sol,
				 CLIENTES Cli,
				 RIESGOCOMUNCLICRE Rie
			WHERE Sol.ClienteID = Cli.ClienteID
			AND Sol.ClienteID = Rie.ClienteIDSolicitud
			AND Sol.SolicitudCreditoID = Rie.SolicitudCreditoID
			AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND Sol.Estatus IN(EstatInact,EstatLiberada)
			AND Rie.Procesado = Con_Str_NO
		LIMIT 0, 15)
		UNION
		(SELECT    Sol.SolicitudCreditoID,	Cadena_Vacia AS NombreCompletoCli,	Pros.NombreCompleto AS NombreCompletoPros, Sol.ClienteID, Sol.ProspectoID,	 Sol.Estatus,        FORMAT(Sol.MontoAutorizado,2) AS MontoAutorizado,        Sol.FechaRegistro
			FROM SOLICITUDCREDITO Sol,
				 PROSPECTOS Pros,
				 RIESGOCOMUNCLICRE Rie
			WHERE Sol.ProspectoID = Pros.ProspectoID
			AND Sol.ProspectoID = Rie.ProspectoID
			AND Sol.SolicitudCreditoID = Rie.SolicitudCreditoID
			AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
			AND Sol.Estatus IN(EstatInact,EstatLiberada)
			AND Rie.Procesado = Con_Str_NO)
		LIMIT 0, 15;

END IF;

# 16.-  Lista solicitudes de credito renovacion
IF(Par_NumLis = Lis_Reacredita ) THEN
	SELECT    Sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	Sol.Estatus,        Sol.MontoAutorizado,        Sol.FechaRegistro
	FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	WHERE Sol.TipoCredito = CreRenovacion
		AND Sol.Reacreditado = Constante_SI
		AND Cli.NombreCompleto LIKE CONCAT('%',Par_ClienteID,'%')
	ORDER BY Sol.FechaActual DESC
	LIMIT 0, 50;
END IF;

# 17.- Lista solicitudes y Solicitudes Agro para Guarda Valores
IF(Par_NumLis = Lis_GuardaValores)THEN
	(SELECT sol.SolicitudCreditoID,	Cli.NombreCompleto,
			CASE WHEN EsAgropecuario = Con_Str_SI THEN 'SOLICITUD CREDITO'
				 WHEN EsAgropecuario = Con_Str_NO THEN 'SOLICITUD CREDITO AGRO'
			END AS TipoSolicitud,
			sol.MontoAutorizado,    sol.FechaRegistro
	FROM SOLICITUDCREDITO sol
	INNER JOIN CLIENTES Cli ON Cli.ClienteID = sol.ClienteID
	WHERE sol.ClienteID = Cli.ClienteID
		AND Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
	ORDER BY sol.FechaActual DESC
	LIMIT 0, 50)
	UNION
	(SELECT sol.SolicitudCreditoID, 	Pros.NombreCompleto,
			CASE WHEN EsAgropecuario = Con_Str_SI THEN 'SOLICITUD CREDITO'
				 WHEN EsAgropecuario = Con_Str_NO THEN 'SOLICITUD CREDITO AGRO'
			END AS TipoSolicitud,
            sol.MontoAutorizado,        sol.FechaRegistro
	FROM SOLICITUDCREDITO sol
	INNER JOIN PROSPECTOS Pros ON sol.ProspectoID = Pros.ProspectoID
	WHERE IFNULL(Pros.ClienteID, Entero_Cero) <= Entero_Cero
		AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
	ORDER BY sol.FechaActual DESC
	LIMIT 0, 50);
END IF;

# 18.-  Lista solicitudes de credito renovacion
IF(Par_NumLis = Lis_SolicitudRenovaAgro) THEN
	SELECT    Sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	Sol.Estatus,        Sol.MontoAutorizado,        Sol.FechaRegistro
	FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
	WHERE Sol.TipoCredito = CreRenovacion
    	AND Sol.EsAgropecuario = Con_Str_SI
		AND Cli.NombreCompleto LIKE CONCAT('%',Par_ClienteID,'%')
	ORDER BY Sol.FechaActual DESC
	LIMIT 0, 50;
END IF;

	-- 19.-Numero de Listado de las Solicitudes de Creditos de Nomina y que el convenio que se encuentra LIgado maneja Capacidad de Pago
	IF(Par_NumLis = Lis_SolCredInstConv) THEN

		SELECT SucursalMatrizID
			INTO Var_SucursalMatrizID
			FROM PARAMETROSSIS
			LIMIT 1;

		SELECT	SOL.SolicitudCreditoID,		CLI.NombreCompleto,			SOL.Estatus,		SOL.MontoAutorizado,		SOL.FechaRegistro
			FROM SOLICITUDCREDITO SOL
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOL.ClienteID
			INNER JOIN CONVENIOSNOMINA CONV ON CONV.ConvenioNominaID = SOL.ConvenioNominaID
			WHERE CONV.ManejaCapPago = Con_Str_SI
				AND SOL.Estatus <> EstatusCancelada
				AND CLI.NombreCompleto LIKE CONCAT('%',Par_ClienteID,'%')
				AND SOL.SucursalID = IF (Aud_Sucursal <> Var_SucursalMatrizID, Aud_Sucursal, SOL.SucursalID)
			ORDER BY SOL.SolicitudCreditoID DESC;
	END IF;

	-- 20.-Numero de Listado de las Solicitudes de Creditos disntintas de liberadas y caceladas.
	IF(Par_NumLis = Lis_SolCredNOLibCan) THEN

		SELECT Sol.SolicitudCreditoID,	Cli.NombreCompleto,	 	Sol.Estatus,        Sol.MontoSolici,	Sol.FechaRegistro
			FROM SOLICITUDCREDITO Sol
				 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
			WHERE Sol.Estatus NOT IN(EstatusCancelada, EstatDesembol)
				AND Cli.NombreCompleto LIKE CONCAT('%',Par_ClienteID,'%')
			LIMIT 0, 15;

	END IF;

	-- Número de Lista 21.- Solicitudes de Credito Consolidadas Agro
	IF(Par_NumLis = Lis_SolConsolidadaAgro) THEN
		(SELECT Sol.SolicitudCreditoID,	Cli.NombreCompleto,		Sol.Estatus,	Sol.MontoAutorizado,	Sol.FechaRegistro
		 FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
		 WHERE Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
		   AND Sol.EsConsolidacionAgro = Constante_SI
		 LIMIT 0, 15)
		UNION
		(SELECT Sol.SolicitudCreditoID,	Pros.NombreCompleto,	Sol.Estatus,	Sol.MontoAutorizado,	Sol.FechaRegistro
		 FROM SOLICITUDCREDITO Sol
		 INNER JOIN PROSPECTOS Pros ON Sol.ProspectoID = Pros.ProspectoID
		 WHERE IFNULL(Pros.ClienteID, Entero_Cero) <= Entero_Cero
		   AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
		   AND Sol.EsConsolidacionAgro = Constante_SI
		 LIMIT 0, 15);
	END IF;

	-- Número de Lista 22.- Solicitudes de Credito Consolidadas
	IF(Par_NumLis = Lis_SolConsolidada) THEN
		(SELECT Sol.SolicitudCreditoID,	Cli.NombreCompleto,		Sol.Estatus,	Sol.MontoAutorizado,	Sol.FechaRegistro
		 FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
		 WHERE Cli.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
		   AND Sol.FlujoOrigen = Con_FlujoConsolida
		 LIMIT 0, 15)
		UNION
		(SELECT Sol.SolicitudCreditoID,	Pros.NombreCompleto,	Sol.Estatus,	Sol.MontoAutorizado,	Sol.FechaRegistro
		 FROM SOLICITUDCREDITO Sol
		 INNER JOIN PROSPECTOS Pros ON Sol.ProspectoID = Pros.ProspectoID
		 WHERE IFNULL(Pros.ClienteID, Entero_Cero) <= Entero_Cero
		   AND Pros.NombreCompleto LIKE CONCAT("%",Par_ClienteID,"%")
		   AND Sol.FlujoOrigen = Con_FlujoConsolida
		 LIMIT 0, 15);
	END IF;

END TerminaStore$$