-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONCAPCAPAMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONCAPCAPAMORPRO`;
DELIMITER $$


CREATE PROCEDURE `FONCAPCAPAMORPRO`(
	/* SP que simula cuotas de pagos iguales de  capital
	-- SE Utiliza solo si hay capitalizacion
	-- se utiliza en el CREDITO PASIVO */
	Par_Monto				DECIMAL(12,2),		#Monto a prestar
	Par_Tasa				DECIMAL(12,4),		#Tasa Anualizada
	Par_Frecu				INT(11),			-- Frecuencia del pago Capital en Dias (si el pago es Periodo)
	Par_FrecuInt			INT(11),			-- Frecuencia del pago interes en Dias (si el pago es Periodo)
	Par_PagoCuota			CHAR(1),			-- Pago de la cuota capital (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)

	Par_PagoInter			CHAR(1),			-- Pago de la cuota de Intereses  (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
	Par_PagoFinAni			CHAR(1),			-- solo si el Pago es (M B T R E) indica si es fin de mes (F) o por aniversario (A)
	Par_PagoFinAniInt		CHAR(1),			-- solo si el Pago es (M B T R E) indica si es fin de mes (F) o por aniversario (A) para los intereses
	Par_FechaInicio			DATE,			    -- fecha en que empiezan los pagos
	Par_NumCuotasInt		INT(11),			-- Numero de Cuotas que se simularan para interes

	Par_DiaHabilSig			CHAR(1),			-- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
	Par_AjustaFecAmo		CHAR(1),			-- Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
	Par_AjusFecExiVen		CHAR (1),			-- Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
	Par_DiaMesInt			INT(11),			-- solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para los intereses
	Par_DiaMesCap			INT(11),			-- solo si el Pago es (M B T R E) indica indica el dia de pago del mes (1 al 31) para el capital

	Par_PagaIVA				CHAR(1),			-- indica si paga IVA valores :  Si = "S" / No = "N")
	Par_IVA					DECIMAL(12,4),		-- indica el valor del iva si es que Paga IVA = si
	Par_CobraISR			CHAR(1),			/* Indica si cobra o no ISR Si = S No = N */
	Par_TasaISR				DECIMAL(12,2),		/* Tasa del ISR*/
	Par_MargenPriCuota		INT(11),			/* Margen para calcular la primer cuota */

	Par_Salida    			CHAR(1),			-- Indica si hay una salida o no
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(350),

	INOUT	Par_NumTran		BIGINT(20),			-- Numero de transaccion con el que se genero el calendario de pagos
	INOUT 	Par_Cuotas		INT(11),			-- devuelve el numero de cuotas de Capital
	INOUT 	Par_CuotasInt	INT(11),			-- devuelve el numero de cuotas de Interes
	INOUT	Par_MontoCuo	DECIMAL(14,4),		-- corresponde con la cuota promedio a pagar
	INOUT	Par_FechaVen 	DATE,				-- corresponde con la fecha final que genere el cotizador

    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Entero_Cero			INT;
	DECLARE Entero_Uno			INT;
	DECLARE Entero_Negativo		INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Var_SI				CHAR(1);	-- SI
	DECLARE Var_No				CHAR(1);	-- NO
	DECLARE PagoSemanal			CHAR(1);	-- Pago Semanal (S)
	DECLARE PagoCatorcenal		CHAR(1);	-- Pago Catorcenal (C)
	DECLARE PagoQuincenal		CHAR(1);	-- Pago Quincenal (Q)
	DECLARE PagoMensual			CHAR(1);	-- Pago Mensual (M)
	DECLARE PagoPeriodo			CHAR(1);	-- Pago por periodo (P)
	DECLARE PagoBimestral		CHAR(1);	-- PagoBimestral (B)
	DECLARE PagoTrimestral		CHAR(1);	-- PagoTrimestral (T)
	DECLARE PagoTetrames		CHAR(1);	-- PagoTetraMestral (R)
	DECLARE PagoSemestral		CHAR(1);	-- PagoSemestral (E)
	DECLARE PagoAnual			CHAR(1);	-- PagoAnual (A)
	DECLARE PagoUnico			CHAR(1);	-- Pago Unico (U)
	DECLARE PagoFinMes			CHAR(1);	-- Pago al final del mes (F)
	DECLARE PagoAniver			CHAR(1);	-- Pago por aniversario (A)
	DECLARE FrecSemanal			INT;		-- frecuencia semanal en dias
	DECLARE FrecCator			INT;		-- frecuencia Catorcenal en dias
	DECLARE FrecQuin			INT;		-- frecuencia en dias quincena
	DECLARE FrecMensual			INT;		-- frecuencia mensual
	DECLARE FrecBimestral		INT;		-- Frecuencia en dias Bimestral
	DECLARE FrecTrimestral		INT;		-- Frecuencia en dias Trimestral
	DECLARE FrecTetrames		INT;		-- Frecuencia en dias TetraMestral
	DECLARE FrecSemestral		INT;		-- Frecuencia en dias Semestral
	DECLARE FrecAnual			INT;		-- frecuencia en dias Anual
	DECLARE Var_Capital			CHAR(1);	-- Bandera que me indica que se trata de un pago de capital
	DECLARE Var_Interes			CHAR(1);	-- Bandera que me indica que se trata de un pago de interes
	DECLARE Var_CapInt			CHAR(1);	-- Bandera que me indica que se trata de un pago de capital y de interes
	DECLARE Var_TipoCap			CHAR(1);	-- Bandera que me indica que se trata de un pago de capital y de interes
	DECLARE ComApDeduc	 		CHAR(1);
	DECLARE ComApFinan	 		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);


	-- Declaracion de Variables
	DECLARE Var_UltDia			INT;
	DECLARE Contador			INT;
	DECLARE Consecutivo			INT;
	DECLARE ContadorInt			INT;
	DECLARE ContadorCap			INT;
	DECLARE FechaInicio			DATE;
	DECLARE FechaFinal			DATE;
	DECLARE FechaInicioInt		DATE;
	DECLARE FechaFinalInt		DATE;
	DECLARE FechaVig			DATE;
	DECLARE Par_FechaVenc		DATE;		-- fecha vencimiento en que terminan los pagos
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_Cuotas			INT;
	DECLARE Var_CuotasInt		INT;
	DECLARE Var_Amor			INT;
	DECLARE Capital				DECIMAL(12,2);
	DECLARE Interes				DECIMAL(12,4);
	DECLARE IvaInt				DECIMAL(12,4);
	DECLARE Subtotal			DECIMAL(12,2);
	DECLARE Insoluto			DECIMAL(12,2);
	DECLARE Var_IVA				DECIMAL(12,4);
	DECLARE Fre_DiasAnio		INT;		-- dias del año
	DECLARE Fre_Dias			INT;		-- numero de dias para pagos de capital
	DECLARE Fre_DiasTab			INT;		-- numero de dias para pagos de capital
	DECLARE Fre_DiasInt			INT;		-- numero de dias para pagos de interes
	DECLARE Fre_DiasIntTab		INT;		-- numero de dias para pagos de interes
	DECLARE Var_GraciaFaltaPag	INT;		-- dias de gracia
	DECLARE Var_ProCobIva		CHAR(1); 	-- Producto cobra Iva S si N no
	DECLARE Var_CtePagIva		CHAR(1);	-- Cliente Paga Iva S si N no
	DECLARE Var_PagaIVA			CHAR(1);
	DECLARE CapInt				CHAR(1);
	DECLARE Var_InteresAco		DECIMAL(12,4);
	DECLARE Var_IvaAco			DECIMAL(12,4);
	DECLARE Var_CoutasAmor		VARCHAR(8000);
	DECLARE Var_CAT 	     	DECIMAL(12,4);
	DECLARE Var_FrecuPago		INT;
	DECLARE MtoSinComAp			DECIMAL(12,2);
	DECLARE CuotaSinIva			DECIMAL(12,2);
	DECLARE Var_TotalCap		DECIMAL(14,2);
	DECLARE Var_TotalInt		DECIMAL(14,2);
	DECLARE Var_TotalIva		DECIMAL(14,2);
	DECLARE Var_GraciaPag		INT;		-- dias de gracia
	DECLARE Var_TasaISR			DECIMAL(12,2); 		/* tasa de ISR */
	DECLARE Var_Retencion		DECIMAL(14,2); 		/* monto de ISR */
	DECLARE Var_SumCapital		DECIMAL(14,2); 		/* suma de Capital*/
	DECLARE Var_SumInteres		DECIMAL(14,2); 		/* suma de Interes*/
	DECLARE Var_SumIVAInt		DECIMAL(14,2); 		/* suma de IVA de Interes*/
	DECLARE Var_SumReten		DECIMAL(14,2); 		/* suma de Retencion*/

	-- asignacion de constantes
	SET Decimal_Cero		:= 0.00;
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Cadena_Vacia		:= '';
	SET Var_SI				:= 'S';
	SET Var_No				:= 'N';
	SET PagoSemanal			:= 'S'; -- PagoSemanal
	SET PagoCatorcenal		:= 'C'; -- PagoCatorcenal
	SET PagoQuincenal		:= 'Q'; -- PagoQuincenal
	SET PagoMensual			:= 'M'; -- PagoMensual
	SET PagoPeriodo			:= 'P'; -- PagoPeriodo
	SET PagoBimestral		:= 'B'; -- PagoBimestral
	SET PagoTrimestral		:= 'T'; -- PagoTrimestral
	SET PagoTetrames		:= 'R'; -- PagoTetraMestral
	SET PagoSemestral		:= 'E'; -- PagoSemestral
	SET PagoAnual			:= 'A'; -- PagoAnual
	SET PagoFinMes			:= 'F'; -- PagoFinMes
	SET PagoAniver			:= 'A'; -- Pago por aniversario
	SET PagoUnico			:= 'U'; -- Pago Unico (U)
	SET Salida_SI 	   		:= 'S';
	SET FrecSemanal			:= 7;	-- frecuencia semanal en dias
	SET FrecCator			:= 14;	-- frecuencia Catorcenal en dias
	SET FrecQuin			:= 15;	-- frecuencia en dias de quincena
	SET FrecMensual			:= 30;	-- frecuencia mesual

	SET FrecBimestral		:= 60;	-- Frecuencia en dias Bimestral
	SET FrecTrimestral		:= 90;	-- Frecuencia en dias Trimestral
	SET FrecTetrames		:= 120;	-- Frecuencia en dias TetraMestral
	SET FrecSemestral		:= 180;	-- Frecuencia en dias Semestral
	SET FrecAnual			:= 360;	-- frecuencia en dias Anual
	SET Var_Capital			:= 'C';	-- Bandera que me indica que se trata de un pago de capital
	SET Var_Interes			:= 'I';	-- Bandera que me indica que se trata de un pago de interes
	SET Var_CapInt			:= 'G';	-- Bandera que me indica que se trata de un pago de capital y de interes
	SET ComApDeduc			:= 'D';
	SET ComApFinan			:= 'F';

	-- asignacion de variables
	SET Contador			:= 1;
	SET ContadorInt			:= 1;
	SET FechaInicio			:= Par_FechaInicio;
	SET FechaInicioInt		:= Par_FechaInicio;
	SET Var_IVA				:= (SELECT IVA FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
	SET Fre_DiasAnio		:= (SELECT DiasCredito FROM PARAMETROSSIS);
	SET Var_CoutasAmor		:= '';
	SET Var_CAT				:= 0.0000;
	SET Var_FrecuPago		:= 0;
	SET MtoSinComAp			:= 0.00;
	SET CuotaSinIva			:= 0;

	IF ( Par_PagoCuota = PagoPeriodo) THEN
		IF(IFNULL(Par_Frecu, Entero_Cero))= Entero_Cero THEN
			IF (Par_Salida = Salida_SI) THEN
				SELECT	'001' AS Par_NumErr,
						'Especificar Frecuencia Pago.',
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,

						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,

						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,

						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo;
			ELSE
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Especificar Frecuencia Pago.';
			END IF ;
			LEAVE TerminaStore;
		END IF ;
	END IF ;



	IF ( Par_PagoInter = PagoPeriodo) THEN
		IF(IFNULL(Par_FrecuInt, Entero_Cero))= Entero_Cero THEN
			IF (Par_Salida = Salida_SI) THEN
				SELECT	'001' AS Par_NumErr,
						'Especificar Frecuencia Pago.',
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,

						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,

						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,

						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo,
						Entero_Cero AS consecutivo;
			ELSE
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Especificar Frecuencia Pago.';
			END IF ;
			LEAVE TerminaStore;
		END IF ;
	END IF ;

	IF(IFNULL(Par_Monto, Decimal_Cero))= Decimal_Cero THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT	'001' AS Par_NumErr,
					'El monto esta Vacio.',
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo;
		ELSE
			SET Par_NumErr 	:= 1;
			SET Par_ErrMen 	:= 'El monto solicitado esta Vacio.';
		END IF;
		LEAVE TerminaStore;
	ELSE
		IF(Par_Monto < Entero_Cero)THEN
			IF (Par_Salida = Salida_SI) THEN
				SELECT '001' AS Par_NumErr,
					'El monto no puede ser negativo.' AS Par_ErrMen,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo;
			ELSE
				SET Par_NumErr 	:= 9;
				SET Par_ErrMen 	:= 'El monto no puede ser negativo.';
			END IF;
			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(IFNULL(Par_NumCuotasInt, Entero_Cero))= Entero_Cero THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT	'001' AS Par_NumErr,
					'Especificar Numero de Cuotas de Interes.',
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,

					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo,
					Entero_Cero AS consecutivo;
		ELSE
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'Especificar Numero de Cuotas de Interes.';
		END IF ;
		LEAVE TerminaStore;
	END IF ;


	/*el pago de la cuota de capital solo puede ser pago unico */
	SET Par_PagoCuota	:= PagoUnico;
	SET Fre_Dias		:=  Par_Frecu;
	SET Var_GraciaPag	:= 0;

	-- se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad
	CASE Par_PagoInter
		WHEN PagoSemanal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*FrecSemanal DAY));
		WHEN PagoCatorcenal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*FrecCator DAY));
		WHEN PagoQuincenal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*FrecQuin DAY));
		WHEN PagoMensual	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt MONTH));
		WHEN PagoPeriodo	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*Par_FrecuInt DAY));
		WHEN PagoBimestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*2 MONTH));
		WHEN PagoTrimestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*3 MONTH));
		WHEN PagoTetrames	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*4 MONTH));
		WHEN PagoSemestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*6 MONTH));
		WHEN PagoAnual		THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt YEAR));
		WHEN PagoUnico		THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumCuotasInt*Par_FrecuInt  DAY));
	END CASE;

	IF (Par_PagaIVA = Var_Si) THEN
		SET Var_IVA	:= IFNULL(Par_IVA/100,Decimal_Cero);
	ELSE
		SET Var_IVA	:= Decimal_Cero;
	END IF;

	/*Compara el valor de pago de la cuota para asiganrle un valor en dias*/
	CASE Par_PagoCuota
		WHEN PagoSemanal	THEN SET Fre_Dias	:=  FrecSemanal; SET Var_GraciaFaltaPag:= 5;
		WHEN PagoCatorcenal	THEN SET Fre_Dias	:=  FrecCator; SET Var_GraciaFaltaPag:= 10;
		WHEN PagoQuincenal	THEN SET Fre_Dias	:=  FrecQuin; SET Var_GraciaFaltaPag:= 10;
		WHEN PagoMensual	THEN SET Fre_Dias	:=  FrecMensual; SET Var_GraciaFaltaPag:= 20;
		WHEN PagoPeriodo	THEN SET Fre_Dias 	:=  Par_Frecu;
		WHEN PagoBimestral	THEN SET Fre_Dias	:=  FrecBimestral; SET Var_GraciaFaltaPag:= 40;
		WHEN PagoTrimestral	THEN SET Fre_Dias	:=  FrecTrimestral; SET Var_GraciaFaltaPag:= 60;
		WHEN PagoTetrames	THEN SET Fre_Dias	:=  FrecTetrames;	SET Var_GraciaFaltaPag:= 80;
		WHEN PagoSemestral	THEN SET Fre_Dias	:=  FrecSemestral; SET Var_GraciaFaltaPag:= 120;
		WHEN PagoAnual		THEN SET Fre_Dias	:=  FrecAnual; SET Var_GraciaFaltaPag:= 240;
		WHEN PagoUnico		THEN SET Fre_Dias	:=  Par_Frecu; SET Var_GraciaFaltaPag:= 0;
	END CASE;

	SET  Var_FrecuPago = Fre_Dias;
	-- ASIGNA EL VALOR QUE LE CORRESPONDE EN FRECUENCIA EN DIAS SEGUN EL TIPO DE PAGO PARA INTERESES
	CASE Par_PagoInter
		WHEN PagoSemanal	THEN SET Fre_DiasInt	:=  FrecSemanal;	SET Var_GraciaFaltaPag:= 5;
		WHEN PagoCatorcenal	THEN SET Fre_DiasInt	:=  FrecCator; 		SET Var_GraciaFaltaPag:= 10;
		WHEN PagoQuincenal	THEN SET Fre_DiasInt	:=  FrecQuin; 		SET Var_GraciaFaltaPag:= 10;
		WHEN PagoMensual	THEN SET Fre_DiasInt	:=  FrecMensual; 	SET Var_GraciaFaltaPag:= 20;
		WHEN PagoPeriodo	THEN SET Fre_DiasInt 	:=  Par_FrecuInt;
		WHEN PagoBimestral	THEN SET Fre_DiasInt	:=  FrecBimestral;	SET Var_GraciaFaltaPag:= 40;
		WHEN PagoTrimestral	THEN SET Fre_DiasInt	:=  FrecTrimestral;	SET Var_GraciaFaltaPag:= 60;
		WHEN PagoTetrames	THEN SET Fre_DiasInt	:=  FrecTetrames;	SET Var_GraciaFaltaPag:= 80;
		WHEN PagoSemestral	THEN SET Fre_DiasInt	:=  FrecSemestral;	SET Var_GraciaFaltaPag:= 120;
		WHEN PagoAnual		THEN SET Fre_DiasInt	:=  FrecAnual;		SET Var_GraciaFaltaPag:= 240;
		WHEN PagoUnico		THEN SET Fre_DiasInt	:=  Par_Frecu; 		SET Var_GraciaFaltaPag:= 0;
	END CASE;

	SET Var_Cuotas		:= 1;
	SET Var_CuotasInt	:= Par_NumCuotasInt;
	SET Capital			:= IF(Var_Cuotas != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
	SET Insoluto		:= Par_Monto;

	DROP TABLE IF EXISTS Tmp_Amortizacion;
	DROP TABLE IF EXISTS Tmp_AmortizacionInt;

	-- tabla temporal donde inserta las fechas de pago de capital
	CREATE TEMPORARY TABLE Tmp_Amortizacion(
		Tmp_Consecutivo	INT,
		Tmp_Dias		INT,
		Tmp_FecIni		DATE,
		Tmp_FecFin		DATE,
		Tmp_FecVig		DATE,
		Tmp_Capital		DECIMAL(12,2),
		Tmp_Interes		DECIMAL(12,4),
		Tmp_iva			DECIMAL(12,4),
		Tmp_SubTotal	DECIMAL(12,2),
		Tmp_Insoluto	DECIMAL(12,2),
		Tmp_CapInt		CHAR(1),
		Tmp_InteresAco 	DECIMAL(12,2),
		PRIMARY KEY  (Tmp_Consecutivo));

	-- tabla temporal donde inserta las fechas de pago de intereses
	CREATE TEMPORARY TABLE Tmp_AmortizacionInt(
		Tmp_Consecutivo	INT,
		Tmp_Dias		INT,
		Tmp_FecIni		DATE,
		Tmp_FecFin		DATE,
		Tmp_FecVig		DATE,
		Tmp_Capital		DECIMAL(12,2),
		Tmp_Interes		DECIMAL(12,4),
		Tmp_iva			DECIMAL(12,4),
		Tmp_SubTotal	DECIMAL(12,2),
		Tmp_Insoluto	DECIMAL(12,2),
		Tmp_CapInt		CHAR(1),
		Tmp_InteresAco 	DECIMAL(12,2),
		PRIMARY KEY  (Tmp_Consecutivo));

	/* -- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE CAPITAL*/
	WHILE (Contador <= Var_Cuotas) DO
		-- pagos quincenales
		IF (Par_PagoCuota = PagoQuincenal) THEN
			IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) = FrecQuin) THEN
				SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
			ELSE
				IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) >28) THEN
					SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
										CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
				ELSE
					SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
					IF  (FechaFinal <= FechaInicio) THEN
						SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
					END	IF;
				END IF;
			END IF;
		ELSE
			-- Pagos Mensuales
			IF (Par_PagoCuota = PagoMensual) THEN
				-- Para pagos que se haran cada 30 dias
				IF (Par_PagoFinAni != PagoFinMes) THEN
					IF(Par_DiaMesCap>28)THEN
						SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
						SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
						IF(Var_UltDia < Par_DiaMesCap)THEN
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

						ELSE
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
						END IF;
					ELSE
						SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
					END IF;
				ELSE
					-- Para pagos que se haran cada fin de mes
					IF (Par_PagoFinAni = PagoFinMes) THEN
						/* se obtiene el final del mes.*/
						SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
					END IF;
				END IF;
			ELSE
				 IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
					  SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);

				 ELSE

					IF (Par_PagoCuota = PagoBimestral ) THEN
						IF (Par_PagoFinAni != PagoFinMes ) THEN
							IF(Par_DiaMesCap>28)THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
								SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
								IF(Var_UltDia < Par_DiaMesCap)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
							ELSE
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran en fin de mes
							IF (Par_PagoFinAni = PagoFinMes) THEN
								IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
									SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 3 MONTH),CHAR(12));
									SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
								ELSE
									SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
								END IF;
							END IF;
						END IF;
					ELSE
						IF (Par_PagoCuota = PagoTrimestral ) THEN
							-- Para pagos que se haran cada 90 dias
							IF (Par_PagoFinAni != PagoFinMes) THEN
	--
								IF(Par_DiaMesCap>28)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesCap)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
	--
							 ELSE
								-- Para pagos que se haran en fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
										SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 4 MONTH),CHAR(12));
										SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
									ELSE
										SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
									END IF;
								 END IF;
							 END IF;

						ELSE
							IF (Par_PagoCuota = PagoTetrames ) THEN
								-- Para pagos que se haran cada 120 dias
								IF (Par_PagoFinAni != PagoFinMes) THEN
									IF(Par_DiaMesCap>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesCap)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAni = PagoFinMes) THEN
										IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
											SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 5 MONTH),CHAR(12));
											SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
										ELSE
											SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
										END IF;
									END IF;
								END IF;

							ELSE
								IF (Par_PagoCuota = PagoSemestral ) THEN
									-- Para pagos que se haran cada 180 dias
									IF (Par_PagoFinAni != PagoFinMes) THEN
										IF(Par_DiaMesCap>28)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesCap)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;

									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAni = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
												SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 7 MONTH),CHAR(12));
												SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									IF (Par_PagoCuota = PagoAnual ) THEN
										-- Para pagos que se haran cada 360 dias
										SET FechaFinal 	:= CONVERT(DATE_ADD(FechaInicio, INTERVAL 1 YEAR),CHAR(12));
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			 END IF;
		 END IF;



		IF(Par_DiaHabilSig = Var_SI) THEN
			CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		ELSE
			CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		IF(Contador=1)THEN
			SET Var_GraciaFaltaPag := Par_MargenPriCuota;
		ELSE
			SET Var_GraciaFaltaPag := Var_GraciaPag;
		END IF;

		-- hace un ciclo para comparar los dias de gracia
		WHILE ((CAST(DATEDIFF(FechaVig, FechaInicio) AS SIGNED)*1) <= Var_GraciaFaltaPag ) DO
			IF (Par_PagoCuota = PagoQuincenal ) THEN
				IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) = FrecQuin) THEN
					SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
				ELSE
					IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) >28) THEN
						SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
											CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
					ELSE
						SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
						IF  (FechaFinal <= FechaInicio) THEN
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						END	IF;
					END IF;
				END IF;
			ELSE
			-- Pagos Mensuales
				IF (Par_PagoCuota = PagoMensual  ) THEN
					IF (Par_PagoFinAni != PagoFinMes) THEN
						IF(Par_DiaMesCap>28)THEN
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
							SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
							IF(Var_UltDia < Par_DiaMesCap)THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

							ELSE
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
							END IF;
						ELSE
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
						END IF;
					ELSE
						-- Para pagos que se haran cada fin de mes
						IF (Par_PagoFinAni = PagoFinMes) THEN
							IF ((CAST(DAY(FechaFinal) AS SIGNED)*1)>=28)THEN
								SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL 2 MONTH),CHAR(12));
								SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
							ELSE
							-- si no indica que es un numero menor y se obtiene el final del mes.
								SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY),CHAR(12));
							END IF;
						END IF;
					END IF ;
				ELSE
					IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
						SET FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
					END IF;
				END IF;
			END IF;
			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			ELSE
				CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		END WHILE;

		/* si el valor de la fecha final es mayoy a la de vencimiento en se ajusta */
		IF (Par_AjustaFecAmo = Var_SI)THEN
			IF (Par_FechaVenc <=  FechaFinal) THEN
				SET FechaFinal 	:= Par_FechaVenc;
			END IF;
			IF (Contador = Var_Cuotas )THEN
				SET FechaFinal 	:= Par_FechaVenc;
			END IF;
		END IF;

		IF(Par_DiaHabilSig = Var_SI) THEN
			CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		ELSE
			CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		/* valida si se ajusta a fecha de exigibilidad o no*/
		IF (Par_AjusFecExiVen= Var_SI)THEN
			SET FechaFinal:= FechaVig;
		END IF;

		SET CapInt:= Var_Capital;

		SET Consecutivo := (SELECT IFNULL(MAX(Tmp_Consecutivo),Entero_Cero) + 1
						FROM Tmp_Amortizacion);

		SET Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));

		INSERT INTO Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
						VALUES	(	Consecutivo,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);
		SET FechaInicio := FechaFinal;/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
		IF (Par_AjustaFecAmo = Var_SI)THEN
			IF (Par_FechaVenc <=  FechaFinal) THEN
				SET Contador 	:= Var_Cuotas+1;
			END IF;
		END IF;

		IF((Contador+1) = Var_Cuotas )THEN

			#Ajuste Saldo
			-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
			IF (Par_AjustaFecAmo = Var_SI)THEN
				SET FechaFinal 	:= Par_FechaVenc;
			ELSE
				-- pagos quincenales
				IF (Par_PagoCuota = PagoQuincenal) THEN
					IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) = FrecQuin) THEN
						SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
					ELSE
						IF ((CAST(DAY(FechaInicio) AS SIGNED)*1) >28) THEN
							SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						ELSE
							SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
							IF  (FechaFinal <= FechaInicio) THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							END	IF;
						END IF;
					END IF;
				ELSE 		-- Pagos Mensuales
					IF (Par_PagoCuota = PagoMensual) THEN
						-- Para pagos que se haran cada 30 dias
						IF (Par_PagoFinAni != PagoFinMes) THEN
							IF(Par_DiaMesCap>28)THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
								SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
								IF(Var_UltDia < Par_DiaMesCap)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
							ELSE
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran cada fin de mes
							IF (Par_PagoFinAni = PagoFinMes) THEN
								IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
									SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 2 MONTH),CHAR(12));
									SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
								ELSE
								-- si no indica que es un numero menor y se obtiene el final del mes.
									SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
								END IF;
							END IF;
						END IF;
					ELSE
						IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
							SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
						ELSE
							IF (Par_PagoCuota = PagoBimestral ) THEN
								IF (Par_PagoFinAni != PagoFinMes ) THEN
									IF(Par_DiaMesCap>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesCap)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAni = PagoFinMes) THEN
										IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
											SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 3 MONTH),CHAR(12));
											SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
										ELSE
											SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
										END IF;
									END IF;
								END IF;
							ELSE
								IF (Par_PagoCuota = PagoTrimestral ) THEN
									-- Para pagos que se haran cada 90 dias
									IF (Par_PagoFinAni != PagoFinMes) THEN
										IF(Par_DiaMesCap>28)THEN
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesCap)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAni = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
												SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 4 MONTH),CHAR(12));
												SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;

								ELSE
									IF (Par_PagoCuota = PagoTetrames ) THEN
										-- Para pagos que se haran cada 120 dias
										IF (Par_PagoFinAni != PagoFinMes) THEN
											IF(Par_DiaMesCap>28)THEN
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesCap)THEN
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
												END IF;
											ELSE
												SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
											END IF;
										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAni = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
													SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 5 MONTH),CHAR(12));
													SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;

									ELSE
										IF (Par_PagoCuota = PagoSemestral ) THEN
											-- Para pagos que se haran cada 180 dias
											IF (Par_PagoFinAni != PagoFinMes) THEN
												IF(Par_DiaMesCap>28)THEN
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesCap)THEN
														SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

													ELSE
														SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
													END IF;
												ELSE
													SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
												END IF;
											ELSE
												-- Para pagos que se haran en fin de mes
												IF (Par_PagoFinAni = PagoFinMes) THEN
													IF ((CAST(DAY(FechaInicio) AS SIGNED)*1)>=28)THEN
														SET FechaFinal := CONVERT(DATE_ADD(FechaInicio, INTERVAL 7 MONTH),CHAR(12));
														SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
													ELSE
														SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY),CHAR(12));
													END IF;
												END IF;
											END IF;

										ELSE
											IF (Par_PagoCuota = PagoAnual ) THEN
												-- Para pagos que se haran cada 360 dias
												SET FechaFinal 	:= CONVERT(DATE_ADD(FechaInicio, INTERVAL 1 YEAR),CHAR(12));
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;

				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

				IF(Contador=1)THEN
					SET Var_GraciaFaltaPag := Par_MargenPriCuota;
				ELSE
					SET Var_GraciaFaltaPag := Var_GraciaPag;
				END IF;
				-- hace un ciclo para comparar los dias de gracia
				WHILE ((DATEDIFF(FechaVig, FechaInicio)*1) <= Var_GraciaFaltaPag ) DO
					IF (Par_PagoCuota = PagoQuincenal ) THEN
						IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) = FrecQuin) THEN
							SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
						ELSE
							IF ((CAST(DAY(FechaFinal) AS SIGNED)*1) >28) THEN
								SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							ELSE
								SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
								IF  (FechaFinal <= FechaInicio) THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
								END	IF;
							END IF;
						END IF;
					ELSE
					-- Pagos Mensuales
						IF (Par_PagoCuota = PagoMensual  ) THEN
							IF (Par_PagoFinAni != PagoFinMes) THEN
								IF(Par_DiaMesCap>28)THEN
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinal)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesCap)THEN
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

									ELSE
										SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
									END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesCap),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran cada fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									IF ((CAST(DAY(FechaFinal) AS SIGNED)*1)>=28)THEN
										SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL 2 MONTH),CHAR(12));
										SET FechaFinal := CONVERT(DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal) AS SIGNED) DAY),CHAR(12));
									ELSE
									-- si no indica que es un numero menor y se obtiene el final del mes.
										SET FechaFinal:= CONVERT(DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY),CHAR(12));
									END IF;
								END IF;
							END IF ;
						ELSE
							IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
								SET FechaFinal:= DATE_ADD(FechaFinal, INTERVAL Fre_Dias DAY);
							END IF;
						END IF;
					END IF;
					IF(Par_DiaHabilSig = Var_SI) THEN
						CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
											Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
											Aud_NumTransaccion);

					ELSE
						CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
					END IF;
				END WHILE;
			END IF;
			-- Obtiene el dia habil siguiente o anterior
			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);

			ELSE
				CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
			/* valida si se ajusta a fecha de exigibilidad o no*/
			IF (Par_AjusFecExiVen= Var_SI)THEN
				SET FechaFinal:= FechaVig;
			END IF;
			SET CapInt:= Var_Capital;
			SET Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));
			INSERT INTO Tmp_Amortizacion(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias, Tmp_CapInt)
						VALUES	(	Consecutivo+1,	FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab, CapInt);/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
			IF (Par_AjustaFecAmo = Var_SI)THEN
				IF (Par_FechaVenc <=  FechaFinal) THEN
					SET Contador 	:= Var_Cuotas+1;
				END IF;
			END IF;
			SET Contador := Contador+1;
		END IF;
		SET Contador := Contador+1;
	END WHILE;

	-- HACE UN CICLO PARA OBTENER LAS FECHAS DE PAGO DE LOS INTERESES
	WHILE (ContadorInt <= Var_CuotasInt ) DO
		-- pagos quincenales
		IF (Par_PagoInter = PagoQuincenal) THEN
			IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) = FrecQuin) THEN
				SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY);
			ELSE
				IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) >28) THEN
					SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
										CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
				ELSE
					SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL DAY(FechaInicioInt) DAY), INTERVAL FrecQuin DAY);
					IF  (FechaFinalInt <= FechaInicioInt) THEN
						SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
					END	IF;
				END IF;
			END IF;
		ELSE
			-- Pagos Mensuales
			IF (Par_PagoInter = PagoMensual) THEN
				-- Para pagos que se haran cada 30 dias de Intereses
				IF (Par_PagoFinAniInt != PagoFinMes) THEN
					IF(Par_DiaMesInt>28)THEN
						SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
						SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
						IF(Var_UltDia < Par_DiaMesInt)THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
						ELSE
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
						END IF;
					ELSE
						SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
					END IF;
				ELSE
					-- Para pagos que se haran cada fin de mes
					IF (Par_PagoFinAniInt = PagoFinMes) THEN
						/* obtiene el final del mes.*/
						SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
					END IF;
				END IF;
			ELSE
				IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal  OR Par_PagoCuota = PagoUnico) THEN
					SET FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
				ELSE
					IF ( Par_PagoInter = PagoBimestral) THEN
						-- Para pagos que se haran cada 60 dias Intereses
						IF (Par_PagoFinAniInt != PagoFinMes ) THEN
							IF(Par_DiaMesInt>28)THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
								SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
								IF(Var_UltDia < Par_DiaMesInt)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran en fin de mes
							IF (Par_PagoFinAniInt = PagoFinMes) THEN
								IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
									SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
									SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
								ELSE
									SET FechaFinalInt	:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
								END IF;
							END IF;
						END IF;
					ELSE
						IF (Par_PagoInter = PagoTrimestral) THEN
							-- Para pagos que se haran cada 90 dias IntereseS
							IF (Par_PagoFinAniInt != PagoFinMes) THEN
								IF(Par_DiaMesInt>28)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesInt)THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran en fin de mes
								IF (Par_PagoFinAniInt = PagoFinMes) THEN
									IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
									ELSE
										SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
									END IF;
								END IF;
							END IF;
						ELSE
							IF ( Par_PagoInter = PagoTetrames) THEN
								-- Para pagos que se haran cada 120 dias interes
								IF (Par_PagoFinAniInt != PagoFinMes) THEN
									IF(Par_DiaMesInt>28)THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesInt)THEN
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAniInt = PagoFinMes) THEN
										IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 5 MONTH),CHAR(12));
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
										ELSE
											SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
										END IF;
									END IF;
								END IF;
							ELSE
								IF (Par_PagoInter = PagoSemestral) THEN
									-- Para pagos que se haran cada 180 dias Interes
									IF (Par_PagoFinAniInt != PagoFinMes) THEN
										IF(Par_DiaMesInt>28)THEN
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesInt)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAniInt = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 7 MONTH),CHAR(12));
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									IF ( Par_PagoInter = PagoAnual) THEN
										-- Para pagos que se haran cada 360 diasInteres
										SET FechaFinalInt	:= CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 1 YEAR),CHAR(12));
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
			END IF;
		END IF;

		IF(Par_DiaHabilSig = Var_SI) THEN
			CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		ELSE
			CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		END IF;

		IF(ContadorInt=1)THEN
			SET Var_GraciaFaltaPag := Par_MargenPriCuota;
		ELSE
			SET Var_GraciaFaltaPag := Var_GraciaPag;
		END IF;

		-- hace un ciclo para comparar los dias de gracia
		WHILE ( (DATEDIFF(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPag ) DO
			IF (Par_PagoInter = PagoQuincenal ) THEN
				IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) = FrecQuin) THEN
					SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY);
				ELSE
					IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) >28) THEN
						SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
											CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
					ELSE
						SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL DAY(FechaFinalInt) DAY), INTERVAL FrecQuin DAY);
						IF  (FechaFinalInt <= FechaInicioInt) THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						END	IF;
					END IF;
				END IF;
			ELSE
			-- Pagos Mensuales
				IF (Par_PagoInter = PagoMensual  ) THEN
					IF (Par_PagoFinAniInt != PagoFinMes) THEN
						IF(Par_DiaMesInt>28)THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
							SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
							IF(Var_UltDia < Par_DiaMesInt)THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

							ELSE
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
							END IF;
						ELSE
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
						END IF;
					ELSE
						-- Para pagos que se haran cada fin de mes
						IF (Par_PagoFinAniInt = PagoFinMes) THEN
							IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1)>=28)THEN
								SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL 2 MONTH),CHAR(12));
								SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
							ELSE
							-- si no indica que es un numero menor y se obtiene el final del mes.
								SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY),CHAR(12));
							END IF;
						END IF;
					END IF ;
				ELSE
					IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoCuota = PagoUnico ) THEN
						SET FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
					END IF;
				END IF;
			END IF;
			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			ELSE
				CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;
		END WHILE;
		/*si la fecha final es mayor a la de vencimiento se ajusta */
		IF (Par_AjustaFecAmo = Var_SI)THEN
			IF (Par_FechaVenc <=  FechaFinalInt) THEN
				SET ContadorInt = Var_CuotasInt+1;
				SET FechaFinalInt 	:= Par_FechaVenc;
			END IF;
			IF (ContadorInt = Var_CuotasInt )THEN
				SET FechaFinalInt 	:= Par_FechaVenc;
			END IF;
		END IF;

		IF(Par_DiaHabilSig = Var_SI) THEN
			CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,			Var_EsHabil,	Par_EmpresaID,
								Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
		ELSE
			CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
		END IF;
		/* valida si se ajusta a fecha de exigibilidad o no*/
		IF (Par_AjusFecExiVen= Var_SI)THEN
			SET FechaFinalInt:= FechaVig;
		END IF;
		SET Consecutivo := (SELECT IFNULL(MAX(Tmp_Consecutivo),Entero_Cero) + 1 FROM Tmp_AmortizacionInt);
		SET CapInt:= Var_Interes;
		SET Fre_DiasIntTab		:= (DATEDIFF(FechaFinalInt,FechaInicioInt));

		INSERT INTO Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,	Tmp_CapInt)
						VALUES	(	Consecutivo,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab, CapInt);

		SET FechaInicioInt := FechaFinalInt;

		IF( (ContadorInt+1) = Var_CuotasInt )THEN
			#Ajuste Saldo
			-- se ajusta a ultima fecha de amortizacion  o a fecha de vencimiento del contrato
			IF (Par_AjustaFecAmo = Var_SI)THEN
				SET FechaFinalInt	:= Par_FechaVenc;
			ELSE
				-- pagos quincenales
				IF (Par_PagoInter = PagoQuincenal) THEN
					IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) = FrecQuin) THEN
						SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY);
					ELSE
						IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1) >28) THEN
							SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
												CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
						ELSE
							SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaInicioInt, INTERVAL DAY(FechaInicioInt) DAY), INTERVAL FrecQuin DAY);
							IF  (FechaFinalInt <= FechaInicioInt) THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							END	IF;
						END IF;
					END IF;
				ELSE
					-- Pagos Mensuales
					IF (Par_PagoInter = PagoMensual) THEN
						-- Para pagos que se haran cada 30 dias de Intereses
						IF (Par_PagoFinAniInt != PagoFinMes) THEN
							IF(Par_DiaMesInt>28)THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
								SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
								IF(Var_UltDia < Par_DiaMesInt)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);
								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
														 CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran cada fin de mes
							IF (Par_PagoFinAniInt = PagoFinMes) THEN
								IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
									SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH),CHAR(12));
									SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
								ELSE
								-- si no indica que es un numero menor y se obtiene el final del mes.
									SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
								END IF;
							END IF;
						END IF;
					ELSE
						IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
							SET FechaFinalInt	:= DATE_ADD(FechaInicioInt, INTERVAL Fre_DiasInt DAY);
						ELSE
							IF ( Par_PagoInter = PagoBimestral) THEN
								-- Para pagos que se haran cada 60 dias Intereses
								IF (Par_PagoFinAniInt != PagoFinMes ) THEN
									IF(Par_DiaMesInt>28)THEN
										SET FechaFinalInt := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , 28),DATE);
										SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
										IF(Var_UltDia < Par_DiaMesInt)THEN
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAniInt = PagoFinMes) THEN
										IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH),CHAR(12));
											SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
										ELSE
											SET FechaFinalInt	:= CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
										END IF;
									END IF;
								END IF;
							ELSE
								IF (Par_PagoInter = PagoTrimestral) THEN
									-- Para pagos que se haran cada 90 dias IntereseS
									IF (Par_PagoFinAniInt != PagoFinMes) THEN
										IF(Par_DiaMesInt>28)THEN
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' ,  28),DATE);
											SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
											IF(Var_UltDia < Par_DiaMesInt)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAniInt = PagoFinMes) THEN
											IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH),CHAR(12));
												SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
											ELSE
												SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
											END IF;
										END IF;
									END IF;
								ELSE
									IF ( Par_PagoInter = PagoTetrames) THEN
										-- Para pagos que se haran cada 120 dias interes
										IF (Par_PagoFinAniInt != PagoFinMes) THEN
											IF(Par_DiaMesInt>28)THEN
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , 28),DATE);
												SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
												IF(Var_UltDia < Par_DiaMesInt)THEN
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
											END IF;
										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAniInt = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 5 MONTH),CHAR(12));
													SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
												ELSE
													SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
												END IF;
											END IF;
										END IF;
									ELSE
										IF (Par_PagoInter = PagoSemestral) THEN
											-- Para pagos que se haran cada 180 dias Interes
											IF (Par_PagoFinAniInt != PagoFinMes) THEN
												IF(Par_DiaMesInt>28)THEN
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , 28),DATE);
													SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
													IF(Var_UltDia < Par_DiaMesInt)THEN
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Var_UltDia),DATE);

													ELSE
														SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
													END IF;
												ELSE
													SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(4)) , '-' ,
														CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
												END IF;
											ELSE
												-- Para pagos que se haran en fin de mes
												IF (Par_PagoFinAniInt = PagoFinMes) THEN
													IF ((CAST(DAY(FechaInicioInt) AS SIGNED)*1)>=28)THEN
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 7 MONTH),CHAR(12));
														SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
													ELSE
														SET FechaFinalInt := CONVERT(DATE_ADD(DATE_ADD(FechaInicioInt, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicioInt) DAY),CHAR(12));
													END IF;
												END IF;
											END IF;
										ELSE
											IF ( Par_PagoInter = PagoAnual) THEN
												-- Para pagos que se haran cada 360 diasInteres
												SET FechaFinalInt	:= CONVERT(DATE_ADD(FechaInicioInt, INTERVAL 1 YEAR),CHAR(12));
											END IF;
										END IF;
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
				END IF;
				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

				IF(Contador=1)THEN
					SET Var_GraciaFaltaPag := Par_MargenPriCuota;
				ELSE
					SET Var_GraciaFaltaPag := Var_GraciaPag;
				END IF;

				-- hace un ciclo para comparar los dias de gracia
				WHILE ( (DATEDIFF(FechaVig, FechaInicioInt)*1) <= Var_GraciaFaltaPag ) DO
					IF (Par_PagoInter = PagoQuincenal ) THEN
						IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) = FrecQuin) THEN
							SET FechaFinalInt 	:= DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY);
						ELSE
							IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1) >28) THEN
								SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
													CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
							ELSE
								SET FechaFinalInt 	:= DATE_ADD(DATE_SUB(FechaFinalInt, INTERVAL DAY(FechaFinalInt) DAY), INTERVAL FrecQuin DAY);
								IF  (FechaFinalInt <= FechaInicioInt) THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															CONVERT(MONTH(DATE_ADD(FechaInicioInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , '15'),DATE);
								END	IF;
							END IF;
						END IF;
					ELSE
					-- Pagos Mensuales
						IF (Par_PagoInter = PagoMensual  ) THEN
							IF (Par_PagoFinAniInt != PagoFinMes) THEN
								IF(Par_DiaMesInt>28)THEN
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , 28),DATE);
									SET Var_UltDia := CAST(DAY(LAST_DAY(FechaFinalInt)) AS SIGNED)*1;
									IF(Var_UltDia < Par_DiaMesCap)THEN
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' ,Var_UltDia),DATE);

									ELSE
										SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
									END IF;
								ELSE
									SET FechaFinalInt := CONVERT(	CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
															 CONVERT(MONTH(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH)),CHAR(2)) , '-' , Par_DiaMesInt),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran cada fin de mes
								IF (Par_PagoFinAniInt = PagoFinMes) THEN
									IF ((CAST(DAY(FechaFinalInt) AS SIGNED)*1)>=28)THEN
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL 2 MONTH),CHAR(12));
										SET FechaFinalInt := CONVERT(DATE_ADD(FechaFinalInt, INTERVAL -1*CAST(DAY(FechaFinalInt) AS SIGNED) DAY),CHAR(12));
									ELSE
									-- si no indica que es un numero menor y se obtiene el final del mes.
										SET FechaFinalInt:= CONVERT(DATE_ADD(DATE_ADD(FechaFinalInt, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinalInt) DAY),CHAR(12));
									END IF;
								END IF;
							END IF ;
						ELSE
							IF ( Par_PagoInter = PagoSemanal OR Par_PagoInter = PagoPeriodo OR Par_PagoInter = PagoCatorcenal OR Par_PagoCuota = PagoUnico) THEN
								SET FechaFinalInt	:= DATE_ADD(FechaFinalInt, INTERVAL Fre_DiasInt DAY);
							END IF;
						END IF;
					END IF;
					IF(Par_DiaHabilSig = Var_SI) THEN
						CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
														Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
														Aud_NumTransaccion);
					ELSE
						CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
											Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
					END IF;

				END WHILE;
			END IF;
			-- Obtiene el dia habil siguiente o anterior
			IF(Par_DiaHabilSig = Var_SI) THEN
				CALL DIASFESTIVOSCAL(	FechaFinalInt,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
									Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
									Aud_NumTransaccion);
			ELSE
				CALL DIASHABILANTERCAL(FechaFinalInt,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			SET CapInt:= Var_Interes;
			/* valida si se ajusta a fecha de exigibilidad o no*/
			IF (Par_AjusFecExiVen= Var_SI)THEN
				SET FechaFinalInt:= FechaVig;
			END IF;
			SET Fre_DiasIntTab	:= (DATEDIFF(FechaFinalInt,FechaInicioInt));
			INSERT INTO Tmp_AmortizacionInt(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,	Tmp_CapInt)
						VALUES	(	Consecutivo+1,	FechaInicioInt,	FechaFinalInt,	FechaVig,	 Fre_DiasIntTab,	CapInt);
			SET ContadorInt := ContadorInt+1;
		END IF;
		SET ContadorInt := ContadorInt+1;
	END WHILE;

	-- INICIALIZO VARIABLES DE CONTROL
	SET Contador := 1;
	SET ContadorCap := 1;
	SET ContadorInt := 1;
	SET Consecutivo := 1;

	-- COMPARO EL NUMERO DE LAS CUOTAS PARA SABER CUAL ES LA MAYOR
	IF (Var_Cuotas >= Var_CuotasInt) THEN
		SET Var_Amor := Var_Cuotas;
	ELSE
		SET Var_Amor := Var_CuotasInt;
	END IF;
	SELECT Tmp_FecIni, Tmp_FecFin INTO FechaInicio, FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = Contador;
	SELECT Tmp_FecIni, Tmp_FecFin INTO FechaInicioInt, FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;

	-- INICIO UN CICLO PARA REACOMODAR LAS FECHAS PARA GENERAR UN CALENDARIO PARA MOSTRAR AL CLIENTE
	WHILE (Contador <= Var_Amor) DO
		IF (FechaFinal<FechaFinalInt)THEN
			SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));

			IF (ContadorInt = Var_CuotasInt)THEN
				SET Var_TipoCap	:= Var_CapInt;
			ELSE
				 SET Var_TipoCap	:= Var_Capital;
			 END IF;
			INSERT INTO TMPPAGAMORSIM (
					Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,			NumTransaccion)
			SELECT	Consecutivo,		Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
					Tmp_CapInt,			Aud_NumTransaccion
			FROM	Tmp_Amortizacion
			WHERE Tmp_Consecutivo = ContadorCap;

			SET FechaInicio := FechaFinal;

			IF (ContadorInt <= Var_CuotasInt)THEN
				IF (ContadorInt>1)THEN SET ContadorInt := ContadorInt-1;ELSE SET ContadorInt :=0 ; END IF;
			END IF;
		ELSE
			IF (FechaFinal=FechaFinalInt)THEN
				SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));

				INSERT INTO TMPPAGAMORSIM (
						Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,		Tmp_FecFin,	Tmp_FecVig,
						Tmp_CapInt,			NumTransaccion)
				SELECT	Consecutivo,		Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Var_CapInt,			Aud_NumTransaccion
				FROM	Tmp_Amortizacion
				WHERE Tmp_Consecutivo = ContadorCap;
				SET FechaInicio := FechaFinal;
			ELSE
				IF (FechaFinal> FechaFinalInt)THEN

					SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
					IF (ContadorInt = Var_CuotasInt)THEN
						SET Var_TipoCap	:= Var_CapInt;
					ELSE
						SET Var_TipoCap	:= Var_Interes;
					END IF;

					INSERT INTO TMPPAGAMORSIM (
							Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
							Tmp_CapInt,			NumTransaccion)
					SELECT 	Consecutivo,		Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Tmp_CapInt ,		Aud_NumTransaccion
					FROM	Tmp_AmortizacionInt
					WHERE	Tmp_Consecutivo = ContadorInt;

					IF (ContadorCap <= Var_Cuotas)THEN
						IF (ContadorCap>1)THEN SET ContadorCap := ContadorCap-1;ELSE SET ContadorCap :=0 ; END IF;
					END IF;
					SET FechaInicio := FechaFinalInt;
				END IF;
			END IF;
		END IF;



		SET Contador := Contador+1;
		SET ContadorCap := ContadorCap+1;
		SET ContadorInt := ContadorInt+1;
		SET Consecutivo := Consecutivo+1;

		IF (Contador>Var_Amor) THEN
			IF (ContadorCap < Var_Cuotas) THEN
				SET Contador:= ContadorCap;
			ELSE IF (ContadorInt < Var_CuotasInt) THEN
					SET Contador:= ContadorInt;
				END IF;
			END IF;
		END IF;

		IF (ContadorCap <= Var_Cuotas) THEN
			SELECT Tmp_FecFin INTO  FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
			ELSE SET FechaFinal:= '2100-12-31';
		END IF;
		IF (ContadorInt <= Var_CuotasInt)THEN
			SELECT  Tmp_FecFin INTO FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
		ELSE
			SET FechaFinalInt:= '2100-12-31';
		END IF;
	END WHILE;

	-- AJUSTE DE FECHAS, INSERTA EL ULTIMO REGISTRO DE LA TABLA.
	IF (ContadorCap = Var_Cuotas) THEN /* si el contador de capital es = al numero de cuotas consideradas */

		IF(ContadorInt = Var_CuotasInt) THEN /* si el contador de interes  es = al numero de cuotas de interes  consideradas */
			SELECT  Tmp_FecFin INTO FechaFinal FROM Tmp_Amortizacion WHERE Tmp_Consecutivo =ContadorCap;
			SELECT  Tmp_FecFin INTO FechaFinalInt FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;

			IF (FechaFinal<FechaFinalInt)THEN/* si la fecha final  de capital es menor que la de  interes  */
				SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
				INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,		NumTransaccion)
					SELECT Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
							Var_CapInt,	Aud_NumTransaccion
						FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
				SET FechaInicio := FechaFinal;
				SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
				SET Consecutivo := Consecutivo+1;
				INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt, 		NumTransaccion)
							SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion
								FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
			ELSE /* si la fecha final  de capital no  es menor que la de  interes  */
				IF (FechaFinal=FechaFinalInt)THEN
					SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
					INSERT INTO 	TMPPAGAMORSIM (	Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
												Tmp_CapInt,		NumTransaccion)
						SELECT	Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
								Var_CapInt,	Aud_NumTransaccion
							FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
					SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
					SET FechaInicio := FechaFinal;
					SET Consecutivo := Consecutivo+1;
					INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
											Tmp_CapInt,		NumTransaccion)
								SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
										Var_CapInt,	Aud_NumTransaccion
									FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
				END IF;
			END IF; /* fin de si la fecha final  de capital es menor que la de  interes  */

			IF (FechaFinal> FechaFinalInt)THEN
				SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
				INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,		NumTransaccion)
							SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion
								FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
				SET FechaInicio := FechaFinal;
				SET Consecutivo := Consecutivo+1;
				INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,		NumTransaccion)
								SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
										Var_CapInt,	Aud_NumTransaccion
									FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
			END IF;
		ELSE /* si el contador de interes  no es igual al numero de cuotas de interes  consideradas */
			SET Fre_Dias		:= (DATEDIFF(FechaFinal,FechaInicio));
			INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
									Tmp_CapInt,		NumTransaccion)
				SELECT Consecutivo,	Fre_Dias,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
						Var_CapInt,	Aud_NumTransaccion
					FROM Tmp_Amortizacion WHERE Tmp_Consecutivo = ContadorCap;
			SET FechaInicio := FechaFinal;
		END IF;
	ELSE
		IF(ContadorInt = Var_CuotasInt) THEN
			SET Fre_DiasInt		:= (DATEDIFF(FechaFinalInt,FechaInicio));
				INSERT INTO TMPPAGAMORSIM (Tmp_Consecutivo,	Tmp_Dias,		Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,
										Tmp_CapInt,		NumTransaccion)
							SELECT 	Consecutivo,	Fre_DiasInt,	FechaInicio,	Tmp_FecFin,	Tmp_FecVig,
									Var_CapInt,	Aud_NumTransaccion
								FROM Tmp_AmortizacionInt WHERE Tmp_Consecutivo = ContadorInt;
		END IF;

	END IF;

	/* se verifica si se paga o no ISR */
	IF( IFNULL(Par_CobraISR,Cadena_Vacia) = Var_SI) THEN
		SET Var_TasaISR:= Par_TasaISR;
	ELSE
		SET Var_TasaISR:= Entero_Cero;
	END IF;


	-- INICIO UN CICLO PARA CALCULO DE CAPITAL Y/O  INTERESES
	SET Contador := 1;
	SELECT MAX(Tmp_Consecutivo) INTO ContadorInt FROM TMPPAGAMORSIM WHERE NumTransaccion = Aud_NumTransaccion ;
	WHILE (Contador <= ContadorInt) DO
		SELECT Tmp_InteresAco INTO  Var_InteresAco FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador-1 AND NumTransaccion = Aud_NumTransaccion ;
		SELECT Tmp_Dias, Tmp_CapInt INTO Fre_Dias, CapInt FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador AND NumTransaccion = Aud_NumTransaccion ;

		SET Var_InteresAco := IFNULL(Var_InteresAco, Entero_Cero);

		IF (CapInt= Var_Interes) THEN
			SET Interes			:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
			SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / (Fre_DiasAnio*100),2);
			SET Var_Retencion	:= ROUND(IF(Interes != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
			SET Capital			:= Decimal_Cero;
			SET Var_InteresAco := Entero_Cero;
		ELSE
			IF (CapInt= Var_CapInt) THEN
				SET Interes	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / (Fre_DiasAnio*100),2);
				SET Var_Retencion	:= ROUND(IF(Interes != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
				SET Capital			:= IF(Var_Cuotas != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
				SET Var_InteresAco := Entero_Cero;
			ELSE
				SET Interes		:= Decimal_Cero;
				SET Capital		:= IF(Var_Cuotas != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
				SET Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / (Fre_DiasAnio*100),2);
				SET Var_Retencion	:= ROUND(IF(Interes != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
			END IF;
		END IF;

		SET IvaInt	:= Interes * Var_IVA;

		SET Subtotal	:= Capital + Interes + IvaInt-Var_Retencion;

		IF (Insoluto<=Capital) THEN
			SET Capital := Insoluto;
		END IF;

		SET Insoluto	:= Insoluto - Capital;
		SET Insoluto	:= Insoluto + Interes - Var_Retencion;
		UPDATE TMPPAGAMORSIM SET
			Tmp_Capital		= Capital,
			Tmp_Interes		= Interes,
			Tmp_iva			= IvaInt,
			Tmp_SubTotal	= Subtotal,
			Tmp_Insoluto	= Insoluto,
			Tmp_InteresAco	= Var_InteresAco,
			Tmp_Retencion	= Var_Retencion
		WHERE Tmp_Consecutivo = Contador
		AND 	NumTransaccion = Aud_NumTransaccion;

		-- si el insoluto es Cero ya no se sigen calculando montos
		IF(Insoluto = Entero_Cero) THEN
			SET Contador := ContadorInt+1;
		END IF;

		IF((Contador+1) = ContadorInt)THEN
			SELECT Tmp_Insoluto, Tmp_InteresAco INTO Insoluto, Var_InteresAco FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador AND NumTransaccion=Aud_NumTransaccion;
			SET Contador = Contador+1;
			SELECT Tmp_Dias, Tmp_CapInt INTO Fre_Dias, CapInt FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo = Contador AND NumTransaccion = Aud_NumTransaccion ;
			IF(IFNULL(Var_InteresAco, Entero_Cero))= Entero_Cero  THEN
				SET Var_InteresAco := Entero_Cero;
			END IF;


			#Ajuste
			IF (CapInt= Var_Interes) THEN
				SET Capital	:= IF(Var_Cuotas != Entero_Cero, (Par_Monto / Var_Cuotas), Entero_Cero);
				SET Capital	:= Insoluto + Capital;
				SET Subtotal	:= Insoluto + Subtotal;
				UPDATE TMPPAGAMORSIM SET
					Tmp_Capital	= Capital,
					Tmp_SubTotal	= Subtotal,
					Tmp_Insoluto	= Insoluto-Insoluto
				WHERE Tmp_Consecutivo = Contador-1
				AND NumTransaccion=Aud_NumTransaccion;

				SET Interes		:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
				SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / (Fre_DiasAnio*100),2);
				SET Var_Retencion	:= ROUND(IF(Interes != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
				SET Capital		:= Decimal_Cero;
				SET Var_InteresAco := Entero_Cero;
			ELSE
				IF (CapInt= Var_CapInt) THEN
					SET Interes	:= ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
					SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / (Fre_DiasAnio*100),2);
					SET Var_Retencion	:= ROUND(IF(Interes != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
					SET Capital	:= Insoluto;
					SET Var_InteresAco := Entero_Cero;
				ELSE
					SET Interes	:= Decimal_Cero;
					SET Capital	:= Insoluto;
					SET Var_InteresAco := ((Insoluto * Par_Tasa * Fre_Dias ) / (Fre_DiasAnio*100))+Var_InteresAco;
					SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_Dias ) / (Fre_DiasAnio*100),2);
					SET Var_Retencion	:= ROUND(IF(Interes != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
				END IF;
				IF (Insoluto<=Capital) THEN
					SET Capital := Insoluto;
				END IF;

				SET Insoluto	:= Insoluto - Capital;

				SET IvaInt	:= Interes * Var_IVA;

				SET Subtotal	:= Capital + Interes + IvaInt-Var_Retencion;

				UPDATE TMPPAGAMORSIM SET
					Tmp_Capital		= Capital,
					Tmp_Interes		= Interes,
					Tmp_iva			= IvaInt,
					Tmp_SubTotal	= Subtotal,
					Tmp_Insoluto	= Insoluto,
					Tmp_InteresAco	= Var_InteresAco,
					Tmp_Retencion	= Var_Retencion
				WHERE Tmp_Consecutivo = Contador
				AND NumTransaccion=Aud_NumTransaccion;

			END IF;
		END IF;
		SET Contador = Contador+1;
	END WHILE;

	-- se eliminan registros vacios, y se asignan valores a numero de cuotas
	SELECT Tmp_Consecutivo INTO Consecutivo FROM TMPPAGAMORSIM WHERE Tmp_Insoluto = Entero_Cero AND NumTransaccion=Aud_NumTransaccion;

	DELETE FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo > Consecutivo AND NumTransaccion=Aud_NumTransaccion;

	SET Var_Cuotas:= (SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Capital OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);

	SET Var_CuotasInt:=(SELECT COUNT(Tmp_Consecutivo) FROM TMPPAGAMORSIM WHERE (Tmp_CapInt = Var_Interes OR  Tmp_CapInt = Var_CapInt) AND NumTransaccion=Aud_NumTransaccion);

	-- se determina cual es la fecha de vencimiento
	SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE 	NumTransaccion = Aud_NumTransaccion);

	-- Se muestran los datos
	IF (Par_Salida = Salida_SI) THEN
		INSERT INTO `TMPPAGAMORSIM`	(
			`Tmp_Consecutivo`,				`Tmp_Dias`,					`Tmp_FecIni`,				`Tmp_FecFin`,					`Tmp_FecVig`,
			`Tmp_Capital`,					`Tmp_Interes`,				`Tmp_Iva`,					`Tmp_SubTotal`,					`Tmp_Insoluto`,
			`Tmp_CapInt`,					`Tmp_CuotasCap`,			`Tmp_CuotasInt`,			`NumTransaccion`,				`Tmp_InteresAco`,
			`Tmp_FrecuPago`,				`Tmp_Retencion`,			`Tmp_Cat`,					`Tmp_MontoSeguroCuota`,			`Tmp_IVASeguroCuota`,
			`Tmp_OtrasComisiones`,			`Tmp_IVAOtrasComisiones`)
			SELECT		Entero_Cero, 		Entero_Cero, 		'1900-01-01', 	MAX(Tmp_FecFin) AS Tmp_FecFin, 	'1900-01-01',
						SUM(Tmp_Capital) ,	SUM(Tmp_Interes), 	SUM(Tmp_Iva),	Decimal_Cero, 					Decimal_Cero,
						Cadena_Vacia, 		Entero_Cero,		Entero_Cero, 	Aud_NumTransaccion, 			Decimal_Cero,
						Entero_Cero, 		SUM(IFNULL(Tmp_Retencion,Entero_Cero)),Decimal_Cero,Decimal_Cero,	Decimal_Cero,
						Decimal_Cero, 		Decimal_Cero
				FROM	TMPPAGAMORSIM
				WHERE 	NumTransaccion = Aud_NumTransaccion;

		SELECT		Tmp_Consecutivo,						Tmp_FecIni,						Tmp_FecFin,								Tmp_FecVig,								FORMAT(Tmp_Capital,2)AS Tmp_Capital,
					FORMAT(Tmp_Interes,2)AS Tmp_Interes,	FORMAT(Tmp_Iva,2)AS Tmp_Iva,	FORMAT(Tmp_SubTotal,2)AS Tmp_SubTotal ,	FORMAT(Tmp_Insoluto,2)AS Tmp_Insoluto,	Tmp_Dias,
					Tmp_CapInt,								Var_Cuotas,						Var_CuotasInt, 							NumTransaccion, 						Par_FechaVenc,
					Par_FechaInicio,						Entero_Cero AS MontoCuota,		FORMAT(IFNULL(Tmp_Retencion,0),2)
			FROM	TMPPAGAMORSIM
			WHERE 	NumTransaccion=Aud_NumTransaccion;
	END IF ;

	SET Par_NumErr 		:= 0;
	SET Par_ErrMen 		:= 'Cuotas generadas';
	SET Par_NumTran		:= Aud_NumTransaccion;
	SET Par_Cuotas 		:= Var_Cuotas;
	SET Par_CuotasInt	:= Var_CuotasInt;
	SET Par_MontoCuo 	:= Entero_Cero;
	SET Par_FechaVen 	:= Par_FechaVenc;

	 DROP TABLE Tmp_Amortizacion;
	 DROP TABLE Tmp_AmortizacionInt;

END TerminaStore$$
