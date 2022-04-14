

-- APORTPAGOVENANTPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTPAGOVENANTPRO`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTPAGOVENANTPRO`(
# =========================================================================
# ----- SP PARA REALIZAR LOS PAGOS DE APORTACIONES POR VENCIMIENTO ANTICIPADO-----
# =========================================================================
	Par_AportacionID	INT(11),		-- Numero de Aportación
	Par_ClienteID		INT(11),		-- Numero de Cliente
	Par_Fecha			DATE,			-- Fecha
	Par_Poliza			BIGINT(20),		-- Numero de Poliza
	Par_Salida          CHAR(1),		-- Indica si espera un SELECT de salida

	INOUT Par_NumErr    INT(11),		-- Numero de error
	INOUT Par_ErrMen    VARCHAR(400),	-- Descripcion de error
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variable
	DECLARE Var_AportacionID	BIGINT;
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_TipoAportID		INT(11);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_Monto           DECIMAL(14,2);
	DECLARE Var_MontoExcento    DECIMAL(14,2);
	DECLARE Var_InteresGenerado DECIMAL(14,2);
	DECLARE Var_InteresRetener  DECIMAL(14,2);
	DECLARE Var_ClienteID       BIGINT;
	DECLARE Var_SaldoProvision  DECIMAL(14,2);
	DECLARE Var_SucCliente      INT(11);
	DECLARE Var_CalculoInteres	INT(11);
	DECLARE Var_InteresPagar  	DECIMAL(14,2);
	DECLARE Var_TasaISR			DECIMAL(18, 2);		-- Tasa ISR
	DECLARE Var_PagaISR			CHAR(1);			-- Si paga ISR
	DECLARE Var_NumeroVenc		INT(11);
	DECLARE Var_MovIntere		VARCHAR(4);
	DECLARE Cue_PagIntere		CHAR(50);
	DECLARE Var_Instrumento		VARCHAR(15);
	DECLARE Var_CuentaStr		VARCHAR(15);
	DECLARE Var_MonedaBase		INT(11);
	DECLARE Var_AmortizacionID	INT(11);
	DECLARE Var_TipCamCom		DECIMAL(14,6);
	DECLARE Var_IntRetMN		DECIMAL(14,2);
	DECLARE Var_FechaVenAnt     DATE;
	DECLARE Var_FechaIniciAmor  DATE;
	DECLARE VarFechaVenAport	DATE;
	DECLARE VarFechaVenAmo		DATE;
	DECLARE SalMinAnuDF			DECIMAL(12,2);
	DECLARE Var_SalMinDF		DECIMAL(12,2);
	DECLARE Var_ISR_pSocio		CHAR(1);			-- si se calcula por socio el ISR
	DECLARE Var_FechaISR		DATE;				-- variable fecha de inicio cobro isr por socio
	DECLARE Var_FechaFinAmor	DATE;				-- variable de la inversion inicial
	DECLARE Var_ISRReal 		DECIMAL(14,2); 		-- variable que guarda el ISR REAL
	DECLARE Var_Tasa			DECIMAL(14,4);		-- Valor de la Tasa de la aportacion
	DECLARE Var_DiasInversion	INT(11);
	DECLARE Var_MontoAport      DECIMAL(14,2);
    DECLARE Var_CapitalizaInt	CHAR(1);			-- Indica si la aportacion capitaliza interes
    DECLARE Var_MontoCapitaliza	DECIMAL(14,2);		-- Guarda el monto de la capitalizacion
    DECLARE Var_RefCapitaliza	VARCHAR(20);		-- Guarda la referencia para el movimiento de capitalizacion
    DECLARE Error_Key           INT DEFAULT 0;		-- Almacena los posibles errores en el cursor
    DECLARE Var_AportStr        VARCHAR(15);		-- Numero de la aportacion para procesos batch
	DECLARE Var_SaldoCapCuota   DECIMAL(14,2);		-- Saldo provisionado de la cuota



	-- Declaracion de Contantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Estatus_Vigente 	CHAR(1);
	DECLARE Est_Pagado  		CHAR(1);
	DECLARE Rei_NO				CHAR(2);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Var_PagoAportr		INT(11);
	DECLARE Var_RefPagoCed		VARCHAR(100);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Var_ConcepCapi		INT(11);
	DECLARE Var_ConcepProv		INT(11);
	DECLARE Var_ConcepISR   	INT(11);
	DECLARE Con_Capital     	INT(11);
	DECLARE Mov_AhorroSI    	CHAR(1);
	DECLARE Mov_AhorroNO    	CHAR(1);
	DECLARE Cue_PagIntExe   	CHAR(50);
	DECLARE Cue_PagIntGra   	CHAR(50);
	DECLARE Cue_RetAportr    	CHAR(50);
	DECLARE Tipo_Provision		CHAR(4);
	DECLARE NombreProceso		VARCHAR(20);
	DECLARE Ope_Interna			CHAR(1);
	DECLARE Tip_Compra			CHAR(1);
	DECLARE AltPoliza_NO		CHAR(1);
	DECLARE Tasa_Fija    		INT(11);
	DECLARE InstAport			INT(11);
	DECLARE Con360				INT(11);
	DECLARE ConCien				INT(11);
	DECLARE ConCinco			INT(11);
	DECLARE Est_Aplicado		CHAR(1);
	DECLARE Est_Calculado		CHAR(1);
	DECLARE Est_Pendiente		CHAR(1);
	DECLARE ProcesoPantalla		CHAR(1);
	DECLARE EnteroUno			INT(1);
	DECLARE Mov_PagCedCap       VARCHAR(4);
	DECLARE Mov_PagIntExe       VARCHAR(4);
	DECLARE Mov_PagIntGra       VARCHAR(4);
	DECLARE Mov_PagCedRet       VARCHAR(4);
	DECLARE Cons_SI  			CHAR(1);
	DECLARE ISRpSocio			VARCHAR(10);	-- ISR del socio
	DECLARE No_constante		VARCHAR(10);	-- constante NO
	DECLARE SI_Isr_Socio 		CHAR(1);
	DECLARE ValorUMA			VARCHAR(15);
    DECLARE Const_DesCapInteres	VARCHAR(50);
    DECLARE Pro_CieDiaAport   	INT(11);
    DECLARE ErrorSQL        	VARCHAR(100);
	DECLARE ErrorAlta       	VARCHAR(100);
	DECLARE ErrorLlamada    	VARCHAR(100);
	DECLARE ErrorValorNulo 		VARCHAR(100);

	DECLARE PAGOAPORTCUR CURSOR FOR
		SELECT	AP.AportacionID,			MAX(AP.CuentaAhoID),    	MAX(AP.TipoAportacionID),	MAX(AP.MonedaID),		MAX(AP.Monto),
				MAX(Amo.Interes),			MAX(Amo.SaldoISR+Amo.SaldoIsrAcum), AP.ClienteID,		MAX(AP.SaldoProvision),	MAX(cte.SucursalOrigen),
				MIN(Amo.AmortizacionID),	MAX(AP.FechaVencimiento),	MAX(Amo.FechaPago),			MAX(AP.CalculoInteres),	MIN(Amo.FechaInicio),
				MIN(Amo.FechaVencimiento),	MAX(AP.PagoIntCapitaliza)
			FROM 	TMPVENCANTAPORT AP
					INNER JOIN  AMORTIZAAPORT Amo ON  AP.AportacionID = Amo.AportacionID AND Amo.Estatus = Estatus_Vigente
					INNER JOIN CLIENTES cte ON AP.ClienteID = cte.ClienteID
			WHERE	AP.Estatus 		= Estatus_Vigente
			AND		AP.NumTransaccion 	= Aud_NumTransaccion
			GROUP BY AP.ClienteID,AP.AportacionID;

	-- Asignacion de Contantes
	SET Cadena_Vacia    		:= '';						-- Constante Cadena Vacia
	SET Fecha_Vacia     		:= '1900-01-01';   		 	-- Constante Fecha Vacia
	SET Entero_Cero     		:= 0;						-- Constante Entero Cero
	SET	Decimal_Cero			:= 0.00;					-- valor para settear el valor de cero con decimales
	SET Estatus_Vigente 		:= 'N';        				-- Estatus de la APORTACION: Vigente
	SET Est_Pagado				:= 'P';        				-- Estatus de la APORTACION: Pagada
	SET Rei_NO          		:= 'N';        				-- NO Reinvertir
	SET Pol_Automatica  		:= 'A'; 					-- Poliza: Automatica
	SET Var_PagoAportr   		:= 911;						-- Concepto Contable: Pago de APORTACION
	SET Var_RefPagoCed  		:= 'VENCIMIENTO ANTICIPADO DE APORTACION';	-- Descripcion Referencia
	SET Nat_Cargo      			:= 'C';        				-- Naturaleza de Cargo
	SET Nat_Abono      			:= 'A';        				-- Naturaleza de Abono
	SET SalidaNO        		:= 'N';        				-- Salida NO
	SET SalidaSI        		:= 'S';        				-- Salida SI
	SET Var_ConcepCapi  		:= 1;          				-- Concepto Contable de APORTACION: Capital
	SET Var_ConcepProv  		:= 5;          				-- Concepto Contable de APORTACION: Provision
	SET Var_ConcepISR   		:= 4;          				-- Concepto Contable de APORTACION: Retencion
	SET Con_Capital     		:= 1;          				-- Concepto Contable de Ahorro: Capital
	SET Mov_AhorroSI    		:= 'S';        				-- Movimiento de Ahorro: SI
	SET Mov_AhorroNO    		:= 'N';        				-- Movimiento de Ahorro: NO
	SET Cue_PagIntExe   		:= 'INTERES EXCENTO';		-- Descripcion Interes Excento
	SET Cue_PagIntGra   		:= 'INTERESES GRAVADO';		-- Descripcion Interes Gravado
	SET Cue_RetAportr   		:= 'RETENCION ISR';			-- Descripcion Retencion ISR
	SET Tipo_Provision 			:= '100';      				-- Tipo de Movimiento de APORTACION: Provision
	SET NombreProceso   		:= 'APORTACION';					-- Descripcion Nombre Proceso
	SET Ope_Interna    			:= 'I';        				-- Tipo de Operacion: Interna
	SET Tip_Compra      		:= 'C';        				-- Tipo de Operacion: Compra de Divisa
	SET AltPoliza_NO    		:= 'N';        				-- Alta de la Poliza NO
	SET Tasa_Fija				:=  1;						-- Tipo de Calculo de Interes Tasa Fija
	SET InstAport				:=	31;						-- Tipo de instrumento aportaciones.
	SET Con360					:=	360;
	SET ConCien					:=	100;
	SET ConCinco				:=	5;
	SET Est_Aplicado			:=	'A';
	SET Est_Calculado			:=	'C';
	SET Est_Pendiente			:=	'P';
	SET ProcesoPantalla			:=	'P';
	SET EnteroUno				:=	1;
	SET Mov_PagCedCap   		:= '609';      				-- VENCIMIENTO ANTICIPADO APORTACIONES
	SET Mov_PagIntExe   		:= '604';      				-- PAGO APORTACION. INTERES EXCENTO
	SET Mov_PagIntGra   		:= '603';      				-- PAGO APORTACION. INTERES GRAVADO
	SET Mov_PagCedRet   		:= '605';      				-- PAGO APORTACION. RETENCION
	SET Cons_SI  				:= 'S';        				-- Constante SI
	SET ISRpSocio				:= 'ISR_pSocio';			-- constante para isr por socio de PARAMGENERALES
	SET No_constante			:= 'N';						-- constante NO
	SET SI_Isr_Socio			:= 'S';						-- Constante para saber si se calcula el ISR por socio
	SET Aud_FechaActual			:= NOW();
	SET Var_FechaVenAnt 		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FechaVenAnt 		:= IFNULL(Var_FechaVenAnt,Fecha_Vacia);
	SET ValorUMA				:= 'ValorUMABase';
    SET Const_DesCapInteres		:= 'CAPITALIZACION INTERES'; -- Descripcion del movimiento de capitalizacion de interes
    SET Pro_CieDiaAport   		:= 1520;                     -- Proceso Batch
    SET ErrorSQL        		:= 'ERROR DE SQL GENERAL';          -- Manejo de errores
	SET ErrorAlta       		:= 'ERROR EN ALTA, LLAVE DUPLICADA';-- Manejo de errores
	SET ErrorLlamada    		:= 'ERROR AL LLAMAR A STORE PROCEDURE'; -- Manejo de errores
	SET ErrorValorNulo 			:= 'ERROR VALORES NULOS';           -- Manejo de errores

	ManejoErrores : BEGIN

	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-APORTPAGOVENANTPRO');
		END;
        SELECT  COUNT(Ap.AportacionID) INTO Var_NumeroVenc
			FROM	TMPVENCANTAPORT	Ap,
					AMORTIZAAPORT		Amo,
					CLIENTES			Cli
			WHERE 	Ap.Estatus		= Estatus_Vigente
			AND 	Amo.Estatus		= Estatus_Vigente
			AND 	Ap.AportacionID	= Amo.AportacionID
			AND 	Ap.ClienteID	= Cli.ClienteID;

		SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);


		IF(Var_NumeroVenc > Entero_Cero AND Par_Poliza = Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,     	Par_EmpresaID,  	Par_Fecha,      	Pol_Automatica,     Var_PagoAportr,
				Var_RefPagoCed, 	SalidaNO,       	Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

		   IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT
			MonedaBaseID,	SalMinDF
		INTO
			Var_MonedaBase,	Var_SalMinDF
		FROM PARAMETROSSIS;

		SELECT 	Suc.TasaISR, 	Cli.PagaISR
				INTO 	Var_TasaISR, 	Var_PagaISR
				FROM	CLIENTES Cli,
						SUCURSALES Suc
				WHERE 	Cli.ClienteID	= Par_ClienteID
                AND 	Suc.SucursalID	= Cli.SucursalOrigen;

        /*SE HABRE CURSOR PARA PAGAR LAS CEDES QUE NO SE RENOVAN DE MANERA AUTOMATICA */
		OPEN PAGOAPORTCUR;

			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH PAGOAPORTCUR INTO
						Var_AportacionID,		Var_CuentaAhoID,    Var_TipoAportID,	Var_MonedaID,   	Var_Monto,
						Var_InteresGenerado,    Var_InteresRetener, Var_ClienteID,		Var_SaldoProvision,	Var_SucCliente,
						Var_AmortizacionID,		VarFechaVenAport,	VarFechaVenAmo,		Var_CalculoInteres,	Var_FechaIniciAmor,
	                    Var_FechaFinAmor,		Var_CapitalizaInt;

					START TRANSACTION;
					ErrorCursor:BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION     SET Error_Key = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;
						DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;

                        SET Aud_FechaActual	:= NOW();
						SET Var_InteresPagar := Entero_Cero;
                        SET Var_AportStr    := Cadena_Vacia;
                        SET Error_Key       := Entero_Cero;

                        -- VALIDACIONES PARA EL MONTO A PAGAR EN CASO DE SER UNA APORTACION
						-- QUE CAPITALIZA INTERES
                        IF(Var_CapitalizaInt=Cons_SI)THEN
							SET Var_SaldoCapCuota := (SELECT SaldoCap
														FROM AMORTIZAAPORT
														WHERE AportacionID = Var_AportacionID
														AND AmortizacionID = Var_AmortizacionID);
							SET Var_SaldoCapCuota := IFNULL(Var_SaldoCapCuota,Decimal_Cero);

							SET Var_Monto := Var_SaldoCapCuota;
						END IF;

						IF(Var_Monto > Entero_Cero) THEN
							-- SE GENERA LA CONTABILIDAD DEL PAGO DE LA APORTACION
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_EmpresaID,      Par_Fecha,        	Var_Monto,      	Mov_PagCedCap,
								Var_PagoAportr,     Var_ConcepCapi,     Con_Capital,        Nat_Abono,      	AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,			Par_Poliza,         Par_NumErr,			Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaID,		Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion);

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Error_Key  := 99;
								LEAVE ErrorCursor;
							END IF;
						END IF;

						IF (Var_InteresRetener = Decimal_Cero) THEN
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

                        -- Interes a pagar de la aportacion
                        IF (Var_InteresPagar > Entero_Cero) THEN
							-- SE GENERA LA CONTABILIDAD DEL PAGO DE LA APORTACION
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_EmpresaID,      Par_Fecha,          Var_InteresPagar,		Var_MovIntere,
								Var_PagoAportr,     Var_ConcepProv,     Con_Capital,        Nat_Abono,				AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,			Par_Poliza,         Par_NumErr,				Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaID,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion);

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Error_Key  := 99;
								LEAVE ErrorCursor;
							END IF;

							CALL APORTMOVALT(
								Var_AportacionID,	Par_Fecha,      	Tipo_Provision,		Var_InteresPagar,		Nat_Abono,
								Cue_PagIntere,		Var_MonedaID,   	SalidaNO,			Par_NumErr,				Par_ErrMen,
								Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,
								Aud_Sucursal,		Aud_NumTransaccion  );

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Error_Key  := 99;
								LEAVE ErrorCursor;
							END IF;

							SET Var_Instrumento := CONVERT(Var_AportacionID, CHAR);

							SET Var_CuentaStr 	:= CONVERT(Var_CuentaAhoID, CHAR);

							-- Se obtiene el Monto de la CEDE
							SET Var_MontoAport 	:= (SELECT Monto FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
							SET Var_MontoAport	:= IFNULL(Var_MontoAport,Decimal_Cero);

							SET Var_Tasa	:=(SELECT TasaFija FROM APORTACIONES WHERE AportacionID = Var_AportacionID);
							SET Var_Tasa	:=IFNULL(Var_Tasa,Decimal_Cero);

							-- Registro de informacion para el Calculo del Interes Real para Cedes
							CALL CALCULOINTERESREALALT (
								 Var_ClienteID,			Par_Fecha,				InstAport,				Var_AportacionID,		Var_MontoAport,
								 Var_InteresPagar,		Var_InteresRetener,		Var_Tasa,				Var_FechaIniciAmor,		Var_FechaFinAmor,
                                 Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,   		Aud_DireccionIP,		Aud_ProgramaID,
                                 Aud_Sucursal,			Aud_NumTransaccion);

						END IF; -- Fin Interes a Pagar

                        -- Interes a retener de la aportacion
                        IF (Var_InteresRetener > Decimal_Cero) THEN
							CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,    	Aud_NumTransaccion,		Par_Fecha,          Nat_Cargo,			Var_InteresRetener,
								Cue_RetAportr,			Var_Instrumento,    	Mov_PagCedRet,		SalidaNO,			Par_NumErr,
								Par_ErrMen,				Par_EmpresaID,        	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Error_Key  := 99;
								LEAVE ErrorCursor;
							END IF;

							CALL POLIZASAHORROPRO(
								Par_Poliza,         Par_EmpresaID,    	Par_Fecha,          Var_ClienteID,      Con_Capital,
								Var_CuentaAhoID,    Var_MonedaID,   	Var_InteresRetener,	Entero_Cero,        Cue_RetAportr,
								Var_CuentaStr,      SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,		Aud_NumTransaccion);

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Error_Key  := 99;
								LEAVE ErrorCursor;
							END IF;

							IF (Var_MonedaBase != Var_MonedaID) THEN

								SELECT TipCamComInt INTO Var_TipCamCom
									FROM MONEDAS
									WHERE MonedaId = Var_MonedaID;

								SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

								CALL COMVENDIVISAALT(
									Var_MonedaID,   Aud_NumTransaccion,     Par_Fecha,          Var_InteresRetener,		Var_TipCamCom,
									Ope_Interna,    Tip_Compra,         	Var_Instrumento,	Var_RefPagoCed, 		NombreProceso,
									Par_Poliza,     Par_EmpresaID, 			Aud_Usuario,  		Aud_FechaActual,        Aud_DireccionIP,
                                    Aud_ProgramaID,	Var_SucCliente,			Aud_NumTransaccion);

							ELSE
								SET Var_IntRetMN := Var_InteresRetener;
							END IF;

							-- SE GENERA LA CONTABILIDAD DEL PAGO DE LA APORTACION
							CALL CONTAAPORTPRO(
								Var_AportacionID,	Par_EmpresaID,      Par_Fecha,          Var_IntRetMN,			Cadena_Vacia,
								Var_PagoAportr,     Var_ConcepISR,		Entero_Cero,        Nat_Abono,				AltPoliza_NO,
								Mov_AhorroNO,       SalidaNO,			Par_Poliza,         Par_NumErr,				Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaBase,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion  );

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Error_Key  := 99;
								LEAVE ErrorCursor;
							END IF;
						END IF; -- Fin Interes a Retener

                        -- Actualizamos el ISR que le retuvo a la Ultima Amortizacion
                        UPDATE AMORTIZAAPORT Amo SET
							Amo.ISRCal			= Var_InteresRetener -- Se actualiza el ISR Real que retuvo a la Amortizacion
						 WHERE Amo.AportacionID     = Var_AportacionID
						   AND 	Amo.Estatus         != Est_Pagado
                           AND 	Amo.AmortizacionID	= Var_AmortizacionID;

                        -- se marca como cancelada la amortizacion
						UPDATE AMORTIZAAPORT Amo SET
								Amo.Estatus		= Est_Calculado,
								EmpresaID 		= Par_EmpresaID,
								Usuario 		= Aud_Usuario,
								FechaActual		= Aud_FechaActual,
								DireccionIP		= Aud_DireccionIP,
								ProgramaID 		= Aud_ProgramaID,
								Sucursal 		= Aud_Sucursal,
								NumTransaccion 	= Aud_NumTransaccion
						WHERE 	Amo.AportacionID 	= Var_AportacionID
						AND 	Amo.Estatus 		!=Est_Pagado;

                        -- Se actualiza la tabla Aportaciones
						UPDATE APORTACIONES SET
								Estatus 		= Est_Calculado,
								SaldoProvision 	= SaldoProvision-Var_InteresPagar,
                                ISRReal			= ISRReal + Var_InteresRetener,
								FechaVenAnt		= Var_FechaVenAnt,
								UsuarioAut      = Aud_Usuario,
								EmpresaID 		= Par_EmpresaID,
								UsuarioID 		= Aud_Usuario,
								FechaActual		= Aud_FechaActual,
								DireccionIP		= Aud_DireccionIP,
								ProgramaID 		= Aud_ProgramaID,
								Sucursal 		= Aud_Sucursal,
								NumTransaccion 	= Aud_NumTransaccion
						WHERE 	AportacionID	= Var_AportacionID;


						# ALTA DE LA CUOTAS CANCELADAS PARA SER DISPERSADAS.
						CALL APORTDISPPENDPRO(
							Var_AportacionID,	Est_Calculado,		Par_Fecha,			SalidaNO,			Par_NumErr,
							Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr!= Entero_Cero) THEN
							SET Error_Key  := 99;
							LEAVE ErrorCursor;
						END IF;

						TRUNCATE TABLE TMPVENCANTAPORT;
                    END ErrorCursor;
                    SET Var_AportStr := CONVERT(Var_AportacionID, CHAR);
					IF Error_Key = 0 THEN
						COMMIT;
					END IF;

                    IF Error_Key = 1 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaAport,	Par_Fecha,			Var_AportStr,		ErrorSQL,	Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 2 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaAport,	Par_Fecha,			Var_AportStr,		ErrorAlta,		Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 3 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaAport,	Par_Fecha,			Var_AportStr,		ErrorLlamada,	Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
					IF Error_Key = 4 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaAport,	Par_Fecha,			Var_AportStr,		ErrorValorNulo,	Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;

					IF Error_Key = 99 THEN
						ROLLBACK;
						START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Pro_CieDiaAport,	Par_Fecha,			Var_AportStr,		CONCAT(Par_NumErr,' - ',	Par_ErrMen),	Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);
						COMMIT;
					END IF;
				END LOOP;
			END;
		CLOSE PAGOAPORTCUR;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Pagos de Aportaciones por Vencimiento Anticipado Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen;
	END IF;
END TerminaStore$$