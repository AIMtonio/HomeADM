-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `MINISTRACREAGROPRO`(
	/*Realiza el desembolso de un credito agropecuario*/
	Par_NumeroMinistracion						INT(11),				# Número de Ministracion que se va desembolsar
	Par_CreditoID								BIGINT(12),				# ID de credito a desembolsar
	INOUT Par_PolizaID							BIGINT(20),				# Numero de	poliza para registrar los detalles contables
	Par_TipoCalculoInteres						CHAR(1),				# Tipo de Calculo de interes fechaPactada	: P, fechaReal: R
	Par_NumTransacionPasivo						BIGINT(12),				# Numero de Transaccion para el credito Pasivo
	Par_Salida									CHAR(1),				# Salida S:Si N:No
	INOUT Par_NumErr							INT(11),				# Numero de error
	INOUT Par_ErrMen							VARCHAR(400),			# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID								INT(11),
	Aud_Usuario									INT(11),

	Aud_FechaActual								DATETIME,
	Aud_DireccionIP								VARCHAR(15),
	Aud_ProgramaID								VARCHAR(50),
	Aud_Sucursal								INT(11),
	Aud_NumTransaccion							BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_MensajeExitoPasivo				VARCHAR(400);
	DECLARE VarCuentaCLABE						VARCHAR(18);
	DECLARE VarRFCPMcte							CHAR(13);
	DECLARE VarRFCcte							CHAR(13);
	DECLARE VarSucursalLin						INT(11);					# Variables para el CURSOR
	DECLARE VarTipoPerson						CHAR(1);
	DECLARE Var_AjFecExiVen						CHAR(1);
	DECLARE Var_AjFecUlVenAmo					CHAR(1);
	DECLARE Var_AltaPoliza						CHAR(1);
	DECLARE Var_AmortizID						INT(11);
	DECLARE Var_AmortizacionIDAgro				INT(11);
	DECLARE Var_AvalesRechazados				INT(11);					# Cantidad de Avales que no cumplen condiciones del Producto Credito
	DECLARE Var_Cantidad						DECIMAL(14,2);				# Fin Variable para el CURSOR
	DECLARE Var_CantidadPagar					DECIMAL(12,2);				# Cantidad a pagar
	DECLARE Var_CargoCuenta						CHAR(1);					# Indica que se trata de un pago con cargo a cuenta
	DECLARE Var_ClasifCre						CHAR(1);					# Clasificacion del Producto de Credito
	DECLARE Var_ClienteID						BIGINT;						# Numero de Cliente
	DECLARE Var_Control							VARCHAR(100);				# Variable de Control
	DECLARE Var_CreditoFondeoID					BIGINT(20);					# Guarda en consecutivo del id de Credito FONDEO
	DECLARE Var_CreditoID						BIGINT(12);					# Variables para el CURSOR
	DECLARE Var_CreditoIDAgro					BIGINT(12);
	DECLARE Var_CreditoIDCNBV					VARCHAR(29);
	DECLARE Var_CtaInstitu						INT(11);
	DECLARE Var_CuentaAhoID						BIGINT(12);					# Cuenta de Ahorro
	DECLARE Var_CuentaAhoStr					VARCHAR(20);
	DECLARE Var_DcIVAComApe						VARCHAR(100);
	DECLARE Var_DescComAper						VARCHAR(100);
	DECLARE Var_DescSegVida						VARCHAR(100);
	DECLARE Var_DescSegu						DECIMAL(12,2);
	DECLARE Var_Descripcion						VARCHAR(100);
	DECLARE Var_DiaMesCap						INT(11);
	DECLARE Var_DiaPagoCap						CHAR(1);
	DECLARE Var_EsHabil							CHAR(1);
	DECLARE Var_EsReestructura					CHAR(1);
	DECLARE Var_EsqSeguroID						DECIMAL(12,2);				# ID del Esquema de Seguro de Vida
	DECLARE Var_EsquemaSeguro					INT(11);
	DECLARE Var_EstatusCre						CHAR(1);					# Estatus del Credito
	DECLARE Var_EstatusDesembolso				CHAR(1);
	DECLARE Var_FactRiSeg						DECIMAL(12,6);
	DECLARE Var_FecIniCred						DATE;
	DECLARE Var_FechaApl						DATE;
	DECLARE Var_FechaInhabil					CHAR(1);
	DECLARE Var_FechaInicioAmor					DATE;
	DECLARE Var_FechaOper						DATE;
	DECLARE Var_FechaSiguienteMinistracion		DATE;						# Fecha de la siguiente Ministracion
	DECLARE Var_ForCobSegVida					CHAR(1);
	DECLARE Var_ForComApe						CHAR(1);
	DECLARE Var_FrecInteres						CHAR(1);					# Almacena la frecuencia de Interes
	DECLARE Var_FrecuenCap						CHAR(1);
	DECLARE Var_IVAComAp						DECIMAL(12,2);
	DECLARE Var_IntercamAvales					INT(11);					# Cantidad de Avales que No Permiten Intecambio Avales
	DECLARE Var_LineaCreditoID					BIGINT(20);
	DECLARE Var_LiquidaInteres					CHAR(1);
	DECLARE Var_ManCapta						CHAR(1);
	DECLARE Var_MonedaCta						INT(11);
	DECLARE Var_MonedaID						INT(11);
	DECLARE Var_MontoADesem						DECIMAL(14, 2);
	DECLARE Var_MontoBloqueo					DECIMAL(14,2);
	DECLARE Var_MontoCancelado					DECIMAL(14,2);				# Monto Cancelado de cada ministracion
	DECLARE Var_MontoComAp						DECIMAL(12,2);
	DECLARE Var_MontoMinistrado					DECIMAL(14,2);				# Monto Ministrado a utilizar en el cursor para la afectación de las amortizaciones
	DECLARE Var_MontoMinistradoAgro				DECIMAL(14,2);				# Monto ministrado hasta el momento
	DECLARE Var_MontoPago						DECIMAL(14,2);
	DECLARE Var_MontoPendAmortAnterior			DECIMAL(14,2);
	DECLARE Var_MontoPendDesembolsoAgro			DECIMAL(14,2);
	DECLARE Var_MontoPolSeg						DECIMAL(12,2);
	DECLARE Var_MontoSegVida					DECIMAL(14,2);
	DECLARE Var_MontoTotCom						DECIMAL(14,2);				# Monto Total del la Comision por Apertura
	DECLARE Var_MsgDesemb						VARCHAR(80);
	DECLARE Var_NomCliente						VARCHAR(200);				# Nombre del Cliente
	DECLARE Var_NumAmorti						INT(11);
	DECLARE Var_NumRetMes						INT(11);
	DECLARE Var_NumTransac						BIGINT;
	DECLARE Var_NumTransaccionAgro				BIGINT(20);
	DECLARE Var_PagIVA							CHAR(1);
	DECLARE Var_PagaInteres						CHAR(1);
	DECLARE Var_PagoAplica						DECIMAL(14,2);
	DECLARE Var_PeriodCap						INT(11);
	DECLARE Var_PeriodInt						INT(11);					# Almacena la Periodicidad del Interes
	DECLARE Var_Poliza							BIGINT(20);
	DECLARE Var_ProdCreID						INT(11);					# Clave del Producto de Credito
	DECLARE Var_ProdCredID						INT(11);
	DECLARE Var_RelaEstatus						CHAR(1);
	DECLARE Var_Relacionado						BIGINT(12);
	DECLARE Var_ReqValidaCred					CHAR(1);
	DECLARE Var_RequiereAvales					CHAR(11);					# Almacena Requiere Avales de Producto de Credito
	DECLARE Var_Reserva							DECIMAL(14,2);
	DECLARE Var_SI								CHAR(1);
	DECLARE Var_SalInteres						DECIMAL(14,2);
	DECLARE Var_SaldoCapVigent					DECIMAL(14,2);				# Monto Saldo capital Vigente del credito
	DECLARE Var_SaldoCapital					DECIMAL(14,2);
	DECLARE Var_SaldoCredAnt					DECIMAL(12,2);
	DECLARE Var_SolCredito						INT(11);
	DECLARE Var_SoliciCredID					BIGINT(20);
	DECLARE Var_SubClasifID						INT(11);
	DECLARE Var_SucCliente						INT(11);					# Sucursal del Cliente
	DECLARE Var_TelCelInst						VARCHAR(20);
	DECLARE Var_TelefonoCel						VARCHAR(30);
	DECLARE Var_TipPagCapita					CHAR(1);
	DECLARE Var_TipPagSegu						CHAR(1);
	DECLARE Var_TipoCredito						CHAR(1);
	DECLARE Var_TipoDisper						CHAR(1);
	DECLARE Var_TipoFondeo						CHAR(1);					# Tipo de Fondeo: P .- Recursos Propios F .- Institucion de Fondeo
	DECLARE Var_TipoLiquidacion					CHAR(1);					# Tipo de Liquidacion con el que se pagará un credito
	DECLARE Var_TipoMovCred						INT(11);					# Tipo de movimiento de contabilidad
	DECLARE Var_TipoProd						INT(11);
	DECLARE Var_TotalInteres					DECIMAL(12,2);
	DECLARE Var_GrupoID							INT(11);
	DECLARE Var_TipoOperaGrupo					VARCHAR(2);
	DECLARE Par_AmortizacionIni					INT(11);
	DECLARE Par_AmortizacionFin					INT(11);
	DECLARE Var_PolizaID						BIGINT(20);
	DECLARE Var_EstatusAmor						CHAR(1);					# Estatus de la amortizacion
	DECLARE Var_EstatusAmortizacion				CHAR(1);					# Estatus de la amortizacion
	DECLARE Var_EstConsolidacion				CHAR(1);	-- Estatus de un credito Consolidado

	DECLARE Var_MonedaLinea						INT(11);		-- Numero de Moneda de la Linea de Credito
	DECLARE Var_FechaVencimiento				DATE;			-- Fecha de Vencimiento de la Linea de Credito
	DECLARE Var_SaldoDisponible					DECIMAL(14,2);	-- Saldo disponible de la Linea de Credito
	DECLARE Var_Dispuesto						DECIMAL(14,2);	-- Saldo Dispuesto de la Linea de Credito
	DECLARE Var_EstatusLinea					CHAR(1);		-- Estatus de la Linea de Credito
	DECLARE Var_SucursalLin						INT(11);		-- Sucursal de la Linea de Credito
	DECLARE Var_EsAgropecuario					CHAR(1);		-- Es Agropecuario

	DECLARE Var_ManejaComAdmon					CHAR(1);		-- Maneja Comisión Administración \nS.- SI \nN.- NO
	DECLARE Var_ComAdmonLinPrevLiq				CHAR(1);		-- Comisión de Admon que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComAdmon					CHAR(1);		-- Forma de Cobro Comisión Administración \n"".- No aplica \nD.- Disposición \nT.- Total en primera Disposición
	DECLARE Var_ForPagComAdmon					CHAR(1);		-- Forma de Pago Comisión por Administración \n"".- No aplica \nD.- Deducción \nF.- Financiado
	DECLARE Var_MontoPagComAdmon				DECIMAL(14,2);	-- Monto a Pagar por Comisión por Administración

	DECLARE Var_ManejaComGarantia				CHAR(1);		-- Maneja Comisión por Garantía \nS.- SI \nN.- NO
	DECLARE Var_ComGarLinPrevLiq				CHAR(1);		-- Comisión de Garantia que ha sido pagada de manera anticipada (Previamente Liquidada) \n"".- No aplica \nN.- NO \nS.- SI
	DECLARE Var_ForCobComGarantia				CHAR(1);		-- Forma de Cobro Comisión Garantía \n"".- No aplica \nC.- Cada Cuota
	DECLARE Var_ForPagComGarantia				CHAR(1);		-- Forma de pago Comision por Garantia \n"".- No aplica \nD.- Deducción \nF.- Financiado
	DECLARE Var_MontoPagComGarantia				DECIMAL(14,2);	-- Monto a Pagar por Comisión por Servicio de Garantia
	DECLARE Var_FechaUltimoCobro				DATE;			-- Fecha de Ultimo cobro de Comision
	DECLARE Var_IVAMontoPagComAdmon				DECIMAL(14,2);	-- Monto de Comision de Pago
	DECLARE Var_RegistroID						INT(11);		-- Numero de Registro

	-- Declaracion de Constantes
	DECLARE Act_Desembolso						INT(11);
	DECLARE Act_SegVigente						INT(11);
	DECLARE Act_TipoActInteres					INT(11);					# Actualizacion AMORTICREDITOACT
	DECLARE AltaMovAho_NO						CHAR(1);
	DECLARE AltaMovAho_SI						CHAR(1);
	DECLARE AltaMovCre_NO						CHAR(1);
	DECLARE AltaPolCre_NO						CHAR(1);
	DECLARE AltaPolCre_SI						CHAR(1);
	DECLARE AltaPoliza_NO						CHAR(1);
	DECLARE AltaPoliza_SI						CHAR(1);
	DECLARE Cadena_Vacia						CHAR(1);
	DECLARE Con_AvalID							INT(1);						# Consulta por AvalID
	DECLARE Con_ClienteID						INT(1);						# Consulta por ClienteID
	DECLARE Con_ContCapCre						INT(11);
	DECLARE Con_ContCapVen						INT(11);
	DECLARE Con_ContCapVNE						INT(11);
	DECLARE Con_ContComApe						INT(11);					# Concepto contable cartera  comision por apertura
	DECLARE Con_ContDesem						INT(11);
	DECLARE Con_ContGastos						INT(11);					# Concepto Contable Cartera: Cuenta Gastos
	DECLARE Con_ContIVACApe						INT(11);					# Concepto contable cartera IVA comision por apertura.
	DECLARE Con_EstBalance						INT(11);
	DECLARE Con_EstResultados					INT(11);
	DECLARE Con_Origen							CHAR(1);
	DECLARE Con_PagoSegVida						INT(11);
	DECLARE Con_ProspectoID						INT(1);						# Consulta por ProspectoID
	DECLARE ConcepCtaOrdenDeuAgro				INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE ConcepCtaOrdenCorAgro				INT(11);		-- Concepto Cuenta Ordenante Corte Agro
	DECLARE Cre_EsRestruct						CHAR(1);
	DECLARE CreNuevo							CHAR(1);
	DECLARE CreReestructura						CHAR(1);
	DECLARE CreRenovacion						CHAR(1);
	DECLARE Des_Reserva							VARCHAR(100);
	DECLARE DescripBloqCheq						VARCHAR(40);
	DECLARE DescripBloqOrden					VARCHAR(100);
	DECLARE DescripBloqSPEI						VARCHAR(40);
	DECLARE DescripBloqueo						VARCHAR(100);
	DECLARE DispersionCheque					CHAR(1);
	DECLARE DispersionOrden						CHAR(1);
	DECLARE DispersionSPEI						CHAR(1);
	DECLARE Entero_Cero							INT(11);
	DECLARE Entero_Uno							INT(11);
	DECLARE Estatus_Activo						CHAR(1);
	DECLARE Estatus_Inactivo					CHAR(1);
	DECLARE Estatus_NoDesembolsada				CHAR(1);
	DECLARE Estatus_Procesado					CHAR(1);
	DECLARE EstatusAvalesSol					CHAR(1);					# Estatus de  Avales por Solicitudes, Asignado.
	DECLARE EstatusDesemb						CHAR(1);
	DECLARE EstatusDesembolsada					CHAR(1);					# Estatus de la solicitud: Desembolsada
	DECLARE EstatusLinea						CHAR(1);
	DECLARE EstatusPagado						CHAR(1);
	DECLARE EstatusVencido						CHAR(1);
	DECLARE EstatusVigente						CHAR(1);
	DECLARE Fecha_Vacia							DATE;
	DECLARE FechPrimAmort						DATE;
	DECLARE FechSistema							DATE;
	DECLARE FechUltiAmort						DATE;
	DECLARE FechVencCred						DATE;
	DECLARE FechVencLinea						DATE;
	DECLARE Finiquito_SI						CHAR(1);
	DECLARE FolioOperac							INT(11);
	DECLARE ForCobroApDeduc						CHAR(1);					# Forma de Cobro de Comision por apertura : D(Deduccion)
	DECLARE ForCobroApFinanc					CHAR(1);					# Forma de Cobro de Comision por apertura : F (Financiamento)
	DECLARE ForComApDeduc						CHAR(1);					# Forma de Cobro de Comision por apertura : D(Deduccion)
	DECLARE ForComApFinanc						CHAR(1);					# Forma de Cobro de Comision por apertura : F (Financiamento)
	DECLARE Fre_Catorce							CHAR(1);
	DECLARE Fre_Mensual							CHAR(1);
	DECLARE Fre_Quince							CHAR(1);
	DECLARE Fre_Semanal							CHAR(1);
	DECLARE FrecLibre							CHAR(1);
	DECLARE FrecUnico							CHAR(1);
	DECLARE IntercamAvales_NO					CHAR(1);					# Producto de Credito No Intercambia Avales
	DECLARE LiquidacionParcial					CHAR(1);
	DECLARE LiquidacionTotal					CHAR(1);
	DECLARE ManCaptacionNo						CHAR(1);
	DECLARE ManCaptacionSi						CHAR(1);
	DECLARE ManjeaLinea							CHAR(1);
	DECLARE MonedaLinea							INT(11);
	DECLARE MontoCred							DECIMAL(14,2);
    DECLARE Mov_CapAtrasado						INT(11);
	DECLARE Mov_CapVencido						INT(11);
	DECLARE Mov_CapVeNoExi						INT(11);
	DECLARE Mov_CapVigente						INT(11);
	DECLARE Nat_Abono							CHAR(1);
	DECLARE Nat_Cargo							CHAR(1);
	DECLARE NatMovBloqueo						CHAR(1);
	DECLARE No_EsReestruc						CHAR(1);
	DECLARE NTranSim							BIGINT(20);
	DECLARE Num_PagRegula						INT(11);
	DECLARE NumCredit							INT(11);
	DECLARE NumPrimAmort						INT(11);
	DECLARE Pag_Libres							CHAR(1);
	DECLARE PagareImp							CHAR(1);
	DECLARE PagImpCred							CHAR(1);
	DECLARE Par_Consecutivo						BIGINT(20);
	DECLARE PrePago_NO							CHAR(1);
	DECLARE RequiereAvales_IN					CHAR(1);					# Producto de Credito Requiere Avales Indistinto
	DECLARE RequiereAvales_SI					CHAR(1);					# Producto de Credito Si Requiere Avales
	DECLARE Res_EstatusCrea						CHAR(1);					# Estatus del Credito anterior
	DECLARE Res_EstatusCredAnt					CHAR(1);					# Saldo del Credito Anterior
	DECLARE Res_NumDiasAtraOri					INT(11);					# Numero de Atrasos
	DECLARE Res_NumPagoSos						INT(11);					# Numero de Pagos Sostenidos
	DECLARE Res_PeriodCap						INT(11);					# Periodicidad del Capital del Credito anterior
	DECLARE Res_SaldoCredAnteri					DECIMAL(12,2);				# Variables para el Manejo de Reestructuras
	DECLARE Res_SaldoExigi						DECIMAL(12,2);				# Exigible del Saldo
	DECLARE SaldoDisp							DECIMAL(14,2);
	DECLARE Salida_SI							CHAR(1);					# Indica una salida en pantalla
	DECLARE Salida_NO							CHAR(1);
	DECLARE Si_EsReestruc						CHAR(1);
	DECLARE SiManejaLinea						CHAR(1);
	DECLARE SiPagaIVA							CHAR(1);
	DECLARE SMS_CamMinistra						INT(11);
	DECLARE Str_NumErr							CHAR(3);
	DECLARE Tip_FonSolici						CHAR(1);
	DECLARE Tip_MovAhoComAp						CHAR(3);
	DECLARE Tip_MovAhoDesem						CHAR(3);
	DECLARE Tip_MovAhoSegVid					CHAR(3);
	DECLARE Tip_MovIVAAhCAp						CHAR(3);
	DECLARE Tipo_InstitucionFondeo				CHAR(1);
	DECLARE Tipo_MovConta						INT(11);					# Tipo de movimiento contable
	DECLARE Tipo_RecursosPropios				CHAR(1);
	DECLARE TipoBloqueo							INT(11);
	DECLARE ProcesoMinistra						CHAR(1);
	DECLARE Estatus_Pagada						CHAR(1);
	DECLARE TipoGrupo_NoAplica					INT(11);
	DECLARE TipoGrupo_NoFormal					INT(11);
	DECLARE TipoGrupo_Global					INT(11);
    DECLARE EstatusAtrasado						CHAR(1);
    DECLARE EstatusCancelado					CHAR(1);					# EstatusCancelado
	DECLARE RespaldaCredSI						CHAR(1);
    DECLARE Var_SaldoRenovar					DECIMAL(16,2);
	DECLARE Var_Monto							DECIMAL(12,2);	-- Variables para el Simulador
	DECLARE Cons_Periodo						CHAR(1);
	DECLARE Var_FolioConsolidacionID			BIGINT(12);		-- Folio de Consolidacion para creditos consolidados AGRO
	DECLARE Var_EsConsolidacionAgro				CHAR(1);		-- Es consolidacion Agro
	DECLARE Con_NO								CHAR(1);		-- Constante NO
	DECLARE Con_SI								CHAR(1);		-- Constante SI
	DECLARE Con_Deduccion						CHAR(1);		-- Forma de Pago por Deduccion
	DECLARE Con_Financiado						CHAR(1);		-- Forma de Pago por Financiado
	DECLARE Con_DesForCobCom					VARCHAR(100);	-- Constante Descripcion Forma de Cobro por Comision
	DECLARE Con_DesIvaForCobCom					VARCHAR(100);	-- Constante Descripcion IVA Forma de Cobro por Comision
	DECLARE Con_CarComAdmonLinCred				INT(11);		-- Concepto Cartera Comision por Admon por Linea Credito Agro
	DECLARE Con_CarComAdmonDisLinCred			INT(11);		-- Concepto Cartera Comision por Admon por Disposicion de Linea Credito Agro
	DECLARE Con_CarIvaComAdmonDisLinCred		INT(11);		-- Concepto Cartera IVA Comision por Admon por Disposicion de Linea Credito Agro
	DECLARE Con_CarComGarDisLinCred				INT(11);		-- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
	DECLARE Var_SucursalID						INT(11);		-- Sucursal del Credito
	DECLARE Var_IVASucursal						DECIMAL(14,2);	-- IVA de Sucursal
	DECLARE Var_IVALineaCredito					DECIMAL(14,2);	-- IVA de Linea de Credito
	DECLARE Tip_Disposicion						CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total							CHAR(1);		-- Constante Total en primera Disposicion
	DECLARE Tip_Cuota							CHAR(1);		-- Constante Cada Cuota
	DECLARE	Tip_ComAdmon						CHAR(1);		-- Constante Tipo Comision Admon
	DECLARE	Tip_ComGarantia						CHAR(1);		-- Constante Tipo Comision Garantia
	DECLARE Tip_MovComAdmonDisLinCred			INT(11);		-- Tipo Movimiento Credito Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE Tip_MovIVAComAdmonDisLinCred		INT(11);		-- Tipo Movimiento Credito IVA Comision por Administracion por Disposicion de Linea Credito Agro
	DECLARE CobraForCobComAdmon					CHAR(1);

	/*CURSOR QUE CREA LAS AMORTIZACIONES EN AMORTICREDITO DE ACUERDO AL CALENDARIO IDEAL Y AL MONTO QUE SE VA DESEMBOLSAR*/
	DECLARE CURSORAMORTIAGRO CURSOR FOR
		SELECT  Amo.CreditoID,  Amo.AmortizacionID, Aud_NumTransaccion, Amo.MontoPendDesembolso
			FROM	AMORTICREDITOAGRO Amo
					INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
			WHERE
				Cre.CreditoID				= Par_CreditoID
			AND Amo.EstatusDesembolso		= Estatus_NoDesembolsada
			AND (Cre.Estatus				= EstatusVigente OR  Cre.Estatus	= EstatusVencido )
			;

	DECLARE CURSORAMORTI CURSOR FOR
		SELECT  Amo.CreditoID,  Amo.AmortizacionID, Aud_NumTransaccion, Amo.TmpMontoDesembolso, A.Estatus
			FROM	AMORTICREDITO A
					INNER JOIN AMORTICREDITOAGRO Amo
                    ON A.CreditoID = Amo.CreditoID
                    AND A.AmortizacionID = Amo.AmortizacionID
					INNER JOIN CREDITOS Cre ON Amo.CreditoID   = Cre.CreditoID
			WHERE	Cre.CreditoID   = Par_CreditoID
			AND	(Cre.Estatus 	= EstatusVigente
					OR  Cre.Estatus	= EstatusVencido )
			AND	Amo.TmpMontoDesembolso	> Entero_Cero ;

	# Asignacion de Constantes
	SET Act_Desembolso							:= 1;						# Tipo de Actualizacion de la Reest: Desembolso
	SET Act_SegVigente							:= 1;						# Tipo de Actualizacion del Seguro: Vigente (Pagado por el Cliente)
	SET Act_TipoActInteres						:= 1;						# Fondeo por Financiamiento
	SET AltaMovAho_NO							:= 'N';						# Alta de Movimiento de Ahorro: NO
	SET AltaMovAho_SI							:= 'S';						# Alta de Movimiento de Ahorro: SI
	SET AltaMovCre_NO							:= 'N';						# Alta de Movimiento de Credito: NO
	SET AltaPolCre_NO							:= 'N';						# Alta de Poliza Contable de Credito: NO
	SET AltaPolCre_SI							:= 'S';						# Alta de Poliza Contable de Credito: SI
	SET AltaPoliza_NO							:= 'N';						# Alta de Poliza Contable General: NO
	SET AltaPoliza_SI							:= 'S';						# Alta de Poliza Contable General: SI
	SET Cadena_Vacia							:= '';						# String Vacio
	SET Con_AvalID								:= 1;						# Consulta por AvalID
	SET Con_ClienteID							:= 2;						# Consulta por ClienteID
	SET Con_ContCapCre							:= 1;						# Concepto Contable de Credito: Capital (CONCEPTOSCARTERA)
	SET Con_ContCapVen							:= 3;						# Concepto Contable de Credito: Capital Vencido (CONCEPTOSCARTERA)
	SET Con_ContCapVNE							:= 4;						# Concepto Contable de Credito: Capital Vencido No Exigible
	SET Con_ContComApe							:= 22;						# Concepto Contable de Credito: Com x Apertura (CONCEPTOSCARTERA)
	SET Con_ContDesem							:= 50;						# Concepto Contable de Desembolso (CONCEPTOSCONTA)
	SET Con_ContGastos							:= 58 ;						# Cuenta Puente para la Comision por Apertura
	SET Con_ContIVACApe							:= 23;						# Concepto Contable de Credito: IVA Com Apertura (CONCEPTOSCARTERA)
	SET Con_EstBalance							:= 17;						# Balance. Estimacion Prev. Riesgos Crediticios
	SET Con_EstResultados						:= 18;						# Resultados. Estimacion Prev. Riesgos Crediticios
	SET Con_Origen								:= 'E';						# Constante Origen donde se llama el SP (S= safy, W=WS)
	SET Con_PagoSegVida							:= 25;						# Concepto Contable de Cobertura de Seguro de Vida
	SET Con_ProspectoID							:= 3;						# Consulta por ProspectoID
	SET ConcepCtaOrdenDeuAgro					:= 138;
	SET ConcepCtaOrdenCorAgro					:= 139;
	SET CreNuevo								:= 'N';						# Credito Nuevo
	SET CreReestructura							:= 'R';						# Credito reestructurador
	SET CreRenovacion							:= 'O';						# Credito Renovador
	SET Des_Reserva								:= 'ESTIMACION CAPITALIZACION INTERES';
	SET DescripBloqCheq							:= 'BLOQUEO DE SALDO POR CHEQUE';
	SET DescripBloqOrden						:= 'BLOQUEO DE SALDO POR ORDEN DE PAGO';
	SET DescripBloqSPEI							:= 'BLOQUEO DE SALDO POR SPEI';
	SET DispersionCheque						:= 'C';						# Tipo de Dispersion por Cheque
	SET DispersionOrden							:= 'O';						# Tipo de Dispersion por Orden de Pago
	SET DispersionSPEI							:= 'S';						# Tipo de Dispersion por SPEI
	SET Entero_Cero								:= 0;						# Entero en Cero
	SET Entero_Uno								:= 1;						# Entero Uno
	SET Estatus_Activo							:= 'A';						# Estatus Activo
	SET Estatus_Inactivo						:= 'I';						# Estatus Inactivo
	SET Estatus_NoDesembolsada					:= 'N';						# Estatus No desembolsada
	SET Estatus_Procesado						:= 'M';						# Estatus Procesado
	SET EstatusAvalesSol						:= 'U';						# Estatus Avales por Solicitud:	Asignado
	SET EstatusDesemb							:= 'D';						# Estatus de Desembolsado
	SET EstatusDesembolsada						:= 'D';						# Estatus de la Solicitud: Desembolsada
	SET EstatusPagado							:= 'P';						# Estatus de Pagado
	SET EstatusVencido							:= 'B';						# Estatus de Vencido
	SET EstatusVigente							:= 'V';						# Estatus de Vigente
	SET Fecha_Vacia								:= '1900-01-01';			# Fecha Vacia
	SET Finiquito_SI							:= 'S';						# El Tipo de Pago SI es Finiquito
	SET ForCobroApDeduc							:= 'D';
	SET ForCobroApFinanc						:= 'F';
	SET ForComApDeduc							:= 'D';						# La Comision por Apertura en por Deduccion
	SET ForComApFinanc							:= 'F';						# La Comision por Apertura en por Financiamiento
	SET Fre_Catorce								:= 'C';						# Frecuencia de Pagos Catorcenales
	SET Fre_Mensual								:= 'M';						# Frecuencia de Pagos Mensual
	SET Fre_Quince								:= 'Q';						# Frecuencia de Pagos Quincenal
	SET Fre_Semanal								:= 'S';						# Frecuencia de Pagos Semanales
	SET FrecLibre								:= 'L';						# Frecuencia Libre
	SET FrecUnico								:= 'U';						# Frecuencua Unica
	SET IntercamAvales_NO						:= 'N';						# Producto Credito Intercambia Avales:		No
	SET LiquidacionParcial						:= 'P';						# Liquidacion Parcial(Renovaciones)
	SET LiquidacionTotal						:= 'T';						# Liquidacion Total(Renovaciones)
	SET ManCaptacionNo							:= 'N';						# La institucion no Maneja Captacion
	SET ManCaptacionSi							:= 'S';						# La institucion si Maneja Captacion
	SET Mov_CapAtrasado 						:= 2;    					# Tipo del Movimiento de Credito: Capital Atrasado (TIPOSMOVSCRE)
    SET Mov_CapVencido							:= 3;						# Tipo del Movimiento de Credito: Capital Vencido (TIPOSMOVSCRE)
	SET Mov_CapVeNoExi							:= 4;						# Tipo del Movimiento de Credito: Capital Vencido No Exigible
	SET Mov_CapVigente							:= 1;						# Tipo del Movimiento de Credito: Capital Vigente (TIPOSMOVSCRE)
	SET Nat_Abono								:= 'A';						# Naturaleza de Abono.
	SET Nat_Cargo								:= 'C';						# Naturaleza de Cargo
	SET NatMovBloqueo							:= 'B';						# Tipo de Movimiento de Bloqueo de Saldo en Cta de Ahorro
	SET No_EsReestruc							:= 'N';						# El Producto de Credito no es para Reestructuras
	SET Num_PagRegula							:= 3;						# Numero de Pagos Para Regularizacion Reestructura: 3
	SET NumPrimAmort							:= 1;						# Numero de la Primera Amortizacion
	SET Pag_Libres								:= 'L';						# Tipo de Calendario: Amortizaciones con Pagos Libres
	SET PagareImp								:= 'S';						# El pagare esta Impreso
	SET PrePago_NO								:= 'N';						# El Tipo de Pago No es PrePago
	SET RequiereAvales_IN						:= 'I';						# Producto Credito Requiere Avales:	Indistinto
	SET RequiereAvales_SI						:= 'S';						# Producto Credito Requiere Avales:	Si
	SET Salida_SI								:= 'S';
	SET Salida_NO								:= 'N';						# Ejecutar Store sin Regreso o Mensaje de Salida
	SET Si_EsReestruc							:= 'S';						# El credito si es una Reestructura
	SET SiManejaLinea							:= 'S';						# El Credito si Maneja Linea
	SET SiPagaIVA								:= 'S';						# El Cliente si Paga IVA
	SET SMS_CamMinistra							:= 1010;					# CampaÃ±a de Ministracion
	SET Tip_FonSolici							:= 'S';						# Tipo de Fondeo en base a la Solicitud
	SET Tip_MovAhoComAp							:= '83';					# Tipo de Movimiento en Cta de Ahorro: Com Apertura (TIPOSMOVSAHO)
	SET Tip_MovAhoDesem							:= '100';					# Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)
	SET Tip_MovAhoSegVid						:= '85';					# Tipo de Movimiento en Cta de Ahorro: Pago de Seguro de Vida
	SET Tip_MovIVAAhCAp							:= '84';					# Tipo de Movimiento en Cta de Ahorro: IVA Com Apert (TIPOSMOVSAHO)
	SET Tipo_InstitucionFondeo					:= 'F';						# Fondeo por Financiamiento
	SET TipoBloqueo								:= 1;						# Tipo de Movimiento de Bloqueo
	SET Var_CargoCuenta							:= 'C';
	SET Var_DcIVAComApe							:= 'IVA COMISION POR APERTURA';
	SET Var_DescComAper							:= 'COMISION POR APERTURA';
	SET Var_Descripcion							:= 'DESEMBOLSO DE CREDITO';
	SET Var_DescSegVida							:= 'SEGURO DE VIDA';
	SET Con_DesForCobCom						:= 'COBRO DE COMISION POR LINEA DE CREDITO';
	SET Con_DesIvaForCobCom						:= 'COBRO DE IVA COMISION POR LINEA DE CREDITO';
	SET Var_SaldoCredAnt						:= 0.0;
	SET Var_SI									:= 'S';
	SET Var_TipoProd							:= 2;						# Creditos sin Linea de Credito
    SET Var_PolizaID							:= 0;
	SET ProcesoMinistra							:='M';
	SET Estatus_Pagada							:='P';
	SET TipoGrupo_NoAplica						:= 1;						# No es tipo grupal el credito
	SET TipoGrupo_NoFormal						:= 2;						# Grupo No Formal
	SET TipoGrupo_Global						:= 3;						# Grupo Global
    SET EstatusAtrasado							:= 'A';						# Estatus Atrasado
	SET EstatusCancelado						:= 'C';				    	# EstatusCancelado.
	SET RespaldaCredSI							:= 'S';
	SET Cons_Periodo							:= 'P';
	SET Con_NO									:= 'N';
	SET Con_SI									:= 'S';
	SET Con_Deduccion							:= 'D';
	SET Con_Financiado							:= 'F';
	SET Tip_Disposicion							:= 'D';
	SET Tip_Total								:= 'T';
	SET Tip_Cuota								:= 'C';
	SET Con_CarComAdmonLinCred 					:= 140;
	SET Con_CarComAdmonDisLinCred 				:= 141;
	SET Con_CarIvaComAdmonDisLinCred			:= 144;
	SET Con_CarComGarDisLinCred 				:= 143;
	SET	Tip_ComAdmon							:= 'A';
	SET	Tip_ComGarantia							:= 'G';
	SET Tip_MovComAdmonDisLinCred				:= 61;
	SET Tip_MovIVAComAdmonDisLinCred			:= 62;
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACREAGROPRO');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SET Var_FechaOper :=(SELECT FechaSucursal FROM SUCURSALES WHERE SucursalID=Aud_Sucursal);
		SET Var_ReqValidaCred := (SELECT ReqValidaCred FROM PARAMETROSSIS);

		CALL DIASFESTIVOSCAL(
			Var_FechaOper,		Entero_Cero,			Var_FechaApl,			Var_EsHabil,		Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		-- Inicializacion
		SET Cre_EsRestruct	:= No_EsReestruc;
		SET Str_NumErr	 := '0';
		SET Var_Poliza	 := Entero_Cero;

		SELECT	Cre.LineaCreditoID,		Cre.ClienteID,				Cre.CuentaID,			Cre.MonedaID,				Cre.Estatus,
				Cli.SucursalOrigen,		Cre.ProductoCreditoID,		Des.Clasificacion,		Pro.ManejaLinea,			Cre.MontoCredito,
				Cre.PagareImpreso,		Cre.FechaVencimien,			Cre.NumTransacSim,		SolicitudCreditoID,			Cre.FechaInicio,
				Cre.FrecuenciaCap,		TipoPagoCapital,			Cta.MonedaID,			Cre.SolicitudCreditoID,		Cli.NombreCompleto,
				Cli.RFC,				Cli.RFCpm,					Cli.TipoPersona,		Cre.MontoComApert,			Cre.IVAComApertura,
				Pro.ForCobroComAper,	Cre.DiaPagoCapital,			Cre.DiaMesCapital,		Cre.FechaInhabil,			AjusFecUlVenAmo,
				AjusFecExiVen,			Cre.Relacionado,			EsReestructura,			Cre.PeriodicidadCap,		Cre.MontoSeguroVida,
				Cre.ForCobroSegVida,	Cli.PagaIVA,				Des.SubClasifID,		Cli.TelefonoCelular,		Cre.FechaInicioAmor,
				Pro.EsquemaSeguroID,	Pro.RequiereAvales,			Cre.TipoCredito,		Cre.TipoLiquidacion,		Cre.CantidadPagar,
				Cre.FrecuenciaInt,		Cre.PeriodicidadInt,		Cre.TipoFondeo,			Cre.MontoDesemb,			Cre.SaldoCapVigent,
				Cre.GrupoID,			EsConsolidacionAgro,		Cre.SucursalID,
				Cre.ManejaComAdmon,		Cre.ComAdmonLinPrevLiq,		Cre.ForCobComAdmon,		Cre.ForPagComAdmon,			Cre.MontoPagComAdmon,
				Cre.ManejaComGarantia,	Cre.ComGarLinPrevLiq,		Cre.ForCobComGarantia,	Cre.ForPagComGarantia,		Cre.MontoPagComGarantia
		INTO	Var_LineaCreditoID,		Var_ClienteID,				Var_CuentaAhoID,		Var_MonedaID,				Var_EstatusCre,
				Var_SucCliente,			Var_ProdCreID,				Var_ClasifCre,			ManjeaLinea,				MontoCred,
				PagImpCred,				FechVencCred,				NTranSim,				Var_SoliciCredID,			Var_FecIniCred,
				Var_FrecuenCap,			Var_TipPagCapita,			Var_MonedaCta,			Var_SolCredito,				Var_NomCliente,
				VarRFCcte,				VarRFCPMcte,				VarTipoPerson,			Var_MontoComAp,				Var_IVAComAp,
				Var_ForComApe,			Var_DiaPagoCap,				Var_DiaMesCap,			Var_FechaInhabil,			Var_AjFecUlVenAmo,
				Var_AjFecExiVen,		Var_Relacionado,			Var_EsReestructura,		Var_PeriodCap,				Var_MontoSegVida,
				Var_ForCobSegVida,		Var_PagIVA,					Var_SubClasifID,		Var_TelefonoCel,			Var_FechaInicioAmor,
				Var_EsqSeguroID,		Var_RequiereAvales,			Var_TipoCredito,		Var_TipoLiquidacion,		Var_CantidadPagar,
				Var_FrecInteres,		Var_PeriodInt,				Var_TipoFondeo,			Var_MontoMinistradoAgro,	Var_SaldoCapVigent,
				Var_GrupoID,			Var_EsConsolidacionAgro,	Var_SucursalID,
				Var_ManejaComAdmon,		Var_ComAdmonLinPrevLiq,		Var_ForCobComAdmon,		Var_ForPagComAdmon,			Var_MontoPagComAdmon,
				Var_ManejaComGarantia,	Var_ComGarLinPrevLiq,		Var_ForCobComGarantia,	Var_ForPagComGarantia,		Var_MontoPagComGarantia
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		INNER JOIN CUENTASAHO Cta ON Cre.CuentaID = Cta.CuentaAhoID AND Cre.ClienteID = Cta.ClienteID
		INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE Cre.CreditoID	= Par_CreditoID;

		# Sacamos el monto del credito de las ministraciones del credito
		SET Var_Monto 									:= MontoCred;
		SET MontoCred									:= (SELECT Capital FROM MINISTRACREDAGRO WHERE CreditoID = Par_CreditoID AND Numero = Par_NumeroMinistracion);
		SET MontoCred									:= IFNULL(MontoCred, Entero_Cero);
		SET Var_MontoMinistradoAgro						:= IFNULL(Var_MontoMinistradoAgro,Entero_Cero) + MontoCred;
		SET Var_MontoMinistrado							:= MontoCred;
		# Sacamos la fecha de pago de la amortización

		SET Var_RequiereAvales							:= IFNULL(Var_RequiereAvales, Cadena_Vacia);
		SET Var_MontoComAp								:= IFNULL(Var_MontoComAp, Entero_Cero);
		SET Var_IVAComAp								:= IFNULL(Var_IVAComAp, Entero_Cero);
		SET Var_MontoSegVida							:= IFNULL(Var_MontoSegVida, Entero_Cero);
		SET Var_ForCobSegVida							:= IFNULL(Var_ForCobSegVida, Cadena_Vacia);
		SET Var_PagIVA									:= IFNULL(Var_PagIVA, Cadena_Vacia);
		SET Var_SubClasifID								:= IFNULL(Var_SubClasifID, Entero_Cero);
		SET Var_EsqSeguroID								:= IFNULL(Var_EsqSeguroID, Entero_Cero);
		SET Var_GrupoID									:= IFNULL(Var_GrupoID, Entero_Cero);
		SET Var_EsConsolidacionAgro	:= IFNULL(Var_EsConsolidacionAgro, Con_NO);
		SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);

		IF( Var_LineaCreditoID > Entero_Cero ) THEN

			SELECT	MonedaID,			FechaVencimiento,		SaldoDisponible,		Dispuesto,		Estatus,
					SucursalID,			EsAgropecuario
			INTO	Var_MonedaLinea,	Var_FechaVencimiento,	Var_SaldoDisponible,	Var_Dispuesto,	Var_EstatusLinea,
					Var_SucursalLin,	Var_EsAgropecuario
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Var_LineaCreditoID;

			SET Var_MonedaLinea		 := IFNULL(Var_MonedaLinea, Entero_Cero);
			SET Var_FechaVencimiento := IFNULL(Var_FechaVencimiento, Fecha_Vacia);
			SET Var_SaldoDisponible	 := IFNULL(Var_SaldoDisponible, Entero_Cero);
			SET Var_Dispuesto		 := IFNULL(Var_Dispuesto, Entero_Cero);
			SET Var_EstatusLinea	 := IFNULL(Var_EstatusLinea, Cadena_Vacia);

			SET Var_SucursalLin		 := IFNULL(Var_SucursalLin, Entero_Cero);
			SET Var_EsAgropecuario	 := IFNULL(Var_EsAgropecuario, Con_NO);

			IF( Var_EsAgropecuario = Con_NO ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'La Linea de Credito no es Agropecuaria.';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SELECT
			EsquemaSeguroID,		ProducCreditoID,	TipoPagoSeguro,		FactorRiesgoSeguro,		DescuentoSeguro,
			MontoPolSegVida
		INTO
			Var_EsquemaSeguro,		Var_ProdCredID,		Var_TipPagSegu,		Var_FactRiSeg,			Var_DescSegu,
			Var_MontoPolSeg
		FROM ESQUEMASEGUROVIDA
		WHERE ProducCreditoID = Var_ProdCreID
		  AND TipoPagoSeguro	= Var_ForCobSegVida;

		SET Var_EsquemaSeguro := IFNULL(Var_EsquemaSeguro, Entero_Cero);

		SELECT
			FechaSistema,			ManejaCaptacion,		PagoIntVertical
			INTO
			FechSistema,			Var_ManCapta,			Var_PagaInteres
			FROM	PARAMETROSSIS
				WHERE	EmpresaID = Aud_EmpresaID;

		SELECT
			MAX(FechaVencim),		MIN(FechaInicio),	COUNT(*)
			INTO
			FechUltiAmort,			FechPrimAmort,		Var_NumAmorti
			FROM	AMORTICREDITO
			WHERE	CreditoID	= Par_CreditoID
			GROUP BY CreditoID;

		SELECT
			TipoDispersion,  	CuentaCLABE
			INTO
			Var_TipoDisper,		VarCuentaCLABE
			FROM	CREDITOS
			WHERE	CreditoID	= Par_CreditoID;

		IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr			:= 1;
			SET Par_ErrMen			:= 'El Numero de Credito esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_ClienteID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr			:= 2;
			SET Par_ErrMen			:= 'El cliente no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr			:= 3;
			SET Par_ErrMen			:= 'La Cuenta no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_MonedaID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr			:= 4;
			SET Par_ErrMen			:= 'La Moneda no Existe.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_EstatusCre, Cadena_Vacia))= Cadena_Vacia THEN
			SET Par_NumErr			:= 5;
			SET Par_ErrMen			:= 'El Credito No Existe o No esta Autorizado.';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_MonedaCta <> Var_MonedaID )THEN
			SET Par_NumErr			:= 6;
			SET Par_ErrMen			:= 'La Moneda de la Cuenta es Diferente de la Moneda del Credito.';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_EstatusCre, Cadena_Vacia))= Estatus_Pagada THEN
			SET Par_NumErr			:= 7;
			SET Par_ErrMen			:= 'El Credito Ya se Encuentra Pagado.';
			LEAVE ManejoErrores;
		END IF;

		# VALIDACIONES QUE SOLO OCURREN EN LA PRIMERA MINISTRACION ======================================================================
		IF(Par_NumeroMinistracion = Entero_Uno) THEN
			IF(Var_ReqValidaCred = 'N')THEN
				IF(Var_EstatusCre != Estatus_Activo) THEN
					SET Par_NumErr	:= 8;
					SET Par_ErrMen	:= CONCAT('El Credito No Existe o No esta Autorizado.');
					LEAVE ManejoErrores;
				END IF;
			ELSE
				IF(Var_EstatusCre != Estatus_Procesado) THEN
					SET Par_NumErr	:= 9;
					SET Par_ErrMen	:= 'El Credito No Existe o No esta Procesado.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(PagImpCred != PagareImp)THEN
				SET Par_NumErr		:= 10;
				SET Par_ErrMen		:= 'El Pagare No ha Sido Impreso.';
				LEAVE ManejoErrores;
			END IF;

			IF DATEDIFF(FechVencCred,FechUltiAmort)  <Entero_Cero THEN
				SET Par_NumErr		:= 11;
				SET Par_ErrMen		:= 'La Fecha de la Ultima Amortizacion no esta Dentro de la Vigencia del Credito.';
				LEAVE ManejoErrores;
			END IF;

			IF(FechPrimAmort < FechSistema)THEN
				SET Par_NumErr		:= 12;
				SET Par_ErrMen		:= 'La Fecha de la Primera Amortizacion No Debe Ser Menor a la Fecha del Sistema.';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EsConsolidacionAgro = Con_NO ) THEN
				IF(FechSistema != Var_FecIniCred)THEN
					SET Par_NumErr		:= 13;
					SET Par_ErrMen		:= 'La Fecha del Sistema es Diferente a la de Inicio del Credito. Genere de Nuevo el Pagare.';
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Var_RequiereAvales = Cadena_Vacia) THEN
				SET Par_NumErr		:= 14;
				SET Par_ErrMen		:= 'El Producto de Credito, No especifica si Requiere Avales.';
				LEAVE ManejoErrores;
			END IF;

			# ============================================ VALIDACIONES PARA LINEA DE CREDITO =================================================
			IF( Var_LineaCreditoID <> Entero_Cero ) THEN

				CALL MINISTRALINEAAGROPRO(
					Par_CreditoID,		Par_PolizaID,		Var_Monto,
					Salida_NO,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;  -- EndIf de la Linea de Credito

			# ============================================== VALIDACIONES PARA AVALES ===================================================
			IF(Var_SolCredito > Entero_Cero AND (Var_RequiereAvales = RequiereAvales_SI OR Var_RequiereAvales = RequiereAvales_IN)) THEN
				-- LIMPIAR REGISTROS DE LA TABLA
				DELETE FROM TMPAVALESVALIDA WHERE NumeroTransaccion=Aud_NumTransaccion;

				-- INSERTAR REGISTROS NUEVOS EN TABLA DE PASO
				INSERT INTO TMPAVALESVALIDA (
					AvalID,					ClienteID,			ProspectoID,			CantidadAvales,			IntercambiaAvales,
					ProducCreditoID,		ClienteCre,			NumCreditosAvalados,	NumeroTransaccion)
					SELECT
						Sol.AvalID,				Sol.ClienteID,		Sol.ProspectoID,		Entero_Cero,			Cadena_Vacia,
						Cre.ProductoCreditoID,	Cre.ClienteID,
							CASE
								WHEN Sol.AvalID > Entero_Cero
									THEN FNNUMCREDITOSAVALADOS(Sol.AvalID , Con_AvalID)
								WHEN Sol.ClienteID > Entero_Cero
									THEN FNNUMCREDITOSAVALADOS(Sol.ClienteID , Con_ClienteID)
								WHEN Sol.ProspectoID > Entero_Cero
									THEN FNNUMCREDITOSAVALADOS(Sol.ProspectoID , Con_ProspectoID)
								END AS NumCreditosAvalados ,								Aud_NumTransaccion
						FROM AVALESPORSOLICI Sol
							INNER JOIN CREDITOS Cre
								ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
								AND Sol.Estatus = EstatusAvalesSol
							WHERE Cre.CreditoID = Par_CreditoID;

				UPDATE TMPAVALESVALIDA Tmp INNER JOIN PRODUCTOSCREDITO Pro ON  Tmp.ProducCreditoID = Pro.ProducCreditoID SET
					Tmp.CantidadAvales		= Pro.CantidadAvales,
					Tmp.IntercambiaAvales 	= Pro.IntercambiaAvales;

				-- Verificar que el Aval No Supere los Creditos Avalados
				SELECT
					COUNT(NumeroTransaccion)
					INTO
					Var_AvalesRechazados
					FROM TMPAVALESVALIDA
						WHERE CantidadAvales < NumCreditosAvalados
						AND NumeroTransaccion=Aud_NumTransaccion ;

				IF(Var_AvalesRechazados > Entero_Cero)THEN
					SET Par_NumErr			:= 30;
					SET Par_ErrMen			:= 'El(los) Aval(es) No Cumplen las Condiciones del Producto de Credito.';
					LEAVE ManejoErrores;
				END IF;

				--  Validad Intercambio Avales
				SELECT COUNT(Tmp.NumeroTransaccion)
					INTO Var_IntercamAvales
					FROM TMPAVALESVALIDA Tmp
						INNER JOIN SOLICITUDCREDITO Sol
							ON Tmp.ClienteID = Sol.ClienteID
							AND Sol.Estatus = EstatusDesembolsada
						INNER JOIN AVALESPORSOLICI Ava
							ON Sol.SolicitudCreditoID =  Ava.SolicitudCreditoID
							AND Ava.ClienteID = Tmp.ClienteCre,
						CREDITOS Cre
					WHERE
						Tmp.ClienteID = Sol.ClienteID
						AND Tmp.IntercambiaAvales = IntercamAvales_NO
						AND Cre.CreditoID= Sol.CreditoID
						AND Cre.Estatus <>EstatusPagado
						AND Tmp.NumeroTransaccion=Aud_NumTransaccion;

				IF(Var_IntercamAvales > Entero_Cero)THEN
					SET Par_NumErr	:= 31;
					SET Par_ErrMen	:= 'El Producto de Credito No Permite Intercambio Avales.';
					LEAVE ManejoErrores;
				END IF;

				-- QUITAR REGISTROS INSERTADOS
				DELETE FROM TMPAVALESVALIDA WHERE NumeroTransaccion=Aud_NumTransaccion;
			END IF;
			# ======================================= FIN VALIDACIONES PARA AVALES ======================================================

		END IF;
		# FIN VALIDACIONES QUE SOLO OCURREN EN LA PRIMERA MINISTRACION ==================================================================

		-- Identificamos el Monto a Desembolsar
		IF(Var_ForComApe = ForCobroApDeduc OR Var_ForComApe = ForCobroApFinanc) THEN
			SET Var_MontoADesem := MontoCred - (Var_MontoComAp + Var_IVAComAp );
		ELSE
			SET Var_MontoADesem := MontoCred;
			SET Var_MontoComAp  := Entero_Cero;
			SET Var_IVAComAp	:= Entero_Cero;
		END IF;

		-- Restamos del Monto a Desembolsar el Monto del Seguro de Vida, Si este fue Financiado o por Deduccion
		IF(Var_EsqSeguroID = Entero_Cero)THEN
			IF(Var_ForCobSegVida = ForCobroApDeduc OR Var_ForCobSegVida = ForCobroApFinanc) THEN
				SET Var_MontoADesem := Var_MontoADesem - Var_MontoSegVida;
			ELSE
				SET Var_MontoSegVida := Entero_Cero;
			END IF;
		 ELSE
			IF(Var_TipPagSegu = ForCobroApDeduc OR Var_TipPagSegu = ForCobroApFinanc) THEN
				SET Var_MontoADesem := Var_MontoADesem - Var_MontoSegVida;
			ELSE
				SET Var_MontoSegVida := Entero_Cero;
			END IF;
		END IF;

		SET Var_ManejaComAdmon		:= IFNULL(Var_ManejaComAdmon, Con_NO);
		SET Var_ComAdmonLinPrevLiq	:= IFNULL(Var_ComAdmonLinPrevLiq, Con_NO);
		SET Var_ForCobComAdmon		:= IFNULL(Var_ForCobComAdmon, Cadena_Vacia);
		SET Var_ForPagComAdmon		:= IFNULL(Var_ForPagComAdmon, Cadena_Vacia);
		SET Var_MontoPagComAdmon	:= IFNULL(Var_MontoPagComAdmon, Entero_Cero);

		SET Var_ManejaComGarantia	:= IFNULL(Var_ManejaComGarantia, Con_NO);
		SET Var_ComGarLinPrevLiq	:= IFNULL(Var_ComGarLinPrevLiq, Con_NO);
		SET Var_ForCobComGarantia	:= IFNULL(Var_ForCobComGarantia, Cadena_Vacia);
		SET Var_ForPagComGarantia	:= IFNULL(Var_ForPagComGarantia, Cadena_Vacia);
		SET Var_MontoPagComGarantia	:= IFNULL(Var_MontoPagComGarantia, Entero_Cero);
		SET Var_IVALineaCredito		:= Entero_Cero;
		SET CobraForCobComAdmon := Con_NO;

		IF( Var_ForCobComAdmon = Tip_Total ) THEN
			SELECT 	MAX(RegistroID)
			INTO 	Var_RegistroID
			FROM BITACORAFORCOBCOMLIN
			WHERE LineaCreditoID = Var_LineaCreditoID
			  AND TipoComision = Tip_ComAdmon
			  AND ForCobCom = Tip_Total;

			SET Var_RegistroID := IFNULL(Var_RegistroID, Entero_Cero);
			IF( Var_RegistroID = Entero_Cero ) THEN
				SET Var_FechaUltimoCobro := Var_FechaOper;
			ELSE
				SELECT 	FechaRegistro
				INTO 	Var_FechaUltimoCobro
				FROM BITACORAFORCOBCOMLIN
				WHERE RegistroID= Var_RegistroID;
				SET Var_FechaUltimoCobro := IFNULL(Var_FechaUltimoCobro, Fecha_Vacia);
			END IF;

			-- Si la fecha de Cobro es menor a la del sistema no se efectua el cargo a la cuenta
			-- en caso contrario se efectua el cargo y se agrega un registro a la bitacora de cobro
			IF( Var_FechaUltimoCobro < Var_FechaOper ) THEN
				SET CobraForCobComAdmon := Con_NO;
			ELSE
				SET CobraForCobComAdmon := Con_SI;
			END IF;
		END IF;


		IF( Var_ManejaComAdmon = Con_SI AND
			Var_ComAdmonLinPrevLiq = Con_NO AND
			Var_MontoPagComAdmon > Entero_Cero AND
			Par_NumeroMinistracion = Entero_Uno ) THEN

			SET Var_MontoADesem := Var_MontoADesem - Var_MontoPagComAdmon;

			IF( Var_PagIVA = Con_SI ) THEN

				SELECT IVA
				INTO Var_IVASucursal
				FROM SUCURSALES
				WHERE SucursalID = Var_SucCliente;

				SET Var_IVASucursal	:= IFNULL(Var_IVASucursal, Entero_Cero);
				SET Var_IVALineaCredito := ROUND((Var_MontoPagComAdmon * Var_IVASucursal), 2);
				SET Var_IVALineaCredito := IFNULL(Var_IVALineaCredito,Entero_Cero);
				SET Var_MontoADesem := Var_MontoADesem - Var_IVALineaCredito;
			END IF;

			IF( CobraForCobComAdmon = Con_NO ) THEN
				SET Var_MontoADesem := Var_MontoPagComAdmon + Var_IVALineaCredito;
			END IF;
		END IF;

		SET Var_Relacionado := IFNULL(Var_Relacionado, Entero_Cero);
		# ===================================================================================================================
		# ===================================================================================================================
		# =================================== CONSIDERACIONES PARA DESEMBOLSO DE CREDITO RENOVACION =========================
		IF(Var_TipoCredito = CreRenovacion AND Var_Relacionado != Entero_Cero AND Par_NumeroMinistracion = Entero_Uno) THEN
			SELECT  ( DATEDIFF(FechSistema,IFNULL(MIN(FechaExigible), FechSistema)))
			INTO  Res_NumDiasAtraOri
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_Relacionado
			  AND Amo.Estatus != EstatusPagado
			  AND Amo.FechaExigible <= FechSistema;

			-- Consultamos el Credito Origen a Renovar (Datos del Credito Original)
			SELECT  FUNCIONTOTDEUDACRE(Cre.CreditoID),
					FUNCIONEXIGIBLE(Cre.CreditoID),
					Cre.Estatus, Cre.PeriodicidadCap,
					ROUND(IFNULL(SaldoIntNoConta, Entero_Cero), 2)
			INTO    Res_SaldoCredAnteri,    Res_SaldoExigi, Res_EstatusCredAnt, Res_PeriodCap,  Var_SalInteres
			FROM CREDITOS Cre
			WHERE Cre.CreditoID = Var_Relacionado;

			SET Res_SaldoCredAnteri := IFNULL(Res_SaldoCredAnteri, Entero_Cero);
			SET Res_SaldoExigi      := IFNULL(Res_SaldoExigi, Entero_Cero);
			SET Res_EstatusCredAnt  := IFNULL(Res_EstatusCredAnt, Cadena_Vacia);
			SET Res_NumDiasAtraOri  := IFNULL(Res_NumDiasAtraOri, Entero_Cero);
			SET Res_PeriodCap       := IFNULL(Res_PeriodCap, Entero_Cero);
			SET Var_SalInteres      := IFNULL(Var_SalInteres, Entero_Cero);

			SELECT  IFNULL(SUM(SaldoCapVigente),Entero_Cero) +
					IFNULL(SUM(SaldoCapAtrasa),Entero_Cero) +
					IFNULL(SUM(SaldoCapVencido),Entero_Cero) +
					IFNULL(SUM(SaldoCapVenNExi),Entero_Cero)
			INTO Var_SaldoCapital
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Var_Relacionado
			AND Amo.Estatus <> EstatusPagado;

			IF (Res_SaldoCredAnteri <= Entero_Cero) THEN
				SET Par_NumErr	:= 200;
				SET Par_ErrMen	:= 'El Credito a Renovar no Presenta Adeudos.';
				LEAVE ManejoErrores;
			END IF;

			SELECT  FNTOTALADEUDORENOVACION(Var_Relacionado) INTO Var_SaldoRenovar;
			SET Var_SaldoRenovar  := IFNULL(Var_SaldoRenovar, Entero_Cero);

			IF(Var_Monto < Var_SaldoRenovar) THEN
				SET Par_NumErr	:= 201;
				SET Par_ErrMen	:= CONCAT('El Monto del Credito ',FORMAT(Var_Monto,2),' es Menor al Total del Adeudo ',FORMAT(Var_SaldoRenovar,2),' del Credito a Renovar.');
				LEAVE ManejoErrores;
			END IF;


			-- Se obtiene el valor de PagoIntVertical de los aprametros generales apra saber si se cobrará el interes exigible
			SELECT  PagoIntVertical INTO Var_LiquidaInteres FROM PARAMETROSSIS;

			-- Validar que cubre el Saldo adeudado
            IF (Var_TipoLiquidacion = LiquidacionTotal AND Var_LiquidaInteres=Var_SI) THEN
				IF (MontoCred < Res_SaldoCredAnteri ) THEN
					SET Par_NumErr	:= 202;
					SET Par_ErrMen	:= 'El Monto del Credito debe Cubrir el Saldo del Credito a Renovar. ';
					LEAVE ManejoErrores;
				END IF;
            END IF;

			IF (Var_EsReestructura = No_EsReestruc) THEN
				SET Par_NumErr	:= 203;
				SET Par_ErrMen	:= 'El Producto de Credito No Permite Renovacion.';
				LEAVE ManejoErrores;
			END IF;

			IF(Res_EstatusCredAnt != EstatusVigente AND Res_EstatusCredAnt != EstatusVencido) THEN
				SET Par_NumErr	:= 204;
				SET Par_ErrMen	:= 'El Credito a Renovar debe estar Vigente o Vencido.';
				LEAVE ManejoErrores;
			END IF;


			/***** VALIDACION PARA ASIGNAR EL ESTATUS AL CREDITO REESTRUCTURADO *****/

			-- Calculo de las Condiciones para el Credito Reestructura

           CALL ESTATUSCREDITOACT(
				Var_Relacionado,	Res_EstatusCredAnt,	Res_EstatusCrea,	Salida_NO,				Par_NumErr,
				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			-- Revision del Numero de Pagos Sostenidos para ser Regularizado
			# Se valida si el Tipo Frecuencia es diferente de Unica y Libre
			IF(Var_FrecuenCap != FrecUnico) THEN
				# Si la periodicidad del Capital es mayor a 60 dias el numero de pagos sostenidos sera 1
				IF(Var_PeriodCap >60) THEN
					SET Res_NumPagoSos  := 1;
				ELSE
                 -- Res_PeriodCap: Periodicidad de Capital del Credito Anterior
                 -- Var_PeriodCap: Periodicidad de Capital del Credito Nuevo
					IF(Var_FrecuenCap != FrecLibre) THEN
						SET Res_NumPagoSos  := CEILING((Res_PeriodCap/Var_PeriodCap) * Num_PagRegula);
					ELSE
						SET Res_NumPagoSos  := Num_PagRegula;
                    END IF;

				END IF;
			ELSE
				IF(Var_FrecuenCap = FrecUnico AND  Var_FrecInteres = FrecUnico) THEN
					SET Res_NumPagoSos  = 1;
				ELSE
                -- Var_PeriodInt: Periodicidad de Interes: Credito Nuevo
                    IF(Var_FrecInteres != Cons_Periodo) THEN
						SET Res_NumPagoSos  = CEILING((90/Var_PeriodInt));
					ELSE
						SET Res_NumPagoSos  = 1;
					END IF;
				END IF;
			END IF;


				-- Si  Renovacion Hacemos la Liquidacion del Credito Anterior
			IF (Var_TipoCredito = CreRenovacion) THEN
				/**VALIDAMOS QUE SI ES EL PRIMER DESEMBOLSO SE REALIZA LA CREACIÓN DEL CREDITO PASIVO**/
					/*Si el tipo de fondeo es por institucion entonces se crea el credito pasivo*/
				IF(Var_TipoFondeo = Tipo_InstitucionFondeo) THEN
					/* VALIDA Y MANDA A LLAMAR AL STORE DE PAGO DE CREDITO FONDEO DEL CREDITO ANTERIOR */
					IF(Var_TipoCredito = CreRenovacion) THEN

							CALL PAGOCREDITORENFONPRO(
								Var_Relacionado,		Par_CreditoID,			Var_EsReestructura,		Var_MonedaID,				Salida_NO,				Par_NumErr,
				   				Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
				   				Aud_ProgramaID,			Aud_Sucursal,			Par_NumTransacionPasivo);

							IF(Par_NumErr!= Entero_Cero) THEN
								SET Par_ErrMen := CONCAT(Par_ErrMen);
								LEAVE ManejoErrores;
							END IF;
					END IF;
				END IF;
			END IF;

			CALL REESTRUCCREDITOACT (
				FechSistema,        Par_CreditoID,      Res_SaldoCredAnteri,    Res_EstatusCredAnt, Res_EstatusCrea,
				Res_NumDiasAtraOri, Res_NumPagoSos,     Entero_Cero,            Entero_Cero,        Act_Desembolso,
				Salida_NO,          Par_NumErr,         Par_ErrMen,             Aud_EmpresaID,      Cadena_Vacia,
				Aud_Usuario, 		Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion  );

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Actualizamos la Estimacion por los Intereses a Capitalizar
			UPDATE REESTRUCCREDITO SET
				ReservaInteres  = Var_SalInteres,
				SaldoInteres    = Var_SalInteres
			WHERE CreditoDestinoID    = Par_CreditoID;

			IF(Var_SalInteres > Entero_Cero) THEN
				-- Abono Estimacion Balance
				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
					Var_FechaApl,       Var_SalInteres,     Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,		Des_Reserva,        Var_CuentaAhoStr,   AltaPoliza_NO,
					Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalance,
					Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,		Nat_Abono,
					Con_Origen, 		/*Salida_NO,*/		Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Aud_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


				-- Cargo Estimacion Resultados (Gasto)
				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
					Var_FechaApl,       Var_SalInteres,     Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,		Des_Reserva,        Var_CuentaAhoStr,   AltaPoliza_NO,
					Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstResultados,
					Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,		Nat_Cargo,
					Con_Origen, 		/*Salida_NO,*/		Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Aud_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			CALL REENOVACCREDITOACT (
				FechSistema,        Par_CreditoID,      Var_SaldoCredAnt,      Cadena_Vacia, 		Cadena_Vacia,
				Entero_Cero	,		Entero_Cero,        Entero_Cero,             Entero_Cero,        Act_Desembolso,
				Salida_NO,          Par_NumErr,         Par_ErrMen,             Aud_EmpresaID,      Cadena_Vacia,
				Aud_Usuario, 		Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,
				Aud_NumTransaccion  );

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF; -- END de la Renovacion de credito

		# ===================================================================================================================
		# ===================================================================================================================
		# =================================== FIN DE CONSIDERACIONES PARA DESEMBOLSO DE CREDITO RENOVACION =========================
		SET Aud_FechaActual := NOW();

		IF( Var_EsConsolidacionAgro = Con_SI AND Par_NumeroMinistracion = Entero_Uno ) THEN

			-- Store Procedure Para consolidar un credito Agro y asigna el estatus con el que nace el credito
			CALL REGCRECONSOLIDADOSALT (
				Par_CreditoID,		Par_PolizaID,
				Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT EstatusCreacion
			INTO Var_EstConsolidacion
			FROM  REGCRECONSOLIDADOS
			WHERE CreditoID	= Par_CreditoID;

			SET Res_EstatusCrea := IFNULL(Var_EstConsolidacion, EstatusVigente);
			SET Var_EstatusCre 	:= IFNULL(Var_EstConsolidacion, EstatusVigente);

		END IF;

		-- Actualizamos el Credito
		IF ((Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura) AND  Res_EstatusCrea = EstatusVencido) THEN
			UPDATE CREDITOS SET
				Estatus			= EstatusVencido,
				NumAmortizacion	= Var_NumAmorti,
				FechaMinistrado	= FechSistema,
				MontoPorDesemb 	= Var_MontoADesem,
				ComAperPagado  	= ComAperPagado +  Var_MontoComAp,
				SeguroVidaPagado	= SeguroVidaPagado + Var_MontoSegVida,

				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion

			WHERE CreditoID	= Par_CreditoID;
		ELSE
			UPDATE CREDITOS SET
				Estatus				= CASE WHEN Var_EsConsolidacionAgro = Con_SI THEN Var_EstConsolidacion
										   ELSE EstatusVigente
									  END,
				NumAmortizacion		= Var_NumAmorti,
				FechaMinistrado		= FechSistema,
				MontoPorDesemb		= Var_MontoADesem,
				ComAperPagado		= ComAperPagado +  Var_MontoComAp,
				SeguroVidaPagado	= SeguroVidaPagado + Var_MontoSegVida,

				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE CreditoID	= Par_CreditoID;
		END IF;

		SET Var_CuentaAhoStr := CONVERT(Var_CuentaAhoID, CHAR);



		/*SE CREAN LAS AMORTIZACIONES DE CREDITOS YA QUE NO EXISTEN =======================================================*/
		OPEN CURSORAMORTIAGRO;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
				FETCH CURSORAMORTIAGRO INTO
					Var_CreditoIDAgro,		Var_AmortizacionIDAgro,		Var_NumTransaccionAgro,		Var_MontoPendDesembolsoAgro;

					IF(Var_MontoMinistrado <= Entero_Cero) THEN
						LEAVE CICLO;
					END IF;

					IF(Par_AmortizacionIni IS NULL) THEN
						SET Par_AmortizacionIni := Var_AmortizacionIDAgro;
					END IF;
					SET Par_AmortizacionFin := Var_AmortizacionIDAgro;

					# Se valida el monto a desembolsar
					IF(Var_MontoMinistrado > Var_MontoPendDesembolsoAgro) THEN
						SET Var_MontoMinistrado 		:= Var_MontoMinistrado - Var_MontoPendDesembolsoAgro;
						SET Var_MontoPendAmortAnterior	:= Entero_Cero;
						SET Var_EstatusDesembolso		:= EstatusDesembolsada;
					 ELSE
						/*PARA ESTE CASO EL RESTO PENDIENTE DE DESEMBOLSO PASA A SER CAPITAL DE LA SIGUIENTE AMORTIZACION*/
						SET Var_MontoPendAmortAnterior	:= Var_MontoPendDesembolsoAgro - Var_MontoMinistrado;
						SET Var_MontoPendDesembolsoAgro	:= Var_MontoMinistrado;
						SET Var_MontoMinistrado			:= Entero_Cero;
						SET Var_EstatusDesembolso		:= 'N';
					END IF;

					SET Var_MontoMinistradoAgro := Var_MontoMinistradoAgro - Var_MontoPendDesembolsoAgro;

					/*Si la amortizacion aun no existe la actualizo, si no es asi se realiza update*/
					IF NOT EXISTS(SELECT AmortizacionID FROM AMORTICREDITO
									WHERE CreditoID = Par_CreditoID
									AND AmortizacionID = Var_AmortizacionIDAgro) THEN
						INSERT INTO AMORTICREDITO(
							AmortizacionID,		CreditoID,				ClienteID,				CuentaID,				FechaInicio,
							FechaVencim,		FechaExigible,			Estatus,				FechaLiquida,			Capital,
							Interes,			IVAInteres,				SaldoCapVigente,		SaldoCapAtrasa,			SaldoCapVencido,
							SaldoCapVenNExi,	SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresVen,		SaldoInteresPro,
							SaldoIntNoConta,	SaldoIVAInteres,		SaldoMoratorios,		SaldoIVAMorato,			SaldoComFaltaPa,
							SaldoIVAComFalP,	SaldoOtrasComis,		SaldoIVAComisi,			ProvisionAcum,			SaldoCapital,
							SaldoMoraVencido,	SaldoMoraCarVen,		MontoSeguroCuota,		IVASeguroCuota,			SaldoSeguroCuota,
							SaldoIVASeguroCuota,SaldoComisionAnual,		SaldoComServGar,		SaldoIVAComSerGar,
							EmpresaID,			Usuario,				FechaActual,			DireccionIP,			ProgramaID,
							Sucursal,			NumTransaccion)
						SELECT
							AmortizacionID,					CreditoID,				ClienteID,				CuentaID,							FechaInicio,
							FechaVencim,					FechaExigible,			IF(Estatus = Estatus_Inactivo,EstatusVigente,Estatus),		FechaLiquida,
							Var_MontoPendDesembolsoAgro,	Interes,				IVAInteres,				SaldoCapVigente,					SaldoCapAtrasa,
							SaldoCapVencido,				SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,					SaldoInteresVen,
							SaldoInteresPro,				Entero_Cero,			SaldoIVAInteres,		SaldoMoratorios,					SaldoIVAMorato,
							SaldoComFaltaPa,				SaldoIVAComFalP,		SaldoOtrasComis,		SaldoIVAComisi,						ProvisionAcum,
							SaldoCapital,					SaldoMoraVencido,		SaldoMoraCarVen,		MontoSeguroCuota,					IVASeguroCuota,
							SaldoSeguroCuota,				SaldoIVASeguroCuota,	SaldoComisionAnual,		Entero_Cero,						Entero_Cero,
							Aud_EmpresaID,					Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,					Aud_ProgramaID,
							Aud_Sucursal,					Aud_NumTransaccion
						FROM AMORTICREDITOAGRO
						WHERE CreditoID = Var_CreditoIDAgro
						  AND AmortizacionID = Var_AmortizacionIDAgro;

						-- Calculo la seguna hacia a delante
						-- valido el monto
					ELSE
						UPDATE AMORTICREDITO SET
							Capital = Capital + Var_MontoPendDesembolsoAgro
							WHERE
							CreditoID = Var_CreditoIDAgro
							AND AmortizacionID = Var_AmortizacionIDAgro;

                        # Se calculan los moratorios por la diferencia del capital pendiente por ministrar
                        IF(Var_EstatusAmortizacion = EstatusAtrasado)THEN
							CALL GENERAINTERMORAAGROPRO(
								FechSistema,		Var_CreditoIDAgro,	Var_MontoPendDesembolsoAgro,	Aud_EmpresaID,		Aud_Usuario,
                                Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,					Aud_Sucursal,		Aud_NumTransaccion	);

                        END IF;
					END IF;

					UPDATE AMORTICREDITOAGRO SET
						MontoPendDesembolso = Var_MontoPendAmortAnterior,
						TipoCalculoInteres = Par_TipoCalculoInteres,
						EstatusDesembolso = Var_EstatusDesembolso,
						TmpMontoDesembolso = Var_MontoPendDesembolsoAgro
						WHERE
							CreditoID = Var_CreditoIDAgro
							AND AmortizacionID = Var_AmortizacionIDAgro;

				END LOOP CICLO;
			END;
		CLOSE CURSORAMORTIAGRO;

		/*FIN DE CREACION DE LAS AMORTIZACIONES DE CREDITOS YA QUE NO EXISTEN =============================================*/
		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		SET Var_CuentaAhoStr := CONVERT(Var_CuentaAhoID, CHAR);

		-- Si la Institucion Maneja el Concepto de Cuentas de Ahorro
		IF(Var_ManCapta = ManCaptacionSi) THEN
			-- Verificamos si el credito es Reestructura o Renovacion y  nace como Vencido
			IF((Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura OR Var_EsConsolidacionAgro = Con_SI) AND
				Res_EstatusCrea = EstatusVencido) THEN
				SET Tipo_MovConta   := Con_ContCapVNE;
			ELSE
				SET Tipo_MovConta   := Con_ContCapCre;
			END IF;

			/* Movimientos del Desembolso del credito*/
			SET Var_Descripcion		:= 'DESEMBOLSO DE CREDITO';
			-- Movimientos del Desembolso del credito
			CALL  CONTACREDITOPRO (
				Par_CreditoID,					Entero_Cero,				Var_CuentaAhoID,			Var_ClienteID,			Var_FechaOper,
				Var_FechaApl,					MontoCred,					Var_MonedaID,				Var_ProdCreID,			Var_ClasifCre,
				Var_SubClasifID,				Var_SucCliente,				Var_Descripcion,			Var_CuentaAhoStr,		AltaPoliza_NO,
				Con_ContDesem,					Par_PolizaID,				AltaPolCre_SI,				AltaMovCre_NO,			Tipo_MovConta,
				Entero_Cero,					Nat_Cargo,					AltaMovAho_SI,				Tip_MovAhoDesem,		Nat_Abono,
				Con_Origen, 					/*Salida_NO,*/				Par_NumErr,					Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,					Cadena_Vacia,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EsConsolidacionAgro = Con_SI  AND
				Par_NumeroMinistracion = Entero_Uno ) THEN
				CALL CONSOLIDACIONAGROPRO(
					Par_CreditoID,		Var_CuentaAhoID,	Par_PolizaID,
					Salida_NO,			Par_NumErr,			Par_ErrMen,
					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;


			-- Formas de cobro de comisión para lineas de credito agro.
			-- Las comisiones cargadas sobre la o las disposiciones en una línea de crédito seran cobradas al cliente al momento del desembolso, de acuerdo a la forma elegida al momento del alta
			-- de la solicitud y alta del crédito (Campo Forma Cobro de la sección de línea de crédito)
			IF( Var_LineaCreditoID > Entero_Cero ) THEN

				CALL CONTACOMLINCREDAGROPRO(
					Par_CreditoID,			Var_SoliciCredID,	Con_NO,			Par_PolizaID,			Con_Origen,
					Par_NumeroMinistracion,
					Salida_NO,				Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_Consecutivo = Entero_Uno) THEN

				-- Movimientos de Comision por Apertura
				IF(Var_MontoComAp != Entero_Cero) THEN
					CALL  CONTACREDITOPRO (
						Par_CreditoID,			Entero_Cero,				Var_CuentaAhoID,			Var_ClienteID,			Var_FechaOper,
						Var_FechaApl,			Var_MontoComAp,				Var_MonedaID,				Var_ProdCreID,			Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,			Var_CuentaAhoStr,		AltaPoliza_NO,
						Con_ContDesem,			Par_PolizaID,				AltaPolCre_SI,				AltaMovCre_NO,			Con_ContGastos,
						Entero_Cero,			Nat_Abono,					AltaMovAho_SI,				Tip_MovAhoComAp,		Nat_Cargo,
						Con_Origen, 			/*Salida_NO,*/				Par_NumErr,					Par_ErrMen,				Par_Consecutivo,
						Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

				IF(Var_PagIVA = SiPagaIVA) THEN
					IF(Var_IVAComAp != Entero_Cero) THEN
						-- movimientos de IVA  de comision por apertura
						CALL  CONTACREDITOPRO (
							Par_CreditoID,		Entero_Cero,				Var_CuentaAhoID,			Var_ClienteID,			Var_FechaOper,
							Var_FechaApl,		Var_IVAComAp,				Var_MonedaID,				Var_ProdCreID,			Var_ClasifCre,
							Var_SubClasifID,	Var_SucCliente,				Var_DcIVAComApe,			Var_CuentaAhoStr,		AltaPoliza_NO,
							Con_ContDesem,		Par_PolizaID,				AltaPolCre_SI,				AltaMovCre_NO,			Con_ContIVACApe,
							Entero_Cero,		Nat_Abono,					AltaMovAho_SI,				Tip_MovIVAAhCAp,		Nat_Cargo,
							Con_Origen, 		/*Salida_NO,*/				Par_NumErr,					Par_ErrMen,				Par_Consecutivo,
							Aud_EmpresaID,		Cadena_Vacia,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

					END IF;
				END IF; -- EndIf del Manejo de IVA

				-- Contabilidad y Movimientos del Cobro del Seguro de Vida
				IF(Var_MontoSegVida != Entero_Cero) THEN
					CALL  CONTACREDITOSPRO (
						Par_CreditoID,			Entero_Cero,				Var_CuentaAhoID,			Var_ClienteID,			Var_FechaOper,
						Var_FechaApl,			Var_MontoSegVida,			Var_MonedaID,				Var_ProdCreID,			Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,				Var_DescSegVida,			Var_CuentaAhoStr,		AltaPoliza_NO,
						Con_ContDesem,			Par_PolizaID,				AltaPolCre_SI,				AltaMovCre_NO,			Con_PagoSegVida,
						Entero_Cero,			Nat_Abono,					AltaMovAho_SI,				Tip_MovAhoSegVid,		Nat_Cargo,
						Con_Origen, 			/*Salida_NO,*/				Par_NumErr,					Par_ErrMen,				Par_Consecutivo,
						Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					-- Actualizamos el Seguro de Vida como Pagado
					CALL  SEGUROVIDAACT (
						Entero_Cero,			Par_CreditoID,					Var_CuentaAhoID,			Act_SegVigente,		Salida_NO,
						Par_NumErr,				Par_ErrMen,						Aud_EmpresaID,				Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,				Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;
			END IF;

			-- Para Hacer la Dispersion revisamos primero que no sea un Credito Reestructura o Renovacion
			-- Ya que si es una Reestructura o renovacion el monto del Credito sera utilizado para Liquidar el Anterior
			IF( Var_TipoCredito = CreNuevo AND Var_EsConsolidacionAgro = Con_NO AND
				((Var_TipoDisper = DispersionSPEI) OR (Var_TipoDisper = DispersionCheque) OR (Var_TipoDisper = DispersionOrden))) THEN

				IF (Var_TipoDisper  = DispersionSPEI) THEN
					SET DescripBloqueo := DescripBloqSPEI;
				END IF;

				IF (Var_TipoDisper  = DispersionCheque) THEN
					SET DescripBloqueo := DescripBloqCheq;
				END IF;

				IF (Var_TipoDisper  = DispersionOrden) THEN
					SET DescripBloqueo := DescripBloqOrden;
				END IF;


				SET Var_MontoBloqueo := MontoCred - (Var_MontoComAp + Var_IVAComAp) - Var_MontoSegVida;

				CALL BLOQUEOSPRO(
					Entero_Cero,				NatMovBloqueo,					Var_CuentaAhoID,			FechSistema,		Var_MontoBloqueo,
					Fecha_Vacia,				TipoBloqueo,					DescripBloqueo,				Par_CreditoID,		Cadena_Vacia,
					Cadena_Vacia,				Salida_NO,						Par_NumErr,					Par_ErrMen,			Aud_EmpresaID,
					Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			END IF; -- Endif del Tipo de Dispersion

		END IF;  -- END del IF si maneja Captacion la institucion

		# CURSOR para registrar el saldo de capital de las amortizaciones en capital vigente o en vencido no exigible
		OPEN CURSORAMORTI;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
				FETCH CURSORAMORTI INTO
					Var_CreditoID,	Var_AmortizID,	Aud_NumTransaccion,	Var_Cantidad,	Var_EstatusAmor;

					-- Verificamos si el credito es Reestructura y  nace como Vencido
					IF ((Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura) AND Res_EstatusCrea = EstatusVencido) THEN
						SET Var_TipoMovCred   := Mov_CapVeNoExi;
					ELSE
						IF(Var_EstatusCre = EstatusAtrasado) THEN
							SET Var_TipoMovCred   := Mov_CapVigente;
						END IF;

						IF(Var_EstatusCre = EstatusVigente AND Var_EstatusAmor = EstatusVigente ) THEN
							SET Var_TipoMovCred   := Mov_CapVigente;
						END IF;

						IF(Var_EstatusCre = EstatusVencido AND Var_EstatusAmor = EstatusVigente) THEN
							SET Var_TipoMovCred   := Mov_CapVeNoExi;
						END IF;

						IF(Var_EstatusCre = EstatusVigente AND Var_EstatusAmor = EstatusAtrasado) THEN
							SET Var_TipoMovCred   := Mov_CapAtrasado;
						END IF;

						IF(Var_EstatusAmor = EstatusVencido) THEN
							SET Var_TipoMovCred   := Mov_CapVencido;
						END IF;

					END IF;


					CALL CREDITOSMOVSALT (
						Var_CreditoID,			Var_AmortizID,		Aud_NumTransaccion,			Var_FechaOper,		Var_FechaApl,
						Var_TipoMovCred,		Nat_Cargo,			Var_MonedaID,				Var_Cantidad,		Var_Descripcion,
						Var_CuentaAhoStr,		Par_PolizaID,		Con_Origen,					Par_NumErr,			Par_ErrMen,
						Par_Consecutivo,		Cadena_Vacia,		Aud_EmpresaID,				Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);

                    IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

					UPDATE AMORTICREDITOAGRO SET
					TmpMontoDesembolso = 0
					WHERE
						CreditoID = Var_CreditoID
						AND AmortizacionID = Var_AmortizID;

				END LOOP;
			END;
		CLOSE CURSORAMORTI;


		# Se recalculan los intereses
		CALL AMORTICREDITOAGROACT(
			Par_CreditoID,		Act_TipoActInteres,		Par_TipoCalculoInteres,	Salida_NO,			Par_NumErr,
            Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		-- si se trata de un calendario con pagos libres, se eliminan las amortizaciones
		IF(Var_TipPagCapita = Pag_Libres AND Par_Consecutivo = Entero_Uno) THEN
			CALL TMPPAGAMORSIMBAJ(
				NTranSim,				Salida_NO,				Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_NumAmorti := (SELECT COUNT(*) FROM AMORTICREDITO WHERE	CreditoID	= Par_CreditoID);

		-- Actualizamos el Credito
		UPDATE CREDITOS SET
			NumAmortizacion		= Var_NumAmorti
		WHERE CreditoID	= Par_CreditoID;

		IF(Par_NumeroMinistracion = Entero_Uno) THEN
			-- Actualizamos la Solicitud de Credito
			UPDATE SOLICITUDCREDITO SET
				CreditoID					= Var_CreditoID,
				Estatus						= EstatusDesemb,
				FechaFormalizacion			= FechSistema,

				Usuario						= Aud_Usuario,
				FechaActual					= Aud_FechaActual,
				DireccionIP					= Aud_DireccionIP,
				ProgramaID 					= Aud_ProgramaID,
				Sucursal					= Aud_Sucursal,
				NumTransaccion				= Aud_NumTransaccion
			WHERE SolicitudCreditoID		= Var_SoliciCredID;



			-- Si es Reestructura o Renovacion Hacemos la Liquidacion del Credito Anterior
			IF (Var_TipoCredito = CreRenovacion OR Var_TipoCredito = CreReestructura) THEN
				IF(Var_TipoLiquidacion = LiquidacionTotal) THEN
					  SET  Var_MontoPago := Res_SaldoCredAnteri;
	            ELSE
					SET Var_MontoPago := Var_CantidadPagar;
	            END IF;

				SET Var_PagoAplica  := Entero_Cero;
				SET Par_Consecutivo := Entero_Cero;

				CALL PAGOCREDITOPRO(
					Var_Relacionado,    Var_CuentaAhoID,    Var_MontoPago,  	Var_MonedaID,       PrePago_NO,
					Finiquito_SI,       Aud_EmpresaID,      Salida_NO,       	AltaPoliza_NO,		Var_PagoAplica,
					Par_PolizaID,       Str_NumErr,         Par_ErrMen,     	Par_Consecutivo,	Var_CargoCuenta,
					Con_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

				-- Se actualizan estos valores para que no permita hacer un desembolso fisico del dinero en ventanilla
				-- Ya que el monto del credito se utiliza para liquidar al que se le esta dando tratamiento
				UPDATE CREDITOS SET
					MontoDesemb		= MontoCred,
					MontoPorDesemb	= MontoCred - Var_MontoPago- (Var_MontoComAp + Var_IVAComAp) - Var_MontoSegVida
				WHERE CreditoID = Par_CreditoID;

				SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				IF (Var_PagoAplica <= Entero_Cero) THEN
					SET Par_NumErr	:= 301;
					SET Par_ErrMen	:= CONCAT('No se pudo Realizar el Pago del Credito: ', CONVERT(Var_Relacionado, CHAR),'.');
					LEAVE ManejoErrores;
				END IF;

				-- Consultamos el Credito Origen a Reestructurar o Renovar
				SELECT  Cre.Estatus INTO Var_RelaEstatus
					FROM CREDITOS Cre
					WHERE Cre.CreditoID = Var_Relacionado;

				SET Var_RelaEstatus := IFNULL(Var_RelaEstatus, Cadena_Vacia);
				IF (Var_TipoLiquidacion = LiquidacionTotal) THEN
					IF (Var_RelaEstatus != EstatusPagado) THEN
						SET Par_NumErr	:= 302;
						SET Par_ErrMen	:= CONCAT('El Credito: ', CONVERT(Var_Relacionado, CHAR), ', No fue Liquidado por Completo.');
						LEAVE ManejoErrores;
					END IF;
	            END IF;

	              -- Se cancelan todas las ministraciones pendientes.
				 UPDATE MINISTRACREDAGRO SET
							Estatus 			= EstatusCancelado,
							FechaMinistracion 	= Aud_FechaActual,
							UsuarioAutoriza 	= Aud_Usuario,
							FechaAutoriza 		= Aud_FechaActual,
							EmpresaID 			= Aud_EmpresaID,
							Usuario 			= Aud_Usuario,
							FechaActual 		= Aud_FechaActual,
							DireccionIP 		= Aud_DireccionIP,
							ProgramaID 			= Aud_ProgramaID,
							Sucursal 			= Aud_Sucursal,
							NumTransaccion 		= Aud_NumTransaccion
						WHERE CreditoID 		= Var_Relacionado
							AND Estatus 		 NOT IN(EstatusDesemb,EstatusCancelado);

			END IF; -- Endif del Pago de Credito cuando es Reestructura o Renovacion

			/*Se realiza respaldo del pagare(para este caso las amortizaciones creadas*/
			CALL PAGARECREDITOAGROALT(
				Par_CreditoID,		Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
			END IF;


			/* ********************************************
			* Se registra el Identificador CNBV para SOFIPOS
			*********************************************** */

			CALL GENERACREDIDCNBVPRO(
				Par_CreditoID,			Var_TipoProd,		Salida_NO,		Par_NumErr,			Par_ErrMen,
				Var_CreditoIDCNBV,		Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		/* *** Fin genera Iden CNBV ****** */
		UPDATE CREGARPRENHIPO
		SET CreditoID=Par_CreditoID
		WHERE SolicitudCreditoID=Var_SoliciCredID;

		/**VALIDAMOS QUE SI ES EL PRIMER DESEMBOLSO SE REALIZA LA CREACIÓN DEL CREDITO PASIVO**/
			/*Si el tipo de fondeo es por institucion entonces se crea el credito pasivo*/
		IF(Var_TipoFondeo = Tipo_InstitucionFondeo) THEN
			IF(Var_GrupoID > Entero_Cero) THEN
				SET Var_TipoOperaGrupo 		:= (SELECT TipoOperaAgro FROM GRUPOSCREDITO WHERE GrupoID = Var_GrupoID);
			END IF;

			SET Var_TipoOperaGrupo 			:= IFNULL(Var_TipoOperaGrupo, Cadena_Vacia);
			#Validamos de que no este dado de alta ya (Si es un grupal solo debe haber 1 pasivo)
			SET Var_CreditoFondeoID := (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO WHERE CreditoID = Par_CreditoID AND EstatusRelacion ='V' LIMIT 1);
			SET Var_CreditoFondeoID := IFNULL(Var_CreditoFondeoID, Entero_Cero);

			# Se da de alta de credito Pasivo
			IF(Par_NumeroMinistracion = Entero_Uno AND Var_CreditoFondeoID = Entero_Cero) THEN
				CALL CREDITOPASIVOAGROALT(
					Par_CreditoID,			Par_TipoCalculoInteres,			Var_TipoOperaGrupo,			Salida_NO,				Par_NumErr,
					Par_ErrMen,				Var_CreditoFondeoID,			Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,				Par_NumTransacionPasivo);

				IF(Par_NumErr!= Entero_Cero) THEN
					SET Par_ErrMen := CONCAT(Par_ErrMen);
					LEAVE ManejoErrores;
				END IF;

				SET Var_MensajeExitoPasivo := IFNULL(Par_ErrMen, Cadena_Vacia);# Este se debe concatenar al mensaje final
			END IF;

			SET Var_CreditoFondeoID := (SELECT CreditoFondeoID FROM RELCREDPASIVOAGRO
											WHERE CreditoID = Par_CreditoID AND EstatusRelacion = 'V');

			CALL MINISTRACREFONDAGROPRO(
				Var_CreditoFondeoID,			Par_CreditoID,			Par_NumeroMinistracion,		MontoCred,					Par_TipoCalculoInteres,
                Par_AmortizacionIni,			Par_AmortizacionFin,	Var_FechaOper,				Var_PolizaID,				Salida_NO,
                Par_NumErr,						Par_ErrMen,				Par_Consecutivo,			Aud_EmpresaID,				Aud_Usuario,
                Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,				Par_NumTransacionPasivo);

			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
		/**FIN VALIDACION QUE SI ES EL PRIMER DESEMBOLSO SE REALIZA LA CREACIÓN DEL CREDITO PASIVO**/
		SET Par_NumErr  := Entero_Cero;
		SET Var_MensajeExitoPasivo := IFNULL(Var_MensajeExitoPasivo, Cadena_Vacia);
		SET Par_ErrMen  := CONCAT('El Credito: ', CONVERT(Par_CreditoID, CHAR), ' Ha sido Desembolsado Exitosamente.', Var_MensajeExitoPasivo);

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID'	AS control,
				Par_CreditoID	AS consecutivo;
	END IF;

END TerminaStore$$