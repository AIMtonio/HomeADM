


-- APORTMASCONDCUR --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTMASCONDCUR`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTMASCONDCUR`(
# =======================================================================
# ------------- SP PARA LA REINVERSION MASIVA DE APORTACIONES -----------
# =======================================================================
	Par_Fecha               	DATE,				-- Fecha en la que se realiza la reinversion
	Par_PolizaID				BIGINT(20),			-- Número de Poliza.
	INOUT Par_NumErr        	INT(11),			-- Numero error
	INOUT Par_ErrMen        	VARCHAR(400),		-- Mensaje error
	INOUT Par_ContadorTotal 	INT(11),			-- Contador total

	INOUT Par_ContadorExito 	INT(11),			-- Contador exitos
	Par_Salida					CHAR(1),			-- Parametro salida
	Par_EmpresaID           	INT(11),			-- Parametro de auditoria
	Aud_Usuario             	INT(11),			-- Parametro de auditoria
	Aud_FechaActual         	DATETIME,			-- Parametro de auditoria

	Aud_DireccionIP         	VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID          	VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal            	INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion      	BIGINT(20)			-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_ErrorKey			INT DEFAULT 0;	-- Error KEY
	DECLARE Var_AportID            	INT(11);		-- vairable para el ID de la aportacion
	DECLARE Var_ClienteID         	INT(11);		-- Almacena el ID del cliente
	DECLARE Var_CuentaAhoID       	BIGINT(20);		-- Almacena la cuenta de ahorro
	DECLARE Var_TipoAportID        	INT(11);		-- Tipo de Aportacion
	DECLARE Var_MonedaID          	INT(11);		-- ID del tipo de moneda
	DECLARE Var_FechaInicio			DATE;			-- Fecha de inicio
	DECLARE Var_FechaInicioAmo    	DATE;			-- Fecha de inicio de amortizacion
	DECLARE Var_FechaFinAmo    	  	DATE;			-- Fecha final de amortizaciones
	DECLARE Var_Monto             	DECIMAL(18,2);	-- Monto de la aporracion
	DECLARE Var_PlazoOriginal     	INT(11);		-- Plazo original
	DECLARE Var_Plazo             	INT(11);		-- Plazo
	DECLARE Var_Tasa              	DECIMAL(12,4);	-- Tasa
	DECLARE Var_TasaISR           	DECIMAL(12,4);	-- Tasa ISR
	DECLARE Var_TasaNeta          	DECIMAL(12,4);	-- Tasa neta
	DECLARE Var_InteresGenerado   	DECIMAL(18,2);	-- Interes generado
	DECLARE Var_InteresRecibir    	DECIMAL(18,2);	-- Interes a recibir
	DECLARE Var_InteresRetener    	DECIMAL(18,2);	-- Interes a retener
	DECLARE Var_TipoPagoInteres   	CHAR(1);		-- Tipo de pago interes
	DECLARE Var_Reinversion       	CHAR(2);		-- Reinversion
	DECLARE Var_Reinvertir        	CHAR(2);		-- Reinvertir
	DECLARE Var_SaldoProAcumulado 	DECIMAL(18,2);	-- Saldo acumulado
	DECLARE Var_SucursalID        	INT(11);		-- ID de la sucursal
	DECLARE Var_TasaFV            	CHAR(1);		-- Tasa fija/variable
	DECLARE Var_Calificacion      	CHAR(2);		-- Calificacion
	DECLARE Var_PlazoInferior     	INT(11);		-- Plazo inferior
	DECLARE Var_PlazoSuperior     	INT(11);		-- Plazo superior
	DECLARE Var_MontoInferior     	DECIMAL(18,2);	-- Monto inferior
	DECLARE Var_MontoSuperior     	DECIMAL(18,2);	-- Monto superior
	DECLARE Var_FechaVencimiento  	DATE;			-- Fecha de vencimiento
	DECLARE Var_FechaPago		  	DATE;			-- Fecha de pago
	DECLARE Var_NuevoPlazo        	INT(11);		-- Nuevo plazo
	DECLARE Var_MontoReinvertir   	DECIMAL(18,2);	-- Monto a reinvertir
	DECLARE Var_NuevaTasa         	DECIMAL(12,4);	-- Nueva tasa
	DECLARE Var_NuevaTasaISR      	DECIMAL(12,4);	-- Nueva tasa ISR
	DECLARE Var_NuevaTasaNeta    	DECIMAL(12,4);	-- Nueva tasa neta
	DECLARE Var_NuevoCalInteres   	INT(11);		-- Nuevo calculo de interes
	DECLARE Var_NuevaTasaBaseID   	INT(11);		-- Nueva tasa base
	DECLARE Var_NuevaSobreTasa    	DECIMAL(12,4);	-- Nueva sobre tasa
	DECLARE Var_NuevoPisoTasa     	DECIMAL(12,4);	-- Nueva tasa piso
	DECLARE Var_NuevoTechoTasa    	DECIMAL(12,4);	-- Nueva tasa techo
	DECLARE Var_NuevoIntGenerado  	DECIMAL(18,2);	-- Nuevo interes generado
	DECLARE Var_NuevoIntRetener   	DECIMAL(18,2);	-- Nuevo interes a retener
	DECLARE Var_NuevoIntRecibir   	DECIMAL(18,2);	-- Nuevo interes recibir
	DECLARE Var_NuevoValorGat     	DECIMAL(12,2);	-- Nuevo valor gat
	DECLARE Var_NuevoValorGatReal 	DECIMAL(12,2);	-- Nuevo valor gat REAL
	DECLARE Var_InteresPagar      	DECIMAL(18,2);	-- Interes a pagar
	DECLARE Var_MovIntere		  	VARCHAR(4);		-- Movimiento de interes
	DECLARE Cue_PagIntere		  	VARCHAR(50);	-- Pago interes
	DECLARE Var_Instrumento		  	VARCHAR(15);	-- Instrumento
	DECLARE Var_CuentaStr		  	VARCHAR(15);	-- Cuenta Str
	DECLARE Var_IntRetMN		  	DECIMAL(12,2);	-- Iinteres a retener MN
	DECLARE Var_TipCamCom		  	DECIMAL(14,6);	-- Tipo cambio comision
	DECLARE Var_Poliza			  	BIGINT(20);		-- Poliza
	DECLARE Var_NumAportaciones	  	INT(11);		-- Numero de aportaciones
	DECLARE	Var_MonedaBase		  	INT(11);		-- Moneda base
	DECLARE Var_NuevaAportID		INT(11); 	-- Nuevo ID de la aportacion
	DECLARE Var_AportStr           	VARCHAR(15);	-- Aportacion Str
	DECLARE Var_SucOrigen		  	INT(11);		-- Sucursal de origen
	DECLARE Var_AmortizacionID	  	INT(11);		-- Id de la amortizacion
	DECLARE	Var_FechaBatch		  	DATE;			-- Fecha batch
	DECLARE Var_FechaSistema	  	DATE;			-- Fecha del sistema
	DECLARE Var_FecBitaco		  	DATETIME;		-- Fecha de la bitacora
	DECLARE Var_MinutosBit 		  	INT(11);		-- Minutos bitacora
	DECLARE Var_CajaRetiro        	INT(11);		-- Caja de retiro
	DECLARE Var_PagaISR			  	CHAR(1);		-- Paga ISR
	DECLARE Var_DiasPeriodo			INT(11);		-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	DECLARE Var_PagoIntCal			CHAR(2);		-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	DECLARE Var_MontoAport       	DECIMAL(14,2);	-- Monto aportacion
	DECLARE Var_MontoGlobal			DECIMAL(18,2);	-- MONTO GLOBAL DEL CLIENTE Y SU GRUPO.
	DECLARE Var_TasaMontoGlobal		CHAR(1);		-- INDICA SI CALCULA LA TASA POR EL MONTO GLOBAL.
	DECLARE Var_IncluyeGpoFam		CHAR(1);		-- INDICA SI INCLUYE A SU GRUPO FAM EN EL MONTO.
	DECLARE Var_DiaPago				INT(11);		-- Especifica el dia de pago para aportaciones con tipo de pago programado
	DECLARE Var_Capitaliza			CHAR(1);		-- Indica si se capitaliza interes. S:si / N:no / I:indistinto
	DECLARE Var_CapitalizaCond		CHAR(1);		-- Indica si se capitaliza interes. Pactadas en Condiciones de Vencimiento.
	DECLARE Var_OpcionAport			VARCHAR(50);	-- Nueva, Renovacion con +, Renovacion con – O Renovacion
	DECLARE Var_CantidadReno		DECIMAL(14,2);	-- Cantidad renovacion de aportacion
	DECLARE Var_InvRenovar			INT(11);		-- Inversion renovar
	DECLARE Var_Notas				VARCHAR(500);	-- Notas puntuales de la aportacion
	DECLARE Var_MontoCapitaliza		DECIMAL(14,2);	-- Guarda el monto de la capitalizacion
	DECLARE Var_RefCapitaliza		VARCHAR(20);	-- Guarda la referencia para el movimiento de capitalizacion
	DECLARE Var_ReinversionPact		CHAR(1);		-- Indica si se condicionó algún tipo de reinversión
	DECLARE Var_SaldoCuenta			DECIMAL(18,2);	-- Saldo disponible de la cuenta.
	DECLARE Var_TotalAmo			INT(11);		-- Total de Amortizaciones.
	DECLARE Var_NuevoDiasPago		INT(11);		-- Dias de Pago de las Condiciones de Vencimiento.
	DECLARE Var_ConsolidarSaldos	CHAR(1);		-- Indica si las aportaciones se consolidan o no.

	-- Declaracion de Constantes
	DECLARE SalidaNO              	CHAR(1);
	DECLARE SalidaSI			  	CHAR(1);
	DECLARE DecimalCero           	DECIMAL(12,2);
	DECLARE EnteroCero            	INT(11);
	DECLARE CadenaVacia           	CHAR(1);
	DECLARE PagoAportr             	INT(11);
	DECLARE TasaFija              	CHAR(1);
	DECLARE PolAutomatica         	CHAR(1);
	DECLARE RefePagoAport          	VARCHAR(50);
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
	DECLARE CueRetAportr           	VARCHAR(50);
	DECLARE OpeInterna            	CHAR(1);
	DECLARE TipCompra             	CHAR(1);
	DECLARE NombreProceso         	VARCHAR(10);
	DECLARE ConCedISR             	INT(11);
	DECLARE EstPagado             	CHAR(1);
	DECLARE Impreso				  	CHAR(1);
	DECLARE EstatusVigente		  	CHAR(1);
	DECLARE Mov_ApeAport		  	VARCHAR(4);
	DECLARE Var_ConAltaAport		INT(11);
	DECLARE Ren_AltaReAport		  	INT(11);
	DECLARE ProcesoAport		  	INT(11);
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
	DECLARE InstrumentoAport		INT(11);
	DECLARE Const_DesCapInteres		VARCHAR(50);
	DECLARE Cons_SI					CHAR(1);
	DECLARE EstatusReinvertida		CHAR(1);
	DECLARE ReinvPosterior			CHAR(1);

	-- Declaracion del CURSOR
	DECLARE CURSORTEMPAPORT CURSOR FOR
		SELECT
			TMP.AportacionID,			TMP.ClienteID,       		TMP.CuentaAhoID,     		MAX(TMP.TipoAportacionID),	MAX(TMP.MonedaID),			MAX(TMP.FechaInicio),
			MAX(TMP.Monto),				MAX(TMP.PlazoOriginal),   	MAX(TMP.Plazo),           	MAX(TMP.Tasa),				MAX(TMP.TasaISR),			MAX(TMP.TasaNeta),
			MAX(TMP.InteresGenerado),	MAX(TMP.InteresRecibir),  	MAX(TMP.InteresRetener),  	MAX(TMP.TipoPagoInteres),	MAX(TMP.Reinversion),		MAX(TMP.Reinvertir),
			MAX(TMP.SaldoProAcumulado),	MAX(TMP.SucursalID),      	MAX(TMP.TasaFV),          	MAX(TMP.Calificacion),		MAX(TMP.PlazoInferior),		MAX(TMP.PlazoSuperior),
			MAX(TMP.MontoInferior),		MAX(TMP.MontoSuperior),   	MAX(TMP.FechaVencimiento),	MAX(TMP.FechaPago),			MAX(TMP.NuevoPlazo),		MAX(TMP.MontoReinvertir),
			MAX(TMP.NuevaTasa),			MAX(TMP.NuevaTasaISR),    	MAX(TMP.NuevaTasaNeta),   	MAX(TMP.NuevoCalInteres),	MAX(TMP.NuevaTasaBaseID),	MAX(TMP.NuevaSobreTasa),
			MAX(TMP.NuevoPisoTasa),		MAX(TMP.NuevoTechoTasa),  	MAX(TMP.NuevoIntGenerado),	MAX(TMP.NuevoIntRetener),	MAX(TMP.NuevoIntRecibir),	MAX(TMP.NuevoValorGat),
			MAX(TMP.NuevoValorGatReal),	MAX(cte.SucursalOrigen),   	MAX(TMP.AmortizacionID),  	MAX(AP.CajaRetiro),			MAX(Amo.FechaInicio),	   	MAX(Amo.FechaVencimiento),
			MAX(cte.PagaISR),			MAX(TMP.DiasPeriodo),	  	MAX(TMP.PagoIntCal),		MAX(TMP.MontoGlobal),		MAX(TMP.TasaMontoGlobal),	MAX(TMP.IncluyeGpoFam),
			MAX(TMP.DiasPago),			MAX(TMP.PagoIntCapitaliza),	MAX(TMP.NuevaOpcionAportID),MAX(TMP.NuevaCantidadReno),	MAX(TMP.InvRenovar),		MAX(TMP.NuevaNotas),
			MAX(TMP.ReinversionPact),	MAX(TMP.NuevoCapitalInteres),MAX(TMP.NuevoDiasPago),	MAX(TMP.ConsolidarSaldos)
		FROM TMPAPORTCONDICIONES TMP
				INNER JOIN APORTACIONES AS AP ON TMP.AportacionID = AP.AportacionID
				INNER JOIN AMORTIZAAPORT AS Amo ON Amo.AportacionID = AP.AportacionID  AND Amo.AmortizacionID =TMP.AmortizacionID
				INNER JOIN CLIENTES  cte ON  TMP.ClienteID = cte.ClienteID
		GROUP BY TMP.ClienteID,TMP.AportacionID,TMP.CuentaAhoID
		ORDER BY TMP.ConsolidarSaldos DESC;

	-- Asignacion de Constantes
	SET SalidaNO        	:= 'N';
	SET SalidaSI			:= 'S';
	SET DecimalCero     	:= 0.0;
	SET EnteroCero      	:= 0;
	SET CadenaVacia     	:= '';
	SET TasaFija        	:= 'F';
	SET PolAutomatica   	:= 'A';
	SET PagoAportr       	:= 902;                                -- Concepto Contable: Pago de Aportacion
	SET RefePagoAport    	:= 'VENCIMIENTO DE APORTACION';        -- Descripcion Referencia
	SET MovPagCedCap    	:= '602';                              -- PAGO APORTACION. CAPITAL
	SET ConCedCapi      	:= 1;                                  -- Concepto Contable de Aportacion: Capital
	SET ConCapital      	:= 1;                                  -- Concepto Contable de Ahorro: Capital
	SET NatAbono        	:= 'A';
	SET NatCargo        	:= 'C';
	SET AltPolizaNO     	:= 'N';
	SET MovAhorroSI     	:= 'S';									-- Movimiento de Ahorro: SI
	SET MovAhorroNO    		:= 'N';                                 -- Movimiento de Ahorro: NO
	SET MovPagIntExe    	:= '604';                               -- PAGO APORTACION. INTERES EXCENTO
	SET CuePagIntExe    	:= 'INTERESES GENERADOS';				-- Descripcion Interes Excento
	SET MovPagIntGra    	:= '603';                               -- PAGO APORTACION. INTERES GRAVADO
	SET CuePagIntGra    	:= 'INTERESES GENERADOS';		        -- Descripcion Interes Gravado
	SET ConCedProv      	:= 5;                                   -- Concepto Contable de APORTACION: Provision
	SET TipoProvision   	:= '100';                               -- Tipo de Movimiento de APORTACION: Provision
	SET MovPagCedRet    	:= '605';                               -- PAGO APORTACION. RETENCION
	SET CueRetAportr     	:= 'RETENCION ISR';						-- Descripcion Retenciuon ISR
	SET OpeInterna      	:= 'I';                                 -- Tipo de Operacion: Interna
	SET TipCompra       	:= 'C';                                 -- Tipo de Operacion: Compra de Divisa
	SET NombreProceso   	:= 'APORTACION';                        -- Descripcion Nombre Proceso
	SET ConCedISR       	:= 4;                                   -- Concepto Contable de Aportacion: Retencion
	SET EstPagado       	:= 'P';                                 -- Estatus de la Aportacion: Pagada
	SET Impreso				:= 'I';								    -- Constante Estatus Impreso
	SET	EstatusVigente		:= 'N';							        -- Constante Estatus Vigente 'N'.
	SET Var_NuevaAportID	:= EnteroCero;	                        -- Para generar la Nueva Aportacion
	SET Var_MonedaBase		:= EnteroCero;				            -- Moneda Base.
	SET Mov_ApeAport		:= '601';   						    -- Apertura de Aportacion Tabla TIPOSMOVSAHO.
	SET Var_ConAltaAport   	:= 900;								    -- Movimiento Aportacion
	SET Ren_AltaReAport  	:= 1504;                                -- Constante para la Bitacora Reinversion de la Aportacion
	SET ProcesoAport		:= 1516;
	SET ErrorUno    		:= 'ERROR DE SQL GENERAL';
	SET ErrorDos    		:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET ErrorTres   		:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET ErrorCuatro  		:= 'ERROR VALORES NULOS';
	SET Entero_Cero			:= 0;
	SET EnteroUno			:= 1;
	SET Est_Pendiente		:= 'P';
	SET ProgramaVencMasivo  := '/microfin/vencMasivoAportVista.htm';  -- Programa Vencimiento Masivo Aportaciones
	SET FechaVacia			:= '1900-01-01';
	SET InstrumentoAport	:= 31;				-- Tipo de Instrumentos Aportaciones
	SET Const_DesCapInteres	:= 'CAPITALIZACION INTERES'; -- Descripcion del movimiento de capitalizacion de interes
	SET Cons_SI				:= 'S';
	SET EstatusReinvertida	:= 'R';
	SET ReinvPosterior		:= 'E';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	:=	999;
				SET Par_ErrMen	:=	CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-APORTMASCONDCUR');
			END;

		SET Var_Poliza		:= IFNULL(Par_PolizaID,Entero_Cero);
		SET Aud_FechaActual	:= NOW();
		SET Var_FecBitaco	:= Aud_FechaActual;

		SELECT 	MonedaBaseID,FechaSistema
		   INTO Var_MonedaBase,Var_FechaSistema
			FROM PARAMETROSSIS;

		SET Var_NumAportaciones := (SELECT COUNT(AportacionID) FROM TMPAPORTCONDICIONES);
		SET Var_NumAportaciones	:=	IFNULL(Var_NumAportaciones,EnteroCero);
		SET Var_FechaSistema	:=	IFNULL(Var_FechaSistema,FechaVacia);

		# SI EN EL PROCESO ANTERIOR NO GENERÓ PÓLIZA, ENTONCES SE EVALÚA SI HAY APORTACIONES POR VENCER.
		IF(Var_Poliza = Entero_Cero)THEN
			IF(Var_NumAportaciones > EnteroCero) THEN
				CALL MAESTROPOLIZASALT(
					Var_Poliza,			Par_EmpresaID,		Par_Fecha,      PolAutomatica,     	PagoAportr,
					RefePagoAport,		SalidaNO,       	Par_NumErr,		Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,   	Aud_NumTransaccion  );

				IF(Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr	:=	0;
				SET Par_ErrMen	:=	'No hay Aportaciones a reinvertir de forma masiva';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		/*Contador vencimiento masivo aportaciones*/
		SET ContadorTotal:=0;
		SET ContadorExito:=0;
	-- =======================================================================================================================================

		OPEN CURSORTEMPAPORT;
			BEGIN
			   DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			   CICLOCURSORTEMPAPORT:LOOP

			   FETCH CURSORTEMPAPORT INTO
					  Var_AportID,				Var_ClienteID,       	Var_CuentaAhoID,     	Var_TipoAportID,       	Var_MonedaID,         	Var_FechaInicio,
					  Var_Monto,             	Var_PlazoOriginal,   	Var_Plazo,           	Var_Tasa,             	Var_TasaISR,          	Var_TasaNeta,
					  Var_InteresGenerado,   	Var_InteresRecibir,  	Var_InteresRetener,  	Var_TipoPagoInteres,  	Var_Reinversion,      	Var_Reinvertir,
					  Var_SaldoProAcumulado, 	Var_SucursalID,      	Var_TasaFV,          	Var_Calificacion,	 	Var_PlazoInferior,    	Var_PlazoSuperior,
					  Var_MontoInferior,   	 	Var_MontoSuperior,   	Var_FechaVencimiento,	Var_FechaPago,	  		Var_NuevoPlazo,    	 	Var_MontoReinvertir,
					  Var_NuevaTasa,       		Var_NuevaTasaISR,     	Var_NuevaTasaNeta,    	Var_NuevoCalInteres,  	Var_NuevaTasaBaseID,   	Var_NuevaSobreTasa,
					  Var_NuevoPisoTasa,   		Var_NuevoTechoTasa,		Var_NuevoIntGenerado, 	Var_NuevoIntRetener,  	Var_NuevoIntRecibir,   	Var_NuevoValorGat,
					  Var_NuevoValorGatReal,	Var_SucOrigen,		 	Var_AmortizacionID,		Var_CajaRetiro,			Var_FechaInicioAmo,  	Var_FechaFinAmo,
					  Var_PagaISR,				Var_DiasPeriodo,		Var_PagoIntCal,			Var_MontoGlobal,		Var_TasaMontoGlobal,	Var_IncluyeGpoFam,
					  Var_DiaPago,				Var_Capitaliza,			Var_OpcionAport,		Var_CantidadReno,		Var_InvRenovar,			Var_Notas,
					  Var_ReinversionPact,		Var_CapitalizaCond,		Var_NuevoDiasPago,		Var_ConsolidarSaldos;

				START TRANSACTION;
					ErrorCursor:BEGIN -- Inicia el BEGIN Start Transaction
						DECLARE EXIT HANDLER FOR SQLEXCEPTION     SET Var_ErrorKey = 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Var_ErrorKey = 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Var_ErrorKey = 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Var_ErrorKey = 4;
						DECLARE EXIT HANDLER FOR NOT FOUND SET Var_ErrorKey = 1;

						SET Aud_FechaActual  := NOW();
						SET Var_InteresPagar := EnteroCero;

						/*Contador vencimiento masivo aportaciones*/
						SET ContadorTotal     :=ContadorTotal+1;

                        SELECT COUNT(*) INTO @numCuota
							FROM AMORTIZAAPORT
                            WHERE AportacionID= Var_AportID;

                        -- VALIDACIONES PARA EL MONTO A PAGAR EN CASO DE SER UNA APORTACION
						-- QUE CAPITALIZA INTERES
                        IF(Var_Capitaliza=Cons_SI AND Var_AmortizacionID = @numCuota)THEN
							SET Var_Monto := (SELECT SaldoCap
												FROM AMORTIZAAPORT
												WHERE AportacionID = Var_AportID
												AND AmortizacionID = @numCuota);
						END IF;

						IF (Var_Monto > EnteroCero) THEN
							CALL CONTAAPORTPRO (
								Var_AportID,		Par_EmpresaID,	Par_Fecha,		Var_Monto,			MovPagCedCap,
								PagoAportr,			ConCedCapi,		ConCapital,		NatAbono,			AltPolizaNO,
								MovAhorroSI,		SalidaNO,		Var_Poliza,		Par_NumErr,			Par_ErrMen,
								Var_CuentaAhoID,	Var_ClienteID,	Var_MonedaID,	Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,	Aud_ProgramaID,	Var_SucursalID, Aud_NumTransaccion);

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

						IF(Var_TasaFV = TasaFija) THEN
							SET Var_InteresPagar := Var_SaldoProAcumulado;
						ELSE
							SET Var_InteresPagar := Var_SaldoProAcumulado;
						END IF;

							   -- Pago Rendimiento
						IF(Var_InteresPagar > EnteroCero) THEN
							CALL CONTAAPORTPRO(
								Var_AportID,		Par_EmpresaID,	    Par_Fecha,		    Var_InteresPagar,	 Var_MovIntere,
								PagoAportr,      	ConCedProv,     	ConCapital,         NatAbono,			 AltPolizaNO,
								MovAhorroSI,       	SalidaNO,		    Var_Poliza,         Par_NumErr,		     Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,	    Aud_Usuario,		 Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,	    Var_SucursalID,     Aud_NumTransaccion);

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;

							CALL APORTMOVALT(
								Var_AportID,		Par_Fecha,      	TipoProvision,		Var_InteresPagar,	 NatAbono,
								Cue_PagIntere,	    Var_MonedaID,   	SalidaNO,			Par_NumErr,			 Par_ErrMen,
								Par_EmpresaID,	    Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	 Aud_ProgramaID,
								Aud_Sucursal,	    Aud_NumTransaccion  );

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;

							SET Var_Instrumento := CONVERT(Var_AportID, CHAR);
							SET Var_CuentaStr   := CONVERT(Var_CuentaAhoID, CHAR);

							-- Se obtiene el Monto de la Aportacion
							SET Var_MontoAport 	:= (SELECT Monto FROM APORTACIONES WHERE AportacionID = Var_AportID);
							SET Var_MontoAport	:= IFNULL(Var_MontoAport,DecimalCero);

							-- Registro de informacion para el Calculo del Interes REAL para Aportaciones
							CALL CALCULOINTERESREALALT (
								 Var_ClienteID,		Par_Fecha,			InstrumentoAport,	Var_AportID,		 	Var_MontoAport,
								 Var_InteresPagar,	Var_InteresRetener,	Var_Tasa,			Var_FechaInicioAmo,	Var_FechaFinAmo,
								 Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,	Aud_ProgramaID,
								 Aud_Sucursal,		Aud_NumTransaccion);


						END IF;
						-- Fin Pago de Rendimiento

						-- Retencion ISR
						IF (Var_InteresRetener > EnteroCero) THEN
							SET Var_CuentaStr   := CONVERT(Var_CuentaAhoID, CHAR);
							SET Var_Instrumento := CONVERT(Var_AportID, CHAR);

							CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,	Aud_NumTransaccion,	Par_Fecha,		NatCargo,			Var_InteresRetener,
								CueRetAportr,		Var_Instrumento,	MovPagCedRet,	SalidaNO,      		Par_NumErr,
								Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID, 	Aud_Sucursal,   	Aud_NumTransaccion);

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;

							CALL POLIZASAHORROPRO(
								Var_Poliza,			Par_EmpresaID,		Par_Fecha,				Var_ClienteID,		ConCapital,
								Var_CuentaAhoID,	Var_MonedaID,		Var_InteresRetener,		EnteroCero,			CueRetAportr,
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
									OpeInterna,		TipCompra,			Var_Instrumento,	RefePagoAport,		NombreProceso,
									Var_Poliza,		Par_EmpresaID,		Aud_Usuario,  		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

							ELSE
								SET Var_IntRetMN := Var_InteresRetener;
							END IF;
							CALL CONTAAPORTPRO(
								Var_AportID,			Par_EmpresaID,	Par_Fecha,		Var_IntRetMN,		CadenaVacia,
								PagoAportr,			ConCedISR,		EnteroCero,		NatAbono,			AltPolizaNO,
								MovAhorroNO,		SalidaNO,		Var_Poliza,		Par_NumErr,			Par_ErrMen,
								Var_CuentaAhoID,	Var_ClienteID,	Var_MonedaBase,	Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;
						END IF;-- Fin de Retencion ISR

						SET Var_TotalAmo := (SELECT COUNT(*) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportID);
						SET Var_TotalAmo := IFNULL(Var_TotalAmo, Entero_Cero);

						-- SI LA APORTACION CAPITALIZA INTERES
						IF(Var_Capitaliza = Cons_SI AND Var_TotalAmo > 1
							AND Var_AmortizacionID < Var_TotalAmo)THEN

							-- SE OBTIENE EL MONTO A CAPITALIZAR
							SET Var_MontoCapitaliza := Var_InteresPagar-Var_InteresRetener;
							SET Var_RefCapitaliza	:= CONVERT(Var_AportID, CHAR);

							-- SE HACE EL CARGO A LA CUENTA POR EL MONTO DE CAPITALIZACION
							CALL CUENTASAHORROMOVALT(
								Var_CuentaAhoID,    	Aud_NumTransaccion,		Par_Fecha,          NatCargo,			Var_MontoCapitaliza,
								Const_DesCapInteres,	Var_RefCapitaliza,    	Var_MovIntere,		SalidaNO,			Par_NumErr,
								Par_ErrMen,				Par_EmpresaID,        	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
								Aud_ProgramaID,     	Aud_Sucursal,       	Aud_NumTransaccion);

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;

							-- se registra la poliza
							CALL POLIZASAHORROPRO(
								Var_Poliza,         Par_EmpresaID,    	Par_Fecha,          Var_ClienteID,      ConCapital,
								Var_CuentaAhoID,    Var_MonedaID,   	Var_MontoCapitaliza,Entero_Cero,        Const_DesCapInteres,
								Var_RefCapitaliza,  SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;

							-- SE GENERA LA CONTABILIDAD DE LA APORTACION
							CALL CONTAAPORTPRO(
								Var_AportID,		Par_EmpresaID,      Par_Fecha,          Var_MontoCapitaliza,	CadenaVacia,
								PagoAportr,     	ConCedCapi,			Entero_Cero,        NatAbono,				AltPolizaNO,
								MovAhorroNO,        SalidaNO,			Var_Poliza,         Par_NumErr,				Par_ErrMen,
								Var_CuentaAhoID,    Var_ClienteID,  	Var_MonedaBase,		Aud_Usuario,			Aud_FechaActual,
								Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,     	Aud_NumTransaccion  );

							IF(Par_NumErr!= EnteroCero) THEN
								SET Var_ErrorKey  := 99;
								LEAVE ErrorCursor;
							END IF;

						END IF; -- FIN CAPITALIZA INTERES

						-- Se Actualiza la Ultima Amotizacion a Pagada
						UPDATE AMORTIZAAPORT Amo
							SET		Amo.Estatus			= EstPagado,
									EmpresaID 			= Par_EmpresaID,
									Usuario 			= Aud_Usuario,
									FechaActual			= Aud_FechaActual,
									DireccionIP			= Aud_DireccionIP,
									ProgramaID 			= Aud_ProgramaID,
									Sucursal 			= Aud_Sucursal,
									NumTransaccion 		= Aud_NumTransaccion
							WHERE 	Amo.AportacionID 	= Var_AportID
							AND 	Amo.Estatus 		!= EstPagado
							AND 	Amo.AmortizacionID	= Var_AmortizacionID;

					-- Fin de la Actualizacion de la Ultima Amotizacion a Pagada
						UPDATE APORTACIONES
							SET		Estatus 		= EstPagado,
									EmpresaID 		= Par_EmpresaID,
									UsuarioID 		= Aud_Usuario,
									FechaActual		= Aud_FechaActual,
									DireccionIP		= Aud_DireccionIP,
									ProgramaID 		= Aud_ProgramaID,
									Sucursal 		= Aud_Sucursal,
									NumTransaccion 	= Aud_NumTransaccion
							WHERE	AportacionID 	= Var_AportID;

						/*SE ACTUALIZA EL SALDO PROVISION APORTACIONES*/
						UPDATE APORTACIONES SET
							SaldoProvision = SaldoProvision - Var_InteresGenerado
						WHERE	AportacionID = Var_AportID;

						# CONSULTA DE SALDO DISPONIBLE DE LA CUENTA.
						SET Var_SaldoCuenta := (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAhoID);
						SET Var_SaldoCuenta := IFNULL(Var_SaldoCuenta, Entero_Cero);

						# SI REINVIERTEN ENTONCES SE REGISTRA LA NUEVA APORTACIÓN.
						IF(Var_ReinversionPact = Cons_SI AND Var_ConsolidarSaldos != 'I')THEN
							# SI EXISTE SUFICIENTE SALDO EN LA CUENTA, SE REINVIERTE.
							IF(Var_SaldoCuenta >= Var_MontoReinvertir)THEN

								SET Var_NuevaAportID := (SELECT IFNULL(MAX(AportacionID), EnteroCero) + 1
														FROM APORTACIONES);
								 -- Insertando en Aportaciones --
								INSERT INTO APORTACIONES(
									AportacionID,			TipoAportacionID,		CuentaAhoID,		    ClienteID,			  	FechaInicio,
									FechaVencimiento,		FechaPago,				Monto,					Plazo,				    TasaFija,
									TasaISR,				TasaNeta,				CalculoInteres,			TasaBase,			    SobreTasa,
									PisoTasa,				TechoTasa,				InteresGenerado,		InteresRecibir,		    InteresRetener,
									SaldoProvision,			ValorGat,				ValorGatReal,		    EstatusImpresion,		MonedaID,
									FechaVenAnt,			FechaApertura,			Estatus,			    TipoPagoInt,			DiasPeriodo,
									PagoIntCal,				CajaRetiro,				AportacionRenovada,		PlazoOriginal,			SucursalID,
									Reinvertir,			    Reinversion,			MontoGlobal,			TasaMontoGlobal,		IncluyeGpoFam,
									DiasPago,				PagoIntCapitaliza,		OpcionAport,			CantidadReno,			InvRenovar,
									Notas,					EmpresaID,				UsuarioID,				FechaActual,			DireccionIP,
									ProgramaID,				Sucursal,				NumTransaccion)

								 VALUES(
									Var_NuevaAportID,		Var_TipoAportID,		Var_CuentaAhoID,	    Var_ClienteID,			Var_FechaInicio,
									Var_FechaVencimiento,	Var_FechaPago,			Var_MontoReinvertir,	Var_NuevoPlazo,		    Var_NuevaTasa,
									Var_NuevaTasaISR,		Var_NuevaTasaNeta,		Var_NuevoCalInteres,	Var_NuevaTasaBaseID,    Var_NuevaSobreTasa,
									Var_NuevoPisoTasa,		Var_NuevoTechoTasa,		Var_NuevoIntGenerado,	Var_NuevoIntRecibir,    Var_NuevoIntRetener,
									DecimalCero,			Var_NuevoValorGat,		Var_NuevoValorGatReal,	Impreso,				Var_MonedaID,
									FechaVacia,				Var_FechaSistema,		EstatusVigente,		    Var_TipoPagoInteres,	Var_DiasPeriodo,
									Var_PagoIntCal,			Var_CajaRetiro,			Var_AportID,			Var_PlazoOriginal,		Var_SucursalID,
									ReinvPosterior,		    Var_Reinversion,		Var_MontoGlobal,		Var_TasaMontoGlobal,	Var_IncluyeGpoFam,
									Var_NuevoDiasPago,		Var_CapitalizaCond,		Var_OpcionAport,		Var_CantidadReno,		Var_InvRenovar,
									Var_Notas,				Par_EmpresaID,			Aud_Usuario,	    	Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,			Aud_Sucursal,		    Aud_NumTransaccion);


								-- Generamos y Guardamos las Amortizaciones de la Aportacion.
								/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA APORTACION */
								CALL APORTAMORTIZAPRO(
									Var_NuevaAportID,	Var_FechaInicio,	Var_FechaVencimiento,	Var_MontoReinvertir,	Var_ClienteID,
									Var_TipoAportID,	Var_NuevaTasa,		Var_TipoPagoInteres,	Var_DiasPeriodo,		Var_PagoIntCal,
									Var_NuevoDiasPago,	Var_PlazoOriginal,	Var_CapitalizaCond,		SalidaNO,				Par_NumErr,
									Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
									Aud_ProgramaID,   	Aud_Sucursal,    	Aud_NumTransaccion
								);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								CALL CONTAAPORTPRO(
									Var_NuevaAportID,	Par_EmpresaID,		Par_Fecha,		Var_MontoReinvertir,	Mov_ApeAport,
									Var_ConAltaAport,	ConCedCapi,	        ConCapital,	    NatCargo,				AltPolizaNO,
									MovAhorroSI,		SalidaNO,		    Var_Poliza,     Par_NumErr,				Par_ErrMen,
									Var_CuentaAhoID,    Var_ClienteID,      Var_MonedaID,	Aud_Usuario,			Aud_FechaActual,
									Aud_DireccionIP,    Aud_ProgramaID,	    Var_SucursalID, Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								-- LLAMADA A SP PARA REGISTRAR SI SE REALIZO CAMBIO DE TASA, DE APORTACIONES
								CALL CAMBIOTASAAPORTCIERREALT(
									Var_AportID,	Var_NuevaAportID,	Var_TipoAportID,		SalidaNO,			Par_NumErr,
									Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr!= EnteroCero) THEN
									SET Var_ErrorKey  := 99;
									LEAVE ErrorCursor;
								END IF;

								/** SE ACTUALIZA LAS CONDICIONES PARA INDICAR QUE SÍ PUDO REINVERTIRSE.
								 ** */
								UPDATE CONDICIONESVENCIMAPORT C
								SET
									C.EstatusRenovacion = EstatusReinvertida,
									C.NuevaAportID = Var_NuevaAportID,
									C.MotivoRenovacion = CONCAT('APORTACION REINVERTIDA: ',Var_NuevaAportID,'.')
								WHERE C.AportacionID = Var_AportID;

								SET Par_NumErr	:= EnteroCero;
								SET Par_ErrMen  := 'Aportacion Reinvertida Correctamente.';
							ELSE
								/** SI NO HUBO SALDO, NO SE REINVIERTE.
								 ** SE ACTUALIZA LAS CONDICIONES PARA INDICAR QUE NO PUDO REINVERTIRSE.
								 ** */
								UPDATE CONDICIONESVENCIMAPORT C
								SET
									C.EstatusRenovacion = SalidaNO,
									C.MotivoRenovacion = 'FONDOS INSUFICIENTES EN LA CUENTA.'
								WHERE C.AportacionID = Var_AportID;

							END IF;
						END IF;

						# ALTA DE LA CUOTAS PAGADAS PARA SER DISPERSADAS.
						CALL APORTDISPPENDPRO(
							Var_AportID,		EstPagado,			Par_Fecha,			SalidaNO,			Par_NumErr,
							Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							SET Var_ErrorKey  := 99;
							LEAVE ErrorCursor;
						END IF;

					END ErrorCursor; -- Termina BEGIN Start Transaction


					SET Var_AportStr := CONVERT(Var_AportID, CHAR);
					IF Var_ErrorKey = 0 THEN
						/*Contador vencimiento masivo aportaciones*/
						SET ContadorExito=ContadorExito+1;
						COMMIT;
					END IF;

					IF Var_ErrorKey = 1 THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_AltaReAport, 	Par_Fecha, 		    Var_AportStr, 	   	ErrorUno,
								Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						COMMIT;
					END IF;

					IF Var_ErrorKey = 2 THEN
						ROLLBACK;
							START TRANSACTION;
						   CALL EXCEPCIONBATCHALT(
								Ren_AltaReAport, 	Par_Fecha, 		    Var_AportStr, 	   	ErrorDos,
								Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						COMMIT;
					 END IF;

					IF Var_ErrorKey = 3 THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_AltaReAport, 	Par_Fecha, 		    Var_AportStr, 	   	ErrorTres,
								Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						COMMIT;
					END IF;

					IF Var_ErrorKey = 4 THEN
						ROLLBACK;
							START TRANSACTION;
							CALL EXCEPCIONBATCHALT(
								Ren_AltaReAport, 	Par_Fecha, 		    Var_AportStr, 	  	ErrorCuatro,
								Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
					   COMMIT;
					END IF;

					IF Var_ErrorKey = 99 THEN
						ROLLBACK;
							START TRANSACTION;
							   CALL EXCEPCIONBATCHALT(
									Ren_AltaReAport, 	Par_Fecha, 		    Var_AportStr, 	  	CONCAT(Par_NumErr,' - ',Par_ErrMen),
									Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
						COMMIT;
					END IF;
				END LOOP CICLOCURSORTEMPAPORT;
			END;
		CLOSE CURSORTEMPAPORT;

		/*Contador vencimiento masivo aportaciones*/
		SET Par_ContadorTotal:= (IFNULL(Par_ContadorTotal, Entero_Cero) + ContadorTotal);
		SET Par_ContadorExito:= (IFNULL(Par_ContadorExito, Entero_Cero) + ContadorExito);

		IF (Par_NumErr = EnteroCero) THEN
			SET Par_NumErr	:=	EnteroCero;
			SET Par_ErrMen	:=	'Alta Reinversion Masiva Aportaciones Realizadas Exitosamente.';
		END IF;

		SET Par_NumErr		:=	EnteroCero;
		SET Par_ErrMen		:=	'Aportacion Masivo Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Par_ContadorTotal AS ContTotal,
				Par_ContadorExito AS ContExito;
	END IF;

END TerminaStore$$