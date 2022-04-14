-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEACCESORIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEACCESORIOSALT`;
DELIMITER $$

CREATE PROCEDURE `DETALLEACCESORIOSALT`(
# =====================================================================================
# ----- SP QUE DA DE ALTA EL DETALLE DE LOS ACCESORIOS COBRADOS POR UN CREDITO --------
# =====================================================================================
	Par_CreditoID			BIGINT(12),			# Numero de Credito
    Par_SolicitudCreditoID	BIGINT(20),			# Numero de Solicitud Credito
    Par_ProductoCreditoID	INT(11),			# Numero del Producto de Credito
    Par_ClienteID			INT(11),			# Numero de Cliente
    Par_NumTransacSim		BIGINT(20),			# Numero de Transaccion de la Solicitud

    Par_PlazoID				INT(11),			# Identificador del Plazo
    Par_TipoOperacion		INT(11),			# Tipo de Transaccion
	Par_Monto				DECIMAL(12,2),		-- Monto Solicitado
	Par_ConvenioNominaID	BIGINT UNSIGNED,	-- Identificador del convenio

	Par_Salida				CHAR(1),			# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error

	# Parametros de Auditoria
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(20);		# Variable de Control
	DECLARE Var_Consecutivo		VARCHAR(50);		# Consecutivo
    DECLARE Var_MontoCredito	DECIMAL(14,2);		# Monto del Credito
    DECLARE Var_CuotasCapital	INT(11);			# Numero de Cuotas de Capital
    DECLARE Var_CuotasInteres	INT(11);			# Numero de Cuotas de Interes

    DECLARE Var_SucCliente		INT(11);			# Sucursal del Cliente
    DECLARE Var_IVASucursal		DECIMAL(14,2);		# IVA de la Sucursal
    DECLARE Var_PagaIVA			CHAR(1);			# Indica si el cliente paga o no IVA
	DECLARE Var_IVAAccesorios	DECIMAL(14,2);		# Indica el valor del IVA a cobrar por Accesorio
    DECLARE Var_NumRegistrosSim	INT(11);			# Numero de registros de la tabla TMPPAGAMORSIM
    DECLARE Contador			INT(11);			# Contador

    DECLARE Var_CicloCliente	INT(11);			# Ciclo Actual del Cliente
    DECLARE Var_EsNomina		CHAR(1);			-- Variable que indica si el producto es de nómina

    	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
    DECLARE Salida_NO			CHAR(1);
    DECLARE Entero_Cero			INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
    DECLARE Fecha_Vacia			DATE;
	DECLARE NumAmortizacion		INT(11);
    DECLARE TipoSimulador		INT(11);
    DECLARE TipoPantalla		INT(11);
    DECLARE CobroFinanciado		CHAR(1);
    DECLARE CobroAnticipado		CHAR(1);
    DECLARE CobroDeduccion		CHAR(1);
    DECLARE TipoMontoOriginal	CHAR(1);
    DECLARE TipoPorcentaje		CHAR(1);
    DECLARE SiPagaIVA      		CHAR(1);
    DECLARE NoPagaIVA			CHAR(1);
	DECLARE Valor_UNO			INT(11);
	DECLARE Var_CadenaSI		CHAR(1);

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia			:= '';				# Constantes: Cadena Vacia
	SET Salida_SI				:= 'S';				# Constante: SI
    SET Salida_NO				:= 'N';				# Constante: NO
    SET Entero_Cero 			:= 0;				# Constante: Entero Cero
    SET Decimal_Cero			:= 0.00;			# Constante: Decimal Cero
	SET Fecha_Vacia				:= '1900-01-01';	# Constante Fecha Vacia
    SET NumAmortizacion			:= 1;				# Amortizacion 1
    SET TipoSimulador			:= 1;				# El alta se ejecuta desde el simulador
    SET TipoPantalla 			:= 2;				# El alta se ejecuta desde pantalla (Forma de Cobro Anticipada y Deduccion)
    SET CobroFinanciado			:= 'F';				# Forma de cobro FINANCIADO
    SET CobroAnticipado			:= 'A';				# Forma de cobro ANTICIPADO
    SET CobroDeduccion			:= 'D';				# Forma de cobro DEDUCCION
    SET TipoMontoOriginal		:= 'M';   			# Tipo de pago: MONTO ORIGINAL
	SET TipoPorcentaje			:= 'P';				# TIpo de pago: PORCENTAJE
    SET SiPagaIVA       		:= 'S';             # Valor SI paga IVA
    SET NoPagaIVA				:= 'N';				# Valor NO paga IVA
	SET Valor_UNO				:= 1;				# Constante: UNO
	SET Var_CadenaSI			:= 'S';				-- Variable con valor S de Si


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr	:= 999;
				SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DETALLEACCESORIOSALT');
				SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SET Par_CreditoID			:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_SolicitudCreditoID	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
        SET Par_ProductoCreditoID	:= IFNULL(Par_ProductoCreditoID, Entero_Cero);
        SET Par_NumTransacSim		:= IFNULL(Par_NumTransacSim, Entero_Cero);
        SET Par_PlazoID				:= IFNULL(Par_PlazoID, Entero_Cero);
		SET Par_TipoOperacion		:= IFNULL(Par_TipoOperacion, Entero_Cero);
        SET NumAmortizacion			:= IFNULL(NumAmortizacion, Entero_Cero);

		SET Aud_FechaActual := NOW();

        SELECT SucursalOrigen,	PagaIVA	INTO Var_SucCliente, Var_PagaIVA FROM CLIENTES WHERE ClienteID = Par_ClienteID;

        SET Var_IVAAccesorios	:= Decimal_Cero;
        SET Var_PagaIVA			:= IFNULL(Var_PagaIVA, Cadena_Vacia);
        SET Var_SucCliente 		:= IFNULL(Var_SucCliente, Entero_Cero);
		SET Var_IVASucursal		:= (SELECT IVA FROM SUCURSALES	WHERE SucursalID = Var_SucCliente);
		SET Var_EsNomina		:= (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProductoCreditoID);

        # Se obtiene el ciclo del Cliente
         CALL CRECALCULOCICLOPRO(
			Par_ClienteID,		Entero_Cero,		Par_ProductoCreditoID,	Entero_Cero,	Var_CicloCliente,
            Entero_Cero,		Salida_NO,			Aud_EmpresaID,			Aud_Usuario,	Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


        # SI EL CLIENTE PAGA IVA, SE OBTIENE EL VALOR DEL IVA DE LA SUCURSAL
        IF(Var_PagaIVA = SiPagaIVA) THEN
			SET Var_IVAAccesorios := Var_IVASucursal;
        END IF;

        # CALCULA EL DETALLE DE LOS ACCESORIOS QUE SU FORMA DE COBRO ES FINANCIADO
        IF(Par_TipoOperacion = TipoSimulador) THEN
			-- VALIDACIONES
			IF(Par_NumTransacSim = Entero_Cero) THEN
				SET Par_NumErr		:= 001;
				SET Par_ErrMen		:= 'El numero de Transaccion esta Vacio.';
				SET Var_Consecutivo	:= Cadena_Vacia;
				SET Var_Control		:= 'numTransacSim';
				LEAVE ManejoErrores;
			END IF;

            IF(Par_PlazoID = Entero_Cero) THEN
				SET Par_NumErr		:= 001;
				SET Par_ErrMen		:= 'El Plazo esta Vacio.';
				SET Var_Consecutivo	:= Cadena_Vacia;
				SET Var_Control		:= 'plazoID';
				LEAVE ManejoErrores;
			END IF;

            # SI YA EXISTE UN CREDITO, SE ELIMINA EL REGISTRO DE LA TABLA DETALLEACCESORIOS Y SI EXISTEN OTROS ACCESORIOS CON OTRA FORMA DE COBRO, SE LES SETEA EL VALOR DEL CREDITO
			IF(Par_CreditoID <> Entero_Cero) THEN
				DELETE FROM DETALLEACCESORIOS WHERE
                CreditoID = Par_CreditoID
                AND TipoFormaCobro =  CobroFinanciado;

            ELSE
				# SE ELIMINAN LOS REGISTROS INSERTADOS DE UNA SIMULACION PREVIA PARA LOS ACCESORIOS QUE SON COBRADOS DE MANERA FINANCIADA
				DELETE FROM DETALLEACCESORIOS WHERE NumTransacSim = Par_NumTransacSim
                AND TipoFormaCobro =  CobroFinanciado;
            END IF;

            SET  Contador := IFNULL(Contador, Entero_Cero);
			SET Var_NumRegistrosSim := (SELECT COUNT(*)FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransacSim);
			IF(Var_NumRegistrosSim > Entero_Cero) THEN

				SET Contador := 1;
				WHILE(Contador <= Var_NumRegistrosSim) DO
					# SE INSERTA EL REGISTRO A LA TABLA
					IF Var_EsNomina != Var_CadenaSI THEN
						INSERT INTO DETALLEACCESORIOS(
								CreditoID,			SolicitudCreditoID,		NumTransacSim,			AccesorioID,		PlazoID,
								CobraIVA,			GeneraInteres,			CobraIVAInteres,		TipoFormaCobro,		TipoPago,
								BaseCalculo,        Porcentaje,				AmortizacionID, 		MontoAccesorio,		MontoIVAAccesorio,
								MontoCuota,         MontoIVACuota,			SaldoVigente,       	SaldoAtrasado,		SaldoIVAAccesorio,
								MontoPagado,        FechaLiquida,			EmpresaID,				Usuario,			FechaActual,
								DireccionIP,		ProgramaID,				Sucursal,  	 			NumTransaccion)

						SELECT  Par_CreditoID,		Par_SolicitudCreditoID,	Par_NumTransacSim,		Esq.AccesorioID,	Par_PlazoID,
								Esq.CobraIVA,		Esq.GeneraInteres,		Esq.CobraIVAInteres,	Esq.TipoFormaCobro,	Esq.TipoPago,
								Esq.BaseCalculo,	EsqAc.Porcentaje,		Contador,				Decimal_Cero,		Decimal_Cero,
								Decimal_Cero,       Decimal_Cero,			Decimal_Cero,			Decimal_Cero,		Decimal_Cero,
								Decimal_Cero,       Fecha_Vacia,			Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
						FROM	ESQUEMAACCESORIOSPROD Esq
						INNER JOIN ESQCOBROACCESORIOS EsqAc
						ON Esq.AccesorioID = EsqAc.AccesorioID
						AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
						WHERE 	Esq.ProductoCreditoID = Par_ProductoCreditoID
						AND EsqAc.PlazoID = Par_PlazoID
						AND Esq.TipoFormaCobro = CobroFinanciado
	                    AND Var_CicloCliente >= EsqAc.CicloIni
	                    AND Var_CicloCliente <= EsqAc.CicloFin
	                    AND EsqAc.ConvenioID = Par_ConvenioNominaID
	                    AND Par_Monto BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax;
                    ELSE
                    	INSERT INTO DETALLEACCESORIOS(
								CreditoID,			SolicitudCreditoID,		NumTransacSim,			AccesorioID,			PlazoID,
								CobraIVA,			GeneraInteres,			CobraIVAInteres,		TipoFormaCobro,			TipoPago,
								BaseCalculo,        Porcentaje,				AmortizacionID, 		MontoAccesorio,			MontoIVAAccesorio,
								MontoCuota,         MontoIVACuota,			SaldoVigente,       	SaldoAtrasado,			SaldoIVAAccesorio,
								MontoPagado,        FechaLiquida,			EmpresaID,				Usuario,				FechaActual,
								DireccionIP,		ProgramaID,				Sucursal,  	 			NumTransaccion)

						SELECT  Par_CreditoID,		Par_SolicitudCreditoID,	Par_NumTransacSim,		Esq.AccesorioID,		Par_PlazoID,
								Esq.CobraIVA,		Esq.GeneraInteres,		Esq.CobraIVAInteres,	Esq.TipoFormaCobro,		Esq.TipoPago,
								Esq.BaseCalculo,	EsqAc.Porcentaje,		Contador,				Decimal_Cero,			Decimal_Cero,
								Decimal_Cero,       Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
								Decimal_Cero,       Fecha_Vacia,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
						FROM	ESQUEMAACCESORIOSPROD Esq
						INNER JOIN ESQCOBROACCESORIOS EsqAc
						ON Esq.AccesorioID = EsqAc.AccesorioID
						AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
						INNER  JOIN CONVENIOSNOMINA Con
						ON EsqAc.ConvenioID = Con.ConvenioNominaID
						AND Esq.InstitNominaID = Con.InstitNominaID
						WHERE 	Esq.ProductoCreditoID = Par_ProductoCreditoID
						AND EsqAc.PlazoID = Par_PlazoID
						AND Esq.TipoFormaCobro = CobroFinanciado
	                    AND Var_CicloCliente >= EsqAc.CicloIni
	                    AND Var_CicloCliente <= EsqAc.CicloFin
	                    AND EsqAc.ConvenioID = Par_ConvenioNominaID
	                    AND Par_Monto BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax;
                    END IF;

					SET Contador = Contador + 1;
				END WHILE;
			ELSE
				# SE INSERTA EL REGISTRO A LA TABLA
                    IF Var_EsNomina != Var_CadenaSI THEN
						INSERT INTO DETALLEACCESORIOS(
								CreditoID,			SolicitudCreditoID,		NumTransacSim,			AccesorioID,			PlazoID,
								CobraIVA,			GeneraInteres,			CobraIVAInteres,		TipoFormaCobro,			TipoPago,
								BaseCalculo,        Porcentaje,				AmortizacionID, 		MontoAccesorio,			MontoIVAAccesorio,
								MontoCuota,         MontoIVACuota,			SaldoVigente,       	SaldoAtrasado,			SaldoIVAAccesorio,
								MontoPagado,        FechaLiquida,			EmpresaID,				Usuario,				FechaActual,
								DireccionIP,		ProgramaID,				Sucursal,  	 			NumTransaccion)

						SELECT  Par_CreditoID,		Par_SolicitudCreditoID,	Par_NumTransacSim,		Esq.AccesorioID,		Par_PlazoID,
								Esq.CobraIVA,		Esq.GeneraInteres,		Esq.CobraIVAInteres,	Esq.TipoFormaCobro,		Esq.TipoPago,
								Esq.BaseCalculo,	EsqAc.Porcentaje,		Contador,				Decimal_Cero,			Decimal_Cero,
								Decimal_Cero,       Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
								Decimal_Cero,       Fecha_Vacia,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
						FROM	ESQUEMAACCESORIOSPROD Esq
						INNER JOIN ESQCOBROACCESORIOS EsqAc
						ON Esq.AccesorioID = EsqAc.AccesorioID
						AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
						WHERE 	Esq.ProductoCreditoID = Par_ProductoCreditoID
						AND EsqAc.PlazoID = Par_PlazoID
						AND Esq.TipoFormaCobro = CobroFinanciado
	                    AND Var_CicloCliente >= EsqAc.CicloIni
	                    AND Var_CicloCliente <= EsqAc.CicloFin
	                    AND EsqAc.ConvenioID = Par_ConvenioNominaID
	                    AND Par_Monto BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax;
                    ELSE
                    	INSERT INTO DETALLEACCESORIOS(
								CreditoID,			SolicitudCreditoID,		NumTransacSim,			AccesorioID,			PlazoID,
								CobraIVA,			GeneraInteres,			CobraIVAInteres,		TipoFormaCobro,			TipoPago,
								BaseCalculo,        Porcentaje,				AmortizacionID, 		MontoAccesorio,			MontoIVAAccesorio,
								MontoCuota,         MontoIVACuota,			SaldoVigente,       	SaldoAtrasado,			SaldoIVAAccesorio,
								MontoPagado,        FechaLiquida,			EmpresaID,				Usuario,				FechaActual,
								DireccionIP,		ProgramaID,				Sucursal,  	 			NumTransaccion)

						SELECT  Par_CreditoID,		Par_SolicitudCreditoID,	Par_NumTransacSim,		Esq.AccesorioID,		Par_PlazoID,
								Esq.CobraIVA,		Esq.GeneraInteres,		Esq.CobraIVAInteres,	Esq.TipoFormaCobro,		Esq.TipoPago,
								Esq.BaseCalculo,	EsqAc.Porcentaje,		Contador,				Decimal_Cero,			Decimal_Cero,
								Decimal_Cero,       Decimal_Cero,			Decimal_Cero,			Decimal_Cero,			Decimal_Cero,
								Decimal_Cero,       Fecha_Vacia,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
						FROM	ESQUEMAACCESORIOSPROD Esq
						INNER JOIN ESQCOBROACCESORIOS EsqAc
						ON Esq.AccesorioID = EsqAc.AccesorioID
						AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
						INNER  JOIN CONVENIOSNOMINA Con
						ON EsqAc.ConvenioID = Con.ConvenioNominaID
						AND Esq.InstitNominaID = Con.InstitNominaID
						WHERE 	Esq.ProductoCreditoID = Par_ProductoCreditoID
						AND EsqAc.PlazoID = Par_PlazoID
						AND Esq.TipoFormaCobro = CobroFinanciado
	                    AND Var_CicloCliente >= EsqAc.CicloIni
	                    AND Var_CicloCliente <= EsqAc.CicloFin
	                    AND EsqAc.ConvenioID = Par_ConvenioNominaID
	                    AND Par_Monto BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax;
                    END IF;
            END IF;
        ELSE

            # OPERACIONES POR SOLICITUD DE CREDITO
            # INSERTA EL DETALLE DE LOS ACCESORIOS CUANDO SU FORMA DE COBRO ES ANTICIPADO Y/O DEDUCCION
			IF(Par_SolicitudCreditoID > Entero_Cero) THEN
				# SE ELIMINA EL DETALLE DE LOS ACCESORIOS GENERADOS EN UN CALCULO PREVIO
                DELETE FROM DETALLEACCESORIOS
                WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                AND TipoFormaCobro <> CobroFinanciado;

				# SE OBTIENE EL MONTO DE LA SOLICITUD DE CREDITO
                 SET Var_MontoCredito := (SELECT CASE WHEN (Estatus = CobroAnticipado OR Estatus = CobroDeduccion) THEN MontoAutorizado
												ELSE MontoSolici END
											FROM SOLICITUDCREDITO WHERE SolicitudCreditoID = Par_SolicitudCreditoID);
            END IF;
            # OPERACIONES POR CREDITO
            IF(Par_CreditoID > Entero_Cero) THEN
				# SE ELIMINA EL DETALLE DE LOS ACCESORIOS GENERADOS EN UN CALCULO PREVIO
				DELETE FROM DETALLEACCESORIOS
                WHERE CreditoID = Par_CreditoID
                AND TipoFormaCobro <> CobroFinanciado;

                # SE OBTIENE EL MONTO DEL CREDITO
                SET Var_MontoCredito := (SELECT MontoCredito FROM CREDITOS	WHERE CreditoID = Par_CreditoID);
            END IF;

			# SE INSERTAN LOS REGISTROS DE LOS ACCESORIOS CUANDO LA FORMA DE CREDITO ES ANTICIPADA O DEDUCCION
			IF Var_EsNomina != Var_CadenaSI THEN
				INSERT INTO DETALLEACCESORIOS(
						CreditoID,			SolicitudCreditoID,		NumTransacSim,			AccesorioID,			PlazoID,
	                    CobraIVA,			GeneraInteres,			CobraIVAInteres,		TipoFormaCobro,			TipoPago,
						BaseCalculo,        Porcentaje,             AmortizacionID, 		MontoAccesorio,			MontoIVAAccesorio,
						MontoCuota,         MontoIVACuota,          SaldoVigente,       	SaldoAtrasado,			SaldoIVAAccesorio,
						MontoPagado,        FechaLiquida,			EmpresaID,				Usuario,				FechaActual,
						DireccionIP,        ProgramaID,             Sucursal,  	 			NumTransaccion)

				SELECT  Par_CreditoID,		Par_SolicitudCreditoID,	Par_NumTransacSim,		Esq.AccesorioID,		Par_PlazoID,
						Esq.CobraIVA,		Esq.GeneraInteres,		Esq.CobraIVAInteres,	Esq.TipoFormaCobro,		Esq.TipoPago,
						Esq.BaseCalculo,	EsqAc.Porcentaje,       Entero_Cero,
	                    CASE WHEN (TipoFormaCobro = CobroDeduccion 	OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN EsqAc.Porcentaje
							WHEN (TipoFormaCobro = CobroDeduccion 	OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje THEN ROUND((Var_MontoCredito * EsqAc.Porcentaje)/100,2)
						END,
	                     CASE
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND(((Var_MontoCredito * EsqAc.Porcentaje) /100 * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
						END,
	                    CASE WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN EsqAc.Porcentaje
							WHEN  (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje THEN ROUND((Var_MontoCredito * EsqAc.Porcentaje)/100,2)
						END,
	                    CASE
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND(((Var_MontoCredito * EsqAc.Porcentaje) /100 * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
						END,
	                    CASE WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN EsqAc.Porcentaje
							WHEN  (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje THEN ROUND((Var_MontoCredito * EsqAc.Porcentaje)/100,2)
						END,
	                    Decimal_Cero,
	                     CASE
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND(((Var_MontoCredito * EsqAc.Porcentaje) /100 * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
						END,
	                    Decimal_Cero,			Fecha_Vacia,
	                    Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
	                    Aud_Sucursal,		Aud_NumTransaccion
				FROM	ESQUEMAACCESORIOSPROD Esq
	            INNER JOIN ESQCOBROACCESORIOS EsqAc
	            ON Esq.AccesorioID = EsqAc.AccesorioID
	            AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
				WHERE 	Esq.ProductoCreditoID = Par_ProductoCreditoID
	            AND EsqAc.PlazoID = Par_PlazoID
	            AND Esq.TipoFormaCobro <> CobroFinanciado
	            AND Var_CicloCliente >= EsqAc.CicloIni
				AND Var_CicloCliente <= EsqAc.CicloFin
				AND EsqAc.ConvenioID = Par_ConvenioNominaID
				AND Par_Monto BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax;
			ELSE
				INSERT INTO DETALLEACCESORIOS(
						CreditoID,			SolicitudCreditoID,		NumTransacSim,			AccesorioID,			PlazoID,
	                    CobraIVA,			GeneraInteres,			CobraIVAInteres,		TipoFormaCobro,			TipoPago,
						BaseCalculo,        Porcentaje,             AmortizacionID, 		MontoAccesorio,			MontoIVAAccesorio,
						MontoCuota,         MontoIVACuota,          SaldoVigente,       	SaldoAtrasado,			SaldoIVAAccesorio,
						MontoPagado,        FechaLiquida,			EmpresaID,				Usuario,				FechaActual,
						DireccionIP,        ProgramaID,             Sucursal,  	 			NumTransaccion)
				SELECT  Par_CreditoID,		Par_SolicitudCreditoID,	Par_NumTransacSim,		Esq.AccesorioID,		Par_PlazoID,
						Esq.CobraIVA,		Esq.GeneraInteres,		Esq.CobraIVAInteres,	Esq.TipoFormaCobro,		Esq.TipoPago,
						Esq.BaseCalculo,	EsqAc.Porcentaje,       Entero_Cero,
	                    CASE WHEN (TipoFormaCobro = CobroDeduccion 	OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN EsqAc.Porcentaje
							WHEN (TipoFormaCobro = CobroDeduccion 	OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje THEN ROUND((Var_MontoCredito * EsqAc.Porcentaje)/100,2)
						END,
	                     CASE
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND(((Var_MontoCredito * EsqAc.Porcentaje) /100 * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
						END,
	                    CASE WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN EsqAc.Porcentaje
							WHEN  (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje THEN ROUND((Var_MontoCredito * EsqAc.Porcentaje)/100,2)
						END,
	                    CASE
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND(((Var_MontoCredito * EsqAc.Porcentaje) /100 * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
						END,
	                    CASE WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal THEN EsqAc.Porcentaje
							WHEN  (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje THEN ROUND((Var_MontoCredito * EsqAc.Porcentaje)/100,2)
						END,
	                    Decimal_Cero,
	                     CASE
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND((EsqAc.Porcentaje * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoMontoOriginal AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = SiPagaIVA THEN IFNULL(ROUND(((Var_MontoCredito * EsqAc.Porcentaje) /100 * Var_IVAAccesorios),2),Decimal_Cero)
							WHEN (TipoFormaCobro = CobroDeduccion OR TipoFormaCobro = CobroAnticipado) AND TipoPago = TipoPorcentaje AND Var_MontoCredito > Decimal_Cero AND Esq.CobraIVA = NoPagaIVA THEN Decimal_Cero
						END,
	                    Decimal_Cero,			Fecha_Vacia,
	                    Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
	                    Aud_Sucursal,		Aud_NumTransaccion
				FROM	ESQUEMAACCESORIOSPROD Esq
	            INNER JOIN ESQCOBROACCESORIOS EsqAc
	            ON Esq.AccesorioID = EsqAc.AccesorioID
	            AND Esq.ProductoCreditoID = EsqAc.ProductoCreditoID
	            INNER  JOIN CONVENIOSNOMINA Con
				ON EsqAc.ConvenioID = Con.ConvenioNominaID
				AND Esq.InstitNominaID = Con.InstitNominaID
				WHERE 	Esq.ProductoCreditoID = Par_ProductoCreditoID
	            AND EsqAc.PlazoID = Par_PlazoID
	            AND Esq.TipoFormaCobro <> CobroFinanciado
	            AND Var_CicloCliente >= EsqAc.CicloIni
				AND Var_CicloCliente <= EsqAc.CicloFin
				AND EsqAc.ConvenioID = Par_ConvenioNominaID
				AND Par_Monto BETWEEN EsqAc.MontoMin AND EsqAc.MontoMax;
			END IF;

		END IF;

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Accesorio Agregado Exitosamente: ', CONVERT(Par_NumTransacSim,CHAR));
		SET Var_Control			:= 'NumTransacSim';
		SET Var_Consecutivo		:= Par_NumTransacSim;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$