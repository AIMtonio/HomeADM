-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONPAGCRECAMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONPAGCRECAMORPRO`;
DELIMITER $$


CREATE PROCEDURE `FONPAGCRECAMORPRO`(
	-- SP que simula cuotas de pagos crecientes de capital
	-- se utiliza en el CREDITO PASIVO
	Par_Monto				DECIMAL(14,2),		-- Monto a prestar
	Par_Tasa				DECIMAL(14,2),		-- Tasa Anualizada
	Par_Frecu				INT(11),			-- Frecuencia del pago en Dias (si el pago es Periodo)
	Par_PagoCuota			CHAR(1),			-- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
	Par_PagoFinAni			CHAR(1),			-- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)

	Par_DiaMes				INT(2),				-- Si escoge en pago por aniversario, puede especificar un dia del mes (1 -31) segun el mes en que se encuentre
	Par_FechaInicio			DATE,				-- fecha en que empiezan los pagos
	Par_NumeroCuotas		INT(11),			-- Numero de Cuotas que se simularan
	Par_PagaIVA				CHAR(1),			-- indica si paga IVA valores :  Si = "S" / No = "N")
	Par_IVA					DECIMAL(12,4),		-- indica el valor del iva si es que Paga IVA = si

	Par_DiaHabilSig			CHAR(1),			-- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
	Par_AjustaFecAmo		CHAR(1),			-- Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
	Par_AjusFecExiVen		CHAR(1),			-- Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
	Par_Salida    			CHAR(1),			-- Indica si hay una salida o no
	Par_MargenPag			DECIMAL(12,2),		-- Margen para Pagos Iguales.

	Par_CobraISR			CHAR(1),		/* Indica si cobra o no ISR Si = S No = N */
	Par_TasaISR				DECIMAL(12,2),	/* Tasa del ISR*/
	Par_MargenPriCuota		INT(11),		/* Margen para calcular la primer cuota */

	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(350),
    INOUT	Par_NumTran		BIGINT(20),		-- Numero de transaccion con el que se genero el calendario de pagos

    INOUT 	Par_Cuotas		INT(11),
	INOUT	Par_MontoCuo	DECIMAL(14,4),	-- corresponde con la cuota promedio a pagar
	INOUT	Par_FechaVen 	DATE,			-- corresponde con la fecha final que genere el cotizador

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
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Entero_Cero			INT;
	DECLARE Entero_Uno			INT;
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
	DECLARE Salida_SI 			CHAR(1);
	DECLARE NumIteraciones		INT;

	-- Declaracion de Variables
	DECLARE Var_UltDia			INT;
	DECLARE Var_CadCuotas		VARCHAR(8000);
	DECLARE Contador			INT;
	DECLARE ContadorMargen		INT;
	DECLARE FechaInicio			DATE;
	DECLARE FechaFinal			DATE;
	DECLARE Par_FechaVenc		DATE	;		-- fecha vencimiento en que terminan los pagos
	DECLARE FechaVig			DATE;
	DECLARE Var_EsHabil			CHAR(1);
	DECLARE Var_Cuotas			INT;
	DECLARE Tas_Periodo			DECIMAL(14,6);
	DECLARE Pag_Calculado		DECIMAL(14,2);
	DECLARE Var_MontoCuota		DECIMAL(14,2); -- guarda el valor que corresponde con el monto de la cuota
	DECLARE Capital				DECIMAL(14,2);
	DECLARE Interes				DECIMAL(14,2);
	DECLARE IvaInt				DECIMAL(14,2);
	DECLARE Subtotal			DECIMAL(14,2);
	DECLARE Insoluto			DECIMAL(14,2);
	DECLARE Var_IVA				DECIMAL(14,2);
	DECLARE Fre_DiasAnio		INT;		-- dias del año
	DECLARE Fre_Dias			INT;		-- numero de dias
	DECLARE Fre_DiasTab			INT;		-- numero de dias para pagos de capital
	DECLARE Var_Diferencia		DECIMAL(14,2);
	DECLARE Var_Ajuste			DECIMAL(14,2);
	DECLARE Var_CoutasAmor		VARCHAR(8000);
	DECLARE Var_FrecuPago		INT;
	DECLARE Var_GraciaFaltaPag	INT;		-- dias de gracia
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
	SET FrecSemanal			:= 7;	-- frecuencia semanal en dias
	SET FrecCator			:= 14;	-- frecuencia Catorcenal en dias
	SET FrecQuin			:= 15;	-- frecuencia en dias de quincena
	SET FrecMensual			:= 30;	-- frecuencia mesual
	SET FrecBimestral		:= 60;	-- Frecuencia en dias Bimestral
	SET FrecTrimestral		:= 90;	-- Frecuencia en dias Trimestral
	SET FrecTetrames		:= 120;	-- Frecuencia en dias TetraMestral
	SET FrecSemestral		:= 180;	-- Frecuencia en dias Semestral
	SET FrecAnual			:= 360;	-- frecuencia en dias Anual
	SET Salida_SI 	   		:= 'S';
	SET NumIteraciones		:= '1'; --

	-- asignacion de variables
	SET Contador			:= 1;
	SET ContadorMargen		:= 1;
	SET FechaInicio			:= Par_FechaInicio;
	SET Var_CoutasAmor		:= '';
	SET Var_CadCuotas		:= '';
	SET Var_FrecuPago		:= 0;
	SET Fre_DiasAnio		:= (SELECT DiasCredito FROM PARAMETROSSIS);



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

					Entero_Cero AS consecutivo;
		ELSE
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El monto esta Vacio.';
		END IF ;
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

					Entero_Cero AS consecutivo;
			ELSE
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'El monto no puede ser negativo.';
			END IF ;
			LEAVE TerminaStore;
		END IF;
	END IF;

	-- Se asigna a N el parametro Par_AjustaFecAmo para que no se ajuste la ultima fecha de amortizacion
	SET Par_AjustaFecAmo := Var_No;

	-- se calcula la fecha de vencimiento en base al numero de cuotas recibidas y a la periodicidad
	CASE Par_PagoCuota
		WHEN PagoSemanal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecSemanal DAY));
		WHEN PagoCatorcenal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecCator DAY));
		WHEN PagoQuincenal	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecQuin DAY));
		WHEN PagoMensual	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas MONTH));
		WHEN PagoPeriodo	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*Par_Frecu DAY));
		WHEN PagoBimestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*2 MONTH));
		WHEN PagoTrimestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*3 MONTH));
		WHEN PagoTetrames	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*4 MONTH));
		WHEN PagoSemestral	THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*6 MONTH));
		WHEN PagoAnual		THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas YEAR));
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
	END CASE;

	SET Var_FrecuPago 	:= Fre_Dias;
	SET Var_Cuotas		:= Par_NumeroCuotas;
	SET Tas_Periodo		:= ((Par_Tasa / 100) * (1 + Var_IVA) * Fre_Dias) / Fre_DiasAnio ;
	SET Pag_Calculado	:= (Par_Monto * Tas_Periodo * (POWER((1 + Tas_Periodo), Var_Cuotas))) / (POWER((1 + Tas_Periodo), Var_Cuotas)-1);

	-- se redondea a cero el valor del pago calculado
	SET Pag_Calculado	:= CEILING(Pag_Calculado);
	SET Insoluto		:= Par_Monto;
	SET Var_CadCuotas 	:= CONCAT(Var_CadCuotas,Pag_Calculado);

	-- se calculan las Fechas
	WHILE (Contador <= Var_Cuotas) DO
		-- pagos quincenales
		IF (Par_PagoCuota = PagoQuincenal) THEN
			IF (DAY(FechaInicio) = FrecQuin) THEN
				SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
			ELSE
				IF (DAY(FechaInicio) >28) THEN
					SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
										MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '15'),DATE);
				ELSE
					SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
					IF  (FechaFinal <= FechaInicio) THEN
						SET FechaFinal := LAST_DAY(FechaInicio);
						IF(Contador=1)THEN
							SET Var_GraciaFaltaPag := Par_MargenPriCuota;
						ELSE
							SET Var_GraciaFaltaPag := Var_GraciaPag;
						END IF;
						IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_GraciaFaltaPag) THEN
							SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
						END IF;
					END	IF;
				END IF;
			END IF;
		ELSE
			-- Pagos Mensuales
			IF (Par_PagoCuota = PagoMensual) THEN
				-- Para pagos que se haran cada 30 dias
				IF (Par_PagoFinAni != PagoFinMes) THEN
					IF(Par_DiaMes>28)THEN
						SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , 28),DATE);
						SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
						IF(Var_UltDia < Par_DiaMes)THEN
							SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
												 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);
						ELSE
							SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
												 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
						END IF;
					ELSE
						SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
												 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
					END IF;
				ELSE
					-- Para pagos que se haran cada fin de mes
					IF (Par_PagoFinAni = PagoFinMes) THEN
						IF (DAY(FechaInicio)>=28)THEN
							SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 2 MONTH);
							SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal)AS SIGNED) DAY);
						ELSE
						-- si no indica que es un numero menor y se obtiene el final del mes.
							SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
						END IF;
					END IF;
				END IF;
			ELSE
				IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal ) THEN
					SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
				ELSE
					IF (Par_PagoCuota = PagoBimestral) THEN
						-- Para pagos que se haran cada 60 dias
						IF (Par_PagoFinAni != PagoFinMes) THEN
							IF(Par_DiaMes>28)THEN
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , 28),DATE);
								SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
								IF(Var_UltDia < Par_DiaMes)THEN
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)) , '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,Par_DiaMes),DATE);
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
								END IF;
							ELSE
								SET FechaFinal := CONVERT(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran en fin de mes
							IF (Par_PagoFinAni = PagoFinMes) THEN
								IF (DAY(FechaInicio)>=28)THEN
									SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 3 MONTH);
									SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal)AS SIGNED) DAY);
								ELSE
									SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
								END IF;
							END IF;
						END IF;
					ELSE
						IF (Par_PagoCuota = PagoTrimestral) THEN
							-- Para pagos que se haran cada 90 dias
							IF (Par_PagoFinAni != PagoFinMes) THEN
								IF(Par_DiaMes>28)THEN
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,  28),DATE);
									SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
									IF(Var_UltDia < Par_DiaMes)THEN
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
													MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Var_UltDia),DATE);
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Par_DiaMes),DATE);
									END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Par_DiaMes),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran en fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									IF (DAY(FechaInicio)>=28)THEN
										SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 4 MONTH);
										SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1* DAY(FechaFinal) DAY);
									ELSE
										SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
									END IF;
								END IF;
							END IF;
						ELSE
							IF (Par_PagoCuota = PagoTetrames) THEN
								-- Para pagos que se haran cada 120 dias
								IF (Par_PagoFinAni != PagoFinMes) THEN
									IF(Par_DiaMes>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)) , '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , 28),DATE);
										SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
										IF(Var_UltDia < Par_DiaMes)THEN
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Var_UltDia),DATE);

										ELSE
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Par_DiaMes),DATE);
										END IF;
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Par_DiaMes),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAni = PagoFinMes) THEN
										IF (DAY(FechaInicio)>=28)THEN
											SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 5 MONTH);
											SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
										ELSE
											SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
										END IF;
									END IF;
								END IF;
							ELSE
								IF (Par_PagoCuota = PagoSemestral) THEN
									-- Para pagos que se haran cada 180 dias
									IF (Par_PagoFinAni != PagoFinMes) THEN
										IF(Par_DiaMes>28)THEN
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)) , '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , 28),DATE);
											SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
											IF(Var_UltDia < Par_DiaMes)THEN
												SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)) , '-' ,Var_UltDia),DATE);

											ELSE
												SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , Par_DiaMes),DATE);
											END IF;
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , Par_DiaMes),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAni = PagoFinMes) THEN
											IF (DAY(FechaInicio)>=28)THEN
												SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 7 MONTH);
												SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
											ELSE
												SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
											END IF;
										END IF;
									END IF;
								ELSE
									IF (Par_PagoCuota = PagoAnual) THEN
										-- Para pagos que se haran cada 360 dias
										SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL 1 YEAR);
									END IF;
								END IF;
							END IF;
						END IF;
					END IF;
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

		IF(Contador=1)THEN
			SET Var_GraciaFaltaPag := Par_MargenPriCuota;
		ELSE
			SET Var_GraciaFaltaPag := Var_GraciaPag;
		END IF;

		-- hace un ciclo para comparar los dias de gracia
		WHILE (DATEDIFF(FechaVig, FechaInicio) < Var_GraciaFaltaPag ) DO
			IF (Par_PagoCuota = PagoQuincenal ) THEN
				IF (DAY(FechaFinal) = FrecQuin) THEN
					SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
				ELSE
					IF (DAY(FechaFinal) >28) THEN
						SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
											MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , '15'),DATE);
					ELSE
						SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
						IF  (FechaFinal <= FechaInicio) THEN
							SET FechaFinal := LAST_DAY(FechaFinal);
							IF(Contador=1)THEN
								SET Var_GraciaFaltaPag := Par_MargenPriCuota;
							ELSE
								SET Var_GraciaFaltaPag := Var_GraciaPag;
							END IF;
							IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_GraciaFaltaPag) THEN
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
													MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
							END IF;
						END	IF;
					END IF;
				END IF;
			ELSE
				-- Pagos Mensuales
				IF (Par_PagoCuota = PagoMensual  ) THEN
					IF (Par_PagoFinAni != PagoFinMes) THEN
						IF(Par_DiaMes>28)THEN
							SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
													 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , 28),DATE);
							SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
							IF(Var_UltDia < Par_DiaMes)THEN
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
													 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);

							ELSE
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
													 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
							END IF;
						ELSE
							SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
													 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
						END IF;
					ELSE
						-- Para pagos que se haran cada fin de mes
						IF (Par_PagoFinAni = PagoFinMes) THEN
							IF (DAY(FechaFinal)>=28)THEN
								SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL 2 MONTH);
								SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal)AS SIGNED) DAY);
							ELSE
							-- si no indica que es un numero menor y se obtiene el final del mes.
								SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
							END IF;
						END IF;
					END IF ;
				ELSE
					IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal ) THEN
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

		/* si el valor de la fecha final es mayor a la de vencimiento en se ajusta */
		IF (Par_AjustaFecAmo = Var_SI)THEN
			IF (Par_FechaVenc <=  FechaFinal) THEN
				SET FechaFinal 	:= Par_FechaVenc;
				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(
						FechaFinal,		Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
						Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(
						FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			END IF;
			IF (Contador = Var_Cuotas )THEN
				SET FechaFinal 	:= Par_FechaVenc;
				IF(Par_DiaHabilSig = Var_SI) THEN
					CALL DIASFESTIVOSCAL(	FechaFinal,	Entero_Cero,		FechaVig,		Var_EsHabil,		Par_EmpresaID,
										Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
										Aud_NumTransaccion);
				ELSE
					CALL DIASHABILANTERCAL(FechaFinal,		Entero_Cero,			FechaVig,		Par_EmpresaID,	Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
				END IF;
			END IF;
		END IF;


		/* valida si se ajusta a fecha de exigibilidad o no*/
		IF (Par_AjusFecExiVen= Var_SI)THEN
			SET FechaFinal:= FechaVig;
		END IF;

		SET Fre_DiasTab:= (DATEDIFF(FechaFinal,FechaInicio));

		INSERT INTO TMPPAGAMORSIM(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,	Tmp_FecVig,	Tmp_Dias,
								NumTransaccion)
						VALUES(	Contador,		FechaInicio,	FechaFinal,	FechaVig,	Fre_DiasTab,
								Aud_NumTransaccion);
		/* si el valor de la fecha final es mayor a la de vencimiento se aumenta el cotizador para salir del ciclo*/
		IF (Par_AjustaFecAmo = Var_SI)THEN
			IF (Par_FechaVenc <=  FechaFinal) THEN
				SET Contador 	:= Var_Cuotas+1;
			END IF;
		END IF;
		SET FechaInicio := FechaFinal;

		IF((Contador+1) = Var_Cuotas)THEN
			#Ajuste Saldo
			-- se ajusta a ultima fecha de amortizacion (no) o a fecha de vencimiento del contrato (si)
			IF (Par_AjustaFecAmo = Var_SI)THEN
				SET FechaFinal 	:= Par_FechaVenc;
			ELSE
				-- pagos quincenales
				IF (Par_PagoCuota = PagoQuincenal) THEN
					IF (DAY(FechaInicio) = FrecQuin) THEN
						SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
					ELSE
						IF (DAY(FechaInicio) >28) THEN
							SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
												MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '15'),DATE);
						ELSE
							SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
							IF  (FechaFinal <= FechaInicio) THEN
								SET FechaFinal := LAST_DAY(FechaInicio);
								IF(Contador=1)THEN
									SET Var_GraciaFaltaPag := Par_MargenPriCuota;
								ELSE
									SET Var_GraciaFaltaPag := Var_GraciaPag;
								END IF;
								IF(Var_GraciaFaltaPag>CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)) THEN
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
								END IF;
							END	IF;
						END IF;
					END IF;
				ELSE
					-- Pagos Mensuales
					IF (Par_PagoCuota = PagoMensual) THEN
						-- Para pagos que se haran cada 30 dias
						IF (Par_PagoFinAni != PagoFinMes) THEN
							IF(Par_DiaMes>28)THEN
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
														 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , 28),DATE);
								SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
								IF(Var_UltDia < Par_DiaMes)THEN
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
														 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
														 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
								END IF;
							ELSE
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
														 MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
							END IF;
						ELSE
							-- Para pagos que se haran cada fin de mes
							IF (Par_PagoFinAni = PagoFinMes) THEN
								IF (DAY(FechaInicio)>=28)THEN
									SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 2 MONTH);
									SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
								ELSE
								-- si no indica que es un numero menor y se obtiene el final del mes.
									SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
								END IF;
							END IF;
						END IF;
					ELSE
						IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal ) THEN
							SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
						ELSE
							IF (Par_PagoCuota = PagoBimestral) THEN
								-- Para pagos que se haran cada 60 dias
								IF (Par_PagoFinAni != PagoFinMes) THEN
									IF(Par_DiaMes>28)THEN
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)) , '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , 28),DATE);
										SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
										IF(Var_UltDia < Par_DiaMes)THEN
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,Par_DiaMes),DATE);
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)) , '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
										END IF;
									ELSE
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
									END IF;
								ELSE
									-- Para pagos que se haran en fin de mes
									IF (Par_PagoFinAni = PagoFinMes) THEN
										IF (DAY(FechaInicio)>=28)THEN
											SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 3 MONTH);
											SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
										ELSE
											SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 2 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
										END IF;
									END IF;
								END IF;
							ELSE
								IF (Par_PagoCuota = PagoTrimestral) THEN
									-- Para pagos que se haran cada 90 dias
									IF (Par_PagoFinAni != PagoFinMes) THEN
										IF(Par_DiaMes>28)THEN
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,  28),DATE);
											SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
											IF(Var_UltDia < Par_DiaMes)THEN
												SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Var_UltDia),DATE);
											ELSE
												SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),'-' , Par_DiaMes),DATE);
											END IF;
										ELSE
											SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)) , '-' , Par_DiaMes),DATE);
										END IF;
									ELSE
										-- Para pagos que se haran en fin de mes
										IF (Par_PagoFinAni = PagoFinMes) THEN
											IF (DAY(FechaInicio)>=28)THEN
												SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 4 MONTH);
												SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal)AS SIGNED) DAY);
											ELSE
												SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 3 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
											END IF;
										END IF;
									END IF;
								ELSE
									IF (Par_PagoCuota = PagoTetrames) THEN
										-- Para pagos que se haran cada 120 dias
										IF (Par_PagoFinAni != PagoFinMes) THEN
											IF(Par_DiaMes>28)THEN
												SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , 28),DATE);
												SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
												IF(Var_UltDia < Par_DiaMes)THEN
													SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)) , '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Var_UltDia),DATE);

												ELSE
													SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),'-' , Par_DiaMes),DATE);
												END IF;
											ELSE
												SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Par_DiaMes),DATE);
											END IF;
										ELSE
											-- Para pagos que se haran en fin de mes
											IF (Par_PagoFinAni = PagoFinMes) THEN
												IF ((CAST(DAY(FechaInicio)AS SIGNED)*1)>=28)THEN
													SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 5 MONTH);
													SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
												ELSE
													SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 4 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
												END IF;
											END IF;
										END IF;
									ELSE
										IF (Par_PagoCuota = PagoSemestral) THEN
											-- Para pagos que se haran cada 180 dias
											IF (Par_PagoFinAni != PagoFinMes) THEN
												IF(Par_DiaMes>28)THEN
													SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , 28),DATE);
													SET Var_UltDia := DAY(LAST_DAY(FechaFinal))*1;
													IF(Var_UltDia < Par_DiaMes)THEN
														SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,Var_UltDia),DATE);

													ELSE
														SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)) , '-' , Par_DiaMes),DATE);
													END IF;
												ELSE
													SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),'-' ,
														MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , Par_DiaMes),DATE);
												END IF;
											ELSE
												-- Para pagos que se haran en fin de mes
												IF (Par_PagoFinAni = PagoFinMes) THEN
													IF (DAY(FechaInicio)>=28)THEN
														SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 7 MONTH);
														SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
													ELSE
														SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 6 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
													END IF;
												END IF;
											END IF;
										ELSE
											IF (Par_PagoCuota = PagoAnual) THEN
												-- Para pagos que se haran cada 360 dias
												SET FechaFinal 	:= DATE_ADD(FechaInicio, INTERVAL 1 YEAR);
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
				-- hace un ciclo para comparar los dias de gracia
				IF(Contador=1)THEN
					SET Var_GraciaFaltaPag := Par_MargenPriCuota;
				ELSE
					SET Var_GraciaFaltaPag := Var_GraciaPag;
				END IF;
				WHILE (DATEDIFF(FechaVig, FechaInicio) < Var_GraciaFaltaPag ) DO
					IF (Par_PagoCuota = PagoQuincenal ) THEN
						IF (DAY(FechaFinal) = FrecQuin) THEN
							SET FechaFinal 	:= DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
						ELSE
							IF (DAY(FechaFinal) >28) THEN
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
													MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
							ELSE
								SET FechaFinal 	:= DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
						IF  (FechaFinal <= FechaInicio) THEN
							SET FechaFinal := LAST_DAY(FechaFinal);
							IF(Contador=1)THEN
								SET Var_GraciaFaltaPag := Par_MargenPriCuota;
							ELSE
								SET Var_GraciaFaltaPag := Var_GraciaPag;
							END IF;
							IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_GraciaFaltaPag) THEN
								SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
													MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
							END IF;
						END	IF;
							END IF;
						END IF;
					ELSE
					-- Pagos Mensuales
						IF (Par_PagoCuota = PagoMensual  ) THEN
							IF (Par_PagoFinAni  != PagoFinMes) THEN
								IF(Par_DiaMes>28)THEN
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
															 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , 28),DATE);
									SET Var_UltDia :=DAY(LAST_DAY(FechaFinal));
									IF(Var_UltDia < Par_DiaMes)THEN
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
															 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);

									ELSE
										SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
															 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
									END IF;
								ELSE
									SET FechaFinal := CONVERT(	CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
															 MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , Par_DiaMes),DATE);
								END IF;
							ELSE
								-- Para pagos que se haran cada fin de mes
								IF (Par_PagoFinAni = PagoFinMes) THEN
									IF ((CAST(DAY(FechaFinal)AS SIGNED)*1)>=28)THEN
										SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL 2 MONTH);
										SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
									ELSE
									-- si no indica que es un numero menor y se obtiene el final del mes.
										SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
									END IF;
								END IF;
							END IF ;
						ELSE
							IF ( Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal ) THEN
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

			SET Fre_DiasTab		:= (DATEDIFF(FechaFinal,FechaInicio));
			INSERT INTO TMPPAGAMORSIM(	Tmp_Consecutivo, 	Tmp_FecIni,	Tmp_FecFin,		Tmp_FecVig,	Tmp_Dias,
									NumTransaccion)
							VALUES(	Contador+1,		FechaInicio,	FechaFinal,		FechaVig,	Fre_DiasTab,
									Aud_NumTransaccion);
			SET Contador := Contador+1;
		END IF;
		SET Contador := Contador+1;
	END WHILE;

	/* se verifica si se paga o no ISR */
	IF( IFNULL(Par_CobraISR,Cadena_Vacia) = Var_SI) THEN
		SET Var_TasaISR:= Par_TasaISR;
	ELSE
		SET Var_TasaISR:= Entero_Cero;
	END IF;

	-- Se inicializa el Contador
	SET Contador			:= 1;
	-- genera los montos y los inserta en la tabla TMPPAGAMORSIM
	WHILE (ContadorMargen <= NumIteraciones) DO
		WHILE (Contador <= Var_Cuotas) DO

			SELECT Tmp_Dias INTO Fre_DiasTab
				FROM TMPPAGAMORSIM
				WHERE NumTransaccion = Aud_NumTransaccion
				AND Tmp_Consecutivo = Contador;

			SET Interes			:= ROUND((Insoluto * Par_Tasa * Fre_DiasTab ) / (Fre_DiasAnio*100),2);
			SET Var_Retencion	:= ROUND((Insoluto * Var_TasaISR * Fre_DiasTab ) / (Fre_DiasAnio*100),2);
			SET Var_Retencion	:= ROUND(IF(IFNULL(Interes, Entero_Cero) != Entero_Cero, (Interes/Interes), Entero_Cero)* Var_Retencion,2);
			SET IvaInt	:= Interes * Var_IVA;

			IF(Insoluto > 0) THEN
				IF(Contador = Var_Cuotas)THEN
					SET Capital	:= Insoluto;
					SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,Capital + Interes);
				ELSE
					SET Capital	:= Pag_Calculado - Interes - IvaInt;
					/* si el capital es negativo entonces la cuota de esta amortizacion tendra como
						capital un peso y su total de pago no sera el pago calculado.*/
	--
					IF(Capital < Entero_Cero)THEN
						SET Capital	:=Entero_Uno;
					END IF;
					IF (Insoluto<=Capital) THEN
						SET Capital := Insoluto;
					END IF;
					SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,Capital + Interes,',');
				END IF;

				SET Insoluto		:= Insoluto - Capital;
				SET Subtotal		:= Capital + Interes + IvaInt-Var_Retencion;
				UPDATE TMPPAGAMORSIM SET
					Tmp_Capital		= Capital,
					Tmp_Interes		= Interes,
					Tmp_Iva			= IvaInt,
					Tmp_SubTotal	= Subtotal,
					Tmp_Insoluto	= Insoluto,
					Tmp_Retencion	= Var_Retencion
				WHERE NumTransaccion = Aud_NumTransaccion
				AND Tmp_Consecutivo = Contador;
			ELSE
				SET Var_Cuotas	:= Contador;
				SET Contador := Var_Cuotas+10;
			END IF;

			SET Contador := Contador+1;

		END WHILE;
		SET Var_MontoCuota := Pag_Calculado; -- se asigna el valor del monto de la cuota
		SET Var_Diferencia := Pag_Calculado-Subtotal;
		SET ContadorMargen = ContadorMargen+1;

		IF (ContadorMargen<=NumIteraciones)THEN
			IF (ABS(Var_Diferencia) > Par_MargenPag) THEN
					-- se redondea el ajuste al proximo entero
					IF(Var_Diferencia>Entero_Cero)THEN
						IF(Subtotal>Pag_Calculado) THEN
							SET Pag_Calculado 	:= Pag_Calculado-2;
						ELSE
							SET Pag_Calculado 	:= Pag_Calculado-Entero_Uno;
						END IF;
					ELSE
						IF(Subtotal>Pag_Calculado) THEN
							SET Pag_Calculado 	:= Pag_Calculado+2;
						ELSE
							SET Pag_Calculado 	:= Pag_Calculado+Entero_Uno;
						END IF;
					END IF;

					-- se redondea a cero el valor del pago calculado
					SET Pag_Calculado	:= CEILING(Pag_Calculado);
					SET Insoluto		:= Par_Monto;

					IF (SELECT Var_CadCuotas LIKE CONCAT('%',Pag_Calculado,'%'))THEN
						SET Contador := Var_Cuotas+1;
						SET ContadorMargen := NumIteraciones+1;
					ELSE
						SET Var_CoutasAmor	:= '';
						SET Contador 			:=1;
					END IF;
					SET Var_CadCuotas := CONCAT(Var_CadCuotas,',',Pag_Calculado);

			ELSE
				IF(Subtotal>Pag_Calculado) THEN
					IF(Var_Diferencia>Entero_Cero)THEN
							SET Pag_Calculado 	:= Pag_Calculado-Entero_Uno;
					ELSE
							SET Pag_Calculado 	:= Pag_Calculado+Entero_Uno;
					END IF;

					-- se redondea a cero el valor del pago calculado
					SET Pag_Calculado	:= CEILING(Pag_Calculado);
					SET Insoluto		:= Par_Monto;

					IF (SELECT Var_CadCuotas LIKE CONCAT('%',Pag_Calculado,'%'))THEN
						SET Contador 		:= Var_Cuotas+1;
						SET ContadorMargen	:= NumIteraciones+1;
					ELSE
						SET Var_CoutasAmor	:= '';
						SET Contador 		:=1;
					END IF;
					SET Var_CadCuotas	:= CONCAT(Var_CadCuotas,',',Pag_Calculado);
				ELSE
					SET ContadorMargen	:= NumIteraciones+1;
					SET Contador 		:= Var_Cuotas+1;
				END IF;


			END IF;
		END IF;
	 END WHILE;

	/* COMPARO SI EL ULTIMO REGISTRO DE LA TABLA TMPPAGAMORSIM ES CERO, ELIMINO EL REGISTRO.*/

	SELECT Tmp_Consecutivo
		INTO Var_Cuotas
		FROM TMPPAGAMORSIM
		WHERE NumTransaccion=Aud_NumTransaccion
		AND Tmp_Insoluto= 0 LIMIT 1;

	DELETE FROM TMPPAGAMORSIM WHERE Tmp_Consecutivo > Var_Cuotas AND NumTransaccion=Aud_NumTransaccion;
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


		SELECT		Tmp_Consecutivo,					Tmp_FecIni,						Tmp_FecFin,								Tmp_FecVig,									FORMAT(Tmp_Capital,2)AS Tmp_Capital,
					FORMAT(Tmp_Interes,2)AS Tmp_Interes,FORMAT(Tmp_Iva,2) AS Tmp_Iva,	FORMAT(Tmp_SubTotal,2)AS Tmp_SubTotal,	FORMAT(Tmp_Insoluto,2)  AS Tmp_Insoluto, 	Tmp_Dias,
					Var_Cuotas,							NumTransaccion,					Par_FechaVenc,							Par_FechaInicio,
					Var_MontoCuota AS MontoCuota,		FORMAT(IFNULL(Tmp_Retencion,0),2) AS Retencion
			FROM	TMPPAGAMORSIM
			WHERE 	NumTransaccion = Aud_NumTransaccion;
	END IF ;

	SET Par_NumErr 		:= 0;
	SET Par_ErrMen 		:= Par_FechaVenc;
	SET Par_NumTran		:= Aud_NumTransaccion;
	SET Par_Cuotas 		:= Var_Cuotas;
	SET Par_MontoCuo 	:= Pag_Calculado;
	SET Par_FechaVen	:= Par_FechaVenc;

END TerminaStore$$
