-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERPAGCIEDIAPRE
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERPAGCIEDIAPRE`;
DELIMITER $$


CREATE PROCEDURE `INVERPAGCIEDIAPRE`(
-- --------------------------------------------------------------------------------
-- SP PARA REALIZAR LOS PAGOS DE LOS INTERESES DE LAS INVERSIONES POR PLAZO
-- --------------------------------------------------------------------------------
    Par_Fecha         DATE,               -- Fecha para el Pago de Inversiones
    Par_Salida        CHAR(1),      -- Tipo de Salida S. Si N. No
  INOUT Par_NumErr    INT(11),      -- Numero de Error
  INOUT Par_ErrMen    VARCHAR(400),   -- Mensaje de Error
  Par_EmpresaID     INT(11),      -- Parametro de Auditoria
  Aud_Usuario       INT(11),      -- Parametro de Auditoria
  Aud_FechaActual     DATE,       -- Parametro de Auditoria
  Aud_DireccionIP     VARCHAR(15),    -- Parametro de Auditoria
  Aud_ProgramaID      VARCHAR(50),    -- Parametro de Auditoria
  Aud_Sucursal      INT(11),      -- Parametro de Auditoria
  Aud_NumTransaccion    BIGINT(20)      -- Parametro de Auditoria
)

TerminaStore: BEGIN
  -- DECLARACION DE VARIABLES

  DECLARE Var_InversionID     BIGINT(20);   -- Variable para el ID de la Inversion
  DECLARE Var_CuentaAhoID     BIGINT(20);   -- Variable para el ID de la Cuenta
  DECLARE Var_TipoInversionID INT(11);    -- Variable para el Tipo de Inversion
  DECLARE Var_MonedaID        INT(11);    -- Variable para ID de Moneda
  DECLARE Var_Monto           DECIMAL(14,2);  -- Variable para el Monto
    DECLARE Var_FechaUlPag    DATE;           -- Variable de Fecha de Ultimo Pago

  DECLARE Var_InteresGenerado DECIMAL(14,2);  -- Variable para el Interes Generado
  DECLARE Var_InteresRetener  DECIMAL(14,2);  -- Variable para el Interes a Retener
  DECLARE Var_ClienteID       BIGINT(20);   -- Variable para el ID del Cliente
  DECLARE Var_SaldoProvision  DECIMAL(14,2);  -- Variable para el Saldo de Provision
  DECLARE VAR_ISRReal     DECIMAL(12,2);  -- Variable para el ISR

    DECLARE Var_ISR_pSocio    CHAR(1);    -- Variable para el ISR por Socio
  DECLARE Var_SucCliente      INT(11);    -- Variable para la Sucursal del Socio
  DECLARE Var_NumeroVenc    INT(11);    -- Variable para el Numero de Inversiones a Vencer
  DECLARE Var_MovIntere     VARCHAR(4);   -- Variable para el Movimiente de Interes
  DECLARE Cue_PagIntere     CHAR(50);   -- Variable para pago de Interes Excento o Gravado
  DECLARE Par_Poliza        BIGINT(20);   -- Variable para la Poliza
  DECLARE Var_Instrumento   VARCHAR(15);  -- Variable para Instrumento de Poliza
  DECLARE Var_CuentaStr     VARCHAR(15);  -- Variable para la Cuenta
  DECLARE Var_MonedaBase    INT(11);    -- Variable para la Moneda Base
  DECLARE Var_TipCamCom     DECIMAL(14,6);  -- Variable
  DECLARE Var_IntRetMN      DECIMAL(12,2);  -- Variable para el Interes a Retener
  DECLARE Var_InverFecIni   DATE;     -- Variable para la Fecha de Inicio de la Inversion
    DECLARE Var_InverFecFin   DATE;     -- Variable para la Fecha de Vencimiento de la Inversion
    DECLARE Var_Tasa      DECIMAL(12,2);  -- Variable para la Tasa de la Inversion
    DECLARE Var_ProxPago        DATE;            -- Variable del Proximo Pago
    DECLARE Var_Periodicidad    INT(11);        -- Variable de Periocidad de Pago

  DECLARE Par_NumErr      INT(11);    -- Variable para Numero de Error
  DECLARE Par_ErrMen      VARCHAR(400); -- Variable para el Mensaje de Error
  DECLARE Var_Control     VARCHAR(50);  -- Variable para el ID del control de pantalla

    -- DECLARIACION DE CONSTANTES
  DECLARE Cadena_Vacia      CHAR(1);        -- Constante de Cadena Vacia
    DECLARE Fecha_Vacia       DATE;           -- Constante de Fecha Vacia
  DECLARE Entero_Cero       INT(11);        -- Constante Entero Cero
    DECLARE Entero_Dos      INT(11);        -- Constante Valor 2
  DECLARE Estatus_Vigente   CHAR(1);        -- Constante de Estatus Vigente de Inversiones
  DECLARE Estatus_Pagada    CHAR(1);        -- Constante de Estatus Pagada de Inversiones
  DECLARE Ren_PagoInver     INT(11);        -- Constante de Pago de Inversion
  DECLARE Pol_Automatica    CHAR(1);        -- Constante de Poliza Automatica
  DECLARE Var_PagoInver     INT(11);        -- Constante de Pago de Inversion
  DECLARE Var_RefPagoInv    VARCHAR(100);   -- Constante de Referencia de Pago
  DECLARE Nat_Cargo         CHAR(1);        -- Constante de Naturaleza de Cargo
  DECLARE Nat_Abono         CHAR(1);        -- Constante de Naturaleza de Abono
  DECLARE SalidaNO          CHAR(1);        -- Constante de Salida 'N'
  DECLARE SalidaSI          CHAR(1);        -- Constante de Salida 'S'
  DECLARE Var_ConInvCapi    INT(11);        -- Constante de Saldo Capital de la Inversion
  DECLARE Var_ConInvProv    INT(11);        -- Constante de Saldo Provisionado de la Inversion
  DECLARE Var_ConInvISR     INT(11);        -- Constante de ISR de la Inversion
  DECLARE Con_Capital       INT(11);        -- Constante de Capital
  DECLARE Mov_AhorroSI      CHAR(1);        -- Constante de Movimiento de Ahorro 'S'
  DECLARE Mov_AhorroNO      CHAR(1);        -- Constante de Movimiento de Ahorro 'N'
  DECLARE Cue_PagIntExe     CHAR(50);       -- Constante de Pago de Interes Excento
  DECLARE Cue_PagIntGra     CHAR(50);       -- Constante de Pago de Interes Gravado
  DECLARE Cue_RetInver      CHAR(50);       -- Constante de Retencion de Inversion
  DECLARE Tipo_Provision    CHAR(4);        -- Constante de Tipo de Provision
  DECLARE NombreProceso     VARCHAR(20);    -- Constante de Nombre del Proceso
  DECLARE Ope_Interna       CHAR(1);        -- Constante de Operacion Interna
  DECLARE Tip_Compra        CHAR(1);        -- Constante de Tipo de Compra
  DECLARE AltPoliza_SI      CHAR(1);        -- Constante de Alta de Poliza 'S'
  DECLARE AltPoliza_NO      CHAR(1);        -- Constante de Alta de Poliza 'N'
  DECLARE SI_Isr_Socio      CHAR(1);        -- Constante de ISR de Socio 'S'
  DECLARE Mov_PagInvCap     VARCHAR(4);     -- Constante de Movimiento de Pago Capital
  DECLARE Mov_PagIntExe     VARCHAR(4);     -- Constante de Movimiento de Int Excedente
  DECLARE Mov_PagIntGra     VARCHAR(4);     -- Constante de Movimiento de Int Gravado
  DECLARE Mov_PagInvRet     VARCHAR(4);     -- Constante de Movimiento de Int Retenido
    DECLARE ISRpSocio     VARCHAR(10);    -- Constante de ISR de Socio
    DECLARE No_constante    VARCHAR(10);    -- Constante NO
  DECLARE Var_FechaISR    DATE;     -- Constante de Fecha de ISR
  DECLARE Var_NumCred     INT(11);    -- Constante de Numero de Credito
  DECLARE Var_TipoInstrumento INT(11);        -- Constante de Tipo de Instrumento
    DECLARE Est_Aplicado        CHAR(1);        -- Constante de Estatus Aplicado
  DECLARE EnteroUno     INT(11);        -- Constante de Entero UNO 1
    DECLARE ProcesoCierre   CHAR(1);        -- Constante de Proceso de Cierre
    DECLARE Var_SI        CHAR(1);        -- Constante SI


-- SETEO DE CONSTANTES

  SET Cadena_Vacia    := '';
  SET Fecha_Vacia     := '1900-01-01';
  SET Entero_Cero     := 0;
    SET Entero_Dos      := 2;
    SET Estatus_Vigente := 'N';
  SET Estatus_Pagada  := 'P';
  SET Ren_PagoInver   := 111;
  SET Pol_Automatica  := 'A';
  SET Var_PagoInver   := 15;
  SET Nat_Cargo       := 'C';
  SET Nat_Abono       := 'A';
  SET SalidaSI        := 'S';
  SET SalidaNO        := 'N';
  SET Mov_PagInvCap   := '61';
  SET Mov_PagIntGra   := '62';
  SET Mov_PagIntExe   := '63';
  SET Mov_PagInvRet   := '64';
  SET Var_ConInvCapi  := 1;
  SET Var_ConInvProv  := 5;
  SET Var_ConInvISR   := 4;
  SET Con_Capital     := 1;
  SET Mov_AhorroSI    := 'S';
  SET Mov_AhorroNO    := 'N';
  SET Tipo_Provision  := '100';
  SET Ope_Interna     := 'I';
  SET Tip_Compra      := 'C';
  SET AltPoliza_SI    := 'S';
  SET AltPoliza_NO    := 'N';
  SET SI_Isr_Socio  := 'S';


  SET Cue_PagIntExe   := 'PAGO INVERSION. INTERES EXENTO';
  SET Cue_PagIntGra   := 'PAGO INVERSION. INTERES GRAVADO';
  SET Cue_RetInver    := 'RETENCION ISR INVERSION';
  SET NombreProceso   := 'INVERSION';
  SET Var_RefPagoInv  := 'PAGO DE INVERSION PERIODICA';


    SET ISRpSocio   := 'ISR_pSocio';
    SET No_constante  := 'N';
    SET Var_TipoInstrumento  := 13;
    SET Est_Aplicado         :=  'A';
    SET EnteroUno   :=  1;
    SET ProcesoCierre :=  'C';
    SET Var_SI      :=  'S';

  ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
      SET Par_NumErr := 999;
      SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-INVERPAGCIEDIAPRE');
      SET Var_Control := 'sqlException' ;
    END;

    DELETE FROM PAGOINVERSION;

    SET @conta := 0;

        INSERT INTO `PAGOINVERSION` (
		`ConsecutivoID`,					`InversionID`,					`CuentaAhoID`,					`TipoInversionID`,					`MonedaID`,
		`Monto`,							`InteresGenerado`,				`InteresRetener`,				`ISRReal`,							`ClienteID`,
		`SaldoProvision`,					`SucursalOrigen`,				`FechaInicio`,					`FechaVencimiento`,					`EmpresaID`,
		`Usuario`,							`FechaActual`,					`DireccionIP`,					`ProgramaID`,						`Sucursal`,
		`NumTransaccion`)
        SELECT (@conta := @conta+1),      Inv.InversionID,      Inv.CuentaAhoID,    Inv.TipoInversionID,    Inv.MonedaID,     Inv.Monto,
         Inv.InteresGenerado, Inv.InteresRetener,   Inv.ISRReal,    Inv.ClienteID,      Inv.SaldoProvision,
         Cli.SucursalOrigen,  Inv.FechaInicio,    Inv.FechaVencimiento, Par_EmpresaID, Aud_Usuario,
         Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion
      FROM INVERSIONES Inv,
         CLIENTES Cli,
                 INVERSIONESDIAPAG Pag
      WHERE Inv.Estatus = Estatus_Vigente
        AND Inv.InversionID = Pag.InversionID
        AND Pag.FechaProximoPago = Par_Fecha
              AND Pag.FechaProximoPago < Inv.FechaVencimiento
        AND Inv.ClienteID = Cli.ClienteID;

        SELECT  COUNT(Inv.InversionID) INTO Var_NumeroVenc
    FROM INVERSIONES Inv,INVERSIONESDIAPAG Pag
    WHERE Inv.Estatus = Estatus_Vigente
        AND Inv.InversionID = Pag.InversionID
        AND Pag.FechaProximoPago = Par_Fecha
              AND Pag.FechaProximoPago < Inv.FechaVencimiento;

    SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);

        IF(Var_NumeroVenc > Entero_Cero) THEN
          CALL MAESTROPOLIZASALT(
                Par_Poliza,         Par_EmpresaID,      Par_Fecha,      Pol_Automatica,     Var_PagoInver,
                Var_RefPagoInv,   SalidaNO,         Par_NumErr,   Par_ErrMen,     Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion  );

            IF(Par_NumErr != Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;
      END IF;

        SELECT MonedaBaseID,FechaISR INTO Var_MonedaBase,Var_FechaISR
    FROM PARAMETROSSIS;

    SELECT ValorParametro INTO Var_ISR_pSocio
      FROM PARAMGENERALES
        WHERE LlaveParametro=ISRpSocio;

    SET Var_ISR_pSocio  := IFNULL(Var_ISR_pSocio , No_constante);
    SET Var_FechaISR  := IFNULL(Var_FechaISR,Par_Fecha);

    IF(Var_NumeroVenc != Entero_Cero) THEN
            SET @contador := Entero_Cero;
            WHILE( @contador < Var_NumeroVenc) DO

                SET @contador = @contador+1;

                SELECT  InversionID,      CuentaAhoID,    TipoInversionID,    MonedaID,   Monto,
                        InteresGenerado,    InteresRetener,   ISRReal,        ClienteID,    SaldoProvision,
                        SucursalOrigen,     FechaInicio,    FechaVencimiento
                INTO
                        Var_InversionID,        Var_CuentaAhoID,      Var_TipoInversionID,    Var_MonedaID,     Var_Monto,
                        Var_InteresGenerado,    Var_InteresRetener,   VAR_ISRReal,      Var_ClienteID,      Var_SaldoProvision,
                        Var_SucCliente,     Var_InverFecIni,    Var_InverFecFin
                FROM PAGOINVERSION
                WHERE ConsecutivoID = @contador;

                SELECT FechaUltimoPago  INTO Var_FechaUlPag
                FROM INVERSIONESDIAPAG WHERE InversionID = Var_InversionID;


                INSERT INTO CTESVENCIMIENTOS(
                        Fecha,        ClienteID,    EmpresaID,    UsuarioID,    FechaActual,
                        DireccionIP,    ProgramaID,   Sucursal,     NumTransaccion)
                SELECT  Par_Fecha,      Var_ClienteID,  Par_EmpresaID,  Aud_Usuario,  Aud_FechaActual,
                        Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion;


                CALL CALCULOISRPRO(
                    Par_Fecha,      Par_Fecha,      EnteroUno,    ProcesoCierre,    SalidaNO,
                    Par_NumErr,     Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,
                    Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal, Aud_NumTransaccion);

                DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

                IF(Par_NumErr != Entero_Cero) THEN
                    LEAVE ManejoErrores;
                END IF;

                IF (Var_ISR_pSocio=SI_Isr_Socio) THEN
                        SET Var_InteresRetener :=FNTOTALISRCTE(Var_ClienteID,Var_TipoInstrumento,Var_InversionID);
                END IF;

                IF (Var_InteresRetener = Entero_Cero) THEN
                    SET Var_MovIntere := Mov_PagIntExe;
                    SET Cue_PagIntere := Cue_PagIntExe;
                ELSE
                    SET Var_MovIntere := Mov_PagIntGra;
                    SET Cue_PagIntere := Cue_PagIntGra;
                END IF;

                IF (Var_SaldoProvision > Entero_Cero) THEN
                    CALL CONTAINVERSIONPRO(
                        Var_InversionID,    Par_EmpresaID,        Par_Fecha,          Var_SaldoProvision, Cadena_Vacia,
                        Var_PagoInver,      Var_ConInvProv,     Entero_Cero,        Nat_Cargo,          AltPoliza_NO,
                        Mov_AhorroNO,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,
                        Aud_NumTransaccion  );

                    CALL INVERSIONESMOVALT(
                        Var_InversionID,    Aud_NumTransaccion, Par_Fecha,        Tipo_Provision,   Var_SaldoProvision,
                        Nat_Abono,          Var_RefPagoInv,     Var_MonedaID,     Par_Poliza,     Par_EmpresaID,
                        Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
                        Aud_NumTransaccion  );

                    SET Var_Instrumento := CONVERT(Var_InversionID, CHAR);

                    CALL CUENTASAHOMOVSALT(
                        Var_CuentaAhoID,        Aud_NumTransaccion,   Par_Fecha,              Nat_Abono,        Var_SaldoProvision,
                        Cue_PagIntere,        Var_Instrumento,      Var_MovIntere,          SalidaNO,           Par_NumErr,
                        Par_ErrMen,             Par_EmpresaID,            Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                    IF(Par_NumErr > Entero_Cero)THEN
                        LEAVE ManejoErrores;
                    END IF;

                    SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

                    CALL POLIZASAHORROPRO(
                        Par_Poliza,         Par_EmpresaID,        Par_Fecha,              Var_ClienteID,          Con_Capital,
                        Var_CuentaAhoID,    Var_MonedaID,       Entero_Cero,            Var_SaldoProvision,     Cue_PagIntere,
                        Var_CuentaStr,    SalidaNO,       Par_NumErr,       Par_ErrMen,         Aud_Usuario,
                        Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,     Var_SucCliente,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE ManejoErrores;
                    END IF;

                    SET Var_Tasa  :=(SELECT Tasa FROM INVERSIONES WHERE InversionID = Var_InversionID);
                    SET Var_Tasa  :=IFNULL(Var_Tasa,Entero_Cero);


                    CALL CALCULOINTERESREALALT (
                        Var_ClienteID,      Par_Fecha,        Var_TipoInstrumento,  Var_InversionID,    Var_Monto,
                        Var_SaldoProvision,   Var_InteresRetener,   Var_Tasa,       Var_FechaUlPag,     Par_Fecha,
                        Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,     Aud_NumTransaccion);
          END IF;

                IF (Var_InteresRetener > Entero_Cero) THEN

                    CALL CUENTASAHOMOVSALT(
                        Var_CuentaAhoID,    Aud_NumTransaccion,     Par_Fecha,              Nat_Cargo,      Var_InteresRetener,
                        Cue_RetInver,       Var_Instrumento,        Mov_PagInvRet,          SalidaNO,           Par_NumErr,
                        Par_ErrMen,         Par_EmpresaID,            Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

                    IF(Par_NumErr > Entero_Cero)THEN
                        LEAVE ManejoErrores;
                    END IF;

                    CALL POLIZASAHORROPRO(
                        Par_Poliza,         Par_EmpresaID,        Par_Fecha,              Var_ClienteID,          Con_Capital,
                        Var_CuentaAhoID,    Var_MonedaID,       Var_InteresRetener,     Entero_Cero,            Cue_RetInver,
                        Var_CuentaStr,    SalidaNO,       Par_NumErr,       Par_ErrMen,         Aud_Usuario,
                        Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,     Var_SucCliente,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE ManejoErrores;
                    END IF;

                    IF (Var_MonedaBase != Var_MonedaID) THEN

                        SELECT TipCamComInt INTO Var_TipCamCom
                            FROM MONEDAS
                                WHERE MonedaId = Var_MonedaID;

                        SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, Entero_Dos);

                        CALL COMVENDIVISAALT(
                            Var_MonedaID,   Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,     Var_TipCamCom,
                            Ope_Interna,    Tip_Compra,           Var_Instrumento,  Var_RefPagoInv,       NombreProceso,
                            Par_Poliza,     Par_EmpresaID,      Aud_Usuario,      Aud_FechaActual,          Aud_DireccionIP,
                            Aud_ProgramaID, Var_SucCliente,     Aud_NumTransaccion   );

                    ELSE
                        SET Var_IntRetMN := Var_InteresRetener;
                    END IF;

                    CALL CONTAINVERSIONPRO(
                        Var_InversionID,    Par_EmpresaID,        Par_Fecha,          Var_IntRetMN,       Cadena_Vacia,
                        Var_PagoInver,      Var_ConInvISR,      Entero_Cero,        Nat_Abono,          AltPoliza_NO,
                        Mov_AhorroNO,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaBase,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,
                        Aud_NumTransaccion  );
                END IF;


                UPDATE INVERSIONES SET
          InteresRecibir  = (InteresGenerado - Var_SaldoProvision ) - (InteresRetener - Var_InteresRetener),
                    SaldoProvision  = SaldoProvision - Var_SaldoProvision,
          InteresGenerado = InteresGenerado - Var_SaldoProvision,
          InteresRetener  = CASE WHEN InteresRetener > Var_InteresRetener THEN
                    InteresRetener - Var_InteresRetener
                    ELSE Entero_Cero END,
          EmpresaID     = Par_EmpresaID,
          Usuario     = Aud_Usuario,
          FechaActual   = Aud_FechaActual,
          DireccionIP   = Aud_DireccionIP,
          ProgramaID    = Aud_ProgramaID,
          Sucursal    = Aud_Sucursal,
          NumTransaccion  = Aud_NumTransaccion
        WHERE InversionID   = Var_InversionID;

                INSERT INTO HISAMORTIZAPAGINVER
                    (InversionID, FechaPago, MontoPago, EmpresaID, Usuario,
                    FechaActual, DireccionIP, ProgramaID, Sucursal, NumTransaccion)
                VALUES
                    (Var_InversionID, Par_Fecha,Var_SaldoProvision, Par_EmpresaID, Aud_Usuario,
                    now(), Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal,Aud_NumTransaccion);

                UPDATE COBROISR isr
                    SET Estatus = Est_Aplicado
                        WHERE ClienteID   = Var_ClienteID
                        AND ProductoID    = Var_InversionID
                        AND InstrumentoID   = Var_TipoInstrumento;

                SET Var_Periodicidad := (SELECT PeriodicidadPago
                                            FROM INVERSIONESDIAPAG
                                            WHERE InversionID = Var_InversionID);

                SET Var_ProxPago := date_add(Par_Fecha,interval Var_Periodicidad day);
                SET Var_ProxPago := (FUNCIONDIAHABILINV(Var_ProxPago, 0, EnteroUno));

                UPDATE INVERSIONESDIAPAG SET
          FechaUltimoPago = Par_Fecha,
                    FechaProximoPago = Var_ProxPago
                WHERE InversionID = Var_InversionID;

            END WHILE;
        END IF;



    SET Par_NumErr  := 00;
    SET Par_ErrMen  :='Informacion Generada Exitosamente.';
  END ManejoErrores;

  IF(Par_Salida=Var_SI)THEN
    SELECT  Par_NumErr AS NumErr,
    Par_ErrMen AS ErrMen,
    Par_Fecha AS Consecutivo,
    Var_Control AS Control;
  END IF;

END TerminaStore$$
