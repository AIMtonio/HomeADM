-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDEPAGOVENANTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDEPAGOVENANTPRO`;
DELIMITER $$


CREATE PROCEDURE `CEDEPAGOVENANTPRO`(
# =========================================================================
# ----- SP PARA REALIZAR LOS PAGOS DE CEDES POR VENCIMIENTO ANTICIPADO-----
# =========================================================================
	Par_CedeID          INT(11),		-- Numero de Cede
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
	DECLARE Var_CedeID			BIGINT;
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_TipoCedeID		INT(11);
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
	DECLARE VarFechaVenCede		DATE;
	DECLARE VarFechaVenAmo		DATE;
	DECLARE SalMinAnuDF			DECIMAL(12,2);
	DECLARE Var_SalMinDF		DECIMAL(12,2);
	DECLARE Var_ISR_pSocio		CHAR(1);			-- si se calcula por socio el ISR
	DECLARE Var_FechaISR		DATE;				-- variable fecha de inicio cobro isr por socio
	DECLARE Var_FechaFinAmor	DATE;				-- variable de la inversion inicial
	DECLARE Var_ISRReal 		DECIMAL(14,2); 		-- variable que guarda el ISR REAL
    DECLARE Var_Tasa			DECIMAL(14,4);		-- Valor de la Tasa de la Cede
    DECLARE Var_DiasInversion	INT(11);
    DECLARE Var_MontoCede       DECIMAL(14,2);

	-- Declaracion de Contantes
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Entero_Cero     	INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Estatus_Vigente 	CHAR(1);
	DECLARE Est_Pagado  		CHAR(1);
	DECLARE Rei_NO				CHAR(2);
	DECLARE Pol_Automatica		CHAR(1);
	DECLARE Var_PagoCeder		INT(11);
	DECLARE Var_RefPagoCed		VARCHAR(100);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Var_ConCedCapi		INT(11);
	DECLARE Var_ConCedProv		INT(11);
	DECLARE Var_ConCedISR   	INT(11);
	DECLARE Con_Capital     	INT(11);
	DECLARE Mov_AhorroSI    	CHAR(1);
	DECLARE Mov_AhorroNO    	CHAR(1);
	DECLARE Cue_PagIntExe   	CHAR(50);
	DECLARE Cue_PagIntGra   	CHAR(50);
	DECLARE Cue_RetCeder    	CHAR(50);
	DECLARE Tipo_Provision		CHAR(4);
	DECLARE NombreProceso		VARCHAR(20);
	DECLARE Ope_Interna			CHAR(1);
	DECLARE Tip_Compra			CHAR(1);
	DECLARE AltPoliza_NO		CHAR(1);
	DECLARE Tasa_Fija    		INT(11);
	DECLARE InstCede			INT(11);
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

	DECLARE PAGOCEDECUR CURSOR FOR
		SELECT	Ced.CedeID,					MAX(Ced.CuentaAhoID),    	MAX(Ced.TipoCedeID),		MAX(Ced.MonedaID),   		SUM(Ced.Monto),
				MIN(Amo.Interes),			SUM(Amo.ISRCal), 			MAX(Ced.ClienteID),			SUM(Ced.SaldoProvision),	MAX(cte.SucursalOrigen),
				MIN(Amo.AmortizacionID),	MAX(Ced.FechaVencimiento), MAX(Amo.FechaPago),			MAX(Ced.CalculoInteres),	MIN(Amo.FechaInicio),
                MIN(Amo.FechaVencimiento)
			FROM 	TMPVENCIMANTCEDE Ced
					INNER JOIN  AMORTIZACEDES Amo ON  Ced.CedeID = Amo.CedeID AND Amo.Estatus = Estatus_Vigente
					INNER JOIN CLIENTES cte ON Ced.ClienteID = cte.ClienteID
			WHERE	Ced.Estatus 		= Estatus_Vigente
            AND		Ced.NumTransaccion 	= Aud_NumTransaccion
			GROUP BY Ced.ClienteID,Ced.CedeID;

	-- Asignacion de Contantes
	SET Cadena_Vacia    		:= '';						-- Constante Cadena Vacia
	SET Fecha_Vacia     		:= '1900-01-01';   		 	-- Constante Fecha Vacia
	SET Entero_Cero     		:= 0;						-- Constante Entero Cero
    SET	Decimal_Cero			:= 0.00;					-- valor para settear el valor de cero con decimales
	SET Estatus_Vigente 		:= 'N';        				-- Estatus de la CEDE: Vigente
	SET Est_Pagado				:= 'P';        				-- Estatus de la CEDE: Pagada
	SET Rei_NO          		:= 'N';        				-- NO ReCedertir
	SET Pol_Automatica  		:= 'A'; 					-- Poliza: Automatica
	SET Var_PagoCeder   		:= 907;						-- Concepto Contable: Pago de CEDE
	SET Var_RefPagoCed  		:= 'VENCIMIENTO ANTICIPADO DE CEDE';	-- Descripcion Referencia
	SET Nat_Cargo      			:= 'C';        				-- Naturaleza de Cargo
	SET Nat_Abono      			:= 'A';        				-- Naturaleza de Abono
	SET SalidaNO        		:= 'N';        				-- Salida NO
	SET SalidaSI        		:= 'S';        				-- Salida SI
	SET Var_ConCedCapi  		:= 1;          				-- Concepto Contable de CEDE: Capital
	SET Var_ConCedProv  		:= 5;          				-- Concepto Contable de CEDE: Provision
	SET Var_ConCedISR   		:= 4;          				-- Concepto Contable de CEDE: Retencion
	SET Con_Capital     		:= 1;          				-- Concepto Contable de Ahorro: Capital
	SET Mov_AhorroSI    		:= 'S';        				-- Movimiento de Ahorro: SI
	SET Mov_AhorroNO    		:= 'N';        				-- Movimiento de Ahorro: NO
	SET Cue_PagIntExe   		:= 'INTERES EXCENTO';		-- Descripcion Interes Excento
	SET Cue_PagIntGra   		:= 'INTERESES GRAVADO';		-- Descripcion Interes Gravado
	SET Cue_RetCeder   			:= 'RETENCION ISR';			-- Descripcion Retencion ISR
	SET Tipo_Provision 			:= '100';      				-- Tipo de Movimiento de CEDE: Provision
	SET NombreProceso   		:= 'CEDE';					-- Descripcion Nombre Proceso
	SET Ope_Interna    			:= 'I';        				-- Tipo de Operacion: Interna
	SET Tip_Compra      		:= 'C';        				-- Tipo de Operacion: Compra de Divisa
	SET AltPoliza_NO    		:= 'N';        				-- Alta de la Poliza NO
	SET Tasa_Fija				:=  1;						-- Tipo de Calculo de Interes Tasa Fija
	SET InstCede				:=	28;						-- Tipo de instrumento cedes.
	SET Con360					:=	360;
	SET ConCien					:=	100;
	SET ConCinco				:=	5;
	SET Est_Aplicado			:=	'A';
	SET Est_Calculado			:=	'C';
	SET Est_Pendiente			:=	'P';
	SET ProcesoPantalla			:=	'P';
	SET EnteroUno				:=	1;
	SET Mov_PagCedCap   		:= '509';      				-- VENCIMIENTO ANTICIPADO CEDES
	SET Mov_PagIntExe   		:= '504';      				-- PAGO CEDE. INTERES EXCENTO
	SET Mov_PagIntGra   		:= '503';      				-- PAGO CEDE. INTERES GRAVADO
	SET Mov_PagCedRet   		:= '505';      				-- PAGO CEDE. RETENCION
	SET Cons_SI  				:= 'S';        				-- Constante SI
    SET ISRpSocio				:= 'ISR_pSocio';			-- constante para isr por socio de PARAMGENERALES
    SET No_constante			:= 'N';						-- constante NO
    SET SI_Isr_Socio			:= 'S';						-- Constante para saber si se calcula el ISR por socio
	SET Aud_FechaActual			:= NOW();
	SET Var_FechaVenAnt 		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FechaVenAnt 		:= IFNULL(Var_FechaVenAnt,Fecha_Vacia);
    SET ValorUMA				:= 'ValorUMABase';

	ManejoErrores : BEGIN

	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CEDEPAGOVENANTPRO');
		END;

		SELECT  COUNT(Ced.CedeID) INTO Var_NumeroVenc
			FROM	TMPVENCIMANTCEDE	Ced,
					AMORTIZACEDES		Amo,
					CLIENTES			Cli
			WHERE 	Ced.Estatus		= Estatus_Vigente
			AND 	Amo.Estatus		= Estatus_Vigente
			AND 	Ced.CedeID		= Amo.CedeID
			AND 	Ced.ClienteID	= Cli.ClienteID;

		SET Var_NumeroVenc  := IFNULL(Var_NumeroVenc, Entero_Cero);


		IF(Var_NumeroVenc > Entero_Cero AND Par_Poliza = Entero_Cero) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,     	Par_EmpresaID,  	Par_Fecha,      	Pol_Automatica,     Var_PagoCeder,
				Var_RefPagoCed, 	SalidaNO,       	Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

		   IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SELECT ValorParametro INTO Var_ISR_pSocio
			FROM 	PARAMGENERALES
			WHERE 	LlaveParametro	= ISRpSocio;
		SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , No_constante);


		SELECT 		 MonedaBaseID,	SalMinDF,		FechaISR
				INTO Var_MonedaBase,Var_SalMinDF, 	Var_FechaISR
				FROM PARAMETROSSIS;

		SELECT ValorParametro
			INTO Var_DiasInversion
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;

		SELECT 	Suc.TasaISR, 	Cli.PagaISR
				INTO 	Var_TasaISR, 	Var_PagaISR
				FROM	CLIENTES Cli,
						SUCURSALES Suc
				WHERE 	Cli.ClienteID	= Par_ClienteID
                AND 	Suc.SucursalID	= Cli.SucursalOrigen;

		SET SalMinAnuDF :=	Var_SalMinDF*ConCinco*Var_DiasInversion;

	-- =============================================================================================================
	-- CALCULO ISR
	-- =============================================================================================================
		IF(Var_NumeroVenc > Entero_Cero) THEN

			DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion ;

			INSERT INTO CTESVENCIMIENTOS(
					Fecha,				ClienteID,			EmpresaID,			UsuarioID,				FechaActual,
					DireccionIP,		ProgramaID,			Sucursal,   		NumTransaccion)
			SELECT	Par_Fecha,			Par_ClienteID,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion;

			CALL CALCULOISRPRO(
					Par_Fecha,			Par_Fecha,			EnteroUno,			ProcesoPantalla,		SalidaNO,
					Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion ;

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

		END IF;

	-- =======================================================================================================================================================
	-- FIN CALCULO DE ISR
	-- =============================================================================================================


		/*SE HABRE CURSOR PARA PAGAR LAS CEDES QUE NO SE RENOVAN DE MANERA AUTOMATICA */
		OPEN PAGOCEDECUR;

			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH PAGOCEDECUR INTO
					Var_CedeID,				Var_CuentaAhoID,    Var_TipoCedeID,		Var_MonedaID,   	Var_Monto,
					Var_InteresGenerado,    Var_InteresRetener, Var_ClienteID,		Var_SaldoProvision,	Var_SucCliente,
					Var_AmortizacionID,		VarFechaVenCede,	VarFechaVenAmo,		Var_CalculoInteres,	Var_FechaIniciAmor,
                    Var_FechaFinAmor;

					START TRANSACTION;
					BEGIN

						SET Aud_FechaActual	:= NOW();
						SET Var_InteresPagar := Entero_Cero;

						IF(Var_Monto > Entero_Cero) THEN
							/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA CEDE */
							CALL CONTACEDESPRO(
								Var_CedeID,			Par_EmpresaID,      Par_Fecha,        	Var_Monto,      Mov_PagCedCap,
								Var_PagoCeder,      Var_ConCedCapi,     Con_Capital,        Nat_Abono,      AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,			Par_Poliza,         Par_NumErr,		Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaID,		Aud_Usuario,	Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

						END IF;

						/* Se obtiene el Interes a Retener*/
                        SET Var_InteresRetener:=FNTOTALISRCTE(Var_ClienteID,InstCede,Var_CedeID);

						IF (Var_InteresRetener = Decimal_Cero) THEN
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
								Var_CedeID,			Par_EmpresaID,      Par_Fecha,          Var_InteresPagar,		Var_MovIntere,
								Var_PagoCeder,      Var_ConCedProv,     Con_Capital,        Nat_Abono,				AltPoliza_NO,
								Mov_AhorroSI,       SalidaNO,			Par_Poliza,         Par_NumErr,				Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaID,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

							CALL CEDESMOVALT(
								Var_CedeID,			Par_Fecha,      	Tipo_Provision,		Var_InteresPagar,		Nat_Abono,
								Cue_PagIntere,		Var_MonedaID,   	SalidaNO,			Par_NumErr,				Par_ErrMen,
								Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,		Aud_ProgramaID,
								Aud_Sucursal,		Aud_NumTransaccion  );

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

								SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);

								SET Var_CuentaStr := CONVERT(Var_CuentaAhoID, CHAR);

							-- Se obtiene el Monto de la CEDE
							SET Var_MontoCede 	:= (SELECT Monto FROM CEDES WHERE CedeID = Var_CedeID);
							SET Var_MontoCede	:= IFNULL(Var_MontoCede,Decimal_Cero);

							SET Var_Tasa	:=(SELECT TasaFija FROM CEDES WHERE CedeID = Var_CedeID);
							SET Var_Tasa	:=IFNULL(Var_Tasa,Decimal_Cero);

							-- Registro de informacion para el Calculo del Interes Real para Cedes
							CALL CALCULOINTERESREALALT (
								 Var_ClienteID,			Par_Fecha,				InstCede,				Var_CedeID,				Var_MontoCede,
								 Var_InteresPagar,		Var_InteresRetener,		Var_Tasa,				Var_FechaIniciAmor,		Var_FechaFinAmor,
                                 Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,   		Aud_DireccionIP,		Aud_ProgramaID,
                                 Aud_Sucursal,			Aud_NumTransaccion);

						END IF;

					-- Retencion

						IF (Var_InteresRetener > Decimal_Cero) THEN
							SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);
							CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,    	Aud_NumTransaccion,		Par_Fecha,          Nat_Cargo,			Var_InteresRetener,
								Cue_RetCeder,			Var_Instrumento,    	Mov_PagCedRet,		SalidaNO,			Par_NumErr,
								Par_ErrMen,				Par_EmpresaID,        	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

							CALL POLIZASAHORROPRO(
								Par_Poliza,         Par_EmpresaID,    	Par_Fecha,          Var_ClienteID,      Con_Capital,
								Var_CuentaAhoID,    Var_MonedaID,   	Var_InteresRetener,	Entero_Cero,        Cue_RetCeder,
								Var_CuentaStr,      SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,		Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
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

						/* SE GENERA LA CONTABILIDAD DEL PAGO DE LA CEDE */
							CALL CONTACEDESPRO(
								Var_CedeID,			Par_EmpresaID,      Par_Fecha,          Var_IntRetMN,			Cadena_Vacia,
								Var_PagoCeder,      Var_ConCedISR,		Entero_Cero,        Nat_Abono,				AltPoliza_NO,
								Mov_AhorroNO,       SalidaNO,			Par_Poliza,         Par_NumErr,				Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaBase,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Var_SucCliente,     Aud_NumTransaccion  );

							IF(Par_NumErr != Entero_Cero) THEN
								LEAVE ManejoErrores;
							END IF;

						END IF;

						/* se marca como cancelada la amortizacion */
						UPDATE AMORTIZACEDES Amo SET
								Amo.Estatus		= Est_Calculado,
								EmpresaID 		= Par_EmpresaID,
								Usuario 		= Aud_Usuario,
								FechaActual		= Aud_FechaActual,
								DireccionIP		= Aud_DireccionIP,
								ProgramaID 		= Aud_ProgramaID,
								Sucursal 		= Aud_Sucursal,
								NumTransaccion 	= Aud_NumTransaccion
						WHERE 	Amo.CedeID 		= Var_CedeID
						AND 	Amo.Estatus 	!=Est_Pagado;

						/* Se actualiza la tabla CEDES */
						UPDATE CEDES SET
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
						WHERE 	CedeID			= Var_CedeID;

 		-- ============================== ACTUALIZA EL COBROISR ======================================================

						UPDATE COBROISR isr
							SET Estatus = Est_Aplicado
							WHERE ClienteID 		= Var_ClienteID
								AND ProductoID 		= Var_CedeID
								AND InstrumentoID 	= InstCede;
		-- ==============================          FIN           ======================================================

						TRUNCATE TABLE TMPVENCIMANTCEDE;
					END;
				END LOOP;
			END;
		CLOSE PAGOCEDECUR;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Pagos de Cedes por Vencimiento Anticipado Realizados Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  AS NumErr,
				Par_ErrMen  AS ErrMen;
	END IF;
END TerminaStore$$