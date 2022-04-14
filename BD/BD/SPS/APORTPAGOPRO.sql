
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTPAGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTPAGOPRO`;
DELIMITER $$

CREATE PROCEDURE `APORTPAGOPRO`(
	/* SP para la Reinversion Individual de APORTACIONES */
	Par_AportacionID		INT(11),		-- Id de la Aportacion a Pagar.
	Par_Fecha				DATE,			-- Fecha en la que Vence la Aportacion.
	Par_Reinversion			CHAR(1),
	Par_Reinvertir			CHAR(2),		-- Indica si despues de Pagar se Reinvertira la Aportacion. S.-Si N.-No
	Par_EsReinversion		CHAR(1),

	Par_TipoAportacionID	INT(11),		-- Indica el Tipo de Aportacion.
	Par_CuentaAhoID			BIGINT(20),		-- Cuenta de Ahorro relacionada a la Aportacion.
	Par_ClienteID			INT(11),		-- ClienteID relacionado a la Aportacion.
	Par_FechaInicio			DATE,			-- Fecha de Inicio de la Aportacion.
	Par_FechaVencimiento	DATE,			-- Fecha de Vencimiento de la Aportacion.

	Par_Monto				DECIMAL(18,2),	-- Monto de la Aportacion.
	Par_Plazo				INT(11),		-- Plazo de la Aportacion.
	Par_TasaFija			DECIMAL(12,4),	-- Tasa de la Aportacion.
	Par_TasaISR				DECIMAL(12,4),	-- Tasa ISR.
	Par_TasaNeta			DECIMAL(12,4),	-- Tasa Neta.

	Par_CalculoInteres		INT(11),		-- Tipo de Formula Aplicada a la Aportacion.
	Par_TasaBaseID			INT(11),		-- Tasa Base Aplicada a la Aportacion.
	Par_SobreTasa			DECIMAL(12,4),	-- Sobre Tasa Aplicada a la Aportacion.
	Par_PisoTasa			DECIMAL(12,4),	-- Piso Tasa Aplicada a la Aportacion.
	Par_TechoTasa			DECIMAL(12,4),	-- Techo Tasa Aplicado a la Aportacion.

	Par_InteresGenerado		DECIMAL(18,2),	-- Interes Genereado de la Aportacion.
	Par_InteresRecibir		DECIMAL(18,2),	-- Interes Neto a Recibir de la Aportacion.
	Par_InteresRetener		DECIMAL(18,2),	-- Interes a Retener de la Aportacion.
	Par_CalGATReal			DECIMAL(18,2),	-- Gat REAL.
	Par_ValorGat			DECIMAL(18,2),	-- Gat Nominal

	Par_TipoPagoInt			VARCHAR(4),		-- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	Par_DiasPeriodo			INT(11),		-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),		-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	Par_PlazoOriginal		INT(11),		-- Plazo Original de la Aportacion.
	Par_AltaEnPoliza		CHAR(1),		-- Indica si se dara de Alta la Poliza.

	Par_Salida				CHAR(1),		-- Indica si espera un SELECT de salida
	INOUT Par_Poliza		BIGINT(20),		-- INOUT Par_Poliza.
	INOUT Par_NumErr		INT(11),		-- INOUT Par_NumErr.
	INOUT Par_ErrMen		VARCHAR(400),	-- INOUT Par_ErrMen.
	Par_Empresa				INT(11),		-- Parametro de Auditoria Par_Empresa.

	Aud_Usuario				INT(11),		-- Parametro de Auditoria Aud_Usuario.
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Aud_FechaActual.
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Aud_DireccionIP.
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Aud_ProgramaID.
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Aud_Sucursal.

	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Aud_Numtransaccion.
)
TerminaStored:BEGIN

	-- Declaracion de Constantes.
	DECLARE Entero_Cero				INT(1);
	DECLARE Entero_Uno				INT(1);
	DECLARE CadenaVacia				CHAR(1);
	DECLARE FechaVacia				DATE;
	DECLARE DecimalCero				DECIMAL(18,2);
	DECLARE SalidaNO				CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE EstatusVigente			VARCHAR(1);
	DECLARE AltPoliza_NO			CHAR(1);
	DECLARE SabDom					CHAR(2);			-- Dia Inhabil: Sabado y Domingo
	DECLARE No_DiaHabil				CHAR(1);			-- No es dia habil
    DECLARE Con_TasaFija			CHAR(1);			-- Tasa Fija
    DECLARE Cons_NO					CHAR(1);			-- Constante no

	-- Declaracion de Variables.
	DECLARE Var_AportacionIDCur		INT(11);					-- Se utiliza en el CURSOR es para la AportacionID
	DECLARE Var_CuentaAhoIDCur		BIGINT(20);					-- Se utiliza en el CURSOR es para la cuenta de ahorro de la aportacion
	DECLARE Var_TipoAportacionIDCur	INT(11);					-- Se utiliza en el CURSOR es para el tipo de aportacion
	DECLARE Var_MonedaIDCur			INT(11);					-- Se utiliza en el CURSOR es para la moneda de la aportacion
	DECLARE Var_CapitalCur			DECIMAL(18,2);				-- Se utiliza en el CURSOR
	DECLARE Var_InteresRetenerCur	DECIMAL(18,2);				-- Se utiliza en el CURSOR
	DECLARE Var_ClienteIDCur		INT(11);					-- Se utiliza en el CURSOR
	DECLARE Var_SaldoProvisionCur	DECIMAL(18,2);				-- Se utiliza en el CURSOR
	DECLARE Var_CalculoInteresCur	INT(11);					-- Se utiliza en el CURSOR
	DECLARE	Var_MonedaBase			INT(11);					-- Se utiliza en el CURSOR
	DECLARE Var_NumVenAmorCur		INT(11);					-- Se utiliza en el CURSOR Numero de amortizacion
	DECLARE Var_DiaInhabil			CHAR(2);					-- Almacena el Dia Inhabil
	DECLARE Var_FecSal				DATE;						-- Almacena la Fecha de Salida
	DECLARE Var_EsHabil				CHAR(1);					-- Almacena si el dia es habil o no
	DECLARE Var_CliPaISR			CHAR(1);					-- Almacena si el dia es habil o no
	DECLARE Var_FechaSistema		DATE;						-- Almacena la Fecha del Sistema
	DECLARE Var_Control				VARCHAR(200);				-- ID del control de pantalla
	DECLARE Var_CajaRetiroCur		INT(11);					-- Caja de retiro pertenece al de la aportacion original
	DECLARE Var_EsAportMadre		INT(11);
	DECLARE Var_AportAnclaje		INT(11);
	DECLARE Var_AportMadreID		INT(11);
	DECLARE Var_MontoCur			DECIMAL(14,2);
	DECLARE Var_InteresGeneradoCur	DECIMAL(14,2);
	DECLARE Var_SucClienteCur		INT;
	DECLARE Var_AmortizacionIDCur	INT;
	DECLARE Var_NumAport			INT;
	DECLARE Var_FechaVenApCur		DATE;
	DECLARE VarFechaVenAmoCur		DATE;
	DECLARE VarIniciaAmoCur			DATE;
	DECLARE VarVenceAmoCur			DATE;
	DECLARE CalculoISRxCli  		CHAR(1);
	DECLARE ProcesoCierre  			CHAR(1);
	DECLARE InstAport				INT(11);
	DECLARE Error_SQLEXCEPTION		INT;
	DECLARE Error_DUPLICATEKEY		INT;
	DECLARE Error_VARUNQUOTED		INT;
	DECLARE Error_INVALIDNULL		INT;
	DECLARE Error_Key 				INT;			# Clave de Error en el ciclo del CURSOR
	DECLARE Mov_PagIntExe			VARCHAR(3);
	DECLARE TasaFija				INT(1);
	DECLARE Pol_Automatica			CHAR(1);
	DECLARE Mov_PagCedCap 			VARCHAR(4);
	DECLARE Var_RefPagoCed			VARCHAR(100);
	DECLARE Var_PagoAportr			INT(3);
	DECLARE Con_Capital				INT(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE Mov_AhorroSI			CHAR(1);
	DECLARE Var_ConcepProv			INT(1);
	DECLARE Tipo_Provision 			VARCHAR(4);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Ope_Interna				CHAR(1);
	DECLARE Tip_Compra				CHAR(1);
	DECLARE ProcesoDesdePant		CHAR(1);
	DECLARE NombreProceso			VARCHAR(10);
	DECLARE Var_ConcepISR			INT(1);
	DECLARE Mov_AhorroNO			CHAR(1);
	DECLARE Mov_PagIntGra			VARCHAR(4);
	DECLARE Cue_PagIntGra			VARCHAR(100);
	DECLARE StringSI				CHAR(1);
	DECLARE Var_Reinvertir			VARCHAR(3);
	DECLARE EstPagado				CHAR(1);
	DECLARE Impreso					CHAR(1);
	DECLARE EstVigente 				CHAR(1);
	DECLARE Est_Aplicado 			CHAR(1);
	DECLARE	TipoReg_Aport			INT(11);

	-- Declaracion de Variables.
	DECLARE Var_AportacionID		INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(20);
	DECLARE Var_TipoAportacionID	INT(11);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_Capital				DECIMAL(18,2);
	DECLARE Var_Interes				DECIMAL(18,2);
	DECLARE Var_InteresRetener		DECIMAL(18,2);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_SaldoProvision		DECIMAL(18,2);
	DECLARE Var_SucursalOrigen		INT(11);
	DECLARE Var_AmotizacionID		INT(11);
	DECLARE Var_AportFecVencim		DATE;
	DECLARE Var_AmoFecVecimiento	DATE;
	DECLARE Var_CalculoInteres		INT(11);
	DECLARE Cue_PagIntExe			VARCHAR(100);
	DECLARE Var_InteresPagar 		DECIMAL(18,2);
	DECLARE Var_NumVenAmor			INT(11);
	DECLARE Var_MovIntere			VARCHAR(4);
	DECLARE Cue_PagIntere			VARCHAR(50);
	DECLARE Var_Instrumento			VARCHAR(15);
	DECLARE Var_CuentaStr			VARCHAR(15);
	DECLARE Cue_RetAportr			VARCHAR(50);
	DECLARE Mov_PagCedRet			VARCHAR(4);
	DECLARE Var_TipCamCom			DECIMAL(8,4);
	DECLARE Var_IntRetMN			DECIMAL(12,2);

	DECLARE Var_NuevaAportID		INT(11);
	DECLARE Var_TasaISR				DECIMAL(12,4);
	DECLARE Var_PagaISR				DECIMAL(12,4);
	DECLARE Var_ConConReinv			INT(11);
	DECLARE Var_ConInvCapi			INT(11);
	DECLARE Var_ConAhoCapi			INT(11);
	DECLARE Mov_ApeAporta			VARCHAR(4);
	DECLARE Var_ConAltApor			INT(3);
	DECLARE Var_ConAportCapi		INT(1);
	DECLARE Var_Relaciones			VARCHAR(750);
	DECLARE Var_CalGAT				DECIMAL(12,4);
	DECLARE Var_CajaRetiro 			INT(11);				-- Caja Retiro de la Aportacion Original
	DECLARE Var_AportAnclajeID 		INT;
	DECLARE Var_Consecutivo 		VARCHAR(20);
 	DECLARE Var_IntRetenerReal		DECIMAL(18,2);
    DECLARE Var_IntRetenerTot		DECIMAL(18,2);
    DECLARE Var_InteresRetRei		DECIMAL(18,2);		-- PARA LA REINVERSION DE LA Aportacion
	DECLARE Factor_Porcen			DECIMAL(16,2);		-- Factor de Porcentaje
	DECLARE Var_DiasInversion		DECIMAL(12,4);		-- Variable que almacena los dias de Inversion
	DECLARE Var_MontoAport			DECIMAL(18,2);		-- Monto de la Aportacion
    DECLARE Var_InteresAport		DECIMAL(18,2);		-- Interes de la Aportacion
    DECLARE Var_TasaFV				CHAR(1);			-- variable de Tasa Fija o Variable
    DECLARE Var_Calific				CHAR(1);			-- Calificacion del cliente
    DECLARE Var_TasaBruta			DECIMAL(12,4);		-- Tasa original de la aportacion
	DECLARE Var_MontoGlobal			DECIMAL(18,2);		-- MONTO GLOBAL DEL CLIENTE Y SU GRUPO.
	DECLARE Var_TasaMontoGlobal		CHAR(1);			-- INDICA SI CALCULA LA TASA POR EL MONTO GLOBAL.
	DECLARE Var_IncluyeGpoFam		CHAR(1);			-- INDICA SI INCLUYE A SU GRUPO FAM EN EL MONTO.
    DECLARE Var_DiaPago				INT(11);			-- Especifica el dia de pago para aportaciones con tipo de pago programado
    DECLARE Var_Capitaliza			CHAR(1);			-- Indica si se capitaliza interes. S:si / N:no / I:indistinto
    DECLARE Var_OpcionAport			VARCHAR(50);		-- Nueva, Renovacion con +, Renovacion con – O Renovacion
    DECLARE Var_CantidadReno		DECIMAL(14,2);		-- Cantidad renovacion de aportacion
    DECLARE Var_InvRenovar			INT(11);			-- Inversion renovar
    DECLARE Var_Notas				VARCHAR(500);		-- Notas puntuales de la aportacion
    DECLARE Var_EspTasa				CHAR(1);			-- Guarda si la aportacion especifica tasa o no

	DECLARE PAGOAPORTCUR CURSOR FOR
	SELECT	Ap.AportacionID,		MIN(Ap.CuentaAhoID), 			MIN(Ap.TipoAportacionID),MIN(Ap.MonedaID),		MIN(Ap.Monto),
			MIN(Amo.Interes),		MIN(Amo.InteresRetener), 		Ap.ClienteID,			MIN(Ap.SaldoProvision),	MIN(cte.SucursalOrigen),
			MIN(Amo.AmortizacionID),MIN(Ap.FechaVencimiento),		MIN(Amo.FechaPago),		MIN(Ap.CalculoInteres),	COUNT(Ap.AportacionID),
			MIN(C.CajaRetiro),		MIN(Amo.Capital),				MIN(Amo.FechaInicio),	MIN(Amo.FechaVencimiento),
            MIN(cte.PagaISR),		MIN(C.TasaISR),					MIN(Amo.SaldoISR+Amo.SaldoIsrAcum),		MIN(Ap.PagoIntCapitaliza)
		FROM TMPVENCANTAPORT Ap
			INNER JOIN APORTACIONES C 	ON Ap.AportacionID = C.AportacionID
			INNER JOIN AMORTIZAAPORT Amo ON Ap.AportacionID = Amo.AportacionID
				AND Amo.Estatus = EstatusVigente
			INNER JOIN CLIENTES cte ON Ap.ClienteID = cte.ClienteID
		WHERE Ap.NumTransaccion = Aud_NumTransaccion
		GROUP BY Ap.ClienteID,Ap.AportacionID;


	-- Asignacion de Constantes.
	SET	Entero_Cero				:= 0;							-- Constante '0' Entero Cero.
	SET	Entero_Uno				:= 1;							-- Constante '0' Entero Cero.
	SET DecimalCero				:= 0.0;							-- Contante '0.0' DECIMAL Cero.
	SET	CadenaVacia				:= '';							-- Constante '' Cadena Vacia.
	SET FechaVacia				:= '1900-01-01';				-- Constante '1900-01-01' Fecha Vacia.
	SET SalidaNO				:= 'N';							-- Constante Salida NO 'N'.
	SET SalidaSI				:= 'S';							-- Constante Salida SI 'S'
	SET	EstatusVigente			:= 'N';							-- Constante Estatus Vigente 'N'.
	SET AltPoliza_NO			:= 'N';							-- Alta de la Poliza NO
	SET SabDom					:= 'SD';						-- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil				:= 'N';							-- No es dia habil
	SET Error_SQLEXCEPTION		:= 1;							-- Codigo de Error para el SQLSTATE: SQLEXCEPTION.
	SET Error_DUPLICATEKEY		:= 2; 							-- Codigo de Error para el SQLSTATE: LLAVE DUPLICADA, COLUMNA NO DEBE SER NULA, COLUMNA AMBIGUA, ETC.
	SET Error_VARUNQUOTED		:= 3; 							-- Codigo de Error para el SQLSTATE: VARIABLE SIN COMILLAS, FUNCIONES DE AGREGACION (GROUP BY, SUM, ETC), ETC.
	SET Error_INVALIDNULL		:= 4; 							-- Codigo de Error para el SQLSTATE: USO INVALIDO DEL VALOR NULL, ERROR OBTENIDO DESDE EXPRESON REGULAR.



	-- Asignacion de Variable.
	SET Var_AportacionIDCur			:= Entero_Cero;			-- Aportacion a Pagar.
	SET Var_CuentaAhoIDCur			:= Entero_Cero;			-- CuentaAho relacionada a la Aportacion.
	SET Var_TipoAportacionIDCur		:= Entero_Cero;			-- Tipo de Aportacion.
	SET Var_MonedaIDCur				:= Entero_Cero;			-- MonedaID.
	SET Var_CapitalCur				:= DecimalCero;			-- Capital a Pagar.
	SET Var_InteresRetenerCur		:= DecimalCero;			-- Interes a Reterner.
	SET Var_ClienteIDCur			:= Entero_Cero;			-- Cliente al que Pertenece la Aportacion.
	SET Var_SaldoProvisionCur		:= DecimalCero;			-- Provision a Pagar.
	SET Var_CalculoInteresCur		:= Entero_Cero;			-- Tipo de Calculo a Aplicar para el Interes.
	SET Var_MonedaBase				:= Entero_Cero;			-- Moneda Base.
	SET Var_NumVenAmorCur			:= Entero_Cero;			-- Numero de Amortiaciones que Vencen.
	SET Var_InteresGeneradoCur		:= DecimalCero;			-- Inicializacion de Variables
	SET Var_SucClienteCur			:= Entero_Cero;			-- Inicializacion de Variables
	SET Var_AmortizacionIDCur		:= Entero_Cero;			-- Inicializacion de Variables
	SET Var_NumAport				:= Entero_Cero;			-- Inicializacion de Variables
	SET InstAport					:= 31;

	SET SalidaSI 		:= 'S'; 							-- Constante Salida SI 'S'
	SET	EstatusVigente	:=	'N';							-- Constante Estatus Vigente 'N'.
	SET Mov_PagIntExe 	:= 	'604'; 							-- PAGO APORTACION. INTERES EXCENTO
	SET Cue_PagIntExe 	:= 	'INTERESES GENERADOS';			-- Descripcion Pago Aportacion Interes Excento.
	SET Mov_PagIntGra 	:= 	'603'; 							-- PAGO APORTACION. INTERES GRAVADO
	SET Cue_PagIntGra 	:= 	'INTERESES GENERADOS';			-- Descripcion Pago Aportacion Interes Gravado.
	SET TasaFija		:=	1;								-- Indica que la Aportacion es de TASA FIJA.
	SET Pol_Automatica 	:= 	'A'; 		 					-- Constante Poliza Automatica.
	SET Mov_PagCedCap 	:= 	'602'; 							-- PAGO DE APORTACION CAPITAL.
	SET Var_RefPagoCed 	:= 	'VENCIMIENTO DE INVERSION';		-- Descripcion Pago de Aportacion.
	SET Var_PagoAportr 	:= 	902;							-- Concepto Contable: Pago de Aportacion
	SET Con_Capital 	:= 	1; 								-- Concepto Contable de Ahorro: Capital
	SET Nat_Abono 		:= 	'A'; 							-- Naturaleza de Abono
	SET Nat_Cargo 		:= 	'C'; 							-- Naturaleza de Cargo
	SET AltPoliza_NO 	:= 	'N'; 							-- Alta de la Poliza NO
	SET Mov_AhorroSI 	:= 	'S'; 							-- Movimiento de Ahorro: SI
	SET Var_ConcepProv 	:= 	5; 								-- Concepto Contable de Aportacion: Provision
	SET Tipo_Provision 	:= 	'100'; 							-- Tipo de Movimiento de Aportacion: Provision
	SET Cue_RetAportr 	:= 	'RETENCION ISR';				-- Descripcion Retencion ISR.
	SET Mov_PagCedRet 	:= 	'605'; 							-- PAGO APORTACION. RETENCION
	SET Ope_Interna 	:= 	'I'; 							-- Tipo de Operacion: Interna
	SET Tip_Compra 		:= 	'C'; 							-- Tipo de Operacion: Compra de Divisa
	SET NombreProceso 	:= 	'Aportacion'; 					-- Descripcion Proceso Aportacion.
	SET Var_ConcepISR 	:= 	4; 								-- Concepto Contable de Aportacion: Retencion
	SET Mov_AhorroNO 	:= 	'N'; 							-- Movimiento de Ahorro: NO
	SET Var_ConConReinv	:= 11;								-- Descripcion reinversion
	SET Var_ConInvCapi	:= 1;								-- Movimiento Inversion Capital
	SET Var_ConAhoCapi 	:= 1;								-- Movimieto Ahorro
	SET Mov_ApeAporta	:= '601'; 							-- Apertura de Aportacion Tabla TIPOSMOVSAHO.
	SET Var_ConAltApor 	:= 900;								-- Movimiento Aportacion
	SET Var_ConAportCapi := 1;								-- ConceptosAhorro.
	SET StringSI		:= 'S';								-- Contante SI.
	SET EstPagado		:= 'P';								-- Constante Estatus Pagado
	SET ProcesoDesdePant:= 'P';								-- Constante Estatus Pagado
	SET Impreso			:= 'I';								-- Constante Estatus Impreso
	SET SabDom			:= 'SD';				 			-- Dia Inhabil: Sabado y Domingo
	SET No_DiaHabil		:= 'N';					 			-- No es dia habil
	SET EstVigente 		:= 'N'; 							-- Valor Estatus Vigente
	SET Est_Aplicado 	:= 'A'; 							-- Valor Estatus Vigente
    SET CalculoISRxCli  := 'C';         					-- Tipo de Calculo ISR por cliente
    SET ProcesoCierre  	:= 'C';         					-- Tipo de Calculo ISR por cliente
    SET Con_TasaFija	:= 'F';								-- Constante Tasa Fija
    SET Cons_NO			:= 'N';
	SET	TipoReg_Aport	:= 01;								-- Tipo de Registro Alta de aportaciones.

	SET Aud_FechaActual	:= NOW();

	-- Asignacion de Variable.
	SET Var_AportacionID		:=	Entero_Cero;				-- Aportacion a Pagar.
	SET Var_CuentaAhoID			:=	Entero_Cero;				-- CuentaAho relacionada a la Aportacion.
	SET Var_TipoAportacionID	:=	Entero_Cero;				-- Tipo de Aportacion.
	SET Var_MonedaID			:=	Entero_Cero;				-- MonedaID.
	SET Var_Capital				:=	DecimalCero;				-- Capital a Pagar.
	SET Var_Interes				:=	DecimalCero;				-- Interes a Pagar.
	SET Var_InteresRetener		:=	DecimalCero;				-- Interes a Reterner.
	SET Var_ClienteID			:=	Entero_Cero;				-- Cliente al que Pertenece la Aportacion.
	SET Var_SaldoProvision		:=	DecimalCero;				-- Provision a Pagar.
	SET Var_SucursalOrigen		:=	Entero_Cero;				-- Sucursal Origen del Cliente.
	SET Var_AmotizacionID		:=	Entero_Cero;				-- Numero de Amortizacion a Pagar.
	SET Var_AportFecVencim		:=	FechaVacia;					-- Fecha de Vencimiento de la Aportacion.
	SET Var_AmoFecVecimiento	:=	FechaVacia;					-- Fecha de Vencimiento de la Amortizacion.
	SET Var_CalculoInteres		:=	Entero_Cero;				-- Tipo de Calculo a Aplicar para el Interes.
	SET Var_InteresPagar		:=	DecimalCero;				-- Interes a Pagar.
	SET Var_MonedaBase			:=	Entero_Cero;				-- Moneda Base.
	SET Var_NumVenAmor			:=	Entero_Cero;				-- Numero de Amortiaciones que Vencen.
	SET Var_MovIntere			:=	CadenaVacia;				-- Inicializacion de Variables
	SET Cue_PagIntere			:=	CadenaVacia;				-- Inicializacion de Variables

	SET Var_NuevaAportID		:=	Entero_Cero;				-- Inicializacion de Variables
	SET Var_TasaISR				:=	DecimalCero;				-- Inicializacion de Variables
	SET Var_PagaISR				:=	DecimalCero;				-- Inicializacion de Variables
	SET Var_IntRetenerTot		:=  DecimalCero;
    SET Var_IntRetenerReal		:=  DecimalCero;
    SET Var_InteresRetRei		:=  DecimalCero;
    SET Factor_Porcen			:= 100.00;			-- Constante Cien

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-APORTPAGOPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- Inicia Proceso de Pago de Aportacion.
		-- Obtenemos la Fecha del Sistema y la Moneda Base
		SELECT FechaSistema, MonedaBaseID
			INTO Var_FechaSistema, Var_MonedaBase
		FROM PARAMETROSSIS LIMIT 1;

		-- Parametrización del Tipo de Aportación.
		SELECT
			TasaMontoGlobal,		IncluyeGpoFam
		INTO
			Var_TasaMontoGlobal,	Var_IncluyeGpoFam
			FROM 	TIPOSAPORTACIONES
			WHERE	TipoAportacionID	= Par_TipoAportacionID;

		-- Cálculo del Monto Global del Cliente.
		SET Var_MontoGlobal :=(FNAPORTMONTOGLOBAL(Par_TipoAportacionID,Par_ClienteID)+IFNULL(Par_Monto,Entero_Cero));

		/** -- ------------------------------------------------------------------------------------ **/
		/** -- VALIDACION DE QUE SI ES Aportacion MADRE ------------------------------------------------- **/
		/** -- ------------------------------------------------------------------------------------ **/
		-- Se obtiene la aportacion madre
		SET Var_AportMadreID :=	(SELECT AportacionOriID
									FROM APORTANCLAJE
									WHERE AportacionAncID = Par_AportacionID LIMIT 1);

		SET Var_AportMadreID := IFNULL(Var_AportMadreID, Par_AportacionID);
		DELETE FROM TMPVENCANTAPORT WHERE NumTransaccion = Aud_NumTransaccion;
		-- Inserta la aportacion madre a la tabla temporal
		INSERT INTO TMPVENCANTAPORT(
			AportacionID,	CuentaAhoID,		TipoAportacionID,	MonedaID,		ClienteID,
			SaldoProvision,	FechaVencimiento,	CalculoInteres,		Estatus,		Reinversion,
			Monto,			PagoIntCapitaliza,	EmpresaID, 			UsuarioID,		FechaActual,
            DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
		SELECT 	AportacionID,	CuentaAhoID, 		TipoAportacionID,MonedaID, 		ClienteID,
				SaldoProvision, FechaVencimiento, 	CalculoInteres, Estatus,		Reinversion,
				Monto,			PagoIntCapitaliza,	EmpresaID, 		UsuarioID,		FechaActual,
                DireccionIP,	ProgramaID,			Sucursal,		Aud_NumTransaccion
		FROM APORTACIONES
			WHERE AportacionID = Var_AportMadreID;

		-- Inserta los anclajes a la tabla temporal
		SET Var_NumAport := (SELECT COUNT(*)	FROM APORTACIONES AP
								INNER JOIN APORTANCLAJE AN ON AP.AportacionID = AN.AportacionAncID AND AP.Estatus = EstatusVigente
									WHERE AN.AportacionOriID = Var_AportMadreID);

		IF(IFNULL(Var_NumAport,Entero_Cero) > Entero_Cero) THEN
			INSERT INTO TMPVENCANTAPORT(
				AportacionID,	CuentaAhoID,		TipoAportacionID,	MonedaID, 		ClienteID,
				SaldoProvision, FechaVencimiento, 	CalculoInteres, 	Estatus,		Reinversion,
				Monto,			PagoIntCapitaliza,	EmpresaID, 			UsuarioID,		FechaActual,
               	DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)

			SELECT 	AP.AportacionID,	AP.CuentaAhoID, 		AP.TipoAportacionID,AP.MonedaID, 	AP.ClienteID,
					AP.SaldoProvision, 	AP.FechaVencimiento, 	AP.CalculoInteres, 	AP.Estatus,		AP.Reinversion,
					AP.Monto,			AP.PagoIntCapitaliza,	AP.EmpresaID, 		AP.UsuarioID,	AP.FechaActual,
					AP.DireccionIP,		AP.ProgramaID,			AP.Sucursal,		Aud_NumTransaccion
			FROM APORTACIONES AP
			INNER JOIN APORTANCLAJE AN ON AP.AportacionID = AN.AportacionAncID AND AP.Estatus = EstatusVigente
			WHERE AN.AportacionOriID = Var_AportMadreID;
		END IF;

		SET Var_NumAport := (SELECT	COUNT(*)
			FROM TMPVENCANTAPORT Ap
				INNER JOIN APORTACIONES C 	ON Ap.AportacionID = C.AportacionID
				INNER JOIN AMORTIZAAPORT Amo ON Ap.AportacionID = Amo.AportacionID
					AND Amo.Estatus = EstatusVigente
				INNER JOIN CLIENTES cte ON Ap.ClienteID = cte.ClienteID
			WHERE Ap.NumTransaccion = Aud_NumTransaccion);

		SET Var_NumAport := IFNULL(Var_NumAport,Entero_Cero);

		 IF(IFNULL(Var_NumAport,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr :=1;
			SET Par_ErrMen	:= CONCAT('La Aportacion ya se encuentra Pagada o Cancelada');
			LEAVE ManejoErrores;
		 END IF;

		/** -- ------------------------------------------------------------------------------------ **/
		/** -- FIN VALIDACION DE QUE SI ES Aportacion MADRE --------------------------------------------- **/
		/** -- ------------------------------------------------------------------------------------ **/
		/** SE ABRE CURSOR PARA PAGAR LAS APORTACIONES HIJAS */
		Open PAGOAPORTCUR;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION 		SET Error_Key := Error_SQLEXCEPTION;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000'	SET Error_Key := Error_DUPLICATEKEY;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000'	SET Error_Key := Error_VARUNQUOTED;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004'	SET Error_Key := Error_INVALIDNULL;
			DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;
			CICLOPAGOAPORTCUR:LOOP
				FETCH PAGOAPORTCUR INTO
					Var_AportacionIDCur,		Var_CuentaAhoIDCur,		Var_TipoAportacionIDCur,Var_MonedaIDCur,		Var_MontoCur,
					Var_InteresGeneradoCur,		Var_InteresRetenerCur,	Var_ClienteIDCur,		Var_SaldoProvisionCur,	Var_SucClienteCur,
					Var_AmortizacionIDCur,		Var_FechaVenApCur,		VarFechaVenAmoCur,		Var_CalculoInteresCur,	Var_NumVenAmorCur,
					Var_CajaRetiroCur,			Var_CapitalCur,			VarIniciaAmoCur,		VarVenceAmoCur,			Var_CliPaISR,
                    Var_TasaISR,				Var_IntRetenerReal,		Var_Capitaliza;

				IF(Error_Key = 1 ) THEN LEAVE CICLOPAGOAPORTCUR; END IF;


				SET Var_IntRetenerTot	:= Var_IntRetenerTot + Var_IntRetenerReal;


				CALL APORTPAGOINDPRO(
					Var_AportacionIDCur,			Par_Fecha,				Par_Reinversion,		Par_Reinvertir,		Par_EsReinversion,
					Var_TipoAportacionIDCur,		Var_CuentaAhoIDCur,		Var_ClienteIDCur,		Par_FechaInicio,	Par_FechaVencimiento,
					Var_MontoCur,			Par_Plazo,				Par_TasaFija,			Par_TasaISR,		Par_TasaNeta,
					Var_CalculoInteresCur,	Par_TasaBaseID,			Par_SobreTasa,			Par_PisoTasa,		Par_TechoTasa,
					Var_InteresGeneradoCur,	Par_InteresRecibir,		Var_InteresRetenerCur,	Par_CalGATReal,		Par_ValorGat,
					Par_TipoPagoInt,		Par_PlazoOriginal,		Par_AltaEnPoliza,		Var_AportMadreID,	SalidaNO,
					Par_Poliza,				Par_NumErr,				Par_ErrMen,				Par_Empresa,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr!=0 OR Error_Key>0)THEN
					LEAVE CICLOPAGOAPORTCUR;
				END IF;

				DELETE FROM TMPVENCANTAPORT WHERE AportacionID=Var_AportacionIDCur;
			END LOOP CICLOPAGOAPORTCUR;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END;
		Close PAGOAPORTCUR;
		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Aportacion Abonada Exitosamente';
        SET Var_Control := 'aportID';

		-- Reinversion Manual de Aportacion.
		IF(Par_EsReinversion = StringSI)THEN

			-- Obtenemos las Amortizaciones con Fecha de Vencimiento Menor o Igual a la Actual.
			SELECT	MIN(Ap.AportacionID),	MIN(Ap.CuentaAhoID),    	MIN(Ap.TipoAportacionID),	MIN(Ap.MonedaID),		SUM(amo.Capital),
					SUM(amo.Interes),		SUM(amo.InteresRetener), 	MIN(Ap.ClienteID),			MIN(Ap.SaldoProvision),	MIN(cte.SucursalOrigen),
					MAX(amo.AmortizacionID),MAX(Ap.FechaVencimiento),	MAX(amo.FechaPago),			MIN(Ap.CalculoInteres),	COUNT(Ap.AportacionID),
					MIN(Ap.CajaRetiro),		MIN(Ap.Monto),				MIN(Ap.InteresGenerado),	MIN(Ap.DiasPago),		MIN(Ap.PagoIntCapitaliza),
                    MIN(Ap.OpcionAport),	MIN(Ap.CantidadReno),		MIN(Ap.InvRenovar),			MIN(Ap.Notas)
			INTO	Var_AportacionID,		Var_CuentaAhoID,			Var_TipoAportacionID,		Var_MonedaID,			Var_Capital,
					Var_Interes,			Var_InteresRetener,			Var_ClienteID,				Var_SaldoProvision,		Var_SucursalOrigen,
					Var_AmotizacionID,		Var_AportFecVencim,			Var_AmoFecVecimiento,		Var_CalculoInteres,		Var_NumVenAmor,
					Var_CajaRetiro,			Var_MontoAport,				Var_InteresAport,			Var_DiaPago,			Var_Capitaliza,
                    Var_OpcionAport, 		Var_CantidadReno, 			Var_InvRenovar, 			Var_Notas
				FROM APORTACIONES Ap
						INNER JOIN AMORTIZAAPORT amo ON Ap.AportacionID = amo.AportacionID AND amo.FechaPago <= Par_Fecha
						INNER JOIN CLIENTES cte ON Ap.ClienteID = cte.ClienteID
				  WHERE Ap.AportacionID =Par_AportacionID;

			/*Obtengo los Dias de Inversion*/
					SELECT 		DiasInversion
						INTO 	Var_DiasInversion
						FROM 	PARAMETROSSIS;

		SET Var_InteresRetRei :=(SELECT IFNULL(ISRReal,Entero_Cero)
										FROM APORTACIONES
                                        WHERE AportacionID =Par_AportacionID);
           /*Obtenemos el Monto Correcto a Reinvertir*/
			IF(Par_Reinvertir	= 'CI') THEN
					SET Par_Monto := Var_MontoAport + Var_InteresAport-Var_InteresRetRei;

			  ELSE
					SET Par_Monto := Var_MontoAport;
            END IF;

			SET Var_NuevaAportID := (SELECT IFNULL(MAX(AportacionID), Entero_Cero) + 1
											FROM APORTACIONES);
			SET Var_Reinvertir	:= (SELECT IFNULL(Reinvertir,CadenaVacia)
										FROM APORTACIONES
										WHERE AportacionID =Par_AportacionID);
			SET Var_InteresRetRei :=(SELECT IFNULL(ISRReal,Entero_Cero)
										FROM APORTACIONES
                                        WHERE AportacionID =Par_AportacionID);

			IF(Par_CalculoInteres = 1) THEN
				SET Var_CalGAT := FUNCIONCALCTAGATAPORTACION(Par_FechaVencimiento,Par_FechaInicio,Par_TasaFija);
			ELSE
				SET Var_CalGAT := Par_ValorGat;
			END IF;

			SET Par_Monto := IFNULL(Par_Monto, Entero_Cero);
			SET Par_InteresGenerado := ROUND((Par_Monto * Par_Plazo * Par_TasaFija) / (Factor_Porcen * Var_DiasInversion), 2);

			INSERT INTO APORTACIONES(
				AportacionID,			TipoAportacionID,		CuentaAhoID,		ClienteID,			 	FechaInicio,
				FechaVencimiento,		FechaPago,				Monto,				Plazo,					TasaFija,
				TasaISR,				TasaNeta,				CalculoInteres,		TasaBase,				SobreTasa,
				PisoTasa,				TechoTasa,				InteresGenerado,	InteresRecibir,			InteresRetener,
				SaldoProvision,			ValorGat,				ValorGatReal,		EstatusImpresion,		MonedaID,
				FechaVenAnt,			FechaApertura,			Estatus,			TipoPagoInt,			DiasPeriodo,
				PagoIntCal,				AportacionRenovada,		PlazoOriginal,		SucursalID,				Reinvertir,
                Reinversion,			CajaRetiro,				TasaMontoGlobal,	IncluyeGpoFam,			MontoGlobal,
                DiasPago,				PagoIntCapitaliza,		OpcionAport,		CantidadReno,			InvRenovar,
				Notas,					EmpresaID,				UsuarioID,			FechaActual,			DireccionIP,
                ProgramaID,				Sucursal,				NumTransaccion)
			VALUES(
				Var_NuevaAportID,		Par_TipoAportacionID,	Par_CuentaAhoID,		Par_ClienteID,			Par_FechaInicio,
				Par_FechaVencimiento,	Par_FechaVencimiento,	Par_Monto,				Par_Plazo,				Par_TasaFija,
				Par_TasaISR,			Par_TasaNeta,			Par_CalculoInteres,		Par_TasaBaseID,			Par_SobreTasa,
				Par_PisoTasa,			Par_TechoTasa,			Par_InteresGenerado,	Par_InteresRecibir,		Par_InteresRetener,
				DecimalCero,			Var_CalGAT,				Par_CalGATReal,			Impreso,				Var_MonedaBase,
				FechaVacia,				FechaVacia,				EstatusVigente,			Par_TipoPagoInt,		Par_DiasPeriodo,
                Par_PagoIntCal,			Par_AportacionID,		Par_PlazoOriginal,		Aud_Sucursal,			Par_Reinvertir,
                Par_Reinversion,		Var_CajaRetiro,			Var_TasaMontoGlobal,	Var_IncluyeGpoFam,		Var_MontoGlobal,
                Var_DiaPago,			Var_Capitaliza,			Var_OpcionAport,		Var_CantidadReno,		Var_InvRenovar,
				Var_Notas,				Par_Empresa,			Aud_Usuario,	 		Aud_FechaActual,		Aud_DireccionIP,
                Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA Aportacion */
			CALL APORTAMORTIZAPRO(
				Var_NuevaAportID,		Par_FechaInicio,	Par_FechaVencimiento,	Par_Monto,			Par_ClienteID,
				Par_TipoAportacionID,	Par_TasaFija,		Par_TipoPagoInt,		Par_DiasPeriodo,	Par_PagoIntCal,
                Var_DiaPago,			Par_PlazoOriginal,	Var_Capitaliza,			SalidaNO,			Par_NumErr,
                Par_ErrMen,				Par_Empresa,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			/*FIN DE LLAMADO AL SP QUE GENERA LAS AMORTIZACIONES*/

			-- Generamos el Movimiento Contable para la Apertura de la Nueva Aportacion.
			CALL CONTAAPORTPRO(
				Var_NuevaAportID,	Par_Empresa,		Par_FechaInicio,		Par_Monto,			Mov_ApeAporta,
				Var_ConAltApor,		Var_ConAportCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
				Mov_AhorroSI,		AltPoliza_NO,		Par_Poliza,				Par_NumErr,			Par_ErrMen,
				Var_CuentaAhoID,	Var_ClienteID,		Var_MonedaBase,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

            -- Se obtiene si es tasa fija o variable
            SELECT	TasaFV,EspecificaTasa
			INTO 	Var_TasaFV,Var_EspTasa
			FROM 	TIPOSAPORTACIONES
			WHERE	TipoAportacionID	= Par_TipoAportacionID;
            SET Var_EspTasa :=IFNULL(Var_EspTasa,Cons_NO);

            /* Si el tipo de aportacion tiene Calculo Interes a tasa fija y
            la aportacion cambio de tasa manualmente, se hace el INSERT a la tabla CAMBIOTASAAPORT*/
			IF (Var_TasaFV = Con_TasaFija AND Var_EspTasa=StringSI) THEN
				SET Var_Calific 	:= (SELECT CalificaCredito FROM CLIENTES WHERE ClienteID=Par_ClienteID);
				SET Var_TasaBruta	:= ROUND(FUNCIONTASAAPORTACION(Par_TipoAportacionID , Par_PlazoOriginal , Var_MontoGlobal, Var_Calific, Aud_Sucursal),2);
                -- Var_TasaBruta: es el valor de la tasa calculado por SAFI
                -- Par_TasaFija es el valor de la tasa ingresada desde la pantalla de reinversion manual
				IF(Var_TasaBruta <> Par_TasaFija)THEN
					CALL CAMBIOTASAAPORTALT(
						Var_NuevaAportID,	Var_TasaBruta,		Par_TasaFija, 		TipoReg_Aport,		SalidaNO,
						Par_NumErr,			Par_ErrMen,			Par_Empresa, 		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				END IF;

                IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen 	:= CONCAT('Aportacion Reinvertida Exitosamente.', Var_NuevaAportID);
			SET Var_Control := 'aportID';
            SET Var_Consecutivo := Var_NuevaAportID;

		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen		 AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	 AS consecutivo;
	END IF;

END TerminaStored$$

