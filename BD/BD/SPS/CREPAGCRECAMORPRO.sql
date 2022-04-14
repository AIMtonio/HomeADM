-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGCRECAMORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGCRECAMORPRO`;
DELIMITER $$


CREATE PROCEDURE `CREPAGCRECAMORPRO`(
    # ======================================================================================================================
    # -------------------------------SP QUE SIMULA CUOTAS DE PAGOS CRECIENTES DE CAPITAL------------------------------------
    # ======================================================================================================================
    Par_ConvenioNominaID    BIGINT UNSIGNED,  		-- Numero del Convenio de Nomina
    Par_Monto                DECIMAL(14,4),         -- Monto a prestar
    Par_Tasa                 DECIMAL(14,2),         -- Tasa Anualizada
    Par_Frecu                INT(11),               -- Frecuencia del pago en Dias (si el pago es Periodo)
    Par_PagoCuota            CHAR(1),               -- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
    Par_PagoFinAni           CHAR(1),               -- solo si el Pago es Mensual indica si es fin de mes (F) o por aniversario (A)

    Par_DiaMes               INT(2),                -- Si escoge en pago por aniversario, puede especificar un dia del mes (1 -31) segun el mes en que se encuentre
    Par_FechaInicio          DATE,                  -- fecha en que empiezan los pagos
    Par_NumeroCuotas         INT(11),               -- Numero de Cuotas que se simularan
    Par_ProdCredID           INT(11),               -- identificador de PRODUCTOSCREDITO para obtener dias de gracia y margen para pag iguales
    Par_ClienteID            INT(11),               -- identificador de CLIENTES para obtener el valor PagaIVA

    Par_DiaHabilSig          CHAR(1),               -- Indica si toma el dia habil siguiente (S - si) o el anterior (N - no)
    Par_AjustaFecAmo         CHAR(1),               -- Indica si se ajusta a fecha de vencimiento  (S- Si) ultima amortizacion(N - no)
    Par_AjusFecExiVen        CHAR(1),               -- Indica si se ajusta la fecha  de vencimiento a fecha de exigibilidad  (S- si se ajusta N- no se ajusta)
    Par_ComAper              DECIMAL(14,2),         -- Monto de la comision por apertura
    Par_MontoGL              DECIMAL(12,2),         -- Monto de la garantia liquida

    Par_CobraSeguroCuota    CHAR(1),                -- Cobra Seguro por cuota
    Par_CobraIVASeguroCuota CHAR(1),                -- Cobra IVA Seguro por cuota
    Par_MontoSeguroCuota     DECIMAL(12,2),         -- Monto Seguro por Cuota
    Par_ComAnualLin			DECIMAL(12,2),			-- Monto Comisión por Anualidad Línea de Crédito
    Par_Salida               CHAR(1),               -- Indica si hay una salida o no

    INOUT Par_NumErr         INT(11),
    INOUT Par_ErrMen         VARCHAR(400),
    INOUT Par_NumTran        BIGINT(20),            -- Numero de transaccion con el que se genero el calendario de pagos
    INOUT Par_Cuotas         INT(11),
    INOUT Par_Cat            DECIMAL(14,4),        -- cat que corresponde con lo generado

    INOUT    Par_MontoCuo    DECIMAL(14,4),        -- corresponde con la cuota promedio a pagar
    INOUT    Par_FechaVen    DATE,                            -- corresponde con la fecha final que genere el cotizador
    Par_EmpresaID            INT(11),

    Aud_Usuario              INT(11),
    Aud_FechaActual          DATETIME,
    Aud_DireccionIP          VARCHAR(15),
    Aud_ProgramaID           VARCHAR(50),
    Aud_Sucursal             INT(11),
    Aud_NumTransaccion       BIGINT(20)
			)

TerminaStore: BEGIN

    -- Declaracion de Constantes
    DECLARE Decimal_Cero                            DECIMAL(14,2);
    DECLARE Entero_Cero                             INT(11);
    DECLARE Entero_Negativo                         INT(11);
    DECLARE Entero_Uno                              INT(11);
    DECLARE Cadena_Vacia                            CHAR(1);
    DECLARE Var_SI                                  CHAR(1);    -- SI
    DECLARE Var_No                                  CHAR(1);    -- NO
    DECLARE PagoSemanal                             CHAR(1);    -- Pago Semanal (S)
    DECLARE PagoDecenal                             CHAR(1);    -- Pago Decenal (D)
    DECLARE PagoCatorcenal                          CHAR(1);    -- Pago Catorcenal (C)
    DECLARE PagoQuincenal                           CHAR(1);    -- Pago Quincenal (Q)
    DECLARE PagoMensual                             CHAR(1);    -- Pago Mensual (M)
    DECLARE PagoPeriodo                             CHAR(1);    -- Pago por periodo (P)
    DECLARE PagoBimestral                           CHAR(1);    -- PagoBimestral (B)
    DECLARE PagoTrimestral                          CHAR(1);    -- PagoTrimestral (T)
    DECLARE PagoTetrames                            CHAR(1);    -- PagoTetraMestral (R)
    DECLARE PagoSemestral                           CHAR(1);    -- PagoSemestral (E)
    DECLARE PagoAnual                               CHAR(1);    -- PagoAnual (A)
    DECLARE PagoFinMes                              CHAR(1);    -- Pago al final del mes (F)
    DECLARE PagoAniver                              CHAR(1);    -- Pago por aniversario (A)
    DECLARE FrecSemanal                             INT(11);    -- frecuencia semanal en dias
    DECLARE FrecDecenal                             INT(11);    -- Frecuencia Decenal en dias
    DECLARE FrecCator                               INT(11);    -- frecuencia Catorcenal en dias
    DECLARE FrecQuin                                INT(11);    -- frecuencia en dias quincena
    DECLARE FrecMensual                             INT(11);    -- frecuencia mensual
    DECLARE FrecBimestral                           INT(11);    -- Frecuencia en dias Bimestral
    DECLARE FrecTrimestral                          INT(11);    -- Frecuencia en dias Trimestral
    DECLARE FrecTetrames                            INT(11);    -- Frecuencia en dias TetraMestral
    DECLARE FrecSemestral                           INT(11);    -- Frecuencia en dias Semestral
    DECLARE FrecAnual                               INT(11);    -- frecuencia en dias Anual
    DECLARE ComApDeduc                              CHAR(1);
    DECLARE ComApFinan                              CHAR(1);
    DECLARE Salida_SI                               CHAR(1);
    DECLARE NumIteraciones                          INT(11);
    DECLARE Cons_FrecExtDiasSemanal                 INT(11);
    DECLARE Cons_FrecExtDiasDecenal                 INT(11);
    DECLARE Cons_FrecExtDiasCatorcenal              INT(11);
    DECLARE Cons_FrecExtDiasQuincenal               INT(11);
    DECLARE Cons_FrecExtDiasMensual                 INT(11);
    DECLARE Cons_FrecExtDiasPeriodo                 INT(11);
    DECLARE Cons_FrecExtDiasBimestral               INT(11);
    DECLARE Cons_FrecExtDiasTrimestral              INT(11);
    DECLARE Cons_FrecExtDiasTetrames                INT(11);
    DECLARE Cons_Var_FrecExtDiasSemestral           INT(11);
    DECLARE Cons_FrecExtDiasAnual                   INT(11);
    DECLARE Cons_FrecExtDiasFinMes                  INT(11);
    DECLARE Cons_FrecExtDiasAniver                  INT(11);

    -- Declaracion de Variables
    DECLARE Var_UltDia                              INT(11);
    DECLARE Var_CadCuotas                           VARCHAR(8000);
    DECLARE Contador                                INT(11);
    DECLARE ContadorMargen                          INT(11);
    DECLARE FechaInicio                             DATE;
    DECLARE FechaFinal                              DATE;
    DECLARE Par_FechaVenc                           DATE;               -- fecha vencimiento en que terminan los pagos
    DECLARE FechaVig                                DATE;
    DECLARE Var_EsHabil                             CHAR(1);
    DECLARE Var_Cuotas                              INT(11);
    DECLARE Tas_Periodo                             DECIMAL(14,6);
    DECLARE Pag_Calculado                           DECIMAL(14,2);
    DECLARE Var_MontoCuota                          DECIMAL(14,2);      -- guarda el valor que corresponde con el monto de la cuota
    DECLARE Capital                                 DECIMAL(14,2);
    DECLARE Interes                                 DECIMAL(14,2);
    DECLARE IvaInt                                  DECIMAL(14,2);
    DECLARE Garantia                                DECIMAL(12,2);
    DECLARE Subtotal                                DECIMAL(14,2);
    DECLARE Insoluto                                DECIMAL(14,2);
    DECLARE Var_IVA                                 DECIMAL(14,2);
    DECLARE Fre_DiasAnio                            INT(11);            -- dias del ano
    DECLARE Fre_Dias                                INT(11);            -- numero de dias
    DECLARE Fre_DiasTab                             INT(11);            -- numero de dias para pagos de capital
    DECLARE Var_DiasExtra                           INT(11);            -- dias de gracia
    DECLARE Var_MargenPagIgual                      INT(11);            -- Margen para pagos iguales
    DECLARE Var_Diferencia                          DECIMAL(14,2);
    DECLARE Var_Ajuste                              DECIMAL(14,2);
    DECLARE Var_ProCobIva                           CHAR(1);            -- Producto cobra Iva S si N no
    DECLARE Var_CtePagIva                           CHAR(1);            -- Cliente Paga Iva S si N no
    DECLARE Var_CoutasAmor                          VARCHAR(8000);
    DECLARE Var_CAT                                 DECIMAL(14,4);
    DECLARE Var_FrecuPago                           INT(11);
    DECLARE Var_TotalCap                            DECIMAL(14,2);
    DECLARE Var_TotalInt                            DECIMAL(14,2);
    DECLARE Var_TotalIva                            DECIMAL(14,2);
    DECLARE Var_Control                             VARCHAR(100);               -- Variable de control
    DECLARE Var_FrecExtDiasSemanal                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasDecenal                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasCatorcenal               INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasQuincenal                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasMensual                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasPeriodo                  INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasBimestral                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasTrimestral               INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasTetrames                 INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasSemestral                INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasAnual                    INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasFinMes                   INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_FrecExtDiasAniver                   INT(11);                    -- Numero de dias que se debende agregar para la primera cuota PARAMDIAFRECUENCRED
    DECLARE Var_LlaveParametro						VARCHAR(50);				-- Llave de parametros
    DECLARE Var_ManejaConvenio						CHAR(5);					-- MANEJA CONVENIO DE NOMINA
    DECLARE Var_ManejaCalendario                    CHAR(1);                    -- Maneja calendario
    DECLARE Var_ManejaFechaIniCal                   CHAR(1);                    -- Maneja fecha de inicio de calendario
	DECLARE Var_ProgramaBancas						VARCHAR(50);				-- ProgramaID de bancas
    # SEGUROS
    DECLARE Var_IVASeguroCuota                      DECIMAL(12,2);              -- Monto que cobrara por IVA
    DECLARE Var_TotalSeguroCuota                    DECIMAL(12,2);              -- Total de seguro cuota
    DECLARE Var_TotalIVASeguroCuota                 DECIMAL(12,2);              -- Total de iva seguro cuota
    DECLARE Var_CliProEsp                           INT;                        -- Almacena el Numero de Cliente para Procesos Especificos
    DECLARE Con_CliProcEspe                         VARCHAR(20);
    DECLARE NumClienteTLR                           INT(11);
    DECLARE NumClienteCrediClub						INT(11);
	DECLARE Var_EsProducNomina						CHAR(1);					-- Si el producto de Credito es de nomina


    -- asignacion de constantes
    SET Decimal_Cero                := 0.00;
    SET Entero_Cero                 := 0;
    SET Entero_Negativo             := -1;
    SET Entero_Uno                  := 1;
    SET Cadena_Vacia                := '';
    SET Var_SI                      := 'S';
    SET Var_No                      := 'N';
    SET PagoSemanal                 := 'S'; -- PagoSemanal
    SET PagoDecenal                 := 'D'; -- Pago Decenal
    SET PagoCatorcenal              := 'C'; -- PagoCatorcenal
    SET PagoQuincenal               := 'Q'; -- PagoQuincenal
    SET PagoMensual                 := 'M'; -- PagoMensual
    SET PagoPeriodo                 := 'P'; -- PagoPeriodo
    SET PagoBimestral               := 'B'; -- PagoBimestral
    SET PagoTrimestral              := 'T'; -- PagoTrimestral
    SET PagoTetrames                := 'R'; -- PagoTetraMestral
    SET PagoSemestral               := 'E'; -- PagoSemestral
    SET PagoAnual                   := 'A'; -- PagoAnual
    SET PagoFinMes                  := 'F'; -- PagoFinMes
    SET PagoAniver                  := 'A'; -- Pago por aniversario
    SET FrecSemanal                 := 7;   -- frecuencia semanal en dias
    SET FrecDecenal                 := 10;  -- Frecuencia decenal en dias
    SET FrecCator                   := 14;  -- frecuencia Catorcenal en dias
    SET FrecQuin                    := 15;  -- frecuencia en dias de quincena
    SET FrecMensual                 := 30;  -- frecuencia mesual

    SET FrecBimestral                   := 60;  -- Frecuencia en dias Bimestral
    SET FrecTrimestral                  := 90;  -- Frecuencia en dias Trimestral
    SET FrecTetrames                    := 120; -- Frecuencia en dias TetraMestral
    SET FrecSemestral                   := 180; -- Frecuencia en dias Semestral
    SET FrecAnual                       := 360; -- frecuencia en dias Anual
    SET ComApDeduc                      := 'D';
    SET ComApFinan                      := 'F';
    SET Salida_SI                       := 'S';
    SET NumIteraciones                  := '100';
    SET Cons_FrecExtDiasSemanal         := 5;
    SET Cons_FrecExtDiasDecenal         := 5;
    SET Cons_FrecExtDiasCatorcenal      := 10;
    SET Cons_FrecExtDiasQuincenal       := 10;
    SET Cons_FrecExtDiasMensual         := 20;
    SET Cons_FrecExtDiasBimestral       := 40;
    SET Cons_FrecExtDiasTrimestral      := 60;
    SET Cons_FrecExtDiasTetrames        := 80;
    SET Cons_Var_FrecExtDiasSemestral   := 120;
    SET Cons_FrecExtDiasAnual           := 240;
    SET Con_CliProcEspe         := 'CliProcEspecifico'; -- Numero de Cliente para Procesos Especificos
    SET NumClienteTLR           :=  14;                 -- Numero de Cliente para Tu Lanita Rapida Procesos Especificos: 14
    SET NumClienteCrediClub		:= 24;					-- Numero de Cliente para Crediclub. Procesos Expecificos: 24

    -- asignacion de variables
    SET Contador                        := 1;
    SET ContadorMargen                  := 1;
    SET FechaInicio                     := Par_FechaInicio;
    SET Var_CoutasAmor                  := '';
    SET Var_CadCuotas                   := '';
    SET Var_CAT                         := 0.0000;
    SET Var_FrecuPago                   := 0;
    SET Var_LlaveParametro        		:= 'ManejaCovenioNomina'; -- Maneje convenios nomina
    SET Var_ProgramaBancas				:= 'AmortiCreditoLisDAO.amortiCreditoLis01';

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPAGCRECAMORPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        SET Var_CliProEsp   := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

        SELECT ValorParametro INTO Var_ManejaConvenio
			FROM PARAMGENERALES
			WHERE LlaveParametro=Var_LlaveParametro;

        SELECT ProductoNomina INTO Var_EsProducNomina
        FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProdCredID;

        SET Var_EsProducNomina := IFNULL(Var_EsProducNomina,Var_No);

        IF(Var_CliProEsp = NumClienteTLR) THEN # SIMULADOR DE PAGOS CRECIENTES DE TLR
            #ESTE PROCESO NO TIENE MONTO SEGURO POR CUOTA EN LA SIMULACION
            CALL CREPAGCRECAMOR014PRO(
                Par_Monto,              Par_Tasa,           		Par_Frecu,          	Par_PagoCuota,      Par_PagoFinAni,
                Par_DiaMes,             Par_FechaInicio,    		Par_NumeroCuotas,   	Par_ProdCredID,     Par_ClienteID,
                Par_DiaHabilSig,        Par_AjustaFecAmo,   		Par_AjusFecExiVen,  	Par_ComAper,        Par_MontoGL,
                Par_CobraSeguroCuota,   Par_CobraIVASeguroCuota,	Par_MontoSeguroCuota,	Par_ComAnualLin,	Par_Salida,
                Par_NumErr, 	        Par_ErrMen,         		Par_NumTran,			Par_Cuotas,         Par_Cat,
                Par_MontoCuo,       	Par_FechaVen,       		Par_EmpresaID,          Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    	Aud_ProgramaID,     		Aud_Sucursal,           Aud_NumTransaccion);
            ELSE

				 IF(Var_CliProEsp = NumClienteCrediClub) THEN # SIMULADOR DE PAGOS CRECIENTES DE CREDICLUB
					CALL CREPAGCRECAMOR024PRO(
					Par_Monto,              Par_Tasa,				Par_Frecu,          	Par_PagoCuota,      Par_PagoFinAni,
					Par_DiaMes,             Par_FechaInicio,   		Par_NumeroCuotas,   	Par_ProdCredID,     Par_ClienteID,
					Par_DiaHabilSig,        Par_AjustaFecAmo,  		Par_AjusFecExiVen,  	Par_ComAper,        Par_MontoGL,
					Par_CobraSeguroCuota,   Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,   Par_ComAnualLin,	Par_Salida,
                    Par_NumErr,        		Par_ErrMen,         	Par_NumTran,			Par_Cuotas,         Par_Cat,
                    Par_MontoCuo,       	Par_FechaVen,       	Par_EmpresaID,			Aud_Usuario,        Aud_FechaActual,
                    Aud_DireccionIP,    	Aud_ProgramaID,     	Aud_Sucursal,			Aud_NumTransaccion);

				ELSE
                -- VALIDACION SI MANEJA CONVENIOS DE NOMINA
					IF(Var_ManejaConvenio = Var_SI AND Var_EsProducNomina = Var_SI AND Aud_ProgramaID != Var_ProgramaBancas )THEN
                        -- VALIDA SI EL SE MANEJA CALENDARIO Y CONVENIO DE NOMINA -----------------------------------------------------
                        SELECT ManejaCalendario, ManejaFechaIniCal INTO Var_ManejaCalendario, Var_ManejaFechaIniCal
                            FROM CONVENIOSNOMINA
                        WHERE ConvenioNominaID = Par_ConvenioNominaID;

                        SET Var_ManejaCalendario    := IFNULL(Var_ManejaCalendario, Var_No);
                        SET Var_ManejaFechaIniCal   := IFNULL(Var_ManejaFechaIniCal, Var_No);

                        CALL CREPAGCRECAMORCVN000PRO(
                            Par_ConvenioNominaID,
                            Par_Monto,              Par_Tasa,               Par_Frecu,              Par_PagoCuota,      Par_PagoFinAni,
                            Par_DiaMes,             Par_FechaInicio,        Par_NumeroCuotas,       Par_ProdCredID,     Par_ClienteID,
                            Par_DiaHabilSig,        Par_AjustaFecAmo,       Par_AjusFecExiVen,      Par_ComAper,        Par_MontoGL,
                            Par_CobraSeguroCuota,   Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,   Par_ComAnualLin,    Par_Salida,
                            Par_NumErr,             Par_ErrMen,             Par_NumTran,            Par_Cuotas,         Par_Cat,
                            Par_MontoCuo,           Par_FechaVen,           Par_EmpresaID,          Aud_Usuario,        Aud_FechaActual,
                            Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                    ELSE
						CALL CREPAGCRECAMOR000PRO(
							Par_Monto,              Par_Tasa,           	Par_Frecu,          	Par_PagoCuota,      Par_PagoFinAni,
							Par_DiaMes,             Par_FechaInicio,    	Par_NumeroCuotas,   	Par_ProdCredID,     Par_ClienteID,
							Par_DiaHabilSig,        Par_AjustaFecAmo,   	Par_AjusFecExiVen,  	Par_ComAper,        Par_MontoGL,
							Par_CobraSeguroCuota,   Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,   Par_ComAnualLin,	Par_Salida,
							Par_NumErr,         	Par_ErrMen,         	Par_NumTran,			Par_Cuotas,         Par_Cat,
							Par_MontoCuo,       	Par_FechaVen,  			Par_EmpresaID,			Aud_Usuario,        Aud_FechaActual,
							Aud_DireccionIP,    	Aud_ProgramaID,     	Aud_Sucursal,			Aud_NumTransaccion);
					END IF;
				END IF;
		END IF;
        IF(Par_NumErr!=0) THEN
         LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr    := 0;
        SET Par_ErrMen    := 'Simulacion Exitosa';

    END ManejoErrores;
    IF (Par_Salida = Salida_SI) THEN
        IF(Par_NumErr != Entero_Cero) THEN
            SELECT
                0,                      Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,           Entero_Cero,        Entero_Cero,
                Entero_Cero,            Entero_Cero,        Entero_Cero,
                Entero_Cero,            Entero_Cero,        Aud_NumTransaccion,
                Entero_Cero,            Cadena_Vacia,       Cadena_Vacia,
                Entero_Cero,            Entero_Cero,        Entero_Cero,
                Entero_Cero,
                Cadena_Vacia AS CobraSeguroCuota,
                Entero_Cero AS MontoSeguroCuota,
                Entero_Cero AS IVASeguroCuota,
                Entero_Cero AS TotalSeguroCuota,
                Entero_Cero AS TotalIVASeguroCuota,
                Entero_Cero AS OtrasComisiones,
                Entero_Cero AS IVAOtrasComisiones,
                Entero_Cero AS TotalOtrasComisiones,
                Entero_Cero AS TotalIVAOtrasComisiones,
                Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen;
        END IF;
    END IF;
END TerminaStore$$
