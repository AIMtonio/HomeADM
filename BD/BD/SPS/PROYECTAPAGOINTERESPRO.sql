-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCALMONTOLIQ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROYECTAPAGOINTERESPRO`;
DELIMITER $$

CREATE PROCEDURE `PROYECTAPAGOINTERESPRO`(
/** ==================================================================================
 ** -- CALCULAR EL MONTO A LIQUIDAR DEL CREDITO A LA FECHA INTRODUCIDA --
 ** ==================================================================================
 */
	Par_CreditoID			BIGINT(12),		-- Credito ID
	Par_FechaProyecta		DATE,			-- Fecha capturada en la pantalla carta deliquidacin
    INOUT Par_MontoTotal	DECIMAL(16,2),	-- Saldo de liquidacion proyectado del credito,
    Par_MontoProyectado		DECIMAL(16,2),	-- Monto limite proyectado en el alta de la carta de liquidacion
    Par_DevengaInteres		CHAR(1),		-- Indica se se realizan los devengos de proyeccion de interes y mora
    Par_PolizaID			BIGINT,			-- Numero de Poliza

    Par_Salida				CHAR(1),			-- Salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),			-- Empresa ID
	Aud_Usuario				INT(11),			-- Campo Auditoria
	Aud_FechaActual			DATETIME,			-- Campo Auditoria

	Aud_DireccionIP			VARCHAR(15),		-- Campo Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Campo Auditoria
	Aud_Sucursal			INT(11),			-- Campo Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Campo Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Varibles
	DECLARE Var_InteresCalculado		DECIMAL(18,4);			-- Interés generado.
	DECLARE Var_InteresProdCre			INT(11);				-- Tipo de Cálculo (interés o retención).
	DECLARE Var_MaxAmorti				INT;					-- La ultima amortizacion Pagada
	DECLARE Var_FechaInicio				DATE;					-- Fecha a comenzar a contar para el calculo de interes
	DECLARE Var_DiasTrans				INT;					-- Días transcurridos
	DECLARE Var_CapitalPorPAgar			DECIMAL(18,2);			-- Capital por pagar
	DECLARE Var_CliPagIVA				CHAR(1);				-- Indica si el cliente paga IVA
	DECLARE Var_SucCredito				INT(11);				-- Sucursal del credito
	DECLARE Var_IVAIntOrd				CHAR(1);				-- Total del IVA de interes ordinario
	DECLARE Var_IVAIntMor				CHAR(1);				-- IVA del interes moratorio
	DECLARE Var_ProyInPagAde			CHAR(1);				-- proyeccion de interes
	DECLARE Var_TipCobComMor			CHAR(1);				-- Tipo de cobro de interes moratorio
	DECLARE Var_CalcInteres				INT(11);				-- ID de calculo de intereses
	DECLARE Var_FactorMora				DECIMAL(12,4);			-- factor mora del credito
	DECLARE Var_CreTasa					DECIMAL(12,4);			-- Tasa del credito
	DECLARE Var_EstatusCre				CHAR(1);				-- Estatus del credito
	DECLARE Var_ClienteID				INT(11);				-- Cliente ID
	DECLARE Var_ValorTasa				DECIMAL(12,4);			-- Valor de la tasa ordinaria
	DECLARE Var_DiasAnio				INT;					-- Dias Año del ejercicios
	DECLARE Var_Moratorios				DECIMAL(18,2);			-- Moratorios cargados al credito
	DECLARE Var_CobraIVAInt				CHAR(1);				-- Cobra IVA interes
	DECLARE Var_IVAInteres				DECIMAL(18,2);			-- Calcular IVA Interes.
	DECLARE Var_IVA						DECIMAL(12,2);			-- Valor IVA Sucursal
	DECLARE Var_CapInt					DECIMAL(18,2);			-- Capital mas interes
	DECLARE Var_IniAmortizaID			INT;
	DECLARE Var_UltAmortizaID			INT;
	DECLARE Var_FechaFinAmortiza		DATE;
	DECLARE Var_SaldoInsoluto			DECIMAL(16,2);
	DECLARE Var_FechaIniAmo				DATE;
	DECLARE Var_FechaFinAmo 			DATE;
	DECLARE Var_SaldoProvAmo			DECIMAL(16,2);
	DECLARE Var_SaldoProvInteres		DECIMAL(16,2);
	DECLARE Var_SaldoProvIVAMoraInt		DECIMAL(16,2);
	DECLARE Var_SaldoProvMoraInt		DECIMAL(16,2);
	DECLARE Var_SaldoDevMoraInt			DECIMAL(16,2);
	DECLARE Var_SaldoDevIVAMoraInt		DECIMAL(16,2);
	DECLARE Var_SaldoProvIVAInteres		DECIMAL(16,2);
	DECLARE Var_SaldoDevInteres			DECIMAL(16,2);
	DECLARE Var_SaldoDevIVAInteres		DECIMAL(16,2);
	DECLARE Var_NumProyecciones			INT;
	DECLARE Var_FechaSistema			DATE;
	DECLARE Var_InteresPactado			DECIMAL(16,2);
	DECLARE Var_CapitalMora				DECIMAL(16,2);
	DECLARE Var_CapitalAmoMora			DECIMAL(16,2);
	DECLARE Var_CapitalAmo				DECIMAL(16,2);
	DECLARE Var_MontoCredito			DECIMAL(16,2);
	DECLARE Var_MontoMoraDev			DECIMAL(16,2);
    DECLARE Var_TipoCalInteres			INT;
    DECLARE Var_DiasProyecta			INT;
    DECLARE Var_GraciaMoratorios		INT;
    DECLARE Var_CobraMora				CHAR(1);
    DECLARE Var_AmoDevMoraIni			INT;
    DECLARE Var_TipoCalInt     			INT;
    DECLARE Var_EsProducNomina			CHAR(1);					-- Si el producto de Credito es de nomina
	DECLARE Var_Interes         		DECIMAL(14,4);
	DECLARE Var_ManejaConvenio			CHAR(5);					-- MANEJA CONVENIO DE NOMINA
    DECLARE Var_FechaIniAmoReal			DATE;
	DECLARE Var_FechaFinAmoReal 		DATE;


	-- Declaracion de constantes
	DECLARE Var_ConCero					INT;					-- Cosntante 0
	DECLARE Var_ConUno					INT;					-- Constante 1
	DECLARE Var_Pagado					CHAR(1);				-- Constante P
	DECLARE Var_ConCien					INT;					-- Constante 100
	DECLARE Var_ConSI					CHAR(1);					-- Constante S
	DECLARE Aud_FechaActual				DATETIME;				-- parametros de auditoria
    DECLARE Tipo_Global					INT;
    DECLARE Salida_NO					CHAR(1);


	-- Asignación de constantes
	SET	Var_ConCero						:= 0;					-- Cosntante 0
	SET	Var_ConUno						:= 1;					-- Cosntante 1
	SET	Var_Pagado						:= 'P';					-- Cosntante P
	SET	Var_ConCien						:= 100;					-- Cosntante 100
	SET	Var_ConSI						:= 'S';					-- Constante S
	SET	Aud_FechaActual					:=NOW();				-- parametros de auditoria
	SET	Var_CapInt						:= 0.00;				-- Capital + interes
    SET Tipo_Global						:= 2;
    SET Salida_NO						:= 'N';

ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET	Par_NumErr	:= 999;
			SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciona. Ref: SP-PROYECTAPAGOINTERESPRO');
		END;

	SELECT	Cli.PagaIVA,			Cre.SucursalID,			Pro.CobraIVAInteres,	Pro.CobraIVAMora,	Pro.ProyInteresPagAde,
			Cre.TipCobComMorato,	Pro.CalcInteres,		Cre.FactorMora ,		Cre.TasaFija,		Cre.Estatus,
			Cre.ClienteID,			Pro.CobraIVAInteres,	Suc.IVA,				Cre.TipoCalInteres,	Cre.MontoCredito,
            Pro.CobraMora,			Pro.GraciaMoratorios,	Cre.CalcInteresID,		Pro.ProductoNomina
		INTO
			Var_CliPagIVA,			Var_SucCredito,			Var_IVAIntOrd,			Var_IVAIntMor,			Var_ProyInPagAde,
			Var_TipCobComMor,		Var_CalcInteres,		Var_FactorMora,			Var_CreTasa,			Var_EstatusCre,
			Var_ClienteID,			Var_CobraIVAInt,		Var_IVA,				Var_TipoCalInteres,		Var_MontoCredito,
            Var_CobraMora,			Var_GraciaMoratorios,	Var_TipoCalInt,			Var_EsProducNomina
	FROM CREDITOS Cre,
		 PRODUCTOSCREDITO Pro,
		 CLIENTES Cli,
		 SUCURSALES Suc
	WHERE Cre.CreditoID			= Par_CreditoID
	  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
	  AND Cre.ClienteID			= Cli.ClienteID
	  AND Cre.SucursalID		= Suc.SucursalID;

	SELECT DiasCredito,	FechaSistema
		INTO Var_DiasAnio,Var_FechaSistema
		FROM PARAMETROSSIS;

	SET Par_MontoProyectado := IFNULL(Par_MontoProyectado,0);

	SELECT MAX(AmortizacionID)
	INTO Var_UltAmortizaID
	FROM AMORTICREDITO
	WHERE  CreditoID = Par_CreditoID
	AND FechaInicio < Par_FechaProyecta
	AND Estatus IN('V','A','B');

    SELECT MAX(AmortizacionID),MIN(AmortizacionID)
	INTO Var_IniAmortizaID,Var_AmoDevMoraIni
	FROM AMORTICREDITO
	WHERE  CreditoID = Par_CreditoID
    AND FechaInicio <= Var_FechaSistema
	AND Estatus IN('V','A','B');

    SELECT ValorParametro INTO Var_ManejaConvenio
	FROM PARAMGENERALES
	WHERE LlaveParametro='ManejaCovenioNomina';

	-- Se obtiene el capital pendiente por pagar

	SET Var_CapitalPorPAgar := FUNCIONCONFINIQCRE(Par_CreditoID);
	SET Par_MontoProyectado := Par_MontoProyectado - Var_CapitalPorPAgar;


	CALL CRECALCULOTASAPRO(	Par_CreditoID,		Var_CalcInteres,	Var_CreTasa,	Par_FechaProyecta,			Var_FechaInicio,
							Aud_EmpresaID,		Var_ValorTasa,		Aud_Usuario,	Aud_FechaActual,			Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SET Var_UltAmortizaID := IFNULL(Var_UltAmortizaID,Var_ConCero);
	SET Var_IniAmortizaID := IFNULL(Var_IniAmortizaID,Var_ConCero);
	SET Var_SaldoProvInteres	:= Var_ConCero;
	SET Var_SaldoProvIVAInteres	:= Var_ConCero;

	SELECT
		   SUM(ROUND(SaldoCapVigente,2)+ROUND(SaldoCapAtrasa,2)+ROUND(SaldoCapVencido,2)+ROUND(SaldoCapVenNExi,2))
	INTO Var_CapitalMora
	FROM AMORTICREDITO
	WHERE  AmortizacionID < Var_IniAmortizaID
	AND CreditoID = Par_CreditoID
	AND Estatus IN('V','A','B');

    SET Var_SaldoProvMoraInt := Var_ConCero;
    SET Var_SaldoProvIVAMoraInt := Var_ConCero;
    SET Var_CapitalMora := IFNULL(Var_CapitalMora,Var_ConCero);

    IF Var_CobraMora = Var_ConSI THEN
		IF Var_TipCobComMor = 'N' THEN
			SET Var_FactorMora := Var_FactorMora * Var_ValorTasa;
        END IF;

		IF  Var_CapitalMora > Var_ConCero THEN
			SET Var_DiasProyecta := DATEDIFF(Par_FechaProyecta,Var_FechaSistema);

			WHILE Var_AmoDevMoraIni < Var_IniAmortizaID DO
				ProyectaMora:BEGIN

					SELECT FechaInicio,		FechaVencim,		SaldoInteresPro,		NumProyInteres,			Interes,
						   (ROUND(SaldoCapVigente,2)+ROUND(SaldoCapAtrasa,2)+ROUND(SaldoCapVencido,2)+ROUND(SaldoCapVenNExi,2))
					INTO Var_FechaIniAmo,	Var_FechaFinAmo,	Var_SaldoProvAmo,		Var_NumProyecciones,	Var_InteresPactado,
						 Var_CapitalMora
					FROM AMORTICREDITO
					WHERE AmortizacionID = Var_AmoDevMoraIni
					AND CreditoID = Par_CreditoID;

					SET Var_SaldoDevMoraInt := ROUND(Var_FactorMora*Var_CapitalMora/(Var_DiasAnio*Var_ConCien),2)*Var_DiasProyecta;
					IF(Var_IVAIntMor = Var_ConSI) THEN
						SET	Var_SaldoDevIVAMoraInt := ROUND(Var_SaldoDevMoraInt*Var_IVA,2);
					END IF;

					IF (Var_SaldoDevMoraInt+Var_SaldoDevIVAMoraInt) > Par_MontoProyectado AND Par_MontoProyectado > 0 THEN
						IF  Var_IVAIntMor = Var_ConSI THEN
							SET Var_SaldoDevMoraInt := ROUND(Par_MontoProyectado,2) - ROUND(((Par_MontoProyectado)/(1+Var_IVA)) * Var_IVA, 2);
						ELSE
							SET Var_SaldoDevMoraInt := Par_MontoProyectado;
						END IF;
					ELSE
						IF Par_MontoProyectado <= 0 THEN
							SET Var_SaldoDevMoraInt := 0;
						END IF;
					END IF;

					IF(Var_IVAIntMor = Var_ConSI) THEN
						SET	Var_SaldoDevIVAMoraInt := ROUND(Var_SaldoDevMoraInt*Var_IVA,2);
					END IF;

					SET Var_SaldoProvMoraInt := Var_SaldoProvMoraInt + Var_SaldoDevMoraInt;
					SET Var_SaldoProvIVAMoraInt := Var_SaldoProvIVAMoraInt + Var_SaldoDevIVAMoraInt;

					SET Par_MontoProyectado := Par_MontoProyectado - Var_SaldoDevMoraInt - Var_SaldoDevIVAMoraInt;


					IF Par_DevengaInteres = Var_ConSI THEN
						IF  Var_SaldoDevMoraInt > Var_ConCero THEN

							CALL DEVENGOINTERMORAPRO(
										Par_CreditoID,		Var_AmoDevMoraIni,		Var_SaldoDevMoraInt,		Par_PolizaID, 		Salida_NO,
										Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
										Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

							IF Par_NumErr <> Var_ConCero THEN
								SET Par_ErrMen	:= CONCAT('Error en devengo de interes, ',Par_ErrMen);
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;

					IF Par_MontoProyectado <= 0 THEN
						LEAVE ManejoErrores;
					END IF;

				END ProyectaMora;

				SET Var_AmoDevMoraIni := Var_AmoDevMoraIni + 1;

			END WHILE;

		END IF;
    END IF;


	WHILE Var_IniAmortizaID <= Var_UltAmortizaID AND Var_IniAmortizaID <> Var_ConCero DO
	 ProyectInteres:BEGIN

	 	SELECT SUM(ROUND(SaldoCapVigente,2)+ROUND(SaldoCapAtrasa,2)+ROUND(SaldoCapVencido,2)+ROUND(SaldoCapVenNExi,2))
		INTO Var_SaldoInsoluto
		FROM AMORTICREDITO
		WHERE AmortizacionID >= Var_IniAmortizaID
		AND CreditoID = Par_CreditoID;

        IF Var_TipoCalInteres = Tipo_Global THEN
			SET Var_SaldoInsoluto := Var_MontoCredito;
        END IF;

		SELECT FechaInicio,		FechaVencim,		SaldoInteresPro,		NumProyInteres,			Interes,
			   (ROUND(SaldoCapVigente,2)+ROUND(SaldoCapAtrasa,2)+ROUND(SaldoCapVencido,2)+ROUND(SaldoCapVenNExi,2))
		INTO Var_FechaIniAmo,	Var_FechaFinAmo,	Var_SaldoProvAmo,		Var_NumProyecciones,	Var_InteresPactado,
			 Var_CapitalMora
		FROM AMORTICREDITO
		WHERE AmortizacionID = Var_IniAmortizaID
		AND CreditoID = Par_CreditoID;

        SET Var_FechaIniAmoReal = Var_FechaIniAmo;
        SET Var_FechaFinAmoReal = Var_FechaFinAmo;

		SET Var_NumProyecciones := IFNULL(Var_NumProyecciones,Var_ConCero);

		IF Var_FechaSistema > Var_FechaIniAmo THEN
			SET Var_FechaIniAmo := Var_FechaSistema;
		END IF;

		IF Par_FechaProyecta < Var_FechaFinAmo THEN
			SET Var_FechaFinAmo := Par_FechaProyecta;
		END IF;

		IF Var_IniAmortizaID = Var_UltAmortizaID THEN


			SET Var_DiasTrans := DATEDIFF(Var_FechaFinAmo,Var_FechaIniAmo);

			SET	Var_SaldoDevInteres	:= ROUND(Var_SaldoInsoluto * Var_ValorTasa / (Var_DiasAnio*Var_ConCien) ,2)*Var_DiasTrans;

			IF (Var_TipoCalInt = 1 and Var_ManejaConvenio = Var_ConSI) THEN  -- Calculo Sobre Saldos Insolutos
	       			SET Var_EsProducNomina := IFNULL(Var_EsProducNomina,'N');

					IF(Var_EsProducNomina = Var_ConSI )THEN
						SET Var_SaldoDevInteres	:= ROUND(Var_InteresPactado / (CAST(DATEDIFF(Var_FechaFinAmoReal, Var_FechaIniAmoReal) AS SIGNED)),2)*Var_DiasTrans;
					END IF;
			END IF;

            IF (Var_SaldoDevInteres+Var_SaldoProvAmo) > Var_InteresPactado THEN
				SET Var_SaldoDevInteres := Var_InteresPactado - Var_SaldoProvAmo;
            END IF;

		ELSE

			IF Var_NumProyecciones = Var_ConCero THEN
				SET Var_SaldoDevInteres := Var_InteresPactado - Var_SaldoProvAmo;
				SET Var_SaldoDevIVAInteres := Var_SaldoDevIVAInteres;
			END IF;

		END IF;

		IF(Var_CobraIVAInt = Var_ConSI) THEN
				SET	Var_SaldoDevIVAInteres := ROUND(Var_SaldoDevInteres*Var_IVA,2);
		END IF;

		IF (Var_SaldoDevInteres+Var_SaldoDevIVAInteres) > Par_MontoProyectado AND Par_MontoProyectado > 0 THEN
			IF Var_CobraIVAInt = Var_ConSI  THEN
				SET Var_SaldoDevInteres := ROUND(Par_MontoProyectado,2) - ROUND(((Par_MontoProyectado)/(1+Var_IVA)) * Var_IVA, 2);
			ELSE
				SET Var_SaldoDevInteres := Par_MontoProyectado;
			END IF;
		ELSE
			IF Par_MontoProyectado <= 0 THEN
				SET Var_SaldoDevInteres := 0;
			END IF;
		END IF;

		IF(Var_CobraIVAInt = Var_ConSI) THEN
				SET	Var_SaldoDevIVAInteres := ROUND(Var_SaldoDevInteres*Var_IVA,2);
		END IF;

        -- Valida si realiza el devengo del interes, para invocar al SP que haga la parte contable

		SET Var_SaldoProvInteres := Var_SaldoProvInteres + Var_SaldoDevInteres;
		SET Var_SaldoProvIVAInteres := Var_SaldoProvIVAInteres + Var_SaldoDevIVAInteres;

        SET Par_MontoProyectado := Par_MontoProyectado - Var_SaldoDevInteres - Var_SaldoDevIVAInteres;

        IF Var_CobraMora = Var_ConSI AND Var_CapitalMora > Var_ConCero THEN

			SET Var_DiasProyecta := DATEDIFF(Par_FechaProyecta,Var_FechaFinAmo);
			SET Var_SaldoDevMoraInt := ROUND(Var_FactorMora*Var_CapitalMora/(Var_DiasAnio*Var_ConCien),2)*Var_DiasProyecta;
			IF(Var_IVAIntMor = Var_ConSI) THEN
				SET	Var_SaldoDevIVAMoraInt := ROUND(Var_SaldoDevMoraInt*Var_IVA,2);
			END IF;

			IF (Var_SaldoDevMoraInt+Var_SaldoDevIVAMoraInt) > Par_MontoProyectado AND Par_MontoProyectado > 0 THEN
				IF  Var_IVAIntMor = Var_ConSI THEN
					SET Var_SaldoDevMoraInt := ROUND(Par_MontoProyectado,2) - ROUND(((Par_MontoProyectado)/(1+Var_IVA)) * Var_IVA, 2);
				ELSE
					SET Var_SaldoDevMoraInt := Par_MontoProyectado;
				END IF;
			ELSE
				IF Par_MontoProyectado <= 0 THEN
					SET Var_SaldoDevMoraInt := 0;
				END IF;
			END IF;

			IF(Var_IVAIntMor = Var_ConSI) THEN
				SET	Var_SaldoDevIVAMoraInt := ROUND(Var_SaldoDevMoraInt*Var_IVA,2);
			END IF;

			SET Var_SaldoProvMoraInt := Var_SaldoProvMoraInt + Var_SaldoDevMoraInt;
			SET Var_SaldoProvIVAMoraInt := Var_SaldoProvIVAMoraInt + Var_SaldoDevIVAMoraInt;
			SET Par_MontoProyectado := Par_MontoProyectado - Var_SaldoDevMoraInt - Var_SaldoDevIVAMoraInt;

		END IF;


		IF Par_DevengaInteres = Var_ConSI THEN
			IF  Var_SaldoDevMoraInt > Var_ConCero THEN

				CALL DEVENGOINTERMORAPRO(
							Par_CreditoID,		Var_IniAmortizaID,		Var_SaldoDevMoraInt,		Par_PolizaID, 		Salida_NO,
							Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF Par_NumErr <> Var_ConCero THEN
					SET Par_ErrMen	:= CONCAT('Error en devengo de interes, ',Par_ErrMen);
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF Var_SaldoDevInteres > Var_ConCero THEN

				CALL DEVENGOINTERORDPRO(
							Par_CreditoID,		Var_IniAmortizaID,		Var_SaldoDevInteres,		Par_PolizaID, 		Salida_NO,
							Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


				IF Par_NumErr <> Var_ConCero THEN
					SET Par_ErrMen	:= CONCAT('Error en devengo de interes, ',Par_ErrMen);
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		IF Par_MontoProyectado <= 0 THEN
			LEAVE ManejoErrores;
		END IF;


	 END ProyectInteres;
	 SET Var_IniAmortizaID := Var_IniAmortizaID + 1;
	END WHILE;


	SET	Par_MontoTotal	:=  Var_CapitalPorPAgar+Var_SaldoProvInteres+Var_SaldoProvIVAInteres+Var_SaldoProvMoraInt+Var_SaldoProvIVAMoraInt;
	SET Par_NumErr := 0;
    SET Par_ErrMen := 'Credito Proyectado Exitosamente';

END ManejoErrores;
	SET Par_MontoTotal := IFNULL(Par_MontoTotal,0);

    IF(Par_Salida = Var_ConSI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Par_MontoTotal	AS MontoTotal;
	END IF;

END TerminaStore$$