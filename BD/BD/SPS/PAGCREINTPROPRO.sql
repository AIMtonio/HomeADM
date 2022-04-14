
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREINTPROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREINTPROPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREINTPROPRO`(
    Par_CreditoID       BIGINT,
    Par_AmortiCreID     INT(4),
    Par_FechaInicio     DATE,
    Par_FechaVencim     DATE,
    Par_CuentaAhoID     BIGINT,

    Par_ClienteID       BIGINT,
    Par_FechaOperacion  DATE,
    Par_FechaAplicacion DATE,
    Par_Monto           DECIMAL(16,4),
    Par_IVAMonto        DECIMAL(16,2),

    Par_MonedaID        INT,
    Par_ProdCreditoID   INT,
    Par_Clasificacion   CHAR(1),
    Par_SubClasifID     INT,
    Par_SucCliente      INT,

    Par_Descripcion     VARCHAR(100),
    Par_Referencia      VARCHAR(50),
    Par_Poliza          BIGINT,
    Par_OrigenPago		CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	INOUT Par_NumErr	INT(11),

	INOUT Par_ErrMen	VARCHAR(400),
	INOUT Par_Consecutivo BIGINT,
    Par_EmpresaID       INT(11),
    Par_ModoPago        CHAR(1),
    Aud_Usuario         INT(11),

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Cre_Estatus     	CHAR(1);
	DECLARE Mov_AboConta		INT;
	DECLARE Mov_CarConta		INT;
	DECLARE Var_RegContaEPRC	CHAR(1);
	DECLARE Var_DivideEPRC	  	CHAR(1);
	DECLARE Var_EPRCAdicional	CHAR(1);

	DECLARE Var_Refinancia			CHAR(1);		# Indica si el credito refinancia los intereses
	DECLARE Var_EsAgropecuario		CHAR(1);		# Indica si el credito es agropecuario
	DECLARE Var_MontoAcumulado		DECIMAL(14,2);	# Indica el Monto Acumulado de Intereses del Credito
	DECLARE Var_MontoRefinanciar	DECIMAL(14,2);	# Indica el Monto a Refinanciar de Intereses del Credito

	DECLARE Var_CreEstatus		CHAR(1);		-- Estatus de Credito
	DECLARE Var_Control			CHAR(100);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero    	DECIMAL(12, 2);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Mov_IntProvis   	INT;
	DECLARE Mov_IVAInteres  	INT;
	DECLARE Con_IntProvis   	INT;
	DECLARE Con_IVAInteres  	INT;
	DECLARE Estatus_Vigente 	CHAR(1);
	DECLARE Estatus_Vencida 	CHAR(1);
	DECLARE Con_Balance  		INT;
	DECLARE Con_ResultEPRC		INT;
	DECLARE	Con_BalIntere		INT;
	DECLARE Con_PtePrinci		INT;
	DECLARE Con_PteIntere		INT;
	DECLARE	Con_ResIntere		INT;
	DECLARE Con_BalAdiEPRC		INT;
	DECLARE Con_PteAdiEPRC		INT;
	DECLARE Con_ResAdiEPRC		INT;

	DECLARE EPRC_Resultados		CHAR(1);
	DECLARE SI_DivideEPRC		CHAR(1);
	DECLARE NO_DivideEPRC		CHAR(1);
	DECLARE NO_EPRCAdicional	CHAR(1);
	DECLARE SI_EPRCAdicional	CHAR(1);

	DECLARE Des_Reserva     	VARCHAR(100);
	DECLARE Cons_SI				CHAR(1);
	DECLARE Cons_NO				CHAR(1);

	DECLARE Con_IntProvisSup	INT(11);	-- Concepto Contable Interes Devengado Supencion
	DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido

	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';                   -- Cadena o String Vacio
	SET Fecha_Vacia     	:= '1900-01-01';         -- Fecha Vacia
	SET Entero_Cero     	:= 0;                    -- Entero en Cero
	SET Decimal_Cero    	:= 0.00;                 -- Decimal en Cero
	SET AltaPoliza_NO   	:= 'N';                  -- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI   	:= 'S';	                 -- Alta de la Poliza de Credito: SI
	SET AltaMovCre_SI   	:= 'S';                  -- Alta del Movimiento de Credito: SI
	SET AltaMovCre_NO   	:= 'N';	                 -- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO   	:= 'N';                  -- Alta del Movimiento de Ahorro: NO
	SET Nat_Cargo       	:= 'C';                  -- Naturaleza del Movimiento: Cargo
	SET Nat_Abono       	:= 'A';                  -- Naturaleza del Movimiento: Abono
	SET Mov_IntProvis   	:= 14;	                 -- Movimiento Operativo de Credito: Interes Provisionado
	SET Mov_IVAInteres  	:= 20;                   -- Movimiento Operativo de Credito: IVA de Interes
	SET Con_IntProvis   	:= 19;                   -- Concepto Contable: Interes Provisionado
	SET Con_IVAInteres  	:= 8;                    -- Concepto Contable: IVA Interes Provisionado
	SET Con_Balance			:= 17;					-- Balance. Estimacion Prev. Riesgos Crediticios
	SET Con_ResultEPRC		:= 18;              	-- Resultados. Estimacion Prev. Riesgos Crediticios
	SET Con_BalIntere		:= 36;					-- Concepto Contable: Balance. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
	SET Con_ResIntere		:= 37;          		-- Concepto Contable: Resultados. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
	SET Con_PtePrinci		:= 38;					-- Concepto Contable: EPRC Cta. Puente de Principal
	SET Con_PteIntere		:= 39;					-- Concepto Contable: EPRC Cta. Puente de Int.Normal y Moratorio
	SET Con_BalAdiEPRC		:= 49;  				-- Concepto Contable: Balance EPRC Adicional Car.Vencida
	SET Con_PteAdiEPRC		:= 50;  				-- Concepto Contable: EPRC Adicional Cta.Puente de Car.Vencida
	SET Con_ResAdiEPRC		:= 51;  				-- Concepto Contable: Resultados EPRC Adicional de Car.Vencida

	SET EPRC_Resultados		:= 'R';					-- Estimacion en Cuentas de Resultados
	SET SI_DivideEPRC		:= 'S';					-- SI Divide en la EPRC en Principal(Capital) e Interes
	SET NO_DivideEPRC		:= 'N';					-- NO Divide en la EPRC en Principal(Capital) e Interes
	SET NO_EPRCAdicional	:= 'N';				-- NO Realiza EPRC Adicional por el Interes Vencido
	SET SI_EPRCAdicional	:= 'S';				-- SI Realiza EPRC Adicional por el Interes Vencido

	SET Estatus_Vigente 	:= 'V';                  -- Estatus: Vigente
	SET Estatus_Vencida 	:= 'B';                  -- Estatus: Vencida
	SET Des_Reserva     	:= 'CANC.ESTIMACION. DEL PASO A VENCIDO';
	SET Cons_SI				:= 'S';					# Constante SI
	SET Cons_NO				:= 'N';					# Constante NO

	SET Cre_Estatus			:= (SELECT  Estatus FROM CREDITOS WHERE CreditoID = Par_CreditoID);
	SET Cre_Estatus 		:= IFNULL(Cre_Estatus, Cadena_Vacia);
	SET	Par_EmpresaID 		:= IFNULL(Par_EmpresaID, 1);

	SET Var_RegContaEPRC	:= (SELECT RegContaEPRC 			FROM PARAMSRESERVCASTIG	WHERE EmpresaID = Par_EmpresaID);
	SET Var_DivideEPRC		:= (SELECT DivideEPRCCapitaInteres	FROM PARAMSRESERVCASTIG WHERE EmpresaID = Par_EmpresaID);
	SET Var_EPRCAdicional	:= (SELECT EPRCAdicional 			FROM PARAMSRESERVCASTIG	WHERE EmpresaID = Par_EmpresaID);
	SET	Var_RegContaEPRC 	:= IFNULL(Var_RegContaEPRC, EPRC_Resultados);
	SET	Var_DivideEPRC		:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
	SET	Var_EPRCAdicional	:= IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);

	SET Con_IntProvisSup	:= 114;		-- Concepto Contable Interes Devengado Ssupencion
	SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
		               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREINTPROPRO');
				SET Var_Control = 'sqlException' ;
			END;

	SELECT  Estatus,		Refinancia,		EsAgropecuario,		InteresAcumulado,	InteresRefinanciar
	INTO 	Cre_Estatus,	Var_Refinancia, Var_EsAgropecuario,	Var_MontoAcumulado,	Var_MontoRefinanciar
	FROM 	CREDITOS
	WHERE 	CreditoID = Par_CreditoID;

	SET Cre_Estatus 			:= IFNULL(Cre_Estatus, Cadena_Vacia);
	SET Var_Refinancia 			:= IFNULL(Var_Refinancia, Cadena_Vacia);
	SET Var_EsAgropecuario		:= IFNULL(Var_EsAgropecuario, Cadena_Vacia);
	SET Var_MontoAcumulado		:= IFNULL(Var_MontoAcumulado, Decimal_Cero);
	SET Var_MontoRefinanciar	:= IFNULL(Var_MontoRefinanciar, Decimal_Cero);

	IF (Par_Monto > Decimal_Cero) THEN

		-- VALIDA SI EL CREDITO ES AGROPECUARIO Y REFINANCIA INTERESES
		IF(Var_EsAgropecuario = Cons_SI AND Var_Refinancia = Cons_SI AND Par_FechaVencim > Par_FechaOperacion) THEN
			-- VALIDA SI EL MONTO A PAGAR ES MAYOR AL MONTO BASE DE INTERES PARA EL CALCULO
			IF(Par_Monto > Var_MontoRefinanciar) THEN
				-- AL INTERES ACUMULADO SE LE RESTA LO QUE SE ESTÁ PAGANDO Y EL INTERES SE QUEDA EN CERO
				UPDATE CREDITOS
						SET	InteresAcumulado = CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
													ELSE InteresAcumulado - Par_Monto END,
							InteresRefinanciar = Decimal_Cero
						WHERE CreditoID = Par_CreditoID;

			ELSE
				-- SI EL MONTO A PAGAR NO ES MAYOR, AL INTERES ACUMULADO E INTERES A REFINANCIAR SE LE RESTA EL MONTO PAGADO
				UPDATE CREDITOS
						SET	InteresAcumulado = CASE WHEN Par_Monto > InteresAcumulado THEN Decimal_Cero
													ELSE InteresAcumulado - Par_Monto END,
							InteresRefinanciar = InteresRefinanciar - Par_Monto
						WHERE CreditoID = Par_CreditoID;
			END IF;

	    END IF;

		SELECT Estatus
			INTO Var_CreEstatus
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

		-- Contabilidad del Pago del Interes Provisionado
		IF (Var_CreEstatus = Estatus_Suspendido) THEN
			CALL CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,	Par_CuentaAhoID,	Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,	Par_Monto,			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,
				Par_SubClasifID,		Par_SucCliente,		Par_Descripcion,	Par_Referencia,			AltaPoliza_NO,
				Entero_Cero,			Par_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,			Con_IntProvisSup,
				Mov_IntProvis,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
				Par_OrigenPago,			Cons_NO,			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,
				Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Var_CreEstatus != Estatus_Suspendido) THEN
			CALL CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,	Par_CuentaAhoID,	Par_ClienteID,			Par_FechaOperacion,
				Par_FechaAplicacion,	Par_Monto,			Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,
				Par_SubClasifID,		Par_SucCliente,		Par_Descripcion,	Par_Referencia,			AltaPoliza_NO,
				Entero_Cero,			Par_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,			Con_IntProvis,
				Mov_IntProvis,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,			Cadena_Vacia,
				Par_OrigenPago,			Cons_NO,			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,
				Par_EmpresaID,			Par_ModoPago,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Cancelacion de la Reserva si se esta Pagando un Credito: Vencido.
		-- Se puede Pagar Interes Provisionado en una Liquidacion Anticipada o Finiquito de un Credito Vencido
	   IF (Cre_Estatus = Estatus_Vencida ) THEN
			-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance
			-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
			-- A la EPRC derivada de la Calificacion de Cartera
			IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
				-- Verificamos si Divide la Estimacion en Capital e Interes
				IF(Var_DivideEPRC = NO_DivideEPRC) THEN
					SET	Mov_CarConta    := Con_Balance;		-- No Concepto: 17
				ELSE
					SET	Mov_CarConta    := Con_BalIntere;	-- No Concepto: 36
				END IF;
			ELSE
				SET	Mov_CarConta    := Con_BalAdiEPRC;	-- No Concepto: 49
			END IF;

	        CALL  CONTACREDITOSPRO (
	            Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,			Par_FechaOperacion,
	            Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,       Par_ProdCreditoID,		Par_Clasificacion,
	            Par_SubClasifID,    Par_SucCliente,         Des_Reserva,        Par_Referencia,        	AltaPoliza_NO,
	            Entero_Cero,		Par_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,      	Mov_CarConta,
	            Entero_Cero,        Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       	Cadena_Vacia,
	            Par_OrigenPago,		Cons_NO,				Par_NumErr,			Par_ErrMen,         	Par_Consecutivo,
	            Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Gasto-Egreso o Cuenta Puente

			-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
			-- A la EPRC derivada de la Calificacion de Cartera
			IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
				-- Verificamos si Divide la Estimacion en Capital e Interes
				IF(Var_DivideEPRC = NO_DivideEPRC) THEN
					-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
					IF(Var_RegContaEPRC = EPRC_Resultados) THEN
						SET	Mov_AboConta    := Con_ResultEPRC; 	-- No Concepto: 18
					ELSE
						SET	Mov_AboConta    := Con_PtePrinci; 	-- No Concepto: 38
					END IF;
				ELSE
					-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
					IF(Var_RegContaEPRC = EPRC_Resultados) THEN
						SET	Mov_AboConta    := Con_ResIntere; 	-- No Concepto: 37
					ELSE
						SET	Mov_AboConta    := Con_PteIntere; 	-- No Concepto: 39
					END IF;

				END IF;

			ELSE -- Estimacion Adicional por la Reserva del Interes Vencido

				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET	Mov_AboConta    := Con_ResAdiEPRC;	-- No Concepto: 51
				ELSE
					SET	Mov_AboConta    := Con_PteAdiEPRC;	-- No Concepto: 50
				END IF;
			END IF;

	        CALL  CONTACREDITOSPRO (
	            Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,		Par_FechaOperacion,
	            Par_FechaAplicacion,Par_Monto,          	Par_MonedaID,       Par_ProdCreditoID,  Par_Clasificacion,
	            Par_SubClasifID,    Par_SucCliente,        	Des_Reserva,        Par_Referencia,     AltaPoliza_NO,
	            Entero_Cero,		Par_Poliza,         	AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
	            Entero_Cero,        Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
	            Par_OrigenPago,		Cons_NO,				Par_NumErr,			Par_ErrMen,         Par_Consecutivo,
	            Par_EmpresaID,      Par_ModoPago,           Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

	    END IF;

		CALL CRWPAGOINTPROVPRO(
			Par_CreditoID,      Par_FechaInicio,    Par_FechaVencim,    Par_FechaOperacion, Par_FechaAplicacion,
			Par_Monto,          Par_MonedaID,       Par_SucCliente,     Par_Poliza,         Cons_NO,
			Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF (Par_IVAMonto > Decimal_Cero) THEN
	    CALL  CONTACREDITOSPRO (
	        Par_CreditoID,      Par_AmortiCreID,	Par_CuentaAhoID,	Par_ClienteID,     		Par_FechaOperacion,
	        Par_FechaAplicacion,    Par_IVAMonto,	Par_MonedaID,		Par_ProdCreditoID,		Par_Clasificacion,
	        Par_SubClasifID,    Par_SucCliente,		Par_Descripcion,    Par_Referencia,        	AltaPoliza_NO,
	        Entero_Cero,		Par_Poliza,			AltaPolCre_SI,      AltaMovCre_SI,      	Con_IVAInteres,
	        Mov_IVAInteres,     Nat_Abono,			AltaMovAho_NO,      Cadena_Vacia,	        Cadena_Vacia,
	        Par_OrigenPago,		Cons_NO,			Par_NumErr,			Par_ErrMen,         	Par_Consecutivo,
	        Par_EmpresaID,      Par_ModoPago,		Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Interes Provisionado realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$

