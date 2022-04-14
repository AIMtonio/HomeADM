-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSGRUPALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSGRUPALPRO`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSGRUPALPRO`(
	Par_Grupo				INT(11),
	Par_TipoTran    		INT(11),
	Par_FechaMinis 			DATE,
	INOUT Par_PolizaID		BIGINT(20),
	Par_OrigenPago			CHAR(1),				-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida          	CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID 			INT(11) ,
	Aud_Usuario 			INT(11) ,
	Aud_FechaActual 		DATETIME,
	Aud_DireccionIP 		VARCHAR(15),
	Aud_ProgramaID 			VARCHAR(50),
	Aud_Sucursal 			INT(11) ,
	Aud_NumTransaccion		BIGINT(20)
			)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_ReqAvales		CHAR(1);
DECLARE Var_FechaVenc		DATE;
DECLARE Var_Cuenta			BIGINT(12);
DECLARE CheckComple			CHAR(1);

DECLARE Par_NumTrans		BIGINT;			-- parametro a enviar para simulador
DECLARE Par_Cuotas			INT;				-- parametro a enviar para simulador
DECLARE Par_CAT				DECIMAL(14,4);	-- parametro a enviar para simulador
DECLARE	Par_MontoCuo		DECIMAL(14,4);	-- parametro a enviar para simulador
DECLARE	Par_FechaVen		DATE;			-- parametro a enviar para simulador
DECLARE Par_CuotasInt		INT;				-- parametro a enviar para simulador
DECLARE Var_ReqGarant		CHAR(1);
DECLARE Var_NumSolGar		INT(11);
DECLARE Var_MontoAsGar		DECIMAL(14,2);
DECLARE Var_RelGarCred		DECIMAL(14,2);
DECLARE Var_ResMonGaran		DECIMAL(14,2);
DECLARE Var_Credito			BIGINT(12);
DECLARE Var_CreditoVacio	BIGINT(12);
DECLARE Var_FechaIni		DATE;
DECLARE VarNumTransCre		BIGINT;
DECLARE Var_ReqGarLiq		CHAR(1);
DECLARE Var_PorGarLiq		DECIMAL(12,4);
DECLARE Par_MonGarLiq		DECIMAL(14,2);	-- parametro a enviar para calculo de monto de garantia liquida asociada al credito
DECLARE Par_MComGarLiq		DECIMAL(14,2);	-- parametro a enviar para calculo de monto de comision por apertura de garantia liquida asociada al credito
DECLARE Var_ForCobCoAp		CHAR(1);
DECLARE Var_MonComAPC		DECIMAL(14,2);	-- Monto de comision por apertura del producto de credito
DECLARE VarDiasDifFec  		INT;
DECLARE Var_TipoPrepago     CHAR(1);
#SEGUROS -------------------------------------------------------------------------------
DECLARE Var_CobraSeguroCuota CHAR(1);			-- Cobra Seguro por cuota
DECLARE Var_CobraIVASeguroCuota CHAR(1);		-- Cobra IVA seguro por cuota
DECLARE Var_MontoSeguroCuota DECIMAL(12,2);		-- Cobra seguro por cuota el credito
DECLARE Var_FechaCobroComision DATE;			-- Fecha de cobro de la comision por apertura

-- de variables para CURSOR
DECLARE Var_Solictud		INT(11);
DECLARE Var_Cliente			INT(11);
DECLARE Var_Producto		INT(11);
DECLARE Var_Monto			DECIMAL(12,2);
DECLARE Var_Moneda			INT(11);
DECLARE Var_FacMora 		DECIMAL(12,2);
DECLARE Var_CalcInter		INT(11);
DECLARE Var_TasaFija		DECIMAL(12,4);
DECLARE Var_TasaBase		DECIMAL(12,4);
DECLARE Var_SobreTasa		DECIMAL(12,4);
DECLARE Var_PisoTasa		DECIMAL(12,4);
DECLARE Var_TechTasa		DECIMAL(12,4);
DECLARE Var_FrecCap			CHAR(1);
DECLARE Var_PeriodCap		INT(11);
DECLARE Var_FrecInter		CHAR(1);
DECLARE Var_PeriodInt		INT(11);
DECLARE Var_TipoPagCap		CHAR(1);
DECLARE Var_NumAmorti		INT(11);
DECLARE Var_EstSolici		CHAR(1);
DECLARE Var_FechInha		CHAR(1);
DECLARE Var_CalIrreg		CHAR(1);
DECLARE Var_DiaPagIn		CHAR(1);
DECLARE Var_DiaPagCap		CHAR(1);
DECLARE Var_DiaMesIn		INT(11);
DECLARE Var_DiaMesCap		INT(11);
DECLARE Var_AjFeUlVA		CHAR(1);
DECLARE Var_AjFecExV		CHAR(1);
DECLARE Var_NumTrSim		BIGINT(20);
DECLARE Var_TipoFond		CHAR(1);
DECLARE Var_MonComA			DECIMAL(12,4);
DECLARE Var_IVAComA			DECIMAL(12,4);
DECLARE Var_CAT				DECIMAL(12,4);
DECLARE Var_Plazo			VARCHAR(20);
DECLARE Var_TipoDisper		CHAR(1);
DECLARE Var_DestCred		INT(11);
DECLARE Var_TipoCalIn		INT(11);
DECLARE Var_InstutFond		INT(11);
DECLARE Var_LineaFon		INT(11);
DECLARE Var_NumAmoInt		INT(11);
DECLARE Var_MonedaSol		INT(11);
DECLARE Var_AporteCte   	DECIMAL(14,2);
DECLARE Var_MonSegVida  	DECIMAL(14,2);
DECLARE Var_ClasiDestinCred	CHAR(1);

