-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSIONMASIVACUR
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSIONMASIVACUR`;
DELIMITER $$


CREATE PROCEDURE `INVERSIONMASIVACUR`(
-- ------------------------------------------------------------------
--        PROCESO PARA REINVERSIONES AUTOMATICAS         --
-- ------------------------------------------------------------------
    Par_Fecha           DATE,   -- Fecha del proceso
    Par_Empresa         INT(11),  -- Numero de empresa

    -- parametros de auditoria
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

    -- declaracion de variables
    DECLARE Decimal_Cero              DECIMAL(12,2);        -- DECIMAL cero
    DECLARE Par_InversionOriginal     BIGINT(20);           -- Inversion original
    DECLARE Par_CuentaAhoID           BIGINT(20);           -- Numero de cuenta de ahorro
    DECLARE Par_ClienteID             BIGINT(20);           -- Numero de cliente
    DECLARE Par_MonedaID              INT(11);              -- Tipo de moneda de la inversion

    DECLARE Par_TipoInversionID       INT(11);              -- Tipo de inversion
    DECLARE Par_FechaInicio           DATE;                 -- Fecha de inicio
    DECLARE Par_MontoOriginal         DECIMAL(12,2);        -- Monto original
    DECLARE Par_PlazoOrigina          INT(11);              -- Plazo
    DECLARE Par_TasaOriginal          DECIMAL(8,4);         -- Tasa original

    DECLARE Par_TasaISROriginal       DECIMAL(8,4);         -- Tasa isr original
    DECLARE Par_TasaNetaOriginal      DECIMAL(8,4);         -- Tasa neta original
    DECLARE Par_InteresGeneradoOriginal DECIMAL(12,2);      -- Interes generado original
    DECLARE Par_InteresRecibirOriginal  DECIMAL(12,2);      -- Interes recibir original
    DECLARE Par_InteresRetenerOriginal  DECIMAL(12,2);      -- Interes retener oroginal

    DECLARE Par_NuevoPlazo            INT(11);              -- Nuevo plazo
    DECLARE Par_FechaVencimiento      DATE;                 -- Fecha de vencimiento
    DECLARE Par_MontoReinvertir       DECIMAL(12,2);        -- MOnto a reinvertir
    DECLARE Par_NuevaTasa             DECIMAL(8,4);         -- Nueva tasa
    DECLARE Par_NuevaTasaISR          DECIMAL(8,4);         -- Nueva tasa isr

    DECLARE Par_NuevaTasaNeta         DECIMAL(8,4);         -- Nueva tasa neta
    DECLARE Par_NuevoInteresGenerado  DECIMAL(12,2);        -- Nuevo interes geenrado
    DECLARE Par_NuevoInteresRetener   DECIMAL(12,2);        -- Nuevo interes retener
    DECLARE Par_NuevoInteresRecibir   DECIMAL(12,2);        -- Nuevo interes recibir
    DECLARE Par_Reinvertir            VARCHAR(5);           -- Parametro reinvertir

    DECLARE Par_Provision             DECIMAL(12,2);        -- Parametro provision
    DECLARE Par_Etiqueta              VARCHAR(100);         -- Parametro Etiqueta
    DECLARE Var_ValorGat              DECIMAL(12,2);        -- Valor gat
    DECLARE Var_Beneficiario          CHAR(1);              -- Beneficiario
    DECLARE Var_ValorGatReal          DECIMAL(12,2);        -- Valor REAL gat

    DECLARE Var_SucInvOriginal        INT(11);              -- Sucursal inversion original
    DECLARE Var_SucCliente            INT(11);              -- Sucursal cliente
    DECLARE Par_ConsecutivoTabla      INT(11);              -- Consecutivo tabla
    DECLARE Par_FechaPosibleVencimiento DATE;               -- Fecha posible de vencimiento
    DECLARE Par_SaldoProvision        DECIMAL(12,2);        -- Saldo provision

    DECLARE Var_MovIntere             VARCHAR(4);           -- Movimiento contable
    DECLARE Var_CuentaStr             VARCHAR(15);          -- Cuenta de la inversion
    DECLARE Var_Instrumento           VARCHAR(15);          -- Id de la inversion
    DECLARE Var_MonedaBase            INT(11);              -- Moneda de la inversion a calcular
    DECLARE Var_IntRetMN              DECIMAL(12,2);        -- Interes en moneda nacional

    DECLARE Var_TipCamCom             DECIMAL(14,6);        -- Tipo de moneda de la inversion
    DECLARE Cue_PagIntere             CHAR(50);             -- Si se paga interes
    DECLARE Var_InversionID           INT(11);              -- Id de la version
    DECLARE Par_Poliza                BIGINT(20);           -- Poliza
    DECLARE Error_Key                 INT DEFAULT 0;        -- Error KEY

    DECLARE Var_InverStr              VARCHAR(15);
    DECLARE Var_ContadorInv           INT(11);
    DECLARE Var_InverFecIni           DATE;                 -- Fecha inicio Inversion
    DECLARE Var_InverFecFin           DATE;                 -- Fecha vencimiento Inversion
    DECLARE Var_InvPagoPeriodico      CHAR(1);              -- variable que indica si las Inversiones seran de Pago Periodico
    DECLARE Var_SucursalOrigen        INT(11);              -- Sucursal de Origen
    DECLARE Var_Estatus               CHAR(2);              -- Almacena el estatus del tipo de inversion


    -- Declaracion de constantes
    DECLARE Entero_Cero           INT(11);
    DECLARE Fecha_Vacia           DATE;
    DECLARE Cadena_Vacia          CHAR(1);
    DECLARE Ren_AltaReinver       INT(11);
    DECLARE Var_MovPagInv         VARCHAR(4);

    DECLARE Var_MovIntExe         VARCHAR(4);
    DECLARE Var_MovIntGra         VARCHAR(4);
    DECLARE Var_MovRetenc         VARCHAR(4);
    DECLARE Var_Reinversion       VARCHAR(4);
    DECLARE Var_ConConReinv       INT(11);

    DECLARE Var_ConAhoCapi        INT(11);
    DECLARE Var_ConInvCapi        INT(11);
    DECLARE Var_ConInvISR         INT(11);
    DECLARE Var_ConInvProv        INT(11);
    DECLARE Mov_AhorroSI          CHAR(1);

    DECLARE Mov_AhorroNO          CHAR(1);
    DECLARE Nat_Cargo             CHAR(1);
    DECLARE Nat_Abono             CHAR(1);
    DECLARE AltPoliza_NO          CHAR(1);
    DECLARE Pol_Automatica        CHAR(1);

    DECLARE Con_RenoMas           INT(11);
    DECLARE Par_NumErr            INT(11);
    DECLARE Tipo_Provision        CHAR(4);
    DECLARE Par_SalidaNO          CHAR(1);
    DECLARE StaAlta               CHAR(1);

    DECLARE StaInvVigente         CHAR(1);
    DECLARE StaInvPagada          CHAR(1);
    DECLARE Var_NoImpresa         CHAR(1);
    DECLARE Ope_Interna           CHAR(1);
    DECLARE Tip_Venta             CHAR(1);

    DECLARE Tip_Compra            CHAR(1);
    DECLARE Cue_PagIntExe         CHAR(50);
    DECLARE Cue_PagIntGra         CHAR(50);
    DECLARE Cue_RetInver          CHAR(50);
    DECLARE Var_Referencia        VARCHAR(100);

    DECLARE Var_DescriReinv       VARCHAR(50);
    DECLARE Act_LiberarReinAut    INT(11);
    DECLARE Par_ErrMen            VARCHAR(400);
    DECLARE Act_AsignarReinAut    INT(11);
    DECLARE Var_GatInfo           DECIMAL(12,2);

    DECLARE Var_Reinvierte        CHAR(5);
    DECLARE Re_Capital            CHAR(5);
    DECLARE Re_CapitalInt         CHAR(5);
    DECLARE Re_Ninguno            CHAR(5);
    DECLARE InstInversion         INT(11);

    DECLARE Est_Aplicado          CHAR(1);
    DECLARE Var_No                CHAR(1);    -- constante NO
    DECLARE Var_Si                CHAR(1);    -- constante SI
    DECLARE Entero_Uno            INT(11);    -- constante UNO
    DECLARE Estatus_Activo        CHAR(1);    -- Estatus Activo

    DECLARE  REINVERCUR  CURSOR FOR

    SELECT  Inv.InversionID,        Inv.CuentaAhoID,            Inv.TipoInversionID,      Inv.MonedaID,               Inv.FechaInicio,
            Inv.Monto,              Inv.Plazo,                  Inv.Tasa,                 Inv.TasaISR,                Inv.TasaNeta,
            Inv.InteresGenerado,    Inv.InteresRecibir,         Inv.InteresRetener,       Inv.ConsecutivoTabla,       Inv.FechaPosibleVencimiento,
            Inv.NuevoPlazo,         Inv.FechaVencimiento,       Inv.MontoReinvertir,      Inv.NuevaTasa,              Inv.NuevaTasaISR,
            Inv.NuevaTasaNeta,      Inv.NuevoInteresGenerado,   Inv.NuevoInteresRetener,  Inv.NuevoInteresRecibir,    Inv.Reinvertir,
            Inv.ClienteID,          Inv.SaldoProvision,         Inv.Etiqueta,             Inv.ValorGat,               Inv.Beneficiario,
            Inv.ValorGatReal,       Cli.SucursalOrigen,         Inv.Reinvertir
    FROM  TEMINVERSIONES Inv,
      CLIENTES Cli
    WHERE Inv.ClienteID = Cli.ClienteID;


    -- asignacion de constantes
    SET Entero_Cero       := 0;           -- entero cero
    SET Decimal_Cero      := 0.00;        -- DECIMAL cero
    SET Cadena_Vacia      := '';          -- cadena vacia
    SET Fecha_Vacia       := '1900-01-01';    -- fecha vacia
    SET Ren_AltaReinver   := 104;         -- alta reinversion

    SET Var_MovPagInv     := '61';        -- Pago invrsion. capital correspondiente a TIPOSMOVSAHO
    SET Var_MovIntGra     := '62';        -- Pago invrsion. interes gravado correspondiente a TIPOSMOVSAHO
    SET Var_MovIntExe     := '63';        -- Pago invrsion. interes excento correspondiente a TIPOSMOVSAHO
    SET Var_MovRetenc     := '64';        -- Retencion ISR Inversion correspondiente a TIPOSMOVSAHO
    SET Var_Reinversion   := '66';        -- Reinversion Automatica correspondiente a TIPOSMOVSAHO

    SET Var_ConConReinv   := 11;          -- concepto contable de Reinversion corresponde a la tabla CONCEPTOSCONTA
    SET Var_ConAhoCapi    := 1;           -- Consepto de Ahorro corresponde con la tabla TIPOSMOVSAHO
    SET Var_ConInvCapi    := 1;           -- capital corresponde a la tabla CONCEPTOSINVER
    SET Var_ConInvISR     := 4;           -- ISR corresponde a la tabla CONCEPTOSINVER
    SET Var_ConInvProv    := 5;           -- DEVENGAMIENTO INTERES  corresponde a la tabla CONCEPTOSINVER

    SET Mov_AhorroSI      := 'S';         -- Si insertar movimientos de Ahorro
    SET Mov_AhorroNO      := 'N';         -- No insertar Movimiento de Ahorro
    SET Nat_Cargo         := 'C';         -- naturaleza cargo
    SET Nat_Abono         := 'A';         -- naturaleza abono
    SET AltPoliza_NO      := 'N';         -- Alta en poliza NO

    SET Pol_Automatica    := 'A';         -- Tipo de Poliza Automatica
    SET Con_RenoMas       := 14;          -- Reno mas
    SET Tipo_Provision    := '100';       -- Tipo provision
    SET Par_SalidaNO      := 'N';         -- Salida en Pantalla NO
    SET StaAlta           := 'A';         -- Estatus activa

    SET StaInvVigente     := 'N';         -- estatus vigente
    SET StaInvPagada      := 'P';         -- estatus pagada
    SET Var_NoImpresa     := 'N';         -- No impresa
    SET Ope_Interna       := 'I';         -- operacion interna
    SET Tip_Venta         := 'V';         -- Tipo venta

    SET Tip_Compra        := 'C';         -- tipo compra
    SET Cue_PagIntExe     := 'PAGO INVERSION. INTERES EXENTO'; -- PAGO INVERSION. INTERES EXENTO
    SET Cue_PagIntGra     := 'PAGO INVERSION. INTERES GRAVADO'; -- PAGO INVERSION. INTERES GRAVADO
    SET Cue_RetInver      := 'RETENCION ISR INVERSION';       -- RETENCION ISR INVERSION
    SET Var_Referencia    := 'RENOVACION AUTOMATICA';       -- RETENCION ISR INVERSION

    SET Var_DescriReinv   := 'CIERRE INVERSIONES';        -- CIERRE INVERSIONES';
    SET Act_LiberarReinAut  := 5;         -- Actualizacion para liberar automaticamente la inversion
    SET Par_NumErr          := 0;         -- numero de error
    SET Act_AsignarReinAut  := 6;         -- Asignar reinversion automatica
    SET Aud_FechaActual     := NOW();          -- fecha actual

    SET Re_Capital        := 'C';         -- Reinvierte Capital
    SET Re_CapitalInt     := 'CI';        -- Reinvierte Capital + Interes
    SET Re_Ninguno        := 'N';         -- No reinvierte
    SET Var_Reinvierte    := '';          -- Variable reinvierte
    SET InstInversion     :=  13;         -- Numero de Instrumento de Inversiones

    SET Est_Aplicado      :=  'A';        -- Estatus Aplicado
    SET Var_No            :=  'N';        -- NO
    SET Var_Si            :=  'S';        -- SI
    SET Entero_Uno        :=  1;          -- Constante Uno
    SET Estatus_Activo    := 'A';         -- Estatus Activo

    SELECT MonedaBaseID INTO Var_MonedaBase
    FROM PARAMETROSSIS;

    SELECT COUNT(InversionID) INTO Var_ContadorInv
    FROM TEMINVERSIONES;

    SET Var_ContadorInv := IFNULL(Var_ContadorInv, Entero_Cero);

    IF (Var_ContadorInv > Entero_Cero) THEN
      CALL MAESTROPOLIZAALT(
        Par_Poliza,     Par_Empresa,    Par_Fecha,    Pol_Automatica,   Con_RenoMas,
        Var_Referencia, Par_SalidaNO,   Aud_Usuario,  Aud_FechaActual,  Aud_DireccionIP,
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);


      CALL CREDITOINVGARACT(
        Entero_Cero,      Entero_Cero,      Entero_Cero,    Par_Poliza,     Act_LiberarReinAut,
        Par_SalidaNO,     Par_NumErr,       Par_ErrMen,     Par_Empresa,    Aud_Usuario,
        Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
    END IF;

    OPEN  REINVERCUR;

    BEGIN
      DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
      LOOP
      FETCH REINVERCUR INTO
        Par_InversionOriginal,        Par_CuentaAhoID,            Par_TipoInversionID,        Par_MonedaID,             Par_FechaInicio,
        Par_MontoOriginal,            Par_PlazoOrigina,           Par_TasaOriginal,           Par_TasaISROriginal,      Par_TasaNetaOriginal,
        Par_InteresGeneradoOriginal,  Par_InteresRecibirOriginal, Par_InteresRetenerOriginal, Par_ConsecutivoTabla,     Par_FechaPosibleVencimiento,
        Par_NuevoPlazo,               Par_FechaVencimiento,       Par_MontoReinvertir,        Par_NuevaTasa,            Par_NuevaTasaISR,
        Par_NuevaTasaNeta,            Par_NuevoInteresGenerado,   Par_NuevoInteresRetener,    Par_NuevoInteresRecibir,  Par_Reinvertir,
        Par_ClienteID,                Par_Provision,              Par_Etiqueta,               Var_ValorGat,             Var_Beneficiario,
        Var_ValorGatReal,             Var_SucCliente,             Var_Reinvierte;

		START TRANSACTION;
		BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

		SET Var_InversionID := Entero_Cero;

		SET Par_NuevoInteresRecibir     := IFNULL(Par_NuevoInteresRecibir, Entero_Cero);
		SET Par_NuevoInteresGenerado    := IFNULL(Par_NuevoInteresGenerado, Entero_Cero);
		SET Par_NuevoInteresRetener     := IFNULL(Par_NuevoInteresRetener, Entero_Cero);

		SET Par_InteresRecibirOriginal  := IFNULL(Par_InteresRecibirOriginal, Entero_Cero);
		SET Par_InteresGeneradoOriginal := IFNULL(Par_InteresGeneradoOriginal, Entero_Cero);
		SET Par_InteresRetenerOriginal  := IFNULL(Par_InteresRetenerOriginal, Entero_Cero);


		CALL CONTAINVERSIONPRO(
			Par_InversionOriginal,  Par_Empresa,      Par_Fecha,        Par_MontoOriginal,  Var_MovPagInv,
			Var_ConConReinv,        Var_ConInvCapi,   Var_ConAhoCapi,   Nat_Abono,          AltPoliza_NO,
			Mov_AhorroSI,           Par_Poliza,       Par_CuentaAhoID,  Par_ClienteID,      Par_MonedaID,
			Aud_Usuario,            Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,     Var_SucCliente,
			Aud_NumTransaccion);


		IF (Par_InteresRetenerOriginal = Entero_Cero) THEN
			SET Var_MovIntere   := Var_MovIntExe;
			SET Cue_PagIntere   := Cue_PagIntExe;
		ELSE
			SET Var_MovIntere   := Var_MovIntGra;
			SET Cue_PagIntere   := Cue_PagIntGra;
		END IF;

		IF (Par_Provision > Entero_Cero) THEN

		CALL CONTAINVERSIONPRO(
			Par_InversionOriginal,  Par_Empresa,      Par_Fecha,        Par_Provision,    Cadena_Vacia,
			Var_ConConReinv,        Var_ConInvProv,   Entero_Cero,      Nat_Cargo,        AltPoliza_NO,
			Mov_AhorroNO,           Par_Poliza,       Par_CuentaAhoID,  Par_ClienteID,    Par_MonedaID,
			Aud_Usuario,            Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Var_SucCliente,
			Aud_NumTransaccion);


		CALL INVERSIONESMOVALT(
			Par_InversionOriginal,  Aud_NumTransaccion, Par_Fecha,        Tipo_Provision,
			Par_Provision,          Nat_Abono,          Var_Referencia,   Par_MonedaID,   Par_Poliza,
			Par_Empresa,            Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,
			Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);

		END IF;

		SET Var_Instrumento = CONVERT(Par_InversionOriginal, CHAR);


		IF(Par_InteresGeneradoOriginal > Entero_Cero) THEN


		CALL CUENTASAHOMOVALT(
			Par_CuentaAhoID,        Aud_NumTransaccion,   Par_Fecha,        Nat_Abono,    Par_InteresGeneradoOriginal,
			Cue_PagIntere,          Var_Instrumento,      Var_MovIntere,    Par_Empresa,  Aud_Usuario,
			Aud_FechaActual,        Aud_DireccionIP,      Aud_ProgramaID,   Aud_Sucursal, Aud_NumTransaccion);

		SET Var_CuentaStr = CONVERT(Par_CuentaAhoID, CHAR);


		CALL POLIZAAHORROPRO(
			Par_Poliza,             Par_Empresa,    Par_Fecha,        Par_ClienteID,                Var_ConAhoCapi,
			Par_CuentaAhoID,        Par_MonedaID,   Entero_Cero,      Par_InteresGeneradoOriginal,  Cue_PagIntere,
			Var_CuentaStr,          Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,              Aud_ProgramaID,
		  Var_SucCliente,         Aud_NumTransaccion);

		-- Se obtiene la fecha de inicio y vencimiento de la inversion
		SET Var_InverFecIni := (SELECT FechaInicio FROM INVERSIONES WHERE InversionID = Par_InversionOriginal);
		SET Var_InverFecFin := (SELECT FechaVencimiento FROM INVERSIONES WHERE InversionID = Par_InversionOriginal);

		-- Registro de informacion para el Calculo del Interes Real para Inversiones
		CALL CALCULOINTERESREALALT (
			Par_ClienteID,                Par_Fecha,                  InstInversion,      Par_InversionOriginal,  Par_MontoOriginal,
			Par_InteresGeneradoOriginal,  Par_InteresRetenerOriginal, Par_TasaOriginal,   Var_InverFecIni,        Var_InverFecFin,
			Par_Empresa,                  Aud_Usuario,                Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
			Aud_Sucursal,                 Aud_NumTransaccion);

		END IF;


		IF (Par_InteresRetenerOriginal > Entero_Cero) THEN

			CALL CUENTASAHOMOVALT(
				Par_CuentaAhoID,  Aud_NumTransaccion,   Par_Fecha,            Nat_Cargo,      Par_InteresRetenerOriginal,
				Cue_RetInver,     Var_Instrumento,      Var_MovRetenc,        Par_Empresa,    Aud_Usuario,
				Aud_FechaActual,  Aud_DireccionIP,      Aud_ProgramaID,       Aud_Sucursal,   Aud_NumTransaccion);

			CALL POLIZAAHORROPRO(
				Par_Poliza,       Par_Empresa,          Par_Fecha,                  Par_ClienteID,      Var_ConAhoCapi,
				Par_CuentaAhoID,  Par_MonedaID,         Par_InteresRetenerOriginal, Entero_Cero,        Cue_RetInver,
				Var_CuentaStr,    Aud_Usuario,          Aud_FechaActual,            Aud_DireccionIP,    Aud_ProgramaID,
				Var_SucCliente,   Aud_NumTransaccion);


			IF (Var_MonedaBase != Par_MonedaID) THEN

				SELECT  TipCamComInt INTO Var_TipCamCom
				FROM MONEDAS
				WHERE MonedaId = Par_MonedaID;

				SET Var_IntRetMN = ROUND(Par_InteresRetenerOriginal * Var_TipCamCom, 2);


				CALL COMVENDIVISAALT(
				Par_MonedaID,     Aud_NumTransaccion, Par_Fecha,          Par_InteresRetenerOriginal,   Var_TipCamCom,
				Ope_Interna,      Tip_Compra,         Var_Instrumento,    Var_Referencia,               Var_DescriReinv,
				Par_Poliza,       Par_Empresa,        Aud_Usuario,        Aud_FechaActual,              Aud_DireccionIP,
				Aud_ProgramaID,   Var_SucCliente,     Aud_NumTransaccion);

			ELSE
				SET Var_IntRetMN = Par_InteresRetenerOriginal;
			END IF;

			CALL CONTAINVERSIONPRO(
				Par_InversionOriginal,  Par_Empresa,      Par_Fecha,        Var_IntRetMN,     Cadena_Vacia,
				Var_ConConReinv,        Var_ConInvISR,    Entero_Cero,      Nat_Abono,        AltPoliza_NO,
				Mov_AhorroNO,           Par_Poliza,       Par_CuentaAhoID,  Par_ClienteID,    Var_MonedaBase,
				Aud_Usuario,            Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Var_SucCliente,
				Aud_NumTransaccion);
		END IF;

		UPDATE INVERSIONES SET
			Estatus     = StaInvPagada,
			EmpresaID   = Par_Empresa,
			Usuario     = Aud_Usuario,
			FechaActual   = Aud_FechaActual,
			DireccionIP   = Aud_DireccionIP,
			ProgramaID    = Aud_ProgramaID,
			Sucursal    = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		WHERE InversionID = Par_InversionOriginal;

		UPDATE COBROISR isr
		SET Estatus = Est_Aplicado
		  WHERE ClienteID       = Par_ClienteID
			AND ProductoID    = Par_InversionOriginal
			AND InstrumentoID = InstInversion;

		SET Var_InversionID := (SELECT IFNULL(MAX(InversionID), Entero_Cero) + 1
		FROM INVERSIONES);

		SET Var_GatInfo := (SELECT IFNULL(TAS.GatInformativo, Entero_Cero) FROM TASASINVERSION TAS
		INNER JOIN DIASINVERSION  DIA ON DIA.TipoInversionID = TAS.TipoInversionID AND TAS.DiaInversionID =DIA.DiaInversionID
		INNER JOIN MONTOINVERSION MON ON  MON.TipoInversionID =TAS.TipoInversionID AND TAS.MontoInversionID = MON.MontoInversionID
		WHERE TAS.TipoInversionID = Par_TipoInversionID
		AND (Par_NuevoPlazo >= DIA.PlazoInferior AND Par_NuevoPlazo <= DIA.PlazoSuperior)
		AND (Par_MontoReinvertir >= MON.PlazoInferior AND Par_MontoReinvertir <= MON.PlazoSuperior)
		LIMIT 1);

		IF(Var_Reinvierte = Re_Capital ) THEN
			SET Par_MontoReinvertir := Par_MontoOriginal;
		END IF;

		-- Se consulta la SucursalOrigen en la tabla INVERSIONES
		SET Var_SucursalOrigen := (SELECT SucursalOrigen FROM INVERSIONES WHERE InversionID = Par_InversionOriginal);
		SET Var_SucursalOrigen := IFNULL(Var_SucursalOrigen, Entero_Cero);

		-- SE OBTIENE EL ESTATUS DEL TIPO DE INVERSION A REINVERTIR
		SET Var_Estatus :=(SELECT Estatus FROM CATINVERSION WHERE TipoInversionID = Par_TipoInversionID);
		SET Var_Estatus := IFNULL(Var_Estatus, Cadena_Vacia);

		-- SI EL ESTATUS DEL TIPO DE INVERSION SE ENCUENTRA ACTIVO, SE REALIZA LA REINVERSION
		IF(Var_Estatus = Estatus_Activo)THEN
			INSERT INTO INVERSIONES VALUES(
				Var_InversionID,        Par_CuentaAhoID,          Par_ClienteID,            Par_TipoInversionID,      Par_Fecha,
				Par_FechaVencimiento,   Par_MontoReinvertir,      Par_NuevoPlazo,           Par_NuevaTasa,            Par_NuevaTasaISR,
				Par_NuevaTasaNeta,      Par_NuevoInteresGenerado, Par_NuevoInteresRecibir,  Par_NuevoInteresRetener,  StaInvVigente,
				Aud_Usuario,            Par_Reinvertir,           Var_NoImpresa,            Par_InversionOriginal,    Par_MonedaID,
				Par_Etiqueta,           Entero_Cero,              Var_ValorGat,             Var_Beneficiario,         Var_ValorGatReal,
				Decimal_Cero,           Fecha_Vacia,              Var_GatInfo,              Par_PlazoOrigina,         Var_SucursalOrigen,
				Par_Empresa,            Aud_Usuario,              Aud_FechaActual,          Aud_DireccionIP,          Aud_ProgramaID,
				Aud_Sucursal,           Aud_NumTransaccion);

			SET Var_InvPagoPeriodico:= (SELECT InvPagoPeriodico FROM PARAMETROSSIS WHERE EmpresaID = Entero_Uno);
			SET Var_InvPagoPeriodico := IFNULL(Var_InvPagoPeriodico, Var_No);

			IF (Var_InvPagoPeriodico = Var_Si) THEN
			  CALL INVPERIODICAALT (
				Var_InversionID,        Par_SalidaNO,           Par_NumErr,             Par_ErrMen,         Par_Empresa,
				Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion);
			END IF;

			CALL CONTAINVERSIONPRO(
				Var_InversionID,  Par_Empresa,      Par_Fecha,        Par_MontoReinvertir,  Var_Reinversion,
				Var_ConConReinv,  Var_ConInvCapi,   Var_ConAhoCapi,   Nat_Cargo,            AltPoliza_NO,
				Mov_AhorroSI,     Par_Poliza,       Par_CuentaAhoID,  Par_ClienteID,        Par_MonedaID,
				Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,       Var_SucCliente,
				Aud_NumTransaccion );

			UPDATE TEMINVERSIONES SET
			NuevaInversionID = Var_InversionID
			WHERE InversionID = Par_InversionOriginal;
		END IF;
	END;

    SET Var_InverStr = CONVERT(Par_InversionOriginal, CHAR);
    IF Error_Key = 0 THEN
      COMMIT;
    END IF;
    IF Error_Key = 1 THEN
      ROLLBACK;
      START TRANSACTION;
		CALL EXCEPCIONBATCHALT(
			Ren_AltaReinver,  Par_Fecha,      Var_InverStr,         'ERROR DE SQL GENERAL',
			Par_Empresa,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,
			Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
      COMMIT;
    END IF;
    IF Error_Key = 2 THEN
      ROLLBACK;
      START TRANSACTION;
		CALL EXCEPCIONBATCHALT(
			Ren_AltaReinver,  Par_Fecha,      Var_InverStr,         'ERROR EN ALTA, LLAVE DUPLICADA',
			Par_Empresa,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,
			Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
      COMMIT;
    END IF;
    IF Error_Key = 3 THEN
      ROLLBACK;
      START TRANSACTION;
		CALL EXCEPCIONBATCHALT(
			Ren_AltaReinver,  Par_Fecha,      Var_InverStr,         'ERROR AL LLAMAR A STORE PROCEDURE',
			Par_Empresa,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,
			Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
      COMMIT;
    END IF;
    IF Error_Key = 4 THEN
      ROLLBACK;
      START TRANSACTION;
		CALL EXCEPCIONBATCHALT(
			Ren_AltaReinver,  Par_Fecha,      Var_InverStr,         'ERROR VALORES NULOS',
			Par_Empresa,      Aud_Usuario,    Aud_FechaActual,      Aud_DireccionIP,
			Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);
      COMMIT;
    END IF;

    END LOOP;
  END;
  CLOSE REINVERCUR;


  IF (Var_ContadorInv > Entero_Cero) THEN

	CALL CREDITOINVGARACT(
		Entero_Cero,        Entero_Cero,      Entero_Cero,      Par_Poliza,     Act_AsignarReinAut,
		Par_SalidaNO,       Par_NumErr,       Par_ErrMen,       Par_Empresa,    Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion);

  END IF;

END TerminaStore$$