-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREANTIINTERECONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREANTIINTERECONTPRO`;DELIMITER $$

CREATE PROCEDURE `CREANTIINTERECONTPRO`(
-- ------------------------------------------------------------------
-- PROCESO PARA EL CALCULO DE INTERESES CONTINGENTE
-- ------------------------------------------------------------------
    Par_CreditoID       BIGINT(12),
    Par_CreEstatus      CHAR(1),
    Par_MonedaID        INT(11),
    Par_ProdCreID       INT(11),
    Par_ClasifCre       CHAR(1),

    Par_SubClasifID     INT(11),
    Par_SucCliente      INT(11),
    Par_CreTasa         DECIMAL(12,4),
    Par_DiasCredito     INT(11),
    Par_FecAplicacion   DATETIME,

    Par_FechaSistema    DATETIME,
    Par_Poliza          BIGINT(20),
	OUT Par_IntAntici   DECIMAL(14,4),

    Par_Salida          CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	/*Parametros de auditoria*/
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
	DECLARE Var_ProxAmorti      INT(11);
	DECLARE Var_FecProxPago     DATE;
	DECLARE Var_FecDiasProPag   DATE;
	DECLARE Var_NumProyInteres  INT(11);
	DECLARE Mov_AboConta        INT(11);
    DECLARE Mov_CarConta        INT(11);
	DECLARE Mov_CarOpera        INT(11);
	DECLARE Var_IntProActual    DECIMAL(14,4);
	DECLARE Var_Interes    		DECIMAL(14,4);
	DECLARE Var_Control			VARCHAR(100);
    DECLARE Var_Consecutivo		BIGINT(12);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero    	DECIMAL(12,2);
	DECLARE Decimal_Cien    	DECIMAL(12,2);
    DECLARE Esta_Vencido    	CHAR(1);
	DECLARE Esta_Pagado     	CHAR(1);
	DECLARE Con_CueOrdInt   	INT(11);
    DECLARE Con_CorOrdInt   	INT(11);
	DECLARE Mov_IntPro      	INT(11);
	DECLARE Mov_IntNoConta  	INT(11);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE AltaPolCre_SI   	CHAR(1);
    DECLARE AltaMovCre_SI   	CHAR(1);
	DECLARE AltaMovCre_NO   	CHAR(1);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Pol_Automatica  	CHAR(1);
    DECLARE AltaMovAho_NO   	CHAR(1);
	DECLARE Des_PagoCred    	VARCHAR(50);
	DECLARE Ref_PagAnti     	VARCHAR(50);
	DECLARE SalidaSI 			CHAR(1);
	DECLARE Salida_NO           CHAR(1);
	-- Asignacion de Constantes
	SET Cadena_Vacia    := '';              -- String Vacio
	SET Fecha_Vacia     := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero     := 0;               -- Entero en Cero
	SET Decimal_Cero    := 0.00;            -- DECIMAL Cero
	SET Decimal_Cien    := 100.00;          -- DECIMAL en Cien
    SET Esta_Pagado     := 'P';             -- Estatus Pagado
	SET Esta_Vencido    := 'B';             -- Estatus Credito: Vencido
	SET Mov_IntPro      := 14;              -- Tipo de Movimiento de Credito: Interes Provisionado
	SET Mov_IntNoConta  := 13;              -- Tipo de Movimiento de Credito: Interes No Contabilizado
	SET Con_CueOrdInt   := 72;              -- Concepto Contable: Orden Intereses - Cartera Castigada
	SET Con_CorOrdInt   := 73;              -- Concepto Contable: Correlativa Intereses - Cartera Castigada
	SET AltaPoliza_NO   := 'N';             -- Alta de la Poliza Contable: NO
	SET AltaPolCre_SI   := 'S';             -- Alta de la Poliza Contable de Credito: SI
    SET AltaMovCre_SI   := 'S';             -- Alta de los Movimientos de Credito: SI
	SET AltaMovCre_NO   := 'N';             -- Alta de los Movimientos de Credito: NO
	SET Nat_Cargo       := 'C';             -- Naturaleza de Cargo
	SET Nat_Abono       := 'A';             -- Naturaleza de Abono.
	SET Pol_Automatica  := 'A';             -- Tipo de Poliza: Automatica
    SET AltaMovAho_NO   := 'N';             -- Alta de los Movimientos de Ahorro: NO
	SET SalidaSI		:= 'S';         	-- Salida SI
	SET Salida_NO       := 'N';
	SET Des_PagoCred    := 'DEVENGO INT.PAGO ANTICI CONTINGENTE'; 			-- Pago de Credito
	SET Ref_PagAnti     := 'PAGO ANTICIPADO CONTINGENTE';		  -- Pago Anticipado
	SET Par_IntAntici   := Entero_Cero;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CREANTIINTERECONTPRO');
			SET Var_Control:= 'SQLEXCEPTION';
		END;

		-- Obtenemos la Amortizacion "Vigente-Actual"
		SELECT MIN(FechaExigible), MIN(FechaVencim), MIN(AmortizacionID) INTO
			   Var_FecProxPago, Var_FecDiasProPag, Var_ProxAmorti
			FROM AMORTICREDITOCONT
			WHERE CreditoID     = Par_CreditoID
			  AND FechaVencim  > Par_FechaSistema
			  AND Estatus     != Esta_Pagado;

		SET Var_FecProxPago 	:= IFNULL(Var_FecProxPago, Fecha_Vacia);
		SET Var_FecDiasProPag 	:= IFNULL(Var_FecDiasProPag, Fecha_Vacia);
		SET Var_ProxAmorti  	:= IFNULL(Var_ProxAmorti, Entero_Cero);


		IF(Var_ProxAmorti != Entero_Cero) THEN
			-- Verificamos si Ya Cargamos con Anterioridad los Intereses por Devengar
			SELECT Amo.NumProyInteres, Amo.Interes,
					IFNULL(Amo.SaldoInteresPro, Entero_Cero) + IFNULL(Amo.SaldoIntNoConta, Entero_Cero) INTO
					Var_NumProyInteres, Var_Interes, Var_IntProActual
				FROM AMORTICREDITOCONT Amo
				WHERE Amo.CreditoID     = Par_CreditoID
				  AND Amo.AmortizacionID = Var_ProxAmorti
				  AND Amo.Estatus     != Esta_Pagado;

			SET Var_NumProyInteres  := IFNULL(Var_NumProyInteres, Entero_Cero);
			SET Var_IntProActual 	:= IFNULL(Var_IntProActual, Entero_Cero);
			SET Var_Interes 		:= IFNULL(Var_Interes, Entero_Cero);

			IF(Var_NumProyInteres = Entero_Cero) THEN
				-- Cargamos los Intereses por Devengar
				SET Par_IntAntici := ROUND(Var_Interes - Var_IntProActual,2);

				IF(Par_IntAntici < Entero_Cero) THEN
					SET Par_IntAntici := Entero_Cero;
				END IF;

				IF (Par_IntAntici > Entero_Cero) THEN
					-- Actualizamos la Amortizacion, con una Proyeccion de Interes
					UPDATE AMORTICREDITOCONT Amo SET
						NumProyInteres = IFNULL(NumProyInteres, Entero_Cero) + 1
						WHERE Amo.CreditoID     = Par_CreditoID
						  AND Amo.AmortizacionID = Var_ProxAmorti;

					-- Verifica si el Credito esta Vencido diferenciar Los Asientos Contables del Interes
					SET	Mov_AboConta	:= Con_CorOrdInt;
					SET	Mov_CarConta	:= Con_CueOrdInt;
					SET	Mov_CarOpera	:= Mov_IntNoConta;



					CALL CONTACREDITOSCONTPRO (
						Par_CreditoID,      Var_ProxAmorti,     Entero_Cero,        Entero_Cero,		Par_FechaSistema,
                        Par_FecAplicacion,  Par_IntAntici,      Par_MonedaID,		Par_ProdCreID,		Par_ClasifCre,
                        Par_SubClasifID,    Par_SucCliente,		Des_PagoCred,       Ref_PagAnti,		AltaPoliza_NO,
                        Entero_Cero,		Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,		Mov_CarConta,
						Mov_CarOpera,       Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,
                        Salida_NO,			Par_NumErr,         Par_ErrMen,         Var_Consecutivo,	Par_EmpresaID,
                        Par_ModoPago,    	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,	Ref_PagAnti,
                        Aud_Sucursal,      	Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSCONTPRO (
						Par_CreditoID,      Var_ProxAmorti,     Entero_Cero,        Entero_Cero,		Par_FechaSistema,
                        Par_FecAplicacion,  Par_IntAntici,      Par_MonedaID,		Par_ProdCreID,		Par_ClasifCre,
                        Par_SubClasifID,    Par_SucCliente,		Des_PagoCred,       Ref_PagAnti,		AltaPoliza_NO,
                        Entero_Cero,		Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,		Mov_AboConta,
						Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Cadena_Vacia,
                        Salida_NO,			Par_NumErr,         Par_ErrMen,         Var_Consecutivo,	Par_EmpresaID,
                        Par_ModoPago,   	Aud_Usuario,        Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
                        Aud_Sucursal,     	Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;
			END IF;
		END IF;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= CONCAT('Interes Provisionado Exitoso: ',Par_IntAntici);
		SET Var_Control		:= 'creditoID';
		SET Var_Consecutivo	:= Par_CreditoID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI)THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS control,
			Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$