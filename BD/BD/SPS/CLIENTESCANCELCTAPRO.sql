-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESCANCELCTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESCANCELCTAPRO`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESCANCELCTAPRO`(
    /* Sp Para desbloquear saldos, generar intereses y  cobrar retencion
		en el proceso de cancelacion de socio, genera movimientos operativos y contables   */
    Par_ClienteID			INT(11),	-- Cliente ID
	Par_ClienteCancelaID	INT(11),	-- Folio de solicitud de cancelacion
	Par_Fecha				DATE,
	Par_AltaEncPoliza		CHAR(1), 	-- S= Alta encabezado de la poliza; N = no da de alta encabezado
	Par_ConceptoCon			INT,		-- Conceto contable, requerido solo si Par_AltaEncPoliza=S, tabla: CONCEPTOSCONTA

    Par_MotivoActivaID		INT(11),	-- Motivo por el cual se esta inactivando el registro
    Par_Comentarios			VARCHAR(500), -- motivo por el cual se esta cancelando al socio
	Par_DesbloqSaldos		CHAR(1),	-- Seccion de desbloqueos de saldo  SI = S NO = N
	Par_GenIntISRAho		CHAR(1),	-- Seccion generacion de intereses y cobro de impuesto retenido en cuentas de ahorro SI = S NO = N
	Par_MoverSaldoCuentas	CHAR(1),	-- Seccion mover saldos de las cuentas de ahorro del cliente a  una cuenta contable SI = S NO = N

	Par_CancelarCuenta		CHAR(1),	-- Seccion cancelar todas las cuentas del cliente  SI = S NO = N
	Par_AportSocial			CHAR(1),	-- Seccion para pagar la aportacion social y ponerla en una cuenta contable  SI = S NO = N
	Par_CobroPROFUN			CHAR(1),	-- Seccion para Cobrar las mutuales SI = S NO = N
	Par_CancelaPROFUN		CHAR(1),	-- Seccion para cancelar el registro PROFUN  S = SI  N = NO
	Par_InactivaCte			CHAR(1),	-- Seccion para inactivar al cliente SI = S NO = N
	Par_VencimInver			CHAR(1),	-- Seccion para realizar el vencimiento anticipado de inversiones SI = S NO = N

	Par_FiniquitoCre		CHAR(1),	-- Seccion para realizar el finiquito de los creditos con cargo a su cuenta de ahorro del cliente SI = S NO = N
	Par_PagoCreProtec		CHAR(1),	-- Seccion para realizar el pago de credito por protecciones SI = S NO = N
    Par_Salida				CHAR(1),
    INOUT	Par_NumErr 		INT,		-- parametros de control de errores
    INOUT	Par_ErrMen  	VARCHAR(350),-- parametros de control de errores

	INOUT Par_Poliza		BIGINT,			-- devuelve o recibe el numero de poliza usado o generado
	/* paramtros de auditoria */
    Par_EmpresaID			INT,
    Aud_Usuario         	INT,
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),

    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
    Aud_NumTransaccion  	BIGINT
			)
