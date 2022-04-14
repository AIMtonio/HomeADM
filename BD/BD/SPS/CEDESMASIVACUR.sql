-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESMASIVACUR
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESMASIVACUR`;
DELIMITER $$

CREATE PROCEDURE `CEDESMASIVACUR`(
# ================================================================
# ------------- SP PARA LA REINVERSION MASIVA DE CEDES -----------
# ================================================================
    Par_Fecha               	DATE,				-- Fecha en la que se realiza la reinversion
    INOUT Par_NumErr        	INT(11),			-- Numero error
    INOUT Par_ErrMen        	VARCHAR(400),		-- Mensaje error
    INOUT Par_ContadorTotal 	INT(11),			-- Contador total
    INOUT Par_ContadorExito 	INT(11),			-- Contador exitos
    Par_Salida					CHAR(1),			-- Parametro salida

    Par_EmpresaID           	INT(11),
    Aud_Usuario             	INT(11),
    Aud_FechaActual         	DATETIME,
    Aud_DireccionIP         	VARCHAR(15),
    Aud_ProgramaID          	VARCHAR(50),
    Aud_Sucursal            	INT(11),
    Aud_NumTransaccion      	BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_ErrorKey			INT DEFAULT 0;
	DECLARE Var_CedeID            	INT(11);
	DECLARE Var_ClienteID         	INT(11);
	DECLARE Var_CuentaAhoID       	BIGINT(20);
	DECLARE Var_TipoCedeID        	INT(11);
	DECLARE Var_MonedaID          	INT(11);
	DECLARE Var_FechaInicio			DATE;
	DECLARE Var_FechaInicioAmo    	DATE;
	DECLARE Var_FechaFinAmo    	  	DATE;
	DECLARE Var_Monto             	DECIMAL(18,2);
	DECLARE Var_PlazoOriginal     	INT(11);
	DECLARE Var_Plazo             	INT(11);
	DECLARE Var_Tasa              	DECIMAL(12,4);
	DECLARE Var_TasaISR           	DECIMAL(12,4);
	DECLARE Var_TasaNeta          	DECIMAL(12,4);
	DECLARE Var_InteresGenerado   	DECIMAL(18,2);
	DECLARE Var_InteresRecibir    	DECIMAL(18,2);
	DECLARE Var_InteresRetener    	DECIMAL(18,2);
	DECLARE Var_TipoPagoInteres   	CHAR(1);
	DECLARE Var_Reinversion       	CHAR(2);
	DECLARE Var_Reinvertir        	CHAR(2);
	DECLARE Var_SaldoProAcumulado 	DECIMAL(18,2);
	DECLARE Var_SucursalID        	INT(11);
	DECLARE Var_TasaFV            	CHAR(1);
	DECLARE Var_Calificacion      	CHAR(2);
	DECLARE Var_PlazoInferior     	INT(11);
	DECLARE Var_PlazoSuperior     	INT(11);
	DECLARE Var_MontoInferior     	DECIMAL(18,2);
	DECLARE Var_MontoSuperior     	DECIMAL(18,2);
	DECLARE Var_FechaVencimiento  	DATE;
	DECLARE Var_FechaPago		  	DATE;
	DECLARE Var_NuevoPlazo        	INT(11);
	DECLARE Var_MontoReinvertir   	DECIMAL(18,2);
	DECLARE Var_NuevaTasa         	DECIMAL(12,4);
	DECLARE Var_NuevaTasaISR      	DECIMAL(12,4);
	DECLARE Var_NuevaTasaNeta    	DECIMAL(12,4);
	DECLARE Var_NuevoCalInteres   	INT(11);
	DECLARE Var_NuevaTasaBaseID   	INT(11);
	DECLARE Var_NuevaSobreTasa    	DECIMAL(12,4);
	DECLARE Var_NuevoPisoTasa     	DECIMAL(12,4);
	DECLARE Var_NuevoTechoTasa    	DECIMAL(12,4);
	DECLARE Var_NuevoIntGenerado  	DECIMAL(18,2);
	DECLARE Var_NuevoIntRetener   	DECIMAL(18,2);
	DECLARE Var_NuevoIntRecibir   	DECIMAL(18,2);
	DECLARE Var_NuevoValorGat     	DECIMAL(12,2);
	DECLARE Var_NuevoValorGatReal 	DECIMAL(12,2);
	DECLARE Var_InteresPagar      	DECIMAL(18,2);
	DECLARE Var_MovIntere		  	VARCHAR(4);
	DECLARE Cue_PagIntere		  	VARCHAR(50);
	DECLARE Var_Instrumento		  	VARCHAR(15);
	DECLARE Var_CuentaStr		  	VARCHAR(15);
	DECLARE Var_IntRetMN		  	DECIMAL(12,2);
	DECLARE Var_TipCamCom		  	DECIMAL(14,6);
	DECLARE Var_Poliza			  	BIGINT(20);
	DECLARE Var_NumCedes		  	INT(11);
	DECLARE	Var_MonedaBase		  	INT(11);
	DECLARE Var_NuevaCedeID		  	INT(11);
	DECLARE Var_CedeStr           	VARCHAR(15);
	DECLARE Var_SucOrigen		  	INT(11);
	DECLARE Var_AmortizacionID	  	INT(11);
    DECLARE	Var_FechaBatch		  	DATE;
	DECLARE Var_FechaSistema	  	DATE;
	DECLARE Var_FecBitaco		  	DATETIME;
	DECLARE Var_MinutosBit 		  	INT(11);
	DECLARE Var_CajaRetiro        	INT(11);
	DECLARE Var_PagaISR			  	CHAR(1);
	DECLARE Var_DiasPeriodo			INT(11);			-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	DECLARE Var_PagoIntCal			CHAR(2);			-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	DECLARE Var_MontoCede       	DECIMAL(14,2);
	DECLARE Var_Estatus             CHAR(2);            -- Almacena el estatus del tipo de cede

	-- Declaracion de Constantes
	DECLARE SalidaNO              	CHAR(1);
	DECLARE SalidaSI			  	CHAR(1);
	DECLARE DecimalCero           	DECIMAL(12,2);
	DECLARE EnteroCero            	INT(11);
	DECLARE CadenaVacia           	CHAR(1);
	DECLARE PagoCeder             	INT(11);
	DECLARE TasaFija              	CHAR(1);
	DECLARE PolAutomatica         	CHAR(1);
	DECLARE RefePagoCede          	VARCHAR(50);
	DECLARE MovPagCedCap          	VARCHAR(4);
	DECLARE ConCedCapi            	INT(11);
	DECLARE ConCapital            	INT(11);
	DECLARE NatAbono              	CHAR(1);
	DECLARE NatCargo              	CHAR(1);
	DECLARE AltPolizaNO           	CHAR(1);
	DECLARE MovAhorroSI           	CHAR(1);
	DECLARE MovAhorroNO           	CHAR(1);
	DECLARE MovPagIntExe          	VARCHAR(4);
	DECLARE CuePagIntExe          	VARCHAR(50);
	DECLARE MovPagIntGra          	VARCHAR(4);
	DECLARE CuePagIntGra          	VARCHAR(50);
	DECLARE ConCedProv            	INT(11);
	DECLARE TipoProvision         	VARCHAR(4);
	DECLARE MovPagCedRet          	VARCHAR(4);
	DECLARE CueRetCeder           	VARCHAR(50);
	DECLARE OpeInterna            	CHAR(1);
	DECLARE TipCompra             	CHAR(1);
	DECLARE NombreProceso         	VARCHAR(10);
	DECLARE ConCedISR             	INT(11);
	DECLARE EstPagado             	CHAR(1);
	DECLARE Impreso				  	CHAR(1);
	DECLARE EstatusVigente		  	CHAR(1);
	DECLARE Mov_ApeCede			  	VARCHAR(4);
	DECLARE Var_ConAltCed		  	INT(11);
	DECLARE Ren_AltaReCede		  	INT(11);
	DECLARE ProcesoCede			  	INT(11);
	DECLARE ErrorUno              	VARCHAR(400);
	DECLARE ErrorDos              	VARCHAR(400);
	DECLARE ErrorTres             	VARCHAR(400);
	DECLARE ErrorCuatro           	VARCHAR(400);
	DECLARE Entero_Cero			  	INT(11);
	DECLARE EnteroUno			  	INT(11);
	DECLARE Est_Pendiente		  	CHAR(1);
	DECLARE ProgramaVencMasivo    	VARCHAR(100);
	DECLARE FechaVacia			  	DATE;
	DECLARE ContadorTotal         	INT(11);
	DECLARE ContadorExito         	INT(11);
	DECLARE InstrumentoCede			INT(11);
    DECLARE Estatus_Activo        	CHAR(1);    -- Estatus Activo

	-- Declaracion del CURSOR
	DECLARE CURSORTEMPCEDES CURSOR FOR
		SELECT 	  tmpc.CedeID,            		tmpc.ClienteID,       		tmpc.CuentaAhoID,     		MAX(tmpc.TipoCedeID),       MAX(tmpc.MonedaID),         MAX(tmpc.FechaInicio),
				  MAX(tmpc.Monto),             	MAX(tmpc.PlazoOriginal),   	MAX(tmpc.Plazo),           	MAX(tmpc.Tasa),             MAX(tmpc.TasaISR),          MAX(tmpc.TasaNeta),
				  MAX(tmpc.InteresGenerado),   	MAX(tmpc.InteresRecibir),  	MAX(tmpc.InteresRetener),  	MAX(tmpc.TipoPagoInteres),	MAX(tmpc.Reinversion),      MAX(tmpc.Reinvertir),
				  MAX(tmpc.SaldoProAcumulado), 	MAX(tmpc.SucursalID),      	MAX(tmpc.TasaFV),          	MAX(tmpc.Calificacion),		MAX(tmpc.PlazoInferior),    MAX(tmpc.PlazoSuperior),
                  MAX(tmpc.MontoInferior),   	MAX(tmpc.MontoSuperior),   	MAX(tmpc.FechaVencimiento),	MAX(tmpc.FechaPago),		MAX(tmpc.NuevoPlazo),  	   	MAX(tmpc.MontoReinvertir),
                  MAX(tmpc.NuevaTasa),       	MAX(tmpc.NuevaTasaISR),    	MAX(tmpc.NuevaTasaNeta),   	MAX(tmpc.NuevoCalInteres),  MAX(tmpc.NuevaTasaBaseID),  MAX(tmpc.NuevaSobreTasa),
                  MAX(tmpc.NuevoPisoTasa),   	MAX(tmpc.NuevoTechoTasa),  	MAX(tmpc.NuevoIntGenerado),	MAX(tmpc.NuevoIntRetener),  MAX(tmpc.NuevoIntRecibir),	MAX(tmpc.NuevoValorGat),
                  MAX(tmpc.NuevoValorGatReal),	MAX(cte.SucursalOrigen),   	MAX(tmpc.AmortizacionID),  	MAX(Ced.CajaRetiro),        MAX(Amo.FechaInicio),	   	MAX(Amo.FechaVencimiento),
                  MAX(cte.PagaISR),				MAX(tmpc.DiasPeriodo),	  	MAX(tmpc.PagoIntCal)
			FROM TEMPCEDES tmpc
					INNER JOIN CEDES AS Ced ON tmpc.CedeID = Ced.CedeID
					INNER JOIN AMORTIZACEDES AS Amo ON Amo.CedeID = Ced.CedeID  AND Amo.AmortizacionID =tmpc.AmortizacionID
					INNER JOIN CLIENTES  cte ON  tmpc.ClienteID = cte.ClienteID
			GROUP BY tmpc.ClienteID,tmpc.CedeID,tmpc.CuentaAhoID;

	-- Asignacion de Constantes
	SET SalidaNO        	:= 'N';
	SET SalidaSI			:= 'S';
	SET DecimalCero     	:= 0.0;
	SET EnteroCero      	:= 0;
	SET CadenaVacia     	:= '';
	SET TasaFija        	:= 'F';
	SET PolAutomatica   	:= 'A';
	SET PagoCeder       	:= 902;                                -- Concepto Contable: Pago de CEDE
	SET RefePagoCede    	:= 'VENCIMIENTO DE CEDE';         	   -- Descripcion Referencia
	SET MovPagCedCap    	:= '502';                              -- PAGO CEDE. CAPITAL
	SET ConCedCapi      	:= 1;                                  -- Concepto Contable de CEDE: Capital
	SET ConCapital      	:= 1;                                  -- Concepto Contable de Ahorro: Capital
	SET NatAbono        	:= 'A';
	SET NatCargo        	:= 'C';
	SET AltPolizaNO     	:= 'N';
	SET MovAhorroSI     	:= 'S';									-- Movimiento de Ahorro: SI
	SET MovAhorroNO    		:= 'N';                                 -- Movimiento de Ahorro: NO
	SET MovPagIntExe    	:= '504';                               -- PAGO CEDE. INTERES EXCENTO
	SET CuePagIntExe    	:= 'INTERESES GENERADOS';				-- Descripcion Interes Excento
	SET MovPagIntGra    	:= '503';                               -- PAGO CEDE. INTERES GRAVADO
	SET CuePagIntGra    	:= 'INTERESES GENERADOS';		        -- Descripcion Interes Gravado
	SET ConCedProv      	:= 5;                                   -- Concepto Contable de CEDE: Provision
	SET TipoProvision   	:= '100';                               -- Tipo de Movimiento de CEDE: Provision
	SET MovPagCedRet    	:= '505';                               -- PAGO CEDE. RETENCION
	SET CueRetCeder     	:= 'RETENCION ISR';						-- Descripcion Retenciuon ISR
	SET OpeInterna      	:= 'I';                                 -- Tipo de Operacion: Interna
	SET TipCompra       	:= 'C';                                 -- Tipo de Operacion: Compra de Divisa
	SET NombreProceso   	:= 'CEDE';                              -- Descripcion Nombre Proceso
	SET ConCedISR       	:= 4;                                   -- Concepto Contable de CEDE: Retencion
	SET EstPagado       	:= 'P';                                 -- Estatus de la CEDE: Pagada
	SET Impreso				:= 'I';								    -- Constante Estatus Impreso
	SET	EstatusVigente		:= 'N';							        -- Constante Estatus Vigente 'N'.
	SET Var_NuevaCedeID		:= EnteroCero;	                        -- Para generar la Nueva CEDE
	SET Var_MonedaBase		:= EnteroCero;				            -- Moneda Base.
	SET Mov_ApeCede			:= '501';   						    -- Apertura de CEDE Tabla TIPOSMOVSAHO.
	SET Var_ConAltCed   	:= 900;								    -- Movimiento Cede
	SET Ren_AltaReCede  	:= 1304;                                -- Constante para la Bitacora Reinversion de la CEDE
	SET ProcesoCede			:= 1316;
	SET ErrorUno    		:= 'ERROR DE SQL GENERAL';
	SET ErrorDos    		:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET ErrorTres   		:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET ErrorCuatro  		:= 'ERROR VALORES NULOS';
	SET Entero_Cero			:= 0;
	SET EnteroUno			:= 1;
	SET Est_Pendiente		:= 'P';
	SET ProgramaVencMasivo  := '/microfin/cedesVencimientoMasivo.htm';  -- Programa Vencimiento Masivo CEDES
	SET FechaVacia			:= '1900-01-01';
	SET InstrumentoCede		:= 28;				-- Tipo de Instrumentos Cedes
	SET Estatus_Activo    	:= 'A';         -- Estatus Activo

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:=	999;
				SET Par_ErrMen	:=	CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										    'esto le ocasiona. Ref: SP-CEDESMASIVACUR');
			END;

		SET Aud_FechaActual	:= NOW();
		SET Var_FecBitaco   := Aud_FechaActual;

		-- Se consulta si existe registro exitoso del proceso y fecha en BITACORABATCH
		CALL BITACORABATCHCON (
			ProcesoCede,			Par_Fecha,			Var_FechaBatch,		EnteroUno,			Par_EmpresaID,
            Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Var_FechaBatch = FechaVacia OR Aud_ProgramaID = ProgramaVencMasivo) THEN

			SELECT 	MonedaBaseID,FechaSistema
			   INTO Var_MonedaBase,Var_FechaSistema
				FROM PARAMETROSSIS;

			SELECT COUNT(CedeID)
			   INTO  Var_NumCedes
				 FROM TEMPCEDES;

			SET Var_NumCedes		:=	IFNULL(Var_NumCedes,EnteroCero);
			SET Var_FechaSistema	:=	IFNULL(Var_FechaSistema,FechaVacia);

			IF(Var_NumCedes > EnteroCero) THEN
				CALL MAESTROPOLIZASALT(
					Var_Poliza,			Par_EmpresaID,		Par_Fecha,      PolAutomatica,     	PagoCeder,
					RefePagoCede,		SalidaNO,       	Par_NumErr,		Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,   	Aud_NumTransaccion  );
				IF(Par_NumErr != Entero_Cero) THEN /* SI SURGIO UN ERROR SE SALE DEL SP*/
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr	:=	0;
				SET Par_ErrMen	:=	'No hay CEDES a reinvertir de forma masiva';
				LEAVE ManejoErrores;
			END IF;

			/*Contador vencimiento masivo cedes*/
			SET ContadorTotal:=0;
			SET ContadorExito:=0;
		-- =======================================================================================================================================

			OPEN CURSORTEMPCEDES;
				BEGIN
				   DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				   CICLOCURSORTEMPCEDES:LOOP

				   FETCH CURSORTEMPCEDES INTO
						  Var_CedeID,				Var_ClienteID,       	Var_CuentaAhoID,     	Var_TipoCedeID,       	Var_MonedaID,         	Var_FechaInicio,
						  Var_Monto,             	Var_PlazoOriginal,   	Var_Plazo,           	Var_Tasa,             	Var_TasaISR,          	Var_TasaNeta,
						  Var_InteresGenerado,   	Var_InteresRecibir,  	Var_InteresRetener,  	Var_TipoPagoInteres,  	Var_Reinversion,      	Var_Reinvertir,
						  Var_SaldoProAcumulado, 	Var_SucursalID,      	Var_TasaFV,          	Var_Calificacion,	 	Var_PlazoInferior,    	Var_PlazoSuperior,
						  Var_MontoInferior,   	 	Var_MontoSuperior,   	Var_FechaVencimiento,	Var_FechaPago,	  		Var_NuevoPlazo,    	 	Var_MontoReinvertir,
						  Var_NuevaTasa,       		Var_NuevaTasaISR,     	Var_NuevaTasaNeta,    	Var_NuevoCalInteres,  	Var_NuevaTasaBaseID,   	Var_NuevaSobreTasa,
						  Var_NuevoPisoTasa,   		Var_NuevoTechoTasa,		Var_NuevoIntGenerado, 	Var_NuevoIntRetener,  	Var_NuevoIntRecibir,   	Var_NuevoValorGat,
						  Var_NuevoValorGatReal,	Var_SucOrigen,		 	Var_AmortizacionID,		Var_CajaRetiro,			Var_FechaInicioAmo,  	Var_FechaFinAmo,
						  Var_PagaISR,				Var_DiasPeriodo,		Var_PagoIntCal;


					START TRANSACTION;
						ErrorCursor:BEGIN -- Inicia el BEGIN Start Transaction
							DECLARE EXIT HANDLER FOR SQLEXCEPTION     SET Var_ErrorKey = 1;
							DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Var_ErrorKey = 2;
							DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Var_ErrorKey = 3;
							DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Var_ErrorKey = 4;
							DECLARE EXIT HANDLER FOR NOT FOUND SET Var_ErrorKey = 1;

							SET Aud_FechaActual  := NOW();
							SET Var_InteresPagar := EnteroCero;

							/*Contador vencimiento masivo cedes*/
							SET ContadorTotal     :=ContadorTotal+1;

							IF (Var_Monto > EnteroCero) THEN
								CALL CONTACEDESPRO (
									Var_CedeID,		Par_EmpresaID,	  Par_Fecha,	  Var_Monto,      	MovPagCedCap,
									PagoCeder,      	ConCedCapi,       ConCapital,     NatAbono,      	AltPolizaNO,
									MovAhorroSI,       SalidaNO,		  Var_Poliza,     Par_NumErr,		Par_ErrMen,
									Var_CuentaAhoID,   Var_ClienteID,    Var_MonedaID,	  Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,   Aud_ProgramaID,	  Var_SucursalID, Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;
							END IF;

							IF (Var_InteresRetener = EnteroCero) THEN
								SET Var_MovIntere := MovPagIntExe;
								SET Cue_PagIntere := CuePagIntExe;
							ELSE
								SET Var_MovIntere := MovPagIntGra;
								SET Cue_PagIntere := CuePagIntGra;
							END IF;

							IF( Var_TasaFV = TasaFija) THEN
								SET Var_InteresPagar := Var_SaldoProAcumulado;
							ELSE
								SET Var_InteresPagar := Var_SaldoProAcumulado;
							END IF;

								   -- Pago Rendimiento
							IF(Var_InteresPagar > EnteroCero) THEN

								CALL CONTACEDESPRO(
									Var_CedeID,			Par_EmpresaID,	    Par_Fecha,		    Var_InteresPagar,	 Var_MovIntere,
									PagoCeder,      	ConCedProv,     	ConCapital,         NatAbono,			 AltPolizaNO,
									MovAhorroSI,       	SalidaNO,		    Var_Poliza,         Par_NumErr,		     Par_ErrMen,
									Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,	    Aud_Usuario,		 Aud_FechaActual,
									Aud_DireccionIP,    Aud_ProgramaID,	    Var_SucursalID,     Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								CALL CEDESMOVALT(
									Var_CedeID,		    Par_Fecha,      	TipoProvision,		Var_InteresPagar,	 NatAbono,
									Cue_PagIntere,	    Var_MonedaID,   	SalidaNO,			Par_NumErr,			 Par_ErrMen,
									Par_EmpresaID,	    Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	 Aud_ProgramaID,
									Aud_Sucursal,	    Aud_NumTransaccion  );

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);
								SET Var_CuentaStr   := CONVERT(Var_CuentaAhoID, CHAR);

								-- Se obtiene el Monto de la CEDE
								SET Var_MontoCede 	:= (SELECT Monto FROM CEDES WHERE CedeID = Var_CedeID);
								SET Var_MontoCede	:= IFNULL(Var_MontoCede,DecimalCero);

                                -- Registro de informacion para el Calculo del Interes Real para Cedes
                                CALL CALCULOINTERESREALALT (
									 Var_ClienteID,		Par_Fecha,			InstrumentoCede,	Var_CedeID,		 	Var_MontoCede,
									 Var_InteresPagar,	Var_InteresRetener,	Var_Tasa,			Var_FechaInicioAmo,	Var_FechaFinAmo,
                                     Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
                                     Aud_Sucursal,		Aud_NumTransaccion);


							END IF;
							-- Fin Pago de Rendimiento
							-- Retencion ISR
							IF (Var_InteresRetener > EnteroCero) THEN

								SET Var_CuentaStr   := CONVERT(Var_CuentaAhoID, CHAR);
								SET Var_Instrumento := CONVERT(Var_CedeID, CHAR);

								CALL CUENTASAHORROMOVALT(
									Var_CuentaAhoID,	Aud_NumTransaccion,	Par_Fecha,		NatCargo,			Var_InteresRetener,
									CueRetCeder,		Var_Instrumento,	MovPagCedRet,	SalidaNO,      		Par_NumErr,
									Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
									Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								CALL POLIZASAHORROPRO(
									Var_Poliza,			Par_EmpresaID,		Par_Fecha,				Var_ClienteID,		ConCapital,
									Var_CuentaAhoID,	Var_MonedaID,		Var_InteresRetener,		EnteroCero,			CueRetCeder,
									Var_CuentaStr,		SalidaNO,			Par_NumErr,			 	Par_ErrMen,			Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								IF (Var_MonedaBase != Var_MonedaID) THEN

									SET Var_TipCamCom	:=	(SELECT TipCamConInt
																FROM MONEDAS
																WHERE MonedaID	= Var_MonedaID);


									SET Var_IntRetMN := ROUND(Var_InteresRetener * Var_TipCamCom, 2);

									CALL COMVENDIVISAALT(
										Var_MonedaID,	Aud_NumTransaccion,	Par_Fecha,			Var_InteresRetener,	Var_TipCamCom,
										OpeInterna,		TipCompra,			Var_Instrumento,	RefePagoCede,		NombreProceso,
										Var_Poliza,		Par_EmpresaID,		Aud_Usuario,  		Aud_FechaActual,	Aud_DireccionIP,
                                        Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

								ELSE
									SET Var_IntRetMN := Var_InteresRetener;
								END IF;
								CALL CONTACEDESPRO(
									Var_CedeID,			Par_EmpresaID,	Par_Fecha,		Var_IntRetMN,		CadenaVacia,
									PagoCeder,			ConCedISR,		EnteroCero,		NatAbono,			AltPolizaNO,
									MovAhorroNO,		SalidaNO,		Var_Poliza,		Par_NumErr,			Par_ErrMen,
									Var_CuentaAhoID,	Var_ClienteID,	Var_MonedaBase,	Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;
							END IF;
							-- Fin de Retencion ISR
							-- Se Actualiza la Ultima Amotizacion a Pagada
							UPDATE AMORTIZACEDES Amo
								SET		Amo.Estatus			= EstPagado,
										EmpresaID 			= Par_EmpresaID,
										Usuario 			= Aud_Usuario,
										FechaActual			= Aud_FechaActual,
										DireccionIP			= Aud_DireccionIP,
										ProgramaID 			= Aud_ProgramaID,
										Sucursal 			= Aud_Sucursal,
										NumTransaccion 		= Aud_NumTransaccion
								WHERE 	Amo.CedeID 			= Var_CedeID
								AND 	Amo.Estatus 		!= EstPagado
								AND 	Amo.AmortizacionID	= Var_AmortizacionID;

						-- Fin de la Actualizacion de la Ultima Amotizacion a Pagada
							UPDATE CEDES
								SET		Estatus 		= EstPagado,
										EmpresaID 		= Par_EmpresaID,
										UsuarioID 		= Aud_Usuario,
										FechaActual		= Aud_FechaActual,
										DireccionIP		= Aud_DireccionIP,
										ProgramaID 		= Aud_ProgramaID,
										Sucursal 		= Aud_Sucursal,
										NumTransaccion 	= Aud_NumTransaccion
								WHERE	CedeID 			= Var_CedeID;

							/*SE ACTUALIZA EL SALDO PROVISION CEDES*/
							UPDATE CEDES SET
								SaldoProvision = SaldoProvision - Var_InteresGenerado
							WHERE	CedeID = Var_CedeID;

							SET Var_NuevaCedeID := (SELECT IFNULL(MAX(CedeID), EnteroCero) + 1
													FROM CEDES);

							-- SE OBTIENE EL ESTATUS DEL TIPO DE CEDE A REINVERTIR
							SET Var_Estatus :=(SELECT Estatus FROM TIPOSCEDES WHERE TipoCedeID = Var_TipoCedeID);
							SET Var_Estatus := IFNULL(Var_Estatus, CadenaVacia);

							-- SI EL ESTATUS DEL TIPO DE CEDE SE ENCUENTRA ACTIVO, SE REALIZA LA REINVERSION
							IF(Var_Estatus = Estatus_Activo)THEN
								 -- Insertando en CEDES --
								INSERT INTO CEDES(
									CedeID,					TipoCedeID,				CuentaAhoID,		    ClienteID,			  	FechaInicio,
									FechaVencimiento,		FechaPago,				Monto,					Plazo,				    TasaFija,
									TasaISR,				TasaNeta,				CalculoInteres,			TasaBase,			    SobreTasa,
									PisoTasa,				TechoTasa,				InteresGenerado,		InteresRecibir,		    InteresRetener,
									SaldoProvision,			ValorGat,				ValorGatReal,		    EstatusImpresion,		MonedaID,
									FechaVenAnt,			FechaApertura,			Estatus,			    TipoPagoInt,			DiasPeriodo,
	                                PagoIntCal,				CajaRetiro,				CedeRenovada,			PlazoOriginal,			SucursalID,
	                                Reinvertir,			    Reinversion,			EmpresaID,				UsuarioID,				FechaActual,
	                                DireccionIP,			ProgramaID,				Sucursal,				NumTransaccion)

								 VALUES(
									Var_NuevaCedeID,		Var_TipoCedeID,			Var_CuentaAhoID,	    Var_ClienteID,			Var_FechaInicio,
									Var_FechaVencimiento,	Var_FechaPago,			Var_MontoReinvertir,	Var_NuevoPlazo,		    Var_NuevaTasa,
									Var_NuevaTasaISR,		Var_NuevaTasaNeta,		Var_NuevoCalInteres,	Var_NuevaTasaBaseID,    Var_NuevaSobreTasa,
									Var_NuevoPisoTasa,		Var_NuevoTechoTasa,		Var_NuevoIntGenerado,	Var_NuevoIntRecibir,    Var_NuevoIntRetener,
									DecimalCero,			Var_NuevoValorGat,		Var_NuevoValorGatReal,	Impreso,				Var_MonedaID,
									FechaVacia,				Var_FechaSistema,		EstatusVigente,		    Var_TipoPagoInteres,	Var_DiasPeriodo,
	                                Var_PagoIntCal,			Var_CajaRetiro,			Var_CedeID,				Var_PlazoOriginal,		Var_SucursalID,
	                                Var_Reinvertir,		    Var_Reinversion,		Par_EmpresaID,			Aud_Usuario,	    	Aud_FechaActual,
	                                Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		    Aud_NumTransaccion);


								-- Generamos y Guardamos las Amortizaciones de la CEDE.
								/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA CEDE */
								CALL CEDEAMORTIZAPRO(
									Var_NuevaCedeID,	Var_FechaInicio,	Var_FechaVencimiento,	Var_MontoReinvertir,	Var_ClienteID,
									Var_TipoCedeID,		Var_NuevaTasa,		Var_TipoPagoInteres,	Var_DiasPeriodo,		Var_PagoIntCal,
	                                SalidaNO,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
	                                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,   		Aud_Sucursal,    		Aud_NumTransaccion
								);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								CALL CONTACEDESPRO(
									Var_NuevaCedeID,	Par_EmpresaID,		Par_Fecha,		Var_MontoReinvertir,	Mov_ApeCede,
									Var_ConAltCed,		ConCedCapi,	        ConCapital,	    NatCargo,				AltPolizaNO,
									MovAhorroSI,		SalidaNO,		    Var_Poliza,     Par_NumErr,				Par_ErrMen,
									Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,	Aud_Usuario,			Aud_FechaActual,
									Aud_DireccionIP,    Aud_ProgramaID,	    Var_SucursalID, Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								SET Par_NumErr	:= EnteroCero;
								SET Par_ErrMen  := 'CEDE Reinvertida Correctamente.';
							END IF;

						END ErrorCursor; -- Termina BEGIN Start Transaction


						SET Var_CedeStr := CONVERT(Var_CedeID, CHAR);
						IF Var_ErrorKey = 0 THEN
							/*Contador vencimiento masivo cedes*/
							SET ContadorExito=ContadorExito+1;
							COMMIT;
						END IF;

						IF Var_ErrorKey = 1 THEN
							ROLLBACK;
								START TRANSACTION;
								CALL EXCEPCIONBATCHALT(
									Ren_AltaReCede, 	Par_Fecha, 		    Var_CedeStr, 	   	ErrorUno,
									Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							COMMIT;
						END IF;

						IF Var_ErrorKey = 2 THEN
							ROLLBACK;
								START TRANSACTION;
							   CALL EXCEPCIONBATCHALT(
									Ren_AltaReCede, 	Par_Fecha, 		    Var_CedeStr, 	   	ErrorDos,
									Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							COMMIT;
						 END IF;

						IF Var_ErrorKey = 3 THEN
							ROLLBACK;
								START TRANSACTION;
								CALL EXCEPCIONBATCHALT(
									Ren_AltaReCede, 	Par_Fecha, 		    Var_CedeStr, 	   	ErrorTres,
									Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							COMMIT;
						END IF;

						IF Var_ErrorKey = 4 THEN
							ROLLBACK;
								START TRANSACTION;
								CALL EXCEPCIONBATCHALT(
									Ren_AltaReCede, 	Par_Fecha, 		    Var_CedeStr, 	  	ErrorCuatro,
									Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
						   COMMIT;
						END IF;

						IF Var_ErrorKey = 99 THEN
							ROLLBACK;
								START TRANSACTION;
								   CALL EXCEPCIONBATCHALT(
										Ren_AltaReCede, 	Par_Fecha, 		    Var_CedeStr, 	  	CONCAT(Par_NumErr,' - ',Par_ErrMen),
										Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							COMMIT;
						END IF;
					END LOOP CICLOCURSORTEMPCEDES;
				END;
			CLOSE CURSORTEMPCEDES;
			/*Contador vencimiento masivo cedes*/
			SET Par_ContadorTotal:=ContadorTotal;
			SET Par_ContadorExito:=ContadorExito;

			IF (Par_NumErr = EnteroCero) THEN
				SET Par_NumErr	:=	EnteroCero;
				SET Par_ErrMen	:=	'Alta Reinversion Masiva CEDES Reailizados Exitosamente.';
			END IF;

			SET Var_MinutosBit	:= TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
			SET Aud_FechaActual	:= NOW();

			/*Programa vencimiento masivo cedes*/
			IF(Aud_ProgramaID!=ProgramaVencMasivo)THEN
				CALL BITACORABATCHALT(
					ProcesoCede, 		Par_Fecha,			Var_MinutosBit,		Par_EmpresaID,		Aud_Usuario,
                    Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			SET Var_FecBitaco	:= NOW();

		END IF;

        SET Par_NumErr		:=	EnteroCero;
		SET Par_ErrMen		:=	'CEDE Masivo Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Par_ContadorTotal AS ContTotal,
				Par_ContadorExito AS ContExito;
	END IF;

END TerminaStore$$