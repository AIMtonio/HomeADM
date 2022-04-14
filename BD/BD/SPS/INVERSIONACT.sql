-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONACT`;

DELIMITER $$
CREATE PROCEDURE `INVERSIONACT`(
/** STORE para Actualizar estatus (pagare), Autorizar, Cancelar, y Vencer de la inverson **/
   Par_InversionID        INT,            -- Numero de inversion
   Par_UsuarioClave       VARCHAR(25),        -- Clave de USUARIO que realiza la operacon de venc ant
   Par_ContraseniaAut       VARCHAR(45),        -- Contrasenia del USUARIO
   Par_AltaEncPoliza        CHAR(1),          -- Alta de Encabezaso de Poliza S: Si, N: No
   Par_NumAct           TINYINT UNSIGNED,     -- Numero de Actualizacion

   Par_Salida           CHAR(1),          -- Salida S: Si N: No
   INOUT  Par_NumErr        INT,            -- Numero de error
   INOUT  Par_ErrMen        VARCHAR(350),       -- Mensaje de Error
   INOUT  Par_Poliza        BIGINT,           -- Numero de poliza
   Par_EmpresaID          INT,            -- Numero de Empresa

   -- Parametros de Auditoria
   Aud_Usuario          INT(11),          -- Auditoria
   Aud_FechaActual        DATETIME,         -- Auditoria
   Aud_DireccionIP        VARCHAR(15),        -- Auditoria
   Aud_ProgramaID         VARCHAR(50),        -- Auditoria
   Aud_Sucursal         INT(11),          -- Auditoria

   Aud_NumTransaccion       BIGINT(20)          -- Auditoria

          )

TerminaStore: BEGIN

  -- Declaracion de Variables
  DECLARE VarControl          CHAR(15);   -- variable de control
  DECLARE Var_Monto         DECIMAL(14,2);  -- monto de la inversion
  DECLARE Var_Cuenta          BIGINT(12);   -- numero de la cuenta de la inversion
  DECLARE Var_CancelaInversion    INT;      -- variable para saber si se cancela la inversion
  DECLARE Var_CancelaReinversion    INT;      -- variable para saber si se cancela la reinversion
  DECLARE Var_Autoriza        INT;      -- variable para saber si se autoriza
  DECLARE Var_ImprimePagare     INT;      -- variable para SABER SI ESTA IMPRESO EL PAGARE
  DECLARE Var_MontoOriginal     DECIMAL(14,2);  -- variable del monto original de la inversion
  DECLARE Var_InteresOriginal     DECIMAL(14,2);  -- variable del monto interes de la inversion
  DECLARE Var_Estatus         CHAR;     -- variable del estatus de la inversion
  DECLARE Var_FechaSucursal     DATE;     -- variable de fecha del sistema
  DECLARE Var_InverFecIni       DATE;     -- variable de la inversion inicial
  DECLARE Var_EstatusImp        CHAR(1);    -- variable del estus de impresion del pagare
  DECLARE Var_Cliente         BIGINT;     -- variable del id del cliente
  DECLARE Var_Moneda          INT;      -- variable del tipo de moneda
  DECLARE Var_IntRetener        DECIMAL(14,2);  -- variable del interes que se retendra por ISR
  DECLARE Var_SalProvision      DECIMAL(14,2);  -- variable para el saldo
  DECLARE Var_InteresGen        DECIMAL(14,2);  -- variable del inetres generado
  DECLARE Var_MovIntere       VARCHAR(4);   -- concepto del movimiento
  DECLARE Cue_PagIntere       CHAR(50);   -- concepto de cuentas
  DECLARE Cue_PagIntExe       CHAR(50);   -- concepto de cuentas
  DECLARE Cue_PagIntGra       CHAR(50);   -- concepto de cuentas
  DECLARE Cue_PagIntAntiExe     CHAR(50);   -- concepto de cuentas
  DECLARE Cue_PagIntAntiGra     CHAR(50);   -- concepto de cuentas
  DECLARE Var_Instrumento       VARCHAR(15);  -- variable del id de la inversion
  DECLARE Var_CuentaStr       VARCHAR(15);  -- variable de la cuenta de la inversion
  DECLARE Var_MonedaBase        INT;      -- variable del tipo de moneda base
  DECLARE Var_TipCamCom       DECIMAL(14,6);  -- variable patra el tipo de cambio
  DECLARE Var_IntRetMN        DECIMAL(12,2);  -- variable del interes a retener
  DECLARE Var_Vencim_Anticipada   INT;      -- variable del vencimiento anticipado
  DECLARE Var_ClienteID       INT;      -- variable del cliente
  DECLARE Var_InverEnGar        INT;      -- variable de la inversion
  DECLARE Var_TasaISR         DECIMAL(12,2);  -- variable de la tas ISR del a inversion
  DECLARE Var_PagaISR         CHAR(1);    -- variable para saber si paga isr
  DECLARE Var_Beneficiario      CHAR(1);    -- variable para guardar si existe beneficiario
  DECLARE Var_EstatusCli        CHAR(1);    -- variable para saber el estus del cliente
  DECLARE Var_FuncionHuella     CHAR(1);    -- variable para saver si tiene huella
  DECLARE Var_ReqHuellaProductos    CHAR(1);    -- variable de los productos
  DECLARE Var_ConInvCapi        INT;      -- conceptos de inversion
  DECLARE Var_ConInvISR       INT;      -- conceptos de inversion
  DECLARE Var_ConAltInv       INT;      -- conceptos de inversion
  DECLARE Var_ConCanInv       INT;      -- conceptos de inversion
  DECLARE Var_PagoInver       INT;      -- conceptos de inversion
  DECLARE Var_PagoInverAnti     INT;      -- variable para guardar el ISRRreal de cada socio
  DECLARE Var_ISRReal         DECIMAL(12,2);  -- variable que guarda el ISRReal
  DECLARE Var_SalMinDF        DECIMAL(12,2);  -- variable que guarda el salario minimo
  DECLARE Var_SalMinAn        DECIMAL(12,2);  -- variable para guardar el salario minimo anualizado
  DECLARE Var_DiasInversion     DECIMAL(12,4);  -- variable para guardar los dias de la inversion
  DECLARE Var_FechaSis        DATE;     -- variable de la fecha del sistema
  DECLARE Var_DiasTrascurrido     INT;      -- variable de los dias transcurridos de la inversion
  DECLARE Var_Plazo         INT;      -- variable del plazo de la invesion en dias
  DECLARE Var_Tasa          DECIMAL(12,2);  -- tasa de la inversion
  DECLARE Var_UsuarioID       INT(11);    -- usuario que cancela la inversion
  DECLARE Var_Contrasenia       VARCHAR(45);  -- contrasena del usuario
  DECLARE Var_Control         VARCHAR(50);  -- variable de control
  DECLARE Var_FechaISR        DATE;     -- variable fecha de inicio cobro isr por socio
  DECLARE Var_AutorizaWS        INT(11);
  DECLARE Var_InverFecFin       DATE;     -- Fecha vencimiento Inversion
  DECLARE Var_ValorUMA        DECIMAL(12,4); -- variable para el valor de UMA
    DECLARE Var_TipoPersona       CHAR(1);
    DECLARE Var_InvPagoPeriodico        CHAR(1);        -- variable que indica si las Inversiones seran de Pago Periodico
  -- Declaracion de Constantes
  DECLARE Factor_Porcen       DECIMAL(12,2);
  DECLARE SI_PagaISR          CHAR(1);
  DECLARE AltPoliza_SI        CHAR(1);
  DECLARE AltPoliza_NO        CHAR(1);
  DECLARE Pagare_Impreso_SI     CHAR(1);
  DECLARE Pagare_Impreso_NO     CHAR(1);
  DECLARE Mov_AhorroSI        CHAR(1);
  DECLARE Mov_AhorroNO        CHAR(1);
  DECLARE Cadena_Vacia        CHAR(1);
  DECLARE Entero_Cero         INT;
  DECLARE Entero_Uno          INT;
  DECLARE Entero_Dos          INT;
  DECLARE Entero_Tres         INT;
  DECLARE Entero_Cinco        INT;
  DECLARE Decimal_Cero        DECIMAL(12,2);
  DECLARE Var_ISR_pSocio        CHAR(1);      -- Variable que guarda si esta activa la opcion de calculo por socio
  DECLARE Con_Capital         INT;
  DECLARE Mov_ApeInver        VARCHAR(4);
  DECLARE Mov_PagInvCap       VARCHAR(4);
  DECLARE Mov_PagInvrAnti       VARCHAR(4);
  DECLARE Mov_PagIntExe       VARCHAR(4);
  DECLARE Mov_PagIntGra       VARCHAR(4);
  DECLARE Mov_PagInvRet       VARCHAR(4);
  DECLARE Mov_CanInver        VARCHAR(4);
  DECLARE Estatus_Alta        CHAR;
  DECLARE Estatus_Vigente       CHAR;
  DECLARE Estatus_Pagada        CHAR;
  DECLARE Estatus_Cancel        CHAR;
  DECLARE No_Reinvertir       CHAR(1);
  DECLARE Nat_Cargo         CHAR(1);
  DECLARE Nat_Abono         CHAR(1);
  DECLARE SalidaNO          CHAR(1);
  DECLARE SalidaSI          CHAR(1);
  DECLARE Tipo_Provision        CHAR(4);
  DECLARE Pol_Automatica        CHAR(1);
  DECLARE Ope_Interna         CHAR(1);
  DECLARE Tip_Compra          CHAR(1);
  DECLARE Var_ConInvProv        INT;
  DECLARE Var_RefPagoInv        VARCHAR(100);
  DECLARE Var_RefPagoAnti       VARCHAR(100);
  DECLARE Cue_RetInver        VARCHAR(100);
  DECLARE NombreProceso       VARCHAR(16);
  DECLARE TipoBenefInver        CHAR(1);
  DECLARE Inactivo          CHAR(1);
  DECLARE AltaEncPolizaSi       CHAR(1);
  DECLARE VarProcesoCancel      VARCHAR(100);
  DECLARE SI_Isr_Socio        CHAR(1);
  DECLARE Act_LiberarInver      INT;
  DECLARE Huella_SI         CHAR(1);
  DECLARE TipoPersonaHu       CHAR(1);
  DECLARE ISRpSocio         VARCHAR(10);
  DECLARE No_constante        VARCHAR(10);
  DECLARE Var_FechaSistema      DATE;
  DECLARE Fecha_Vacia         DATE;
    DECLARE Par_TipoRegisPantalla   CHAR(1);
  DECLARE InstInversion       INT(11);
  DECLARE Est_Aplicado        CHAR(1);
  DECLARE ValorUMA          VARCHAR(15);
  DECLARE Es_Migrada            INT(11);
  DECLARE FechaInicioMigrada      DATE;
  DECLARE Var_ISRPendiente      DECIMAL(14,2);
  DECLARE Var_No                      CHAR(1);
    DECLARE Var_Si                      CHAR(1);
  -- Asignacion de constantes
  SET AltPoliza_SI        := 'S'; -- valor para comparar si se dara de alta una poliza
  SET AltPoliza_NO        := 'N'; -- valor para comparar si no se dara de alta una poliza
  SET Pagare_Impreso_SI     := 'S'; -- valor para comparar si se ha imprimido un pagare
  SET Pagare_Impreso_NO     := 'N'; -- valor para comparar si no se ha imprimido el pagare
  SET Mov_AhorroSI        := 'S'; -- valor para comparar si el movimiento es de ahorro
  SET Mov_AhorroNO        := 'N'; -- valor para comparar si el movimiento no es de ahorro
  SET Cadena_Vacia        := '';  -- valor para settear una cadena vacia
  SET Entero_Cero         := 0; -- valor para settear el valor de cero
  SET Entero_Uno          := 1; -- valor para settear el valor de uno
  SET Entero_Dos          := 2; -- valor para settear el valor de dos
  SET Entero_Tres         := 3; -- valor para settear el valor de tres
  SET Entero_Cinco        := 5; -- valor para settear el valor de cinco
  SET Decimal_Cero        := 0.00;-- valor para settear el valor de cero con decimales
  SET Con_Capital         := 1; -- concepto de cuentasaho
  SET Factor_Porcen       := 100.00;-- constante para operaciones contables
  SET Mov_ApeInver        := '60';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Mov_PagInvCap       := '61';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Mov_PagInvrAnti       := '68';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Mov_PagIntGra       := '62';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Mov_PagIntExe       := '63';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Mov_PagInvRet       := '64';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Mov_CanInver        := '67';-- concepto de inversion de la tabla TIPOSMOVSAHO
  SET Estatus_Alta        := 'A'; -- constante para saber si esta en estatus de alta la inversion
  SET Estatus_Vigente       := 'N'; -- constante para saber si esta vigente la inversion
  SET No_Reinvertir       := 'N'; -- constante para saber si se reinvertira o no
  SET Estatus_Pagada        := 'P'; -- constante para comparar si una inversion esta pagada
  SET Estatus_Cancel        := 'C'; -- constante para comparar si una inversion esta cancelada
  SET Nat_Cargo         := 'C'; -- constante para saber si es un movimiento de naturaleza cargo
  SET Nat_Abono         := 'A'; -- constante para saber si es un movimiento de naturaleza abono
  SET SalidaSI          := 'S'; -- constante para saber si tendra una salida
  SET SalidaNO          := 'N'; -- constante para saber si tendra una salida
  SET Tipo_Provision        := '100';-- concepto
  SET Pol_Automatica        := 'A'; -- constante para saber si es una poliza automatica
  SET Ope_Interna         := 'I'; -- concepto de operacion
  SET Tip_Compra          := 'C'; -- concepto de operacion
  SET SI_PagaISR          := 'S'; -- constante para comparar si se paga ISR
  SET SI_Isr_Socio        := 'S'; -- Constante para saber si se calcula el ISR por socio
  SET NombreProceso       := 'INVERSION';              -- Constante referencia de operacion
  SET Cue_PagIntExe       := 'PAGO INVERSION. INTERES EXENTO';   -- Constante referencia de operacion
  SET Cue_PagIntGra       := 'PAGO INVERSION. INTERES GRAVADO';  -- Constante referencia de operacion
  SET Cue_PagIntAntiExe     := 'VENCIMIENTO ANTICIPADO INVERSION. INTERES EXENTO';-- Constante referencia de operacion
  SET Cue_PagIntAntiGra     := 'VENCIMIENTO ANTICIPADO INVERSION. INTERES GRAVADO';-- Constante referencia de operacion
  SET Cue_RetInver        := 'RETENCION ISR INVERSION';     -- Constante referencia de operacion
  SET TipoBenefInver        := 'I';                 -- optenemos el tipo de beneficiario de la tabla INVERSIONES
  SET Inactivo          := 'I';                 -- constante para saber el estatus del cliente
  SET AltaEncPolizaSi       := 'S';                 -- contante para comparar si se da de alta una poliza
  SET Act_LiberarInver      := 4;                 -- constante para saberel numero de actualizacion de la inversion
  SET Par_NumErr          := Entero_Cero;             -- constante valor inicial del numero de error
  SET Par_ErrMen          := Cadena_Vacia;            -- constante valor inicial del mensaje de error
  SET VarProcesoCancel      := 'CLIENTESCANCELCTAPRO';        -- constante del proceso que se efectuara
  SET Huella_SI         := "S";                 -- si tiene huella el cliente
  SET TipoPersonaHu       := "C";                 -- tipo de persona que tiene huella
  SET Var_No                      := 'N'; -- Constante NO
    SET Var_Si                      := 'S'; -- Constante SI


 -- asignacion de variables
  SET Var_RefPagoInv        := 'PAGO DE INVERSION';          -- variable referencia de operacion
  SET Var_RefPagoAnti       := 'VENCIMIENTO ANTICIPADO INVERSION';   -- variable referencia de operacion
  SET Var_MontoOriginal     := Entero_Cero;             -- inicializamos el moto original a cero
  SET Var_InteresOriginal     := Entero_Cero;             -- inicializamos el el interes original a cero
  SET Var_CancelaInversion    := 2; -- valor para comparar el proceso que se realizara
  SET Var_CancelaReinversion    := 4; -- valor para comparar el proceso que se realizara
  SET Var_Autoriza        := 6; -- valor para comparar el proceso que se realizara
  SET Var_ImprimePagare     := 7; -- valor para comparar el proceso que se realizara
  SET Var_Vencim_Anticipada   := 8; -- valor para comparar el proceso que se realizara
  SET Var_AutorizaWS        := 9; -- valor para autorizar inversion desde ws sin PLD
  SET Var_ConInvCapi        := 1; -- concepto de inversion de la tabla CONCEPTOSINVER
  SET Var_ConInvProv        := 5; -- concepto de inversion de la tabla CONCEPTOSINVER
  SET Var_ConInvISR       := 4; -- concepto de inversion de la tabla CONCEPTOSINVER
  SET Var_ConAltInv       := 10;  -- concepto de inversion de la tabla CONCEPTOSINVER
  SET Var_ConCanInv       := 12;  -- concepto de inversion de la tabla CONCEPTOSINVER
  SET Var_PagoInver       := 15;  -- concepto depago inversion
  SET Var_PagoInverAnti     := 16;  -- concepto de pago anticipado
  SET ISRpSocio         := 'ISR_pSocio';  -- constante para isr por socio de PARAMGENERALES
  SET No_constante        := 'N';       -- constante NO
  SET Fecha_Vacia         := '1900-01-01';  -- fecha vacia
    SET Par_TipoRegisPantalla   := 'P';       -- Proceso en pantalla
    SET InstInversion       :=  13;       -- Instrumento tipo inversion
  SET Est_Aplicado        := 'A';       -- Estatus Aplicado
  SET ValorUMA          := 'ValorUMABase';  -- Valor Base para UMA
   SET FechaInicioMigrada :=  '2018-02-28';
  SET Var_ISRPendiente := 0;
  ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
      concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-INVERSIONACT');
        SET VarControl = 'SQLEXCEPTION' ;
      END;

    SELECT MonedaBaseID,FuncionHuella,ReqHuellaProductos,FechaSistema,FechaISR
      INTO Var_MonedaBase,Var_FuncionHuella,Var_ReqHuellaProductos,Var_FechaSistema,Var_FechaISR
        FROM PARAMETROSSIS;

    SET Var_MonedaBase = IFNULL(Var_MonedaBase,Entero_Uno);

    SELECT ValorParametro INTO Var_ISR_pSocio FROM PARAMGENERALES WHERE LlaveParametro=ISRpSocio;

    SELECT
      CuentaAhoID,   Monto,   Estatus,    FechaInicio,      EstatusImpresion,
      ClienteID,     MonedaID,  InteresRetener, SaldoProvision,     InteresGenerado,
      ISRReal,     FechaVencimiento
      INTO
      Var_Cuenta,   Var_Monto,  Var_Estatus,   Var_InverFecIni,  Var_EstatusImp,
      Var_Cliente,  Var_Moneda, Var_IntRetener,  Var_SalProvision,   Var_InteresGen,
      Var_ISRReal,  Var_InverFecFin
      FROM INVERSIONES
        WHERE InversionID = Par_InversionID;

    SET Var_IntRetener  := IFNULL(Var_IntRetener, Entero_Cero);
    SET Var_ISRReal   := IFNULL(Var_ISRReal, Entero_Cero);
    SET Var_FechaSistema:= IFNULL(Var_FechaSistema,Fecha_Vacia);
        SET Var_ISR_pSocio  := IFNULL(Var_ISR_pSocio,No_constante);
    SET Var_FechaISR  := IFNULL(Var_FechaISR,Var_FechaSistema);
        SELECT FechaSucursal INTO Var_FechaSucursal
      FROM SUCURSALES
        WHERE SucursalID = Aud_Sucursal;

    SET Aud_FechaActual := NOW();

/* ************************************************************************************************************************
  CANCELAR INVERSION ************************************************************************************
************************************************************************************************************************ */

    IF(Par_NumAct = Var_CancelaInversion)THEN
      IF (Var_Estatus != Estatus_Vigente AND Var_Estatus != Estatus_Alta) THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT('La Inversion no puede ser Cancelada (Revisar Estatus)');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      IF (DATEDIFF(Var_FechaSucursal,Var_InverFecIni)) != Entero_Cero THEN
        SET Par_NumErr  := Entero_Dos;
        SET Par_ErrMen  := CONCAT('La Inversion no es del Dia de Hoy');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT('El Usuario no esta logeado');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      SET Var_InverEnGar  := (SELECT COUNT(InversionID)
                  FROM CREDITOINVGAR
                  WHERE InversionID = Par_InversionID);
      SET Var_InverEnGar  := IFNULL(Var_InverEnGar, Entero_Cero);

      IF(Var_InverEnGar >Entero_Cero)THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT('No se puede Cancelar la Inversion porque esta Comprometida con un Credito que No esta Liquidado.');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      ELSE
        IF(Var_Estatus = Estatus_Vigente) THEN
          CALL CONTAINVERSIONPRO(
            Par_InversionID,  Par_EmpresaID,    Var_FechaSucursal,    Var_Monto,      Mov_CanInver,
            Var_ConCanInv,    Var_ConInvCapi,   Con_Capital,      Nat_Abono,      AltPoliza_NO,
            Mov_AhorroSI,   Par_Poliza,     Var_Cuenta,       Var_Cliente,    Var_Moneda,
            Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion);
        END IF;

        UPDATE INVERSIONES SET
          Estatus     = Estatus_Cancel,
          Reinvertir    = No_Reinvertir,
          EmpresaID     = Par_EmpresaID,
          Usuario     = Aud_Usuario,
          FechaActual   = Aud_FechaActual,
          DireccionIP   = Aud_DireccionIP,
          ProgramaID    = Aud_ProgramaID,
          Sucursal    = Aud_Sucursal,
          NumTransaccion  = Aud_NumTransaccion
          WHERE InversionID   = Par_InversionID;

        SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := CONCAT('Inversion Cancelada Exitosamente: ',Par_InversionID);
        SET varControl  := 'inversionID';
      END IF;
    END IF;

/* ************************************************************************************************************************
  CANCELAR RE INVERSION ************************************************************************************
************************************************************************************************************************ */

    /** Este se llama cuando se cancela la cuenta **/
    IF(Par_NumAct = Var_CancelaReinversion)THEN
      SELECT Estatus
      INTO  Var_Estatus
      FROM INVERSIONES
      WHERE InversionID = Par_InversionID;

      IF(IFNULL(Var_Estatus, Cadena_Vacia) = Estatus_Cancel)THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := CONCAT('No se puede Abonar la Inversion porque esta en Estatus Cancelada.');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      SET Var_InverEnGar  := (SELECT COUNT(InversionID)
                    FROM CREDITOINVGAR
                      WHERE InversionID = Par_InversionID);
      SET Var_InverEnGar  := IFNULL(Var_InverEnGar, Entero_Cero);

      IF(Var_InverEnGar >Entero_Cero)THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT('No se puede Reinvertir la Inversion porque esta Comprometida con un Credito que No esta Liquidado.');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      ELSE

    -- ============================== ISR POR CLIENTE ======================================================

        CALL CALCULOISRINSTPRO(
          Var_FechaSistema, Var_Cliente,    Par_TipoRegisPantalla,  SalidaNO,     Par_NumErr,
          Par_ErrMen,     Par_EmpresaID,    Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
          Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;


    -- ==============================FIN ISR POR CLIENTE======================================================

        IF(Par_AltaEncPoliza = AltaEncPolizaSi) THEN
          CALL MAESTROPOLIZAALT(
            Par_Poliza,     Par_EmpresaID,  Var_FechaSucursal,    Pol_Automatica,   Var_PagoInver,
            Var_RefPagoInv,   SalidaNO,   Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
            Aud_ProgramaID,   Aud_Sucursal, Aud_NumTransaccion);
        END IF;

        CALL CONTAINVERSIONPRO(
          Par_InversionID,    Par_EmpresaID,    Var_FechaSucursal,    Var_Monto,    Mov_PagInvCap,
          Var_PagoInver,      Var_ConInvCapi,   Con_Capital,      Nat_Abono,    AltPoliza_NO,
          Mov_AhorroSI,     Par_Poliza,     Var_Cuenta,       Var_Cliente,  Var_Moneda,
          Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
          Aud_NumTransaccion);
        -- si esta activo el calculo por socio settea el valor de isr a Var_IntRetener
      SELECT ISRReal
      INTO
        Var_ISRReal
          FROM INVERSIONES
    WHERE InversionID = Par_InversionID;

    SET Es_Migrada := (SELECT IFNULL(COUNT(InversionIDSAFI),Entero_Cero) FROM EQU_INVERSIONES
                WHERE InversionIDSAFI= Par_InversionID);

             /*Revisar esta validacion */
        IF (Var_ISR_pSocio=SI_Isr_Socio) THEN
           -- Si es migrada y menor a Marzo
            IF(Es_Migrada > Entero_Cero AND Var_InverFecIni<= FechaInicioMigrada) THEN
              SET Var_IntRetener:= Var_IntRetener;
            ELSE
              SET Var_IntRetener :=FNTOTALISRCTE(Var_Cliente,InstInversion,Par_InversionID);
            END IF;
        END IF;

        SET Var_ISRPendiente :=(SELECT IFNULL(InteresRet,Entero_Cero) FROM TMP_INVERSIONESRETENER
                    WHERE InversionID=Par_InversionID);

        SET Var_ISRPendiente := IFNULL(Var_ISRPendiente,Entero_Cero);

        IF (Var_ISRPendiente <> 0) THEN
          SET Var_IntRetener:= Var_IntRetener + (Var_ISRPendiente);
          IF(Var_IntRetener < Entero_Cero) THEN
            SET Var_IntRetener:= Entero_Cero;
          END IF;
        END IF;

        IF (Var_IntRetener = Entero_Cero) THEN
          SET Var_MovIntere := Mov_PagIntExe;
          SET Cue_PagIntere := Cue_PagIntExe;
        ELSE
          SET Var_MovIntere := Mov_PagIntGra;
          SET Cue_PagIntere := Cue_PagIntGra;
        END IF;

        IF (Var_InteresGen > Entero_Cero) THEN
          CALL CONTAINVERSIONPRO(
            Par_InversionID,  Par_EmpresaID,      Var_FechaSucursal,    Var_InteresGen,   Cadena_Vacia,
            Var_PagoInver,    Var_ConInvProv,     Entero_Cero,      Nat_Cargo,      AltPoliza_NO,
            Mov_AhorroNO,   Par_Poliza,       Var_Cuenta,       Var_Cliente,    Var_Moneda,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion  );

          CALL INVERSIONESMOVALT(
            Par_InversionID,  Aud_NumTransaccion,   Var_FechaSucursal,    Tipo_Provision,   Var_InteresGen,
            Nat_Abono,      Var_RefPagoInv,     Var_Moneda,       Par_Poliza,     Par_EmpresaID,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion );

        END IF;

        SET Var_Instrumento := CONVERT(Par_InversionID, CHAR);

        CALL CUENTASAHOMOVALT(
          Var_Cuenta,     Aud_NumTransaccion,   Var_FechaSucursal,    Nat_Abono,      Var_InteresGen,
          Cue_PagIntere,    Var_Instrumento,    Var_MovIntere,      Par_EmpresaID,    Aud_Usuario,
          Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        SET Var_CuentaStr := CONVERT(Var_Cuenta, CHAR);

        CALL POLIZAAHORROPRO(
          Par_Poliza,     Par_EmpresaID,      Var_FechaSucursal,    Var_Cliente,    Con_Capital,
          Var_Cuenta,     Var_Moneda,       Entero_Cero,      Var_InteresGen,   Cue_PagIntere,
          Var_CuentaStr,    Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
          Aud_Sucursal,   Aud_NumTransaccion);

        SET Var_Tasa  :=(SELECT Tasa FROM INVERSIONES WHERE InversionID = Par_InversionID);
                SET Var_Tasa  :=IFNULL(Var_Tasa,Decimal_Cero);

        -- Registro de infomacion para el Calculo del Interes REAL para Inversiones
        CALL CALCULOINTERESREALALT (
           Var_Cliente,   Var_FechaSucursal,  InstInversion,    Par_InversionID,  Var_Monto,
                     Var_InteresGen,  Var_IntRetener,   Var_Tasa,     Var_InverFecIni,  Var_FechaSistema,
                     Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                     Aud_Sucursal,    Aud_NumTransaccion);

        IF (Var_IntRetener > Entero_Cero) THEN
          CALL CUENTASAHOMOVALT(
            Var_Cuenta,     Aud_NumTransaccion,   Var_FechaSucursal,  Nat_Cargo,      Var_IntRetener,
            Cue_RetInver,   Var_Instrumento,    Mov_PagInvRet,    Par_EmpresaID,    Aud_Usuario,
            Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

          CALL POLIZAAHORROPRO(
            Par_Poliza,     Par_EmpresaID,      Var_FechaSucursal,  Var_Cliente,    Con_Capital,
            Var_Cuenta,     Var_Moneda,       Var_IntRetener,   Entero_Cero,    Cue_RetInver,
            Var_CuentaStr,    Aud_Usuario,      Aud_FechaActual,   Aud_DireccionIP, Aud_ProgramaID,
            Aud_Sucursal,   Aud_NumTransaccion  );

          IF (Var_MonedaBase != Var_Moneda) THEN

            SELECT TipCamComInt INTO Var_TipCamCom
              FROM MONEDAS
                WHERE MonedaId = Var_Moneda;

            SET Var_TipCamCom := IFNULL(Var_TipCamCom, Entero_Uno);
            SET Var_IntRetMN  := ROUND(Var_IntRetener * Var_TipCamCom, Entero_Dos);

            CALL COMVENDIVISAALT(
              Var_Moneda,   Aud_NumTransaccion,   Var_FechaSucursal,  Var_IntRetener,   Var_TipCamCom,
              Ope_Interna,  Tip_Compra,       Var_Instrumento,  Var_RefPagoInv,   NombreProceso,
              Par_Poliza,   Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
              Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion  );
          ELSE
            SET Var_IntRetMN = Var_IntRetener;
          END IF;

          CALL CONTAINVERSIONPRO(
            Par_InversionID,  Par_EmpresaID,    Var_FechaSucursal,    Var_IntRetMN,   Cadena_Vacia,
            Var_PagoInver,    Var_ConInvISR,    Entero_Cero,      Nat_Abono,      AltPoliza_NO,
            Mov_AhorroNO,   Par_Poliza,     Var_Cuenta,       Var_Cliente,    Var_MonedaBase,
            Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion  );
        END IF;

        UPDATE INVERSIONES SET
          Estatus     = Estatus_Pagada,
          ISRReal     = Var_IntRetener,  -- Se actualiza el ISR REAL a retener.
          Reinvertir    = No_Reinvertir,
          EmpresaID     = Par_EmpresaID,
          Usuario     = Aud_Usuario,
          FechaActual   = Aud_FechaActual,
          DireccionIP   = Aud_DireccionIP,
          ProgramaID    = Aud_ProgramaID,
          Sucursal    = Aud_Sucursal,
          NumTransaccion  = Aud_NumTransaccion
          WHERE InversionID   = Par_InversionID;

    -- ============================== ACTUALIZA EL COBROISR ======================================================
        UPDATE COBROISR isr
            SET Estatus = Est_Aplicado
          WHERE ClienteID   = Var_Cliente
          AND ProductoID    = Par_InversionID
          AND InstrumentoID = InstInversion;
    -- ==============================          FIN           ======================================================


      END IF;
      SET Par_NumErr  := 000;
      SET Par_ErrMen  := CONCAT('Inversion Abonada Exitosamente: ',Par_InversionID);
      SET varControl  := 'inversionID';
    END IF;

    IF(Par_NumAct = Var_Autoriza) THEN

      IF Var_FuncionHuella= Huella_SI AND Var_ReqHuellaProductos=Huella_SI THEN
        IF NOT EXISTS(SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona=TipoPersonaHu AND Hue.PersonaID=Var_Cliente)THEN
          SET Par_NumErr  := Entero_Dos;
          SET Par_ErrMen  := CONCAT( 'El Cliente no tiene Huella Registrada.');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;
      END IF;

      SELECT Cli.Estatus INTO Var_EstatusCli
        FROM CLIENTES Cli
          INNER JOIN INVERSIONES Inv ON Inv.ClienteID=Cli.ClienteID
          WHERE InversionID=Par_InversionID;

      IF(Var_EstatusCli = Inactivo) THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT( 'El Cliente se Encuentra Inactivo');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      SELECT Beneficiario INTO Var_Beneficiario
          FROM INVERSIONES Inv
            WHERE Beneficiario = TipoBenefInver
            AND Inv.InversionID= Par_InversionID;

      IF(IFNULL(Var_Beneficiario,Cadena_Vacia )= TipoBenefInver)THEN
        IF NOT EXISTS(SELECT *
          FROM BENEFICIARIOSINVER Ben
            WHERE Ben.InversionID= Par_InversionID)THEN
          SET Par_NumErr  := Entero_Tres;
          SET Par_ErrMen  := CONCAT( 'Es Necesario Capturar los Beneficiarios de la Inversion');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;
      END IF;

       IF(Par_NumErr = Entero_Cero OR Par_NumErr = 502) THEN
        IF (Var_Estatus != Estatus_Alta) THEN
          SET Par_NumErr  := Entero_Tres;
          SET Par_ErrMen  := CONCAT('La Inversion no puede ser Autorizada (Revisar Estatus)');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;

        IF (DATEDIFF(Var_InverFecIni, Var_FechaSucursal)) != Entero_Cero THEN
          SET Par_NumErr  := Entero_Tres;
          SET Par_ErrMen  := CONCAT('La Inversion no es del Dia de Hoy');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;

        IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
          SET Par_NumErr  := Entero_Tres;
          SET Par_ErrMen  := CONCAT('El Usuario no esta logeado');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;

        CALL CONTAINVERSIONPRO(
          Par_InversionID,  Par_EmpresaID,    Var_FechaSucursal,    Var_Monto,      Mov_ApeInver,
          Var_ConAltInv,    Var_ConInvCapi,   Con_Capital,      Nat_Cargo,      AltPoliza_NO,
          Mov_AhorroSI,   Par_Poliza,     Var_Cuenta,       Var_Cliente,    Var_Moneda,
          Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
          Aud_NumTransaccion);
        SET Var_InvPagoPeriodico:= (SELECT InvPagoPeriodico FROM PARAMETROSSIS WHERE EmpresaID = Entero_Uno);
                SET Var_InvPagoPeriodico := IFNULL(Var_InvPagoPeriodico, Var_No);

                IF (Var_InvPagoPeriodico = Var_Si) THEN
                    CALL INVPERIODICAALT (
                        Par_InversionID,        SalidaNO,           Par_NumErr,             Par_ErrMen,         Par_EmpresaID,
                        Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
                        Aud_NumTransaccion
                        );

                IF(Par_NumErr != Entero_Cero)THEN
                  LEAVE ManejoErrores;
                END IF;
              END IF;

        UPDATE INVERSIONES SET
          Estatus     = Estatus_Vigente,
          UsuarioID     = Aud_Usuario,
          EmpresaID     = Par_EmpresaID,
          FechaActual   = Aud_FechaActual,
          DireccionIP   = Aud_DireccionIP,
          ProgramaID    = Aud_ProgramaID,
          Sucursal    = Aud_Sucursal,
          NumTransaccion  = Aud_NumTransaccion
          WHERE InversionID   = Par_InversionID;
        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Inversion Autorizada Exitosamente: ',Par_InversionID);
        SET varControl  := 'inversionID';
       ELSE
        SET Par_NumErr  := 000;
        SET Par_ErrMen  := Par_ErrMen;
        SET varControl  := 'inversionID';
      END IF;

    END IF;

    IF(Par_NumAct = Var_ImprimePagare) THEN

      IF(IFNULL(Var_EstatusImp, Cadena_Vacia)) != Pagare_Impreso_NO THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT( 'El Pagare ya ha sido Impreso');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;


      UPDATE INVERSIONES SET
        EstatusImpresion = Pagare_Impreso_SI,
        UsuarioID   = Aud_Usuario,
        EmpresaID   = Par_EmpresaID,
        FechaActual = Aud_FechaActual,
        DireccionIP = Aud_DireccionIP,
        ProgramaID  = Aud_ProgramaID,
        Sucursal  = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
        WHERE InversionID   = Par_InversionID;
      SET Par_NumErr  := 000;
      SET Par_ErrMen  := CONCAT('Pagare Impreso Exitosamente');
      SET varControl  := 'inversionID';
    END IF;

    IF(Par_NumAct = Var_Vencim_Anticipada)THEN
      IF (Var_Estatus != Estatus_Vigente) THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT('La Inversion no puede ser Cancelada (Revisar Estatus)');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      IF(Aud_ProgramaID != VarProcesoCancel)THEN
        IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
          SET Par_NumErr  := Entero_Tres;
          SET Par_ErrMen  := CONCAT('El Usuario no esta logeado');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;

        SELECT  UsuarioID , Contrasenia INTO  Var_UsuarioID,Var_Contrasenia
          FROM USUARIOS
          WHERE Clave = Par_UsuarioClave;

        SET Var_Contrasenia := IFNULL(Var_Contrasenia, Cadena_Vacia);

        IF(Var_UsuarioID = Aud_Usuario)THEN
          SET Par_NumErr  :=  Entero_Tres;
          SET Par_ErrMen  := CONCAT('El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza.');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;

        IF(Par_ContraseniaAut != Var_Contrasenia)THEN
          SET  Par_NumErr := Entero_Cinco;
          SET  Par_ErrMen := 'Contrasena o Usuario Incorrecto.';
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;
    END IF;


    SELECT
      DiasInversion,    MonedaBaseID, FechaSistema, SalMinDF,   FechaISR
      INTO
      Var_DiasInversion,  Var_MonedaBase, Var_FechaSis, Var_SalMinDF, Var_FechaISR
        FROM PARAMETROSSIS;

    SET Var_MonedaBase = IFNULL(Var_MonedaBase,Entero_Uno);

    SELECT ValorParametro
      INTO Var_ValorUMA
      FROM PARAMGENERALES
    WHERE LlaveParametro=ValorUMA;

    SELECT
      DATEDIFF(Var_FechaSucursal,FechaInicio),  Plazo,    Tasa,   Monto,    ClienteID,
      SaldoProvision,     FechaInicio
      INTO
      Var_DiasTrascurrido,            Var_Plazo,  Var_Tasa, Var_Monto,  Var_ClienteID,
      Var_SalProvision,   Var_InverFecIni
      FROM INVERSIONES
        WHERE InversionID = Par_InversionID;

    -- ============================== ISR POR CLIENTE ======================================================

        CALL CALCULOISRINSTPRO(
          Var_FechaSistema, Var_ClienteID,    Par_TipoRegisPantalla,  SalidaNO,     Par_NumErr,
          Par_ErrMen,     Par_EmpresaID,    Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
          Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;

    -- ==============================FIN ISR POR CLIENTE======================================================

    SELECT  Suc.TasaISR,  Cli.PagaISR,  Cli.TipoPersona
        INTO Var_TasaISR,   Var_PagaISR,  Var_TipoPersona
      FROM  CLIENTES Cli,
          SUCURSALES Suc
        WHERE   Cli.ClienteID = Var_ClienteID
          AND   Suc.SucursalID = Cli.SucursalOrigen;

    SET Var_SalMinAn := Var_SalMinDF * Entero_Cinco* Var_ValorUMA;

        SELECT
      ISRReal
      INTO
         Var_ISRReal
      FROM INVERSIONES
        WHERE InversionID = Par_InversionID;
    SET Es_Migrada := (SELECT IFNULL(COUNT(InversionIDSAFI),Entero_Cero) FROM EQU_INVERSIONES
                    WHERE InversionIDSAFI= Par_InversionID);

    IF (Var_PagaISR = SI_PagaISR) THEN
  -- si esta activo el calculo por socio settea el valor de isr a Var_IntRetener
      IF (Var_ISR_pSocio=SI_Isr_Socio) THEN

         -- Si es migrada y menor a Marzo
      IF(Es_Migrada > Entero_Cero AND Var_InverFecIni<= FechaInicioMigrada) THEN
        SET Var_IntRetener:= Var_IntRetener;
      ELSE
        SET Var_IntRetener :=FNTOTALISRCTE(Var_Cliente,InstInversion,Par_InversionID);
      END IF;
         ELSE
            /* Cuando sea persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exencion alguna. */
          IF( Var_Monto > Var_SalMinAn OR Var_TipoPersona = 'M')THEN
            IF(Var_TipoPersona = 'M')THEN
              SET Var_IntRetener = ROUND((Var_Monto * Var_DiasTrascurrido * Var_TasaISR) / (Factor_Porcen * Var_DiasInversion), 2);
            ELSE
              SET Var_IntRetener :=FNTOTALISRCTE(Var_Cliente,InstInversion,Par_InversionID);
                        END IF;
          ELSE
            SET Var_IntRetener = Decimal_Cero;
                    END IF;
       END IF;
    END IF;
     SET Var_ISRPendiente :=(SELECT IFNULL(InteresRet,Entero_Cero) FROM TMP_INVERSIONESRETENER
      WHERE InversionID=Par_InversionID);

    SET Var_ISRPendiente := IFNULL(Var_ISRPendiente,Entero_Cero);

    IF (Var_ISRPendiente <> 0) THEN
      SET Var_IntRetener:= Var_IntRetener + (Var_ISRPendiente);
      IF(Var_IntRetener < Entero_Cero) THEN
        SET Var_IntRetener:= Entero_Cero;
      END IF;
    END IF;
    IF(Var_Estatus = Estatus_Vigente) THEN
      IF(Par_AltaEncPoliza = AltaEncPolizaSi) THEN
        CALL MAESTROPOLIZAALT(
          Par_Poliza,     Par_EmpresaID,  Var_FechaSucursal,    Pol_Automatica,   Var_PagoInverAnti,
          Var_RefPagoAnti,  SalidaNO,   Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
          Aud_ProgramaID,   Aud_Sucursal, Aud_NumTransaccion);
      END IF;

      SET Var_InverEnGar  := (SELECT COUNT(InversionID)
                  FROM CREDITOINVGAR
                  WHERE InversionID = Par_InversionID);
      SET Var_InverEnGar  := IFNULL(Var_InverEnGar, Entero_Cero);

      IF(Var_InverEnGar >Entero_Cero)THEN
        CALL CREDITOINVGARACT(
          Entero_Cero,    Entero_Cero,    Par_InversionID,  Par_Poliza,   Act_LiberarInver,
          SalidaNO,     Par_NumErr,     Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,
          Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal, Aud_NumTransaccion);
        IF(Par_NumErr != Entero_Cero)THEN
          LEAVE ManejoErrores;
        END IF;
      END IF;

      CALL CONTAINVERSIONPRO(
        Par_InversionID,     Par_EmpresaID,     Var_FechaSucursal,    Var_Monto,     Mov_PagInvrAnti,
        Var_PagoInverAnti,     Var_ConInvCapi,    Con_Capital,      Nat_Abono,     AltPoliza_NO,
        Mov_AhorroSI,      Par_Poliza,      Var_Cuenta,       Var_Cliente,   Var_Moneda,
        Aud_Usuario,       Aud_FechaActual,   Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
        Aud_NumTransaccion);

      IF (Var_IntRetener = Entero_Cero) THEN
        SET Var_MovIntere := Mov_PagIntExe;
        SET Cue_PagIntere := Cue_PagIntAntiExe;
      ELSE
        SET Var_MovIntere := Mov_PagIntGra;
        SET Cue_PagIntere := Cue_PagIntAntiGra;
      END IF;

      IF (Var_SalProvision > Entero_Cero) THEN
        CALL CONTAINVERSIONPRO(
          Par_InversionID,    Par_EmpresaID,    Var_FechaSucursal,    Var_SalProvision,   Cadena_Vacia,
          Var_PagoInverAnti,    Var_ConInvProv,   Entero_Cero,      Nat_Cargo,         AltPoliza_NO,
          Mov_AhorroNO,     Par_Poliza,     Var_Cuenta,       Var_Cliente,      Var_Moneda,
          Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
          Aud_NumTransaccion  );

        CALL INVERSIONESMOVALT(
          Par_InversionID,  Aud_NumTransaccion,     Var_FechaSucursal,    Tipo_Provision,   Var_SalProvision,
          Nat_Abono,      Var_RefPagoAnti,      Var_Moneda,       Par_Poliza,     Par_EmpresaID,
          Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,     Aud_ProgramaID,   Aud_Sucursal,
          Aud_NumTransaccion );


        SET Var_Instrumento = CONVERT(Par_InversionID, CHAR);

        CALL CUENTASAHOMOVALT(
          Var_Cuenta,       Aud_NumTransaccion,   Var_FechaSucursal,  Nat_Abono,    Var_SalProvision,
          Cue_PagIntere,      Var_Instrumento,    Var_MovIntere,    Par_EmpresaID,  Aud_Usuario,
          Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal, Aud_NumTransaccion);


        SET Var_CuentaStr = CONVERT(Var_Cuenta, CHAR);

        CALL POLIZAAHORROPRO(
          Par_Poliza,   Par_EmpresaID,  Var_FechaSucursal,    Var_Cliente,      Con_Capital,
          Var_Cuenta,   Var_Moneda,   Entero_Cero,      Var_SalProvision,   Cue_PagIntere,
          Var_CuentaStr,  Aud_Usuario,  Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
          Aud_Sucursal, Aud_NumTransaccion  );

                -- Registro de informacion para el Calculo del Interes REAL para Inversiones
        CALL CALCULOINTERESREALALT (
           Var_Cliente,   Var_FechaSucursal,  InstInversion,    Par_InversionID,  Var_Monto,
                     Var_SalProvision,  Var_IntRetener,   Var_Tasa,     Var_InverFecIni,  Var_FechaSis,
                     Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,
                     Aud_Sucursal,    Aud_NumTransaccion);

        IF (Var_IntRetener > Entero_Cero) THEN

          CALL CUENTASAHOMOVALT(
            Var_Cuenta,     Aud_NumTransaccion,     Var_FechaSucursal,    Nat_Cargo,    Var_IntRetener,
            Cue_RetInver,   Var_Instrumento,      Mov_PagInvRet,      Par_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,  Aud_DireccionIP,      Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion);

          CALL POLIZAAHORROPRO(
            Par_Poliza,   Par_EmpresaID,    Var_FechaSucursal,    Var_Cliente,        Con_Capital,
            Var_Cuenta,   Var_Moneda,     Var_IntRetener,     Entero_Cero,        Cue_RetInver,
            Var_CuentaStr,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,      Aud_ProgramaID,
            Aud_Sucursal, Aud_NumTransaccion  );

          IF (Var_MonedaBase != Var_Moneda) THEN
            SELECT TipCamComInt INTO Var_TipCamCom
              FROM MONEDAS
              WHERE MonedaId = Var_Moneda;

          SET Var_TipCamCom := IFNULL(Var_TipCamCom, Entero_Uno);

            SET Var_IntRetMN = ROUND(Var_IntRetener * Var_TipCamCom, Entero_Dos);

            CALL COMVENDIVISAALT(
              Var_Moneda,   Aud_NumTransaccion,   Var_FechaSucursal,    Var_IntRetener,   Var_TipCamCom,
              Ope_Interna,  Tip_Compra,       Var_Instrumento,    Var_RefPagoAnti,  NombreProceso,
              Par_Poliza,   Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
              Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);

          ELSE
            SET Var_IntRetMN = Var_IntRetener;
          END IF;

          CALL CONTAINVERSIONPRO(
            Par_InversionID,    Par_EmpresaID,    Var_FechaSucursal,  Var_IntRetMN,   Cadena_Vacia,
            Var_PagoInverAnti,    Var_ConInvISR,    Entero_Cero,    Nat_Abono,      AltPoliza_NO,
            Mov_AhorroNO,     Par_Poliza,     Var_Cuenta,     Var_Cliente,    Var_MonedaBase,
            Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion  );
        END IF;
      END IF;

      UPDATE INVERSIONES SET
        Estatus     = Estatus_Cancel,
        Reinvertir    = No_Reinvertir,
        FechaVenAnt   = Var_FechaSis,
        EmpresaID     = Par_EmpresaID,
        Usuario     = Aud_Usuario,
        FechaActual   = Aud_FechaActual,
        DireccionIP   = Aud_DireccionIP,
        ProgramaID    = Aud_ProgramaID,
        Sucursal    = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
        WHERE InversionID   = Par_InversionID;
      END IF;

    -- ============================== ACTUALIZA EL COBROISR ======================================================
        UPDATE COBROISR isr
            SET Estatus = Est_Aplicado
          WHERE ClienteID   = Var_ClienteID
          AND ProductoID    = Par_InversionID
          AND InstrumentoID = InstInversion;
    -- ==============================          FIN           ======================================================

            SET Par_NumErr  := 000;
      SET Par_ErrMen  := CONCAT('Inversion Cancelada Exitosamente: ',Par_InversionID);

      SET varControl  := 'inversionID';

    END IF;

        -- Autorizacion de inversion desde WS NUMERO 9
        IF(Par_NumAct = Var_AutorizaWS) THEN

      IF Var_FuncionHuella= Huella_SI AND Var_ReqHuellaProductos=Huella_SI THEN
        IF NOT EXISTS(SELECT * FROM HUELLADIGITAL Hue WHERE Hue.TipoPersona=TipoPersonaHu AND Hue.PersonaID=Var_Cliente)THEN
          SET Par_NumErr  := Entero_Dos;
          SET Par_ErrMen  := CONCAT( 'El Cliente no tiene Huella Registrada.');
          SET varControl  := 'inversionID';
          LEAVE ManejoErrores;
        END IF;
      END IF;

      SELECT Cli.Estatus INTO Var_EstatusCli
        FROM CLIENTES Cli
          INNER JOIN INVERSIONES Inv ON Inv.ClienteID=Cli.ClienteID
          WHERE InversionID=Par_InversionID;

      IF(Var_EstatusCli = Inactivo) THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT( 'El Cliente se Encuentra Inactivo');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      IF (Var_Estatus != Estatus_Alta) THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT('La Inversion no puede ser Autorizada (Revisar Estatus)');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      IF (DATEDIFF(Var_InverFecIni, Var_FechaSucursal)) != Entero_Cero THEN
        SET Par_NumErr  := Entero_Tres;
        SET Par_ErrMen  := CONCAT('La Inversion No Es Del Dia de Hoy');
        SET varControl  := 'inversionID';
        LEAVE ManejoErrores;
      END IF;

      CALL CONTAINVERSIONPRO(
        Par_InversionID,  Par_EmpresaID,    Var_FechaSucursal,    Var_Monto,      Mov_ApeInver,
        Var_ConAltInv,    Var_ConInvCapi,   Con_Capital,      Nat_Cargo,      AltPoliza_NO,
        Mov_AhorroSI,   Par_Poliza,     Var_Cuenta,       Var_Cliente,    Var_Moneda,
        Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion);

      UPDATE INVERSIONES SET
        Estatus     = Estatus_Vigente,
        UsuarioID     = Aud_Usuario,
        EmpresaID     = Par_EmpresaID,
        FechaActual   = Aud_FechaActual,
        DireccionIP   = Aud_DireccionIP,
        ProgramaID    = Aud_ProgramaID,
        Sucursal    = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion
      WHERE InversionID = Par_InversionID;

      SET Par_NumErr  := 000;
      SET Par_ErrMen  := CONCAT('Inversion Autorizada Exitosamente: ',Par_InversionID);
      SET varControl  := 'inversionID';

    END IF;

  END ManejoErrores;

  IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr    AS NumErr,
        Par_ErrMen    AS ErrMen,
        varControl    AS control,
        Par_InversionID AS consecutivo;
  END IF;

END TerminaStore$$
