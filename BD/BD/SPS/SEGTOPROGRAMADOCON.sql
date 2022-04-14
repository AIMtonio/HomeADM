-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOPROGRAMADOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOPROGRAMADOCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOPROGRAMADOCON`(
# ==========================================================
# ------ SP PARA CONSULTAR LOS SEGMENTOS PROGRAMADOS -------
# ==========================================================
    Par_SegtoPrograID       INT(11),
    Par_CreditoID           BIGINT(12),
    Par_GrupoID             INT(11),
	Par_GestorID			INT(11),
    Par_TipConsulta         TINYINT UNSIGNED,

    Par_EmpresaID   		INT(11),
    Aud_Usuario     		INT(11),
    Aud_FechaActual 		DATETIME,
    Aud_DireccionIP 		VARCHAR(15),
    Aud_ProgramaID  		VARCHAR(50),
    Aud_Sucursal    		INT(11),
    Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_FecReg      DATETIME;

	/* Declaracion de Constantes */
	DECLARE diasFaltaPago   		INT(11);
	DECLARE Entero_Cero     		INT(11);
    DECLARE Cadena_Vacia			VARCHAR(1);
	DECLARE Decimal_Cero    		INT(11);
	DECLARE Est_Activo      		CHAR(1);
	DECLARE Estatus_Vigente			CHAR(1);
	DECLARE Con_Principal			TINYINT UNSIGNED;
	DECLARE Con_Foranea				TINYINT UNSIGNED;
	DECLARE Con_CreditoID			TINYINT UNSIGNED;
	DECLARE Con_GrupoID     		TINYINT UNSIGNED;
	DECLARE Con_Avales				TINYINT UNSIGNED;
	DECLARE Con_Supervisor			TINYINT UNSIGNED;
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE	Var_EstatusCre			CHAR(1);
	DECLARE	Var_Asignada			CHAR(1);

	/* variables */
	DECLARE Var_FechaVencim			DATE;
	DECLARE Var_FecActual			DATE;
	DECLARE EstatusPagado			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Int_Presiden			INT(11);
	DECLARE Var_SolPres				INT(11);
	DECLARE Var_ProdCredPres		INT(11);
	DECLARE Var_DescripPres			VARCHAR(45);
	DECLARE Var_FechaSolPres		DATE;
	DECLARE Var_FechaDesPres		DATE;
	DECLARE Var_EstatusCrePres		CHAR(1);
	DECLARE Var_CredPres			BIGINT(12);
	DECLARE Var_MontoSolGrup        INT(11);
	DECLARE Var_MontoAutGrup        INT(11);
	DECLARE Var_SalCapVigGrup       INT(11);
	DECLARE Var_SalCapAtrGrup       INT(11);
	DECLARE Var_SalCapVenGrup       INT(11);
	DECLARE Var_NombrePresidente	VARCHAR(100);
	DECLARE Var_ClientePres			INT(11);
    DECLARE Var_Telefono			VARCHAR(20);
	DECLARE Var_ExtensionTel		VARCHAR(7);
    DECLARE Var_TelCel				VARCHAR(20);

	/* Asignacion de Constantes */
	SET EstatusPagado   			:= 'P';     		-- Estatus Pagado
	SET Fecha_Vacia     			:= '1900-01-01';    -- Fecha Vacia
	SET Est_Activo      			:= 'A';             -- Estatus del Integrante: Activo
	SET Int_Presiden   				:= 1;
	SET diasFaltaPago   			:= 0;
	SET Entero_Cero     			:= 0;
    SET Cadena_Vacia				:= '';
	SET Decimal_Cero    			:= 0.00;
	SET Con_Principal   			:= 1;		-- Consulta Principal del registro manual de seguimiento
	SET Con_Foranea	    			:= 2;		-- Consulta por foranea del registro manual de seguimiento
	SET Con_CreditoID   			:= 3;		-- Consulta datos generales del credito por el numero de Credito
	SET Con_GrupoID     			:= 4;		-- Consulta datos generales del credito por el GRUPO
	SET Con_Avales      			:= 5;		-- Consulta de avales
	SET Con_Supervisor				:= 6;		-- Consulta para obtener el supervisor de un seguimiento
	SET Estatus_Vigente				:='V';
	SET Var_Asignada				:='A';
	SET Var_FecReg					:= NOW();
	SET Par_GestorID 				:= IFNULL(Var_FechaSolPres,Entero_Cero);

	IF(Par_TipConsulta = Con_Principal)THEN
		SELECT
			SegtoPrograID, 		CreditoID,		GrupoID,				FechaProgramada,
			HoraProgramada,		CategoriaID,	PuestoResponsableID,	PuestoSupervisorID,
			TipoGeneracion,		SecSegtoForzado,FechaRegistro,  		Estatus,
			EsForzado
		FROM SEGTOPROGRAMADO
		WHERE SegtoPrograID = Par_SegtoPrograID ;
	END IF;

	IF(Par_TipConsulta = Con_CreditoID)THEN
		SELECT
			FechaSistema INTO Var_FecActual
		FROM PARAMETROSSIS;

		SELECT
			MIN(FechaExigible) INTO Var_FechaVencim
		FROM AMORTICREDITO
		WHERE CreditoID     = Par_CreditoID
		  AND FechaExigible <= Var_FecActual
		  AND Estatus       != EstatusPagado;

		SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		SELECT
			Cl.NombreCompleto,	Cr.SolicitudCreditoID,	Cr.ProductoCreditoID,	Pr.Descripcion,
			CASE WHEN IFNULL(Sol.MontoSolici,Entero_Cero) = Entero_Cero THEN Cr.MontoCredito
			ELSE Sol.MontoSolici
			END,
			Cr.MontoCredito,
			CASE WHEN IFNULL(Sol.FechaRegistro,Fecha_Vacia) =Fecha_Vacia THEN Fecha_Vacia
			ELSE Sol.FechaRegistro
			END,
			CASE WHEN Cr.FechaInicio ='' THEN Fecha_Vacia
			ELSE Cr.FechaInicio
			END,Cr.Estatus,Cr.SaldoCapVigent,diasFaltaPago,
			Cr.SaldoCapAtrasad,(Cr.SaldoCapVencido + Cr.SaldCapVenNoExi) AS SaldoVencido,
			IFNULL(Cl.Telefono,Cadena_Vacia)AS Telefono, IFNULL(Cl.ExtTelefonoPart,Cadena_Vacia)AS ExtTelefonoPart,IFNULL(Cl.TelefonoCelular,Cadena_Vacia)AS TelefonoCelular
		FROM CREDITOS Cr
		LEFT JOIN SOLICITUDCREDITO AS Sol ON Sol.CreditoID = Cr.CreditoID
		INNER JOIN CLIENTES AS Cl ON Cl.ClienteID  = Cr.ClienteID
		INNER JOIN PRODUCTOSCREDITO AS Pr ON  Pr.ProducCreditoID = Cr.ProductoCreditoID
		WHERE Cr.CreditoID  = Par_CreditoID;

	END IF;

	IF(Par_TipConsulta = Con_GrupoID)THEN

		SELECT
			Ing.SolicitudCreditoID, Cr.ProductoCreditoID,	Pr.Descripcion,	Sol.FechaRegistro,
			Cr.FechaInicio,         Cr.Estatus,           	Cr.CreditoID,  	Cl.NombreCompleto,
			IFNULL(Cl.Telefono,Cadena_Vacia)AS Telefono, IFNULL(Cl.ExtTelefonoPart,Cadena_Vacia)AS ExtTelefonoPart,IFNULL(Cl.TelefonoCelular,Cadena_Vacia)AS TelefonoCelular

		INTO
			Var_SolPres, 			Var_ProdCredPres,		Var_DescripPres, Var_FechaSolPres,
			Var_FechaDesPres, 		Var_EstatusCrePres,		Var_CredPres, 	 Var_NombrePresidente,
            Var_Telefono,			Var_ExtensionTel,		Var_TelCel

			FROM 	INTEGRAGRUPOSCRE Ing,
					SOLICITUDCREDITO Sol,
					CREDITOS Cr,
					PRODUCTOSCREDITO Pr,
					CLIENTES Cl
			WHERE 	Ing.GrupoID   			= Par_GrupoID
			AND 	Ing.Cargo     			= Int_Presiden
			AND 	Ing.Estatus   			= Est_Activo
			AND 	Ing.SolicitudCreditoID	= Sol.SolicitudCreditoID
			AND 	Cl.ClienteID 			= Ing.ClienteID
			AND 	Sol.CreditoID 			= Cr.CreditoID
			AND 	Pr.ProducCreditoID 		= Cr.ProductoCreditoID;

		SELECT
			FechaSistema INTO Var_FecActual
		FROM PARAMETROSSIS;

		SELECT
			MIN(FechaExigible) INTO Var_FechaVencim
			FROM 	AMORTICREDITO
			WHERE 	CreditoID     = Var_CredPres
			AND 	FechaExigible <= Var_FecActual
			AND 	Estatus       != EstatusPagado;

		SET Var_FechaVencim := IFNULL(Var_FechaVencim, Fecha_Vacia);

		IF(Var_FechaVencim != Fecha_Vacia) THEN
			SET diasFaltaPago   := DATEDIFF(Var_FecActual, Var_FechaVencim);
		ELSE
			SET diasFaltaPago   := Entero_Cero;
		END IF;

		SET Var_FechaSolPres 	:= IFNULL(Var_FechaSolPres,Fecha_Vacia);
		SET Var_FechaDesPres	:= IFNULL(Var_FechaDesPres,Fecha_Vacia);
		SET Var_SolPres 		:= IFNULL(Var_SolPres,Entero_Cero);

		SELECT
			SUM(Cr.MontoCredito),	SUM(Cr.MontoCredito),	SUM(Cr.SaldoCapVigent),
			SUM(Cr.SaldoCapAtrasad),(SUM(Cr.SaldoCapVencido)+SUM(Cr.SaldoCapVencido))AS SaldoVencido

			INTO
				Var_MontoSolGrup,	Var_MontoAutGrup,	Var_SalCapVigGrup,
				Var_SalCapAtrGrup,	Var_SalCapVenGrup

			FROM 	INTEGRAGRUPOSCRE Ing,
					SOLICITUDCREDITO Sol,
					CREDITOS Cr,
					PRODUCTOSCREDITO Pr,
					CLIENTES Cl
			WHERE 	Ing.GrupoID   			= Par_GrupoID
			AND 	Ing.Estatus   			= Est_Activo
			AND 	Ing.SolicitudCreditoID	= Sol.SolicitudCreditoID
			AND 	Cl.ClienteID 			= Ing.ClienteID
			AND 	Sol.CreditoID 			= Cr.CreditoID
			AND 	Pr.ProducCreditoID		= Cr.ProductoCreditoID;

			SELECT ClienteID INTO Var_ClientePres
				FROM 	INTEGRAGRUPOSCRE
				WHERE 	GrupoID	= Par_GrupoID
				AND 	Cargo	= Int_Presiden;
		SELECT
			Var_SolPres, 		Var_ProdCredPres, 	Var_DescripPres, 	Var_MontoSolGrup, 	Var_MontoAutGrup,
			Var_FechaSolPres,	Var_FechaDesPres, 	Var_EstatusCrePres, Var_SalCapVigGrup, 	diasFaltaPago,
			Var_SalCapAtrGrup,	Var_SalCapVenGrup,	Var_NombrePresidente, Var_ClientePres,	Var_Telefono,
            Var_ExtensionTel,	Var_TelCel;

	END IF;

	IF(Par_TipConsulta = Con_Avales) THEN
		SELECT AP.AvalID, IFNULL(C.ClienteID,Entero_Cero) AS ClienteID, IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,
				CASE WHEN  AP.AvalID <> Entero_Cero AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
				C.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID<> Entero_Cero THEN
				P.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID <> Entero_Cero THEN
				A.NombreCompleto
			ELSE	CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ProspectoID <> Entero_Cero THEN
				A.NombreCompleto END END END END END AS Nombre
		FROM AVALESPORSOLICI AP
		LEFT OUTER JOIN AVALES A ON AP.AvalID= A.AvalID
		LEFT OUTER JOIN CLIENTES C ON AP.ClienteID= C.ClienteID
		LEFT OUTER JOIN PROSPECTOS P ON AP.ProspectoID= P.ProspectoID
		WHERE AP.SolicitudCreditoID=Par_CreditoID;
	END IF;

	IF (Par_TipConsulta = Con_Supervisor) THEN
		SELECT PuestoSupervisorID
			FROM SEGTOPROGRAMADO
			WHERE SegtoPrograID = Par_SegtoPrograID AND PuestoSupervisorID = Par_GestorID;
	END IF;

END TerminaStore$$