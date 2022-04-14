-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERPAGOCIERRE024
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERPAGOCIERRE024`;
DELIMITER $$


CREATE PROCEDURE `INVERPAGOCIERRE024`(
-- --------------------------------------------------------------------------------------
/* sp ejecutado al final del dia para realizar los movimientos contable y financieros */
-- --------------------------------------------------------------------------------------
	Par_Fecha			DATE,		-- fecha del proceso
	Par_Empresa			INT(11),    -- empresa del proceso

	/*parametros de Auditoria*/
	Aud_Usuario		INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
				)

TerminaStore: BEGIN

	/* Declaracion de Variable */
	DECLARE Var_InverStr        VARCHAR(20); 	-- variable para la inversion
	DECLARE Var_InversionID     BIGINT(20);		-- variable para la nueva inversion
	DECLARE Var_CuentaAhoID     BIGINT(20);		-- variable de la cuenta de la inversion
	DECLARE Var_TipoInversionID INT(11);		-- variabale para el tipo de inversion
	DECLARE Var_MonedaID        INT(11);		-- variable para la moneda que maneja la inverison
	DECLARE Var_Monto           DECIMAL(14,2);	-- variable para el monto de la inversion

	DECLARE Var_InteresGenerado DECIMAL(14,2);	-- variable de los interesesq que genera la inversion
	DECLARE Var_InteresRetener  DECIMAL(14,2);  -- variable para los intereses que retiene la inversion
	DECLARE Var_ClienteID       BIGINT(20);		-- variable del cliente
	DECLARE Var_SaldoProvision  DECIMAL(14,2);	-- variable del saldo de invesion
	DECLARE VAR_ISRReal		DECIMAL(12,2);	-- variable que guardara el valor de isrreal de cada socio

    DECLARE Var_ISR_pSocio		CHAR(1);		-- variable que guaradra el valor de parametrosgenerales si se calcula ISR por socio
	DECLARE Var_SucCliente      INT(11);		-- variable para la sucursal del cliente
	DECLARE Error_Key      		INT DEFAULT 0;	-- variable para manejo de errores
	DECLARE Var_NumeroVenc 		INT(11);		-- variable de NumeroVenc
	DECLARE Var_MovIntere  		VARCHAR(4);		-- variable del movimiento interes
	DECLARE Cue_PagIntere   	CHAR(50);		-- concepto de cuenta
	DECLARE Par_Poliza     		BIGINT(20);		-- numero de poliza
	DECLARE Var_Instrumento 	VARCHAR(15);	-- numero de la inversion
	DECLARE Var_CuentaStr   	VARCHAR(15);	-- numero de la cuenta id
	DECLARE Var_MonedaBase  	INT(11);		-- moneda base de la inersion
	DECLARE Var_TipCamCom   	DECIMAL(14,6);	-- variable del tipo de cambio
	DECLARE Var_IntRetMN    	DECIMAL(12,2);	-- variable del interes a retener
	DECLARE Var_InverFecIni  	DATE;			-- variable del interes a retener
    DECLARE Var_InverFecFin  	DATE;			-- Fecha vencimiento Inversion
    DECLARE Var_Tasa			DECIMAL(12,2);	-- Valor de la Tasa de la Inversion

	/*VARIABLES PARA CURSOR BLOQINVGARCUR*/
	DECLARE Var_CredInvGarant 	BIGINT(12);		--  credito como garantia de inversion
	DECLARE Var_CredID			BIGINT(12);		-- id del credito de garantia
	DECLARE Var_MontoEnGar		DECIMAL(12,2);	-- monto del credito
	DECLARE Var_CreInvGarStr	VARCHAR(20);	-- numero del credito
	DECLARE Var_MontoGar		DECIMAL(12,2);	-- monto del credito
	-- Constante
	DECLARE Ren_BloqInverGar	INT(11);		-- Ren_BloqInverGar
	DECLARE NatMovimiento		CHAR(1);		-- Naturaleza de movimiento
	DECLARE BloqueoSaldo		CHAR(1);		-- Bloqueo de saldo
	DECLARE ConceptoConta		INT(11);       	-- 64 BLOQUEO por garantia liquida
	DECLARE Var_TipoBloqueo		INT(11);		-- variable del tipo de bloquep
	DECLARE Var_TipoBloqDes		VARCHAR(30);	-- variable del tipo de bloquep
	DECLARE LiberarInver		INT(11);		-- Liberar Inversion
	DECLARE Par_NumErr			INT(11);		-- Numero de error
	DECLARE Par_ErrMen			VARCHAR(400);	-- Mensaje de error
	DECLARE Var_NumErr			CHAR;			-- variable numero de error

	/* Declaracion de Contantes */
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
    DECLARE Entero_Dos			INT(11);
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Estatus_Pagada  	CHAR(1);
	DECLARE Rei_NO          	CHAR(2);
	DECLARE Ren_PagoInver   	INT(11);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE Var_PagoInver  	 	INT(11);
	DECLARE Var_RefPagoInv  	VARCHAR(100);
	DECLARE Nat_Cargo       	CHAR(1);
	DECLARE Nat_Abono      		CHAR(1);
	DECLARE SalidaNO       		CHAR(1);
	DECLARE SalidaSI       		CHAR(1);
	DECLARE Var_ConInvCapi  	INT(11);
	DECLARE Var_ConInvProv  	INT(11);
	DECLARE Var_ConInvISR   	INT(11);
	DECLARE Con_Capital     	INT(11);
	DECLARE Mov_AhorroSI    	CHAR(1);
	DECLARE Mov_AhorroNO    	CHAR(1);
	DECLARE Cue_PagIntExe   	CHAR(50);
	DECLARE Cue_PagIntGra   	CHAR(50);
	DECLARE Cue_RetInver    	CHAR(50);
	DECLARE Tipo_Provision  	CHAR(4);
	DECLARE NombreProceso  		VARCHAR(20);
	DECLARE Ope_Interna     	CHAR(1);
	DECLARE Tip_Compra      	CHAR(1);
	DECLARE AltPoliza_SI    	CHAR(1);
	DECLARE AltPoliza_NO    	CHAR(1);
	DECLARE SI_Isr_Socio    	CHAR(1);
	DECLARE Mov_PagInvCap   	VARCHAR(4);
	DECLARE Mov_PagIntExe   	VARCHAR(4);
	DECLARE Mov_PagIntGra   	VARCHAR(4);
	DECLARE Mov_PagInvRet   	VARCHAR(4);
	DECLARE ISRpSocio		VARCHAR(10);
	DECLARE No_constante		VARCHAR(10);
	DECLARE Var_FechaISR		DATE;			-- variable fecha de inicio cobro isr por socio
	DECLARE Var_NumCred		INT(11);		-- Numero de credito
	DECLARE Var_TipoInstrumento	INT(11);
	DECLARE Est_Aplicado		CHAR(1);
	DECLARE EnteroUno		INT(11);
	DECLARE ProcesoCierre		CHAR(1);
	DECLARE Es_Migrada		INT(11);
	DECLARE FechaInicioMigrada	DATE;
	DECLARE Var_ISRPendiente  DECIMAL(14,2);

    DECLARE PAGOINVERCUR CURSOR FOR
		SELECT Inv.InversionID,    	Inv.CuentaAhoID,    Inv.TipoInversionID,    Inv.MonedaID,   	Inv.Monto,
			   Inv.InteresGenerado, Inv.InteresRetener, Inv.ISRReal,			Inv.ClienteID,      Inv.SaldoProvision,
			   Cli.SucursalOrigen,	Inv.FechaInicio,	Inv.FechaVencimiento
			FROM INVERSIONES Inv,
				 CLIENTES Cli
			WHERE Inv.Estatus	= Estatus_Vigente
			  AND Reinvertir    = Rei_NO
			  AND Inv.FechaVencimiento	= Par_Fecha
			  AND Inv.ClienteID = Cli.ClienteID;

	/*declaracion de CURSOR que servira para realizar el bloqueo de inversiones que no renovan automaticamente y estaban amparANDo creditos*/
	DECLARE BLOQINVGARCUR CURSOR FOR
	 SELECT InversionID,    		CuentaAhoID,    TipoInversionID,    MonedaID,   		Monto,
			InteresGenerado, 		InteresRetener, ClienteID,          SaldoProvision,		SucursalOrigen,
			CreditoInvGarID,		CreditoID, 		MontoEnGar
			FROM TMPINVERSINRENOVA;

	/* Asignacion de Contantes */
	SET Cadena_Vacia    := '';          -- constante con valor vacio para settear
	SET Fecha_Vacia     := '1900-01-01';-- constante con valor fecha inicial para settear
	SET Entero_Cero     := 0;			-- constante con valor cero para settear
    SET Entero_Dos      := 2;			-- constante con valor dos para settear
    SET Estatus_Vigente := 'N';         -- Estatus de la Inversion: Vigente
	SET Estatus_Pagada  := 'P';         -- Estatus de la Inversion: Pagada
	SET Rei_NO          := 'N';         -- NO Reinvertir
	SET Ren_PagoInver   := 111;         -- Proceso de Pago de Inversion
	SET Pol_Automatica  := 'A'; 		-- Poliza: Automatica
	SET Var_PagoInver   := 15;          -- Concepto Contable: Pago de Inversion
	SET Nat_Cargo       := 'C';         -- Naturaleza de Cargo
	SET Nat_Abono       := 'A';         -- Naturaleza de Abono
	SET SalidaSI        := 'S';         -- Salida SI
	SET SalidaNO        := 'N';         -- Salida NO
	SET Mov_PagInvCap   := '61';        -- PAGO INVERSION. CAPITAL
	SET Mov_PagIntGra   := '62';        -- PAGO INVERSION. INTERES GRAVADO
	SET Mov_PagIntExe   := '63';        -- PAGO INVERSION. INTERES EXCENTO
	SET Mov_PagInvRet   := '64';        -- PAGO INVERSION. RETENCION
	SET Var_ConInvCapi  := 1;           -- Concepto Contable de Inversion: Capital
	SET Var_ConInvProv  := 5;           -- Concepto Contable de Inversion: Provision
	SET Var_ConInvISR   := 4;           -- Concepto Contable de Inversion: Retencion
	SET Con_Capital     := 1;           -- Concepto Contable de Ahorro: Capital
	SET Mov_AhorroSI    := 'S';         -- Movimiento de Ahorro: SI
	SET Mov_AhorroNO    := 'N';         -- Movimiento de Ahorro: NO
	SET Tipo_Provision  := '100';       -- Tipo de Movimiento de Inversion: Provision
	SET Ope_Interna     := 'I';         -- Tipo de Operacion: Interna
	SET Tip_Compra      := 'C';         -- Tipo de Operacion: Compra de Divisa
	SET AltPoliza_SI    := 'S';         -- Alta de la Poliza SI
	SET AltPoliza_NO    := 'N';         -- Alta de la Poliza NO
	SET SI_Isr_Socio	:= 'S';   		-- Si se calcula isr por socio


	SET Cue_PagIntExe   := 'PAGO INVERSION. INTERES EXENTO';	-- PAGO INVERSION. INTERES EXENTO
	SET Cue_PagIntGra   := 'PAGO INVERSION. INTERES GRAVADO';	-- PAGO INVERSION. INTERES GRAVADO
	SET Cue_RetInver    := 'RETENCION ISR INVERSION';			-- RETENCION ISR INVERSION
	SET NombreProceso   := 'INVERSION'; 						-- INVERSION
	SET Var_RefPagoInv  := 'PAGO DE INVERSION';					-- PAGO DE INVERSION

	-- CURSOR BLOQINVGARCUR constantes -----
	SET Ren_BloqInverGar:= 111;		-- Ren_BloqInverGar
	SET NatMovimiento	:= 'B';		-- NatMovimiento
	SET Var_TipoBloqueo	:=  8;		-- Tipo de bloqueo
	SET Var_TipoBloqDes	:= 'DEPOSITO POR GARANTIA LIQUIDA';	--  Tipo de bloqueo DEPOSITO POR GARANTIA LIQUIDA
	SET BloqueoSaldo	:= 'B';		-- Bloqueo saldo
	SET ConceptoConta	:=  64;     -- Concepto contable
	SET LiberarInver	:=  2;			  -- Numero de actualizacion para liberar inversiÃ³n
    SET ISRpSocio		:= 'ISR_pSocio';  -- constante para isr por socio de PARAMGENERALES
    SET No_constante	:= 'N';			  -- constante NO
    SET Var_TipoInstrumento	 :=	13;		  -- Numero de Instrumento de Inversiones
    SET Est_Aplicado         :=  'A';
    SET EnteroUno		:=	1;
    SET ProcesoCierre	:=	'C';
    SET FechaInicioMigrada :=  '2018-02-28';
      SET Var_ISRPendiente := 0;

	SELECT  COUNT(InversionID) INTO Var_NumeroVenc
		FROM INVERSIONES Inv
		WHERE Estatus       = Estatus_Vigente
		  AND Reinvertir    = Rei_NO
		  AND FechaVencimiento	= Par_Fecha;

	SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);

	IF(Var_NumeroVenc > Entero_Cero) THEN
		CALL MAESTROPOLIZAALT(
			Par_Poliza,     Par_Empresa,    Par_Fecha,      Pol_Automatica,     Var_PagoInver,
			Var_RefPagoInv, SalidaNO,       Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );
	END IF;

	SELECT MonedaBaseID,FechaISR INTO Var_MonedaBase,Var_FechaISR
		FROM PARAMETROSSIS;

	SELECT ValorParametro INTO Var_ISR_pSocio
		FROM PARAMGENERALES
			WHERE LlaveParametro=ISRpSocio;
    SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , No_constante);
    SET Var_FechaISR	:= IFNULL(Var_FechaISR,Par_Fecha);
	/*SE LLENA TABLA TEMPORAL PARA ALMACENAR LA INFORMACION QUE SE UTILIZARA AL HACER EL BLOQUEO DE
	LA GARANTIA QUE SE TUVIERA AMPARANDO CREDITOS */
	TRUNCATE TMPINVERSINRENOVA;

	INSERT INTO TMPINVERSINRENOVA(
		InversionID,    		CuentaAhoID,    		TipoInversionID,    	MonedaID,   		Monto,
		InteresGenerado,
		InteresRetener,
		ClienteID,
		SaldoProvision,
		SucursalOrigen,
		CreditoInvGarID,		CreditoID, 				MontoEnGar)
		SELECT
        Inv.InversionID,    	Inv.CuentaAhoID,    	Inv.TipoInversionID,    Inv.MonedaID,   	Inv.Monto,
		Inv.InteresGenerado,
		CASE WHEN (Var_ISR_pSocio=SI_Isr_Socio AND FechaInicio>=Var_FechaISR ) THEN Inv.ISRReal
			ELSE Inv.InteresRetener END AS InteresRetener,
		Inv.ClienteID,
		Inv.SaldoProvision,
		Cli.SucursalOrigen,
		CrInv.CreditoInvGarID,	CrInv.CreditoID, 		CrInv.MontoEnGar
		FROM  INVERSIONES Inv,
			  CLIENTES Cli,
			  CREDITOINVGAR CrInv
			WHERE Inv.Estatus	= Estatus_Vigente
			  AND Reinvertir    = Rei_NO
			  AND Inv.FechaVencimiento	= Par_Fecha
			  AND Inv.ClienteID = Cli.ClienteID
			  AND Inv.InversionID = CrInv.InversionID;

	DROP TABLE IF EXISTS TMPINVERCRED;
	CREATE TEMPORARY TABLE TMPINVERCRED(
		RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		InversionID	BIGINT(12),
		Creditos	INT(11));

	INSERT INTO TMPINVERCRED (InversionID, Creditos)
		SELECT InversionID,	COUNT(CreditoID) AS CREDITOS
			FROM TMPINVERSINRENOVA
			GROUP BY InversionID;



	/*SE HABRE CURSOR PARA PAGAR LAS INVERSIONES QUE NO SE RENOVAN DE MANERA AUTOMATICA */
	OPEN PAGOINVERCUR;

	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
		FETCH PAGOINVERCUR INTO
		Var_InversionID,        Var_CuentaAhoID,    Var_TipoInversionID,    Var_MonedaID,   	Var_Monto,
		Var_InteresGenerado,    Var_InteresRetener, VAR_ISRReal,			Var_ClienteID,      Var_SaldoProvision,
		Var_SucCliente,			Var_InverFecIni,	Var_InverFecFin;

		START TRANSACTION;
		BEGIN

			DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

   		-- ==================Calculo de ISR ===================================
		INSERT INTO CTESVENCIMIENTOS(
				Fecha,				ClienteID,		EmpresaID,		UsuarioID,		FechaActual,
				DireccionIP,		ProgramaID,		Sucursal,   	NumTransaccion)
		SELECT	Par_Fecha,			Var_ClienteID,	Par_Empresa,	Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion;


		CALL CALCULOISRPRO(
			Par_Fecha,			Par_Fecha,			EnteroUno,		ProcesoCierre,		SalidaNO,
			Par_NumErr,			Par_ErrMen,			Par_Empresa,	Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

		DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

   		-- ================== Fin de Calculo de ISR ===================================


    SET Es_Migrada := (SELECT IFNULL(COUNT(InversionIDSAFI),Entero_Cero) FROM EQU_INVERSIONES
                    WHERE InversionIDSAFI= Var_InversionID);

    -- Si existe un monto pendiente de ISR a cobrar ya se de menos o de más, se suma al interés a retener.
    IF (Var_ISR_pSocio=SI_Isr_Socio) THEN

        IF(Es_Migrada > Entero_Cero AND Var_InverFecIni<= FechaInicioMigrada) THEN
            SET Var_InteresRetener:= Var_InteresRetener;
          ELSE
             SET Var_InteresRetener :=FNTOTALISRCTE(Var_ClienteID,Var_TipoInstrumento,Var_InversionID);
        END IF;
    END IF;

  SET Var_ISRPendiente :=(SELECT IFNULL(InteresRet,Entero_Cero) FROM TMP_INVERSIONESRETENER
                    WHERE InversionID=Var_InversionID);

  SET Var_ISRPendiente := IFNULL(Var_ISRPendiente,Entero_Cero);

  -- Si existe un monto pendiente de ISR a cobrar ya se de menos o de más, se suma al interés a retener.
  IF (Var_ISRPendiente <> 0) THEN
        SET Var_InteresRetener:= Var_InteresRetener + (Var_ISRPendiente);
      IF(Var_InteresRetener < Entero_Cero) THEN
        SET Var_InteresRetener:= Entero_Cero;
      END IF;
  END IF;

			CALL CONTAINVERSIONPRO(
				Var_InversionID,    Par_Empresa,        Par_Fecha,          Var_Monto,      Mov_PagInvCap,
				Var_PagoInver,      Var_ConInvCapi,     Con_Capital,        Nat_Abono,      AltPoliza_NO,
				Mov_AhorroSI,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,  Var_MonedaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Var_SucCliente,
				Aud_NumTransaccion  );

			IF (Var_InteresRetener = Entero_Cero) THEN
				SET Var_MovIntere := Mov_PagIntExe;
				SET Cue_PagIntere := Cue_PagIntExe;
			ELSE
				SET Var_MovIntere := Mov_PagIntGra;
				SET Cue_PagIntere := Cue_PagIntGra;
			END IF;

			IF (Var_InteresGenerado > Entero_Cero) THEN
				CALL CONTAINVERSIONPRO(
					Var_InversionID,    Par_Empresa,        Par_Fecha,          Var_InteresGenerado, Cadena_Vacia,
					Var_PagoInver,      Var_ConInvProv,     Entero_Cero,        Nat_Cargo,          AltPoliza_NO,
					Mov_AhorroNO,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,
					Aud_NumTransaccion  );

				CALL INVERSIONESMOVALT(
					Var_InversionID,    Aud_NumTransaccion, Par_Fecha,      	Tipo_Provision,		Var_InteresGenerado,
					Nat_Abono,          Var_RefPagoInv,     Var_MonedaID,   	Par_Poliza,			Par_Empresa,
					Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
					Aud_NumTransaccion  );

				 SET Var_Instrumento := CONVERT(Var_InversionID, CHAR);

				-- Abono Operativo y Contable del Interes Generado
				CALL CUENTASAHOMOVALT(
					Var_CuentaAhoID,        Aud_NumTransaccion, 	Par_Fecha,      Nat_Abono,		Var_InteresGenerado,
                    Cue_PagIntere,      	Var_Instrumento,	    Var_MovIntere,	Par_Empresa,    Aud_Usuario,
                    Aud_FechaActual,    	Aud_DireccionIP,		Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion  );

				SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

				CALL POLIZAAHORROPRO(
					Par_Poliza,         Par_Empresa,    Par_Fecha,          Var_ClienteID,          Con_Capital,
					Var_CuentaAhoID,    Var_MonedaID,   Entero_Cero,        Var_InteresGenerado,    Cue_PagIntere,
					Var_CuentaStr,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
					Var_SucCliente,		Aud_NumTransaccion  );

				SET Var_Tasa	:=(SELECT Tasa FROM INVERSIONES WHERE InversionID = Var_InversionID);
                SET Var_Tasa	:=IFNULL(Var_Tasa,Entero_Cero);

				--  Registro de informacion para el Calculo del Interes Real para Inversiones
				CALL CALCULOINTERESREALALT (
					 Var_ClienteID,			Par_Fecha,				Var_TipoInstrumento,	Var_InversionID,		Var_Monto,
                     Var_InteresGenerado,	Var_InteresRetener,		Var_Tasa,				Var_InverFecIni,		Var_InverFecFin,
                     Par_Empresa,			Aud_Usuario,			Aud_FechaActual,   		Aud_DireccionIP,		Aud_ProgramaID,
                     Aud_Sucursal,			Aud_NumTransaccion);

			END IF;

			-- Retencion
			IF (Var_InteresRetener > Entero_Cero) THEN

				CALL CUENTASAHOMOVALT(
					Var_CuentaAhoID,    Aud_NumTransaccion, Par_Fecha,          Nat_Cargo,			Var_InteresRetener,
                    Cue_RetInver,       Var_Instrumento,    Mov_PagInvRet,		Par_Empresa,        Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion  );

				CALL POLIZAAHORROPRO(
					Par_Poliza,         Par_Empresa,    Par_Fecha,          Var_ClienteID,      Con_Capital,
					Var_CuentaAhoID,    Var_MonedaID,   Var_InteresRetener,	Entero_Cero,        Cue_RetInver,
					Var_CuentaStr,      Aud_Usuario, 	Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
					Var_SucCliente,		Aud_NumTransaccion   );

				IF (Var_MonedaBase != Var_MonedaID) THEN

					SELECT TipCamComInt INTO Var_TipCamCom
						FROM MONEDAS
							WHERE MonedaId = Var_MonedaID;

					SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, Entero_Dos);

					CALL COMVENDIVISAALT(
						Var_MonedaID,   Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,			Var_TipCamCom,
                        Ope_Interna,    Tip_Compra,   	 	    Var_Instrumento,	Var_RefPagoInv, 			NombreProceso,
                        Par_Poliza,     Par_Empresa,	 		Aud_Usuario,  		Aud_FechaActual,        	Aud_DireccionIP,
                        Aud_ProgramaID,	Var_SucCliente,			Aud_NumTransaccion   );

				ELSE
					SET Var_IntRetMN := Var_InteresRetener;
				END IF;

				CALL CONTAINVERSIONPRO(
					Var_InversionID,    Par_Empresa,        Par_Fecha,          Var_IntRetMN,       Cadena_Vacia,
					Var_PagoInver,      Var_ConInvISR,      Entero_Cero,        Nat_Abono,          AltPoliza_NO,
					Mov_AhorroNO,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaBase,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,
					Aud_NumTransaccion  );
			END IF;

			IF(Var_InversionID NOT IN (SELECT InversionID FROM TMPINVERCRED))THEN
				UPDATE INVERSIONES SET
					Estatus 		= Estatus_Pagada,
					EmpresaID 		= Par_Empresa,
					Usuario 		= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP		= Aud_DireccionIP,
					ProgramaID 		= Aud_ProgramaID,
					Sucursal 		= Aud_Sucursal,
					NumTransaccion 	= Aud_NumTransaccion
					WHERE InversionID  	= Var_InversionID;

				UPDATE COBROISR isr
					SET Estatus = Est_Aplicado
						WHERE ClienteID 	= Var_ClienteID
						AND ProductoID 		= Var_InversionID
						AND InstrumentoID 	= Var_TipoInstrumento;
			END IF;
		END;

		SET Var_InverStr := CONVERT(Var_InversionID, CHAR);

		IF Error_Key = 0 THEN
			COMMIT;
		END IF;

		IF Error_Key = 1 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_PagoInver,	 		Par_Fecha, 			Var_InverStr, 		'ERROR DE SQL GENERAL',  Par_Empresa,
                    Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF Error_Key = 2 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_PagoInver, 			Par_Fecha, 				Var_InverStr, 		'ERROR EN ALTA, LLAVE DUPLICADA',	Par_Empresa,
                    Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,						Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF Error_Key = 3 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_PagoInver, 		Par_Fecha, 			Var_InverStr, 		'ERROR AL LLAMAR A STORE PROCEDURE', 	Par_Empresa,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;
		IF Error_Key = 4 THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_PagoInver, 		Par_Fecha, 			Var_InverStr, 		'ERROR VALORES NULOS', 		Par_Empresa,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		END LOOP;

	END;
	CLOSE PAGOINVERCUR;


	-- CURSOR PARA BLOQUEO DE SALDO POR VENCIMIENTO DE INVERSION y
	-- ARANTIA DE CREDITO VIGENTE
	OPEN BLOQINVGARCUR;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH BLOQINVGARCUR INTO
				Var_InversionID,        Var_CuentaAhoID,    Var_TipoInversionID,    Var_MonedaID,   	Var_Monto,
				Var_InteresGenerado,    Var_InteresRetener, Var_ClienteID,          Var_SaldoProvision,	Var_SucCliente,
				Var_CredInvGarant,		Var_CredID,			Var_MontoEnGar;
		START TRANSACTION;
		Transaccion:BEGIN

			DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
			DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

			IF(IFNULL(Var_InversionID, Entero_Cero) != Entero_Cero)THEN
				SELECT Creditos INTO Var_NumCred FROM  TMPINVERCRED
					WHERE	InversionID	= Var_InversionID;

                CALL CREDITOINVGARACT(
					Var_CredInvGarant,	 Var_CredID,		Var_InversionID,	Par_Poliza,		LiberarInver,
					SalidaNO,			 Par_NumErr,		Par_ErrMen,			Par_Empresa,	Aud_Usuario,
					Aud_FechaActual,	 Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					SET Error_Key := 99;
					LEAVE Transaccion;
				END IF;

				CALL BLOQUEOSPRO(
					Entero_Cero,  	NatMovimiento, 		Var_CuentaAhoID, 	Par_Fecha, 		Var_MontoEnGar,
					Fecha_Vacia,  	Var_TipoBloqueo, 	Var_TipoBloqDes,	Var_CredID,		Cadena_Vacia,
					Cadena_Vacia, 	SalidaNO,			Par_NumErr,			Par_ErrMen,		Par_Empresa,
					Aud_Usuario, 	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					SET Error_Key := 99;
					LEAVE Transaccion;
				END IF;

				CALL CONTAGARLIQPRO(
					Par_Poliza,			Par_Fecha,		Var_ClienteID,	Var_CuentaAhoID, Var_MonedaID,
					Var_MontoEnGar, 	AltPoliza_NO,	ConceptoConta,	NatMovimiento,	 Var_TipoBloqueo,
					Var_TipoBloqDes,	SalidaNO,		Par_NumErr,		Par_ErrMen,	 	 Par_Empresa,
					Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,	 Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					SET Error_Key := 99;
					LEAVE Transaccion;
				END IF;

                SET Var_NumCred	:= Var_NumCred-1;

				UPDATE TMPINVERCRED SET
					Creditos		= Var_NumCred
				WHERE	InversionID	= Var_InversionID;


				IF(Var_NumCred = 0)THEN
					UPDATE INVERSIONES SET
						Estatus 		= Estatus_Pagada,
						EmpresaID 		= Par_Empresa,
						Usuario 		= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID 		= Aud_ProgramaID,
						Sucursal 		= Aud_Sucursal,
						NumTransaccion 	= Aud_NumTransaccion
					WHERE InversionID  	= Var_InversionID;
				END IF;

			 END IF;

        END Transaccion;

		SET Var_CreInvGarStr := CONVERT(Var_CredInvGarant, CHAR);

		IF (Error_Key = 0) THEN
			COMMIT;
		END IF;

		IF (Error_Key = 1) THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_BloqInverGar, 	Par_Fecha, 			Var_CreInvGarStr, 	'ERROR DE SQL GENERAL', 	Par_Empresa,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF (Error_Key = 2) THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_BloqInverGar, 	Par_Fecha, 			Var_CreInvGarStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',	Par_Empresa,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,					 	Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF (Error_Key = 3) THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_BloqInverGar, 	Par_Fecha, 			Var_CreInvGarStr, 	'ERROR AL LLAMAR A STORE PROCEDURE',	Par_Empresa,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,							Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF (Error_Key = 4) THEN
			ROLLBACK;
			START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Ren_BloqInverGar, 	Par_Fecha, 			Var_CreInvGarStr, 	'ERROR VALORES NULOS', 	Par_Empresa,
                    Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
                    Aud_NumTransaccion);
			COMMIT;
		END IF;

		IF (Error_Key = 99) THEN
            ROLLBACK;
            START TRANSACTION;
                CALL EXCEPCIONBATCHALT(
                    Ren_BloqInverGar,   Par_Fecha,          Var_CreInvGarStr,   CONCAT(Par_NumErr,' - ',Par_ErrMen),  	Par_Empresa,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         				Aud_Sucursal,
                    Aud_NumTransaccion);
            COMMIT;
        END IF;


	END LOOP;

	END;
	CLOSE BLOQINVGARCUR;

END TerminaStore$$
