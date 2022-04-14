-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEPAGOCIERREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEPAGOCIERREPRO`;
DELIMITER $$


CREATE PROCEDURE `CEDEPAGOCIERREPRO`(
# ============================================================
# ----------- SP QUE REALIZA LOS PAGOS DE LOS CEDES-----------
# ============================================================
    Par_Fecha                   DATE,   		-- Fecha
    Par_TipoRegistro            CHAR(1),		-- Tipo de Registro
    Par_TipoProceso             CHAR(1),    	-- Tipo De Proceso: N.- Cede que no Reinvierten, S .- Cedes que Reinvierten

    Par_Salida                  CHAR(1),    	-- Indica una salida
    INOUT Par_NumErr            INT(11),        -- Numero de Error
    INOUT Par_ErrMen            VARCHAR(400),	-- Mensaje de error

    INOUT Par_ContadorTotal     INT(11),    	-- Contador Total vencimiento masivo cedes
    INOUT Par_ContadorExito     INT(11),    	-- Contador Exito vencimiento masivo cedes

    -- Parametros de Auditoria
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
	DECLARE Var_CederStr        VARCHAR(20);
	DECLARE Var_CedeID          BIGINT(12);
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_TipoCedeID      INT(11);
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
	DECLARE VarFechaVenCede     DATE;
	DECLARE VarFechaVenAmo      DATE;
	DECLARE VarFecVenceAmor     DATE;
	DECLARE VarFecIniciaAmo     DATE;
    DECLARE Var_MontoCede       DECIMAL(14,2);
	DECLARE Var_PagaISR  		CHAR(1);
    DECLARE Var_TasaISR  		DECIMAL(14,2);
    DECLARE Var_ISRReal			DECIMAL(12,2);	-- variable que guardara el valor de isrreal de cada socio
	DECLARE Var_ISR_pSocio		CHAR(1);		-- variable que guaradra el valor de parametrosgenerales si se calcula ISR por socio
    DECLARE Var_FechaISR		DATE;			-- variable fecha de inicio cobro isr por socio
    DECLARE Var_Tasa			DECIMAL(14,4);	-- Valor de la Tasa de la Cede

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
	DECLARE Ren_PagoCeder       INT;
	DECLARE Pol_Automatica      CHAR(1);
	DECLARE Var_PagoCeder       INT;
	DECLARE Var_RefPagoCed      VARCHAR(100);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono           CHAR(1);
	DECLARE Var_ConCedCapi      INT;
	DECLARE Var_ConCedProv      INT;
	DECLARE Var_ConCedISR       INT;
	DECLARE Con_Capital         INT;
	DECLARE Mov_AhorroSI        CHAR(1);
	DECLARE Mov_AhorroNO        CHAR(1);
	DECLARE Cue_PagIntExe       CHAR(50);
	DECLARE Cue_PagIntGra       CHAR(50);
	DECLARE Cue_RetCeder        CHAR(50);
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
	DECLARE ContadorTotal       INT(11);  	-- Contador total vencimiento masivo cedes
	DECLARE ContadorExito       INT(11);  	-- Contador exitoso vencimiento masivo cedes
    DECLARE CalculoISRxCli  	CHAR(1);	-- Constante tipo de calculo por cliente
	DECLARE ISRpSocio			VARCHAR(10);
    DECLARE No_constante		VARCHAR(10);
    DECLARE SI_Isr_Socio    	CHAR(1);
    DECLARE InsCede				INT(11);

	DECLARE PAGOCEDECUR CURSOR FOR
		SELECT  Ced.CedeID,         Ced.CuentaAhoID,        Ced.TipoCedeID,             Ced.MonedaID,       Ced.Capital,
				Ced.Interes,        Ced.InteresRetener,   	Ced.ClienteID,      		Ced.SaldoProvision, Ced.SucursalOrigen,
				Ced.AmortizacionID, Ced.FechaVencimiento,   Ced.FechaPago,              Ced.CalculoInteres, Ce.Monto,
                Ced.FechaIniAmo,	Ced.FechaVenciAmo,		Ced.PagaISR,				Ced.TasaISR,		Ce.ISRReal
			FROM TMPPAGOCEDE Ced INNER JOIN  CEDES Ce ON Ced.CedeID=Ce.CedeID
				WHERE Ced.NumTransaccion = Aud_NumTransaccion;

	-- Asignacion de Contantes
	SET Cadena_Vacia        := '';              -- Constante Cadena Vacia
	SET Fecha_Vacia         := '1900-01-01';    -- Constante Fecha Vacia
	SET Entero_Cero         := 0;               -- Constante Entero Cero
	SET SalidaSI            := 'S';         	-- Salida SI
	SET SalidaNO            := 'N';         	-- Salida NO
    SET Mov_PagCedCap       := '502';        	-- PAGO CEDE. CAPITAL
	SET Mov_PagIntGra       := '503';        	-- PAGO CEDE. INTERES GRAVADO
	SET Mov_PagIntExe       := '504';        	-- PAGO CEDE. INTERES EXCENTO
	SET Mov_PagCedRet       := '505';        	-- PAGO CEDE. RETENCION
	SET Estatus_Vigente     := 'N';        		-- Estatus de la CEDE: Vigente
	SET Est_Pagado          := 'P';         	-- Estatus de la CEDE: Pagada
	SET Ren_PagoCeder       := 1306;         	-- Proceso de Pago de Cede
	SET Pol_Automatica      := 'A';           	-- Poliza: Automatica
	SET Var_PagoCeder       := 902;         	-- Concepto Contable: Pago de CEDE
	SET Var_RefPagoCed      := 'VENCIMIENTO DE CEDE';		-- Descripcion Referencia
	SET Nat_Cargo           := 'C';         	-- Naturaleza de Cargo
	SET Nat_Abono           := 'A';         	-- Naturaleza de Abono
	SET Var_ConCedCapi      := 1;           	-- Concepto Contable de CEDE: Capital
	SET Var_ConCedProv      := 5;           	-- Concepto Contable de CEDE: Provision
	SET Var_ConCedISR       := 4;           	-- Concepto Contable de CEDE: Retencion
	SET Con_Capital         := 1;           	-- Concepto Contable de Ahorro: Capital
	SET Mov_AhorroSI        := 'S';         	-- Movimiento de Ahorro: SI
	SET Mov_AhorroNO        := 'N';         	-- Movimiento de Ahorro: NO
	SET Cue_PagIntExe       := 'INTERESES GENERADOS';			-- Descripcion Interes Excento
	SET Cue_PagIntGra       := 'INTERESES GENERADOS';			-- Descripcion Interes Gravado
	SET Cue_RetCeder        := 'RETENCION ISR';					-- Descripcion Retencion ISR
	SET Tipo_Provision      := '100';       	-- Tipo de Movimiento de CEDE: Provision
	SET NombreProceso       := 'CEDE';			--  Descripcion Nombre Proceso
	SET Ope_Interna         := 'I';        	 	-- Tipo de Operacion: Interna
	SET Tip_Compra          := 'C';         	-- Tipo de Operacion: Compra de Divisa
	SET AltPoliza_NO        := 'N';        	 	-- Alta de la Poliza NO
	SET Tasa_Fija           :=  1;         		-- Tipo de Calculo de Interes Tasa Fija
	SET Pago_NoReinversion  := 'N';     		-- Tipo de Cedes que NO Reinvierten
    SET Pago_SiReinversion  := 'S';     		-- Tipo de Cedes que SI Reinvierten
   	SET InicioMes           := CONVERT(CONCAT(EXTRACT(YEAR_MONTH FROM Par_Fecha),'01'),DATE);       -- Fecha de Inicio del Mes a Trabajar.
	SET Est_Aplicado        :=  'A';
	SET EnteroUno           :=  1;
	SET Aud_FechaActual     := NOW();
	SET CalculoISRxCli      := 'C';         	-- Tipo de Calculo ISR por cliente
    SET ISRpSocio			:= 'ISR_pSocio';  	-- constante para isr por socio de PARAMGENERALES
    SET No_constante		:= 'N';			  	-- constante NO
	SET SI_Isr_Socio		:= 'S';   			-- Si se calcula isr por socio
    SET InsCede				:= 28;				-- Tipo de instrumento cedes.

	ManejoErrores : BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-CEDEPAGOCIERREPRO');
			END;

		DELETE FROM TMPPAGOCEDE
			WHERE NumTransaccion = Aud_NumTransaccion;

		SET Par_TipoProceso := IFNULL(Par_TipoProceso, Pago_NoReinversion);

		SELECT MonedaBaseID,FechaISR INTO Var_MonedaBase,Var_FechaISR
			FROM PARAMETROSSIS WHERE EmpresaID = Par_Empresa;

		SET    Var_MonedaBase := IFNULL(Var_MonedaBase,EnteroUno);


		SELECT ValorParametro INTO Var_ISR_pSocio
			FROM PARAMGENERALES
			WHERE LlaveParametro	= ISRpSocio;
		SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , No_constante);
		SET Var_FechaISR	:= IFNULL(Var_FechaISR,Par_Fecha);

		-- CONSIDERACION SI AL VENCIMIENTO SE PAGAN LAS QUE SE REINVIERTEN O NO
		IF (Par_TipoProceso = Pago_NoReinversion) THEN
			INSERT INTO `TMPPAGOCEDE`	(
						`NumTransaccion`,				`CedeID`,					`CuentaAhoID`,					`TipoCedeID`,				`MonedaID`,
						`Capital`,						`Interes`,					`InteresRetener`,				`ClienteID`,				`SaldoProvision`,
						`SucursalOrigen`,				`AmortizacionID`,			`FechaVencimiento`,				`FechaPago`,				`CalculoInteres`,
						`FechaIniAmo`,					`FechaVenciAmo`,			`PagaISR`,						`TasaISR`)
				SELECT  Aud_NumTransaccion, 		Ced.CedeID,             	MAX(Ced.CuentaAhoID),   	MAX(Ced.TipoCedeID),    MAX(Ced.MonedaID),
						MAX(Amo.Capital),   		MAX(Amo.Interes),       	MAX(Amo.ISRCal),     		Ced.ClienteID,          MAX(Amo.SaldoProvision),
						MAX(cte.SucursalOrigen),	MAX(Amo.AmortizacionID),	MAX(Ced.FechaVencimiento),  MAX(Amo.FechaPago),     MAX(Ced.CalculoInteres),
						MAX(Amo.FechaInicio),		MAX(Amo.FechaVencimiento),	MAX(cte.PagaISR),			MAX(Ced.TasaISR)
					FROM 	CEDES Ced
							INNER JOIN  AMORTIZACEDES Amo ON  Ced.CedeID 		= Amo.CedeID
														  AND Amo.Estatus 		= Estatus_Vigente
														  AND Amo.FechaPago 	<= Par_Fecha
														  AND (Ced.Reinversion 	= Pago_NoReinversion
														  OR  ( Ced.Reinversion = Pago_SiReinversion
														  AND Ced.FechaPago != Amo.FechaPago) )
							INNER JOIN CLIENTES cte ON Ced.ClienteID = cte.ClienteID
					WHERE 	Ced.Estatus = Estatus_Vigente
					GROUP BY Ced.ClienteID,Ced.CedeID;

		ELSE  -- Pago de las que si Reinversion.

			INSERT INTO `TMPPAGOCEDE`	(
						`NumTransaccion`,				`CedeID`,					`CuentaAhoID`,					`TipoCedeID`,				`MonedaID`,
						`Capital`,						`Interes`,					`InteresRetener`,				`ClienteID`,				`SaldoProvision`,
						`SucursalOrigen`,				`AmortizacionID`,			`FechaVencimiento`,				`FechaPago`,				`CalculoInteres`,
						`FechaIniAmo`,					`FechaVenciAmo`,			`PagaISR`,						`TasaISR`)
				SELECT  Aud_NumTransaccion, 		Ced.CedeID,             	MAX(Ced.CuentaAhoID),       MAX(Ced.TipoCedeID),	MAX(Ced.MonedaID),
						MAX(Amo.Capital),        	MAX(Amo.Interes),           MAX(Amo.ISRCal),     		Ced.ClienteID,          MAX(Amo.SaldoProvision),
						MAX(cte.SucursalOrigen), 	MAX(Amo.AmortizacionID),    MAX(Ced.FechaVencimiento),	MAX(Amo.FechaPago),     MAX(Ced.CalculoInteres),
						MAX(Amo.FechaInicio),		MAX(Amo.FechaVencimiento),	MAX(cte.PagaISR),			MAX(Ced.TasaISR)
					FROM 	CEDES Ced
							INNER JOIN  AMORTIZACEDES Amo ON  Ced.CedeID 		= Amo.CedeID
														  AND Ced.FechaPago		= Amo.FechaPago
														  AND Amo.Estatus 		= Estatus_Vigente
														  AND Ced.FechaPago 	= Par_Fecha
														  AND Ced.Reinversion 	= Pago_SiReinversion
							INNER JOIN CEDESANCLAJE anc ON Ced.CedeID = anc.CedeAncID
							INNER JOIN CLIENTES cte ON Ced.ClienteID = cte.ClienteID
					WHERE 	Ced.Estatus = Estatus_Vigente
					GROUP BY Ced.ClienteID, Ced.CedeID;
		END IF;

		SELECT  COUNT(Ced.CedeID) INTO Var_NumeroVenc
			FROM 	TMPPAGOCEDE        Ced
			WHERE 	NumTransaccion = Aud_NumTransaccion;

		SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);


		IF(Var_NumeroVenc > Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,         Par_Empresa,        Par_Fecha,      Pol_Automatica,     Var_PagoCeder,
				Var_RefPagoCed,     SalidaNO,           Par_NumErr,     Par_ErrMen,         Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion  );
			IF(Par_NumErr != Entero_Cero) THEN /* SI SURGIO UN ERROR SE SALE DEL SP*/
				LEAVE ManejoErrores;
			END IF;
		END IF;

	-- =============================================================================================================
		IF(Var_NumeroVenc > Entero_Cero) THEN

		-- ============================== ISR POR CLIENTE ======================================================

			DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion ;

			INSERT INTO CTESVENCIMIENTOS(
					Fecha,              ClienteID,      EmpresaID,      UsuarioID,      FechaActual,
					DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
			SELECT  Par_Fecha,          cede.ClienteID, Par_Empresa,    Aud_Usuario,    Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
				FROM TMPPAGOCEDE cede
				GROUP BY cede.ClienteID;

			CALL CALCULOISRPRO(
					Par_Fecha,          Par_Fecha,      EnteroUno,		Par_TipoRegistro,   SalidaNO,
					Par_NumErr,         Par_ErrMen,     Par_Empresa,    Aud_Usuario,        Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

             IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
			 END IF;

 		-- ==============================FIN ISR POR CLIENTE======================================================

		END IF;
		-- =============================================================================================================
		/*Contador vencimiento masivo cedes*/
		SET ContadorTotal:=0;
		SET ContadorExito:=0;

		/*SE HABRE CURSOR PARA PAGAR LAS CEDES QUE NO SE RENOVAN DE MANERA AUTOMATICA */
		OPEN PAGOCEDECUR;

			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOPAGOCEDECUR:LOOP

					FETCH PAGOCEDECUR INTO
					Var_CedeID,             Var_CuentaAhoID,    Var_TipoCedeID,     Var_MonedaID,       Var_Monto,
					Var_InteresGenerado,    Var_InteresRetener, Var_ClienteID,      Var_SaldoProvision, Var_SucCliente,
					Var_AmortizacionID,     VarFechaVenCede,    VarFechaVenAmo,     Var_CalculoInteres,	Var_MontoCede,
                    VarFecIniciaAmo,		VarFecVenceAmor,	Var_PagaISR,		Var_TasaISR,		Var_ISRReal;

					START TRANSACTION;
					Transaccion:BEGIN

						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
						DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

						SET Aud_FechaActual     := NOW();
						SET Var_InteresPagar    := Entero_Cero;


						/*Contador vencimiento masivo cedes*/
						SET ContadorTotal:=ContadorTotal+1;
						IF(Var_Monto > Entero_Cero) THEN
							/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA CEDE */
							CALL CONTACEDESPRO(
								Var_CedeID,         Par_Empresa,        Par_Fecha,          Var_Monto,      Mov_PagCedCap,
								Var_PagoCeder,      Var_ConCedCapi,     Con_Capital,        Nat_Abono,      AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,           Par_Poliza,         Par_NumErr,     Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,       Aud_Usuario,    Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,     Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero) THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

						END IF;

					/* Se obtiene el Interes a Retener*/
     					SET Var_InteresRetener:=FNTOTALISRCTE(Var_ClienteID,InsCede,Var_CedeID);

						IF (Var_InteresRetener = Entero_Cero) THEN
							SET Var_MovIntere := Mov_PagIntExe;
							SET Cue_PagIntere := Cue_PagIntExe;
						ELSE
							SET Var_MovIntere := Mov_PagIntGra;
							SET Cue_PagIntere := Cue_PagIntGra;
						END IF;

						-- Verificamos si el Interes de Pagare en Tasa Fija o el Saldo de Provision de Tasa Variable
						IF(Var_CalculoInteres = Tasa_Fija) THEN
							-- SET Var_InteresPagar = Var_InteresGenerado;
							SET Var_InteresPagar := Var_SaldoProvision;
						ELSE
							SET Var_InteresPagar := Var_SaldoProvision;
						END IF;
						IF (Var_InteresPagar > Entero_Cero) THEN
							/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA CEDE */
							CALL CONTACEDESPRO(
								Var_CedeID,         Par_Empresa,        Par_Fecha,          Var_InteresPagar,   Var_MovIntere,
								Var_PagoCeder,      Var_ConCedProv,     Con_Capital,        Nat_Abono,              AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,           Par_Poliza,         Par_NumErr,             Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,       Aud_Usuario,            Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,     Aud_NumTransaccion  );

								IF(Par_NumErr != Entero_Cero) THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

							CALL CEDESMOVALT(
								Var_CedeID,         Par_Fecha,          Tipo_Provision,     Var_InteresPagar,       Nat_Abono,
								Cue_PagIntere,      Var_MonedaID,       SalidaNO,           Par_NumErr,             Par_ErrMen,
								Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,
								Aud_Sucursal,       Aud_NumTransaccion  );

								IF(Par_NumErr != Entero_Cero) THEN
									SET Error_Key := 99;
									LEAVE Transaccion;
								END IF;

							 SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);
							 SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

							 SET Var_Tasa	:=(SELECT TasaFija FROM CEDES WHERE CedeID = Var_CedeID);
							 SET Var_Tasa	:=IFNULL(Var_Tasa,Entero_Cero);

							-- Registro de informacion para el Calculo del Interes Real para Cedes
							CALL CALCULOINTERESREALALT (
								 Var_ClienteID,			Par_Fecha,			InsCede,			Var_CedeID,			Var_MontoCede,
								 Var_InteresPagar,		Var_InteresRetener,	Var_Tasa,			VarFecIniciaAmo,	VarFecVenceAmor,
                                 Par_Empresa,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
                                 Aud_Sucursal,			Aud_NumTransaccion);

						END IF;
						-- Retencion

						IF (Var_InteresRetener > Entero_Cero) THEN
							 SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);
							 SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

							CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,    Aud_NumTransaccion, Par_Fecha,          Nat_Cargo,			Var_InteresRetener,
								Cue_RetCeder,   	Var_Instrumento,    Mov_PagCedRet,		SalidaNO,			Par_NumErr,
								Par_ErrMen,			Par_Empresa,        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							CALL POLIZASAHORROPRO(
								Par_Poliza,         Par_Empresa,    	Par_Fecha,          Var_ClienteID,      Con_Capital,
								Var_CuentaAhoID,    Var_MonedaID,   	Var_InteresRetener, Entero_Cero,        Cue_RetCeder,
								Var_CuentaStr,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;

							IF (Var_MonedaBase != Var_MonedaID) THEN

								SELECT TipCamComInt INTO Var_TipCamCom
									FROM MONEDAS
									WHERE MonedaId = Var_MonedaID;

								SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

								CALL COMVENDIVISAALT(
									Var_MonedaID,   	Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,		Var_TipCamCom,
									Ope_Interna,    	Tip_Compra,         	Var_Instrumento,	Var_RefPagoCed, 		NombreProceso,
									Par_Poliza,   		Par_Empresa, 			Aud_Usuario,  		Aud_FechaActual,        Aud_DireccionIP,
                                    Aud_ProgramaID,		Var_SucCliente, 		Aud_NumTransaccion);

							ELSE
								SET Var_IntRetMN := Var_InteresRetener;
							END IF;

								/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA CEDE */
							CALL CONTACEDESPRO(
								Var_CedeID,         Par_Empresa,        Par_Fecha,          Var_IntRetMN,           Cadena_Vacia,
								Var_PagoCeder,      Var_ConCedISR,      Entero_Cero,        Nat_Abono,              AltPoliza_NO,
								Mov_AhorroNO,       SalidaNO,           Par_Poliza,         Par_NumErr,             Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaBase,     Aud_Usuario,            Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,     Var_SucCliente,     Aud_NumTransaccion  );

							IF(Par_NumErr != Entero_Cero) THEN
								SET Error_Key := 99;
								LEAVE Transaccion;
							END IF;
						END IF;
						/* se marca como pagada la amortizacion */
						UPDATE AMORTIZACEDES Amo SET
									Amo.Estatus     	= Est_Pagado,
                                    Amo.ISRCal			= Var_InteresRetener, -- Se actualiza el ISR Real que retuvo a la Amortizacion
									EmpresaID       	= Par_Empresa,
									Usuario         	= Aud_Usuario,
									FechaActual     	= Aud_FechaActual,
									DireccionIP     	= Aud_DireccionIP,
									ProgramaID      	= Aud_ProgramaID,
									Sucursal        	= Aud_Sucursal,
									NumTransaccion		= Aud_NumTransaccion
							WHERE 	Amo.CedeID       	= Var_CedeID
							  AND 	Amo.Estatus         != Est_Pagado
							  AND 	Amo.AmortizacionID	= Var_AmortizacionID;

						/* si se trata del pago de la ultima amortizacion se actualiza el estatus  de la cede */
						IF( VarFechaVenAmo = VarFechaVenCede ) THEN
							UPDATE CEDES SET
									Estatus         = Est_Pagado,
									EmpresaID       = Par_Empresa,
									UsuarioID       = Aud_Usuario,
									FechaActual     = Aud_FechaActual,
									DireccionIP     = Aud_DireccionIP,
									ProgramaID      = Aud_ProgramaID,
									Sucursal        = Aud_Sucursal,
									NumTransaccion  = Aud_NumTransaccion
							WHERE	CedeID        	= Var_CedeID;
						END IF;
						/*SE ACTUALIZA EL SALDO PROVISION CEDES Y EL ISR REAL*/
						UPDATE CEDES SET
								SaldoProvision	= SaldoProvision - Var_SaldoProvision,
                                ISRReal			= ISRReal + Var_InteresRetener
						WHERE   CedeID 			= Var_CedeID;

 		-- ============================== ACTUALIZA EL COBROISR ======================================================
					UPDATE COBROISR isr
							SET Estatus = Est_Aplicado
						WHERE ClienteID 	= Var_ClienteID
                        AND ProductoID 		= Var_CedeID
						AND InstrumentoID 	= InsCede;
		-- ==============================          FIN           ======================================================

					 END Transaccion;

					SET Var_CederStr := CONVERT(Var_CedeID, CHAR);
					IF Error_Key = 0 THEN
						/*Contador vencimiento masivo cedes*/
						SET ContadorExito:=ContadorExito+1;
						COMMIT;
					END IF;
					IF Error_Key = 1 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoCeder,  Par_Fecha,      Var_CederStr,   	'ERROR DE SQL GENERAL',
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoCeder,  Par_Fecha,        Var_CederStr,   		'ERROR EN ALTA, LLAVE DUPLICADA',
								Par_Empresa,    Aud_Usuario,      Aud_FechaActual,    	Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,     Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoCeder,  Par_Fecha,      Var_CederStr,   	'ERROR AL LLAMAR A STORE PROCEDURE',
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoCeder,  Par_Fecha,      Var_CederStr,   	'ERROR VALORES NULOS',
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 99 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_PagoCeder,  Par_Fecha,      Var_CederStr,   	CONCAT(Par_NumErr,' - ',Par_ErrMen),
								Par_Empresa,    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
						COMMIT;
					END IF;
				END LOOP CICLOPAGOCEDECUR;
			END;
		CLOSE PAGOCEDECUR;

		DELETE FROM TMPPAGOCEDE
			WHERE NumTransaccion = Aud_NumTransaccion;

		/*Contador vencimiento masivo cedes*/
		SET Par_ContadorTotal:=ContadorTotal;
		SET Par_ContadorExito:=ContadorExito;

		DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:= 'Pago de CEDES Realizados Exitosamente.';

	END ManejoErrores;
		IF (Par_Salida = SalidaSI) THEN
		  SELECT  	Par_NumErr  AS NumErr,
					Par_ErrMen  AS ErrMen;
		END IF;
END TerminaStore$$
