-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCREDITOSALT`;
DELIMITER $$

CREATE PROCEDURE `BANCREDITOSALT`(
# =============================================================================================================================
# ----------- SP PARA DAR DE ALTA UN CREDITO NUEVO O UN CREDITO RENOVACION ----------------------------
# =============================================================================================================================
    Par_ClienteID       INT(11),					-- Número de cliente
    Par_LinCreditoID    INT(11),					-- Número de Linea de Crédito
    Par_ProduCredID     INT(11),					-- Número del producto de crédito
    Par_CuentaID        BIGINT(12),					-- Número de la cuenta
	Par_TipoCredito     CHAR(1),					-- Tipo de crédito (Renovación o Reestructura)
    Par_Relacionado     BIGINT(12),					-- Número del Crédito
    Par_SolicCredID     INT(11),					-- Número de la Solicitud de Crédito
    Par_MontoCredito    DECIMAL(12,2),				-- Monto del Crédito
    Par_MonedaID        INT(11),					-- Número de MonedaID
    Par_FechaInicio     DATE,						-- Fecha de Inicio

    Par_FechaVencim     DATE,						-- Fecha de Vencimiento
    Par_FactorMora      DECIMAL(12,2),				-- Factor Moratorio
    Par_CalcInterID     INT(11),					-- Calculo de Interes
    Par_TasaBase        INT(11),					-- Tasa Base
    Par_TasaFija        DECIMAL(12,4),				-- Tasa Fija
    Par_SobreTasa       DECIMAL(12,4),				-- Sobre Tasa
    Par_PisoTasa        DECIMAL(12,2),				-- Piso Tasa
    Par_TechoTasa       DECIMAL(12,2),				-- Techo Tasa
    Par_FrecuencCap     CHAR(1),					-- Fecuencia de Capital
    Par_PeriodCap       INT(11),					-- Periodicidad del capital

    Par_FrecuencInt     CHAR(1),					-- Frecuencia de Interes
    Par_PeriodicInt     INT(11),					-- Periodicidad del Interes
    Par_TPagCapital     VARCHAR(10),				-- Tipo de Pago capital
    Par_NumAmortiza     INT(11),					-- Número de Amortizaciones
    Par_FecInhabil      CHAR(1),					-- Fecha Inhabil
    Par_CalIrregul      CHAR(1),					-- Calculo Irregular
    Par_DiaPagoInt      CHAR(1),					-- Dia de pago de Interes
    Par_DiaPagoCap      CHAR(1),					-- Dia de pago de capital
    Par_DiaMesInt       INT(11),					-- Dia mes Interes
    Par_DiaMesCap       INT(11),					-- Dia mes capital

    Par_AjFUlVenAm      CHAR(1),					-- Ajuste de fecha de Vencimiento de Amortizacion
    Par_AjuFecExiVe     CHAR(1),					-- Ajuste de fehca de exigible de vencimiento
    Par_NumTransacSim   BIGINT(20),					-- Numero de transaccion de simulador
    Par_TipoFondeo      CHAR(1),					-- Tipo de fondeo
    Par_MonComApe       DECIMAL(12,2),				-- Monto de comision por apertura
    Par_IVAComApe       DECIMAL(12,2),				-- Iva de comision por apertura
    Par_ValorCAT        DECIMAL(12,4),				-- Valor de CAT
    Par_Plazo           VARCHAR(20),				-- Plazo
    Par_TipoDisper      CHAR(1),					-- Tipo de Dispersion
	Par_CuentaCABLE		CHAR(18), --  Cuenta Clabe para cuando el tipo de Dispersion sea por SPEI

    Par_TipoCalInt      INT(11),					-- Tipo de calculo de interes
    Par_DestinoCreID    INT(11),					-- destino de credito
    Par_InstitFondeoID  INT(11),					-- institucion de fondeo
    Par_LineaFondeo     INT(11),					-- linea de fondeo
    Par_NumAmortInt     INT(11),					-- Numero de amortizaciones de interes
    Par_MontoCuota      DECIMAL(12,2),				-- Monto de la cuota
    Par_MontoSegVida    DECIMAL(12,2),				-- Monto del seguro de Vida
    Par_AportaCliente	DECIMAL(12,2),				-- Aportacion del cliente
    Par_ClasiDestinCred CHAR(1),					-- Clasificacion de destino de credito
	Par_TipoPrepago     CHAR(1),					-- Tipo de prepago

	Par_FechaInicioAmor	DATE,						-- Fecha de inicio de las amortizaciones
 	Par_ForCobroSegVida	CHAR(1),					-- Fecha de Cobro de Seguro de Vida
 	Par_DescSeguro		DECIMAL(12,2),				-- seguro
	Par_MontoSegOri		DECIMAL(12,2),				-- Monto seguro

	Par_TipoConsultaSIC CHAR(2),					-- ConsultaSIC
    Par_FolioConsultaBC VARCHAR(30),				-- Folio Consulta BC
	Par_FolioConsultaCC VARCHAR(30),				-- Folio Consulta CC
    Par_FechaCobroComision DATE,					-- Fecha Cobro Comision
    Par_ReferenciaPago	VARCHAR(20),				-- Referencia de Pago

    Par_Salida          CHAR(1),
    OUT   NumCreditoID  BIGINT(12),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_empresa 		INT(11) ,					-- Auditoria
    Par_Usuario 		INT(11) ,					-- Auditoria
    Par_FechaActual 	DATETIME,					-- Auditoria
    Par_DireccionIP 	VARCHAR(15),				-- Auditoria
    Par_ProgramaID 		VARCHAR(50),				-- Auditoria
    Par_SucursalID 		INT(11) ,					-- Auditoria
    Par_NumTransaccion 	BIGINT(20)					-- Auditoria
						)
TerminaStore: BEGIN
    -- Declaracion de constantes
	DECLARE SalidaNO				CHAR(1);		-- Constante Salida NO
	DECLARE SalidaSI				CHAR(1);		-- Constante Salida SI
	DECLARE Entero_Cero				INT(11);		-- Entero Cero
	DECLARE Cadena_Vacia			VARCHAR(10);	-- Cadena Vacia
	DECLARE ServicioNO				CHAR(1);		-- Constante Servicio NO

	-- Declaracion de Variables
	DECLARE Var_Respuesta			VARCHAR(70);	-- Cadena con la respuesta
	DECLARE Var_UsuarioID			INT(11);		-- Numero de Usuario
	DECLARE Var_Control             VARCHAR(100);	-- Variable con el nombre del control

	-- Asignacion de valor a constantes
	SET SalidaNO					:= 'N';			-- Constante Salida NO
	SET SalidaSI					:= 'S';			-- Constante Salida SI
	SET Entero_Cero					:= 0;			-- Entero Cero
	SET Cadena_Vacia				:= '';			-- Cadena vacía.
	SET ServicioNO					:= 'N';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-BANCREDITOSALT');
				SET Var_Control := 'SQLEXCEPTION';
			END;

		CALL CREDITOSALT(
				Par_ClienteID,				Par_LinCreditoID,			Par_ProduCredID,			Par_CuentaID,			Par_TipoCredito,
				Par_Relacionado,			Par_SolicCredID,			Par_MontoCredito,			Par_MonedaID,			Par_FechaInicio,
				Par_FechaVencim,			Par_FactorMora,				Par_CalcInterID,			Par_TasaBase,			Par_TasaFija,
				Par_SobreTasa,				Par_PisoTasa,				Par_TechoTasa,				Par_FrecuencCap,		Par_PeriodCap,
				Par_FrecuencInt,			Par_PeriodicInt,			Par_TPagCapital,			Par_NumAmortiza,		Par_FecInhabil,
				Par_CalIrregul,				Par_DiaPagoInt,				Par_DiaPagoCap,				Par_DiaMesInt,			Par_DiaMesCap,
				Par_AjFUlVenAm,				Par_AjuFecExiVe,			Par_NumTransacSim,			Par_TipoFondeo,			Par_MonComApe,
				Par_IVAComApe,				Par_ValorCAT,				Par_Plazo,					Par_TipoDisper,			Par_CuentaCABLE,
				Par_TipoCalInt,				Par_DestinoCreID,			Par_InstitFondeoID,			Par_LineaFondeo,		Par_NumAmortInt,
				Par_MontoCuota,				Par_MontoSegVida,			Par_AportaCliente,			Par_ClasiDestinCred,	Par_TipoPrepago,
				Par_FechaInicioAmor,		Par_ForCobroSegVida,		Par_DescSeguro,				Par_MontoSegOri,		Par_TipoConsultaSIC,
				Par_FolioConsultaBC,		Par_FolioConsultaCC,		Par_FechaCobroComision,		Par_ReferenciaPago,		SalidaNO,
				NumCreditoID,				Par_NumErr,					Par_ErrMen,					Par_empresa,			Par_Usuario,
				Par_FechaActual,			Par_DireccionIP,			Par_ProgramaID,				Par_SucursalID,			Par_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero) THEN
			SET NumCreditoID := 0;
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Credito Agregado Exitosamente: ', CONVERT(NumCreditoID, CHAR), '.');
		SET Var_Control := 'creditoID';

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				NumCreditoID AS consecutivo;/*Enviar siempre en exito el numero de Solicitud*/
	END IF;
END TerminaStore$$ 
