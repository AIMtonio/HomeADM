-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCOTRASCOMISIONESATEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCOTRASCOMISIONESATEPRO`;
DELIMITER $$


CREATE PROCEDURE `CALCOTRASCOMISIONESATEPRO`(
# =====================================================================================
# ----- SP QUE CALCULA OTRAS COMISIONES DE UNA SOLICITUD	 -----------------
# =====================================================================================
	Par_NumTransaccion		BIGINT(8),		-- Numero de Transaccion
    Par_ClienteID			INT(11),		-- Numero de Cliente
    Par_ProductoCreditoID	INT(11),		-- Numero del Producto de Credito
    Par_Monto				DECIMAL(14,1),	-- Monto del Credito
	Par_Tasa				DECIMAL(12,4),	-- Tasa de interes indicada en la simulacion
    Par_PagoCuota           CHAR(1),        -- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)

	Par_Salida          	CHAR(1),		-- Indica si existira una respuesta de salida S:SI  N:NO

    INOUT Par_NumErr    	INT(11),		-- Numero de Error
    INOUT Par_ErrMen    	VARCHAR(400),	-- Mensaje de Error

    # Parametros de Auditoria
    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_CreditoID       BIGINT(12);					-- Variable CreditoID
DECLARE Var_Control			VARCHAR(100);				-- Variable Control
DECLARE Var_SucCliente		INT(11);					-- Indica la Sucursal del Cliente
DECLARE Var_IVASucursal		DECIMAL(14,2);				-- Indica el valor del IVA de la Sucursal del Cliente
DECLARE Var_PagaIVA			CHAR(1);					-- Indica si el cliente paga o no IVA
DECLARE Var_IVAAccesorios	DECIMAL(14,2);				-- Indica el valor del IVA a cobrar por Accesorio

# OTRAS COMISIONES
DECLARE Var_NumCuotas				INT(11);			-- Indica el numero de cuotas de la solicitud/credito
DECLARE Comisiones					DECIMAL(12,2);		-- Comisiones
DECLARE Var_MontoOtrasCom			DECIMAL(12,2);		-- Monto Acumulado Otras Comisiones
DECLARE Var_SaldoOtrasCom			DECIMAL(12,2);		-- Saldo Pendiente Otras Comisiones
DECLARE Var_TotalOtrasComisiones	DECIMAL(12,2);		-- Total Otras Comisiones
DECLARE Var_TotalIVAOtrasCom		DECIMAL(14,2);		-- Total de IVA de Otras Comisiones
DECLARE Var_TotalIntOtrasCom		DECIMAL(14,2);		-- Total de Interes de Otras Comisiones
DECLARE Var_TotalIVAIntOtrCom		DECIMAL(14,2);
DECLARE Contador					INT(11);			-- Contador-Auxiliar
DECLARE Var_PlazoID					INT(11);			-- Identificador del Plazo
DECLARE Var_Credito					BIGINT(12);			-- indica el Credito ID
DECLARE Var_DiasInteres				INT(11);			-- Numero de dias de la vida del credito
DECLARE Var_DiasAnioParam			INT(11);			-- Dias del anio parametrizados
DECLARE FrecSemanal         INT(11);       				-- frecuencia semanal en dias
DECLARE FrecCator           INT(11);       				-- frecuencia Catorcenal en dias
DECLARE FrecQuin            INT(11);       				-- frecuencia en dias quincena
DECLARE FrecMensual         INT(11);       				-- frecuencia mensual
DECLARE FrecBimestral       INT(11);   					-- Frecuencia en dias Bimestral
DECLARE FrecTrimestral      INT(11);   					-- Frecuencia en dias Trimestral
DECLARE FrecTetrames        INT(11);   					-- Frecuencia en dias TetraMestral
DECLARE FrecSemestral       INT(11);   					-- Frecuencia en dias Semestral
DECLARE FrecAnual           INT(11);   					-- frecuencia en dias Anual
DECLARE PagoSemanal         CHAR(1);    				-- Pago Semanal (S)
DECLARE PagoCatorcenal      CHAR(1);    				-- Pago Catorcenal (C)
DECLARE PagoQuincenal       CHAR(1);    				-- Pago Quincenal (Q)
DECLARE PagoMensual         CHAR(1);    				-- Pago Mensual (M)
DECLARE PagoPeriodo         CHAR(1);    				-- Pago por periodo (P)
DECLARE PagoBimestral       CHAR(1);    				-- PagoBimestral (B)
DECLARE PagoTrimestral      CHAR(1);    				-- PagoTrimestral (T)
DECLARE PagoTetrames        CHAR(1);    				-- PagoTetraMestral (R)
DECLARE PagoSemestral       CHAR(1);    				-- PagoSemestral (E)
DECLARE PagoAnual           CHAR(1);    				-- PagoAnual (A)
DECLARE Var_PagoCuota		CHAR(1);
DECLARE Var_ClienteEsp		CHAR(200);
DECLARE Var_ClienteATE		CHAR(200);
DECLARE Var_FechaDiffer		INT(11);

/* Declaracion de Constantes */
DECLARE Estatus_Vigente 	CHAR(1);
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE SiPagaIVA      		CHAR(1); 			-- Constante Paga IVA : S
DECLARE SalidaNO    		CHAR(1);
DECLARE SalidaSI    		CHAR(1);
DECLARE ForCobFinanciado	CHAR(1); 			-- Constante Forma Cobro Financiado : F
DECLARE ForCobMonto 		CHAR(1);			-- Constante Forma Cobro Monto : M
DECLARE ForCobPorcentaje 	CHAR(1);			-- Constante Forma Cobro Porcentaje : P

/* Asignacion de Constantes */
SET Var_ClienteATE		:= '49';
SET Estatus_Vigente 	:= 'V';                 -- Estatus Amortizacion: Vigente
SET Cadena_Vacia    	:= '';                  -- Cadena Vacia
SET Fecha_Vacia     	:= '1900-01-01';        -- Fecha Vacia
SET Entero_Cero     	:= 0;                   -- Entero en Cero
SET Decimal_Cero    	:= 0.00;            	-- DECIMAL Cero
SET SiPagaIVA       	:= 'S';             	-- El Cliente si Paga IVA
SET SalidaNO    		:= 'N';                 -- El store no Arroja una Salida
SET SalidaSI    		:= 'S';                 -- El store no Arroja una Salida
SET ForCobFinanciado	:= 'F';					-- Forma de Cobro del Accesorio: Financiado
SET ForCobMonto 		:= 'M'; 				-- Forma Cobro Monto
SET ForCobPorcentaje 	:= 'P'; 				-- Forma Cobro Porcentaje
SET FrecSemanal         := 7;   				-- frecuencia semanal en dias
SET FrecCator           := 14;  				-- frecuencia Catorcenal en dias
SET FrecQuin            := 15;  				-- frecuencia en dias de quincena
SET FrecMensual         := 30;  				-- frecuencia mesual

SET FrecBimestral       := 60;  				-- Frecuencia en dias Bimestral
SET FrecTrimestral      := 90;  				-- Frecuencia en dias Trimestral
SET FrecTetrames        := 120; 				-- Frecuencia en dias TetraMestral
SET FrecSemestral       := 180; 				-- Frecuencia en dias Semestrals
SET FrecAnual           := 360; 				-- frecuencia en dias Anual
SET PagoSemanal         := 'S'; 				-- PagoSemanal
SET PagoCatorcenal      := 'C'; 				-- PagoCatorcenal
SET PagoQuincenal       := 'Q'; 				-- PagoQuincenal
SET PagoMensual         := 'M'; 				-- PagoMensual
SET PagoPeriodo         := 'P'; 				-- PagoPeriodo
SET PagoBimestral       := 'B'; 				-- PagoBimestral
SET PagoTrimestral      := 'T'; 				-- PagoTrimestral
SET PagoTetrames        := 'R'; 				-- PagoTetraMestral
SET PagoSemestral       := 'E'; 				-- PagoSemestral
SET PagoAnual           := 'A'; 				-- PagoAnual


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  := 999;
		   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  'Disculpe las molestias que esto le ocasiona. Ref: SP-CALCOTRASCOMISIONESATEPRO');
		   SET Var_Control  := 'SQLEXCEPTION';
		END;

		SELECT SucursalOrigen,	PagaIVA	INTO Var_SucCliente, Var_PagaIVA FROM CLIENTES WHERE ClienteID = Par_ClienteID;
        SET Var_IVAAccesorios	:= Decimal_Cero;
        SET Var_PagaIVA			:= IFNULL(Var_PagaIVA, Cadena_Vacia);
        SET Var_SucCliente 		:= IFNULL(Var_SucCliente, Entero_Cero);
		SET Var_IVASucursal		:= (SELECT IFNULL(IVA,Entero_Cero) FROM SUCURSALES	WHERE SucursalID = Aud_Sucursal);

        IF(Var_PagaIVA = SiPagaIVA) THEN
			SET Var_IVAAccesorios := Var_IVASucursal;
        END IF;
		-- VARIABLE PARA DETERMINAR EL NÚMERO DE AMORTIZACIONES POR CREDITO
		SET Var_NumCuotas := (SELECT COUNT(*) FROM TMPPAGAMORSIM WHERE NumTransaccion = Par_NumTransaccion);

        SET Var_Credito := (SELECT MAX(Det.CreditoID) FROM  DETALLEACCESORIOS Det
								INNER JOIN CREDITOS Cre
                                ON Det.CreditoID = Cre.CreditoID
                                AND Cre.ClienteID = Par_ClienteID
                                AND Det.NumTransaccion = Aud_NumTransaccion GROUP BY Det.CreditoID);

		SET Var_Credito := IFNULL(Var_Credito, Entero_Cero);
		-- Obtengo el número de dias reales del plazo del credito

		SELECT ValorParametro INTO Var_ClienteEsp FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico';

		SET Var_ClienteEsp := IFNULL(Var_ClienteEsp,Cadena_Vacia);

		IF (Var_ClienteEsp = Var_ClienteATE) THEN

            CASE Par_PagoCuota
                WHEN PagoSemanal    THEN SET Var_DiasInteres := (FrecSemanal * Var_NumCuotas);
                WHEN PagoCatorcenal THEN SET Var_DiasInteres := (FrecCator * Var_NumCuotas);
                WHEN PagoQuincenal  THEN SET Var_DiasInteres := (FrecQuin * Var_NumCuotas);
                WHEN PagoMensual    THEN SET Var_DiasInteres := (FrecMensual * Var_NumCuotas);
            END CASE;

		ELSE
			SELECT	DATEDIFF(MAX(Tmp_FecFin), MIN(Tmp_FecIni))
			INTO    Var_DiasInteres
			FROM	TMPPAGAMORSIM
			WHERE	NumTransaccion = Aud_NumTransaccion;
		END IF;

		SELECT		DiasCredito
			INTO	Var_DiasAnioParam
			FROM	PARAMETROSSIS;

		SET Var_DiasInteres		:= IFNULL(Var_DiasInteres, Entero_Cero);
		SET Var_DiasAnioParam	:= IFNULL(Var_DiasAnioParam, Entero_Cero);

		SET Contador := 1;

        # SE RECORRE LA TABLA QUE CONTIENE LAS AMORTIZACIONES DEL SIMULADOR PARA ACTUALIZAR EL MONTO TOTA DE OTRAS COMISIONES QUE A COBRAR.
        WHILE (Contador <= Var_NumCuotas) DO

			IF(Var_Credito <> Entero_Cero) THEN

				# SE ACTUALIZA EL MONTO A COBRAR DE ACUERDO AL PORCENTAJE OBTENIDO EN LA TABLA ANTERIOR
				UPDATE DETALLEACCESORIOS DET	SET
					DET.MontoAccesorio		=	CASE WHEN TipoPago	= ForCobMonto THEN  Porcentaje
												WHEN DET.TipoPago 	= ForCobPorcentaje THEN ((Par_Monto * Porcentaje) / 100)
												ELSE ((Par_Monto * Porcentaje) / 100)
											END,
					DET.MontoIVAAccesorio	=	CASE WHEN DET.CobraIVA = SiPagaIVA THEN ROUND(DET.MontoAccesorio * Var_IVAAccesorios,2)
												ELSE Decimal_Cero
											END,
					DET.MontoCuota			= 	CASE WHEN DET.TipoFormaCobro = ForCobFinanciado THEN	ROUND(DET.MontoAccesorio/Var_NumCuotas,2)
												ELSE DET.MontoAccesorio
											END,
					DET.MontoIVACuota		= 	CASE WHEN DET.CobraIVA = SiPagaIVA THEN ROUND(DET.MontoCuota * Var_IVAAccesorios,2)
												ELSE Decimal_Cero
											END,
					DET.MontoInteres		=	CASE WHEN DET.TipoFormaCobro = ForCobFinanciado AND DET.GeneraInteres = SalidaSI AND Par_Tasa > Entero_Cero
												THEN (DET.MontoAccesorio * ((Par_Tasa * Var_DiasInteres) / (Var_DiasAnioParam * 100)))
												ELSE Entero_Cero
											END,
					DET.MontoIVAInteres		=	CASE WHEN DET.CobraIVAInteres = SiPagaIVA THEN ROUND(DET.MontoInteres * Var_IVAAccesorios, 2)
												ELSE Entero_Cero
											END,
					DET.MontoIntCuota		=	CASE WHEN DET.TipoFormaCobro = ForCobFinanciado AND DET.GeneraInteres = SalidaSI AND Par_Tasa > Entero_Cero
												THEN ROUND(DET.MontoInteres / Var_NumCuotas,2)
												ELSE Entero_Cero
											END,
					DET.MontoIVAIntCuota	=	CASE WHEN DET.CobraIVAInteres = SiPagaIVA THEN ROUND(DET.MontoIntCuota * Var_IVAAccesorios, 2)
												ELSE Entero_Cero
											END
				WHERE CreditoID	 		= Var_Credito;

				IF(Contador = Var_NumCuotas)THEN
				UPDATE DETALLEACCESORIOS DET SET
					DET.MontoCuota			= 	( DET.MontoAccesorio - (ROUND(DET.MontoAccesorio/Var_NumCuotas,2) * (Var_NumCuotas - 1))),
					DET.MontoIVACuota       = 	IF (DET.CobraIVA = SalidaNO, Entero_Cero, (DET.MontoIVAAccesorio - (ROUND(DET.MontoIVAAccesorio/Var_NumCuotas,2) * (Var_NumCuotas - 1)))),
					DET.MontoIntCuota  		= 	IF (DET.GeneraInteres = SalidaNO, Entero_Cero, (DET.MontoInteres - (ROUND(DET.MontoInteres/Var_NumCuotas,2) * (Var_NumCuotas - 1)))),
					DET.MontoIVAIntCuota	= 	IF (DET.CobraIVAInteres = SalidaNO, Entero_Cero, (DET.MontoIVAInteres - (ROUND(DET.MontoIVAInteres/Var_NumCuotas,2) * (Var_NumCuotas - 1))))
					WHERE DET.CreditoID = Var_Credito AND DET.AmortizacionID = Contador;
				END IF;

				# MONTO TOTAL DE LOS ACCESORIOS COBRADOS POR SOLICITUD/CREDITO
				SET Var_TotalOtrasComisiones	:= (SELECT SUM(MontoCuota)
													FROM DETALLEACCESORIOS
													WHERE CreditoID 		= Var_Credito
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);
				SET Var_TotalIVAOtrasCom		:= (SELECT SUM(MontoIVACuota)
													FROM DETALLEACCESORIOS
													WHERE CreditoID 		= Var_Credito
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);
				SET Var_TotalOtrasComisiones	:= IFNULL(Var_TotalOtrasComisiones, Decimal_Cero);
				SET Var_TotalIVAOtrasCom		:= IFNULL(Var_TotalIVAOtrasCom, Decimal_Cero);

				SET Var_TotalIntOtrasCom		:= (SELECT ROUND(SUM(MontoIntCuota), 2)
													FROM DETALLEACCESORIOS
													WHERE CreditoID 		= Var_Credito
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);

				SET Var_TotalIVAIntOtrCom		:= (SELECT ROUND(SUM(MontoIVAIntCuota), 2)
													FROM DETALLEACCESORIOS
													WHERE CreditoID 		= Var_Credito
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);

				SET Var_TotalIntOtrasCom		:= IFNULL(Var_TotalIntOtrasCom, Entero_Cero);
				SET Var_TotalIVAIntOtrCom		:= IFNULL(Var_TotalIVAIntOtrCom, Entero_Cero);

			ELSE

				# SE ACTUALIZA EL MONTO A COBRAR DE ACUERDO AL PORCENTAJE OBTENIDO EN LA TABLA ANTERIOR
				UPDATE DETALLEACCESORIOS DET SET
					DET.MontoAccesorio		=	CASE WHEN TipoPago	= ForCobMonto THEN  Porcentaje
												WHEN DET.TipoPago 	= ForCobPorcentaje THEN ((Par_Monto * Porcentaje) / 100)
												ELSE ((Par_Monto * Porcentaje) / 100)
											END,
					DET.MontoIVAAccesorio	=	CASE WHEN DET.CobraIVA = SiPagaIVA THEN ROUND(DET.MontoAccesorio * Var_IVAAccesorios,2)
												ELSE Decimal_Cero
											END,
					DET.MontoCuota			= 	CASE WHEN DET.TipoFormaCobro = ForCobFinanciado THEN	ROUND(DET.MontoAccesorio/Var_NumCuotas,2)
												ELSE DET.MontoAccesorio
											END,
					DET.MontoIVACuota		= 	CASE WHEN DET.CobraIVA = SiPagaIVA THEN ROUND(DET.MontoCuota * Var_IVAAccesorios,2)
												ELSE Decimal_Cero
											END,
					DET.MontoInteres		=	CASE WHEN DET.TipoFormaCobro = ForCobFinanciado AND DET.GeneraInteres = SalidaSI AND Par_Tasa > Entero_Cero
												THEN (DET.MontoAccesorio * ((Par_Tasa * Var_DiasInteres) / (Var_DiasAnioParam * 100)))
												ELSE Entero_Cero
											END,
					DET.MontoIVAInteres		=	CASE WHEN DET.CobraIVAInteres = SiPagaIVA THEN ROUND(DET.MontoInteres * Var_IVAAccesorios, 2)
												ELSE Entero_Cero
											END,
					DET.MontoIntCuota		=	CASE WHEN DET.TipoFormaCobro = ForCobFinanciado AND DET.GeneraInteres = SalidaSI AND Par_Tasa > Entero_Cero
												THEN ROUND(DET.MontoInteres / Var_NumCuotas,2)
												ELSE Entero_Cero
											END,
					DET.MontoIVAIntCuota	=	CASE WHEN DET.CobraIVAInteres = SiPagaIVA THEN ROUND(DET.MontoIntCuota * Var_IVAAccesorios, 2)
												ELSE Entero_Cero
											END
				WHERE DET.NumTransacSim 	= Aud_NumTransaccion;

				IF(Contador = Var_NumCuotas)THEN
				UPDATE DETALLEACCESORIOS DET SET
					DET.MontoCuota			= 	( DET.MontoAccesorio - (ROUND(DET.MontoAccesorio/Var_NumCuotas,2) * (Var_NumCuotas - 1))),
					DET.MontoIVACuota       = 	IF (DET.CobraIVA = SalidaNO, Entero_Cero, (DET.MontoIVAAccesorio - (ROUND(DET.MontoIVAAccesorio/Var_NumCuotas,2) * (Var_NumCuotas - 1)))),
					DET.MontoIntCuota  		= 	IF (DET.GeneraInteres = SalidaNO, Entero_Cero, (DET.MontoInteres - (ROUND(DET.MontoInteres/Var_NumCuotas,2) * (Var_NumCuotas - 1)))),
					DET.MontoIVAIntCuota	= 	IF (DET.CobraIVAInteres = SalidaNO, Entero_Cero, (DET.MontoIVAInteres - (ROUND(DET.MontoIVAInteres/Var_NumCuotas,2) * (Var_NumCuotas - 1))))
					WHERE DET.NumTransacSim = Aud_NumTransaccion AND DET.AmortizacionID = Contador;
				END IF;

				# MONTO TOTAL DE LOS ACCESORIOS COBRADOS POR SOLICITUD/CREDITO
				SET Var_TotalOtrasComisiones	:= (SELECT SUM(MontoCuota)
													FROM DETALLEACCESORIOS
													WHERE NumTransacSim 	= Aud_NumTransaccion
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);
				SET Var_TotalIVAOtrasCom		:= (SELECT SUM(MontoIVACuota)
													FROM DETALLEACCESORIOS
													WHERE NumTransacSim	 	= Aud_NumTransaccion
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);

				SET Var_TotalOtrasComisiones	:= IFNULL(Var_TotalOtrasComisiones, Decimal_Cero);
				SET Var_TotalIVAOtrasCom		:= IFNULL(Var_TotalIVAOtrasCom, Decimal_Cero);

				SET Var_TotalIntOtrasCom		:= (SELECT ROUND(SUM(MontoIntCuota), 2)
													FROM DETALLEACCESORIOS
													WHERE NumTransacSim 	= Aud_NumTransaccion
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);

				SET Var_TotalIVAIntOtrCom		:= (SELECT ROUND(SUM(MontoIVAIntCuota), 2)
													FROM DETALLEACCESORIOS
													WHERE NumTransacSim	 	= Aud_NumTransaccion
														AND TipoFormaCobro 	= ForCobFinanciado
														AND AmortizacionID 	= Contador);

				SET Var_TotalIntOtrasCom		:= IFNULL(Var_TotalIntOtrasCom, Entero_Cero);
				SET Var_TotalIVAIntOtrCom		:= IFNULL(Var_TotalIVAIntOtrCom, Entero_Cero);

			END IF;

			# SE LE SETEA A LA VARIABLE EL MONTO TOTAL DE LOS ACCESORIOS COBRADOS POR SOLICITUD-CREDITO
			SET Var_SaldoOtrasCom			:= Var_TotalOtrasComisiones;
			SET Var_SaldoOtrasCom			:= IFNULL(Var_SaldoOtrasCom, Decimal_Cero);

			UPDATE 	TMPPAGAMORSIM SET
					Tmp_OtrasComisiones = Var_TotalOtrasComisiones,
                    Tmp_IVAOtrasComisiones = Var_TotalIVAOtrasCom,
                    Tmp_InteresOtrasComisiones = Var_TotalIntOtrasCom,
                    Tmp_IVAInteresOtrasComisiones = Var_TotalIVAIntOtrCom,
                    Tmp_SubTotal	= Tmp_SubTotal + Var_TotalOtrasComisiones + Var_TotalIVAOtrasCom + Var_TotalIntOtrasCom + Var_TotalIVAIntOtrCom
			WHERE	Tmp_Consecutivo = Contador
			AND		NumTransaccion	= Par_NumTransaccion;

			SET Contador := Contador + 1;
        END WHILE;


		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Comision Generada Exitosamente';
END ManejoErrores;  # END del Handler de Errores

IF(Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
			Par_ErrMen 		AS ErrMen,
			Var_Control	 	AS control,
			Var_Credito 	AS consecutivo;
END IF;

END TerminaStore$$
