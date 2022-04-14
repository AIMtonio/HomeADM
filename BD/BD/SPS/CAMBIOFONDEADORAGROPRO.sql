-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAMBIOFONDEADORAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAMBIOFONDEADORAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `CAMBIOFONDEADORAGROPRO`(
	# =====================================================================================
	# ----- STORE PARA REALIZAR CAMBIO DE FUENTE DE FONDEADOR DE UN CREDITO AGROPECUARIO---
	# =====================================================================================
    Par_CreditoID		    BIGINT(12),			-- ID del credito
    Par_FechaRegistro		DATE,				-- Fecha de registro del cambio
	Par_LineaFondeoID   	INT(11),			-- Linea de Fondeo, corresponde con la tabla LINEAFONDEADOR
	Par_InstitutFondID		INT(11),			-- id de institucion de fondeo corresponde con la tabla INSTITUTFONDEO
    Par_PolizaID			BIGINT(12),			-- ID de la poliza en caso de generar nuevo credito pasivo

    Par_Monto				DECIMAL(16,2),		-- adeudo del credito al momento del cambio
	Par_UsuarioID			INT(11),			-- ID usuario que realiza autorizacion
	Par_LineaFondeoIDAnt   	INT(11),			-- Linea de Fondeo anterior, corresponde con la tabla LINEAFONDEADOR
	Par_InstitutFondIDAnt	INT(11),			-- id de institucion anterior de fondeo corresponde con la tabla INSTITUTFONDEO
	Par_MonedaID			INT(11),			-- Identificador de la moneda

	Par_OrigenOperacion 	CHAR(1),			-- Origen de la Operacion F.- Cambio de Fuente de Fondeo G.- Aplicacion de Garantias

	Par_Salida 				CHAR(1),    		-- indica una salida
	INOUT	Par_NumErr	 	INT(11),			-- parametro numero de error
	INOUT	Par_ErrMen	 	VARCHAR(400),		-- mensaje de error

    Par_EmpresaID	    	INT(11),			-- parametros de auditoria
    Aud_Usuario	       		INT(11),			-- parametros de auditoria
    Aud_FechaActual			DATETIME ,			-- parametros de auditoria
    Aud_DireccionIP			VARCHAR(15),		-- parametros de auditoria
    Aud_ProgramaID	    	VARCHAR(70),		-- parametros de auditoria
    Aud_Sucursal	    	INT(11),			-- parametros de auditoria
    Aud_NumTransaccion		BIGINT(20)			-- parametros de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_FechaSis 			DATE;				-- Fecha del sistema
	DECLARE Var_CreditoID			BIGINT(12);			-- ID del credito
	DECLARE Var_EstatusC			CHAR(1);			-- Estatus del credito
	DECLARE Var_CuentaID			BIGINT(12);			-- ID de la cuenta
	DECLARE Var_ClienteID			INT(11);			-- Id del cliente
	DECLARE Var_SaldoDispo			DECIMAL(12,2);		-- Saldo disponible de la cuenta
	DECLARE Var_Moneda				INT(11);			-- Id de la moneda
	DECLARE Var_MontoPago			DECIMAL(16,2);		-- MOnto del Pago
	DECLARE Var_Poliza				BIGINT(12);			-- Numero de Poliza
	DECLARE Var_Consecutivo			BIGINT(12);			-- Consecutivo
	DECLARE Var_ConsecutivoID		BIGINT(20);			-- Consecutivo
    DECLARE Var_Control				VARCHAR(100);		-- control de pantalla
    DECLARE Var_LineaFondeoID		INT(11);			-- ID linea de fondeo
	DECLARE Var_InstitutFondID		INT(11);			-- ID instituto de fondeo
	DECLARE Var_AntPasivoID			BIGINT(12);			-- ID credito pasivo anterior
	DECLARE Var_CreditoPasivoID		BIGINT(12);			-- ID credito pasivo
    DECLARE Var_InstitucionID		INT(11);			-- ID institucion de linea de fondeo anterior
    DECLARE Var_NumCtaInstit		VARCHAR(20);		-- Numero de Cuenta Bancaria.
	DECLARE Var_FechaMinistrado		DATE;				-- Fecha de ministracion con 30 dias posteriores
    DECLARE Var_TipoGarantiaFIRAID 	INT(11);			-- Id de la garantia fega o fonaga
    DECLARE Var_AmortiActual		INT(11);			-- ID de la amortizacion actual
    DECLARE Var_TipoCalculoInteres	CHAR(1);			-- Tipo de calculo de intereses
    DECLARE Var_SaldoLinea			DECIMAL(16,2);		-- Saldo de la linea
    DECLARE Var_FechaVencimien		DATE;				-- Fecha de vencimiento del credito
    DECLARE Var_FechaFinLinea		DATE;				-- Fecha de fin de la linea
    DECLARE Var_ProductoCreditoID	INT(11);			-- Producto de credito
    DECLARE Var_EstatusCre			CHAR(1);			-- Estatus de l credito
	DECLARE Var_SaldoCapAtrasado	DECIMAL(14,2);		-- Saldo de capital atrasado
    DECLARE Var_Generico			BIGINT(12);			-- Campo generico que recupera el numero de transaccion
	DECLARE Var_MontoDeuda			DECIMAL(14,2);		-- monto del adeudo en credito pasivo
    DECLARE Var_PagaIva 			CHAR(1);			-- Guarda el valor para saber si el credito paga IVA
	DECLARE Var_IVA 				DECIMAL(12,2);		-- Guarda el valor del IVA
    DECLARE Var_EstatusGarantiaFIRA	CHAR(1);

	-- Declaracion de Constantes
    DECLARE Entero_Cero 		INT(11);			-- entero cero
    DECLARE Entero_Uno	 		INT(11);			-- entero uno
    DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL Cero
    DECLARE Salida_SI 			CHAR(1);			-- salida SI
    DECLARE Fecha_Vacia 		DATE;				-- Fecha vacia
    DECLARE Cadena_Vacia 		CHAR(1);			-- cadena vacia
    DECLARE EstatusVigente		CHAR(1);			-- Credito vigente
    DECLARE EstatusVencido		CHAR(1);			-- Credito Vencido
    DECLARE ConstanteNo			CHAR(1);			-- Constamnte no
    DECLARE CargoCuenta			CHAR(1);			-- Cargo cuenta
	DECLARE Ope_CambioFon		INT(1);				-- Tipo operacion actualiza
	DECLARE Ope_NuevoPasivo		INT(1);				-- crea nuevo credito pasivo
    DECLARE EstatusDes			CHAR(1);			-- Estatus desembolsado
	DECLARE ProcesoCambioFon	CHAR(1);			-- PROCESO CAMBIO FONDEADOR
    DECLARE EstatusPagado		CHAR(1);			-- estatus pagado
    DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
    DECLARE EstatusFin			CHAR(1);
    DECLARE Entero_999			INT(11);
    DECLARE EstProcesado		CHAR(1);
	DECLARE Origen_Garantias 	CHAR(1);			-- Origen de fondeo por Garantias

    -- Asignacion de constantes
    SET Entero_Cero 	:= 0;
    SET Entero_Uno		:= 1;
    SET Decimal_Cero	:= 0.00;
    SET Salida_SI		:= 'S';
	SET Fecha_Vacia		:= '1900-01-01';
    SET Cadena_Vacia 	:= '';
    SET EstatusVigente  := 'V';
    SET EstatusVencido	:= 'B';
    SET EstatusDes		:= 'D';
    SET ConstanteNo		:= 'N';
    SET CargoCuenta		:= 'C';
    SET ProcesoCambioFon:= 'F';
    SET EstatusPagado	:= 'P';
	SET Nat_Cargo		:= 'C';
	SET Nat_Abono		:= 'A';
    SET EstatusFin		:= 'F';
    SET EstProcesado	:= 'P';
	SET Origen_Garantias := 'G';
    SET Ope_CambioFon	:= 1;
    SET Ope_NuevoPasivo	:= 2;
    SET Entero_999		:= 999;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
				concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CAMBIOFONDEADORAGROPRO');
			SET Var_Control := 'sqlexception';
		END;

		-- Asignamos valor a varibles
		SET Aud_FechaActual  	:= NOW();
		SET Var_FechaSis 	 	:= (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
									WHERE EmpresaID = Par_EmpresaID);
		SET Var_MontoPago		:= Decimal_Cero;
		SET Var_Poliza			:= Par_PolizaID;
		SET Var_Consecutivo		:= Entero_Cero;
		SET Par_LineaFondeoID 	:= IFNULL(Par_LineaFondeoID, Entero_Cero);
		SET Par_LineaFondeoIDAnt := IFNULL(Par_LineaFondeoIDAnt, Entero_Cero);

		-- Obtenemos valor de credito
		SELECT  Cre.CreditoID, 		Cre.TipoGarantiaFIRAID,		DATE_ADD(IFNULL(Cre.FechaMinistrado,Fecha_Vacia), INTERVAL IFNULL(30, Entero_Cero) DAY),
				Cre.FechaVencimien, Cre.ProductoCreditoID,		Cre.Estatus,					Cre.EstatusGarantiaFIRA
				INTO	Var_CreditoID, 	Var_TipoGarantiaFIRAID,	 	Var_FechaMinistrado, 		Var_FechaVencimien,			Var_ProductoCreditoID,
						Var_EstatusCre,	Var_EstatusGarantiaFIRA
				FROM CREDITOS Cre
					WHERE Cre.CreditoID = Par_CreditoID
						AND Cre.EsAgropecuario = Salida_SI
						AND Cre.Estatus = EstatusVigente
						AND Cre.GrupoID <= Entero_Cero;


		IF( Par_OrigenOperacion = Origen_Garantias ) THEN
			SELECT  Cre.CreditoID, 		Cre.TipoGarantiaFIRAID,		DATE_ADD(IFNULL(Cre.FechaMinistrado,Fecha_Vacia), INTERVAL IFNULL(30, Entero_Cero) DAY),
					Cre.FechaVencimien, Cre.ProductoCreditoID,		Cre.Estatus,					Cre.EstatusGarantiaFIRA
			INTO	Var_CreditoID, 	Var_TipoGarantiaFIRAID,	 		Var_FechaMinistrado, 		Var_FechaVencimien,			Var_ProductoCreditoID,
					Var_EstatusCre,	Var_EstatusGarantiaFIRA
			FROM CREDITOS Cre
			WHERE Cre.CreditoID = Par_CreditoID
			  AND Cre.EsAgropecuario = Salida_SI
			  AND Cre.GrupoID <= Entero_Cero;
		END IF;

		-- Obtenemos valor de credito pasivo
		SELECT  Re.CreditoFondeoID	INTO	Var_AntPasivoID
			FROM RELCREDPASIVOAGRO Re
				WHERE Re.CreditoID=Par_CreditoID
					AND  EstatusRelacion= EstatusVigente;

		SELECT	lin.LineaFondeoID,		lin.InstitutFondID,  	lin.SaldoLinea,
				lin.FechaFinLinea
			INTO Var_LineaFondeoID,		Var_InstitutFondID,		Var_SaldoLinea,
				 Var_FechaFinLinea
			FROM LINEAFONDEADOR lin
				WHERE lin.LineaFondeoID    = Par_LineaFondeoID
					AND lin.InstitutFondID = Par_InstitutFondID;

		SET Var_AntPasivoID := IFNULL(Var_AntPasivoID,Entero_Cero);
		-- Valores de IVA
        -- se obtienen los valores requeridos para las operaciones del sp
		SELECT	 IFNULL(PagaIVA,ConstanteNo),		IFNULL(PorcentanjeIVA/100,0)
			INTO Var_PagaIva,						Var_IVA
		FROM CREDITOFONDEO Cre
			WHERE Cre.CreditoFondeoID = Var_AntPasivoID;

		SET Var_SaldoCapAtrasado:= FUNCIONEXIGIBLE(Par_CreditoID);

		-- validaciones
		IF( Par_OrigenOperacion <> Origen_Garantias ) THEN
			IF(IFNULL(Var_CreditoID,Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 		:= 1;
				SET	Par_ErrMen 		:= 'El Numero de Credito No Existe.';
				SET Var_Control  	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_EstatusCre,Cadena_Vacia)<>EstatusVigente)THEN
				SET	Par_NumErr 		:= 2;
				SET	Par_ErrMen 		:= 'El Estatus del Credito Debe ser Vigente.';
				SET Var_Control  	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_InstitutFondID!= Entero_Cero) THEN

			IF(IFNULL(Par_LineaFondeoID,Entero_Cero))= Entero_Cero THEN
				SET	Par_NumErr 		:= 3;
				SET	Par_ErrMen 		:= 'La Linea de Fondeo esta Vacia.';
				SET Var_Control  	:= 'lineaFondeoID';
				LEAVE ManejoErrores;
			ELSE
				IF(IFNULL(Var_LineaFondeoID,Entero_Cero))= Entero_Cero THEN
					SET	Par_NumErr 		:= 4;
					SET	Par_ErrMen 		:= 'La Linea de Fondeo No Existe.';
					SET Var_Control  	:= 'lineaFondeoID';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(IFNULL(Var_SaldoLinea,Decimal_Cero) < Par_Monto)THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := 'El Saldo de la Linea es Insuficiente para el Monto del Credito.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_FechaFinLinea<Var_FechaVencimien)THEN
				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'La Fecha de Vencimiento de la Linea Seleccionada es Menor a la del Credito.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(IFNULL(Par_UsuarioID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'El Usuario esta Vacio';
			SET Var_Control := 'claveUsuarioAut';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaRegistro,Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Fecha esta Vacia';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr  := 9;
			SET Par_ErrMen  := 'El Saldo Total del Credito debe ser Mayor a Cero.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_OrigenOperacion <> Origen_Garantias ) THEN
			IF(Par_UsuarioID=Aud_Usuario) THEN
				SET Par_NumErr  := 10;
				SET Par_ErrMen  := 'El Usuario que Autoriza debe ser Diferente al Usuario Logeado.';
				SET Var_Control := 'claveUsuarioAut';
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Var_SaldoCapAtrasado,Decimal_Cero)>Decimal_Cero)THEN
				SET Par_NumErr  := 11;
				SET Par_ErrMen  := 'El Credito Presenta Adeudos, Realize al Pago Correspondiente Para Continuar.';
				SET Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Var_FechaMinistrado <= Var_FechaSis  AND IFNULL(Var_TipoGarantiaFIRAID,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr  := 12;
			SET Par_ErrMen  := 'El Credito No Cuenta con Garantias Asignadas, y su Fecha de Ministracion es Superior a 30 Dias.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_InstitutFondIDAnt = Par_InstitutFondID ) THEN
			SET	Par_NumErr 		:= 13;
			SET	Par_ErrMen 		:= 'La Institucion de Fondeo No Puede Ser Igual a la Anterior.';
			SET Var_Control  	:= 'institFondeoID';
			LEAVE ManejoErrores;
		END IF;

        IF(Var_InstitutFondID =Par_InstitutFondIDAnt)THEN
			SET	Par_NumErr 		:= 14;
			SET	Par_ErrMen 		:= 'La Institucion de Fondeo No Puede Ser Igual a la Anterior.';
			SET Var_Control  	:= 'institFondeoIDN';
			LEAVE ManejoErrores;
        END IF;

		IF( Par_OrigenOperacion <> Origen_Garantias ) THEN

	        IF(IFNULL(Var_EstatusGarantiaFIRA,Cadena_Vacia)=EstProcesado)THEN
				SET	Par_NumErr 		:= 15;
				SET	Par_ErrMen 		:= 'El Credito Tiene Garantias FIRA Aplicadas, No es Posible Realizar el Cambio de Fondeador.';
				SET Var_Control  	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;
        END IF;

        SELECT  MAX(AmortizacionID) INTO Var_AmortiActual
			FROM AMORTICREDITOAGRO WHERE CreditoID  = Par_CreditoID
				AND EstatusDesembolso = EstatusDes
					AND  Var_FechaSis <=  FechaExigible LIMIT 1;

        SET Var_TipoCalculoInteres := (SELECT TipoCalculoInteres  FROM AMORTICREDITOAGRO
											WHERE CreditoID  = Par_CreditoID AND AmortizacionID=Var_AmortiActual);

		-- Se realiza el pago de credito pasivo si existe
        IF(Var_AntPasivoID > Entero_Cero)THEN
			-- se obtiene total de deuda en pasivo

            /* se compara para saber si el credito pasivo paga o no iva*/
			IF(Var_PagaIva <> Salida_SI) THEN
				SET Var_IVA := Decimal_Cero;
			ELSE
				SET Var_IVA := IFNULL(Var_IVA, Decimal_Cero);
			END IF;

            SELECT   ROUND( IFNULL(
						SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2) +
							  ROUND(SaldoInteresPro + SaldoInteresAtra,2) +
							  ROUND(ROUND(SaldoInteresPro + SaldoInteresAtra, 2) * Var_IVA, 2) +
							  ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_IVA,2) +
							  ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_IVA,2) +
							  ROUND(SaldoMoratorios,2) + ROUND(ROUND(SaldoMoratorios,2) * Var_IVA,2)
							 ),
						   Entero_Cero)
					, 2)
				INTO Var_MontoDeuda
				FROM AMORTIZAFONDEO
				WHERE CreditoFondeoID   =  Var_AntPasivoID
				  AND Estatus   <> EstatusPagado;

			SELECT	lin.NumCtaInstit, lin.InstitucionID INTO Var_NumCtaInstit, Var_InstitucionID
				FROM LINEAFONDEADOR lin
				WHERE lin.LineaFondeoID    = Par_LineaFondeoIDAnt
					AND lin.InstitutFondID = Par_InstitutFondIDAnt;

			IF( Var_MontoDeuda > Entero_Cero ) THEN

				CALL PAGOCREDITOFONPRO(
					Var_AntPasivoID,		Var_MontoDeuda,		Par_MonedaID,			Salida_SI,			ConstanteNo,
	                Var_InstitucionID,		Var_NumCtaInstit,	ConstanteNo,			Var_MontoPago,		Var_Poliza,
					Par_NumErr,				Par_ErrMen,			Var_ConsecutivoID,		Par_EmpresaID,		Aud_Usuario,
	                Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

            UPDATE RELCREDPASIVOAGRO SET
				EstatusRelacion = EstatusFin
			WHERE CreditoFondeoID=Var_AntPasivoID
			  AND CreditoID=Par_CreditoID
			  AND EstatusRelacion= EstatusVigente;
        END IF;

        -- Se genera contabilidad  para cuenta anterior del credito activo: capital e intereses
        CALL CONTACAMBIOFONDEOPRO(
			Par_CreditoID,		Var_FechaSis,		Par_MonedaID,			Var_ProductoCreditoID,		ConstanteNo,
            Nat_Abono,			Entero_Cero,		Cadena_Vacia,			Var_Poliza,         		ConstanteNo,
            Par_NumErr,			Par_ErrMen,			Par_EmpresaID,        	Aud_Usuario,       		 	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Actualizacion en tabla de creditos
		CALL CAMBIOFONDEOAGROACT(
			Par_CreditoID,		Par_LineaFondeoID,		Par_InstitutFondID,		Ope_CambioFon,		ConstanteNo,
			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        -- Se genera poliza con abono para cuenta nueva del credito activo: capital e intereses
		CALL CONTACAMBIOFONDEOPRO(
			Par_CreditoID,		Var_FechaSis,		Par_MonedaID,			Var_ProductoCreditoID,		ConstanteNo,
			Nat_Cargo,			Entero_Cero,		Cadena_Vacia,			Var_Poliza,         		ConstanteNo,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,        	Aud_Usuario,       		 	Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        IF(Par_InstitutFondID != Entero_Cero)THEN
			-- Se crea nuevo credito Pasivo
			CALL CREDITOPASIVOAGROALT(
				Par_CreditoID,		Var_TipoCalculoInteres,		Cadena_Vacia,			ConstanteNo,		Par_NumErr,
				Par_ErrMen,			Var_CreditoPasivoID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- SE crean las amortizaciones y desembolso del pasivo
			CALL MINISTRACAMFONDAGROPRO(
				Var_CreditoPasivoID,		Par_CreditoID,			Par_Monto,				Var_TipoCalculoInteres,		Var_FechaSis,
				Var_Poliza,					ConstanteNo,			Par_NumErr,				Par_ErrMen,					Var_ConsecutivoID,
				Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Se da de alta en Bitacora
        CALL CAMBIOFONDEOAGROALT(
			Par_CreditoID,			Par_FechaRegistro, 		Par_Monto, 				Par_LineaFondeoIDAnt,		Par_InstitutFondIDAnt,
            Var_AntPasivoID,		Par_LineaFondeoID, 		Par_InstitutFondID,		Var_CreditoPasivoID, 		Par_UsuarioID,
            ConstanteNo,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID,				Aud_Usuario,
            Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        IF(Par_InstitutFondID!= Entero_Cero)THEN
			SET Par_ErrMen:= CONCAT('Cambio de Fuente de Fondeo Realizado Exitosamente, Se Creo el Nuevo Credito Pasivo: ',Var_CreditoPasivoID );
		ELSE
			SET Par_ErrMen:= CONCAT('Cambio de Fuente de Fondeo Realizado Exitosamente');
        END IF;

		SET Par_NumErr		:= Entero_Cero;
        SET Var_Consecutivo	:= Par_CreditoID;
        SET Var_Control		:= 'creditoID';
        SET Var_Generico    := Aud_NumTransaccion;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
				Par_NumErr          AS NumErr,
                Par_ErrMen          AS ErrMen,
                Var_Control         AS control,
                Var_Consecutivo     AS consecutivo,
                Var_Generico		AS CampoGenerico;

	END IF;

END TerminaStore$$