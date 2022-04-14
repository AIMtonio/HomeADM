-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROACCESORIOSCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROACCESORIOSCREPRO`;
DELIMITER $$

CREATE PROCEDURE `COBROACCESORIOSCREPRO`(
# ======================================================================================================
# ----- SP QUE REALIZA EL COBRO DE LOS ACCESORIOS DE UN CREDITO QUE SON COBRADOS DE MANERA ANTICIPADA
# ======================================================================================================
	Par_CreditoID			BIGINT(12),		# Indica el numero de Credito
    Par_AccesorioID			INT(11),		# Indica el ID del Accesorio
	Par_CuentaAhoID			BIGINT(12),		# Cuenta de Ahorro del Cliente
	Par_ClienteID			INT(11),		# ID del Cliente
	Par_MonedaID			INT(11),		# Moneda

	Par_ProductoCreditoID	INT(4),			# Producto de Credito
	Par_MontoAccesorio		DECIMAL(14,2), 	# Monto Total a Pagar
	Par_IvaAccesorio		DECIMAL(14,2),	# Monto del IVA a Pagar
	Par_ForCobroAccesorio	CHAR(1),		# Forma de Cobro del Accesorio A:Anticipada  D:Deduccion  F:Financiamiento
	Par_Poliza				INT(11),		# Numero de Poliza

	Par_OrigenPago			CHAR(1),		# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida				CHAR(1), 		# Indica la Salida S:Si  N:No
    INOUT	Par_NumErr 		INT(11),		# Numero de Error
    INOUT	Par_ErrMen  	VARCHAR(400),	# Mensaje de Error
	# Parametros de Auditoria
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
DECLARE Var_EsHabil				CHAR(1);		# Indica si el dia es habil
DECLARE Var_SucCliente			INT(11);		# Sucursal del Cliente
DECLARE Var_ClasifCre			CHAR(1);		# Clasificacion del Credito
DECLARE Var_CuentaAhoStr		VARCHAR(20);	# Cuenta de Ahorro
DECLARE Par_Consecutivo			BIGINT(20);		# Consecutivo
DECLARE Var_MontoAccesorio		DECIMAL(14,2);	# Monto del Accesorio
DECLARE Var_MontoIva			DECIMAL(14,2);	# Monto de IVA del Accesorio
DECLARE Var_Iva					DECIMAL(14,2);	# Valor del IVA
DECLARE Var_SubClasifID     	INT(11);		# Subclasificacion del Destino de Credito
DECLARE Var_PagaIVA				CHAR(1);		# Indica si el cliente paga o no paga IVA
DECLARE Var_AbrevAccesorio		VARCHAR(20);	# Abreviatura del accesorio
DECLARE Var_ConceptoCartera		INT(11);		# Concepto de Cartera al que corresponde el accesorio
DECLARE Var_CobraIVAAc			CHAR(1);		# Indica si el accesorio cobra IVA
DECLARE varControl 		    	VARCHAR(100);	# Almacena el elemento que es incorrecto

-- Declaracion de Constantes
DECLARE Cadena_Vacia 			CHAR(1);		# Constante Cadena Vacía
DECLARE Entero_Cero  			INT(11); 		# Consntante Entero Cero
DECLARE Decimal_Cero 			DECIMAL(12,2); 	# constante Decimal Cero
DECLARE Fecha_Vacia				DATE; 			# Constante Fecha Vacía
DECLARE Salida_SI				CHAR(1); 		# Constante Salida Si
DECLARE Salida_NO				CHAR(1); 		# Constante Salida No
DECLARE Var_SI					CHAR(1);		# Constante Cadena Si
DECLARE ComAnticipada			CHAR(1); 		# Constante Comisión Anticipada
DECLARE AltaPoliza_NO			CHAR(1); 		# Constante Alta de Póliza No
DECLARE AltaPolCre_SI			CHAR(1); 		# Constante Alta Póliza Crédito Si
DECLARE AltaMovCre_NO			CHAR(1); 		# Constante Alta Movimiento Crédito No
DECLARE AltaMovAho_SI			CHAR(1); 		# Constante Alta Movimientos Ahorro Si
DECLARE Nat_Cargo				CHAR(1); 		# Constante Naturaleza Cargo
DECLARE Nat_Abono				CHAR(1); 		# Constante Naturaleza Abono
DECLARE Con_ContComApe			INT(11); 		# Concepto contable cartera  comision por apertura
DECLARE Con_ContIVACApe			INT(11); 		# Concepto contable cartera IVA comision por apertura
DECLARE Tip_MovAhoAccesorios	CHAR(3); 		# Movimiento Comision por Apertura
DECLARE Tip_MovIVAAccesorios	CHAR(3); 		# Movimiento Iva Comision por Apertura
DECLARE Var_DescAccesorio		VARCHAR(100); 	# Variable Descripción de Accesorio
DECLARE Var_DescIVAAccesorio	VARCHAR(100); 	# Variable Descripción IVA de Accesorio
DECLARE Ref_GenAccesorios 		VARCHAR(100);	# Descripcion de la referencia de generacion de accesorios
DECLARE Ref_GenIVAAccesorios 	VARCHAR(100);	# Descripcion de la referencia de generacion del IVA de accesorios
DECLARE Var_ConceptoIVACartera	INT(11);		# Concepto de Cartera al que corresponde el accesorio

-- Asignacion de constantes
SET Cadena_Vacia			:= '';				# Constante: Cadena Vacia
SET Entero_Cero     		:= 0;				# Constante: Entero Cero
SET Decimal_Cero    		:= 0.00;			# Constante: DECIMAL Cero
SET Fecha_Vacia				:= '1900-01-01';	# Constante Fecha Vacia
SET Salida_SI				:= 'S';				# Valor Salida SI
SET Salida_NO				:= 'N';				# Valor Salida NO
SET Var_SI					:= 'S';				# Constante SI
SET ComAnticipada   		:= 'A';				# Forma de Cobro de Accesorio: ANTICIPADA
SET AltaPoliza_NO   		:= 'N';				# Indica que no da de alta la poliza
SET AltaPolCre_SI			:= 'S';				# Indica si se da de alta el detalle de la poliza
SET AltaMovCre_NO			:= 'N';				# Indica que no se se realizaran movimientos operativos del credito
SET AltaMovAho_SI			:= 'S';				# Indica que se realizaran movimientos a la cuenta de ahorro del cliente
SET Nat_Cargo				:= 'C';				# Constante CARGO
SET Nat_Abono				:= 'A';				# Constamte ABONO
SET Con_ContComApe  		:= 22; 				# corresponde con la tabla CONCEPTOSCARTERA
SET Con_ContIVACApe 		:= 23;				# corresponde con la tabla CONCEPTOSCARTERA
SET Tip_MovAhoAccesorios	:= '108'; 			# Corresponde con la tabla TIPOSMOVSAHO
SET Tip_MovIVAAccesorios  	:= '109'; 			# Corresponde con la tabla TIPOSMOVSAHO

-- Asignacion de variables
SET Aud_FechaActual 		:= NOW();
SET Var_FechaOper 			:=(SELECT FechaSistema FROM PARAMETROSSIS);
SET	Var_CuentaAhoStr		:= CONVERT(Par_CuentaAhoID, CHAR(20));


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	   SET Par_NumErr  = 999;
	   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				  'Disculpe las molestias que esto le ocasiona. Ref: SP-COBROACCESORIOSCREPRO');
	   SET varControl  = 'SQLEXCEPTION';
	END;

	CALL DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,	Aud_EmpresaID,
        Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
        Aud_NumTransaccion);

	# SE OBTIENEN LOS DATOS GENERALES DEL CLIENTE Y DEL CREDITO
	SELECT		Cli.SucursalOrigen,	Des.Clasificacion,	Des.SubClasifID,	Cli.PagaIVA
		INTO	Var_SucCliente,		Var_ClasifCre,		Var_SubClasifID,	Var_PagaIVA
		FROM CREDITOS Cre
			INNER JOIN	CLIENTES Cli
			ON Cre.ClienteID = Cli.ClienteID
			INNER JOIN	DESTINOSCREDITO Des
			ON Cre.DestinoCreID	= Des.DestinoCreID
		WHERE CreditoID			= Par_CreditoID;

	# SE OBTIENEN DATOS DEL ACCESORIO
	SELECT	Ac.NombreCorto,		Con.ConceptoCarID,		Det.CobraIVA
	INTO	Var_AbrevAccesorio, Var_ConceptoCartera,	Var_CobraIVAAc
	FROM DETALLEACCESORIOS Det
		INNER JOIN ACCESORIOSCRED Ac
		ON Det.AccesorioID = Ac.AccesorioID
	INNER JOIN CONCEPTOSCARTERA Con
	ON Ac.NombreCorto = Con.Descripcion
	WHERE Det.CreditoID = Par_CreditoID
	AND Det.AccesorioID = Par_AccesorioID
	LIMIT 1;

	IF(Var_CobraIVAAc = Var_SI) THEN
		SET Var_ConceptoIVACartera := (SELECT ConceptoCarID FROM CONCEPTOSCARTERA WHERE Descripcion = CONCAT('IVA ', Var_AbrevAccesorio) );
	END IF;

	SET Var_SubClasifID 		:= IFNULL(Var_SubClasifID, Entero_Cero);
	SET Var_AbrevAccesorio 		:= IFNULL(Var_AbrevAccesorio, Cadena_Vacia);
	SET Var_ConceptoCartera 	:= IFNULL(Var_ConceptoCartera, Entero_Cero);
    SET Var_ConceptoIVACartera 	:= IFNULL(Var_ConceptoIVACartera, Entero_Cero);

	IF(IFNULL(Par_MontoAccesorio, Entero_Cero) = Decimal_Cero) THEN
		SET Par_NumErr		:= '001';
		SET Par_ErrMen		:= 'Especificar Monto Accesorio.';
		SET varControl		:= 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_AccesorioID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr		:= '002';
		SET Par_ErrMen		:= CONCAT('Especificar Forma de Cobro.', Par_AccesorioID);
		SET varControl		:= 'creditoID';
		LEAVE ManejoErrores;
	END IF;

	SET Var_Iva := (SELECT IVA FROM SUCURSALES WHERE  SucursalID = Var_SucCliente);

	IF(Var_PagaIVA = Var_SI) THEN
		IF(Var_CobraIVAAc = Var_SI) THEN
			-- SE CALCULA EL MONTO Y EL IVA PROPORCIONAL
			SET Var_MontoAccesorio := ROUND(Par_MontoAccesorio/(1+Var_Iva),2);
			SET Var_MontoIva := ROUND((Par_MontoAccesorio/(1+Var_Iva)) * Var_Iva,2);

        ELSE
			# VALORES CUANDO EL CLIENTE NO PAGA IVA
			SET Var_MontoAccesorio := ROUND(Par_MontoAccesorio,2);
			SET Var_MontoIva := Entero_Cero;
        END IF;
    ELSE
			# VALORES CUANDO EL CLIENTE NO PAGA IVA
		SET Var_MontoAccesorio := ROUND(Par_MontoAccesorio,2);
		SET Var_MontoIva := Entero_Cero;
	END IF;


	# SE ASIGNA VALOR PARA LA REFERENCIA DEL MOVIMIENTO
	SET Ref_GenAccesorios 		:= CONCAT('PAGO DE ACCESORIO ', Var_AbrevAccesorio);
	SET Ref_GenIVAAccesorios	:= CONCAT('PAGO DE IVA DE ACCESORIO', Var_AbrevAccesorio);

    SET Var_DescAccesorio		:= CONCAT('ACCESORIOS CREDITO ', Var_AbrevAccesorio);		# Descripcion OTRAS COMISIONES
	SET Var_DescIVAAccesorio	:= CONCAT('IVA ACCESORIOS CREDITO ', Var_AbrevAccesorio);	# Descripcion IVA OTRAS COMISIONES


	-- Movimientos por el cobro de Accesorios solo si la forma de cobro es Anticipada
	IF((Par_ForCobroAccesorio = ComAnticipada)) THEN

		# SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
		CALL CONTACCESORIOSCREDPRO (
			Par_CreditoID,			Entero_Cero,				Par_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
			Var_FechaOper,			Var_FechaApl,				Var_MontoAccesorio,		Par_MonedaID,			Par_ProductoCreditoID,
			Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescAccesorio, 		Ref_GenAccesorios,
			AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_NO,
			Var_ConceptoCartera,	Entero_Cero, 				Nat_Abono,				AltaMovAho_SI,			Tip_MovAhoAccesorios,
			Nat_Cargo, 				Par_OrigenPago,				Salida_NO,				Par_NumErr,				Par_ErrMen,
			Par_Consecutivo,		Aud_EmpresaID,				Cadena_Vacia, 			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,	 		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MontoIva > Entero_Cero) THEN
				-- movimientos de cobro de IVA de Accesorios si el Accesorio cobra IVA
				 # SE EJECUTA LA LLAMADA QUE REALIZA LOS MOVIMIENTOS OPERATIVOS Y CONTABLES
			CALL CONTACCESORIOSCREDPRO (
				Par_CreditoID,			Entero_Cero,				Par_AccesorioID,		Par_CuentaAhoID,		Par_ClienteID,
				Var_FechaOper,			Var_FechaApl,				Var_MontoIva,			Par_MonedaID,			Par_ProductoCreditoID,
				Var_ClasifCre,			Var_SubClasifID, 			Var_SucCliente,			Var_DescIVAAccesorio, 	Ref_GenAccesorios,
				AltaPoliza_NO,			Entero_Cero,				Par_Poliza, 			AltaPolCre_SI,			AltaMovCre_NO,
				Var_ConceptoIVACartera,	Entero_Cero, 				Nat_Abono,				AltaMovAho_SI,			Tip_MovIVAAccesorios,
				Nat_Cargo, 				Par_OrigenPago,				Salida_NO,				Par_NumErr,				Par_ErrMen,
				Par_Consecutivo,		Aud_EmpresaID,				Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

			-- Actualizamos el Monto Pagado del Credito
			UPDATE DETALLEACCESORIOS SET
				SaldoVigente	= SaldoVigente - Var_MontoAccesorio,
                SaldoIVAAccesorio = SaldoIVAAccesorio - Var_MontoIva,
                MontoPagado		= MontoPagado + Var_MontoAccesorio,
				FechaLiquida	= CASE WHEN (SaldoVigente + SaldoAtrasado) = Decimal_Cero THEN Var_FechaOper
									ELSE Fecha_Vacia END,
				Usuario         = Aud_Usuario,
				FechaActual     = Aud_FechaActual,
				DireccionIP     = Aud_DireccionIP,
				ProgramaID      = Aud_ProgramaID,
				Sucursal        = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
				WHERE CreditoID	= Par_CreditoID
                AND TipoFormaCobro = ComAnticipada
                AND AccesorioID = Par_AccesorioID;

			SET Par_NumErr := 0;
			SET Par_ErrMen := 'Accesorio Cobrado Exitosamente.';
			SET varControl := 'creditoID';

	END IF;


END ManejoErrores;  # END del Handler de Errores

	IF(Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				varControl	 	AS control,
				Par_CreditoID 	AS consecutivo;
	END IF;


END TerminaStore$$