-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTACOMLINCREDAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTACOMLINCREDAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `CONTACOMLINCREDAGROPRO`(
	-- Realiza la Contabilidad de comision por manejo de una linea de crédito agro
	Par_CreditoID			BIGINT(12),		-- ID de credito
	Par_SolicitudCreditoID	BIGINT(12),		-- ID de credito
	Par_EsReestructura		CHAR(1),		-- Es una Reestructuracion
	INOUT Par_PolizaID		BIGINT(20),		-- Numero de poliza para registrar los detalles contables
	Par_OrigenPago			CHAR(1),		-- Origen del Pago
	Par_NumeroMinistracion	INT(11),		-- Número de Ministracion que se va desembolsar

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema				DATE;			-- Fecha del Sistema
	DECLARE Var_FechaProximoCobro			DATE;			-- Fecha de Ultimo cobro de Comision
	DECLARE Var_ManejaComAdmon				CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ComAdmonLinPrevLiq			CHAR(1);		-- Comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComAdmon				CHAR(1);		-- Forma de Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición

	DECLARE Var_ManejaComGarantia			CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq			CHAR(1);		-- Comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ClasifCre					CHAR(1);		-- Clasificacion del Credito
	DECLARE Var_PagIVA						CHAR(1);		-- Pago de IVA
	DECLARE Var_TipoCredito					CHAR(1);		-- Tipo de Credito

	DECLARE Var_EsConsolidacion				CHAR(1);		-- Tipo de Credito Consolidado IVA Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE Var_Naturaleza					CHAR(1);		-- Tipo de Naturaleza
	DECLARE Var_AltaMovAho					CHAR(1);		-- Tipo de Alta de Mov de Cuenta
	DECLARE Var_TipoMovCuenta				CHAR(3);		-- Tipo de Alta de Movimiento
	DECLARE Var_Control						VARCHAR(100);	-- Variable de Control

	DECLARE Var_MonedaID					INT(11);		-- Moneda del Credito
	DECLARE Var_ProductoCreditoID			INT(11);		-- Clave del Producto de Credito
	DECLARE Var_RegistroID					INT(11);		-- Numero de Registro
	DECLARE Var_SucursalCte					INT(11);		-- Sucursal del Cliente
	DECLARE Var_ConceptoConta				INT(11);		-- Concepto Contable

	DECLARE Var_AmortizacionID				INT(11);		-- Numero de Amortizaccion
	DECLARE Var_ClienteID					INT(11);		-- Numero de Cliente
	DECLARE Var_SubClasifID					INT(11);		-- SubClasificacion del Credito
	DECLARE Var_MontoPagComAdmon			DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administración
	DECLARE Var_MontoPagComGarantia			DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia

	DECLARE Var_MontoComisionPago			DECIMAL(14,2);	-- Monto de Comision de Pago
	DECLARE Var_IVALineaCredito				DECIMAL(14,2);	-- IVA de Linea de Credito
	DECLARE Var_IVASucurs					DECIMAL(14,2);	-- IVA
	DECLARE Var_CuentaAhoID					BIGINT(12);		-- Numero de Cuenta de Ahorro
	DECLARE Var_Consecutivo					BIGINT(20);		-- Numero de Consecutivo

	DECLARE Var_LineaCreditoID				BIGINT(20);		-- Numero de Linea de Credito

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia					CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_NO							CHAR(1);		-- Constante NO
	DECLARE Con_SI							CHAR(1);		-- Constante SI
	DECLARE Salida_SI						CHAR(1);		-- Indica una salida en pantalla SI
	DECLARE Salida_NO						CHAR(1);		-- Indica una salida en pantalla NO

	DECLARE Nat_Abono						CHAR(1);		-- Naturaleza de Abono.
	DECLARE Nat_Cargo						CHAR(1);		-- Naturaleza de Cargo
	DECLARE AltaMovAho_NO					CHAR(1);		-- Alta de Movimiento de Ahorro: NO
	DECLARE AltaMovAho_SI					CHAR(1);		-- Alta de Movimiento de Ahorro: SI
	DECLARE AltaMovCre_NO					CHAR(1);		-- Alta de Movimiento de Credito: NO

	DECLARE AltaMovCre_SI 					CHAR(1);		-- Alta de Movimiento de Credito: SI
	DECLARE AltaPolCre_NO					CHAR(1);		-- Alta de Poliza Contable de Credito: NO
	DECLARE AltaPolCre_SI					CHAR(1);		-- Alta de Poliza Contable de Credito: SI
	DECLARE AltaPoliza_NO					CHAR(1);		-- Alta de Poliza Contable General: NO
	DECLARE AltaPoliza_SI					CHAR(1);		-- Alta de Poliza Contable General: SI

	DECLARE Tip_Disposicion					CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total						CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota						CHAR(1);		-- Constante Cada Cuota
	DECLARE	Tip_ComAdmon					CHAR(1);		-- Constante Tipo Comision Admon
	DECLARE	Tip_ComGarantia					CHAR(1);		-- Constante Tipo Comision Garantia

	DECLARE Con_Deduccion					CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado					CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Estatus_Vigente					CHAR(1);		-- Estatus vigente
	DECLARE Estatus_Vencido					CHAR(1);		-- Estatus vencido
	DECLARE Estatus_Atrasado				CHAR(1);		-- Estatus Atrasado

	DECLARE Con_SiPagaIVA					CHAR(1);		--
	DECLARE Con_EsConsolidacion				CHAR(1);		-- Es consolidacion
	DECLARE TipCred_Nuevo					CHAR(1);		-- Tipo de Credito Nuevo
	DECLARE TipCred_Renovacion				CHAR(1);		-- Tipo de Credito Renovado
	DECLARE Tip_MovAhoDesem					CHAR(3);		-- Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)

	DECLARE Tip_MovAhoPago					CHAR(3);		-- Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)
	DECLARE Con_DesForCobCom				VARCHAR(100);	-- Constante Descripcion Forma de Cobro por Comision
	DECLARE Con_DesIvaForCobCom				VARCHAR(100);	-- Constante Descripcion IVA Forma de Cobro por Comision
	DECLARE Con_DesForCarCom				VARCHAR(100);	-- Constante Descripcion Forma de Cobro por Comision
	DECLARE Con_DesIvaForCarCom				VARCHAR(100);	-- Constante Descripcion IVA Forma de Cobro por Comision

	DECLARE Entero_Cero						INT(11);		-- Constante  Entero en Cero
	DECLARE Entero_Uno						INT(11);		-- Constante Entero Uno
	DECLARE Con_ContDesem					INT(11);		-- Concepto Contable de Desembolso (CONCEPTOSCONTA)
	DECLARE ConcReestrRen					INT(11);		-- Concepto Contable de Reestructura (CONCEPTOSCONTA)
	DECLARE Tip_MovComGarDisLinCred			INT(11);		-- Tipo Movimiento Credito Comision por Garantia por Disposicion de Linea Credito Agro

	DECLARE Tip_MovIVAComGarDisLinCred		INT(11);		-- Tipo Movimiento Credito IVA Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE Tip_MovComAdmonDisLinCred		INT(11);		-- Tipo Movimiento Credito Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE Tip_MovIVAComAdmonDisLinCred	INT(11);		-- Tipo Movimiento Credito IVA Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE Con_CarCtaOrdenDeuAgro			INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE Con_CarCtaOrdenCorAgro			INT(11);		-- Concepto Cuenta Ordenante Corte Agro

	DECLARE Con_CarComAdmonLinCred			INT(11);		-- Concepto Cartera Comision por Admon por Linea Credito Agro
	DECLARE Con_CarComAdmonDisLinCred		INT(11);		-- Concepto Cartera Comision por Admon por Disposicion de Linea Credito Agro
	DECLARE Con_CarIvaComAdmonDisLinCred	INT(11);		-- Concepto Cartera IVA Comision por Admon por Disposicion de Linea Credito Agro
	DECLARE Con_CarComGarDisLinCred			INT(11);		-- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE Fecha_Vacia						DATE;			-- Contante Fecha Vacia

	-- Asignacion de Constantes
	SET Cadena_Vacia					:= '';
	SET Con_NO							:= 'N';
	SET Con_SI							:= 'S';
	SET Salida_SI						:= 'S';
	SET Salida_NO						:= 'N';

	SET Nat_Abono						:= 'A';
	SET Nat_Cargo						:= 'C';
	SET AltaMovAho_NO					:= 'N';
	SET AltaMovAho_SI					:= 'S';
	SET AltaMovCre_NO					:= 'N';

	SET AltaMovCre_SI 					:= 'S';
	SET AltaPolCre_NO					:= 'N';
	SET AltaPolCre_SI					:= 'S';
	SET AltaPoliza_NO					:= 'N';
	SET AltaPoliza_SI					:= 'S';

	SET Tip_Disposicion					:= 'D';
	SET Tip_Total						:= 'T';
	SET Tip_Cuota						:= 'C';
	SET	Tip_ComAdmon					:= 'A';
	SET	Tip_ComGarantia					:= 'G';

	SET Con_Deduccion					:= 'D';
	SET Con_Financiado					:= 'F';
	SET Estatus_Vigente					:= 'V';
	SET Estatus_Vencido					:= 'B';
	SET Estatus_Atrasado				:= 'A';

	SET Con_SiPagaIVA					:= 'S';
	SET Con_EsConsolidacion 			:= 'S';
	SET TipCred_Nuevo					:= 'N';
	SET TipCred_Renovacion				:= 'O';
	SET Tip_MovAhoDesem					:= '100';

	SET Tip_MovAhoPago					:= '101';
	SET Con_DesForCobCom				:= 'COBRO DE COMISION POR LINEA DE CREDITO';
	SET Con_DesIvaForCobCom				:= 'COBRO DE IVA COMISION POR LINEA DE CREDITO';
	SET Con_DesForCarCom				:= 'CARGO DE COMISION POR LINEA DE CREDITO';
	SET Con_DesIvaForCarCom				:= 'CARGO DE IVA COMISION POR LINEA DE CREDITO';

	SET Entero_Cero						:= 0;
	SET Entero_Uno						:= 1;
	SET Con_ContDesem					:= 50;
	SET ConcReestrRen					:= 66;
	SET Tip_MovComGarDisLinCred			:= 59;

	SET Tip_MovIVAComGarDisLinCred		:= 60;
	SET Tip_MovComAdmonDisLinCred		:= 61;
	SET Tip_MovIVAComAdmonDisLinCred	:= 62;
	SET Con_CarCtaOrdenDeuAgro			:= 138;
	SET Con_CarCtaOrdenCorAgro			:= 139;

	SET Con_CarComAdmonLinCred 			:= 140;
	SET Con_CarComAdmonDisLinCred 		:= 141;
	SET Con_CarIvaComAdmonDisLinCred	:= 144;
	SET Con_CarComGarDisLinCred 		:= 143;
	SET Fecha_Vacia						:= '1900-01-01';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTACOMLINCREDAGROPRO');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		# Inicializacion de variables
		SELECT  Cli.SucursalOrigen,		Cre.EsConsolidacionAgro,Cre.ClienteID,			Cre.MonedaID,			Cre.ProductoCreditoID,
				Cre.CuentaID,			Cre.TipoCredito,		Des.Clasificacion,		Des.SubClasifID,		Cli.PagaIVA,
				Cre.LineaCreditoID,		Cre.ManejaComAdmon,		Cre.ComAdmonLinPrevLiq,	Cre.ForCobComAdmon,		Cre.MontoPagComAdmon,
				Cre.ManejaComGarantia,	Cre.ComGarLinPrevLiq,	Cre.MontoPagComGarantia
		INTO	Var_SucursalCte,		Var_EsConsolidacion,	Var_ClienteID,			Var_MonedaID,			Var_ProductoCreditoID,
				Var_CuentaAhoID,		Var_TipoCredito,		Var_ClasifCre,			Var_SubClasifID,		Var_PagIVA,
				Var_LineaCreditoID,		Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,	Var_ForCobComAdmon,		Var_MontoPagComAdmon,
				Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,	Var_MontoPagComGarantia
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli	ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		INNER JOIN DESTINOSCREDITO Des ON  Cre.DestinoCreID = Des.DestinoCreID
		WHERE Cre.CreditoID = Par_CreditoID;

		SET Var_PagIVA	:= IFNULL(Var_PagIVA, Con_NO);
		SELECT IVA
		INTO Var_IVASucurs
		FROM SUCURSALES WHERE SucursalID	= Var_SucursalCte;
		SET Var_IVASucurs	:= IFNULL(Var_IVASucurs, Entero_Cero);

		IF( Par_EsReestructura = Con_SI ) THEN
			SELECT	LineaCreditoID,			ManejaComAdmon,			ComAdmonLinPrevLiq,			ForCobComAdmon,			MontoPagComAdmon,
					ManejaComGarantia,		ComGarLinPrevLiq,		MontoPagComGarantia
			INTO	Var_LineaCreditoID,		Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,		Var_MontoPagComAdmon,
					Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,	Var_MontoPagComGarantia
			FROM SOLICITUDCREDITO Cre
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID ;
		END IF;

		# Sacamos el monto del credito de las ministraciones del credito
		SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);

		IF( Var_LineaCreditoID = Entero_Cero) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'La Linea de Credito no Existe.';
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaSistema
		INTO	Var_FechaSistema
		FROM PARAMETROSSIS
		WHERE EmpresaID = Aud_EmpresaID;

		SET Var_ManejaComAdmon		:= IFNULL(Var_ManejaComAdmon, Con_NO);
		SET Var_ComAdmonLinPrevLiq	:= IFNULL(Var_ComAdmonLinPrevLiq, Con_NO);
		SET Var_ForCobComAdmon		:= IFNULL(Var_ForCobComAdmon, Cadena_Vacia);
		SET Var_MontoPagComAdmon	:= IFNULL(Var_MontoPagComAdmon, Entero_Cero);

		SET Var_ManejaComGarantia	:= IFNULL(Var_ManejaComGarantia, Con_NO);
		SET Var_ComGarLinPrevLiq	:= IFNULL(Var_ComGarLinPrevLiq, Con_NO);
		SET Var_MontoPagComGarantia	:= IFNULL(Var_MontoPagComGarantia, Entero_Cero);

		-- Formas de cobro de comisión para lineas de credito agro.
		-- Las comisiones cargadas sobre la o las disposiciones en una línea de crédito seran cobradas al cliente al momento del desembolso, de acuerdo a la forma elegida al momento del alta
		-- de la solicitud y alta del crédito (Campo Forma Cobro de la sección de línea de crédito)
		-- Tipos de cobro de comisión.
		/*Cobros de comision para una linea de credito con comisiones por administracion
		T.- Total en primera dispersión
		D.- Por disposición**/
		IF( Var_ManejaComAdmon = Con_SI AND
			Var_ComAdmonLinPrevLiq = Con_NO AND
			Var_MontoPagComAdmon <> Entero_Cero AND
			Par_NumeroMinistracion = Entero_Uno ) THEN

			SET Var_AmortizacionID	:= Entero_Uno;
			IF(Var_PagIVA = Con_SiPagaIVA) THEN
				SET Var_IVALineaCredito := ROUND((Var_MontoPagComAdmon * Var_IVASucurs), 2);
				SET Var_IVALineaCredito := IFNULL(Var_IVALineaCredito,Entero_Cero);
			END IF;

			SET Var_TipoMovCuenta	:= Tip_MovAhoPago;
			SET Var_AltaMovAho 		:= Cadena_Vacia;
			SET Var_Naturaleza		:= Cadena_Vacia;

			IF( Par_EsReestructura = Con_SI ) THEN
				SELECT	MIN(Amo.AmortizacionID)
				INTO Var_AmortizacionID
				FROM AMORTICREDITO Amo
				INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
				WHERE Cre.CreditoID   = Par_CreditoID
				  AND Amo.Estatus IN (Estatus_Vigente, Estatus_Vencido, Estatus_Atrasado)
				  AND Cre.Estatus IN (Estatus_Vigente, Estatus_Vencido);
			END IF;

			IF( Var_TipoCredito IN (TipCred_Renovacion, TipCred_Nuevo) OR Var_EsConsolidacion = Con_SI ) THEN
				SET Var_TipoMovCuenta	:= Tip_MovAhoDesem;
				SET Var_AltaMovAho		:= AltaMovAho_SI;
				SET Var_Naturaleza		:= Nat_Cargo;
			END IF;

			-- Si la Forma de Cobro es  Total en primera dispersión se volverá a cobrar  la comision
			-- una vez transcurrido un año calendario en las nuevas disposiciones
			IF( Var_ForCobComAdmon = Tip_Total ) THEN

				ValidaForCobComAdmon:BEGIN

					SELECT 	MAX(RegistroID)
					INTO 	Var_RegistroID
					FROM BITACORAFORCOBCOMLIN
					WHERE LineaCreditoID = Var_LineaCreditoID
					  AND TipoComision = Tip_ComAdmon
					  AND ForCobCom = Tip_Total;

					SET Var_RegistroID := IFNULL(Var_RegistroID, Entero_Cero);
					IF( Var_RegistroID = Entero_Cero ) THEN
						SET Var_FechaProximoCobro := Var_FechaSistema;
					ELSE
						SELECT 	FechaProximoCobro
						INTO 	Var_FechaProximoCobro
						FROM BITACORAFORCOBCOMLIN
						WHERE RegistroID = Var_RegistroID;
						SET Var_FechaProximoCobro := IFNULL(Var_FechaProximoCobro, Fecha_Vacia);
					END IF;

					-- Si la fecha de Cobro es menor a la del sistema no se efectua el cargo a la cuenta
					-- en caso contrario se efectua el cargo y se agrega un registro a la bitacora de cobro
					IF( Var_FechaSistema >= Var_FechaProximoCobro ) THEN
						CALL BITACORAFORCOBCOMLINALT(
							Par_CreditoID,		Var_LineaCreditoID,	Tip_ComAdmon,
							Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					ELSE
						LEAVE ValidaForCobComAdmon;
					END IF;

					CALL CONTACREDITOPRO(
						Par_CreditoID,				Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,			Var_FechaSistema,
						Var_FechaSistema,			Var_MontoPagComAdmon,	Var_MonedaID,		Var_ProductoCreditoID,	Var_ClasifCre,
						Var_SubClasifID,			Var_SucursalCte,		Con_DesForCobCom,	Par_CreditoID,			AltaPoliza_NO,
						Con_ContDesem,				Par_PolizaID,			AltaPolCre_SI,		AltaMovCre_SI,			Con_CarComAdmonLinCred,
						Tip_MovComAdmonDisLinCred,	Nat_Abono,				AltaMovAho_SI,		Var_TipoMovCuenta,		Var_Naturaleza,
						Par_OrigenPago,				Par_NumErr,				Par_ErrMen,			Var_Consecutivo,		Aud_EmpresaID,
						Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,				Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					IF( Var_IVALineaCredito > Entero_Cero ) THEN

						CALL CONTACREDITOPRO(
							Par_CreditoID,					Var_AmortizacionID,		Var_CuentaAhoID,		Var_ClienteID,			Var_FechaSistema,
							Var_FechaSistema,				Var_IVALineaCredito,	Var_MonedaID,			Var_ProductoCreditoID,	Var_ClasifCre,
							Var_SubClasifID,				Var_SucursalCte,		Con_DesIvaForCobCom,	Par_CreditoID,			AltaPoliza_NO,
							Entero_Cero,					Par_PolizaID,			AltaPolCre_SI,			AltaMovCre_SI,			Con_CarIvaComAdmonDisLinCred,
							Tip_MovIVAComAdmonDisLinCred,	Nat_Abono,				Var_AltaMovAho,			Var_TipoMovCuenta,		Var_Naturaleza,
							Par_OrigenPago,					Par_NumErr,				Par_ErrMen,				Var_Consecutivo,		Aud_EmpresaID,
							Cadena_Vacia,					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
							Aud_Sucursal,					Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END ValidaForCobComAdmon;
			END IF;

			IF( Var_ForCobComAdmon = Tip_Disposicion ) THEN

				CALL CONTACREDITOPRO(
					Par_CreditoID,				Var_AmortizacionID,		Var_CuentaAhoID,	Var_ClienteID,			Var_FechaSistema,
					Var_FechaSistema,			Var_MontoPagComAdmon,	Var_MonedaID,		Var_ProductoCreditoID,	Var_ClasifCre,
					Var_SubClasifID,			Var_SucursalCte,		Con_DesForCobCom,	Par_CreditoID,			AltaPoliza_NO,
					Con_ContDesem,				Par_PolizaID,			AltaPolCre_SI,		AltaMovCre_SI,			Con_CarComAdmonDisLinCred,
					Tip_MovComAdmonDisLinCred,	Nat_Abono,				Var_AltaMovAho,		Var_TipoMovCuenta,		Var_Naturaleza,
					Par_OrigenPago,				Par_NumErr,				Par_ErrMen,			Var_Consecutivo,		Aud_EmpresaID,
					Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
					Aud_Sucursal,				Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				IF( Var_IVALineaCredito > Entero_Cero ) THEN

					CALL CONTACREDITOPRO(
						Par_CreditoID,					Var_AmortizacionID,		Var_CuentaAhoID,		Var_ClienteID,			Var_FechaSistema,
						Var_FechaSistema,				Var_IVALineaCredito,	Var_MonedaID,			Var_ProductoCreditoID,	Var_ClasifCre,
						Var_SubClasifID,				Var_SucursalCte,		Con_DesIvaForCobCom,	Par_CreditoID,			AltaPoliza_NO,
						Con_ContDesem,					Par_PolizaID,			AltaPolCre_SI,			AltaMovCre_SI,			Con_CarIvaComAdmonDisLinCred,
						Tip_MovIVAComAdmonDisLinCred,	Nat_Abono,				Var_AltaMovAho,			Var_TipoMovCuenta,		Var_Naturaleza,
						Par_OrigenPago,					Par_NumErr,				Par_ErrMen,				Var_Consecutivo,		Aud_EmpresaID,
						Cadena_Vacia,					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,					Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			-- Actualizo el Monto Pagado en la solicitud y en el Credito
			UPDATE CREDITOS SET
				MontoCobComAdmon = MontoCobComAdmon + Var_MontoPagComAdmon
			WHERE CreditoID = Par_CreditoID;
		END IF;

		IF( Var_ManejaComGarantia = Con_SI AND
			Var_ComGarLinPrevLiq = Con_NO AND
			Var_MontoPagComGarantia <> Entero_Cero ) THEN

			-- Ajuste para el monto de Garantia cuando es la primera ministracion
			IF( Par_NumeroMinistracion = Entero_Uno ) THEN
				-- Actualizo el Monto Pagado en la solicitud y en el Credito
				UPDATE CREDITOS SET
					MontoPagComGarantia = Entero_Cero,
					MontoCobComGarantia = Entero_Cero
				WHERE CreditoID = Par_CreditoID;
			END IF;

			-- En el caso de la comision por garantia se hace el cobro por financiamiento debido
			-- a que en el monto de la renovacion ministracion se efectua
			IF( Par_EsReestructura = Con_SI OR Var_EsConsolidacion = Con_EsConsolidacion ) THEN

				SELECT	MIN(Amo.AmortizacionID)
				INTO Var_AmortizacionID
				FROM AMORTICREDITO Amo
				INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
				WHERE Cre.CreditoID   = Par_CreditoID
				  AND Amo.Estatus IN (Estatus_Vigente, Estatus_Vencido, Estatus_Atrasado)
				  AND Cre.Estatus IN (Estatus_Vigente, Estatus_Vencido);

				SET Var_ConceptoConta := ConcReestrRen;

				IF( Var_EsConsolidacion = Con_SI ) THEN
					SET Var_AmortizacionID	:= Entero_Uno;
					SET Var_ConceptoConta	:= Con_ContDesem;
				END IF;

				IF( Var_PagIVA = Con_SiPagaIVA ) THEN
					SET Var_IVALineaCredito := ROUND((Var_MontoPagComGarantia * Var_IVASucurs), 2);
					SET Var_IVALineaCredito := IFNULL(Var_IVALineaCredito,Entero_Cero);
				END IF;

				-- Cargo de Movimiento Operativo de la comision
				CALL CONTACREDITOPRO(
					Par_CreditoID,				Var_AmortizacionID,			Var_CuentaAhoID,		Var_ClienteID,			Var_FechaSistema,
					Var_FechaSistema,			Var_MontoPagComGarantia,	Var_MonedaID,			Var_ProductoCreditoID,	Var_ClasifCre,
					Var_SubClasifID,			Var_SucursalCte,			Con_DesForCarCom,		Par_CreditoID,			AltaPoliza_NO,
					Var_ConceptoConta,			Par_PolizaID,				AltaPolCre_SI,			AltaMovCre_SI,			Con_CarComGarDisLinCred,
					Tip_MovComGarDisLinCred,	Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
					Par_OrigenPago,				Par_NumErr,					Par_ErrMen,				Var_Consecutivo,
					Aud_EmpresaID,				Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				-- Cargo de Movimiento Operativo de la comision
				CALL CONTACREDITOPRO(
					Par_CreditoID,				Var_AmortizacionID,			Var_CuentaAhoID,		Var_ClienteID,			Var_FechaSistema,
					Var_FechaSistema,			Var_MontoPagComGarantia,	Var_MonedaID,			Var_ProductoCreditoID,	Var_ClasifCre,
					Var_SubClasifID,			Var_SucursalCte,			Con_DesForCarCom,		Par_CreditoID,			AltaPoliza_NO,
					Var_ConceptoConta,			Par_PolizaID,				AltaPolCre_SI,			AltaMovCre_NO,			Con_CarCtaOrdenDeuAgro,
					Entero_Cero,				Nat_Abono,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
					Par_OrigenPago,				Par_NumErr,					Par_ErrMen,				Var_Consecutivo,
					Aud_EmpresaID,				Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				IF( Var_PagIVA = Con_SiPagaIVA) THEN

					UPDATE AMORTICREDITO SET
						SaldoIVAComSerGar	= IFNULL(SaldoIVAComSerGar, Entero_Cero) + Var_IVALineaCredito,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
					  AND CreditoID = Par_CreditoID;

					UPDATE CREDITOS SET
						SaldoIVAComSerGar	= IFNULL(SaldoIVAComSerGar, Entero_Cero) + Var_IVALineaCredito,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion		= Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;
				END IF;
			END IF;

			IF( Var_TipoCredito IN (TipCred_Nuevo, TipCred_Renovacion) ) THEN

				CALL CRESIMPAGCOMSERGARPRO(
					Var_LineaCreditoID,		Par_SolicitudCreditoID,	Par_CreditoID,	Par_NumeroMinistracion,	Aud_NumTransaccion,
					Var_MontoComisionPago,	Par_PolizaID,			Entero_Cero,	Fecha_Vacia,
					Salida_NO,				Par_NumErr,				Par_ErrMen,		Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Desembolso de Linea de Credito Realizada con exito.');

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Cadena_Vacia	AS control,
				Var_LineaCreditoID	AS consecutivo;
	END IF;

END TerminaStore$$