DECLARE Fecha_Sis			DATE;
DECLARE Error_Key			INT;
DECLARE NumDias				INT;

DECLARE Var_ForCobroSegVida	CHAR(1);
DECLARE Var_DescSeguro		DECIMAL(12,2);
DECLARE Var_MontoSegOri		DECIMAL(12,2);
DECLARE Var_EstatusCiclo	CHAR(1);

DECLARE Var_CuentaCLABE		CHAR(18);
DECLARE Var_TipoConsultaSIC	CHAR(2);
DECLARE Var_FolioConsultaBC	VARCHAR(30);
DECLARE Var_FolioConsultaCC VARCHAR(30);

DECLARE Var_CobraAccesorios	CHAR(1);					-- Indica si la solicitud cobra accesorios
DECLARE Var_CobraAccesoriosGen	CHAR(1);				-- Valor del Cobro de Accesorios
DECLARE Var_NumRegistrosFin	INT(11);					-- Numero de Accesorios que son cobrados de manera financiada

-- Declaracion de Constantes
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cer			DECIMAL(14,4);
DECLARE Fecha_Vacia			DATE;

DECLARE TipoTranAltaCre		INT;
DECLARE TipoTranAutCre  	INT;
DECLARE TipoTranPagaCre 	INT;
DECLARE TipoTranDesCre 	 	INT;
DECLARE Str_NO				CHAR(1);
DECLARE ValorSI				CHAR(1);
DECLARE Estatus_Activo		CHAR(1);
DECLARE Estatus_Autori		CHAR(1);
DECLARE SalidaSI        	CHAR(1);
DECLARE SalidaNO        	CHAR(1);
DECLARE EstCerrGrup     	CHAR(1);
DECLARE TasFija         	INT;
DECLARE TasBasCuPu      	INT;
DECLARE TBasCuPuPisTec 		INT;
DECLARE PagCrecientes   	CHAR(1);
DECLARE PagIguales      	CHAR(1);
DECLARE TipoCalIntGlo   	INT;
DECLARE Act_AutorCred   	INT;
DECLARE TipVal_Grupal   	INT(11);
DECLARE Cla_RevMesaControl  INT(11);
DECLARE No_Asignado         CHAR(1);
DECLARE Si_Asignado         CHAR(1);
DECLARE AplicaMesa          CHAR(1);
DECLARE AplicaAmbos         CHAR(1);
DECLARE AplicaGrupo         CHAR(1);
DECLARE TipoCredito			CHAR(1);
DECLARE OperaPagare			INT(11);			-- Indica que la transacción viene desde el pagaré
DECLARE Llave_CobraAccesorios	VARCHAR(100); 	-- Llave para consulta el valor de Cobro de Accesorios
DECLARE FormaFinanciada		CHAR(1); 			-- Forma Cobro Financiada

-- *
-- Declaracion del CURSOR Para Alta de Creditos: En base al Grupo
DECLARE CURSORALTACRED CURSOR FOR
    SELECT  Sol.SolicitudCreditoID, Sol.ClienteID,          Sol.ProductoCreditoID,  Sol.MontoAutorizado,
            Sol.MonedaID,           Sol.FactorMora,         Sol.CalcInteresID,      Sol.TasaFija,
            Sol.TasaBase,           Sol.SobreTasa,          Sol.PisoTasa,           Sol.TechoTasa,
            Sol.FrecuenciaCap,      Sol.PeriodicidadCap,    Sol.FrecuenciaInt,      Sol.PeriodicidadInt,
            Sol.TipoPagoCapital,    Sol.NumAmortizacion,    Sol.FechaInhabil,       Sol.CalendIrregular,
            Sol.DiaPagoInteres,     Sol.DiaPagoCapital,     Sol.DiaMesInteres,      Sol.DiaMesCapital,
            Sol.AjusFecUlVenAmo,    Sol.AjusFecExiVen,      Sol.NumTransacSim,		Sol.TipoFondeo,
            Sol.MontoPorComAper,    Sol.IVAComAper,         Sol.ValorCAT,           Sol.PlazoID,
            Sol.TipoDispersion,     Sol.CuentaCLABE,		Sol.DestinoCreID,       Sol.TipoCalInteres,
			Sol.InstitFondeoID,		Sol.LineaFondeo,        Sol.NumAmortInteres,    Sol.Estatus,
			Sol.MonedaID,			Sol.AporteCliente,      Sol.MontoSeguroVida,	Sol.ClasiDestinCred,
			Sol.ForCobroSegVida,	Sol.DescuentoSeguro,	Sol.MontoSegOriginal,   Sol.CobraSeguroCuota,
			Sol.CobraIVASeguroCuota,Sol.MontoSeguroCuota,	Sol.TipoConsultaSIC,	Sol.FolioConsultaBC,
            Sol.FolioConsultaCC,	Sol.CobraAccesorios

		FROM	INTEGRAGRUPOSCRE	Inte,
				GRUPOSCREDITO		Gru,
				SOLICITUDCREDITO	Sol
			WHERE Inte.GrupoID = Gru.GrupoID
			  AND Inte.GrupoID = Par_Grupo
			  AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.Estatus = Estatus_Autori
			  AND Inte.Estatus = Estatus_Activo
			  AND Gru.EstatusCiclo = EstCerrGrup;


