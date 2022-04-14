-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACOMAPERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACOMAPERPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELACOMAPERPRO`(
# =====================================================================================
# ----- SP QUE CANCELA LA COMISION POR APERTURA DE UN CREDITO -----------------
# =====================================================================================
	Par_CreditoID			BIGINT(12),		# Numero de Credito
	Par_CuentaAhoID			BIGINT(12),		# Numero de Cuenta de Ahorro
	Par_ClienteID			INT(11),		# Numero de Cliente
	Par_MonedaID			INT(11),		# Tipo Moneda
	Par_ProdCreID			INT(4), 		# Producto de Credito

	Par_MontoComAp			DECIMAL(14,2),	# Monto de la Comision por Apertura
	Par_ForCobroComAper		CHAR(1),		# Forma de Cobro de la Comision por Apertura
	Par_Poliza				INT(11),		# Numero de Poliza

	Par_Salida    			CHAR(1), 		# Salida S:SI  N:NO

    INOUT	Par_NumErr 		INT,			# Numero de Error
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
	DECLARE Var_FechaOper 		DATE;			-- Fecha de Operacion
	DECLARE Var_FechaApl 		DATE;			-- Fecha de Aplicacion
	DECLARE Var_EsHabil			CHAR(1);		-- Indica si es dia habil
	DECLARE Var_SucCliente		INT(11);		-- Sucursal del Cliente
	DECLARE Var_ClasifCre		CHAR(1);		-- Clasificacion del Creditod
	DECLARE Var_CuentaAhoStr	VARCHAR(20);	-- Numero de la Cuenta de Ahorro
	DECLARE Par_Consecutivo		BIGINT;			-- Consecutivo
	DECLARE Var_MontoCom		DECIMAL(14,2);	-- Monto de la Comision por Apertura
	DECLARE Var_MontoIva		DECIMAL(14,2);	-- Monto del IVA De la Comision por Apertura
	DECLARE Var_Iva				DECIMAL(14,2);	-- Valor IVA
	DECLARE Var_SubClasifID     INT(11);		-- Subclasificacion del destino de credito
    DECLARE Var_PagaIVA			CHAR(1);		-- Indica si el cliente paga IVA
	DECLARE Var_Control         VARCHAR(100);	-- Variable de control
    DECLARE Num_Registros		INT(11);		-- Numero de Movimientos Ventanilla


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Entero_Cero  		INT(11);
	DECLARE Decimal_Cero 		DECIMAL(12,2);
	DECLARE ComAnticipada		CHAR(1);
	DECLARE Var_DescComAper		VARCHAR(100);
	DECLARE Var_DcIVAComApe		VARCHAR(100);
	DECLARE AltaPoliza_SI		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Con_ContComApe		INT(11); 		-- Concepto contable cartera  comision por apertura
	DECLARE Con_ContIVACApe		INT(11); 		-- Concepto contable cartera IVA comision por apertura
	DECLARE RevMovAhoComAp		CHAR(3);		-- Movimiento  Reversa Comision por Apertura
	DECLARE RevMovAhoIvaComAp	CHAR(3); 		-- Movimiento Reversa Iva Comision por Apertura
	DECLARE AltaPolCre_SI		CHAR(1);
	DECLARE AltaMovCre_NO		CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE AltaMovAho_SI		CHAR(1);
	DECLARE ConContaComAperRev	INT(11);
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE Con_ContGastos		INT(11);
    DECLARE Var_SI				CHAR(1);
    DECLARE Var_NO				CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';		-- Constante Cadena Vacia
	SET Entero_Cero     	:= 0;		-- Constante Entero Cero
	SET Decimal_Cero    	:= 0;		-- Constante Decimal Cero
	SET ComAnticipada   	:= 'A';		-- Cobra Comision por Apertura ANTICIPADA
	SET AltaPoliza_SI   	:= 'S';		-- Alta Poliza SI
	SET AltaPoliza_NO		:='N';		-- Alta Poliza NO
	SET Salida_SI			:= 'S';		-- Salida SI
	SET Con_ContComApe  	:= 22; 		-- Corresponde con la tabla CONCEPTOSCARTERA
	SET Con_ContIVACApe 	:= 23; 		-- Corresponde con la tabla CONCEPTOSCARTERA
	SET RevMovAhoComAp 	  	:= '301'; 	-- Corresponde con la tabla TIPOSMOVSAHO Reversa Comision por apertura
	SET RevMovAhoIvaComAp  	:= '302'; 	-- Corresponde con la tabla TIPOSMOVSAHO Reversa Comision por apertura
	SET AltaPolCre_SI		:= 'S';		-- Alta Detalle de los movimientos contables del credito: SI
	SET AltaMovCre_NO		:= 'N';		-- Alta Movimientos Operativos del Credito: NO
	SET Nat_Cargo			:= 'C';		-- Naturaleza: Cargo
	SET Nat_Abono			:= 'A';		-- Naturaleza: Abono
	SET AltaMovAho_SI		:= 'S';		-- Alta Movimientos a la Cuenta de Ahorro del Cliente: SI
	SET ConContaComAperRev  := 61;		-- Concepto Contable de Seguro de Vida tabla CONCEPTOSCONTA
	SET Con_ContGastos		:= 58 ; 	-- Cuenta Contable Gastos
    SET Var_SI				:= 'S';		-- Constante SI.
	SET Var_NO				:= 'N';		-- Constante NO

	-- Asignacion de variables
	SET Var_DescComAper	:= 'CANC. COMISION POR APERTURA';
	SET Var_DcIVAComApe	:= 'CANC. IVA COMISION POR APERTURA';
	SET Aud_FechaActual := NOW();
	SET Var_FechaOper 	:=(SELECT FechaSistema FROM PARAMETROSSIS);
	SET	Var_CuentaAhoStr := CONVERT(Par_CuentaAhoID, CHAR(20));

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELACOMAPERPRO');
				SET Var_Control := 'sqlexception';
			END;

	CALL DIASFESTIVOSCAL(
		Var_FechaOper,		Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	SELECT		Cli.SucursalOrigen,		Des.Clasificacion,		Des.SubClasifID,		Cli.PagaIVA
		INTO	Var_SucCliente,			Var_ClasifCre, 			Var_SubClasifID,		Var_PagaIVA
		FROM CREDITOS Cre,
			 CLIENTES Cli,
			 DESTINOSCREDITO Des
		WHERE CreditoID         = Par_CreditoID
		  AND Cre.ClienteID     = Cli.ClienteID
		  AND Cre.DestinoCreID  = Des.DestinoCreID;

	SET Num_Registros := (SELECT COUNT(*)
							FROM CAJASMOVS
                            WHERE Referencia = Par_CreditoID
								AND TipoOperacion = 3
                                AND Instrumento = Par_CuentaAhoID
                                AND MontoEnFirme = Par_MontoComAp);

	SET Var_SubClasifID     := IFNULL(Var_SubClasifID, Entero_Cero);

	IF(IFNULL(Par_MontoComAp, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr		:= '01';
			SET Par_ErrMen		:= 'Especificar Monto Comision Por apertura';
			SET Var_Control		:= 	'creditoID';
		LEAVE ManejoErrores;
	END IF;


	IF(IFNULL(Par_ForCobroComAper, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr		:= '02';
			SET Par_ErrMen		:= 'Especificar Forma de Cobro Comision por Apertura';
			SET Var_Control		:= 	'creditoID';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Num_Registros, Entero_Cero)) != Entero_Cero THEN
			SET Par_NumErr		:= '03';
			SET Par_ErrMen		:= 'No se puede Cancelar el Credito. La comision fue cobrada en Ventanilla';
			SET Var_Control		:= 	'creditoID';
		LEAVE ManejoErrores;
	END IF;

    IF(Var_PagaIVA = Var_SI) THEN
		SET Var_Iva := (SELECT IVA FROM SUCURSALES WHERE  SucursalID = Aud_Sucursal);
		-- Se calcula el monto y el iva proporcional
		SET Var_MontoCom := ROUND(Par_MontoComAp,2);
		SET Var_MontoIva := (ROUND((Par_MontoComAp) * (Var_Iva),2));
	ELSE
		-- Cuando el cliente no paga iva
		SET Var_MontoCom := ROUND(Par_MontoComAp,2);
		SET Var_MontoIva := Entero_Cero;
    END IF;

	-- movimientos de comision por apertura solo si es Anticipada
	SET Par_Poliza := IFNULL(Par_Poliza,Entero_Cero);
	IF(Par_Poliza > Entero_Cero)THEN
		SET AltaPoliza_SI:= Var_NO;
	END IF;
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
			Var_FechaApl,       Var_MontoCom, 	 	Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Var_DescComAper,    Var_CuentaAhoStr,   AltaPoliza_SI,
			ConContaComAperRev, Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_ContGastos,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      RevMovAhoComAp,     Nat_Abono,
			Cadena_Vacia,		Var_NO,				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Aud_EmpresaID,     Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,    Aud_Sucursal,       Aud_NumTransaccion  );

            IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		IF(Var_MontoIva != Entero_Cero) THEN
			-- movimientos de IVA  de comision por apertura
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
				Var_FechaApl,       Var_MontoIva,       Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Var_DcIVAComApe,    Var_CuentaAhoStr,   AltaPoliza_NO,
				Entero_Cero,		Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_ContIVACApe,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      RevMovAhoIvaComAp,  Nat_Abono,
				Cadena_Vacia,		Var_NO,				Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Aud_EmpresaID,     	Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,    	Aud_Sucursal,       Aud_NumTransaccion  );

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		 -- Actualizamos el Monto Pagado del Credito
		UPDATE CREDITOS SET
			ComAperPagado = IFNULL(ComAperPagado, Entero_Cero) - Var_MontoCom,

			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

			WHERE CreditoID	= Par_CreditoID;



	END ManejoErrores;
		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
                    Var_NomControl 	AS control,
					Par_CreditoID AS consecutivo;
		END IF;


END TerminaStore$$