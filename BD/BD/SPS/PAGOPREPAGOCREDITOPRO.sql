-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOPREPAGOCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS PAGOPREPAGOCREDITOPRO;
DELIMITER $$


CREATE PROCEDURE PAGOPREPAGOCREDITOPRO (
    -- SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO 
    Par_CreditoID         BIGINT(12),
    Par_CuentaAhoID       BIGINT(12),
    Par_MontoPagar        DECIMAL(12,2),
    Par_MonedaID          INT(11),
    Par_EmpresaID         INT(11),

    Par_Salida            CHAR(1),
    Par_AltaEncPoliza     CHAR(1),
    INOUT Var_MontoPago   DECIMAL(12,2),
    INOUT Var_Poliza      BIGINT,
    INOUT Par_NumErr      INT(11),
  
    INOUT Par_ErrMen      VARCHAR(400),
    INOUT Par_Consecutivo BIGINT,
    Par_ModoPago          CHAR(1),
    Par_Origen            CHAR(1),
    Par_RespaldaCred          CHAR(1),      -- Bandera que indica si se realizara el proceso de Respaldo de la informacion del Credito (S = Si se respalda, N = No se respalda)
    -- Parametros de Auditoria 
    Aud_Usuario           INT(11),
    Aud_FechaActual       DATETIME,
    Aud_DireccionIP       VARCHAR(15),
    Aud_ProgramaID        VARCHAR(50),
    Aud_Sucursal          INT(11),

    Aud_NumTransaccion    BIGINT(20)
)

