-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSGRUPOSAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSGRUPOSAGROALT`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSGRUPOSAGROALT`(
# =====================================================================================
# ----- STORE PARA DAR DE ALTA CREDITOS AGROPECUARIOS GRUPALES --
# =====================================================================================
	Par_GrupoID             INT(11),                -- ID del grupo

	Par_Salida              CHAR(1),                -- indica una salida
	INOUT   Par_NumErr      INT(11),                -- parametro numero de error
	INOUT   Par_ErrMen      VARCHAR(400),           -- mensaje de error

	Par_EmpresaID           INT(11),                -- parametros de auditoria
	Aud_Usuario             INT(11),                -- parametros de auditoria
	Aud_FechaActual         DATETIME ,              -- parametros de auditoria
	Aud_DireccionIP         VARCHAR(15),            -- parametros de auditoria
	Aud_ProgramaID          VARCHAR(70),            -- parametros de auditoria
	Aud_Sucursal            INT(11),                -- parametros de auditoria
	Aud_NumTransaccion      BIGINT(20)              -- parametros de auditoria
	)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_FechaSis            DATE;               -- Fecha del sistema
	DECLARE Var_CreditoID           BIGINT(12);         -- ID del credito
	DECLARE Var_EstatusC            CHAR(1);            -- Estatus del credito
	DECLARE Var_CuentaID            BIGINT(12);         -- ID de la cuenta
	DECLARE Var_ClienteID           INT(11);            -- Id del cliente
	DECLARE Var_SaldoDispo          DECIMAL(12,2);      -- Saldo disponible de la cuenta
	DECLARE Var_MontoPago           DECIMAL(12,2);      -- Monto del Pago
	DECLARE Var_Poliza              BIGINT(12);         -- Numero de Poliza
	DECLARE Var_Consecutivo         BIGINT(12);         -- Consecutivo
	DECLARE Var_TipoCredito         INT(11);            -- Tipo de Credito
	DECLARE Var_TipoPrepago         CHAR(1);            -- Tipo de prepago
	DECLARE Var_ProductoCreditoID   INT(11);            -- Producto de credito
	DECLARE Var_UsuarioID           INT(11);            -- Usuario ID
	DECLARE Var_GrupoID             INT(11);            -- ID del grupo
	DECLARE Var_EstatusCiclo        CHAR(1);            -- Estatus del ciclo actual del grupo
	DECLARE Var_NumIntegrantes      INT(11);            -- NUmero de integrantes Grupo
	DECLARE Var_Cuenta              BIGINT(12);         -- Numero de cuenta
	DECLARE Var_FechaVen            DATE;               -- Fecha de vencimiento
	DECLARE Var_ConSim              INT(11);            -- Consecutivo de simulador
	DECLARE Var_Control             VARCHAR(50);        -- Variable de control.
	DECLARE Var_Solictud            INT(11);
	DECLARE Var_Cliente             INT(11);
	DECLARE Var_Producto            INT(11);
	DECLARE Var_Monto               DECIMAL(12,2);
	DECLARE Var_Moneda              INT(11);
	DECLARE Var_FacMora             DECIMAL(12,2);
	DECLARE Var_CalcInter           INT(11);
	DECLARE Var_TasaFija            DECIMAL(12,4);
	DECLARE Var_TasaBase            DECIMAL(12,4);
	DECLARE Var_SobreTasa           DECIMAL(12,4);
	DECLARE Var_PisoTasa            DECIMAL(12,4);
	DECLARE Var_TechTasa            DECIMAL(12,4);
	DECLARE Var_FrecCap             CHAR(1);
	DECLARE Var_PeriodCap           INT(11);
	DECLARE Var_FrecInter           CHAR(1);
	DECLARE Var_PeriodInt           INT(11);
	DECLARE Var_TipoPagCap          CHAR(1);
	DECLARE Var_NumAmorti           INT(11);
	DECLARE Var_EstSolici           CHAR(1);
	DECLARE Var_FechInha            CHAR(1);
	DECLARE Var_CalIrreg            CHAR(1);
	DECLARE Var_DiaPagIn            CHAR(1);
	DECLARE Var_DiaPagCap           CHAR(1);
	DECLARE Var_DiaMesIn            INT(11);
	DECLARE Var_DiaMesCap           INT(11);
	DECLARE Var_AjFeUlVA            CHAR(1);
	DECLARE Var_AjFecExV            CHAR(1);
	DECLARE Var_NumTrSim            BIGINT(20);
	DECLARE Var_TipoFond            CHAR(1);
	DECLARE Var_MonComA             DECIMAL(12,4);
	DECLARE Var_IVAComA             DECIMAL(12,4);
	DECLARE Var_CAT                 DECIMAL(12,4);
	DECLARE Var_CATReal             DECIMAL(12,4);
	DECLARE Var_Plazo               VARCHAR(20);
	DECLARE Var_TipoDisper          CHAR(1);
	DECLARE Var_DestCred            INT(11);
	DECLARE Var_TipoCalIn           INT(11);
	DECLARE Var_InstutFond          INT(11);
	DECLARE Var_LineaFon            INT(11);
	DECLARE Var_NumAmoInt           INT(11);
	DECLARE Var_MonedaSol           INT(11);
	DECLARE Var_AporteCte           DECIMAL(14,2);
	DECLARE Var_MonSegVida          DECIMAL(14,2);
	DECLARE Var_ClasiDestinCred     CHAR(1);
	DECLARE Var_ForCobroSegVida     CHAR(1);
	DECLARE Var_DescSeguro          DECIMAL(12,2);
	DECLARE Var_MontoSegOri         DECIMAL(12,2);
	DECLARE Var_CuentaCLABE         CHAR(18);
	DECLARE Var_TipoConsultaSIC     CHAR(2);
	DECLARE Var_FolioConsultaBC     VARCHAR(30);
	DECLARE Var_FolioConsultaCC     VARCHAR(30);
	DECLARE Var_CobraSeguroCuota 	CHAR(1);			-- Cobra Seguro por cuota
	DECLARE Var_CobraIVASeguroCuota CHAR(1);		-- Cobra IVA seguro por cuota
	DECLARE Var_MontoSeguroCuota 	DECIMAL(12,2);		-- Cobra seguro por cuota el credito
	DECLARE Var_FechaCobroComision	DATE;			-- Fecha de cobro de la comision por apertura
	DECLARE Var_TasaPasiva			DECIMAL(14,4);		-- Cobra seguro por cuota el credito

	-- Declaracion de Constantes
	DECLARE Entero_Cero         INT(11);                -- entero cero
	DECLARE Entero_Uno          INT(11);                -- entero uno
	DECLARE Decimal_Cero        DECIMAL(14,2);          -- DECIMAL Cero
	DECLARE Salida_SI           CHAR(1);                -- salida SI
	DECLARE Fecha_Vacia         DATE;                   -- Fecha vacia
	DECLARE Cadena_Vacia        CHAR(1);                -- cadena vacia
	DECLARE EstatusVigente      CHAR(1);                -- Credito vigente
	DECLARE EstatusInactivo     CHAR(1);                -- Credito Vencido
	DECLARE ConstanteNo         CHAR(1);                -- Constamnte no
	DECLARE CreditoIndividual   INT(11);                -- Credito Individual
	DECLARE CreditoGrupal       INT(11);                -- Credito GRupal
	DECLARE ImprimePagare       INT(11);                -- numero de actualizacion para imprimir pagare de credito
	DECLARE AutorizaCredWS      INT(11);                -- numero de actualizacion para actualizacion de credito
	DECLARE EstatusCerrado      CHAR(1);                -- EStatus cerrado
	DECLARE EstatusActivo       CHAR(1);                -- EStatus activo
	DECLARE CerrarGrupo			INT(11);				-- Cierra el grupo
	DECLARE TipoCredito         CHAR(1);                -- Tipo de Credito Nuevo
	DECLARE Act_Credito         INT(11);                -- Actualizacion para ministra
	DECLARE Act_Solicitud		INT(11);				-- actualizacion de la solicitud
	-- Asignacion de constantes
	SET Entero_Cero         := 0;
	SET Entero_Uno          := 1;
	SET Decimal_Cero        := 0.00;
	SET Salida_SI           := 'S';
	SET Fecha_Vacia         := '1900-01-01';
	SET Cadena_Vacia        := '';
	SET EstatusVigente      := 'V';
	SET EstatusInactivo     := 'I';
	SET ConstanteNo         := 'N';
	SET CreditoIndividual   := 1;
	SET CreditoGrupal       := 2;
	SET ImprimePagare       := 2;
	SET AutorizaCredWS      := 11;
	SET EstatusCerrado      := 'C';
	SET EstatusActivo       := 'A';
	SET CerrarGrupo			:= 2;
	SET TipoCredito         := 'N';
	SET Act_Credito         := 3;
	SET Act_Solicitud		:= 2;

	ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSGRUPOSAGROALT');
			SET Var_Control := 'sqlexception';
		END;

		-- Asignamos valor a varibles
		SET Aud_FechaActual     := NOW();
		SET Var_FechaSis        := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
									WHERE EmpresaID = Par_EmpresaID);
		SET Var_Consecutivo     := Entero_Cero;
		SET Var_FechaVen        := Fecha_Vacia;
		SET Var_CATReal         := Entero_Cero;


		SELECT GrupoID INTO Var_GrupoID
			FROM GRUPOSCREDITO
		WHERE GrupoID = Par_GrupoID;

		IF(IFNULL(Var_GrupoID,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Numero de Grupo No Existe.';
			SET Var_Control:= 'grupoID';
			LEAVE ManejoErrores;
		END IF;

		-- Se inserta tabla con los valores de cada mienbro del grupo
		SET @Consecutivo:= 0;
		INSERT INTO TMPCREDITOSGRUPOSAGRO(
			SELECT  (@Consecutivo := @Consecutivo + 1),		Sol.SolicitudCreditoID,     Sol.ClienteID,          Sol.ProductoCreditoID,
					Sol.MontoAutorizado,    				Sol.MonedaID,               Sol.FactorMora,         Sol.CalcInteresID,
					Sol.TasaFija,           				Sol.TasaBase,               Sol.SobreTasa,          Sol.PisoTasa,
					Sol.TechoTasa,          				Sol.FrecuenciaCap,          Sol.PeriodicidadCap,    Sol.FrecuenciaInt,
					Sol.PeriodicidadInt,    				Sol.TipoPagoCapital,        Sol.NumAmortizacion,    Sol.FechaInhabil,
					Sol.CalendIrregular,    				Sol.DiaPagoInteres,         Sol.DiaPagoCapital,     Sol.DiaMesInteres,
					Sol.DiaMesCapital,      				Sol.AjusFecUlVenAmo,        Sol.AjusFecExiVen,      Sol.NumTransacSim,
					Sol.TipoFondeo,         				Sol.MontoPorComAper,        Sol.IVAComAper,         Sol.ValorCAT,
					Sol.PlazoID,            				Sol.TipoDispersion,         Sol.CuentaCLABE,        Sol.DestinoCreID,
					Sol.TipoCalInteres,     				Sol.InstitFondeoID,         Sol.LineaFondeo,        Sol.NumAmortInteres,
					Sol.Estatus,            				Sol.AporteCliente,          Sol.MontoSeguroVida,    Sol.ClasiDestinCred,
					Sol.ForCobroSegVida,    				Sol.DescuentoSeguro,        Sol.MontoSegOriginal,   Sol.CobraSeguroCuota,
					Sol.CobraIVASeguroCuota,				Sol.MontoSeguroCuota,       Sol.TipoConsultaSIC,    Sol.FolioConsultaBC,
					Sol.FolioConsultaCC,					Sol.GrupoID,				T.TasaPasiva,			Aud_NumTransaccion

		FROM    INTEGRAGRUPOSCRE    Inte,
				GRUPOSCREDITO       Gru,
				SOLICITUDCREDITO    Sol,
				CREDTASAPASIVAAGRO	T
			WHERE Inte.GrupoID = Gru.GrupoID
			  AND Inte.GrupoID = Par_GrupoID
			  AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND T.SolicitudCreditoID = Sol.SolicitudCreditoID
			  AND Sol.Estatus = EstatusActivo
			  AND Inte.Estatus = EstatusActivo
			  AND Gru.EstatusCiclo = EstatusCerrado);

		SET Var_NumIntegrantes := (SELECT MAX(SolicitudGrupID) FROM  TMPCREDITOSGRUPOSAGRO WHERE GrupoID = Par_GrupoID);

		IF(IFNULL(Var_NumIntegrantes,Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Grupo No Cuenta Con Solicitudes Registradas.';
			SET Var_Control:= 'grupoID';
			LEAVE ManejoErrores;
		END IF;

		-- Se realiza el ciclo para registrar el alta del credito
		WHILE  (Var_NumIntegrantes > Entero_Cero)  DO

			SELECT SolCreditoID,    ClienteID,          ProductoCred,       MontoAut,           MonedaID,
				   FacMora,         CalcInter,          TasaFija,           TasaBase,           SobreTasa,
				   PisoTasa,        TechTasa,           FrecCap,            PeriodCap,          FrecInter,
				   PeriodInt,       TipoPagCap,         NumAmorti,          FechInha,           CalIrreg,
				   DiaPagIn,        DiaPagCap,          DiaMesIn,           DiaMesCap,          AjFeUlVA,
				   AjFecExV,        NumTrSim,           TipoFond,           MonComA,            IVAComA,
				   CAT,             Plazo,              TipoDisper,         CuentaCLABE,        DestCred,
				   TipoCalIn,       InstutFond,         LineaFon,           NumAmoInt,          EstSolici,
				   AporteCte,       MonSegVida,         ClasiDestinCred,    ForCobroSegVida,    DescSeguro,
				   MontoSegOri,     CobraSegCuota,      CobraIVASegCuo,     MontoSegCuota,      TipoConsultaSIC,
				   FolioConsultaBC, FolioConsultaCC,	TasaPasiva

			INTO Var_Solictud,          Var_Cliente,            Var_Producto,               Var_Monto,                  Var_Moneda,
				Var_FacMora,            Var_CalcInter,          Var_TasaFija,               Var_TasaBase,               Var_SobreTasa,
				Var_PisoTasa,           Var_TechTasa,           Var_FrecCap,                Var_PeriodCap,              Var_FrecInter,
				Var_PeriodInt,          Var_TipoPagCap,         Var_NumAmorti,              Var_FechInha,               Var_CalIrreg,
				Var_DiaPagIn,           Var_DiaPagCap,          Var_DiaMesIn,               Var_DiaMesCap,              Var_AjFeUlVA,
				Var_AjFecExV,           Var_NumTrSim,           Var_TipoFond,               Var_MonComA,                Var_IVAComA,
				Var_CAT,                Var_Plazo,              Var_TipoDisper,             Var_CuentaCLABE,            Var_DestCred,
				Var_TipoCalIn,          Var_InstutFond,         Var_LineaFon,               Var_NumAmoInt,              Var_EstSolici,
				Var_AporteCte,          Var_MonSegVida,         Var_ClasiDestinCred,        Var_ForCobroSegVida,        Var_DescSeguro,
				Var_MontoSegOri,        Var_CobraSeguroCuota,   Var_CobraIVASeguroCuota,    Var_MontoSeguroCuota,       Var_TipoConsultaSIC,
				Var_FolioConsultaBC,    Var_FolioConsultaCC,	Var_TasaPasiva

			FROM TMPCREDITOSGRUPOSAGRO WHERE SolicitudGrupID = Var_NumIntegrantes;

			-- inicializa variables
			SET Var_CalcInter			:= (IFNULL(Var_CalcInter,Entero_Cero));
			SET Var_TasaFija			:= (IFNULL(Var_TasaFija,Decimal_Cero));
			SET Var_FrecCap				:= (IFNULL(Var_FrecCap,Cadena_Vacia));
			SET Var_PeriodCap			:= (IFNULL(Var_PeriodCap,Entero_Cero));
			SET Var_FrecInter			:= (IFNULL(Var_FrecInter,Cadena_Vacia));
			SET Var_PeriodInt			:= (IFNULL(Var_PeriodInt,Entero_Cero));
			SET Var_TipoPagCap			:= (IFNULL(Var_TipoPagCap,Cadena_Vacia));
			SET Var_FechInha			:= (IFNULL(Var_FechInha,Cadena_Vacia));
			SET Var_DiaPagIn			:= (IFNULL(Var_DiaPagIn,Cadena_Vacia));
			SET Var_DiaMesIn			:= (IFNULL(Var_DiaMesIn,Entero_Cero));
			SET Var_DiaMesCap			:= (IFNULL(Var_DiaMesCap,Entero_Cero));
			SET Var_AjFeUlVA			:= (IFNULL(Var_AjFeUlVA,Cadena_Vacia));
			SET Var_AjFecExV			:= (IFNULL(Var_AjFecExV,Cadena_Vacia));
			SET Var_TipoCalIn			:= (IFNULL(Var_TipoCalIn,Entero_Cero));
			SET Var_CobraSeguroCuota 	:= IFNULL(Var_CobraSeguroCuota, ConstanteNo);
			SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, ConstanteNo);
			SET Var_MontoSeguroCuota 	:= IFNULL(Var_MontoSeguroCuota, Entero_Cero);
			SET Var_TipoConsultaSIC 	:= IFNULL(Var_TipoConsultaSIC,Cadena_Vacia);
			SET Var_FolioConsultaBC 	:= IFNULL(Var_FolioConsultaBC,Cadena_Vacia);
			SET Var_FolioConsultaCC 	:= IFNULL(Var_FolioConsultaCC,Cadena_Vacia);

            -- Se asigna el tipo de prepago
            SET Var_TipoPrepago	:= (SELECT TipoPrepago FROM PRODUCTOSCREDITO WHERE ProducCreditoID=Var_Producto);
			SET Var_TipoPrepago := IFNULL(Var_TipoPrepago,Cadena_Vacia);

			IF(Var_TasaFija =Decimal_Cero )THEN
				SET Par_NumErr := 3;
				SET	Par_ErrMen := 'La Tasa esta vacia.'  ;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_CalcInter =Entero_Cero )THEN
				SET Par_NumErr := 4;
				SET	Par_ErrMen := 'El Calculo de Interes esta vacio.'   ;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TipoPagCap =Cadena_Vacia )THEN
				SET Par_NumErr := 5;
				SET	Par_ErrMen := 'El Tipo de pago esta vacio.';
				LEAVE ManejoErrores;
			END IF;
			-- Se obtienen valores del simulador pagos libres
			CALL PAGAMORLIBPRO(
				Var_NumTrSim,       Par_EmpresaID,      Aud_Usuario,     Aud_FechaActual,   Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			SELECT  MAX(Tmp_Consecutivo)  INTO    Var_ConSim    FROM TMPPAGAMORSIM
				WHERE NumTransaccion = Var_NumTrSim;

			-- Valor CAT
			SELECT Tmp_FecFin,     Tmp_Cat
				INTO   Var_FechaVen,   Var_CATReal
			FROM TMPPAGAMORSIM
				WHERE NumTransaccion = Var_NumTrSim
					AND Tmp_Consecutivo= Var_ConSim;

			-- Obtiene la cuenta principal del cliente
			SELECT CuentaAhoID INTO Var_Cuenta
				FROM CUENTASAHO
					WHERE ClienteID = Var_Cliente
					  AND EsPrincipal= Salida_SI
					  AND Estatus= EstatusActivo   LIMIT 1;

			IF(Var_FechaVen = Fecha_Vacia AND Var_CATReal = Entero_Cero) THEN
				SET Par_NumErr := 6;
				SET Par_ErrMen := CONCAT('Error al Simular Amortizaciones. Solicitud:',Var_Solictud) ;
				SET Var_Control:= 'grupoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSis,Var_PeriodCap));
			SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Par_EmpresaID));

			-- Se genera llamada Alta de Creditos
			CALL CREDITOSALT (
				Var_Cliente,            Entero_Cero,            Var_Producto,       	Var_Cuenta,             TipoCredito,
				Entero_Cero,            Var_Solictud,           Var_Monto,          	Var_Moneda,             Var_FechaSis,
				Var_FechaVen,           Var_FacMora,            Var_CalcInter,      	Var_TasaBase,           Var_TasaFija,
				Var_SobreTasa,          Var_PisoTasa,           Var_TechTasa,       	Var_FrecCap,            Var_PeriodCap,
				Var_FrecInter,          Var_PeriodInt,          Var_TipoPagCap,     	Var_NumAmorti,          Var_FechInha,
				Var_CalIrreg,           Var_DiaPagIn,           Var_DiaPagCap,      	Var_DiaMesIn,           Var_DiaMesCap,
				Var_AjFeUlVA,           Var_AjFecExV,           Var_NumTrSim,       	Var_TipoFond,           Var_MonComA,
				Var_IVAComA,            Var_CATReal,            Var_Plazo,          	Var_TipoDisper,         Var_CuentaCLABE,
				Var_TipoCalIn,          Var_DestCred,           Var_InstutFond,     	Var_LineaFon,           Var_NumAmoInt,
				Decimal_Cero,           Var_MonSegVida,         Var_AporteCte,      	Var_ClasiDestinCred,    Var_TipoPrepago,
				Var_FechaSis,           Var_ForCobroSegVida,    Var_DescSeguro,     	Var_MontoSegOri,        Var_TipoConsultaSIC,
				Var_FolioConsultaBC,    Var_FolioConsultaCC,    Var_FechaCobroComision,	Cadena_Vacia,			ConstanteNo,
				Var_CreditoID,          Par_NumErr,             Par_ErrMen,             Par_EmpresaID,          Aud_Usuario,
				Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se genera llamada a ministra para actuzlizar
			CALL MINISTRACREDAGROACT(
				Aud_NumTransaccion,     Entero_Cero,        Var_Solictud,       Var_CreditoID,      Var_Cliente,
				Entero_Cero,            Fecha_Vacia,        Decimal_Cero,       Fecha_Vacia,        Cadena_Vacia,
				Entero_Cero,           	Fecha_Vacia,        Cadena_Vacia,       Cadena_Vacia,		Act_Credito,
				ConstanteNo,			Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se manda a llamar SP de actualizacion
			CALL SOLICITUDCREDITOAGROACT(
				Act_Solicitud,		Var_Solictud,		Entero_Cero,		Entero_Cero,		Entero_Cero,
				Entero_Cero,		Entero_Cero,		Cadena_Vacia,		Entero_Cero,		Decimal_Cero,
				Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Entero_Cero,
				Cadena_Vacia,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Var_TasaPasiva,
				Entero_Cero,		Entero_Cero,
				ConstanteNo,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_Solictud         := Entero_Cero;
			SET Var_CreditoID        := Entero_Cero;
			SET Var_NumTrSim         := Entero_Cero;
			SET Var_FechaVen         := Fecha_Vacia;
			SET Var_CATReal          := Entero_Cero;
			SET Var_NumIntegrantes   := Var_NumIntegrantes - Entero_Uno;

		END WHILE;

		SET Par_NumErr      := Entero_Cero;
		SET Par_ErrMen      := CONCAT('Creditos Registrados Exitosamente, Grupo: ',Var_GrupoID);
		SET Var_Consecutivo := Var_GrupoID;
		SET Var_Control     := 'grupoID';


END ManejoErrores;

	-- Se eliminan los registros de la tabla temporal
	DELETE FROM TMPCREDITOSGRUPOSAGRO WHERE NumTransaccion = Aud_NumTransaccion;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr          AS NumErr,
			Par_ErrMen          AS ErrMen,
			Var_Control         AS control,
			Var_Consecutivo     AS consecutivo;

	END IF;

END TerminaStore$$