-- Declaracion del CURSOR de autorizacion de credito grupal
DECLARE CURSORAUTOCRED CURSOR FOR

	SELECT	Cre.SolicitudCreditoID,		Cre.CreditoID,		Cre.MontoCredito,		Cre.TasaFija,			Cre.PeriodicidadCap,
			Cre.PeriodicidadInt,		Cre.FrecuenciaCap,	Cre.FrecuenciaInt,		Cre.DiaPagoCapital,		Cre.DiaPagoInteres,
			Cre.DiaMesCapital,			Cre.DiaMesInteres,	Cre.FechaInicio,		Cre.FechaVencimien,		Cre.ProductoCreditoID,
			Cre.ClienteID,				Cre.FechaInhabil,	Cre.AjusFecUlVenAmo,	Cre.AjusFecExiVen,		Cre.MontoComApert,
			Cre.NumTransacSim
		FROM	INTEGRAGRUPOSCRE	Inte,
			GRUPOSCREDITO		Gru,
			SOLICITUDCREDITO		Sol,
			CREDITOS				Cre
			WHERE Inte.GrupoID 			= Gru.GrupoID
			AND Inte.GrupoID 			= Par_Grupo
			AND Inte.SolicitudCreditoID	= Sol.SolicitudCreditoID
			AND Sol.SolicitudCreditoID		= Cre.SolicitudCreditoID
			AND Gru.EstatusCiclo 		= EstCerrGrup;


-- Declaracion del CURSOR de pagare de credito grupal
DECLARE CURSORPAGACRED CURSOR FOR

	SELECT	Cre.SolicitudCreditoID,		Cre.CreditoID,		Cre.MontoCredito,		Cre.TasaFija,			Cre.PeriodicidadCap,
			Cre.PeriodicidadInt,		Cre.FrecuenciaCap,	Cre.FrecuenciaInt,		Cre.DiaPagoCapital,		Cre.DiaPagoInteres,
			Cre.DiaMesCapital,			Cre.DiaMesInteres,	Cre.FechaInicio,		Cre.FechaVencimien,		Cre.ProductoCreditoID,
			Cre.ClienteID,				Cre.FechaInhabil,	Cre.AjusFecUlVenAmo,	Cre.AjusFecExiVen,		Cre.MontoComApert,
			Cre.NumTransacSim,			Cre.CalcInteresID,	Cre.TipoPagoCapital,	Cre.NumAmortInteres
		FROM	INTEGRAGRUPOSCRE	Inte,
			GRUPOSCREDITO		Gru,
			SOLICITUDCREDITO	Sol,
			CREDITOS			Cre
			WHERE Inte.GrupoID			= Gru.GrupoID
			AND Inte.GrupoID			= Par_Grupo
			AND Inte.SolicitudCreditoID	= Sol.SolicitudCreditoID
			AND Sol.SolicitudCreditoID	= Cre.SolicitudCreditoID
			AND Gru.EstatusCiclo		= EstCerrGrup;


-- Asignacion de Constantes
SET Cadena_Vacia		:= '';			-- Cadena o String Vacio
SET Entero_Cero			:= 0;			-- Entero en Cero
SET Decimal_Cer			:= 0.0;			-- DECIMAL Cero
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
SET TipoTranAltaCre		:= 13;              	-- Tipo de Transacion: Alta de Creditos
SET TipoTranAutCre		:= 14;			-- Tipo de Transacion: Autorizacion de Creditos
SET TipoTranPagaCre		:= 15;			-- Tipo de Transacion: Pagare de Creditos
SET TipoTranDesCre		:= 16;			-- Tipo de Transacion: Desembolso de Creditos
SET Str_NO				:= 'N';			-- String Valor NO
SET ValorSI				:= 'S';			-- String Valor SI
SET Estatus_Activo		:= 'A';			-- Estatus de la Cuenta: Activa
SET Estatus_Autori		:= 'A';			-- Estatus de la Solicitud de Credito: Autorizada
SET SalidaSI			:= 'S';			-- El store SI Arroja una Salida
SET SalidaNO			:= 'N';			-- El store NO Arroja una Salida
SET EstCerrGrup			:= 'C';			-- Estatus del Grupo: Cerrado
SET TasFija				:= 1;			-- TasaFija
SET TasBasCuPu			:= 2;			-- TasaBase de inicio de cupon+Puntos
SET TBasCuPuPisTec		:= 3;			-- Tasa Base de inicio de cupon+Puntos, con Piso y Techo
SET PagCrecientes		:= 'C';			-- Pago de capital crecientes
SET PagIguales			:= 'I';			-- Pago de capital iguales
SET TipoCalIntGlo		:= 2;			-- Tipo calculo interes  Monto Original (Saldos Globales)
SET Act_AutorCred		:= 1;			-- Tipo de Actualiazcion en Credito: Autorizacion
SET TipVal_Grupal		:= 2;			-- Validacion Grupal del CheckList de Creditos

-- Inicializacion
SET Par_NumErr			:= 0;			-- inicializacion de valor
SET Par_ErrMen			:= '';			-- inicializacion de valor
SET Cla_RevMesaControl  := 9998;  		-- Clasificacion de Documentos que es comentario para el de Mesa de control y que esta por DEFAULT en el sistema (no se parametriza)
SET Si_Asignado 		:= 'S';         -- El Documento SI esta Asignado
SET No_Asignado 		:= 'N';          -- El Documento NO esta Asignado
SET AplicaMesa     	 	:= 'M';          -- Documento Aplica Mesa Control
SET AplicaAmbos     	:= 'A';          -- Documento Aplica Ambos
SET AplicaGrupo     	:= 'G';           -- Documento Aplica Grupo
SET Par_PolizaID		:= (IFNULL(Par_PolizaID,Entero_Cero));
SET TipoCredito			:= 'N';			-- Tipo de credito Nuevo
SET OperaPagare			:= 1;			-- Indica que la transaccion se genera al grabar el pagare de credito
SET Llave_CobraAccesorios	:= 'CobraAccesorios'; -- Llave para Consulta si Cobra Accesorios
SET FormaFinanciada		:= 'F';			-- Forma de cobro: FINANCIADA

