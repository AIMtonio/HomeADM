-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTICREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTICREDITOACT`;DELIMITER $$

CREATE PROCEDURE `AMORTICREDITOACT`(
	-- Store Procedure para la Actualizacion de la Amortizacion de un Credito
	Par_CreditoID			BIGINT(12),		-- Numero del Credito
	Par_TipoAct				INT(11),		-- Tipo de Actualizacion
	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro de Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de Mensaje de Error

	-- Parametros de Auditoria
	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CreditoID       BIGINT(12);		-- ID de Credito
DECLARE Var_AmortizacionID  INT(11);		-- ID  de Amortizacion
DECLARE Var_SaldoCapVigente DECIMAL(14,4);	-- Saldo Capital Vigente
DECLARE Var_SaldoCapVenNExi DECIMAL(14,4);	-- Saldo Capital Venciodo no Exigible
DECLARE Var_FechaInicio     DATE;			-- Fecha de Inicio de la Amortizacion
DECLARE Var_FechaVencim     DATE;			-- Fecha de Vencimiento de la Amortizacion
DECLARE Var_FechaExigible   DATE;			-- Fecha de Exigible de la Amortizacion
DECLARE Var_AmoEstatus      CHAR(1);		-- Estatus de la Amortizacion
DECLARE Var_SaldoInteresPro	DECIMAL(14,4);	-- Saldo Interes Provisionado
DECLARE	Var_SaldoIntNoConta	DECIMAL(14,4);	-- Saldo Interes No Contable
DECLARE Var_ProvisionAcum   DECIMAL(14,4);	-- Saldo Provisionado Acumulado
DECLARE Var_IntPago  		DECIMAL(14,4);	-- Pago de Interes
DECLARE Var_MonedaID        INT(11);		-- Moneda del Credito
DECLARE Var_CalInteresID    INT(11);		-- ID del Calculo de Interes
DECLARE Var_Dias            INT(11);		-- Dias de la amortizacion
DECLARE Var_TotCapital      DECIMAL(14,4);	-- Total el Capital
DECLARE Var_Interes         DECIMAL(14,4);	-- Interes
DECLARE Var_IvaInt	        DECIMAL(10,2);	-- IVA Interes
DECLARE Var_CreTasa         DECIMAL(14,4);	-- Tasa Fija del Credito
DECLARE Var_DiasCredito     INT(11);		-- Dias del Credito
DECLARE Var_ValIVAIntOr 	DECIMAL(14,4);	-- IVA Interes Ordinario
DECLARE Var_SaldoCapital 	DECIMAL(14,4);	-- Saldo Capital
DECLARE Insoluto		 	DECIMAL(14,4);	-- Saldo Insoluto
DECLARE Var_FechaSistema    DATE;			-- Fecha del Sistema
DECLARE Var_SucCliente      INT(11);		-- Sucursal del Cliente
DECLARE Var_IVAIntOrd   	CHAR(1);		-- IVA Interes Ordinario
DECLARE Var_IVASucurs   	DECIMAL(8,4);	-- IVA Sucursal
DECLARE Var_CliPagIVA   	CHAR(1);		-- Variable para Determinar si el Cliente Paga IVA
DECLARE Var_TipoCalInteres	INT(11);		-- Tipo de Calculo de Instes -- Insoluto o Monto Original
DECLARE Var_Cuotas			INT(11);		-- Cuotas del Credito
DECLARE Var_TipoGeneraInteres	CHAR(1);	-- Tipo de Generacion de Interes
DECLARE Var_InteresReal			DECIMAL(14,4);	-- Interes pagado de la amortizacion
DECLARE Var_InteresOrdinario	DECIMAL(14,4);	-- Interes Ordinario en DetallePagCred
DECLARE Var_InteresPagado		DECIMAL(14,4);	-- Interes Ordinario en DetallePagCred
DECLARE Var_SiguienteAmotizacion	INT(11);	-- Amortizacion Siguiente
-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);		-- Constante Cadena Vacia
DECLARE Fecha_Vacia     DATE;			-- Constante Fecha Vacia
DECLARE Entero_Cero     INT(11);		-- Constante Entero Cero
DECLARE Decimal_Cero    DECIMAL(14,4);	-- Constante Decimal Cero
DECLARE SiPagaIVA       CHAR(1);		-- Constante Si paga IVA
DECLARE SalidaSI        CHAR(1);		-- Constante Salida SI
DECLARE SalidaNO        CHAR(1);		-- Constante Salida NO
DECLARE Esta_Pagado     CHAR(1);		-- Estatus Pagado
DECLARE Esta_Activo     CHAR(1);		-- Estatus Activo
DECLARE Esta_Vencido    CHAR(1);		-- Estatus Vencido
DECLARE Esta_Vigente    CHAR(1);		-- Estatus Vigente
DECLARE Esta_Atrasado	CHAR(1);		-- Estatus Atrasado
DECLARE TipoActInteres	INT(11);		-- Tipo Actualizacion de Interes
DECLARE CalculoSalInsol INT(11);		-- Constante Calculo por Saldos Insolutos
DECLARE CalculoSalGlob  INT(11);		-- Constante Calculo por Saldos Globales
DECLARE Tasa_Fija       INT(11);		-- Constante Tasa Fija
DECLARE Contador		INT(11);		-- Contador para Ciclo
DECLARE TipoMontoIguales	CHAR(1);	-- Tipo de Monto Original (Saldos Globales): I.- Iguales
DECLARE TipoMontoDiasTrans	CHAR(1);	-- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
DECLARE TipoActInteresCouSig	INT(11);-- Tipo de Actualizacion Cuota Siguiente
DECLARE TipoActInteresProrreteo	INT(11);-- Tipo de Actualizacion por Prorreteo
DECLARE TipoActInteresUltimaCuo	INT(11);-- Tipo de Actualizacion Ultimas Cuota
DECLARE Var_FechaVencimiento	DATE;	-- Fecha de Vencimiento de la Amortizacion
DECLARE Var_FechaInicioAmor		DATE;	-- Fecha de Inicio de la Amortizacion
DECLARE Var_InteresPendiente	DECIMAL(14,4);	-- Interes Ordinario en DetallePagCred

-- Declaracion del Cursor para actualizar los intereses de las amortizaciones
DECLARE CURSORAMOINTERES CURSOR FOR
    SELECT  Amo.CreditoID,      Amo.AmortizacionID, Amo.SaldoCapVigente,    Amo.SaldoCapVenNExi,
            Cre.MonedaID,       Amo.FechaInicio,    Amo.FechaVencim,        Amo.FechaExigible,
            (IFNULL(Amo.SaldoInteresPro, 0.00) + IFNULL(Amo.SaldoIntNoConta, 0.00)) AS Provision
		FROM AMORTICREDITO Amo,
			  CREDITOS	 Cre
		WHERE Amo.CreditoID   = Cre.CreditoID
		  AND Cre.CreditoID   = Par_CreditoID
		  AND (Cre.Estatus    = Esta_Vigente  OR Cre.Estatus = Esta_Vencido)
		  AND Amo.Estatus	  = Esta_Vigente
        AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;

-- Asignacion de Constantes
SET Cadena_Vacia    := '';              	-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
SET Entero_Cero		:= 0;					-- Entero en Cero
SET Decimal_Cero    := 0.00;            	-- Decimal en Cero
SET SiPagaIVA       := 'S';             	-- El Cliente si Paga IVA
SET SalidaSI        := 'S';             	-- El Store si Regresa una Salida
SET SalidaNO        := 'N';             	-- El Store no Regresa una Salida
SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
SET Esta_Activo     := 'A';             	-- Estatus: Activo
SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
SET Esta_Vigente    := 'V';             	-- Estatus del Credito: Vigente
SET TipoActInteres	:= 1;             		-- Tipo de Actualizacion: actualiza los intereses
SET CalculoSalInsol	:= 1;					-- Calculo de Interes por Saldos Insolutos
SET CalculoSalGlob	:= 2;					-- Calculo de Interes por Saldos Globales (Monto Original)
SET Tasa_Fija       := 1;					-- CalInteresID para tasa fija
SET TipoMontoIguales		:= 'I';			-- Tipo de Monto Original (Saldos Globales): I.- Iguales
SET TipoMontoDiasTrans		:= 'D';			-- Tipo de Monto Original (Saldos Globales): D.- Dias Transcurridos
SET TipoActInteresCouSig	:= 2;			-- Actualizacion 2.- Actualiza Interes Cuota Siguiente
SET TipoActInteresProrreteo	:= 3;			-- Actualizacion 3.- Actualiza Interes por Prorreteo
SET TipoActInteresUltimaCuo	:= 4;			-- Actualizacion 4.- Actualiza Interes Ultimas Cuota

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTICREDITOACT');
		END;

	SELECT 	FechaSistema, 		DiasCredito
	INTO 	Var_FechaSistema, 	Var_DiasCredito
		FROM PARAMETROSSIS;

	SET Par_TipoAct := IFNULL(Par_TipoAct,Entero_Cero);

	IF( Par_TipoAct = TipoActInteres 		  OR Par_TipoAct = TipoActInteresCouSig OR
		Par_TipoAct = TipoActInteresProrreteo OR Par_TipoAct = TipoActInteresUltimaCuo ) THEN
		SELECT  Cli.SucursalOrigen,	Cre.TasaFija,		Cre.MonedaID,	Cli.PagaIVA,	Cre.CalcInteresID,
				Pro.TipoCalInteres,	Pro.CobraIVAInteres, Cre.TipoGeneraInteres, Cre.FechaInicioAmor, Cre.FechaVencimien
			INTO
				Var_SucCliente,		Var_CreTasa,	Var_MonedaID,	Var_CliPagIVA,	Var_CalInteresID,
                Var_TipoCalInteres,	Var_IVAIntOrd,	Var_TipoGeneraInteres, Var_FechaInicioAmor, Var_FechaVencimiento
			FROM CLIENTES Cli
				INNER JOIN CREDITOS Cre ON Cre.ClienteID = Cli.ClienteID
                INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			WHERE Cre.CreditoID			= Par_CreditoID;

		SET Var_SucCliente  := IFNULL(Var_SucCliente,Entero_Cero);

		SELECT IVA INTO Var_IVASucurs
			FROM SUCURSALES
			WHERE SucursalID = Var_SucCliente;

		SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
		SET Var_ValIVAIntOr := Entero_Cero;

		IF(Var_CliPagIVA = SiPagaIVA) THEN
			IF (Var_IVAIntOrd = SiPagaIVA) THEN
				SET Var_ValIVAIntOr  := Var_IVASucurs;
			END IF;
		END IF;

		SELECT  SUM(IFNULL(SaldoCapVigente, Entero_Cero) +
				IFNULL(SaldoCapAtrasa, Entero_Cero)  +
				IFNULL(SaldoCapVencido, Entero_Cero) +
				IFNULL(SaldoCapVenNExi, Entero_Cero) ) INTO Var_SaldoCapital
		  FROM AMORTICREDITO Amo
			WHERE CreditoID = Par_CreditoID
			  AND Amo.Estatus != Esta_Pagado;

		SET Var_SaldoCapital := IFNULL(Var_SaldoCapital,Decimal_Cero);

		IF(Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres=CalculoSalInsol) THEN

			OPEN CURSORAMOINTERES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOAMORTI:LOOP

				FETCH CURSORAMOINTERES INTO
					Var_CreditoID,      Var_AmortizacionID, 	Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
					Var_FechaInicio,    Var_FechaVencim,    	Var_FechaExigible,      Var_ProvisionAcum;

				SET Var_ProvisionAcum 	:= IFNULL(Var_ProvisionAcum, 	Decimal_Cero);
				SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, 	Decimal_Cero);
				SET Var_SaldoCapVigente := IFNULL(Var_SaldoCapVigente, 	Decimal_Cero);
				SET Var_Interes 		:= Decimal_Cero;
				SET Var_TotCapital  	:= Var_SaldoCapVigente + Var_SaldoCapVenNExi;

				IF(Var_FechaInicio < Var_FechaSistema) THEN
					SET Var_Dias := DATEDIFF(Var_FechaVencim, Var_FechaSistema);
				ELSE
					SET Var_Dias := DATEDIFF(Var_FechaVencim, Var_FechaInicio);
				END IF;

				SET Var_Interes := ROUND(Var_SaldoCapital * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);

				UPDATE AMORTICREDITO SET
					Interes = ROUND(Var_Interes + Var_ProvisionAcum,2),
					IVAInteres = ROUND(ROUND(Var_Interes + Var_ProvisionAcum,2) * Var_ValIVAIntOr, 2)

					WHERE	CreditoID   = Var_CreditoID
					  AND	AmortizacionID  = Var_AmortizacionID;

				SET Var_SaldoCapital := Var_SaldoCapital - Var_TotCapital;

				END LOOP CICLOAMORTI;
			END;
			CLOSE CURSORAMOINTERES;

		ELSEIF (Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres = CalculoSalGlob AND Par_TipoAct NOT IN (TipoActInteresProrreteo , TipoActInteresUltimaCuo )) THEN

			SET Var_SaldoCapital := (SELECT SUM(Capital) FROM AMORTICREDITO WHERE CreditoID= Par_CreditoID);
			SET Var_InteresPagado := Entero_Cero;

			SELECT SUM(Interes)
			INTO Var_InteresPendiente
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			  AND Estatus <> Esta_Pagado;

			SELECT MIN(AmortizacionID)
			INTO Var_SiguienteAmotizacion
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			  AND Estatus <> Esta_Pagado
			  AND FechaExigible >= Var_FechaSistema;

			SELECT SUM( Det.MontoIntOrd +  Det.MontoIntAtr + Det.MontoIntVen )
			INTO  Var_InteresOrdinario
			FROM DETALLEPAGCRE Det
			INNER JOIN AMORTICREDITO Amo ON Amo.AmortizacionID = Det.AmortizacionID AND Amo.CreditoID = Det.CreditoID
			WHERE Det.CreditoID = Par_CreditoID
			  AND Amo.Estatus = Esta_Pagado
			  AND Det.AmortizacionID <> Var_SiguienteAmotizacion;

            SET Var_InteresReal := ROUND((Var_SaldoCapital*((Var_CreTasa*1)/(Var_DiasCredito*100))),2)*DATEDIFF(Var_FechaVencimiento,Var_FechaInicioAmor);


			SET Var_InteresReal := IFNULL(Var_InteresReal, Entero_Cero);
			SET Var_InteresOrdinario := IFNULL(Var_InteresOrdinario, Entero_Cero);


			SET Var_InteresPagado := Var_InteresReal - Var_InteresOrdinario - Var_InteresPendiente;


            SET Var_SiguienteAmotizacion := IFNULL(Var_SiguienteAmotizacion, Entero_Cero);
            SET Var_InteresPagado := IFNULL(Var_InteresPagado, Entero_Cero);

			OPEN CURSORAMOINTERES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOAMORTI:LOOP

					FETCH CURSORAMOINTERES INTO
						Var_CreditoID,      Var_AmortizacionID, 	Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
						Var_FechaInicio,    Var_FechaVencim,    	Var_FechaExigible,    	Var_ProvisionAcum;

						SET Var_IntPago := (SELECT SUM(MontoIntOrd)
											FROM DETALLEPAGCRE
											WHERE CreditoID = Var_CreditoID
													AND AmortizacionID = Var_AmortizacionID
													AND MontoIntOrd > Entero_Cero);

						SET Var_IntPago := IFNULL(Var_IntPago,Entero_Cero);
						SET Var_Dias := DATEDIFF(Var_FechaVencim, Var_FechaInicio);

						IF( Par_TipoAct = TipoActInteresCouSig) THEN

							SELECT Interes
							INTO Var_Interes
							FROM AMORTICREDITO
							WHERE CreditoID = Var_CreditoID
								AND AmortizacionID = Var_AmortizacionID;

							SET Var_Interes := IFNULL(Var_Interes, Entero_Cero);

							IF( Var_AmortizacionID = Var_SiguienteAmotizacion ) THEN
								SET Var_Interes := Var_Interes + Var_InteresPagado;

							END IF;

						ELSE

							SET Var_Interes :=ROUND(Var_SaldoCapital*Var_CreTasa*Var_Dias/(Var_DiasCredito*100),2);

						END IF;

                        SET Var_Interes := (Var_Interes - Var_IntPago);
						UPDATE AMORTICREDITO SET
							Interes		= Var_Interes,
							IVAInteres	= ROUND(( Var_Interes * Var_ValIVAIntOr),2)
						WHERE CreditoID = Var_CreditoID
						  AND AmortizacionID = Var_AmortizacionID;
				END LOOP CICLOAMORTI;
			END;
			CLOSE CURSORAMOINTERES;
		END IF;
	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Los Intereses han sido Actualizados Correctamente. Credito: ',CONVERT(Par_CreditoID, CHAR(12)));

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$