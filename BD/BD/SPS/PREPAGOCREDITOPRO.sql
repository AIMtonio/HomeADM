-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOCREDITOPRO`;
DELIMITER $$

CREATE PROCEDURE `PREPAGOCREDITOPRO`(
    Par_CreditoID     	BIGINT(12),
    Par_CuentaAhoID  	BIGINT(12),
    Par_MontoPagar    	DECIMAL(14,2),
    Par_MonedaID      	INT(11),
    Par_EmpresaID     	INT(11),
    Par_Salida        	CHAR(1),
    Par_AltaEncPoliza	CHAR(1),

OUT Par_MontoPago		DECIMAL(12,2),
INOUT Var_Poliza		BIGINT,

OUT   Par_NumErr		INT(11),
OUT	Par_ErrMen			VARCHAR(400),
OUT	Par_Consecutivo		BIGINT,
	Par_ModoPago       	CHAR(1),
	Par_Origen			CHAR(1),
	Par_RespaldaCred	CHAR(1),		-- Bandera que indica si se realizara el proceso de Respaldo de la informacion del Credito (S = Si se respalda, N = No se respalda)

	Aud_Usuario		    INT(11),
	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_EstatusCre      CHAR(1);
	DECLARE Var_EsGrupal        CHAR(1);
	DECLARE Var_GrupoID         INT;
	DECLARE Var_CicloGrupo      INT;
	DECLARE Var_TipoPrepago		CHAR(1);
	DECLARE Var_CicloActual     INT;
	DECLARE Var_SoliciCreID		INT;
	DECLARE Var_ProrrateaPago	CHAR(1);
	DECLARE Var_EstGrupo		CHAR(1);
	DECLARE Var_FechaInicioAmor	DATE;
	DECLARE Var_FechaSistema	DATE;
	DECLARE Var_TipoDiferimiento CHAR(1);
	DECLARE Var_FechaBloqPre	DATE;
	DECLARE Var_FechaActPago	DATETIME;
	DECLARE Var_DifDiasPago		INT;
	DECLARE Var_NumErr			INT(11);
	DECLARE Var_ErrMen			VARCHAR(400);
	DECLARE Var_ClienteID			INT(11);      -- Numero del Cliente
	DECLARE Var_CargosPoliza	DECIMAL(14,4);		-- Variable para almacenar los Cargos de la Poliza
	DECLARE Var_AbonosPoliza	DECIMAL(14,4);		-- Variable para almacenar los Abonos de la Poliza
	DECLARE Var_Control     	VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    CHAR(1);
	DECLARE Fecha_Vacia     DATE;
	DECLARE Entero_Cero     INT;
	DECLARE Entero_Uno		INT;
	DECLARE Decimal_Cero    DECIMAL(12, 2);
	DECLARE Esta_Vencido    CHAR(1);
	DECLARE Esta_Vigente    CHAR(1);
	DECLARE NO_EsGrupal     CHAR(1);
	DECLARE Si_EsGrupal     CHAR(1);
	DECLARE SI_Prorratea	CHAR(1);
	DECLARE Tip_UltCuo		CHAR(1);
	DECLARE Tip_SigCuo		CHAR(1);
	DECLARE Tip_Prorrateo	CHAR(1);
	DECLARE Gru_Activo		CHAR(1);
	DECLARE SalidaSI        CHAR(1);
	DECLARE SalidaNO        CHAR(1);
	DECLARE Var_NumRecPago		INT;
	DECLARE Var_OrigenWS	CHAR(1);  			-- Cuando el origen del credito es mediante Web Service
	DECLARE Var_OrigenSAFY	CHAR(1); 			-- Cuando el origen del credito es mediante SAFY
	DECLARE EsAutomatico	CHAR(1);			-- Prepago Automatico
	DECLARE Tipo_Unico		CHAR(1);
	DECLARE Tipo_Completo	CHAR(1);
	DECLARE Tipo_TasaPref	CHAR(1);
	DECLARE Tip_CuoProyComp CHAR(1);			-- Pago Cuotas Completas Proyectadas
	DECLARE TipoOperPLDCredito   	  INT(11); 		-- Tipo de operacion 1 = Abonos y cargos cuenta,2= Pago de credito
	DECLARE LimiteDifPoliza	DECIMAL(12,2);		-- Monto Limite de Diferencia
	DECLARE Con_CargoCta	CHAR(1);
	DECLARE Con_OrigenDepRef CHAR(1);			-- Origen pago deposito referenciado

	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';              				-- Cadena Vacia
	SET Fecha_Vacia     := '1900-01-01';					-- Fecha Vacia
	SET Entero_Cero     := 0;               				-- Entero en Cero
	SET Decimal_Cero    := 0.00;            				-- DECIMAL Cero
	SET Entero_Uno   	:= 1;    	        				-- DECIMAL Cero
	SET Esta_Vencido    := 'B';             				-- Estatus del Credito: Vencido
	SET Esta_Vigente    := 'V';								-- Estatus del Credito: Vigente
	SET NO_EsGrupal     := 'N';             				-- Si es un Credito Grupal
	SET SI_EsGrupal     := 'S';								-- Si es un Credito Grupal
	SET SI_Prorratea	:= 'S';								-- Si Prorrate el Pago Grupal
	SET Tip_UltCuo		:= 'U';								-- Tipo de PrePago: Ultimas cuotas
	SET Tip_SigCuo		:= 'I';								-- Tipo de PrePago: A las cuotas siguientes inmediatas
	SET Tip_Prorrateo	:= 'V';								-- Tipo de PrePago: Prorrateo de pago en cuotas vivas
	SET Gru_Activo		:= 'A';								-- Estatus dentro del Grupo: Activo
	SET SalidaSI        := 'S';             				-- El Store si Regresa una Salida
	SET SalidaNO        := 'N';             				-- El Store no Regresa una Salida
	SET Var_NumRecPago	:= 0;
	SET Var_OrigenWS		:= 'W';   			-- Cuando el origen del credito es mediante Web Service
	SET Var_OrigenSAFY		:= 'S'; 			-- Cuando el origen del credito es mediante SAFY
	SET EsAutomatico		:= 'A';				-- Prepago Automatico
	SET Tipo_Unico			:= 'U';
	SET Tipo_Completo		:= 'C';
	SET Tipo_TasaPref		:= 'P';
	SET Tip_CuoProyComp		:= 'P';
	SET TipoOperPLDCredito	:= 2;
	SET LimiteDifPoliza		:= 0.01;			-- Monto Limite de Diferencia
	SET Con_CargoCta		:= 'C';
    SET Con_OrigenDepRef	:= 'R';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-PREPAGOCREDITOPRO');
				SET Var_Control = 'sqlException';
			END;

		IF IFNULL(Par_CreditoID,Entero_Cero)=Entero_Cero THEN
			SET Par_NumErr		:= '001';
			SET Par_ErrMen		:= 'El Numero de Credito esta vacio.';
			SET Var_Control   	:= 'creditoIDPre';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_CuentaAhoID,Entero_Cero)=Entero_Cero THEN
			SET Par_NumErr		:= '002';
			SET Par_ErrMen		:= 'El Numero de Cuenta esta vacio.';
			SET Var_Control   	:= 'cuentaIDPre';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_MontoPagar,Decimal_Cero)=Decimal_Cero THEN
			SET Par_NumErr		:= '003';
			SET Par_ErrMen		:= 'El Monto a Pagar esta vacio.';
			SET Var_Control   	:= 'montoPagarPre';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_MontoPagar,Decimal_Cero)<Entero_Uno THEN
			SET Par_NumErr		:= '004';
			SET Par_ErrMen		:= 'El Monto a Pagar no debe ser menor a 1';
			SET Var_Control   	:= 'montoPagarPre';
			SET Par_Consecutivo	:= 0;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual		:= NOW();
		-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE CREDITO SI AUN NO PASA MAS DE UN MINUTO.
		IF (Par_Origen != Var_OrigenWS AND Par_Origen != EsAutomatico AND Par_Origen != Con_OrigenDepRef) THEN
			-- SE OBTIENE LA FECHA DEL PAGO MÁS RECIENTE.
			SET Var_FechaActPago := (SELECT MAX(FechaActual) FROM DETALLEPAGCRE WHERE CreditoID = Par_CreditoID);
			SET Var_FechaActPago := IFNULL(Var_FechaActPago,Fecha_Vacia);

			-- SE CALCULA LA DIFERENCIA ENTRE LAS FECHAS EN DÍAS
			SET Var_DifDiasPago := DATEDIFF(Aud_FechaActual,Var_FechaActPago);
			SET Var_DifDiasPago := IFNULL(Var_DifDiasPago,Entero_Cero);

			-- SI EL PAGO ES EN EL MISMO DÍA, SE VALIDA QUE HAYA PASADO AL MENOS 1 MIN.
			IF(Var_DifDiasPago=Entero_Cero)THEN
				IF(TIMEDIFF(Aud_FechaActual,Var_FechaActPago)<= TIME('00:01:00'))THEN
					SET Par_NumErr    	:= '001';
	        		SET Par_ErrMen    	:= 'Ya se realizo un pago de credito para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
	        		SET Var_Control   	:= 'montoPagarPre';
	        		SET Par_Consecutivo := 0;
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

		SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;
		SELECT  Cre.Estatus,			Pro.EsGrupal,			Cre.GrupoID,	Cre.CicloGrupo, 	Cre.TipoPrepago,
				Cre.SolicitudCreditoID,	Cre.FechaInicioAmor,	Cre.ClienteID
			INTO
		        Var_EstatusCre,     	Var_EsGrupal,			Var_GrupoID,		Var_CicloGrupo, 	Var_TipoPrepago,
				Var_SoliciCreID,		Var_FechaInicioAmor,	Var_ClienteID
			FROM PRODUCTOSCREDITO Pro,
		         CREDITOS Cre
		WHERE Cre.CreditoID			= Par_CreditoID
			AND Cre.ProductoCreditoID	= Pro.ProducCreditoID;

		-- Inicializaciones
		SET Var_EstatusCre  := IFNULL(Var_EstatusCre, Cadena_Vacia);
		SET Var_EsGrupal    := IFNULL(Var_EsGrupal, Cadena_Vacia);
		SET Var_GrupoID     := IFNULL(Var_GrupoID, Entero_Cero);
		SET Var_CicloGrupo  := IFNULL(Var_CicloGrupo, Entero_Cero);
		SET Var_TipoPrepago := IFNULL(Var_TipoPrepago, Cadena_Vacia);
		SET Var_SoliciCreID := IFNULL(Var_SoliciCreID, Entero_Cero);
		SET Par_MontoPago   := Entero_Cero;
		SET Par_Consecutivo := Entero_Cero;


		IF (Var_FechaSistema < Var_FechaInicioAmor) THEN
			SET Par_NumErr    	:= '004';
    		SET Par_ErrMen    	:= 'La Fecha Actual del Sistema es Menor a \nla Fecha Inicio de Primer Amortizacion.';
    		SET Var_Control   	:= 'creditoID';
    		SET Par_Consecutivo := Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;

		IF ( Var_TipoPrepago = Cadena_Vacia ) THEN
			SET Par_NumErr    	:= '005';
    		SET Par_ErrMen    	:= CONCAT('La opcion de Prepago no esta habilitada para el Credito ', Par_CreditoID);
    		SET Var_Control   	:= 'creditoID';
    		SET Par_Consecutivo := Par_CreditoID;
			LEAVE ManejoErrores;
		END IF;


-- Validacion para Creditos Diferidos
SELECT TipoDiferimiento,FechaFinPeriodo
INTO Var_TipoDiferimiento,Var_FechaBloqPre
FROM CREDITOSDIFERIDOS WHERE CreditoID = Par_CreditoID;

SET Var_TipoDiferimiento := IFNULL(Var_TipoDiferimiento,Cadena_Vacia);
SET Var_FechaBloqPre := IFNULL(Var_FechaBloqPre,Fecha_Vacia);

IF  (Var_TipoDiferimiento = Tipo_Completo
    AND Var_FechaSistema < Var_FechaBloqPre)
THEN
    SET Par_NumErr  := 101;
	SET Par_ErrMen := CONCAT('No es posible aplicar prepagos a un Credito Diferido, hasta que se termine el perido de Diferimiento. <br><br> <b>Fin de Periodo: </b>',Var_FechaBloqPre);
	LEAVE ManejoErrores;
END IF;

IF  (Var_TipoDiferimiento = Tipo_TasaPref)
THEN
    SET Par_NumErr  := 101;
	SET Par_ErrMen := CONCAT('No es posible aplicar prepagos a un Credito Diferido con tasa preferencial.');
	LEAVE ManejoErrores;
END IF;

-- FIN Validacion para Creditos Diferidos
		IF (Var_TipoPrepago = Tip_UltCuo) THEN 				-- Tipo de PrePago: Ultimas cuotas

			CALL `PREPAGOCREULTCUOPRO`(
				Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,	Par_MonedaID,		Par_EmpresaID,
				SalidaNO,			Par_AltaEncPoliza,	Par_MontoPago,	Var_Poliza,			Par_Origen,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,Par_ModoPago,		Par_RespaldaCred,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		ELSEIF (Var_TipoPrepago = Tip_SigCuo) THEN			-- Tipo de PrePago: A las cuotas siguientes inmediatas

			CALL `PREPAGOCRESIGCUOPRO`(
				Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,		Par_MonedaID,		Par_EmpresaID,
				SalidaNO,			Par_AltaEncPoliza,	Par_MontoPago,		Var_Poliza,			Par_Origen,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,		Par_RespaldaCred,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		ELSEIF (Var_TipoPrepago = Tip_Prorrateo) THEN		-- Tipo de PrePago: Prorrateo de pago en cuotas vivas

			CALL `PREPAGOCREPRORRAPRO`(
				Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,		Par_MonedaID,		Par_EmpresaID,
				SalidaNO,			Par_AltaEncPoliza,	Par_MontoPago,		Var_Poliza,			Par_Origen,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,		Par_RespaldaCred,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		ELSEIF ( Var_TipoPrepago = Tip_CuoProyComp) THEN		-- Tipo de PrePago: Pago Cuotas Completas Proyectadas

			CALL `PREPAGOCREDCUOCOMPRO`(
				Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,		Par_MonedaID,		SalidaNO,
				Par_AltaEncPoliza,	Par_MontoPago,		Var_Poliza,			Par_NumErr,			Par_ErrMen,
				Par_Consecutivo,	Par_ModoPago,		Par_Origen,			Par_RespaldaCred,	Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE
			SET Par_NumErr  := 1;
			SET Par_ErrMen := 'El Tipo de Prepago no Existe';
			LEAVE ManejoErrores;
		END IF;

		-- EJECUTA PROCESO DE DETECCION DE OPERACIONES INUSUALES AL MOMNETO DE LA TRANSACCION POR PREPAGO DE CREDITO
		CALL PLDOPEINUSALERTTRANSPRO(
			TipoOperPLDCredito,		Var_ClienteID,			Par_CuentaAhoID,		Cadena_Vacia,			Cadena_Vacia,
			Par_CreditoID,
			SalidaNO,         		Var_NumErr,           	Var_ErrMen,             Par_EmpresaID,          Aud_Usuario,
			Aud_FechaActual,     	Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
		);

		IF(Var_NumErr <> Entero_Cero)THEN
			CALL BITAERRORPLDDETOPETRANALT(
				'PLDOPEINUSALERTTRANSPRO',	Var_NumErr,				Var_ErrMen,				TipoOperPLDCredito,		Var_ClienteID,
				Par_CreditoID,				Cadena_Vacia,			Par_MontoPagar,
				SalidaNO,         			Var_NumErr,           	Var_ErrMen,             Par_EmpresaID,          Aud_Usuario,
				Aud_FechaActual,     		Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion
			);
		END IF;

	-- Se valida la poliza cuando el pago es cargo a cuenta
	IF( Par_Origen = Con_CargoCta ) THEN
		-- Se realiza la suma de los CARGOS y ABONOS de la Poliza
		SELECT ROUND(SUM(Cargos),2), ROUND(SUM(Abonos),2) INTO Var_CargosPoliza, Var_AbonosPoliza
		FROM DETALLEPOLIZA
		WHERE PolizaID = Var_Poliza;

		SET	Var_CargosPoliza	:= IFNULL(Var_CargosPoliza,Decimal_Cero);
		SET	Var_AbonosPoliza	:= IFNULL(Var_AbonosPoliza,Decimal_Cero);

		IF(Var_CargosPoliza > Decimal_Cero OR Var_AbonosPoliza > Decimal_Cero)THEN
			IF(ABS((Var_CargosPoliza - Var_AbonosPoliza)) > LimiteDifPoliza OR (Var_CargosPoliza + Var_AbonosPoliza) = Decimal_Cero)THEN
				SET Par_NumErr 	:= 01;
				SET Par_ErrMen	:= CONCAT("Poliza Descuadrada ",Var_CargosPoliza ,' - ',Var_AbonosPoliza);
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen := 'PrePago de Credito Aplicado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Poliza AS control,
				Aud_NumTransaccion AS consecutivo;
	END IF;


END TerminaStore$$