SET	Fecha_Sis := (SELECT FechaSistema  FROM PARAMETROSSIS);
SET Var_EstatusCiclo := (SELECT IFNULL(EstatusCiclo,Cadena_Vacia)
							FROM GRUPOSCREDITO
								WHERE GrupoID = Par_Grupo);


 -- Se obtiene el valor de si se realiza el cobro de accesorios
SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

IF(IFNULL(Par_Grupo, Entero_Cero))= Entero_Cero THEN
	IF(Par_Salida =SalidaSI) THEN
		SELECT	'001' AS NumErr,
				'El Grupo esta Vacio.' AS ErrMen,
				'grupoID' AS control,
				Par_Grupo AS consecutivo;
		LEAVE TerminaStore;
	END IF;
	IF(Par_Salida =SalidaNO) THEN
		SET Par_NumErr := 1;
		SET	Par_ErrMen := 'El Grupo esta Vacio.' ;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(Var_EstatusCiclo != EstCerrGrup) THEN
	IF(Par_Salida =SalidaSI) THEN
		SELECT  '002' AS NumErr,
				'El Grupo debe estar Cerrado.' AS ErrMen,
				'grupoID' AS control,
				Par_Grupo AS consecutivo;
		LEAVE TerminaStore;
	END IF;
	IF(Par_Salida =SalidaNO) THEN
		SET Par_NumErr := 2;
		SET	Par_ErrMen := 'El Grupo debe estar Cerrado.' ;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(NOT EXISTS(SELECT  Cla.ClasificaTipDocID,	Cla.ClasificaDesc,
			CASE WHEN IFNULL(Sol.ClasificaTipDocID, Entero_Cero) = Entero_Cero THEN No_Asignado
				ELSE Si_Asignado
                END	AS Asignado, Cla.ClasificaTipo, Cla.TipoGrupInd, Sol.ProducCreditoID
            FROM CLASIFICATIPDOC Cla
            LEFT OUTER JOIN SOLICIDOCREQ AS Sol ON  Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
			LEFT OUTER JOIN PRODUCTOSCREDITO Prod ON Prod.ProducCreditoID=Sol.ProducCreditoID
			LEFT OUTER JOIN  SOLICITUDCREDITO Sl ON Sl.ProductoCreditoID = Sol.ProducCreditoID
			LEFT OUTER JOIN GRUPOSCREDITO  Gpo ON Gpo.GrupoID=Sl.GrupoID
            WHERE Cla.ClasificaTipDocID <> Cla_RevMesaControl
				AND Cla.ClasificaTipo IN(AplicaAmbos,AplicaMesa)
				AND Cla.TipoGrupInd IN(AplicaAmbos,AplicaGrupo)
				AND Sl.GrupoID=Par_Grupo
				LIMIT 1)) THEN
		IF(Par_Salida =SalidaSI) THEN
				SELECT  '010' AS NumErr,
				'El Producto de Credito No tiene Documentos Parametrizados para Mesa de Control.' AS ErrMen,
					'grupoID' AS control,
					Par_Grupo AS consecutivo;
			LEAVE TerminaStore;
		END IF;
		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 10;
			SET	Par_ErrMen := 'El Producto de Credito No tiene Documentos Parametrizados para Mesa de Control.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;

