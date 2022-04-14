-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINFONDEOCANCELPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINFONDEOCANCELPRO`;DELIMITER $$

CREATE PROCEDURE `MINFONDEOCANCELPRO`(
/* SP QUE CANCELA LA MINISTRACION DE ACUERDO AL TIPO DE CANCELACION DEL CREDITO PASIVO */
	Par_CreditoID 					BIGINT(12),			-- Número de Crédito
	Par_CreditoFondeoID				BIGINT(20),			-- Número del Crédito Pasivo (CREDITOFONDEO).
	Par_Numero						INT(11),			-- Número de la Ministración a Cancelar.
	Par_Salida						CHAR(1),			-- Tipo de Salida.
	INOUT Par_NumErr				INT(11),			-- Número de Error.
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error.

	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),

	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_FechaSistema			DATE;				-- Fecha del sistema
DECLARE Var_AmortizacionID			INT(11);			-- Número de Amortización
DECLARE Var_UltimaMinistracion		INT(11);			-- Número de la Última Ministración
DECLARE Var_EstatusMinistracion		CHAR(1);			-- Estatus de la Ministración
DECLARE Var_TipoCancelacion			CHAR(1);			-- Tipo de Cancelación
DECLARE Var_MontoCancelar			DECIMAL(14,2);		-- Monto de la Ministración Cancelada
DECLARE Var_MontoDiferencia			DECIMAL(14,2);		-- Monto diferencia.
DECLARE Var_SaldoCapVigente			DECIMAL(14,2);		-- Monto de la Amortización.
DECLARE	Var_FechaPagoMinis			DATE;				-- Fecha de Pago Pactada de desembolso de la ministración
DECLARE Var_TotalAmor				INT(11);			-- Numero total de amortizaciones.
DECLARE Var_TotalAmorVivas			INT(11);			-- Numero total de amortizaciones vivas.
DECLARE Var_Consecutivo				BIGINT(12);			-- Número consecutivo
DECLARE Var_Control					VARCHAR(50);		-- Control id
DECLARE Var_CreditoFondeoID			BIGINT(20);			-- Id del credito pasivo
DECLARE Var_TipoFondeo				CHAR(1);			-- Tipo de Fondeo: P .- Recursos Propios F .- Institucion de Fondeo

-- Declaracion de Constantes
DECLARE Cadena_Vacia				CHAR(1);
DECLARE Fecha_Vacia					DATE;
DECLARE Entero_Cero					INT(11);
DECLARE Entero_Uno					INT(11);
DECLARE Decimal_Cero				DECIMAL(12, 2);
DECLARE TipoActInteres				INT(11);
DECLARE PrimerMinistracion			INT(11);
DECLARE TipoUltCuota				CHAR(1);
DECLARE TipoSigCuota				CHAR(1);
DECLARE TipoProrrateo				CHAR(1);
DECLARE SalidaSI					CHAR(1);
DECLARE SalidaNO					CHAR(1);
DECLARE EstatusPagado     			CHAR(1);
DECLARE EstatusActivo     			CHAR(1);
DECLARE EstatusInactivo    			CHAR(1);
DECLARE EstatusVencido    			CHAR(1);
DECLARE EstatusVigente    			CHAR(1);
DECLARE EstatusAtrasado				CHAR(1);
DECLARE EstatusCancelado			CHAR(1);
DECLARE Tipo_InstitucionFondeo		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia    				:= '';              -- Cadena Vacia
SET Fecha_Vacia     				:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero     				:= 0;               -- Entero en Cero
SET Entero_Uno   					:= 1;    	        -- Entero en Uno
SET Decimal_Cero    				:= 0.00;            -- Decimal Cero
SET TipoActInteres 					:= 1;    	        -- Tipo de actualizacion para los intereses
SET PrimerMinistracion				:= 1;    	        -- Número de la Primer Ministración.
SET TipoUltCuota					:= 'U';				-- Tipo de Cancelacion: Ultimas cuotas
SET TipoSigCuota					:= 'I';				-- Tipo de Cancelacion: A las cuotas siguientes inmediatas
SET TipoProrrateo					:= 'V';				-- Tipo de Cancelacion: Prorrateo en cuotas vivas
SET SalidaSI        				:= 'S';             -- El Store si Regresa una Salida
SET SalidaNO        				:= 'N';             -- El Store no Regresa una Salida
SET EstatusPagado     				:= 'P';            	-- Estatus: Pagado
SET EstatusActivo     				:= 'A';            	-- Estatus: Activo
SET EstatusInactivo    				:= 'I';            	-- Estatus: Inactivo
SET EstatusVencido    				:= 'B';            	-- Estatus: Vencido
SET EstatusVigente    				:= 'N';            	-- Estatus: Vigente
SET EstatusAtrasado					:= 'A';				-- Estatus: Atrasado
SET EstatusCancelado				:= 'C';             -- Estatus: Cancelado
SET Tipo_InstitucionFondeo			:= 'F';				-- Fondeo por Financiamiento

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-MINFONDEOCANCELPRO');
			SET Var_Control := 'sqlException';
		END;

	IF(IFNULL(Par_CreditoFondeoID,Entero_Cero)=Entero_Cero)THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= CONCAT('El Numero de Credito de Fondeo esta vacio.');
		SET Var_Control := 'creditofondeoID';
		SET Var_Consecutivo := Par_CreditoFondeoID;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Numero, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr	:= 2;
		SET Par_ErrMen	:= CONCAT('La Ministracion esta vacia.');
		SET Var_Control := 'numero';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Numero, Entero_Cero) = Entero_Uno) THEN
		SET Par_NumErr	:= 3;
		SET Par_ErrMen	:= CONCAT('La Primer Ministracion No se puede Cancelar.');
		SET Var_Control := 'numero';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	-- Se obtiene el monto, el estatus y la fecha de pago de la ministracion a cancelar
	SELECT Capital, 		Estatus, 					FechaPagoMinis
	INTO Var_MontoCancelar, Var_EstatusMinistracion,	Var_FechaPagoMinis
		FROM MINISTRACREDAGRO
			WHERE CreditoID = Par_CreditoID
				AND Numero = Par_Numero;

	IF(IFNULL(Var_MontoCancelar, Decimal_Cero)=Decimal_Cero)THEN
		SET Par_NumErr	:= 4;
		SET Par_ErrMen	:= CONCAT('El Monto a Cancelar esta vacio.');
		SET Var_Control := 'montoPagarPre';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_MontoCancelar, Decimal_Cero)<Entero_Uno)THEN
		SET Par_NumErr	:= 5;
		SET Par_ErrMen	:= CONCAT('El Monto a Pagar no debe ser menor a 1.');
		SET Var_Control := 'montoPagarPre';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Var_EstatusMinistracion, Cadena_Vacia) = EstatusCancelado) THEN
		SET Par_NumErr	:= 6;
		SET Par_ErrMen	:= CONCAT('La Ministracion ya se encuentra cancelada.');
		SET Var_Control := 'numero';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Numero, Entero_Cero) = PrimerMinistracion) THEN
		SET Par_NumErr	:= 7;
		SET Par_ErrMen	:= CONCAT('La Primer Ministracion no puede ser Cancelada.');
		SET Var_Control := 'numero';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;

	-- Se obiente el tipo de cancelación
	SET Var_TipoCancelacion := (SELECT Cre.TipoCancelacion
									FROM CREDITOFONDEO Cre WHERE Cre.CreditoFondeoID = Par_CreditoFondeoID);

	SET Var_TipoCancelacion	:= IFNULL(Var_TipoCancelacion, Cadena_Vacia);

	SET Aud_FechaActual		:= NOW();

	-- Se actualizan los Estatus de las Amortizaciones en AMOTICREDITOAGRO dependiendo cómo se encuentren en AMORTICREDITO.
	UPDATE AMORTIZAFONDEOAGRO AG
		INNER JOIN AMORTIZAFONDEO AM ON(AG.CreditoFondeoID = AM.CreditoFondeoID and AG.AmortizacionID = AM.AmortizacionID)
	    SET AG.Estatus = AM.Estatus
	WHERE AG.CreditoFondeoID = Par_CreditoFondeoID;

	-- Se obtiene el número total de amortizaciones
	SET	Var_TotalAmor	:= (SELECT MAX(AmortizacionID) FROM AMORTIZAFONDEOAGRO WHERE CreditoFondeoID = Par_CreditoFondeoID);

	-- Se obtiene la ultima ministración del calendario de ministraciones.
	SET Var_UltimaMinistracion := (SELECT MAX(Numero) FROM MINISTRACREDAGRO WHERE CreditoID = Par_CreditoID);
	SET Var_UltimaMinistracion := IFNULL(Var_UltimaMinistracion, Entero_Cero);

	IF (Var_TipoCancelacion = TipoUltCuota) THEN
		-- Tipo de Cancelacion: Ultimas cuotas
		-- Se obtiene el número de la amortizacion final vigente
		SET	Var_AmortizacionID	:= (SELECT MAX(AmortizacionID) FROM AMORTIZAFONDEOAGRO
									WHERE CreditoFondeoID = Par_CreditoFondeoID AND Estatus IN (EstatusVigente, EstatusInactivo));
		SET	Var_AmortizacionID	:= IFNULL(Var_AmortizacionID, Entero_Cero);

		-- Se redondea el nuevo monto calculado.
		SET Var_MontoCancelar := ROUND(Var_MontoCancelar, 2);

		/* Se recorren las amortizaciones para restar (de abajo arriba) el monto de la
		 * ministracion a cancelar. */
		WHILE(Var_AmortizacionID <= Var_TotalAmor AND Var_MontoCancelar > Entero_Cero)DO

			SET	Var_SaldoCapVigente	:= (SELECT Capital FROM AMORTIZAFONDEOAGRO
											WHERE CreditoFondeoID = Par_CreditoFondeoID AND AmortizacionID = Var_AmortizacionID);
			SET	Var_SaldoCapVigente	:= IFNULL(Var_SaldoCapVigente, Entero_Cero);

			/* Si el monto de la ministracion a cancelar es mayor al saldo de la amortización
			 * entonces se obtiene la diferencia para afectar a la amortizacion siguiente.
			 * */
			IF(Var_MontoCancelar > Var_SaldoCapVigente)THEN
				SET Var_MontoDiferencia := Var_MontoCancelar - Var_SaldoCapVigente;
				SET	Var_MontoDiferencia	:= IFNULL(Var_MontoDiferencia, Entero_Cero);
				SET Var_MontoCancelar	:= Var_SaldoCapVigente;
			ELSE
				SET	Var_MontoDiferencia	:= Entero_Cero;
			END IF;

			-- Se actualiza el saldo capital de la amortizacion
			UPDATE AMORTIZAFONDEOAGRO SET
				Capital = Capital - Var_MontoCancelar,
				MontoPendDesembolso = MontoPendDesembolso - Var_MontoCancelar,
				MontoCancelado = Var_MontoCancelar,
				NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoFondeoID = Par_CreditoFondeoID;

			-- Siguiente amortizacion
			SET Var_AmortizacionID	:= Var_AmortizacionID - Entero_Uno;
			SET Var_MontoCancelar	:= Var_MontoDiferencia;
		END WHILE;

	ELSEIF (Var_TipoCancelacion = TipoSigCuota) THEN
		-- Tipo de Cancelacion: A las cuotas siguientes inmediatas
		-- Se obtiene el número de la amortizacion actual
		SET	Var_AmortizacionID	:= (SELECT AmortizacionID FROM AMORTIZAFONDEOAGRO
									WHERE CreditoFondeoID = Par_CreditoFondeoID AND Var_FechaPagoMinis BETWEEN FechaInicio AND FechaVencim);
		SET	Var_AmortizacionID	:= IFNULL(Var_AmortizacionID, Entero_Cero);

		-- Se suma 1 amortizacion a la que se obtuvo (la siguiente inmediata)
		SET	Var_AmortizacionID	:= Var_AmortizacionID + Entero_Uno;

		-- Se redondea el nuevo monto calculado.
		SET Var_MontoCancelar := ROUND(Var_MontoCancelar, 2);

		/* Se recorren las amortizaciones para restar (de arriba abajo) el monto de la
		 * ministracion a cancelar. */
		WHILE(Var_AmortizacionID <= Var_TotalAmor AND Var_MontoCancelar > Entero_Cero)DO

			SET	Var_SaldoCapVigente	:= (SELECT Capital FROM AMORTIZAFONDEOAGRO
											WHERE CreditoFondeoID = Par_CreditoFondeoID AND AmortizacionID = Var_AmortizacionID);
			SET	Var_SaldoCapVigente	:= IFNULL(Var_SaldoCapVigente, Entero_Cero);

			/* Si el monto de la ministracion a cancelar es mayor al saldo de la amortización
			 * entonces se obtiene la diferencia para afectar a la amortizacion siguiente.
			 * */
			IF(Var_MontoCancelar > Var_SaldoCapVigente)THEN
				SET Var_MontoDiferencia := Var_MontoCancelar - Var_SaldoCapVigente;
				SET	Var_MontoDiferencia	:= IFNULL(Var_MontoDiferencia, Entero_Cero);
				SET Var_MontoCancelar	:= Var_SaldoCapVigente;
			ELSE
				SET	Var_MontoDiferencia	:= Entero_Cero;
			END IF;

			-- Se actualiza el saldo capital de la amortizacion
			UPDATE AMORTIZAFONDEOAGRO SET
				Capital = Capital - Var_MontoCancelar,
				MontoPendDesembolso = MontoPendDesembolso - Var_MontoCancelar,
				MontoCancelado = Var_MontoCancelar,
				NumTransaccion = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
					AND CreditoFondeoID = Par_CreditoFondeoID;

			-- Siguiente amortizacion
			SET Var_AmortizacionID	:= Var_AmortizacionID + Entero_Uno;
			SET Var_MontoCancelar	:= Var_MontoDiferencia;
		END WHILE;

	ELSEIF (Var_TipoCancelacion = TipoProrrateo) THEN
		-- Tipo de Cancelacion: Prorrateo de pago en cuotas vivas
		-- Se obtiene el número de la amortizacion que, apartir de la cual se aplicará el prorrateo.
		SET	Var_AmortizacionID	:= (SELECT AmortizacionID FROM AMORTIZAFONDEOAGRO
									WHERE CreditoFondeoID = Par_CreditoFondeoID AND Var_FechaPagoMinis BETWEEN FechaInicio AND FechaVencim);
		SET	Var_AmortizacionID	:= IFNULL(Var_AmortizacionID, Entero_Cero);

		-- Se obtene el total de cuotas a las cuales se les aplicará el prorrateo
		SELECT  COUNT(Amo.AmortizacionID)
		INTO Var_TotalAmorVivas
			FROM AMORTIZAFONDEOAGRO Amo INNER JOIN CREDITOFONDEO Cre ON(Amo.CreditoFondeoID = Cre.CreditoFondeoID)
			WHERE Cre.CreditoFondeoID   = Par_CreditoFondeoID
			  AND Cre.Estatus	  IN (EstatusVigente, EstatusInactivo)
			  AND Amo.Estatus	  = EstatusVigente
		      AND Amo.AmortizacionID > Var_AmortizacionID
			ORDER BY FechaExigible;

		SET Var_TotalAmorVivas := IFNULL(Var_TotalAmorVivas, Entero_Cero);

		-- Si el numero de coutas es mayor a cero entonces se hace la division del monto entre las cuotas vivas
		IF(Var_TotalAmorVivas > Entero_Cero)THEN
			SET Var_MontoCancelar := Var_MontoCancelar / Var_TotalAmorVivas;
		END IF;

		-- Se redondea el nuevo monto calculado.
		SET Var_MontoCancelar := ROUND(Var_MontoCancelar, 2);

		-- Se actualiza el saldo capital de las amortizaciones
		UPDATE AMORTIZAFONDEOAGRO SET
			Capital = Capital - Var_MontoCancelar,
			MontoPendDesembolso = MontoPendDesembolso - Var_MontoCancelar,
			MontoCancelado = Var_MontoCancelar,
			NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID > Var_AmortizacionID
						AND CreditoFondeoID = Par_CreditoFondeoID;

	END IF;

	/* Marcamos como Canceladas las Amortizaciones que hayan sido afectadas
	 * en la Cancelacion */
	UPDATE AMORTIZAFONDEOAGRO Amo  SET
		Estatus				= EstatusCancelado,
		EstatusDesembolso	= EstatusCancelado,
		FechaLiquida = Var_FechaSistema
		WHERE Capital = Entero_Cero
			AND Amo.CreditoFondeoID 	= Par_CreditoFondeoID
			AND FechaExigible > Var_FechaSistema
			AND Estatus NOT IN (EstatusCancelado, EstatusPagado, EstatusVencido)
			AND Amo.NumTransaccion = Aud_NumTransaccion;



	/* Si es la última ministración que se cancela y la ministración no es la primero y el tipo de cancelación es por últimas cuotas
	 * entonces se registran las amoritzaciónes que fueron canceladas (con saldo cero). */
	IF (Par_Numero = Var_UltimaMinistracion AND Par_Numero != Entero_Uno AND Var_TipoCancelacion = TipoUltCuota) THEN
		-- SE REGISTRAN LAS AMORTIZACIONES CANCELADAS EN AMORTIZAFONDEO
		INSERT INTO AMORTIZAFONDEO(
			CreditoFondeoID,	AmortizacionID,		FechaInicio,		FechaVencimiento,	FechaExigible,
			FechaLiquida,		Estatus,			Capital,			Interes,			IVAInteres,
			SaldoCapVigente,	SaldoCapAtrasad,	SaldoInteresAtra,	SaldoInteresPro,	SaldoIVAInteres,
			SaldoMoratorios,	SaldoIVAMora,		SaldoComFaltaPa,	SaldoIVAComFalP,	SaldoOtrasComis,
			SaldoIVAComisi,		ProvisionAcum,		SaldoCapital,		SaldoRetencion,		Retencion,
			EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,			NumTransaccion)
		SELECT
			CreditoFondeoID,	AmortizacionID,		FechaInicio,		FechaVencimiento,	FechaExigible,
			FechaLiquida,		Estatus,			Capital,			Interes,			IVAInteres,
			SaldoCapVigente,	SaldoCapAtrasad,	SaldoInteresAtra,	SaldoInteresPro,	SaldoIVAInteres,
			SaldoMoratorios,	SaldoIVAMora,		SaldoComFaltaPa,	SaldoIVAComFalP,	SaldoOtrasComis,
			SaldoIVAComisi,		ProvisionAcum,		SaldoCapital,		SaldoRetencion,		Retencion,
			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
			FROM AMORTIZAFONDEOAGRO
				WHERE CreditoFondeoID	= Par_CreditoFondeoID
					AND Estatus			= EstatusCancelado
					AND	FechaLiquida	= Var_FechaSistema
					AND NumTransaccion	= Aud_NumTransaccion;
	END IF;

	SET Par_NumErr	:= Entero_Cero;
	SET Par_ErrMen	:= 'Ministracion de Credito Cancelada Exitosamente.';
	SET Var_Control	:= 'numero';
	SET Var_Consecutivo = Par_CreditoFondeoID;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$