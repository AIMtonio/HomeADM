-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOWSPRO`;
DELIMITER $$

CREATE PROCEDURE `SOLICITUDCREDITOWSPRO`(
    -- SP PARA DAR DE ALTA LAS REFERENCIAS DE LA SOLICITUD DE CREDITO

    Par_ClienteID           INT(11),            -- CLIENTE ID
    Par_SolicitudCreditoID  BIGINT(20),         -- Numero de solicitud de credito
    Par_ProduCredID         INT(11),            -- PRODUCTO DE CREDITO
    Par_FechaReg            DATE,               -- FECHA DE REGISTRO
    Par_InstitNominaID      INT(11),            -- INSTITUCION DE NOMINA

    Par_FolioCtrl           VARCHAR(20),        -- FOLIO DE CONTROL
    Par_MontoSolic          DECIMAL(12,2),      -- MONTO DE SOLICITUD
    Par_TasaFija            DECIMAL(12,4),      -- TASA FIJA
    Par_FrecCapital         CHAR(1),            -- "Periodicidad de las Amortizaciones: Valor por DEFAULT:  “Q” - Quincenal"
    Par_PlazoID             INT(11),            -- ID DE PLAZO

    Par_NumOpe              TINYINT UNSIGNED,   -- TIPO DE OPERACION 1 = Alta, 2 = Modificacion
    Par_Usuario             VARCHAR(400),       -- USUARIO
    Par_Clave               VARCHAR(400),       -- LLAVE
    Par_Salida              CHAR(1),            -- Indica si hay una salida o no
    INOUT Par_NumErr        INT(11),

    INOUT Par_ErrMen        VARCHAR(400),       -- MENSAJE
    Aud_EmpresaID           INT(11),            -- Parametro de Auditoria
    Aud_Usuario             INT(11),            -- Parametro de Auditoria
    Aud_FechaActual         DATETIME,           -- Parametro de Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de Auditoria

    Aud_ProgramaID          VARCHAR(50),        -- Parametro de Auditoria
    Aud_Sucursal            INT(11),            -- Parametro de Auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de Auditoria
)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Control             VARCHAR(50);    -- CONTROL
DECLARE Var_Consecutivo         VARCHAR(50);    -- CONSECUTIVO
DECLARE Var_SolicitudCreditoID  BIGINT(20);     -- Variable para validacion de que existe la solicitud de credito
DECLARE Var_Dias                INT(11);        -- DIAS
DECLARE Var_ClienteID           INT;            -- CLIENTE ID
DECLARE Var_Estatus             CHAR(1);        -- ESTATUS
DECLARE ClienteInactivo         CHAR(1);        -- CLIENTE INACTIVO
DECLARE Var_FuncionHuella       CHAR(1);        -- FUNCION HUELLA
DECLARE Var_ReqHuellaProductos  CHAR(1);        -- REQ HUELLA PRODUCTOS
DECLARE Var_FechaSistema        DATE;           -- FECHA DE SISTEMA
DECLARE VarProductoCreditoID    INT;            -- PRODUCTO ID
DECLARE Var_PerfilWsVbc         INT(11);        -- PERFIL OPERACIONES VBC
DECLARE Par_ProspectoID         BIGINT(20);     -- PROSPECTO
DECLARE Par_Promotor            INT(11);        -- PROMOTOR
DECLARE Par_TipoCredito         CHAR(1);        -- TIPO DE CREDITO
DECLARE Par_NumCreditos         INT(11);        -- NUMERO DE CREDITOS
DECLARE Par_Relacionado         BIGINT(12);     -- RELACIONADO
DECLARE Par_AporCliente         DECIMAL(12,2);  -- APORTA CLIENTE
DECLARE Var_ClasifiCli          CHAR(1);        -- Clasificacion del cliente
DECLARE Par_Moneda              INT(11);        -- MONEDA
DECLARE Par_DestinoCre          INT(11);        -- DESTINO DE CREDITO
DECLARE Par_Proyecto            VARCHAR(500);   -- PROYECTO
DECLARE Par_SucursalID          INT(11);        -- SUCURSAL
DECLARE Par_FactorMora          DECIMAL(8,4);   -- FACTOR MORA
DECLARE Par_ComApertura         DECIMAL(12,4);  -- COMISION POR APERTURA
DECLARE Par_IVAComAper          DECIMAL(12,4);  -- IVA DE COMISION POR APERTURA
DECLARE Par_TipoDisper          CHAR(1);        -- TIPO DE DISPERSION
DECLARE Par_CalcInteres         INT(11);        -- CALCULO DE INTERES
DECLARE Par_TasaBase            DECIMAL(12,4);  -- TASA BASE
DECLARE Par_SobreTasa           DECIMAL(12,4);  -- SOBRE TASA
DECLARE Par_PisoTasa            DECIMAL(12,4);  -- PISO TASA
DECLARE Par_TechoTasa           DECIMAL(12,4);  -- TECHO TASA
DECLARE Par_FechInhabil         CHAR(1);        -- FECHA INHABIL
DECLARE Par_AjuFecExiVe         CHAR(1);        -- AJUSTA FECHA
DECLARE Par_CalIrreg            CHAR(1);        -- CALENDARIO IRREGULAR
DECLARE Par_AjFUlVenAm          CHAR(1);        -- AJUSTA ULTIMA FECHA
DECLARE Par_TipoPagCap          CHAR(1);        -- TIPO DE PAGO DE CAPITAL
DECLARE Par_PeriodInt           INT(11);        -- PERIODICIDAD ENTERO
DECLARE Par_PeriodCap           INT(11);        -- PERIODICIDAD CAPITAL
DECLARE Par_DiaPagInt           CHAR(1);        -- DIA PAG INT
DECLARE Par_DiaPagCap           CHAR(1);        -- DIA PAGO CAPITAL
DECLARE Par_DiaMesInter         INT(11);        -- DIA MES INTERES
DECLARE Par_DiaMesCap           INT(11);        -- DIA MES CAPITAL
DECLARE Par_NumAmorti           INT(11);        -- NUMERO AMORTIZACIONES
DECLARE Par_NumTransacSim       BIGINT(20);     -- NUMERO TRANSACCION
DECLARE Par_CAT                 DECIMAL(12,4);  -- CAT
DECLARE Par_CuentaClabe         CHAR(18);       -- CUENTA CLABE
DECLARE Par_TipoCalInt          INT(11);        -- TIPO CAL INTERES
DECLARE Par_TipoFondeo          CHAR(1);        -- FONDEO
DECLARE Par_InstitFondeoID      INT(11);        -- INSTITTUCION FONDEO
DECLARE Par_LineaFondeo         INT(11);        -- LINEA  FONDEO
DECLARE Par_NumAmortInt         INT(11);        -- NUMERO DE AMOR INT
DECLARE Par_MontoCuota          DECIMAL(12,2);  -- MONTO CUOTA
DECLARE Par_GrupoID             INT(11);        -- GRUPO ID
DECLARE Par_TipoIntegr          INT(11);        -- TIPO DE INTEGRANTE
DECLARE Par_FechaVencim         DATE;           -- FECHA DE VENCIMIENTO
DECLARE Par_FechaInicio         DATE;           -- FECHA INICIO
DECLARE Par_MontoSeguroVida     DECIMAL(12,2);  -- MONTO SEGURO DE VIDA
DECLARE Par_ForCobroSegVida     CHAR(1);        -- FOR COBRO SEG VIDA
DECLARE Par_ClasiDestinCred     CHAR(1);        -- CLASIFICA DESTINO
DECLARE Par_HorarioVeri         VARCHAR(20);    -- HORARIO
DECLARE Par_PorcGarLiq          DECIMAL(12,2);  -- PORCENTAJE GARANTIA LIQUIDA
DECLARE Par_DescuentoSeguro     DECIMAL(12,2);  -- DESCUENTO SEGURO
DECLARE Par_MontoSegOriginal    DECIMAL(12,2);  -- MONTO SEG ORIGINAL
DECLARE Par_Comentario          VARCHAR(500);   -- COMENTARIO
DECLARE VarFrecuencias          CHAR(10);       -- frecuencia
DECLARE Var_ProductoNomina      CHAR(1);        -- PRODUCTO NOMINA
DECLARE Var_TipoConsultaSIC		CHAR(2);		-- TIPO CONSULTA SIC
DECLARE Var_FechaCobroComision 	DATE;		-- Fecha de cobro de la comision por apertura
-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia            CHAR(1);        -- CADENA VACIA
DECLARE Fecha_Vacia             DATE;           -- FECHA VACIA
DECLARE Entero_Cero             INT;            -- ENTERO CERO
DECLARE Var_SI                  CHAR(1);        -- VALOR SI
DECLARE Var_NO                  CHAR(1);        -- VALOR NO

DECLARE Var_Interesado          CHAR(1);        -- S: Si esta interesando en ser referencia N:No esta interesado
DECLARE Var_Validado            CHAR(1);        -- S:Si esta validada la referencia N: DEFAULT Si no ha sido validado
DECLARE Var_OpAlta              INT;            -- OPERACION DE ALTA
DECLARE Var_OpMod               INT;            -- OPERACION DE MODIFICA
DECLARE Est_Activo              CHAR(1);        -- ESTATUS ACTIVO
DECLARE SI_Huella               CHAR(1);        -- SI HUELLA
DECLARE Persona_Cliente         CHAR(1);        -- PERSONA
DECLARE MenorEdad               CHAR(1);        -- MENOR EDAD

DECLARE PagoSemanal             CHAR(1);        -- Pago Semanal (S)
DECLARE PagoDecenal             CHAR(1);        -- Pago Decenal (D)
DECLARE PagoCatorcenal          CHAR(1);        -- Pago Catorcenal (C)
DECLARE PagoQuincenal           CHAR(1);        -- Pago Quincenal (Q)
DECLARE PagoMensual             CHAR(1);        -- Pago Mensual (M)
DECLARE PagoPeriodo             CHAR(1);        -- Pago por periodo (P)
DECLARE PagoBimestral           CHAR(1);        -- PagoBimestral (B)
DECLARE PagoTrimestral          CHAR(1);        -- PagoTrimestral (T)
DECLARE PagoTetrames            CHAR(1);        -- PagoTetraMestral (R)
DECLARE PagoSemestral           CHAR(1);        -- PagoSemestral (E)
DECLARE PagoAnual               CHAR(1);        -- PagoAnual (A)
DECLARE PagoUnico               CHAR(1);        -- Pago Unico (U)
DECLARE	ConSic_TipoBuro			CHAR(2);		-- Consulta tipo buro
DECLARE ConSic_TipoCirculo		CHAR(2);		-- Consulta tipo circulo
DECLARE Con_TipoBuro			CHAR(1);

-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia            := '';              -- Cadena Vacia
SET Fecha_Vacia             := '1900-01-01';    -- Fecha Vacia
SET Entero_Cero             := 0;               -- Entero en Cero
SET Var_SI                  := 'S';             -- Permite Salida SI
SET Var_NO                  := 'N';             -- Permite Salida NO

SET Var_Interesado          := Var_NO;          -- INTERESADO
SET Var_Validado            := Var_NO;          -- VALIDADO
SET Var_OpAlta              := 1;               -- OPERACION DE ALTA
SET Var_OpMod               := 2;               -- OPERACION MODIFICA
SET Est_Activo              := 'A';             -- ESTATUS ACTIVO
SET SI_Huella               := 'S';             -- Si registra huella
SET Persona_Cliente         := 'C';             -- Tipo de persona: Cliente
SET MenorEdad               := 'S';             -- El cliente SI es menor de edad
SET PagoSemanal             := 'S';             -- PagoSemanal
SET PagoDecenal             := 'D';             -- Pago Decenal
SET PagoCatorcenal          := 'C';             -- PagoCatorcenal
SET PagoQuincenal           := 'Q';             -- PagoQuincenal
SET PagoMensual             := 'M';             -- PagoMensual
SET PagoPeriodo             := 'P';             -- PagoPeriodo
SET PagoBimestral           := 'B';             -- PagoBimestral
SET PagoTrimestral          := 'T';             -- PagoTrimestral
SET PagoTetrames            := 'R';             -- PagoTetraMestral
SET PagoSemestral           := 'E';             -- PagoSemestral
SET PagoAnual               := 'A';             -- PagoAnual
SET ConSic_TipoBuro			:= 'BC';			-- Consulta SIC buro
SET ConSic_TipoCirculo		:= 'CC';			-- Consulta SIC Circulo
SET Con_TipoBuro			:= 'B';				-- Tipo buro

-- ASIGNACION DE VARIABLES
SET Aud_FechaActual         := NOW();

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr  = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDITOWSPRO');
            SET Var_Control = 'SQLEXCEPTION';
        END;


    -- **************************************************************************************
    -- SE VALIDA EL USUARIO   *******************
    -- **************************************************************************************
    SET Var_PerfilWsVbc     := (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc     := IFNULL(Var_PerfilWsVbc,Entero_Cero);
	SET Var_TipoConsultaSIC	:= (SELECT ConBuroCreDefaut FROM PARAMETROSSIS LIMIT 1);

    IF(IFNULL(Var_TipoConsultaSIC, Cadena_Vacia)= Cadena_Vacia) THEN
		SET Var_TipoConsultaSIC	:= Cadena_Vacia;
    ELSE
		IF (Var_TipoConsultaSIC = Con_TipoBuro)THEN
			SET Var_TipoConsultaSIC := ConSic_TipoBuro;
		ELSE
			SET Var_TipoConsultaSIC := ConSic_TipoCirculo;
        END IF;
    END IF;

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
        LEAVE ManejoErrores;
    END IF;

    SET Aud_DireccionIP := '127.0.0.1';
    SET Aud_ProgramaID  := 'SOLICITUDCREDITOWSPRO';
    -- **************************************************************************************
    -- SE VALIDA LA OPERACION A REALIZAR   *******************
    -- **************************************************************************************
    IF(Par_NumOpe = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "Especifique la Operacion a Realizar";
        LEAVE ManejoErrores;
    END IF;

    -- **************************************************************************************
    IF(Par_NumOpe != 1)THEN
        IF(Par_NumOpe != 2)THEN
            SET Par_NumErr      := 7;
            SET Par_ErrMen      := "Especifique una Operacion a Realizar Valida";
            LEAVE ManejoErrores;
        END IF;
    END IF;

    -- **************************************************************************************
    -- SE VALIDA EL VALOR DEL CLIENTE **************************************************************************************
    SELECT FuncionHuella,       ReqHuellaProductos,         FechaSistema  INTO
           Var_FuncionHuella,   Var_ReqHuellaProductos,     Var_FechaSistema
    FROM PARAMETROSSIS LIMIT 1;

    IF(Par_ClienteID = Entero_Cero) THEN
        SET Par_NumErr := 001;
        SET Par_ErrMen := 'El safilocale.cliente esta Vacio.';
        LEAVE ManejoErrores;
    ELSE
        IF(Par_ClienteID <> Entero_Cero) THEN
            SELECT      ClienteID ,      Estatus,        CalificaCredito
                INTO    Var_ClienteID,   Var_Estatus,    Var_ClasifiCli
                FROM CLIENTES
                WHERE ClienteID = Par_ClienteID;

            IF(IFNULL(Var_ClienteID, Entero_Cero)= Entero_Cero) THEN
                SET Par_NumErr := 002;
                SET Par_ErrMen := 'El safilocale.cliente Indicado No Existe.';
                SET Var_Control := 'clienteID';
                LEAVE ManejoErrores;
            END IF;

            IF (Var_Estatus = ClienteInactivo) THEN
                SET Par_NumErr := 003;
                SET Par_ErrMen := 'El safilocale.cliente Indicado se Encuentra Inactivo.';
                SET Var_Control := 'clienteID';
                LEAVE ManejoErrores;
            END IF;

            IF(Var_FuncionHuella = SI_Huella AND Var_ReqHuellaProductos=SI_Huella) THEN
                IF NOT EXISTS( SELECT PersonaID FROM HUELLADIGITAL Hue
                                WHERE Hue.PersonaID = Par_ClienteID
                                    AND Hue.TipoPersona = Persona_Cliente) THEN
                SET Par_NumErr := 004;
                SET Par_ErrMen := 'El safilocale.cliente No tiene Huella Registrada.';
                SET Var_Control := 'clienteID';
                LEAVE ManejoErrores;
                END IF;
            END IF;
        END IF; -- IF(Par_ClienteID <> Entero_Cero) THEN

    END IF; -- IF(Par_ClienteID = Entero_Cero AND Par_ProspectoID = Entero_Cero) THEN

    IF EXISTS (SELECT ClienteID FROM CLIENTES
                WHERE ClienteID = Par_ClienteID
                AND EsMenorEdad = MenorEdad)THEN
                        SET Par_NumErr := 006;
                        SET Par_ErrMen := 'El safilocale.cliente es Menor, No es Posible Asignar Credito.';
                        SET Var_Control := 'clienteID';
                        LEAVE ManejoErrores;
    END IF;

    IF(Par_FechaReg != Var_FechaSistema)THEN
        SET Par_NumErr      := 5;
        SET Par_ErrMen      := "La fecha de registro debe ser igual a la fecha del sistema.";
        SET Var_Control     := 'clienteID';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_TasaFija = Entero_Cero)THEN
        SET Par_NumErr      := 4;
        SET Par_ErrMen      := "La Tasa esta Vacia.";
        SET Var_Control := 'clienteID';
        LEAVE ManejoErrores;
    END IF;


    -- SE OBTIENEN LOS VALORES DEL PRODUCTO DE CREDITO ***********************************************************************
    SELECT      FactorMora,
                CASE TipoComXapert
                    WHEN 'M'    THEN MontoComXapert
                    WHEN 'P'    THEN Par_MontoSolic * (MontoComXapert / 100) END AS ComXAper,
                Calcinteres,        TipoCalInteres,     ProductoNomina,     ProducCreditoID
        INTO    Par_FactorMora,     Par_ComApertura,    Par_CalcInteres,    Par_TipoCalInt,     Var_ProductoNomina,
                VarProductoCreditoID
        FROM PRODUCTOSCREDITO
            WHERE   ProducCreditoID = Par_ProduCredID;

    SET VarProductoCreditoID    := IFNULL(VarProductoCreditoID,Entero_Cero);
    IF(VarProductoCreditoID = Entero_Cero) THEN
        SET Par_NumErr      := 10;
        SET Par_ErrMen      := "El producto de credito no existe";
        LEAVE ManejoErrores;
    END IF;


    IF(Var_ProductoNomina = Var_SI) THEN
        IF(Par_InstitNominaID = Entero_Cero) THEN
            SET Par_NumErr      := 8;
            SET Par_ErrMen      := "La institucion de nomina esta vacia";
            LEAVE ManejoErrores;
        END IF;
    END IF;

    -- **************************************************************************************
    -- SE VALIDA LA PERIODICIDAD   *******************
    -- **************************************************************************************
    CASE Par_FrecCapital
        WHEN PagoSemanal        THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoDecenal        THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoCatorcenal     THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoQuincenal      THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoMensual        THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoPeriodo        THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoBimestral      THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoTrimestral     THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoTetrames       THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoSemestral      THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoAnual          THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN PagoUnico          THEN SET Par_FrecCapital   := Par_FrecCapital;
        WHEN Cadena_Vacia       THEN SET Par_FrecCapital   := 'Q';
        ELSE
            SET Par_NumErr      := 1;
            SET Par_ErrMen      := "El Valor Especificado para la Periodicidad no es Valido";
            LEAVE ManejoErrores;
    END CASE;


    SELECT  LOCATE(Par_FrecCapital,Frecuencias)
    INTO    VarFrecuencias
    FROM CALENDARIOPROD
        WHERE ProductoCreditoID = Par_ProduCredID;

    IF(VarFrecuencias = Entero_Cero)THEN
        SET Par_NumErr      := 7;
        SET Par_ErrMen      := "El Valor Especificado para la Periodicidad no se encuentra parametrizado en el producto de credito";
        LEAVE ManejoErrores;
    END IF;


    /** VALIDACIONES *************************************************************/

    SET Par_ProspectoID     := Entero_Cero;
    SET Par_TasaBase        := Entero_Cero;
    SET Par_SobreTasa       := Entero_Cero;
    SET Par_PisoTasa        := Entero_Cero;
    SET Par_TechoTasa       := Entero_Cero;
    SET Par_NumAmorti       := Entero_Cero;
    SET Par_CAT             := Entero_Cero;
    SET Par_MontoCuota      := Entero_Cero;
    SET Par_TipoIntegr      := Entero_Cero;

    SELECT ValorParametro INTO Par_Promotor     FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'PromotorID';
    SELECT ValorParametro INTO Par_TipoCredito  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'TipoCredito';
    SELECT ValorParametro INTO Par_NumCreditos  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'NumCreditos';
    SELECT ValorParametro INTO Par_Relacionado  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'Relacionado';
    SELECT ValorParametro INTO Par_Moneda       FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'MonedaID';
    SELECT ValorParametro INTO Par_DestinoCre   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'DestinoCreID';
    SELECT ValorParametro INTO Par_Proyecto     FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'Proyecto';
    SELECT ValorParametro INTO Par_SucursalID   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'SucursalID';
    SELECT ValorParametro INTO Par_TipoDisper   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'TipoDispersion';
    SELECT ValorParametro INTO Par_NumTransacSim   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'NumTransacSim';
    SELECT ValorParametro INTO Par_CuentaClabe  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'CuentaCLABE';
    SELECT ValorParametro INTO Par_TipoFondeo   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'TipoFondeo';
    SELECT ValorParametro INTO Par_InstitFondeoID   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'InstitFondeoID';
    SELECT ValorParametro INTO Par_LineaFondeo  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'LineaFondeo';

    SELECT ValorParametro INTO Par_GrupoID      FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'GrupoID';
    SELECT ValorParametro INTO Par_MontoSeguroVida  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'MontoSeguroVida';
    SELECT ValorParametro INTO Par_ForCobroSegVida  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'ForCobroSegVida';
    SELECT ValorParametro INTO Par_ClasiDestinCred  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'ClasiDestinCred';
    SELECT ValorParametro INTO Par_HorarioVeri  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'HorarioVeri';
    SELECT ValorParametro INTO Par_DescuentoSeguro  FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'DescuentoSeguro';
    SELECT ValorParametro INTO Par_MontoSegOriginal FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'MontoSegOriginal';
    SELECT ValorParametro INTO Par_Comentario   FROM PARAMETROSVBCWS WHERE ParametroVbcID = 'Comentario';

	SET Par_NumAmortInt :=(SELECT IFNULL((Dias/15),Entero_Cero)  FROM CREDITOSPLAZOS WHERE PlazoID=Par_PlazoID);
    SET Par_NumAmorti	:=IFNULL(Par_NumAmortInt,Entero_Cero);

    -- SE OBTIENE EL PORCENTAJE PARA CALCULAR EL VALOR DEL MONTO DE GARANTIA LIQUIDA *****************************************
    SELECT      Porcentaje
        INTO    Par_PorcGarLiq
        FROM ESQUEMAGARANTIALIQ
            WHERE   ProducCreditoID = Par_ProduCredID
                AND Clasificacion   = Var_ClasifiCli
                AND LimiteInferior  <= Par_MontoSolic
                AND LimiteSuperior  >= Par_MontoSolic;

    if ifnull(Par_PorcGarLiq,Entero_Cero) = Entero_Cero then
		SET Par_AporCliente := Entero_Cero;
    else
		SET Par_AporCliente := Par_MontoSolic / (Par_PorcGarLiq /100);
    end if;


    SET Par_IVAComAper  := Entero_Cero;

    SELECT  ProductoCreditoID,      FecInHabTomar,      AjusFecExigVenc,        AjusFecUlAmoVen,
            CASE WHEN LOCATE(',',TipoPagoCapital)   >Entero_Cero THEN SUBSTRING(TipoPagoCapital,1,(LOCATE(',',TipoPagoCapital)-1))  ELSE  TipoPagoCapital END,
            DiaPagoCapital,         DiaPagoInteres,     PermCalenIrreg
    INTO    VarProductoCreditoID,   Par_FechInhabil,    Par_AjuFecExiVe,        Par_AjFUlVenAm,         Par_TipoPagCap,
            Par_DiaPagCap,      Par_DiaPagInt,          Par_CalIrreg
    FROM CALENDARIOPROD
        WHERE ProductoCreditoID = Par_ProduCredID;

    SELECT Dias
        INTO Var_Dias
        FROM CREDITOSPLAZOS
            WHERE PlazoID = Par_PlazoID;


    SET Par_DiaMesCap      := DAY(Par_FechaReg);
    SET Par_DiaMesInter    := DAY(Par_FechaReg);

    SET Par_FechaVencim     := (SELECT DATE_ADD(Par_FechaReg, INTERVAL Var_Dias DAY));

	# Se suman los dias correspondientes a la frecuencia,
	SET Var_FechaCobroComision := (SELECT FNSUMADIASFECHA(Var_FechaSistema,Par_PeriodCap));
    SET Var_FechaCobroComision := (SELECT FUNCIONDIAHABIL(Var_FechaCobroComision, 0, Aud_EmpresaID));

    CASE Par_NumOpe
        WHEN Var_OpAlta THEN
            -- SP PARA DAR DE ALTA LAS REFERENCIAS DE LA SOLICITUD DE CREDITO
            CALL SOLICITUDCREDITOALT( /*SP PARA DAR DE ALTA UNA SOLICITUD DE CREDITO */
                Par_ProspectoID,        Par_ClienteID,          Par_ProduCredID,        Par_FechaReg,           Par_Promotor,
                Par_TipoCredito,        Par_NumCreditos,        Par_Relacionado,        Par_AporCliente,        Par_Moneda,
                Par_DestinoCre,         Par_Proyecto,           Par_SucursalID,         Par_MontoSolic,         Par_PlazoID,
                Par_FactorMora,         Par_ComApertura,        Par_IVAComAper,         Par_TipoDisper,         Par_CalcInteres,
                Par_TasaBase,           Par_TasaFija,           Par_SobreTasa,          Par_PisoTasa,           Par_TechoTasa,
                Par_FechInhabil,        Par_AjuFecExiVe,        Par_CalIrreg,           Par_AjFUlVenAm,         Par_TipoPagCap,
                Par_FrecCapital,        Par_FrecCapital,        Par_PeriodInt,          Par_PeriodCap,          Par_DiaPagInt,
                Par_DiaPagCap,          Par_DiaMesInter,        Par_DiaMesCap,          Par_NumAmorti,          Par_NumTransacSim,
                Par_CAT,                Par_CuentaClabe,        Par_TipoCalInt,         Par_TipoFondeo,         Par_InstitFondeoID,
                Par_LineaFondeo,        Par_NumAmortInt,        Par_MontoCuota,         Par_GrupoID,            Par_TipoIntegr,
                Par_FechaVencim,        Par_FechaReg,           Par_MontoSeguroVida,    Par_ForCobroSegVida,    Par_ClasiDestinCred,
                Par_InstitNominaID,     Par_FolioCtrl,          Par_HorarioVeri,        Par_PorcGarLiq,         Par_FechaReg,
                Par_DescuentoSeguro,    Par_MontoSegOriginal,   Cadena_Vacia,           Entero_Cero,            Var_TipoConsultaSIC,
                Cadena_Vacia, 			Cadena_Vacia, 			Var_FechaCobroComision,	Entero_Cero,			Entero_Cero,
                Entero_Cero,			Entero_Cero,			Entero_Cero,            Entero_Cero,            Cadena_Vacia,
                Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,
                Entero_Cero,            Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,
                Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,
                Var_NO,					Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,          Aud_Usuario,
                Aud_FechaActual,       	Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero )THEN
                LEAVE ManejoErrores;
            END IF;

        WHEN Var_OpMod THEN
            IF(IFNULL(Par_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
                SET Par_NumErr  := 001;
                SET Par_ErrMen  := 'El Numero de Solicitud de Credito Esta Vacio.';
                SET Var_Control := 'solicitudCreditoID';
                SET Var_Consecutivo := Entero_Cero;
                LEAVE ManejoErrores;
            END IF;

            SET Var_SolicitudCreditoID  := (SELECT SolicitudCreditoID FROM SOLICITUDCREDITO WHERE SolicitudCreditoID=Par_SolicitudCreditoID);


            IF(IFNULL(Var_SolicitudCreditoID, Entero_Cero)) = Entero_Cero THEN
                SET Par_NumErr  := 002;
                SET Par_ErrMen  := 'El Numero de Solicitud de Credito No Existe.';
                SET Var_Control := 'solicitudCreditoID';
                SET Var_Consecutivo := Entero_Cero;
                LEAVE ManejoErrores;
            END IF;


            CALL SOLICITUDCREDITOMOD(
                Par_SolicitudCreditoID, Par_ProspectoID,        Par_ClienteID,          Par_ProduCredID,        Par_FechaReg,
                Par_Promotor,           Par_TipoCredito,        Par_NumCreditos,        Par_Relacionado,        Par_AporCliente,
                Par_Moneda,             Par_DestinoCre,         Par_Proyecto,           Par_SucursalID,         Par_MontoSolic,
                Par_PlazoID,            Par_FactorMora,         Par_ComApertura,        Par_IVAComAper,         Par_TipoDisper,
                Par_CalcInteres,        Par_TasaBase,           Par_TasaFija,           Par_SobreTasa,          Par_PisoTasa,
                Par_TechoTasa,          Par_FechInhabil,        Par_AjuFecExiVe,        Par_CalIrreg,           Par_AjFUlVenAm,
                Par_TipoPagCap,         Par_FrecCapital,        Par_FrecCapital,        Par_PeriodInt,          Par_PeriodCap,
                Par_DiaPagInt,          Par_DiaPagCap,          Par_DiaMesInter,        Par_DiaMesCap,          Par_NumAmorti,
                Par_NumTransacSim,      Par_CAT,                Par_CuentaClabe,        Par_TipoCalInt,         Par_TipoFondeo,
                Par_InstitFondeoID,     Par_LineaFondeo,        Par_NumAmortInt,        Par_MontoCuota,         Par_GrupoID,
                Par_TipoIntegr,         Par_FechaVencim,        Par_FechaReg,           Par_MontoSeguroVida,    Par_ForCobroSegVida,
                Par_ClasiDestinCred,    Par_InstitNominaID,     Par_FolioCtrl,          Par_HorarioVeri,        Par_PorcGarLiq,
                Par_FechaReg,           Par_DescuentoSeguro,    Par_MontoSegOriginal,   Par_Comentario,         Var_TipoConsultaSIC,
                Cadena_Vacia,			Cadena_Vacia,			Var_FechaCobroComision,	Entero_Cero,			Entero_Cero,
                Entero_Cero,			Entero_Cero,			Entero_Cero,            Entero_Cero,            Cadena_Vacia,
                Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,
                Entero_Cero,            Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,
                Entero_Cero,            Cadena_Vacia,           Cadena_Vacia,           Cadena_Vacia,
                Var_NO,					Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,          Aud_Usuario,
                Aud_FechaActual,		Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero )THEN
                LEAVE ManejoErrores;
            END IF;
        ELSE
            SET Par_NumErr      := 0;
            SET Par_ErrMen      := CONCAT('Especifique una Operacion a Realizar Valida');
            LEAVE ManejoErrores;
    END CASE;

    SET Par_NumErr      := 0;
    SET Par_ErrMen      := CONCAT(Par_ErrMen);

END ManejoErrores;

IF(Par_Salida = Var_SI)THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$