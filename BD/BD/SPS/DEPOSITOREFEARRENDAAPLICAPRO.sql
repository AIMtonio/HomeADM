-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEARRENDAAPLICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEARRENDAAPLICAPRO`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFEARRENDAAPLICAPRO`(
	-- SP QUE REGISTRA EL DEPOSITO REFERENCIADO DEL ARRENDAMIENTO*/
	Par_DepRefereID		BIGINT,			-- FOLIO DE CARGA A PROCESAR
	Par_FolioCargaID    BIGINT,       	-- FOLIO DE CARGA A PROCESAR DETALLE
	Par_Poliza        	BIGINT,       	-- POLIZA CONTABLE
	Par_Salida        	CHAR(1),      	-- INDICA SI EXISTE O NO UNA SALIDA
	INOUT Var_Poliza    BIGINT,       	-- NUMERO DE POLIZA

	INOUT Par_NumErr    INT(11),      	-- NUMERO DE ERROR
	INOUT Par_ErrMen    VARCHAR(400), 	-- MENSAJE DE ERROR

	Aud_EmpresaID     	INT(11),      	-- PARAMETRO DE AUDITORIA
	Aud_Usuario       	INT(11),      	-- PARAMETRO DE AUDITORIA
	Aud_FechaActual     DATETIME,     	-- PARAMETRO DE AUDITORIA
	Aud_DireccionIP     VARCHAR(15),  	-- PARAMETRO DE AUDITORIA
	Aud_ProgramaID      VARCHAR(50),  	-- PARAMETRO DE AUDITORIA
	Aud_Sucursal      	INT(11),      	-- PARAMETRO DE AUDITORIA
	Aud_NumTransaccion  BIGINT(20)    	-- PARAMETRO DE AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero     		INT(11);			-- ENTERO CERO
	DECLARE Cadena_Vacia    		CHAR(1);			-- CADENA VACIA
	DECLARE Decimal_Cero    		DECIMAL(14,2);		-- DECIMAL CERO
	DECLARE Nat_Abono     			CHAR(1);			-- ABONO
	DECLARE Var_CanalArrenda  		INT(11);    		-- INDICA QUE SE DEPOSITA REFERENCIANDO UN ARRENDAMIENTO
	DECLARE Var_CanalCliente  		INT(11);    		-- INDICA QUE SE DEPOSITA REFERENCIANDO UN CLIENTE
	DECLARE TipoMovDepRef   		CHAR(4); 			-- corresponde con la tabla TIPOSMOVTESO
	DECLARE Var_FechaSistema 		DATE;				-- FECHA DE SISTEMA
	DECLARE Con_AhoCapital    		INT(11);			-- CAPITAL
	DECLARE Var_NO        			CHAR(1);			-- NO
	DECLARE Var_SI        			CHAR(1);			-- SI
	DECLARE Var_Automatico   		CHAR(1);			-- AUTOMATICO
	DECLARE Var_Aplicado    		CHAR(1);			-- APLICADO
	DECLARE Var_Deposito 			CHAR(1);			-- DEPOSITO
	DECLARE Est_Vigente				CHAR(1);			-- Estatus Vigente
	DECLARE Est_Autorizado			CHAR(1);			-- Estatus autorizado
	DECLARE Var_NumAct				TINYINT UNSIGNED;	-- Numero de actualizacion en ARRENDAMIENTOSACT



	-- Declaracion de Variables
	DECLARE Var_Cargos        		DECIMAL(14,2);		-- CARGOS
	DECLARE Var_Abonos        		DECIMAL(14,2);		-- ABONOS
	DECLARE Var_FolioOperacion  	INT(11);			-- FOLIO DE OPERACION
	DECLARE Par_TipoPago    		CHAR(1);			-- TIPO DE PAGO
	DECLARE Var_MonedaID    		INT(11);			-- ID MONEDA
	DECLARE Var_ArrendaID   		BIGINT(12);			-- ID DE ARRENDAMIENTO
	DECLARE Var_ClienteID   		BIGINT;				-- CLIENTE
	DECLARE Var_CuentaTeso    		BIGINT(12);			-- CUENTA TESO
	DECLARE Var_CuentaBancaria  	VARCHAR(20);		-- CUENTA BANCARIA
	DECLARE Fecha_Valida    		DATE;				-- FECHA VALIDA
	DECLARE DiaHabil      			CHAR(1);			-- DIA HABIL
	DECLARE Var_Descripcion   		VARCHAR(50);		-- DESCRIPCION
	DECLARE Var_EmitePoliza   		CHAR(1);			-- EMITE POLIZA
	DECLARE Var_ConceptoCon   		INT(11);			-- CONCEPTO
	DECLARE Var_NatConta    		CHAR(1);			-- NAT CONTABLE
	DECLARE Var_Control     		VARCHAR(30);		-- CONTROL
	DECLARE Var_Instrumento   		VARCHAR(20);		-- INSTRUMENTO
	DECLARE Var_ReferenciaMov 		VARCHAR(40);		-- REFERENCIA
	DECLARE Par_InstitucionID 		INT(11);        	-- ID DE LA INSTITUCION BANCARIA
	DECLARE Par_NumCtaInstit  		VARCHAR(20);		-- NUM CTA
	DECLARE Par_MontoMov    		DECIMAL(14,2);		-- MONTO MOV
	DECLARE Var_MontoPago   		DECIMAL(14,2);		-- MONTO DE PAGO
	DECLARE Par_Consecutivo   		BIGINT;				-- CONSECUTIVO
	DECLARE Par_ModoPago    		CHAR; 				-- MODO DE PAGO
	DECLARE VarEstatusCtl   		CHAR;				-- ESTATUS CLIENTE
	DECLARE Var_TotalExigible  		DECIMAL(14,2);		-- TotalExigible
	DECLARE Var_IVASucurs			DECIMAL(8, 4);		-- IVA aplicado al arrendamiento
	DECLARE Est_Pagado				CHAR(1);			-- Estatus Pagado
	DECLARE Var_EstArrenda			CHAR(1);			-- Estatus del arrendamiento



	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;						-- ENTERO CERO
	SET Decimal_Cero    	:= 0;						-- DECIMAL CERO
	SET Var_Aplicado    	:= 'A';						-- ESTATUS APLICADO
	SET Cadena_Vacia    	:= '';						-- CADENA VACIA
	SET Nat_Abono     		:= 'A';						-- ABONO
	SET Var_CanalArrenda  	:= 1;						-- CANAL ARRENDAMIENTO
	SET Var_CanalCliente  	:= 2;						-- CANAL CLIENTE
	SET TipoMovDepRef   	:= '1';						-- corresponde con la tabla TIPOSMOVTESO (deposito Referenciado)
	SET Con_AhoCapital    	:= 1;   					-- Concepto capital
	SET Var_NO        		:= 'N';						-- Valor no
	SET Var_SI        		:= 'S';						-- VALOR SI
	SET Var_Automatico    	:= 'A';						-- AUTOMATICO
	SET Var_Deposito 		:= 'D';						-- TIPO DEPOSITO
	SET	Est_Pagado			:= 'P';						-- Estatus Pagado
	SET Est_Vigente			:= 'V';						-- Estatus vigente
	SET Est_Autorizado		:= 'A';						-- Estatus autorizado
	SET Var_NumAct			:= 4;						-- Numero de actualizacion en ARRENDAMIENTOSACT


	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();		-- PARAMETRO DE AUDITORIA
	SET Var_ArrendaID   	:= 0;						-- ID DE ARRENDAMIENTO
	SET Var_ClienteID   	:= 0;						-- ID DE CLIENTE
	SET Var_Descripcion   	:= 'APLICACION DEPOSITO REFERENCIADO ARRENDAMIENTO';-- DESCRIPCION
	SET Var_ConceptoCon   	:= 45;						-- CONCEPTO CONTABLE
	SET Var_NatConta    	:= 'A';						-- NATURALEZA CONTABLE
	SET Par_Consecutivo   	:= Entero_Cero;				-- CONSECUTIVO
	SET Var_MonedaID    	:= 1;						-- ID DE MONEDA
	SET Par_NumErr      	:= 999;						-- NUMERO DE ERROR
	SET Par_ErrMen       	:= CONCAT( 'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
	                  					'esto le ocasiona. Ref: SP-DEPOSITOREFEARRENDAAPLICAPRO');	-- NENSAJE DE ERROR

	ManejoErrores: BEGIN
	  	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		    SET Par_NumErr := 999;
		    SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
		                'esto le ocasiona. Ref: SP-DEPOSITOREFEARRENDAAPLICAPRO');
		    SET Var_Control:= 'sqlException' ;
		END;

	 	SET Var_FechaSistema  := (SELECT FechaSistema FROM PARAMETROSSIS  );

	  	SELECT		ReferenciaMov,		InstitucionID,		NumCtaInstit,		MontoMov
		    INTO 	Var_ReferenciaMov,  Par_InstitucionID,  Par_NumCtaInstit,	Par_MontoMov
		    	FROM 	DEPOSITOREFEARRENDA
			      	WHERE   DepRefereID   = Par_DepRefereID
			       	AND  	FolioCargaID  = Par_FolioCargaID;

		SELECT    CuentaAhoID
		    INTO  	Var_CuentaTeso
		    FROM 	CUENTASAHOTESO
		    	WHERE   InstitucionID   = Par_InstitucionID
		      	AND   	NumCtaInstit 	= Par_NumCtaInstit
		      	LIMIT 1;

		SELECT		ArrendaID,		ClienteID,		Estatus
			INTO 	Var_ArrendaID,	Var_ClienteID,	Var_EstArrenda
			FROM	ARRENDAMIENTOS
			WHERE	ArrendaID = Var_ReferenciaMov;

	    SET Var_ArrendaID := IFNULL(Var_ArrendaID,Entero_Cero);
	    IF(Var_ArrendaID = Entero_Cero)THEN
			SET	Par_NumErr		:= 1;
			SET	Par_ErrMen		:= CONCAT('El arrendamiento: ', Var_ArrendaID ,' no existe');
			SET	Par_Consecutivo	:= 0;
			SET	Var_Control		:= 'montoPagarArrendamiento';
			LEAVE ManejoErrores;
		END IF;

		--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
		SET Var_Instrumento := Var_ArrendaID;

	  	SELECT    Estatus
	    	INTO  VarEstatusCtl
	    	FROM TMPDEPOARRENDA
			    WHERE 	DepRefereID   	= Par_DepRefereID
			    AND   	FolioCargaID  	= Par_FolioCargaID
			    AND   	NumTransaccion 	= Aud_NumTransaccion;

		IF(IFNULL(VarEstatusCtl,Cadena_Vacia) = Var_NO )THEN
			SET Par_NumErr      := 998;
			SET Par_ErrMen      := CONCAT("El pago del arrendamiento ", Var_ReferenciaMov, ' no puede aplicarse debido a que el pago inicial no esta completo');
			SET Par_Consecutivo := Var_FolioOperacion;
			SET Var_Control   	:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	IVA
			INTO	Var_IVASucurs
			FROM	SUCURSALES
			WHERE	SucursalID	= Aud_Sucursal;

		IF (Var_EstArrenda = Est_Vigente) THEN
			-- Validacion del monto a pagar sea menor o igual al exigible del dia
			SELECT	ROUND(IFNULL(SUM(SaldoCapVigent +  SaldoCapAtrasad +  SaldoCapVencido +  SaldoInteresVigente + SaldoInteresAtras +  SaldoInteresVen +  SaldComFaltPago+  SaldoOtrasComis +
										SaldoSeguro +  SaldoMoratorios +  SaldoSeguroVida+
										(SaldComFaltPago*Var_IVASucurs) +
										(SaldoOtrasComis*Var_IVASucurs) +
										(SaldoSeguro*Var_IVASucurs) +
										(SaldoSeguroVida*Var_IVASucurs) +
										((SaldoInteresVigente + SaldoInteresAtras + SaldoInteresVen)*Var_IVASucurs)+
										((SaldoCapVigent+ SaldoCapAtrasad+ SaldoCapVencido)*Var_IVASucurs)+
										(SaldoMoratorios* Var_IVASucurs)
										),Decimal_Cero),2)
				INTO	Var_TotalExigible
				FROM	ARRENDAAMORTI amo
				WHERE	ArrendaID		= Var_ArrendaID
				AND	FechaExigible	<= Var_FechaSistema
				AND	Estatus       != Est_Pagado;

			IF(Par_MontoMov	> Var_TotalExigible) THEN
				SET	Par_NumErr		:= 3;
				SET	Par_ErrMen		:= 'El monto a pagar no puede ser mayor al pago exigible del dia.';
				SET	Par_Consecutivo	:= 0;
				SET	Var_Control		:= 'montoPagarArrendamiento';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
		SET Var_Cargos    := Decimal_Cero;  -- VALOR DE CARGOS
		SET Var_Abonos    := Par_MontoMov;  -- VALOR DE ABONOS

		SET Var_Poliza    := IFNULL(Par_Poliza,Entero_Cero);
		IF(IFNULL(Par_Poliza,Entero_Cero) = Entero_Cero)THEN
			SET Var_EmitePoliza := Var_SI;      -- VALOR NO EMITE POLIZA
		ELSE
			SET Var_EmitePoliza := Var_NO;      -- VALOR NO EMITE POLIZA
		END IF;

		-- SE INSERTAN LOS MOVIMIENTOS DE TESORERIA
		CALL TESORERIAMOVALT(
			Var_CuentaTeso,			Var_FechaSistema, 		Par_MontoMov,   		Var_Descripcion,  		Var_ReferenciaMov,
			Cadena_Vacia,			Nat_Abono,      		Var_Aplicado,   		TipoMovDepRef,    		Entero_Cero,
			Var_NO,       			Par_NumErr,				Par_ErrMen,     		Par_Consecutivo,  		Aud_EmpresaID,
			Aud_Usuario,   			Aud_FechaActual,		Aud_DireccionIP,  		Aud_ProgramaID,   		Aud_Sucursal,
			Aud_NumTransaccion);
		-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- ACTUALIZA SALDOS DE TESORERIA
		CALL SALDOSCTATESOREACT(
			Par_NumCtaInstit, 		Par_InstitucionID, 		Par_MontoMov,   		Nat_Abono,      		Var_NO,
			Par_NumErr,     		Par_ErrMen,     		Par_Consecutivo,  		Aud_EmpresaID,    		Aud_Usuario,
			Aud_FechaActual,  		Aud_DireccionIP,  		Aud_ProgramaID,   		Aud_Sucursal,     		Aud_NumTransaccion);
	   	-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

	 	SET Par_ModoPago  := Var_Deposito;
		--  SP DE PROCESO QUE REALIZA EL PAGO DE ARRENDAMIENTO
		CALL PAGOREFEREARRENDAPRO(
			Var_ArrendaID,	Par_MontoMov,		Var_MonedaID,		Var_NO,				Var_MontoPago,
			Var_Poliza,		Par_Consecutivo,	Par_ModoPago,		Var_NO,				Par_NumErr,
			Par_ErrMen,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
		);

		-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		UPDATE DEPOSITOREFEARRENDA SET
			Estatus = Var_Aplicado
		WHERE     DepRefereID   = Par_DepRefereID
		AND   FolioCargaID  	= Par_FolioCargaID;

		IF (Var_EstArrenda = Est_Autorizado) THEN
			CALL ARRENDAMIENTOSACT (Var_ArrendaID,	Var_NumAct,		Var_NO,				Par_NumErr,			Par_ErrMen,
									Aud_EmpresaID,	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
									Aud_Sucursal,	Aud_NumTransaccion);
		END IF;

		IF (Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- SI TERMINA CON EXITO SE SETEAN LOS VALORES
		SET Par_NumErr      := 0;
		SET Par_ErrMen      := CONCAT("Deposito referenciado Aplicado Exitosamente");
		SET Par_Consecutivo := Var_FolioOperacion;
		SET Var_Control   := 'institucionID';

	END ManejoErrores;

	-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
	IF (Par_Salida = Var_SI) THEN
	    SELECT  Par_NumErr,
				Par_ErrMen,
				Var_Control,
				Par_Consecutivo;
	END IF;

END TerminaStore$$