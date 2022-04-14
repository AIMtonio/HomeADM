-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDCREDITOCON;

DELIMITER $$
CREATE PROCEDURE  SOLICITUDCREDITOCON (
	# =====================================================================================
	# ------- STORE PARA CONSULTAR LAS SOLICITUDES DE CREDITOS---------
	# =====================================================================================
	Par_SoliCredID      BIGINT(20),			-- Parametro Identificador de la Solicitud de Credito
	Par_NumCon          TINYINT UNSIGNED,	-- Numero de Consulta
	/* Parametros de Auditoria */
	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,

	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)

TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_AtiendeSucursales	CHAR(1);
	DECLARE Var_SucursalUsuario		INT(11);
	DECLARE Var_ClienteID			BIGINT(20);
	DECLARE	Var_ProspectoID			BIGINT(20);
	DECLARE	Var_ProductoCreditoID	INT;
	DECLARE	Var_GrupoID				INT;
	DECLARE	Var_CicloCliente		INT;
	DECLARE Var_CicloPondGrupo		INT;
	DECLARE Var_TasaPasiva			DECIMAL(14,4);
	DECLARE Var_NumTrSim            BIGINT(20);
	DECLARE Var_FechaSistema        DATE;
	DECLARE Var_DiasReqPrimerAmor	INT(11);
	DECLARE Var_FecFinPrimerAmor	DATE;
	DECLARE Var_NumDiasVenPrimAmor  INT(11);
	DECLARE Var_ProductoCreID       INT(11);
	DECLARE Var_ValorReqPrimerAmor	CHAR(1);
    DECLARE Var_EditaSucursal		CHAR(1);
	DECLARE Var_CantCreditos		INT(11);
	DECLARE Var_NombreGrupo			VARCHAR(200);
	DECLARE Var_GrpFechaRegistro	DATETIME;

	/* Declaracion de Constantes */
	DECLARE Con_FechaVacia          DATE;
	DECLARE Decimal_Cero            DECIMAL(12,2);
	DECLARE Entero_Cero             INT;
	DECLARE Con_StrVacio            CHAR(1);
	DECLARE Con_Principal           INT;
	DECLARE Con_Foranea             INT;
	DECLARE Con_SolicitudAs         INT;
	DECLARE Con_SolActiva           INT;
	DECLARE Con_SolSucur            INT;
	DECLARE Con_SolOblSucur         INT;
	DECLARE Con_SolGrupal           INT;
	DECLARE Con_Status              INT;
	DECLARE Con_TasStatus           INT;
	DECLARE Con_Agropecuario		INT;
	DECLARE Con_General				INT(11);
    DECLARE Con_AgropecuarioRes		INT(11);
    DECLARE Con_RenovacionesAgro	INT(11);
	DECLARE Con_SolCredInstConv		INT(11);			-- Consulta de Solicitudes de Creditos de Nomina y que el convenio que se encuentra Ligado maneja Capacidad de Pago
	DECLARE Lis_SolCredNOLibCan		INT(11);				-- Número de listado de las Solicitudes de Crédito NO liberadas o Conceladas.


	DECLARE GrupalSI                CHAR(1);
	DECLARE EsAutorizada            CHAR(1);
	DECLARE EsInactiva              CHAR(1);

	DECLARE EsSolCredito            CHAR(1);
	DECLARE CicloCliente			VARCHAR(15);
	DECLARE	CicloPondGrupo			VARCHAR(15);
	DECLARE Salida_Si				CHAR(1);
	DECLARE Salida_No				CHAR(1);
    DECLARE Es_Reestructura			CHAR(1);
    DECLARE Est_Vigente				CHAR(1);
    DECLARE Est_Vencido				CHAR(1);
    DECLARE Est_Castigado			CHAR(1);
    DECLARE Est_Pagado				CHAR(1);
	DECLARE Con_DiasPrimerAmor      INT(11);
	DECLARE DescValidaReqPrimerAmor	VARCHAR(50);
	DECLARE ConstanteNO				CHAR(1);
	DECLARE Cons_EsRenovacion 		CHAR(1);
	DECLARE Cons_SI 				CHAR(1);
	DECLARE	EstatDesembol			CHAR(1);
	DECLARE EstatusCancelada		CHAR(1);
    DECLARE Con_LlaveEditSuc		VARCHAR(100);

	-- Asigancion de Constantes
	SET Con_FechaVacia          	:= '1900-01-01';            -- Fecha Vacia
	SET Decimal_Cero            	:= 0.0;                     -- DECIMAL en Cero
	SET Entero_Cero             	:= 0;                       -- Entero en Cero
	SET Con_StrVacio            	:= '';                      -- String o Cadena Vacia

	SET Con_Principal           	:= 1;                       -- Consuta: Principal
	SET Con_Foranea             	:= 2;                       -- Consuta: Foranea
	SET Con_SolicitudAs         	:= 3;                       -- Consuta: Avales Asignados
	SET Con_SolActiva           	:= 4;                       -- Consulta: Por Solicitud y Sucursal.
	SET Con_SolSucur            	:= 5;                       -- Consulta: Avales Asignados por Sucursal
	SET Con_SolGrupal           	:= 6;
	SET Con_Status              	:= 7;                       -- Consulta: Solicitud en estatus L
	SET Con_TasStatus           	:= 8;                       -- Consulta: Solicitud en estatus L para cambio de Tazas
	SET Con_Agropecuario        	:= 9;                       -- Consulta: Solicitudes que sean de tipo Agropecuario
	SET Con_General			    	:= 10;						-- Numero de consulta general, no distingue de sol. agro y no agro
    SET Con_AgropecuarioRes	    	:= 11;
    SET Con_SolOblSucur         	:= 12;                      -- Consulta: Obligados Solidarios Asignados por Sucursal
	SET Con_DiasPrimerAmor	    	:= 14;						-- Consulta: Dias Primer Amortizacion para Tipo Pago Capital: LIBRES
	SET Con_RenovacionesAgro    	:= 15;						-- Consulta: 15 Consulta de Solicitudes de Renovacion de Creditos Agro
	SET Con_SolCredInstConv			:= 16;						-- Consulta de Solicitudes de Creditos de Nomina y que el convenio que se encuentra Ligado maneja Capacidad de Pago
	SET Lis_SolCredNOLibCan			:= 17;						-- Número de listado de las Solicitudes de Crédito NO liberadas o Conceladas.

	SET GrupalSI                	:= 'S';                     -- La Solicitud si es Grupal
	SET EsAutorizada            	:= 'A';                     -- Estatus de la Solicitud: Autorizada
	SET EsInactiva              	:= 'I';                     -- Estatus de la Solicitud: Inactiva
	SET EsSolCredito            	:= 'L';                     -- Estatus de la Solicitud de Credito Liberada
	SET Salida_Si			    	:= 'S';						-- salida si
	SET Salida_No			    	:= 'N';						-- salida no
    SET Es_Reestructura		    	:= 'R';						-- Es Reestructura
    SET Est_Vigente			    	:= 'V';						-- Estatus Vigente
    SET Est_Vencido			    	:= 'B';						-- Estatus Vencido
    SET Est_Castigado		    	:= 'K';						-- Estatus Castigado
    SET Est_Pagado			    	:= 'P';						-- Estatus Pagado
    SET DescValidaReqPrimerAmor	    := 'ValidaReqPrimerAmor';	-- Descripcion de LLave del Parametro
	SET ConstanteNO			    	:= 'N';						-- Constante: NO
	SET Cons_EsRenovacion			:= 'O';						-- Es Renovacion
	SET Cons_SI 					:= 'S';						-- Constante SI
	SET EstatDesembol				:= 'D';
	SET EstatusCancelada			:= 'C';
    SET Con_LlaveEditSuc			:= 'EdicionBusquedaSucursal';	-- Llave para la consulta de Edita sucursal del cliente


	SET Var_TasaPasiva := (SELECT TasaPasiva
								FROM CREDTASAPASIVAAGRO
							WHERE SolicitudCreditoID = Par_SoliCredID ORDER BY FechaActual DESC LIMIT 1);
	SET Var_TasaPasiva := IFNULL(Var_TasaPasiva, Entero_Cero);
	SELECT	ValorParametro INTO Var_EditaSucursal
			FROM PARAMGENERALES
			WHERE	LlaveParametro	= Con_LlaveEditSuc;

	SET Var_EditaSucursal := IFNULL(Var_EditaSucursal, ConstanteNO);
	/* 1- Consulta Principal de Solicitudes
		  se usa en Alta de Solicitud, Asigna Garantias y Checklist de Solicitudes
	  */
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	Pue.AtiendeSuc,			Usu.SucursalUSuario
		INTO	Var_AtiendeSucursales,  Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID	= Usu.ClavePuestoID
			WHERE	Usu.UsuarioID	= Aud_Usuario;

        IF(Var_EditaSucursal = "S")THEN
			SELECT PRO.SucursalID INTO Var_SucursalUsuario
				FROM SOLICITUDCREDITO SOL
				INNER JOIN PROMOTORES PRO ON SOL.PromotorID = PRO.PromotorID
				WHERE SOL.SolicitudCreditoID=Par_SoliCredID;

            SET Var_SucursalUsuario := IFNULL(Var_SucursalUsuario, Entero_Cero);
        END IF;

		SELECT COUNT(Cre.CreditoID)
		INTO Var_CantCreditos
		FROM SOLICITUDCREDITO Sol
			INNER JOIN CLIENTES Cli	ON Sol.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS Cre ON Cre.ClienteID = Cli.ClienteID
				AND Cre.Estatus IN (Est_Vigente,Est_Pagado,Est_Vencido,Est_Castigado)
		WHERE	Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Salida_No;

		SELECT
			Grp.GrupoID,
			MAX(Grp.NombreGrupo),
			MAX(Grp.FechaRegistro),
			MAX(Grp.CicloActual)
		INTO Var_GrupoID, Var_NombreGrupo, Var_GrpFechaRegistro, Var_CicloPondGrupo
		FROM SOLICITUDCREDITO Sol
			INNER JOIN INTEGRAGRUPOSCRE SolGrp 	ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID
			INNER JOIN GRUPOSCREDITO Grp       	ON SolGrp.GrupoID = Grp.GrupoID
			WHERE	Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Salida_No
			GROUP BY Grp.GrupoID;

		SELECT	Sol.SolicitudCreditoID,	Sol.ClienteID,
				IFNULL(Cli.NombreCompleto, Con_StrVacio) AS CliNombreCompleto,
				Sol.MonedaID,       Sol.ProductoCreditoID,      Sol.ProspectoID,
				IFNULL(Pro.NombreCompleto, Con_StrVacio) AS ProNombreCompleto,
				Sol.FechaRegistro,      Sol.FechaAutoriza,      Sol.MontoSolici,
				Sol.MontoAutorizado,    Sol.PlazoID,            Sol.Estatus,
				Sol.TipoDispersion,     Sol.CuentaCLABE,        Sol.SucursalID,
				Sol.ForCobroComAper,    ROUND(Sol.MontoPorComAper,2) AS MontoPorComAper,    ROUND(Sol.IVAComAper,2) AS IVAComAper,
				Sol.DestinoCreID,       Sol.PromotorID,         Sol.CalcInteresID,
				Sol.TasaFija,           FORMAT(Sol.TasaBase,0) AS TasaBase,           		Sol.SobreTasa,
				Sol.PisoTasa,           Sol.TechoTasa,          Sol.FactorMora,
				Sol.FrecuenciaCap,      Sol.PeriodicidadCap,    Sol.FrecuenciaInt,
				Sol.PeriodicidadInt,    Sol.TipoPagoCapital,    Sol.NumAmortizacion,
				Sol.CalendIrregular,    Sol.DiaPagoInteres,     Sol.DiaPagoCapital,
				Sol.DiaMesInteres,      Sol.DiaMesCapital,      Sol.AjusFecUlVenAmo,
				Sol.AjusFecExiVen,      Sol.NumTransacSim,      Sol.ValorCAT,
				Sol.FechaInhabil,       Sol.AporteCliente,      Sol.UsuarioAutoriza,
				Sol.FechaRechazo,       Sol.UsuarioRechazo,     Sol.ComentarioRech,
				Sol.MotivoRechazo,      Sol.TipoCredito,        Sol.NumCreditos,
				Sol.Relacionado,        Sol.Proyecto,           Sol.TipoFondeo,
				Sol.InstitFondeoID,     Sol.LineaFondeo,        Sol.TipoCalInteres,
				Sol.CreditoID,          Sol.FechaFormalizacion, Sol.MontoFondeado,
				Sol.PorcentajeFonde,    Sol.NumeroFondeos,      Sol.NumAmortInteres,
				Sol.MontoCuota,
				IFNULL(Var_GrupoID, Entero_Cero) AS GrupoID,
				IFNULL(Var_NombreGrupo, Con_StrVacio) AS NombreGrupo,
				IFNULL(Var_GrpFechaRegistro, Con_FechaVacia) AS GrpFechaRegistro,
				IFNULL(Var_CicloPondGrupo, Entero_Cero) AS CicloActual,
				Sol.ComentarioEjecutivo,
				Sol.ComentarioMesaControl,
				Var_SucursalUsuario AS SucursalPromot,
				Var_AtiendeSucursales AS PromotAtiendeSucursal,
				Var_CantCreditos AS CantCreditos,
				Sol.FechaVencimiento,   Sol.FechaInicio, Sol.MontoSeguroVida , Sol.ForCobroSegVida,
				Sol.ClasiDestinCred, Sol.InstitucionNominaID, Sol.FolioCtrl, Sol.HorarioVeri,
				IFNULL(Sol.PorcGarLiq, Decimal_Cero) AS PorcGarLiq, PRC.TipoContratoCCID,
				Sol.FechaInicioAmor,		Sol.DiaPagoProd,		Sol.MontoSeguroCuota,	Sol.IVASeguroCuota,		Sol.CobraSeguroCuota,
				Sol.CobraIVASeguroCuota,	Sol.TipoConsultaSIC,	Sol.FolioConsultaBC,	Sol.FolioConsultaCC,	Sol.EsAgropecuario,
				Sol.CadenaProductivaID,		Sol.RamaFIRAID,			Sol.SubramaFIRAID,		Sol.ActividadFIRAID,	Sol.TipoGarantiaFIRAID,
                Sol.ProgEspecialFIRAID,		Sol.FechaCobroComision,	Sol.EsAutomatico,		Sol.TipoAutomatico,		Sol.InvCredAut,
                Sol.CtaCredAut,				Sol.AcreditadoIDFIRA,	Sol.CreditoIDFIRA,		Sol.Reacreditado,		Sol.CobraAccesorios,
				Sol.Cobertura,				Sol.Prima,				Sol.Vigencia,			Sol.ConvenioNominaID,	IFNULL(Sol.FolioSolici, Con_StrVacio) AS FolioSolici,
                Sol.QuinquenioID,			Sol.ClabeCtaDomici AS ClabeDomiciliacion,		Sol.TipoCtaSantander,	Sol.CtaSantander,				Sol.CtaClabeDisp,
                Cli.TipoPersona,			Sol.EsConsolidacionAgro,	Sol.DeudorOriginalID,		Sol.FlujoOrigen,		Sol.LineaCreditoID,
				Sol.ManejaComAdmon,			Sol.ComAdmonLinPrevLiq,		Sol.ForCobComAdmon,			Sol.ForPagComAdmon,		Sol.PorcentajeComAdmon,
				Sol.MontoPagComAdmon,		Sol.ManejaComGarantia,		Sol.ComGarLinPrevLiq,		Sol.ForCobComGarantia,
				Sol.ForPagComGarantia,		Sol.PorcentajeComGarantia,	Sol.MontoPagComGarantia
				FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli				ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro          	ON Sol.ProspectoID = Pro.ProspectoID
				INNER JOIN PRODUCTOSCREDITO PRC  	ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE	Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Salida_No;

	END IF;

	IF(Par_NumCon = Con_Foranea) THEN

		SELECT	Sol.SolicitudCreditoID,		Sol.ClienteID,	Sol.ProductoCreditoID,	Sol.ProspectoID,
				FORMAT(Sol.MontoSolici,2),	FORMAT(Sol.MontoAutorizado,2)
			FROM SOLICITUDCREDITO Sol
				INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID=Pro.ProducCreditoID
			WHERE Sol.SolicitudCreditoID    = Par_SoliCredID
			  AND (Pro.EsGrupal = GrupalSI)
			  AND (Sol.Estatus= EsAutorizada OR Sol.Estatus= EsInactiva);

	END IF;

	IF(Par_NumCon = Con_SolicitudAs) THEN

		SELECT	Sol.SolicitudCreditoID,	Sol.ClienteID,	Sol.ProductoCreditoID,	Sol.ProspectoID,	Aso.Estatus
			FROM SOLICITUDCREDITO Sol
				INNER JOIN  AVALESPORSOLICI Aso ON Sol.SolicitudCreditoID   = Aso.SolicitudCreditoID
			WHERE	Sol.SolicitudCreditoID = Par_SoliCredID
			GROUP BY	Sol.SolicitudCreditoID, Sol.ClienteID, Sol.ProductoCreditoID, Sol.ProspectoID, Aso.Estatus;

	END IF;


	IF(Par_NumCon = Con_SolActiva) THEN

		SELECT	SolicitudCreditoID,	ClienteID,	ProductoCreditoID,	ProspectoID,	Estatus
			FROM SOLICITUDCREDITO
			WHERE	SolicitudCreditoID	= Par_SoliCredID
			  AND	SucursalID			= Aud_Sucursal;

	END IF;


	IF(Par_NumCon = Con_SolSucur) THEN

		SELECT	Sol.SolicitudCreditoID,	Sol.ClienteID,	Sol.ProductoCreditoID,	Sol.ProspectoID,
				Aso.Estatus,			Sol.Estatus AS EstatusSol,				MAX(Sol.TipoCredito) AS TipoCredito
			FROM SOLICITUDCREDITO Sol
				INNER JOIN AVALESPORSOLICI Aso ON Sol.SolicitudCreditoID = Aso.SolicitudCreditoID
			WHERE	Sol.SolicitudCreditoID	= Par_SoliCredID
			  AND	Sol.SucursalID			= Aud_Sucursal
			GROUP BY Sol.SolicitudCreditoID, Sol.ClienteID, Sol.ProductoCreditoID, Sol.ProspectoID,
					 Aso.Estatus, Sol.Estatus;

	END IF;

	IF(Par_NumCon = Con_SolOblSucur) THEN

		SELECT	Sol.SolicitudCreditoID,	Sol.ClienteID,	Sol.ProductoCreditoID,	Sol.ProspectoID,
				OBL.Estatus,			Sol.Estatus AS EstatusSol
			FROM SOLICITUDCREDITO Sol
				INNER JOIN OBLSOLIDARIOSPORSOLI OBL ON Sol.SolicitudCreditoID = OBL.SolicitudCreditoID
			WHERE	Sol.SolicitudCreditoID	= Par_SoliCredID
			  AND	Sol.SucursalID			= Aud_Sucursal
			GROUP BY Sol.SolicitudCreditoID, Sol.ClienteID, Sol.ProductoCreditoID, Sol.ProspectoID,
					 OBL.Estatus, Sol.Estatus;

	END IF;

	IF(Par_NumCon = Con_Status) THEN

		SELECT	Sol.ClienteID,		Sol.SolicitudCreditoID,		Sol.ProductoCreditoID,
				PRC.Descripcion,	Sol.FechaInicio,			Sol.FechaVencimiento,
				Sol.PlazoID,		PRC.TipCobComMorato,		Sol.TasaFija,
				Sol.FactorMora

			FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli            	ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro          	ON Sol.ProspectoID = Pro.ProspectoID
				INNER JOIN PRODUCTOSCREDITO PRC		ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE	Sol.SolicitudCreditoID	= Par_SoliCredID
			  AND	Sol.Estatus 			= EsSolCredito;
	END IF;

	IF(Par_NumCon = Con_TasStatus) THEN

		SELECT	Sol.ClienteID, 	Sol.ProspectoID,	Sol.ProductoCreditoID,	Sol.GrupoID
		INTO  	Var_ClienteID,	Var_ProspectoID,	Var_ProductoCreditoID,	Var_GrupoID
			FROM SOLICITUDCREDITO Sol
			WHERE	Sol.SolicitudCreditoID	= Par_SoliCredID
			  AND	Sol.Estatus 			= EsSolCredito;

		CALL CRECALCULOCICLOPRO(
			Var_ClienteID,		Var_ProspectoID,	Var_ProductoCreditoID,		Var_GrupoID,
			CicloCliente,		CicloPondGrupo,		Salida_No,					Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Var_CicloCliente 	:=	CicloCliente;
		SET Var_CicloPondGrupo	:=	CicloPondGrupo;

		SELECT	Sol.ClienteID,			Sol.SolicitudCreditoID,			IFNULL(Cli.NombreCompleto, Con_StrVacio) AS CliNombreCompleto,
				Sol.ProductoCreditoID,  PRC.Descripcion,    			PRC.CobraMora,			PRC.TipCobComMorato,    		PRC.CalcInteres,
				Sol.FechaInicio,        Sol.FechaVencimiento,   		Sol.PlazoID,    		CP.Descripcion AS DesPlazo, 	Sol.TasaFija,
				Sol.FactorMora, 		CicloCliente AS CicloActual,	Sol.MontoPorComAper,    PRC.TipoComXapert,				Sol.SobreTasa,
				FORMAT(Sol.TasaBase,0) AS TasaBase,		Sol.PisoTasa,	Sol.TechoTasa
			FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli              ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro            ON Sol.ProspectoID = Pro.ProspectoID
				LEFT JOIN CREDITOSPLAZOS CP     	ON CP.PlazoID = Sol.PlazoID
				INNER JOIN PRODUCTOSCREDITO PRC     ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE	Sol.SolicitudCreditoID	= Par_SoliCredID
			  AND	Sol.Estatus				= EsAutorizada;

	END IF;

	/*	Consulta: 009
		Descripcion: Consulta solo las solicitudes que son de tipo Agropecuario*/
	IF(Par_NumCon = Con_Agropecuario) THEN
		SELECT	Pue.AtiendeSuc,			Usu.SucursalUSuario
		INTO	Var_AtiendeSucursales,	Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID	= Usu.ClavePuestoID
				WHERE	Usu.UsuarioID	= Aud_Usuario;
		SET Var_TasaPasiva := (SELECT TasaPasiva
									FROM CREDTASAPASIVAAGRO
								WHERE SolicitudCreditoID = Par_SoliCredID ORDER BY FechaActual DESC LIMIT 1);
		SET Var_TasaPasiva := IFNULL(Var_TasaPasiva, Entero_Cero);

		SELECT COUNT(Cre.CreditoID)
		INTO Var_CantCreditos
		FROM SOLICITUDCREDITO Sol
			INNER JOIN CLIENTES Cli	ON Sol.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS Cre ON Cre.ClienteID = Cli.ClienteID
				AND Cre.Estatus IN (Est_Vigente,Est_Pagado,Est_Vencido,Est_Castigado)
		WHERE Sol.SolicitudCreditoID = Par_SoliCredID
			AND Sol.EsAgropecuario = Cons_SI;

		SELECT
			Grp.GrupoID,
			MAX(Grp.NombreGrupo),
			MAX(Grp.FechaRegistro),
			MAX(Grp.CicloActual)
		INTO Var_GrupoID, Var_NombreGrupo, Var_GrpFechaRegistro, Var_CicloPondGrupo
		FROM SOLICITUDCREDITO Sol
			INNER JOIN INTEGRAGRUPOSCRE SolGrp 	ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID
			INNER JOIN GRUPOSCREDITO Grp       	ON SolGrp.GrupoID = Grp.GrupoID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
			GROUP BY Grp.GrupoID;

		SELECT
			Sol.SolicitudCreditoID,											Sol.ClienteID,											IFNULL(Cli.NombreCompleto, Con_StrVacio) AS CliNombreCompleto,
			Sol.MonedaID,													Sol.ProductoCreditoID,									Sol.ProspectoID,
			IFNULL(Pro.NombreCompleto, Con_StrVacio) AS ProNombreCompleto,	Sol.FechaRegistro,										Sol.FechaAutoriza,
			Sol.MontoSolici,												Sol.MontoAutorizado,									Sol.PlazoID,
			Sol.Estatus,													Sol.TipoDispersion,										Sol.CuentaCLABE,
			Sol.SucursalID,													Sol.ForCobroComAper,									ROUND(Sol.MontoPorComAper,2) AS MontoPorComAper,
			ROUND(Sol.IVAComAper,2) AS IVAComAper,							Sol.DestinoCreID,										Sol.PromotorID,
			Sol.CalcInteresID,												Sol.TasaFija,											FORMAT(Sol.TasaBase,0) AS TasaBase,
			Sol.SobreTasa,Sol.PisoTasa,										Sol.TechoTasa,											Sol.FactorMora,
			Sol.FrecuenciaCap,												Sol.PeriodicidadCap,									Sol.FrecuenciaInt,
			Sol.PeriodicidadInt,											Sol.TipoPagoCapital,									Sol.NumAmortizacion,
			Sol.CalendIrregular,											Sol.DiaPagoInteres,										Sol.DiaPagoCapital,
			Sol.DiaMesInteres,												Sol.DiaMesCapital,										Sol.AjusFecUlVenAmo,
			Sol.AjusFecExiVen,												Sol.NumTransacSim,										Sol.ValorCAT,
			Sol.FechaInhabil,												Sol.AporteCliente,										Sol.UsuarioAutoriza,
			Sol.FechaRechazo,												Sol.UsuarioRechazo,										Sol.ComentarioRech,
			Sol.MotivoRechazo,												Sol.TipoCredito,										Sol.NumCreditos,
			Sol.Relacionado,												Sol.Proyecto,											Sol.TipoFondeo,
			Sol.InstitFondeoID,												Sol.LineaFondeo,										Sol.TipoCalInteres,
			Sol.CreditoID,													Sol.FechaFormalizacion,									Sol.MontoFondeado,
			Sol.PorcentajeFonde,											Sol.NumeroFondeos,										Sol.NumAmortInteres,
			Sol.MontoCuota,													IFNULL(Var_GrupoID, Entero_Cero) AS GrupoID,		IFNULL(Var_NombreGrupo, Con_StrVacio) AS NombreGrupo,
			IFNULL(Var_GrpFechaRegistro, Con_FechaVacia) AS GrpFechaRegistro,	IFNULL(Var_CicloPondGrupo,Entero_Cero) AS CicloActual,		Sol.ComentarioEjecutivo,
			Sol.ComentarioMesaControl,										Var_SucursalUsuario AS SucursalPromot,					Var_AtiendeSucursales AS PromotAtiendeSucursal,
			Var_CantCreditos AS CantCreditos,							Sol.FechaVencimiento,									Sol.FechaInicio,
			Sol.MontoSeguroVida ,											Sol.ForCobroSegVida,									Sol.ClasiDestinCred,
			Sol.InstitucionNominaID,										Sol.FolioCtrl,											Sol.HorarioVeri,
			IFNULL(Sol.PorcGarLiq, Decimal_Cero) AS PorcGarLiq,				PRC.TipoContratoCCID,									Sol.FechaInicioAmor,
			Sol.DiaPagoProd,												Sol.MontoSeguroCuota,									Sol.IVASeguroCuota,
			Sol.CobraSeguroCuota,											Sol.CobraIVASeguroCuota,								Sol.TipoConsultaSIC,
			Sol.FolioConsultaBC,											Sol.FolioConsultaCC,									Sol.EsAgropecuario,
			Sol.CadenaProductivaID,											Sol.RamaFIRAID,											Sol.SubramaFIRAID,
			Sol.ActividadFIRAID,											Sol.TipoGarantiaFIRAID,									Sol.ProgEspecialFIRAID,
			Sol.FechaCobroComision,											Var_TasaPasiva AS TasaPasiva,							Sol.EsAutomatico,
			Sol.TipoAutomatico,												Sol.InvCredAut,											Sol.CtaCredAut,
			Sol.AcreditadoIDFIRA,											Sol.CreditoIDFIRA,										Sol.Reacreditado,
            Sol.CobraAccesorios,											PRC.ReqConsultaSIC,										Sol.EsConsolidacionAgro,
			Sol.DeudorOriginalID,		Sol.LineaCreditoID,
			Sol.ManejaComAdmon,			Sol.ComAdmonLinPrevLiq,		Sol.ForCobComAdmon,			Sol.ForPagComAdmon,		Sol.PorcentajeComAdmon,
			Sol.MontoPagComAdmon,		Sol.ManejaComGarantia,		Sol.ComGarLinPrevLiq,		Sol.ForCobComGarantia,
			Sol.ForPagComGarantia,		Sol.PorcentajeComGarantia,	Sol.MontoPagComGarantia
			FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli				ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro          	ON Sol.ProspectoID = Pro.ProspectoID
				INNER JOIN PRODUCTOSCREDITO PRC  	ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE
				Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI;
	END IF;

	IF(Par_NumCon = Con_General) THEN
		SELECT	Pue.AtiendeSuc,			Usu.SucursalUSuario
		INTO	Var_AtiendeSucursales,  Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID	= Usu.ClavePuestoID
			WHERE	Usu.UsuarioID	= Aud_Usuario;

		SELECT COUNT(Cre.CreditoID)
		INTO Var_CantCreditos
		FROM SOLICITUDCREDITO Sol
			INNER JOIN CLIENTES Cli	ON Sol.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS Cre ON Cre.ClienteID = Cli.ClienteID
				AND Cre.Estatus IN (Est_Vigente,Est_Pagado,Est_Vencido,Est_Castigado)
				WHERE	Sol.SolicitudCreditoID = Par_SoliCredID;

		SELECT
			Grp.GrupoID,
			MAX(Grp.NombreGrupo),
			MAX(Grp.FechaRegistro),
			MAX(Grp.CicloActual)
		INTO Var_GrupoID, Var_NombreGrupo, Var_GrpFechaRegistro, Var_CicloPondGrupo
		FROM SOLICITUDCREDITO Sol
			INNER JOIN INTEGRAGRUPOSCRE SolGrp 	ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID
			INNER JOIN GRUPOSCREDITO Grp       	ON SolGrp.GrupoID = Grp.GrupoID
			WHERE	Sol.SolicitudCreditoID = Par_SoliCredID
			GROUP BY Grp.GrupoID;

		SELECT	Sol.SolicitudCreditoID,	Sol.ClienteID,
				IFNULL(Cli.NombreCompleto, Con_StrVacio) AS CliNombreCompleto,
				Sol.MonedaID,       Sol.ProductoCreditoID,      Sol.ProspectoID,
				IFNULL(Pro.NombreCompleto, Con_StrVacio) AS ProNombreCompleto,
				Sol.FechaRegistro,      Sol.FechaAutoriza,      Sol.MontoSolici,
				Sol.MontoAutorizado,    Sol.PlazoID,            Sol.Estatus,
				Sol.TipoDispersion,     Sol.CuentaCLABE,        Sol.SucursalID,
				Sol.ForCobroComAper,    ROUND(Sol.MontoPorComAper,2) AS MontoPorComAper,    ROUND(Sol.IVAComAper,2) AS IVAComAper,
				Sol.DestinoCreID,       Sol.PromotorID,         Sol.CalcInteresID,
				Sol.TasaFija,           FORMAT(Sol.TasaBase,0) AS TasaBase,           		Sol.SobreTasa,
				Sol.PisoTasa,           Sol.TechoTasa,          Sol.FactorMora,
				Sol.FrecuenciaCap,      Sol.PeriodicidadCap,    Sol.FrecuenciaInt,
				Sol.PeriodicidadInt,    Sol.TipoPagoCapital,    Sol.NumAmortizacion,
				Sol.CalendIrregular,    Sol.DiaPagoInteres,     Sol.DiaPagoCapital,
				Sol.DiaMesInteres,      Sol.DiaMesCapital,      Sol.AjusFecUlVenAmo,
				Sol.AjusFecExiVen,      Sol.NumTransacSim,      Sol.ValorCAT,
				Sol.FechaInhabil,       Sol.AporteCliente,      Sol.UsuarioAutoriza,
				Sol.FechaRechazo,       Sol.UsuarioRechazo,     Sol.ComentarioRech,
				Sol.MotivoRechazo,      Sol.TipoCredito,        Sol.NumCreditos,
				Sol.Relacionado,        Sol.Proyecto,           Sol.TipoFondeo,
				Sol.InstitFondeoID,     Sol.LineaFondeo,        Sol.TipoCalInteres,
				Sol.CreditoID,          Sol.FechaFormalizacion, Sol.MontoFondeado,
				Sol.PorcentajeFonde,    Sol.NumeroFondeos,      Sol.NumAmortInteres,
				Sol.MontoCuota,
				IFNULL(Var_GrupoID, Entero_Cero) AS GrupoID,
				IFNULL(Var_NombreGrupo, Con_StrVacio) AS NombreGrupo,
				IFNULL(Var_GrpFechaRegistro, Con_FechaVacia) AS GrpFechaRegistro,
				IFNULL(Var_CicloPondGrupo, Entero_Cero) AS CicloActual,
				Sol.ComentarioEjecutivo,
				Sol.ComentarioMesaControl,
				Var_SucursalUsuario AS SucursalPromot,
				Var_AtiendeSucursales AS PromotAtiendeSucursal,
				Var_CantCreditos AS CantCreditos,
				Sol.FechaVencimiento,   Sol.FechaInicio, 		Sol.MontoSeguroVida ,
				Sol.ForCobroSegVida,	Sol.ClasiDestinCred, 	Sol.InstitucionNominaID,
				Sol.FolioCtrl, 			Sol.HorarioVeri,		Sol.ConvenioNominaID,
				IFNULL(Sol.PorcGarLiq, Decimal_Cero) AS PorcGarLiq, PRC.TipoContratoCCID,
				Sol.FechaInicioAmor, 	Sol.DiaPagoProd, 		Sol.MontoSeguroCuota,
				Sol.IVASeguroCuota,		Sol.CobraSeguroCuota, 	Sol.CobraIVASeguroCuota,
				Sol.TipoConsultaSIC,	Sol.FolioConsultaBC,	Sol.FolioConsultaCC,
				Sol.EsAgropecuario,		Sol.CadenaProductivaID,	Sol.RamaFIRAID,
				Sol.SubramaFIRAID,		Sol.ActividadFIRAID,	Sol.TipoGarantiaFIRAID,
				Sol.ProgEspecialFIRAID, Sol.FechaCobroComision,	Sol.AcreditadoIDFIRA,
				Sol.CreditoIDFIRA,		Sol.EsAutomatico,		Sol.TipoAutomatico,
				Sol.InvCredAut,			Sol.CtaCredAut, 		Sol.Reacreditado,
				Sol.CobraAccesorios,	Sol.Cobertura,			Sol.Prima,
				Sol.Vigencia,			Sol.EsConsolidacionAgro,	Sol.DeudorOriginalID,		Sol.LineaCreditoID,
				Sol.ManejaComAdmon,		Sol.ComAdmonLinPrevLiq,		Sol.ForCobComAdmon,			Sol.ForPagComAdmon,		Sol.PorcentajeComAdmon,
				Sol.MontoPagComAdmon,	Sol.ManejaComGarantia,		Sol.ComGarLinPrevLiq,		Sol.ForCobComGarantia,
				Sol.ForPagComGarantia,	Sol.PorcentajeComGarantia,	Sol.MontoPagComGarantia
			FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli				ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro          	ON Sol.ProspectoID = Pro.ProspectoID
				INNER JOIN PRODUCTOSCREDITO PRC  	ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE	Sol.SolicitudCreditoID = Par_SoliCredID
			GROUP BY Grp.GrupoID;

	END IF;

	IF(Par_NumCon = Con_AgropecuarioRes) THEN
		SELECT	Pue.AtiendeSuc,			Usu.SucursalUSuario
		INTO	Var_AtiendeSucursales,	Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID	= Usu.ClavePuestoID
				WHERE	Usu.UsuarioID	= Aud_Usuario;

		SET Var_TasaPasiva := (SELECT TasaPasiva
									FROM CREDTASAPASIVAAGRO
								WHERE SolicitudCreditoID = Par_SoliCredID ORDER BY FechaActual DESC LIMIT 1);
		SET Var_TasaPasiva := IFNULL(Var_TasaPasiva, Entero_Cero);

		SELECT COUNT(Cre.CreditoID)
		INTO Var_CantCreditos
		FROM SOLICITUDCREDITO Sol
			INNER JOIN CLIENTES Cli	ON Sol.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS Cre ON Cre.ClienteID = Cli.ClienteID
				AND Cre.Estatus IN (Est_Vigente,Est_Pagado,Est_Vencido,Est_Castigado)
		WHERE
				Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
				AND Sol.TipoCredito = Es_Reestructura;

		SELECT
			Grp.GrupoID,
			MAX(Grp.NombreGrupo),
			MAX(Grp.FechaRegistro),
			MAX(Grp.CicloActual)
		INTO Var_GrupoID, Var_NombreGrupo, Var_GrpFechaRegistro, Var_CicloPondGrupo
		FROM SOLICITUDCREDITO Sol
			INNER JOIN INTEGRAGRUPOSCRE SolGrp 	ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID
			INNER JOIN GRUPOSCREDITO Grp       	ON SolGrp.GrupoID = Grp.GrupoID
			WHERE
				Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
				AND Sol.TipoCredito = Es_Reestructura
			GROUP BY Grp.GrupoID;

		SELECT
			Sol.SolicitudCreditoID,											Sol.ClienteID,											IFNULL(Cli.NombreCompleto, Con_StrVacio) AS CliNombreCompleto,
			Sol.MonedaID,													Sol.ProductoCreditoID,									Sol.ProspectoID,
			IFNULL(Pro.NombreCompleto, Con_StrVacio) AS ProNombreCompleto,	Sol.FechaRegistro,										Sol.FechaAutoriza,
			Sol.MontoSolici,												Sol.MontoAutorizado,									Sol.PlazoID,
			Sol.Estatus,													Sol.TipoDispersion,										Sol.CuentaCLABE,
			Sol.SucursalID,													Sol.ForCobroComAper,									ROUND(Sol.MontoPorComAper,2) AS MontoPorComAper,
			ROUND(Sol.IVAComAper,2) AS IVAComAper,							Sol.DestinoCreID,										Sol.PromotorID,
			Sol.CalcInteresID,												Sol.TasaFija,											FORMAT(Sol.TasaBase,0) AS TasaBase,
			Sol.SobreTasa,Sol.PisoTasa,										Sol.TechoTasa,											Sol.FactorMora,
			Sol.FrecuenciaCap,												Sol.PeriodicidadCap,									Sol.FrecuenciaInt,
			Sol.PeriodicidadInt,											Sol.TipoPagoCapital,									Sol.NumAmortizacion,
			Sol.CalendIrregular,											Sol.DiaPagoInteres,										Sol.DiaPagoCapital,
			Sol.DiaMesInteres,												Sol.DiaMesCapital,										Sol.AjusFecUlVenAmo,
			Sol.AjusFecExiVen,												Sol.NumTransacSim,										Sol.ValorCAT,
			Sol.FechaInhabil,												Sol.AporteCliente,										Sol.UsuarioAutoriza,
			Sol.FechaRechazo,												Sol.UsuarioRechazo,										Sol.ComentarioRech,
			Sol.MotivoRechazo,												Sol.TipoCredito,										Sol.NumCreditos,
			Sol.Relacionado,												Sol.Proyecto,											Sol.TipoFondeo,
			Sol.InstitFondeoID,												Sol.LineaFondeo,										Sol.TipoCalInteres,
			Sol.CreditoID,													Sol.FechaFormalizacion,									Sol.MontoFondeado,
			Sol.PorcentajeFonde,											Sol.NumeroFondeos,										Sol.NumAmortInteres,
			Sol.MontoCuota,													IFNULL(Var_GrupoID, Entero_Cero) AS GrupoID,		IFNULL(Var_NombreGrupo, Con_StrVacio) AS NombreGrupo,
			IFNULL(Var_GrpFechaRegistro, Con_FechaVacia) AS GrpFechaRegistro,	IFNULL(Var_CicloPondGrupo, Entero_Cero) AS CicloActual,		Sol.ComentarioEjecutivo,
			Sol.ComentarioMesaControl,										Var_SucursalUsuario AS SucursalPromot,					Var_AtiendeSucursales AS PromotAtiendeSucursal,
			Var_CantCreditos AS CantCreditos,							Sol.FechaVencimiento,									Sol.FechaInicio,
			Sol.MontoSeguroVida ,											Sol.ForCobroSegVida,									Sol.ClasiDestinCred,
			Sol.InstitucionNominaID,										Sol.FolioCtrl,											Sol.HorarioVeri,
			IFNULL(Sol.PorcGarLiq, Decimal_Cero) AS PorcGarLiq,				PRC.TipoContratoCCID,									Sol.FechaInicioAmor,
			Sol.DiaPagoProd,												Sol.MontoSeguroCuota,									Sol.IVASeguroCuota,
			Sol.CobraSeguroCuota,											Sol.CobraIVASeguroCuota,								Sol.TipoConsultaSIC,
			Sol.FolioConsultaBC,											Sol.FolioConsultaCC,									Sol.EsAgropecuario,
			Sol.CadenaProductivaID,											Sol.RamaFIRAID,											Sol.SubramaFIRAID,
			Sol.ActividadFIRAID,											Sol.TipoGarantiaFIRAID,									Sol.ProgEspecialFIRAID,
			Sol.FechaCobroComision,											Sol.EsAutomatico,										Sol.TipoAutomatico,
            Sol.InvCredAut,													Sol.CtaCredAut, 										Sol.Reacreditado,
            Sol.CobraAccesorios,											Sol.AcreditadoIDFIRA,									Sol.CreditoIDFIRA,
            Sol.EsConsolidacionAgro,										Sol.DeudorOriginalID,			Var_TasaPasiva AS TasaPasiva,
			Sol.LineaCreditoID,
			Sol.ManejaComAdmon,		Sol.ComAdmonLinPrevLiq,		Sol.ForCobComAdmon,			Sol.ForPagComAdmon,		Sol.PorcentajeComAdmon,
			Sol.MontoPagComAdmon,	Sol.ManejaComGarantia,		Sol.ComGarLinPrevLiq,		Sol.ForCobComGarantia,
			Sol.ForPagComGarantia,	Sol.PorcentajeComGarantia,	Sol.MontoPagComGarantia
			FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli				ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro          	ON Sol.ProspectoID = Pro.ProspectoID
				INNER JOIN PRODUCTOSCREDITO PRC  	ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE
				Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
				AND Sol.TipoCredito = Es_Reestructura;

	END IF;

    -- Consulta: Dias Primer Amortizacion para Tipo Pago Capital: LIBRES
    IF(Par_NumCon = Con_DiasPrimerAmor) THEN
		-- SE OBTIENE EL NUMERO DE TRANSACCION DE LA SIMULACION DE LA SOLICITUD DE CREDITO
		SELECT 	ProductoCreditoID,	NumTransacSim
        INTO 	Var_ProductoCreID,	Var_NumTrSim
        FROM SOLICITUDCREDITO
        WHERE SolicitudCreditoID = Par_SoliCredID;

		-- SE OBTIENE LOS DIAS REQUERIDO EN LA PRIMERA AMORTIZACION
		SELECT 	DiasReqPrimerAmor
		INTO 	Var_DiasReqPrimerAmor
		FROM CALENDARIOPROD
		WHERE ProductoCreditoID = Var_ProductoCreID;

		SET Var_DiasReqPrimerAmor   := IFNULL(Var_DiasReqPrimerAmor, Entero_Cero);

		-- Se obtiene el valor si requiere validar los dias requeridos para la primera amortizacion en Tipo Pago Capital LIBRES
		SELECT ValorParametro
		INTO Var_ValorReqPrimerAmor
		FROM PARAMGENERALES
		WHERE LlaveParametro = DescValidaReqPrimerAmor;

		SET Var_ValorReqPrimerAmor   := IFNULL(Var_ValorReqPrimerAmor, ConstanteNO);

		-- SE OBTIENE LA FECHA DE VENCIMIENTO DE LA PRIMERA AMORTIZACION
		SET Var_FecFinPrimerAmor := (SELECT MIN(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE NumTransaccion = Var_NumTrSim);

		-- SE OBTIENE LA FECHA DEL SISTEMA
		SET Var_FechaSistema	:=  (SELECT FechaSistema FROM PARAMETROSSIS);

		-- SE OBTIENE LA DIFERENCIA ENTRE LA FECHA DE VENCIMIENTO DE LA PRIMERA AMORTIZACION Y LA FECHA DEL SISTEMA
		SET Var_NumDiasVenPrimAmor := (SELECT DATEDIFF(Var_FecFinPrimerAmor,Var_FechaSistema));
		SET Var_NumDiasVenPrimAmor  := IFNULL(Var_NumDiasVenPrimAmor, Entero_Cero);

		SELECT Var_ValorReqPrimerAmor,Var_NumDiasVenPrimAmor,Var_DiasReqPrimerAmor,Var_FechaSistema,Var_FecFinPrimerAmor;

    END IF;

  -- Consulta: 15 CONSULTA SOLICITUDES DE RENOVACION DE CREDITO AGRO
	IF(Par_NumCon = Con_RenovacionesAgro) THEN
		SELECT	Pue.AtiendeSuc,			Usu.SucursalUSuario
		INTO	Var_AtiendeSucursales,	Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue ON Pue.ClavePuestoID	= Usu.ClavePuestoID
				WHERE	Usu.UsuarioID	= Aud_Usuario;
		SET Var_TasaPasiva := (SELECT TasaPasiva
									FROM CREDTASAPASIVAAGRO
								WHERE SolicitudCreditoID = Par_SoliCredID ORDER BY FechaActual DESC LIMIT 1);
		SET Var_TasaPasiva := IFNULL(Var_TasaPasiva, Entero_Cero);

		SELECT COUNT(Cre.CreditoID)
		INTO Var_CantCreditos
		FROM SOLICITUDCREDITO Sol
			INNER JOIN CLIENTES Cli	ON Sol.ClienteID = Cli.ClienteID
			INNER JOIN CREDITOS Cre ON Cre.ClienteID = Cli.ClienteID
				AND Cre.Estatus IN (Est_Vigente,Est_Pagado,Est_Vencido,Est_Castigado)
			WHERE
				Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
				AND Sol.TipoCredito = Cons_EsRenovacion;

		SELECT
			Grp.GrupoID,
			MAX(Grp.NombreGrupo),
			MAX(Grp.FechaRegistro),
			MAX(Grp.CicloActual)
		INTO Var_GrupoID, Var_NombreGrupo, Var_GrpFechaRegistro, Var_CicloPondGrupo
		FROM SOLICITUDCREDITO Sol
			INNER JOIN INTEGRAGRUPOSCRE SolGrp 	ON Sol.SolicitudCreditoID =  SolGrp.SolicitudCreditoID
			INNER JOIN GRUPOSCREDITO Grp       	ON SolGrp.GrupoID = Grp.GrupoID
			WHERE Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
				AND Sol.TipoCredito = Cons_EsRenovacion
			GROUP BY Grp.GrupoID;

		SELECT
			Sol.SolicitudCreditoID,											Sol.ClienteID,											IFNULL(Cli.NombreCompleto, Con_StrVacio) AS CliNombreCompleto,
			Sol.MonedaID,													Sol.ProductoCreditoID,									Sol.ProspectoID,
			IFNULL(Pro.NombreCompleto, Con_StrVacio) AS ProNombreCompleto,	Sol.FechaRegistro,										Sol.FechaAutoriza,
			Sol.MontoSolici,												Sol.MontoAutorizado,									Sol.PlazoID,
			Sol.Estatus,													Sol.TipoDispersion,										Sol.CuentaCLABE,
			Sol.SucursalID,													Sol.ForCobroComAper,									ROUND(Sol.MontoPorComAper,2) AS MontoPorComAper,
			ROUND(Sol.IVAComAper,2) AS IVAComAper,							Sol.DestinoCreID,										Sol.PromotorID,
			Sol.CalcInteresID,												Sol.TasaFija,											FORMAT(Sol.TasaBase,0) AS TasaBase,
			Sol.SobreTasa,Sol.PisoTasa,										Sol.TechoTasa,											Sol.FactorMora,
			Sol.FrecuenciaCap,												Sol.PeriodicidadCap,									Sol.FrecuenciaInt,
			Sol.PeriodicidadInt,											Sol.TipoPagoCapital,									Sol.NumAmortizacion,
			Sol.CalendIrregular,											Sol.DiaPagoInteres,										Sol.DiaPagoCapital,
			Sol.DiaMesInteres,												Sol.DiaMesCapital,										Sol.AjusFecUlVenAmo,
			Sol.AjusFecExiVen,												Sol.NumTransacSim,										Sol.ValorCAT,
			Sol.FechaInhabil,												Sol.AporteCliente,										Sol.UsuarioAutoriza,
			Sol.FechaRechazo,												Sol.UsuarioRechazo,										Sol.ComentarioRech,
			Sol.MotivoRechazo,												Sol.TipoCredito,										Sol.NumCreditos,
			Sol.Relacionado,												Sol.Proyecto,											Sol.TipoFondeo,
			Sol.InstitFondeoID,												Sol.LineaFondeo,										Sol.TipoCalInteres,
			Sol.CreditoID,													Sol.FechaFormalizacion,									Sol.MontoFondeado,
			Sol.PorcentajeFonde,											Sol.NumeroFondeos,										Sol.NumAmortInteres,
			Sol.MontoCuota,													IFNULL(Var_GrupoID, Entero_Cero) AS GrupoID,		IFNULL(Var_NombreGrupo, Con_StrVacio) AS NombreGrupo,
			IFNULL(Var_GrpFechaRegistro, Con_FechaVacia) AS GrpFechaRegistro,	IFNULL(Var_CicloPondGrupo,Entero_Cero) AS CicloActual,		Sol.ComentarioEjecutivo,
			Sol.ComentarioMesaControl,										Var_SucursalUsuario AS SucursalPromot,					Var_AtiendeSucursales AS PromotAtiendeSucursal,
			Var_CantCreditos AS CantCreditos,							Sol.FechaVencimiento,									Sol.FechaInicio,
			Sol.MontoSeguroVida ,											Sol.ForCobroSegVida,									Sol.ClasiDestinCred,
			Sol.InstitucionNominaID,										Sol.FolioCtrl,											Sol.HorarioVeri,
			IFNULL(Sol.PorcGarLiq, Decimal_Cero) AS PorcGarLiq,				PRC.TipoContratoCCID,									Sol.FechaInicioAmor,
			Sol.DiaPagoProd,												Sol.MontoSeguroCuota,									Sol.IVASeguroCuota,
			Sol.CobraSeguroCuota,											Sol.CobraIVASeguroCuota,								Sol.TipoConsultaSIC,
			Sol.FolioConsultaBC,											Sol.FolioConsultaCC,									Sol.EsAgropecuario,
			Sol.CadenaProductivaID,											Sol.RamaFIRAID,											Sol.SubramaFIRAID,
			Sol.ActividadFIRAID,											Sol.TipoGarantiaFIRAID,									Sol.ProgEspecialFIRAID,
			Sol.FechaCobroComision,											Var_TasaPasiva AS TasaPasiva,							Sol.EsAutomatico,
			Sol.TipoAutomatico,												Sol.InvCredAut,											Sol.CtaCredAut,
			Sol.AcreditadoIDFIRA,											Sol.CreditoIDFIRA,										Sol.Reacreditado,
            Sol.CobraAccesorios,											PRC.ReqConsultaSIC,										Sol.EsConsolidacionAgro,
            Sol.DeudorOriginalID,	Sol.LineaCreditoID,
			Sol.ManejaComAdmon,		Sol.ComAdmonLinPrevLiq,		Sol.ForCobComAdmon,			Sol.ForPagComAdmon,		Sol.PorcentajeComAdmon,
			Sol.MontoPagComAdmon,	Sol.ManejaComGarantia,		Sol.ComGarLinPrevLiq,		Sol.ForCobComGarantia,
			Sol.ForPagComGarantia,	Sol.PorcentajeComGarantia,	Sol.MontoPagComGarantia
			FROM SOLICITUDCREDITO Sol
				LEFT JOIN CLIENTES Cli				ON Sol.ClienteID = Cli.ClienteID
				LEFT JOIN PROSPECTOS Pro          	ON Sol.ProspectoID = Pro.ProspectoID
				INNER JOIN PRODUCTOSCREDITO PRC  	ON PRC.ProducCreditoID = Sol.ProductoCreditoID
			WHERE
				Sol.SolicitudCreditoID = Par_SoliCredID
				AND Sol.EsAgropecuario = Cons_SI
				AND Sol.TipoCredito = Cons_EsRenovacion;

	END IF;

	IF (Par_NumCon = Con_SolCredInstConv) THEN
		SELECT	SOL.SolicitudCreditoID,		SOL.ProspectoID,					SOL.ClienteID,				CLI.NombreCompleto,		SOL.ProductoCreditoID,
				SOL.ConvenioNominaID,		CONV.Descripcion,					SOL.InstitucionNominaID,	INTS.NombreInstit,		NOM.NoEmpleado,
				SOL.TipoCredito,			TIPO.Descripcion AS TipoEmpleado,	SOL.MontoSolici,			SOL.SucursalID,			SOL.FechaRegistro,
				CONV.ManejaCapPago,			SOL.Estatus,						CONV.Resguardo,				IF(SOL.TipoCredito = 'N', TIPOEMP.SinTratamiento,ConTratamiento) AS PorcentajeCapacidad
			FROM SOLICITUDCREDITO SOL
			INNER JOIN CLIENTES CLI ON CLI.ClienteID = SOL.ClienteID
			INNER JOIN CONVENIOSNOMINA CONV ON CONV.ConvenioNominaID = SOL.ConvenioNominaID
			INNER JOIN INSTITNOMINA INTS ON INTS.InstitNominaID = SOL.InstitucionNominaID
			LEFT JOIN NOMINAEMPLEADOS NOM ON NOM.ClienteID = CLI.ClienteID AND NOM.ConvenioNominaID = CONV.ConvenioNominaID
			LEFT JOIN CATTIPOEMPLEADOS TIPO ON TIPO.TipoEmpleadoID = NOM.TipoEmpleadoID
			LEFT JOIN TIPOEMPLEADOSCONVENIO TIPOEMP ON TIPOEMP.TipoEmpleadoID = NOM.TipoEmpleadoID
													AND  TIPOEMP.ConvenioNominaID = CONV.ConvenioNominaID
													AND  TIPOEMP.InstitNominaID = CONV.InstitNominaID
			WHERE SOL.SolicitudCreditoID = Par_SoliCredID;
	END IF;

	-- 17.- Solicitud de crèdito par dispersión
	IF (Par_NumCon = Lis_SolCredNOLibCan) THEN

		SELECT Sol.SolicitudCreditoID,	Cli.ClienteID,	Cli.NombreCompleto,
				CASE ForCobroComAper WHEN "D" THEN Sol.MontoSolici -(ROUND((Sol.MontoPorComAper + Sol.IVAComAper),2))
									 WHEN "F" THEN Sol.MontoSolici -(ROUND((Sol.MontoPorComAper + Sol.IVAComAper),2))
					ELSE Sol.MontoSolici
				END AS MontoSolici,
				Sol.Estatus
		  FROM SOLICITUDCREDITO Sol
		 INNER JOIN CLIENTES Cli ON Sol.ClienteID = Cli.ClienteID
		 WHERE Sol.SolicitudCreditoID = Par_SoliCredID;

	END IF;

END TerminaStore$$