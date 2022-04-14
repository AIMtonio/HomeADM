-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BONIFICACREDITOPRO`;
DELIMITER $$

CREATE PROCEDURE `BONIFICACREDITOPRO`(
-- =================================================================================
-- SP PARA REALIAR EL PROCESO DE BONIFICACION DE FOGA Y FOGAFI
-- =================================================================================
	Par_PolizaID      		BIGINT(20),	# Numero de Poliza
	Par_CreditoID     		BIGINT(20),	# Indica el numero de credito
    Par_ClienteID     		INT(11),	# Numero de Cliente
	Par_CuentaAhoID     	BIGINT(12),	# Cuenta De Ahorro del Cliente
    Par_FechaOperacion    	DATE,       # Fecha de Operacion
    Par_FechaAplicacion		DATE,       # Fecha de Aplicacion
    Par_MonedaID      		INT(11),	# Moneda

	Par_Salida        		CHAR(1),	# Indica la Salida
	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

  -- Parametros de Auditoria
	Par_EmpresaID     		INT(11),
	Aud_Usuario       		INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal      		INT(11),
	Aud_NumTransaccion    	BIGINT(20)
)
TerminaStore:Begin

  	-- Declaracion de variables
	DECLARE Var_Control      	 	VARCHAR(100); 	# Variable de Control
    DECLARE Var_RequiereGarantia  	CHAR(1);    	# Indica si se requiere el cobro de garantía Liquida(FOGA)
	DECLARE Var_GeneraBonificacion  CHAR(1);    	# Indica si el crédito genera Bonificación por Garantía Líquida(FOGA)
    DECLARE Var_PorcBonificacion  	DECIMAL(12,2);  # Indica el porcentaje de bonificacion de Garantia Liquida(FOGA)
    DECLARE Var_MontoGarFOGA    	DECIMAL(14,2);  # Indica el monto de Garantía FOGA Cubierto
	DECLARE Var_RequiereGarFOGAFI 	CHAR(1);   		# Indica si se requiere garantía FOGAFI
    DECLARE Var_GeneraBonifFOGAFI 	CHAR(1);   	 	# Indica si el crédito genera Bonificación por Garantía Financiada(FOGAFI)
    DECLARE Var_PorcBonifFOGAFI   	DECIMAL(12,2);  # Indica el porcentaje de bonificación por Garantía Financiada(FOGAFI)
    DECLARE Var_MontoGarFOGAFI   	DECIMAL(14,2);  # Indica el monto de la Garantía FOGAFI cubierto
    DECLARE Var_NumCuotasAtraso   	INT(11);    	# Numero de cuotas que no son liquidadas en la fecha correspondiente
    DECLARE Var_NumCuotasAtrasoGar  INT(11);    	# Numero de cuotas cuya garantía no fue cubierta en el momento indicado
    DECLARE AplicaBonifi      		CHAR(1);    	# Indica si el crédito amerita bonificación
    DECLARE Var_BonificaFOGA    	CHAR(1);    	# Indica si el crédito amerita bonificación FOGA
    DECLARE Var_BonificaFOGAFI    	CHAR(1);   	 	# Indica si el crédito amerita bonificación FOGAFI
    DECLARE Var_MontoBonifFOGA    	DECIMAL(14,2);	# Monto de Bonificación por Concepto de Garantía FOGA
    DECLARE Var_MontoBonifFOGAFI  	DECIMAL(14,2);  # Monto de Bonificación por Concepto de Garantía FOGAFI
    DECLARE Var_CuentaStr     		VARCHAR(20);  	# Cuenta del Cliente
    DECLARE Var_SucursalID      	INT(11);   	 	# Indica la sucursal del Cliente
    DECLARE Var_CreditoStr      	VARCHAR(50); 	# Variable para convertir el crédito a String

	-- Declaracion de Constantes
	DECLARE Entero_Cero       	INT(11);    	# Constante: Entero Cero
	DECLARE Decimal_Cero      	DECIMAL(14,2);  # Constante: Decimal_Cero
	DECLARE Fecha_Vacia       	DATE;     		# Constante: Fecha Vacia
	DECLARE Cadena_Vacia      	CHAR(1);    	# Constante: Cadena Vacia
    DECLARE Cons_SI        	 	CHAR(1);    	# Constante: SI
    DECLARE Cons_NO         	CHAR(1);    	# Constante: NO
    DECLARE Con_AhoBonifica		INT(11);   	 	# Concepto por Bonificación: CONCEPTOSAHORRO
    DECLARE Con_DescriMov     	VARCHAR(200); 	# Depósito por Bonificación
    DECLARE Nat_Abono         	CHAR(1);    	# Constante: Naturaleza Abono
    DECLARE Con_AhoBono       	INT(11);    	# Constante: Concepto Ahorro por Bonificación
    DECLARE AltaPoliza_NO       CHAR(1);		# Constente: Alta Encabezado Poliza No
    DECLARE AltaMovAho_SI       CHAR(1);    	# Constante: Alta Detalle Poliza de Ahorro Si
    DECLARE Con_AhoCapital      INT(11);    	# Constante: Concepto Ahorro Capital
    DECLARE Estatus_Pagado      CHAR(1);    	# Constante: Estatus Pagado
    DECLARE Salida_SI         	CHAR(1);
    DECLARE Salida_NO         	CHAR(1);

	-- Asignacion de Constantes
	SET Entero_Cero         	:= 0;     			# Constante: Entero Cero
	SET Decimal_Cero        	:= 0.00;    		# Constante: Decimal_Cero
	SET Fecha_Vacia        	:= '1900-01-01';	# Constante: Fecha Vacia
	SET Cadena_Vacia        	:= '';      		# Constante: Cadena Vacia
    SET Cons_SI           	:= 'S';     		# Constante: SI
    SET Cons_NO           	:= 'N';     		# Constante: NO
    SET Con_AhoBonifica		:= 33;     			# Concepto por Bonificación: CONCEPTOSAHORRO
	SET Con_DescriMov			:= 'DEPOSITO POR BONIFICACION';
    SET Nat_Abono           := 'A';     		# Constante: Naturaleza Abono
    SET Con_AhoBono         := 31;      		# Constante: Concepto Ahorro Bonificación
    SET AltaPoliza_NO       := 'N';     		# Constante: Alta Encabezado Poliza No
    SET AltaMovAho_SI       := 'S';     		# Constante: Alta Detalle Poliza Ahorro Si
    SET Con_AhoCapital      := 1;     			# constante: Concepto Ahorro Capital
    SET Estatus_Pagado      := 'P';     		# Constante: Estatus Pagado
    SET Salida_SI           := 'S';
    SET Salida_NO           := 'N';

   ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
       SET Par_NumErr = 999;
       SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-BONIFICACREDITOPRO');
       SET Var_Control = 'SQLEXCEPTION';
    END;


    SELECT  RequiereGarantia,	Bonificacion,     		PorcBonificacion,     MontoGarLiq,  	RequiereGarFOGAFI,
			BonificacionFOGAFI,	PorcBonificacionFOGAFI, MontoGarFOGAFI
    INTO  Var_RequiereGarantia, Var_GeneraBonificacion, Var_PorcBonificacion, Var_MontoGarFOGA, Var_RequiereGarFOGAFI,
        Var_GeneraBonifFOGAFI,  Var_PorcBonifFOGAFI,  	Var_MontoGarFOGAFI
    FROM DETALLEGARLIQUIDA
    WHERE CreditoID = Par_CreditoID;

    SET Var_RequiereGarantia  	:= IFNULL(Var_RequiereGarantia, Cadena_Vacia);
    SET Var_GeneraBonificacion	:= IFNULL(Var_GeneraBonificacion, Cadena_Vacia);
    SET Var_PorcBonificacion  	:= IFNULL(Var_PorcBonificacion, Decimal_Cero);
    SET Var_MontoGarFOGA    	:= IFNULL(Var_MontoGarFOGA, Decimal_Cero);
    SET Var_RequiereGarFOGAFI   := IFNULL(Var_RequiereGarFOGAFI, Cadena_Vacia);
    SET Var_GeneraBonifFOGAFI   := IFNULL(Var_GeneraBonifFOGAFI, Cadena_Vacia);
    SET Var_PorcBonifFOGAFI   	:= IFNULL(Var_PorcBonifFOGAFI, Decimal_Cero);
    SET Var_MontoGarFOGAFI    	:= IFNULL(Var_MontoGarFOGAFI, Decimal_Cero);

    -- Si el crédito cobra Garantia Líquida y Genera Bonificación, se realizan validaciones para saber si amerita o no bonificación.
	IF((Var_RequiereGarantia = Cons_SI AND Var_GeneraBonificacion = Cons_SI) AND (Var_RequiereGarFOGAFI = Cons_SI AND Var_GeneraBonifFOGAFI = Cons_SI) )  THEN

		-- Se obtiene el numero de cuotas que no fueron pagadas en tiempo y forma
		SET Var_NumCuotasAtraso := (SELECT COUNT(*) AmortizacionID
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoID
									AND FechaLiquida > FechaExigible
									AND Estatus=Estatus_Pagado);

		SET Var_NumCuotasAtraso := IFNULL(Var_NumCuotasAtraso, Entero_Cero);

		-- Se obtiene el numero de cuotas que no fueron pagadas en tiempo y forma
		SET Var_NumCuotasAtrasoGar := (SELECT COUNT(*) AmortizacionID
										FROM DETALLEGARFOGAFI
										WHERE CreditoID = Par_CreditoID
										AND ((FechaLiquida > FechaPago)OR (FechaLiquida = Fecha_Vacia))
										  );

		SET Var_NumCuotasAtrasoGar := IFNULL(Var_NumCuotasAtrasoGar, Entero_Cero);

		-- Si el numero de cuotas de atraso del pago de las cuotas del crédito, se valida si cumplió con el pago puntual de la garantía financiada
		IF(Var_NumCuotasAtraso = Entero_Cero) THEN
			# Se valida que el numero de cuotas de atraso por Garantia Financiada sea cero.
			IF(Var_NumCuotasAtrasoGar = Entero_Cero) THEN
				SET AplicaBonifi    	:= Cons_SI; -- Aplica Bonificacion
				SET Var_BonificaFOGA  	:= Cons_SI; -- Aplica Bonificacion FOGA
				SET Var_BonificaFOGAFI  := Cons_SI; -- Aplica Bonificacion FOGAFI
			ELSE
				SET AplicaBonifi := Cons_NO;  -- No Aplica Bonificacion
			END IF;

		ELSE -- Si el numero es mayor a cero, indica que hay cuotas que  pagaron en una fecha mayor y por este motivo no aplica bonificación
			SET AplicaBonifi := Cons_NO;
		END IF;

    ELSE
      -- Si no cumple con la validación anterior, puede tener Garantía FOGA o Garantia FOGAFI.
      -- Se obtiene el numero de cuotas que no fueron pagadas en tiempo y forma
      SET Var_NumCuotasAtraso := (SELECT COUNT(*) AmortizacionID
									FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoID
									AND FechaLiquida > FechaExigible );

      SET Var_NumCuotasAtraso := IFNULL(Var_NumCuotasAtraso, Entero_Cero);

	-- Se valida si requiere Garantía FOGA
	IF(Var_RequiereGarantia = Cons_SI AND Var_GeneraBonificacion = Cons_SI) THEN

		IF(Var_NumCuotasAtraso = Entero_Cero) THEN
			SET AplicaBonifi    := Cons_SI;   -- Aplica Bonificación
			SET Var_BonificaFOGA  := Cons_SI;   -- Aplica Bonificación FOGA
        ELSE
          SET AplicaBonifi := Cons_NO;      -- No Aplica Bonificación
        END IF;

	END IF;

	-- Se valida si requiere Garantía FOGAFI
	IF(Var_RequiereGarFOGAFI = Cons_SI AND Var_GeneraBonifFOGAFI = Cons_SI)THEN
		-- Se obtiene el numero de cuotas que no fueron pagadas en tiempo y forma
		SET Var_NumCuotasAtrasoGar := (SELECT COUNT(*) AmortizacionID
										FROM DETALLEGARFOGAFI
										WHERE CreditoID = Par_CreditoID
										AND ((FechaLiquida > FechaPago)OR (FechaLiquida = Fecha_Vacia))
										  );

        SET Var_NumCuotasAtrasoGar := IFNULL(Var_NumCuotasAtrasoGar, Entero_Cero);

		IF(Var_NumCuotasAtraso = Entero_Cero) THEN

			IF(Var_NumCuotasAtrasoGar = Entero_Cero) THEN
				SET AplicaBonifi    := Cons_SI;   -- Aplica Bonificación
				SET Var_BonificaFOGAFI  := Cons_SI;   -- Aplica Bonifiación FOGAFI
			ELSE
				SET AplicaBonifi := Cons_NO;      -- No Aplica Bonificación
			END IF;

        ELSE
			-- Si el numero es mayor a cero, indica que hay cuotas que  pagaron en una fecha mayor y por este motivo ,
			SET AplicaBonifi := Cons_NO;  -- No Aplica Bonificación
        END IF;

      END IF;

    END IF;


    IF(AplicaBonifi = Cons_SI) THEN

		SELECT SucursalID,	CuentaID	 INTO Var_SucursalID,	Par_CuentaAhoID
		  FROM CREDITOS
		  WHERE ClienteID = Par_ClienteID
		  AND CreditoID = Par_CreditoID;


		SET Var_CuentaStr   := CONCAT("Cta.",CONVERT(Par_CuentaAhoID, CHAR));
		SET Var_CreditoStr  := CONCAT("Cred.",CONVERT(Par_CreditoID,CHAR));



		IF(Var_BonificaFOGA = Cons_SI) THEN
			-- Se obtiene el monto de bonificación que le corresponde al crédito.
			SET Var_MontoBonifFOGA:= ( Var_MontoGarFOGA  * Var_PorcBonificacion / 100);

			-- Se realiza un cargo a la cuenta de Resultado
			CALL POLIZASAHORROPRO(
				Par_PolizaID,       Par_EmpresaID,    	Par_FechaOperacion,		Par_ClienteID,	    Con_AhoBonifica,
				Par_CuentaAhoID,    Par_MonedaID,   	Var_MontoBonifFOGA, 	Entero_Cero,		Con_DescriMov,
				Var_CuentaStr,		Salida_NO,      	Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			  	LEAVE ManejoErrores;
			END IF;

			-- Se realiza un abono la cuenta eje(Pasivo)
			CALL CONTAAHOPRO(
				Par_CuentaAhoID,	Par_ClienteID,		Aud_NumTransaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
				Nat_Abono,			Var_MontoBonifFOGA,	Con_DescriMov,		Var_CreditoStr,		Con_AhoBono,
				Par_MonedaID,		Var_SucursalID,		AltaPoliza_NO,		Entero_Cero,		Par_PolizaID,
				AltaMovAho_SI, 		Con_AhoCapital,		Nat_Abono,			Entero_Cero,		Salida_NO,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			  	LEAVE ManejoErrores;
			END IF;

		END IF;


		IF(Var_BonificaFOGAFI = Cons_SI)THEN
			-- Se obtiene el monto de bonificación que le corresponde al crédito.
			SET Var_MontoBonifFOGAFI := ( Var_MontoGarFOGAFI * Var_PorcBonifFOGAFI / 100);

			-- Se realiza un cargo a la cuenta de Resultado
			 CALL POLIZASAHORROPRO(
				Par_PolizaID,       Par_EmpresaID,    	Par_FechaOperacion,		Par_ClienteID,	    Con_AhoBonifica,
				Par_CuentaAhoID,    Par_MonedaID,   	Var_MontoBonifFOGAFI, 	Entero_Cero,		Con_DescriMov,
				Var_CuentaStr,		Salida_NO,      	Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			  	LEAVE ManejoErrores;
			END IF;

			-- Se realiza un abono la cuenta eje(Pasivo)
			CALL CONTAAHOPRO(
				Par_CuentaAhoID,	Par_ClienteID,			Aud_NumTransaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
				Nat_Abono,			Var_MontoBonifFOGAFI,	Con_DescriMov,		Var_CreditoStr,		Con_AhoBono,
				Par_MonedaID,		Var_SucursalID,			AltaPoliza_NO,		Entero_Cero,		Par_PolizaID,
				AltaMovAho_SI, 		Con_AhoCapital,			Nat_Abono,			Entero_Cero,		Salida_NO,
				Par_NumErr,			Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
			  	LEAVE ManejoErrores;
			END IF;

		END IF;

    END IF;

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := 'Proceso aplicado exitosamente.';

  END ManejoErrores;

  IF (Par_Salida = Salida_SI) THEN
    SELECT 	Par_NumErr AS NumErr,
		    Par_ErrMen AS ErrMen,
		    'creditoID' AS control,
		    Par_CreditoID AS consecutivo;
  END IF;

END TerminaStore$$