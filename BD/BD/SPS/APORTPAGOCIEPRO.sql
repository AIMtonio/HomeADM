

-- APORTPAGOCIEPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTPAGOCIEPRO`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTPAGOCIEPRO`(
# ============================================================
# -----  SP QUE REALIZA LOS PAGOS DE LOS APORTACIONES---------
# ============================================================
	Par_Fecha                   DATE,   		-- Fecha
	Par_TipoRegistro            CHAR(1),		-- Tipo de Registro
	Par_TipoProceso             CHAR(1),    	-- Tipo De Proceso: N.- No Reinvierten, S .- Si Reinvierten
	Par_Salida                  CHAR(1),    	-- Indica una salida
	INOUT Par_NumErr            INT(11),        -- Numero de Error

	INOUT Par_ErrMen            VARCHAR(400),	-- Mensaje de error
	INOUT Par_ContadorTotal     INT(11),    	-- Contador Total vencimiento masivo aportaciones
	INOUT Par_ContadorExito     INT(11),    	-- Contador Exito vencimiento masivo aportaciones
	/* Parámetros de Auditoría */
	Par_Empresa                 INT(11),
	Aud_Usuario                 INT(11),

	Aud_FechaActual             DATETIME,
	Aud_DireccionIP             VARCHAR(15),
	Aud_ProgramaID              VARCHAR(50),
	Aud_Sucursal                INT(11),
	Aud_NumTransaccion          BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_AportStr        VARCHAR(20);
	DECLARE Var_AportacionID	BIGINT(12);
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_TipoAportID      INT(11);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_Monto           DECIMAL(14,2);
	DECLARE Var_InteresGenerado DECIMAL(14,2);
	DECLARE Var_InteresRetener  DECIMAL(14,2);
	DECLARE Var_ClienteID       BIGINT(12);
	DECLARE Var_SaldoProvision  DECIMAL(14,2);
	DECLARE Var_SucCliente      INT(11);
	DECLARE Var_CalculoInteres  INT(11);
	DECLARE Var_InteresPagar    DECIMAL(14,2);
	DECLARE Error_Key           INT DEFAULT 0;
	DECLARE Var_NumeroVenc      INT(11);
	DECLARE Var_MovIntere       VARCHAR(4);
	DECLARE Cue_PagIntere       CHAR(50);
	DECLARE Par_Poliza          BIGINT(12);
	DECLARE Var_Instrumento     VARCHAR(15);
	DECLARE Var_CuentaStr       VARCHAR(15);
	DECLARE Var_MonedaBase      INT(11);
	DECLARE Var_AmortizacionID  INT(11);
	DECLARE Var_TipCamCom       DECIMAL(14,6);
	DECLARE Var_IntRetMN        DECIMAL(16,2);
	DECLARE Var_FechaVenAport     DATE;
	DECLARE VarFechaVenAmo      DATE;
	DECLARE VarFecVenceAmor     DATE;
	DECLARE VarFecIniciaAmo     DATE;
	DECLARE Var_MontoAport       DECIMAL(14,2);
	DECLARE Var_PagaISR  		CHAR(1);
	DECLARE Var_TasaISR  		DECIMAL(14,2);
	DECLARE Var_ISRReal			DECIMAL(12,2);	-- variable que guardara el valor de isrreal de cada socio
	DECLARE Var_ISR_pSocio		CHAR(1);		-- variable que guaradra el valor de parametrosgenerales si se calcula ISR por socio
	DECLARE Var_FechaISR		DATE;			-- variable fecha de inicio cobro isr por socio
	DECLARE Var_Tasa			DECIMAL(14,4);	-- Valor de la Tasa de la Aportacion
    DECLARE Var_CapitalizaInt	CHAR(1);		-- Indica si la aportacion capitaliza interes
    DECLARE Var_MontoCapitaliza	DECIMAL(14,2);		-- Guarda el monto de la capitalizacion
    DECLARE Var_RefCapitaliza	VARCHAR(20);		-- Guarda la referencia para el movimiento de capitalizacion

	-- Declaracion de Contantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT(3);
	DECLARE SalidaSI            CHAR(1);
	DECLARE SalidaNO            CHAR(1);
	DECLARE Mov_PagCedCap       VARCHAR(4);
	DECLARE Mov_PagIntGra       VARCHAR(4);
	DECLARE Mov_PagIntExe       VARCHAR(4);
	DECLARE Mov_PagCedRet       VARCHAR(4);
	DECLARE Estatus_Vigente     CHAR(1);
	DECLARE Est_Pagado          CHAR(1);
	DECLARE Ren_PagoAport       INT;
	DECLARE Pol_Automatica      CHAR(1);
	DECLARE Var_PagoAport       INT;
	DECLARE Var_RefPagoCed      VARCHAR(100);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono           CHAR(1);
	DECLARE Var_ConcepCapi      INT;
	DECLARE Var_ConcepProv      INT;
	DECLARE Var_ConcepISR       INT;
	DECLARE Con_Capital         INT;
	DECLARE Mov_AhorroSI        CHAR(1);
	DECLARE Mov_AhorroNO        CHAR(1);
	DECLARE Cue_PagIntExe       CHAR(50);
	DECLARE Cue_PagIntGra       CHAR(50);
	DECLARE Cue_RetAport        CHAR(50);
	DECLARE Tipo_Provision      CHAR(4);
	DECLARE NombreProceso       VARCHAR(20);
	DECLARE Ope_Interna         CHAR(1);
	DECLARE Tip_Compra          CHAR(1);
	DECLARE AltPoliza_NO        CHAR(1);
	DECLARE Tasa_Fija           INT(11);
	DECLARE Pago_NoReinversion  CHAR(1);
	DECLARE Pago_SiReinversion  CHAR(1);
	DECLARE InicioMes           DATE;
	DECLARE Est_Aplicado        CHAR(1);
	DECLARE EnteroUno           INT(11);
	DECLARE ContadorTotal       INT(11);  	-- Contador total vencimiento masivo aportaciones
	DECLARE ContadorExito       INT(11);  	-- Contador exitoso vencimiento masivo aportaciones
	DECLARE CalculoISRxCli  	CHAR(1);	-- Constante tipo de calculo por cliente
	DECLARE ISRpSocio			VARCHAR(10);
	DECLARE No_constante		VARCHAR(10);
	DECLARE SI_Isr_Socio    	CHAR(1);
	DECLARE InstAport			INT(11);
    DECLARE Cons_Si				CHAR(1);	-- Constante si
    DECLARE Const_DesCapInteres	VARCHAR(50);
    DECLARE Cons_Posterior		CHAR(1);
    DECLARE Estatus_Aut			CHAR(1);

	DECLARE PAGOAPORTCUR CURSOR FOR
		SELECT
			AP.AportacionID,	AP.CuentaAhoID,		AP.TipoAportacionID,	AP.MonedaID,		AP.Capital,
			AP.Interes,			AP.InteresRetener,	AP.ClienteID,      		AP.SaldoProvision,	AP.SucursalOrigen,
			AP.AmortizacionID,	AP.FechaVencimiento,AP.FechaPago,			AP.CalculoInteres,	Ce.Monto,
			AP.FechaIniAmo,		AP.FechaVenciAmo,	AP.PagaISR,				AP.TasaISR,			Ce.ISRReal,
            AP.PagoIntCapitaliza
		FROM TMPPAGOSAPORT AP INNER JOIN APORTACIONES Ce ON AP.AportacionID=Ce.AportacionID
			WHERE AP.NumTransaccion = Aud_NumTransaccion;

	-- Asignacion de Contantes
	SET Cadena_Vacia        := '';              -- Constante Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Constante Fecha Vacia
	SET Entero_Cero         := 0;               -- Constante Entero Cero
	SET SalidaSI            := 'S';         	-- Salida SI
	SET SalidaNO            := 'N';         	-- Salida NO
	SET Mov_PagCedCap       := '602';        	-- PAGO APORTACION. CAPITAL
	SET Mov_PagIntGra       := '603';        	-- PAGO APORTACION. INTERES GRAVADO
	SET Mov_PagIntExe       := '604';        	-- PAGO APORTACION. INTERES EXCENTO
	SET Mov_PagCedRet       := '605';        	-- PAGO APORTACION. RETENCION
	SET Estatus_Vigente     := 'N';        		-- Estatus de la APORTACION: Vigente
	SET Est_Pagado          := 'P';         	-- Estatus de la APORTACION: Pagada
	SET Ren_PagoAport       := 1506;         	-- Proceso de Pago de Aportacion
	SET Pol_Automatica      := 'A';           	-- Poliza: Automatica
	SET Var_PagoAport       := 902;         	-- Concepto Contable: Pago de APORTACION
	SET Var_RefPagoCed      := 'VENCIMIENTO DE APORTACION';		-- Descripcion Referencia
	SET Nat_Cargo           := 'C';         	-- Naturaleza de Cargo
	SET Nat_Abono           := 'A';         	-- Naturaleza de Abono
	SET Var_ConcepCapi      := 1;           	-- Concepto Contable de APORTACION: Capital
	SET Var_ConcepProv      := 5;           	-- Concepto Contable de APORTACION: Provision
	SET Var_ConcepISR       := 4;           	-- Concepto Contable de APORTACION: Retencion
	SET Con_Capital         := 1;           	-- Concepto Contable de Ahorro: Capital
	SET Mov_AhorroSI        := 'S';         	-- Movimiento de Ahorro: SI
	SET Mov_AhorroNO        := 'N';         	-- Movimiento de Ahorro: NO
	SET Cue_PagIntExe       := 'INTERESES GENERADOS';			-- Descripcion Interes Excento
	SET Cue_PagIntGra       := 'INTERESES GENERADOS';			-- Descripcion Interes Gravado
	SET Cue_RetAport        := 'RETENCION ISR';					-- Descripcion Retencion ISR
	SET Tipo_Provision      := '100';       	-- Tipo de Movimiento de APORTACION: Provision
	SET NombreProceso       := 'Aportacion';			--  Descripcion Nombre Proceso
	SET Ope_Interna         := 'I';        	 	-- Tipo de Operacion: Interna
	SET Tip_Compra          := 'C';         	-- Tipo de Operacion: Compra de Divisa
	SET AltPoliza_NO        := 'N';        	 	-- Alta de la Poliza NO
	SET Tasa_Fija           :=  1;         		-- Tipo de Calculo de Interes Tasa Fija
	SET Pago_NoReinversion  := 'N';     		-- Tipo de Aportaciones que NO Reinvierten
	SET Pago_SiReinversion  := 'S';     		-- Tipo de Aportaciones que SI Reinvierten
	SET InicioMes           := CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE);       -- Fecha de Inicio del Mes a Trabajar.
	SET Est_Aplicado        :=  'A';
	SET EnteroUno           :=  1;
	SET Aud_FechaActual     := NOW();
	SET CalculoISRxCli      := 'C';         	-- Tipo de Calculo ISR por cliente
	SET ISRpSocio			:= 'ISR_pSocio';  	-- constante para isr por socio de PARAMGENERALES
	SET No_constante		:= 'N';			  	-- constante NO
	SET SI_Isr_Socio		:= 'S';   			-- Si se calcula isr por socio
	SET InstAport			:= 31;				-- Tipo de instrumento Aportaciones.
    SET Cons_Si				:= 'S';				-- Constante si
    SET Const_DesCapInteres	:= 'CAPITALIZACION INTERES'; -- Descripcion del movimiento de capitalizacion de interes
    SET Cons_Posterior		:= 'F';
    SET Estatus_Aut			:= 'A';				-- Estatus de Condiciones de Vencimiento: Autorizadas.

	ManejoErrores : BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-APORTPAGOCIEPRO');
			END;

		DELETE FROM TMPPAGOSAPORT
			WHERE NumTransaccion = Aud_NumTransaccion;

		SET Par_TipoProceso := IFNULL(Par_TipoProceso, Pago_NoReinversion);

		SET Var_MonedaBase :=  (SELECT MonedaBaseID FROM PARAMETROSSIS WHERE EmpresaID = Par_Empresa);
		SET Var_MonedaBase := IFNULL(Var_MonedaBase,EnteroUno);

		-- CONSIDERACION SI AL VENCIMIENTO SE PAGAN LAS QUE SE REINVIERTEN O NO
		IF (Par_TipoProceso = Pago_NoReinversion) THEN
			INSERT INTO TMPPAGOSAPORT (
						NumTransaccion,				AportacionID,				CuentaAhoID,				TipoAportacionID,			MonedaID,
						Capital,					Interes,					InteresRetener,				ClienteID,					SaldoProvision,
						SucursalOrigen,				AmortizacionID,				FechaVencimiento,			FechaPago,					CalculoInteres,
						FechaIniAmo,				FechaVenciAmo,				PagaISR,					TasaISR,					PagoIntCapitaliza)

				(SELECT  Aud_NumTransaccion, 		AP.AportacionID,			MAX(AP.CuentaAhoID),		MAX(AP.TipoAportacionID),	MAX(AP.MonedaID),
						MAX(Amo.Capital),   		MAX(Amo.Interes),       	MAX(Amo.SaldoISR+Amo.SaldoIsrAcum), AP.ClienteID,		MAX(Amo.SaldoProvision),
						MAX(cte.SucursalOrigen),	MAX(Amo.AmortizacionID),	MAX(AP.FechaVencimiento),	MAX(Amo.FechaPago),			MAX(AP.CalculoInteres),
						MAX(Amo.FechaInicio),		MAX(Amo.FechaVencimiento),	MAX(cte.PagaISR),			MAX(AP.TasaISR),			MAX(AP.PagoIntCapitaliza)
					FROM 	APORTACIONES AP
							INNER JOIN  AMORTIZAAPORT Amo ON  AP.AportacionID 	= Amo.AportacionID
														  AND Amo.Estatus 		= Estatus_Vigente
														  AND Amo.FechaPago 	<= Par_Fecha
														  AND (AP.Reinversion 	= Pago_NoReinversion
														  OR  ( AP.Reinversion = Pago_SiReinversion
															  AND AP.FechaPago != Amo.FechaPago)
                                                          OR ( AP.Reinversion = Cons_Posterior
															  AND AP.FechaPago != Amo.FechaPago))
							INNER JOIN CLIENTES cte ON AP.ClienteID = cte.ClienteID
					WHERE 	AP.Estatus = Estatus_Vigente
						AND (AP.ConCondiciones = No_constante
							OR (AP.ConCondiciones = Cons_Si AND AP.ConsolidarSaldos = 'G'))
					GROUP BY AP.ClienteID,AP.AportacionID)
				UNION
				# APORTACIONES VIGENTES CON CONDICIONES AUTORIZADAS QUE NO REINVIERTEN.
				(SELECT  Aud_NumTransaccion, 		AP.AportacionID,			MAX(AP.CuentaAhoID),		MAX(AP.TipoAportacionID),	MAX(AP.MonedaID),
						MAX(Amo.Capital),   		MAX(Amo.Interes),       	MAX(Amo.SaldoISR+Amo.SaldoIsrAcum), AP.ClienteID,		MAX(Amo.SaldoProvision),
						MAX(cte.SucursalOrigen),	MAX(Amo.AmortizacionID),	MAX(AP.FechaVencimiento),	MAX(Amo.FechaPago),			MAX(AP.CalculoInteres),
						MAX(Amo.FechaInicio),		MAX(Amo.FechaVencimiento),	MAX(cte.PagaISR),			MAX(AP.TasaISR),			MAX(AP.PagoIntCapitaliza)
					FROM 	APORTACIONES AP
							INNER JOIN  AMORTIZAAPORT Amo ON  AP.AportacionID 	= Amo.AportacionID
														  AND Amo.Estatus 		= Estatus_Vigente
														  AND Amo.FechaPago 	<= Par_Fecha
														  AND (AP.Reinversion 	= Pago_NoReinversion
														  OR  ( AP.Reinversion = Pago_SiReinversion
															  AND AP.FechaPago != Amo.FechaPago)
                                                          OR ( AP.Reinversion = Cons_Posterior
															  AND AP.FechaPago != Amo.FechaPago))
							INNER JOIN CONDICIONESVENCIMAPORT AC ON AP.AportacionID = AC.AportacionID
							INNER JOIN CLIENTES cte ON AP.ClienteID = cte.ClienteID
					WHERE 	AP.Estatus = Estatus_Vigente
						AND AC.Estatus = Estatus_Aut
					GROUP BY AP.ClienteID,AP.AportacionID);

		ELSE  -- Pago de las que si Reinversion.

			INSERT INTO TMPPAGOSAPORT(
						NumTransaccion,				AportacionID,				CuentaAhoID,				TipoAportacionID,			MonedaID,
						Capital,					Interes,					InteresRetener,				ClienteID,					SaldoProvision,
						SucursalOrigen,				AmortizacionID,				FechaVencimiento,			FechaPago,					CalculoInteres,
						FechaIniAmo,				FechaVenciAmo,				PagaISR,					TasaISR,					PagoIntCapitaliza)
				SELECT  Aud_NumTransaccion, 		AP.AportacionID,			MAX(AP.CuentaAhoID),		MAX(AP.TipoAportacionID),	MAX(AP.MonedaID),
						MAX(Amo.Capital),        	MAX(Amo.Interes),           MAX(Amo.SaldoISR+Amo.SaldoIsrAcum), AP.ClienteID,		MAX(Amo.SaldoProvision),
						MAX(cte.SucursalOrigen), 	MAX(Amo.AmortizacionID),    MAX(AP.FechaVencimiento),	MAX(Amo.FechaPago),     	MAX(AP.CalculoInteres),
						MAX(Amo.FechaInicio),		MAX(Amo.FechaVencimiento),	MAX(cte.PagaISR),			MAX(AP.TasaISR),			MAX(AP.PagoIntCapitaliza)
					FROM 	APORTACIONES AP
							INNER JOIN  AMORTIZAAPORT Amo ON  AP.AportacionID 		= Amo.AportacionID
														  AND AP.FechaPago		= Amo.FechaPago
														  AND Amo.Estatus 		= Estatus_Vigente
														  AND AP.FechaPago 	= Par_Fecha
														  AND AP.Reinversion 	= Pago_SiReinversion
							INNER JOIN APORTANCLAJE anc ON AP.AportacionID = anc.AportacionAncID
							INNER JOIN CLIENTES cte ON AP.ClienteID = cte.ClienteID
					WHERE 	AP.Estatus = Estatus_Vigente
						AND ((AP.ConCondiciones = No_constante AND AP.ConsolidarSaldos = No_constante) OR
							(AP.ConCondiciones = Cons_Si AND AP.ConsolidarSaldos != 'G'))
					GROUP BY AP.ClienteID, AP.AportacionID;
		END IF;

		SELECT  COUNT(AP.AportacionID) INTO Var_NumeroVenc
			FROM 	TMPPAGOSAPORT AP
			WHERE 	AP.NumTransaccion = Aud_NumTransaccion;

		SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);

		# SI HAY APORTACIONES QUE VENCIERON, SE GENERA EL ENCABEZADO DE LA PÓLIZA.
		IF(Var_NumeroVenc > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,         Par_Empresa,        Par_Fecha,      Pol_Automatica,     Var_PagoAport,
				Var_RefPagoCed,     SalidaNO,           Par_NumErr,     Par_ErrMen,         Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );
			IF(Par_NumErr != Entero_Cero) THEN /* SI SURGIO UN ERROR SE SALE DEL SP*/
				LEAVE ManejoErrores;
			END IF;
		END IF;

		/*Contador vencimiento masivo aportaciones*/
		SET ContadorTotal:=0;
		SET ContadorExito:=0;

		/*SE HABRE CURSOR PARA PAGAR LAS APORTACIONES QUE NO SE RENUEVAN DE MANERA AUTOMATICA */
		OPEN PAGOAPORTCUR;

			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOPAGOAPORTCUR:LOOP

					FETCH PAGOAPORTCUR INTO
					Var_AportacionID,		Var_CuentaAhoID,    Var_TipoAportID,	Var_MonedaID,       Var_Monto,
					Var_InteresGenerado,    Var_InteresRetener, Var_ClienteID,      Var_SaldoProvision, Var_SucCliente,
					Var_AmortizacionID,     Var_FechaVenAport,	VarFechaVenAmo,     Var_CalculoInteres,	Var_MontoAport,
					VarFecIniciaAmo,		VarFecVenceAmor,	Var_PagaISR,		Var_TasaISR,		Var_ISRReal,
                    Var_CapitalizaInt;

					START TRANSACTION;
					Transaccion:BEGIN

						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
						DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

						SET Error_Key			:= Entero_Cero;
						SET Aud_FechaActual		:= NOW();
						SET Var_InteresPagar	:= Entero_Cero;
						SET Var_FechaVenAport	:= (SELECT FechaVencimiento FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
						SET VarFechaVenAmo		:= (SELECT FechaPago FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
						SET VarFecIniciaAmo		:= (SELECT FechaInicio FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);
						SET VarFecVenceAmor		:= (SELECT FechaVencimiento FROM AMORTIZAAPORT WHERE AportacionID = Var_AportacionID AND AmortizacionID = Var_AmortizacionID);

                        SET @numCuota := (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID= Var_AportacionID);
                        SET @numCuota := IFNULL(@numCuota,Entero_Cero);

                        -- VALIDACIONES PARA EL MONTO A PAGAR EN CASO DE SER UNA APORTACION
						-- QUE CAPITALIZA INTERES
                        IF(Var_CapitalizaInt=Cons_Si AND Var_AmortizacionID = @numCuota)THEN
							SET Var_Monto := (SELECT SaldoCap
												FROM AMORTIZAAPORT
												WHERE AportacionID = Var_AportacionID
												AND AmortizacionID = @numCuota);
						END IF;

						/*Contador vencimiento masivo aportaciones*/
						SET ContadorTotal:=ContadorTotal+1;
						IF(Var_Monto > Entero_Cero) THEN
							/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA APORTACION */
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_Empresa,        Par_Fecha,          Var_Monto,      Mov_PagCedCap,
								Var_PagoAport,      Var_ConcepCapi,     Con_Capital,        Nat_Abono,      AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,           Par_Poliza,         Par_NumErr,     Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,       Aud_Usuario,    Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,     Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero) THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

						END IF;

						IF (Var_InteresRetener = Entero_Cero) THEN
							SET Var_MovIntere := Mov_PagIntExe;
							SET Cue_PagIntere := Cue_PagIntExe;
						ELSE
							SET Var_MovIntere := Mov_PagIntGra;
							SET Cue_PagIntere := Cue_PagIntGra;
						END IF;

						-- Verificamos si el Interes de Pagare en Tasa Fija o el Saldo de Provision de Tasa Variable
						IF(Var_CalculoInteres = Tasa_Fija) THEN
							SET Var_InteresPagar := Var_SaldoProvision;
						ELSE
							SET Var_InteresPagar := Var_SaldoProvision;
						END IF;

						IF (Var_InteresPagar > Entero_Cero) THEN
							/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA APORTACION */
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_Empresa,        Par_Fecha,          Var_InteresPagar,   Var_MovIntere,
								Var_PagoAport,      Var_ConcepProv,     Con_Capital,        Nat_Abono,              AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,           Par_Poliza,         Par_NumErr,             Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,       Aud_Usuario,            Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,     Aud_NumTransaccion  );

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							CALL APORTMOVALT(
								Var_AportacionID,	Par_Fecha,          Tipo_Provision,     Var_InteresPagar,       Nat_Abono,
								Cue_PagIntere,      Var_MonedaID,       SalidaNO,           Par_NumErr,             Par_ErrMen,
								Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion  );

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							 SET Var_Instrumento := CONVERT(Var_AportacionID, CHAR);
							 SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

							 SET Var_Tasa	:=(SELECT TasaFija FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
							 SET Var_Tasa	:=IFNULL(Var_Tasa,Entero_Cero);

							-- Registro de informacion para el Calculo del Interes Real para Aportaciones
							CALL CALCULOINTERESREALALT (
								 Var_ClienteID,			Par_Fecha,			InstAport,			Var_AportacionID,			Var_MontoAport,
								 Var_InteresPagar,		Var_InteresRetener,	Var_Tasa,			VarFecIniciaAmo,	VarFecVenceAmor,
								 Par_Empresa,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
								 Aud_Sucursal,			Aud_NumTransaccion);

						END IF;

						-- Retencion
						IF (Var_InteresRetener > Entero_Cero) THEN
							 SET Var_Instrumento := CONVERT(Var_AportacionID, CHAR);
							 SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

							CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,    Aud_NumTransaccion, Par_Fecha,          Nat_Cargo,			Var_InteresRetener,
								Cue_RetAport,   	Var_Instrumento,    Mov_PagCedRet,		SalidaNO,			Par_NumErr,
								Par_ErrMen,			Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							CALL POLIZASAHORROPRO(
								Par_Poliza,         Par_Empresa,    	Par_Fecha,          Var_ClienteID,      Con_Capital,
								Var_CuentaAhoID,    Var_MonedaID,   	Var_InteresRetener, Entero_Cero,        Cue_RetAport,
								Var_CuentaStr,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							IF (Var_MonedaBase != Var_MonedaID) THEN
								SET Var_TipCamCom := (SELECT TipCamComInt FROM MONEDAS WHERE MonedaId = Var_MonedaID);

								SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

								CALL COMVENDIVISAALT(
									Var_MonedaID,   	Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,		Var_TipCamCom,
									Ope_Interna,    	Tip_Compra,         	Var_Instrumento,	Var_RefPagoCed, 		NombreProceso,
									Par_Poliza,   		Par_Empresa, 			Aud_Usuario,  		Aud_FechaActual,        Aud_DireccionIP,
									Aud_ProgramaID,		Var_SucCliente, 		Aud_NumTransaccion);

							ELSE
								SET Var_IntRetMN := Var_InteresRetener;
							END IF;

								/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA APORTACION */
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_Empresa,        Par_Fecha,          Var_IntRetMN,           Cadena_Vacia,
								Var_PagoAport,      Var_ConcepISR,      Entero_Cero,        Nat_Abono,              AltPoliza_NO,
								Mov_AhorroNO,       SalidaNO,           Par_Poliza,         Par_NumErr,             Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaBase,     Aud_Usuario,            Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,     Aud_NumTransaccion  );

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;
						END IF; -- Fin interes retener

                        -- Obtner el numero de cuotas de la aportacion
                        SET @numCuota := (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID= Var_AportacionID);

                        SET @numCuota := IFNULL(@numCuota,Entero_Cero);

                        -- SI LA APORTACION CAPITALIZA INTERES, EL NUMERO DE CUOTAS ES MAYOR A UNO Y NO ES LA ULTIMA CUOTA
                        IF((Var_CapitalizaInt = Cons_SI AND @numCuota > EnteroUno AND Var_AmortizacionID < @numCuota))THEN

                            -- SE OBTIENE EL MONTO A CAPITALIZAR
                            SET Var_MontoCapitaliza := Var_InteresPagar-Var_InteresRetener;
                            SET Var_RefCapitaliza	:= CONVERT(Var_AportacionID, CHAR);

							-- SE HACE EL CARGO A LA CUENTA POR EL MONTO DE CAPITALIZACION
                            CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,    	Aud_NumTransaccion,		Par_Fecha,          Nat_Cargo,			Var_MontoCapitaliza,
								Const_DesCapInteres,	Var_RefCapitaliza,    	Var_MovIntere,		SalidaNO,			Par_NumErr,
								Par_ErrMen,				Par_Empresa,        	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

                            -- se registra la poliza
                            CALL POLIZASAHORROPRO(
								Par_Poliza,         Par_Empresa,    	Par_Fecha,          Var_ClienteID,      Con_Capital,
								Var_CuentaAhoID,    Var_MonedaID,   	Var_MontoCapitaliza,Entero_Cero,        Const_DesCapInteres,
								Var_RefCapitaliza,  SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,		Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							-- SE GENERA LA CONTABILIDAD DE LA APORTACION
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_Empresa,      	Par_Fecha,          Var_MontoCapitaliza,	Cadena_Vacia,
								Var_PagoAport,     	Var_ConcepCapi,		Entero_Cero,        Nat_Abono,				AltPoliza_NO,
								Mov_AhorroNO,       SalidaNO,			Par_Poliza,         Par_NumErr,				Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaBase,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion  );

                            IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

                        END IF; -- FIN CAPITALIZA INTERES

						/* se marca como pagada la amortizacion */
						UPDATE AMORTIZAAPORT Amo SET
									Amo.Estatus     	= Est_Pagado,
									Amo.ISRCal			= Var_InteresRetener, -- Se actualiza el ISR Real que retuvo a la Amortizacion
									EmpresaID       	= Par_Empresa,
									Usuario         	= Aud_Usuario,
									FechaActual     	= Aud_FechaActual,
									DireccionIP     	= Aud_DireccionIP,
									ProgramaID      	= Aud_ProgramaID,
									Sucursal        	= Aud_Sucursal,
									NumTransaccion		= Aud_NumTransaccion
							WHERE 	Amo.AportacionID	= Var_AportacionID
							  AND 	Amo.Estatus         != Est_Pagado
							  AND 	Amo.AmortizacionID	= Var_AmortizacionID;

						/* si se trata del pago de la ultima amortizacion se actualiza el estatus  de la aportacion */
						IF( VarFechaVenAmo = Var_FechaVenAport ) THEN
							UPDATE APORTACIONES SET
									Estatus         = Est_Pagado,
									EmpresaID       = Par_Empresa,
									UsuarioID       = Aud_Usuario,
									FechaActual     = Aud_FechaActual,
									DireccionIP     = Aud_DireccionIP,
									ProgramaID      = Aud_ProgramaID,
									Sucursal        = Aud_Sucursal,
									NumTransaccion  = Aud_NumTransaccion
							WHERE	AportacionID        	= Var_AportacionID;
						ELSE
							UPDATE APORTACIONES SET
									EmpresaID       = Par_Empresa,
									UsuarioID       = Aud_Usuario,
									FechaActual     = Aud_FechaActual,
									DireccionIP     = Aud_DireccionIP,
									ProgramaID      = Aud_ProgramaID,
									Sucursal        = Aud_Sucursal,
									NumTransaccion  = Aud_NumTransaccion
							WHERE	AportacionID   	= Var_AportacionID;
						END IF;

						/*SE ACTUALIZA EL SALDO PROVISION APORTACIONES Y EL ISR REAL*/
						UPDATE APORTACIONES SET
								SaldoProvision	= SaldoProvision - Var_SaldoProvision,
								ISRReal			= ISRReal + Var_InteresRetener
						WHERE   AportacionID 	= Var_AportacionID;

						# ALTA DE LA CUOTAS PAGADAS PARA SER DISPERSADAS.
						CALL APORTDISPPENDPRO(
							Var_AportacionID,	Est_Pagado,			Par_Fecha,			SalidaNO,			Par_NumErr,
							Par_ErrMen,			Par_Empresa,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET Error_Key := 99;
							LEAVE Transaccion;
						END IF;

					END Transaccion;

					SET Var_AportStr := CONVERT(Var_AportacionID, CHAR);
					IF Error_Key = 0 THEN
						/*Contador vencimiento masivo aportaciones*/
						SET ContadorExito:=ContadorExito+1;
						COMMIT;
					END IF;
					IF Error_Key = 1 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoAport,  Par_Fecha,      Var_AportStr,   	'ERROR DE SQL GENERAL',
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoAport,  Par_Fecha,        Var_AportStr,   		'ERROR EN ALTA, LLAVE DUPLICADA',
								Par_Empresa,    Aud_Usuario,      Aud_FechaActual,    	Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoAport,  Par_Fecha,      Var_AportStr,   	'ERROR AL LLAMAR A STORE PROCEDURE',
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoAport,  Par_Fecha,      Var_AportStr,   	'ERROR VALORES NULOS',
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 99 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoAport,  Par_Fecha,      Var_AportStr,   	CONCAT(Par_NumErr,' - ',Par_ErrMen),
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;
				END LOOP CICLOPAGOAPORTCUR;
			END;
		CLOSE PAGOAPORTCUR;

		DELETE FROM TMPPAGOSAPORT
			WHERE NumTransaccion = Aud_NumTransaccion;

		/*Contador vencimiento masivo aportaciones*/
		SET Par_ContadorTotal:=ContadorTotal;
		SET Par_ContadorExito:=ContadorExito;

		DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de Aportaciones Realizado Exitosamente.';

	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
		  SELECT  	Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen;
		END IF;

END TerminaStore$$