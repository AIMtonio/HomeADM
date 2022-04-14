-- FNADEUDOTOTALCRED
DELIMITER ;
DROP FUNCTION IF EXISTS `FNSALDOPROYECTADCRED`;
DELIMITER $$

CREATE FUNCTION `FNSALDOPROYECTADCRED`(
/*FUNCION PARA OBTENER EL SALDO PROYECTADO DE UN CREDITO EN BASE A SALDOPROYECTADOWSCON*/
	Par_CreditoID		BIGINT(12),				-- ID del credito a proyectar
	Par_FechaProyecta	DATE,					-- Fecha de la proyeccion
	Par_NumCon			TINYINT UNSIGNED		-- Numero de Consulta

) RETURNS DECIMAL(16,2)
	DETERMINISTIC
BEGIN

	DECLARE Par_EmpresaID			INT(11);				-- parametros de auditoria
	DECLARE Aud_Usuario				INT(11);				-- parametros de auditoria
	DECLARE Aud_FechaActual			DATETIME;				-- parametros de auditoria
	DECLARE Aud_DireccionIP			VARCHAR(15);			-- parametros de auditoria
	DECLARE Aud_ProgramaID			VARCHAR(50);			-- parametros de auditoria
	DECLARE Aud_Sucursal			INT(11);				-- parametros de auditoria
	DECLARE Aud_NumTransaccion 		BIGINT(20);				-- parametros de auditoria

	-- Declaracion de Variables
	DECLARE Var_CreditoID			BIGINT(12);				-- ID del credito
	DECLARE Var_CliPagIVA			CHAR(1);				-- Indica si el cliente paga IVA
	DECLARE Var_IVAIntOrd			CHAR(1);				-- Total del IVA de interes ordinario
	DECLARE Var_IVAIntMor			CHAR(1);				-- IVA del interes moratorio
	DECLARE Var_ValIVAIntOr			DECIMAL(12,2);			-- Valor del IVA
	DECLARE Var_ValIVAIntMo			DECIMAL(12,2);			-- Valor de IVA interes moratorio
	DECLARE Var_ValIVAGen			DECIMAL(12,2);			-- Valor IVA general
	DECLARE Var_IVASucurs			DECIMAL(12,2);			-- Valor del IVA por sucursal
	DECLARE Var_SucCredito			INT(11);				-- Sucursal del credito
	DECLARE Var_FecActual			DATE;					-- Fecha actual del sistema
	DECLARE Var_ProyInPagAde		CHAR(1);				-- proyeccion de interes
	DECLARE Var_SaldoCapital		DECIMAL(14,2);			-- Saldo capital del credito
	DECLARE Var_CreTasa				DECIMAL(12,4);			-- Tasa del credito
	DECLARE Var_DiasCredito			INT(11);				-- Dias de vida del credito
	DECLARE Var_IntAntici			DECIMAL(14,4);			-- interes anticipado
	DECLARE Var_ProxAmorti			INT(11);				-- fecha proxima de amortizaciones
	DECLARE Var_NumProyInteres		INT(11);				-- Numero de proyecciones de interes
	DECLARE Var_IntProActual		DECIMAL(14,4);			-- Interes proyectado actual
	DECLARE Var_Interes				DECIMAL(14,4);			-- variable interes
	DECLARE Var_TipCobComMor		CHAR(1);				-- Tipo de cobro de interes moratorio
	DECLARE Var_CalcInteres			INT(11);				-- ID de calculo de intereses
	DECLARE Var_SaldoIVAInteres		DECIMAL(14,2);			-- Saldo IVA intereses
	DECLARE Var_MoraProyecta		DECIMAL(12,2);			-- Monto moratorio proyectado
	DECLARE Var_IVAMoraProy			DECIMAL(12,2);			-- Iva moratorio proyectado
	DECLARE Var_FactorMora			DECIMAL(12,4);			-- factor mora del credito
	DECLARE Var_Dias				DECIMAL(10,2);			--  Dias que pasan de fecha actual a la proyeccion
	DECLARE Var_ValorTasa			DECIMAL(12,4);			-- Valor de la tasa ordinaria
	DECLARE Var_FechaInicio			DATE;					-- fecha de inicio de la amortizacion
	DECLARE Var_FechaProxAmo		DATE;					-- Fecha exigible de la proxima amortizacion
	DECLARE Var_EstatusCre			CHAR(1);				-- Estatus del credito
	DECLARE Var_AntAmorti			INT(11);				-- amortizacion anterior
	DECLARE Var_EstatusAmoAnt		CHAR(1);
	DECLARE Var_FechaAntAmo			DATE;
	DECLARE Var_PagaIVA				CHAR(1);
	DECLARE Var_ClienteID			INT(11);

	DECLARE Var_TotalCapitalProy 	DECIMAL(16,2);
	DECLARE Var_TotalInteresProy 	DECIMAL(14,4);
	DECLARE Var_SaldoIVAIntProy		DECIMAL(14,4);
	DECLARE Var_SaldoMoraProy 		DECIMAL(14,4);
	DECLARE Var_SaldoIVAMoraProy	DECIMAL(14,4);
	DECLARE Var_TotalComProy 		DECIMAL(16,2);
	DECLARE Var_TotalIVAComProy 	DECIMAL(14,4);
	DECLARE Var_SaldoProyectado 	DECIMAL(16,2);

	--  Declaracion de constantes

	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,4);
	DECLARE Decimal_Cien        DECIMAL(12,4);
	DECLARE Con_Proyeccion      INT(11);
	DECLARE Con_PagCreExi2      INT(11);
	DECLARE SiPagaIVA           CHAR(1);
	DECLARE SI_ProyectInt       CHAR(1);
	DECLARE EstatusPagado       CHAR(1);
	DECLARE Mora_NVeces         CHAR(1);
	DECLARE Entero_Uno          INT(11);
	DECLARE EstatusVigente      CHAR(1);

	-- Asiganacion de constantes
	SET Cadena_Vacia        := '';                  -- cadena vacia
	SET Fecha_Vacia         := '1900-01-01';        -- fecha vacia
	SET Entero_Cero         := 0;                   -- entero cero
	SET Decimal_Cero        := 0.0;                 -- DECIMAL cero
	SET Decimal_Cien        := 100.00;              -- DECIMAL 100
	SET Con_Proyeccion      := 1;                   -- consulta proyeccion de saldo
	SET Con_PagCreExi2      := 2;                   -- consulta de exigible de credito
	SET SiPagaIVA           := 'S';                 -- si paga IVA
	SET EstatusPagado       := 'P';                 -- Estatus pagado
	SET SI_ProyectInt       := 'S';                 -- si proyecta interes
	SET Mora_NVeces         := 'N';                 -- Tipo de Cobro de Moratorios: N Veces la Tasa Ordinaria
	SET Aud_FechaActual     := NOW();               -- fecha actual
	SET Entero_Uno          := 1;                   -- ENTERO UNO
	SET EstatusVigente      := 'V';                 -- estatus vigente


	SET Par_EmpresaID		:=1;				-- parametros de auditoria
	SET Aud_Usuario			:=1;				-- parametros de auditoria
	SET Aud_FechaActual		:=NOW();			-- parametros de auditoria
	SET Aud_DireccionIP		:='';				-- parametros de auditoria
	SET Aud_ProgramaID		:='';				-- parametros de auditoria
	SET Aud_Sucursal		:=1;				-- parametros de auditoria
	SET Aud_NumTransaccion	:=1;				-- parametros de auditoria


	-- Obtener valores para consulta
	SELECT  Cli.PagaIVA,            Cre.SucursalID,         Pro.CobraIVAInteres,    Pro.CobraIVAMora,       Pro.ProyInteresPagAde,
			SUM(IFNULL(Amo.SaldoCapVigente, Entero_Cero) + IFNULL(Amo.SaldoCapAtrasa, Entero_Cero) +
				IFNULL(Amo.SaldoCapVencido, Entero_Cero)  + IFNULL(Amo.SaldoCapVenNExi, Entero_Cero)),
			Pro.TipCobComMorato,    Pro.CalcInteres,        MIN(Amo.FechaInicio),   Cre.FactorMora ,        Cre.TasaFija,
			Cre.CreditoID,          Cre.Estatus,            Cre.ClienteID
	INTO
			Var_CliPagIVA,          Var_SucCredito,         Var_IVAIntOrd,          Var_IVAIntMor,          Var_ProyInPagAde,
			Var_SaldoCapital,       Var_TipCobComMor,       Var_CalcInteres,        Var_FechaInicio,        Var_FactorMora,
			Var_CreTasa,            Var_CreditoID,          Var_EstatusCre,         Var_ClienteID

	FROM CREDITOS Cre,
		 PRODUCTOSCREDITO Pro,
		 AMORTICREDITO Amo,
		 CLIENTES Cli
	WHERE Cre.CreditoID			= Par_CreditoID
	  AND Cre.ProductoCreditoID = Pro.ProducCreditoID
	  AND Amo.CreditoID			= Cre.CreditoID
	  AND Cre.ClienteID			= Cli.ClienteID
	  AND Amo.Estatus			<> EstatusPagado;

	SELECT FechaSistema, DiasCredito
		INTO Var_FecActual, Var_DiasCredito
		FROM PARAMETROSSIS;

	-- Inicializa variables
	SET Var_SaldoCapital		:= IFNULL(Var_SaldoCapital, Entero_Cero);
	SET Var_CliPagIVA			:= IFNULL(Var_CliPagIVA, SiPagaIVA);
	SET Var_IVAIntOrd			:= IFNULL(Var_IVAIntOrd, SiPagaIVA);
	SET Var_IVAIntMor			:= IFNULL(Var_IVAIntMor, SiPagaIVA);
	SET Var_ValIVAIntOr			:= Entero_Cero;
	SET Var_ValIVAIntMo			:= Entero_Cero;
	SET Var_ValIVAGen			:= Entero_Cero;

	SET Var_TotalCapitalProy 	:= Decimal_Cero;
	SET Var_TotalInteresProy 	:= Decimal_Cero;
	SET Var_SaldoIVAIntProy		:= Decimal_Cero;
	SET Var_SaldoMoraProy 		:= Decimal_Cero;
	SET Var_SaldoIVAMoraProy	:= Decimal_Cero;
	SET Var_TotalComProy 		:= Decimal_Cero;
	SET Var_TotalIVAComProy 	:= Decimal_Cero;
	SET Var_SaldoProyectado 	:= Decimal_Cero;

	-- Validaciones para IVA'S
	IF (Var_CliPagIVA = SiPagaIVA) THEN
		SET Var_IVASucurs   := IFNULL((SELECT IVA
										FROM SUCURSALES
										 WHERE  SucursalID = Var_SucCredito),  Entero_Cero);

		SET Var_ValIVAGen  := Var_IVASucurs;

		IF (Var_IVAIntOrd = SiPagaIVA) THEN
			SET Var_ValIVAIntOr  := Var_IVASucurs;
		END IF;

		IF (Var_IVAIntMor = SiPagaIVA) THEN
			SET Var_ValIVAIntMo  := Var_IVASucurs;
		END IF;
	END IF;


	IF(Par_NumCon = Con_Proyeccion) THEN

		SET Var_IntAntici		:= Entero_Cero;
		SET Var_NumProyInteres	:= Entero_Cero;
		SET Var_IntProActual	:= Entero_Cero;
		SET Var_ValorTasa		:= Entero_Cero;
		SET Var_SaldoIVAInteres := Decimal_Cero;

		SELECT  MIN(AmortizacionID), MIN(FechaExigible)
				INTO Var_ProxAmorti, Var_FechaProxAmo
			FROM AMORTICREDITO
			WHERE CreditoID		= Par_CreditoID
			  AND FechaVencim 	> Var_FecActual
			  AND Estatus		!= EstatusPagado
			  LIMIT 1;

		SET Var_ProxAmorti	:= IFNULL(Var_ProxAmorti, Entero_Cero);

		IF(Var_ProxAmorti = Entero_Cero) THEN

			SELECT  MAX(AmortizacionID), MAX(FechaExigible)
					INTO Var_ProxAmorti, Var_FechaProxAmo
			FROM AMORTICREDITO
			WHERE CreditoID  		= Par_CreditoID
			  AND Estatus 			!= EstatusPagado
			LIMIT 1;
		END IF;

		SET Var_AntAmorti:= Var_ProxAmorti - Entero_Uno;

		SELECT Estatus, FechaExigible
			INTO Var_EstatusAmoAnt, Var_FechaAntAmo
		FROM AMORTICREDITO
		WHERE CreditoID  		= Par_CreditoID
		  AND AmortizacionID 	= Var_AntAmorti;

		IF(Var_AntAmorti <= Entero_Cero)THEN
			SET Var_EstatusAmoAnt   := EstatusPagado;
		END IF;

		SELECT  CASE WHEN  Amo.AmortizacionID = Var_ProxAmorti THEN Amo.NumProyInteres ELSE Entero_Cero END,
				CASE WHEN  Amo.AmortizacionID = Var_ProxAmorti THEN Amo.Interes ELSE Entero_Cero END,
				CASE WHEN  Amo.AmortizacionID = Var_ProxAmorti THEN
												IFNULL(Amo.SaldoInteresPro, Entero_Cero) +
												IFNULL(Amo.SaldoIntNoConta, Entero_Cero)
							ELSE Entero_Cero END INTO
				Var_NumProyInteres, Var_Interes, Var_IntProActual
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID			= Par_CreditoID
			  AND Amo.AmortizacionID	= Var_ProxAmorti
			  AND Amo.Estatus			!= EstatusPagado;

		SET Var_NumProyInteres 	:= IFNULL(Var_NumProyInteres, Entero_Cero);
		SET Var_IntProActual	:= IFNULL(Var_IntProActual, Entero_Cero);
		SET Var_Interes			:= IFNULL(Var_Interes, Entero_Cero);
		SET Var_Dias			:= DATEDIFF(Par_FechaProyecta,Var_FecActual);

		IF(Var_NumProyInteres = Entero_Cero) THEN
			SET Var_IntAntici = ROUND(Var_Interes - Var_IntProActual,2);
			IF(Var_IntAntici < Entero_Cero) THEN
				SET Var_IntAntici := Entero_Cero;
			END IF;
		END IF;

		-- Sp que realiza calculo de tasa
		CALL CRECALCULOTASAPRO(
				Par_CreditoID,		Var_CalcInteres,    Var_CreTasa,    Par_FechaProyecta,          Var_FechaInicio,
				Par_EmpresaID,      Var_ValorTasa,      Aud_Usuario,    Aud_FechaActual,            Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

		IF (Var_TipCobComMor = Mora_NVeces) THEN
			SET Var_FactorMora  = Var_FactorMora * Var_ValorTasa;
		END IF;

		-- Sp que realiza calculo de intereses
		CALL CALCIVAINTERESPROVCON(
			Par_CreditoID,      Con_PagCreExi2,     Var_SaldoIVAInteres,    Par_EmpresaID,  Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);

		SET Var_SaldoIVAInteres := IFNULL(Var_SaldoIVAInteres,Decimal_Cero);

		-- Formula para obtener la proyeccion de moratorios Ee intereses
		IF (Var_FechaProxAmo = Par_FechaProyecta AND Var_EstatusCre = EstatusVigente AND Var_EstatusAmoAnt = EstatusPagado)THEN

			SET Var_MoraProyecta := IFNULL(Var_MoraProyecta, Entero_Cero);
			SET Var_IVAMoraProy  := IFNULL(Var_IVAMoraProy, Entero_Cero);
		ELSE

			IF(Var_EstatusAmoAnt = EstatusPagado  AND Var_EstatusCre = EstatusVigente AND Var_FecActual < Var_FechaProxAmo )THEN

				SELECT SUM( ROUND(Var_SaldoCapital * Var_FactorMora * DATEDIFF(Par_FechaProyecta,Var_FechaProxAmo) /
						 (Var_DiasCredito * Decimal_Cien), 2))  INTO Var_MoraProyecta;

			ELSE

				SELECT SUM( ROUND(Var_SaldoCapital * Var_FactorMora * Var_Dias /
						 (Var_DiasCredito * Decimal_Cien), 2))  INTO Var_MoraProyecta;
			END IF;


		END IF;

		SET Var_MoraProyecta := IFNULL(Var_MoraProyecta, Entero_Cero);
		SET Var_IVAMoraProy  := Var_MoraProyecta * Var_ValIVAIntMo;
		SET Var_IVAMoraProy  := IFNULL(Var_IVAMoraProy, Entero_Cero);

		SELECT
			-- capital
			IFNULL(SUM(ROUND(SaldoCapVigente,2)  +
						  ROUND(SaldoCapAtrasa,2)   +
						  ROUND(SaldoCapVencido,2)  +
						  ROUND(SaldoCapVenNExi,2)),Entero_Cero) AS TotalCapital,
			-- intereses
			ROUND(IFNULL(SUM(ROUND(SaldoInteresOrd +
									  SaldoInteresAtr +
									  SaldoInteresVen +
									  SaldoInteresPro +
									  SaldoIntNoConta +
									  CASE WHEN AmortizacionID = Var_ProxAmorti THEN Var_IntAntici
										   WHEN AmortizacionID > Var_ProxAmorti THEN Amo.Interes
									  ELSE Entero_Cero END
									,2)),Entero_Cero), 2) AS TotalInteres,
			-- IVA intereses
			IFNULL(ROUND(Var_SaldoIVAInteres,2)  + SUM(CASE
												WHEN AmortizacionID >= Var_ProxAmorti THEN Amo.IVAInteres
												ELSE Entero_Cero END), Entero_Cero) AS SaldoIVAInteres,
			-- Moratorios
			IFNULL(SUM(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen),Entero_Cero) + Var_MoraProyecta AS SaldoMoratorios,
			-- IVA moratorios
			IFNULL(SUM(
					ROUND(SaldoMoratorios * Var_ValIVAIntMo, 2)+
					ROUND(SaldoMoraVencido * Var_ValIVAIntMo, 2) +
					ROUND(SaldoMoraCarVen * Var_ValIVAIntMo, 2)),Entero_Cero) + Var_IVAMoraProy AS SaldoIVAMorato,
			-- Comisiones
			ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2)),
						   Entero_Cero),2) AS TotalComision,

			-- IVA comisiones
			ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) + ROUND(SaldoComServGar,2) + ROUND(SaldoOtrasComis,2)),
								Entero_Cero) * Var_ValIVAGen,2) AS TotalIVACom
		INTO  Var_TotalCapitalProy, Var_TotalInteresProy, Var_SaldoIVAIntProy, Var_SaldoMoraProy, Var_SaldoIVAMoraProy,
				Var_TotalComProy, Var_TotalIVAComProy

		FROM AMORTICREDITO Amo
			WHERE CreditoID = Par_CreditoID
				AND Estatus <> EstatusPagado;


		SET Var_SaldoProyectado := Var_TotalCapitalProy+Var_TotalInteresProy+Var_SaldoIVAIntProy
									+Var_SaldoMoraProy+Var_SaldoIVAMoraProy+Var_TotalComProy
									+Var_TotalIVAComProy;
	END IF;

	RETURN Var_SaldoProyectado;

END$$
