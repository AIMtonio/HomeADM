-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SIMULADORCREVBCPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SIMULADORCREVBCPRO`;
DELIMITER $$

CREATE PROCEDURE `SIMULADORCREVBCPRO`(
    -- SP para generar el simulador de amortizaciones que se manda a llamar desde un ws
    -- dependiendo de los parametros se ejecuta el indicado
    Par_Monto                   DECIMAL(14,2),          -- Monto a prestar
    Par_Tasa                    DECIMAL(14,4),          -- Tasa Anualizada
    Par_Frecuencia              CHAR(1),                -- Pago de la cuota (Semanal (S), Catorcenal(C) , Quincenal (Q), Mensual(M), P .- Periodo B.-Bimestral T.-Trimestral R.-TetraMestral E.-Semestral A.-Anual)
    Par_Periodicidad            INT(11),                -- Periodicidad del pago en Dias (si el pago es Periodo)
    Par_FechaInicio             DATE,                   -- fecha en que empiezan los pagos

    Par_NumeroCuotas            INT(11),                -- Numero de Cuotas que se simularan
    Par_ProdCredID              INT(11),                -- identificador de PRODUCTOSCREDITO para obtener dias de gracia y margen para pag iguales
    Par_ClienteID               INT(11),                -- identificador de CLIENTES para obtener el valor PagaIVA
    Par_ComAper                 DECIMAL(14,2),          -- Monto de la comision por apertura
    Par_Usuario                 VARCHAR(400),           -- USUARIO

    Par_Clave                   VARCHAR(400),           -- CLAVE
    Par_Salida                  CHAR(1),                -- Indica si hay una salida o no
    INOUT   Par_NumErr          INT(11),                -- NUMERO ERROR
    INOUT   Par_ErrMen          VARCHAR(400),           -- MENSAJE
    Aud_EmpresaID               INT(11),                -- Parametro de Auditoria

    Aud_Usuario                 INT(11),                -- Parametro de Auditoria
    Aud_FechaActual             DATETIME,               -- Parametro de Auditoria
    Aud_DireccionIP             VARCHAR(15),            -- Parametro de Auditoria
    Aud_ProgramaID              VARCHAR(50),            -- Parametro de Auditoria
    Aud_Sucursal                INT(11),                -- Parametro de Auditoria

    Aud_NumTransaccion          BIGINT(20)              -- Parametro de Auditoria
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control             VARCHAR(100);       -- Variable de control
DECLARE VarProductoCreditoID    INT;                -- PRODUCTO DE CREDITO
DECLARE VarFecInHabTomar        CHAR(1);            -- FECHA IN HABIL
DECLARE VarAjusFecExigVenc      CHAR(1);            -- FECHA EXIGIBLE
DECLARE VarAjusFecUlAmoVen      CHAR(1);            -- ULTIMA FECHA AMORTIZACION
DECLARE VarTipoPagoCapital      CHAR(15);           -- TIPO DE PAGO DE CAPITAL
DECLARE VarFrecuencias          VARCHAR(200);       -- FRECUENCIA
DECLARE VarPlazoID              TEXT;           	-- PLAZO
DECLARE VarDiaPagoCapital       CHAR(1);            -- DIA CAPITAL
DECLARE VarDiaPagoInteres       CHAR(1);            -- DIA INTERES
DECLARE Var_DiaMesCap           INT(11);            -- MES CAPITAL
DECLARE Var_DiaMesIn            INT(11);            -- MES INTERES
DECLARE Var_MontoSeguro         DECIMAL(14,2);      -- MONTO DE SEGURO
DECLARE VarCobraSeguroCuota     CHAR(1);            -- COBRA SEGURO CUOTA
DECLARE VarCobraIVASeguroCuota  CHAR(1);            -- IVA SEGURO CUOTA
DECLARE VarCrecientes           CHAR(1);            -- CRECIENTE
DECLARE VarIguales              CHAR(1);            -- IGUALES

DECLARE Par_NumTran             BIGINT(20);         -- Numero de transaccion con el que se genero el calendario de pagos
DECLARE Par_Cuotas              INT(11);            -- NUMERO DE CUOTAS
DECLARE Par_Cat                 DECIMAL(14,4);      -- cat que corresponde con lo generado
DECLARE Par_MontoCuo            DECIMAL(14,4);      -- corresponde con la cuota promedio a pagar
DECLARE Par_FechaVen            DATE;               -- FECHA DE VENCIMIENTO
DECLARE Var_PerfilWsVbc         INT(11);            -- PERFIL OPERACIONES VBC


-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia            CHAR(1);            -- cadena vacia
DECLARE Fecha_Vacia             DATE;               -- fecha vacia
DECLARE Entero_Cero             INT;                -- entero cero
DECLARE Var_SI                  CHAR(1);            -- valor si
DECLARE Var_NO                  CHAR(1);            -- valor no
DECLARE Var_Aniversario         CHAR(1);            -- dia de pago por ANIVERSARIO
DECLARE Var_DiaDelMes           CHAR(1);            -- dia de pago por DIA DEL MES
DECLARE Var_Indistinto          CHAR(1);            -- dia de pago por INDISTINTO
DECLARE Est_Activo              CHAR(1);            -- estatus activo
DECLARE PagoSemanal             CHAR(1);            -- Pago Semanal (S)
DECLARE PagoDecenal             CHAR(1);            -- Pago Decenal (D)
DECLARE PagoCatorcenal          CHAR(1);            -- Pago Catorcenal (C)
DECLARE PagoQuincenal           CHAR(1);            -- Pago Quincenal (Q)
DECLARE PagoMensual             CHAR(1);            -- Pago Mensual (M)
DECLARE PagoPeriodo             CHAR(1);            -- Pago por periodo (P)
DECLARE PagoBimestral           CHAR(1);            -- PagoBimestral (B)
DECLARE PagoTrimestral          CHAR(1);            -- PagoTrimestral (T)
DECLARE PagoTetrames            CHAR(1);            -- PagoTetraMestral (R)
DECLARE PagoSemestral           CHAR(1);            -- PagoSemestral (E)
DECLARE PagoAnual               CHAR(1);            -- PagoAnual (A)
DECLARE PagoUnico               CHAR(1);            -- Pago Unico (U)
DECLARE Var_CliEsp              INT(11);
DECLARE Var_CliCred             INT(11);
DECLARE Var_SucOrigen           INT(11);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia            := '';                  -- Cadena Vacia
SET Fecha_Vacia             := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero             := 0;                   -- Entero en Cero
SET Var_SI                  := 'S';                 -- Permite Salida SI
SET Var_NO                  := 'N';                 -- Permite Salida NO
SET Var_Aniversario         := 'A';                 -- Dia de pago ANIVERSARIO
SET Var_DiaDelMes           := 'D';                 -- dia de pago por DIA DEL MES
SET Var_Indistinto          := 'I';                 -- dia de pago por INDISTINTO
SET VarCrecientes           := 'C';                 -- CRECIENTES
SET VarIguales              := 'I';                 -- IGUALES
SET Est_Activo              := 'A';                 -- ESTATUS ACTIVO
SET PagoSemanal             := 'S';                 -- PagoSemanal
SET PagoDecenal             := 'D';                 -- Pago Decenal
SET PagoCatorcenal          := 'C';                 -- PagoCatorcenal
SET PagoQuincenal           := 'Q';                 -- PagoQuincenal
SET PagoMensual             := 'M';                 -- PagoMensual
SET PagoPeriodo             := 'P';                 -- PagoPeriodo
SET PagoBimestral           := 'B';                 -- PagoBimestral
SET PagoTrimestral          := 'T';                 -- PagoTrimestral
SET PagoTetrames            := 'R';                 -- PagoTetraMestral
SET PagoSemestral           := 'E';                 -- PagoSemestral
SET PagoAnual               := 'A';                 -- PagoAnual
SET PagoUnico               := 'U';   
SET Var_CliEsp              := (SELECT  IFNULL(ValorParametro,Entero_Cero) FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');
SET Var_CliCred             := 24; -- CREDICLUB

-- ASIGNACION DE VARIABLES
SET Aud_FechaActual         := NOW();               -- FECHA ACTUAL

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-SIMULADORCREVBCPRO');
            SET Var_Control = 'SQLEXCEPTION';
        END;


    -- **************************************************************************************
    -- SE VALIDA EL USUARIO   *******************
    -- **************************************************************************************
    SET Var_PerfilWsVbc     := (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc     := IFNULL(Var_PerfilWsVbc,Entero_Cero);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
        SET Par_NumErr      := '60';
        SET Par_ErrMen      := 'No existe perfil definido para el usuario.';
        LEAVE ManejoErrores;
    END IF;

    SET Aud_Usuario := (SELECT UsuarioID
                            FROM USUARIOS
                            WHERE Clave = Par_Usuario
                                AND Contrasenia = Par_Clave
                                AND Estatus = Est_Activo  AND RolID = Var_PerfilWsVbc);

    SET Aud_Usuario := IFNULL(Aud_Usuario, Entero_Cero);
    IF(Aud_Usuario = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "Usuario o Password no valido";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;

    -- **************************************************************************************
    -- SE VALIDA EL MONTO   *******************
    -- **************************************************************************************
    IF(Par_Monto = Entero_Cero)THEN
        SET Par_NumErr      := 1;
        SET Par_ErrMen      := "El monto solicitado esta Vacio.";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;

    -- **************************************************************************************
    -- SE VALIDA LA FRECUENCIA   *******************
    -- **************************************************************************************
    IF(Par_Frecuencia = Cadena_Vacia)THEN
        SET Par_NumErr      := 2;
        SET Par_ErrMen      := "La frecuencia esta Vacia.";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;


    -- **************************************************************************************
    -- SE VALIDA EL NUMERO DE CUOTAS   *******************
    -- **************************************************************************************
    IF(Par_NumeroCuotas = Entero_Cero)THEN
        SET Par_NumErr      := 3;
        SET Par_ErrMen      := "El Numero de Cuotas esta Vacio.";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;

    -- **************************************************************************************
    -- SE VALIDA LA FRECUENCIA   *******************
    -- **************************************************************************************
    IF(Par_Tasa = Entero_Cero)THEN
        SET Par_NumErr      := 4;
        SET Par_ErrMen      := "La Tasa esta Vacia.";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;


    IF(Par_FechaInicio = Fecha_Vacia)THEN
        SET Par_NumErr      := 4;
        SET Par_ErrMen      := "La Fecha esta Vacia.";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;

    SET Par_ClienteID   := (SELECT ClienteID FROM CLIENTES WHERE ClienteID = Par_ClienteID);
    SET Par_ClienteID   := IFNULL(Par_ClienteID,Entero_Cero);
    IF(Par_ClienteID = Entero_Cero)THEN
        SET Par_NumErr      := 4;
        SET Par_ErrMen      := "El cliente no existe";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;

    -- **************************************************************************************
    -- SE VALIDA LA PERIODICIDAD   *******************
    -- **************************************************************************************
    CASE Par_Frecuencia
        WHEN PagoSemanal        THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoDecenal        THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoCatorcenal     THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoQuincenal      THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoMensual        THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoPeriodo        THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoBimestral      THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoTrimestral     THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoTetrames       THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoSemestral      THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoAnual          THEN SET Par_Frecuencia   := Par_Frecuencia;
        WHEN PagoUnico          THEN SET Par_Frecuencia   := Par_Frecuencia;
        ELSE
            SET Par_NumErr      := 1;
            SET Par_ErrMen      := "El Valor Especificado para la Frecuencia no es Valido";
            SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                    Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                    Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
            LEAVE ManejoErrores;
    END CASE;

    -- **************************************************************************************
    -- SE VALIDA EL  PRODUCTO DE CREDITO   *******************
    -- **************************************************************************************
    IF(Par_ProdCredID = Entero_Cero)THEN
        SET Par_NumErr      := 10;
        SET Par_ErrMen      := "El producto de credito esta vacio.";
        SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
        LEAVE ManejoErrores;
    END IF;

    SELECT      CobraSeguroCuota,       CobraIVASeguroCuota,    ProducCreditoID
        INTO    VarCobraSeguroCuota,    VarCobraIVASeguroCuota, VarProductoCreditoID
        FROM PRODUCTOSCREDITO
            WHERE ProducCreditoID = Par_ProdCredID;

    SET VarProductoCreditoID    := IFNULL(VarProductoCreditoID,Entero_Cero);
    IF(VarProductoCreditoID = Entero_Cero) THEN
        SET Par_NumErr      := 11;
            SET Par_ErrMen      := "El Producto de Credito no existe";
            SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                    Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                    Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
            LEAVE ManejoErrores;
    END IF;
    -- **************************************************************************************
    -- SE OBTIENEN LOS DATOS DEL PRODUCTO DE CREDITO   *******************
    -- **************************************************************************************

    SELECT      ProductoCreditoID,      FecInHabTomar,      AjusFecExigVenc,        AjusFecUlAmoVen,
                CASE WHEN LOCATE(',',TipoPagoCapital)   >Entero_Cero THEN SUBSTRING(TipoPagoCapital,1,(LOCATE(',',TipoPagoCapital)-1))  ELSE  TipoPagoCapital END,
                CASE WHEN LOCATE(',',Frecuencias)       >Entero_Cero THEN SUBSTRING(Frecuencias,    1,(LOCATE(',',Frecuencias)-1))      ELSE  Frecuencias END,
                CASE WHEN LOCATE(',',PlazoID)           >Entero_Cero THEN SUBSTRING(PlazoID,        1,(LOCATE(',',PlazoID)-1))          ELSE  PlazoID END,
                DiaPagoCapital,         DiaPagoInteres
        INTO    VarProductoCreditoID,   VarFecInHabTomar,   VarAjusFecExigVenc,     VarAjusFecUlAmoVen,     VarTipoPagoCapital,
                VarFrecuencias,         VarPlazoID,         VarDiaPagoCapital,      VarDiaPagoInteres
        FROM CALENDARIOPROD
            WHERE ProductoCreditoID = Par_ProdCredID;

    SET VarProductoCreditoID    := IFNULL(VarProductoCreditoID,Entero_Cero);
    IF(VarProductoCreditoID = Entero_Cero) THEN
        SET Par_NumErr      := 11;
            SET Par_ErrMen      := "El Producto de Credito indicado no esta parametrizado.";
            SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                    Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                    Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
            LEAVE ManejoErrores;
    END IF;

    -- Valida el dia de pago del capital, puede ser por ANIVERSARIO, INDISTINTO O DIA DEL MES.
    SET Var_DiaMesCap   := DAY(Par_FechaInicio);
    SET Var_DiaMesIn    := DAY(Par_FechaInicio);

    SET Var_MontoSeguro := (SELECT Monto FROM ESQUEMASEGUROCUOTA WHERE ProducCreditoID = VarProductoCreditoID AND Frecuencia = VarFrecuencias);
    SET Var_MontoSeguro := IFNULL(Var_MontoSeguro, Entero_Cero);

    IF(Var_CliEsp = Var_CliCred) THEN
        SELECT SucursalOrigen INTO
                Var_SucOrigen
            FROM CLIENTES WHERE ClienteID=Par_ClienteID;
        SET Var_SucOrigen := IFNULL(Var_SucOrigen,Entero_Cero);
        SET Aud_Sucursal  := Var_SucOrigen;
    ELSE
    SET Aud_Sucursal  := (SELECT SucursalMatrizID FROM PARAMETROSSIS);

    END IF;


    CASE VarTipoPagoCapital
        WHEN VarCrecientes THEN
            -- ********************************************************************************************
            -- SE MANDA A LLAMAR A SP DE PAGOS CRECIENTES  DE CAPITAL- ************************************
            -- ********************************************************************************************
            CALL CREPAGCRECAMORPRO(
                Entero_Cero,
                Par_Monto,              Par_Tasa,               Par_Periodicidad,   Par_Frecuencia,     VarDiaPagoCapital,
                Var_DiaMesCap,          Par_FechaInicio,        Par_NumeroCuotas,   Par_ProdCredID,     Par_ClienteID,
                VarFecInHabTomar,       VarAjusFecUlAmoVen,     VarAjusFecExigVenc, Par_ComAper,        Entero_Cero,
                VarCobraSeguroCuota,    VarCobraIVASeguroCuota, Var_MontoSeguro,    Entero_Cero,    Par_Salida,
                Par_NumErr,             Par_ErrMen,             Par_NumTran,        Par_Cuotas,         Par_Cat,
                Par_MontoCuo,           Par_FechaVen,           Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

        WHEN VarIguales THEN
            -- ********************************************************************************************
            -- SE MANDA A LLAMAR A SP DE PAGOS IGUALES  DE CAPITAL- ************************************
            -- ********************************************************************************************
            CALL CREPAGIGUAMORPRO(
                Par_Monto,              Par_Tasa,               Par_Periodicidad,   Par_Periodicidad,   Par_Frecuencia,
                Par_Frecuencia,         VarDiaPagoCapital,      VarDiaPagoCapital,  Par_FechaInicio,    Par_NumeroCuotas,
                Par_NumeroCuotas,       Par_ProdCredID,         Par_ClienteID,      VarFecInHabTomar,   VarAjusFecUlAmoVen,
                VarAjusFecExigVenc,     Var_DiaMesIn,           Var_DiaMesCap,      Par_ComAper,        Entero_Cero,
                VarCobraSeguroCuota,    VarCobraIVASeguroCuota, Var_MontoSeguro,    Entero_Cero,    Par_Salida,
                Par_NumErr,             Par_ErrMen,             Par_NumTran,        Par_Cuotas,         Par_Cuotas,
                Par_Cat,                Par_MontoCuo,           Par_FechaVen,       Aud_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
        ELSE
            SET Par_NumErr      := 10;
            SET Par_ErrMen      := "El tipo de pago de capita no es valido.";
            SELECT  Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,
                    Cadena_Vacia,                           Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia AS CobraSeguroCuota,
                    Cadena_Vacia AS MontoSeguroCuota,       Cadena_Vacia AS IVASeguroCuota,   Cadena_Vacia AS TotalSeguroCuota,
                    Cadena_Vacia AS TotalIVASeguroCuota,    Par_NumErr AS NumErr,       Par_ErrMen AS ErrMen;
            LEAVE ManejoErrores;

    END CASE;


END ManejoErrores;


SET Par_NumErr      := 0;
SET Par_ErrMen      := CONCAT(Par_NumErr);

END TerminaStore$$