-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGENAMORTIZARESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREGENAMORTIZARESPRO`;
DELIMITER $$


CREATE PROCEDURE `CREGENAMORTIZARESPRO`(
/* SP que da de Alta las Amortizaciones en una Reestructura cuando el tipo de pago de capital sea
Iguales o Crecientes */
	Par_SolicitudCreditoID		BIGINT(12),		-- Numero de la nueva solicitud de credito

 	Par_CreditoOrigenID			BIGINT(20),		-- Credito a Reestructurar
    Par_FechaInicioAmor DATE,					-- Fecha de Inicio
	Par_Salida			CHAR(1),

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	# Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)

TerminaStore: BEGIN


	DECLARE Var_EstCredito		CHAR(1);		# Estatus del Credito
	DECLARE Var_FecInicio		DATE;			# Fecha de Inicio
	DECLARE Var_FecTermin		DATE;			# Fecha de Terminacion
	DECLARE Var_Monto			DECIMAL(12,2); 	# Monto
	DECLARE Var_TasaFija		DECIMAL(12,4);	# Tasa Fija
	DECLARE Var_PeriodCap		INT(11);		# Periodicidad del Capital
	DECLARE Var_PeriodInt		INT(11);		# Periodicidad del Interes
	DECLARE Var_FrecCap			CHAR(1);		# Frecuencia de Capital
	DECLARE Var_FrecInter		CHAR(1);		# Frecuencia de Interes
	DECLARE Var_DiaPagCap		CHAR(1);		# Dia de Pago de Capital
	DECLARE Var_DiaPagIn		CHAR(1);		# Dia de Pago de Interes
	DECLARE Var_DiaMesCap		INT(11);		# Dia y Mes de Pago de Capital
	DECLARE Var_DiaMesIn		INT(11);		# Dia y Mes de Pago de Interes
	DECLARE Var_FechaIni		DATE;			# Fecha de Inicio
	DECLARE Var_FechInha		CHAR(1);		# Fecha Inhabil
	DECLARE Var_NumAmorti		INT(11);		# Numero de Amortizaciones
	DECLARE Var_AjFeUlVA		CHAR(1);
	DECLARE Var_AjFecExV		CHAR(1);
	DECLARE Var_CalcInter		INT(11);
	DECLARE Var_TipoPagCap		CHAR(1);
	DECLARE Var_Producto		INT(11);
	DECLARE Var_Cliente			INT(11);
	DECLARE Var_MonComA			DECIMAL(12,4);
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_Dia				INT(11);
	DECLARE Var_Cuenta			BIGINT(12);
	DECLARE Var_MontoCre		DECIMAL(12,2);
	DECLARE Var_TipoCalIn		INT(11);
	DECLARE Var_NumAmoInt		INT(11);
	DECLARE Var_Cuotas			INT;
	DECLARE varControl 		 	CHAR(20);
	DECLARE Var_Garantia 		DECIMAL(12,2);
    DECLARE Par_NumTransSim		BIGINT(20);
    DECLARE Var_ConvenioNomina	BIGINT UNSIGNED;	-- Convenio de nomina

	DECLARE Var_CobraSeguroCuota CHAR(1);
	DECLARE Var_CobraIVASeguroCuota CHAR(1);
	DECLARE Var_MontoSeguroCuota DECIMAL(12,2);

    DECLARE Var_LineaCreditoID	BIGINT; 		-- Identificador de la linea de créito
    DECLARE Var_CobraComAnual 	CHAR(1);		-- Indica si cobra comisión anual de linea
	DECLARE Var_SaldoComAnual 	DECIMAL(14,2); 	-- Indica el saldo pendiente de la comisión anual de la linea
	DECLARE Var_ComisionCobrada CHAR(1); 		-- Indica si la comisión anual de la linea y afue cobrada o no
	DECLARE Var_ComAnualLin 	DECIMAL(14,2); 	-- Indica el monto a cubrir de la comisión anual de la linea

	DECLARE Var_TasaBase		INT;
	DECLARE Var_ValorTasa		DECIMAL(12,4);
	DECLARE Var_SobreTasa		DECIMAL(12,4);
	DECLARE Var_TasaBPuntos 	DECIMAL(12,4);


	DECLARE	Par_ValorCAT		DECIMAL(14,4);

	DECLARE	Var_NumCuotas		INT;
	DECLARE	Var_NumCuotInt		INT;
	DECLARE	Par_MontoCuo		DECIMAL(14,4);
	DECLARE	Par_FechaVen		DATE;
	DECLARE	Var_NumTransacSim	BIGINT;


	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Cre_Autorizado		CHAR(1);
	DECLARE Cre_Inactivo		CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE TasFija				INT;
	DECLARE PagCrecientes		CHAR(1);
	DECLARE PagIguales			CHAR(1);
	DECLARE PagLibres			CHAR(1);
	DECLARE FrecMensual			CHAR(1);
	DECLARE DiaAniversario		CHAR(1);
	DECLARE Act_CreditoAmor		INT;
	DECLARE Var_SI				CHAR(1);
	DECLARE TipoCalIntGlo		INT;
	DECLARE Var_Aniversario		CHAR(1);
	DECLARE Var_DiaDelMes		CHAR(1);
	DECLARE Var_Indistinto		CHAR(1);
	DECLARE Var_Capital			CHAR(1);
	DECLARE Var_Interes			CHAR(1);
	DECLARE Var_CapInt			CHAR(1);
	DECLARE Var_MontoSeguro		DECIMAL(12,2);
	DECLARE NoHabil				CHAR(1);
	DECLARE CalendarioNormal	INT(11);
    DECLARE CalendarioReestr	INT(11);


	SET Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:= '';
	SET Cre_Autorizado	:= 'A';
	SET Cre_Inactivo	:= 'I';
	SET SalidaNO		:= 'N';
	SET SalidaSI		:= 'S';
	SET TasFija			:= 1;
	SET PagCrecientes	:= 'C';
	SET PagIguales		:= 'I';
	SET PagLibres		:= 'L';
	SET FrecMensual		:= 'M';
	SET DiaAniversario	:= 'A';
	SET Act_CreditoAmor	:= 4;
	SET Var_SI			:= 'S';
	SET TipoCalIntGlo	:= 2;
	SET Var_Aniversario	:= 'A';
	SET Var_DiaDelMes	:= 'D';
	SET Var_Indistinto	:= 'I';
	SET Var_Capital		:= 'C';
	SET Var_Interes		:= 'I';
	SET Var_CapInt		:= 'G';
	SET NoHabil			:= 'N';
	SET CalendarioNormal := 1;
    SET CalendarioReestr := 2;

	SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

	SET Par_NumErr		:= Entero_Cero;
	SET Par_ErrMen		:= "";
	SET Par_ValorCAT	:= 0.0;
	SET Var_NumCuotas	:= 0;
	SET Var_NumCuotInt	:= 0;


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CREGENAMORTIZARESPRO');
			SET varControl := 'SQLEXCEPTION';
	    END;

        # Se obtienen los datos de la Nueva Solicitud de Credito
		SELECT	MontoAutorizado,	TasaFija,			PeriodicidadCap,	PeriodicidadInt,	FrecuenciaCap,
				FrecuenciaInt,		DiaPagoCapital,		DiaPagoInteres,		DiaMesCapital,		DiaMesInteres,
				FechaInicio,		FechaInhabil,		NumAmortizacion, 	AjusFecUlVenAmo,	AjusFecExiVen,
				CalcInteresID,		TipoPagoCapital,	ProductoCreditoID,	ClienteID,			MontoPorComAper,
				TipoCalInteres,		NumAmortInteres,	TasaBase, 			SobreTasa, 			CobraSeguroCuota,
                CobraIVASeguroCuota,MontoSeguroCuota,	ConvenioNominaID
		INTO
				Var_Monto,			Var_TasaFija,		Var_PeriodCap,		Var_PeriodInt,		Var_FrecCap,
				Var_FrecInter,		Var_DiaPagCap,		Var_DiaPagIn,		Var_DiaMesCap,		Var_DiaMesIn,
				Var_FechaIni,		Var_FechInha,		Var_NumAmorti,		Var_AjFeUlVA,		Var_AjFecExV,
				Var_CalcInter,		Var_TipoPagCap,		Var_Producto,		Var_Cliente,		Var_MonComA,
				Var_TipoCalIn,		Var_NumAmoInt,
				Var_TasaBase,		Var_SobreTasa,		Var_CobraSeguroCuota, Var_CobraIVASeguroCuota,
				 Var_MontoSeguroCuota, Var_ConvenioNomina
		FROM	SOLICITUDCREDITO
			WHERE SolicitudCreditoID  = Par_SolicitudCreditoID;


		SELECT LineaCreditoID INTO Var_LineaCreditoID
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoOrigenID;


		-- Determina el Monto de La Comisión por Anualidad de Línea de Crédito
        SELECT CobraComAnual,	SaldoComAnual, ComisionCobrada
			INTO Var_CobraComAnual,	Var_SaldoComAnual, 	Var_ComisionCobrada
		FROM LINEASCREDITO
        WHERE LineaCreditoID= Var_LineaCreditoID;

        SET Var_CobraComAnual := IFNULL(Var_CobraComAnual,Cadena_Vacia);
        SET Var_SaldoComAnual := IFNULL(Var_SaldoComAnual,Entero_Cero);
        SET Var_ComisionCobrada := IFNULL(Var_ComisionCobrada,Cadena_Vacia);
		SET Var_ConvenioNomina	:=IFNULL(Var_ConvenioNomina, Entero_Cero);
        IF(Var_LineaCreditoID<>Entero_Cero AND Var_CobraComAnual='S' AND Var_ComisionCobrada='N')THEN
			SET Var_ComAnualLin := Var_SaldoComAnual;
        ELSE
			SET Var_ComAnualLin := Entero_Cero;
        END IF;

            SET Var_Cuenta := (SELECT  Cre.CuentaID FROM CREDITOS Cre
								WHERE Cre.CreditoID = Par_CreditoOrigenID
                                LIMIT 1);
		SET Var_CobraSeguroCuota := IFNULL(Var_CobraSeguroCuota, 'N');
		SET Var_CobraIVASeguroCuota := IFNULL(Var_CobraIVASeguroCuota, 'N');
		SET Var_MontoSeguroCuota := IFNULL(Var_MontoSeguroCuota, Entero_Cero);

		# Se evalua el dia/mes Capital
		CASE Var_DiaPagCap
			WHEN Var_Aniversario	THEN SET Var_DiaMesCap	:= DAY(Par_FechaInicioAmor);
			WHEN Var_DiaDelMes		THEN SET Var_DiaMesCap	:= IFNULL(Var_DiaMesCap, DAY(Par_FechaInicioAmor));
			WHEN Var_Indistinto		THEN SET Var_DiaMesCap	:= IFNULL(Var_DiaMesCap, DAY(Par_FechaInicioAmor));
			ELSE SET Var_DiaMesCap	:= DAY(Par_FechaInicioAmor);
		END CASE ;

		# Se evalua el dia/mes Interes
		CASE Var_DiaPagIn
			WHEN Var_Aniversario	THEN SET Var_DiaMesIn	:= DAY(Par_FechaInicioAmor);
			WHEN Var_DiaDelMes		THEN SET Var_DiaMesIn	:= IFNULL(Var_DiaMesIn, DAY(Par_FechaInicioAmor));
			WHEN Var_Indistinto		THEN SET Var_DiaMesIn	:= IFNULL(Var_DiaMesIn, DAY(Par_FechaInicioAmor));
			ELSE SET Var_DiaMesIn	:= DAY(Par_FechaInicioAmor);
		END CASE ;

       -- SI ES UNA REESTRCUTURA CREADA POR CRCBREESTRUCTURACREDPRO BORRO LAS AMORTIZACIONES PREVIAS
       IF Aud_ProgramaID = 'CRCBREESTRUCTURACREDPRO' THEN
				    DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion;
       END IF;

		# Se calculan las amortizaciones de pago CRECIENTES cuando la tasa de interes sea Tasa Fija
		IF(Var_CalcInter = TasFija ) THEN
		 SELECT AporteCliente INTO Var_Garantia FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
			CASE Var_TipoPagCap
				WHEN PagCrecientes THEN

					CALL CREPAGCRECAMORPRO (
						Var_ConvenioNomina,
						Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_FrecCap,		Var_DiaPagCap,
						Var_DiaMesCap,			Par_FechaInicioAmor,		Var_NumAmorti,			Var_Producto,		Var_Cliente,
						Var_FechInha,			Var_AjFeUlVA,				Var_AjFecExV,			Var_MonComA,		Var_Garantia,
						Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Var_ComAnualLin,	SalidaNO,
                        Par_NumErr,             Par_ErrMen,					Par_NumTransSim,		Var_NumCuotas,		Par_ValorCAT,
                        Par_MontoCuo,			Par_FechaVen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
                        Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

				WHEN PagIguales THEN
					# Se calculan las amortizaciones de pago IGUALES
					CALL CREPAGIGUAMORPRO (
						Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_PeriodInt,			Var_FrecCap,
						Var_FrecInter,			Var_DiaPagCap,				Var_DiaPagIn,			Par_FechaInicioAmor,	Var_NumAmorti,
						Var_NumAmoInt,			Var_Producto,				Var_Cliente,			Var_FechInha,			Var_AjFeUlVA,
						Var_AjFecExV,			Var_DiaMesIn,				Var_DiaMesCap,			Var_MonComA,			Var_Garantia,
						Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Var_ComAnualLin,		SalidaNO,
                        Par_NumErr,				Par_ErrMen,					Par_NumTransSim,		Var_NumCuotas,			Var_NumCuotInt,
                        Par_ValorCAT,			Par_MontoCuo,				Par_FechaVen,			Par_EmpresaID,			Aud_Usuario,
                        Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


				END CASE ;
		END IF;

		# Se calculan las amortizaciones cuando la tasa no sea Fija
		IF(Var_CalcInter != TasFija ) THEN
			IF(Var_TipoPagCap = PagIguales )THEN


				SELECT	Valor	INTO Var_ValorTasa
									FROM	TASASBASE
									WHERE TasaBaseID = Var_TasaBase;

				SET Var_TasaBPuntos := IFNULL(Var_ValorTasa, Entero_Cero) + IFNULL(Var_SobreTasa, Entero_Cero);

            # Se calculan las amortizaciones cuando el tipo de pago sea IGUALES
			CALL CREPAGIGUAMORPRO (
				Var_Monto,				Var_TasaBPuntos,			Var_PeriodCap,			Var_PeriodInt,			Var_FrecCap,
				Var_FrecInter,			Var_DiaPagCap,				Var_DiaPagIn,			Par_FechaInicioAmor,	Var_NumAmorti,
				Var_NumAmoInt,			Var_Producto,				Var_Cliente,			Var_FechInha,			Var_AjFeUlVA,
				Var_AjFecExV,			Var_DiaMesIn,				Var_DiaMesCap,			Var_MonComA,			Var_Garantia,
				Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota,	Var_ComAnualLin,		SalidaNO,
				Par_NumErr,				Par_ErrMen,					Par_NumTransSim,		Var_NumCuotas,			Var_NumCuotInt,
                Par_ValorCAT,			Par_MontoCuo,				Par_FechaVen,			Par_EmpresaID,			Aud_Usuario,
                Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
				END IF;
			END IF;


		IF(Var_TipoCalIn = TipoCalIntGlo) THEN
			DELETE FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransSim;
			SELECT AporteCliente INTO Var_Garantia FROM SOLICITUDCREDITO WHERE CreditoID = Par_SolicitudCreditoID;
			CALL CRESIMSALGLOPRO (
					Var_Monto,				Var_TasaFija,				Var_PeriodCap,			Var_FrecCap,		Var_DiaPagCap,
					Var_DiaMesCap,			Par_FechaInicioAmor,		Var_NumAmorti,			Var_Producto,		Var_Cliente,
					Var_FechInha,			Var_AjFeUlVA,				Var_AjFecExV,			Var_MonComA,		Var_Garantia,
					Var_CobraSeguroCuota,	Var_CobraIVASeguroCuota,	Var_MontoSeguroCuota, 	Var_ComAnualLin,	SalidaNO,
                    Par_NumErr,				Par_ErrMen,					Par_NumTransSim,		Var_NumCuotas,		Par_ValorCAT,
                    Par_MontoCuo,			Par_FechaVen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
                    Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);
		END IF;

        		-- verifica que no hubo error en la simulacion
		IF(Par_NumErr != Entero_Cero ) THEN
			SET varControl 	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF; -- fin IF(Par_NumErr != Entero_Cero )


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen	:= Cadena_Vacia;

		-- llama al sp que Graba las amortizaciones temporales en la tabla de amortizaciones definitivas
		CALL AMORTICREDITOALT (
				Par_CreditoOrigenID,		Par_NumTransSim,	Var_Cliente,		Var_Cuenta,			Var_MontoCre,
				CalendarioReestr,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario, 		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);


		IF(Par_NumErr = Entero_Cero ) THEN

			-- Elimina amortizaciones temporales si no se trata de un pago de capital libre
			IF(Var_TipoPagCap != PagLibres) THEN
				DELETE
					FROM TMPPAGAMORSIM
					WHERE NumTransaccion= Par_NumTransSim;
			END IF;

			UPDATE CREDITOS SET
				DiaMesCapital	= Var_DiaMesCap,
				DiaMesInteres	= Var_DiaMesIn,
				FechaInicioAmor = Par_FechaInicioAmor
			WHERE CreditoID = Par_CreditoOrigenID;

			SELECT	MIN(FechaInicio), 	MAX(FechaVencim)
			INTO Var_FecInicio,		Var_FecTermin
			FROM AMORTICREDITO WHERE CreditoID= Par_CreditoOrigenID;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := Cadena_Vacia;
			CALL CREDITOSACT(
					Par_CreditoOrigenID,	Par_NumTransSim,	Fecha_Vacia,		Entero_Cero,		Act_CreditoAmor,
					Var_FechaSis,			Var_FecTermin,		Par_ValorCAT,	 	Entero_Cero,		Entero_Cero,
					Cadena_Vacia,			Cadena_Vacia,    	Entero_Cero,		SalidaNO,			Par_NumErr,
					Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal, 		Aud_NumTransaccion);

				-- Actualiza la Fecha Inicio y Fecha de Vencimiento en la tabla SEGUROVIDA
				SET Aud_FechaActual := NOW();
				UPDATE SEGUROVIDA Seg
					INNER JOIN CREDITOS Cre
					ON(Seg.CreditoID = Cre.CreditoID)
				SET Seg.FechaInicio 		= Var_FecInicio,
					Seg.FechaVencimiento 	= Var_FecTermin,

					Seg.EmpresaID 			= Par_EmpresaID,
					Seg.Usuario				= Aud_Usuario,
					Seg.FechaActual 		= Aud_FechaActual,
					Seg.DireccionIP 		= Aud_DireccionIP,
					Seg.ProgramaID 			= Aud_ProgramaID,
					Seg.Sucursal			= Aud_Sucursal,
					Seg.NumTransaccion		= Aud_NumTransaccion
				WHERE Seg.CreditoID 		= Par_CreditoOrigenID
						AND Cre.Estatus IN (Cre_Inactivo,Cre_Autorizado);

				-- verifica que no exista nungun error al actualizar el credito
				IF(Par_NumErr != Entero_Cero ) THEN
					SET varControl 	:= 'creditoID';
					LEAVE ManejoErrores;
				END IF;


		END IF; -- fin IF(Par_NumErr = Entero_Cero )


		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= CONCAT('Amortizaciones Grabadas Exitosamente: ', Par_CreditoOrigenID);
		SET varControl 	:= 'exportarPDF';

	END ManejoErrores;


	 IF (Par_Salida = SalidaSI) THEN
		SELECT CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl 		AS control,
				Entero_Cero 	AS consecutivo;
	 END IF;

END TerminaStore$$