TerminaStore: BEGIN

	/*DECLARACION DE VARIABLES*/
	DECLARE VarMontoCobPROFUN	DECIMAL(14,2);	-- almacena el monto pendiente cobrado de profun
	DECLARE VarCuentaAhoID		BIGINT(12);		-- numero de la cuenta
	DECLARE VarCreditoID		BIGINT(12);		-- variable para los creditos
	DECLARE VarInversionID		INT(11);		-- variable para las inversiones
	DECLARE VarPlazo			INT(11);		-- plazo
	DECLARE VarControl			VARCHAR(100);	-- almacena el elemento que es incorrecto
	DECLARE	VarBloqueoID		INT;			-- variable para las cuentas blouqeadas
	DECLARE	VarNumBloqueos		INT;			-- variable para el numero de bloqueos
	DECLARE	VarMontoBloq		DECIMAL(12,2);	-- variable para el monto bloqueado
	DECLARE VarDescripDes		VARCHAR(50);	-- Descripcion del desbloqueo
	DECLARE DiasMes				INT;			-- Se utiliza para obtener el saldo promedio
	DECLARE Fre_DiasAnio		INT;			-- Variable para los dias del anio
	DECLARE Var_SalMinDF		DECIMAL(12,2);	-- Salario minimo segun el df
	DECLARE Var_SalMinAn		DECIMAL(12,2);	-- Salario minimo anualizado segun el df
	DECLARE VarSucursalOrigen	INT(11);		-- sucrusal del cliente
	DECLARE Var_MonedaBase		INT(11);		-- moneda base para operaciones
	DECLARE VarTipoPersona		CHAR(1);		-- tipo de personas
	DECLARE Var_AplicaSeguro	CHAR(1);		-- si tiene seguro
	DECLARE VarMonedaID			INT(11);		-- tipo de moneda del cliente
	DECLARE VarTipoCuentaID		INT(11);		-- tipo de cuenta
	DECLARE Var_DiasTrascurrido	INT(11);		-- dias trasncurridos de inversion
	DECLARE Var_DiasInversion	INT(11);		-- dias de inversion
	DECLARE Var_Moneda			INT(11);		-- moneda
	DECLARE Mov_IVAInteres		INT;			-- movimientos de interes
	DECLARE Mov_IVAIntMora		INT;			-- movimientos de ineterees moratorios
	DECLARE Mov_IVAComFaPag		INT;			-- movimientos de iva con falta de pago
	DECLARE Var_UltimaAmor		INT;			-- ultimo dia de amortizacion
	DECLARE Var_IntRetener		DECIMAL(14,2);	-- variable de intereses a retener
	DECLARE VarMontoInv			DECIMAL(14,2);	-- monto de la inverszion
	DECLARE VarSaldoDispon		DECIMAL(14,2);	-- saldo disponoble
	DECLARE VarSaldoProvision	DECIMAL(14,2);	-- variable saldo provision
	DECLARE VarSaldoIniMes		DECIMAL(14,2);	-- variable saldo inicial del mes
	DECLARE VarSaldoProm		DECIMAL(14,2);	-- variable saldo promedio
	DECLARE VarSaldo			DECIMAL(14,2);	-- variable saldo
	DECLARE VarTasaInv			DECIMAL(12,2);	-- variabla tasa de inversion
	DECLARE VarTasaInteres		DECIMAL(14,2);	-- variable tasa de interes
	DECLARE VarInteresesGen		DECIMAL(14,2);	-- variable intereses generados
	DECLARE VarISR				DECIMAL(14,2);	-- variable isr
	DECLARE VarTasaISR			DECIMAL(14,2);	-- tasa isr
	DECLARE Var_AportSocial		DECIMAL(14,2);	-- aportacion social
	DECLARE VarTotalAdeudo		DECIMAL(14,2);	-- total de adeudo
	DECLARE VarTotalAdeudoIva	DECIMAL(14,2);	-- total de adeudo mas iva
	DECLARE VarExigible			DECIMAL(14,2);	--  exigible
	DECLARE VarPendientePag		DECIMAL(14,2);	-- pendiente de pago
	DECLARE Var_MontoPago		DECIMAL(14,2);	-- monto de pago
	DECLARE Var_MontoIVAInt		DECIMAL(12, 2); -- monto de inva intereses
	DECLARE Var_MontoIVAIntPer	DECIMAL(12, 2); -- monto iva interes
	DECLARE Var_MontoIVAMora	DECIMAL(12, 2);	-- monto iva moratorios
	DECLARE Var_MontoIVAMoraPer	DECIMAL(12, 2);	-- monto iva moratorios
	DECLARE Var_MontoIVAComi	DECIMAL(12, 2); -- monto iva comision
	DECLARE Var_MontoIVAComiPer	DECIMAL(12, 2); -- monto iva comision
	DECLARE Var_MontoProCred	DECIMAL(14,2);	-- monto
	DECLARE VarGeneraInteres	CHAR(1);		-- si genera intereses
	DECLARE VarTipoInteres		CHAR(1);		-- tipo de intereses
	DECLARE VarPagaISR			CHAR(1);		-- si paga isr
	DECLARE Mov_AhorroNO		CHAR(1);		-- movimiento de ahorro no
	DECLARE Ope_Interna			CHAR(1);		-- operacion interna
	DECLARE Tip_Compra          CHAR(1);		-- tipo de
	DECLARE Var_ClasifCre		CHAR(1);		-- clasificacion de credito
	DECLARE Var_ConcepPago		VARCHAR(4);		-- Concepto de Pago
	DECLARE Var_DescripcCon		VARCHAR(45); 	-- descripcion de pago
	DECLARE Var_ConRendGra		VARCHAR(45); 	-- con reendimiento gravado
	DECLARE Var_ConRendExc		VARCHAR(45); 	-- con rendimiento execento
	DECLARE Var_ConRetISR		VARCHAR(150); 	-- con setencion ISR
	DECLARE Var_CuentaConta		VARCHAR(50); 	-- cuenta contable
	DECLARE Var_CtaContaExHab	VARCHAR(50); 	-- cuenta contable
	DECLARE Var_CtaConProCta	VARCHAR(50); 	-- cuenta contable con procedencia de cuenta
	DECLARE Var_CtaConProCre	VARCHAR(50); 	-- cuenta contable con procedencia de credito
	DECLARE Var_CtaPerdida		VARCHAR(50); 	-- cuenta perdida
	DECLARE Var_CCHaberesEx		VARCHAR(30); 	-- cuenta perdida
	DECLARE Var_CCContaPerdida	VARCHAR(30); 	-- cuenta operdida
	DECLARE Var_CCProtecAhorro	VARCHAR(30); 	-- cuenta ahorro
	DECLARE Var_CentroCostos	VARCHAR(30); 	-- centro de costos
	DECLARE Var_CuentaStr		VARCHAR(15);	-- cuenta
	DECLARE Var_TipCamCom       DECIMAL(8,4);	-- tipo de cambio
	DECLARE Var_IntRetMN		DECIMAL(12,2);	-- intereses a retener moneda nacioal
	DECLARE Var_MontoPendiente	DECIMAL(12,2);	-- Monto Pendiente de pago
	DECLARE VarTotalDeudaCre	DECIMAL(14,2);	-- almacena la suma de los deudos que tenga el cliente
	DECLARE VarSaldoTotalCue	DECIMAL(14,2);	-- almacena la suma del saldo total de las cuentas del cliente
	DECLARE Var_ClienteIDProtec	INT(11);		-- cliente id
	DECLARE Par_Consecutivo		INT(11);		-- consecutivo
	DECLARE Var_ProductoCreID	INT(4);			-- producto credito id
	DECLARE Var_FechaSis		DATE;			-- fecha sistema
	DECLARE Var_APortaSocID     VARCHAR(50);	-- aportacion social ID
	DECLARE Var_Cancelacion     VARCHAR(50);	-- cancelacion
	DECLARE Var_ISR_pSocio		CHAR(1);		-- Variable que guarda si esta activa la opcion de calculo por socio
	DECLARE Var_FechaISR		DATE;	-- variable fecha de inicio cobro isr por socio
	DECLARE Var_ValorUMA		DECIMAL(12,4);
    DECLARE Var_TipoPersona		CHAR(1);
    /*DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia		CHAR(1);		-- cadena vacia
	DECLARE	Entero_Cero			INT;			-- constante cero
	DECLARE	Entero_Cien			INT;			-- constante cien
	DECLARE	Decimal_Cero		DECIMAL(14,2);	-- constante DECIMAL cero
	DECLARE Factor_Porcen		DECIMAL(12,2);	-- factor porcentaje
	DECLARE	Salida_SI       	CHAR(1);		-- salida si
	DECLARE	Salida_NO       	CHAR(1);		-- salida no
	DECLARE	Est_Autorizado		CHAR(1);		-- Estatus Autorizado de la cuenta de ahorro
	DECLARE	Nat_Abono			CHAR(1);		-- Naturaleza de Abono
	DECLARE	Nat_Cargo			CHAR(1);		-- Naturaleza de Cargo
	DECLARE	Nat_Bloqueo			CHAR(1); 		-- Naturaleza de Bloqueo
	DECLARE	Nat_Desbloqueo		CHAR(1);		-- Naturaleza de Bloqueo
	DECLARE	SI_PagaISR			CHAR(1);		-- SI PAGA ISR
	DECLARE	Var_Si				CHAR(1);		-- constante con valor S
	DECLARE	Var_NO				CHAR(1);		-- constante con valor N
	DECLARE	AltaDetPolSI		CHAR(1);		-- Alta en detalle de poliza Si
	DECLARE	AltaEncPolizaSI		CHAR(1);		-- Alta en encabezado  de poliza Si
	DECLARE	AltaEncPolizaNO		CHAR(1);		-- Alta en encabezado de poliza No
	DECLARE	Est_Cancelada		CHAR(1);		-- Estatus Cancelado en cuentas de ahorro
	DECLARE	Est_Inactivo		CHAR(1);		-- Estatus Inactivo del cliente
	DECLARE	Est_VigenteInv		CHAR(1);		-- Estatus Vigente de la inversion
	DECLARE	Est_Vigente			CHAR(1);		-- Estatus Vigente de la inversion
	DECLARE	Est_Vencido			CHAR(1);		-- Estatus Vigente de la inversion
	DECLARE AltPoliza_NO        CHAR(1);		-- alta de poliza no
	DECLARE FiniquitoSI	        CHAR(1);		-- finiquitos si
	DECLARE FiniquitoNo	        CHAR(1);		-- finiquitos no
	DECLARE EsPrePagoSi	        CHAR(1);		-- si es prepago
	DECLARE EsPrePagoNo	        CHAR(1);		-- no es prepago
	DECLARE NO_CobraLiqAnt      CHAR(1);		-- cobra liquidacion anticipada
	DECLARE SI_PagaIva			CHAR(1);		-- si paga iva
	DECLARE NO_PagaIva			CHAR(1);		-- no paga iva
	DECLARE AltaMovAho_SI		CHAR(1);		-- alta de movimiento ahorro
	DECLARE AltaMovCre_SI		CHAR(1);		-- alta movimiento credito
	DECLARE AltaPolCre_SI		CHAR(1);		-- alta poliza de credito si
	DECLARE AltaPolCre_NO		CHAR(1);		-- alta poliza de credito no
	DECLARE AltaMovAho_NO		CHAR(1);		-- alta de movimiento ahorro no
	DECLARE Con_IVAInteres		INT;			-- con iva intereses
	DECLARE Con_IVAMora			INT;			-- con iva a moratorios
	DECLARE Con_IVAFalPag		INT;			-- con falra de pago
	DECLARE Tipo_Provision		CHAR(4);		-- tipo de provision
	DECLARE Blo_CancelSoc		INT;			-- tipo de bloqueo para cancelacion de socio
	DECLARE Var_TiposBloqID		INT(11);		-- bloque de cancelacion de socio
	DECLARE Var_MovRendGra		VARCHAR(4);		-- Tipo de movimiento de ahorro de Pago de Rendimiento Cta.Gravado - TIPOSMOVSAHO
	DECLARE Var_MovRendExc		VARCHAR(4);		-- Tipo de movimiento de ahorro de Pago de Rendimiento Cta.Excento - TIPOSMOVSAHO
	DECLARE Var_MovRetISR		VARCHAR(4); 	-- Tipo de movimiento de ahorro de Retencion ISR Cta - TIPOSMOVSAHO
	DECLARE Var_MovCancel		VARCHAR(4); 	-- Tipo de movimiento de ahorro por Cancelacion de socio - TIPOSMOVSAHO
	DECLARE Mov_PagInvrAnti		VARCHAR(4);		-- Movimiento de vencimiento anticipado de inversion
	DECLARE Mov_PagInvRet		VARCHAR(4);		-- movimientos de pago interes retenido
	DECLARE Mov_PagIntExe       VARCHAR(4);		-- movimiento pago interes exento
	DECLARE Mov_PagIntGra		VARCHAR(4);		-- movimiento pago interes grabado
	DECLARE Var_RefPagoAnti		VARCHAR(100);	-- pago eefernciado anticipado
	DECLARE Var_ProgramaID      VARCHAR(50);	-- programa id
	DECLARE Cue_RetInver        VARCHAR(100);	-- cuenta reinversion
	DECLARE Cue_PagIntere		CHAR(50);		-- cuenta intereses
	DECLARE Cue_PagIntAntiExe	CHAR(50);		-- cuenta pago intereses anticipado exigible
	DECLARE Cue_PagIntAntiGra	CHAR(50);		-- cuenta pago intereses anticipado grabado
	DECLARE Con_Capital			INT;			-- con capital
	DECLARE Var_ConInvCapi      INT;			-- con capital mas interes
	DECLARE	VarConcepConta		INT;			-- concepto contable
	DECLARE	DesConcepConta		VARCHAR(150);	-- descripcion concepto contable
	DECLARE	VarDescripMov		VARCHAR(150);	-- decripcion del movimiento
	DECLARE ConAhoIntGravad		INT;			-- Corresponde con la tabla CONCEPTOSAHORRO
	DECLARE ConAhoIntExento		INT;			-- Corresponde con la tabla CONCEPTOSAHORRO
	DECLARE ConAhoISR			INT;			-- Corresponde con la tabla CONCEPTOSAHORRO
	DECLARE Var_PagoInverAnti   INT;			-- Concepto contable
	DECLARE Var_ConInvProv      INT;			-- pago inversion anticipada
	DECLARE ConAho				INT;			-- cuenta del cliente
	DECLARE ConAhoPasivo		INT;			-- Corresponde con la tabla CONCEPTOSAHORRO
	DECLARE TipoInsCuenta 		INT(11);  		-- Instrumento Cliente Corresponde con la tabla TIPOINSTRUMENTOS
	DECLARE TipoInsCliente 		INT(11);  		-- Instrumento Cliente Corresponde con la tabla TIPOINSTRUMENTOS
	DECLARE Act_Devolucion		INT(11);		-- Tipo de actualizacion para devolver la aportacion social
	DECLARE ConContaAportSocio	INT(11);		-- aportacion social
	DECLARE ConceptosCaja		INT(11);		-- concepto de caja
	DECLARE Var_CtaOrdinaria	INT(11);		-- cuenta ordinaria
	DECLARE Var_CtaVista		INT(11);		-- cuenta vista
	DECLARE Var_Vencim_Anticipada   INT;		-- cuenta vencimiento anticpada
	DECLARE Var_SubClasifID     	INT;		-- sub clacificacion
	DECLARE	For_SucOrigen			CHAR(3);	-- sucursal de origen
	DECLARE	For_SucCliente			CHAR(3);	-- sucursal del cliente
	DECLARE Var_CenCosto			INT(11);	-- centro de costos
	DECLARE Var_SucCliente			INT(11);	-- sucursal cliente
	DECLARE Cancelar_PROFUN			INT(1);		-- constante para indicar cancelacion del registro profun
	DECLARE	Est_Activo				CHAR(1);	-- estatus activo
	DECLARE	Bloq_GarLiq				INT(11);	-- vloqeuo garantia liquida
	DECLARE	TipoAutomatica			CHAR(1);	-- tipo automatica
	DECLARE DevGL					CHAR(1);	-- no se
	DECLARE ISRpSocio				VARCHAR(10);-- si se calcula isr por socio
	DECLARE No_constante			VARCHAR(10);-- no constante
	DECLARE SI_Isr_Socio   			CHAR(1);	-- si isr por socio
	DECLARE Con_Origen				CHAR(1);	-- Origen desde donde se ejecuta el SP
	DECLARE ValorUMA				VARCHAR(15);
	DECLARE Var_CentroCostosID		INT(11);
    DECLARE CancelaCta				INT(11);		-- Tipo: Cancelacion de la Cuenta
	DECLARE RespaldaCredSI			CHAR(1);
	DECLARE OrigenPago				CHAR(1);		-- origen de pago
	/* DECLARACION DE CURSORES*/
	DECLARE  cursorCtasCliente CURSOR FOR  /*CURSOR para obtener las cuentas activas del cliente y generar rendimiento */
		SELECT 	TMP.CuentaAhoID,	TMP.SucursalOrigen,	TMP.TipoPersona,	TMP.MonedaID,		TMP.TipoCuentaID,
				TMP.SaldoIniMes,	TMP.SaldoProm,		TMP.TasaInteres,  	TMP.InteresesGen,	TMP.ISR,
				TMP.TasaISR,		TMP.GeneraInteres,	TMP.TipoInteres,	TMP.PagaISR,		TMP.Saldo
		FROM 	TMPCUENTASCANCELCLI TMP
			WHERE	TMP.ClienteID	= Par_ClienteID;

	DECLARE  cursorBloqueosCliente CURSOR FOR  /*CURSOR para obtener las cuentas activas del cliente */
		SELECT	BL.BloqueoID,	BL.MontoBloq,	BL.CuentaAhoID, 	BL.TiposBloqID,		BL.Referencia
				FROM	BLOQUEOS	BL,
						CUENTASAHO	CA
				WHERE	BL.NatMovimiento = Nat_Bloqueo
				 AND 	IFNULL(BL.FolioBloq,Entero_Cero) = Entero_Cero
				 AND 	BL.CuentaAhoID	= CA.CuentaAhoID
				 AND	CA.ClienteID 	= Par_ClienteID;

	DECLARE  cursorInversionPlazo CURSOR FOR  /*CURSOR para obtener las cuentas activas del cliente */
		/* se obtienen los valores que se ocupan para realizar la inversion */
		SELECT	InversionID,		CuentaAhoID,		Plazo,		Tasa,		Monto,
				SaldoProvision,		MonedaID,			DATEDIFF(Var_FechaSis,FechaInicio)
		FROM	INVERSIONES
		WHERE	Estatus		= Est_VigenteInv
		AND		ClienteID	= Par_ClienteID;

	DECLARE  cursorCuentasConSaldo CURSOR FOR  /*CURSOR para obtener las cuentas activas del cliente con saldo disponible mayor a cero*/
		SELECT 	CA.CuentaAhoID,		CA.SaldoDispon
			FROM 	CUENTASAHO		CA
				WHERE	(CA.Estatus 		= Nat_Bloqueo
				 OR		CA.Estatus 			= Est_Activo)
				 AND 	CA.SaldoDispon		> Entero_Cero
				 AND 	CA.ClienteID 		= Par_ClienteID;

	DECLARE  cursorCreditosConAdeudo CURSOR FOR  /*CURSOR para obtener los creditos que presentan adeudos*/
		SELECT CreditoID,	FUNCIONTOTDEUDACRE(CreditoID),	FUNCIONEXIGIBLE(CreditoID),	MonedaID
			FROM CREDITOS
			WHERE	ClienteID	= Par_ClienteID
			 AND	(Estatus	= Est_Vigente
			 OR 	Estatus		= Est_Vencido)
			 AND FUNCIONTOTDEUDACRE(CreditoID) > Entero_Cero;

	DECLARE  cursorCreditosConAdeudoSinIva CURSOR FOR  /*CURSOR para obtener los creditos que presentan adeudos*/
		SELECT	CR.CreditoID,	FUNCTOTDEUCRESINIIVA(CR.CreditoID),	FUNCTOTDEUCRESINIIVA(CR.CreditoID),	CR.MonedaID, 		IFNULL(CP.MontoAplicaCred,Decimal_Cero),
				CR.CuentaID,	CR.ProductoCreditoID,				Des.Clasificacion,					Des.SubClasifID,	FUNCIONTOTDEUDACRE(CR.CreditoID)
			FROM	CREDITOS		CR
					INNER JOIN DESTINOSCREDITO Des		ON CR.DestinoCreID = Des.DestinoCreID
					LEFT OUTER JOIN CLIAPROTECCRED	CP	ON CR.CreditoID 	= CP.CreditoID
			WHERE	CR.ClienteID	= Par_ClienteID
			 AND	(CR.Estatus		= Est_Vigente
			 OR 	CR.Estatus		= Est_Vencido)
			 AND FUNCTOTDEUCRESINIIVA(CR.CreditoID) > Decimal_Cero;

	/*ASIGNACION DE CONSTANTES*/
	SET	Cadena_Vacia		:= '';		-- cadena vacia
	SET	Entero_Cero			:= 0;		-- constante cero
	SET	Entero_Cien			:= 100;		-- constante cien
	SET	Decimal_Cero		:= 0.0;		-- constante DECIMAL cero
	SET Salida_SI			:= 'S';		-- salida si
	SET Salida_NO			:= 'N';		-- salida no
	SET Est_Autorizado		:= 'A';		-- si esta autorizado
	SET Est_Cancelada		:= 'C';		-- si esta cancelada
	SET Est_Inactivo		:= 'I';		-- si esta activo
	SET Est_VigenteInv		:= 'N';		-- si esta vigenete la inversion
	SET Est_Vigente			:= 'V';		-- si esta vigente
	SET Est_Vencido			:= 'B';		-- si eta vencido
	SET Nat_Abono			:= 'A';		-- si es de naturaleza abono
	SET Nat_Cargo			:= 'C';		-- si es de naturaleza abono
	SET Nat_Bloqueo			:= 'B';		-- si esta bloqueado
	SET Nat_Desbloqueo		:= 'D';		-- si esta desbloqueado
	SET AltaDetPolSI		:= 'S';		-- alta de deposito si
	SET AltaEncPolizaSI		:= 'S';		-- Alta de encabezado de poliza SI
	SET AltaEncPolizaNO		:= 'N';		-- Alta de encabezado de poliza NO
	SET Mov_AhorroNO		:= 'N';     -- Movimiento de Ahorro: NO
	SET Ope_Interna			:= 'I';     -- Tipo de Operacion: Interna
	SET Tip_Compra      	:= 'C';     -- Tipo de Operacion: Compra de Divisa
	SET Blo_CancelSoc		:= 15;		-- Tipo de desbloqueo Automatico por cancelacion de socio
	SET SI_PagaISR			:= 'S';		-- si paga isr
	SET Var_Si				:= 'S';		-- constante si
	SET Var_NO				:= 'N';		-- constante no
	SET FiniquitoSI			:= 'S';		-- finiquito si
	SET FiniquitoNo			:= 'N';		-- finiquito no
	SET EsPrePagoSi			:= 'S';		-- es prepago si
	SET EsPrePagoNo			:= 'N';		-- es prepago no
	SET SI_PagaIva			:= 'S';		-- si paga iva
	SET NO_PagaIva			:= 'N';		-- no paga iva
	SET NO_CobraLiqAnt		:= 'N';		-- no cobra liquidez anticipada
	SET AltaMovAho_SI		:= 'S';		-- si da de alta movimiento de cuenta
	SET AltaMovCre_SI		:= 'S';		-- si da de alta movimiento de credito
	SET AltaPolCre_SI		:= 'S';		-- si da de alta poliza de credito
	SET AltaPolCre_NO		:= 'N';		-- no da de alta poliza de credito
	SET AltaMovAho_NO		:= 'N';		-- alta de poliza cuenta no
	SET AltPoliza_NO		:= 'N';     -- Alta de la Poliza NO
	SET Tipo_Provision		:= '100';   -- -- Tipo de Movimiento de Inversion: Provision
	SET	Var_MovRendGra		:= '200';	-- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Pago de Rendimiento Cta.Gravado
	SET	Var_MovRendExc		:= '201';	-- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Pago de Rendimiento Cta.Excento
	SET	Var_MovRetISR		:= '220';	-- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Retencion ISR Cta
	SET	Var_MovCancel		:= '400';	-- corresponde a TipoMovAhoID de la tabla TIPOSMOVSAHO Cancelacion de Socio
	SET Mov_PagInvrAnti		:= '68';    -- Vencimiento Anticipado inversion
	SET Mov_PagIntExe       := '63';    -- PAGO INVERSION. INTERES EXCENTO
	SET Mov_PagInvRet		:= '64';    --  -- PAGO INVERSION. RETENCION
	SET Mov_PagIntGra       := '62';	-- PAGO INVERSION. INTERES GRAVADO
	SET Cue_PagIntAntiExe	:= 'VENCIMIENTO ANTICIPADO INVERSION. INTERES EXCENTO'; -- concepto de movimiento
	SET Cue_PagIntAntiGra	:= 'VENCIMIENTO ANTICIPADO INVERSION. INTERES GRAVADO';	-- concepto de movimiento
	SET Var_RefPagoAnti		:= 'VENCIMIENTO ANTICIPADO INVERSION';					-- concepto de movimiento
	SET Cue_RetInver    	:= 'RETENCION ISR INVERSION';							-- concepto de movimiento
	SET Con_Capital      	:= 1;       -- Concepto Contable de Ahorro: Capital
	SET Var_ConInvCapi      := 1;       -- Concepto Contable de Inversion: Capital
	SET Var_PagoInverAnti   := 16;      -- Concepto Contable: Pago de Inversion vencimiento anticipado
	SET Factor_Porcen		:= 100.00;	-- facto de porcentaje
	SET	VarConcepConta		:= 805;		-- concepto contable
	SET	DesConcepConta		:= (SELECT Descripcion FROM CONCEPTOSCONTA WHERE ConceptoContaID = VarConcepConta);-- concepto contable
	SET ConAhoIntGravad		:= 2;		-- Corresponde con la tabla CONCEPTOSAHORRO
	SET ConAhoIntExento		:= 3;		-- Corresponde con la tabla CONCEPTOSAHORRO
	SET ConAhoISR			:= 4;		-- Corresponde con la tabla CONCEPTOSAHORRO
	SET ConAhoPasivo		:= 1;		-- Corresponde con la tabla CONCEPTOSAHORRO
	SET Var_ConInvProv		:= 5;           -- Concepto Contable de Inversion: Provision
	SET	TipoInsCliente		:= 4;		-- Instrumento Cliente Corresponde con la tabla TIPOINSTRUMENTOS
	SET	TipoInsCuenta		:= 2;		-- Instrumento Cuenta Corresponde con la tabla TIPOINSTRUMENTOS
	SET Act_Devolucion  	:= 2;		-- Tipo de actualizacion para devolver la aportacion social
	SET ConContaAportSocio	:= 401;		-- Concepto Contable de Devolucion Aportacion Socio tabla CONCEPTOSCONTA
	SET ConceptosCaja		:=1;		-- Conceptos caja	Aportacion Social
	SET Var_Vencim_Anticipada   	:= 8; 	 -- Tipo de Actualizacion: Vencimiento Anticipada.
	SET Con_IVAInteres		:= 8;       -- Concepto Contable de Credito: IVA de Interes
	SET Con_IVAMora			:= 9;       -- Concepto Contable de Credito: IVA Moratorios
	SET Con_IVAFalPag		:= 10;      -- Concepto Contable de Credito: IVA Falta de Pago
	SET Mov_IVAInteres		:= 20;      -- movimiento iva intereses
	SET Mov_IVAIntMora		:= 21;      -- monimiento iva mora
	SET Mov_IVAComFaPag		:= 22;		-- movimiento iva comicion falta de pago
	SET	For_SucOrigen		:= '&SO';	-- Nomenclatura  Centro de Costos(Sucursal Origen)
	SET	For_SucCliente		:= '&SC';	-- Nomenclatura Centro de Costos (Sucursal Cliente)
	SET Cancelar_PROFUN		:= 1;		-- cancelar profun
	SET Var_ProgramaID		:= 'CLIENTESCANCELCTAPRO';-- programa id
	SET Est_Activo		    := 'A';      -- Cuenta Activa
	SET Bloq_GarLiq         := 8;        -- Tipo Bloqueo: Deposito por garantia liquida
	SET TipoAutomatica      := 'A';		 -- Tipo Automatica
	SET DevGL				:= 'V';      -- Devolucion Garantia Liquida
	SET Var_SucCliente := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_ClienteID );
	SET SI_Isr_Socio				:= 'S';	-- Constante para saber si se calcula el ISR por socio
	SET ISRpSocio					:= 'ISR_pSocio';-- constante para isr por socio de PARAMGENERALES
	SET Con_Origen			:= 'S'; -- Variable para identificar el origen que ejecuta el SP
	SET RespaldaCredSI		:= 'S';
	/*ASIGNACION DE VARIABLES */
	SET Par_NumErr  		:= Entero_Cero;
	SET Par_ErrMen  		:= Cadena_Vacia;
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
	SET Var_MontoIVAIntPer			:= 0;
	SET ValorUMA			:='ValorUMABase';
	SET Var_CentroCostosID	:= 0;
    SET CancelaCta				:= 2;		-- Tipo: Cancelacion de la Cuenta
	SET OrigenPago			:= 'L';			-- PAGO DE TARJETA AL CANCELAR EL CLIENTE
	/* Se obtienen valores de los parametros del sistema */
	SELECT 	DiasInversion, 		MonedaBaseID,		FechaSistema,	SalMinDF,		FechaISR
	 INTO 	Var_DiasInversion,	Var_MonedaBase,		Var_FechaSis,	Var_SalMinDF,	Var_FechaISR
		FROM PARAMETROSSIS;

    SELECT ValorParametro
			INTO Var_ValorUMA
			FROM PARAMGENERALES
		WHERE LlaveParametro=ValorUMA;

	SET Var_FechaISR	:= IFNULL(Var_FechaISR,Par_Fecha);
	SELECT ValorParametro INTO Var_ISR_pSocio
	FROM PARAMGENERALES
		WHERE LlaveParametro=ISRpSocio;
	SET Var_ISR_pSocio	:= IFNULL(Var_ISR_pSocio , No_constante);

	SELECT		HaberExSocios,		CtaOrdinaria,		CuentaVista,		HaberExSocios,			CtaProtecCta,
				CtaProtecCre,		CCHaberesEx,		CCContaPerdida,		CCProtecAhorro,			CtaContaPerdida
		INTO	Var_CuentaConta,	Var_CtaOrdinaria,	Var_CtaVista,		Var_CtaContaExHab,		Var_CtaConProCta,
				Var_CtaConProCre,	Var_CCHaberesEx,	Var_CCContaPerdida,	Var_CCProtecAhorro, 	Var_CtaPerdida
		FROM PARAMETROSCAJA;
	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores

	/* SE VALIDA SI SE REALIZA LA SECCION QUE REALIZA EL VENCIMIENTO ANTICIPADO DE INVERSIONES
	REALIZA EL VENCIMIENTO Y HACE EL ABONO A CUENTA DEL CLIENTE ---------------------------------------------------- */
	IF(Par_VencimInver = Var_Si ) THEN
		/* Se consulta para saber si el cliente paga o no ISR
		y se obtiene el valor de TasaISR*/
		SELECT 	PagaISR,		CASE PagaISR WHEN 'S' THEN Suc.TasaISR ELSE 0 END AS TasaISR, Cli.TipoPersona
		INTO 	VarPagaISR,		VarTasaISR, Var_TipoPersona
		FROM	CLIENTES Cli,
				SUCURSALES Suc
		WHERE 	Cli.ClienteID	= Par_ClienteID
		AND 	Suc.SucursalID	= Cli.SucursalOrigen;

		/* SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
			* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
			* si no es CERO */
		SET Var_SalMinAn := Var_SalMinDF * 5 * Var_ValorUMA; /* Salario minimo General Anualizado*/

		INSERT INTO PROTECCIONESINV (
			ClienteID,		InversionID,		Monto,		InteresGenerado,	InteresRetener,
			Total)
		SELECT
			Par_ClienteID,	InversionID,		Monto,		SaldoProvision,
				CASE WHEN  (Var_ISR_pSocio = SI_Isr_Socio AND FechaInicio>=Var_FechaISR) THEN
					ISRReal
				ELSE
					CASE WHEN Monto > Var_SalMinAn  OR Var_TipoPersona = 'M' THEN
						CASE WHEN Var_TipoPersona = 'M' THEN
							ROUND((Monto * DATEDIFF(Var_FechaSis,FechaInicio) * VarTasaISR) / (100 * Var_DiasInversion), 2)
						ELSE
							ROUND(((Monto-Var_SalMinAn) * DATEDIFF(Var_FechaSis,FechaInicio) * VarTasaISR) / (100 * Var_DiasInversion), 2)
						END
					ELSE 0
					END
				END AS InteresRetener,

				Monto +SaldoProvision - (	CASE WHEN Monto > Var_SalMinAn  OR Var_TipoPersona = 'M' THEN
												CASE WHEN Var_TipoPersona = 'M' THEN
													ROUND((Monto * DATEDIFF(Var_FechaSis,FechaInicio) * VarTasaISR) / (100 * Var_DiasInversion), 2)
												ELSE
													ROUND(((Monto-Var_SalMinAn) * DATEDIFF(Var_FechaSis,FechaInicio) * VarTasaISR) / (100 * Var_DiasInversion), 2)
												END
											ELSE 0
											END) AS Total
		FROM	INVERSIONES
		WHERE	Estatus		= Est_VigenteInv
		 AND	ClienteID	= Par_ClienteID;


		OPEN  cursorInversionPlazo; /* se abre CURSOR para vencer por anticipado las inversiones plazo */
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP
				FETCH cursorInversionPlazo INTO
					VarInversionID,		VarCuentaAhoID,		VarPlazo,				VarTasaInv,			VarMontoInv,
					VarSaldoProvision,	Var_Moneda,			Var_DiasTrascurrido;

				IF(Par_Poliza = Entero_Cero) THEN
					SET Par_AltaEncPoliza 	:= AltaEncPolizaSI;
				ELSE
					SET Par_AltaEncPoliza := AltaEncPolizaNO;
				END IF;

				CALL INVERSIONACT(
					VarInversionID,		Cadena_Vacia,		Cadena_Vacia,			Par_AltaEncPoliza,		Var_Vencim_Anticipada,
					Salida_NO,			Par_NumErr,			Par_ErrMen,				Par_Poliza,				Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Var_ProgramaID,			Aud_Sucursal,
					Aud_NumTransaccion);


				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLO;
				END IF;
			END LOOP CICLO;
		END;
		CLOSE cursorInversionPlazo; /* se cierra CURSOR para vencer por anticipado las inversiones plazo */

	END IF;  /* **FIN DE VENCIMIENTO ANTICIPADO DE INVERSIONES ** ********************************************************** */

	/* SE VALIDA SI SE REALIZARA LA SECCION QUE REALIZA EL DESBLOQUEO DE LAS CUENTAS DEL CLIENTE */
	IF (Par_DesbloqSaldos = Var_Si)THEN
		SET VarMonedaID 		:= (SELECT MonedaBaseID FROM PARAMETROSSIS);
		/* ********** se obtiene cuantos bloqueos tiene el cliente para comenzar a desbloquear los saldos *********** */
		SET VarNumBloqueos	:= (SELECT	COUNT(BL.BloqueoID)
									FROM	BLOQUEOS	BL,
											CUENTASAHO	CA
									WHERE	BL.NatMovimiento = Nat_Bloqueo
									 AND 	IFNULL(BL.FolioBloq,Entero_Cero) = Entero_Cero
									 AND 	BL.CuentaAhoID	= CA.CuentaAhoID
									 AND	CA.ClienteID 	= Par_ClienteID);
		SET VarNumBloqueos	:= IFNULL(VarNumBloqueos,Entero_Cero);
		IF( VarNumBloqueos > Entero_Cero )THEN

			SET VarDescripDes	:= (SELECT Descripcion FROM TIPOSBLOQUEOS WHERE TiposBloqID = Blo_CancelSoc );

			OPEN  cursorBloqueosCliente; /* se abre CURSOR para hacer los desbloqueos del  cliente */
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
					FETCH cursorBloqueosCliente  INTO VarBloqueoID,	VarMontoBloq,	VarCuentaAhoID,	Var_TiposBloqID,	VarCreditoID;

					/* se hace la llamada a BLOQUEOSPRO para comenzar a desbloquear los saldos. */
					CALL BLOQUEOSPRO(
						VarBloqueoID,		Nat_Desbloqueo,		VarCuentaAhoID,		Par_Fecha,			VarMontoBloq,
						Par_Fecha,			Var_TiposBloqID,	VarDescripDes,		VarCreditoID,		Cadena_Vacia,
						Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Var_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE CICLO;
					END IF;

					IF(Var_TiposBloqID = Bloq_GarLiq) THEN
						IF(Par_Poliza = Entero_Cero) THEN
							SET Par_AltaEncPoliza	:= AltaEncPolizaNO;
							SET Var_DescripcCon		:= DesConcepConta;
							/*si no hay un encabezado de poliza se crea uno*/
							CALL MAESTROPOLIZAALT(
								Par_Poliza,		Par_EmpresaID,	Par_Fecha,		TipoAutomatica,		VarConcepConta,
								DesConcepConta,	Salida_NO,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion );
						ELSE
							SET Par_AltaEncPoliza := AltaEncPolizaNO;
						END IF;


						CALL CONTAGARLIQPRO(
							Par_Poliza,		Par_Fecha,			Par_ClienteID,		VarCuentaAhoID,		VarMonedaID,
							VarMontoBloq,	Par_AltaEncPoliza,	Par_ConceptoCon,	DevGL,				Var_TiposBloqID,
							VarDescripDes,	Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
							Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);
						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE CICLO;
						END IF;
					END IF;

				END LOOP CICLO;
			END;
			CLOSE cursorBloqueosCliente; /* se abre CURSOR para hacer los desbloqueos del  cliente */
		END IF;

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		/*  fin de desbloquear los saldos */
	END IF;

	/* SE VALIDA SI SE REALIZA LA SECCION QUE GENERA LOS INTERESES POR RENDIMIENTO DE LAS CUENTAS DE AHORRO Y
		EL COBRO DEL IMPUESTO */
	IF(Par_GenIntISRAho = Var_Si ) THEN
		/****************  SE INICIA SECCION PARA GENERAR INTERESES Y COBRAR ISR ***********************/
		TRUNCATE TMPCUENTASCANCELCLI;
		INSERT INTO	TMPCUENTASCANCELCLI (
			CuentaAhoID,		SucursalOrigen,			TipoPersona,		MonedaID,			TipoCuentaID,
			SaldoIniMes,	    SaldoProm,			    TasaInteres,	    InteresesGen,	    ISR,
			TasaISR,		    GeneraInteres,		    TipoInteres,	    PagaISR,		    ClienteID,
			Saldo)
		SELECT
			CA.CuentaAhoID,		Cli.SucursalOrigen,		Cli.TipoPersona,	CA.MonedaID,		CA.TipoCuentaID,
			CA.SaldoIniMes,		CA.SaldoProm,			CA.TasaInteres,  	CA.InteresesGen,	CASE WHEN  (Var_ISR_pSocio = SI_Isr_Socio)
																											THEN
																												CA.ISRReal
																											ELSE
																											CA.ISR
																											END AS ISR,
			SU.TasaISR,			TiCta.GeneraInteres,	TiCta.TipoInteres,	Cli.PagaISR,		CA.ClienteID,
			Saldo
		FROM 	CUENTASAHO		CA,
				CLIENTES		Cli,
				TIPOSCUENTAS	TiCta,
				SUCURSALES		SU
			WHERE	(CA.Estatus 		= Nat_Bloqueo
			 OR		CA.Estatus 			= Est_Activo)
			 AND 	CA.ClienteID  		= Cli.ClienteID
			 AND 	CA.TipoCuentaID 	= TiCta.TipoCuentaID
			 AND 	Cli.SucursalOrigen 	= SU.SucursalID
			 AND 	CA.ClienteID 		= Par_ClienteID;

		/*se guarda un respaldo en la tabla de PROTECCIONESCTA*/
		INSERT INTO PROTECCIONESCTA(
			ClienteID,		CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesCap,
			InteresRetener,	TotalHaberes,	EmpresaID,		Usuario,		FechaActual,
			DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
		SELECT
			Par_ClienteID,	CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesGen,
			ISR,			Saldo,			Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
			Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
		FROM TMPCUENTASCANCELCLI
			WHERE ClienteID = Par_ClienteID;

		/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
		SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
		SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
		IF(Var_ClienteIDProtec = Entero_Cero) THEN
			INSERT INTO PROTECCIONES (
				ClienteID,			ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
				InteresRetener,		TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	ApliCASERVIFUN,
				AplicaProtecCre,	AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
				MontoProtecAho,		TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
				FechaActual,		DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
			SELECT
				Par_ClienteID,		Par_ClienteCancelaID,	SUM(Saldo),			Decimal_Cero,	Decimal_Cero,
				Decimal_Cero,		SUM(Saldo),				Decimal_Cero,		Var_NO,			Var_NO,
				Var_NO,				Var_NO,					Decimal_Cero,		Decimal_Cero,	Decimal_Cero,
				Decimal_Cero,		Decimal_Cero,			SUM(Saldo),			Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
			FROM PROTECCIONESCTA
			WHERE ClienteID = Par_ClienteID
			GROUP BY ClienteID;
		ELSE
			UPDATE PROTECCIONES P,
				(SELECT SUM(PC.Saldo) AS Saldo FROM  PROTECCIONESCTA PC WHERE PC.ClienteID	= Par_ClienteID GROUP BY ClienteID) AS PC
			SET
				P.TotalSaldoOriCap 	= PC.Saldo,
				P.TotalHaberes		= PC.Saldo,
				P.SaldoFavorCliente	= PC.Saldo,
				P.CobradoPROFUN		=  Decimal_Cero,
				P.ClienteCancelaID = Par_ClienteCancelaID
			WHERE	P.ClienteID		= Par_ClienteID;
		END IF;

		/* se insertan datos que calculan el saldo promedio si es que los hay */
		TRUNCATE TABLE TMPMOVSCTA;		/* se eliminan datos de tabla temporal */
		SET DiasMes	:= DAY(Par_Fecha);	/* se obtiene el numero de dias transcurridos*/
		SELECT 		DiasInversion,	SalMinDF
			INTO 	Fre_DiasAnio,	Var_SalMinDF
			FROM 	PARAMETROSSIS;
		SET Var_SalMinDF	:= IFNULL(Var_SalMinDF , Decimal_Cero);
		SET Fre_DiasAnio 	:= IFNULL(Fre_DiasAnio , Entero_Cero);
		SET Var_SalMinAn 	:= Var_SalMinDF * 5 * Fre_DiasAnio; /* Salario minimo General Anualizado*/

		INSERT INTO TMPMOVSCTA (
			CuentaAhoID, SaldoPromedio)
			SELECT Movs.CuentaAhoID, SUM(Movs.CantidadMov)/DiasMes AS SaldoPromedio
				FROM (SELECT CM.CuentaAhoID, CM.Fecha, CM.NatMovimiento,
								CASE WHEN (CM.NatMovimiento = Nat_Abono)
									THEN (CM.CantidadMov*(DATEDIFF(Par_Fecha,CM.Fecha) +1))
									ELSE ((CM.CantidadMov*(DATEDIFF(Par_Fecha,CM.Fecha) +1))*-1) END AS CantidadMov
						FROM CUENTASAHOMOV	CM,
							 CUENTASAHO CA
						 WHERE 	Fecha >= DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY)
							AND Fecha <= Par_Fecha
							AND CA.CuentaAhoID 	= CM.CuentaAhoID
							AND CA.ClienteID 	= Par_ClienteID) AS Movs
			 GROUP BY Movs.CuentaAhoID;

			/* SE HACE EL CALCULO DEL SALDO PROMEDIO*/
			UPDATE 	TMPCUENTASCANCELCLI TCA,
					(SELECT IFNULL(SaldoPromedio,Entero_Cero)+SaldoIniMes AS SaldoPromedio,TCA.CuentaAhoID
						FROM TMPCUENTASCANCELCLI TCA
						LEFT OUTER JOIN TMPMOVSCTA TMP
						ON TCA.CuentaAhoID= TMP.CuentaAhoID ) Movs
			SET		TCA.SaldoProm = Movs.SaldoPromedio
			WHERE TCA.CuentaAhoID= Movs.CuentaAhoID;

		/**** Se hace la generacion de interes, dependiendo del tipo de cuenta del cliente, si este paga ISR  y genero
		* intereses y EL MONTO DE SALDO PROMEDIO es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF),
		* entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL MONTO ORIGINAL,
		* si no es CERO */
		/* Si el cliente paga ISR entonces se calcula el interes a Retener , sino su valor sera cero*/
		UPDATE 	TMPCUENTASCANCELCLI TCA,
				(
					SELECT  	TC.CuentaAhoID, TA.Tasa
						FROM 	TASASAHORRO   TA,
							TMPCUENTASCANCELCLI TC
					WHERE  TA.TipoCuentaID    = TC.TipoCuentaID
					AND    TA.MonedaID        = TC.MonedaID
					AND    TA.TipoPersona     = TC.TipoPersona
					AND    TA.MontoInferior <= TC.SaldoProm
					AND    TA.MontoSuperior >= TC.SaldoProm
				) AS Movs
		SET
			TCA.TasaInteres 	= Movs.Tasa,
			TCA.InteresesGen	= (TCA.SaldoProm*DiasMes*Movs.Tasa)/(Fre_DiasAnio*Entero_Cien),
			TCA.ISR				= CASE WHEN  (Var_ISR_pSocio = SI_Isr_Socio)
									THEN TCA.ISR
									ELSE
										CASE WHEN  TCA.SaldoProm > Var_SalMinAn OR TCA.TipoPersona = 'M' THEN
											CASE WHEN  TCA.TipoPersona = 'M' THEN
												ROUND((TCA.SaldoProm * DiasMes * TCA.TasaISR) / (Entero_Cien * Fre_DiasAnio), 2)
											ELSE
												ROUND(((TCA.SaldoProm-Var_SalMinAn) * DiasMes * TCA.TasaISR) / (Entero_Cien * Fre_DiasAnio), 2)
											END
										ELSE Decimal_Cero
										END
									END
		WHERE	TCA.CuentaAhoID		= Movs.CuentaAhoID
		 AND	TCA.GeneraInteres 	= Var_Si;

		-- INICIO LLAMADA PARA OBTENER LOS RENDIMIENTOS DE LAS CUENTAS PARA EL INTERES REAL EN LA CONSTANCIA DE RETENCION
		CALL RENDIMIENTOSCTASPRO(
			Var_FechaSis,		CancelaCta,			Par_EmpresaID, 		Aud_Usuario, 	Aud_FechaActual,
            Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		-- FIN LLAMADA PARA OBTENER LOS RENDIMIENTOS DE LAS CUENTAS PARA EL INTERES REAL EN LA CONSTANCIA DE RETENCION


		OPEN  cursorCtasCliente; /* se abre CURSOR para hacer EL PAGO DE RENDIMIENTO Y RETENCION DE IMPUESTO */
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP
				FETCH cursorCtasCliente  INTO
					VarCuentaAhoID,		VarSucursalOrigen,	VarTipoPersona,		VarMonedaID,		VarTipoCuentaID,
					VarSaldoIniMes,		VarSaldoProm,		VarTasaInteres,		VarInteresesGen,	VarISR,
					VarTasaISR,			VarGeneraInteres,	VarTipoInteres,		VarPagaISR,			VarSaldo;

			IF(VarPagaISR = Var_Si) THEN
				SET Var_ConcepPago	:= Var_MovRendGra;
				SET Var_ConRendGra	:= (SELECT  Descripcion  FROM TIPOSMOVSAHO WHERE	TipoMovAhoID = Var_MovRendGra);
				SET Var_DescripcCon	:= Var_ConRendGra;
				SET ConAho			:= ConAhoIntGravad;
			ELSE
				SET Var_ConcepPago	:= Var_MovRendExc;
				SET Var_ConRendExc	:= (SELECT  Descripcion  FROM TIPOSMOVSAHO WHERE	TipoMovAhoID = Var_MovRendExc);
				SET Var_DescripcCon	:= Var_ConRendExc;
				SET ConAho			:= ConAhoIntExento;
			END IF;

			SET VarInteresesGen	:= IFNULL(VarInteresesGen,Decimal_Cero );
			IF(VarInteresesGen > Decimal_Cero) THEN
				IF(Par_Poliza = Entero_Cero) THEN
					SET Par_AltaEncPoliza 	:= AltaEncPolizaSI;
					SET Var_DescripcCon		:= DesConcepConta;
				ELSE
					SET Par_AltaEncPoliza := AltaEncPolizaNO;
				END IF;


				CALL CONTAAHORROPRO( /* movimiento de capital de Interes Generado */
					VarCuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Par_Fecha,			Par_Fecha,
					Nat_Abono,			VarInteresesGen,	Var_DescripcCon,		VarCuentaAhoID,		Var_ConcepPago,
					VarMonedaID,		VarSucursalOrigen,	Par_AltaEncPoliza,		Par_ConceptoCon,	Par_Poliza,
					AltaDetPolSI,		ConAhoPasivo,		Nat_Abono,				Cadena_Vacia,		Par_ErrMen,
					Entero_Cero,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				/* se llama al sp de POLIZAAHORROPRO para realizar la parte contable */
				CALL POLIZAAHORROPRO( /* movimiento de Interes Generado */
					Par_Poliza, 		Par_EmpresaID,		Par_Fecha,			Par_ClienteID,		ConAho,
					VarCuentaAhoID,		VarMonedaID,		VarInteresesGen,	Decimal_Cero,		Var_DescripcCon,
					VarCuentaAhoID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				/*SE ACTUALIZAN LOS INTERESES GENERADOS EN LA TABLA DE CUENTASAHO*/
				UPDATE CUENTASAHO SET
					InteresesGen = VarInteresesGen
				WHERE CuentaAhoID = VarCuentaAhoID;

				IF(Par_Poliza = Entero_Cero) THEN
					SET Par_AltaEncPoliza := AltaEncPolizaSI;
				ELSE
					SET Par_AltaEncPoliza := AltaEncPolizaNO;
				END IF;
			END IF;

			SET VarISR	:= IFNULL(VarISR,Decimal_Cero );
			IF(VarISR > Decimal_Cero) THEN
				SET Var_ConRetISR:= (SELECT  Descripcion  FROM TIPOSMOVSAHO WHERE	TipoMovAhoID = Var_MovRetISR);

				IF(Par_Poliza = Entero_Cero) THEN
					SET Par_AltaEncPoliza := AltaEncPolizaSI;
					SET Var_DescripcCon		:= DesConcepConta;
				ELSE
					SET Par_AltaEncPoliza := AltaEncPolizaNO;
				END IF;

				CALL CONTAAHORROPRO( /* movimiento de capital de ISR */
					VarCuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Par_Fecha,			Par_Fecha,
					Nat_Cargo,			VarISR,				Var_ConRetISR,			VarCuentaAhoID,		Var_MovRetISR,
					VarMonedaID,		VarSucursalOrigen,	Par_AltaEncPoliza,		Par_ConceptoCon,	Par_Poliza,
					AltaDetPolSI,		ConAhoPasivo,		Nat_Cargo,				Cadena_Vacia,		Par_ErrMen,
					Entero_Cero,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							/* se llama al sp de POLIZAAHORROPRO para realizar la parte contable */
				CALL POLIZAAHORROPRO( /* movimiento de ISR */
					Par_Poliza, 		Par_EmpresaID,		Par_Fecha,			Par_ClienteID,		ConAhoISR,
					VarCuentaAhoID,		VarMonedaID,		Decimal_Cero,		VarISR,				Var_DescripcCon,
					VarCuentaAhoID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				/* se actualiza el monto de interes a retener */
				UPDATE CUENTASAHO SET
					ISR = VarISR
				WHERE CuentaAhoID = VarCuentaAhoID;

				IF(Par_Poliza = Entero_Cero) THEN
					SET Par_AltaEncPoliza := AltaEncPolizaSI;
				ELSE
					SET Par_AltaEncPoliza := AltaEncPolizaNO;
				END IF;
			END IF;

			END LOOP CICLO;
		END;
		CLOSE cursorCtasCliente; /* se abre cierra para hacer EL PAGO DE RENDIMIENTO Y RETENCION DE IMPUESTO */

		DELETE FROM PROTECCIONESCTA WHERE  ClienteID = Par_ClienteID;
		/*se guarda un respaldo en la tabla de PROTECCIONESCTA*/
		INSERT INTO PROTECCIONESCTA(
			ClienteID,		CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesCap,
			InteresRetener,	TotalHaberes,	EmpresaID,		Usuario,		FechaActual,
			DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
		SELECT
			Par_ClienteID,	CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesGen,
			ISR,			Saldo+InteresesGen-ISR,			Par_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,Aud_DireccionIP,				Aud_ProgramaID,	Aud_Sucursal,
			Aud_NumTransaccion
		FROM TMPCUENTASCANCELCLI
			WHERE ClienteID = Par_ClienteID;

		/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
		SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
		SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
		IF(Var_ClienteIDProtec = Entero_Cero) THEN
			INSERT INTO PROTECCIONES (
				ClienteID,				ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
				InteresRetener,			TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	ApliCASERVIFUN,
				AplicaProtecCre,		AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
				MontoProtecAho,			TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
			SELECT
				Par_ClienteID,			Par_ClienteCancelaID,	SUM(Saldo),			Decimal_Cero,	SUM(InteresesCap),
				SUM(InteresRetener),	SUM(TotalHaberes),		Decimal_Cero,		Var_NO,			Var_NO,
				Var_NO,					Var_NO,					Decimal_Cero,		Decimal_Cero,	Decimal_Cero,
				Decimal_Cero,			Decimal_Cero,			SUM(TotalHaberes),	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
			FROM PROTECCIONESCTA
			WHERE ClienteID = Par_ClienteID
			GROUP BY ClienteID;
		ELSE
			UPDATE PROTECCIONES P,
				(SELECT SUM(Saldo) AS Saldo, SUM(InteresesCap) AS InteresesCap, SUM(InteresRetener) AS InteresRetener, SUM(TotalHaberes) AS TotalHaberes
					FROM  PROTECCIONESCTA PC WHERE PC.ClienteID	= Par_ClienteID GROUP BY ClienteID ) AS PC
			SET
				P.TotalSaldoOriCap	= PC.Saldo,
				P.InteresCap		= PC.InteresesCap,
				P.InteresRetener	= PC.InteresRetener,
				P.TotalHaberes		= PC.TotalHaberes,
				P.SaldoFavorCliente	= PC.TotalHaberes,
				P.ClienteCancelaID = Par_ClienteCancelaID
			WHERE	P.ClienteID		= Par_ClienteID;
		END IF;
	END IF;  /* *************** */


	/* *********************************************************************************************
		SE VALIDA SI SE REALIZARA LA DEVOLUCION DE LA APORTACION SOCIAL
							********************************************************************** */
	IF(Par_AportSocial = Var_Si ) THEN
		SET Var_AportSocial		:= (SELECT 	Saldo  	FROM APORTACIONSOCIO WHERE ClienteID = Par_ClienteID);
		SET Var_AportSocial 	:= (IFNULL(Var_AportSocial, Decimal_Cero));

		SET VarMonedaID 		:= (SELECT MonedaBaseID FROM PARAMETROSSIS);
		SET VarSucursalOrigen	:= (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Par_ClienteID );

		CALL APORTACIONSOCIOACT(
			Par_ClienteID, 		Var_AportSocial,	Act_Devolucion,		Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_Poliza = Entero_Cero) THEN
			SET Par_AltaEncPoliza := AltaEncPolizaSI;
			SET Var_DescripcCon		:= DesConcepConta;
		ELSE
			SET Par_AltaEncPoliza := AltaEncPolizaNO;
		END IF;

		IF(Var_AportSocial > Decimal_Cero)THEN
			/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
			SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
			SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
			IF(Var_ClienteIDProtec = Entero_Cero) THEN
				INSERT INTO PROTECCIONES (
					ClienteID,				ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
					InteresRetener,			TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	ApliCASERVIFUN,
					AplicaProtecCre,		AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
					MontoProtecAho,			TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				VALUES(
					Par_ClienteID,			Par_ClienteCancelaID,	Decimal_Cero,		Var_AportSocial,Decimal_Cero,
					Decimal_Cero,			Decimal_Cero,			Decimal_Cero,		Var_NO,			Var_NO,
					Var_NO,					Var_NO,					Decimal_Cero,		Decimal_Cero,	Decimal_Cero,
					Decimal_Cero,			Decimal_Cero,			Var_AportSocial,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);
			ELSE
				UPDATE PROTECCIONES P SET
					ParteSocial			= Var_AportSocial,
					SaldoFavorCliente	= SaldoFavorCliente + Var_AportSocial,
					P.ClienteCancelaID = Par_ClienteCancelaID
				WHERE	P.ClienteID		= Par_ClienteID;
			END IF;

			CALL FOLIOSAPLICAACT('APORTASOCIOMOV', Var_APortaSocID);

			INSERT INTO APORTASOCIOMOV (
							AportaSocMOvID,     ClienteID,          Monto,              Tipo,
							SucursalID,         CajaID,             Fecha,              UsuarioID,
							DescripcionMov,     NumMovimiento,      MonedaID,           EmpresaID,
							Usuario,            FechaActual,        DireccionIP,        ProgramaID,
							Sucursal,           NumTransaccion)
					VALUES  (
							Var_APortaSocID,    Par_ClienteID,      Var_AportSocial,    'D',
							Aud_Sucursal,    	Entero_Cero,        Par_Fecha,          Aud_Usuario,
							'DEVOLUCION POR CANCELACION DE SOCIO ', Aud_NumTransaccion,  1,       Par_EmpresaID,
							Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
							Aud_Sucursal,       Aud_NumTransaccion);

			CALL CONTACAJAPRO(
				Aud_NumTransaccion,	Par_Fecha,			Var_AportSocial,	DesConcepConta,		VarMonedaID,
				VarSucursalOrigen,	Par_AltaEncPoliza,	ConContaAportSocio,	Par_Poliza,			AltaDetPolSI,
				ConceptosCaja,		Nat_Cargo,			Par_ClienteID,		Par_ClienteID,		Entero_Cero,
				TipoInsCliente,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
				Aud_NumTransaccion);

			SET VarCuentaAhoID := (SELECT	CA.CuentaAhoID
										FROM	CUENTASAHO	CA
										WHERE	CA.ClienteID 	= Par_ClienteID
										 AND 	CA.Estatus		= 'A' LIMIT 1);
			IF(Par_Poliza = Entero_Cero) THEN
				SET Par_AltaEncPoliza := AltaEncPolizaSI;
				SET Var_DescripcCon		:= DesConcepConta;
			ELSE
				SET Par_AltaEncPoliza := AltaEncPolizaNO;
			END IF;

			SET Var_ConRetISR:= "DEVOLUCION APORTACION SOCIAL CANCELACION SOCIO";
			CALL CONTAAHORROPRO( /* movimiento de capital de ISR */
				VarCuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Par_Fecha,			Par_Fecha,
				Nat_Abono,			Var_AportSocial,	Var_ConRetISR,			VarCuentaAhoID,		Var_MovCancel,
				VarMonedaID,		VarSucursalOrigen,	Par_AltaEncPoliza,		Par_ConceptoCon,	Par_Poliza,
				AltaDetPolSI,		ConAhoPasivo,		Nat_Abono,				Cadena_Vacia,		Par_ErrMen,
				Entero_Cero,		Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Poliza = Entero_Cero) THEN
				SET Par_AltaEncPoliza := AltaEncPolizaSI;
				SET Var_DescripcCon		:= DesConcepConta;
			ELSE
				SET Par_AltaEncPoliza := AltaEncPolizaNO;
			END IF;

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			/* ***** 1 */

			SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONESCTA WHERE ClienteID = Par_ClienteID LIMIT 1);
			SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
			IF(Var_ClienteIDProtec = Entero_Cero) THEN

				TRUNCATE TMPCUENTASCANCELCLI;
				INSERT INTO `TMPCUENTASCANCELCLI`	(
						`CuentaAhoID`,					`SucursalOrigen`,				`TipoPersona`,				`MonedaID`,					`TipoCuentaID`,
						`SaldoIniMes`,					`SaldoProm`,					`TasaInteres`,				`InteresesGen`,				`ISR`,
						`TasaISR`,						`GeneraInteres`,				`TipoInteres`,				`PagaISR`,					`ClienteID`,
						`Saldo`)
				SELECT
					CA.CuentaAhoID,		Cli.SucursalOrigen,		Cli.TipoPersona,	CA.MonedaID,		CA.TipoCuentaID,
					CA.SaldoIniMes,		CA.SaldoProm,			CA.TasaInteres,  	CA.InteresesGen,	CASE WHEN  (Var_ISR_pSocio = SI_Isr_Socio)
																											THEN
																												CA.ISRReal
																											ELSE
																											CA.ISR
																											END AS ISR,
					SU.TasaISR,			TiCta.GeneraInteres,	TiCta.TipoInteres,	Cli.PagaISR,		CA.ClienteID,
					Saldo
				FROM 	CUENTASAHO		CA,
						CLIENTES		Cli,
						TIPOSCUENTAS	TiCta,
						SUCURSALES		SU
					WHERE	(CA.Estatus 		= 'B'
					 OR		CA.Estatus 			= 'A')
					 AND 	CA.ClienteID  		= Cli.ClienteID
					 AND 	CA.TipoCuentaID 	= TiCta.TipoCuentaID
					 AND 	Cli.SucursalOrigen 	= SU.SucursalID
					 AND 	CA.ClienteID 		= Par_ClienteID;

				DELETE FROM PROTECCIONESCTA WHERE  ClienteID = Par_ClienteID;
				/*se guarda un respaldo en la tabla de PROTECCIONESCTA*/
				INSERT INTO PROTECCIONESCTA(
					ClienteID,		CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesCap,
					InteresRetener,	TotalHaberes,	EmpresaID,		Usuario,		FechaActual,
					DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
				SELECT
					Par_ClienteID,	CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesGen,
					ISR,			Saldo+InteresesGen-ISR+Var_AportSocial,			Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
				FROM TMPCUENTASCANCELCLI
					WHERE ClienteID = Par_ClienteID;
			ELSE
				UPDATE PROTECCIONESCTA SET
					Saldo = Saldo , -- sandra
					TotalHaberes	= TotalHaberes + Var_AportSocial
				WHERE ClienteID = Par_ClienteID
					AND CuentaAhoID  = VarCuentaAhoID;

			END IF;

			/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
			SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
			SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
			IF(Var_ClienteIDProtec = Entero_Cero) THEN
				INSERT INTO PROTECCIONES (
					ClienteID,				ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
					InteresRetener,			TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	ApliCASERVIFUN,
					AplicaProtecCre,		AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
					MontoProtecAho,			TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
				SELECT
					Par_ClienteID,			Par_ClienteCancelaID,	SUM(Saldo),			Decimal_Cero,	SUM(InteresesCap),
					SUM(InteresRetener),	SUM(TotalHaberes),		Decimal_Cero,		Var_NO,			Var_NO,
					Var_NO,					Var_NO,					Decimal_Cero,		Decimal_Cero,	Decimal_Cero,
					Decimal_Cero,			Decimal_Cero,			SUM(TotalHaberes),	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
				FROM PROTECCIONESCTA
				WHERE ClienteID = Par_ClienteID
				GROUP BY ClienteID;
			ELSE
				UPDATE PROTECCIONES P,
					(SELECT SUM(Saldo) AS Saldo, SUM(InteresesCap) AS InteresesCap, SUM(InteresRetener) AS InteresRetener, SUM(TotalHaberes) AS TotalHaberes
						FROM  PROTECCIONESCTA PC WHERE PC.ClienteID	= Par_ClienteID GROUP BY ClienteID ) AS PC
				SET
					P.TotalSaldoOriCap	= PC.Saldo,
					P.InteresCap		= PC.InteresesCap,
					P.InteresRetener	= PC.InteresRetener,
					P.TotalHaberes		= PC.TotalHaberes,
					P.SaldoFavorCliente	= PC.TotalHaberes,
					P.ClienteCancelaID = Par_ClienteCancelaID
				WHERE	P.ClienteID		= Par_ClienteID;
			END IF; /* *************1  */
		END IF;
	END IF;

	/* *********************************************************************************************
		SE VALIDA SI SE REALIZARA DE COBRO DE MUTUALES
								********************************************************************** */
	IF(Par_CobroPROFUN = Var_Si ) THEN
		/* *************************
			Antes de cancelar, se valida que el cliente no tenga saldo pendiente de pago en PROFUN,
			si el cliente tiene monto pendiende de pago, se realiza un cargo a su cuenta con el
			total por pagar, si no se tiene saldo suficiente, el cliente debera de pasar a realizar
			un abono a cuenta en ventanilla */
		SET Var_MontoPendiente := (SELECT MontoPendiente FROM CLICOBROSPROFUN WHERE ClienteID = Par_ClienteID);
		SET Var_MontoPendiente := IFNULL(Var_MontoPendiente, Decimal_Cero);

		IF(Var_MontoPendiente > Decimal_Cero)THEN
			SET VarMontoCobPROFUN := Var_MontoPendiente; /* Si el monto es mayor que cero se guarda como posible cobrado*/
			IF(Par_Poliza = Entero_Cero) THEN
				SET Par_AltaEncPoliza 	:= AltaEncPolizaSI;
			ELSE
				SET Par_AltaEncPoliza := AltaEncPolizaNO;
			END IF;
			/* Proceso  que realiza el cargo a cuenta  por concepto de PROFUN*/
			CALL CLICOBROSPROFUNPRO(
				Par_ClienteID,		Par_Fecha,			Var_MontoPendiente,		Par_AltaEncPoliza,	Salida_NO,
				Par_NumErr,			Par_ErrMen,			Par_Poliza,				Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			/*se compara para saber si hubo error */
			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_MontoPendiente 	:= (SELECT MontoPendiente FROM CLICOBROSPROFUN WHERE ClienteID = Par_ClienteID);
			SET Var_MontoPendiente 	:= IFNULL(Var_MontoPendiente, Decimal_Cero);
			SET VarMontoCobPROFUN	:= VarMontoCobPROFUN - Var_MontoPendiente;
			IF(VarMontoCobPROFUN > Decimal_Cero)THEN
				/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
				SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
				SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
				IF(Var_ClienteIDProtec = Entero_Cero) THEN
					INSERT INTO PROTECCIONES (
						ClienteID,				ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,		InteresCap,
						InteresRetener,			CobradoPROFUN,			TotalHaberes,		TotalAdeudoCre,		AplicaPROFUN,
						ApliCASERVIFUN,			AplicaProtecCre,		AplicaProtecAho,	MontoPROFUN,		MontoSERVIFUN,
						MontoProtecCre,			MontoProtecAho,			TotalBeneAplicado,	SaldoFavorCliente,	EmpresaID,
						Usuario,				FechaActual,			DireccionIP,		ProgramaID,			Sucursal,
						NumTransaccion)
					VALUES(
						Par_ClienteID,			Par_ClienteCancelaID,	Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
						Decimal_Cero,			VarMontoCobPROFUN, 		Decimal_Cero,		Decimal_Cero,		Var_NO,
						Var_NO,					Var_NO,					Var_NO,				Decimal_Cero,		Decimal_Cero,
						Decimal_Cero,			Decimal_Cero,			Decimal_Cero,		Decimal_Cero,		Par_EmpresaID,
						Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				ELSE
					UPDATE PROTECCIONES P SET
						P.CobradoPROFUN		= VarMontoCobPROFUN,
						P.SaldoFavorCliente	= SaldoFavorCliente - VarMontoCobPROFUN,
						P.ClienteCancelaID = Par_ClienteCancelaID
					WHERE	P.ClienteID		= Par_ClienteID;

					/*se actualiza la tabla de PROTECCIONESCTA */
					TRUNCATE TMPCUENTASCANCELCLI;
					INSERT INTO `TMPCUENTASCANCELCLI`	(
						`CuentaAhoID`,					`SucursalOrigen`,				`TipoPersona`,				`MonedaID`,					`TipoCuentaID`,
						`SaldoIniMes`,					`SaldoProm`,					`TasaInteres`,				`InteresesGen`,				`ISR`,
						`TasaISR`,						`GeneraInteres`,				`TipoInteres`,				`PagaISR`,					`ClienteID`,
						`Saldo`)
					SELECT
						CA.CuentaAhoID,		Cli.SucursalOrigen,		Cli.TipoPersona,	CA.MonedaID,		CA.TipoCuentaID,
						CA.SaldoIniMes,		CA.SaldoProm,			CA.TasaInteres,  	CA.InteresesGen,	CASE WHEN  (Var_ISR_pSocio = SI_Isr_Socio)
																											THEN
																												CA.ISRReal
																											ELSE
																											CA.ISR
																											END AS ISR,
						SU.TasaISR,			Cadena_Vacia,			Cadena_Vacia,		Cli.PagaISR,		CA.ClienteID,
						CA.Saldo
					FROM 	CUENTASAHO		CA,
							CLIENTES		Cli,
							SUCURSALES		SU
						WHERE	(CA.Estatus 		= 'B'
						 OR		CA.Estatus 			= 'A')
						 AND 	CA.ClienteID  		= Cli.ClienteID
						 AND 	Cli.SucursalOrigen 	= SU.SucursalID
						 AND 	CA.ClienteID 		= Par_ClienteID;

					/*se guarda un respaldo en la tabla de PROTECCIONESCTA*/
					UPDATE PROTECCIONESCTA P ,
							TMPCUENTASCANCELCLI T SET
							P.TotalHaberes		= T.Saldo
					WHERE	P.ClienteID		= Par_ClienteID
					 AND 	P.CuentaAhoID	= T.CuentaAhoID;
				END IF;
			END IF;


			--
			IF(Var_MontoPendiente > Decimal_Cero)THEN
				SET Par_NumErr	:= '008';
				SET Par_ErrMen	:= CONCAT('El safilocale.cliente Tiene Monto Pendiente de Pago por Mutuales, <br>favor de pasar a ventanilla a realizar un abono a cuenta por: $ ',
										CONVERT(format(Var_MontoPendiente,2),CHAR),'.');
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;
	/* ************************* */

	/* ===============0 SECCION PARA REALIZAR LA CANCELACION DEL REGISTRO PROFUN 0===============*/
	IF(Par_CancelaPROFUN = Var_Si ) THEN
		IF EXISTS (SELECT ClienteID FROM CLIENTESPROFUN WHERE ClienteID = Par_ClienteID AND Estatus IN ('R','A','I')) THEN
			SET Var_FechaSis	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			CALL CLIENTESPROFUNACT(
				Par_ClienteID,		Var_FechaSis,			Aud_Usuario,		Aud_Sucursal,		Cancelar_PROFUN,
				Salida_NO,			Par_NumErr,			 	Par_ErrMen,			Par_EmpresaID,    	Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP, 		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;
	/* *************************** */

	/* SE VALIDA SI SE REALIZA LA SECCION QUE REALIZA EL FINIQUITO DE SUS CREDITOS
		EN ESTA SECCION SOLO SE PUEDEN FINIQUITAR CREDITOS CON LOS SALDOS DE SUS CUENTAS. SI ESTAS NO  ALCANZAN A CUBRIR EL MONTO
		LA SOLICITUD DE CANCELACION NO SE REALIZA.*/
	IF(Par_FiniquitoCre = Var_Si ) THEN
		/* Se obtiene el total de su deuda de los creditos */
		SET VarTotalDeudaCre := (SELECT SUM(FUNCIONTOTDEUDACRE(CreditoID))
									FROM CREDITOS
									WHERE	ClienteID = Par_ClienteID
									 AND	(Estatus	= Est_Vigente
									 OR 	Estatus		= Est_Vencido));
		SET VarTotalDeudaCre := IFNULL(VarTotalDeudaCre, Decimal_Cero);
		/* si el cliente tiene adeudo de algun credito se valida que el monto pueda
			cubrirse en su totalidad con el saldo de sus cuentas.*/
		IF(VarTotalDeudaCre > Decimal_Cero)THEN
			SET VarSaldoTotalCue	:= (SELECT SUM(Saldo)	/* saldo de la cuenta*/
											FROM CUENTASAHO
											WHERE ClienteID = Par_ClienteID);
			SET VarSaldoTotalCue	:= IFNULL(VarSaldoTotalCue, Decimal_Cero);

			IF(VarSaldoTotalCue < VarTotalDeudaCre)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := CONCAT('El safilocale.cliente ',Par_ClienteID,' no Alcanza Cubrir el Adeudo de sus Creditos con el Saldo de las Cuentas.');
				SET varControl	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;

			OPEN  cursorCuentasConSaldo; /* se abre CURSOR para obtener las cuentas activas del cliente con saldo disponible mayor a cero */
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP
					FETCH cursorCuentasConSaldo INTO
						VarCuentaAhoID,		VarSaldoDispon;

					OPEN  cursorCreditosConAdeudo; /* CURSOR para obtener los creditos que presentan adeudos */
					BEGIN
						DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
						CICLOANI:LOOP
							FETCH cursorCreditosConAdeudo INTO
								VarCreditoID,	VarTotalAdeudo,	VarExigible,	VarMonedaID;
							/* se compara si el saldo disponible alcanza a cubri el total del adeudo del credito para poder finiquitarlo*/
							SET VarSaldoDispon	:= (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID = VarCuentaAhoID);
							IF(VarSaldoDispon >= VarTotalAdeudo )THEN
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;

								CALL PAGOCREDITOPRO(	/* sp para aplicar el pago de credito con finiquito */
									VarCreditoID,		VarCuentaAhoID,		VarTotalAdeudo,		VarMonedaID,		EsPrePagoNo,
									FiniquitoSI,		Par_EmpresaID,		Salida_NO,			Par_AltaEncPoliza,	Var_MontoPago,
									Par_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Cadena_Vacia,
									OrigenPago,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
							ELSE
								/* si existe un saldo exigible */
								IF(VarExigible > Decimal_Cero) THEN
									IF(Par_Poliza = Entero_Cero) THEN
										SET Par_AltaEncPoliza := AltaEncPolizaSI;
									ELSE
										SET Par_AltaEncPoliza := AltaEncPolizaNO;
									END IF;
									CALL PAGOCREDITOPRO(	/* sp para aplicar el pago de credito del total exigible */
										VarCreditoID,		VarCuentaAhoID,		VarExigible,		VarMonedaID,		EsPrePagoNo,
										FiniquitoNo,		Par_EmpresaID,		Salida_NO,			Par_AltaEncPoliza,	Var_MontoPago,
										Par_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Cadena_Vacia,
										OrigenPago,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
									IF(Par_NumErr != Entero_Cero)THEN
										LEAVE CICLOANI;
									END IF;
								END IF;
								SET VarSaldoDispon	:= (SELECT SaldoDispon FROM CUENTASAHO WHERE CuentaAhoID = VarCuentaAhoID);
								SET VarPendientePag := FUNCIONTOTDEUDACRE(VarCreditoID);
								SET VarPendientePag := IFNULL(VarPendientePag, Decimal_Cero);
								/* si aun tiene adeudo de credito  */
								IF(VarSaldoDispon > Decimal_Cero AND VarPendientePag > Decimal_Cero) THEN
									IF(Par_Poliza = Entero_Cero) THEN
										SET Par_AltaEncPoliza := AltaEncPolizaSI;
									ELSE
										SET Par_AltaEncPoliza := AltaEncPolizaNO;
									END IF;
									CALL PREPAGOCREDITOPRO( /* sp para realizar un prepago de credito */
										VarCreditoID,		VarCuentaAhoID,		VarSaldoDispon,		VarMonedaID,		Par_EmpresaID,
										Salida_NO,			Par_AltaEncPoliza,	Var_MontoPago,		Par_Poliza,			Par_NumErr,
										Par_ErrMen,			Par_Consecutivo,	Cadena_Vacia,       OrigenPago,			RespaldaCredSI,
										Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);
									IF(Par_NumErr != Entero_Cero)THEN
										LEAVE CICLOANI;
									END IF;
								END IF;
							END IF;

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
						END LOOP CICLOANI;
					END;
					CLOSE cursorCreditosConAdeudo; /* CURSOR para obtener los creditos que presentan adeudos */

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE CICLO;
					END IF;
				END LOOP CICLO;
			END;
			CLOSE cursorCuentasConSaldo; /* se cierra CURSOR para obtener las cuentas activas del cliente con saldo disponible mayor a cero */
		END IF;
	END IF;

	/* *********************************************************************************************
		SE VALIDA SI SE REALIZARA LA SECCION QUE TRASPASA EL SALDO DE LAS CUENTAS DE LOS CLIENTES
		A UNA CUENTA CONTABLE ********************************************************************** */
	IF(Par_MoverSaldoCuentas = Var_Si ) THEN
		TRUNCATE TMPCUENTASCANCELCLI;
		INSERT INTO `TMPCUENTASCANCELCLI`	(
						`CuentaAhoID`,					`SucursalOrigen`,				`TipoPersona`,				`MonedaID`,					`TipoCuentaID`,
						`SaldoIniMes`,					`SaldoProm`,					`TasaInteres`,				`InteresesGen`,				`ISR`,
						`TasaISR`,						`GeneraInteres`,				`TipoInteres`,				`PagaISR`,					`ClienteID`,
						`Saldo`)
		SELECT
			CA.CuentaAhoID,		Cli.SucursalOrigen,		Cli.TipoPersona,	CA.MonedaID,		CA.TipoCuentaID,
			CA.SaldoIniMes,		CA.SaldoProm,			CA.TasaInteres,  	CA.InteresesGen,	CASE WHEN  (Var_ISR_pSocio = SI_Isr_Socio)
																											THEN
																												CA.ISRReal
																											ELSE
																											CA.ISR
																											END AS ISR,
			SU.TasaISR,			Cadena_Vacia,			Cadena_Vacia,		Cli.PagaISR,		CA.ClienteID,
			CA.Saldo
		FROM 	CUENTASAHO		CA,
				CLIENTES		Cli,
				SUCURSALES		SU
			WHERE	(CA.Estatus 		= 'B'
			 OR		CA.Estatus 			= 'A')
			 AND 	CA.ClienteID  		= Cli.ClienteID
			 AND 	Cli.SucursalOrigen 	= SU.SucursalID
			 AND 	CA.ClienteID 		= Par_ClienteID;

		/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
		SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONESCTA WHERE ClienteID = Par_ClienteID LIMIT 1);
		SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
		IF(Var_ClienteIDProtec = Entero_Cero) THEN
			DELETE FROM PROTECCIONESCTA WHERE  ClienteID = Par_ClienteID;
			/*se guarda un respaldo en la tabla de PROTECCIONESCTA*/
			INSERT INTO PROTECCIONESCTA(
				ClienteID,		CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesCap,
				InteresRetener,	TotalHaberes,	EmpresaID,		Usuario,		FechaActual,
				DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion)
			SELECT
				Par_ClienteID,	CuentaAhoID,	TipoCuentaID,	Saldo,			InteresesGen,
				ISR,			Saldo,			Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
			FROM TMPCUENTASCANCELCLI
				WHERE ClienteID = Par_ClienteID;
		END IF;

		/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
		SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
		SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
		IF(Var_ClienteIDProtec = Entero_Cero) THEN
			INSERT INTO PROTECCIONES (
				ClienteID,				ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
				InteresRetener,			TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	ApliCASERVIFUN,
				AplicaProtecCre,		AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
				MontoProtecAho,			TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
			SELECT
				Par_ClienteID,			Par_ClienteCancelaID,	SUM(Saldo),			Decimal_Cero,	SUM(InteresesCap),
				SUM(InteresRetener),	SUM(TotalHaberes),		Decimal_Cero,		Var_NO,			Var_NO,
				Var_NO,					Var_NO,					Decimal_Cero,		Decimal_Cero,	Decimal_Cero,
				Decimal_Cero,			Decimal_Cero,			SUM(TotalHaberes),			Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
			FROM PROTECCIONESCTA
			WHERE ClienteID = Par_ClienteID
			GROUP BY ClienteID;
		ELSE
			UPDATE PROTECCIONES P,
				(SELECT SUM(Saldo) AS Saldo, SUM(InteresesCap) AS InteresesCap, SUM(InteresRetener) AS InteresRetener , SUM(TotalHaberes) AS TotalHaberes
					FROM  PROTECCIONESCTA PC WHERE PC.ClienteID	= Par_ClienteID GROUP BY ClienteID ) AS PC
				SET
				P.TotalSaldoOriCap	= PC.Saldo,
				P.InteresCap		= PC.InteresesCap,
				P.InteresRetener	= PC.InteresRetener,
				P.TotalHaberes		= PC.TotalHaberes,
				P.SaldoFavorCliente	= PC.TotalHaberes,
				P.ClienteCancelaID = Par_ClienteCancelaID
			WHERE	P.ClienteID		= Par_ClienteID;
		END IF;


		OPEN  cursorCtasCliente; /* se abre CURSOR para hacer EL PAGO DE RENDIMIENTO Y RETENCION DE IMPUESTO */
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLO:LOOP
				FETCH cursorCtasCliente  INTO
					VarCuentaAhoID,		VarSucursalOrigen,	VarTipoPersona,		VarMonedaID,		VarTipoCuentaID,
					VarSaldoIniMes,		VarSaldoProm,		VarTasaInteres,		VarInteresesGen,	VarISR,
					VarTasaISR,			VarGeneraInteres,	VarTipoInteres,		VarPagaISR,			VarSaldo;

			IF(Par_Poliza = Entero_Cero) THEN
				SET Par_AltaEncPoliza := AltaEncPolizaSI;
				SET Var_DescripcCon		:= DesConcepConta;
			ELSE
				SET Par_AltaEncPoliza := AltaEncPolizaNO;
			END IF;

			IF( VarSaldo > Decimal_Cero)THEN
				/* se valida si el registro ya existe en la tabla PROTECCIONES, si no existe se agrega, si existe se actualiza */
				SET Var_ClienteIDProtec	:= (SELECT ClienteID FROM PROTECCIONES WHERE ClienteID = Par_ClienteID);
				SET Var_ClienteIDProtec	:= IFNULL(Var_ClienteIDProtec, Entero_Cero);
				IF(Var_ClienteIDProtec = Entero_Cero) THEN
					INSERT INTO PROTECCIONES (
						ClienteID,			ClienteCancelaID,		TotalSaldoOriCap,	ParteSocial,	InteresCap,
						InteresRetener,		TotalHaberes,			TotalAdeudoCre,		AplicaPROFUN,	ApliCASERVIFUN,
						AplicaProtecCre,	AplicaProtecAho,		MontoPROFUN,		MontoSERVIFUN,	MontoProtecCre,
						MontoProtecAho,		TotalBeneAplicado,		SaldoFavorCliente,	EmpresaID,		Usuario,
						FechaActual,		DireccionIP,			ProgramaID,			Sucursal,		NumTransaccion)
					SELECT
						Par_ClienteID,		Par_ClienteCancelaID,	SUM(Saldo),			Decimal_Cero,	Decimal_Cero,
						Decimal_Cero,		SUM(TotalHaberes),		Decimal_Cero,		Var_NO,			Var_NO,
						Var_NO,				Var_NO,					Decimal_Cero,		Decimal_Cero,	Decimal_Cero,
						Decimal_Cero,		Decimal_Cero,			SUM(TotalHaberes),	Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion
					FROM PROTECCIONESCTA
					WHERE ClienteID = Par_ClienteID
					GROUP BY ClienteID;
				ELSE
					UPDATE PROTECCIONES P,
							(SELECT SUM(PC.Saldo) AS Saldo , SUM(TotalHaberes) AS TotalHaberes
								FROM  PROTECCIONESCTA PC WHERE PC.ClienteID	= Par_ClienteID GROUP BY ClienteID ) AS PC
					SET
						P.TotalSaldoOriCap 	= PC.Saldo,
						P.TotalHaberes		= PC.TotalHaberes,
						P.SaldoFavorCliente	= PC.TotalHaberes,
						P.ClienteCancelaID = Par_ClienteCancelaID
					WHERE	P.ClienteID		= Par_ClienteID;
				END IF;

				SET Var_CentroCostosID := FNCENTROCOSTOS(VarSucursalOrigen);

				/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
				CALL CONTACLICANCELPRO(
					VarCuentaAhoID,			Par_ClienteID,		Par_Fecha,			VarSaldo,			DesConcepConta,
					VarMonedaID,			VarCuentaAhoID,		VarSucursalOrigen,	Par_AltaEncPoliza,	Par_ConceptoCon,
					Nat_Cargo,				Nat_Cargo,			Var_MovCancel,		ConAhoPasivo,		Var_SI,
					Var_SI,					TipoInsCuenta,		VarCuentaAhoID,		Var_CuentaConta,	Decimal_Cero,
					VarSaldo,				Var_CentroCostosID,	Var_NO,				Entero_Cero,		Entero_Cero,
					Entero_Cero,			Cadena_Vacia,		Entero_Cero, 		Cadena_Vacia,		Cadena_Vacia,
					Entero_Cero, 			Entero_Cero, 		Cadena_Vacia,		Par_NumErr,			Par_ErrMen,
					Par_Poliza,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE CICLO;
				END IF;

			END IF;

			/* *********************************************************************************************
				VALIDA SI SE HARA LA CANCELACION DE TODAS LAS CUENTAS DEL CLIENTE  ************************* */
			IF(Par_CancelarCuenta = Var_Si )THEN
				UPDATE CUENTASAHO SET
					UsuarioCanID	= Aud_Usuario,
					FechaCan		= Par_Fecha,
					MotivoCan		= DesConcepConta,
					Estatus			= Est_Cancelada,

					EmpresaID		= Par_EmpresaID,
					Usuario			= Aud_Usuario,
					FechaActual 	= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID  	= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE CuentaAhoID 	= VarCuentaAhoID;

				UPDATE CUENTASTRANSFER SET
					Estatus		= Nat_Bloqueo
				WHERE ClienteDestino = Par_ClienteID;
			END IF;

			END LOOP CICLO;
		END;
		CLOSE cursorCtasCliente; /* se abre cierra para hacer EL PAGO DE RENDIMIENTO Y RETENCION DE IMPUESTO */

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	/* *********************************************************************************************
		SE VALIDA SI SE REALIZARA LA INACTIVACION DEL SOCIO
							********************************************************************** */
	IF(Par_InactivaCte = Var_Si ) THEN
		/** REGISTRO EN LA BITÁCORA DE ACTIVACIONES E INACTIVACIONES, ANTES DE LA ACTUALIZACION
		 ** DE ESTATUS DEL CLIENTE.*/
		CALL BITACTIVACIONESCTESALT(
			Par_ClienteID,		Var_NO,				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Var_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		UPDATE CLIENTES
		SET Estatus 	   = Est_Inactivo,
			TipoInactiva   = Par_MotivoActivaID,
			MotivoInactiva = Par_Comentarios,
			FechaBaja  	   = Par_Fecha, /*Se actualiza la fecha de baja  del cliente en momento de inactivacion*/

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual 	= Aud_FechaActual,
			DireccionIP 	= Aud_DireccionIP,
			ProgramaID  	= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE ClienteID = Par_ClienteID;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Proceso Realizado Exitosamente.');
		SET varControl	:= 'clienteID';
	END IF;


	/* *********************************************************************************************
		SE VALIDA SI SE REALIZARA EL PAGO DE LOS CREDITOS CUANDO LA SOLICITUD LA REALIZA
		EL AREA DE PROTECCIONES, ESTA SECCION DEBE SE LLAMARSE CUANDO SE AUTORIZA LA SOLICITUD
		DE CANCELACION DE SOCIO.
							 ********************************************************************** */
	IF(Par_PagoCreProtec = Var_Si ) THEN
		SET Var_Cancelacion := "CLIENTESCANCELAPRO";

		/*se obtiene el monto que tiene el cliente a favor*/
		SELECT	PR.SaldoFavorCliente,	CC.ApliCASEguro
		 INTO	VarSaldoTotalCue,		Var_AplicaSeguro
			FROM	PROTECCIONES 	PR,
					CLIENTESCANCELA CC
		WHERE	CC.ClienteID = PR.ClienteID
		 AND	PR.ClienteID = Par_ClienteID
		 AND 	CC.ClienteCancelaID = Par_ClienteCancelaID;

		SELECT	SucursalOrigen
		 INTO	VarSucursalOrigen
			FROM CLIENTES
			WHERE ClienteID = Par_ClienteID;
		SET Var_FechaSis	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		SET VarSaldoTotalCue := IFNULL(VarSaldoTotalCue,Decimal_Cero);

		UPDATE PROTECCIONES SET
			TotalAdeudoCre		= Decimal_Cero
		WHERE ClienteID = Par_ClienteID;

		OPEN  cursorCreditosConAdeudoSinIva; /* CURSOR para obtener los creditos que presentan adeudos */
		BEGIN
			DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
			CICLOANI:LOOP
				FETCH cursorCreditosConAdeudoSinIva INTO
					VarCreditoID,	VarTotalAdeudo,		VarExigible,	VarMonedaID,		Var_MontoProCred,
					VarCuentaAhoID,	Var_ProductoCreID,	Var_ClasifCre,	Var_SubClasifID,	VarTotalAdeudoIva;
				SET VarDescripMov:= "PAGO DE CREDITO";

				-- Obtenemos la ULTIMA AMORTIZACION.
				SET Var_UltimaAmor	:= (SELECT MAX(AmortizacionID)
											FROM AMORTICREDITO
											WHERE	CreditoID	=	VarCreditoID
												AND	FechaInicio	<=	Var_FechaSis);

				/* se valida si aplica la cancelacion Seguro */
				IF(Var_AplicaSeguro = Var_Si AND Var_MontoProCred > Decimal_Cero)THEN /* si aplica el pago de credito sera sin ivas*/
					IF(VarTotalAdeudo <= Var_MontoProCred )THEN/* si cubre con el seguro el monto que adeuda sin el iva */
						IF(Par_Poliza = Entero_Cero) THEN
							SET Par_AltaEncPoliza := AltaEncPolizaSI;
						ELSE
							SET Par_AltaEncPoliza := AltaEncPolizaNO;
						END IF;
						#Determinamos el Centro de Costos.
						IF LOCATE(For_SucOrigen, Var_CCProtecAhorro) > Entero_Cero THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						ELSE
							IF LOCATE(For_SucCliente, Var_CCProtecAhorro) > Entero_Cero THEN

									IF (Var_SucCliente > Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF; -- Sucursal del Cte
						END IF;
						CALL PAGOCREDITOCONTAPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
							VarCreditoID,		Var_CtaConProCre,		Var_CentroCostosID,	VarTotalAdeudo,		VarMonedaID,
							FiniquitoSI,		NO_CobraLiqAnt,			NO_PagaIva,			Par_EmpresaID,		Salida_NO,
							Par_AltaEncPoliza,	Var_MontoPago,			Var_MontoIVAInt,	Var_MontoIVAMora,	Var_MontoIVAComi,
							Par_Poliza,			OrigenPago,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
							Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE CICLOANI;
						END IF;

                        -- SE ACTUALIZA EL SALDO DEL CREDITO
						UPDATE PROTECCIONES SET
							TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoPago
						WHERE ClienteID = Par_ClienteID;

						IF(Par_Poliza = Entero_Cero) THEN
							SET Par_AltaEncPoliza := AltaEncPolizaSI;
						ELSE
							SET Par_AltaEncPoliza := AltaEncPolizaNO;
						END IF;

						IF(Var_MontoIVAInt > Entero_Cero)THEN
							/* Llamada a sp de CONTACREDITOSPRO para meter movimiento operativo */
						   CALL  CONTACREDITOPRO ( /*MOVIMIENTO OPERATIVO DE INTERES ORDINARIO */
								VarCreditoID,			Var_UltimaAmor,		VarCuentaAhoID,		Par_ClienteID,		Par_Fecha,
								Par_Fecha,   			Var_MontoIVAInt,	VarMonedaID,		Var_ProductoCreID,	Var_ClasifCre,
								Var_SubClasifID,		VarSucursalOrigen,	VarDescripMov,		VarCreditoID,		Par_AltaEncPoliza,
								Entero_Cero,			Par_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Con_IVAInteres,
								Mov_IVAInteres,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Cadena_Vacia,			/*Var_NO,*/				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
								Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Var_Cancelacion,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;

						IF(Var_MontoIVAMora > Entero_Cero)THEN
						   CALL  CONTACREDITOPRO ( /*MOVIMIENTO OPERATIVO DE INTERES MORATORIO */
								VarCreditoID,			Var_UltimaAmor,		VarCuentaAhoID,		Par_ClienteID,		Par_Fecha,
								Par_Fecha,   			Var_MontoIVAMora,	VarMonedaID,		Var_ProductoCreID,	Var_ClasifCre,
								Var_SubClasifID,		VarSucursalOrigen,	VarDescripMov,		VarCreditoID,		Par_AltaEncPoliza,
								Entero_Cero,			Par_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Con_IVAMora,
								Mov_IVAIntMora,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Cadena_Vacia,			/*Var_NO,*/				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
								Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Var_Cancelacion,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;

						IF(Var_MontoIVAComi > Entero_Cero)THEN
						   CALL  CONTACREDITOPRO ( /*MOVIMIENTO OPERATIVO DE INTERES COMISIONES */
								VarCreditoID,			Var_UltimaAmor,		VarCuentaAhoID,		Par_ClienteID,		Par_Fecha,
								Par_Fecha,   			Var_MontoIVAComi,	VarMonedaID,		Var_ProductoCreID,	Var_ClasifCre,
								Var_SubClasifID,		VarSucursalOrigen,	VarDescripMov,		VarCreditoID,		Par_AltaEncPoliza,
								Entero_Cero,			Par_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Con_IVAFalPag,
								Mov_IVAComFaPag,		Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Cadena_Vacia,			/*Var_NO,*/				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
								Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Var_Cancelacion,		Aud_Sucursal,		Aud_NumTransaccion);
							/* FIn de llamada a sp de CONTACREDITOSPRO para meter movimiento operativo */
						END IF;

						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
						IF(Var_MontoIVAInt > Decimal_Cero)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
							IF(VarSaldoTotalCue >= Var_MontoIVAInt)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							ELSE
								/* si el total de los haberes no cubre el iva  entonces se cobra  lo que se tenga en el saldo disponible
									y el resto se pasa a una cuenta de perdida.*/
								SET Var_MontoIVAIntPer	:= Var_MontoIVAInt-VarSaldoTotalCue; /* monto que se ira a la cuenta de perdida*/
								SET Var_MontoIVAInt		:= Var_MontoIVAIntPer;
								SET Var_CuentaConta		:= Var_CtaPerdida;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCContaPerdida) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCContaPerdida) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							END IF;

							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
								VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAInt,	VarDescripMov,
								VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
								Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
								Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	Var_MontoIVAInt,
								Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
								Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
								Con_IVAInteres,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
								Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
							-- SE ACTUALIZA EL MONTO COBRADO DE IVA
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAInt,
								TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAInt
							WHERE ClienteID = Par_ClienteID;

							IF(VarSaldoTotalCue > Entero_Cero AND Var_MontoIVAIntPer > Entero_Cero)THEN /* se cobra el proporcional del saldo de los haberes */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
									VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAIntPer,	VarDescripMov,
									VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
									Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	VarSaldoTotalCue,
									Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
									Var_ProductoCreID,	Var_ClasIFCre,			Var_SubClasIFID,	Var_Si,				Var_NO,
									Con_IVAInteres,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
									Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAIntPer,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAIntPer
								WHERE ClienteID = Par_ClienteID;
							END IF;

						END IF; /* fin cobrar iva mayor a cero */


						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID); -- actualizas saldo disponible
						IF(Var_MontoIVAMora > Decimal_Cero )THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
							IF(VarSaldoTotalCue >= Var_MontoIVAMora)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							ELSE
								/* si el total de los haberes no cubre el iva  entonces se cobra  lo que se tenga en el saldo disponible
									y el resto se pasa a una cuenta de perdida.*/
								SET Var_MontoIVAMoraPer	:= Var_MontoIVAMora-VarSaldoTotalCue; /* monto que se ira a la cuenta de perdida*/
								SET Var_MontoIVAMora	:= Var_MontoIVAMoraPer;
								SET Var_CuentaConta		:= Var_CtaPerdida;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCContaPerdida) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCContaPerdida) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							END IF;
							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
								VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAMora,	VarDescripMov,
								VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
								Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
								Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	Var_MontoIVAMora,
								Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
								Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
								Con_IVAMora,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
								Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
							/* se actualiza el saldo a favor del cliente */
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAMora,
								TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAMora
							WHERE ClienteID = Par_ClienteID;

							IF(VarSaldoTotalCue > Entero_Cero AND Var_MontoIVAMoraPer > Entero_Cero)THEN /* se cobra el proporcional del saldo de los haberes */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
									VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAMoraPer,	VarDescripMov,
									VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
									Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	VarSaldoTotalCue,
									Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
									Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
									Con_IVAMora,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
									Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAMoraPer,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAMoraPer
								WHERE ClienteID = Par_ClienteID;
							END IF;
						END IF;

						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
						IF(Var_MontoIVAComi > Decimal_Cero)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
							IF(VarSaldoTotalCue >= Var_MontoIVAComi)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							ELSE
								/* si el total de los haberes no cubre el iva  entonces se cobra  lo que se tenga en el saldo disponible
									y el resto se pasa a una cuenta de perdida.*/
								SET Var_MontoIVAComiPer	:= Var_MontoIVAComi-VarSaldoTotalCue; /* monto que se ira a la cuenta de perdida*/
								SET Var_MontoIVAComi	:= Var_MontoIVAComiPer;
								SET Var_CuentaConta		:= Var_CtaPerdida;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCContaPerdida) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCContaPerdida) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							END IF;
							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
								VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAComi,	VarDescripMov,
								VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
								Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
								Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	Var_MontoIVAComi,
								Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
								Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
								Con_IVAFalPag,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
								Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

							/* se actualiza el saldo a favor del cliente */
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAComi,
								TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAComi
							WHERE ClienteID = Par_ClienteID;
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
							IF(VarSaldoTotalCue > Entero_Cero AND Var_MontoIVAComiPer > Entero_Cero)THEN /* se cobra el proporcional del saldo de los haberes */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
									VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAComiPer,	VarDescripMov,
									VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
									Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	VarSaldoTotalCue,
									Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
									Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
									Con_IVAFalPag,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
									Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAComiPer,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAComiPer
								WHERE ClienteID = Par_ClienteID;
								SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
							END IF;
						END IF;
					ELSE /* si no cubre con el seguro el monto que adeuda sin el iva */

						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
						IF(Par_Poliza = Entero_Cero) THEN
							SET Par_AltaEncPoliza := AltaEncPolizaSI;
						ELSE
							SET Par_AltaEncPoliza := AltaEncPolizaNO;
						END IF;
						#Determinamos el Centro de Costos.
						IF LOCATE(For_SucOrigen, Var_CCProtecAhorro) > Entero_Cero THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						ELSE
							IF LOCATE(For_SucCliente, Var_CCProtecAhorro) > Entero_Cero THEN
									IF (Var_SucCliente > Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF; -- Sucursal del Cte
						END IF;
						CALL PAGOCREDITOCONTAPRO(	/* sp para aplicar el pago de credito vs cuenta contable */ -- REV1
							 VarCreditoID,		Var_CtaConProCre,		Var_CentroCostosID,		Var_MontoProCred,	VarMonedaID,
							FiniquitoNO,		NO_CobraLiqAnt,			NO_PagaIva,				Par_EmpresaID,		Salida_NO,
							Par_AltaEncPoliza,	Var_MontoPago,			Var_MontoIVAInt,		Var_MontoIVAMora,	Var_MontoIVAComi,
							Par_Poliza,			OrigenPago,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
							Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);
						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE CICLOANI;
						END IF;
                        -- *
                        -- SE ACTUALIZA EL SALDO DEL CREDITO
						UPDATE PROTECCIONES SET
							TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoPago
						WHERE ClienteID = Par_ClienteID;

						IF(Par_Poliza = Entero_Cero) THEN
							SET Par_AltaEncPoliza := AltaEncPolizaSI;
						ELSE
							SET Par_AltaEncPoliza := AltaEncPolizaNO;
						END IF;
						/* Llamada a sp de CONTACREDITOSPRO para meter movimiento operativo */
						IF(Var_MontoIVAInt > Entero_Cero)THEN
							CALL  CONTACREDITOPRO ( /*MOVIMIENTO OPERATIVO DE INTERES ORDINARIO */
								VarCreditoID,			Var_UltimaAmor,		VarCuentaAhoID,		Par_ClienteID,		Par_Fecha,
								Par_Fecha,				Var_MontoIVAInt,	VarMonedaID,		Var_ProductoCreID,	Var_ClasifCre,
								Var_SubClasifID,		VarSucursalOrigen,	VarDescripMov,		VarCreditoID,		Par_AltaEncPoliza,
								Entero_Cero,			Par_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Con_IVAInteres,
								Mov_IVAInteres,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Cadena_Vacia,			/*Var_NO,*/				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
								Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Var_Cancelacion,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
						IF(Var_MontoIVAMora > Entero_Cero)THEN
						   CALL  CONTACREDITOPRO ( /*MOVIMIENTO OPERATIVO DE INTERES MORATORIO */
								VarCreditoID,			Var_UltimaAmor,		VarCuentaAhoID,		Par_ClienteID,		Par_Fecha,
								Par_Fecha,				Var_MontoIVAMora,	VarMonedaID,		Var_ProductoCreID,	Var_ClasifCre,
								Var_SubClasifID,		VarSucursalOrigen,	VarDescripMov,		VarCreditoID,		Par_AltaEncPoliza,
								Entero_Cero,			Par_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Con_IVAMora,
								Mov_IVAIntMora,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Cadena_Vacia,			/*Var_NO,*/				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
								Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Var_Cancelacion,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
						IF(Var_MontoIVAComi >Entero_Cero)THEN
							CALL  CONTACREDITOPRO ( /*MOVIMIENTO OPERATIVO DE INTERES COMISIONES */
								VarCreditoID,			Var_UltimaAmor,		VarCuentaAhoID,		Par_ClienteID,		Par_Fecha,
								Par_Fecha,   			Var_MontoIVAComi,	VarMonedaID,		Var_ProductoCreID,	Var_ClasifCre,
								Var_SubClasifID,		VarSucursalOrigen,	VarDescripMov,		VarCreditoID,		Par_AltaEncPoliza,
								Entero_Cero,			Par_Poliza,			AltaPolCre_NO,		AltaMovCre_SI,		Con_IVAFalPag,
								Mov_IVAComFaPag,		Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
								Cadena_Vacia,			/*Var_NO,*/				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
								Par_EmpresaID,			Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Var_Cancelacion,		Aud_Sucursal,		Aud_NumTransaccion);
						END IF;
						/* FIn de llamada a sp de CONTACREDITOSPRO para meter movimiento operativo */

						IF(Var_MontoIVAInt > Decimal_Cero)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
							IF(VarSaldoTotalCue >= Var_MontoIVAInt)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							ELSE
								/* si el total de los haberes no cubre el iva  entonces se cobra  lo que se tenga en el saldo disponible
									y el resto se pasa a una cuenta de perdida.*/
								SET Var_MontoIVAIntPer	:= Var_MontoIVAInt-VarSaldoTotalCue; /* monto que se ira a la cuenta de perdida*/
								SET Var_MontoIVAInt		:= Var_MontoIVAIntPer;
								SET Var_CuentaConta		:= Var_CtaPerdida;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCContaPerdida) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCContaPerdida) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							END IF;

							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
								VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAInt,	VarDescripMov,
								VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
								Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
								Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	Var_MontoIVAInt,
								Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
								Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
								Con_IVAInteres,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
								Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
							/* se actualiza el saldo a favor del cliente */
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAInt,
								TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAInt
							WHERE ClienteID = Par_ClienteID;

							IF(VarSaldoTotalCue >Entero_Cero AND Var_MontoIVAIntPer >Entero_Cero )THEN /* se cobra el proporcional del saldo de los haberes */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
									VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAIntPer,	VarDescripMov,
									VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
									Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	VarSaldoTotalCue,
									Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
									Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
									Con_IVAInteres,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
									Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAIntPer,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAIntPer
								WHERE ClienteID = Par_ClienteID;
							END IF;
						END IF;

						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
						IF(Var_MontoIVAMora > Decimal_Cero)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
							IF(VarSaldoTotalCue >= Var_MontoIVAMora)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							ELSE
								/* si el total de los haberes no cubre el iva  entonces se cobra  lo que se tenga en el saldo disponible
									y el resto se pasa a una cuenta de perdida.*/
								SET Var_MontoIVAMoraPer	:= Var_MontoIVAMora-VarSaldoTotalCue; /* monto que se ira a la cuenta de perdida*/
								SET Var_MontoIVAMora	:= Var_MontoIVAMoraPer;
								SET Var_CuentaConta		:= Var_CtaPerdida;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCContaPerdida) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCContaPerdida) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							END IF;

							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
								VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAMora,	VarDescripMov,
								VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
								Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
								Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	Var_MontoIVAMora,
								Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
								Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
								Con_IVAMora,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
								Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
							/* se actualiza el saldo a favor del cliente */
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAMora,
								TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAMora
							WHERE ClienteID = Par_ClienteID;

							IF(VarSaldoTotalCue > Entero_Cero AND Var_MontoIVAMoraPer  > Entero_Cero )THEN /* se cobra el proporcional del saldo de los haberes */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
									VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAMoraPer,	VarDescripMov,
									VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
									Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	VarSaldoTotalCue,
									Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
									Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
									Con_IVAMora,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
									Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAMoraPer,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAMoraPer
								WHERE ClienteID = Par_ClienteID;
							END IF;
						END IF;

						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
						IF(Var_MontoIVAComi > Decimal_Cero)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
							IF(VarSaldoTotalCue >= Var_MontoIVAComi)THEN/*se compara si el saldo de los haberes cubre los ivas que se deben de pagar */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							ELSE
								/* si el total de los haberes no cubre el iva  entonces se cobra  lo que se tenga en el saldo disponible
									y el resto se pasa a una cuenta de perdida.*/
								SET Var_MontoIVAComiPer	:= Var_MontoIVAComi-VarSaldoTotalCue; /* monto que se ira a la cuenta de perdida*/
								SET Var_MontoIVAComi	:= Var_MontoIVAComiPer;
								SET Var_CuentaConta		:= Var_CtaPerdida;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCContaPerdida) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCContaPerdida) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
							END IF;

							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
								VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAComi,	VarDescripMov,
								VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
								Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
								Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	Var_MontoIVAComi,
								Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
								Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
								Con_IVAFalPag,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
								Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							END IF;
							/* se actualiza el saldo a favor del cliente */
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAComi,
								TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAComi
							WHERE ClienteID = Par_ClienteID;
							IF(VarSaldoTotalCue > Entero_Cero AND Var_MontoIVAComiPer > Entero_Cero  )THEN /* se cobra el proporcional del saldo de los haberes */
								SET Var_CuentaConta		:= Var_CtaContaExHab;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CenCosto := Aud_Sucursal;
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CenCosto := VarSucursalOrigen;
											ELSE
												SET Var_CenCosto := Aud_Sucursal;
											END IF;
									ELSE
										SET Var_CenCosto := Aud_Sucursal;
									END IF; -- Sucursal del Cte
								END IF;
								SET Var_CentroCostosID	:= FNCENTROCOSTOS(Var_CenCosto);
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								CALL CONTACLICANCELPRO(	/* SP QUE REALIZA AFECTACIONS CONTABLES, SE UTILIZA EN EL PROCESO DE CANCELACION DE SOCIO .*/
									VarCuentaAhoID,		Par_ClienteID,			Par_Fecha,			Var_MontoIVAComiPer,	VarDescripMov,
									VarMonedaID,		VarCreditoID,			VarSucursalOrigen,	Par_AltaEncPoliza,	Entero_Cero,
									Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,		Entero_Cero,		Var_NO,
									Var_Si,				TipoInsCliente,			Par_ClienteID,		Var_CuentaConta,	VarSaldoTotalCue,
									Decimal_Cero,		Var_CentroCostosID,		Var_Si,				VarCreditoID,		Entero_Cero,
									Var_ProductoCreID,	Var_ClasifCre,			Var_SubClasifID,	Var_Si,				Var_NO,
									Con_IVAFalPag,		Entero_Cero,			Nat_Abono,			Par_NumErr,			Par_ErrMen,
									Par_Poliza,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoIVAComiPer,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoIVAComiPer
								WHERE ClienteID = Par_ClienteID;
								SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
							END IF;
						END IF; /* fin de cobro de iva de comisiones*/

						/*se obtiene el saldo por cubrir del credito y se trata de cobrar de los haberes del ex socio */
						SET VarTotalAdeudo := FUNCIONTOTDEUDACRE(VarCreditoID);
                        SET VarTotalAdeudo := IFNULL(VarTotalAdeudo, Decimal_Cero);
						SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
                        SET VarSaldoTotalCue := IFNULL(VarSaldoTotalCue, Decimal_Cero);
						IF(IFNULL(VarTotalAdeudo, Decimal_Cero) > Decimal_Cero AND VarSaldoTotalCue > Decimal_Cero )THEN /*si aun queda un monto de adeudo del credito se trata de cobrar de los haberes del exsocio*/ -- REV2
							IF(VarTotalAdeudo <= VarSaldoTotalCue )THEN/* si cubre con el saldo de los haberes el monto que adeuda con el iva */
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;

								/*#Determinamos el Centro de Costos.*/
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
											ELSE
												SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
											END IF;
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF; -- Sucursal del Cte
								END IF;
								CALL PAGOCREDITOCONTAPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
									VarCreditoID,		Var_CtaContaExHab,		Var_CentroCostosID,		VarTotalAdeudo,		VarMonedaID,
									FiniquitoSI,		NO_CobraLiqAnt,			SI_PagaIva,				Par_EmpresaID,		Salida_NO,
									Par_AltaEncPoliza,	Var_MontoPago,			Var_MontoIVAInt,    Var_MontoIVAMora,		Var_MontoIVAComi,
									Par_Poliza,			OrigenPago,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
									Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								END IF;
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoPago - Var_MontoIVAInt - Var_MontoIVAMora - Var_MontoIVAComi,
									TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoPago	+ Var_MontoIVAInt + Var_MontoIVAMora + Var_MontoIVAComi
								WHERE ClienteID = Par_ClienteID;

								SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);

							ELSE
								IF(Par_Poliza = Entero_Cero) THEN
									SET Par_AltaEncPoliza := AltaEncPolizaSI;
								ELSE
									SET Par_AltaEncPoliza := AltaEncPolizaNO;
								END IF;
								#Determinamos el Centro de Costos.
								IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
									SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
								ELSE
									IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
											IF (Var_SucCliente > Entero_Cero) THEN
												SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
											ELSE
												SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
											END IF;
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF; -- Sucursal del Cte
								END IF;
								 CALL PAGOCREDITOCONTAPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
									VarCreditoID,		Var_CtaContaExHab,		Var_CentroCostosID,		VarTotalAdeudo,		VarMonedaID,
									FiniquitoNO,		NO_CobraLiqAnt,			SI_PagaIva,				Par_EmpresaID,		Salida_NO,
									Par_AltaEncPoliza,	Var_MontoPago,			Var_MontoIVAInt,		Var_MontoIVAMora,	Var_MontoIVAComi,
									Par_Poliza,			OrigenPago,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
									Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);
								IF(Par_NumErr != Entero_Cero)THEN
									LEAVE CICLOANI;
								ELSE
									/* se actualiza el saldo a favor del cliente */
									UPDATE PROTECCIONES SET
										SaldoFavorCliente	= SaldoFavorCliente	- Var_MontoPago - Var_MontoIVAInt - Var_MontoIVAMora-Var_MontoIVAComi,
										TotalAdeudoCre		= TotalAdeudoCre	+ Var_MontoPago	+ Var_MontoIVAInt + Var_MontoIVAMora+Var_MontoIVAComi
									WHERE ClienteID = Par_ClienteID;
									SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
								END IF;
							END IF;
						END IF;
					END IF;
				ELSE/* si no aplica  el seguro el pago de credito sera normal */
					IF(VarTotalAdeudoIva <= VarSaldoTotalCue )THEN/* si cubre con el saldo de los haberes el monto que adeuda con el iva */
						IF(Par_Poliza = Entero_Cero) THEN
							SET Par_AltaEncPoliza := AltaEncPolizaSI;
						ELSE
							SET Par_AltaEncPoliza := AltaEncPolizaNO;
						END IF;
						#Determinamos el Centro de Costos.
						IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						ELSE
							IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
									IF (Var_SucCliente > Entero_Cero) THEN
										SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
									ELSE
										SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
									END IF;
							ELSE
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							END IF; -- Sucursal del Cte
						END IF;
						CALL PAGOCREDITOCONTAPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
							VarCreditoID,		Var_CtaContaExHab,		Var_CentroCostosID,		VarTotalAdeudoIva,	VarMonedaID,
							FiniquitoSI,		NO_CobraLiqAnt,			SI_PagaIva,				Par_EmpresaID,		Salida_NO,
							Par_AltaEncPoliza,	Var_MontoPago,			Var_MontoIVAInt,		Var_MontoIVAMora,	Var_MontoIVAComi,
							Par_Poliza,			OrigenPago,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
							Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);
						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE CICLOANI;
						ELSE
							/* se actualiza el saldo a favor del cliente */
							UPDATE PROTECCIONES SET
								SaldoFavorCliente	= SaldoFavorCliente	- VarTotalAdeudoIva,
								TotalAdeudoCre		= TotalAdeudoCre	+ VarTotalAdeudoIva
							WHERE ClienteID = Par_ClienteID;
							SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
						END IF;
					ELSE /*si no cubre con el saldo de los haberes el monto que adeuda con iva */
						IF(VarSaldoTotalCue > Decimal_Cero) THEN
							IF(Par_Poliza = Entero_Cero) THEN
								SET Par_AltaEncPoliza := AltaEncPolizaSI;
							ELSE
								SET Par_AltaEncPoliza := AltaEncPolizaNO;
							END IF;
							#Determinamos el Centro de Costos.
							IF LOCATE(For_SucOrigen, Var_CCHaberesEx) > Entero_Cero THEN
								SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
							ELSE
								IF LOCATE(For_SucCliente, Var_CCHaberesEx) > Entero_Cero THEN
										IF (Var_SucCliente > Entero_Cero) THEN
											SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
										ELSE
											SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
										END IF;
								ELSE
									SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
								END IF; -- Sucursal del Cte
							END IF;
							 CALL PAGOCREDITOCONTAPRO(	/* sp para aplicar el pago de credito vs cuenta contable */
								VarCreditoID,		Var_CtaContaExHab,		Var_CentroCostosID,		VarSaldoTotalCue,	VarMonedaID,
								FiniquitoNO,		NO_CobraLiqAnt,			SI_PagaIva,				Par_EmpresaID,		Salida_NO,
								Par_AltaEncPoliza,	Var_MontoPago,			Var_MontoIVAInt,		Var_MontoIVAMora,	Var_MontoIVAComi,
								Par_Poliza,			OrigenPago,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,
								Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLOANI;
							ELSE
								/* se actualiza el saldo a favor del cliente */
								UPDATE PROTECCIONES SET
									SaldoFavorCliente	= SaldoFavorCliente	- VarSaldoTotalCue,
									TotalAdeudoCre		= TotalAdeudoCre	+ VarSaldoTotalCue
								WHERE ClienteID = Par_ClienteID;
								SET VarSaldoTotalCue := (SELECT	SaldoFavorCliente FROM	PROTECCIONES WHERE ClienteID = Par_ClienteID);
							END IF;
						END IF;
					END IF;
					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE CICLOANI;
					END IF;
				END IF;
			END LOOP CICLOANI;
		END;
		CLOSE cursorCreditosConAdeudoSinIva; /* CURSOR para obtener los creditos que presentan adeudos */

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Proceso Realizado Exitosamente.');
		SET varControl	:= 'clienteID';
	END IF;

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := CONCAT('Proceso Realizado Exitosamente.');
	SET varControl	:= 'clienteID';

END ManejoErrores; #fin del manejador de errores

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 	AS ErrMen,
			varControl	 	AS control,
			Par_ClienteID	AS consecutivo;
END IF;

END TerminaStore$$
