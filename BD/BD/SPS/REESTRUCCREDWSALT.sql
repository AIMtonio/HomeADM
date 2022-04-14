-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTRUCCREDWSALT`;
DELIMITER $$


CREATE PROCEDURE `REESTRUCCREDWSALT`(
	-- SP para registrar el alta de un credito de reestructura a partir de una solicitud de crédito
    Par_ClienteID       INT(11),						-- Parametro Numero de cliente
    Par_ProducCreID     INT(11),						-- Parametro número de producto de credito
    Par_Relacionado     BIGINT(12),						-- Parametro credito relacionado
    Par_SolicitudCred	BIGINT(20),						-- Parametro Numero de solicitud de credito
    Par_FactorMora      DECIMAL(12,2),					-- Parametro factor mora

    Par_TasaFija        DECIMAL(12,4),					-- Parametro tasa fija
    Par_Frecuencia      CHAR(1),						-- Parametro frecuecia de capital
    Par_TipoPagoCap     VARCHAR(10),					-- Parametro tipo de pago de capital
    Par_NumeroAmor      INT(11),						-- Parametro numero de amortizaciones
    Par_AjusFecVen      CHAR(1),						-- Parametro que indica si ajusta las cuotas a la fecha de vencimiento

    Par_MontoComAp      DECIMAL(12,2),					-- Parametro monto de comision de apertura
    Par_IvaComAp        DECIMAL(12,2),					-- Parametro iva de comision de apertura

    Par_Salida          CHAR(1),						-- Parametro para salida de datos
    OUT Par_NumErr      INT(11),                        -- Parametro de entrada/salida de numero de error
    OUT Par_ErrMen      VARCHAR(400),                   -- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Par_EmpresaID       INT(11),                        -- Parametro de Auditoria EmpresaID
    Aud_Usuario         INT(11),                        -- Parametro de Auditoria Usuario
    Aud_FechaActual     DATETIME,                       -- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     VARCHAR(15),                    -- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      VARCHAR(50),                    -- Parametro de Auditoria Programa ID
    Aud_Sucursal        INT(11),                        -- Parametro de Auditoria Sucursal
    Aud_NumTransaccion  BIGINT(20)                      -- Parametro de Auditoria Numero de Transaccion
        )

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CuentaID        BIGINT(12);				-- Variable para almacenar la cuenta de ahorro del credito
	DECLARE Var_MontoCre        DECIMAL(12,2);			-- Variable para almacenar el monto del credito
	DECLARE Var_FechaSis        DATE;					-- Variable para almacenar la fecha del sistema
	DECLARE Var_DiaMesSis       INT;					-- Variable para el dia del mes de la fecha del sistema
	DECLARE Par_NumTran         BIGINT(20);				-- Variable para almacenar el numero de transaccion del simulador
	DECLARE Par_Cat             DECIMAL(14,4);			-- Variable para almacenar el cat del simulador
	DECLARE Par_FechaVencim     DATE;					-- Variable para almacenar la fecha de vencimiento
	DECLARE Par_MontoCuota      DECIMAL(12,2);			-- Variable para almacenar el monto de la cuota
	DECLARE Par_CreditoID       BIGINT(12);				-- Variable para almacenar el credito nuevo
	DECLARE Var_ClienteID       INT(11);				-- Variable para almacenar el numero de cliente
	DECLARE Var_ProductoCre     INT(11);				-- Variable para almacenar el producto de credito
	DECLARE Var_Relacionado     BIGINT(12);				-- Variable para almacenar el credito relacionado
	DECLARE Var_Periodicidad    CHAR(1);				-- Variable para almacenar la periocidad de capital
	DECLARE Var_Control			CHAR(50);				-- Variable de control de errores
	DECLARE Var_Cuotas			INT(11);				-- Numero de cuotas
	DECLARE Var_CuotasInt		INT(11);				-- Numero de cuotas de interes
	DECLARE Var_TipoDisper 		CHAR(1);				-- Tipo de dispersion del credito
	DECLARE Var_ClasifDestino 	CHAR(1);				-- Clasificacion del destino de credito
	DECLARE Var_DestinoCred		INT(11);				-- Destino del credito
	DECLARE Var_InstitFondeoID	INT(11);				-- instituto de fondeo
	DECLARE Var_LineaFondeo		INT(11);				-- linea de fondeo
	DECLARE Var_Plazo			VARCHAR(20);			-- Plazo del credito
	DECLARE Var_FechaInicio		DATE;					-- Fecha de inicio
	DECLARE Var_TipoPrepago		CHAR(1);				-- Tipo de prepago
	DECLARE Var_TransacPagare	BIGINT(20);				-- Numero de transaccion de pagare
	DECLARE Var_FrecuenciaCap   INT(11);				-- Variable para almacenar los dias de la frecuencia cap
	DECLARE Var_FrecuenciaInt	INT(11);				-- Variable para almacenar los dias de la frecuencia int

	-- Declaracion de constantes
	DECLARE Cadena_Vacia    CHAR(1);					-- Cadena vacia
	DECLARE Entero_Cero     INT;						-- Entero cero
	DECLARE Decimal_Cero    DECIMAL(12,2);				-- Decimal cero
	DECLARE Fecha_Vacia     DATE;						-- Fecha vacia
	DECLARE SalidaSI        CHAR(1);					-- Salida si
	DECLARE SalidaNO        CHAR(1);					-- Salida no

	DECLARE MonedaPesos     INT(11);					-- MonedaID : Pesos
	DECLARE TipoCalInt      INT(11);					-- Tipo de calculo de interes
	DECLARE FechaHabilSig   CHAR(1);					-- Toma la fecha habil siguiente
	DECLARE CalendIrrNo     CHAR(1);					-- No calendario irregular
	DECLARE PagoAniver      CHAR(1);					-- Pago por aniversario
	DECLARE NoAjusFecExi    CHAR(1);					-- No ajusta la fecha de exigibilidad
	DECLARE RecursosPro     CHAR(1);					-- Recursos propios
	DECLARE TipoPagoCre     CHAR(1);					-- Tipo de pago crecientes
	DECLARE Var_CadenaSi    CHAR(1);					-- Cadena si
	DECLARE Act_Autoriza    INT;						-- Actualizacion de autorizar credito

	-- Asignacion de constantes
	SET Cadena_Vacia    := '';
	SET Fecha_Vacia     := '1900-01-01';
	SET Entero_Cero     := 0;
	SET Decimal_Cero    := 0.00;
	SET SalidaSI        := 'S';
	SET SalidaNO        := 'N';

	SET MonedaPesos     := 1;
	SET TipoCalInt      := 1;
	SET FechaHabilSig   := 'S';
	SET CalendIrrNo     := 'N';
	SET PagoAniver      := 'A';
	SET NoAjusFecExi    := 'N';
	SET RecursosPro     := 'P';
	SET TipoPagoCre     := 'C';
	SET Var_CadenaSi    := 'S';
	SET Act_Autoriza    := 1;

	SET Aud_FechaActual := NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REESTRUCCREDWSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;


		SELECT ClienteID INTO Var_ClienteID
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;

		IF(IFNULL(Var_ClienteID,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El numero de Cliente no Existe';
			LEAVE ManejoErrores;
		END IF;

		SELECT ProducCreditoID INTO Var_ProductoCre
			FROM PRODUCTOSCREDITO
			WHERE ProducCreditoID = Par_ProducCreID;

		IF(IFNULL(Var_ProductoCre,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Producto de Credito no Existe';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID, FrecuenciaInt INTO Var_Relacionado, Var_Periodicidad
		FROM CREDITOS
		WHERE CreditoID =Par_Relacionado;

		IF(IFNULL(Var_Relacionado,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 14;
			SET Par_ErrMen  := 'El Credito a Reestructurar no Existe';
			LEAVE ManejoErrores;
		END IF;

		SELECT  CuentaID
		INTO   Var_CuentaID
			FROM    CREDITOS
			WHERE   CreditoID = Par_Relacionado;

		SET Var_MontoCre := (FUNCIONTOTDEUDACRE(Par_Relacionado) +Par_MontoComAp + Par_IvaComAp);

		SELECT TipoDispersion,		ClasiDestinCred,			DestinoCreID,				InstitFondeoID,			LineaFondeo,
				PlazoID,			PeriodicidadCap,			PeriodicidadInt
			INTO Var_TipoDisper,	Var_ClasifDestino,			Var_DestinoCred,			Var_InstitFondeoID,		Var_LineaFondeo,
				Var_Plazo,			Var_FrecuenciaCap,			Var_FrecuenciaInt
		FROM SOLICITUDCREDITO
		WHERE SolicitudCreditoID = Par_SolicitudCred;

		SET Var_TipoDisper := IFNULL(Var_TipoDisper, Cadena_Vacia);
		SET Var_ClasifDestino := IFNULL(Var_ClasifDestino, Entero_Cero);
		SET Var_DestinoCred := IFNULL(Var_DestinoCred, Entero_Cero);
		SET Var_InstitFondeoID := IFNULL(Var_InstitFondeoID, Entero_Cero);
		SET Var_LineaFondeo := IFNULL(Var_LineaFondeo, Entero_Cero);
		SET Var_Plazo 		:= IFNULL(Var_Plazo, Cadena_Vacia);
		SET Var_FrecuenciaCap 	:= IFNULL(Var_FrecuenciaCap, Entero_Cero);
		SET Var_FrecuenciaInt 	:= IFNULL(Var_FrecuenciaInt, Entero_Cero);

		SELECT  FechaSistema
		INTO   Var_FechaSis
			FROM PARAMETROSSIS;

		SET Var_DiaMesSis := DAY(Var_FechaSis);

		IF(Par_TipoPagoCap = TipoPagoCre) THEN

			CALL CREPAGCRECAMORPRO(
				Entero_Cero,		Var_MontoCre,       Par_TasaFija,       Entero_Cero,        Par_Frecuencia,
				PagoAniver,			Var_DiaMesSis,      Var_FechaSis,       Par_NumeroAmor,     Par_ProducCreID,
				Par_ClienteID,		FechaHabilSig,		Par_AjusFecVen,     NoAjusFecExi,       Par_MontoComAp,
				Decimal_Cero,		SalidaNO,			SalidaNO,			Decimal_Cero,		Decimal_Cero,
				SalidaNO,           Par_NumErr,			Par_ErrMen,         Par_NumTran,        Var_Cuotas,
				Par_Cat,            Par_MontoCuota,		Par_FechaVencim,   	Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		ELSE

			CALL CREPAGIGUAMORPRO(
				Var_MontoCre,       Par_TasaFija,       Entero_Cero,        Entero_Cero,        Par_Frecuencia,
				Par_Frecuencia,     PagoAniver,         PagoAniver,         Var_FechaSis,       Par_NumeroAmor,
				Par_NumeroAmor,		Par_ProducCreID,    Par_ClienteID,      FechaHabilSig,      Par_AjusFecVen,
				NoAjusFecExi,		Var_DiaMesSis,      Var_DiaMesSis,      Par_MontoComAp,    	Decimal_Cero,
				SalidaNO,			SalidaNO,			Decimal_Cero,		Decimal_Cero,		SalidaNO,
				Par_NumErr,			Par_ErrMen,         Par_NumTran,       	Var_Cuotas,			Var_CuotasInt,
				Par_Cat,            Par_MontoCuota,		Par_FechaVencim,   	Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion
			);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		CALL CREDITOREESTALT(
			Par_ClienteID,      Entero_Cero,        Par_ProducCreID,        Var_CuentaID,       Par_Relacionado,
			Par_SolicitudCred,  Var_MontoCre,       MonedaPesos,            Var_FechaSis,       Par_FechaVencim,
			Par_FactorMora,     TipoCalInt,         Entero_Cero,            Par_TasaFija,       Decimal_Cero,
			Decimal_Cero,       Decimal_Cero,       Par_Frecuencia,         Var_FrecuenciaCap,  Par_Frecuencia,
			Var_FrecuenciaInt,  Par_TipoPagoCap,    Par_NumeroAmor,         FechaHabilSig,      CalendIrrNo,
			PagoAniver,         PagoAniver,         Var_DiaMesSis,          Var_DiaMesSis,      Par_AjusFecVen,
			NoAjusFecExi,       Par_NumTran,        RecursosPro,            Par_MontoComAp,     Par_IvaComAp,
			Par_Cat,			Var_Plazo,			Var_TipoDisper,			TipoCalInt,			Var_DestinoCred,
			Var_InstitFondeoID,	Var_LineaFondeo,	Par_NumeroAmor,			Par_MontoCuota,		Var_ClasifDestino,
			Par_CreditoID,		SalidaNO,           Par_NumErr,				Par_ErrMen,         Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaInicio,	TipoPrepago
				Var_FechaInicio,	Var_TipoPrepago
			FROM CREDITOS
			WHERE CreditoID =  Par_CreditoID;

		CALL TRANSACCIONESPRO(Var_TransacPagare);

		-- se graba pagare
		CALL CREGENAMORTIZAPRO(Par_CreditoID,		Var_FechaSis,		Var_FechaInicio,	Var_TipoPrepago,		SalidaNO,
								Par_NumErr, 		Par_ErrMen,		 	Par_EmpresaID,		Aud_Usuario,       		Aud_FechaActual,
								Aud_DireccionIP,   Aud_ProgramaID,     	Aud_Sucursal,		Var_TransacPagare);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Se actualiza bandera de pagare
		UPDATE CREDITOS
		SET PagareImpreso =  Var_CadenaSi
		WHERE CreditoID  = Par_CreditoID;

		-- actualizamos el check list como recibido
		UPDATE CREDITODOCENT
		SET DocAceptado = Var_CadenaSi
		WHERE CreditoID  = Par_CreditoID;

		CALL CREDITOSACT(
			Par_CreditoID,      Par_NumTran,        Var_FechaSis,           Aud_Usuario,        Act_Autoriza,
			Var_FechaSis,       Par_FechaVencim,    Par_Cat,                Decimal_Cero,       Entero_Cero,
			Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,			SalidaNO,           Par_NumErr,
			Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,			Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_CreditoID AS Consecutivo;
	END IF;

END TerminaStore$$