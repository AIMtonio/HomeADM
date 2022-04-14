-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCEDEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCEDEPRO`;
DELIMITER $$

CREATE PROCEDURE `PAGOCEDEPRO`(
	/* SP para la Reinversion Individual de CEDES */
	Par_CedeID				INT(11),		-- Id de la CEDE a Pagar.
	Par_Fecha				DATE,			-- Fecha en la que Vence la CEDE.
	Par_Reinversion			CHAR(1),
	Par_Reinvertir			CHAR(2),		-- Indica si despues de Pagar se Reinvertira la CEDE. S.-Si N.-No
	Par_EsReinversion		CHAR(1),

	Par_TipoCedeID			INT(11),		-- Indica el Tipo de CEDE.
	Par_CuentaAhoID			BIGINT(20),		-- Cuenta de Ahorro relacionada a la CEDE.
	Par_ClienteID			INT(11),		-- ClienteID relacionado a la CEDE.
	Par_FechaInicio			DATE,			-- Fecha de Inicio de la CEDE.
	Par_FechaVencimiento	DATE,			-- Fecha de Vencimiento de la CEDE.

	Par_Monto				DECIMAL(18,2),	-- Monto de la CEDE.
	Par_Plazo				INT(11),		-- Plazo de la CEDE.
	Par_TasaFija			DECIMAL(12,4),	-- Tasa de la CEDE.
	Par_TasaISR				DECIMAL(12,4),	-- Tasa ISR.
	Par_TasaNeta			DECIMAL(12,4),	-- Tasa Neta.

	Par_CalculoInteres		INT(11),		-- Tipo de Formula Aplicada a la CEDE.
	Par_TasaBaseID			INT(11),		-- Tasa Base Aplicada a la CEDE.
	Par_SobreTasa			DECIMAL(12,4),	-- Sobre Tasa Aplicada a la CEDE.
	Par_PisoTasa			DECIMAL(12,4),	-- Piso Tasa Aplicada a la CEDE.
	Par_TechoTasa			DECIMAL(12,4),	-- Techo Tasa Aplicado a la CEDE.

	Par_InteresGenerado		DECIMAL(18,2),	-- Interes Genereado de la CEDE.
	Par_InteresRecibir		DECIMAL(18,2),	-- Interes Neto a Recibir de la CEDE.
	Par_InteresRetener		DECIMAL(18,2),	-- Interes a Retener de la CEDE.
	Par_CalGATReal			DECIMAL(18,2),	-- Gat REAL.
	Par_ValorGat			DECIMAL(18,2),	-- Gat Nominal

	Par_TipoPagoInt			VARCHAR(4),		-- Indica si es a FIN DE MES (F) o al VENCIMIENTO (V) o por PERIODO(P)
	Par_DiasPeriodo			INT(11),		-- Especifica los dias por periodo cuando la forma de pago de interes es por periodo
	Par_PagoIntCal			CHAR(2),		-- Especifica el tipo de pago de interes D - Devengado, I - Iguales
	Par_PlazoOriginal		INT(11),		-- Plazo Original de la CEDE.
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
	DECLARE SabDom					CHAR(2);			/*Dia Inhabil: Sabado y Domingo */
	DECLARE No_DiaHabil				CHAR(1);			/* No es dia habil */

	-- Declaracion de Variables.
	DECLARE Var_CedeIDCur			INT(11);					-- Se utiliza en el CURSOR es para la CedeID
	DECLARE Var_CuentaAhoIDCur		BIGINT(20);					-- Se utiliza en el CURSOR es para la cuenta de ahorro de la cede
	DECLARE Var_TipoCedeIDCur		INT(11);					-- Se utiliza en el CURSOR es para el tipo de cede
	DECLARE Var_MonedaIDCur			INT(11);					-- Se utiliza en el CURSOR es para la moneda de la cede
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
	DECLARE Var_CajaRetiroCur		INT(11);					-- Caja de retiro pertenece al de la cede original
	DECLARE Var_EsCedeMadre			INT(11);
	DECLARE Var_CedeAnclaje			INT(11);
	DECLARE Var_CedeMadreID			INT(11);
	DECLARE Var_MontoCur			DECIMAL(14,2);
	DECLARE Var_InteresGeneradoCur	DECIMAL(14,2);
	DECLARE Var_SucClienteCur		INT;
	DECLARE Var_AmortizacionIDCur	INT;
	DECLARE Var_NCedes				INT;
	DECLARE VarFechaVenCedeCur		DATE;
	DECLARE VarFechaVenAmoCur		DATE;
	DECLARE VarIniciaAmoCur			DATE;
	DECLARE VarVenceAmoCur			DATE;
	DECLARE CalculoISRxCli  		CHAR(1);
	DECLARE ProcesoCierre  			CHAR(1);
	DECLARE InstCede				INT(11);
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
	DECLARE Var_PagoCeder			INT(3);
	DECLARE Var_ConCedCapi			INT(1);
	DECLARE Con_Capital				INT(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE Mov_AhorroSI			CHAR(1);
	DECLARE Var_ConCedProv			INT(1);
	DECLARE Tipo_Provision 			VARCHAR(4);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Ope_Interna				CHAR(1);
	DECLARE Tip_Compra				CHAR(1);
	DECLARE ProcesoDesdePant		CHAR(1);
	DECLARE NombreProceso			VARCHAR(10);
	DECLARE Var_ConCedISR			INT(1);
	DECLARE Mov_AhorroNO			CHAR(1);
	DECLARE Mov_PagIntGra			VARCHAR(4);
	DECLARE Cue_PagIntGra			VARCHAR(100);
	DECLARE StringSI				CHAR(1);
	DECLARE Var_Reinvertir			VARCHAR(3);
	DECLARE EstPagado				CHAR(1);
	DECLARE Impreso					CHAR(1);
	DECLARE EstVigente 				CHAR(1);
	DECLARE Est_Aplicado 			CHAR(1);
	DECLARE Estatus_Inactivo    	CHAR(1);

	-- Declaracion de Variables.
	DECLARE Var_CedeID				INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(20);
	DECLARE Var_TipoCedeID			INT(11);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_Capital				DECIMAL(18,2);
	DECLARE Var_Interes				DECIMAL(18,2);
	DECLARE Var_InteresRetener		DECIMAL(18,2);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_SaldoProvision		DECIMAL(18,2);
	DECLARE Var_SucursalOrigen		INT(11);
	DECLARE Var_AmotizacionID		INT(11);
	DECLARE Var_CedeFecVencimiento	DATE;
	DECLARE Var_AmoFecVecimiento	DATE;
	DECLARE Var_CalculoInteres		INT(11);
	DECLARE Cue_PagIntExe			VARCHAR(100);
	DECLARE Var_InteresPagar 		DECIMAL(18,2);
	DECLARE Var_NumVenAmor			INT(11);
	DECLARE Var_MovIntere			VARCHAR(4);
	DECLARE Cue_PagIntere			VARCHAR(50);
	DECLARE Var_Instrumento			VARCHAR(15);
	DECLARE Var_CuentaStr			VARCHAR(15);
	DECLARE Cue_RetCeder			VARCHAR(50);
	DECLARE Mov_PagCedRet			VARCHAR(4);
	DECLARE Var_TipCamCom			DECIMAL(8,4);
	DECLARE Var_IntRetMN			DECIMAL(12,2);

	DECLARE Var_NuevaCedeID			INT(11);
	DECLARE Var_TasaISR				DECIMAL(12,4);
	DECLARE Var_PagaISR				DECIMAL(12,4);
	DECLARE Var_ConConReinv			INT(11);
	DECLARE Var_ConInvCapi			INT(11);
	DECLARE Var_ConAhoCapi			INT(11);
	DECLARE Mov_ApeCede				VARCHAR(4);
	DECLARE Var_ConAltCed			INT(3);
	DECLARE Var_ConCedeCapi			INT(1);
	DECLARE Var_Relaciones			VARCHAR(750);
	DECLARE Var_CalGAT				DECIMAL(12,4);
	DECLARE Var_CajaRetiro 			INT(11);				-- Caja Retiro de la CEDE Original
	DECLARE Var_CedeAnclajeID 		INT;
	DECLARE Var_Consecutivo 		VARCHAR(20);
 	DECLARE Var_IntRetenerReal		DECIMAL(18,2);
    DECLARE Var_IntRetenerTot		DECIMAL(18,2);
    DECLARE Var_InteresRetRei		DECIMAL(18,2);		-- PARA LA REINVERSION DE LA CEDE
	DECLARE Factor_Porcen			DECIMAL(16,2);		-- Factor de Porcentaje
	DECLARE Var_DiasInversion		DECIMAL(12,4);		-- Variable que almacena los dias de Inversion
	DECLARE Var_MontoCede			DECIMAL(18,2);		-- Monto de la Cede
    DECLARE Var_InteresCede			DECIMAL(18,2);		-- Interes de la Cede
    DECLARE Var_EstatusTipoCede		CHAR(2);			-- Estatus del Tipo Cede
	DECLARE Var_Descripcion			VARCHAR(200);		-- Descripcion Tipo Cede

	DECLARE PAGOCEDECUR CURSOR FOR
	SELECT	Ced.CedeID,				MIN(Ced.CuentaAhoID), 			MIN(Ced.TipoCedeID),	MIN(Ced.MonedaID),			MIN(Ced.Monto),
			MIN(Amo.Interes),		MIN(Amo.InteresRetener), 		Ced.ClienteID,			MIN(Ced.SaldoProvision),	MIN(cte.SucursalOrigen),
			MIN(Amo.AmortizacionID),MIN(Ced.FechaVencimiento),		MIN(Amo.FechaPago),		MIN(Ced.CalculoInteres),	COUNT(Ced.CedeID),
			MIN(C.CajaRetiro),		MIN(Amo.Capital),				MIN(Amo.FechaInicio),	MIN(Amo.FechaVencimiento),
            MIN(cte.PagaISR),		MIN(C.TasaISR),					MIN(Amo.ISRCal)
		FROM TMPVENCIMANTCEDE Ced
			INNER JOIN CEDES C 	ON Ced.CedeID = C.CedeID
			INNER JOIN AMORTIZACEDES Amo ON Ced.CedeID = Amo.CedeID
				AND Amo.Estatus = EstatusVigente
			INNER JOIN CLIENTES cte ON Ced.ClienteID = cte.ClienteID
		WHERE Ced.NumTransaccion = Aud_NumTransaccion
		GROUP BY Ced.ClienteID,Ced.CedeID;


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
	SET Var_CedeIDCur				:= Entero_Cero;			-- CEDE a Pagar.
	SET Var_CuentaAhoIDCur			:= Entero_Cero;			-- CuentaAho relacionada a la CEDE.
	SET Var_TipoCedeIDCur			:= Entero_Cero;			-- Tipo de CEDE.
	SET Var_MonedaIDCur				:= Entero_Cero;			-- MonedaID.
	SET Var_CapitalCur				:= DecimalCero;			-- Capital a Pagar.
	SET Var_InteresRetenerCur		:= DecimalCero;			-- Interes a Reterner.
	SET Var_ClienteIDCur			:= Entero_Cero;			-- Cliente al que Pertenece la CEDE.
	SET Var_SaldoProvisionCur		:= DecimalCero;			-- Provision a Pagar.
	SET Var_CalculoInteresCur		:= Entero_Cero;			-- Tipo de Calculo a Aplicar para el Interes.
	SET Var_MonedaBase				:= Entero_Cero;			-- Moneda Base.
	SET Var_NumVenAmorCur			:= Entero_Cero;			-- Numero de Amortiaciones que Vencen.
	SET Var_InteresGeneradoCur		:= DecimalCero;			-- Inicializacion de Variables
	SET Var_SucClienteCur			:= Entero_Cero;			-- Inicializacion de Variables
	SET Var_AmortizacionIDCur		:= Entero_Cero;			-- Inicializacion de Variables
	SET Var_NCedes					:= Entero_Cero;			-- Inicializacion de Variables
	SET InstCede					:= 28;

	SET SalidaSI 		:= 'S'; 							-- Constante Salida SI 'S'
	SET	EstatusVigente	:=	'N';							-- Constante Estatus Vigente 'N'.
	SET Mov_PagIntExe 	:= 	'504'; 							-- INTERESES GENERADOS
	SET Cue_PagIntExe 	:= 	'INTERESES GENERADOS';			-- Descripcion Pago CEDE Interes Excento.
	SET Mov_PagIntGra 	:= 	'503'; 							-- INTERESES GENERADOS
	SET Cue_PagIntGra 	:= 	'INTERESES GENERADOS';			-- Descripcion Pago CEDE Interes Gravado.
	SET TasaFija		:=	1;								-- Indica que la CEDE es de TASA FIJA.
	SET Pol_Automatica 	:= 	'A'; 		 					-- Constante Poliza Automatica.
	SET Mov_PagCedCap 	:= 	'502'; 							-- VENCIMIENTO DE INVERSION.
	SET Var_RefPagoCed 	:= 	'VENCIMIENTO DE INVERSION';		-- Descripcion Pago de CEDE.
	SET Var_PagoCeder 	:= 	902;							-- Concepto Contable: Pago de CEDE
	SET Var_ConCedCapi 	:= 	1; 								-- Concepto Contable de CEDE: Capital
	SET Con_Capital 	:= 	1; 								-- Concepto Contable de Ahorro: Capital
	SET Nat_Abono 		:= 	'A'; 							-- Naturaleza de Abono
	SET Nat_Cargo 		:= 	'C'; 							-- Naturaleza de Cargo
	SET AltPoliza_NO 	:= 	'N'; 							-- Alta de la Poliza NO
	SET Mov_AhorroSI 	:= 	'S'; 							-- Movimiento de Ahorro: SI
	SET Var_ConCedProv 	:= 	5; 								-- Concepto Contable de CEDE: Provision
	SET Tipo_Provision 	:= 	'100'; 							-- Tipo de Movimiento de CEDE: Provision
	SET Cue_RetCeder 	:= 	'RETENCION ISR';				-- Descripcion Retencion ISR.
	SET Mov_PagCedRet 	:= 	'505'; 							-- RETENCION ISR
	SET Ope_Interna 	:= 	'I'; 							-- Tipo de Operacion: Interna
	SET Tip_Compra 		:= 	'C'; 							-- Tipo de Operacion: Compra de Divisa
	SET NombreProceso 	:= 	'CEDE'; 						-- Descripcion Proceso CEDE.
	SET Var_ConCedISR 	:= 	4; 								-- Concepto Contable de CEDE: Retencion
	SET Mov_AhorroNO 	:= 	'N'; 							-- Movimiento de Ahorro: NO
	SET Var_ConConReinv	:= 11;								-- Descripcion reinversion
	SET Var_ConInvCapi	:= 1;								-- Movimiento Inversion Capital
	SET Var_ConAhoCapi 	:= 1;								-- Movimieto Ahorro
	SET Mov_ApeCede		:= '501'; 							-- Apertura de CEDE Tabla TIPOSMOVSAHO.
	SET Var_ConAltCed 	:= 900;								-- Movimiento Cede
	SET Var_ConCedeCapi	:= 1;								-- ConceptosAhorro.
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
    SET Estatus_Inactivo := 'I';							-- Estatus Inactivo

	SET Aud_FechaActual	:= NOW();

	-- Asignacion de Variable.
	SET Var_CedeID				:=	Entero_Cero;				-- CEDE a Pagar.
	SET Var_CuentaAhoID			:=	Entero_Cero;				-- CuentaAho relacionada a la CEDE.
	SET Var_TipoCedeID			:=	Entero_Cero;				-- Tipo de CEDE.
	SET Var_MonedaID			:=	Entero_Cero;				-- MonedaID.
	SET Var_Capital				:=	DecimalCero;				-- Capital a Pagar.
	SET Var_Interes				:=	DecimalCero;				-- Interes a Pagar.
	SET Var_InteresRetener		:=	DecimalCero;				-- Interes a Reterner.
	SET Var_ClienteID			:=	Entero_Cero;				-- Cliente al que Pertenece la CEDE.
	SET Var_SaldoProvision		:=	DecimalCero;				-- Provision a Pagar.
	SET Var_SucursalOrigen		:=	Entero_Cero;				-- Sucursal Origen del Cliente.
	SET Var_AmotizacionID		:=	Entero_Cero;				-- Numero de Amortizacion a Pagar.
	SET Var_CedeFecVencimiento	:=	FechaVacia;					-- Fecha de Vencimiento de la CEDE.
	SET Var_AmoFecVecimiento	:=	FechaVacia;					-- Fecha de Vencimiento de la Amortizacion.
	SET Var_CalculoInteres		:=	Entero_Cero;				-- Tipo de Calculo a Aplicar para el Interes.
	SET Var_InteresPagar		:=	DecimalCero;				-- Interes a Pagar.
	SET Var_MonedaBase			:=	Entero_Cero;				-- Moneda Base.
	SET Var_NumVenAmor			:=	Entero_Cero;				-- Numero de Amortiaciones que Vencen.
	SET Var_MovIntere			:=	CadenaVacia;				-- Inicializacion de Variables
	SET Cue_PagIntere			:=	CadenaVacia;				-- Inicializacion de Variables

	SET Var_NuevaCedeID			:=	Entero_Cero;				-- Inicializacion de Variables
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
										'esto le ocasiona. Ref: SP-PAGOCEDEPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- Inicia Proceso de Pago de CEDE.
		-- Obtenemos la Fecha del Sistema y la Moneda Base
		SELECT FechaSistema, MonedaBaseID
			INTO Var_FechaSistema, Var_MonedaBase
		FROM PARAMETROSSIS LIMIT 1;

		SELECT	Estatus,				Descripcion
		INTO 	Var_EstatusTipoCede,	Var_Descripcion
		FROM 	TIPOSCEDES
		WHERE	TipoCedeID	= Par_TipoCedeID;

		/** -- ------------------------------------------------------------------------------------ **/
		/** -- VALIDACION DE QUE SI ES CEDE MADRE ------------------------------------------------- **/
		/** -- ------------------------------------------------------------------------------------ **/
		-- Se obtiene el cede madre
		SET Var_CedeMadreID :=	(SELECT CedeOriID
									FROM CEDESANCLAJE
									WHERE CedeAncID = Par_CedeID LIMIT 1);

		SET Var_CedeMadreID := IFNULL(Var_CedeMadreID, Par_CedeID);
		DELETE FROM TMPVENCIMANTCEDE WHERE NumTransaccion = Aud_NumTransaccion;
		-- Inserta el cede madre a la tabla temporal
		INSERT INTO TMPVENCIMANTCEDE(
			CedeID,			CuentaAhoID,		TipoCedeID,			MonedaID,		ClienteID,
			SaldoProvision,	FechaVencimiento,	CalculoInteres,		Estatus,		Reinversion,
			Monto,			EmpresaID, 			UsuarioID,		FechaActual,		DireccionIP,
            ProgramaID,		Sucursal,			NumTransaccion)
		SELECT 	CedeID,			CuentaAhoID, 		TipoCedeID, 	MonedaID, 		ClienteID,
				SaldoProvision, FechaVencimiento, 	CalculoInteres, Estatus,		Reinversion,
				Monto,			EmpresaID, 			UsuarioID,		FechaActual,	DireccionIP,
                ProgramaID,		Sucursal,			Aud_NumTransaccion
		FROM CEDES
			WHERE CedeID = Var_CedeMadreID;

		-- Inserta los anclajes a la tabla temporal
		SET Var_NCedes := (SELECT COUNT(*)	FROM CEDES CD
								INNER JOIN CEDESANCLAJE AN ON CD.CedeID = AN.CedeAncID AND CD.Estatus = EstatusVigente
									WHERE AN.CedeOriID = Var_CedeMadreID);

		IF(IFNULL(Var_NCedes,Entero_Cero) > Entero_Cero) THEN
			INSERT INTO TMPVENCIMANTCEDE(
				CedeID,			CuentaAhoID,		TipoCedeID, 		MonedaID, 		ClienteID,
				SaldoProvision, FechaVencimiento, 	CalculoInteres, 	Estatus,		Reinversion,
				Monto,			EmpresaID, 			UsuarioID,			FechaActual,	 DireccionIP,
               	ProgramaID,		Sucursal,			NumTransaccion)

			SELECT 	CD.CedeID,			CD.CuentaAhoID, 		CD.TipoCedeID, 		CD.MonedaID, 	CD.ClienteID,
					CD.SaldoProvision, 	CD.FechaVencimiento, 	CD.CalculoInteres, 	CD.Estatus,		CD.Reinversion,
					CD.Monto,			CD.EmpresaID, 			CD.UsuarioID,		CD.FechaActual,	CD.DireccionIP,
					CD.ProgramaID,		CD.Sucursal,			Aud_NumTransaccion
			FROM CEDES CD
			INNER JOIN CEDESANCLAJE AN ON CD.CedeID = AN.CedeAncID AND CD.Estatus = EstatusVigente
			WHERE AN.CedeOriID = Var_CedeMadreID;
		END IF;

		IF(Par_EsReinversion = StringSI) THEN
	      IF(Var_EstatusTipoCede = Estatus_Inactivo) THEN
	        SET Par_NumErr  :=  01;
	        SET Par_ErrMen  :=  CONCAT('No se puede reinvertir debido a que el Producto ',Var_Descripcion,' se encuentra Inactivo, por favor comunicarse con el Administrador para mas informacion.');
	        SET Var_Control :=  'cedeID';
	        LEAVE ManejoErrores;
	      END IF;
	    END IF;

		/*VALIDA QUE EL EVENTO SE ESTE REALIZANDO EN UN DIA HABIL Y QUE NO SE TRATE DE LA IMPRESION DEL PAGARE*/
		IF(Var_DiaInhabil = SabDom)THEN
			CALL DIASFESTIVOSABDOMCAL(
			Par_Fecha,			Entero_Cero, 		Var_FecSal, 		Var_EsHabil,		Par_Empresa,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

			IF(Var_EsHabil = No_DiaHabil)THEN
				SET Par_NumErr	:=	06;
				SET Par_ErrMen	:=	CONCAT('El Tipo de CEDE ', Par_TipoCedeID,' Tiene Parametrizado Dia Inhabil: Sabado y Domingo
				por tal Motivo No se Puede Registrar el CEDE.');
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- Obtenemos si la fecha es habil o no del Tipo de CEDE Dia Inhabil: Sabado y Domingo
		IF(Var_DiaInhabil = SabDom)THEN
			CALL DIASFESTIVOSABDOMCAL(
				Var_FechaSistema,	Entero_Cero, 		Var_FecSal, 		Var_EsHabil,		Par_Empresa,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion	);
		END IF;

		SET Var_NCedes := (SELECT	COUNT(*)
			FROM TMPVENCIMANTCEDE Ced
				INNER JOIN CEDES C 	ON Ced.CedeID = C.CedeID
				INNER JOIN AMORTIZACEDES Amo ON Ced.CedeID = Amo.CedeID
					AND Amo.Estatus = EstatusVigente
				INNER JOIN CLIENTES cte ON Ced.ClienteID = cte.ClienteID
			WHERE Ced.NumTransaccion = Aud_NumTransaccion);

		SET Var_NCedes := IFNULL(Var_NCedes,Entero_Cero);

		 IF(IFNULL(Var_NCedes,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr  := 07;
			SET Par_ErrMen	:= CONCAT('La Cede ya se encuentra Pagada o Cancelada');
			LEAVE ManejoErrores;
		 END IF;

		/** -- ------------------------------------------------------------------------------------ **/
		/** -- FIN VALIDACION DE QUE SI ES CEDE MADRE --------------------------------------------- **/
		/** -- ------------------------------------------------------------------------------------ **/
		/*SE HABRE CURSOR PARA PAGAR LAS CEDES HIJAS */
		Open PAGOCEDECUR;
		BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION 		SET Error_Key := Error_SQLEXCEPTION;
			DECLARE EXIT HANDLER FOR SQLSTATE '23000'	SET Error_Key := Error_DUPLICATEKEY;
			DECLARE EXIT HANDLER FOR SQLSTATE '42000'	SET Error_Key := Error_VARUNQUOTED;
			DECLARE EXIT HANDLER FOR SQLSTATE '22004'	SET Error_Key := Error_INVALIDNULL;
			DECLARE EXIT HANDLER FOR NOT FOUND SET Error_Key = 1;
			CICLOPAGOCEDECUR:LOOP
				FETCH PAGOCEDECUR INTO
					Var_CedeIDCur,				Var_CuentaAhoIDCur,		Var_TipoCedeIDCur,		Var_MonedaIDCur,		Var_MontoCur,
					Var_InteresGeneradoCur,		Var_InteresRetenerCur,	Var_ClienteIDCur,		Var_SaldoProvisionCur,	Var_SucClienteCur,
					Var_AmortizacionIDCur,		VarFechaVenCedeCur,		VarFechaVenAmoCur,		Var_CalculoInteresCur,	Var_NumVenAmorCur,
					Var_CajaRetiroCur,			Var_CapitalCur,			VarIniciaAmoCur,		VarVenceAmoCur,			Var_CliPaISR,
                    Var_TasaISR,				Var_IntRetenerReal;

				IF(Error_Key = 1 ) THEN LEAVE CICLOPAGOCEDECUR; END IF;


				SET Var_IntRetenerTot	:= Var_IntRetenerTot + Var_IntRetenerReal;


				CALL PAGOCEDEINDPRO(
					Var_CedeIDCur,			Par_Fecha,				Par_Reinversion,		Par_Reinvertir,		Par_EsReinversion,
					Var_TipoCedeIDCur,		Var_CuentaAhoIDCur,		Var_ClienteIDCur,		Par_FechaInicio,	Par_FechaVencimiento,
					Var_MontoCur,			Par_Plazo,				Par_TasaFija,			Par_TasaISR,		Par_TasaNeta,
					Var_CalculoInteresCur,	Par_TasaBaseID,			Par_SobreTasa,			Par_PisoTasa,		Par_TechoTasa,
					Var_InteresGeneradoCur,	Par_InteresRecibir,		Var_InteresRetenerCur,	Par_CalGATReal,		Par_ValorGat,
					Par_TipoPagoInt,		Par_PlazoOriginal,		Par_AltaEnPoliza,		Var_CedeMadreID,	SalidaNO,
					Par_Poliza,				Par_NumErr,				Par_ErrMen,				Par_Empresa,		Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr!=0 OR Error_Key>0)THEN
					LEAVE CICLOPAGOCEDECUR;
				END IF;

				DELETE FROM TMPVENCIMANTCEDE WHERE CedeID=Var_CedeIDCur;
			END LOOP CICLOPAGOCEDECUR;

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END;
		Close PAGOCEDECUR;
		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Cede Abonada Exitosamente';
        SET Var_Control := 'cedeID';

		-- Reinversion Manual de CEDE.
		IF(Par_EsReinversion = StringSI)THEN

			-- Obtenemos las Amortizaciones con Fecha de Vencimiento Menor o Igual a la Actual.
			SELECT	MIN(cede.CedeID),		MIN(cede.CuentaAhoID),    	MIN(cede.TipoCedeID),		MIN(cede.MonedaID),			SUM(amo.Capital),
					SUM(amo.Interes),		SUM(amo.InteresRetener), 	MIN(cede.ClienteID),		MIN(cede.SaldoProvision),	MIN(cte.SucursalOrigen),
					MAX(amo.AmortizacionID),MAX(cede.FechaVencimiento),	MAX(amo.FechaPago),			MIN(cede.CalculoInteres),	COUNT(cede.CedeID),
					MIN(cede.CajaRetiro),	MIN(cede.Monto),			MIN(cede.InteresGenerado)
			INTO	Var_CedeID,				Var_CuentaAhoID,			Var_TipoCedeID,				Var_MonedaID,				Var_Capital,
					Var_Interes,			Var_InteresRetener,			Var_ClienteID,				Var_SaldoProvision,			Var_SucursalOrigen,
					Var_AmotizacionID,		Var_CedeFecVencimiento,		Var_AmoFecVecimiento,		Var_CalculoInteres,			Var_NumVenAmor,
					Var_CajaRetiro,			Var_MontoCede,				Var_InteresCede
				FROM CEDES			cede
						INNER JOIN AMORTIZACEDES amo ON cede.CedeID = amo.CedeID AND amo.FechaPago <= Par_Fecha
						INNER JOIN CLIENTES cte ON cede.ClienteID = cte.ClienteID
				  WHERE cede.CedeID =Par_CedeID;

			/*Obtengo los Dias de Inversion*/
					SELECT 		DiasInversion
						INTO 	Var_DiasInversion
						FROM 	PARAMETROSSIS;

		SET Var_InteresRetRei :=(SELECT IFNULL(ISRReal,Entero_Cero)
										FROM CEDES
                                        WHERE CedeID =Par_CedeID);
           /*Obtenemos el Monto Correcto a Reinvertir*/
			IF(Par_Reinvertir	= 'CI') THEN
					SET Par_Monto := Var_MontoCede + Var_InteresCede-Var_InteresRetRei;

			  ELSE
					SET Par_Monto := Var_MontoCede;
            END IF;

			SET Var_NuevaCedeID := (SELECT IFNULL(MAX(CedeID), Entero_Cero) + 1
											FROM CEDES);
			SET Var_Reinvertir	:= (SELECT IFNULL(Reinvertir,CadenaVacia)
										FROM CEDES
										WHERE CedeID =Par_CedeID);
			SET Var_InteresRetRei :=(SELECT IFNULL(ISRReal,Entero_Cero)
										FROM CEDES
                                        WHERE CedeID =Par_CedeID);

			IF(Par_CalculoInteres = 1) THEN
				SET Var_CalGAT := FUNCIONCALCTAGATCEDE(Par_FechaVencimiento,Par_FechaInicio,Par_TasaFija);
			ELSE
				SET Var_CalGAT := Par_ValorGat;
			END IF;

			SET Par_Monto := IFNULL(Par_Monto, Entero_Cero);
			SET Par_InteresGenerado := ROUND((Par_Monto * Par_Plazo * Par_TasaFija) / (Factor_Porcen * Var_DiasInversion), 2);

			INSERT INTO CEDES(
				CedeID,					TipoCedeID,				CuentaAhoID,		ClienteID,			 	FechaInicio,
				FechaVencimiento,		FechaPago,				Monto,				Plazo,					TasaFija,
				TasaISR,				TasaNeta,				CalculoInteres,		TasaBase,				SobreTasa,
				PisoTasa,				TechoTasa,				InteresGenerado,	InteresRecibir,			InteresRetener,
				SaldoProvision,			ValorGat,				ValorGatReal,		EstatusImpresion,		MonedaID,
				FechaVenAnt,			FechaApertura,			Estatus,			TipoPagoInt,			DiasPeriodo,
				PagoIntCal,				CedeRenovada,			PlazoOriginal,		SucursalID,				Reinvertir,
                Reinversion,			CajaRetiro,				EmpresaID,			UsuarioID,				FechaActual,
                DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
			VALUES(
				Var_NuevaCedeID,		Par_TipoCedeID,			Par_CuentaAhoID,		Par_ClienteID,			Par_FechaInicio,
				Par_FechaVencimiento,	Par_FechaVencimiento,	Par_Monto,				Par_Plazo,				Par_TasaFija,
				Par_TasaISR,			Par_TasaNeta,			Par_CalculoInteres,		Par_TasaBaseID,			Par_SobreTasa,
				Par_PisoTasa,			Par_TechoTasa,			Par_InteresGenerado,	Par_InteresRecibir,		Par_InteresRetener,
				DecimalCero,			Var_CalGAT,				Par_CalGATReal,			Impreso,				Var_MonedaBase,
				FechaVacia,				FechaVacia,				EstatusVigente,			Par_TipoPagoInt,		Par_DiasPeriodo,
                Par_PagoIntCal,			Par_CedeID,				Par_PlazoOriginal,		Aud_Sucursal,			Par_Reinvertir,
                Par_Reinversion,		Var_CajaRetiro,			Par_Empresa,			Aud_Usuario,	 		Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			/*SE MANDA A LLAMAR AL SP PARA QUE GENERE LAS AMORTIZACIONES DE LA CEDE */
			CALL CEDEAMORTIZAPRO(
				Var_NuevaCedeID,	Par_FechaInicio,	Par_FechaVencimiento,	Par_Monto,			Par_ClienteID,
				Par_TipoCedeID,		Par_TasaFija,		Par_TipoPagoInt,		Par_DiasPeriodo,	Par_PagoIntCal,
                SalidaNO,			Par_NumErr,			Par_ErrMen,				Par_Empresa,		Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			/*FIN DE LLAMADO AL SP QUE GENERA LAS AMORTIZACIONES*/

			-- Generamos el Movimiento Contable para la Apertura de la Nueva CEDE.
			CALL CONTACEDESPRO(
				Var_NuevaCedeID,	Par_Empresa,		Par_FechaInicio,		Par_Monto,			Mov_ApeCede,
				Var_ConAltCed,		Var_ConCedeCapi,	Con_Capital,			Nat_Cargo,			AltPoliza_NO,
				Mov_AhorroSI,		AltPoliza_NO,		Par_Poliza,				Par_NumErr,			Par_ErrMen,
				Var_CuentaAhoID,	Var_ClienteID,		Var_MonedaBase,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen 	:= CONCAT('CEDE Reinvertida Exitosamente.', Var_NuevaCedeID);
			SET Var_Control := 'cedeID';
            SET Var_Consecutivo := Var_NuevaCedeID;

		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
				Par_ErrMen		 AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	 AS consecutivo;
	END IF;

END TerminaStored$$