-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNCALMONTOLIQ
DELIMITER ;
DROP FUNCTION IF EXISTS `FNCALMONTOLIQ`;
DELIMITER $$

CREATE FUNCTION `FNCALMONTOLIQ`(
/** ==================================================================================
 ** -- FUNCION PARA CALCULAR EL MONTO A LIQUIDAR DEL CREDITO A LA FECHA INTRODUCIDA --
 ** ==================================================================================
 */
	Par_CreditoID			BIGINT(12),		-- Credito ID
	Par_FechaProyecta		DATE			-- Fecha capturada en la pantalla carta deliquidación

) RETURNS decimal(18,2)
	DETERMINISTIC
BEGIN
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

	-- Declaracion de constantes
	DECLARE Var_ConCero					INT;					-- Cosntante 0
	DECLARE Var_ConUno					INT;					-- Constante 1
	DECLARE Var_Pagado					CHAR(1);				-- Constante P
	DECLARE Var_ConCien					INT;					-- Constante 100
	DECLARE Var_ConSI					CHAR(1);					-- Constante S
	DECLARE Par_EmpresaID				INT(11);				-- parametros de auditoria
	DECLARE Aud_Usuario					INT(11);				-- parametros de auditoria
	DECLARE Aud_FechaActual				DATETIME;				-- parametros de auditoria
	DECLARE Aud_DireccionIP				VARCHAR(15);			-- parametros de auditoria
	DECLARE Aud_ProgramaID				VARCHAR(50);			-- parametros de auditoria
	DECLARE Aud_Sucursal				INT(11);				-- parametros de auditoria
	DECLARE Aud_NumTransaccion 			BIGINT(20);				-- parametros de auditoria


	-- Asignación de constantes
	SET	Var_ConCero						:= 0;					-- Cosntante 0
	SET	Var_ConUno						:= 1;					-- Cosntante 1
	SET	Var_Pagado						:= 'P';					-- Cosntante P
	SET	Var_ConCien						:= 100;					-- Cosntante 100
	SET	Var_ConSI						:= 'S';					-- Constante S
	SET	Par_EmpresaID					:=1;					-- parametros de auditoria
	SET	Aud_Usuario						:=1;					-- parametros de auditoria
	SET	Aud_FechaActual					:=NOW();				-- parametros de auditoria
	SET	Aud_DireccionIP					:='';					-- parametros de auditoria
	SET	Aud_ProgramaID					:='';					-- parametros de auditoria
	SET	Aud_Sucursal					:=1;					-- parametros de auditoria
	SET	Aud_NumTransaccion				:=1;					-- parametros de auditoria
	SET	Var_CapInt						:= 0.00;				-- Capital + interes

	SELECT	Cli.PagaIVA,			Cre.SucursalID,			Pro.CobraIVAInteres,	Pro.CobraIVAMora,	Pro.ProyInteresPagAde,
			Pro.TipCobComMorato,	Pro.CalcInteres,		Cre.FactorMora ,		Cre.TasaFija,		Cre.Estatus,
			Cre.ClienteID,			Pro.CobraIVAInteres,	Suc.IVA
		INTO
			Var_CliPagIVA,			Var_SucCredito,			Var_IVAIntOrd,			Var_IVAIntMor,			Var_ProyInPagAde,
			Var_TipCobComMor,		Var_CalcInteres,		Var_FactorMora,			Var_CreTasa,			Var_EstatusCre,
			Var_ClienteID,			Var_CobraIVAInt,		Var_IVA
	FROM CREDITOS Cre,
		 PRODUCTOSCREDITO Pro,
		 CLIENTES Cli,
		 SUCURSALES Suc
	WHERE Cre.CreditoID			= Par_CreditoID
	  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
	  AND Cre.ClienteID			= Cli.ClienteID
	  AND Cre.SucursalID		= Suc.SucursalID;

	SELECT DiasCredito
		INTO Var_DiasAnio
		FROM PARAMETROSSIS;

	-- Se obtiene el capital pendiente por pagar
	SELECT SUM(ROUND(SaldoCapVigente,2)+ROUND(SaldoCapAtrasa,2)+ROUND(SaldoCapVencido,2)+ROUND(SaldoCapVenNExi,2))
		INTO Var_CapitalPorPAgar
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID;

	-- Se obtiene la ultima amortizacion pagada
	SELECT	IFNULL(MAX(AmortizacionID),Var_ConCero)
		INTO	Var_MaxAmorti
		FROM AMORTICREDITO 
		WHERE Estatus = Var_Pagado
		  AND CreditoID = Par_CreditoID;

	-- Se asigna la fecha para calcular los dias transcurridos a la fecha de proyeccion
	IF(Var_MaxAmorti = Var_ConCero) THEN
		SET	Var_FechaInicio	:= (SELECT	FechaInicio FROM AMORTICREDITO WHERE AmortizacionID = Var_ConUno AND CreditoID = Par_CreditoID);
	ELSE
		SET	Var_FechaInicio	:= (SELECT	FechaLiquida FROM AMORTICREDITO WHERE AmortizacionID = Var_MaxAmorti AND CreditoID = Par_CreditoID);
	END IF;

	CALL CRECALCULOTASAPRO(	Par_CreditoID,		Var_CalcInteres,	Var_CreTasa,	Par_FechaProyecta,			Var_FechaInicio,
							Par_EmpresaID,		Var_ValorTasa,		Aud_Usuario,	Aud_FechaActual,			Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	SET	Var_DiasTrans	:= DATEDIFF(Par_FechaProyecta,Var_FechaInicio);

	SET	Var_ValorTasa	:= Var_DiasTrans * Var_ValorTasa / Var_DiasAnio / Var_ConCien;

	SET	Var_CapInt		:= Var_CapitalPorPAgar * Var_ValorTasa;

	SELECT		SUM(ROUND(SaldoMoratorios,2)+ROUND(SaldoIVAMorato))
		INTO	Var_Moratorios
		FROM AMORTICREDITO
		WHERE CreditoID = Par_CreditoID
		  AND Estatus <> Var_Pagado;

	IF(Var_CobraIVAInt = Var_ConSI) THEN
		SET	Var_IVAInteres	:= Var_CapInt * Var_IVA;
		SET	Var_CapInt	:= Var_CapInt + Var_Moratorios + Var_IVAInteres;
	END IF;

	SET	Var_CapInt	:= Var_CapInt + Var_Moratorios + Var_CapitalPorPAgar;

	RETURN Var_CapInt;
END$$