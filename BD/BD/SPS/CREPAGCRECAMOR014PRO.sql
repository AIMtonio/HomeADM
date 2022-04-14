-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPAGCRECAMOR014PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPAGCRECAMOR014PRO`;
DELIMITER $$

CREATE PROCEDURE `CREPAGCRECAMOR014PRO`(
    Par_Monto                DECIMAL(14,2),
    Par_Tasa                 DECIMAL(14,2),
    Par_Frecu                INT(11),
    Par_PagoCuota            CHAR(1),
    Par_PagoFinAni           CHAR(1),

    Par_DiaMes               INT(2),
    Par_FechaInicio          DATE,
    Par_NumeroCuotas         INT(11),
    Par_ProdCredID           INT(11),
    Par_ClienteID            INT(11),

    Par_DiaHabilSig          CHAR(1),
    Par_AjustaFecAmo         CHAR(1),
    Par_AjusFecExiVen        CHAR(1),
    Par_ComAper              DECIMAL(14,2),
    Par_MontoGL              DECIMAL(12,2),

    Par_CobraSeguroCuota    CHAR(1),
    Par_CobraIVASeguroCuota CHAR(1),
    Par_MontoSeguroCuota     DECIMAL(12,2),
    Par_ComAnualLin			DECIMAL(12,2), 		-- Monto Comisión Anualidad Línea de Crédito
    Par_Salida               CHAR(1),

    INOUT Par_NumErr         INT(11),
    INOUT Par_ErrMen         VARCHAR(400),
    INOUT Par_NumTran        BIGINT(20),
    INOUT Par_Cuotas         INT(11),
    INOUT Par_Cat            DECIMAL(14,4),

    INOUT    Par_MontoCuo    DECIMAL(14,4),
    INOUT    Par_FechaVen    DATE,
    Par_EmpresaID            INT(11),

    Aud_Usuario              INT(11),
    Aud_FechaActual          DATETIME,
    Aud_DireccionIP          VARCHAR(15),
    Aud_ProgramaID           VARCHAR(50),
    Aud_Sucursal             INT(11),
    Aud_NumTransaccion       BIGINT(20)
)
TerminaStore: BEGIN


    DECLARE Decimal_Cero                            DECIMAL(14,2);
    DECLARE Entero_Cero                             INT(11);
    DECLARE Entero_Negativo                         INT(11);
    DECLARE Entero_Uno                              INT(11);
    DECLARE Cadena_Vacia                            CHAR(1);
    DECLARE Var_SI                                  CHAR(1);
    DECLARE Var_No                                  CHAR(1);
    DECLARE PagoSemanal                             CHAR(1);
    DECLARE PagoDecenal                             CHAR(1);
    DECLARE PagoCatorcenal                          CHAR(1);
    DECLARE PagoQuincenal                           CHAR(1);
    DECLARE PagoMensual                             CHAR(1);
    DECLARE PagoPeriodo                             CHAR(1);
    DECLARE PagoBimestral                           CHAR(1);
    DECLARE PagoTrimestral                          CHAR(1);
    DECLARE PagoTetrames                            CHAR(1);
    DECLARE PagoSemestral                           CHAR(1);
    DECLARE PagoAnual                               CHAR(1);
    DECLARE PagoFinMes                              CHAR(1);
    DECLARE PagoAniver                              CHAR(1);
    DECLARE FrecSemanal                             INT(11);
    DECLARE FrecDecenal                             INT(11);
    DECLARE FrecCator                               INT(11);
    DECLARE FrecQuin                                INT(11);
    DECLARE FrecMensual                             INT(11);
    DECLARE FrecBimestral                           INT(11);
    DECLARE FrecTrimestral                          INT(11);
    DECLARE FrecTetrames                            INT(11);
    DECLARE FrecSemestral                           INT(11);
    DECLARE FrecAnual                               INT(11);
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
    DECLARE Llave_CobraAccesorios					VARCHAR(100); 		-- Llave para consulta el valor de Cobro de Accesorios
    DECLARE OperaSimulador							INT(11);			-- Indica que la transacción viene desde el simulador
	DECLARE FormaFinanciado							CHAR(1); 			-- Foma Cobro Financiado


    DECLARE Var_UltDia                              INT(11);
    DECLARE Var_CadCuotas                           VARCHAR(8000);
    DECLARE Contador                                INT(11);
    DECLARE ContadorMargen                          INT(11);
    DECLARE FechaInicio                             DATE;
    DECLARE FechaFinal                              DATE;
    DECLARE Par_FechaVenc                           DATE;
    DECLARE FechaVig                                DATE;
    DECLARE Var_EsHabil                             CHAR(1);
    DECLARE Var_ProductoNomina  					CHAR(1);
    DECLARE Var_Cuotas                              INT(11);
    DECLARE Tas_Periodo                             DECIMAL(14,6);
    DECLARE DiferenciaCuota     					DECIMAL(14,2);
    DECLARE Pag_Calculado                           DECIMAL(14,2);
    DECLARE Var_MontoCuota                          DECIMAL(14,2);
    DECLARE Capital                                 DECIMAL(14,2);
    DECLARE Interes                                 DECIMAL(14,2);
    DECLARE IvaInt                                  DECIMAL(14,2);
    DECLARE Garantia                                DECIMAL(12,2);
    DECLARE Subtotal                                DECIMAL(14,2);
    DECLARE Insoluto                                DECIMAL(14,2);
    DECLARE Var_IVA                                 DECIMAL(14,2);
    DECLARE Fre_DiasAnio                            INT(11);
    DECLARE Fre_Dias                                INT(11);
    DECLARE Fre_DiasTab                             INT(11);
    DECLARE Var_DiasExtra                           INT(11);
    DECLARE Var_MargenPagIgual                      INT(11);
    DECLARE Var_Diferencia                          DECIMAL(14,2);
    DECLARE Var_Ajuste                              DECIMAL(14,2);
    DECLARE Var_ProCobIva                           CHAR(1);
    DECLARE Var_CtePagIva                           CHAR(1);
    DECLARE Var_CoutasAmor                          VARCHAR(8000);
    DECLARE Var_CAT                                 DECIMAL(14,4);
    DECLARE Var_FrecuPago                           INT(11);
    DECLARE Var_TotalCap                            DECIMAL(14,2);
    DECLARE Var_TotalInt                            DECIMAL(14,2);
    DECLARE Var_TotalIva                            DECIMAL(14,2);
    DECLARE Var_Control                             VARCHAR(100);
    DECLARE Var_FrecExtDiasSemanal                  INT(11);
    DECLARE Var_FrecExtDiasDecenal                  INT(11);
    DECLARE Var_FrecExtDiasCatorcenal               INT(11);
    DECLARE Var_FrecExtDiasQuincenal                INT(11);
    DECLARE Var_FrecExtDiasMensual                  INT(11);
    DECLARE Var_FrecExtDiasPeriodo                  INT(11);
    DECLARE Var_FrecExtDiasBimestral                INT(11);
    DECLARE Var_FrecExtDiasTrimestral               INT(11);
    DECLARE Var_FrecExtDiasTetrames                 INT(11);
    DECLARE Var_FrecExtDiasSemestral                INT(11);
    DECLARE Var_FrecExtDiasAnual                    INT(11);
    DECLARE Var_FrecExtDiasFinMes                   INT(11);
    DECLARE Var_FrecExtDiasAniver                   INT(11);

    DECLARE Var_IVASeguroCuota                      DECIMAL(12,2);
    DECLARE Var_TotalSeguroCuota                    DECIMAL(12,2);
    DECLARE Var_TotalIVASeguroCuota                 DECIMAL(12,2);
    DECLARE Var_1erDiaQuinc                         INT(11);                    -- Primer día de la quincena.
    DECLARE Var_2doDiaQuinc                         INT(11);                    -- Segundo día de la quincena.
    DECLARE Var_CobraAccesorios                     CHAR(1);                    -- Indica si la solicitud cobra accesorios
    DECLARE Var_SaldoOtrasComisiones                DECIMAL(14,2);              -- Saldo Otras Comisiones
    DECLARE Var_SaldoIVAOtrasComisiones             DECIMAL(14,2);              -- Saldo IVA Otras Comisiones

	DECLARE Var_PlazoID								INT(11);					-- Plazo del credito
    DECLARE Var_SolicitudCreditoID					BIGINT(20);					-- Numero de Solicitud de Credito
    DECLARE Var_CreditoID							BIGINT(12);					-- Numero de Credito
	DECLARE Var_CobraAccesoriosGen					CHAR(1);					-- Valor del Cobro de Accesorios
    DECLARE Var_TipoFormaCobro						CHAR(1);					-- Tipo de Forma de Accesorios

    DECLARE Var_FechaInicioCre                      DATE;                       -- Fecha de Inicio
    DECLARE Var_FechaVenc                           DATE;                       -- Fecha de vencimiento
    DECLARE Var_ManejaCalendario                    CHAR(1);                    -- Maneja calendario
    DECLARE Var_InstitNominaID                      INT(11);                    -- Institucion de nomina
    DECLARE FormaApertura                           CHAR(1);                    -- valida forma de pago Apertura
    DECLARE FormaDeducciones                        CHAR(1);                    -- valida forma de pago Deducciones
    DECLARE TipoPagoAccesorioM                      CHAR(1);                    -- valida TIPO PAGO MONTO
    DECLARE TipoPagoAccesorioP                      CHAR(1);                    -- valida TIPO PAGO PROCENTAJE
    DECLARE Var_MontoApertu                         DECIMAL(12,2);              -- monto acesorios apertura
    DECLARE Var_MontoIvaApertu                      DECIMAL(12,2);              -- monto acesorios IVA apertura
    DECLARE Var_MontoDeducci                        DECIMAL(12,2);              -- monto acesorios Deduccion
    DECLARE Var_MontoIvaDeducci                     DECIMAL(12,2);              -- monto acesorios IVA Deduccion
    DECLARE Entero_Dos                              INT;                                -- entero dos
    DECLARE Entero_Cien                             INT;                                -- entero cien
    DECLARE Var_MontoCredito                        DECIMAL(12,2);              -- monto acesorios IVA Deduccion


    SET Decimal_Cero                := 0.00;
    SET Entero_Cero                 := 0;
    SET Entero_Negativo             := -1;
    SET Entero_Uno                  := 1;
    SET Entero_Dos                  := 2;
    SET Entero_Cien                 := 100;
    SET Cadena_Vacia                := '';
    SET Var_SI                      := 'S';
    SET Var_No                      := 'N';
    SET PagoSemanal                 := 'S';
    SET PagoDecenal                 := 'D';
    SET PagoCatorcenal              := 'C';
    SET PagoQuincenal               := 'Q';
    SET PagoMensual                 := 'M';
    SET PagoPeriodo                 := 'P';
    SET PagoBimestral               := 'B';
    SET PagoTrimestral              := 'T';
    SET PagoTetrames                := 'R';
    SET PagoSemestral               := 'E';
    SET PagoAnual                   := 'A';
    SET PagoFinMes                  := 'F';
    SET PagoAniver                  := 'A';
    SET FrecSemanal                 := 7;
    SET FrecDecenal                 := 10;
    SET FrecCator                   := 14;
    SET FrecQuin                    := 15;
    SET FrecMensual                 := 30;

    SET FrecBimestral                   := 60;
    SET FrecTrimestral                  := 90;
    SET FrecTetrames                    := 120;
    SET FrecSemestral                   := 180;
    SET FrecAnual                       := 360;
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

    SET Contador                        := 1;
    SET ContadorMargen                  := 1;
    SET FechaInicio                     := Par_FechaInicio;
    SET Var_CoutasAmor                  := '';
    SET Var_CadCuotas                   := '';
    SET Var_CAT                         := 0.0000;
    SET Var_FrecuPago                   := 0;
    SET Llave_CobraAccesorios			:= 'CobraAccesorios'; -- Llave para Consultar Si Cobra Accesorios
    SET OperaSimulador					:= 1; 		-- Indicador Opera Simulador
    SET FormaFinanciado					:= 'F';		-- Forma de cobro Financiado
    SET FormaApertura                   := 'A';     -- Forma de cobro Financiado
    SET FormaDeducciones                := 'D';     -- Forma de cobro Financiado
    SET TipoPagoAccesorioM              := 'M';     -- Forma de cobro MONTO
    SET TipoPagoAccesorioP              := 'P';     -- Forma de cobro Procentaje

    ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-CREPAGCRECAMOR014PRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        SET Fre_DiasAnio                    := (SELECT DiasCredito FROM PARAMETROSSIS);

        -- Se obtiene el valor de si se realiza o no el cobro de accesorios
		SET Var_CobraAccesoriosGen := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Llave_CobraAccesorios);
		SET Var_CobraAccesoriosGen := IFNULL(Var_CobraAccesoriosGen,Cadena_Vacia);

        SET Var_CobraAccesorios := (SELECT CobraAccesorios FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Par_ProdCredID);
        SET Var_CobraAccesorios := IFNULL(Var_CobraAccesorios, Cadena_Vacia);

        SET Var_FrecExtDiasSemanal              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoSemanal AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasDecenal              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoDecenal AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasCatorcenal           :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoCatorcenal AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasQuincenal            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoQuincenal AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasMensual              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoMensual AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasPeriodo              :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoPeriodo AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasBimestral            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoBimestral AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasTrimestral           :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoTrimestral AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasTetrames             :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoTetrames AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasSemestral            :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoSemestral AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasAnual                :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoAnual AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasFinMes               :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoFinMes AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);
        SET Var_FrecExtDiasAniver               :=(SELECT Dias FROM PARAMDIAFRECUENCRED WHERE Frecuencia = PagoAniver AND ProducCreditoID = Par_ProdCredID ORDER BY FechaActual DESC LIMIT 1);


        SET Var_FrecExtDiasSemanal              :=IFNULL(Var_FrecExtDiasSemanal, Cons_FrecExtDiasSemanal);
        SET Var_FrecExtDiasDecenal              :=IFNULL(Var_FrecExtDiasDecenal, Cons_FrecExtDiasDecenal);
        SET Var_FrecExtDiasCatorcenal           :=IFNULL(Var_FrecExtDiasCatorcenal, Cons_FrecExtDiasCatorcenal);
        SET Var_FrecExtDiasQuincenal            :=IFNULL(Var_FrecExtDiasQuincenal, Cons_FrecExtDiasQuincenal);
        SET Var_FrecExtDiasMensual              :=IFNULL(Var_FrecExtDiasMensual, Cons_FrecExtDiasMensual);
        SET Var_FrecExtDiasPeriodo              :=IFNULL(Var_FrecExtDiasPeriodo, Cons_FrecExtDiasPeriodo);
        SET Var_FrecExtDiasBimestral            :=IFNULL(Var_FrecExtDiasBimestral, Cons_FrecExtDiasBimestral);
        SET Var_FrecExtDiasTrimestral           :=IFNULL(Var_FrecExtDiasTrimestral, Cons_FrecExtDiasTrimestral);
        SET Var_FrecExtDiasTetrames             :=IFNULL(Var_FrecExtDiasTetrames, Cons_FrecExtDiasTetrames);
        SET Var_FrecExtDiasSemestral            :=IFNULL(Var_FrecExtDiasSemestral, Cons_Var_FrecExtDiasSemestral);
        SET Var_FrecExtDiasAnual                :=IFNULL(Var_FrecExtDiasAnual, Cons_FrecExtDiasAnual);
        SET Var_FrecExtDiasFinMes               :=IFNULL(Var_FrecExtDiasFinMes, Cons_FrecExtDiasFinMes);
        SET Var_FrecExtDiasAniver               :=IFNULL(Var_FrecExtDiasAniver, Cons_FrecExtDiasAniver);




        IF ( Par_PagoCuota = PagoPeriodo) THEN
            IF(IFNULL(Par_Frecu, Entero_Cero))= Entero_Cero THEN
                SET Par_NumErr := 1;
                SET Par_ErrMen := 'Especificar Frecuencia Pago.';
                LEAVE ManejoErrores;
            END IF ;
        END IF ;

        IF(IFNULL(Par_Monto, Decimal_Cero))= Decimal_Cero THEN
            SET Par_NumErr := 2;
            SET Par_ErrMen := 'El monto esta Vacio.';
            LEAVE ManejoErrores;
          ELSE
            IF(Par_Monto < Entero_Cero)THEN
                SET Par_NumErr := 3;
                SET Par_ErrMen := 'El monto no puede ser negativo.';
                LEAVE ManejoErrores;
            END IF;
        END IF;

        IF(IFNULL(Par_CobraSeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := 004;
            SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra Seguro por Cuota.';
            LEAVE ManejoErrores;
          ELSE
            IF(Par_CobraSeguroCuota = Var_SI) THEN
                IF(IFNULL(Par_CobraIVASeguroCuota,Cadena_Vacia) = Cadena_Vacia) THEN
                    SET Par_NumErr := 005;
                    SET Par_ErrMen := 'El Producto de Credito no Especifica si Cobra IVA por Seguro por Cuota.';
                    LEAVE ManejoErrores;
                END IF;
                IF(IFNULL(Par_MontoSeguroCuota,Entero_Cero)= Entero_Cero) THEN
                    SET Par_NumErr := 006;
                    SET Par_ErrMen := 'El Monto para el Seguro no se encuentra Parametrizado.';
                    LEAVE ManejoErrores;
                END IF;
              ELSE
                SET Par_MontoSeguroCuota := Decimal_Cero;
                SET Var_TotalSeguroCuota := Decimal_Cero;
                SET Var_TotalIVASeguroCuota := Decimal_Cero;
            END IF;
        END IF;



        CASE Par_PagoCuota
            WHEN PagoSemanal        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecSemanal DAY));
            WHEN PagoDecenal        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecDecenal DAY));
            WHEN PagoCatorcenal     THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecCator DAY));
            WHEN PagoQuincenal      THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*FrecQuin DAY));
            WHEN PagoMensual        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas MONTH));
            WHEN PagoPeriodo        THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*Par_Frecu DAY));
            WHEN PagoBimestral      THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*2 MONTH));
            WHEN PagoTrimestral     THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*3 MONTH));
            WHEN PagoTetrames       THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*4 MONTH));
            WHEN PagoSemestral      THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas*6 MONTH));
            WHEN PagoAnual          THEN SET Par_FechaVenc := (SELECT DATE_ADD(Par_FechaInicio, INTERVAL Par_NumeroCuotas YEAR));
        END CASE;


        SELECT      MargenPagIgual,     CobraIVAInteres ,   ProductoNomina
    INTO    Var_MargenPagIgual, Var_ProCobIva,      Var_ProductoNomina
        FROM PRODUCTOSCREDITO
         WHERE ProducCreditoID = Par_ProdCredID;

        IF (Var_ProductoNomina = Var_SI) THEN
            SET NumIteraciones      := 2;
        ELSE
            SET NumIteraciones      := 20;
        END IF;


        SELECT PagaIVA INTO Var_CtePagIva
            FROM CLIENTES
                WHERE ClienteID = Par_ClienteID;

        IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Var_CtePagIva  := Var_Si;
        END IF;

        IF(IFNULL(Aud_Sucursal,Entero_Cero ) = Entero_Cero) THEN
            SET Aud_Sucursal  := (SELECT SucursalMatrizID FROM PARAMETROSSIS);
        END IF;
        SET Var_IVA       := (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);

        IF (Var_ProCobIva = Var_Si) THEN
            IF (Var_CtePagIva = Var_No) THEN
                SET Var_IVA := Decimal_Cero;
            END IF;
          ELSE
            SET Var_IVA     := Decimal_Cero;
        END IF;



        CASE Par_PagoCuota
            WHEN PagoSemanal            THEN SET Fre_Dias :=  FrecSemanal;          SET Var_DiasExtra  := Var_FrecExtDiasSemanal;
            WHEN PagoDecenal            THEN SET Fre_Dias :=  FrecDecenal;          SET Var_DiasExtra  := Var_FrecExtDiasDecenal;
            WHEN PagoCatorcenal         THEN SET Fre_Dias :=  FrecCator;            SET Var_DiasExtra  := Var_FrecExtDiasCatorcenal;
            WHEN PagoQuincenal          THEN SET Fre_Dias :=  FrecQuin;             SET Var_DiasExtra  := Var_FrecExtDiasQuincenal;
            WHEN PagoMensual            THEN SET Fre_Dias :=  FrecMensual;          SET Var_DiasExtra  := Var_FrecExtDiasMensual;
            WHEN PagoPeriodo            THEN SET Fre_Dias :=  Par_Frecu;
            WHEN PagoBimestral          THEN SET Fre_Dias :=  FrecBimestral;        SET Var_DiasExtra  := Var_FrecExtDiasBimestral;
            WHEN PagoTrimestral         THEN SET Fre_Dias :=  FrecTrimestral;       SET Var_DiasExtra  := Var_FrecExtDiasTrimestral;
            WHEN PagoTetrames           THEN SET Fre_Dias :=  FrecTetrames;         SET Var_DiasExtra  := Var_FrecExtDiasTetrames;
            WHEN PagoSemestral          THEN SET Fre_Dias :=  FrecSemestral;        SET Var_DiasExtra  := Var_FrecExtDiasSemestral;
            WHEN PagoAnual              THEN SET Fre_Dias :=  FrecAnual;            SET Var_DiasExtra  := Var_FrecExtDiasAnual;
        END CASE;

        SET Var_FrecuPago   := Fre_Dias;
        SET Var_Cuotas      := Par_NumeroCuotas;
        SET Tas_Periodo     := ((Par_Tasa / 100) * (1 + Var_IVA) * Fre_Dias) / Fre_DiasAnio ;
        SET Pag_Calculado   := (Par_Monto * Tas_Periodo * (POWER((1 + Tas_Periodo), Var_Cuotas))) / (POWER((1 + Tas_Periodo), Var_Cuotas)-1);


        SET Pag_Calculado    := Pag_Calculado;
        SET Insoluto    := Par_Monto;
        SET Var_CadCuotas   := CONCAT(Var_CadCuotas,Pag_Calculado);

        IF(Par_CobraIVASeguroCuota = Var_Si) THEN
            SET Var_IVASeguroCuota :=  ROUND(Par_MontoSeguroCuota * Var_IVA,2);
          ELSE
            SET Var_IVASeguroCuota := Decimal_Cero;
        END IF;



        WHILE (Contador <= Var_Cuotas) DO

            IF (Par_PagoCuota = PagoDecenal) THEN
                IF (DAY(FechaInicio) = FrecDecenal) THEN
                    SET FechaFinal  := DATE_ADD(FechaInicio, INTERVAL FrecDecenal DAY);
                  ELSE
                    IF (DAY(FechaInicio) < 6 ) THEN
                        SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '10'),DATE);
                      ELSE
                        IF(DAY(FechaInicio) < 16 ) THEN
                            SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '20'),DATE);
                          ELSE
                            IF(DAY(FechaInicio) < 26 ) THEN
                                SET FechaFinal := LAST_DAY(FechaInicio);
                              ELSE
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                            END IF;
                        END IF;
                    END IF;
                END IF;
              ELSE
                -- pagos quincenales
                IF (Par_PagoCuota = PagoQuincenal) THEN
                    # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                    IF(Par_DiaMes = FrecQuin) THEN
                        IF (DAY(FechaInicio) = FrecQuin) THEN
                            SET FechaFinal  := DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
                        ELSE
                            IF (DAY(FechaInicio) >28) THEN
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '15'),DATE);
                            ELSE
                                SET FechaFinal  := DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
                                IF  (FechaFinal <= FechaInicio) THEN
                                    SET FechaFinal := LAST_DAY(FechaInicio);
                                    IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    ELSE
                        # Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
                        SET Var_1erDiaQuinc := Par_DiaMes;
                        SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                        IF (DAY(FechaInicio) = Var_1erDiaQuinc) THEN
                            SET FechaFinal  := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                        ELSE
                            IF (DAY(FechaInicio) >28) THEN
                                SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , LPAD(Var_1erDiaQuinc,2,'0')));
                            ELSE
                                SET FechaFinal := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                IF(FechaFinal <= FechaInicio) THEN
                                    SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),'-',
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),'-',
                                                        LPAD(Var_1erDiaQuinc,2,'0')));
                                    IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                        SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')));
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                  ELSE

                    IF (Par_PagoCuota = PagoMensual) THEN

                        IF (Par_PagoFinAni != PagoFinMes) THEN
                            IF(Par_DiaMes>28)THEN
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , 28),DATE);
                                SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                IF(Var_UltDia < Par_DiaMes)THEN
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);
                                  ELSE
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                                END IF;
                              ELSE
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                            END IF;
                          ELSE

                            IF (Par_PagoFinAni = PagoFinMes) THEN
                                IF (DAY(FechaInicio)>=28)THEN
                                    SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 2 MONTH);
                                    SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal)AS SIGNED) DAY);
                                  ELSE

                                    SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
                                END IF;
                            END IF;
                        END IF;
                      ELSE
                        IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal ) THEN
                            SET FechaFinal  := DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
                          ELSE
                            IF (Par_PagoCuota = PagoBimestral) THEN

                                IF (Par_PagoFinAni != PagoFinMes) THEN
                                    IF(Par_DiaMes>28)THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , 28),DATE);
                                        SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                        IF(Var_UltDia < Par_DiaMes)THEN
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)) , '-' ,
                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,Par_DiaMes),DATE);
                                          ELSE
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
                                        END IF;
                                      ELSE
                                        SET FechaFinal := CONVERT(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
                                    END IF;
                                  ELSE

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

                                    IF (Par_PagoFinAni != PagoFinMes) THEN
                                        IF(Par_DiaMes>28)THEN
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,  28),DATE);
                                            SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                            IF(Var_UltDia < Par_DiaMes)THEN
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Var_UltDia),DATE);
                                              ELSE
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Par_DiaMes),DATE);
                                            END IF;
                                          ELSE
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Par_DiaMes),DATE);
                                        END IF;
                                      ELSE

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

                                        IF (Par_PagoFinAni != PagoFinMes) THEN
                                            IF(Par_DiaMes>28)THEN
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , 28),DATE);
                                                SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                                IF(Var_UltDia < Par_DiaMes)THEN
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Var_UltDia),DATE);
                                                  ELSE
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Par_DiaMes),DATE);
                                                END IF;
                                              ELSE
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Par_DiaMes),DATE);
                                            END IF;
                                          ELSE

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

                                            IF (Par_PagoFinAni != PagoFinMes) THEN
                                                IF(Par_DiaMes>28)THEN
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)) , '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , 28),DATE);
                                                    SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                                    IF(Var_UltDia < Par_DiaMes)THEN
                                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)) , '-' ,Var_UltDia),DATE);
                                                      ELSE
                                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , Par_DiaMes),DATE);
                                                    END IF;
                                                  ELSE
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , Par_DiaMes),DATE);
                                                END IF;
                                              ELSE

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

                                                SET FechaFinal  := DATE_ADD(FechaInicio, INTERVAL 1 YEAR);
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF;

            IF(Par_DiaHabilSig = Var_SI) THEN
                CALL DIASFESTIVOSCAL( FechaFinal,   Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                Aud_NumTransaccion);
              ELSE
                CALL DIASHABILANTERCAL(FechaFinal,    Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
            END IF;


            WHILE (DATEDIFF(FechaVig, FechaInicio) < Var_DiasExtra ) DO

                IF (Par_PagoCuota = PagoDecenal) THEN
                    IF (DAY(FechaFinal) = FrecDecenal) THEN
                        SET FechaFinal  := DATE_ADD(FechaFinal, INTERVAL FrecDecenal DAY);
                      ELSE
                        IF (DAY(FechaFinal) < 6 ) THEN
                            SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '10'),DATE);
                          ELSE
                            IF(DAY(FechaFinal) < 16 ) THEN
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '20'),DATE);
                              ELSE
                                IF(DAY(FechaFinal) < 26 ) THEN
                                    SET FechaFinal := LAST_DAY(FechaFinal);
                                  ELSE
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                    MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                                END IF;
                            END IF;
                        END IF;
                    END IF;
                  ELSE
                    IF (Par_PagoCuota = PagoQuincenal ) THEN
                        # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                        IF(Par_DiaMes = FrecQuin) THEN
                            IF (DAY(FechaFinal) = FrecQuin) THEN
                                SET FechaFinal  := DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
                              ELSE
                                IF (DAY(FechaFinal) >28) THEN
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                    MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , '15'),DATE);
                                  ELSE
                                    SET FechaFinal  := DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
                                    IF  (FechaFinal <= FechaInicio) THEN
                                        SET FechaFinal := LAST_DAY(FechaFinal);
                                        IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                            MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        ELSE
                            SET Var_1erDiaQuinc := Par_DiaMes;
                            SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                            IF (DAY(FechaFinal) >= Var_2doDiaQuinc) THEN

                                SET FechaFinal  := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                    CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);
                            ELSE
                                IF (DAY(FechaFinal) < Var_2doDiaQuinc) THEN
                                    SET FechaFinal  :=  DATE(CONCAT(YEAR(FechaFinal),'-',MONTH(FechaFinal),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                END IF;
                            END IF;
                        END IF;
                      ELSE

                        IF (Par_PagoCuota = PagoMensual  ) THEN
                            IF (Par_PagoFinAni != PagoFinMes) THEN
                                IF(Par_DiaMes>28)THEN
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                    MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , 28),DATE);
                                    SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                    IF(Var_UltDia < Par_DiaMes)THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);
                                      ELSE
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                                    END IF;
                                  ELSE
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                    MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                                END IF;
                              ELSE

                                IF (Par_PagoFinAni = PagoFinMes) THEN
                                    IF (DAY(FechaFinal)>=28)THEN
                                        SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL 2 MONTH);
                                        SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*CAST(DAY(FechaFinal)AS SIGNED) DAY);
                                      ELSE

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
                END IF;

                IF(Par_DiaHabilSig = Var_SI) THEN
                    CALL DIASFESTIVOSCAL( FechaFinal, Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                    Aud_NumTransaccion);
                  ELSE
                    CALL DIASHABILANTERCAL(FechaFinal,    Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
                END IF;
            END WHILE;


            IF (Par_AjustaFecAmo = Var_SI)THEN
                IF (Par_FechaVenc <=  FechaFinal) THEN
                    SET FechaFinal  := Par_FechaVenc;
                    IF(Par_DiaHabilSig = Var_SI) THEN
                        CALL DIASFESTIVOSCAL(
                        FechaFinal,   Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                        Aud_NumTransaccion);
                      ELSE
                        CALL DIASHABILANTERCAL(
                        FechaFinal,   Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                        Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
                    END IF;
                END IF;
                IF (Contador = Var_Cuotas )THEN
                    SET FechaFinal  := Par_FechaVenc;
                    IF(Par_DiaHabilSig = Var_SI) THEN
                        CALL DIASFESTIVOSCAL( FechaFinal, Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                        Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                        Aud_NumTransaccion);
                      ELSE
                        CALL DIASHABILANTERCAL(FechaFinal,    Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                        Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
                    END IF;
                END IF;
            END IF;


            IF (Par_AjusFecExiVen= Var_SI)THEN
                SET FechaFinal:= FechaVig;
            END IF;

            SET Fre_DiasTab:= (DATEDIFF(FechaFinal,FechaInicio));

            INSERT INTO TMPPAGAMORSIM(
                Tmp_Consecutivo,  Tmp_FecIni, Tmp_FecFin, Tmp_FecVig, Tmp_Dias,
                NumTransaccion,   Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
              VALUES(
                Contador,   FechaInicio,  FechaFinal, FechaVig, Fre_DiasTab,
                Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota);


            IF (Par_AjustaFecAmo = Var_SI)THEN
                IF (Par_FechaVenc <=  FechaFinal) THEN
                    SET Contador  := Var_Cuotas+1;
                END IF;
            END IF;
            SET FechaInicio := FechaFinal;

            IF((Contador+1) = Var_Cuotas)THEN


                IF (Par_AjustaFecAmo = Var_SI)THEN
                    SET FechaFinal  := Par_FechaVenc;
                  ELSE


                    IF (Par_PagoCuota = PagoDecenal) THEN
                        IF (DAY(FechaInicio) = FrecDecenal) THEN
                            SET FechaFinal  := DATE_ADD(FechaInicio, INTERVAL FrecDecenal DAY);
                          ELSE
                            IF (DAY(FechaInicio) < 6 ) THEN
                                SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '10'),DATE);
                              ELSE
                                IF(DAY(FechaInicio) < 16 ) THEN
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaInicio) , '-' ,MONTH(FechaInicio), '-' , '20'),DATE);
                                  ELSE
                                    IF(DAY(FechaInicio) < 26 ) THEN
                                        SET FechaFinal := LAST_DAY(FechaInicio);
                                      ELSE
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                      ELSE
                        -- pagos quincenales
                        IF (Par_PagoCuota = PagoQuincenal) THEN
                            # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                            IF(Par_DiaMes = FrecQuin) THEN
                                IF (DAY(FechaInicio) = FrecQuin) THEN
                                    SET FechaFinal  := DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
                                  ELSE
                                    IF (DAY(FechaInicio) >28) THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , '15'),DATE);
                                      ELSE
                                        SET FechaFinal  := DATE_ADD(DATE_SUB(FechaInicio, INTERVAL DAY(FechaInicio) DAY), INTERVAL FrecQuin DAY);
                                        IF  (FechaFinal <= FechaInicio) THEN
                                            SET FechaFinal := LAST_DAY(FechaInicio);
                                            IF(Var_DiasExtra>CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)) THEN
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            ELSE
                                # Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
                                SET Var_1erDiaQuinc := Par_DiaMes;
                                SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                IF (DAY(FechaInicio) = Var_1erDiaQuinc) THEN
                                    SET FechaFinal  := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                  ELSE
                                    IF (DAY(FechaInicio) >28) THEN
                                        SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , LPAD(Var_1erDiaQuinc,2,'0')));
                                      ELSE
                                        SET FechaFinal  := DATE(CONCAT(YEAR(FechaInicio),'-',MONTH(FechaInicio),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                        IF(FechaFinal <= FechaInicio) THEN
                                            SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),'-',
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)),'-',
                                                        LPAD(Var_1erDiaQuinc,2,'0')));
                                            IF(Var_DiasExtra>CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)) THEN
                                                SET FechaFinal := DATE(CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')));
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                          ELSE

                            IF (Par_PagoCuota = PagoMensual) THEN

                                IF (Par_PagoFinAni != PagoFinMes) THEN
                                    IF(Par_DiaMes>28)THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , 28),DATE);
                                        SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                            IF(Var_UltDia < Par_DiaMes)THEN
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);
                                              ELSE
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                                            END IF;
                                      ELSE
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' ,
                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                                    END IF;
                                  ELSE

                                    IF (Par_PagoFinAni = PagoFinMes) THEN
                                        IF (DAY(FechaInicio)>=28)THEN
                                            SET FechaFinal := DATE_ADD(FechaInicio, INTERVAL 2 MONTH);
                                            SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
                                          ELSE

                                            SET FechaFinal:= DATE_ADD(DATE_ADD(FechaInicio, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaInicio) DAY);
                                        END IF;
                                    END IF;
                                END IF;
                              ELSE
                                IF (Par_PagoCuota = PagoSemanal OR Par_PagoCuota = PagoPeriodo OR Par_PagoCuota = PagoCatorcenal ) THEN
                                    SET FechaFinal  := DATE_ADD(FechaInicio, INTERVAL Fre_Dias DAY);
                                  ELSE
                                    IF (Par_PagoCuota = PagoBimestral) THEN

                                        IF (Par_PagoFinAni != PagoFinMes) THEN
                                            IF(Par_DiaMes>28)THEN
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)) , '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , 28),DATE);
                                                SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                                IF(Var_UltDia < Par_DiaMes)THEN
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,Par_DiaMes),DATE);
                                                  ELSE
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)) , '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
                                                END IF;
                                              ELSE
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 2 MONTH)), '-' , Par_DiaMes),DATE);
                                            END IF;
                                          ELSE

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

                                            IF (Par_PagoFinAni != PagoFinMes) THEN
                                                IF(Par_DiaMes>28)THEN
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,  28),DATE);
                                                    SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                                    IF(Var_UltDia < Par_DiaMes)THEN
                                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' , Var_UltDia),DATE);
                                                      ELSE
                                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)),'-' , Par_DiaMes),DATE);
                                                    END IF;
                                                  ELSE
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)), '-' ,
                                                    MONTH(DATE_ADD(FechaInicio, INTERVAL 3 MONTH)) , '-' , Par_DiaMes),DATE);
                                                END IF;
                                              ELSE

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

                                                IF (Par_PagoFinAni != PagoFinMes) THEN
                                                    IF(Par_DiaMes>28)THEN
                                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , 28),DATE);
                                                        SET Var_UltDia := DAY(LAST_DAY(FechaFinal));
                                                        IF(Var_UltDia < Par_DiaMes)THEN
                                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)) , '-' ,
                                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Var_UltDia),DATE);

                                                          ELSE
                                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
                                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)),'-' , Par_DiaMes),DATE);
                                                        END IF;
                                                      ELSE
                                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' ,
                                                        MONTH(DATE_ADD(FechaInicio, INTERVAL 4 MONTH)), '-' , Par_DiaMes),DATE);
                                                    END IF;
                                                  ELSE

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

                                                    IF (Par_PagoFinAni != PagoFinMes) THEN
                                                        IF(Par_DiaMes>28)THEN
                                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
                                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , 28),DATE);
                                                            SET Var_UltDia := DAY(LAST_DAY(FechaFinal))*1;
                                                            IF(Var_UltDia < Par_DiaMes)THEN
                                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
                                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,Var_UltDia),DATE);

                                                              ELSE
                                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' ,
                                                                MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)) , '-' , Par_DiaMes),DATE);
                                                            END IF;
                                                          ELSE
                                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)),'-' ,
                                                            MONTH(DATE_ADD(FechaInicio, INTERVAL 6 MONTH)), '-' , Par_DiaMes),DATE);
                                                        END IF;
                                                      ELSE

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

                                                        SET FechaFinal  := DATE_ADD(FechaInicio, INTERVAL 1 YEAR);
                                                    END IF;
                                                END IF;
                                            END IF;
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                        END IF;
                    END IF;

                    IF(Par_DiaHabilSig = Var_SI) THEN
                        CALL DIASFESTIVOSCAL( FechaFinal, Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                        Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                        Aud_NumTransaccion);
                      ELSE
                        CALL DIASHABILANTERCAL(FechaFinal,    Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                        Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
                    END IF;


                    WHILE (DATEDIFF(FechaVig, FechaInicio) < Var_DiasExtra ) DO

                        IF (Par_PagoCuota = PagoDecenal) THEN
                            IF (DAY(FechaFinal) = FrecDecenal) THEN
                                SET FechaFinal  := DATE_ADD(FechaFinal, INTERVAL FrecDecenal DAY);
                              ELSE
                                IF (DAY(FechaFinal) < 6 ) THEN
                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '10'),DATE);
                                  ELSE
                                    IF(DAY(FechaFinal) < 16 ) THEN
                                        SET FechaFinal := CONVERT(  CONCAT(YEAR(FechaFinal) , '-' ,MONTH(FechaFinal), '-' , '20'),DATE);
                                      ELSE
                                        IF(DAY(FechaFinal) < 26 ) THEN
                                            SET FechaFinal := LAST_DAY(FechaFinal);
                                          ELSE
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                            MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , '10'),DATE);
                                        END IF;
                                    END IF;
                                END IF;
                            END IF;
                          ELSE
                            IF (Par_PagoCuota = PagoQuincenal ) THEN
                                # Si el día de la quincena es quince, entonces hace el cálculo de fechas normal.
                                IF(Par_DiaMes = FrecQuin) THEN
                                    IF (DAY(FechaFinal) = FrecQuin) THEN
                                        SET FechaFinal  := DATE_ADD(DATE_ADD(FechaFinal, INTERVAL 1 MONTH), INTERVAL -1 * DAY(FechaFinal) DAY);
                                      ELSE
                                        IF (DAY(FechaFinal) >28) THEN
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                            MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                          ELSE
                                            SET FechaFinal  := DATE_ADD(DATE_SUB(FechaFinal, INTERVAL DAY(FechaFinal) DAY), INTERVAL FrecQuin DAY);
                                            IF  (FechaFinal <= FechaInicio) THEN
                                                SET FechaFinal := LAST_DAY(FechaFinal);
                                                IF(CAST(DATEDIFF(FechaFinal, FechaInicio)AS SIGNED)<Var_DiasExtra) THEN
                                                    SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                                    MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , '15'),DATE);
                                                END IF;
                                            END IF;
                                        END IF;
                                    END IF;
                                ELSE
                                    # Si el día de la primer quincena es diferente a 15, entonces se calcula el día de la 2da quincena.
                                    SET Var_1erDiaQuinc := Par_DiaMes;
                                    SET Var_2doDiaQuinc := Var_1erDiaQuinc + FrecQuin;
                                    IF (DAY(FechaFinal) >= Var_2doDiaQuinc) THEN

                                        SET FechaFinal  := CONVERT(CONCAT(CONVERT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(4)) , '-' ,
                                                            CONVERT(MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)),CHAR(2)) , '-' , LPAD(Var_1erDiaQuinc,2,'0')),DATE);
                                    ELSE
                                        IF (DAY(FechaFinal) < Var_2doDiaQuinc) THEN
                                            SET FechaFinal  :=  DATE(CONCAT(YEAR(FechaFinal),'-',MONTH(FechaFinal),'-',LPAD(Var_2doDiaQuinc,2,'0')));
                                        END IF;
                                    END IF;
                                END IF;
                              ELSE

                                IF (Par_PagoCuota = PagoMensual  ) THEN
                                    IF (Par_PagoFinAni  != PagoFinMes) THEN
                                        IF(Par_DiaMes>28)THEN
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                            MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , 28),DATE);
                                            SET Var_UltDia :=DAY(LAST_DAY(FechaFinal));
                                            IF(Var_UltDia < Par_DiaMes)THEN
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,Var_UltDia),DATE);
                                              ELSE
                                                SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' ,
                                                MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)), '-' , Par_DiaMes),DATE);
                                            END IF;
                                          ELSE
                                            SET FechaFinal := CONVERT(  CONCAT(YEAR(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' ,
                                            MONTH(DATE_ADD(FechaFinal, INTERVAL 1 MONTH)) , '-' , Par_DiaMes),DATE);
                                        END IF;
                                      ELSE

                                        IF (Par_PagoFinAni = PagoFinMes) THEN
                                            IF ((CAST(DAY(FechaFinal)AS SIGNED)*1)>=28)THEN
                                                SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL 2 MONTH);
                                                SET FechaFinal := DATE_ADD(FechaFinal, INTERVAL -1*DAY(FechaFinal) DAY);
                                              ELSE

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
                        END IF;
                        IF(Par_DiaHabilSig = Var_SI) THEN
                            CALL DIASFESTIVOSCAL( FechaFinal, Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                            Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                            Aud_NumTransaccion);
                          ELSE
                            CALL DIASHABILANTERCAL(FechaFinal,    Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                            Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
                        END IF;
                    END WHILE;
                END IF;

                IF(Par_DiaHabilSig = Var_SI) THEN
                    CALL DIASFESTIVOSCAL( FechaFinal, Entero_Cero,    FechaVig,   Var_EsHabil,    Par_EmpresaID,
                    Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,
                    Aud_NumTransaccion);
                  ELSE
                    CALL DIASHABILANTERCAL(FechaFinal,    Entero_Cero,      FechaVig,   Par_EmpresaID,  Aud_Usuario,
                    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
                END IF;


                IF (Par_AjusFecExiVen= Var_SI)THEN
                    SET FechaFinal:= FechaVig;
                END IF;

                SET Fre_DiasTab   := (DATEDIFF(FechaFinal,FechaInicio));
                INSERT INTO TMPPAGAMORSIM(
                    Tmp_Consecutivo,  Tmp_FecIni, Tmp_FecFin,   Tmp_FecVig, Tmp_Dias,
                    NumTransaccion, Tmp_MontoSeguroCuota, Tmp_IVASeguroCuota)
                VALUES(
                    Contador+1,   FechaInicio,  FechaFinal,   FechaVig, Fre_DiasTab,
                    Aud_NumTransaccion, Par_MontoSeguroCuota, Var_IVASeguroCuota);

                SET Contador = Contador+1;
            END IF;
            SET Contador = Contador+1;
        END WHILE;


        SET Contador      := 1;

        WHILE (ContadorMargen <= NumIteraciones) DO
            WHILE (Contador <= Var_Cuotas) DO

               IF (Var_ProductoNomina = Var_SI) THEN
            IF(Par_PagoCuota = PagoQuincenal) THEN
                SET Fre_DiasTab := FrecQuin;
            ELSE IF(Par_PagoCuota = PagoMensual) THEN
                SET Fre_DiasTab := FrecMensual;
                END IF;
            END IF;
        ELSE
            SELECT Tmp_Dias INTO Fre_DiasTab
                FROM TMPPAGAMORSIM
                WHERE NumTransaccion = Aud_NumTransaccion
                AND Tmp_Consecutivo = Contador;
        END IF;

        SET Interes := ((Insoluto * Par_Tasa * Fre_DiasTab ) / (Fre_DiasAnio*100));
        SET IvaInt  := Interes * Var_IVA;
        SET Garantia := Par_MontoGL / Var_Cuotas;


                IF(Insoluto > 0) THEN
                    IF(Contador = Var_Cuotas)THEN
                        SET Capital := Insoluto;
                        SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,Capital + Interes);
                      ELSE

                        SET Capital := Pag_Calculado - Interes - IvaInt;

                        IF(Capital < Entero_Cero)THEN
                            SET Capital :=Entero_Uno;
                        END IF;
                        IF (Insoluto<=Capital) THEN
                            SET Capital := Insoluto;
                        END IF;
                        SET Var_CoutasAmor := CONCAT(Var_CoutasAmor,Capital + Interes,',');
                    END IF;

                    SET Insoluto    := Insoluto - Capital;
                    SET Subtotal    := Capital + Interes + IvaInt+Par_MontoSeguroCuota+Var_IVASeguroCuota;
                    UPDATE TMPPAGAMORSIM SET
                        Tmp_Capital   = Capital,
                        Tmp_Interes   = Interes,
                        Tmp_Iva     = IvaInt,
                        Tmp_SubTotal  = Subtotal,
                        Tmp_Insoluto  = Insoluto
                        WHERE NumTransaccion = Aud_NumTransaccion
                            AND Tmp_Consecutivo = Contador;
                  ELSE
                    SET Var_Cuotas  := Contador;
                    SET Contador := Var_Cuotas+10;
                END IF;

                SET Contador = Contador+1;
            END WHILE;
            SET Var_MontoCuota := Pag_Calculado;
            SET Var_Diferencia := Pag_Calculado-Subtotal;
            SET ContadorMargen = ContadorMargen+1;

            IF (ContadorMargen<=NumIteraciones)THEN
            IF (Var_ProductoNomina = Var_SI AND  (Par_PagoCuota = PagoQuincenal OR Par_PagoCuota = PagoMensual)) THEN
            SET DiferenciaCuota := 0.02;
        ELSE
            SET DiferenciaCuota := ROUND((ABS(Var_Diferencia) /(Var_Cuotas*3))/6,2);
        END IF;
                IF (ABS(Var_Diferencia) > Var_MargenPagIgual) THEN

                    IF(Var_Diferencia>Entero_Cero)THEN
                        IF(Subtotal>Pag_Calculado) THEN
                            SET Pag_Calculado   := Pag_Calculado-DiferenciaCuota;
                          ELSE
                            SET Pag_Calculado   := Pag_Calculado+DiferenciaCuota;
                        END IF;
                      ELSE
                        IF(Subtotal>Pag_Calculado) THEN
                            SET Pag_Calculado   := Pag_Calculado+DiferenciaCuota;
                          ELSE
                            SET Pag_Calculado   := Pag_Calculado+DiferenciaCuota;
                        END IF;
                    END IF;


                    SET Pag_Calculado := Pag_Calculado;
                    SET Insoluto    := Par_Monto;

                    IF (SELECT Var_CadCuotas LIKE CONCAT('%',Pag_Calculado,'%'))THEN
                        SET Contador := Var_Cuotas+1;
                        SET ContadorMargen := NumIteraciones+1;
                      ELSE
                        SET Var_CoutasAmor  := '';
                        SET Contador      :=1;
                    END IF;
                    SET Var_CadCuotas := CONCAT(Var_CadCuotas,',',Pag_Calculado);
                  ELSE
                    IF(Subtotal>Pag_Calculado) THEN
                        IF(Var_Diferencia>Entero_Cero)THEN
                            SET Pag_Calculado   := Pag_Calculado-DiferenciaCuota;
                          ELSE
                            SET Pag_Calculado   := Pag_Calculado+DiferenciaCuota;
                        END IF;


                        SET Pag_Calculado := Pag_Calculado;
                        SET Insoluto    := Par_Monto;

                        IF (SELECT Var_CadCuotas LIKE CONCAT('%',Pag_Calculado,'%'))THEN
                            SET Contador := Var_Cuotas+1;
                            SET ContadorMargen := NumIteraciones+1;
                          ELSE
                            SET Var_CoutasAmor  := '';
                            SET Contador      :=1;
                        END IF;
                        SET Var_CadCuotas := CONCAT(Var_CadCuotas,',',Pag_Calculado);
                      ELSE
                        SET ContadorMargen := NumIteraciones+1;
                        SET Contador = Var_Cuotas+1;
                    END IF;
                END IF;
            END IF;
        END WHILE;



        SELECT Tmp_Consecutivo
            INTO Var_Cuotas
            FROM TMPPAGAMORSIM
                WHERE NumTransaccion=Aud_NumTransaccion
                    AND Tmp_Insoluto= 0 LIMIT 1;

        DELETE FROM TMPPAGAMORSIM
            WHERE Tmp_Consecutivo > Var_Cuotas AND NumTransaccion=Aud_NumTransaccion;



        SET Par_FechaVenc := (SELECT MAX(Tmp_FecFin) FROM TMPPAGAMORSIM WHERE   NumTransaccion = Aud_NumTransaccion);


       IF(Var_CobraAccesoriosGen = Var_SI AND Var_CobraAccesorios = Var_SI) THEN
			SELECT		SolicitudCreditoID,		CreditoID,		PlazoID ,		TipoFormaCobro
				INTO	Var_SolicitudCreditoID,	Var_CreditoID,	Var_PlazoID,	Var_TipoFormaCobro
				FROM DETALLEACCESORIOS
				WHERE NumTransacSim = Aud_NumTransaccion
                AND MontoAccesorio = Decimal_Cero LIMIT 1;

			SET Var_SolicitudCreditoID 	:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
			SET Var_CreditoID 			:= IFNULL(Var_CreditoID, Entero_Cero);
			SET Var_PlazoID 			:= IFNULL(Var_PlazoID, Entero_Cero);
            SET Var_TipoFormaCobro		:= IFNULL(Var_TipoFormaCobro, Cadena_Vacia);


			IF(Var_TipoFormaCobro = FormaFinanciado) THEN
				# SE DAN DE ALTA LOS ACCESORIOS COBRADOS POR EL CREDITO PARA GRABARLOS DEFINITIVAMENTE
				CALL DETALLEACCESORIOSALT(
					Var_CreditoID,		Var_SolicitudCreditoID,		Par_ProdCredID,		Par_ClienteID,		Aud_NumTransaccion,
					Var_PlazoID,		OperaSimulador,				Par_Monto,          Entero_Cero,        Var_No,
                    Par_NumErr, 		Par_ErrMen,                 Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
                    Aud_DireccionIP,	Aud_ProgramaID,             Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				# SE CALCULA EL VALOR DE LAS COMISIONES COBRADAS POR EL CREDITO
				CALL CALCOTRASCOMISIONESPRO(
					Aud_NumTransaccion,     Par_ClienteID,      Par_ProdCredID,		Par_Monto,          Par_Tasa,
					Var_No,					Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;
            END IF;

        END IF;



        CALL CALCULARCATPRO(
                Par_Monto,      Var_CoutasAmor,     Var_FrecuPago,      Var_No,     Par_ProdCredID,
                Par_ClienteID,      Par_ComAper,        Par_ComAnualLin,    Var_CAT,    Aud_NumTransaccion);


        SELECT SUM(Tmp_Capital),            SUM(Tmp_Interes),   SUM(Tmp_Iva),   SUM(Tmp_MontoSeguroCuota), SUM(Tmp_IVASeguroCuota),
                SUM(Tmp_OtrasComisiones),   SUM(Tmp_IVAOtrasComisiones)
            INTO Var_TotalCap,              Var_TotalInt,       Var_TotalIva,   Var_TotalSeguroCuota,       Var_TotalIVASeguroCuota,
                Var_SaldoOtrasComisiones,   Var_SaldoIVAOtrasComisiones
            FROM TMPPAGAMORSIM
            WHERE   NumTransaccion = Aud_NumTransaccion;

        SET Var_TotalSeguroCuota        := IFNULL(Var_TotalSeguroCuota,Decimal_Cero);
        SET Var_TotalIVASeguroCuota     := IFNULL(Var_TotalIVASeguroCuota, Decimal_Cero);
        SET Var_SaldoOtrasComisiones    := IFNULL(Var_SaldoOtrasComisiones, Decimal_Cero);
        SET Var_SaldoIVAOtrasComisiones := IFNULL(Var_SaldoIVAOtrasComisiones, Decimal_Cero);


        SET Par_NumTran   := Aud_NumTransaccion;
        SET Par_Cat     := Var_CAT;
        SET Par_Cuotas    := Var_Cuotas;
        SET Par_MontoCuo  := Pag_Calculado;
        SET Var_MontoCuota := (Var_MontoCuota+Par_MontoSeguroCuota + Var_IVASeguroCuota);
        SET Par_FechaVen  := Par_FechaVenc;
        SET Par_NumErr    := 0;
        SET Par_ErrMen    := 'Simulacion Exitosa';

    END ManejoErrores;
    IF (Par_Salida = Salida_SI) THEN
        IF(Par_NumErr = Entero_Cero) THEN
            SELECT
                Tmp_Consecutivo,                    Tmp_FecIni,                             Tmp_FecFin,
                Tmp_FecVig,                         FORMAT(Tmp_Capital,2)AS Tmp_Capital,    FORMAT(Tmp_Interes,2)AS Tmp_Interes,
                FORMAT(Tmp_Iva,2) AS Tmp_Iva,       FORMAT(Tmp_SubTotal,2)AS Tmp_SubTotal,  FORMAT(Tmp_Insoluto,2)  AS Tmp_Insoluto,
                Tmp_Dias,                           Var_Cuotas,                             NumTransaccion,
                Var_CAT,                            Par_FechaVenc,                          Par_FechaInicio,
                Var_MontoCuota AS MontoCuota,
                FORMAT(Var_TotalCap,2) AS TotalCap,
                FORMAT(Var_TotalINT,2) AS TotalInt,
                FORMAT(Var_TotalIva,2) AS TotalIva,
                Par_CobraSeguroCuota AS CobraSeguroCuota,
                FORMAT(Tmp_MontoSeguroCuota,2) AS MontoSeguroCuota,
                FORMAT(Tmp_IVASeguroCuota,2) AS IVASeguroCuota,
                Var_TotalSeguroCuota AS TotalSeguroCuota,
                Var_TotalIVASeguroCuota AS TotalIVASeguroCuota,
                Tmp_OtrasComisiones AS OtrasComisiones,
                Tmp_IVAOtrasComisiones  AS IVAOtrasComisiones,
                Var_SaldoOtrasComisiones AS TotalOtrasComisiones,
                Var_SaldoIVAOtrasComisiones AS TotalIVAOtrasComisiones,
                Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen
                FROM    TMPPAGAMORSIM
                    WHERE   NumTransaccion = Aud_NumTransaccion;
          ELSE
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