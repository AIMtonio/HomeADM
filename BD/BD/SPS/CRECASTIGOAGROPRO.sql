-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOAGROPRO`;
DELIMITER $$

CREATE PROCEDURE `CRECASTIGOAGROPRO`(
-- =======================================================================
-- SP QUE REALIZA EL PROCESO DE CASTIGO PARA LOS CREDITOS AGROS
-- =======================================================================
	Par_CreditoID     		BIGINT(12),		-- Credito ID
	INOUT Par_PolizaID		BIGINT(20),		-- Parametro de ID Poliza
	Par_MotivoCastigoID 	INT(11),		-- Parametro de  Mov de Castigo
	Par_Observaciones		VARCHAR(500),	-- Parametro de Observaciones referente al Castigo
	Par_TipoCastigo			CHAR(1),		-- Parametro de Tipo de Castigo
    Par_TipoCobranza	    INT,			-- Parametro de Tipo de Cobranza
	Par_AltaEncPoliza       CHAR(1),		-- Parametro de Alta de Encabezado de Poliza
    Par_Salida        		CHAR(1),		-- Parametro de Salida
    INOUT   Par_NumErr 		INT(11),		-- Parametro de Numero de Error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Parametro de Error de Mensaje
	Par_EmpresaID     		INT,			-- Parametro de Auditoria Empresa ID
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Usuario ID
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Sucursal
	Aud_NumTransaccion 		BIGINT(20)		-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CreditoID 		BIGINT(12);			-- Variable Credito ID
DECLARE Var_AmortizacionID	INT(4);				-- Variable ID de Amortizacion
DECLARE Var_SaldoCapVigente	DECIMAL(12,2);		-- Variable de Saldo Capital Vigente
DECLARE Var_SaldoCapAtrasa	DECIMAL(12,2);		-- Varariable de Capital Atrasado
DECLARE Var_SaldoCapVencido	DECIMAL(12,2);		-- Variable de Capital Vencido
DECLARE Var_SaldoCapVenNExi	DECIMAL(12,2);		-- Variable de Capital Vencido no Exigible
DECLARE Var_SaldoInteresOrd	DECIMAL(12,4);		-- Variable de Interes Ordinario
DECLARE Var_SaldoInteresAtr	DECIMAL(12,4);		-- Variable de Interes Atrasado
DECLARE Var_SaldoInteresVen	DECIMAL(12,4);		-- Variable de Interes Vencido
DECLARE Var_SaldoInteresPro	DECIMAL(12,4);		-- Variable de Interes Provisionado
DECLARE Var_SaldoIntNoConta	DECIMAL(12,4);		-- Variable de Interes No Contabilizado
DECLARE Var_SaldoMoratorios	DECIMAL(12,2);		-- Variable de Moratorios
DECLARE Var_SaldoComFaltaPa	DECIMAL(12,2);		-- Variable Saldo Comision por Falta de Pago
DECLARE Var_SaldoOtrasComis	DECIMAL(12,2);		-- Variable de Otras Comisiones
DECLARE Var_SaldoComServGar	DECIMAL(12,2);		-- Variable de Saldo Comision Servicios de Garantia

DECLARE Var_FechaInicio     DATE;				-- Variable de Fecha de Inicio
DECLARE Var_FechaVencim     DATE;				-- Variable de Fecha de Vencimiento
DECLARE Var_FechaExigible   DATE;				-- Variable de Fecha de Exigible
DECLARE Var_AmoEstatus      CHAR(1);			-- Variable a Estatus de la Amortizacion
DECLARE Var_SalMoraVencido	DECIMAL(12,2);		-- Variable de Saldos Moratorios Vencidos
DECLARE Var_SalMoraCarVen	DECIMAL(12,2);		-- Variable de Saldos Moratorios derivado de Cartera Vencida

DECLARE Var_ReservCan   	DECIMAL(14,2);		-- Variable de Reserva
DECLARE Var_ResAnterior 	DECIMAL(14,2);		-- Variable de Reserva Anterior
DECLARE Var_ResCapital  	DECIMAL(14,2);		-- Variable de Reserva de Capital
DECLARE Var_ResInteres  	DECIMAL(14,2);		-- Variable de Reserva de Interes
DECLARE Var_FecAntRes   	DATE;				-- Variable de Fecha
DECLARE Var_MonReservar 	DECIMAL(14,2);		-- Variable monto de Reserva
DECLARE Var_MonLibReser 	DECIMAL(14,2);		-- Variable monto libre de Reserva
DECLARE Var_MonResCapita	DECIMAL(14,2);		-- Variable monto de Reserva Capital
DECLARE Var_MonResIntere	DECIMAL(14,2);		-- Variable monto de Reserva de Interes
DECLARE Mov_AboConta   		INT;				-- Variable de Abono a Cuenta
DECLARE Mov_CarConta    	INT;				-- Variable de Cargo a Cuenta
DECLARE Var_FechaSistema    DATE;				-- Varaible fecha del Sistema
DECLARE Var_FecApl      	DATE;				-- Variable Fecha
DECLARE Var_EsHabil     	CHAR(1);			-- Variable es Habil
DECLARE Var_SucCliente  	INT;				-- Variable Sucursal del Cliente
DECLARE Var_MonedaID    	INT(11);			-- Variable Moneda
DECLARE Var_ProdCreID   	INT;				-- Varaible Producto de Credito ID
DECLARE Var_ClasifCre   	CHAR(1);			-- Varaible de Clasificacion de Credito
DECLARE Var_SubClasifID 	INT;				-- Varaible de Subclasificacion
DECLARE Var_CastigoCap  	DECIMAL(14,2);		-- Variable de Castigo de Capital
DECLARE Var_CastigoInt  	DECIMAL(14,2);		-- Varaible de Castigo de Interes
DECLARE Var_CasIntMora  	DECIMAL(14,2);		-- Variable de Castigo de Moratorios
DECLARE Var_CasAccesor  	DECIMAL(14,2);		-- Varaible de Castigos de Accesorios
DECLARE Var_CasMoraVenc 	DECIMAL(14,2);		-- Variable de Castigos de Moratorios
DECLARE Var_CasInteVenc 	DECIMAL(14,2);		-- Variable de Castigos de Interes Vencido

DECLARE Par_Consecutivo 	BIGINT;				-- Variable consecutivo
DECLARE Var_CreEstatus  	CHAR(1);			-- Variable de Estatus del Credito
DECLARE Var_SucursalCred	INT;				-- Variable de Sucursal del Credito
DECLARE Var_RegContaEPRC	CHAR(1);			-- Variable RegContaEPRC
DECLARE Var_DivideEPRC	  	CHAR(1);			-- Variable DivideEPRC
DECLARE	Var_TotalCastigo	DECIMAL(14,2);		-- Variable Total de Castigo
DECLARE	Var_TipoContaMora	CHAR(1);			-- Variable TipoContaMora
DECLARE	Var_ConIntereCarVen CHAR(1);			-- Variable ConIntereCarVen
DECLARE	Var_CondMoraCarVen	CHAR(1);			-- Variable CondMoraCarVen
DECLARE Var_ConAccesorios	CHAR(1);			-- Variable ConAccesorios
DECLARE Var_DivideCastigo	CHAR(1);			-- Variable DivideCastigo
DECLARE Var_EPRCAdicional	CHAR(1);			-- Variable EPRCAdicional
DECLARE	Var_TotIntVenc		DECIMAL(14,2);		-- Variable de Total de Interes Vencido
DECLARE Var_FecPrimAtraso   DATE;             	-- Variable Fecha de Primer Atraso
DECLARE Var_FecUltPagoCap   DATE; 			  	-- Variable de Fecha de Ultimo Pago Capital
DECLARE Var_FecUltPagoInt   DATE;    		  	-- Varaible de Fecha de Ultimo Pago Interes
DECLARE Var_MonUltPagoCap	DECIMAL(14,2);	  	-- Variable de Monto Ultimo Pago Capital
DECLARE Var_MonUltPagoInt 	DECIMAL(14,2);    	-- Variable de Monto de Ultimo Pago de Interes
DECLARE Var_UltNumTransac	BIGINT;				-- Varaible de Ultimo Numero de Transaccion
DECLARE Var_UltAmortizacionID	INT;			-- Variable de Ultimo ID de Amortizacion
DECLARE Var_TranCastigo		BIGINT;				-- Variable TranCastigo
DECLARE Var_NumAmorti		INT(11);			-- Variable Numero de Amortizaciones
DECLARE Var_LineaCreditoID  BIGINT(20);			-- Numero de Linea

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);			-- Constante Cadena Vacia
DECLARE Fecha_Vacia     	DATE;				-- Constante Fecha Vacia
DECLARE Entero_Cero     	INT;				-- Constante Entero Cero
DECLARE Decimal_Cero    	DECIMAL(12, 2);		-- Constante Decimal _Cero
DECLARE Decimal_Cien    	DECIMAL(12, 2);		-- Constante Decimal Cien 100

DECLARE Esta_Activo     	CHAR(1);			-- Constante Estatus Activo
DECLARE Esta_Cancelado  	CHAR(1);			-- Constante Estatus Cancelado
DECLARE Esta_Inactivo   	CHAR(1);			-- Constante Estatus Inactivo
DECLARE Esta_Vencido    	CHAR(1);			-- Constante Estatus Vencido
DECLARE Esta_Vigente    	CHAR(1);			-- Constante Estatus Vigente
DECLARE Esta_Castigado  	CHAR(1);			-- Constante Estatus Castigado
DECLARE Esta_Pagado     	CHAR(1);			-- Constante Estatus Pagado
DECLARE Esta_Atrasado       CHAR(1);			-- Constante Estatus Atrasado


DECLARE Par_SalidaNO    	CHAR(1);			-- Constante Salida NO
DECLARE Par_SalidaSI    	CHAR(1);			-- Constante Salida SI
DECLARE AltaPoliza_SI   	CHAR(1);			-- Constante Alta de Poliza SI
DECLARE AltaPoliza_NO   	CHAR(1);			-- Constante Alta de Poliza NO
DECLARE AltaPolCre_NO   	CHAR(1);			-- Constante Alta de Poliza de Credito NO
DECLARE AltaPolCre_SI   	CHAR(1);			-- Constante Alta de Poliza de Credito SI
DECLARE AltaMovAho_SI   	CHAR(1);			-- Constante Alta de Movimiento de Ahorro SI
DECLARE AltaMovAho_NO   	CHAR(1);			-- Constante Alta de Movimiento de Ahorro NO
DECLARE AltaMovCre_SI   	CHAR(1);			-- Constante Alta de Movimiento de Credito SI
DECLARE AltaMovCre_NO   	CHAR(1);			-- Constante Alta de Movimiento de Credito NO
DECLARE Con_EstBalance      INT;				-- Constante Estado de Balance
DECLARE Con_EstResultados   INT;				-- Constante Estado de Resultados
DECLARE Con_EstBalanceInt	INT;				-- Constante Estado de Balance Interes
DECLARE	Con_EstResultaInt	INT;				-- Constante Estado de Resultados Interes
DECLARE	Con_CtaPtePrinc		INT;				-- Constante CtaPtePrinc
DECLARE	Con_CtaPteIntere	INT;				-- Constante CtaPteIntere
DECLARE Con_CtaOrdCom   	INT;				-- Constante CtaOrdCom
DECLARE Con_CorComFal   	INT;				-- Constante CorComFal
DECLARE Con_IngresoMora		INT;				-- Constante IngresoMora
DECLARE Con_IngMoraCarVen	INT;				-- Constante IngMoraCarVen
DECLARE Con_CtaOrdMor   	INT;				-- Constante CtaOrdMor
DECLARE Con_CorIntMor   	INT;				-- Constante CorIntMor
DECLARE Con_MoraVencido		INT;				-- Constante de Moratorios Vencidos
DECLARE Con_CtaOrdInt   	INT;				-- Constante CtaOrdInt
DECLARE Con_CorIntOrd   	INT;				-- Constante CorIntOrd
DECLARE	Con_IngInteCarVen	INT;				-- Constante IngInteCarVen
DECLARE Con_IntProvis   	INT;				-- Constante de Interes Provisionado
DECLARE Con_IntVencido  	INT;				-- Constante de Interes Vencido
DECLARE Con_IntAtrasado 	INT;				-- Constante de Interes Atrasado
DECLARE Con_CapVigente  	INT;				-- Constante de Capital Vigente
DECLARE Con_CapAtrasado 	INT;				-- Constante de Capital Atrasado
DECLARE Con_CapVencido  	INT;				-- Constante de Capital Vencido
DECLARE Con_CapVenNoExi 	INT;				-- Constante de Capital Vencido No Exigible
DECLARE Con_OrdCastigo  	INT;				-- Contante OrdCastigo
DECLARE Con_CorCastigo  	INT;				-- Constante CorCastigo
DECLARE	Con_OrdCasInt 		INT;				-- Constante OrdCasInt
DECLARE	Con_CorCasInt 		INT;				-- Constante CorCasInt
DECLARE	Con_OrdCasMora 		INT;				-- Constante OrdCasMora
DECLARE	Con_CorCasMora 		INT;				-- Constante CorCasMora
DECLARE	Con_OrdCasComi 		INT;				-- Constante OrdCasComi
DECLARE	Con_CorCasComi 		INT;				-- Constante CorCasComi
DECLARE Con_BalAdiEPRC		INT;				-- Constante BalAdiEPRC
DECLARE Con_PteAdiEPRC		INT;				-- Constante PteAdiEPRC
DECLARE Con_ResAdiEPRC		INT;				-- Constante ResAdiEPRC

DECLARE Si_AplicaConta  	CHAR(1);			-- Constante Si_AplicaConta
DECLARE Pol_Automatica  	CHAR(1);			-- Constante de Poliza Automatica
DECLARE Con_CastigoCar  	INT;				-- Constante CastigoCar
DECLARE Con_IngComisi		INT;				-- Constante IngComisi

DECLARE Mov_ComFalPag  	 	INT;				-- Constante de Movimiento ComFalPag
DECLARE Mov_Moratorio   	INT;				-- Constante de Movimiento Moratorio
DECLARE	Mov_MoraVencido		INT;				-- Constante de Movimiento de Moratorio Vencido
DECLARE	Mov_MoraCarVen		INT;				-- Constante de Movimiento de Moratorios de Cartera Vencida
DECLARE	Con_MoraVigente		INT;				-- Constante de Movimiento de Moratorios Vigente
DECLARE Mov_IntNoConta  	INT;				-- Constante de Movimiento de Interes no Contabilizado
DECLARE Mov_IntProvis   	INT;				-- Constante de Movimiento de Interes Provisionado
DECLARE Mov_IntVencido  	INT;				-- Constante de Movimiento de Interes Vencido
DECLARE Mov_IntAtrasado 	INT;				-- Constante de Movimiento de Interes Atrasado
DECLARE Mov_CapVigente  	INT;				-- Constante de Movimiento de Capital Vigente
DECLARE Mov_CapAtrasado 	INT;				-- Constante de Movimiento de Capital Atrasado
DECLARE Mov_CapVencido  	INT;				-- Constante de Movimiento de Capital Vencido
DECLARE Mov_CapVenNoExi 	INT;				-- Constante de Movimiento de Capital Vencido No Exigible
DECLARE Nat_Cargo       	CHAR(1);			-- Constante Naturaleza de Cargo
DECLARE Nat_Abono       	CHAR(1);			-- Constante Naturaleza de Abono
DECLARE EPRC_Resultados		CHAR(1);			-- Constante EPRC_Resultados
DECLARE SI_DivideEPRC		CHAR(1);			-- Constante SI_DivideEPRC
DECLARE NO_DivideEPRC		CHAR(1);			-- Constante NO_DivideEPRC
DECLARE Mora_CueOrden		CHAR(1);			-- Constante Mora_CueOrden
DECLARE SI_Condona			CHAR(1);			-- Constante SI Condona
DECLARE No_DivideCastigo	CHAR(1);			-- Constante No_DivideCastigo
DECLARE NO_EPRCAdicional	CHAR(1);			-- Constante NO_EPRCAdicional
DECLARE SI_EPRCAdicional	CHAR(1);			-- Constante SI_EPRCAdicional
DECLARE Mon_MinPago     	DECIMAL(12,2);		-- Constante monto minimo de Pago
DECLARE Des_Castigo     	VARCHAR(100);		-- Consante Des_Castigo
DECLARE Var_NumError		INT(11);			-- Constante Var_NumError
DECLARE CastPagVertical		CHAR(1);			-- Constante CastPagVertical

DECLARE Tip_MovComGarDisLinCred		INT(11);	-- Tipo Movimiento Credito Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Tip_MovIVAComGarDisLinCred	INT(11);	-- Tipo Movimiento Credito IVA Comision por Garantia por Disposicion de Linea Credito Agro

DECLARE Con_CarCtaOrdenDeuAgro		INT(11);	-- Concepto Cuenta Ordenante Deudor Agro
DECLARE Con_CarCtaOrdenCorAgro		INT(11);	-- Concepto Cuenta Ordenante Corte Agro
DECLARE Con_CarComGarDisLinCred		INT(11);	-- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Con_CarIVAComGarDisLinCred	INT(11);	-- Concepto Cartera IVA Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Act_Bloqueo             INT(11);        -- Numero de Actualizacion por Bloqueo
DECLARE Var_RegistroID			INT(11);

-- Asignacion de Constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Decimal_Cien    := 100.00;

SET Esta_Activo     := 'A';
SET Esta_Cancelado  := 'C';
SET Esta_Inactivo   := 'I';
SET Esta_Vencido    := 'B';
SET Esta_Vigente    := 'V';
SET Esta_Castigado  := 'K';
SET Esta_Pagado     := 'P';
SET Par_SalidaNO    := 'N';
SET Par_SalidaSI    := 'S';
SET Esta_Atrasado   := 'A';

SET AltaPoliza_SI   := 'S';
SET AltaPoliza_NO   := 'N';
SET AltaPolCre_SI   := 'S';
SET AltaPolCre_NO   := 'N';
SET AltaMovAho_NO   := 'N';
SET AltaMovAho_SI   := 'S';
SET AltaMovCre_NO   := 'N';
SET AltaMovCre_SI   := 'S';
SET Si_AplicaConta  := 'S';
SET Pol_Automatica  := 'A';

SET Con_EstBalance      := 17;
SET Con_EstResultados   := 18;
SET Con_EstBalanceInt	:= 36;
SET Con_EstResultaInt   := 37;
SET Con_CtaPtePrinc   	:= 38;
SET Con_CtaPteIntere	:= 39;
SET Con_CtaOrdCom       := 15;
SET Con_CorComFal       := 16;
SET Con_IngresoMora		:= 6;
SET Con_IngMoraCarVen	:= 35;
SET Con_CtaOrdMor       := 13;
SET Con_CorIntMor       := 14;
SET	Con_MoraVencido		:= 34;
SET	Con_MoraVigente		:= 33;
SET Con_CtaOrdInt       := 11;
SET Con_CorIntOrd       := 12;
SET Con_IngInteCarVen	:= 32;
SET Con_IntProvis       := 19;
SET Con_IntVencido      := 21;
SET Con_IntAtrasado     := 20;
SET Con_CapVigente      := 1;
SET Con_CapAtrasado     := 2;
SET Con_CapVencido      := 3;
SET Con_CapVenNoExi     := 4;
SET Con_OrdCastigo      := 29;
SET Con_CorCastigo      := 30;
SET Con_CastigoCar      := 59;
SET Con_IngComisi      	:= 7;
SET	Con_OrdCasInt 		:= 40;
SET	Con_CorCasInt 		:= 41;
SET	Con_OrdCasMora 		:= 42;
SET	Con_CorCasMora 		:= 43;
SET	Con_OrdCasComi 		:= 44;
SET	Con_CorCasComi 		:= 45;
SET Con_BalAdiEPRC		:= 49;
SET Con_PteAdiEPRC		:= 50;
SET Con_ResAdiEPRC		:= 51;

SET Mov_ComFalPag       := 40;
SET Mov_Moratorio       := 15;
SET Mov_MoraVencido		:= 16;
SET Mov_MoraCarVen		:= 17;
SET Mov_IntNoConta      := 13;
SET Mov_IntProvis       := 14;
SET Mov_IntVencido      := 12;
SET Mov_IntAtrasado     := 11;
SET Mov_CapVigente      := 1;
SET Mov_CapAtrasado     := 2;
SET Mov_CapVencido      := 3;
SET Mov_CapVenNoExi     := 4;
SET Nat_Cargo       	:= 'C';
SET Nat_Abono       	:= 'A';
SET EPRC_Resultados		:= 'R';
SET SI_DivideEPRC		:= 'S';
SET NO_DivideEPRC		:= 'N';
SET Mora_CueOrden		:= 'C';
SET	SI_Condona			:= 'S';
SET	No_DivideCastigo	:= 'N';
SET NO_EPRCAdicional	:= 'N';
SET SI_EPRCAdicional	:= 'S';
SET CastPagVertical		:= 'V';

SET Mon_MinPago     	:= 0.01;
SET Des_Castigo     	:= 'CASTIGO DE CARTERA';

SET Var_ResAnterior		:= Entero_Cero;
SET Var_ResInteres		:= Entero_Cero;
SET Var_ResCapital		:= Entero_Cero;
SET Var_MonReservar 	:= Entero_Cero;
SET Var_MonResCapita	:= Entero_Cero;
SET Var_MonResIntere	:= Entero_Cero;
SET Var_ReservCan   	:= Entero_Cero;
SET Var_CastigoCap  	:= Entero_Cero;
SET Var_CastigoInt  	:= Entero_Cero;
SET Var_CasIntMora  	:= Entero_Cero;
SET Var_CasAccesor  	:= Entero_Cero;
SET Var_CasMoraVenc 	:= Entero_Cero;
SET Var_CasInteVenc		:= Entero_Cero;
SET Tip_MovComGarDisLinCred		:= 57;
SET Tip_MovIVAComGarDisLinCred	:= 58;

SET Con_CarCtaOrdenDeuAgro		:= 138;
SET Con_CarCtaOrdenCorAgro		:= 139;
SET Con_CarComGarDisLinCred 	:= 143;
SET Con_CarIVAComGarDisLinCred	:= 145;
SET Act_Bloqueo					:= 2;

SET	Var_TotalCastigo	:= Entero_Cero;
SET Par_EmpresaID	:= IFNULL(Par_EmpresaID, 1);

ManejoErrores : BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECASTIGOAGROPRO');
			END;

SET Par_EmpresaID		:= IFNULL(Par_EmpresaID, Entero_Cero);
SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
SET Aud_FechaActual		:= IFNULL(Aud_FechaActual, NOW());
SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);

DELETE FROM TMPCASTIGOSAGRO WHERE TransaccionID = Aud_NumTransaccion AND CreditoID = Par_CreditoID;

SET @cont :=0;

INSERT INTO TMPCASTIGOSAGRO(
	RegistroID,				TransaccionID,			CreditoID,				AmortizacionID,			SaldoCapVigente,
	SaldoCapAtrasa,			SaldoCapVencido,		SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,
	SaldoInteresVen,		SaldoInteresPro,		SaldoIntNoConta,		SaldoMoratorios,		SaldoComFaltaPa,
	SaldoComServGar,		SaldoOtrasComis,		MonedaID,				FechaInicio,			FechaVencim,
	FechaExigible,			Estatus,				SaldoMoraVencido,		SaldoMoraCarVen,
	EmpresaID,				Usuario,				FechaActual,			DireccionIP,			ProgramaID,
	Sucursal,				NumTransaccion)
SELECT
	(@cont:=@cont+1),		Aud_NumTransaccion,		Amo.CreditoID,			Amo.AmortizacionID,		Amo.SaldoCapVigente,
	Amo.SaldoCapAtrasa,		Amo.SaldoCapVencido,	Amo.SaldoCapVenNExi,	Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,
	Amo.SaldoInteresVen,	Amo.SaldoInteresPro,	Amo.SaldoIntNoConta,	Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,
	Amo.SaldoComServGar,	Amo.SaldoOtrasComis,	Cre.MonedaID,			Amo.FechaInicio,		Amo.FechaVencim,
	Amo.FechaExigible,		Amo.Estatus,			Amo.SaldoMoraVencido,	Amo.SaldoMoraCarVen,
	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
	Aud_Sucursal,			Aud_NumTransaccion
	FROM AMORTICREDITO Amo
	INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
	WHERE Cre.CreditoID	= Par_CreditoID
	  AND (Cre.Estatus = Esta_Vigente OR Cre.Estatus = Esta_Vencido)
	  AND (Amo.Estatus = Esta_Vigente OR Amo.Estatus = Esta_Vencido OR Amo.Estatus = Esta_Activo)
	ORDER BY FechaExigible;

SELECT FechaSistema, TipoContaMora INTO Var_FechaSistema, Var_TipoContaMora
	FROM PARAMETROSSIS
		WHERE EmpresaID = Par_EmpresaID;

SELECT RegContaEPRC, DivideEPRCCapitaInteres, CondonaIntereCarVen, CondonaMoratoCarVen, CondonaAccesorios,
	   DivideCastigo, EPRCAdicional INTO
		Var_RegContaEPRC, Var_DivideEPRC, Var_ConIntereCarVen, Var_CondMoraCarVen, Var_ConAccesorios,
		Var_DivideCastigo, Var_EPRCAdicional
	FROM PARAMSRESERVCASTIG
	WHERE EmpresaID = Par_EmpresaID;

SET	Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
SET	Var_DivideEPRC	:= IFNULL(Var_DivideEPRC, NO_DivideEPRC);
SET	Var_TipoContaMora := IFNULL(Var_TipoContaMora, Mora_CueOrden);
SET	Var_ConIntereCarVen := IFNULL(Var_ConIntereCarVen, SI_Condona);
SET	Var_CondMoraCarVen	:= IFNULL(Var_CondMoraCarVen, SI_Condona);
SET Var_ConAccesorios	:= IFNULL(Var_ConAccesorios, SI_Condona);
SET	Var_DivideCastigo	:= IFNULL(Var_DivideCastigo, No_DivideCastigo);
SET	Var_EPRCAdicional	:= IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);

SELECT  Cli.SucursalOrigen,     Cre.MonedaID,   Pro.ProducCreditoID,    Des.Clasificacion,  Des.SubClasifID,
        Cre.Estatus,			Cre.SucursalID
        INTO
        Var_SucCliente,         Var_MonedaID,   Var_ProdCreID,      Var_ClasifCre,  Var_SubClasifID,
        Var_CreEstatus,			Var_SucursalCred
    FROM CREDITOS Cre
    INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
    INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
    WHERE Cre.CreditoID = Par_CreditoID;

IF(Par_TipoCastigo != CastPagVertical)THEN
	CALL CRECASTIGOSVAL(Par_CreditoID, 		Par_SalidaNO, 				Par_NumErr, 			Par_ErrMen,
						Par_EmpresaID,		Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,		Aud_NumTransaccion);

	SET	Var_NumError	:= CONVERT(Par_NumErr, UNSIGNED);
	IF(Var_NumError != Entero_Cero) THEN
		SET Par_NumErr	:= '001';
		  LEAVE ManejoErrores;
	END IF;
END IF;



CALL DIASFESTIVOSCAL(
    Var_FechaSistema,   Entero_Cero,        Var_FecApl,         Var_EsHabil,    Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);


SELECT  MAX(Fecha) INTO Var_FecAntRes
    FROM CALRESCREDITOS
    WHERE AplicaConta = Si_AplicaConta
      AND CreditoID = Par_CreditoID;

SET Var_FecAntRes := IFNULL(Var_FecAntRes, Fecha_Vacia);

IF(Var_FecAntRes != Fecha_Vacia) THEN
    SELECT SaldoResInteres, SaldoResCapital INTO Var_ResInteres, Var_ResCapital
        FROM CALRESCREDITOS
        WHERE AplicaConta = Si_AplicaConta
          AND CreditoID = Par_CreditoID
          AND Fecha = Var_FecAntRes;

	SET	Var_ResCapital := IFNULL(Var_ResCapital, Entero_Cero);
	SET Var_ResInteres := IFNULL(Var_ResInteres, Entero_Cero);

    SET Var_ResAnterior := Var_ResCapital + Var_ResInteres;
END IF;

IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
	CALL MAESTROPOLIZASALT(
		Par_PolizaID,     	Par_EmpresaID,  	Var_FecApl,     Pol_Automatica,		Con_CastigoCar,
		Des_Castigo,    	Par_SalidaNO, 	 	Par_NumErr,		Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   	Aud_NumTransaccion);

    IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
	END IF;
END IF;

SET @contador := Entero_Cero;

SELECT COUNT(*) AS Amorti
	INTO Var_NumAmorti
    FROM TMPCASTIGOSAGRO
WHERE TransaccionID = Aud_NumTransaccion AND CreditoID = Par_CreditoID;

WHILE (@Contador < Var_NumAmorti) DO
	SET @contador = @contador+1;

	SELECT 	CreditoID, 			AmortizacionID,		SaldoCapVigente,	SaldoCapAtrasa,		SaldoCapVencido,
	 		SaldoCapVenNExi,	SaldoInteresOrd,	SaldoInteresAtr, 	SaldoInteresVen,	SaldoInteresPro,
			SaldoIntNoConta,	SaldoMoratorios,	SaldoComFaltaPa,	SaldoComServGar,    SaldoOtrasComis,
			MonedaID,           FechaInicio,		FechaVencim, 		FechaExigible, 		Estatus,
			SaldoMoraVencido,   SaldoMoraCarVen
	INTO	Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoCapVigente,    Var_SaldoCapAtrasa,
			Var_SaldoCapVencido,    Var_SaldoCapVenNExi,    Var_SaldoInteresOrd,    Var_SaldoInteresAtr,
			Var_SaldoInteresVen,    Var_SaldoInteresPro,    Var_SaldoIntNoConta,    Var_SaldoMoratorios,
			Var_SaldoComFaltaPa,    Var_SaldoComServGar,    Var_SaldoOtrasComis,    Var_MonedaID,
		    Var_FechaInicio,        Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus,
			Var_SalMoraVencido,     Var_SalMoraCarVen
	FROM TMPCASTIGOSAGRO
	WHERE RegistroID = @contador
	  AND TransaccionID = Aud_NumTransaccion
	  AND CreditoID = Par_CreditoID;

        SET Var_SaldoCapVigente := IFNULL(Var_SaldoCapVigente, Entero_Cero);
        SET Var_SaldoCapAtrasa  := IFNULL(Var_SaldoCapAtrasa,  Entero_Cero);
        SET Var_SaldoCapVencido := IFNULL(Var_SaldoCapVencido, Entero_Cero);
        SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Entero_Cero);
        SET Var_SaldoInteresOrd := IFNULL(Var_SaldoInteresOrd, Entero_Cero);
        SET Var_SaldoInteresAtr := IFNULL(Var_SaldoInteresAtr, Entero_Cero);
        SET Var_SaldoInteresVen := IFNULL(Var_SaldoInteresVen, Entero_Cero);
        SET Var_SaldoInteresPro := IFNULL(Var_SaldoInteresPro, Entero_Cero);
        SET Var_SaldoIntNoConta := IFNULL(Var_SaldoIntNoConta, Entero_Cero);
        SET Var_SaldoMoratorios := IFNULL(Var_SaldoMoratorios, Entero_Cero);
        SET Var_SaldoComFaltaPa := IFNULL(Var_SaldoComFaltaPa, Entero_Cero);
		SET Var_SaldoComServGar := IFNULL(Var_SaldoComServGar, Entero_Cero);
        SET Var_SaldoOtrasComis := IFNULL(Var_SaldoOtrasComis, Entero_Cero);
        SET Var_SalMoraVencido 	:= IFNULL(Var_SalMoraVencido, Entero_Cero);
        SET Var_SalMoraCarVen 	:= IFNULL(Var_SalMoraCarVen, Entero_Cero);



        SET Var_CastigoCap  := Var_CastigoCap + Var_SaldoCapVigente + Var_SaldoCapAtrasa +
                               Var_SaldoCapVencido + Var_SaldoCapVenNExi;

        SET Var_CastigoInt  := Var_CastigoInt + Var_SaldoInteresAtr + Var_SaldoInteresVen +
                               Var_SaldoInteresPro + Var_SaldoIntNoConta;

		SET Var_CasIntMora  := Var_CasIntMora + Var_SaldoMoratorios + Var_SalMoraVencido + Var_SalMoraCarVen;
		SET Var_CasAccesor  := Var_CasAccesor + Var_SaldoComFaltaPa + Var_SaldoComServGar + Var_SaldoOtrasComis;

		SET Var_CasMoraVenc := Var_CasMoraVenc + Var_SalMoraVencido;
		SET Var_CasInteVenc	:= Var_CasInteVenc + Var_SaldoInteresVen;


		IF (Var_CreEstatus = Esta_Vencido) THEN

			SET	Var_MonResCapita := Var_MonResCapita +
									(Var_SaldoCapVigente + Var_SaldoCapAtrasa + Var_SaldoCapVencido + Var_SaldoCapVenNExi);

			SET Var_CasInteVenc	:= Var_CasInteVenc + Var_SaldoInteresPro;

		ELSE
			SET	Var_MonResCapita := Var_MonResCapita +
									(Var_SaldoCapVigente + Var_SaldoCapAtrasa + Var_SaldoCapVencido + Var_SaldoCapVenNExi);

			SET	Var_MonResIntere := Var_MonResIntere + (Var_SaldoInteresAtr  + Var_SaldoInteresPro);

		END IF;


		IF( Var_SaldoComServGar >= Mon_MinPago ) THEN

			CALL CONTACREDITOSPRO (
				Par_CreditoID,				Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
				Var_FecApl,					Var_SaldoComServGar,	Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
				Var_SubClasifID,			Var_SucCliente,			Des_Castigo,		Des_Castigo,		AltaPoliza_NO,
				Entero_Cero,				Par_PolizaID,			AltaPolCre_SI,		AltaMovCre_SI,		Con_CarCtaOrdenDeuAgro,
				Tip_MovComGarDisLinCred,	Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,				Par_SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
				Par_EmpresaID,				Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,				Var_SucursalCred,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CONTACREDITOSPRO (
				Par_CreditoID,				Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Var_FechaSistema,
				Var_FecApl,					Var_SaldoComServGar,	Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
				Var_SubClasifID,			Var_SucCliente,			Des_Castigo,		Des_Castigo,		AltaPoliza_NO,
				Entero_Cero,				Par_PolizaID,			AltaPolCre_SI,		AltaMovCre_NO,		Con_CarCtaOrdenCorAgro,
				Tip_MovComGarDisLinCred,	Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
				Cadena_Vacia,				Par_SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
				Par_EmpresaID,				Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,				Var_SucursalCred,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

    IF (Var_SaldoComFaltaPa >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoComFaltaPa,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CtaOrdCom,
            Mov_ComFalPag,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoComFaltaPa,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorComFal,
            Mov_ComFalPag,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		IF(Var_ConAccesorios != SI_Condona) THEN
			SET	Var_MonResIntere := Var_MonResIntere + Var_SaldoComFaltaPa;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_SaldoComFaltaPa,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_IngComisi,
				Mov_ComFalPag,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

    END IF;


    IF (Var_SalMoraVencido >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SalMoraVencido,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_MoraVencido,
            Mov_MoraVencido,	Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
		END IF;
    END IF;


    IF (Var_SaldoMoratorios >= Mon_MinPago) THEN


		IF(Var_TipoContaMora = Mora_CueOrden) THEN
			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CtaOrdMor,
				Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorIntMor,
				Mov_Moratorio,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			IF(Var_CondMoraCarVen != SI_Condona) THEN
				SET	Var_MonResIntere := Var_MonResIntere + Var_SaldoMoratorios;

				CALL  CONTACREDITOSPRO (
					Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
					Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
					Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_IngresoMora,
					Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
					Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

		ELSE


			SET	Var_MonResIntere := Var_MonResIntere + Var_SaldoMoratorios;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_SaldoMoratorios,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_MoraVigente,
				Mov_Moratorio,		Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
    END IF;


    IF (Var_SalMoraCarVen >= Mon_MinPago) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_SalMoraCarVen,    	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CtaOrdMor,
			Mov_MoraCarVen,		Nat_Abono,				AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_SalMoraCarVen,    	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorIntMor,
			Mov_MoraCarVen,		Nat_Cargo,				AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		IF(Var_CondMoraCarVen != SI_Condona) THEN
			SET	Var_MonResIntere := Var_MonResIntere + Var_SalMoraCarVen;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_SalMoraCarVen,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_IngMoraCarVen,
				Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;
	END IF;


    IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CtaOrdInt,
            Mov_IntNoConta,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorIntOrd,
            Mov_IntNoConta,     Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		IF(Var_ConIntereCarVen != SI_Condona) THEN
			SET	Var_MonResIntere := Var_MonResIntere + Var_SaldoIntNoConta;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_SaldoIntNoConta,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,  	Con_IngInteCarVen,
				Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,   	Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

    END IF;

    IF (Var_SaldoInteresPro >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoInteresPro,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_IntProvis,
            Mov_IntProvis,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

    IF (Var_SaldoInteresVen >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoInteresVen,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_IntVencido,
            Mov_IntVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       	Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,		Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;


    IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoInteresAtr,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_IntAtrasado,
            Mov_IntAtrasado,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;



    IF (Var_SaldoCapVigente >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoCapVigente,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CapVigente,
            Mov_CapVigente,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

    IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoCapAtrasa,     Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CapAtrasado,
            Mov_CapAtrasado,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

    IF (Var_SaldoCapVencido >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoCapVencido,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CapVencido,
            Mov_CapVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    	Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

    IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN
        CALL  CONTACREDITOSPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
            Var_FecApl,         Var_SaldoCapVenNExi,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,  	Con_CapVenNoExi,
            Mov_CapVenNoExi,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
            Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,
            Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,   		Aud_DireccionIP,
            Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
    END IF;

END WHILE;




SET Var_ReservCan   := Var_MonResCapita + Var_MonResIntere;
SET	Var_MonReservar := Var_MonResCapita + Var_MonResIntere;


IF(Var_DivideEPRC = NO_DivideEPRC) THEN


	IF(Var_MonReservar > Var_ResAnterior) THEN
		SET Var_MonReservar := (Var_MonReservar - Var_ResAnterior);

		SET Mov_AboConta	:= Con_EstBalance;


		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		IF(Var_RegContaEPRC = EPRC_Resultados) THEN
			SET Mov_CarConta	:= Con_EstResultados;
		ELSE
			SET Mov_CarConta	:= Con_CtaPtePrinc;
		END IF;


		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_CarConta,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	ELSE
		SET Var_MonLibReser := (Var_ResAnterior - Var_MonReservar);

		SET Mov_AboConta	:= Con_EstResultados;

		IF(Var_MonLibReser > Entero_Cero) THEN

			SET Mov_CarConta	:= Con_EstBalance;


			IF(Var_RegContaEPRC = EPRC_Resultados) THEN
				SET Mov_AboConta	:= Con_EstResultados;
			ELSE
				SET Mov_AboConta	:= Con_CtaPtePrinc;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
				Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_CarConta,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
	END IF;
ELSE

	IF(Var_MonResCapita > Var_ResCapital) THEN
		SET Var_MonReservar := (Var_MonResCapita - Var_ResCapital);

		SET Mov_AboConta	:= Con_EstBalance;


		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_RegContaEPRC = EPRC_Resultados) THEN
			SET Mov_CarConta	:= Con_EstResultados;
		ELSE
			SET Mov_CarConta	:= Con_CtaPtePrinc;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_CarConta,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	ELSE

		SET Var_MonLibReser := (Var_ResCapital- Var_MonResCapita);

		SET Mov_AboConta	:= Con_EstResultados;

		IF(Var_MonLibReser > Entero_Cero) THEN

			SET Mov_CarConta	:= Con_EstBalance;


			IF(Var_RegContaEPRC = EPRC_Resultados) THEN
				SET Mov_AboConta	:= Con_EstResultados;
			ELSE
				SET Mov_AboConta	:= Con_CtaPtePrinc;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
				Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_CarConta,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
	END IF;

	IF(Var_MonResIntere > Var_ResInteres) THEN
		SET Var_MonReservar := (Var_MonResIntere - Var_ResInteres);

		SET Mov_AboConta	:= Con_EstBalanceInt;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		IF(Var_RegContaEPRC = EPRC_Resultados) THEN
			SET Mov_CarConta	:= Con_EstResultaInt;
		ELSE
			SET Mov_CarConta	:= Con_CtaPteIntere;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_CarConta,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	ELSE

		SET Var_MonLibReser := (Var_ResInteres - Var_MonResIntere);

		IF(Var_MonLibReser > Entero_Cero) THEN

			SET Mov_CarConta	:= Con_EstBalanceInt;


			IF(Var_RegContaEPRC = EPRC_Resultados) THEN
				SET Mov_AboConta	:= Con_EstResultaInt;
			ELSE
				SET Mov_AboConta	:= Con_CtaPteIntere;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_AboConta,
				Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Mov_CarConta,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
	END IF;
END IF;


UPDATE CALRESCREDITOS SET
    SaldoResCapital = Entero_Cero,
    SaldoResInteres = Entero_Cero
    WHERE AplicaConta = Si_AplicaConta
      AND CreditoID = Par_CreditoID
      AND Fecha = Var_FecAntRes;

-- ---------------------------------------------------------
-- Fecha de 1er Incumplimiento
-- ---------------------------------------------------------
SELECT  IFNULL(MIN(FechaExigible), Fecha_Vacia)
		INTO Var_FecPrimAtraso
		FROM AMORTICREDITO Amo
		WHERE Amo.CreditoID = Var_CreditoID
		  AND (Amo.Estatus != Esta_Pagado
		   OR  ( 	Amo.Estatus = Esta_Pagado
			   AND	Amo.NumTransaccion  = Var_TranCastigo ) )
		  AND Amo.FechaExigible <= Var_FechaSistema;

-- -----------------------------------------------------------------
-- Fecha y Monto del Ultimo Pago de Capital cubierto en su Totalidad
-- -----------------------------------------------------------------

DROP TABLE IF EXISTS TMPREG453;

CREATE TEMPORARY TABLE TMPREG453(
	AmortizacionID		INT,
	MontoPago			DECIMAL(14,2),
	FechaPago			DATE,
	Exigible			DECIMAL(14,2),
	FecUltPagCompleto	DATE,
	NumTransaccion		BIGINT
	);

INSERT INTO TMPREG453
	SELECT	Det.AmortizacionID, SUM(Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen),
			MAX(Det.FechaPago),	MAX(Amo.Capital),	Fecha_Vacia, MAX(Det.NumTransaccion)
		FROM DETALLEPAGCRE Det,
			 AMORTICREDITO Amo
		WHERE Det.CreditoID  = Var_CreditoID
		  AND Det.FechaPago <= Var_FechaSistema
		  AND (Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen) > Entero_Cero
		  AND Det.CreditoID = Amo.CreditoID
		  AND Det.AmortizacionID = Amo.AmortizacionID
	GROUP BY Det.AmortizacionID;

UPDATE TMPREG453 Tem SET
	Tem.FecUltPagCompleto = Tem.FechaPago
	WHERE MontoPago >= Exigible;

SELECT	IFNULL(MAX(Det.FecUltPagCompleto), Fecha_Vacia) INTO Var_FecUltPagoCap
	FROM TMPREG453 Det;

IF(Var_FecUltPagoCap != Fecha_Vacia) THEN

	SELECT	MAX(Tem.NumTransaccion), MAX(Tem.AmortizacionID) INTO Var_UltNumTransac, Var_UltAmortizacionID
		FROM TMPREG453 Tem
		WHERE Tem.FecUltPagCompleto = Var_FecUltPagoCap;


	SET Var_UltNumTransac := IFNULL(Var_UltNumTransac, Entero_Cero);
	SET Var_UltAmortizacionID := IFNULL(Var_UltAmortizacionID, Entero_Cero);

	SELECT	Det.MontoPago INTO Var_MonUltPagoCap
		FROM TMPREG453 Det
		WHERE Det.FecUltPagCompleto = Var_FecUltPagoCap
		  AND Det.NumTransaccion = Var_UltNumTransac
		  AND Det.AmortizacionID = Var_UltAmortizacionID;

END IF;

SET Var_MonUltPagoCap := IFNULL(Var_MonUltPagoCap,Entero_Cero);


-- -----------------------------------------------------------------
-- Fecha y Monto del Ultimo Pago de Interes cubierto en su Totalidad
-- -----------------------------------------------------------------

SET	Var_UltNumTransac	  := Entero_Cero;
SET	Var_UltAmortizacionID := Entero_Cero;

DELETE FROM TMPREG453;

INSERT INTO TMPREG453
	SELECT	Det.AmortizacionID, SUM(Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen + Det.MontoIntMora),
			MAX(Det.FechaPago),	MAX(Amo.ProvisionAcum),	Fecha_Vacia, MAX(Det.NumTransaccion)
		FROM DETALLEPAGCRE Det,
			 AMORTICREDITO Amo
		WHERE Det.CreditoID  = Var_CreditoID
		  AND Det.FechaPago <= Var_FechaSistema
		  AND (Det.MontoIntAtr + Det.MontoIntOrd + Det.MontoIntVen) > Entero_Cero
		  AND Det.CreditoID = Amo.CreditoID
		  AND Det.AmortizacionID = Amo.AmortizacionID
	GROUP BY Det.AmortizacionID;

UPDATE TMPREG453 Tem SET
	Tem.FecUltPagCompleto = Tem.FechaPago
	WHERE MontoPago >= Exigible;

SELECT	IFNULL(MAX(Det.FecUltPagCompleto), Fecha_Vacia) INTO Var_FecUltPagoInt
	FROM TMPREG453 Det;

IF(Var_FecUltPagoInt != Fecha_Vacia) THEN

	SELECT	MAX(Tem.NumTransaccion), MAX(Tem.AmortizacionID) INTO Var_UltNumTransac, Var_UltAmortizacionID
		FROM TMPREG453 Tem
		WHERE Tem.FecUltPagCompleto = Var_FecUltPagoInt;


	SET Var_UltNumTransac := IFNULL(Var_UltNumTransac, Entero_Cero);
	SET Var_UltAmortizacionID := IFNULL(Var_UltAmortizacionID, Entero_Cero);

	SELECT	Det.MontoPago INTO Var_MonUltPagoInt
		FROM TMPREG453 Det
		WHERE Det.FecUltPagCompleto = Var_FecUltPagoInt
		  AND Det.NumTransaccion = Var_UltNumTransac
		  AND Det.AmortizacionID = Var_UltAmortizacionID;

END IF;

SET Var_MonUltPagoInt := IFNULL(Var_MonUltPagoInt,Entero_Cero);

-- ----------------------------------------------------------------

UPDATE AMORTICREDITO SET
    Estatus		= Esta_Pagado,
    FechaLiquida	= Var_FechaSistema

    WHERE CreditoID 	= Par_CreditoID
      AND Estatus 	!= Esta_Pagado;

UPDATE CREDITOS SET
    Estatus         = Esta_Castigado,
    FechTerminacion = Var_FechaSistema,

    Usuario     = Aud_Usuario,
    FechaActual = Aud_FechaActual,
    DireccionIP = Aud_DireccionIP,
    ProgramaID  = Aud_ProgramaID,
    Sucursal    = Aud_Sucursal,
    NumTransaccion	= Aud_NumTransaccion

    WHERE CreditoID = Par_CreditoID;

-- Se valida que el credito tiene una linea de crédito y se realiza el proceso de bloqueo
SET Var_LineaCreditoID := IFNULL(Var_LineaCreditoID, Entero_Cero);
IF( Var_LineaCreditoID > Entero_Cero ) THEN

	CALL LINEASCREDITOACT(
		Var_LineaCreditoID,	Entero_Cero,		Var_FechaSistema,	Aud_Usuario,	Des_Castigo,
		Entero_Cero,		Cadena_Vacia,		Act_Bloqueo,
		Par_SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET	Var_TotalCastigo	:= Var_CastigoCap + Var_CastigoInt + Var_CasIntMora + Var_CasAccesor;

INSERT INTO CRECASTIGOS (
	CreditoID,			Fecha,			CapitalCastigado,	InteresCastigado,	TotalCastigo,
	MonRecuperado,		EstatusCredito,	MotivoCastigoID,	Observaciones,		IntMoraCastigado,
	AccesorioCastigado,	SaldoCapital,	SaldoInteres,		SaldoMoratorio,		SaldoAccesorios,
    FecPrimAtraso,		FecUltPagoCap,  FecUltPagoInt,		MonUltPagoCap,		MonUltPagoInt,
    TipoCobranza,		EmpresaID,		Usuario,			FechaActual,		DireccionIP,
    ProgramaID,		    Sucursal,			NumTransaccion)
	VALUES(
	Par_CreditoID,		Var_FechaSistema,	Var_CastigoCap,     	Var_CastigoInt,		Var_TotalCastigo,
	Entero_Cero,		Var_CreEstatus,		Par_MotivoCastigoID,	Par_Observaciones,  Var_CasIntMora,
	Var_CasAccesor,		Var_CastigoCap,		Var_CastigoInt,			Var_CasIntMora,		Var_CasAccesor,
    Var_FecPrimAtraso,	Var_FecUltPagoCap, 	Var_FecUltPagoInt,		Var_MonUltPagoCap,	Var_MonUltPagoInt,
    Par_TipoCobranza,	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
    Aud_ProgramaID,	    Aud_Sucursal,		Aud_NumTransaccion  );

IF(Var_ReservCan > Entero_Cero) THEN

	IF(Var_DivideEPRC = NO_DivideEPRC) THEN

		SET	Var_ReservCan := Var_ReservCan + IFNULL(Var_CasMoraVenc, Entero_Cero)  +
											 IFNULL(Var_CasInteVenc, Entero_Cero);

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_ReservCan,      Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_EstBalance,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

	ELSE



		IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonResCapita,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_EstBalance,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_MonResIntere := Var_MonResIntere + IFNULL(Var_CasMoraVenc, Entero_Cero)  +
													   IFNULL(Var_CasInteVenc, Entero_Cero);

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonResIntere,   Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_EstBalanceInt,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonResCapita,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_EstBalance,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL  CONTACREDITOSPRO (
				Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
				Var_FecApl,         Var_MonResIntere,   Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_EstBalanceInt,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
				Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			SET Var_TotIntVenc = IFNULL(Var_CasMoraVenc, Entero_Cero) + IFNULL(Var_CasInteVenc, Entero_Cero);
			IF(Var_TotIntVenc > Entero_Cero) THEN
				CALL  CONTACREDITOSPRO (
					Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
					Var_FecApl,         Var_TotIntVenc,   	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
					Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_BalAdiEPRC,
					Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
					Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
					Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;

	END IF;
END IF;


IF(Var_DivideCastigo = No_DivideCastigo) THEN

	CALL  CONTACREDITOSPRO (
		Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
		Var_FecApl,         Var_TotalCastigo,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
		Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
		Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorCastigo,
		Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
		Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
		Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	CALL  CONTACREDITOSPRO (
		Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
		Var_FecApl,         Var_TotalCastigo,	Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
		Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
		Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_OrdCastigo,
		Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
		Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
		Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

ELSE


	IF(Var_CastigoCap > Entero_Cero) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CastigoCap,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorCastigo,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CastigoCap,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_OrdCastigo,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF(Var_CastigoInt > Entero_Cero) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CastigoInt,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorCasInt,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CastigoInt,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_OrdCasInt,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF(Var_CasIntMora > Entero_Cero) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CasIntMora,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorCasMora,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CasIntMora,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_OrdCasMora,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;


	IF(Var_CasAccesor > Entero_Cero) THEN
		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CasAccesor,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_CorCasComi,
			Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL  CONTACREDITOSPRO (
			Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,    	Var_FechaSistema,
			Var_FecApl,         Var_CasAccesor,		Var_MonedaID,       Var_ProdCreID,  	Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,    	AltaPoliza_NO,
			Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,  	Con_OrdCasComi,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,  	Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Var_SucursalCred,	Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

END IF;

DELETE FROM TMPCASTIGOSAGRO WHERE TransaccionID = Aud_NumTransaccion AND CreditoID = Par_CreditoID;
SET Par_NumErr      := '000';
SET Par_ErrMen      := CONCAT('Credito Castigado Exitosamente: ',CONVERT(Par_CreditoID,CHAR));

END ManejoErrores;

IF (Par_Salida = Par_SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           'creditoID' AS control,
           Par_PolizaID AS consecutivo;
END IF;

END TerminaStore$$