IF(Par_TipoTran = TipoTranAltaCre) THEN
	OPEN CURSORALTACRED;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOALTA: LOOP

			FETCH CURSORALTACRED INTO
				Var_Solictud,			Var_Cliente,			Var_Producto,			Var_Monto,					Var_Moneda,
				Var_FacMora,    		Var_CalcInter,			Var_TasaFija,			Var_TasaBase,				Var_SobreTasa,
				Var_PisoTasa,			Var_TechTasa,			Var_FrecCap,			Var_PeriodCap,  			Var_FrecInter,
				Var_PeriodInt,			Var_TipoPagCap, 		Var_NumAmorti,  		Var_FechInha,   			Var_CalIrreg,
				Var_DiaPagIn,			Var_DiaPagCap,			Var_DiaMesIn,   		Var_DiaMesCap,				Var_AjFeUlVA,
				Var_AjFecExV,			Var_NumTrSim,			Var_TipoFond,   		Var_MonComA,    			Var_IVAComA,
				Var_CAT,				Var_Plazo,				Var_TipoDisper, 		Var_CuentaCLABE,			Var_DestCred,
				Var_TipoCalIn,			Var_InstutFond,			Var_LineaFon,			Var_NumAmoInt,  			Var_EstSolici,
				Var_MonedaSol,			Var_AporteCte,  		Var_MonSegVida, 		Var_ClasiDestinCred,		Var_ForCobroSegVida,
				Var_DescSeguro,			Var_MontoSegOri, 		Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota, 	Var_MontoSeguroCuota,
                Var_TipoConsultaSIC,	Var_FolioConsultaBC,	Var_FolioConsultaCC,	Var_CobraAccesorios;


			SET Error_Key   := Entero_Cero;
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := Cadena_Vacia;

			-- Valida si la solicitud de credito esta autorizada
			IF(Var_EstSolici != Estatus_Activo) THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'La Solicitud no Esta Autorizada.' ;
				LEAVE CICLOALTA;
			END IF;

			-- Inicalizacion
			SET Var_CalcInter	:= (IFNULL(Var_CalcInter,Entero_Cero));
			SET Var_TasaFija	:= (IFNULL(Var_TasaFija,Decimal_Cer));
			SET Var_FrecCap		:= (IFNULL(Var_FrecCap,Cadena_Vacia));
			SET Var_PeriodCap	:= (IFNULL(Var_PeriodCap,Entero_Cero));
			SET Var_FrecInter	:= (IFNULL(Var_FrecInter,Cadena_Vacia));
			SET Var_PeriodInt	:= (IFNULL(Var_PeriodInt,Entero_Cero));
			SET Var_TipoPagCap	:= (IFNULL(Var_TipoPagCap,Cadena_Vacia));
			SET Var_FechInha	:= (IFNULL(Var_FechInha,Cadena_Vacia));
			SET Var_DiaPagIn	:= (IFNULL(Var_DiaPagIn,Cadena_Vacia));
			SET Var_DiaMesIn	:= (IFNULL(Var_DiaMesIn,Entero_Cero));
			SET Var_DiaMesCap	:= (IFNULL(Var_DiaMesCap,Entero_Cero));
			SET Var_AjFeUlVA	:= (IFNULL(Var_AjFeUlVA,Cadena_Vacia));
			SET Var_AjFecExV	:= (IFNULL(Var_AjFecExV,Cadena_Vacia));
			SET Var_TipoCalIn	:= (IFNULL(Var_TipoCalIn,Entero_Cero));
			#SEGUROS
			SET Var_CobraSeguroCuota 	:= IFNULL(Var_CobraSeguroCuota, 'N');
			SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
			SET Var_MontoSeguroCuota 	:= IFNULL(Var_MontoSeguroCuota, Entero_Cero);

            SET Var_TipoConsultaSIC := IFNULL(Var_TipoConsultaSIC,Cadena_Vacia);
			SET Var_FolioConsultaBC := IFNULL(Var_FolioConsultaBC,Cadena_Vacia);
			SET Var_FolioConsultaCC := IFNULL(Var_FolioConsultaCC,Cadena_Vacia);
            SET Var_CobraAccesorios := IFNULL(Var_CobraAccesorios,Cadena_Vacia);


			IF(Var_TasaFija =Decimal_Cer )THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'La Tasa esta vacia.'  ;
				LEAVE CICLOALTA;
			END IF;

			IF(Var_CalcInter =Entero_Cero )THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'El Calculo de Interes esta vacio.'   ;
				LEAVE CICLOALTA;
			END IF;

			IF(Var_TipoPagCap =Cadena_Vacia )THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'El Tipo de pago esta vacio.';
				LEAVE CICLOALTA;
			END IF;

			IF(Var_FrecCap =Cadena_Vacia )THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'La Frecuencia de Capital.'  ;
				LEAVE CICLOALTA;
			END IF;

			IF(Var_PeriodCap = Entero_Cero)THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'La Periodicidad de Capital esta vacia.'   ;
				LEAVE CICLOALTA;
			END IF;

				-- Obtiene la cuenta principal del cliente
			SET Var_Cuenta := (SELECT CuentaAhoID
									FROM CUENTASAHO
									WHERE ClienteID	= Var_Cliente
									  AND EsPrincipal 	= ValorSI
									  AND Estatus		= Estatus_Activo   LIMIT 1 );

			SET Var_Cuenta = IFNULL(Var_Cuenta, Entero_Cero);

			IF(Var_Cuenta = Entero_Cero) THEN
				SET Par_NumErr := 7;
				SET	Par_ErrMen := CONCAT('El Cliente ', CONVERT(Var_Cliente, CHAR),
								  ' No Tiene una Cuenta Principal o no Esta Autorizada.');
				LEAVE CICLOALTA;
			END IF;
			IF(Var_NumAmorti = Entero_Cero)THEN
				SET	Par_NumErr := 8;
				SET	Par_ErrMen := 'Numero de Cuotas Vacio.';
				LEAVE CICLOALTA;
			END IF;

			SET Par_NumTrans	:= Entero_Cero;
			SET Par_Cuotas		:= Entero_Cero;
			SET Par_CuotasInt	:= Entero_Cero;
			SET Par_CAT			:= Entero_Cero;
			SET Par_MontoCuo	:= Entero_Cero;

            # SE OBTIENEN LOS ACCESORIOS QUE COBRA EL CREDITO
            IF(Var_CobraAccesorios = ValorSI AND Var_CobraAccesoriosGen = ValorSI) THEN

				# SE DAN DE ALTA LOS ACCESORIOS COBRADOS POR EL CREDITO PARA GRABARLOS DEFINITIVAMENTE
				CALL DETALLEACCESORIOSALT(
					Entero_Cero,		Var_Solictud, 		Var_Producto,			Var_Cliente,		Aud_NumTransaccion,
                    Var_Plazo, 			OperaPagare,		Var_Monto,				Entero_Cero,		SalidaNO,
                    Par_NumErr, 		Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
                    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLOALTA;
					END IF;
			END IF;


			-- inicia la simulacion de amortizaciones
			-- tasa fija pagos crecientes
			IF(Var_CalcInter = TasFija ) THEN
				IF(Var_TipoPagCap = PagCrecientes )THEN
					CALL CREPAGCRECAMORPRO (
						Entero_Cero,
						Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_FrecCap,		Var_DiaPagCap,
						Var_DiaMesCap,			Fecha_Sis,					Var_NumAmorti,			Var_Producto,   	Var_Cliente,
						Var_FechInha,			Var_AjFeUlVA,				Var_AjFecExV,			Var_MonComA,  		Var_AporteCte,
						Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,		SalidaNO,
                        Par_NumErr,				Par_ErrMen,					Par_NumTrans,			Par_Cuotas,   		Par_CAT,
                        Par_MontoCuo,			Par_FechaVen,				Par_EmpresaID,			Aud_Usuario,   		Aud_FechaActual,
                        Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLOALTA;
					END IF;
				END IF;

				 -- tasa fija pagos iguales
				IF(Var_TipoPagCap = PagIguales )THEN
					CALL CREPAGIGUAMORPRO (
						Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_PeriodInt,		Var_FrecCap,
						Var_FrecInter,			Var_DiaPagCap, 				Var_DiaPagIn,			Fecha_Sis,			Var_NumAmorti,
						Var_NumAmoInt,			Var_Producto,   			Var_Cliente,			Var_FechInha,		Var_AjFeUlVA,
						Var_AjFecExV,			Var_DiaMesIn,   			Var_DiaMesCap,			Var_MonComA,		Var_AporteCte,
						Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,		SalidaNO,
                        Par_NumErr,				Par_ErrMen,      			Par_NumTrans,			Par_Cuotas,			Par_CuotasInt,
                        Par_CAT,				Par_MontoCuo,  				Par_FechaVen,			Par_EmpresaID,		Aud_Usuario,
                        Aud_FechaActual,    	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLOALTA;
					END IF;
				END IF;
			END IF;

			-- tasa variable pagos iguales
			IF(Var_CalcInter != TasFija ) THEN
				IF(Var_TipoPagCap = PagIguales )THEN

					CALL CREPAGIGUAMORPRO (
						Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_PeriodInt,		Var_FrecCap,
						Var_FrecInter,			Var_DiaPagCap, 				Var_DiaPagIn,			Fecha_Sis,			Var_NumAmorti,
						Var_NumAmoInt,			Var_Producto,   			Var_Cliente,			Var_FechInha,		Var_AjFeUlVA,
						Var_AjFecExV,			Var_DiaMesIn,   			Var_DiaMesCap,			Var_MonComA,		Var_AporteCte,
						Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,		SalidaNO,
                        Par_NumErr,				Par_ErrMen,      			Par_NumTrans,			Par_Cuotas,			Par_CuotasInt,
                        Par_CAT,				Par_MontoCuo,  				Par_FechaVen,			Par_EmpresaID,		Aud_Usuario,
                        Aud_FechaActual,    	Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLOALTA;
					END IF;
				END IF;
			END IF;

			IF(Var_TipoCalIn = TipoCalIntGlo) THEN

				DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTrans;

                CALL CRESIMSALGLOPRO (
					Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_FrecCap,		Var_DiaPagCap,
					Var_DiaMesCap,			Fecha_Sis,					Var_NumAmorti,			Var_Producto,   	Var_Cliente,
					Var_FechInha,			Var_AjFeUlVA,				Var_AjFecExV,			Var_MonComA,  		Var_AporteCte,
					Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Entero_Cero,		SalidaNO,
                    Par_NumErr,				Par_ErrMen,					Par_NumTrans,			Par_Cuotas,			Par_CAT,
                    Par_MontoCuo,			Par_FechaVen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
                    Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,   		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE CICLOALTA;
				END IF;
			END IF;

			IF(Par_Cuotas = Entero_Cero AND Par_NumTrans = Entero_Cero) THEN
				SET Par_NumErr := 8;
				SET	Par_ErrMen := 'Error al Simular Amortizaciones' ;
				LEAVE CICLOALTA;
			END IF;

			-- Veifica que el simulador no devuelva error y da de alta el credito
			IF(Par_NumErr = Entero_Cero AND Par_NumTrans != Entero_Cero) THEN
       SET Var_TipoPrepago := ( SELECT TipoPrepago
                                    FROM PRODUCTOSCREDITO
                                     WHERE ProducCreditoID=Var_Producto);

				SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Fecha_Sis,Var_PeriodCap));
				SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Par_EmpresaID));


				CALL CREDITOSALT (
                Var_Cliente,        	Entero_Cero,        	Var_Producto,       Var_Cuenta,    			TipoCredito,
				Entero_Cero, 			Var_Solictud,       	Var_Monto,          Var_MonedaSol,      	Fecha_Sis,
				Par_FechaVen,  			Var_FacMora,        	Var_CalcInter,      Var_TasaBase,       	Var_TasaFija,
				Var_SobreTasa, 	 		Var_PisoTasa,       	Var_TechTasa,       Var_FrecCap,        	Var_PeriodCap,
				Var_FrecInter,  		Var_PeriodInt,      	Var_TipoPagCap,     Var_NumAmorti,      	Var_FechInha,
				Var_CalIrreg, 			Var_DiaPagIn,       	Var_DiaPagCap,      Var_DiaMesIn,       	Var_DiaMesCap,
				Var_AjFeUlVA, 			Var_AjFecExV,       	Par_NumTrans,       Var_TipoFond,       	Var_MonComA,
				Var_IVAComA, 	 		Par_CAT,            	Var_Plazo,          Var_TipoDisper,     	Var_CuentaCLABE,
				Var_TipoCalIn,      	Var_DestCred,       	Var_InstutFond,     Var_LineaFon,       	Var_NumAmoInt,
				Par_MontoCuo,       	Var_MonSegVida,     	Var_AporteCte,      Var_ClasiDestinCred, 	Var_TipoPrepago,
				Fecha_Sis, 				Var_ForCobroSegVida, 	Var_DescSeguro,		Var_MontoSegOri,		Var_TipoConsultaSIC,
                Var_FolioConsultaBC,	Var_FolioConsultaCC,	Var_FechaCobroComision,	Cadena_Vacia,		SalidaNO,
                Var_CreditoVacio,   	Par_NumErr,             Par_ErrMen,         	Par_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,     	Aud_Sucursal,      	Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE CICLOALTA;
				END IF;
			END IF;

			DELETE FROM TMPPAGAMORSIM
				WHERE NumTransaccion    = Par_NumTrans;

				IF(Var_CobraAccesorios = ValorSI AND Var_CobraAccesoriosGen = ValorSI) THEN
					SET Var_NumRegistrosFin := (SELECT COUNT(*) FROM DETALLEACCESORIOS
												WHERE NumTransacSim = Par_NumTrans
													AND TipoFormaCobro = FormaFinanciada);

					SET Var_NumRegistrosFin := IFNULL(Var_NumRegistrosFin, Entero_Cero);

                    IF(Var_NumRegistrosFin > Entero_Cero) THEN
						# SE ELIMINAN LAS AMORTIZACIONES QUE SE CREARON EN LA SIMULACION DE CREDITO
						CALL DETALLEACCESORIOSBAJ(
							Par_NumTrans,		SalidaNO,			Par_NumErr, 		Par_ErrMen, 		Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLOALTA;
					END IF;
				END IF;

				END IF;

			END LOOP CICLOALTA;
		END;
	CLOSE CURSORALTACRED;

    -- Verificamos si el CURSOR Termino con Exito
    IF(Par_NumErr != Entero_Cero) THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT Par_NumErr AS NumErr,
                   Par_ErrMen  AS ErrMen,
                   'grupoID'  AS control,
                   Par_Grupo AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    SET Par_ErrMen := CONCAT("Creditos del Grupo: ", CONVERT(Par_Grupo, CHAR)," Agregados con Exito.");

    IF(Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
                Par_ErrMen AS ErrMen,
                'grupoID' AS control,
                Par_Grupo AS consecutivo;
    END IF;

END IF; -- Fin Alta de Credito Grupal

-- Autorizacion de credito grupal

 IF(Par_TipoTran = TipoTranAutCre) THEN
    SET CheckComple := Cadena_Vacia;

    -- validar que tenga el checklist de Creditos completo
    CALL CREDITODOCENTVAL(	Entero_Cero,		Par_Grupo,		TipVal_Grupal,		CheckComple,		SalidaNO,
							Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

    IF Par_NumErr > Entero_Cero THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT  '003' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'grupoID' AS control,
                    Par_Grupo AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;


    IF CheckComple = Str_NO THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT  '004' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'grupoID' AS control,
                    Par_Grupo AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

	OPEN CURSORAUTOCRED;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOAUTORIZA: LOOP

			FETCH CURSORAUTOCRED INTO
				Var_Solictud,	Var_Credito,	Var_Monto,		Var_TasaFija,	Var_PeriodCap,
				Var_PeriodInt,	Var_FrecCap,	Var_FrecInter,	Var_DiaPagCap,	Var_DiaPagIn,
				Var_DiaMesCap,	Var_DiaMesIn,	Var_FechaIni,	Var_FechaVenc,	Var_Producto,
				Var_Cliente,	Var_FechInha,	Var_AjFeUlVA,	Var_AjFecExV,	Var_MonComA,
				VarNumTransCre;

			SET Error_Key 	:= Entero_Cero;
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen	:= Cadena_Vacia;

			-- actualiza el credito con estatus Autorizado
			CALL CREDITOSACT(
						Var_Credito,		Entero_Cero,		Fecha_Sis,			Aud_Usuario,		Act_AutorCred,
						Var_FechaIni,		Var_FechaVenc,		Decimal_Cer,		Decimal_Cer,		Entero_Cero,
						Cadena_Vacia,		Cadena_Vacia,  		Entero_Cero,		SalidaNO,			Par_NumErr,
                        Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                        Aud_ProgramaID, 	Aud_Sucursal,  		Aud_NumTransaccion);

			-- valida si hubo errores en la actualizacion
			IF(Par_NumErr != Entero_Cero) THEN
				IF(Par_Salida =SalidaSI) THEN
					SELECT  Par_NumErr AS NumErr,
							Par_ErrMen AS ErrMen,
							'grupoID' AS control,
							Par_Grupo AS consecutivo;
					LEAVE CICLOAUTORIZA;
				END IF;
				IF(Par_Salida =SalidaNO) THEN
					SET Par_NumErr := Par_ErrMen;
					SET	Par_ErrMen := Par_ErrMen ;
					LEAVE CICLOAUTORIZA;
				END IF;
			END IF;

			END LOOP CICLOAUTORIZA;
		END;
	CLOSE CURSORAUTOCRED;

	-- Verificamos si el CURSOR Termino con Exito
    IF(Par_NumErr != Entero_Cero) THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT Par_NumErr AS NumErr,
                   Par_ErrMen  AS ErrMen,
                   'grupoID'  AS control,
                   Par_Grupo AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    SET Par_ErrMen := CONCAT("Creditos del Grupo: ", CONVERT(Par_Grupo, CHAR)," Autorizados.");

    IF(Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
                Par_ErrMen AS ErrMen,
                'grupoID' AS control,
                Par_Grupo AS consecutivo;
    END IF;

END IF; -- Fin de Autorizacion de Credito Grupal



-- pagare de credito grupal
 IF(Par_TipoTran = TipoTranPagaCre) THEN

	IF(IFNULL(Par_FechaMinis,Fecha_Vacia) < Fecha_Sis) THEN
		IF(Par_Salida =SalidaSI) THEN
			SELECT  '003' AS NumErr,
					'La Fecha de Desembolso no debe ser Inferior a la del Sistema.' AS ErrMen,
					'fechaMinistrado' AS control,
					Par_Grupo AS consecutivo;
			LEAVE TerminaStore;
		END IF;
		IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 3;
			SET	Par_ErrMen := 'La Fecha de Desembolso no debe ser Inferior a la del Sistema.' ;
			LEAVE TerminaStore;
		END IF;
	END IF;


	OPEN CURSORPAGACRED;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOPAGARE: LOOP

			FETCH CURSORPAGACRED INTO
				Var_Solictud,		Var_Credito,	Var_Monto,			Var_TasaFija,		Var_PeriodCap,
				Var_PeriodInt,		Var_FrecCap,	Var_FrecInter,		Var_DiaPagCap,		Var_DiaPagIn,
				Var_DiaMesCap,		Var_DiaMesIn,	Var_FechaIni,		Var_FechaVenc,		Var_Producto,
				Var_Cliente,		Var_FechInha,	Var_AjFeUlVA,		Var_AjFecExV,		Var_MonComA,
				VarNumTransCre,		Var_CalcInter,	Var_TipoPagCap,		Var_NumAmoInt;

			SET Error_Key		:= Entero_Cero;
			SET Par_NumTrans	:= Entero_Cero;
			SET Par_Cuotas		:= Entero_Cero;
			SET Par_ErrMen		:= Cadena_Vacia;
			SET Par_CAT			:= Entero_Cero;
			SET Par_NumErr		:= Entero_Cero;

			--  LLamada al proceso que graba las amortizaciones definitivas y actualiza el credito con las fechas
			CALL CREGENAMORTIZAPRO	(
									Var_Credito,	    Par_FechaMinis,		Par_FechaMinis,		Cadena_Vacia,       SalidaNO,
									Par_NumErr,		   	Par_ErrMen,
									Par_EmpresaID,    	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
									Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE CICLOPAGARE;
			END IF;

			END LOOP;
		END;
	CLOSE CURSORPAGACRED;

   -- Verificamos si el CURSOR Termino con Exito
    IF(Par_NumErr != Entero_Cero) THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT Par_NumErr AS NumErr,
                   Par_ErrMen  AS ErrMen,
                   'grupoID'  AS control,
                   Par_Grupo AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    SET Par_ErrMen := CONCAT("Pagare(s) del Grupo: ", CONVERT(Par_Grupo, CHAR)," Generado(s) con Exito.");

    IF(Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
                Par_ErrMen AS ErrMen,
                'grupoID' AS control,
                Par_Grupo AS consecutivo;
    END IF;
END IF;-- Fin Pagare Credito Grupal



-- Desembolso de credito grupal
IF(Par_TipoTran = TipoTranDesCre) THEN
	OPEN CURSORAUTOCRED;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLODESEMBOLSO: LOOP

			FETCH CURSORAUTOCRED INTO
				Var_Solictud,	Var_Credito,	Var_Monto,		Var_TasaFija,	Var_PeriodCap,
				Var_PeriodInt,	Var_FrecCap,	Var_FrecInter,	Var_DiaPagCap,	Var_DiaPagIn,
				Var_DiaMesCap,	Var_DiaMesIn,	Var_FechaIni,	Var_FechaVenc,	Var_Producto,
				Var_Cliente,	Var_FechInha,	Var_AjFeUlVA,	Var_AjFecExV,	Var_MonComA,
				VarNumTransCre;

			SET Error_Key 	= Entero_Cero;

			CALL MINISTRACREPRO (
					Var_Credito,	Par_PolizaID,		SalidaNO,			Par_NumErr,			Par_ErrMen,
					Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				IF(Par_Salida =SalidaSI) THEN
					SELECT  Par_NumErr AS NumErr,
							Par_ErrMen AS ErrMen,
							'grupoID' AS control,
							Par_Grupo AS consecutivo;
					LEAVE CICLODESEMBOLSO;
				END IF;
				IF(Par_Salida =SalidaNO) THEN
					SET Par_NumErr := Par_ErrMen;
					SET	Par_ErrMen := Par_ErrMen ;
					LEAVE CICLODESEMBOLSO;
				END IF;
			END IF;

			END LOOP;
		END;
	CLOSE CURSORAUTOCRED;

	-- Verificamos si el CURSOR Termino con Exito
    IF(Par_NumErr != Entero_Cero) THEN
        IF(Par_Salida = SalidaSI) THEN
            SELECT Par_NumErr AS NumErr,
                   Par_ErrMen  AS ErrMen,
                   'grupoID'  AS control,
                   Par_Grupo AS consecutivo;
        END IF;
        LEAVE TerminaStore;
    END IF;

    SET Par_ErrMen := CONCAT("Credito(s) del Grupo: ", CONVERT(Par_Grupo, CHAR)," Desembolsados(s) con Exito.");

    IF(Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
                Par_ErrMen AS ErrMen,
                'grupoID' AS control,
                Par_Grupo AS consecutivo;
    END IF;

END IF; -- Fin Desembolso Grupal


END TerminaStore$$