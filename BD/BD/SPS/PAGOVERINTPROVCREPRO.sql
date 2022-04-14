-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOVERINTPROVCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOVERINTPROVCREPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOVERINTPROVCREPRO`(



	Par_CreditoID       	BIGINT,
    Par_MontoPagar	    	DECIMAL(12,2),
	Par_ModoPago			CHAR(1),
	Par_CuentaAhoID     	BIGINT,
	Par_Poliza				BIGINT,
	Par_OrigenPago			CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida          	CHAR(1),

    INOUT Par_NumErr    	INT(10),
    INOUT Par_ErrMen    	VARCHAR(400),
	INOUT Par_MontoSaldo 	DECIMAL(12,2),

    Par_EmpresaID       	INT,
    Aud_Usuario         	INT,
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
    Aud_NumTransaccion  	BIGINT

)
TerminaStore: BEGIN



    DECLARE VarControl 		    	CHAR(20);
	DECLARE Var_FechaSistema    	DATE;
	DECLARE Var_FecAplicacion   	DATE;
	DECLARE Var_MontoSaldo	    	DECIMAL(12,2);
	DECLARE Var_ClienteID			INT(11);

    DECLARE Var_SucursalID      	INT;
	DECLARE Var_PagaIVA				CHAR(1);
	DECLARE Var_CobraIVAInteres		CHAR(1);
	DECLARE Var_MonedaID	    	INT(11);
    DECLARE Var_ProducCreditoID		INT(11);

    DECLARE Var_ClasificaCredito	CHAR(1);
	DECLARE Var_SubClasifCredito	INT;
	DECLARE Var_EstatusCredito		CHAR(1);
	DECLARE Var_AmortizacionID  	INT(4);
	DECLARE Var_SaldoInteresPro		DECIMAL(12, 4);

    DECLARE Var_SaldoInteresAtr		DECIMAL(12, 4);
	DECLARE Var_FechaInicio     	DATE;
	DECLARE Var_FechaVencim     	DATE;
	DECLARE Var_MontoIVAPagar	 	DECIMAL(12, 2);
	DECLARE Var_IVA					DECIMAL(12,2);

    DECLARE Var_IVAInteresOrdi		DECIMAL(12,2);
    DECLARE Var_MontoPagar     		DECIMAL(14, 4);
	DECLARE Var_Consecutivo			BIGINT;
	DECLARE Var_IvaIntProvAtr		DECIMAL(14,2);



    DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Entero_Cero     		INT;
	DECLARE Decimal_Cero			DECIMAL(4,2);
	DECLARE SalidaNO        		CHAR(1);
	DECLARE SalidaSI        		CHAR(1);

    DECLARE Estatus_Vigente    		CHAR(1);
	DECLARE Estatus_Atrasado  		CHAR(1);
	DECLARE Estatus_Vencido    		CHAR(1);
	DECLARE Monto_MinimoPago    	DECIMAL(12,2);
	DECLARE SiPagaIVA       		CHAR(1);

    DECLARE Des_PagoCredito			VARCHAR(50);
	DECLARE Mov_Referencia			VARCHAR(50);
	DECLARE Naturaleza_Cargo        CHAR(1);



    DECLARE CURSORAMORTIZACIONES CURSOR FOR
		SELECT  Amo.AmortizacionID, 	Amo.SaldoInteresPro, 	Amo.SaldoInteresAtr,	Amo.FechaInicio,
				Amo.FechaVencim
		FROM AMORTICREDITO Amo
			 INNER JOIN CREDITOS Cre ON (Amo.CreditoID = Cre.CreditoID)
			 INNER JOIN CLIENTES Cli ON (Cre.ClienteID = Cli.ClienteID)
		WHERE Cre.CreditoID      = 	Par_CreditoID
			AND (Amo.Estatus	 =  Estatus_Vigente
					OR Amo.Estatus =  Estatus_Atrasado
					OR Amo.Estatus =  Estatus_Vencido)
			AND (Cre.Estatus	   =  Estatus_Vigente
					OR Cre.Estatus =  Estatus_Vencido)
		ORDER BY Amo.FechaInicio;



	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero		:= 0.0;
	SET SalidaNO       		:= 'N';
	SET SalidaSI        	:= 'S';
	SET Estatus_Vigente 	:= 'V';
	SET Estatus_Atrasado  	:= 'A';
	SET Estatus_Vencido 	:= 'B';
	SET Monto_MinimoPago	:= 0.01;
	SET SiPagaIVA			:= 'S';
	SET Des_PagoCredito     := 'PAGO DE CREDITO';
	SET Mov_Referencia		:= 'PAGO DE INTERES CON CARGO A CTA';
	SET Aud_ProgramaID  	:= 'PAGOCREDITOPRO';
	SET Naturaleza_Cargo 	:= 'C';



	SET Var_MontoSaldo		:= Par_MontoPagar;
	SELECT FechaSistema	INTO Var_FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID;

    SET Var_FecAplicacion	:= Var_FechaSistema;

	SELECT  Cli.ClienteID,			Cli.SucursalOrigen,		Cli.PagaIVA,			Pro.CobraIVAInteres,
			Cre.MonedaID,			Pro.ProducCreditoID,	Des.Clasificacion,		Des.SubClasifID,
            Cre.Estatus
	INTO 	Var_ClienteID,			Var_SucursalID,			Var_PagaIVA,			Var_CobraIVAInteres,
			Var_MonedaID,			Var_ProducCreditoID,	Var_ClasificaCredito,	Var_SubClasifCredito,
			Var_EstatusCredito
	FROM CLIENTES Cli
		INNER JOIN CREDITOS Cre ON (Cli.ClienteID = Cre.ClienteID)
		INNER JOIN PRODUCTOSCREDITO Pro ON (Cre.ProductoCreditoID = Pro.ProducCreditoID)
		INNER JOIN DESTINOSCREDITO Des ON (Cre.DestinoCreID = Des.DestinoCreID)
	WHERE Cre.CreditoID = Par_CreditoID;

     IF (Var_PagaIVA = SiPagaIVA) THEN
		SET Var_IVA  := (SELECT IVA FROM SUCURSALES WHERE SucursalID = Var_SucursalID);

		IF (Var_CobraIVAInteres = SiPagaIVA) THEN
			SET Var_IVAInteresOrdi  := Var_IVA;
		ELSE
			SET Var_IVAInteresOrdi  := Decimal_Cero;
		END IF;
	END IF;

	SET Var_IVA				:= IFNULL(Var_IVA,  Decimal_Cero);
	SET Var_IVAInteresOrdi	:= IFNULL(Var_IVAInteresOrdi,  Decimal_Cero);

    ManejoErrores: BEGIN


		IF(IFNULL(Par_CreditoID,  Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'El Numero de Credito esta Vacio.';
			SET VarControl  := 'creditoID' ;
			LEAVE ManejoErrores;

		ELSE IF(Var_EstatusCredito != Estatus_Vigente AND Var_EstatusCredito != Estatus_Vencido ) THEN
				SET Par_NumErr  := '002';
				SET Par_ErrMen  := 'El Credito debe estar Vigente o Vencido.';
				SET VarControl  := 'creditoID' ;
				LEAVE ManejoErrores;
			END IF;
		END IF;




	OPEN CURSORAMORTIZACIONES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOFETCH: LOOP

				FETCH CURSORAMORTIZACIONES INTO
					Var_AmortizacionID,		Var_SaldoInteresPro, 	Var_SaldoInteresAtr,	Var_FechaInicio,
                    Var_FechaVencim;


				IF (Var_SaldoInteresPro >= Monto_MinimoPago) THEN
					SET	Var_MontoIVAPagar = ROUND((ROUND(Var_SaldoInteresPro, 2) *  Var_IVAInteresOrdi), 2);

					IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoInteresPro, 2) + Var_MontoIVAPagar)) THEN
						SET	Var_MontoPagar		:=  Var_SaldoInteresPro;
					ELSE

						SET	Var_MontoPagar		:= Var_MontoSaldo -
												   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
						SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					END IF;



					CALL PAGCREINTPROPRO (
						Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,    	Par_CuentaAhoID,
						Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,	    	Var_MontoIVAPagar,
						Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
						Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,         	Par_OrigenPago,			Par_NumErr,
						Par_ErrMen,			Var_Consecutivo,		Par_EmpresaID,     		Par_ModoPago,			Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);



					SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);
					IF(ROUND(Var_MontoSaldo, 2)	<= Decimal_Cero) THEN
						LEAVE CICLOFETCH;
					END IF;

				END IF;


				IF (Var_SaldoInteresAtr >= Monto_MinimoPago) THEN
					SET	Var_MontoIVAPagar = ROUND((ROUND(Var_SaldoInteresAtr, 2) *  Var_IVAInteresOrdi), 2);

					IF(ROUND(Var_MontoSaldo,2)	>= (ROUND(Var_SaldoInteresAtr, 2) + Var_MontoIVAPagar)) THEN
						SET	Var_MontoPagar		:=  Var_SaldoInteresAtr;
					ELSE

						SET	Var_MontoPagar		:= Var_MontoSaldo -
												   ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
						SET	Var_MontoIVAPagar	:= ROUND(((Var_MontoSaldo) / (1 + Var_IVAInteresOrdi)) * Var_IVAInteresOrdi, 2);
					END IF;


					CALL PAGCREINTATRPRO (
						Par_CreditoID,      Var_AmortizacionID, 	Var_FechaInicio,    	Var_FechaVencim,   		Par_CuentaAhoID,
						Var_ClienteID,      Var_FechaSistema,   	Var_FecAplicacion,  	Var_MontoPagar,    		Var_MontoIVAPagar,
						Var_MonedaID,       Var_ProducCreditoID,    Var_ClasificaCredito,   Var_SubClasifCredito,   Var_SucursalID,
						Des_PagoCredito,    Mov_Referencia,   		Par_Poliza,         	Par_OrigenPago,			Par_NumErr,
						Par_ErrMen,			Var_Consecutivo,    	Par_EmpresaID,      	Par_ModoPago,			Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);



					SET Var_MontoSaldo	:= Var_MontoSaldo - (Var_MontoPagar + Var_MontoIVAPagar);
					IF(ROUND(Var_MontoSaldo, 2)	<= Decimal_Cero) THEN
						LEAVE CICLOFETCH;
					END IF;

				END IF;
			END LOOP;
		END;
	CLOSE CURSORAMORTIZACIONES;

	SET Par_MontoSaldo  := Var_MontoSaldo;

    END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				VarControl	 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;


END TerminaStore$$