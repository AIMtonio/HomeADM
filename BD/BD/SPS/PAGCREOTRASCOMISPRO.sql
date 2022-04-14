-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREOTRASCOMISPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREOTRASCOMISPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGCREOTRASCOMISPRO`(
	# =====================================================================================
	# ----- SP QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES DEL COBRO DE ACCESORIOS ----
	# =====================================================================================
	Par_CreditoID			BIGINT(12),			# Numero de Credito
	Par_AmortiCreID			INT(11),			# Numero de Amortizacion
	Par_FechaInicio			DATE,				# Fecha de Inicio
	Par_FechaVencim			DATE,				# Fecha de Vencimiento
	Par_CuentaAhoID			BIGINT(12),			# Cuenta de Ahorro

	Par_ClienteID			INT(11),			# Numero de Cliente
	Par_FechaOperacion		DATE,				# Fecha de Operacion
	Par_FechaAplicacion		DATE,				# Fecha de Aplicacion
	INOUT Par_Monto			DECIMAL(12,2),		# Monto Operativo de Otras Comisiones
	Par_IVAMonto			DECIMAL(12,2),		# Monto Operativo del IVA de Otras Comisiones

	Par_MonedaID			INT(11),			# Moneda
	Par_ProdCreditoID		INT(11),			# Producto de Credito
	Par_Clasificacion		CHAR(1),			# Clasificacion
	Par_SubClasifID     	INT(11),			# Subclasificacion
	Par_SucCliente			INT(11),			# Sucursal del Cliente

	Par_Descripcion			VARCHAR(100),		# Descripcion
	Par_Referencia			VARCHAR(50),		# Referencia
	Par_Poliza				BIGINT(20),			# Numero de Poliza
	Par_OrigenPago			CHAR(1),			# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida				CHAR(1),			# Parametro de salida S:SI  N:NO

	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,
	# Parametros de Auditoria
	Par_EmpresaID			INT(11),
	Par_ModoPago           	CHAR(1),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	# DECLARACION DE VARIABLES
	DECLARE varControl				VARCHAR(100);		# Variable de Control
	DECLARE Var_NumRegistros		INT(11);			# Numero de Registros
	DECLARE Contador				INT(11);			# Auxiliar para ciclo WHILE

	DECLARE Var_AccesorioID			INT(11);			# Identificador del accesorio
	DECLARE Var_MontoAccesorio		DECIMAL(14,2);		# Monto a cobrar del accesorio
	DECLARE Var_MontoIVAAccesorio	DECIMAL(14,2);		# Monto a cobrar del IVA de Accesorios
	DECLARE Var_AbrevAccesorio		VARCHAR(20);		# Abreviatura del accesorio
	DECLARE Var_ConceptoCartera		INT(11);			# Concepto de Cartera al que corresponde el accesorio
	DECLARE Var_ConceptoIVACartera	INT(11);			# Concepto de Cartera al que corresponde el accesorio
	DECLARE Ref_GenAccesorios 		VARCHAR(100);		# Descripcion de la referencia de generacion de accesorios
	DECLARE Ref_GenIVAAccesorios 	VARCHAR(100);		# Descripcion de la referencia de generacion del IVA de accesorios
	DECLARE Var_RefPagoIntAcces		VARCHAR(150);		-- Descripcion de la referencia del pago de intereses
	DECLARE Var_RefPagoIvaIntAcc	VARCHAR(150);		-- Descripcion de la referencia del pago de iva de intereses
	DECLARE Var_MontoCuota			DECIMAL(12,2);		# Monto Fijo de la Cuota
	DECLARE Var_PagaIVA				CHAR(1);			# Indica si el cliente paga IVA
	DECLARE Var_SucursalCliente		INT(11);			# Indica la sucursal origen del Cliente
	DECLARE Var_CobraIVAAc			CHAR(1);			# Indica si el accesorio cobra IVA
	DECLARE Var_Iva					DECIMAL(14,2);		# Valor del IVA
	DECLARE Var_MontoIntCuota		DECIMAL(14,2);		-- Monto de interes del accesorio
	DECLARE Var_SaldoInteres		DECIMAL(14,2);		-- Saldo de interes del accesorio
	DECLARE Var_CobraIVAInteres		CHAR(1);			-- Indica si el accesorio cobra IVA de interes
	DECLARE Var_MontoIVAAIntAcc		DECIMAL(14,2);		-- Monto de IVA de interes del accesorio


	# DECLARACION CONSTANTES
	DECLARE	Cadena_Vacia	  		CHAR(1);			# Constante Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;				# Constante Fecha Vacia
	DECLARE	Entero_Cero				INT(11);			# Constante Entero Cero
	DECLARE	Decimal_Cero			DECIMAL(12, 2);		# Constante DECIMAL Cero

	DECLARE	AltaPoliza_NO			CHAR(1);			# Constante Alta de Poliza NO
	DECLARE	AltaPolCre_SI			CHAR(1);			# Constante Alta de Poliza de Credito SI
	DECLARE	AltaMovCre_SI			CHAR(1);			# Alta de Movimiento de Credito SI
	DECLARE	AltaMovAho_NO			CHAR(1);			# Alta de Movimiento de Ahorro NO
	DECLARE	Nat_Cargo				CHAR(1);			# Constante Naturaleza CARGO
	DECLARE	Nat_Abono				CHAR(1);			# Constante Naturaleza ABONO
	DECLARE Mov_OtrasComisiones		INT(11);			# Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
	DECLARE Mov_IVAOtrasComisiones	INT(11);			# Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
	DECLARE Salida_NO				CHAR(1);			# Salida NO
	DECLARE Salida_SI				CHAR(1);			# Salida SI
	DECLARE Cons_SI					CHAR(1);			# Constante SI
	DECLARE FormFinanciada			CHAR(1);			# Forma de Cobro F:FINANCIADA
	DECLARE Var_TipoMovIntAcc		INT(11);			-- Tipo de movimiento de credito Interes Accesorios
	DECLARE Var_TipoMovIvaIntAc		INT(11);			-- Tipo de movimiento de credito IVA Interes Accesorios

	SET	Cadena_Vacia	  	:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.00;

	SET	AltaPoliza_NO		:= 'N';
	SET	AltaPolCre_SI		:= 'S';
	SET	AltaMovCre_SI		:= 'S';
	SET	AltaMovAho_NO		:= 'N';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET Mov_OtrasComisiones	:= 43;					-- TIPOSMOVSCRE: Otras Comisiones
	SET Mov_IVAOtrasComisiones	:= 26;				-- TIPOSMOVSCRE: IVA Otras Comisiones
	SET Salida_NO			:= 'N'; 				-- Constante Salida No
	SET Salida_SI			:= 'S'; 				-- Constante Salida Si
	SET Cons_SI				:= 'S';		 			-- Constante Cadena Si
	SET FormFinanciada		:= 'F';
	SET Var_TipoMovIntAcc	:= 57;					-- Tipo de movimiento de credito Interes Accesorios
	SET Var_TipoMovIvaIntAc	:= 58;					-- Tipo de movimiento de credito IVA Interes Accesorios

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREOTRASCOMISPRO');
			SET varControl  = 'SQLEXCEPTION';
		END;

		DELETE FROM TMPACCESORIOSPROD WHERE CreditoID = Par_CreditoID;

		SET @Cont := 0;
		# SE LLENA LA  TABLA CON LOS ACCESORIOS QUE COBRA EL CREDITO
		INSERT INTO TMPACCESORIOSPROD(
					Consecutivo,							CreditoID,			AccesorioID,		MontoCuota,			MontoIVACuota,
					SaldoAccesorios,						Prelacion,			Abreviatura,		CobraIVA,			ConceptoCartera,
	                MontoIntCuota,							SaldoInteres,		CobraIVAInteres,	EmpresaID,			Usuario,
	                FechaActual,							DireccionIP,		ProgramaID,			Sucursal,	 		NumTransaccion)
		SELECT  	(@Cont:=@Cont+1) AS Consecutivo,		MAX(D.CreditoID),	MAX(D.AccesorioID),	MAX(D.MontoCuota),	MAX(D.MontoIVACuota),
					MAX(D.SaldoVigente + D.SaldoAtrasado)AS SaldoAccesorios,	MAX(A.Prelacion),	MAX(A.NombreCorto),	MAX(D.CobraIVA),	MAX(C.ConceptoCarID),
	                MAX(D.MontoIntCuota),					MAX(D.SaldoInteres),MAX(D.CobraIVAInteres),Par_EmpresaID,	Aud_Usuario,
	                Aud_FechaActual,						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		FROM DETALLEACCESORIOS D
		INNER JOIN ACCESORIOSCRED A ON D.AccesorioID = A.AccesorioID
		INNER JOIN CONCEPTOSCARTERA C ON A.NombreCorto = C.Descripcion
		WHERE D.CreditoID = Par_CreditoID
	      AND D.TipoFormaCobro = FormFinanciada
	      AND (SaldoVigente + SaldoAtrasado) >= Decimal_Cero
	      AND D.AmortizacionID = Par_AmortiCreID
		GROUP BY D.AccesorioID, D.AmortizacionID
		ORDER BY A.Prelacion ASC;

		SELECT PagaIVA, SucursalOrigen INTO Var_PagaIVA, Var_SucursalCliente FROM CLIENTES WHERE ClienteID = Par_ClienteID;
	    SET Var_Iva := (SELECT IVA FROM SUCURSALES WHERE  SucursalID = Var_SucursalCliente);

		# SE OBTIENE EL NUMERO DE ACCESORIOS COBRADOS POR EL CREDITO
		SET Var_NumRegistros := (SELECT COUNT(Consecutivo) FROM TMPACCESORIOSPROD WHERE CreditoID = Par_CreditoID);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		IF (Var_NumRegistros = Entero_Cero) THEN
		SET Par_NumErr  = 001;
			SET Par_ErrMen  = CONCAT('Sin Accesorios por Cobrar para este Credito');
			SET varControl  = 'NumRegistros';
			LEAVE ManejoErrores;
		END IF;

		SET Contador := 1;

	    # INICIA CICLO PARA EL COBRO DE ACCESORIOS
	   	CICLO: WHILE(Contador <= Var_NumRegistros) DO

	        ProcesoPagoAccesorios:begin
				SET Var_MontoIntCuota	:= Entero_Cero;
		        SET Var_SaldoInteres	:= Entero_Cero;
		        SET Var_CobraIVAInteres	:= Salida_NO;
		        SET Var_MontoIVAAccesorio := Decimal_Cero;
				SET Var_MontoIVAAIntAcc	:= Entero_Cero;
		        # SE OBTIENEN LOS DATOS NECESARIOS PARA LA APLICACION DEL PAGO
				SELECT	AccesorioID, 	MontoCuota,		SaldoAccesorios, 	Abreviatura,		ConceptoCartera,
						CobraIVA,		MontoIntCuota,	SaldoInteres,		CobraIVAInteres
		        INTO	Var_AccesorioID,	Var_MontoCuota,	Var_MontoAccesorio,	Var_AbrevAccesorio,	Var_ConceptoCartera,
						Var_CobraIVAAc,		Var_MontoIntCuota,	Var_SaldoInteres,	Var_CobraIVAInteres
		        FROM TMPACCESORIOSPROD
		        WHERE Consecutivo = Contador
		        AND		CreditoID = Par_CreditoID;

				SET Var_MontoIntCuota	:= IFNULL(Var_MontoIntCuota, Entero_Cero);
		        SET Var_SaldoInteres	:= IFNULL(Var_SaldoInteres, Entero_Cero);
		        SET Var_CobraIVAInteres	:= IFNULL(Var_CobraIVAInteres, Salida_NO);

			   # SE ASIGNA VALOR PARA LA REFERENCIA DEL MOVIMIENTO
				SET Ref_GenAccesorios 		:= CONCAT('PAGO DE ACCESORIO ', Var_AbrevAccesorio);
				SET Ref_GenIVAAccesorios	:= CONCAT('PAGO DE IVA DE ACCESORIO ', Var_AbrevAccesorio);
				SET Var_RefPagoIntAcces		:= CONCAT('PAGO DE INTERES ACCESORIO ', Var_AbrevAccesorio);
				SET Var_RefPagoIvaIntAcc	:= CONCAT('PAGO DE IVA DE INTERES DE ACCESORIO ', Var_AbrevAccesorio);


		        CALL RESDETACCESORIOSPRO(
						Par_CreditoID,		Var_AccesorioID,	Par_AmortiCreID,	Salida_NO, 			Par_NumErr,    		Par_ErrMen,
		                Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		                Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr <> Decimal_Cero) THEN
					LEAVE ProcesoPagoAccesorios;
				END IF;

		        IF(Var_MontoAccesorio >= Var_MontoCuota) THEN
					SET Var_MontoAccesorio := Var_MontoCuota;
				ELSE
					SET Var_MontoAccesorio := Var_MontoAccesorio;
				END IF;

				SET Var_MontoAccesorio := IFNULL(Var_MontoAccesorio, Decimal_Cero);

				IF (Var_SaldoInteres >= Var_MontoIntCuota) THEN
					SET Var_SaldoInteres	:= Var_MontoIntCuota;
				END IF;


				-- Si el cliente Paga IVA calculo el IVA de Accesorio
				IF(Var_PagaIVA = Cons_SI) THEN
					IF(Var_CobraIVAAc = Cons_SI) THEN
						SET Var_MontoIVAAccesorio	:= ROUND((Var_MontoAccesorio) * Var_Iva,2);
					END IF;

					IF (Var_CobraIVAInteres = Cons_SI) THEN
						SET Var_MontoIVAAIntAcc	:= ROUND(Var_SaldoInteres * Var_Iva, 2);
					END IF;
				END IF;

				-- INICIO INTERES ACCESORIO

		-- Si el Monto a pagar es Mayor a la suma del interes del accesorio mas IVA
		IF(Par_Monto >= (Var_SaldoInteres + Var_MontoIVAAIntAcc)) THEN
			SET Var_SaldoInteres := Var_SaldoInteres;
		ELSE

			SET Var_SaldoInteres	:= Par_Monto;
			-- Se calculo si el IVA si el cliente y el Accesorio conbra IVA
			IF(Var_PagaIVA = Cons_SI) THEN
				IF(Var_CobraIVAAc = Cons_SI)THEN
					SET Var_SaldoInteres	:= Par_Monto - ROUND(((Par_Monto) / (1 + Var_Iva)) * Var_Iva, 2);
				END IF;
			END IF;
		END IF;

		-- INGRESO POR CONCEPTO DE INTERES DE ACCESORIOS
		IF (Var_SaldoInteres > Decimal_Cero) THEN

			SET Var_ConceptoCartera	:= (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('INTERES ', Var_AbrevAccesorio) );

			-- SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
			CALL CONTACCESORIOSCREDPRO (
					Par_CreditoID,			Par_AmortiCreID,			Var_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
					Par_FechaOperacion,		Par_FechaAplicacion,		Var_SaldoInteres,		Par_MonedaID,			Par_ProdCreditoID,
					Par_Clasificacion,		Par_SubClasifID, 			Par_SucCliente,			Par_Descripcion, 		Var_RefPagoIntAcces,
					AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_SI,
					Var_ConceptoCartera,	Var_TipoMovIntAcc, 			Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,
					Cadena_Vacia,			Par_OrigenPago,				Par_Salida,				Par_NumErr,				Par_ErrMen,
					Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

			SET Par_Monto := Par_Monto - Var_SaldoInteres;

			IF(Par_Monto <= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;
		END IF;

		IF(Var_PagaIVA = Cons_SI) THEN
			IF(Var_CobraIVAInteres = Cons_SI) THEN
				-- SE CALCULA EL MONTO Y EL IVA PROPORCIONAL
				SET Var_MontoIVAAIntAcc := ROUND((Var_SaldoInteres) * Var_Iva,2);
				SET Var_ConceptoIVACartera := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('IVA INTERES ', Var_AbrevAccesorio) );

			ELSE
				# VALORES CUANDO EL CLIENTE NO PAGA IVA
				SET Var_MontoIVAAIntAcc := Entero_Cero;
			END IF;
		ELSE
				# VALORES CUANDO EL CLIENTE NO PAGA IVA
			SET Var_MontoIVAAIntAcc := Entero_Cero;
		END IF;

		SET Var_MontoIVAAIntAcc := IFNULL(Var_MontoIVAAIntAcc, Decimal_Cero);
		IF(Par_Monto >= Var_MontoIVAAIntAcc  ) THEN
			SET Var_MontoIVAAIntAcc := Var_MontoIVAAIntAcc;
		ELSE
			SET Var_MontoIVAAIntAcc := Par_Monto;
		END IF;

		-- INGRESO POR CONCEPTO DE IVA INTERES DE ACCESORIOS
		IF (Var_MontoIVAAIntAcc > Decimal_Cero) THEN

			# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
		CALL CONTACCESORIOSCREDPRO (
				Par_CreditoID,			Par_AmortiCreID,			Var_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
				Par_FechaOperacion,		Par_FechaAplicacion,		Var_MontoIVAAIntAcc,	Par_MonedaID,			Par_ProdCreditoID,
				Par_Clasificacion,		Par_SubClasifID, 			Par_SucCliente,			Par_Descripcion, 		Var_RefPagoIvaIntAcc,
				AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_SI,
				Var_ConceptoIVACartera,	Var_TipoMovIvaIntAc, 		Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,
				Cadena_Vacia, 			Par_OrigenPago,				Par_Salida,				Par_NumErr,				Par_ErrMen,
				Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

			SET Par_Monto := Par_Monto - Var_MontoIVAAIntAcc;

			IF(Par_Monto <= Decimal_Cero) THEN
				LEAVE ProcesoPagoAccesorios;
			END IF;
		END IF;

		-- FIN INTERES ACCESORIO

				-- Si el Monto a pagar es Mayor a la suma del accesorio mas IVA
				IF(Par_Monto >= (Var_MontoAccesorio + Var_MontoIVAAccesorio)) THEN
					SET Var_MontoAccesorio := Var_MontoAccesorio;
				ELSE

					SET Var_MontoAccesorio	:= Par_Monto;
					-- Se calculo si el IVA si el cliente y el Accesorio conbra IVA
					IF(Var_PagaIVA = Cons_SI) THEN
						IF(Var_CobraIVAAc = Cons_SI)THEN
							SET Var_MontoAccesorio	:= Par_Monto - ROUND(((Par_Monto)/(1+Var_Iva)) * Var_Iva, 2 );
						END IF;
					END IF;
				END IF;

				# INGRESO POR CONCEPTO DE OTRA COMISIONES(ACCESORIOS)
				IF (Var_MontoAccesorio > Decimal_Cero) THEN

					# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
		           CALL CONTACCESORIOSCREDPRO (
						Par_CreditoID,			Par_AmortiCreID,			Var_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
		                Par_FechaOperacion,		Par_FechaAplicacion,		Var_MontoAccesorio,		Par_MonedaID,			Par_ProdCreditoID,
		                Par_Clasificacion,		Par_SubClasifID, 			Par_SucCliente,			Par_Descripcion, 		Ref_GenAccesorios,
		                AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_SI,
		                Var_ConceptoCartera,	Mov_OtrasComisiones, 		Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,
		                Cadena_Vacia,			Par_OrigenPago,				Par_Salida,				Par_NumErr,				Par_ErrMen,
		                Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
		                Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

					SET Par_Monto := Par_Monto - Var_MontoAccesorio;

		            IF(Par_Monto <= Decimal_Cero) THEN
						LEAVE ProcesoPagoAccesorios;
		            END IF;
				END IF;

		        IF(Var_PagaIVA = Cons_SI) THEN
					IF(Var_CobraIVAAc = Cons_SI) THEN
						-- SE CALCULA EL MONTO Y EL IVA PROPORCIONAL
						SET Var_MontoIVAAccesorio := ROUND((Var_MontoAccesorio) * Var_Iva,2);
		                SET Var_ConceptoIVACartera := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('IVA ', Var_AbrevAccesorio) );

					ELSE
						# VALORES CUANDO EL CLIENTE NO PAGA IVA
						SET Var_MontoIVAAccesorio := Entero_Cero;
					END IF;
				ELSE
						# VALORES CUANDO EL CLIENTE NO PAGA IVA
					SET Var_MontoIVAAccesorio := Entero_Cero;
				END IF;



				SET Var_MontoIVAAccesorio := IFNULL(Var_MontoIVAAccesorio, Decimal_Cero);
		        IF(Par_Monto >= Var_MontoIVAAccesorio  ) THEN
					SET Var_MontoIVAAccesorio := Var_MontoIVAAccesorio;
		        ELSE
					SET Var_MontoIVAAccesorio := Par_Monto;
		        END IF;


		        # INGRESO POR CONCEPTO DE IVA OTRA COMISIONES(ACCESORIOS)
				IF (Var_MontoIVAAccesorio > Decimal_Cero) THEN

					# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
		           CALL CONTACCESORIOSCREDPRO (
						Par_CreditoID,			Par_AmortiCreID,			Var_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
		                Par_FechaOperacion,		Par_FechaAplicacion,		Var_MontoIVAAccesorio,	Par_MonedaID,			Par_ProdCreditoID,
		                Par_Clasificacion,		Par_SubClasifID, 			Par_SucCliente,			Par_Descripcion, 		Ref_GenIVAAccesorios,
		                AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_SI,
		                Var_ConceptoIVACartera,	Mov_IVAOtrasComisiones, 	Nat_Abono,				AltaMovAho_NO,			Cadena_Vacia,
		                Cadena_Vacia, 			Par_OrigenPago,				Par_Salida,				Par_NumErr,				Par_ErrMen,
		                Par_Consecutivo,		Par_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
		                Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

					SET Par_Monto := Par_Monto - Var_MontoIVAAccesorio;

		            IF(Par_Monto <= Decimal_Cero) THEN
						LEAVE ProcesoPagoAccesorios;
		            END IF;
				END IF;

	        END ProcesoPagoAccesorios;

			-- Actualizamos el Monto Pagado del Credito
			UPDATE DETALLEACCESORIOS SET
				FechaLiquida	= CASE WHEN (SaldoVigente + SaldoAtrasado + SaldoInteres) = Decimal_Cero THEN Par_FechaOperacion
									ELSE Fecha_Vacia END,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID	= Par_CreditoID
	          AND TipoFormaCobro = FormFinanciada
	          AND AccesorioID = Var_AccesorioID
	          AND AmortizacionID = Par_AmortiCreID;

			IF(Par_Monto <= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

	        SET Contador := Contador + 1;
		END WHILE CICLO;

	    DELETE FROM TMPACCESORIOSPROD WHERE CreditoID = Par_CreditoID;

	    SET Par_NumErr := 0;
		SET Par_ErrMen := 'Respaldo Realizado Exitosamente.';
		SET varControl := 'creditoID';

	END ManejoErrores;  # END Manejo de Errores

	IF(Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl	 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;


END TerminaStore$$
