-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWGENERAINTEREINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWGENERAINTEREINVPRO`;

DELIMITER $$
CREATE PROCEDURE `CRWGENERAINTEREINVPRO`(
	Par_Fecha			DATE,				-- FECHA DE APLICACION
	Par_Salida			CHAR(1),			-- TIPO DE SALIDA.
	INOUT Par_NumErr	INT(11),			-- NUMERO DE ERROR
	INOUT Par_ErrMen	VARCHAR(400),		-- MENSAJE DE ERROR
	Par_EmpresaID		INT(11),			-- EMPRESA ID

	Aud_Usuario			INT(11),			-- AUDITORIA
	Aud_FechaActual		DATETIME,			-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal		INT(11),			-- AUDITORIA

	Aud_NumTransaccion	BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_SolFondeoID    	BIGINT(20);
DECLARE Var_AmortizacionID  INT(11);
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_EmpresaID		INT(11);
DECLARE Var_CapitalVig		DECIMAL(10,2);
DECLARE Var_FormulaID 		INT(11);
DECLARE Var_TasaFija		DECIMAL(12,4);
DECLARE Var_MonedaID		INT(11);
DECLARE Var_Estatus			CHAR(1);
DECLARE Var_SucCliente	 	INT(11);
DECLARE Var_ClienteID		BIGINT(20);
DECLARE Var_PagaISR			CHAR(1);
DECLARE Var_CuentaAhoID		BIGINT(20);
DECLARE Var_NumRetirosMes   INT(11);
DECLARE Var_Interes			DECIMAL(14,4);
DECLARE	Var_SaldoInteres	 DECIMAL(14,4);
DECLARE	Var_SaldoIntCtaOrden DECIMAL(14,4);
DECLARE	Var_UltimoDia		CHAR(1);
DECLARE Var_ProvisionAcum	DECIMAL(14,4);
DECLARE Var_CreditoStr 		VARCHAR(30);
DECLARE Var_ValorTasa		DECIMAL(12,4);
DECLARE Var_DiasCredito		DECIMAL(10,2);
DECLARE Var_Intere          DECIMAL(12,4);
DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil			CHAR(1);
DECLARE SalCapital          DECIMAL(10,2);
DECLARE DiasInteres         DECIMAL(10,2);
DECLARE Var_CapAju          DECIMAL(10,2);
DECLARE Ref_GenInt          VARCHAR(50);
DECLARE Error_Key           INT(11);

DECLARE Mov_CarConta		INT(11);
DECLARE Var_Poliza          BIGINT(20);
DECLARE Var_TasaISR			DECIMAL(12,4);
DECLARE Var_RetenInt		DECIMAL(12,4);

DECLARE Sig_DiaHab          DATE;
DECLARE Par_Consecutivo     BIGINT(20);
-- DECLARE Var_ContadorInv     INT(11);
DECLARE Var_FormReten       CHAR(1);
DECLARE Var_SigFecha        DATE;
DECLARE Var_CapCtaOrden		DECIMAL(14,4);

-- Declaracion de Constantes
DECLARE Estatus_Vigente		CHAR(1);
DECLARE Estatus_Pagada  	CHAR(1);
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero     	INT(11);
DECLARE Decimal_Cero		DECIMAL(8,2);
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono			CHAR(1);
DECLARE Dec_Cien			DECIMAL(10,2);
DECLARE Pro_GenIntere		INT(11);

DECLARE Mov_IntPro      	INT(11);
DECLARE Con_IntDeven    	INT(11);
DECLARE Con_EgreIntGra  	INT(11);
DECLARE Con_EgreIntExc  	INT(11);

DECLARE Pol_Automatica  	CHAR(1);
DECLARE Con_GenIntere   	INT(11);
DECLARE AltaPoliza_NO   	CHAR(1);
DECLARE AltaPolKubo_SI  	CHAR(1);
DECLARE AltaMovKubo_SI  	CHAR(1);
DECLARE AltaMovKubo_NO  	CHAR(1);
DECLARE AltaMovAho_NO		CHAR(1);
DECLARE PagaISR_SI			CHAR(1);
DECLARE Des_CieDia			VARCHAR(100);
DECLARE Ret_Porcenta		CHAR(1);
DECLARE Var_SaldoCapVigAmo	DECIMAL(12,4); -- Vladimir Jz
DECLARE Var_SaldoCapExiAmo	DECIMAL(12,4); -- Vladimir Jz.

DECLARE	For_TasaFija		INT(11);
DECLARE	SI_UltimoDia		CHAR(1);
DECLARE	NO_UltimoDia		CHAR(1);
DECLARE Var_NumRegistros	INT(11);
DECLARE Var_AuxContador		INT(11);
DECLARE Var_Control    		VARCHAR(100);   		-- Variable de Control
DECLARE	Str_SI				CHAR(1);
DECLARE	Str_NO				CHAR(1);

-- Asignacion de Constantes
SET Estatus_Vigente := 'N';					-- Estatus Vigente
SET Estatus_Pagada  := 'P';                 -- Estatus Amortizacion: Pagada
SET Cadena_Vacia    := '';					-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';		-- Fecha Vacia
SET Entero_Cero     := 0;					-- Entero Cero
SET Decimal_Cero    := 0.00;				-- DECIMAL Cero
SET Nat_Cargo       := 'C';					-- Naturaleza Cargo
SET Nat_Abono       := 'A';					-- Naturaleza abono
SET Dec_Cien        := 100.00;				-- DECIMAL cien
SET Pro_GenIntere   := 301;					-- Proceso Batch Generacion de Interes Ordinario. Inv Kubo
SET Mov_IntPro      := 10;					-- Tipo de Movimiento de Kubo Interes Ordinario
SET Con_IntDeven    := 8;					-- Concepto de kubo Devengamiento Interes
SET Con_EgreIntGra  := 3;					-- Concepto de kubo Resultados. Provision INT(11). Gravado
SET Con_EgreIntExc  := 4;					-- Concepto de kubo Resultados. Provision INT(11). Excento
SET Pol_Automatica  := 'A'; 				-- Poliza automatica
SET Con_GenIntere   := 20;					-- Concepto contable generacion de interes inversiones kubo
SET AltaPoliza_NO   := 'N';					-- alta en Poliza NO
SET AltaPolKubo_SI  := 'S';					-- Alta en poliza SI
SET AltaMovKubo_NO  := 'N';					-- Alta en movimiento de Kubo NO
SET AltaMovKubo_SI  := 'S';					-- Alta en movimiento de Kubo SI
SET AltaMovAho_NO   := 'N';					-- Alta en Movimiento de Ahorro NO
SET PagaISR_SI      := 'S';					-- Paga ISR SI
SET Ret_Porcenta    := 'P';         		-- Formual de Retencion: Porcentaje Directo Sobre Rendimiento

SET	For_TasaFija	:= 1;				-- Formula de Calculo de Interes: Tasa Fija
SET	SI_UltimoDia	:= 'S';				-- Ultimo Dia del calculo de Interes: SI
SET	NO_UltimoDia	:= 'N';				-- Ultimo Dia del calculo de Interes: NO
SET DiasInteres 	:= 1;				-- Dias para el Calculo de Interes: Un Dia
SET	Str_SI			:= 'S';				-- Constante SI.
SET	Str_NO			:= 'N';				-- Constante NO.

SET Des_CieDia      := 'CIERRE DIARIO CROWDFUNDING';
SET Ref_GenInt      := 'GENERACION INTERES';
SET Aud_ProgramaID  := 'CRWGENERAINTEREINVPRO';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  := 999;
		   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWGENERAINTEREINVPRO');
		   SET Var_Control := 'SQLEXCEPTION';
		END;

	SELECT DiasCredito INTO Var_DiasCredito
		FROM PARAMETROSSIS;

	SET Var_SigFecha	:= DATE_ADD(Par_Fecha, INTERVAL 1 DAY);
	SET Var_FecApl 		:= Par_Fecha;

	INSERT INTO TMPCRWGENINTEREINVPRO(
		SolFondeoID, 			AmortizacionID, 		FechaInicio, 			FechaVencimiento, 			FechaExigible,
		EmpresaID, 				SaldoCapVigente, 		CalcInteresID, 			TasaFija, 					MonedaID,
		Estatus, 				SucursalOrigen, 		ClienteID, 				PagaISR, 					CuentaAhoID,
		NumRetirosMes, 			SaldoCapCtaOrden, 		InteresGenerado, 		SaldoInteres, 				SaldoIntCtaOrden,
		ProvisionAcum, 			SaldoCapVigAmo, 		SaldoCapExigibleL, 		NumTransaccion,				CreditoID)
	SELECT
		Inv.SolFondeoID, 		Amo.AmortizacionID,		Amo.FechaInicio,		Amo.FechaVencimiento,		Amo.FechaExigible,
		Inv.EmpresaID,			Inv.SaldoCapVigente,	Inv.CalcInteresID,		Inv.TasaFija,				Inv.MonedaID,
		Inv.Estatus,			Cli.SucursalOrigen,		Cli.ClienteID	,		Cli.PagaISR,				Inv.CuentaAhoID,
		Inv.NumRetirosMes,		Inv.SaldoCapCtaOrden, 	Amo.InteresGenerado,	Amo.SaldoInteres,			Amo.SaldoIntCtaOrden,
		Amo.ProvisionAcum,		Amo.SaldoCapVigente,	Amo.SaldoCapExigible,	Aud_NumTransaccion,			Inv.CreditoID
	FROM AMORTICRWFONDEO Amo,
		 CRWFONDEO	 Inv,
		 CLIENTES Cli
	WHERE Amo.SolFondeoID 			= Inv.SolFondeoID
		AND Inv.ClienteID			= Cli.ClienteID
		AND Amo.FechaInicio			<= Par_Fecha
		AND Amo.FechaVencimiento	>  Par_Fecha
		AND Amo.FechaExigible		>  Par_Fecha
		AND Amo.Estatus				=  'N'
		AND Inv.Estatus				=  'N';

	# ACTUALIZACION DE LA TASA Y FORMULA DE RETENSIÓN PARAMETROS CROWDFUNDING.
	UPDATE TMPCRWGENINTEREINVPRO TMP
		INNER JOIN CREDITOS CRE ON TMP.CreditoID = CRE.CreditoID
		INNER JOIN PRODUCTOSCREDITO PRO ON CRE.ProductoCreditoID = PRO.ProducCreditoID
		INNER JOIN PARAMETROSCRW PCRW ON PRO.ProducCreditoID = PCRW.ProductoCreditoID
	SET
		TMP.TasaISR = PCRW.TasaISR,
		TMP.FormulaRetencion = PCRW.FormulaRetencion;

	CALL MAESTROPOLIZASALT(
		Var_Poliza,			Par_EmpresaID,		Var_FecApl,			Pol_Automatica,		Con_GenIntere,
		Ref_GenInt,			Str_NO,				Par_NumErr,			Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	SET Var_NumRegistros := (SELECT COUNT(*) FROM TMPCRWGENINTEREINVPRO WHERE NumTransaccion = Aud_NumTransaccion);
	SET Var_AuxContador := 0;

	WHILE (Var_AuxContador > Var_NumRegistros) DO
		SET SalCapital				:= Decimal_Cero;
		SET Var_CapAju				:= Decimal_Cero;
		SET Var_Intere				:= Decimal_Cero;
		SET	Var_RetenInt			:= 0.0000;
		SET Var_ValorTasa			:= Var_TasaFija;
		SET Var_CapCtaOrden			:= IFNULL(Var_CapCtaOrden,Decimal_Cero);
		SET Var_Interes				:= IFNULL(Var_Interes,Decimal_Cero );
		SET Var_SaldoInteres		:= IFNULL(Var_SaldoInteres,Decimal_Cero );
		SET Var_SaldoIntCtaOrden 	:= IFNULL(Var_SaldoIntCtaOrden, Decimal_Cero);
		SET Var_ProvisionAcum		:= IFNULL(Var_ProvisionAcum, Decimal_Cero);
		SET Var_UltimoDia 			:= NO_UltimoDia;
		SET Var_SaldoCapVigAmo		:=IFNULL(Var_SaldoCapVigAmo,Decimal_Cero);
		SET Var_SaldoCapExiAmo		:=IFNULL(Var_SaldoCapExiAmo,Decimal_Cero);

		SELECT
			SolFondeoID, 			AmortizacionID, 		FechaInicio, 			FechaVencimiento, 			FechaExigible,
			EmpresaID, 				SaldoCapVigente, 		CalcInteresID, 			TasaFija, 					MonedaID,
			Estatus, 				SucursalOrigen, 		ClienteID, 				PagaISR, 					CuentaAhoID,
			NumRetirosMes,			TasaISR,				FormulaRetencion
		INTO
			Var_SolFondeoID,		Var_AmortizacionID,		Var_FechaInicio,		Var_FechaVencim,			Var_FechaExigible,
			Var_EmpresaID,			Var_CapitalVig,			Var_FormulaID,			Var_TasaFija,				Var_MonedaID,
			Var_Estatus,			Var_SucCliente,			Var_ClienteID,			Var_PagaISR,				Var_CuentaAhoID,
			Var_NumRetirosMes,		Var_TasaISR,			Var_FormReten
		FROM TMPCRWGENINTEREINVPRO
		WHERE NumTransaccion = Aud_NumTransaccion
		LIMIT Var_AuxContador,1;

		-- Si Hoy es la Fecha del ultimo calculo de Interes, y es Tasa Fija, entonces el interes
		-- Ya no lo calculamos lo tomamos de la tabla de amortizacion, esto para poder ajustarnos
		-- A calendarios arbitrarios en las migraciones y evitar errores en calculos de centavos
		IF ( (Var_FechaVencim > Var_FechaExigible AND (DATEDIFF(Var_FechaExigible, Var_SigFecha) = Entero_Cero)) OR
			 (Var_FechaExigible >= Var_FechaVencim AND (DATEDIFF(Var_FechaVencim, Var_SigFecha) = Entero_Cero)) ) THEN
			IF(Var_FormulaID = For_TasaFija) THEN
				SET Var_UltimoDia := SI_UltimoDia;
			END IF;
		END IF;

		-- Hacemos el Calculo del Interes
		IF(Var_CapitalVig + Var_CapCtaOrden > Entero_Cero)THEN -- Si la Inversión ya no tienen Saldo de Capital
			IF(Var_SaldoCapVigAmo+Var_SaldoCapExiAmo>Entero_Cero) THEN  -- si la cuota ya no tiene saldo de capital.
				IF(Var_UltimoDia = NO_UltimoDia) THEN
					SET	SalCapital = Var_CapitalVig + Var_CapCtaOrden;

					SET	Var_CapAju	:= (SELECT IFNULL(SUM(SaldoCapVigente +  IFNULL(SaldoCapCtaOrden,Decimal_Cero)), Decimal_Cero)
										FROM AMORTICRWFONDEO
										WHERE SolFondeoID 	= Var_SolFondeoID
										AND AmortizacionID	< Var_AmortizacionID
										AND Estatus <> Estatus_Pagada
										GROUP BY SolFondeoID );

					SET Var_CapAju := IFNULL(Var_CapAju, Entero_Cero);

					SET SalCapital := SalCapital - Var_CapAju;

					SET Var_Intere := ROUND(SalCapital * Var_ValorTasa * DiasInteres / (Var_DiasCredito * Dec_Cien), 2);

					IF((Var_SaldoInteres + Var_SaldoIntCtaOrden + Var_Intere) > Var_Interes)THEN
						SET Var_Intere	= ROUND(Var_Interes - IFNULL(Var_ProvisionAcum, Entero_Cero),2);
					END IF;

				ELSE	-- ELSE del que es el ultimo dia del calculo del Interes
						-- Var_Interes Es el Interes Original Calculado de la Amortizacion
					SET	Var_Intere := ROUND(Var_Interes - IFNULL(Var_ProvisionAcum,Entero_Cero), 2);
				END IF;
			END IF; -- Si la cuota actual no tiene capital (Ya esta liquidada, esto ocurre en los prepagos)
		END IF;

		-- Seleccion del Tipo de Calculo de la Retencion (Porcentaje del Rendimiento o Sobre la Base)
		IF (Var_PagaISR = PagaISR_SI) THEN
			IF(Var_FormReten = Ret_Porcenta) THEN
				SET	Var_RetenInt := ROUND(Var_Intere * Var_TasaISR / Dec_Cien, 4);
			ELSE
				SET	Var_RetenInt := ROUND(SalCapital * Var_TasaISR * DiasInteres / (Var_DiasCredito * Dec_Cien), 4);
			END IF;
		ELSE
			SET Var_RetenInt := Entero_Cero;
		END IF;

		IF (Var_Intere > Entero_Cero) THEN
			IF (Var_PagaISR = PagaISR_SI) THEN
				SET	Mov_CarConta	:= Con_EgreIntGra;
			ELSE
				SET	Mov_CarConta	:= Con_EgreIntExc;
			END IF;

			CALL CRWCONTAINVPRO (
				Var_SolFondeoID,	Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
				Var_FecApl,			Var_Intere,				Var_MonedaID,		Var_NumRetirosMes,	Var_SucCliente,
				Des_CieDia,			Ref_GenInt,				AltaPoliza_NO,		Entero_Cero,		Var_Poliza,
				AltaPolKubo_SI,		AltaMovKubo_SI,			Mov_CarConta,		Mov_IntPro,			Nat_Cargo,
				Nat_Cargo,			AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,		Str_NO,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CRWCONTAINVPRO (
				Var_SolFondeoID,	Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,		Par_Fecha,
				Var_FecApl,			Var_Intere,				Var_MonedaID,		Var_NumRetirosMes,	Var_SucCliente,
				Des_CieDia,			Ref_GenInt,				AltaPoliza_NO,		Entero_Cero,		Var_Poliza,
				AltaPolKubo_SI,		AltaMovKubo_NO,			Con_IntDeven,		Entero_Cero,		Nat_Abono,
				Cadena_Vacia,		AltaMovAho_NO,			Cadena_Vacia,		Cadena_Vacia,		Str_NO,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE AMORTICRWFONDEO SET
				RetencionIntAcum	= RetencionIntAcum + Var_RetenInt
				WHERE SolFondeoID 	= Var_SolFondeoID
					AND AmortizacionID = Var_AmortizacionID;
		END IF;

		SET Var_AuxContador :=Var_AuxContador +1;

	END WHILE;

	DELETE FROM TMPCRWGENINTEREINVPRO WHERE NumTransaccion = Aud_NumTransaccion;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := 'Proceso Terminado Exitosamente';

END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Str_SI) THEN
		SELECT
			Par_NumErr 		AS NumErr,
			Par_ErrMen		AS ErrMen,
			'creditoID' 	AS control;
	END IF;

END TerminaStore$$