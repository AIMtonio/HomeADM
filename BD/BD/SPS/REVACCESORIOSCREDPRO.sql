-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVACCESORIOSCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVACCESORIOSCREDPRO`;
DELIMITER $$

CREATE PROCEDURE `REVACCESORIOSCREDPRO`(
# =====================================================================================
# ----- SP QUE REALIZA LA REVERSA DE PAGO DE ACCESORIOS DE UN CREDITO -----------------
# =====================================================================================
	Par_CreditoID			BIGINT(12),		# Numero de Credito
	Par_AccesorioID			INT(11),		# Numero de Accesorio
	Par_CuentaAhoID			BIGINT(12),		# Numero de Cuenta de Ahorro
	Par_ClienteID			INT(11),		# Numero de Cliente
	Par_MonedaID			INT(11),		# Tipo Moneda

	Par_ProdCreID			INT(4), 		# Producto de Credito
    Par_SucursalCliente		INT(11),		# Sucursal del Cliente
    Par_ClasifCred			CHAR(1),		# Clasificacion del Credito
    Par_SubClasifCred		INT(11),		# Indica la subclasificacion del destino de credito
    Par_PagaIVA				CHAR(1),		# Indica si el cliente paga IVA

	INOUT	Par_Poliza		INT(11),		# Numero de Poliza
	Par_Salida    			CHAR(1), 		# Salida S:SI  N:NO
    INOUT	Par_NumErr 		INT(11),		# Numero de Error
    INOUT	Par_ErrMen  	VARCHAR(400),

-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaOper 			DATE;			# Fecha de Operacion
	DECLARE Var_FechaApl 			DATE;			# Fecha de Aplicacion
	DECLARE Var_EsHabil				CHAR(1);		# Indica si es dia habil
	DECLARE Par_Consecutivo			BIGINT;			# Consecutivo
	DECLARE Var_Iva					DECIMAL(14,2);	# Valor IVA
	DECLARE Var_Control         	VARCHAR(100);	# Variable de control
    DECLARE Var_DescAccesorio		VARCHAR(100); 	# Variable Descripción Acceosorio
	DECLARE Var_DescIVAAccesorio	VARCHAR(100); 	# Variable Descripción IVA Accesorio

	DECLARE Var_ConceptoCartera		INT(11);		# Concepto de Cartera
    DECLARE Var_ConceptoIVACartera	INT(11);		# Concepto de Cartera al que corresponde el accesorio
    DECLARE Var_MontoPagado			DECIMAL(14,2);	# Monto Pagado de Accesorios
    DECLARE Var_AbrevAccesorio		VARCHAR(20);	# Abreviatura del Accesorio
    DECLARE Var_CobraIVAAc			CHAR(1);		# Indica si el Accesorio cobra IVA
    DECLARE Var_MontoAccesorio		DECIMAL(14,2);	# Indica el que se cobro de accesorios
    DECLARE Var_MontoIVAAccesorio	DECIMAL(14,2);	# Indica el monto de iva que se cobro del accesorio

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 			CHAR(1); 		# Constante Cadena Vacía
	DECLARE Entero_Cero  			INT(11); 		# Constante Entero Cero
	DECLARE Decimal_Cero 			DECIMAL(12,2); 	# Constante Decimal
	DECLARE ComAnticipada			CHAR(1); 		# Constante Comisión Anticipada
	DECLARE AltaPoliza_SI			CHAR(1); 		# constante Alta de Poliza Si
	DECLARE Salida_SI				CHAR(1); 		# Constante Salida Si
    DECLARE Salida_NO				CHAR(1); 		# Constante Salida No
	DECLARE RevMovAhoComAp			CHAR(3);		# Movimiento  Reversa Comision por Apertura
	DECLARE RevMovAhoIvaComAp		CHAR(3); 		# Movimiento Reversa Iva Comision por Apertura
	DECLARE AltaPolCre_SI			CHAR(1); 		# Alta en Poliza de Crédito Si : S
	DECLARE AltaMovCre_NO			CHAR(1); 		# Alta de Movimientos de Crédito No : N
	DECLARE Nat_Cargo				CHAR(1); 		# Constante Naturaleza Cargo
	DECLARE Nat_Abono				CHAR(1); 		# Constante Naturaleza Abono
	DECLARE AltaMovAho_SI			CHAR(1); 		# Alta Movimientos de Ahorro Si : S
	DECLARE AltaPoliza_NO			CHAR(1); 		# Alta de Poliza No : N
    DECLARE Var_SI					CHAR(1); 		# Constante Si : S
    DECLARE Var_NO					CHAR(1); 		# Constante No : N
    DECLARE Ref_GenAccesorios 		VARCHAR(100);	# Descripcion de la referencia de generacion de accesorios
    DECLARE Ref_GenIVAAccesorios	VARCHAR(100);	# Descripcion de la referencia de generacion del IVA de accesorios
    DECLARE RevMovAccesorios		CHAR(3);		# Movimiento Reversa Comision por Apertura
	DECLARE RevMovIVAAccesorios		CHAR(3); 		# Movimiento Reversa Iva Comision por Apertura

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';		# Constante Cadena Vacia
	SET Entero_Cero     	:= 0;		# Constante Entero Cero
	SET Decimal_Cero    	:= 0;		# Constante DECIMAL Cero
	SET ComAnticipada   	:= 'A';		# Cobra Comision por Apertura ANTICIPADA
	SET AltaPoliza_SI   	:= 'S';		# Alta Poliza SI
	SET AltaPoliza_NO		:='N';		# Alta Poliza NO
	SET Salida_SI			:= 'S';		# Salida SI
    SET Salida_NO			:= 'N';		# Salida NO
	SET RevMovAhoComAp 	  	:= '301'; 	# Corresponde con la tabla TIPOSMOVSAHO Reversa Comision por apertura
	SET RevMovAhoIvaComAp  	:= '302'; 	# Corresponde con la tabla TIPOSMOVSAHO Reversa Comision por apertura
	SET AltaPolCre_SI		:= 'S';		# Alta Detalle de los movimientos contables del credito: SI
	SET AltaMovCre_NO		:= 'N';		# Alta Movimientos Operativos del Credito: NO
	SET Nat_Cargo			:= 'C';		# Naturaleza: Cargo
	SET Nat_Abono			:= 'A';		# Naturaleza: Abono
	SET AltaMovAho_SI		:= 'S';		# Alta Movimientos a la Cuenta de Ahorro del Cliente: SI
    SET Var_SI				:= 'S';		# Constante SI.
	SET Var_NO				:= 'N';		# Constante NO
    SET RevMovAccesorios	:= '308';	# Corresponde con la tabla TIPOSMOVSAHO Reversa Accesorios Credito
    SET RevMovIVAAccesorios	:= '309';	# Corresponde con la tabla TIPOSMOVSAHO Reversa IVA Accesorios Credito


	-- Asignacion de variables
	SET Aud_FechaActual := NOW();
	SET Var_FechaOper 	:=(SELECT FechaSistema FROM PARAMETROSSIS);

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-REVACCESORIOSCREDPRO');
				SET Var_Control := 'SQLEXCEPTION';
			END;

	CALL DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);


    # SE OBTIENEN LOS DATOS NECESARIOS PARA LA APLICACION DEL PAGO
	SELECT  Det.MontoPagado,		Ac.NombreCorto,		Det.CobraIVA
	INTO 	Var_MontoPagado,		Var_AbrevAccesorio,	Var_CobraIVAAc
	FROM DETALLEACCESORIOS Det
    INNER JOIN ACCESORIOSCRED Ac
    ON Det.AccesorioID = Ac.AccesorioID
	WHERE Det.CreditoID =  Par_CreditoID
	AND Ac.AccesorioID = Par_AccesorioID;

    SET Var_ConceptoCartera := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = Var_AbrevAccesorio);

	IF(Var_CobraIVAAc = Var_SI) THEN
		SET Var_ConceptoIVACartera := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('IVA ', Var_AbrevAccesorio) );
	END IF;
	IF(IFNULL(Par_AccesorioID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr		:= '01';
			SET Par_ErrMen		:= 'Especificar Accesorio';
			SET Var_Control		:= 	'creditoID';
		LEAVE ManejoErrores;
	END IF;

    IF(Par_PagaIVA = Var_SI) THEN
		IF(Var_CobraIVAAc = Var_SI) THEN
			SET Var_Iva := (SELECT IVA FROM SUCURSALES WHERE  SucursalID = Par_SucursalCliente);
			-- Se calcula el monto y el iva proporcional
			SET Var_MontoAccesorio 		:= ROUND(Var_MontoPagado,2);
			SET Var_MontoIVAAccesorio	:= (ROUND((Var_MontoPagado) * (Var_Iva),2));

        ELSE
			SET Var_MontoAccesorio := ROUND(Var_MontoPagado,2);
			SET Var_MontoIVAAccesorio := Entero_Cero;
        END IF;
	ELSE
		-- Cuando el cliente no paga iva
		SET Var_MontoAccesorio := ROUND(Var_MontoPagado,2);
		SET Var_MontoIVAAccesorio := Entero_Cero;
    END IF;

	-- movimientos de comision por apertura solo si es Anticipada
	SET Par_Poliza := IFNULL(Par_Poliza,Entero_Cero);
	IF(Par_Poliza > Entero_Cero)THEN
		SET AltaPoliza_SI:= Var_NO;
	END IF;

	# SE ASIGNA VALOR PARA LA REFERENCIA DEL MOVIMIENTO
	SET Ref_GenAccesorios := CONCAT('PAGO DE ACCESORIO ', Var_AbrevAccesorio);
	SET Ref_GenIVAAccesorios	:= CONCAT('PAGO DE IVA DE ACCESORIO', Var_AbrevAccesorio);
	SET Var_DescAccesorio		:= CONCAT('REVERSA ACCESORIO ', Var_AbrevAccesorio);
	SET Var_DescIVAAccesorio	:= CONCAT('REVERSA IVA ACCESORIO ', Var_AbrevAccesorio);

	# INGRESO POR CONCEPTO DE OTRA COMISIONES(ACCESORIOS)
	IF (Var_MontoAccesorio > Decimal_Cero) THEN

		# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
	   CALL CONTACCESORIOSCREDPRO (
			Par_CreditoID,			Entero_Cero,				Par_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
			Var_FechaOper,			Var_FechaApl,				Var_MontoAccesorio,		Par_MonedaID,			Par_ProdCreID,
			Par_ClasifCred,			Par_SubClasifCred, 			Par_SucursalCliente,	Var_DescAccesorio, 		Ref_GenAccesorios,
			AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_NO,
			Var_ConceptoCartera,	Entero_Cero, 				Nat_Cargo,				AltaMovAho_SI,			RevMovAccesorios,
			Nat_Abono, 				Cadena_Vacia,				Salida_NO,				Par_NumErr,				Par_ErrMen,
			Par_Consecutivo,		Aud_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Var_MontoIVAAccesorio != Decimal_Cero) THEN
		# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
		CALL CONTACCESORIOSCREDPRO (
			Par_CreditoID,			Entero_Cero,				Par_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
			Var_FechaOper,			Var_FechaApl,				Var_MontoIVAAccesorio,	Par_MonedaID,			Par_ProdCreID,
			Par_ClasifCred,			Par_SubClasifCred, 			Par_SucursalCliente,	Var_DescIVAAccesorio, 	Ref_GenIVAAccesorios,
			AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_NO,
			Var_ConceptoIVACartera,	Entero_Cero, 				Nat_Cargo,				AltaMovAho_SI,			RevMovIVAAccesorios,
			Nat_Abono, 				Cadena_Vacia,				Salida_NO,				Par_NumErr,				Par_ErrMen,
			Par_Consecutivo,		Aud_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);
		END IF;


		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	# SE OBTIENEN LOS DATOS ANTES DEL DESEMBOLSO DEL CREDITO
	UPDATE RESDETACCESORIOS		RDET	INNER JOIN
			DETALLEACCESORIOS 	DET		ON
            RDET.CreditoID  		= DET.CreditoID	AND
            RDET.AccesorioID 		= DET.AccesorioID
		SET
			DET.CreditoID 			= RDET.CreditoID,
			DET.SolicitudCreditoID	= RDET.SolicitudCreditoID,
			DET.NumTransacSim 		= RDET.NumTransacSim,
			DET.AccesorioID 		= RDET.AccesorioID,
			DET.PlazoID 			= RDET.PlazoID,
			DET.CobraIVA 			= RDET.CobraIVA,
			DET.GeneraInteres		= RDET.GeneraInteres,
			DET.CobraIVAInteres		= RDET.CobraIVAInteres,
			DET.TipoFormaCobro 		= RDET.TipoFormaCobro,
			DET.TipoPago 			= RDET.TipoPago,
			DET.BaseCalculo 		= RDET.BaseCalculo,
			DET.Porcentaje 			= RDET.Porcentaje,
			DET.AmortizacionID 		= RDET.AmortizacionID,
			DET.MontoAccesorio 		= RDET.MontoAccesorio,
			DET.MontoIVAAccesorio 	= RDET.MontoIVAAccesorio,
			DET.MontoCuota 			= RDET.MontoCuota,
			DET.MontoIVACuota 		= RDET.MontoIVACuota,
			DET.SaldoVigente 		= RDET.SaldoVigente,
			DET.SaldoAtrasado 		= RDET.SaldoAtrasado,
			DET.SaldoIVAAccesorio 	= RDET.SaldoIVAAccesorio,
			DET.MontoPagado 		= RDET.MontoPagado,
			DET.FechaLiquida 		= RDET.FechaLiquida
		WHERE 	DET.CreditoID 		= Par_CreditoID
		  AND	RDET.AccesorioID	= Par_AccesorioID;

		DELETE FROM RESDETACCESORIOS
			WHERE	CreditoID	=	Par_CreditoID
			  AND	AccesorioID   	= Par_AccesorioID;


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Reversa de Credito Realizado Exitosamente.';
		SET Var_Control := 'creditoID';

	END ManejoErrores;
	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control 	AS control,
				Par_CreditoID AS consecutivo;
	END IF;


END TerminaStore$$