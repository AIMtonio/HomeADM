-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSISCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSISCON`;

DELIMITER $$
CREATE PROCEDURE `PARAMETROSSISCON`(
	-- --------------------------------------------------------------------
	-- SP QUE REALIZA LA CONSULTA DE LOS PARAMETROS GENERALES DEL SISTEMA
	-- --------------------------------------------------------------------
	Par_EmpresaID		VARCHAR(11),		-- Numero de la Empresa
	Par_ClaveUsuario	VARCHAR(45),		-- Clave del Usuario
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	/* Parametros de Auditoria */
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 		-- Auditoria
	Aud_Sucursal		INT(11), 			-- Auditoria
	Aud_NumTransaccion	BIGINT(20) 			-- Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_LookAndFeel			VARCHAR(50);
    DECLARE Var_TipoImpresora	    CHAR(1);  -- Define el tipo de impreso a Ocupar por S: Socket o A: Applet

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);
	DECLARE	Entero_Uno				INT(11);
	DECLARE	Entero_Dos				INT(11);

	DECLARE	Entero_Tres				INT(11);
	DECLARE	Con_Principal			INT(11);
	DECLARE	Con_Login				INT(11);
	DECLARE	Con_WS					INT(11);
	DECLARE Con_FechaHoraWS			INT(11);

	DECLARE Con_Representante		INT(11);
	DECLARE EstatusActivo			CHAR(1);
	DECLARE	Var_NumDias				INT(11);
	DECLARE cambioPass				CHAR(1);
	DECLARE CajaPrincipal			CHAR(2);

	DECLARE CajaBovedaCentral		CHAR(2);
	DECLARE CajaAtencionPub			CHAR(2);
	DECLARE Con_FacElec				INT(11);
	DECLARE Con_Timbrado			INT(11);
	DECLARE Con_DiaAnteriorSistema	INT(11);

	DECLARE Con_DatosCliente		INT(11);
	DECLARE Timbrado_No				CHAR(1);
	DECLARE Con_ActivaPromotor		INT(11);
	DECLARE Con_FechaSucursal		INT(11);
	DECLARE Con_CambiaPromotor  	INT(11);

	DECLARE Con_TipoInstFin			INT(11);
	DECLARE Con_ParamSeccionEsp		INT(11);
	DECLARE VarLogoCtePantalla		VARCHAR(300);
	DECLARE	Str_SI					CHAR(1);
	DECLARE	Str_NO					CHAR(1);

	DECLARE Cte_T					CHAR(1);
	DECLARE	Desc_CP					VARCHAR(50);
	DECLARE	Desc_BG					VARCHAR(50);
	DECLARE	Desc_CA					VARCHAR(50);
	DECLARE Con_CalcularCURPyRFC	INT(11);

	DECLARE Var_CobranzaXReferencia	VARCHAR(1);
	DECLARE Con_FechaConsDisp		INT(2);
	DECLARE Clave_TipoImpresora		VARCHAR(20);
	DECLARE Con_OficialCumplimiento	INT(2);
	DECLARE Con_RepFinancieros  	INT(11);
	DECLARE Con_ValidaCFDI			INT(11);
	DECLARE Con_RutaArchivoWs		INT(11);		-- Consulta de archivo para el ws de milagro
	DECLARE HabilitaConfPass		VARCHAR(100);	-- Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Var_HabilitaConfPass	CHAR(1);		-- Variable para Guardar Llave Parametro: Indica si la contrasenia requiere configuracion
	DECLARE Con_ConfigContra		INT(11);		-- Consulta de parametros de configuracion de la contraseña si es requerido
	DECLARE Con_ValRolFlujoSol		INT(11);		-- COnsulta de los parametros de configuracion de roles en flujo d esolicitud para liberar y rechazar
	DECLARE Con_InfoRelWS			INT(11);		-- Consulta de informacion relevante para los Web Services
	DECLARE Con_NecCamPass			INT(11);		-- Consulta para saber si requiere cambio de contraseña el usuario
	DECLARE Var_ConCierre			INT(11);		-- Consulta cierre automatico

    DECLARE Var_FechaSistema		DATE;
    DECLARE	Con_UnificaClientes		INT(11);
    DECLARE Con_RutaArchivos  		INT(11);
    DECLARE Con_ParametrosBancas    INT(11);
    DECLARE	Si_SPEI					CHAR(1);
	DECLARE	No_SPEI					CHAR(1);
    DECLARE Con_CargaLayoutXLSDepRef INT(11);
	DECLARE Llave_LookAndFeel		VARCHAR(50);
	
	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	Entero_Uno				:= 1;				-- Entero Uno
	SET	Entero_Dos				:= 2;				-- Entero dos

	SET	Entero_Tres				:= 3;				-- Entero tres
	SET	Con_Principal			:= 1;				-- Consulta principal
	SET	Con_Login				:= 2;				-- Consulta inicio de sesion
	SET	Con_WS					:= 3;				-- Consulta por WS
	SET Con_FacElec				:= 5;				-- Consulta Factura Electronica

	SET Con_FechaHoraWS			:= 7;				-- Consulta la fecha y hora por WS
	SET Con_Representante 		:= 8;				-- Consulta datos del representante
	SET Con_DiaAnteriorSistema	:= 9;				-- Consulta la fecha anterior a la del sistema
	SET Con_DatosCliente		:= 10;				-- Consulta Datos del Cliente
	SET Con_FechaSucursal		:= 11;				-- Consulta la Fecha de la Sucursal

	SET Con_CambiaPromotor  	:= 12;				-- Consulta si se cambia el promotor en solicitud de credito
	SET Con_TipoInstFin		  	:= 15; 				-- Consulta para saber el tipo de institucion financiera
	SET Con_ParamSeccionEsp		:= 16; 				-- Consulta los parametros que habilitan secciones especificas
	SET	EstatusActivo			:= 'A'; 			-- Estatus Activo
	SET	CajaPrincipal			:= 'CP';			-- Caja Principal

	SET	CajaBovedaCentral		:= 'BG';			-- Caja Boveda Central
	SET	CajaAtencionPub			:= 'CA';			-- Caja de Atencion al Publico
	SET Con_Timbrado			:= 6;				-- Consulta si el Edo de Cta Timbra
	SET Timbrado_No				:= 'N';				-- No Timbra el Edo de Cta
	SET	Str_SI					:= 'S';				-- Constante SI

    SET	Si_SPEI					:= 'S';
	SET	No_SPEI					:= 'N';

	SET	Str_NO					:= 'N';				-- Constante NO
	SET	Cte_T					:= 'T';				-- Separador entre Fecha y la Hora WS
	SET	Desc_CP	:= 'CAJA PRINCIPAL DE SUCURSAL';	-- Descripcion Caja Principal
	SET	Desc_BG	:= 'BOVEDA CENTRAL';				-- Descripcion Caja Boveda Central
	SET	Desc_CA	:= 'CAJA DE ATENCION AL PUBLICO';	-- Descripcion Caja de Atencion al Publico

	SET Con_CalcularCURPyRFC	:= 17; 				-- Consulta si se calcular CURP y RFC
	SET Con_FechaConsDisp		:= 18;				-- Consulta la fecha de consulta disponible
	SET Clave_TipoImpresora		:= 'TipoImpresoraTicket';
	SET Con_OficialCumplimiento	:= 19;				-- Consulta el Oficial de Cumplimiento
	SET Con_RepFinancieros		:= 20;				-- Consulta de Reportes Financieros
	SET Con_ValidaCFDI			:= 21;				-- Consulta de parametros del WS de validacion de CFDI
	SET Con_RutaArchivoWs		:= 22;				-- Consulta de archivo para el ws de milagro
	SET Con_ConfigContra		:= 23;				-- Consulta de parametros de configuracion de la contraseña si es requerido
	SET Con_ValRolFlujoSol		:= 24;				-- COnsulta de los parametros de configuracion de roles en flujo d esolicitud para liberar y rechazar
	SET Con_InfoRelWS			:= 25;				-- Consulta de informacion relevante para los Web Services
    SET Con_NecCamPass			:= 26;				-- Consulta si requiere cambio de contraseña
	SET HabilitaConfPass		:= "HabilitaConfPass";		-- Llave Parametro: Indica si la contrasenia requiere configuracion
	SET	Var_ConCierre			:= 27;				-- Consulta cierre automatico
	SET Con_UnificaClientes		:= 28;
	SET Con_ParametrosBancas    := 29;
	SET Con_RutaArchivos		:= 30;
	SET Con_CargaLayoutXLSDepRef:= 31;
	SET Llave_LookAndFeel		:= 'LookAndFeel';

	/* Consulta No. 2: Para el login */
	IF(Par_NumCon = Con_Login) THEN
	   SET VarLogoCtePantalla := (SELECT LogoCtePantalla FROM COMPANIA LIMIT 1 );
       SELECT ValorParametro  INTO Var_TipoImpresora
       FROM PARAMGENERALES WHERE LlaveParametro = Clave_TipoImpresora;

		-- Consultamno si la contrasenia tiene configurado el parametro HabilitaConfPass para validacion de politica de seguridad de la contrasenia
		-- Si no mantener la existente
		SET Var_HabilitaConfPass	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass	:= IFNULL(Var_HabilitaConfPass,Str_NO);
		SET Var_LookAndFeel 		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_LookAndFeel);

		SELECT
		Par.FechaSistema,       Par.SucursalMatrizID,       Suc.NombreSucurs AS NombreSucursal,     Suu.Telefono,          Par.TelefonoInterior,
		Par.InstitucionID,      Ins.Nombre AS NombreIns,   	Par.NombreRepresentante,  				Par.RFCRepresentante,
		Par.MonedaBaseID,       Mon.Descripcion,            Mon.DescriCorta,                        Mon.Simbolo,                Usu.UsuarioID,
		Usu.Clave,              Usu.RolID,                  Usu.NombreCompleto,                     Usu.Correo AS CorreoUsu,    Suu.SucursalID AS SucursalIde,
		Suu.FechaSucursal,      Suu.NombreSucurs,           Suu.NombreGerente,                      Suu.TasaISR,                Suu.EmpresaID AS EmpresaIde,
		DiasInversion,          Usu.FechUltimAcces,         Usu.FechUltPass,
		IF(Var_HabilitaConfPass = Str_SI,CASE WHEN DATEDIFF(NOW(), Usu.FechUltPass) > Par.DiaMaxCamContra THEN Str_SI ELSE Str_NO END ,CASE WHEN DATEDIFF(NOW(), Usu.FechUltPass) > Par.DiasCambioPass THEN Str_SI ELSE Str_NO END) AS cambioPass,
					Usu.EstatusSesion, 			Usu.IPsesion,
					DATEDIFF(NOW(), Usu.FechUltPass),	Pro.PromotorID,         Par.ClienteInstitucion,      Par.CuentaInstituc,					Par.RutaArchivos,
					RIGHT(CONCAT("000",CONVERT(CajaID, CHAR)), Entero_Tres),	TipoCaja,					FORMAT(SaldoEfecMN,Entero_Dos),			FORMAT(SaldoEfecME,Entero_Dos),		LimiteEfectivoMN,
					CASE WHEN TipoCaja = CajaPrincipal THEN Desc_CP
					ELSE CASE WHEN TipoCaja = CajaBovedaCentral THEN Desc_BG
					ELSE CASE WHEN TipoCaja = CajaAtencionPub THEN Desc_CA
					ELSE TipoCaja END	END END	AS TipoCajaDes,	Usu.ClavePuestoID, Par.RutaArchivosPLD,IFNULL(Suu.IVA,Entero_Cero) AS IVASucursal,
					Ins.Direccion, CONCAT(IFNULL(MR.Nombre,Cadena_Vacia),"," ,IFNULL(ER.Nombre,Cadena_Vacia)) AS DirSucursal,
								IFNULL(Par.ImpTicket,Cadena_Vacia) AS impresoraTicket, Par.TipoImpTicket, CV.Estatus,
								IFNULL(Par.MontoAportacion,Entero_Cero) AS MontoAportacion,
								IFNULL(Par.MontoPolizaSegA,Entero_Cero) AS MontoPolizaSegA,
								IFNULL(Par.MontoSegAyuda,Entero_Cero) AS MontoSegAyuda, Tip.NombreCorto,
								IFNULL(Par.SalMinDF ,Entero_Cero) AS SalMinDF, Ins.DirFiscal, Ins.RFC,
								IFNULL(Par.ImpSaldoCred,Cadena_Vacia) AS ImpSaldoCred,
								IFNULL(Par.ImpSaldoCta,Cadena_Vacia) AS ImpSaldoCuenta,
								IFNULL(Par.NombreJefeCobranza,Cadena_Vacia) AS JefeCobranza,
								IFNULL(Par.NomJefeOperayPromo,Cadena_Vacia) AS JefeOperaPromo,
								IFNULL(Ins.NombreCorto,Cadena_Vacia) AS NombreCortoInst,
					Par.GerenteGeneral,		Par.PresidenteConsejo,	Par.JefeContabilidad,			Par.RecursoTicketVent,
					Par.RolTesoreria, 		Par.RolAdminTeso, 		Par.MostrarSaldDisCtaYSbc,		Par.FuncionHuella,		Par.CambiaPromotor,
					MostrarPrefijo, 		CAST(VarLogoCtePantalla AS CHAR CHARACTER SET UTF8 ) AS LogoCtePantalla, 		Par.RutaNotifiCobranza,
                    Var_TipoImpresora AS TipoImpresoraTicket,		ActPerfilTransOpeMas,			NumEvalPerfilTrans,		Par.DirectorFinanzas,
                    Par.MostrarBtnResumen,
		    Var_LookAndFeel AS LookAndFeel
                    FROM PARAMETROSSIS Par
				INNER JOIN INSTITUCIONES AS Ins ON Par.InstitucionID	= Ins.InstitucionID
				INNER JOIN TIPOSINSTITUCION AS Tip ON Ins.TipoInstitID = Tip.TipoInstitID
				INNER JOIN MONEDAS AS Mon ON Par.MonedaBaseID = Mon.MonedaId
				INNER JOIN SUCURSALES AS Suc ON Par.SucursalMatrizID	= Suc.SucursalID
				INNER JOIN USUARIOS AS Usu ON  Usu.Clave    = Par_ClaveUsuario
				INNER JOIN SUCURSALES AS Suu ON Usu.SucursalUsuario	= Suu.SucursalID
				LEFT OUTER JOIN PROMOTORES AS Pro ON Usu.UsuarioID = Pro.UsuarioID
										  AND Pro.Estatus = EstatusActivo
				LEFT OUTER JOIN CAJASVENTANILLA AS CV ON Usu.UsuarioID	= CV.UsuarioID
				LEFT OUTER JOIN ESTADOSREPUB AS ER ON ER.EstadoID	  = Suu.EstadoID
				LEFT OUTER JOIN MUNICIPIOSREPUB AS MR ON ER.EstadoID = MR.EstadoID AND Suu.MunicipioID=MR.MunicipioID;
	END IF;

	/* Consulta No. 3: para los parametros de sesion para usuario del web service */
	IF(Par_NumCon = Con_WS) THEN
		SELECT Par.ClienteInstitucion, Par.CuentaInstituc, Par.FechaSistema, Par.NombreRepresentante, Ins.RFC
		FROM PARAMETROSSIS AS Par
		INNER JOIN INSTITUCIONES AS Ins ON Par.InstitucionID	= Ins.InstitucionID;
	END IF;

	/* Consulta No. 1: para los parametros de sesion en la aplicacion */
	IF(Par_NumCon = Con_Principal) THEN
		SET Var_CobranzaXReferencia := (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = 'PagosXReferencia');
		SET Var_CobranzaXReferencia := IFNULL(Var_CobranzaXReferencia,'N');
		SET Var_HabilitaConfPass	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass	:= IFNULL(Var_HabilitaConfPass,Str_NO);

		SELECT 	Param.EmpresaID			,	Param.FechaSistema		,	Param.SucursalMatrizID		,Param.TelefonoLocal		,Param.TelefonoInterior,
				Param.InstitucionID		,	Param.EmpresaDefault	,	Param.NombreRepresentante	,Param.RFCRepresentante		,Param.MonedaBaseID,
				Param.MonedaExtrangeraID,	Param.TasaISR			,	Param.TasaIDE				,Param.MontoExcIDE			,Param.EjercicioVigente,
				Param.PeriodoVigente	,	Param.DiasInversion	,		Param.DiasCredito			,Param.DiasCambioPass		,Param.LonMinCaracPass,
				Param.ClienteInstitucion,	Param.CuentaInstituc	,	Param.ManejaCaptacion		,Param.BancoCaptacion		,Param.TipoCuenta,
				Param.RutaArchivos		,	Param.RolTesoreria		,	Param.RolAdminTeso			,Param.OficialCumID			,Param.DirGeneralID,
				Param.DirOperID			,	Param.TipoCtaGLAdi		,	Param.RutaArchivosPLD		,Param.Remitente			,Param.ServidorCorreo,
				Param.Puerto			,	Param.UsuarioCorreo	,		Param.Contrasenia			,Param.CtaIniGastoEmp,		Param.CtaFinGastoEmp,
				Param.ImpTicket			,	Param.TipoImpTicket	,		Param.MontoAportacion 		,Param.ReqAportacionSo,		Param.MontoPolizaSegA,
				Param.MontoSegAyuda		,	Param.CuentasCapConta	,	Param.LonMinPagRemesa 		,Param.LonMaxPagRemesa,		Param.LonMinPagOport,
				Param.LonMaxPagOport	,	Param.SalMinDF			,	Param.ImpSaldoCred			,Param.ImpSaldoCta,			Param.NombreJefeCobranza,
				Param.NomJefeOperayPromo,	Param.GerenteGeneral	,	Param.PresidenteConsejo	,	Param.JefeContabilidad, 	Param.RecursoTicketVent,
				Param.VigDiasSeguro,		Param.VencimAutoSeg,	 	Ins.EstadoEmpresa,    	 	Ins.MunicipioEmpresa,       Ins.LocalidadEmpresa,
				Ins.ColoniaEmpresa,			Ins.CalleEmpresa,     	 	Ins.NumIntEmpresa,			Ins.NumExtEmpresa,    		Ins.CPEmpresa,
				Ins.DirFiscal,				Ins.RFC,				 	Param.TimbraEdoCta,			Param.GeneraCFDINoReg,    	Param.GeneraEdoCtaAuto,
				AplCobPenCieDia,			Param.FecUltConsejoAdmon,	Param.FoliosActasComite, 	Param.ServReactivaCte, 		Param.CtaContaSobrante,
				Param.CtaContaFaltante,		Param.CalifAutoCliente,  	Param.CtaContaDocSBCD,		Param.CtaContaDocSBCA, 		Param.AfectaContaRecSBC,
				Param.ContabilidadGL,		Param.DiasVigenciaBC,		Param.CenCostosChequeSBC,	Param.MostrarSaldDisCtaYSbc,Param.ValidaAutComite,
				Param.TipoContaMora, 		Param.DivideIngresoInteres, Param.ExtTelefonoLocal, 	Param.ExtTelefonoInt,		Param.EstCreAltInvGar ,
				Param.FuncionHuella,		Param.ConBuroCreDefaut,		Param.AbreviaturaCirculo, 	Param.ReqHuellaProductos, 	CancelaAutMenor,
				Param.ActivaPromotorCapta, 	Param.CambiaPromotor ,		MostrarPrefijo, 			TesoMovsCieMes,				ChecListCte,
				Param.TarjetaIdentiSocio, 	Param.CancelaAutSolCre, 	Param.DiasCancelaAutSolCre,	Param.NumTratamienCre,		Param.CapitalCubierto,
				Param.PagoIntVertical,  	Param.NumMaxDiasMora,
				Param.ImpFomatosInd,		Param.SistemasID,			Param.RutaNotifiCobranza,	Param.ReqValidaCred,		Param.CobraSeguroCuota ,
				Param.TipoDocumentoFirma,	Param.PerfilWsVbc,			Param.ReestCalVenc,			Param.EstValReest,			TipoDetRecursos,
				Param.CalculaCURPyRFC,		Param.ManejaCarteraAgro,	Param.SalMinDFReal,			Param.EvaluacionMatriz,		Param.FrecuenciaMensual,
				Param.EvaluaRiesgoComun,	Param.CapitalContableNeto,	Param.FechaEvaluacionMatriz,Param.ActPerfilTransOpe,	Param.FrecuenciaMensPerf,
				Param.FechaActPerfil,		Param.PorcCoincidencias,	Param.FecVigenDomicilio,	Param.ModNivelRiesgo,		Param.ValidarVigDomi,
				Param.TipoDocDomID,			Param.CobranzaAutCierre,	Param.CobroCompletoAut,		Param.CapitalCubiertoReac,	Param.PorcPersonaFisica,
				Param.PorcPersonaMoral,		Param.FechaConsDisp,
				Var_CobranzaXReferencia AS CobranzaXReferencia,
				ActPerfilTransOpeMas,		NumEvalPerfilTrans, 		Param.InvPagoPeriodico,
				Param.InstitucionCirculoCredito,	Param.ClaveEntidadCirculo,	Param.ReportarTotalIntegrantes,
				Param.PerfilAutEspAport,	Param.DirectorFinanzas,		Param.ValidaFactura, 		Param.ValidaFacturaURL,		Param.TiempoEsperaWS,
				Param.NumTratamienCreRees,	Param.RestringeReporte,		Param.CamFuenFonGarFira,	Param.PersonNoDeseadas,		Param.OcultaBtnRechazoSol,
				Param.PrimerRolFlujoSolID,	Param.SegundoRolFlujoSolID,	Param.RestringebtnLiberacionSol,	IFNULL(Param.VecesSalMinVig,0) AS VecesSalMinVig,
				Param.CaracterMinimo,		Param.CaracterMayus,		Param.CaracterMinus,		Param.CaracterNumerico,		Param.CaracterEspecial,
				Param.UltimasContra,		Param.DiaMaxCamContra,		Param.DiaMaxInterSesion,	Param.NumIntentos,			Param.NumDiaBloq,
				Param.ReqCaracterMayus,		Param.ReqCaracterMinus,		Param.ReqCaracterNumerico,	Param.ReqCaracterEspecial,	Var_HabilitaConfPass AS HabilitaConfPass,
				Param.PerfilCamCarLiqui,	Param.PermitirMultDisp,
                IFNULL(Param.AlerVerificaConvenio, 'N') AS AlerVerificaConvenio,
                IFNULL(Param.NoDiasAntEnvioCorreo,	0) AS NoDiasAntEnvioCorreo,
                IFNULL(Param.CorreoRemitente, '') AS  CorreoRemitente,
                IFNULL(Param.CorreoAdiDestino, '') AS CorreoAdiDestino,
                IFNULL(RemitenteID, 0) AS RemitenteID, ClabeInstitBancaria,
                IFNULL(Param.ValidarEtiqCambFond,'N') AS ValidarEtiqCambFond,
		        IFNULL(Param.UnificaCI,'N') AS UnificaCI,
		        IFNULL(Param.OrigenReplica,'') AS OrigenReplica,
		        IFNULL(Param.ReplicaAct,'N')    AS ReplicaAct,
				Param.RemitenteCierreID, Param.CorreoRemCierre,		Param.EjecDepreAmortiAut,		ZonaHoraria,	ValidaReferencia, Param.AplicaGarAdiPagoCre,
				Param.MostrarBtnResumen, Param.ValidaCicloGrupo,
				Param.ValidaCapitalConta, Param.PorMaximoDeposito
		FROM PARAMETROSSIS Param
		INNER JOIN INSTITUCIONES Ins ON Param.InstitucionID = Ins.InstitucionID
		WHERE Param.EmpresaID = Par_EmpresaID;

	END IF;

	/* Consulta No. 5: Consulta para obtener datos para realizar Conexion a WEB Service del PAC */
	IF(Par_NumCon = Con_FacElec) THEN
		SELECT
			Sis.EmpresaID, Sis.UsuarioFactElec, Sis.PassFactElec, Ins.InstitucionID, Sis.RFCFactElec AS RFC,
			Sis.TimbraEdoCta, Sis.UrlWSDLFactElec AS RutaWSDL,    IFNULL(Con.TimbraConsRet,Cadena_Vacia) AS TimbraConsRet,
			Sis.ProveedorTimbrado
			FROM PARAMETROSSIS Sis
				LEFT JOIN INSTITUCIONES Ins ON Sis.InstitucionID = Ins.InstitucionID
				LEFT JOIN CONSTANCIARETPARAMS Con ON Con.InstitucionID = Ins.InstitucionID;
	END IF;

	/* Consulta No. 6: Consulta si el Edo de Cta Timbra */
	IF(Par_NumCon=Con_Timbrado)THEN
		SELECT IFNULL(TimbraEdoCta,Timbrado_No) AS TimbraEdoCta
			FROM PARAMETROSSIS
				WHERE EmpresaID=Par_EmpresaID;
	END IF;

	/* Consulta No. 7: Consulta para obtener la fecha y la hora del sistema usada en WS*/
	IF(Par_NumCon=Con_FechaHoraWS)THEN
		SET Par_EmpresaID	:= Entero_Uno;
		SELECT CONCAT(IFNULL(FechaSistema,Fecha_Vacia), Cte_T,CURRENT_TIME) AS FechaSistema
			FROM PARAMETROSSIS
				WHERE EmpresaID = Par_EmpresaID;
	END IF;

	/* Consulta No. 8: Consulta para obtener los datos del representante legal asi como de la institucion*/
	IF(Par_NumCon=Con_Representante)THEN
		SELECT PS.NombreRepresentante, PS.RFCRepresentante, INS.Nombre,INS.RFC
				FROM PARAMETROSSIS PS INNER JOIN INSTITUCIONES INS ON PS.InstitucionID=INS.InstitucionID;
	END IF;

	/* Consulta No. 9: Consulta el dia anterior a la fecha del sistema */
	IF(Par_NumCon=Con_DiaAnteriorSistema)THEN
		SELECT DATE_ADD(FechaSistema,INTERVAL - Entero_Uno DAY) AS FechaSistema, CURRENT_TIME AS HoraSistema
			FROM PARAMETROSSIS;
	END IF;

	/* Consulta No. 10: Consulta el dia anterior a la fecha del sistema */
	IF (Par_NumCon = Con_DatosCliente)THEN
		SELECT
			Par.ValidaClaveKey, Par.NomCortoInstit, UPPER(Ins.Nombre) AS Nombre
		FROM PARAMETROSSIS Par
		INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID;
	END IF;

	/* Consulta No. 11: Consulta la fecha del sistema y de la sucursal */
	IF(Par_NumCon = Con_FechaSucursal) THEN
		SELECT suc.FechaSucursal, par.FechaSistema
			FROM SUCURSALES suc
				INNER JOIN PARAMETROSSIS par ON suc.EmpresaID = par.EmpresaID
				WHERE suc.SucursalID = Aud_Sucursal;
	END IF;

	/* Consulta No. 12: Consulta la fecha del sistema y de la sucursal */
	IF(Par_NumCon = Con_CambiaPromotor)THEN
		SELECT CambiaPromotor
			FROM PARAMETROSSIS
				WHERE  EmpresaID = Par_EmpresaID;
	END IF;

	/* Consulta No. 15: Consulta el tipo de institucion financiera */
	IF(Par_NumCon = Con_TipoInstFin)THEN
		SELECT IFNULL(Ins.TipoInstitID,Entero_Cero) AS TipoInstitID, Tip.NombreCorto
			FROM PARAMETROSSIS Par
				INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
				INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;
	END IF;

	/* Consulta No. 16: Consulta los parametros que habilitan secciones especificas */
	IF(Par_NumCon = Con_ParamSeccionEsp)THEN
		SELECT Par.CobraSeguroCuota
			FROM PARAMETROSSIS Par
				WHERE  EmpresaID = Par_EmpresaID;
	END IF;

	/* Consulta No. 17: Consulta si permite calcular la CURP Y RFC*/
	IF(Par_NumCon = Con_CalcularCURPyRFC)THEN
		SELECT Par.CalculaCURPyRFC
			FROM PARAMETROSSIS Par
				WHERE  EmpresaID = Par_EmpresaID;
	END IF;

	/* Consulta No. 18: Consulta si esta la disponible la opcion de consultar dispersion por fecha*/
	IF(Par_NumCon = Con_FechaConsDisp)THEN
		SELECT Par.FechaConsDisp
			FROM PARAMETROSSIS Par
				WHERE  EmpresaID = Par_EmpresaID;
	END IF;


	/* Consulta No. 19: Consulta el ID del usuario que es Oficial de Cumplimiento */
	IF(Par_NumCon = Con_OficialCumplimiento) THEN
		SELECT Par.OficialCumID
			FROM PARAMETROSSIS Par
				WHERE Par.EmpresaID = Par_EmpresaID;
	END IF;

	-- Consulta de Reportes Financieros
	IF(Par_NumCon = Con_RepFinancieros)THEN
		SELECT GerenteGeneral, JefeContabilidad, PresidenteConsejo, DirectorFinanzas
			FROM PARAMETROSSIS Par
				WHERE Par.EmpresaID = Par_EmpresaID;
	END IF;

	IF Par_NumCon = Con_ValidaCFDI THEN
		SELECT ValidaFactura, ValidaFacturaURL , TiempoEsperaWS
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;
	END IF;

	-- 22.- Consulta de archivo para el ws de milagro
	IF ( Par_NumCon = Con_RutaArchivoWs ) THEN
		SELECT RutaArchivos,	SucursalMatrizID
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;
	END IF;

	-- 23.- Consulta de parametros de configuracion de la contraseña si es requerido
	IF (Par_NumCon = Con_ConfigContra) THEN
		SET Var_HabilitaConfPass	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass	:= IFNULL(Var_HabilitaConfPass,Str_NO);

		SELECT	CaracterMinimo,		CaracterMayus,			CaracterMinus,			CaracterNumerico,		CaracterEspecial,
				UltimasContra,		DiaMaxCamContra,		DiaMaxInterSesion,		NumIntentos,			NumDiaBloq,
				ReqCaracterMayus,	ReqCaracterMinus,		ReqCaracterNumerico,	ReqCaracterEspecial,	Var_HabilitaConfPass AS HabilitaConfPass
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;
	END IF;

	-- 24.- COnsulta de los parametros de configuracion de roles en flujo d esolicitud para liberar y rechazar
	IF Par_NumCon = Con_ValRolFlujoSol THEN
		SELECT OcultaBtnRechazoSol,		RestringebtnLiberacionSol,		PrimerRolFlujoSolID,		SegundoRolFlujoSolID
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;
	END IF;


	-- 25.- Consulta de informacion relevante para los WebService
	IF(Par_NumCon = Con_InfoRelWS) THEN
		SELECT ClienteInstitucion, 		CuentaInstituc, 		FechaSistema,			EmpresaID
			FROM PARAMETROSSIS;
	END IF;

        /* Consulta No. 26: Si ya requiere cambio de contraseña para ws*/
    IF(Par_NumCon = Con_NecCamPass) THEN
		-- Consultamno si la contrasenia tiene configurado el parametro HabilitaConfPass para validacion de politica de seguridad de la contrasenia
		-- Si no mantener la existente
		SET Var_HabilitaConfPass	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LLaveParametro = HabilitaConfPass);
		SET Var_HabilitaConfPass	:= IFNULL(Var_HabilitaConfPass,Str_NO);

		SELECT FechaSistema  INTO Var_FechaSistema  FROM PARAMETROSSIS;

		SELECT
			IF(Var_HabilitaConfPass = Str_SI,CASE WHEN
													DATEDIFF(Var_FechaSistema, Usu.FechUltPass) > Par.DiaMaxCamContra THEN Str_SI
												ELSE Str_NO END ,
											CASE WHEN DATEDIFF(Var_FechaSistema, Usu.FechUltPass) > Par.DiasCambioPass THEN Str_SI
												ELSE Str_NO END) AS CambioPass
		FROM PARAMETROSSIS Par
		INNER JOIN USUARIOS AS Usu ON  Usu.Clave    = Par_ClaveUsuario;
	END IF;

	-- 27 Consulta para la pantalla de cierre automatico
	IF(Par_NumCon = Var_ConCierre) THEN

		SELECT CierreAutomatico
			FROM PARAMETROSSIS
			WHERE Par_EmpresaID
			LIMIT 1;

	END IF;

	IF Par_NumCon = Con_UnificaClientes THEN
		SELECT 	IFNULL(UnificaCI,'N') AS UnificaCI,
		        IFNULL(OrigenReplica,'') AS OrigenReplica,
		        IFNULL(ReplicaAct,'N')    AS ReplicaAct
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;
	END IF;

    IF Par_NumCon = Con_ParametrosBancas THEN
              SELECT
                    Param.EmpresaID,			Param.FechaSistema,				Param.SucursalMatrizID,			Param.TelefonoLocal,			Param.TelefonoInterior,
					Param.InstitucionID,		Param.EmpresaDefault,			Param.NombreRepresentante,		Param.RFCRepresentante,			Param.MonedaBaseID,
					Param.MonedaExtrangeraID,	Param.TasaISR,					Param.TasaIDE,					Param.MontoExcIDE,				Param.EjercicioVigente,
					Param.PeriodoVigente,		Param.DiasInversion,			Param.DiasCredito,				Param.DiasCambioPass,			Param.LonMinCaracPass,
					Param.ClienteInstitucion,	Param.CuentaInstituc,			Param.ManejaCaptacion,			Param.BancoCaptacion,			Param.TipoCuenta,
					Param.RutaArchivos,			Param.RolTesoreria,				Param.RolAdminTeso,				Param.OficialCumID,				Param.DirGeneralID,
					Param.DirOperID,			Param.TipoCtaGLAdi,				Param.RutaArchivosPLD,			Param.Remitente,				Param.ServidorCorreo,
					Param.Puerto,				Param.UsuarioCorreo,			Param.Contrasenia,				Param.CtaIniGastoEmp,			Param.CtaFinGastoEmp,
					Param.ImpTicket,			Param.TipoImpTicket,			Param.MontoAportacion,			Param.ReqAportacionSo,			Param.MontoPolizaSegA,
					Param.MontoSegAyuda,		Param.CuentasCapConta,			Param.LonMinPagRemesa,			Param.LonMaxPagRemesa,			Param.LonMinPagOport,
					Param.LonMaxPagOport,		Param.SalMinDF,					Param.ImpSaldoCred,				Param.ImpSaldoCta,				Param.NombreJefeCobranza,
					Param.NomJefeOperayPromo,	Param.GerenteGeneral,			Param.PresidenteConsejo,		Param.JefeContabilidad, 		Param.RecursoTicketVent,
					Param.VigDiasSeguro,		Param.VencimAutoSeg,			Ins.EstadoEmpresa,				Ins.MunicipioEmpresa,       	Ins.LocalidadEmpresa,
					Ins.ColoniaEmpresa,			Ins.CalleEmpresa,				Ins.NumIntEmpresa,				Ins.NumExtEmpresa,    			Ins.CPEmpresa,
					Ins.DirFiscal,				Ins.RFC,						Param.TimbraEdoCta,				Param.GeneraCFDINoReg,    		Param.GeneraEdoCtaAuto,
					AplCobPenCieDia,			Param.FecUltConsejoAdmon,		Param.FoliosActasComite,		Param.ServReactivaCte, 			Param.CtaContaSobrante,
					Param.CtaContaFaltante,		Param.CalifAutoCliente,			Param.CtaContaDocSBCD,			Param.CtaContaDocSBCA, 			Param.AfectaContaRecSBC,
					Param.ContabilidadGL,		Param.DiasVigenciaBC,			Param.CenCostosChequeSBC,		Param.MostrarSaldDisCtaYSbc,	Param.ValidaAutComite,
					Param.TipoContaMora, 		Param.DivideIngresoInteres,		Param.ExtTelefonoLocal,			Param.ExtTelefonoInt,			Param.EstCreAltInvGar ,
					Param.FuncionHuella,		Param.ConBuroCreDefaut,			Param.AbreviaturaCirculo,		Param.ReqHuellaProductos, 		CancelaAutMenor,
					Param.ActivaPromotorCapta, 	Param.CambiaPromotor,			MostrarPrefijo,					TesoMovsCieMes,					ChecListCte,
					Param.TarjetaIdentiSocio, 	Param.CancelaAutSolCre,			Param.DiasCancelaAutSolCre,		Param.NumTratamienCre,			Param.CapitalCubierto,
					Param.PagoIntVertical,  	Param.NumMaxDiasMora,			Param.ImpFomatosInd,			Param.SistemasID,				Param.RutaNotifiCobranza,
					Param.ReqValidaCred,		Param.CobraSeguroCuota,			Param.TipoDocumentoFirma,		Param.PerfilWsVbc,				Param.ReestCalVenc,
					Param.EstValReest,			TipoDetRecursos,				Param.CalculaCURPyRFC,			Param.ManejaCarteraAgro,		Param.SalMinDFReal,
					Param.EvaluacionMatriz,		Param.FrecuenciaMensual,		Param.EvaluaRiesgoComun,		Param.ClabeInstitBancaria,		Ins.NombreCorto,
					CASE WHEN IFNULL(Ins.ClaveParticipaSpei, Entero_Cero) = Entero_Cero
							THEN No_SPEI
							ELSE Si_SPEI
						END AS CuentaConSPEI
			FROM PARAMETROSSIS Param
			INNER JOIN INSTITUCIONES Ins ON Param.InstitucionID = Ins.InstitucionID
			WHERE Param.EmpresaID = Par_EmpresaID;
	END IF;

	IF( Par_NumCon = Con_RutaArchivos ) THEN
		SELECT RutaArchivos
		FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;
	END IF;

	/* Consulta No. 31: Consulta Parametro para leer un layout en formato xls(excel) en el proceso de depositos referenciados */
	IF(Par_NumCon = Con_CargaLayoutXLSDepRef)THEN
		SELECT CargaLayoutXLSDepRef
		FROM PARAMETROSSIS
		WHERE  EmpresaID = Par_EmpresaID;
	END IF;

END TerminaStore$$
