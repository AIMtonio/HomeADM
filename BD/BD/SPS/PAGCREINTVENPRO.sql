
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCREINTVENPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGCREINTVENPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGCREINTVENPRO`(
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
    Par_EmpresaID       INT,
    Par_ModoPago        CHAR(1),
    Aud_Usuario         INT,

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Mov_AboConta		INT;
	DECLARE Mov_CarConta		INT;
	DECLARE Var_RegContaEPRC	CHAR(1);
	DECLARE Var_DivideEPRC	  	CHAR(1);
	DECLARE Var_EPRCAdicional	CHAR(1);
	DECLARE Var_CreEstatus		CHAR(1);	-- Estatus de Credito
	DECLARE Var_Control			CHAR(100);
	DECLARE Var_Consecutivo		INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT;
	DECLARE Decimal_Cero    	DECIMAL(12, 2);
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
	DECLARE AltaMovCre_SI		CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE AltaMovAho_NO		CHAR(1);
	DECLARE Str_NO				CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE Mov_IntVencido		INT;
	DECLARE Mov_IVAInteres		INT;
	DECLARE Con_IntVencido		INT;
	DECLARE Con_IVAInteres		INT;
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Estatus_Vencida		CHAR(1);
	DECLARE Con_Balance			INT;
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
	DECLARE Estatus_Suspendido	CHAR(1);	-- Estatus Suspendido
	DECLARE Con_IntVencidoSup	INT(11);	-- Concepto Contable: Interes Vencido Suspendido

	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero    	:= 0.00;
	SET AltaPoliza_NO		:= 'N';
	SET AltaPolCre_SI		:= 'S';
	SET AltaMovCre_SI   	:= 'S';
	SET AltaMovCre_NO   	:= 'N';
	SET AltaMovAho_NO   	:= 'N';
	SET Str_NO			   	:= 'N';
	SET Nat_Cargo       	:= 'C';
	SET Nat_Abono			:= 'A';
	SET Mov_IntVencido  	:= 12;
	SET Mov_IVAInteres		:= 20;
	SET Con_IntVencido		:= 21;
	SET Con_IVAInteres		:= 8;
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

	SET Estatus_Vigente 	:= 'V';
	SET Estatus_Vencida 	:= 'B';
	SET Des_Reserva     	:= 'CANC.ESTIMACION. DEL PASO A VENCIDO';
	SET	Par_EmpresaID 		:= IFNULL(Par_EmpresaID, 1);

	SET Var_RegContaEPRC	:= (SELECT RegContaEPRC				FROM PARAMSRESERVCASTIG WHERE EmpresaID = Par_EmpresaID);
	SET Var_DivideEPRC		:= (SELECT DivideEPRCCapitaInteres	FROM PARAMSRESERVCASTIG WHERE EmpresaID = Par_EmpresaID);
	SET Var_EPRCAdicional	:= (SELECT EPRCAdicional			FROM PARAMSRESERVCASTIG	WHERE EmpresaID = Par_EmpresaID);

	SET	Var_RegContaEPRC	:= IFNULL(Var_RegContaEPRC, EPRC_Resultados);
	SET	Var_DivideEPRC		:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
	SET	Var_EPRCAdicional	:= IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);
	SET Estatus_Suspendido	:= 'S';		-- Estatus Suspendido
	SET Con_IntVencidoSup	:= 116;		-- Concepto Contable: Interes Vencido

	ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
	               			 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCREINTVENPRO');
			SET Var_Control = 'sqlException' ;
		END;

	SELECT Estatus
		INTO Var_CreEstatus
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

	IF (Par_Monto > Decimal_Cero) then

		IF (Var_CreEstatus = Estatus_Suspendido) THEN
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,	Par_ClienteID,		Par_FechaOperacion,
				Par_FechaAplicacion,	Par_Monto,				Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
				Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,	Par_Referencia,		AltaPoliza_NO,
				Entero_Cero,			Par_Poliza,				AltaPolCre_SI,		AltaMovCre_SI,		Con_IntVencidoSup,
				Mov_IntVencido,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Par_OrigenPago,			Str_NO,					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
				Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF (Var_CreEstatus != Estatus_Suspendido) THEN
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,			Par_AmortiCreID,		Par_CuentaAhoID,	Par_ClienteID,		Par_FechaOperacion,
				Par_FechaAplicacion,	Par_Monto,				Par_MonedaID,		Par_ProdCreditoID,	Par_Clasificacion,
				Par_SubClasifID,		Par_SucCliente,			Par_Descripcion,	Par_Referencia,		AltaPoliza_NO,
				Entero_Cero,			Par_Poliza,				AltaPolCre_SI,		AltaMovCre_SI,		Con_IntVencido,
				Mov_IntVencido,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Par_OrigenPago,			Str_NO,					Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
				Par_EmpresaID,			Par_ModoPago,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Balance

		-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
		-- A la EPRC derivada de la Calificacion de Cartera
		IF(Var_EPRCAdicional = NO_EPRCAdicional) then
			-- Verificamos si Divide la Estimacion en Capital e Interes
			IF(Var_DivideEPRC = NO_DivideEPRC) then
				SET	Mov_CarConta    := Con_Balance;		-- No Concepto: 17
			ELSE
				SET	Mov_CarConta    := Con_BalIntere;	-- No Concepto: 36
			END IF;
		ELSE
			SET	Mov_CarConta    := Con_BalAdiEPRC;	-- No Concepto: 49
		END IF;

	    CALL  CONTACREDITOSPRO (
	        Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
	        Par_ProdCreditoID,  Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Des_Reserva,        Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_CarConta,
	        Mov_IntVencido,     Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
	        Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
	        Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Cancelacion de la Estimacion de Interes Anterior. Cuenta de Gasto-Egreso o Cuenta Puente

		-- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
		-- A la EPRC derivada de la Calificacion de Cartera
		IF(Var_EPRCAdicional = NO_EPRCAdicional) then
			-- Verificamos si Divide la Estimacion en Capital e Interes
			IF(Var_DivideEPRC = NO_DivideEPRC) then
				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) then
					SET	Mov_AboConta    := Con_ResultEPRC; 	-- No Concepto: 18
				ELSE
					SET	Mov_AboConta    := Con_PtePrinci; 	-- No Concepto: 38
				END IF;
			ELSE
				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) then
					SET	Mov_AboConta    := Con_ResIntere; 	-- No Concepto: 37
				ELSE
					SET	Mov_AboConta    := Con_PteIntere; 	-- No Concepto: 39
				END IF;

			END IF;

		ELSE -- Estimacion Adicional por la Reserva del Interes Vencido

			-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
			IF(Var_RegContaEPRC = EPRC_Resultados) then
				SET	Mov_AboConta    := Con_ResAdiEPRC;	-- No Concepto: 51
			ELSE
				SET	Mov_AboConta    := Con_PteAdiEPRC;	-- No Concepto: 50
			END IF;
		END IF;

	    CALL  CONTACREDITOSPRO (
	        Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion, Par_FechaAplicacion,    Par_Monto,          Par_MonedaID,
	        Par_ProdCreditoID,  Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Des_Reserva,        Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_NO,      Mov_AboConta,
	        Mov_IntVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
	        Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
	        Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL CRWPAGOINTPROVPRO(
			Par_CreditoID,      Par_FechaInicio,    Par_FechaVencim,	Par_FechaOperacion, Par_FechaAplicacion,
			Par_Monto,          Par_MonedaID,       Par_SucCliente,		Par_Poliza,         Str_NO,
			Par_NumErr,			Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;

	IF (Par_IVAMonto > Decimal_Cero) then
	    CALL  CONTACREDITOSPRO (
	        Par_CreditoID,      Par_AmortiCreID,        Par_CuentaAhoID,    Par_ClienteID,
	        Par_FechaOperacion,	Par_FechaAplicacion,    Par_IVAMonto,       Par_MonedaID,
	        Par_ProdCreditoID,	Par_Clasificacion,      Par_SubClasifID,    Par_SucCliente,
	        Par_Descripcion,    Par_Referencia,         AltaPoliza_NO,      Entero_Cero,
	        Par_Poliza,         AltaPolCre_SI,          AltaMovCre_SI,      Con_IVAInteres,
	        Mov_IVAInteres,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,
	        Cadena_Vacia,       Par_OrigenPago,			Str_NO,				Par_NumErr,
	        Par_ErrMen,         Par_Consecutivo,        Par_EmpresaID,      Par_ModoPago,
	        Aud_Usuario,        Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Interes Vencido realizado Exitosamente.';
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := 0;

	END ManejoErrores;

END TerminaStore$$

