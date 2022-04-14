-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOSPEIPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOSPEIPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGOCREDITOSPEIPRO`(
-- =========================================================
-- SP PARA REALIZAR PAGO O PREPAGO DE CREDITO DESDE UN SPEI
-- =========================================================
	Par_CreditoID		BIGINT(12), 		-- Identificador del Crédito
	Par_CuentaAhoID 	BIGINT(12),			-- Identificador de la Cuenta de Ahorro
	Par_MontoPago		DECIMAL(12,2),		-- Monto del Pago
	Par_FechaOper		DATE,				-- Fecha de Operacion
	Par_Poliza 			BIGINT,				-- Identificador de la Poliza

	Par_Salida 			CHAR(1),			-- Parametros de Salida
INOUT Par_NumErr		INT,				-- Numero de Error
INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID 		INT(11),
	Aud_Usuario 		INT(11),
	Aud_FechaActual 	DATETIME,
	Aud_DireccionIP 	VARCHAR(20),
	Aud_ProgramaID 		VARCHAR(50),
	Aud_Sucursal 		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore:BEGIN

	/*Declaración de Variables*/
	DECLARE Var_ProducCredito 			INT(11);		-- Variable para el Producto de Crédito
	DECLARE Var_ParticipaSpei 			CHAR(1);		-- Variable Indica Si Participa en SPEI o no
	DECLARE Var_ProductoCLABE 			CHAR(3);		-- Variable CLABE del SPEI del producto de crédito
	DECLARE Var_PermitePrepago 			CHAR(1);		-- Indica si permite prepago o no
	DECLARE Var_MontoExigible 			DECIMAL(12,2);	-- Monto Exigible del crédito
	DECLARE Var_DiferenciaPago			DECIMAL(12,2);	-- Diferencia entre monto exigible y el monto a pagar
	DECLARE Var_FechaExigible 			DATE;			-- Fecha de Exigibilidad
	DECLARE Var_MonedaID 				INT(11);		-- Moneda ID
	DECLARE Var_MontoPagado 			DECIMAL(12,2);	-- Monto de Pago
	DECLARE Var_Origen 					CHAR(1);		-- Origen del Pago
	DECLARE Var_Control 				VARCHAR(50);	-- Variable de control
	DECLARE Var_MontoPago 				DECIMAL(12,2);	-- Variable para guardar el monto de pago a realizar
	DECLARE Par_Consecutivo 			BIGINT;
	DECLARE Var_CuentaCLABE				VARCHAR(18);	-- Cuenta CLABE
	DECLARE Var_ValorParametro			INT(11);		-- Valor del Cliente Especifico
    DECLARE Var_AplicaPagAutCre     	CHAR(1);		-- Aplica Pago automatico
	DECLARE Var_EnCasoNoTieneExiCre		CHAR(1);		-- En caso tener Exigible. A.-Abono a Cta. P.-Prepago
	DECLARE Var_EnCasoSobrantePagCre 	CHAR(1);		-- En Caso tener Sobrante. A.-Abono a Cta. P.-Prepago
    DECLARE Var_FechaSistema			DATE;			-- Fecha del sistema
    DECLARE Var_Cliente					INT(11);		-- Cliente
    DECLARE Var_SucursalOrigen			INT(11);		-- Sucursal del cliente Cliente
    DECLARE Var_Poliza					INT(11);		-- Poliza
    DECLARE Var_MontoDeuda    			DECIMAL(14,2);	-- Monto total de la deuda
    DECLARE Var_DifTotalPag    			DECIMAL(14,2);	-- Monto de diferencia del total del pago de credito

	/* Declaracion de Constantes*/
	DECLARE Entero_Cero 				INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno					INT(11);		-- Constante Entero Uno
	DECLARE Cadena_Vacia 				CHAR(1);		-- Constante Cadena Vacía
	DECLARE Cons_SI 					CHAR(1);		-- Constante SI
	DECLARE Constante_NO				CHAR(1);		-- Constante NO
	DECLARE AltaPoliza_Si 				CHAR(1);		-- Alta de Poliza
	DECLARE AltaPoliza_No 				CHAR(1);		-- Origen del Pago
	DECLARE Var_ModoPago 				CHAR(1);		-- Modo de pago. S: SPEI
	DECLARE Pagada						CHAR(1);		-- Constante Pagada
	DECLARE RespaldaCredSI				CHAR(1);
	DECLARE CliProcEspecifico			VARCHAR(30);	-- Cliente especifico
	DECLARE Abono						CHAR(1);		-- Abono
	DECLARE DescripcionMovSob			VARCHAR(150);	-- Descripcion de abono en caso que el pago de credito tenga sobrante
	DECLARE DescripcionMov				VARCHAR(150);	-- Descripcion de movimiento
	DECLARE ConceptoCon					INT(11);		-- Concepto contable de la tabla CONCEPTOSCONTA
	DECLARE TipoMov						INT(11);		-- Tipo de movimiento de la tabla TIPOSMOVSAHO
	DECLARE ConceptoAhorro				INT(11);		-- Concepto de AHorro de la tabla CONCEPTOSAHORRO
	DECLARE Prepago						CHAR(1);		-- Prepago
	DECLARE FechaVacia					DATE;			-- Fecha Vacia
	DECLARE Bloqueo						CHAR(1);		-- Bloqueo de saldo de CTA.
	DECLARE DesBloqueo					VARCHAR(50);	-- Descripcion de Bloqueo de saldo de CTA.
	DECLARE TipoBloqueo					INT(11);		-- Tipo de Bloque de la tabla TIPOSBLOQUEOS
	DECLARE RealizoPagoTotal			CHAR(1);		-- Indica si realizo el pago total del credito
	DECLARE Var_EstatusCastigado		CHAR(1);		-- Estatus Castigado
	DECLARE Var_EstatusCredito			CHAR(1);		-- Estatus Credito
	DECLARE Var_Descripcion 			VARCHAR(100);	-- Descripcion

	/* SALDOS DE CREDITOS CASTIGADOS*/
	DECLARE Var_SaldoCapital    		DECIMAL(14,2);
	DECLARE Var_SaldoInteres    		DECIMAL(14,2);
	DECLARE Var_SaldoMoratorio  		DECIMAL(14,2);
	DECLARE Var_SaldoAccesorios 		DECIMAL(14,2);
	DECLARE Var_PorRecuperar  			DECIMAL(14,2);

	DECLARE Var_AplicaIVA       		CHAR(1);
	DECLARE Var_TasaIVA         		DECIMAL(12,2);
	DECLARE Decimal_Cero				DECIMAL(12,2);
	DECLARE Var_NatCargo				CHAR(1);
	DECLARE Var_DescripcionCast			VARCHAR(100);

	DECLARE Var_TipoMovAhoID			VARCHAR(5);
    DECLARE Con_AhoCapital  			INT(11);
    DECLARE Var_CuentaStr      			VARCHAR(20);
    DECLARE Var_CreditoStr      		VARCHAR(20);

	/*Asignación de Contantes*/
	SET Entero_Cero						:= 0;
	SET Entero_Uno						:= 1;
	SET Cadena_Vacia 					:= '';
	SET Cons_SI 						:= 'S';
	SET Constante_NO 					:= 'N';
	SET AltaPoliza_Si 					:= 'S';
	SET Decimal_Cero					:= 0.00;
	SET Var_ModoPago 					:= 'S';
	SET Pagada 							:= 'P';
	SET RespaldaCredSI					:= 'S';
	SET CliProcEspecifico 				:= 'CliProcEspecifico';
	SET Abono		  					:= 'A';
	SET DescripcionMovSob	  			:= 'Abono Sobrante del Pago de Credito Por SPEI';
	SET DescripcionMov		  			:= 'No Permite Prepago SPEI';
	SET ConceptoCon						:= 808;
	SET TipoMov							:= 224;
	SET ConceptoAhorro					:= 1;
	SET Prepago							:= "P";
	SET FechaVacia						:= '1900-01-01';
	SET Bloqueo							:= 'B';
	SET DesBloqueo						:= 'BLOQUEO AUTOMATICO SPEI RECEPCION';
	SET TipoBloqueo						:= 16;
	SET RealizoPagoTotal				:= 'N';
    SET Var_EstatusCastigado			:= 'K';
    SET Var_Descripcion					:= 'PAGO DE CREDITO SPEI';
    SET Var_NatCargo					:= 'C';
    SET Var_DescripcionCast				:= 'PAGO DE CREDITO CASTIGADO SPEI';
    SET Var_CreditoStr 					:= CONCAT("Cred.",CONVERT(Par_CreditoID, CHAR(20)));
    SET Var_CuentaStr   				:= CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));
	SET Var_Origen 						:= 'S'; -- Origen de Pago SPEI
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOSPEIPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;

		SELECT MonedaBaseID, FechaSistema INTO Var_MonedaID, Var_FechaSistema
		FROM PARAMETROSSIS;
		-- VERIFICAR SI EL CREDITO ES CASTIGADO
		SELECT Estatus
			INTO  Var_EstatusCredito
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

        -- Consulta de Parametros
        SELECT AplicaPagAutCre, 		EnCasoNoTieneExiCre, 			EnCasoSobrantePagCre
			INTO Var_AplicaPagAutCre, 	Var_EnCasoNoTieneExiCre, 		Var_EnCasoSobrantePagCre
		FROM SPEIPARAMPAGOCRE;

        SET Var_AplicaPagAutCre := IFNULL(Var_AplicaPagAutCre, Cons_SI);
        SET Var_EnCasoNoTieneExiCre := IFNULL(Var_EnCasoNoTieneExiCre, Prepago);
        SET Var_EnCasoSobrantePagCre := IFNULL(Var_EnCasoSobrantePagCre, Prepago);

		-- Obtiene Producto de Crédito
		SELECT 	 ProductoCreditoID, 		Clabe,				ClienteID
			INTO Var_ProducCredito, 		Var_CuentaCLABE,	Var_Cliente
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

        SET Var_Cliente := IFNULL(Var_Cliente, Entero_Cero);
        SET Var_ProducCredito := IFNULL(Var_ProducCredito, Entero_Cero);
        SET Var_CuentaCLABE := IFNULL(Var_CuentaCLABE, Cadena_Vacia);

        SELECT SucursalOrigen INTO Var_SucursalOrigen
			FROM CLIENTES
            WHERE ClienteID = Var_Cliente;

		-- Obtiene valores del parametros SPEI
		SELECT IFNULL(ParticipaSpei,Constante_NO), IFNULL(ProductoCLABE,Cadena_Vacia), IFNULL(PermitePrepago,Cadena_Vacia)
			INTO Var_ParticipaSpei, Var_ProductoCLABE, Var_PermitePrepago
		FROM PRODUCTOSCREDITO
        WHERE ProducCreditoID = Var_ProducCredito;

        IF (Var_ParticipaSpei=Constante_NO) THEN
        	SET Par_NumErr 	:= 014;
			SET Par_ErrMen 	:= 'El Producto No Participa en SPEI.';
			LEAVE ManejoErrores;
        END IF;

        IF (Var_CuentaCLABE=Cadena_Vacia) THEN
        	SET Par_NumErr 	:= 014;
			SET Par_ErrMen 	:= 'El crédito No Cuenta con una Cuenta CLABE SPEI.';
			LEAVE ManejoErrores;
        END IF;

        -- Obtiene Monto Exigible y Diferencia entre el pago exigible.
        SET Var_MontoExigible 	:= FUNCIONEXIGIBLE(Par_CreditoID);
        SET Var_DiferenciaPago 	:= (Par_MontoPago - Var_MontoExigible);
        SET Var_DiferenciaPago 	:= IFNULL(Var_DiferenciaPago,Entero_Cero);

        -- Obtiene Fecha de Exigibilidad
        SELECT MIN(FechaExigible) INTO Var_FechaExigible
            FROM AMORTICREDITO
            WHERE CreditoID = Par_CreditoID
            AND Estatus <> Pagada;

        SELECT FUNCIONTOTDEUDACRE(Par_CreditoID) INTO Var_MontoDeuda;

        IF(Var_AplicaPagAutCre = Cons_SI AND Var_EstatusCredito <> Var_EstatusCastigado)THEN
			-- Validaciones para determinar si realizar pagos o prepagos de crédito
			IF(Var_FechaExigible<=Par_FechaOper)THEN
				-- Obtiene el monto a pagar para el pago o prepago
				IF(Par_MontoPago>Var_MontoDeuda)THEN
					SET Var_DifTotalPag := Par_MontoPago-Var_MontoDeuda;
					SET Var_MontoPago := Var_MontoDeuda;
                    SET RealizoPagoTotal := "S";
                ELSEIF(Par_MontoPago>Var_MontoExigible)THEN
					SET Var_MontoPago := Var_MontoExigible;
				ELSE
					SET Var_MontoPago := Par_MontoPago;
				END IF;

				CALL PAGOCREDITOPRO(
					Par_CreditoID, 	Par_CuentaAhoID, 	Var_MontoPago,			Var_MonedaID,		Constante_NO,
					Constante_NO,	Par_EmpresaID,		Constante_NO,			AltaPoliza_Si,		Var_MontoPagado,
					Par_Poliza,		Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Var_ModoPago,
					Var_Origen,		Constante_NO,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
				-- VALIDACION SI TIENE SOBRANTE
				IF(Var_DiferenciaPago>Entero_Cero AND Var_DiferenciaPago>Entero_Uno)THEN
					-- VALIDAMOS SI PERMITE PREPAGO
					IF(IFNULL(Var_PermitePrepago,Cadena_Vacia)=Cons_SI AND Var_EnCasoNoTieneExiCre=Prepago)THEN
						CALL PREPAGOCREDITOPRO(
							Par_CreditoID,		Par_CuentaAhoID,	Var_DiferenciaPago,		Var_MonedaID,		Par_EmpresaID,
							Constante_NO,		AltaPoliza_No,		Var_MontoPagado,		Par_Poliza,			Par_NumErr,
							Par_ErrMen,			Par_Consecutivo,	Var_ModoPago,			Var_Origen,			Constante_NO,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;

				END IF;

			-- VALIDACION SI NO TIENE EXIGIBLE
			ELSEIF(Var_FechaExigible>Par_FechaOper)THEN
				IF(Par_MontoPago>Var_MontoDeuda)THEN
					SET Par_MontoPago := Var_MontoDeuda;
				END IF;

				IF(Par_MontoPago < Var_MontoDeuda AND IFNULL(Var_PermitePrepago,Cadena_Vacia)=Cons_SI AND Var_EnCasoNoTieneExiCre=Prepago)THEN
					-- VALIDACION SI PERMITE PREPAGO
					CALL PREPAGOCREDITOPRO(
						Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPago,			Var_MonedaID,		Par_EmpresaID,
						Constante_NO,		AltaPoliza_Si,		Var_MontoPagado,		Par_Poliza,			Par_NumErr,
						Par_ErrMen,			Par_Consecutivo,	Var_ModoPago,			Var_Origen,			Constante_NO,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;


			END IF;
		END IF; -- FIN SI REALIZA PAGO AUTOMATICO PARA CREDITOS DIFERENTES DE CASTIGADOS


		IF(Var_AplicaPagAutCre = Cons_SI AND Var_EstatusCredito = Var_EstatusCastigado)THEN  -- INICIA EL PAGO DE CREDITO CASTIGADO

			-- PARAMETROS PARA LA RECUPERACION DE CARTERA CASTIGADA
			SELECT IVARecuperacion INTO  Var_AplicaIVA
			FROM PARAMSRESERVCASTIG
			WHERE EmpresaID = Par_EmpresaID;

			SET Var_AplicaIVA   := IFNULL(Var_AplicaIVA, Cons_SI);

			-- APLICA IVA SEGUN EL PARAMETRO
			IF(Var_AplicaIVA = Cons_SI) THEN
			    SELECT Suc.IVA INTO Var_TasaIVA
			        FROM CREDITOS Cre,
			             SUCURSALES Suc
			        WHERE CreditoID = Par_CreditoID
			          AND Cre.SucursalID = Suc.SucursalID;
			END IF;

			 -- DATOS GENERALES DEL CREDITO CASTIGADO
		    SELECT   SaldoCapital,      SaldoInteres,     SaldoMoratorio,     SaldoAccesorios
		        INTO Var_SaldoCapital,  Var_SaldoInteres, Var_SaldoMoratorio, Var_SaldoAccesorios
		    FROM CRECASTIGOS
		    WHERE CreditoID = Par_CreditoID;

		     -- Inicializaciones
		    SET Var_SaldoCapital    := IFNULL(Var_SaldoCapital, Decimal_Cero );
		    SET Var_SaldoInteres    := IFNULL(Var_SaldoInteres, Decimal_Cero );
		    SET Var_SaldoMoratorio  := IFNULL(Var_SaldoMoratorio, Decimal_Cero );
		    SET Var_SaldoAccesorios := IFNULL(Var_SaldoAccesorios, Decimal_Cero );

			SET Var_PorRecuperar :=  ROUND(Var_SaldoCapital 	 * (1+Var_TasaIVA),2) +
			                         ROUND(Var_SaldoInteres		 * (1+Var_TasaIVA),2) +
			                         ROUND(Var_SaldoMoratorio	 * (1+Var_TasaIVA),2) +
			                         ROUND(Var_SaldoAccesorios 	 * (1+Var_TasaIVA),2);

			IF(Var_PorRecuperar > Decimal_Cero) THEN -- INICIO DE CREDITO CASTIGADO
				/* SE HACE EL CARGO A LA CUENTA*/
	  			SET Var_TipoMovAhoID	:= '101'; 		-- PAGO DE CREDITO

	            CALL CUENTASAHOMOVSALT(
	                Par_CuentaAhoID,     Aud_NumTransaccion,     Par_FechaOper,        		 Var_NatCargo,     	 Par_MontoPago,
	                Var_DescripcionCast, Var_CreditoStr,         Var_TipoMovAhoID,           Constante_NO,       Par_NumErr,
	                Par_ErrMen,          Par_EmpresaID,          Aud_Usuario,                Aud_FechaActual,    Aud_DireccionIP,
	                Aud_ProgramaID,      Aud_Sucursal,           Aud_NumTransaccion);

	            IF(Par_NumErr > Entero_Cero)THEN
	                LEAVE ManejoErrores;
	            END IF;

				SET Con_AhoCapital  := 1;               -- Concepto Contable de Ahorro: Pasivo

	            CALL POLIZASAHORROPRO(
	                Par_Poliza,         Par_EmpresaID,        Par_FechaOper,       		Var_Cliente,     	Con_AhoCapital,
	                Par_CuentaAhoID,    Var_MonedaID,     	  Par_MontoPago,            Decimal_Cero,       Var_DescripcionCast,
	                Var_CuentaStr,      Constante_NO,         Par_NumErr,              	Par_ErrMen,         Aud_Usuario,
	                Aud_FechaActual,    Aud_DireccionIP,      Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

	            IF(Par_NumErr > Entero_Cero)THEN
	                LEAVE ManejoErrores;
	            END IF;

				IF(Par_MontoPago>Var_PorRecuperar)THEN
					SET Par_MontoPago := Var_PorRecuperar;
				END IF;

				CALL CRECASTIGOSRECPRO(	Par_CreditoID, 		Par_MontoPago,			Entero_Cero,	Par_Poliza,			Var_Descripcion,
										Constante_NO, 		Par_NumErr,				Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, Aud_Sucursal, 		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF; -- FIN SI TIENE SALDO POR RECUPERAR
		END IF; -- FIN RECUPERACION DE CREDITO CASTIGADO


        SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= "Pago de Credito Via SPEI Realizado Exitosamente.";
		SET Var_Control	:= 'creditoID' ;
		SET Par_Consecutivo := Par_CreditoID;

    END ManejoErrores;

    IF (Par_Salida = Cons_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$