TerminaStore: BEGIN
    -- DECLACRACION DE VARIABLES
    DECLARE Var_MontoExi            DECIMAL(12,2);              -- Monto exigible del credito
    DECLARE Var_MontoFiniq          DECIMAL(12,2);              -- Monto para liquidar el credito
    DECLARE Var_MontoRest           DECIMAL(12,2);              -- Monto restante
    DECLARE Var_Control             VARCHAR(100);               -- Variable de Control
    DECLARE Var_ProdCreditoID       INT(11);                    -- ID del Producto de Credito
    DECLARE Var_PermPrePago         CHAR(1);                    -- Indica si el credito permite prepagos
    DECLARE Var_TotalDeuda          DECIMAL(12,2);              -- Monto total de la deuda sin comision por liquidacion anticipada
    DECLARE Var_MontoPrePago        DECIMAL(12,2);              -- Monto real prepagado
    DECLARE Var_Origen              CHAR(1);                    -- Origen para el prepago de Credito
    DECLARE Var_WSFiniCuoCompleta	CHAR(1);					-- Indica si se realiza el finiquito por cuota completa
    DECLARE Var_TotalFinqCuoComp	DECIMAL(16,2);				-- Total de deuda con proyeccion de interes y de comisiones
    DECLARE Var_CliEspecifico       VARCHAR(20);
	DECLARE Var_PagoCredAutom		CHAR(1);					-- Indica SI aplica en automatico o NO el pago de credito, S=SI, N=NO
	DECLARE Var_Exigible			CHAR(1);					-- Indica la Accion a Realizar en caso de NO tener exigible, A=Abono a cuenta, P=Prepago de credito
	DECLARE Var_Sobrante			CHAR(1);					-- Indica la accion a realizar en caso de tener Sobrante, P=Prepago de Credito,A=Ahorro
	DECLARE Var_AplicaCobranzaRef	CHAR(1);					-- Indica SI aplica Cobranza Referenciado: S=SI ,N=NO
	DECLARE Var_EstatusCredito		CHAR(1);					-- Estatus del Credito
	DECLARE Var_EsAgropecuario		CHAR(1);

    -- DECLARACION DE CONSTANTES
    DECLARE SalidaSI                CHAR(1);                    -- Salida SI
    DECLARE SalidaNO                CHAR(1);                    -- Salida NO
    DECLARE Finiquito_SI            CHAR(1);                    -- SI para finiquito
    DECLARE Finiquito_NO            CHAR(1);                    -- No para finiquito del credito
    DECLARE PrePago_SI              CHAR(1);                    -- Si para prepago de credito
    DECLARE PrePago_NO              CHAR(1);                    -- No para prepago de credito
    DECLARE RespalCred_NO           CHAR(1);                    -- Valor NO para Respaldo de credito
    DECLARE RespalCred_SI           CHAR(1);                    -- Valor SI para respaldo del credito
    DECLARE Var_AltaEncPoliza       CHAR(1);                    -- Variable para alta de Poliza
    DECLARE Var_OrigenT             CHAR(1);                    -- Origen define de donde viene la peticion T = Pago Tradicional
    DECLARE ValorSI                 CHAR(1);                    -- Valor SI
    DECLARE Entero_Cero             INT(11);                    -- Entero Cero
    DECLARE OrigenWS                CHAR(1);                    -- Cuando el origen del credito es mediante Web Service
    DECLARE Cadena_Vacia            VARCHAR(2);                    -- Cuando el origen del credito es mediante Web Service
    DECLARE CliEspecifMexiVigua     VARCHAR(10);
    DECLARE AplicaPago              CHAR(1);
    DECLARE AplicaFiniquito         CHAR(1);
    DECLARE Var_ProyInteresPagAde	CHAR(1);

	DECLARE Naturaleza_Bloq		CHAR(1);
	DECLARE TipoBloq			INT(11);
	DECLARE FechaDelSistema		DATE;
	DECLARE Descrip_Bloq		VARCHAR(200);
	DECLARE Cons_ExigibleAbono	CHAR(1);			-- Constante en caso de no tener exigible Abono a cuenta
	DECLARE Cons_SobranteAbono	CHAR(1);			-- En caso de tener sobrante realizar Abono a cuenta
	DECLARE Accion_PrepagoCred	CHAR(1);			-- Prepago de Credito (P)
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Estatus_Vencido		CHAR(1);

    -- ASIGNACION DE CONSTANTES
    SET SalidaSI                    := 'S';                     -- Salida SI
    SET SalidaNO                    := 'N';                     -- Salida NO
    SET PrePago_SI                  := 'S';                     -- SI es un PrePago
    SET PrePago_NO                  := 'N';                     -- NO es un PrePago
    SET Finiquito_SI                := 'S';                     -- SI es un Finiquito o Liquidacion Total Anticipada
    SET Finiquito_NO                := 'N';                     -- NO es un Finiquito o Liquidacion Total Anticipada
    SET RespalCred_NO               := 'N';                     -- Valor NO para Respaldo de credito
    SET RespalCred_SI               := 'S';                     -- Valor SI para respaldo del credito
    SET Var_AltaEncPoliza           := 'N';                     -- Variable para alta de Poliza
    SET Var_OrigenT                 := 'T';                     -- Origen define de donde viene la peticion T = Pago Tradicional
    SET ValorSI                     := 'S';                     -- Valor SI
    SET Entero_Cero                 := 0;                       -- Entero Cero
    SET OrigenWS                    := 'W';                     -- Cuando el origen del credito es mediante Web Service
    SET Cadena_Vacia				:= '';
    SET CliEspecifMexiVigua			:='38';

	SET Naturaleza_Bloq		:= 'B';
	SET TipoBloq			:= 26;
	SET FechaDelSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Descrip_Bloq		:= 'BLOQUEO AUT. COBRANZA REFERENCIADO';	
	SET Cons_ExigibleAbono	:= 'A';			-- Constante en caso de no tener exigible Abono a cuenta
	SET Cons_SobranteAbono	:= 'A';			-- En caso de tener sobrante realizar Abono a cuenta
	SET Accion_PrepagoCred	:= 'P';
	SET Estatus_Vigente		:= 'V';
	SET Estatus_Vencido		:= 'B';

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOPREPAGOCREDITOPRO');
    END;

    SET Var_MontoFiniq  := FUNCIONCONFINIQCRE(Par_CreditoID);
    SET Var_MontoExi    := FUNCIONEXIGIBLE(Par_CreditoID);
    SET Var_MontoRest   := Par_MontoPagar;
    SET Var_TotalDeuda  := FUNCIONTOTDEUDACRE(Par_CreditoID); -- Monto total de la deuda sin comision por liquidacion anticipada
    SET Var_MontoPrePago := Entero_Cero;
    SET Var_MontoPago := Entero_Cero;


    SELECT ProductoCreditoID, TipoPrepago,				Estatus
      INTO Var_ProdCreditoID, Var_WSFiniCuoCompleta,	Var_EstatusCredito
      FROM CREDITOS
      WHERE CreditoID = Par_CreditoID;

    SELECT PermitePrepago,		ProyInteresPagAde,		EsAgropecuario
        INTO Var_PermPrePago,	Var_ProyInteresPagAde,	Var_EsAgropecuario
      FROM PRODUCTOSCREDITO
      WHERE ProducCreditoID = Var_ProdCreditoID;

	SET Var_EsAgropecuario	:= IFNULL(Var_EsAgropecuario,SalidaNO );

	-- SE CONSULTA LA PARAMETRIZACION DE CONDICIONES DE PAGO DE CREDITO MEDIANTE EL SERVICIO CREDITPAYMET
	SELECT PagoCredAutom,	Exigible,		Sobrante,	AplicaCobranzaRef
		INTO Var_PagoCredAutom,	Var_Exigible,		Var_Sobrante,	Var_AplicaCobranzaRef
		FROM PARAMCREDITPAYMENT
		WHERE ProducCreditoID = Var_ProdCreditoID
		LIMIT 1;

	SET Var_PagoCredAutom		:= IFNULL(Var_PagoCredAutom,SalidaNO);
	SET Var_Exigible			:= IFNULL(Var_Exigible,Cadena_Vacia);
	SET Var_Sobrante			:= IFNULL(Var_Sobrante,Cadena_Vacia);
	SET Var_AplicaCobranzaRef	:= IFNULL(Var_AplicaCobranzaRef,SalidaNO);

    IF  Var_WSFiniCuoCompleta = 'P' THEN
      SET Var_MontoFiniq := FNFINIQCUOTASCOMPLETAS(Par_CreditoID,'S');
      SET Var_TotalDeuda := FNFINIQCUOTASCOMPLETAS(Par_CreditoID,'N');
    END IF;

    SELECT ValorParametro INTO Var_CliEspecifico FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico';

    -- Para el caso de MEXI se finiquita el credito y se deja el restante en la cuenta de ahorro por lo que se ignora validacion por monto de finiquito.
    IF(Var_CliEspecifico <> CliEspecifMexiVigua)THEN
        IF Par_MontoPagar > Var_MontoFiniq THEN
            SET Par_NumErr    := '01';
            SET Par_ErrMen    := 'El monto es superior a la cantidad para liquidar el credito';
            SET Par_Consecutivo := 0;
            SET Var_Control   :=  'creditoID';
            LEAVE ManejoErrores;
        END IF;
    END IF;
    

    IF(Var_CliEspecifico <> CliEspecifMexiVigua)THEN
        IF (Par_MontoPagar > Var_MontoExi AND Var_PermPrePago = PrePago_NO AND Var_Sobrante = Accion_PrepagoCred) THEN
          SET Par_NumErr    := '02';
          SET Par_ErrMen    := CONCAT('No se permiten prepagos para el Credito especificado, el monto a pagar es mayor que el exigible (', Par_MontoPagar, ' > ', Var_MontoExi, ').');
          SET Par_Consecutivo := 0;
          SET Var_Control   :=  'creditoID';
          LEAVE ManejoErrores;
        END IF;
    END IF;
    
    -- Para el caso de MEXI se finiquita el credito y se deja el restante en la cuenta de ahorro por lo que se ignora validacion por monto de finiquito.
    IF(Var_CliEspecifico <> CliEspecifMexiVigua)THEN
        IF Par_MontoPagar >= Var_TotalDeuda AND Var_TotalDeuda <> Var_MontoFiniq AND Par_MontoPagar < Var_MontoFiniq THEN
            SET Par_NumErr    := '03';
            SET Par_ErrMen    := CONCAT('Si se desea liquidar el credito anticipadamente se deben pagar ', Var_MontoFiniq, ', total adeudo:', Var_TotalDeuda, ', liquidando anticipadamente se debe pagar:', Var_MontoFiniq, '.');
            SET Par_Consecutivo := 0;
            SET Var_Control   :=  'creditoID';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    -- ------------------------------------------------------------
    -- Inicia Finiquito de Credito
    -- ------------------------------------------------------------
    SET AplicaFiniquito := Finiquito_NO;
    IF Par_MontoPagar = Var_MontoFiniq  AND Var_WSFiniCuoCompleta != 'P' THEN
		SET AplicaFiniquito = ValorSI;
    END IF;
    IF Par_MontoPagar >= Var_MontoFiniq AND Var_WSFiniCuoCompleta != 'P' AND Var_MontoExi = Var_TotalDeuda AND Var_CliEspecifico = CliEspecifMexiVigua  AND Var_ProyInteresPagAde = ValorSI THEN 
		SET AplicaFiniquito = ValorSI;
        SET Par_MontoPagar := Var_TotalDeuda;
    END IF;

	-- SE REALIZARA EL BLOQUEO DEL SALDO SI NO SE TIENE CONFIGURACION DEL TIPO DE LAYOUT PERMITE REALIZAR PAGO AUTOMATICO DE CREDITO
	-- LOS PRODUCTOS QUE NO SE ENCUENTRAN PARAMETRIZADO TAMBIEM SE REALIZA EL BLOQUEO AUTOMATICAMENTE
	IF(Var_PagoCredAutom = SalidaNO AND Var_AplicaCobranzaRef = ValorSI AND Var_CliEspecifico <> CliEspecifMexiVigua AND Var_EstatusCredito IN (Estatus_Vigente,Estatus_Vencido) AND Var_EsAgropecuario = SalidaNO) THEN
		CALL BLOQUEOSPRO(	Entero_Cero,		Naturaleza_Bloq,	Par_CuentaAhoID,	FechaDelSistema,	Par_MontoPagar,
							Aud_FechaActual,	TipoBloq,			Descrip_Bloq,		Par_CreditoID,		Cadena_Vacia,
							Cadena_Vacia,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

		-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
	END IF;

	IF (Var_PagoCredAutom = ValorSI) THEN
		IF AplicaFiniquito = ValorSI THEN
			CALL PAGOCREDITOPRO(
								Par_CreditoID,    Par_CuentaAhoID,    Par_MontoPagar,   Par_MonedaID,         PrePago_NO,   
								Finiquito_SI,     Par_EmpresaID,      SalidaNO,         Var_AltaEncPoliza,    Var_MontoPago,  
								Var_Poliza,       Par_NumErr,         Par_ErrMen,       Par_Consecutivo,      Par_ModoPago,  
								Par_Origen,       RespalCred_SI,      Aud_Usuario,      Aud_FechaActual,      Aud_DireccionIP,  
								Aud_ProgramaID,   Aud_Sucursal,       Aud_NumTransaccion );
			LEAVE ManejoErrores;
		END IF;
		-- Finaliza Finiquito de Credito
		-- ------------------------------------------------------------
		
		-- ------------------------------------------------------------
		-- Inicia Pago por totalidad o parcialidad del monto exigible del Credito
		-- ------------------------------------------------------------
		IF Par_MontoPagar <= Var_MontoExi THEN
			SET AplicaPago := ValorSI;
		END IF;

		IF Par_MontoPagar > Var_MontoExi AND Var_CliEspecifico = CliEspecifMexiVigua AND Var_ProyInteresPagAde = ValorSI THEN
			SET AplicaPago := ValorSI;
		END IF;

		IF  AplicaPago = ValorSI THEN
			CALL PAGOCREDITOPRO(
							Par_CreditoID,    Par_CuentaAhoID,    Par_MontoPagar,   Par_MonedaID,         PrePago_NO,   
							Finiquito_NO,     Par_EmpresaID,      SalidaNO,         Var_AltaEncPoliza,    Var_MontoPago,  
							Var_Poliza,       Par_NumErr,         Par_ErrMen,       Par_Consecutivo,      Par_ModoPago,  
							Par_Origen,       RespalCred_SI,      Aud_Usuario,      Aud_FechaActual,      Aud_DireccionIP,  
							Aud_ProgramaID,   Aud_Sucursal,       Aud_NumTransaccion );
			LEAVE ManejoErrores;
		END IF;
		-- Finaliza Pago por totalidad o parcialidad del monto exigible del Credito
		-- ------------------------------------------------------------

		-- ------------------------------------------------------------
		-- Inicia Pago del monto exigible y prepago de Credito
		-- ------------------------------------------------------------
		CALL RESPAGCREDITOPRO(
			Par_CreditoID,  Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

		CALL RESPAGCREDITOALT(  Aud_NumTransaccion,     Par_CuentaAhoID,        Par_CreditoID,      Par_MontoPagar,   Par_NumErr,                 
								Par_ErrMen,               Par_EmpresaID,          Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,        
								Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_MontoRest   :=  Par_MontoPagar - Var_MontoExi;
		
		IF(Var_MontoExi > Entero_Cero) THEN
			CALL PAGOCREDITOPRO(
								Par_CreditoID,    Par_CuentaAhoID,    Var_MontoExi,     Par_MonedaID,         PrePago_NO,   
								Finiquito_NO,     Par_EmpresaID,      SalidaNO,         Var_AltaEncPoliza,    Var_MontoPago,  
								Var_Poliza,       Par_NumErr,         Par_ErrMen,       Par_Consecutivo,      Par_ModoPago,  
								Par_Origen,       RespalCred_NO,      Aud_Usuario,      Aud_FechaActual,      Aud_DireccionIP,  
								Aud_ProgramaID,   Aud_Sucursal,       Aud_NumTransaccion );
			IF Par_NumErr <> Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_Origen := OrigenWS; -- Sobreescribimos la variable de origen para que proceda el prepago
		ELSE
			SET Var_Origen := Par_Origen; -- Si no hubo un pago de Credito mantenemos la validacion del tiempo para volver a pagar
		END IF;

		IF(Var_CliEspecifico <> CliEspecifMexiVigua)THEN
			IF (Var_Exigible  = Accion_PrepagoCred OR Var_Sobrante = Accion_PrepagoCred ) THEN
				CALL PREPAGOCREDITOPRO(
									Par_CreditoID,          Par_CuentaAhoID,        Var_MontoRest,          Par_MonedaID,       Par_EmpresaID,        
									SalidaNO,               Var_AltaEncPoliza,      Var_MontoPrePago,       Var_Poliza,         Par_NumErr,           
									Par_ErrMen,             Par_Consecutivo,        Par_ModoPago,           Var_Origen,         RespalCred_NO,        
									Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,        
									Aud_NumTransaccion );
				IF Par_NumErr <> Entero_Cero THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		-- REALIZAMOS LA EVALUACION PARA EL BLOQUEO DE SALDO SI SE TIENE HABILITADA COBRANZA REFERENCIADA TOMANDO EN CUENTA
		-- QUE EN LAS OPCIONES DE "EN CASO DE TENER SOBRANTE" Y "EN CASO DE SOBRANTE" SE TENGA HABILITADO ABONO A CUENTA.
		IF ( Var_CliEspecifico <> CliEspecifMexiVigua AND Var_EstatusCredito IN (Estatus_Vigente,Estatus_Vencido) AND Var_EsAgropecuario = SalidaNO) THEN
			IF((Var_Exigible = Cons_ExigibleAbono AND Var_AplicaCobranzaRef = ValorSI) OR (Var_Sobrante = Cons_SobranteAbono AND Var_AplicaCobranzaRef = ValorSI)) THEN
				CALL BLOQUEOSPRO(	Entero_Cero,		Naturaleza_Bloq,	Par_CuentaAhoID,	FechaDelSistema,	Var_MontoRest,
									Aud_FechaActual,	TipoBloq,			Descrip_Bloq,		Par_CreditoID,		Cadena_Vacia,
									Cadena_Vacia,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);

				-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;
	END IF;
		-- Finaliza Pago del monto exigible y prepago de Credito
		-- ------------------------------------------------------------

    SET Var_MontoPago := Var_MontoPago + Var_MontoPrePago;
    
    SET Par_NumErr    := '000';
    SET Par_ErrMen    := 'Pago Aplicado Exitosamente';
    SET Par_Consecutivo := 0;
    SET Var_Control   := 'creditoID';
  
  END ManejoErrores;

IF (Par_Salida = ValorSI) THEN
  SELECT  Par_NumErr      AS NumErr,
          Par_ErrMen      AS ErrMen,
          Var_Control     AS Control,
          Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
