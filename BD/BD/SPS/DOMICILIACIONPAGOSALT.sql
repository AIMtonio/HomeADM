-- SP DOMICILIACIONPAGOSALT

DELIMITER ;

DROP PROCEDURE IF EXISTS DOMICILIACIONPAGOSALT;

DELIMITER $$

CREATE PROCEDURE `DOMICILIACIONPAGOSALT`(
# ==========================================================================
# ------------ STORE PARA EL REGISTRO DE DOMICILIACION DE PAGOS ------------
# ==========================================================================
	Par_FolioID				BIGINT(20),			-- Numero de Folio
	Par_ClienteID			INT(11),			-- ID del Cliente
    Par_InstitucionID		INT(11),			-- ID Institucion
	Par_CuentaClabe			VARCHAR(18),		-- Cuenta Clabe
    Par_CreditoID			BIGINT(12),			-- Numero de Credito

    Par_MontoExigible		DECIMAL(14,2),		-- Monto Exigible

    Par_Salida           	CHAR(1),			-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     	INT(11),			-- Numero de Error
	INOUT Par_ErrMen     	VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control     		VARCHAR(100);	-- Almacena el control de errores
    DECLARE	Var_DomiciliacionID		BIGINT(20);		-- ID de Domiciliacion
    DECLARE Var_NumCuotasCobrar		INT(11);		-- Numnero de Cuotas a Cobrar
    DECLARE Var_MontoExigible		DECIMAL(14,2);	-- Monto Exigible
	DECLARE Var_FechaSistema		DATE;			-- Se obtiene la Fecha del Sistema

    DECLARE Var_IVASucurs       	DECIMAL(12,2);	-- IVA de la Sucursal
	DECLARE Var_CliPagIVA       	CHAR(1);		-- Almacena si el Cliente paga IVA
	DECLARE Var_IVAIntOrd   		CHAR(1);		-- Almacena si cobra IVA de Interes
	DECLARE Var_IVAIntMor   		CHAR(1);		-- Almacena si cobra IVA de Interes Moratorio
	DECLARE Var_ValIVAIntOr 		DECIMAL(12,2);	-- Almacena el valor del IVA de Interes Ordinario

    DECLARE Var_ValIVAIntMo 		DECIMAL(12,2);	-- ALmacena el valor del IVA de Insteres Moratorio
	DECLARE Var_ValIVAGen   		DECIMAL(12,2);	-- Almacena el valor del IVA de las Comisiones
	DECLARE Var_MontoCapInteres		DECIMAL(14,2);	-- Monto de Capital e Intereses Ordinarios del Credito
	DECLARE Var_MontoMora			DECIMAL(14,2);	-- Monto de Moratorios del Credito
	DECLARE Var_MontoComision		DECIMAL(14,2);	-- Monto de las Comisiones del Credito

    DECLARE Var_InstitucionNominaID INT(11);		-- Almacena el valor de la empresa de Institucion de Nomina en la Solicitud de Credito
	DECLARE Var_NumCreditos			INT(11);		-- Numero de Creditos
    DECLARE Var_NumAmortizacion		INT(11);		-- Numero de Amortizaciones
    DECLARE Var_AmortizacionID		INT(11);		-- ID de la Amortizacion
    DECLARE Var_MaxAmortizacionID	INT(11);		-- Numero Maximo de la Amortizacion

    DECLARE Var_MinAmortizacionID	INT(11);		-- Numero Minimo de la Amortizacion
	DECLARE Var_MontoCuota			DECIMAL(14,2);	-- Monto de la Cuota
    DECLARE Var_TipoPagoCapital		CHAR(1);		-- Tipo de Pago de Capital
    DECLARE Var_NumAmortizaCredito	INT(11);		-- Numero de Amortizaciones del Credito
	DECLARE Var_Referencia			VARCHAR(50);	-- Valor de la Referencia

    DECLARE Var_NumEmpleado			VARCHAR(30);	-- Numero de empleado de la Empresa de Nomina
	DECLARE Var_MontoExigibleCuota	DECIMAL(14,2);	-- Monto Exigible de la Cuota de Creditos que no son de Nomina

	-- Declaracion de Constantes
	DECLARE Entero_Cero    	INT(11);
    DECLARE Decimal_Cero	DECIMAL(14,2);
	DECLARE Cadena_Vacia   	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	SalidaSI        CHAR(1);

    DECLARE	SalidaNO        CHAR(1);
    DECLARE ConstanteSI		CHAR(1);
    DECLARE Est_Pagado		CHAR(1);
    DECLARE SiPagaIVA       CHAR(1);
    DECLARE Entero_Uno		INT(11);

    DECLARE TipPagCapCre	CHAR(1);
    DECLARE UnPeso			DECIMAL(12,2);
	DECLARE Est_Activo		CHAR(1);
	DECLARE TipoCapitalInt	INT(11);
    DECLARE TipoMoratorio 	INT(11);

    DECLARE TipoComision 	INT(11);

	-- Asignacion de Constantes
	SET Entero_Cero			:= 0; 				-- Entero Cero
    SET Decimal_Cero        := 0.00;			-- Decimal Cero
	SET Cadena_Vacia		:= '';    			-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	SalidaSI        	:= 'S';				-- Salida Si

    SET	SalidaNO        	:= 'N'; 			-- Salida No
    SET ConstanteSI			:= 'S';				-- Constante: SI
    SET Est_Pagado			:= 'P';				-- Estatus: Pagado
    SET SiPagaIVA       	:= 'S';				-- Paga IVA: SI
	SET Entero_Uno			:= 1;				-- Entero Uno

    SET TipPagCapCre		:= 'C';				-- Tipo de Pago de Capital: Creciente
    SET UnPeso				:= 1.00;			-- Un Peso
	SET Est_Activo			:= 'A';				-- Estatus: Activo
	SET TipoCapitalInt 		:= 1;				-- Tipo: Capital e Intereses
    SET TipoMoratorio		:= 2;				-- Tipo: Intereses Moratorios

    SET TipoComision		:= 3;				-- Tipo: Comisiones

    ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DOMICILIACIONPAGOSALT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Se obtiene la Referencia del Cliente registrada en DETAFILIABAJACTADOM
        SET Var_Referencia :=(SELECT MAX(Referencia) FROM DETAFILIABAJACTADOM WHERE ClienteID = Par_ClienteID AND EstatusDomicilia = 'A');
        SET Var_Referencia := IFNULL(Var_Referencia,Cadena_Vacia);

		-- Si no existe se genera la referencia a traves del Numero de Cliente y RFC Oficial
        IF(Var_Referencia = Cadena_Vacia)THEN
			SET Var_Referencia := (SELECT CONCAT(ClienteID,RFCOficial) AS Referencia FROM CLIENTES WHERE ClienteID = Par_ClienteID);
			SET Var_Referencia := IFNULL(Var_Referencia,Cadena_Vacia);
        END IF;

		-- Se obtiene el Numero de Institucion de Nomina del Credito del Cliente
		SELECT Cre.InstitNominaID INTO Var_InstitucionNominaID
		FROM CLIENTES Cli,
			 CREDITOS Cre
		WHERE Cre.ClienteID = Cli.ClienteID
		  AND Cre.ClienteID = Par_ClienteID
		  AND Cre.CreditoID = Par_CreditoID;

		SET Var_InstitucionNominaID :=IFNULL(Var_InstitucionNominaID,Entero_Cero);

        -- Se obtien el Numero de Empleado de la Empresa de Nomina
        SELECT Nom.NoEmpleado
        INTO Var_NumEmpleado
		FROM INSTITNOMINA Ins,
			 CONVENIOSNOMINA Con,
			 NOMINAEMPLEADOS Nom,
			 CLIENTES Cli
		WHERE Ins.InstitNominaID = Con.InstitNominaID
		AND Con.ConvenioNominaID = Nom.ConvenioNominaID
		AND Nom.ClienteID = Cli.ClienteID
		AND Con.Estatus = Est_Activo
		AND Nom.ClienteID = Par_ClienteID
        AND Ins.InstitNominaID = Var_InstitucionNominaID
        AND Nom.Estatus = Est_Activo;

		SET Var_NumEmpleado :=IFNULL(Var_NumEmpleado,Cadena_Vacia);

        -- Se obtiene el Monto Exigible del Credito
        SET Var_MontoExigible := (SELECT FUNCIONEXIGIBLE(Par_CreditoID));
		SET Var_MontoExigible := IFNULL(Var_MontoExigible,Decimal_Cero);

        SET Aud_FechaActual := NOW();

        -- Cuando el Monto Exigible es igual 0.00, se ingresa el valor del total de la cuota de proyeccion (Capital + Interés + IVA Int)
		IF(Var_MontoExigible = Decimal_Cero)THEN
			-- Se obtiene el Numero Consecutivo de la Domiciliacion
			SET Var_DomiciliacionID := (SELECT IFNULL(MAX(DomiciliacionID),Entero_Cero)+1 FROM DOMICILIACIONPAGOS);

			INSERT INTO DOMICILIACIONPAGOS(
				DomiciliacionID, 		FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
				CreditoID,				MontoExigible,			Referencia,				NoEmpleado,				EmpresaID,
                Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal,
                NumTransaccion)
			VALUES(
				Var_DomiciliacionID, 	Par_FolioID,			Par_ClienteID,			Par_InstitucionID,		Par_CuentaClabe,
				Par_CreditoID,			Par_MontoExigible,		Var_Referencia,			Var_NumEmpleado,		Par_EmpresaID,
                Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
                Aud_NumTransaccion);
        END IF;

        -- Si agrega validacion cuando el Monto Exigible sea Mayor a 0.00
        IF(Var_MontoExigible > Decimal_Cero)THEN
			-- Se obtiene la Fecha del Sistema
			SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS);

            -- Se obtienen los datos necesarios del Credito
            SELECT  Cli.PagaIVA,	Suc.IVA,		Pro.CobraIVAInteres, 	Pro.CobraIVAMora,
					Cre.TipoPagoCapital
			INTO 	Var_CliPagIVA, 	Var_IVASucurs,  Var_IVAIntOrd, 			Var_IVAIntMor,
					Var_TipoPagoCapital
			FROM CREDITOS   Cre,
				 CLIENTES   Cli,
				 SUCURSALES Suc,
				 PRODUCTOSCREDITO Pro
			WHERE   Cre.CreditoID           = Par_CreditoID
			  AND   Cre.ProductoCreditoID   = Pro.ProducCreditoID
			  AND   Cre.ClienteID           = Cli.ClienteID
			  AND   Cre.SucursalID          = Suc.SucursalID;

			SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA, SiPagaIVA);
			SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd, SiPagaIVA);
			SET Var_IVAIntMor   := IFNULL(Var_IVAIntMor, SiPagaIVA);
			SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);

            SET Var_ValIVAIntOr := Entero_Cero;
			SET Var_ValIVAIntMo := Entero_Cero;
			SET Var_ValIVAGen   := Entero_Cero;

            -- Se obtiene el valor del IVA
            IF (Var_CliPagIVA = SiPagaIVA) THEN

				SET Var_ValIVAGen  := Var_IVASucurs;

				IF (Var_IVAIntOrd = SiPagaIVA) THEN
					SET Var_ValIVAIntOr  := Var_IVASucurs;
				END IF;

				IF (Var_IVAIntMor = SiPagaIVA) THEN
					SET Var_ValIVAIntMo  := Var_IVASucurs;
				END IF;

			END IF;

			-- Se obtiene si se realiza la Domiciliacion de Pagos y el Numero de Cuotas a Cobrar
			SELECT Con.NoCuotasCobrar
			INTO Var_NumCuotasCobrar
			FROM INSTITNOMINA Ins,
				 CONVENIOSNOMINA Con,
				 NOMINAEMPLEADOS Nom,
				 CLIENTES Cli,
				 CREDITOS Cre
			WHERE Ins.InstitNominaID = Con.InstitNominaID
			  AND Con.ConvenioNominaID = Nom.ConvenioNominaID
			  AND Con.InstitNominaID = Nom.InstitNominaID
			  AND Nom.ClienteID = Cli.ClienteID
		      AND Nom.ClienteID = Cre.ClienteID
			  AND Con.Estatus = Est_Activo
			  AND Con.DomiciliacionPagos = ConstanteSI
			  AND Nom.ClienteID = Par_ClienteID
			  AND Cre.CreditoID = Par_CreditoID
			  AND Nom.Estatus = Est_Activo
              AND Ins.InstitNominaID = Var_InstitucionNominaID;

			SET Var_NumCuotasCobrar := IFNULL(Var_NumCuotasCobrar,Entero_Cero);

            -- Se obtiene la Sumatoria del Capital + Interes + IVA Interes de las Cuotas Atrasadas
            SET Var_MontoCapInteres := (SELECT FNDOMICILIACIONPAGOSCRE(Par_CreditoID,Var_InstitucionNominaID,TipoCapitalInt));
            SET Var_MontoCapInteres := IFNULL(Var_MontoCapInteres,Decimal_Cero);

            -- Se obtiene el Capital + Interes + IVA Interes de las Cuotas Atrasadas
            IF(Var_MontoCapInteres  > Decimal_Cero)THEN

                -- Validaciones para Creditos de Clientes que no son de Nomina
                IF(Var_InstitucionNominaID = Entero_Cero) THEN

					SELECT  ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
							ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

							ROUND(SaldoInteresOrd + SaldoInteresAtr +
								  SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) +
							ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
							ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
							ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
							ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
							ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2),2)
					INTO Var_MontoExigibleCuota
					FROM AMORTICREDITO
					WHERE FechaExigible <= Var_FechaSistema
					  AND Estatus       <> Est_Pagado
					  AND CreditoID     =  Par_CreditoID LIMIT 1;

					SET Var_MontoExigibleCuota := IFNULL(Var_MontoExigibleCuota,Decimal_Cero);

                    -- Se registra el Monto Exigible de la cuota en la tabla DOMICILIACIONPAGOS
					IF(Var_MontoExigibleCuota > Decimal_Cero)THEN
						-- Se obtiene el Numero Consecutivo de la Domiciliacion
						SET Var_DomiciliacionID := (SELECT IFNULL(MAX(DomiciliacionID),Entero_Cero)+1 FROM DOMICILIACIONPAGOS);

						INSERT INTO DOMICILIACIONPAGOS(
							DomiciliacionID, 		FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
							CreditoID,				MontoExigible,			Referencia,				NoEmpleado,				EmpresaID,
							Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal,
							NumTransaccion)
						VALUES(
							Var_DomiciliacionID, 	Par_FolioID,			Par_ClienteID,			Par_InstitucionID,		Par_CuentaClabe,
							Par_CreditoID,			Var_MontoExigibleCuota,	Var_Referencia,			Var_NumEmpleado,		Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
							Aud_NumTransaccion);
					END IF;

				END IF; -- FIN validaciones para Creditos de Clientes que no son de Nomina

				-- Validaciones para Creditos de Clientes que son de Nomina con Numero de Cuotas a Cobrar
                IF(Var_InstitucionNominaID > Entero_Cero AND Var_NumCuotasCobrar > Entero_Cero) THEN
					INSERT INTO TMPDOMICILIACIONPAGOS(
						FolioID,		ClienteID,			InstitucionID,		CuentaClabe,		AmortizacionID,
						CreditoID,		MontoExigible,		EmpresaID, 			Usuario, 			FechaActual,
						DireccionIP,	ProgramaID, 		Sucursal, 			NumTransaccion)
					SELECT
						Par_FolioID,	ClienteID,			Par_InstitucionID,	Par_CuentaClabe,	AmortizacionID,
						CreditoID,		ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
										ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2) +

										ROUND(SaldoInteresOrd + SaldoInteresAtr +
											  SaldoInteresVen + SaldoInteresPro + SaldoIntNoConta, 2) +
										ROUND(ROUND(SaldoInteresOrd * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresAtr * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresVen * Var_ValIVAIntOr, 2) +
										ROUND(SaldoInteresPro * Var_ValIVAIntOr, 2) +
										ROUND(SaldoIntNoConta * Var_ValIVAIntOr, 2),2),
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion
					FROM AMORTICREDITO
					WHERE FechaExigible <= Var_FechaSistema
					  AND Estatus       <> Est_Pagado
					  AND CreditoID     =  Par_CreditoID
					  LIMIT Var_NumCuotasCobrar;

					-- Se obtiene el Numero Total de las Amortizaciones
					SET Var_NumAmortizacion  := (SELECT COUNT(AmortizacionID) FROM TMPDOMICILIACIONPAGOS WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
					SET	Var_NumAmortizacion  := IFNULL(Var_NumAmortizacion, Entero_Cero);

					-- Se obtiene el Numero Maximo de la Amortizacion
					SET Var_MaxAmortizacionID	:= (SELECT MAX(AmortizacionID) FROM TMPDOMICILIACIONPAGOS WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
					SET	Var_MaxAmortizacionID  	:= IFNULL(Var_MaxAmortizacionID, Entero_Cero);

					 -- Se obtiene el Numero Minimo de la Amortizacion
					SET Var_MinAmortizacionID	:= (SELECT MIN(AmortizacionID) FROM TMPDOMICILIACIONPAGOS WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
					SET	Var_MinAmortizacionID   := IFNULL(Var_MinAmortizacionID, Entero_Cero);

					-- Se obtiene el Numero de la Siguiente Amortizacion
					SET Var_AmortizacionID 		:= Var_MinAmortizacionID + 1;

					-- Se valida cuando el Numero Total de las Amortizaciones sea mayor a Uno y el Tipo de Pago de Capital del Credito sea CRECIENTE
					IF(Var_NumAmortizacion > Entero_Uno AND Var_TipoPagoCapital = TipPagCapCre)THEN
						-- Se obtiene el Numero de Amortizaciones del Credito
						SET Var_NumAmortizaCredito := (SELECT COUNT(AmortizacionID) FROM AMORTICREDITO WHERE CreditoID = Par_CreditoID);
						-- Se inicializa el Monto de la Cuota agregando un centavo 0.01
						SET Var_MontoCuota := UnPeso;

						  -- INICIA EL WHILE
						  WHILE (Var_AmortizacionID <= Var_MaxAmortizacionID) DO

								IF(Var_AmortizacionID != Var_NumAmortizaCredito)THEN
									-- Se actualiza el Monto Exigible de las Amortizaciones
									UPDATE TMPDOMICILIACIONPAGOS
									SET MontoExigible = MontoExigible + Var_MontoCuota
									WHERE AmortizacionID = Var_AmortizacionID
									AND CreditoID = Par_CreditoID
									AND NumTransaccion = Aud_NumTransaccion;
								END IF;

								SET Var_MontoCuota			:= Var_MontoCuota + UnPeso;
								SET Var_AmortizacionID  	:= Var_AmortizacionID + Entero_Uno;

						  END WHILE; -- TERMINA EL WHILE

					END IF; -- FIN cuando el Numero Total de las Amortizaciones sea mayor a Uno y el Tipo de Pago de Capital del Credito sea CRECIENTE

					-- Se obtiene el Numero Total de Creditos
					SET Var_NumCreditos  := (SELECT COUNT(CreditoID) FROM TMPDOMICILIACIONPAGOS WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
					SET	Var_NumCreditos  := IFNULL(Var_NumCreditos, Entero_Cero);

					-- Se obtiene el Numero Maximo de la Amortizacion
					SET Var_MaxAmortizacionID	:= (SELECT MAX(AmortizacionID) FROM TMPDOMICILIACIONPAGOS WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
					SET	Var_MaxAmortizacionID  	:= IFNULL(Var_MaxAmortizacionID, Entero_Cero);

					-- Se obtiene el Numero Minimo de la Amortizacion
					SET Var_MinAmortizacionID	:= (SELECT MIN(AmortizacionID) FROM TMPDOMICILIACIONPAGOS WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion);
					SET	Var_MinAmortizacionID   := IFNULL(Var_MinAmortizacionID, Entero_Cero);

					-- Se realiza el registro de los creditos en la tabla DOMICILIACIONPAGOS
					IF(Var_NumCreditos > Entero_Cero)THEN

						WHILE (Var_MinAmortizacionID <= Var_MaxAmortizacionID) DO
							-- Se obtiene el Numero Consecutivo de la Domiciliacion
							SET Var_DomiciliacionID := (SELECT IFNULL(MAX(DomiciliacionID),Entero_Cero)+1 FROM DOMICILIACIONPAGOS);

							INSERT INTO DOMICILIACIONPAGOS(
								DomiciliacionID, 		FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
								CreditoID,				MontoExigible,			Referencia,				NoEmpleado,				EmpresaID,
								Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal,
								NumTransaccion)
							SELECT
								Var_DomiciliacionID, 	FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
								CreditoID,				MontoExigible,			Var_Referencia,			Var_NumEmpleado,		Par_EmpresaID,
								Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
								Aud_NumTransaccion
							FROM TMPDOMICILIACIONPAGOS
							WHERE AmortizacionID = Var_MinAmortizacionID
							AND CreditoID = Par_CreditoID
							AND NumTransaccion = Aud_NumTransaccion;

							SET Var_MinAmortizacionID  	:= Var_MinAmortizacionID + Entero_Uno;

						END WHILE;

						-- Se elimina el Numero de Transaccion una vez ingresado la informacion en la tabla DOMICILIACIONPAGOS
						DELETE FROM TMPDOMICILIACIONPAGOS WHERE NumTransaccion = Aud_NumTransaccion;

					END IF; -- FIN registro de los creditos en la tabla DOMICILIACIONPAGOS

                END IF; -- FIN Validaciones para Creditos de Clientes que son de Nomina con Numero de Cuotas a Cobrar

            END IF; -- FIN Capital + Interes + IVA Interes de las Cuotas Atrasadas

			-- Se obtiene el Monto Exigible de los Intereses Moratorios
			SET Var_MontoMora := (SELECT FNDOMICILIACIONPAGOSCRE(Par_CreditoID,Var_InstitucionNominaID,TipoMoratorio));
            SET Var_MontoMora := IFNULL(Var_MontoMora, Decimal_Cero);

            -- Se registra el Monto Exigible de los Intereses Moratorios en la tabla DOMICILIACIONPAGOS
            IF(Var_MontoMora > Decimal_Cero)THEN
				-- Se obtienen los Moratorios para Creditos de Nomina
				IF(Var_InstitucionNominaID > Entero_Cero)THEN
					INSERT INTO TMPDOMICILIACIONPAGOS(
						FolioID,		ClienteID,			InstitucionID,		CuentaClabe,		AmortizacionID,
						CreditoID,		MontoExigible,		EmpresaID, 			Usuario, 			FechaActual,
						DireccionIP,	ProgramaID, 		Sucursal, 			NumTransaccion)
					SELECT
						Par_FolioID,	ClienteID,			Par_InstitucionID,	Par_CuentaClabe,	AmortizacionID,
                        CreditoID,		ROUND(IFNULL(ROUND(SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen,2) +
										ROUND(ROUND(SaldoMoratorios * Var_ValIVAIntMo,2)+
										ROUND(SaldoMoraVencido * Var_ValIVAIntMo,2)+
										ROUND(SaldoMoraCarVen * Var_ValIVAIntMo,2)),Decimal_Cero),2),
                        Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
                        Aud_Sucursal,	Aud_NumTransaccion
					FROM AMORTICREDITO
					WHERE FechaExigible <= Var_FechaSistema
					  AND Estatus       <> Est_Pagado
					  AND CreditoID     =  Par_CreditoID LIMIT Var_NumCuotasCobrar;

                    -- Se realiza la suma de los Moratorios
					SET Var_MontoMora := (SELECT IFNULL(SUM(MontoExigible),Decimal_Cero) FROM TMPDOMICILIACIONPAGOS WHERE  NumTransaccion = Aud_NumTransaccion);
                END IF;

                 IF(Var_MontoMora > Decimal_Cero)THEN

					-- Se obtiene el Numero Consecutivo de la Domiciliacion
					SET Var_DomiciliacionID := (SELECT IFNULL(MAX(DomiciliacionID),Entero_Cero)+1 FROM DOMICILIACIONPAGOS);

					INSERT INTO DOMICILIACIONPAGOS(
						DomiciliacionID, 		FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
						CreditoID,				MontoExigible,			Referencia,				NoEmpleado,				EmpresaID,
						Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal,
						NumTransaccion)
					VALUES(
						Var_DomiciliacionID, 	Par_FolioID,			Par_ClienteID,			Par_InstitucionID,		Par_CuentaClabe,
						Par_CreditoID,			Var_MontoMora,			Var_Referencia,			Var_NumEmpleado,		Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
						Aud_NumTransaccion);
				END IF;
				-- Se elimina el Numero de Transaccion una vez ingresado la informacion en la tabla DOMICILIACIONPAGOS
				DELETE FROM TMPDOMICILIACIONPAGOS WHERE NumTransaccion = Aud_NumTransaccion;
            END IF;

            -- Se obtiene el Monto Exigible de las Comisiones
			SET Var_MontoComision := (SELECT FNDOMICILIACIONPAGOSCRE(Par_CreditoID,Var_InstitucionNominaID,TipoComision));
			SET Var_MontoComision := IFNULL(Var_MontoComision, Decimal_Cero);

            -- Se registra el Monto Exigible de las Comisiones en la tabla DOMICILIACIONPAGOS
            IF(Var_MontoComision > Decimal_Cero)THEN
				-- Se obtienen las Comisiones para Creditos de Nomina
				IF(Var_InstitucionNominaID > Entero_Cero)THEN
					INSERT INTO TMPDOMICILIACIONPAGOS(
						FolioID,		ClienteID,			InstitucionID,		CuentaClabe,		AmortizacionID,
						CreditoID,		MontoExigible,		EmpresaID, 			Usuario, 			FechaActual,
						DireccionIP,	ProgramaID, 		Sucursal, 			NumTransaccion)
					SELECT
						Par_FolioID,	ClienteID,			Par_InstitucionID,	Par_CuentaClabe,	AmortizacionID,
                        CreditoID, 		ROUND(IFNULL(ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_ValIVAGen,2) +
					                 	ROUND(SaldoComServGar,2) + ROUND(ROUND(SaldoComServGar,2) * Var_ValIVAGen,2) +
										ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_ValIVAGen,2) +
										ROUND(SaldoComisionAnual,2) + ROUND(ROUND(SaldoComisionAnual,2) * Var_ValIVAGen,2) +
										ROUND(SaldoSeguroCuota,2) + ROUND(SaldoIVASeguroCuota,2), Decimal_Cero),2),
						Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
                        Aud_Sucursal,	Aud_NumTransaccion
					FROM AMORTICREDITO
					WHERE FechaExigible <= Var_FechaSistema
					  AND Estatus       <> Est_Pagado
					  AND CreditoID     =  Par_CreditoID LIMIT Var_NumCuotasCobrar;

					-- Se realiza la suma de las Comisiones
					SET Var_MontoComision := (SELECT IFNULL(SUM(MontoExigible),Decimal_Cero) FROM TMPDOMICILIACIONPAGOS WHERE  NumTransaccion = Aud_NumTransaccion);

                END IF;

                IF(Var_MontoComision > Decimal_Cero)THEN
					-- Se obtiene el Numero Consecutivo de la Domiciliacion
					SET Var_DomiciliacionID := (SELECT IFNULL(MAX(DomiciliacionID),Entero_Cero)+1 FROM DOMICILIACIONPAGOS);

					INSERT INTO DOMICILIACIONPAGOS(
						DomiciliacionID, 		FolioID,				ClienteID,				InstitucionID,			CuentaClabe,
						CreditoID,				MontoExigible,			Referencia,				NoEmpleado,				EmpresaID,
						Usuario, 				FechaActual,			DireccionIP, 			ProgramaID, 			Sucursal,
						NumTransaccion)
					VALUES(
						Var_DomiciliacionID, 	Par_FolioID,			Par_ClienteID,			Par_InstitucionID,		Par_CuentaClabe,
						Par_CreditoID,			Var_MontoComision,		Var_Referencia,			Var_NumEmpleado,		Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, 		Aud_Sucursal,
						Aud_NumTransaccion);
                END IF;
				-- Se elimina el Numero de Transaccion una vez ingresado la informacion en la tabla DOMICILIACIONPAGOS
				DELETE FROM TMPDOMICILIACIONPAGOS WHERE NumTransaccion = Aud_NumTransaccion;

            END IF;
        END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Domiciliacion de Pagos Agregada Exitosamente.';
		SET Var_Control	:= 'agregar';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Var_DomiciliacionID AS Consecutivo;
	END IF;
END TerminaStore$$