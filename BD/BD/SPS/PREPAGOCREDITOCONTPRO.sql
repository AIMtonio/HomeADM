-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCREDITOCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOCREDITOCONTPRO`;
DELIMITER $$

CREATE PROCEDURE `PREPAGOCREDITOCONTPRO`(
-- ==============================================================
--  SP DE PROCESO QUE REALIZA EL PREPAGO DE CREDITO CONTINGENTE
--  =============================================================
    Par_CreditoID       BIGINT(12),
    Par_CuentaAhoID     BIGINT(12),
    Par_MontoPagar      DECIMAL(14,2),
    Par_MonedaID        INT(11),
    Par_EmpresaID       INT(11),
    Par_Salida          CHAR(1),
    Par_AltaEncPoliza   CHAR(1),

    OUT Par_MontoPago   DECIMAL(12,2),
    INOUT Var_Poliza    BIGINT,

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    OUT Par_Consecutivo BIGINT,
    Par_ModoPago        CHAR(1),
    Par_Origen          CHAR(1),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN
    -- Declaracion de variables
    DECLARE Var_EstatusCre      CHAR(1);
    DECLARE Var_EsGrupal        CHAR(1);
    DECLARE Var_GrupoID         INT;
    DECLARE Var_CicloGrupo      INT;
    DECLARE Var_TipoPrepago     CHAR(1);
    DECLARE Var_CicloActual     INT;
    DECLARE Var_SoliciCreID     INT;
    DECLARE Var_ProrrateaPago   CHAR(1);
    DECLARE Var_EstGrupo        CHAR(1);
    DECLARE Var_FechaInicioAmor DATE;
    DECLARE Var_FechaSistema    DATE;
    DECLARE Var_Control         VARCHAR(100);
	DECLARE Var_FechaActPago	DATETIME;
	DECLARE Var_DifDiasPago		INT;

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT;
    DECLARE Entero_Uno      INT;
    DECLARE Decimal_Cero    DECIMAL(12, 2);
    DECLARE Esta_Vencido    CHAR(1);
    DECLARE Esta_Vigente    CHAR(1);
    DECLARE NO_EsGrupal     CHAR(1);
    DECLARE Si_EsGrupal     CHAR(1);
    DECLARE SI_Prorratea    CHAR(1);
    DECLARE Tip_UltCuo      CHAR(1);
    DECLARE Tip_SigCuo      CHAR(1);
    DECLARE Tip_Prorrateo   CHAR(1);
    DECLARE Gru_Activo      CHAR(1);
    DECLARE SalidaSI        CHAR(1);
    DECLARE SalidaNO        CHAR(1);
    DECLARE Var_NumRecPago  INT;
    DECLARE Var_OrigenWS    CHAR(1);            -- Cuando el origen del credito es mediante Web Service
    DECLARE Var_OrigenSAFY  CHAR(1);            -- Cuando el origen del credito es mediante SAFY

    -- Asignacion de Constantes
    SET Cadena_Vacia    := '';                              -- Cadena Vacia
    SET Fecha_Vacia     := '1900-01-01';                    -- Fecha Vacia
    SET Entero_Cero     := 0;                               -- Entero en Cero
    SET Decimal_Cero    := 0.00;                            -- DECIMAL Cero
    SET Entero_Uno      := 1;                               -- DECIMAL Cero
    SET Esta_Vencido    := 'B';                             -- Estatus del Credito: Vencido
    SET Esta_Vigente    := 'V';                             -- Estatus del Credito: Vigente
    SET NO_EsGrupal     := 'N';                             -- Si es un Credito Grupal
    SET SI_EsGrupal     := 'S';                             -- Si es un Credito Grupal
    SET SI_Prorratea    := 'S';                             -- Si Prorrate el Pago Grupal
    SET Tip_UltCuo      := 'U';                             -- Tipo de PrePago: Ultimas cuotas
    SET Tip_SigCuo      := 'I';                             -- Tipo de PrePago: A las cuotas siguientes inmediatas
    SET Tip_Prorrateo   := 'V';                             -- Tipo de PrePago: Prorrateo de pago en cuotas vivas
    SET Gru_Activo      := 'A';                             -- Estatus dentro del Grupo: Activo
    SET SalidaSI        := 'S';                             -- El Store si Regresa una Salida
    SET SalidaNO        := 'N';                             -- El Store no Regresa una Salida
    SET Var_NumRecPago  := 0;
    SET Var_OrigenWS    := 'W';                             -- Cuando el origen del credito es mediante Web Service
    SET Var_OrigenSAFY  := 'S';                             -- Cuando el origen del credito es mediante SAFY

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: SP-PREPAGOCREDITOCONTPRO');
        END;

        SET Aud_FechaActual     := NOW();

        IF(IFNULL(Par_CreditoID,Entero_Cero)=Entero_Cero) THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'El Numero de Credito esta vacio.';
            SET Var_Control:= 'creditoIDPre';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_CuentaAhoID,Entero_Cero)=Entero_Cero) THEN
            SET Par_NumErr := 2;
            SET Par_ErrMen := 'El Numero de Cuenta esta vacio.';
            SET Var_Control:= 'cuentaIDPre';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoPagar,Decimal_Cero)=Decimal_Cero) THEN
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'El Monto a Pagar esta vacio.';
            SET Var_Control:= 'montoPagarPre';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_MontoPagar,Decimal_Cero)<Entero_Uno) THEN
            SET Par_NumErr := 4;
            SET Par_ErrMen := 'El Monto a Pagar no debe ser menor a 1.';
            SET Var_Control:= 'montoPagarPre';
            LEAVE ManejoErrores;
        END IF;

        SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;

		-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE CREDITO SI AUN NO PASA MAS DE UN MINUTO.
		IF (Par_Origen != Var_OrigenWS) THEN
			# SE OBTIENE LA FECHA DEL PAGO MÁS RECIENTE.
			SET Var_FechaActPago := (SELECT MAX(FechaActual) FROM DETALLEPAGCRE WHERE CreditoID = Par_CreditoID AND FechaPago = Var_FechaSistema);
			SET Var_FechaActPago := IFNULL(Var_FechaActPago,Fecha_Vacia);

			# SE CALCULA LA DIFERENCIA ENTRE LAS FECHAS EN DÍAS
			SET Var_DifDiasPago := DATEDIFF(Aud_FechaActual,Var_FechaActPago);
			SET Var_DifDiasPago := IFNULL(Var_DifDiasPago,Entero_Cero);

			# SI EL PAGO ES EN EL MISMO DÍA, SE VALIDA QUE HAYA PASADO AL MENOS 1 MIN.
			IF(Var_DifDiasPago=Entero_Cero)THEN
				IF(TIMEDIFF(Aud_FechaActual,Var_FechaActPago)<= time('00:01:00'))THEN
					SET Par_NumErr		:= '001';
					SET Par_ErrMen		:= 'Ya se realizo un pago de credito para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
					SET Var_Control		:= 'montoPagarPre';
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

        SELECT  Cre.Estatus,        Cre.TipoPrepago,   Cre.FechaInicioAmor
            INTO
                Var_EstatusCre,     Var_TipoPrepago,   Var_FechaInicioAmor
            FROM PRODUCTOSCREDITO Pro,
                 CREDITOSCONT Cre
        WHERE Cre.CreditoID = Par_CreditoID
            AND Cre.ProductoCreditoID = Pro.ProducCreditoID;

        -- Inicializaciones
        SET Var_EstatusCre   := IFNULL(Var_EstatusCre, Cadena_Vacia);
        SET Var_TipoPrepago  := IFNULL(Var_TipoPrepago, Cadena_Vacia);
        SET Par_MontoPago    := Entero_Cero;
        SET Par_Consecutivo  := Entero_Cero;


        IF (Var_FechaSistema < Var_FechaInicioAmor) THEN
            SET Par_NumErr := 6;
            SET Par_ErrMen := 'La Fecha Actual del Sistema es Menor a \nla Fecha Inicio de Primer Amortizacion.';
            SET Var_Control:= 'creditoID';
            LEAVE ManejoErrores;
        END IF;

        IF (Var_TipoPrepago = Tip_SigCuo) THEN -- Tipo de PrePago: A las cuotas siguientes inmediatas

            CALL PREPAGOCRECONTSIGCUOPRO(
                Par_CreditoID,  Par_CuentaAhoID,    Par_MontoPagar, Par_MonedaID,       Par_EmpresaID,
                SalidaNO,       Par_AltaEncPoliza,  Par_MontoPago,  Var_Poliza,         Par_NumErr,
                Par_ErrMen,     Par_Consecutivo,    Par_ModoPago,   Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        ELSE
                SET Par_NumErr  := 7;
                SET Par_ErrMen := 'El Tipo de Prepago no Existe';
                LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := 'PrePago de Credito Aplicado Exitosamente.';

END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Poliza AS control,
            Aud_NumTransaccion AS consecutivo;
    END IF;


END TerminaStore$$