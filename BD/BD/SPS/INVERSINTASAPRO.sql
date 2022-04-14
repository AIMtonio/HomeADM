-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERSINTASAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERSINTASAPRO`;
DELIMITER $$


CREATE PROCEDURE `INVERSINTASAPRO`(
# =============================================================================
#  	SP que identifica todas las inversiones que tienen configurado reinvertise
#	pero que por alguna condicion no les corresponde ninguna tasa segun lo parametrizado
#	Ejemplo: Cuando la inversion es de 365 dias y por un dia inabil se calcula a 366 y ya no hay tasas
#	parametrizadas para este plazo o cuando es migrada
# =============================================================================
	Par_Fecha			DATE,		-- Parametro fecha
	Par_EmpresaID		INT(11),	-- Parametro Empresa

-- Parametros de auditoria
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
			)

TerminaStore: BEGIN


	/* PARA CURSOR PAGOINVERCUR */
	DECLARE Var_InversionID     BIGINT(20);			-- Inversion id
	DECLARE Var_CuentaAhoID     BIGINT(20);			-- Cuenta de ahorro
	DECLARE Var_TipoInversionID INT(11);			-- Tipo de inversion
	DECLARE Var_MonedaID        INT(11);			-- ID Moneda
	DECLARE Var_Monto           DECIMAL(14,2);		-- Monto
	DECLARE Var_InteresGenerado DECIMAL(14,2);		-- Interes generado
	DECLARE Var_InteresRetener  DECIMAL(14,2);		-- Interes retener
	DECLARE Var_ClienteID       BIGINT(20);			-- Cliente id
	DECLARE Var_SaldoProvision  DECIMAL(14,2);		-- Saldo provision
	DECLARE Mov_PagInvCap       VARCHAR(4);			-- Pago Inversion Capital
	DECLARE Mov_PagIntExe       VARCHAR(4);			-- Mov_PagIntGra
	DECLARE Mov_PagIntGra       VARCHAR(4);			-- Mov_PagIntGra
	DECLARE Mov_PagInvRet       VARCHAR(4);			-- Mov_PagInvRet
	DECLARE Var_SucCliente      INT(11);			-- Var_SucCliente

	-- Declaracion de Variables
	DECLARE Var_FecBitaco 		DATETIME;			-- Fecha bitacora
	DECLARE Var_MinutosBit 		INT(11);			-- Minutos bit
	DECLARE Var_InverStr        VARCHAR(20);		-- Var_InverStr
	DECLARE Error_Key			INT DEFAULT 0;		-- Error_Key
	DECLARE Var_NumeroVenc		INT(11);			-- Var_NumeroVenc
	DECLARE Var_MovIntere		VARCHAR(4);			-- Var_MovIntere
	DECLARE Cue_PagIntere		CHAR(50);			-- Cue_PagIntere
	DECLARE Par_Poliza			BIGINT(20);			-- Poliza
	DECLARE Var_Instrumento		VARCHAR(15);		-- Instrumento
	DECLARE Var_CuentaStr		VARCHAR(15);		-- Var_CuentaStr
	DECLARE Var_MonedaBase		INT(11);			-- Moneda base
	DECLARE Var_TipCamCom		DECIMAL(14,6);		-- Var_TipCamCom
	DECLARE Var_IntRetMN		DECIMAL(12,2);		-- Var_IntRetMN
	DECLARE Var_NumCred			INT(11);			-- Numero de creditos

	/*VARIABLES PARA CURSOR BLOQINVGARCUR*/
	DECLARE Var_CredInvGarant 	INT(11);			-- Var_CredInvGarant
	DECLARE Var_CredID			BIGINT(20);			-- Var_CredID
	DECLARE Var_MontoEnGar		DECIMAL(12,2);		-- Monto en garantia
	DECLARE Var_CreInvGarStr	VARCHAR(20);		-- Var_CreInvGarStr
	DECLARE Var_MontoGar		DECIMAL(12,2);		-- Var_MontoGar

	-- Constante
	DECLARE Ren_BloqInverGar	INT(11);			-- Bloqueo inversion garantia
	DECLARE NatMovimiento		CHAR(1);			-- Naturaleza de movimiento
	DECLARE BloqueoSaldo		CHAR(1);			-- Concepto contable
	DECLARE ConceptoConta		INT(11);        	-- 64 BLOQUEO por garantia liquida
	DECLARE Var_TipoBloqueo		INT(11);			-- Tipo de bloqueo
	DECLARE Var_TipoBloqDes		VARCHAR(30);		-- Tipo bloqueo descripcion
	DECLARE LiberarInver		INT(11);			-- Liberar inversion

	DECLARE Par_NumErr			INT(11);			-- Numero de error
	DECLARE Par_ErrMen			VARCHAR(400);		-- Mensaje de error
	DECLARE Var_NumErr			INT(11);			-- Variable numero de error
	DECLARE Var_InverFecIni  	DATE;				-- Fecha inicio Inversion
    DECLARE Var_InverFecFin  	DATE;				-- Fecha vencimiento Inversion

	DECLARE Var_Tasa			DECIMAL(12,2);		-- Valor de la Tasa de la Inversion

	/* Declaracion de Contantes */
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Estatus_Pagada		CHAR(1);
	DECLARE Rei_NO				CHAR(2);
	DECLARE Ren_PagoInver		INT(11);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Var_PagoInver		INT(11);
	DECLARE Var_RefPagoInv		VARCHAR(100);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Var_ConInvCapi		INT(11);
	DECLARE Var_ConInvProv		INT(11);
	DECLARE Var_ConInvISR		INT(11);
	DECLARE Con_Capital			INT(11);
	DECLARE Mov_AhorroSI		CHAR(1);
	DECLARE Mov_AhorroNO		CHAR(1);
	DECLARE Cue_PagIntExe		CHAR(50);
	DECLARE Cue_PagIntGra		CHAR(50);
	DECLARE Cue_RetInver		CHAR(50);
	DECLARE Tipo_Provision		CHAR(4);
	DECLARE NombreProceso		VARCHAR(20);
	DECLARE Ope_Interna			CHAR(1);
	DECLARE Tip_Compra			CHAR(1);
	DECLARE AltPoliza_SI		CHAR(1);
	DECLARE AltPoliza_NO		CHAR(1);


	-- Declaracion de Constantes
	DECLARE Pro_CieDiaInv		INT(11);
	DECLARE Rei_Capital			CHAR(2);
	DECLARE Rei_CapInte			CHAR(2);
	DECLARE Var_InverSinTasa 	INT(11);
	DECLARE SI_PagaISR			CHAR(1);
    DECLARE Est_Aplicado		CHAR(1);
    DECLARE InstInversion       INT(11);
    DECLARE EnteroUno           INT(11);
    DECLARE ProcesoCierre       CHAR(1);

	DECLARE PAGOINVERCUR CURSOR FOR
		SELECT	Inv.InversionID,		Inv.CuentaAhoID,	Inv.TipoInversionID,	Inv.MonedaID,		Inv.Monto,
				Inv.InteresGenerado,	Inv.InteresRetener,	Inv.ClienteID,			Inv.SaldoProvision,	Cli.SucursalOrigen
			FROM TMPINVERSINTASA Inv,
				 CLIENTES Cli
			WHERE	Inv.ClienteID	= Cli.ClienteID;

	/*declaracion de CURSOR que servira para realizar el bloqueo de inversiones que no renovan automaticamente y estaban amparando creditos*/
	DECLARE BLOQINVGARCUR CURSOR FOR
		SELECT 	InversionID,			CuentaAhoID,		TipoInversionID,		MonedaID,   		Monto,
				InteresGenerado,		InteresRetener,		ClienteID,				SaldoProvision,		SucursalOrigen,
				CreditoInvGarID,		CreditoID,			MontoEnGar
			FROM TMPINVERSINRENOVA;


	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';		-- Cadena vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero			:= 0;		-- Entero cero
	SET Estatus_Vigente		:= 'N';		-- Estatus vigente
	SET Estatus_Pagada		:= 'P';		-- Estatus de la Inversion: Pagada
	SET Rei_NO				:= 'N';		-- Rei_NO
	SET Rei_Capital			:= 'C';		-- Rei_Capital
	SET Rei_CapInte			:= 'CI';	-- Rei_Capital
	SET Var_InverSinTasa	:= 113;		-- Var_InverSinTasa
	SET SI_PagaISR			:= 'S';		-- El Cliente si Paga ISR
	SET Ren_PagoInver		:= 111;     -- Proceso de Pago de Inversion
	SET Pol_Automatica		:= 'A'; 	-- Poliza: Automatica
	SET Var_PagoInver		:= 15;      -- Concepto Contable: Pago de Inversion
	SET Nat_Cargo			:= 'C';     -- Naturaleza de Cargo
	SET Nat_Abono			:= 'A';     -- Naturaleza de Abono
	SET SalidaSI			:= 'S';     -- Salida SI
	SET SalidaNO			:= 'N';     -- Salida NO
	SET Mov_PagInvCap		:= '61';    -- PAGO INVERSION. CAPITAL
	SET Mov_PagIntGra		:= '62';    -- PAGO INVERSION. INTERES GRAVADO
	SET Mov_PagIntExe		:= '63';    -- PAGO INVERSION. INTERES EXCENTO
	SET Mov_PagInvRet		:= '64';    -- PAGO INVERSION. RETENCION
	SET Var_ConInvCapi		:= 1;       -- Concepto Contable de Inversion: Capital
	SET Var_ConInvProv		:= 5;       -- Concepto Contable de Inversion: Provision
	SET Var_ConInvISR		:= 4;       -- Concepto Contable de Inversion: Retencion
	SET Con_Capital			:= 1;       -- Concepto Contable de Ahorro: Capital
	SET Mov_AhorroSI		:= 'S';     -- Movimiento de Ahorro: SI
	SET Mov_AhorroNO		:= 'N';     -- Movimiento de Ahorro: NO
	SET Tipo_Provision		:= '100';	-- Tipo de Movimiento de Inversion: Provision
	SET Ope_Interna			:= 'I';		-- Tipo de Operacion: Interna
	SET Tip_Compra			:= 'C';		-- Tipo de Operacion: Compra de Divisa
	SET AltPoliza_SI		:= 'S';		-- Alta de la Poliza SI
	SET AltPoliza_NO		:= 'N';		-- Alta de la Poliza NO

	SET Cue_PagIntExe		:= 'PAGO INVERSION. INTERES EXENTO';	-- PAGO INVERSION. INTERES EXENTO
	SET Cue_PagIntGra		:= 'PAGO INVERSION. INTERES GRAVADO';	-- PAGO INVERSION. INTERES GRAVADO
	SET Cue_RetInver		:= 'RETENCION ISR INVERSION';			-- RETENCION ISR INVERSION
	SET NombreProceso		:= 'INVERSION'; 						-- INVERSION
	SET Var_RefPagoInv		:= 'PAGO DE INVERSION';					-- PAGO DE INVERSION

	-- CURSOR BLOQINVGARCUR constantes -----
	SET Ren_BloqInverGar	:= 111;									-- Ren_BloqInverGar
	SET NatMovimiento		:= 'B';									-- Naturaleza del movimiento
	SET Var_TipoBloqueo		:=  8;									-- Tipo de bloqueo
	SET Var_TipoBloqDes		:= 'DEPOSITO POR GARANTIA LIQUIDA';		-- DEPOSITO POR GARANTIA LIQUIDA
	SET BloqueoSaldo		:= 'B';									-- Bloqueo de saldo
	SET ConceptoConta		:= 64;       							-- Concepto contable
	SET LiberarInver		:= 2;			-- Numero de actualizacion para liberar inversiÃ³n

	SET Aud_FechaActual		:= NOW();								-- Fecha actual de auditoria
	SET Var_FecBitaco		:= NOW();								-- Fecha actual de bitacora
    SET Est_Aplicado		:= 'A';		-- Estatus Aplicado
    SET InstInversion   	:=  13;		-- Numero de Instrumento de Inversiones
	SET EnteroUno       	:=  1;
    SET ProcesoCierre   	:=  'C';

	/*SE BORRAN LOS DATOS QUE PUDIERA TENER LA TABLA TEMPORAL DE PASO */
	TRUNCATE TABLE TMPINVERSINTASA;

	/* se guarda en la tabla temporal de paso las inversiones que se van a reinvertir */
	INSERT INTO TMPINVERSINTASA(
		InversionID,			CuentaAhoID,				TipoInversionID,				MonedaID,							FechaInicio,
		Monto,					Plazo,						Tasa,							TasaISR,							TasaNeta,
		InteresGenerado,		InteresRecibir,				InteresRetener,					ConsecutivoTabla,					NuevaTasa,
		ClienteID,				SaldoProvision)
	SELECT
		Inv.InversionID,        Inv.CuentaAhoID,    	 	Inv.TipoInversionID,    		Inv.MonedaID,               		Inv.FechaInicio,
		Inv.Monto,              Inv.Plazo,          		IFNULL(Inv.Tasa,Entero_Cero),   IFNULL(Inv.TasaISR,Entero_Cero),	Inv.TasaNeta,
		Inv.InteresGenerado,    Inv.InteresRecibir, 		Inv.InteresRetener,				Inv.ConsecutivoTabla, 				IFNULL(Inv.NuevaTasa,Entero_Cero),
		Inv.ClienteID,          Inv.SaldoProvision
	FROM TEMINVERSIONES Inv
	WHERE Inv.NuevaTasa <= 0 ;


	/*se cuentan cuantas inversiones sin tasa hay */
	SELECT  COUNT(InversionID) INTO Var_NumeroVenc
		FROM TEMINVERSIONES Inv
	WHERE Inv.NuevaTasa <= 0 ;

	SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);

	/*si hay al menos una inversion sin tasa se genera el encabezado de la poliza  */
	IF(Var_NumeroVenc > Entero_Cero) THEN
		CALL MAESTROPOLIZAALT(
			Par_Poliza,     Par_EmpresaID,	Par_Fecha,      Pol_Automatica,     Var_PagoInver,
			Var_RefPagoInv, SalidaNO,		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,	Aud_NumTransaccion  );
	ELSE
		/* en caso contrario se sale del programa */
		LEAVE TerminaStore;
	END IF;

	SELECT MonedaBaseID INTO Var_MonedaBase
		FROM PARAMETROSSIS;

	/*SE LLENA TABLA TEMPORAL PARA ALMACENAR LA INFORMACION QUE SE UTILIZARA AL HACER EL BLOQUEO DE
	LA GARANTIA QUE SE TUVIERA AMPARANDO CREDITOS */
	DELETE FROM TMPINVERSINRENOVA;
	INSERT INTO TMPINVERSINRENOVA(
				InversionID,    		CuentaAhoID,		TipoInversionID,		MonedaID,   		Monto,
				InteresGenerado, 		InteresRetener,		ClienteID,				SaldoProvision,		SucursalOrigen,
				CreditoInvGarID,		CreditoID,			MontoEnGar)
		SELECT 	Inv.InversionID,    	Inv.CuentaAhoID,    Inv.TipoInversionID,    Inv.MonedaID,   	Inv.Monto,
				Inv.InteresGenerado, 	Inv.InteresRetener, Inv.ClienteID,          Inv.SaldoProvision,	Cli.SucursalOrigen,
				CrInv.CreditoInvGarID,	CrInv.CreditoID, 	CrInv.MontoEnGar
			FROM  TEMINVERSIONES Inv,
				  CLIENTES Cli,
				  CREDITOINVGAR CrInv
			WHERE	Inv.ClienteID	= Cli.ClienteID
			  AND 	Inv.InversionID	= CrInv.InversionID
              AND	Inv.NuevaTasa <= 0 ;


	-- TABLA TEMPORAL PARA SABER A CUANTOS CREDITOS AVALA UNA INVERSION
	DROP TABLE IF EXISTS TMPINVERCRED;
	CREATE TEMPORARY TABLE TMPINVERCRED(
		RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
		InversionID	BIGINT(12),
		Creditos	INT(11));

	INSERT INTO TMPINVERCRED (InversionID, Creditos)
		SELECT InversionID,	COUNT(CreditoID) AS CREDITOS
			FROM TMPINVERSINRENOVA
			GROUP BY InversionID;

		-- =============================================================================================================
		IF(Var_NumeroVenc > Entero_Cero) THEN
				DELETE FROM CTESVENCIMIENTOS;

				INSERT INTO CTESVENCIMIENTOS(
						Fecha,              ClienteID,      EmpresaID,      UsuarioID,      FechaActual,
						DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
				SELECT  Par_Fecha,          inv.ClienteID,  Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,
						Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
					FROM TMPINVERSINTASA inv
					GROUP BY inv.ClienteID;

				CALL CALCULOISRPRO(
						Par_Fecha,          Par_Fecha,      EnteroUno,      ProcesoCierre,      SalidaNO,
						Par_NumErr,         Par_ErrMen,     Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
						Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

		END IF;
		-- =============================================================================================================

	/*SE HABRE CURSOR PARA PAGAR LAS INVERSIONES QUE NO SE RENOVAN DE MANERA AUTOMATICA */
	OPEN PAGOINVERCUR;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH PAGOINVERCUR INTO
				Var_InversionID,        Var_CuentaAhoID,    Var_TipoInversionID,    Var_MonedaID,   	Var_Monto,
				Var_InteresGenerado,    Var_InteresRetener, Var_ClienteID,          Var_SaldoProvision,	Var_SucCliente;

			START TRANSACTION;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

				CALL CONTAINVERSIONPRO(
					Var_InversionID,    Par_EmpresaID,		Par_Fecha,          Var_Monto,      Mov_PagInvCap,
					Var_PagoInver,      Var_ConInvCapi,     Con_Capital,        Nat_Abono,      AltPoliza_NO,
					Mov_AhorroSI,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,  Var_MonedaID,
					Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Var_SucCliente,
					Aud_NumTransaccion  );

-- ========================== ISR
			SET Var_InteresRetener:=FNTOTALISRCTE(Var_ClienteID,InstInversion,Var_InversionID);
-- ========================== ISR

				IF (Var_InteresRetener = Entero_Cero) THEN
					SET Var_MovIntere := Mov_PagIntExe;
					SET Cue_PagIntere := Cue_PagIntExe;
				ELSE
					SET Var_MovIntere := Mov_PagIntGra;
					SET Cue_PagIntere := Cue_PagIntGra;
				END IF;

				IF (Var_InteresGenerado > Entero_Cero) THEN
					CALL CONTAINVERSIONPRO(
						Var_InversionID,    Par_EmpresaID,		Par_Fecha,          Var_InteresGenerado,	Cadena_Vacia,
						Var_PagoInver,      Var_ConInvProv,     Entero_Cero,        Nat_Cargo,				AltPoliza_NO,
						Mov_AhorroNO,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,			Var_MonedaID,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,			Var_SucCliente,
						Aud_NumTransaccion);

					CALL INVERSIONESMOVALT(
						Var_InversionID,    Aud_NumTransaccion, Par_Fecha,      	Tipo_Provision,		Var_InteresGenerado,
						Nat_Abono,          Var_RefPagoInv,     Var_MonedaID,   	Par_Poliza,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,
						Aud_NumTransaccion);


					SET Var_Instrumento := CONVERT(Var_InversionID, CHAR);

					-- Abono Operativo y Contable del Interes Generado
					CALL CUENTASAHOMOVALT(
						Var_CuentaAhoID,	Aud_NumTransaccion,	Par_Fecha,		Nat_Abono,		Var_InteresGenerado,
						Cue_PagIntere,		Var_Instrumento,	Var_MovIntere,	Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion  );



					SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

					CALL POLIZAAHORROPRO(
						Par_Poliza,        	Par_EmpresaID,		Par_Fecha,         Var_ClienteID,          Con_Capital,
						Var_CuentaAhoID,   	Var_MonedaID,		Entero_Cero,       Var_InteresGenerado,    Cue_PagIntere,
						Var_CuentaStr,     	Aud_Usuario,		Aud_FechaActual,   Aud_DireccionIP,        Aud_ProgramaID,
						Var_SucCliente,		Aud_NumTransaccion);

					 -- Se obtiene la fecha de inicio y vencimiento de la inversion
					 SET Var_InverFecIni := (SELECT FechaInicio FROM INVERSIONES WHERE InversionID = Var_InversionID);
					 SET Var_InverFecFin := (SELECT FechaVencimiento FROM INVERSIONES WHERE InversionID = Var_InversionID);

                     SET Var_Tasa	:=(SELECT Tasa FROM INVERSIONES WHERE InversionID = Var_InversionID);
					 SET Var_Tasa	:=IFNULL(Var_Tasa,Entero_Cero);

                     -- Registro de informacion para el Calculo del Interes Real para Inversiones
					 CALL CALCULOINTERESREALALT (
						 Var_ClienteID,			Par_Fecha,				InstInversion,		 	Var_InversionID,		Var_Monto,
						 Var_InteresGenerado,	Var_InteresRetener,		Var_Tasa,				Var_InverFecIni,		Var_InverFecFin,
                         Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,   		Aud_DireccionIP,		Aud_ProgramaID,
                         Aud_Sucursal,			Aud_NumTransaccion);

				END IF;

				-- Retencion
				IF (Var_InteresRetener >	Entero_Cero) THEN

					CALL CUENTASAHOMOVALT(
						Var_CuentaAhoID,	Aud_NumTransaccion,	Par_Fecha,			Nat_Cargo,		Var_InteresRetener,
						Cue_RetInver,		Var_Instrumento,	Mov_PagInvRet,		Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion );


					CALL POLIZAAHORROPRO(
						Par_Poliza,         Par_EmpresaID,		Par_Fecha,          Var_ClienteID,		Con_Capital,
						Var_CuentaAhoID,    Var_MonedaID,		Var_InteresRetener,	Entero_Cero,        Cue_RetInver,
						Var_CuentaStr,      Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Var_SucCliente,		Aud_NumTransaccion);

					IF(Var_MonedaBase != Var_MonedaID)THEN
						SELECT TipCamComInt INTO Var_TipCamCom
							FROM MONEDAS
							WHERE	MonedaId	= Var_MonedaID;

						SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

						CALL COMVENDIVISAALT(
							Var_MonedaID,	Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,		Var_TipCamCom,
							Ope_Interna,	Tip_Compra,				Var_Instrumento,	Var_RefPagoInv,			NombreProceso,
							Par_Poliza,		Par_EmpresaID, 			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,	Var_SucCliente,			Aud_NumTransaccion);
					ELSE
						SET Var_IntRetMN := Var_InteresRetener;
					END IF;

					CALL CONTAINVERSIONPRO(
						Var_InversionID,    Par_EmpresaID,		Par_Fecha,			Var_IntRetMN,		Cadena_Vacia,
						Var_PagoInver,      Var_ConInvISR,      Entero_Cero,        Nat_Abono,          AltPoliza_NO,
						Mov_AhorroNO,       Par_Poliza,         Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaBase,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,
						Aud_NumTransaccion);
				END IF;

				IF(Var_InversionID NOT IN (SELECT InversionID FROM TMPINVERCRED))THEN

					/* SE MARCAN LAS INVERSIONES COMO PAGADAS */
					UPDATE INVERSIONES SET
						Estatus 		= Estatus_Pagada,
						EmpresaID 		= Par_EmpresaID,
						Usuario 		= Aud_Usuario,
						FechaActual		= Aud_FechaActual,
						DireccionIP		= Aud_DireccionIP,
						ProgramaID 		= Aud_ProgramaID,
						Sucursal 		= Aud_Sucursal,
						NumTransaccion 	= Aud_NumTransaccion
					WHERE InversionID  	= Var_InversionID;

				END IF;

				/*Parte del ISR */
					UPDATE COBROISR isr
						SET Estatus = Est_Aplicado
						WHERE ClienteID 		= Var_ClienteID
							AND ProductoID 		= Var_InversionID
							AND InstrumentoID 	= InstInversion;

				SET Var_InverStr := CONVERT(Var_InversionID, CHAR);

				/* SE INSERTA EL REGISTRO COMO UNA EXCEPCION*/
				CALL EXCEPCIONBATCHALT(
					Var_InverSinTasa,		Par_Fecha,			Var_InverStr,		'INVERSION SIN TASA ',	Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);
			END;

			SET Var_InverStr := CONVERT(Var_InversionID, CHAR);
			IF (Error_Key = 0 )THEN
				COMMIT;
			END IF;

			IF (Error_Key = 1) THEN
				ROLLBACK;
				START TRANSACTION;
				CALL EXCEPCIONBATCHALT(
					Var_InverSinTasa, 	Par_Fecha, 		Var_InverStr,		'ERROR DE SQL GENERAL',
					Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

			IF (Error_Key = 2) THEN
				ROLLBACK;
				START TRANSACTION;

				CALL EXCEPCIONBATCHALT(
					Var_InverSinTasa, 	Par_Fecha,		Var_InverStr, 		'ERROR EN ALTA, LLAVE DUPLICADA',
					Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

			IF (Error_Key = 3) THEN
				ROLLBACK;
				START TRANSACTION;

					CALL EXCEPCIONBATCHALT(
						Var_InverSinTasa, 	Par_Fecha, 		Var_InverStr, 		'ERROR AL LLAMAR A STORE PROCEDURE',
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

			IF (Error_Key = 4) THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Var_InverSinTasa, 	Par_Fecha, 		Var_InverStr, 		'ERROR VALORES NULOS',
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
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
		CICLO:LOOP
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


					CALL BLOQUEOSPRO(
						Entero_Cero,		NatMovimiento,		Var_CuentaAhoID, 	Par_Fecha, 			Var_MontoEnGar,
						Fecha_Vacia,		Var_TipoBloqueo,	Var_TipoBloqDes,	Var_CredID,			Cadena_Vacia,
						Cadena_Vacia,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);


					IF(Par_NumErr <> Entero_Cero)THEN
						SET Error_Key := 99;
						LEAVE Transaccion;
					END IF;


					CALL CONTAGARLIQPRO(
						Par_Poliza,			Par_Fecha,			Var_ClienteID,		Var_CuentaAhoID,	Var_MonedaID,
						Var_MontoEnGar,		AltPoliza_NO,		ConceptoConta,		NatMovimiento,		Var_TipoBloqueo,
						Var_TipoBloqDes,	SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr <> Entero_Cero)THEN
						SET Error_Key := 99;
						LEAVE Transaccion;
					END IF;

				CALL CREDITOINVGARACT(
						Var_CredInvGarant,	 Var_CredID,		Var_InversionID,	Par_Poliza,		LiberarInver,
						SalidaNO,			 Par_NumErr,		Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	 Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

					SET	Par_NumErr	:= IFNULL(Par_NumErr, Entero_Cero);

					IF(Par_NumErr != Entero_Cero) THEN
						SET Error_Key := 99;
						LEAVE Transaccion;
					END IF;

					SET Var_NumCred	:= Var_NumCred-1;

					UPDATE TMPINVERCRED SET
						Creditos		= Var_NumCred
					WHERE	InversionID	= Var_InversionID;

					IF(Var_NumCred = 0)THEN
						/* SE MARCAN LAS INVERSIONES COMO PAGADAS */
						UPDATE INVERSIONES SET
							Estatus 		= Estatus_Pagada,
							EmpresaID 		= Par_EmpresaID,
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
						Var_InverSinTasa, 	Par_Fecha, 		Var_CreInvGarStr, 	'ERROR DE SQL GENERAL',
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

			IF (Error_Key = 2) THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Var_InverSinTasa, 	Par_Fecha, 		Var_CreInvGarStr, 	'ERROR EN ALTA, LLAVE DUPLICADA',
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

			IF (Error_Key = 3) THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Var_InverSinTasa, 	Par_Fecha, 		Var_CreInvGarStr, 	'ERROR AL LLAMAR A STORE PROCEDURE',
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

			IF (Error_Key = 4) THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Var_InverSinTasa, 	Par_Fecha, 		Var_CreInvGarStr, 	'ERROR VALORES NULOS',
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

            IF (Error_Key = 99) THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Var_InverSinTasa, 	Par_Fecha, 		Var_CreInvGarStr, 	CONCAT(Par_NumErr,' - ',Par_ErrMen),
						Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
				COMMIT;
			END IF;

		END LOOP CICLO;
	END;
	CLOSE BLOQINVGARCUR;


	/* se borran de la tabla temporal las inversiones que no tienen tasa, para que el
	proceso que reinvierte de manera masiva no los tome*/
	DELETE FROM TEMINVERSIONES WHERE  NuevaTasa <= Entero_Cero;

	/*SE INSERTA EN LA BITACORA EL TIEMPO QUE TARDO ESTE PROCESO*/
	SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual	:= NOW();

	CALL BITACORABATCHALT(
		Var_InverSinTasa, 	Par_Fecha, 			Var_MinutosBit,	Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

	SET Var_FecBitaco := NOW();


	/*SE ELIMINA TABLA TEMPORAL DE INVERSIONES*/
	TRUNCATE TABLE TMPINVERSINTASA;


END TerminaStore$$
