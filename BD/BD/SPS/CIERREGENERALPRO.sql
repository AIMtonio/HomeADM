-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREGENERALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREGENERALPRO`;

DELIMITER $$
CREATE PROCEDURE `CIERREGENERALPRO`(
    # ====================================================================
    # -------PROCESO ENCARGADO DE EJECUTAR LOS PROCESOS DE CIERRES--------
    # ====================================================================
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
    -- Declaracion de variables
    DECLARE Var_FecActual       DATETIME;
    DECLARE Var_Empresa         INT(11);
    DECLARE Var_FechaSig        DATE;
    DECLARE Var_ISR_pSocio      CHAR(1);    -- variable que guarda si se calcula el isr por socio
    DECLARE Sig_DiaHabil        DATE;
    DECLARE Sig_DiaHab          DATE;
    DECLARE Var_EsHabil         CHAR(1);
    DECLARE Var_FechaInicMes    DATETIME;   -- Fecha Inicial del mes usada en el proceso 801
    DECLARE Var_FechaFinalMes   DATETIME;   -- Fecha final del mes usada en el proceso 801

    DECLARE Es_DiaHabil         CHAR(1);
    DECLARE Var_FecBitaco       DATETIME;
    DECLARE Var_MinutosBit      INT(11);
    DECLARE Par_NumErr          INT(11);
    DECLARE Par_IntNumErr       INT(11);
    DECLARE Par_ErrMen          VARCHAR(400);
    DECLARE Par_Consecutivo     BIGINT;
    DECLARE Var_CalifCliSI      CHAR(1);
    DECLARE Var_CancelaAut      CHAR(1);

    DECLARE Var_EvaluacionMatriz        CHAR(1);
    DECLARE Var_EvaluacionPerfil        CHAR(1);                # Indica si se evalua el perfil transaccional
    DECLARE Var_FrecuenciaMensual       INT(11);
    DECLARE Var_FechaEvaluacionMatriz   DATE;
    DECLARE Var_ManejaCarteraAgro       CHAR(1);
    DECLARE Var_FecBitacoCierre         DATETIME;
    DECLARE Var_MinutosBitCierre        INT(11);
    DECLARE Var_ClienteCajaCierre       VARCHAR(10);
    DECLARE Par_Poliza                  BIGINT(20);     -- Numero de Poliza
    DECLARE Var_AplicaCobPen            CHAR(1);        -- Aplica cobros pendientes


    -- Declaracion de constantes
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT(11);
    DECLARE SalidaSI            CHAR(1);
    DECLARE CalifCliSI          CHAR(1);

    DECLARE Tip_Fecha           INT(11);
    DECLARE Cero_DiaHabil       INT(11);
    DECLARE Un_DiaHabil         INT(11);
    DECLARE SiEs_DiaHabil       CHAR(1);
    DECLARE NoEs_DiaHabil       CHAR(1);

    DECLARE Salida_NO           CHAR(1);
    DECLARE Pro_CieGeneral      INT(11);
    DECLARE Pro_CalPosTeso      INT(11);
    DECLARE Pro_DevInvBan       INT(11);
    DECLARE Pro_PLDParamSe      INT(11);
    DECLARE Entero_Uno          INT(11);

    DECLARE Pro_VenSegVid       INT(11);
    DECLARE Pro_ISR_Socio       INT(11);
    DECLARE ProCierreISRSInv    INT(11);
    DECLARE ProCierreISRSCta    INT(11);
    DECLARE ProCierreISRCede    INT(11);
    DECLARE Var_FecOper         DATE;

    DECLARE Var_FecApli         DATE;
    DECLARE Var_FecSiguie       DATE;
    DECLARE Pro_CierreGralVal   INT(11);
    DECLARE Var_CajaID          INT(11);
    DECLARE Pro_Profun          INT(11);

    DECLARE Pro_CalificaCli     INT(11);
    DECLARE CancelaMenor        INT(11);
    DECLARE Cancelado           CHAR(1);
    DECLARE Decimal_Cero        DECIMAL;
    DECLARE Pro_CierreMes       INT(11);

    DECLARE Pro_CierreDiario    INT(11);
    DECLARE Var_NumInversion    INT(11);
    DECLARE MesActual           INT(11);
    DECLARE MesAnterior         INT(11);
    DECLARE DiaHabilAnterior    VARCHAR(10);

    DECLARE Pro_CierreTajetas   INT(11);
    DECLARE Pro_HisTasas        INT(3);
    DECLARE Pro_CierreDiaConta  INT(11);
    DECLARE Pro_CieMesSaldCont  INT(11);
    DECLARE SI_Isr_Socio        CHAR(1);
    DECLARE ParaISRpSocio       VARCHAR(10);
    DECLARE No_constante        VARCHAR(10);
    DECLARE Fec_CalculoHabil    DATE;
    DECLARE Pro_HisEmisionCob   INT(11);
    DECLARE Pro_HisBitAccesos   INT(11);        -- Proceso batch 9004 paso a historico de bitacora de accesos
    DECLARE Pro_EvalMatrizPLD   INT(11);
    DECLARE Pro_EvalPerfilPLD   INT(11);
    DECLARE TodosLosClientes    INT(11);
    DECLARE Si_constante        CHAR(1);
    DECLARE CierreEnPantalla    CHAR(1);
    DECLARE Act_FinCierre       INT(11);
    DECLARE Pro_HisBitacoraGrdValor INT(11);    -- Proceso Batch 1601: bitacora de documentos guarda valores
    DECLARE Pro_AmorBonificacion    INT(11);    -- Proceso Batch 1602: Bitacora de Bonificacion de Amortizaciones
    DECLARE Pro_ActVencConv         INT(11);        -- Proceso de Vencimiento Automatico de Convenios de Empresas de Nomina
    DECLARE InactivaUsuarios        INT(11);        -- InactivaUsuarios Confiadora
    DECLARE Act_CieBovPrin          INT(11);
    DECLARE Act_OpenCaja            INT(11);
    DECLARE Pro_CalculosSaldo       INT(11);    -- Proceso Batch 9016: CALCULO DE SALDOS CONTABLES AL CIERR DE DIA
    DECLARE ProcesoCobrosPen        INT(11);  -- Cobros pendientes
	DECLARE Pro_PostCierre			INT(11);	-- Proceso batch 10000: post cierre

    -- Asignacion de constantes
    SET Cadena_Vacia            := '';
    SET Fecha_Vacia             := '1900-01-01';
    SET Entero_Cero             := 0;
    SET Entero_Uno              := 1;
    SET Tip_Fecha               := 3;
    SET Cero_DiaHabil           := 0;

    SET Un_DiaHabil             := 1;
    SET SiEs_DiaHabil           := 'S';
    SET NoEs_DiaHabil           := 'N';
    SET Salida_NO               := 'N';
    SET Pro_CieGeneral          := 900;

    SET Pro_CalPosTeso          := 450;     -- Proceso Batch de Posicion de Tesoreria
    SET Pro_PLDParamSe          := 503;     -- Proceso Batch de PLD  seg de operaciones
    SET SalidaSI                :='S';      -- Salida SI
    SET Pro_CierreGralVal       := 901;     -- Proceso Batch de validacion del Cierre General
    SET Pro_VenSegVid           := 1000;    -- Proceso Batch de Vencimiento de Seguros de Vida

    SET Pro_Profun              := 407;     -- Proceso Batch para programa profun
    SET Pro_CalificaCli         := 9003;
    SET Pro_ISR_Socio           := 1100;    -- Proceso para calculo ISR por socio
    SET ProCierreISRSInv        := 1102;    -- Proceso para calculo ISR por socio
    SET ProCierreISRSCta        := 1101;    -- Proceso para calculo ISR por socio
    SET ProCierreISRCede        := 1319;    -- Proceso para calculo ISR por socio

    SET CalifCliSI              := 'S';
    SET CancelaMenor            := 904;     -- Proceso Batch para cancelacion de cliente por mayoria de edad
    SET Cancelado               := "C";
    SET Decimal_Cero            := 0.0;
    SET Pro_CierreDiario        := 1;       -- Proceso para Cierre Diario Tarjeta Debito
    SET Pro_CierreMes           := 2;       -- Proceso para Cierre Mes Tarjeta Debito
    SET Pro_CierreTajetas       := 999;     -- Proceso para Tarjetas Primer Cierre Diario del Mes
    SET Pro_HisTasas            := 409;     -- Proceso Batch de Calculo de Tasas Base.
    SET Pro_CierreDiaConta      := 800;     -- Proceso Batch de Cierre diario de Contabilidad
    SET Pro_CieMesSaldCont      := 801;     -- Proceso Batch de Cierre Mensual para saldos contables
    SET SI_Isr_Socio            := 'S';     -- Constante para saber si se calcula ISR por Socio
    SET ParaISRpSocio           := 'ISR_pSocio';-- constante para isr por socio de PARAMGENERALES
    SET No_constante            := 'N';                 -- constante NO
    SET Pro_HisEmisionCob       := 1201;    -- Proceso Batch paso a historico bitacora emision notificaciones cobranza
    SET Pro_HisBitAccesos       := 9007;    -- Proceso batch 9007 paso a historico de bitacora de accesos
    SET Pro_EvalMatrizPLD       := 505;     -- Proceso batch 9007 Evaluacion Nivel de Riesgo Matriz PLD
    SET Pro_EvalPerfilPLD       := 506;     -- Proceso batch 506 Evaluacion del Perfil Transaccional
    SET TodosLosClientes        := 4;       -- Tipo de Evaluacion Matriz PLD 3.- Todos los clientes, excepto inactivos que no permita reingreso
    SET Pro_HisBitacoraGrdValor := 1601;    -- Proceso Batch 1601: bitacora de documentos guarda valores
    SET Pro_AmorBonificacion    := 1602;    -- Proceso Batch 1602: Bitacora de Bonificacion de Amortizaciones
    SET Si_constante            := 'S';     -- SI
    SET CierreEnPantalla        := 'P';
    SET Act_FinCierre           := 6;
    SET Pro_ActVencConv         := 998;     -- Proceso de Vencimiento Automatico de Convenios de Empresas de Nomina
    SET Pro_CalculosSaldo       := 9016;    -- Proceso Batch de Calculos de Saldos
    SET ProcesoCobrosPen        := 421;   -- Proceso Batch de COBROS PENDIENTES
    SET Pro_PostCierre			:= 10000;	-- Proceso batch 10000: post cierre
    SET Var_FecBitacoCierre := NOW(); -- FECHA INCIA CIERRE

    SET InactivaUsuarios        := 12;        -- InactivaUsuarios Confiadora
    SET Act_CieBovPrin          := 12;
    SET Act_OpenCaja            := 13;

    SELECT  FechaSistema,   EmpresaDefault, CancelaAutMenor,    ManejaCarteraAgro
        INTO Var_FecActual, Var_Empresa,    Var_CancelaAut,     Var_ManejaCarteraAgro
    FROM PARAMETROSSIS;

    -- optenemos el valor del sistema para saber si se calcula por socio el ISR
    SELECT  ValorParametro INTO Var_ISR_pSocio
        FROM    PARAMGENERALES
        WHERE   LlaveParametro  = ParaISRpSocio;
    SET Var_FecOper     := Var_FecActual;
    SET Var_ISR_pSocio  :=IFNULL(Var_ISR_pSocio,No_constante);
    SET Aud_FechaActual := NOW();
    SET Aud_ProgramaID  := 'CIERREGENERALPRO';

    CALL TRANSACCIONESPRO(Aud_NumTransaccion);

    SELECT ValorParametro
    INTO Var_ClienteCajaCierre
    FROM PARAMGENERALES
    WHERE LlaveParametro = 'PermiteValidaCajas';

    -- Inicio de CIERRE
    -- Desactivar usarios de confiadora / Cerrar boveda
    IF(Var_ClienteCajaCierre = Si_constante) THEN
        CALL USUARIOSACT(   Entero_Cero,    Cadena_Vacia,       Cadena_Vacia,       Cadena_Vacia,       Fecha_Vacia,
                            Cadena_Vacia,   Fecha_Vacia,        Cadena_Vacia,       Entero_Cero,        Cadena_Vacia,
                            Fecha_Vacia,    InactivaUsuarios,   Salida_NO,          Par_IntNumErr,      Par_ErrMen,
                            Var_Empresa,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                            Aud_Sucursal,   Aud_NumTransaccion);

        CALL CAJASVENTANILLAACT(
                            Entero_Cero,     Entero_Cero,        Cadena_Vacia,       Entero_Cero,       Cadena_Vacia,
                            Cadena_Vacia,    Cadena_Vacia,       Cadena_Vacia,       Var_FecActual,      Cadena_Vacia,
                            Var_FecActual,    Cadena_Vacia,       Var_FecActual,       Cadena_Vacia,      Entero_Cero,
                            Entero_Cero,     Decimal_Cero,       Decimal_Cero,       Entero_Cero,       Cadena_Vacia,
                            Act_CieBovPrin,  Var_Empresa,      Aud_Usuario,        Aud_FechaActual,   Aud_DireccionIP,
                            Aud_ProgramaID,  Aud_Sucursal,       Aud_NumTransaccion );

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr   AS NumErr,
                    Par_ErrMen      AS ErrMen,
                    'inversionID'   AS control;
            LEAVE TerminaStore;
        END IF;
    END IF;

    -- validaciones antes del cierre.
    SET Var_FecBitaco   := NOW();
    CALL CIERREGENERALVAL(
        Salida_NO,      Par_IntNumErr,      Par_ErrMen,     Var_Empresa,    Aud_Usuario,
        Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

    IF (Par_IntNumErr <> Entero_Cero)THEN
        SELECT  Par_IntNumErr   AS NumErr,
                Par_ErrMen      AS ErrMen,
                'inversionID'   AS control;
        LEAVE TerminaStore;
    END IF;


    -- -------------------------------------------------------------------------------------------
    -- VALIDA SI YA SE ESTA EJECUTANDO EL CIERRE, SI NO LO ESTA ACTIVA BANDERA QUE COMENZO
    -- -------------------------------------------------------------------------------------------
    CALL EJECUCIONCIERREVAL(
        CierreEnPantalla,   Salida_NO,      Par_IntNumErr,      Par_ErrMen,
        Var_Empresa,        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion
    );

    IF(Par_IntNumErr <> Entero_Cero)THEN
        SELECT  Par_IntNumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                '' AS control;
        LEAVE TerminaStore;
    END IF;
    SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    CALL BITACORABATCHALT(
        Pro_CierreGralVal,  Var_FecActual,      Var_MinutosBit, Var_Empresa,        Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

    -- -------------------------------------------------------------------------------------------
    -- CONSULTA SI EL DIA QUE SE REALIZA ES CIERRE ES UN DIA HABIL
    -- -------------------------------------------------------------------------------------------

    CALL DIASFESTIVOSCAL(
        Var_FecActual,      Cero_DiaHabil,      Var_FechaSig,       Es_DiaHabil,        Var_Empresa,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

    SET Var_FecBitaco   := NOW();


    CALL  CALCULOHISTASASPRO(
        Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

    IF(Par_IntNumErr <> Entero_Cero)THEN

        SELECT  Par_IntNumErr AS NumErr,
                Par_ErrMen AS ErrMen,
            'inversionID' AS control;
        LEAVE TerminaStore;
    END IF;


    SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

    SET Aud_FechaActual := NOW();

    CALL BITACORABATCHALT(
        Pro_HisTasas,       Var_FecActual,      Var_MinutosBit, Var_Empresa,    Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

   -- LLAMADA SP PARA VALIDAR TABLA REAL DE CREDITOS
      CALL VALIDADIASCREDITOPRO(Var_FecOper,Salida_NO,Par_IntNumErr,Par_ErrMen,Var_Empresa,
                            Aud_Usuario,Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,Aud_Sucursal,
                            Aud_NumTransaccion);

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;
   -- FIN VALIDAR TABLA REAL



    IF (Es_DiaHabil = SiEs_DiaHabil) THEN
    -- INICIO CIERRE PLAN AHORRO
    CALL CIERREPLANAHORROPRO(
      Var_FecActual,    Salida_NO,    Par_IntNumErr,    Par_ErrMen,   Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);
    -- FIN CIERRE PLAN AHORRO

        -- -------------------------------------------------------------------------------------------
        -- INICIO CIERRE DE INVERSIONES
        -- -------------------------------------------------------------------------------------------

        -- Se relizas los movimientos contables de inversiones
        CALL INVERCIEDIAPRO(
            Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion  );

        IF(Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen    AS ErrMen,
                    'InversionID'  AS control;
            LEAVE TerminaStore;
        END IF;
        -- -------------------------------------------------------------------------------------------
        -- INICIO CIERRE DE CEDES
        -- BITACORABATCHALT es llamado dentro de CEDECIEDIAPRO
        -- -------------------------------------------------------------------------------------------
        CALL CEDECIEDIAPRO(
            Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        -- SE VALIDA QUE EL NUMERO DE ERROR SEA DE EXITO Y SE CONTINUA CON EL PROCESO
        IF(Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen    AS ErrMen,
                    'cedeID'  AS control;
            LEAVE TerminaStore;
        END IF;

        -- -------------------------------------------------------------------------------------------
        -- FIN CIERRE DE CEDES
        -- -------------------------------------------------------------------------------------------

        -- -------------------------------------------------------------
        -- INICIO CIERRE DE APORTACIONES
        -- BITACORABATCHALT es llamado dentro de APORTCIEDIAPRO
        -- -------------------------------------------------------------
        CALL APORTCIEDIAPRO(
            Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        -- SE VALIDA QUE EL NUMERO DE ERROR SEA DE EXITO Y SE CONTINUA CON EL PROCESO
        IF(Par_IntNumErr != Entero_Cero)THEN
            SELECT
                Par_IntNumErr   AS NumErr,
                Par_ErrMen      AS ErrMen,
                'aportacionID'  AS control;
            LEAVE TerminaStore;
        END IF;
        -- -------------------------------------------------------------
        -- FIN CIERRE DE APORTACIONES
        -- -------------------------------------------------------------

        SET Var_FecBitaco   := NOW();

		-- EJECUTAMOS EL PROCESO DE COBRANZA REFERENCIADA
		CALL DESBLOQCOBRANZAREFERENCIADOPRO(	Var_FecActual,		Salida_NO,			Par_IntNumErr,		Par_ErrMen,			Var_Empresa,
												Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
												Aud_NumTransaccion);
		IF(Par_IntNumErr <> Entero_Cero)THEN
			SELECT Par_IntNumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					'cierreCobranzaRefID' AS control;
			LEAVE TerminaStore;
		END IF;

        CALL CARTERACIEDIAPRO(
            Var_FecActual,  Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );

        -- INICIO CIERRE DE CREDITOS CONTINGENTES
        IF(IFNULL(Var_ManejaCarteraAgro,No_constante) = Si_constante)THEN

            CALL CRECONTCIEDIAPRO(
                Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            -- SE VALIDA QUE EL NUMERO DE ERROR SEA DE EXITO Y SE CONTINUA CON EL PROCESO
            IF(Par_IntNumErr <> Entero_Cero)THEN
                SELECT  Par_IntNumErr AS NumErr,
                        Par_ErrMen    AS ErrMen,
                        'creditoID'  AS control;
                LEAVE TerminaStore;
            END IF;

        END IF;
        -- FIN CIERRE DE CREDITOS CONTINGENTES

        -- Se agrega llamado a stored de cierre de arrendamiento. Modificado por Cardinal Sistemas Inteligentes
        CALL ARRENDAMIENTOCIEDIAPRO(
            Var_FecActual,  Salida_NO,          Par_IntNumErr,      Par_ErrMen,     Var_Empresa,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        -- Se agrega llamado a stored de cierre de arrendamiento. Modificado por Cardinal Sistemas Inteligentes


        -- INICIO CIERRE DE TARJETAS CREDITO
        CALL TC_LINEACIEDIAPRO(
            Var_FecActual,  Salida_NO,          Par_IntNumErr,      Par_ErrMen,     Var_Empresa,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen    AS ErrMen,
                    'cierreTarCredID'  AS control;
            LEAVE TerminaStore;
        END IF;
        -- FIN CIERRE DE TARJETAS DE CREDITO

        -- Calculo de la Posicion para Tesoreria
        SET Var_FecBitaco   := NOW();

        CALL POSICIONTESORERIAPRO(
            Var_FecActual,  Salida_NO,          Par_IntNumErr,      Par_ErrMen,     Var_Empresa,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion  );

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_CalPosTeso,     Var_FecActual,      Var_MinutosBit, Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

        -- Cierre Diario de Inversiones Bancarias
        SET Var_FecBitaco   := NOW();

        CALL INVBANCIEDIAPRO(
            Var_FecActual,  Var_Empresa,        Salida_NO,          Par_NumErr,      Par_ErrMen,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion  );

        -- ------------------------------------------------------------------------------------------------
        -- -INICIO DEL PROCESO 500 GENERAL DE DETECCION DE OPERACIONES RELEVANTES 501 E INUSUALES 502 PLD -
        -- ------------------------------------------------------------------------------------------------
        CALL PLDOPEDETECPRO(
            Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF(Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen    AS ErrMen,
                    'pldDetectProID'  AS control;
            LEAVE TerminaStore;
        END IF;
        -- -----------------------------------------------------------------------------------------------
        -- ------ FIN DEL PROCESO GENERAL DE DETECCION DE OPERACIONES RELEVANTES E INUSUALES PLD ---------
        -- -----------------------------------------------------------------------------------------------

        SET Var_FecBitaco   := NOW();

        SET Sig_DiaHabil    := Var_FecActual;

        CALL DIASFESTIVOSCAL(
            Var_FecOper,        Entero_Cero,        Var_FecApli,        Es_DiaHabil,        Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        CALL DIASFESTIVOSCAL(
            Var_FecOper,        Un_DiaHabil,        Var_FecSiguie,      Es_DiaHabil,        Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);
        /* ==============================================================================================================*/
        /* =========================== SP PARA GENERAR COBROS A SOCIOS INSCRITOS EN  PROFUN =============================*/

        SET Var_FecBitaco   := NOW();

       CALL CLIENTESPROFUNPRO(
            Var_FecActual,      Var_FecActual,  Salida_NO,          Par_IntNumErr,      Par_ErrMen,
            Var_Empresa,        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion  );

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
        SET Aud_FechaActual := NOW();

        CALL BITACORABATCHALT(
            Pro_Profun,         Var_FecActual,      Var_MinutosBit, Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
        /* ==============================================================================================================*/


        -- ------------------------------------------------------------------------------------------------------------------------------
        -- ----- INICIO Generacion de Factores de Captacion para el Calculo del ISR por Cliente.-------------------------------------------------
        -- ----- ANTES DEL CIERRE DE AHORRO ***************************************
        -- ------------------------------------------------------------------------------------------------------------------------------
        CALL FACTORCAPTACIONPRO(
            Var_FecActual,      Salida_NO,          par_NumErr,         Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        -- SE VALIDA QUE EL NUMERO DE ERROR SEA DE EXITO Y SE CONTINUA CON EL PROCESO
        IF(Par_NumErr <> Entero_Cero) THEN
                SELECT  Par_IntNumErr AS NumErr,
                        Par_ErrMen    AS ErrMen,
                        'Fecha'  AS control;
                LEAVE TerminaStore;
        END IF;

        SET Var_FecBitaco   := NOW();
        SET Var_AplicaCobPen := (SELECT AplCobPenCieDia FROM PARAMETROSSIS);

        -- si se encuentra parametrizado que se ejcutara el cobro de los pendientes ene el cierre de dia
        IF(Var_AplicaCobPen = Si_constante)THEN

            -- SP .- Se ejecuta en el CIERRE DIARIO  sirve para aplicar los cobros pendientes del dia
            CALL COBROSPENDPRO(
                Var_FecOper,    Salida_NO,          Par_NumErr,         Par_ErrMen,     Par_Poliza,
                Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                Aud_Sucursal,   Aud_NumTransaccion);

            SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

            CALL BITACORABATCHALT(
                ProcesoCobrosPen,   Var_FecActual,      Var_MinutosBit,     Var_Empresa,    Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        END IF;

        IF (MONTH(Var_FecOper) != MONTH(Var_FecSiguie))THEN

            SET Var_FecBitaco   := NOW();
            SET Aud_FechaActual := NOW();

            -- Pase a Historico de Gastos y Anticipos
            CALL HISBITADOCGRDVALORESPRO(
                Var_FecActual,      Salida_NO,          Par_NumErr,         Par_ErrMen,         Var_Empresa,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                SELECT  Par_IntNumErr AS NumErr,
                        Par_ErrMen    AS ErrMen,
                        'Fecha'  AS control;
                LEAVE TerminaStore;
            END IF;

            SET Var_MinutosBit  := TIMESTAMPDIFF(SECOND, Var_FecBitaco, NOW());
            SET Aud_FechaActual := NOW();

            CALL BITACORABATCHALT(
                Pro_HisBitacoraGrdValor,    Var_FecActual,      Var_MinutosBit,     Var_Empresa,    Aud_Usuario,
                Aud_FechaActual,            Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);


            -- Generacion de Amortizaciones por Bonificacion
            SET Var_FecBitaco   := NOW();
            SET Aud_FechaActual := NOW();

            CALL BONIFICACIONESPRO(
                Var_FecOper,        Salida_NO,          Par_NumErr,         Par_ErrMen,         Var_Empresa,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            IF(Par_NumErr <> Entero_Cero) THEN
                SELECT  Par_IntNumErr AS NumErr,
                        Par_ErrMen    AS ErrMen,
                        'Fecha'  AS control;
                LEAVE TerminaStore;
            END IF;

            SET Var_MinutosBit  := TIMESTAMPDIFF(SECOND, Var_FecBitaco, NOW());
            SET Aud_FechaActual := NOW();

            CALL BITACORABATCHALT(
                Pro_AmorBonificacion,   Var_FecActual,      Var_MinutosBit,     Var_Empresa,    Aud_Usuario,
                Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

            -- ------------------------------------------------------------------------------------------------------------------------------
            -- ----- INICIO PROCESO PARA EL CIERRE DE MES AHORRO
            -- ------------------------------------------------------------------------------------------------------------------------------
            CALL CIERREMESAHORRO(
                Var_FecOper,            Var_FecApli,        Var_Empresa,        Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
            );
            -- -------------------------------------------------------------------------------------
            -- INICIO DEL PROCESO 504 DE AGRUPAMIENTO OPERACIONES QUE REBASEN LIMITES MENSUALES PLD
            -- -------------------------------------------------------------------------------------
            CALL LIMEXEFECLIMESPRO(
                Var_FecActual,  Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
                Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion);

            IF(Par_IntNumErr <> Entero_Cero)THEN
                SELECT  Par_IntNumErr AS NumErr,
                        Par_ErrMen    AS ErrMen,
                        'limexEfectMesID'  AS control;
                LEAVE TerminaStore;
            END IF;
            -- -------------------------------------------------------------------------------------
            -- - FIN DEL PROCESO 504 DE AGRUPAMIENTO OPERACIONES QUE REBASEN LIMITES MENSUALES PLD -
            -- -------------------------------------------------------------------------------------

            -- Reinicio de Contadores Mensuales de Modulo de Tarjeta de DÃ©bito
            CALL TARDEBINICIACONTAPRO(Pro_CierreMes, Salida_NO, Par_NumErr, Par_ErrMen);


            -- ------------------------------------------------------------------------------------------------------------------------------
            -- ------- INICIO Calculo de ISR para los Clientes que no tuvieron Vencimientos por Ahorro,Inversion o CEDES.-- -----------------
            -- ------------------------------------------------------------------------------------------------------------------------------
            IF (Var_ISR_pSocio=SI_Isr_Socio) THEN

                    SET Var_FecBitaco   := NOW();

                    CALL ISRPENDIENTEPRO(
                        Var_FecOper,        Par_IntNumErr,      Par_ErrMen,         Salida_NO,      Var_Empresa,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
                        Aud_NumTransaccion);

                    IF(Par_IntNumErr <> Entero_Cero)THEN
                    SELECT  Par_IntNumErr AS NumErr,
                            Par_ErrMen    AS ErrMen,
                        '   inversionID'  AS control;
                    LEAVE TerminaStore;
                    END IF;

                    -- Se optiene el tiempo que se tardo el sp en terminar
                    SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
                    -- Se guarda el registro del proceso con el SP BITACORABATCHALT
                    CALL BITACORABATCHALT(
                        ProCierreISRSCta,   Var_FecActual,      Var_MinutosBit, Var_Empresa,        Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

            END IF;
            -- ------------------------------------------------------------------------------------------------------------------------------
            -- ------- FIN Calculo de ISR para los Clientes que no tuvieron Vencimientos por Ahorro,Inversion o CEDES.-----------------------
            -- ------------------------------------------------------------------------------------------------------------------------------

            -- ------------------------------------------------------------------
            -- ------- INICIA MOVIMIENTO A HISTORICO DEL ISR.-- -----------------
            -- ------------------------------------------------------------------
                    SET Var_FecBitaco   := NOW();

                    CALL HISCOBROISRALT(
                        Var_FecOper,        Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                        Aud_NumTransaccion);

                    IF(Par_IntNumErr <> Entero_Cero)THEN
                    SELECT  Par_IntNumErr AS NumErr,
                            Par_ErrMen    AS ErrMen,
                        '   inversionID'  AS control;
                    LEAVE TerminaStore;
                    END IF;

            -- ------------------------------------------------------------------
            -- ------- FIN MOVIMIENTO A HISTORICO DEL ISR.-- -----------------
            -- ------------------------------------------------------------------

        ELSE

            -- Reinicio de Contadores Diarios de Modulo de Tarjeta de Debito
            CALL TARDEBINICIACONTAPRO(Pro_CierreDiario, Salida_NO, Par_NumErr, Par_ErrMen);

        END IF;
        -- -------------------------------------------------------------------------------------
        -- ------- INICIO DEL PROCESO 503 DE PLD PARA EL SEGUIMIENTO DE OPERACIONES ------------
        -- -------------------------------------------------------------------------------------
        SET Var_FecBitaco   := NOW();

        CALL PLDPARAMSEGOPPRO(
            Var_FecOper,        Salida_NO,          Par_NumErr,         Par_ErrMen,     Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        SET Aud_FechaActual := NOW();
        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_PLDParamSe,     Var_FecActual,      Var_MinutosBit,     Var_Empresa,    Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        -- -------------------------------------------------------------------------------------
        -- --------- FIN DEL PROCESO 503 DE PLD PARA EL SEGUIMIENTO DE OPERACIONES -------------
        -- -------------------------------------------------------------------------------------

        -- Cierre de Ventanilla o Caja

        CALL VENTANILLACIEDIAPRO(
            Var_FecActual,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;

        -- Calculo del Capital Contable
        CALL CONTACALCAPCONTPRO(
            Var_FecActual,      Var_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion   );

        /* Sp que hace el cierre diario de creditos pasivos*/

        CALL CREPASIVOCIEDIAPRO(
            Var_FecActual,  Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

        -- Se realiza el cierre diario de las Cuentas de Ahorro

        CALL CIERREDIARIOAHORRO(
            Var_FecOper,    Var_FecApli,    Salida_NO,      Par_IntNumErr,      Par_ErrMen,
            Var_Empresa,    Aud_Usuario,    Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion);


        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;

        # ACTUALIZACIÓN DE LA TASA DE ISR SI EXISTE CAMBIO.
        CALL CAMBIOTASAISRPRO(
            Var_FecOper,        Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF (Par_IntNumErr != Entero_Cero)THEN
            SELECT
                Par_IntNumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;

        -- Se verifica si existen movimientos de tarjetas del mes anterior.ALTER

        SET MesActual := month(Var_FecOper);

        SET DiaHabilAnterior := FUNCIONDIAHABILANT(Var_FecOper,1,1);

        SET MesAnterior := month(DiaHabilAnterior);


        IF (MesActual != MesAnterior) THEN

            CALL TARDEBCIEPRO(Var_FecOper);


        END IF;


        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_CierreTajetas,  Var_FecActual,      Var_MinutosBit, Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);


        /* =========== EJECUTA EL PROCESO DIARIO PARA ASIGNACION DE CALIFICACION DEL CLIENTE   ============== */
        SET Var_FecBitaco   := NOW();

        SET Var_CalifCliSI := (SELECT  IFNULL(CalifAutoCliente,Cadena_Vacia) FROM PARAMETROSSIS);

        IF(Var_CalifCliSI = CalifCliSI) THEN

            CALL CALIFICACIONCLIPRO(
                Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,        Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,      Aud_Sucursal,      Aud_NumTransaccion);
        END IF;

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_CalificaCli,    Var_FecActual,      Var_MinutosBit, Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
        /*  ------------------------------------------------------------------------------------------------- */

        -- Cierre diario dia contabilidad

        CALL CIERREDIACONTAPRO(
            Pro_CierreDiaConta,     Salida_NO,          Par_IntNumErr,      Par_ErrMen,     Var_Empresa,
            Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion);

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;

        -- fin cierre diarios dia contabilidad
        -- ---------------------------------------------------------
        -- Generacion de Folios de las Actas de Comite de Credito
        -- ---------------------------------------------------------

        CALL GENFOLIOSCOMITEPRO(
            Var_FecActual,  Salida_NO,          Par_IntNumErr,      Par_ErrMen,     Var_Empresa,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
            Aud_NumTransaccion  );
        -- PROCESO 801 : CIERRE DE MES CONTABILIDAD SALDOS CONTABLES
        IF (MONTH(Var_FecOper) != MONTH(Var_FecSiguie))THEN

            SET Var_FechaInicMes    := DATE_FORMAT(Var_FecOper ,'%Y-%m-01');
            SET Var_FechaFinalMes   := LAST_DAY(Var_FecOper);
            SET Var_FecBitaco       := NOW();

            CALL SALDOSCUENTASPRO(
                Var_FechaInicMes,       Var_FechaFinalMes,      Salida_NO,          Par_IntNumErr,          Par_ErrMen,
                Var_Empresa,        Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
                Aud_Sucursal,       Aud_NumTransaccion);

            IF (Par_IntNumErr <> Entero_Cero)THEN
                SELECT  Par_IntNumErr AS NumErr,
                        Par_ErrMen AS ErrMen,
                    'Fecha' AS control;
                LEAVE TerminaStore;
            END IF;

             SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
             SET Aud_FechaActual := NOW();

            CALL BITACORABATCHALT(
                Pro_CieMesSaldCont,     Var_FecActual,      Var_MinutosBit,     Var_Empresa,        Aud_Usuario,
                Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        END IF;
        -- PROCESO 801 : FIN CIERRE DE MES CONTABILIDAD SALDOS CONTABLES

        -- -----------------------------------HISOTRICO EMISION DE  NOTFICACIONES DE COBRANZA---------------------------------------------------
        -- -------------------------------------------------------------------------------------------------------------------------------------
        SET Var_FecBitaco   := NOW();

        CALL `HIS-EMISIONNOTICOB`(
            Var_FecOper,        Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_HisEmisionCob,   Var_FecActual,      Var_MinutosBit,    Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,       Aud_NumTransaccion);
        -- -------------------------------------FIN HISTORICO EMISION DE  NOTFICACIONES DE COBRANZA---------------------------------------------
        -- ------------------------------ PROCESO VENCIMIENTO AUTOMATICO DE CONVENIOS DE EMPRESAS DE NOMINA ------------------------------------
        -- -------------------------------------------------------------------------------------------------------------------------------------
        SET Var_FecBitaco   := NOW();

        CALL CAMBIOESTATUSCONVPRO (
            Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                'Fecha' AS control; -- Se eliminó update a BanderaCieGene con el valor N
            LEAVE TerminaStore;
        END IF;

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_ActVencConv,    Var_FecActual,      Var_MinutosBit,     Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
        -- ---------------------------- FIN PROCESO VENCIMIENTO AUTOMATICO DE CONVENIOS DE EMPRESAS DE NOMINA ----------------------------------

        -- ------------------------------ EVALUACION NIVEL DE RIESGO DE ACUERDO A MATRIZ DE RIESGO ----------------------------------

        /* Si el proceso de evaluacion NO ha sido ejecutado de forma manual, se ejecuta automaticamente. */
        IF(NOT EXISTS(SELECT ProcesoBatchID FROM BITACORABATCH WHERE ProcesoBatchID = Pro_EvalMatrizPLD AND Fecha = Var_FecActual))THEN
            -- SE OBTIENE LA FECHA ACTUAL DE LA DE EVALUACION
            SET Var_FechaEvaluacionMatriz   := (SELECT FechaEvaluacionMatriz FROM PARAMETROSSIS WHERE EmpresaID = Var_Empresa LIMIT 1);
            SET Var_EvaluacionMatriz        := (SELECT EvaluacionMatriz FROM PARAMETROSSIS WHERE EmpresaID = Var_Empresa LIMIT 1);

            /* SE EVALUA SI ESTA PRENDIDO EL PARAMETRO Y SI LA FECHA A REALIZAR LA EVALUACION ES LA DEL SISTEMA.
             * LA LLAMADA A BITACORABATCHALT SE ENCUENTRA DENTRO DE ACTRIESGOCTEPRO. */
            IF(IFNULL(Var_EvaluacionMatriz,Cadena_Vacia) = Si_constante AND Var_FecActual = Var_FechaEvaluacionMatriz)THEN
                CALL ACTRIESGOCTEPRO(
                    TodosLosClientes,   Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                    Aud_NumTransaccion);

                IF (Par_IntNumErr <> Entero_Cero)THEN
                    SELECT  Par_IntNumErr AS NumErr,
                            Par_ErrMen AS ErrMen,
                        'Fecha' AS control;
                    LEAVE TerminaStore;
                END IF;

            END IF;
        END IF;
    -- -------------------------------------------- EVALUACION DEL PERFIL TRANSACCIONAL  --------------------------------------------
    IF(NOT EXISTS(SELECT ProcesoBatchID FROM BITACORABATCH WHERE ProcesoBatchID = Pro_EvalPerfilPLD AND Fecha = Var_FecActual))THEN
        SET Var_EvaluacionPerfil        := (SELECT PAR.ActPerfilTransOpe FROM PARAMETROSSIS AS PAR WHERE EmpresaID = Var_Empresa LIMIT 1);
        IF(Var_EvaluacionPerfil = Si_constante) THEN
            CALL PLDPERFILTRANSACCIONALPRO(
                Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,        Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_IntNumErr <> Entero_Cero)THEN
                    SELECT
                        Par_IntNumErr AS NumErr,
                        Par_ErrMen AS ErrMen,
                        'Fecha' AS control;
                    LEAVE TerminaStore;
                END IF;
        END IF;
    END IF;
    -- ---------------------------------------------- FIN EVALUACION DEL PERFIL TRANSACCIONAL ----------------------------------------

        -- -----------------------------------HISOTRICO BITACORA DE ACCESOS A SAFI---------------------------------------------------
        -- -------------------------------------------------------------------------------------------------------------------------------------
        SET Var_FecBitaco   := NOW();

        CALL `HISBITACORAACCESOALT`(
            Var_FecOper,    Salida_NO,          Par_IntNumErr,      Par_ErrMen,
            Var_Empresa,    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion);

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                'Fecha' AS control;
            LEAVE TerminaStore;
        END IF;

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_HisBitAccesos,   Var_FecActual,      Var_MinutosBit,    Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,       Aud_NumTransaccion);

        CALL CONCILIACIONPAGOSPRO(
            Cadena_Vacia,       Fecha_Vacia,            Salida_NO,          Par_IntNumErr,      Par_ErrMen,
            Var_Empresa,        Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion
        );

        -- -------------------------------------FIN BITACORA DE ACCESOS A SAFI ---------------------------------------------


        START TRANSACTION;

            CALL DIASFESTIVOSCAL(
                Sig_DiaHabil,       Un_DiaHabil,        Sig_DiaHabil,       Es_DiaHabil,        Var_Empresa,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
                Aud_NumTransaccion);


            CALL PARAMETROSSISACT(
                Var_Empresa,        Sig_DiaHabil,       Entero_Cero,        Cadena_Vacia,       Cadena_Vacia,
                Entero_Cero,        Cadena_Vacia,       Cadena_Vacia,       Entero_Cero,        Entero_Cero,
                Entero_Cero,        Entero_Cero,        Tip_Fecha,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );

            UPDATE SUCURSALES SET
                FechaSucursal   = Sig_DiaHabil;

            SET Var_MinutosBitCierre := TIMESTAMPDIFF(MINUTE, Var_FecBitacoCierre, NOW());

            CALL BITACORABATCHALT(
                Pro_CieGeneral,     Var_FecActual,          Var_MinutosBitCierre,   Var_Empresa,        Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

			CALL PROCESOPOSTCIERREPRO(
				Var_FecActual, 	Salida_NO,			Par_IntNumErr,			Par_ErrMen,			Var_Empresa,
				Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_IntNumErr <> Entero_Cero)THEN
				SELECT  Par_IntNumErr AS NumErr,
						Par_ErrMen AS ErrMen,
						'' AS control;
				LEAVE TerminaStore;
			END IF;

        COMMIT;
        -- -------------------------------------------------------------------------------------------
        -- SE ACTUALIZA PARAMGENERALES BANDERA QUE TERMINO CIERRE DE DIA
        -- -------------------------------------------------------------------------------------------
        CALL PARAMGENERALESACT(
            Act_FinCierre,      Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    '' AS control;
            LEAVE TerminaStore;
        END IF;

        -- Registro de Cierre de Dia para ISOTRX
        CALL ISOTRXTARNOTIFICAPRO(
            Sig_DiaHabil,       Salida_NO,          Par_IntNumErr,      Par_ErrMen,         Var_Empresa,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

        IF (Par_IntNumErr <> Entero_Cero)THEN
            SELECT  Par_IntNumErr AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Cadena_Vacia AS control;
            LEAVE TerminaStore;
        END IF;


    IF(Var_ClienteCajaCierre = SalidaSI) THEN
        CALL CAJASVENTANILLAACT(    Entero_Cero,    Entero_Cero,        Cadena_Vacia,       Entero_Cero,       Cadena_Vacia,
                                    Cadena_Vacia,   Cadena_Vacia,       Cadena_Vacia,       Var_FecActual,      Cadena_Vacia,
                                    Var_FecActual,   Cadena_Vacia,       Var_FecActual,       Cadena_Vacia,      Entero_Cero,
                                    Entero_Cero,    Decimal_Cero,       Decimal_Cero,       Entero_Cero,       Cadena_Vacia,
                                    Act_OpenCaja,   Var_Empresa,      Aud_Usuario,        Aud_FechaActual,   Aud_DireccionIP,
                                    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
    END IF;

    -- -------------------------------------------------------------------------------------------
    -- SE CALCULAN LOS SALDOS DE DETALLES POLIZAS POR DIA
    -- POST-CIERRE
    -- -------------------------------------------------------------------------------------------
    CALL SALDODETALLECIERREDIAPRO(  Salida_NO,        Par_IntNumErr,     Par_ErrMen,       Var_Empresa,       Aud_Usuario,
                                    Aud_FechaActual,  Aud_DireccionIP,   Aud_ProgramaID,   Aud_Sucursal,      Aud_NumTransaccion);
    IF (Par_IntNumErr <> Entero_Cero)THEN
        SELECT  Par_IntNumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Cadena_Vacia AS control;
        LEAVE TerminaStore;
    END IF;

    SET Var_MinutosBitCierre := TIMESTAMPDIFF(MINUTE, Var_FecBitacoCierre, NOW());

    CALL BITACORABATCHALT(
        Pro_CalculosSaldo,     Var_FecActual,          Var_MinutosBitCierre,   Var_Empresa,        Aud_Usuario,
        Aud_FechaActual,       Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);
    -- -------------------------------------------------------------------------------------------
    -- FIN DE CALCULO DE SALDOS DE DETALLES POLIZAS POR DIA
    -- POST-CIERRE
    -- -------------------------------------------------------------------------------------------


    -- -------------------------------------------------------------------------------------------
	-- INICIO POST-CIERRE
    -- ------------------------------------------------------------------------------------------
		SET Var_FecBitaco   := NOW();

        CALL `CIERREGENERALPOSTPRO`(
			Var_FecActual,
            Salida_NO,        	Par_IntNumErr,     	Par_ErrMen,			Var_Empresa,    	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,   	Aud_NumTransaccion
		);

        IF (Par_IntNumErr <> Entero_Cero)THEN
			SELECT  Par_IntNumErr AS NumErr,
                CONCAT('POST-CIERRE: ',Par_ErrMen) AS ErrMen,
                Cadena_Vacia AS control;
			LEAVE TerminaStore;
		END IF;

        SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

        CALL BITACORABATCHALT(
            Pro_PostCierre,   	Var_FecActual,      Var_MinutosBit,    Var_Empresa,        Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,    Aud_Sucursal,       Aud_NumTransaccion
		);
    -- -------------------------------------------------------------------------------------------
	-- FIN POST-CIERRE
    -- -------------------------------------------------------------------------------------------

        SELECT  '000' AS NumErr ,
              'Cierre Realizado Correctamente.' AS ErrMen,
              'inversionID' AS control;

    END IF;

END TerminaStore$$
