-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREQUITASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREQUITASPRO`;

DELIMITER $$
CREATE PROCEDURE `CREQUITASPRO`(
	Par_CreditoID           BIGINT(12),         -- Identificador del numero de credito
	Par_UsuarioID           INT(11),            -- Parametro del usuario
	Par_PuestoID            VARCHAR(10),        -- Parametro del puesto del usuario
	Par_FechaRegistro       DATE,               -- Fecha del registro
	Par_MontoComisiones     DECIMAL(12,2),      -- Parametro del Monto de la comision a condonar

	Par_PorceComisiones     DECIMAL(12,4),      -- Parametro del Porcentaje de la comision a condonar
	Par_MontoMoratorios     DECIMAL(12,2),      -- Parametro del Monto moratorio a condonar
	Par_PorceMoratorios     DECIMAL(12,4),      -- Parametro del porcentaje moratorios
	Par_MontoInteres        DECIMAL(12,2),      -- Parametro del monto de interes a condonar
	Par_PorceInteres        DECIMAL(12,4),      -- Parametro del porcentaje de interes

	Par_MontoCapital        DECIMAL(12,2),      -- Parametro del monto de la capital a condonar
	Par_PorceCapital        DECIMAL(12,4),      -- Parametro del porcentaje del capital
	Par_MontoNotasCargo		DECIMAL(12,2),		-- Parametro del monto de Nota Cargo a condonar
	Par_PorceNotasCargo		DECIMAL(12,4),		-- Parametro del porcentaje Nota Cargo

	Par_Poliza              BIGINT(20),         -- Parametro del numero de poliza
	Par_AltaPoliza          CHAR(1),            -- Parametro del si se quiere alta de poliza SI- S, NO- N

	Par_Salida              CHAR(1),            -- Parametro de Salida
	INOUT Par_NumErr        INT(11),            -- Numero de Error
	INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de Error

	Par_EmpresaID           INT(11),            -- Parametro de auditoria ID de la empresa
	Aud_Usuario             INT(11),            -- Parametro de auditoria ID del usuario
	Aud_FechaActual         DATETIME,           -- Parametro de auditoria Fecha actual
	Aud_DireccionIP         VARCHAR(15),        -- Parametro de auditoria Direccion IP
	Aud_ProgramaID          VARCHAR(50),        -- Parametro de auditoria Programa
	Aud_Sucursal            INT(11),            -- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion      BIGINT(20)          -- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_FechaSistema    DATE;
DECLARE Var_MontoCondonar   DECIMAL(12,2);

DECLARE Var_SaldoCondCom    DECIMAL(12,2);
DECLARE Var_SaldoCondMora   DECIMAL(12,2);
DECLARE Var_SaldoCondIntere DECIMAL(12,2);
DECLARE Var_SaldoCondCap    DECIMAL(12,2);


DECLARE Var_AmortizacionID  INT;                    -- Variables para el Cursor
DECLARE Var_EmpresaID       INT;
DECLARE Var_MonedaID        INT;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_SucursalOrigen  INT;
DECLARE Var_ProdCreditoID   INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_SaldoCapVigente DECIMAL(14,2);
DECLARE Var_SaldoCapAtrasa  DECIMAL(14,2);
DECLARE Var_SaldoCapVencido DECIMAL(14,2);
DECLARE Var_SaldoCapVenNExi DECIMAL(14,2);
DECLARE Var_SaldoInteresOrd DECIMAL(14,2);
DECLARE Var_SaldoInteresAtr DECIMAL(14,2);
DECLARE Var_SaldoInteresVen DECIMAL(14,2);
DECLARE Var_SaldoInteresPro DECIMAL(14,2);
DECLARE Var_SaldoIntNoConta DECIMAL(14,2);
DECLARE Var_SaldoMoratorios DECIMAL(14,2);
DECLARE Var_SaldoComFaltaPa DECIMAL(14,2);
DECLARE Var_SaldoOtrasComis DECIMAL(14,2);
DECLARE Var_SaldoInterVenc  DECIMAL(14,2);
DECLARE Var_SaldoMoraVencid DECIMAL(14,2);
DECLARE Var_SaldoMoraCarVen DECIMAL(14,2);
DECLARE Var_SaldoNotCargoRev		DECIMAL(14,2);		-- Variable de Nota Cargo
DECLARE Var_SaldoNotCargoSinIVA		DECIMAL(14,2);		-- Variable de Nota Cargo sin Iva
DECLARE Var_SaldoNotCargoConIVA		DECIMAL(14,2);		-- Variable de Nota Cargo con Iva
DECLARE Var_SaldoCondNotaCargo		DECIMAL(14,2);

DECLARE Var_EsHabil         CHAR(1);
DECLARE Mov_CarOpera        INT;
DECLARE Mov_AboOpera        INT;
DECLARE Mov_CarConta        INT;
DECLARE Mov_AboConta        INT;

DECLARE Par_Consecutivo     BIGINT;
DECLARE Var_NumAmoPag       INT;
DECLARE Var_NumAmorti       INT;
DECLARE Var_NumAmoExi       INT;
DECLARE Var_EstCredito      CHAR(1);
DECLARE Var_SubClasifID     INT;
DECLARE Var_TipoContaMora   CHAR(1);
DECLARE Var_RegContaEPRC    CHAR(1);
DECLARE Var_DivideEPRC      CHAR(1);
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_EPRCAdicional   CHAR(1);
DECLARE Var_CantAmoVenSusp  INT(11);          -- Cantidad de amortizaciones Vencidas solo para creditos suspendidos.
DECLARE Var_PagoPerdCentRedond  CHAR(1);
DECLARE Var_PagoMontoMaxPerd    DECIMAL(16,2);
DECLARE Var_CuentaContablePerd  VARCHAR(29);
DECLARE Var_SaldoPerdida        DECIMAL(16,2);
DECLARE Var_ClienteID 			BIGINT(10); -- Variable para almacenar el id de cliente
DECLARE Var_PermCondonarCapVig 	CHAR(1);
DECLARE Var_SaldoComServGar		DECIMAL(14,2);	-- Saldo de Comision por Servicio de Garantia
DECLARE Var_PagoComFaltaPagAnt CHAR(1);

-- Declaracion de constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE SalidaNO        CHAR(1);
DECLARE SalidaSI        CHAR(1);

DECLARE Estatus_Pagado  CHAR(1);
DECLARE Estatus_Vigente CHAR(1);
DECLARE Estatus_Vencida CHAR(1);
DECLARE Estatus_Atraso  CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPoliza_SI   CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE AltaPolCre_SI   CHAR(1);
DECLARE AltaMovCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE AltaMovAho_NO   CHAR(1);
DECLARE Con_Condona     INT;
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);

DECLARE Con_CapVigente  CHAR(1);
DECLARE Con_CapAtrasado CHAR(1);
DECLARE Con_CapVencido  CHAR(1);
DECLARE Con_CapVNE      CHAR(1);
DECLARE Con_CueOrdComFP INT;
DECLARE Con_CorOrdComFP INT;
DECLARE Con_CueOrdMora  INT;
DECLARE Con_CorOrdMora  INT;
DECLARE Con_CueOrdInte  INT;
DECLARE Con_CorOrdInte  INT;
DECLARE Con_EgreCondona INT;
DECLARE Con_IntDevenga  INT;
DECLARE Con_IntAtrasado INT;
DECLARE Con_IntVencido  INT;
DECLARE Con_ResultEPRC  INT;
DECLARE Con_Balance     INT;
DECLARE Con_PtePrinci   INT;
DECLARE Con_PteIntere   INT;
DECLARE Con_ResIntere   INT;
DECLARE Con_MoraDeven   INT;
DECLARE Con_BalIntere   INT;
DECLARE Con_IntMoraVenc INT;
DECLARE Con_BalAdiEPRC  INT;
DECLARE Con_PteAdiEPRC  INT;
DECLARE Con_ResAdiEPRC  INT;

DECLARE Mov_CapVigente  INT;
DECLARE Mov_CapAtrasado INT;
DECLARE Mov_CapVencido  INT;
DECLARE Mov_CapVNE      INT;
DECLARE Mov_ComFalPago  INT;
DECLARE Mov_IntMorato   INT;
DECLARE Mov_IntVencido  INT;
DECLARE Mov_IntAtraso   INT;
DECLARE Mov_IntProvis   INT;
DECLARE Mov_IntMorCarVen    INT;
DECLARE Mov_IntMorVencid    INT;
DECLARE Mov_IntNoConta  INT;
DECLARE Tol_DifPago     DECIMAL(10,4);
DECLARE Ref_Condona     VARCHAR(50);
DECLARE Mora_CtaOrden   CHAR(1);
DECLARE EPRC_Resultados CHAR(1);
DECLARE SI_DivideEPRC   CHAR(1);
DECLARE NO_DivideEPRC   CHAR(1);
DECLARE NO_EPRCAdicional    CHAR(1);
DECLARE SI_EPRCAdicional    CHAR(1);
DECLARE Var_Total       DECIMAL(12,2);
DECLARE	Mov_NotaCargoConIVA		INT(11);		-- Movimiento de credito por Nota de Cargo con iva
DECLARE	Mov_NotaCargoSinIVA		INT(11);		-- Movimiento de credito por Nota de Cargo sin iva
DECLARE	Mov_NotaCargoNoRecon	INT(11);		-- Movimiento de credito por Nota de Cargo no reconocido


DECLARE Auxiliar    INT(11);
DECLARE Num_Reg     INT(11);
DECLARE Var_Control VARCHAR(100);   -- CS tkt  13463  
DECLARE Var_TotalAdeudo  CHAR(1);
DECLARE Var_TotalExigible   DECIMAL(12,2);

DECLARE Con_CapVigenteSup		INT(11);		-- Concepto Contable: Capital Vigente Suspendido
DECLARE Con_CapAtrasadoSup		INT(11);		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
DECLARE Con_CapVencidoSup		INT(11);		-- Concepto Contable: Capital Vencido Suspendido
DECLARE Con_CapVenNoExSup		INT(11);		-- Concepto Contable: Capital Vencido no Exigible Suspendido
DECLARE Estatus_Suspendido		CHAR(1);		-- Estatus Suspendido
DECLARE Con_MoraDevenSup		INT(11);		-- Concepto Contable: Interes Moratorio Devengado Suspendido
DECLARE Con_MoraVencidoSup		INT(11);		-- Concepto Contable: Interes Moratorio Vencido Suspendido
DECLARE	Con_CtaOrdMorSup		INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
DECLARE	Con_CorIntMorSup		INT(11);		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido
DECLARE Con_IntDevenSup			INT(11);		-- Concepto Contable Interes Devengado Supencion
DECLARE Con_IntAtrasadoSup		INT(11);		-- Concepto Contable: Interes Atrasado Suspendido
DECLARE Con_IntVencidoSup		INT(11);		-- Concepto Contable: Interes Vencido Suspendido
DECLARE Con_CtaOrdIntSup		INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
DECLARE Con_CorIntOrdSup		INT(11);		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado
DECLARE Cons_Si             	CHAR(1);
DECLARE Cons_No             	CHAR(1);
DECLARE Modo_Pago           	CHAR(1);
DECLARE OrigenCargoCta			CHAR(1);
DECLARE	Con_CueOrdNotaCargo		INT(11);		-- Concepto Contable: Cta. Ord. Nota de Cargo
DECLARE	Con_CorOrdNotaCargo		INT(11);		-- Concepto Contable:Corr. Cta. Ord. Nota de Cargo
DECLARE Con_NotRecNotaCargo		INT(11);		-- Nota de Cargo Pago No Reconocido

DECLARE Con_PtePrinNotaCargo	INT(11);		-- Ingresos Nota de Cargo
DECLARE Con_PermCondonarCapVig VARCHAR(20);
DECLARE Tip_MovComGarDisLinCred		INT(11);	-- Tipo Movimiento Credito Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Tip_MovIVAComGarDisLinCred	INT(11);	-- Tipo Movimiento Credito IVA Comision por Garantia por Disposicion de Linea Credito Agro

DECLARE Con_CarCtaOrdenDeuAgro		INT(11);	-- Concepto Cuenta Ordenante Deudor Agro
DECLARE Con_CarCtaOrdenCorAgro		INT(11);	-- Concepto Cuenta Ordenante Corte Agro
DECLARE Con_CarComGarDisLinCred		INT(11);	-- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Con_CarIVAComGarDisLinCred	INT(11);	-- Concepto Cartera IVA Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Var_PagaIVA					CHAR(1);		-- Si el cliente paga IVA
DECLARE Var_SucursalID				INT(11);		-- Sucursal del Credito
DECLARE Con_SI						CHAR(1);		-- Constante SI
DECLARE Con_NO						CHAR(1);		-- Constante NO
DECLARE Var_IVASucursal				DECIMAL(12,2);	-- IVA de Sucursal
DECLARE Var_IVAComisionPago			DECIMAL(14,2);	-- Monto de IVA Comision de Pago

-- Asignacion  de constantes
SET Cadena_Vacia    := '';          -- Cadena Vacia
SET Entero_Cero     := 0;           -- Entero en Cero
SET SalidaNO        := 'N';         -- El store NO arroja una SALIDA
SET SalidaSI        := 'S';         -- El store SI arroja una SALIDA

SET Estatus_Pagado  := 'P';         -- Estatus Pagado
SET Estatus_Vigente := 'V';         -- Estatus Vigente
SET Estatus_Vencida := 'B';         -- Estatus Vencido
SET Estatus_Atraso  := 'A';         -- Estatus Atrasado

SET AltaPoliza_NO   := 'N';         -- Alta de la Poliza Contable: NO
SET AltaPoliza_SI   := 'S';         -- Alta de la Poliza Contable: SI
SET Pol_Automatica  := 'A';          -- Tipo de Alta de Poliza: Automatica
SET Con_Condona     := 57;          -- Proceso Contable de Condonacion
SET AltaPolCre_SI   := 'S';          -- Alta de la Poliza de Credito: SI
SET AltaMovCre_NO   := 'N';          -- Alta del Movimiento Credito: NO
SET AltaMovCre_SI   := 'S';           -- Alta del Movimiento Credito: SI
SET AltaMovAho_NO   := 'N';           -- Alta del Movimiento Ahorro: NO
SET Nat_Cargo       := 'C';         -- Naturaleza de Cargo
SET Nat_Abono       := 'A';         -- Naturaleza de Abono

SET Con_CapVigente  := 1;          -- Concepto Contable Cartera: Capital Vigente
SET Con_CapAtrasado := 2;          -- Concepto Contable Cartera: Capital Atrasado
SET Con_CapVencido  := 3;          -- Concepto Contable Cartera: Capital Vencido
SET Con_CapVNE      := 4;          -- Concepto Contable Cartera: Capital Vencido no Exigible
SET Con_CueOrdComFP := 15;          -- Concepto Contable Cartera: Cta. Orden Comision Falta Pago
SET Con_CorOrdComFP := 16;          -- Concepto Contable Cartera: Corr. Cta. Orden Com. Falta Pago
SET Con_CueOrdMora  := 13;          -- Concepto Contable Cartera: Cta. Orden Moratorios
SET Con_CorOrdMora  := 14;          -- Concepto Contable Cartera: Corr. Cta. Orden Moratorios
SET Con_CueOrdInte  := 11;          -- Concepto Contable Cartera: Cta. Orden Interes No Contabilizado
SET Con_CorOrdInte  := 12;          -- Concepto Contable Cartera: Corr. Cta. Orden Interes No Contabilizado
SET Con_EgreCondona := 24;          -- Concepto Contable Cartera: Egresos por Condonaciones
SET Con_IntDevenga  := 19;          -- Concepto Contable Cartera: Interes Devengado
SET Con_IntAtrasado := 20;          -- Concepto Contable Cartera: Interes Atrasado
SET Con_IntVencido  := 21;          -- Concepto Contable Cartera: Interes Vencido
SET Con_Balance     := 17;          -- Concepto Contable: EPRC, Balance
SET Con_ResultEPRC  := 18;          -- Concepto Contable Cartera: Estimacion Preventiva, Resultados-Gastos
SET Con_MoraDeven   := 33;          -- Concepto Contable: Interes Moratorio Devengado
SET Con_IntMoraVenc := 34;          -- Concepto Contable: Interes Moratorio Vencido
SET Con_BalIntere   := 36;          -- Concepto Contable: Balance. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
SET Con_ResIntere   := 37;          -- Concepto Contable: Resultados. Estimacion Prev. Riesgos Crediticios. Int.Ord y Moratorio
SET Con_PtePrinci   := 38;          -- Concepto Contable: EPRC Cta. Puente de Principal
SET Con_PteIntere   := 39;          -- Concepto Contable: EPRC Cta. Puente de Int.Normal y Moratorio
SET Con_BalAdiEPRC  := 49;          -- Concepto Contable: Balance EPRC Adicional Car.Vencida
SET Con_PteAdiEPRC  := 50;          -- Concepto Contable: EPRC Adicional Cta.Puente de Car.Vencida
SET Con_ResAdiEPRC  := 51;          -- Concepto Contable: Resultados EPRC Adicional de Car.Vencida

SET Mov_CapVigente  := 1;          -- Tipos de Movimiento de Credito: Capital Vigente
SET Mov_CapAtrasado := 2;          -- Tipos de Movimiento de Credito: Capital Atrasado
SET Mov_CapVencido  := 3;          -- Tipos de Movimiento de Credito: Capital Vencido
SET Mov_CapVNE      := 4;          -- Tipos de Movimiento de Credito: Capital Vencido no Exigible
SET Mov_ComFalPago  := 40;          -- Tipos de Movimiento de Credito: Comision por Falta de Pago
SET Mov_IntMorato   := 15;          -- Tipos de Movimiento de Credito: Interes Moratorio
SET Mov_IntVencido  := 12;          -- Tipos de Movimiento de Credito: Interes Vencido
SET Mov_IntAtraso   := 11;          -- Tipos de Movimiento de Credito: Interes Atrasado
SET Mov_IntProvis   := 14;          -- Tipos de Movimiento de Credito: Interes Provisionado
SET Mov_IntMorVencid    := 16;      -- Tipos de Movimiento de Credito: Interes Moratorio Vencido
SET Mov_IntMorCarVen    := 17;      -- Tipos de Movimiento de Credito: Interes Moratorio de Cartera Vencida
SET Mov_IntNoConta  := 13;          -- Tipos de Movimiento de Credito: Interes Devengado No Contabilizado
SET	Mov_NotaCargoConIVA	:= 53;		-- Movimiento de credito por Nota de Cargo con iva
SET	Mov_NotaCargoSinIVA	:= 54;		-- Movimiento de credito por Nota de Cargo sin iva
SET	Mov_NotaCargoNoRecon:= 55;		-- Movimiento de credito por Nota de Cargo no reconocido

SET Tol_DifPago     := 0.05;         -- Margen de Adeudo para Marcar la Cuota como Pagada
SET Mora_CtaOrden   := 'C';         -- Tipo de Contabilizacion de los Intereses Moratorios: En Cuentas de Orden
SET EPRC_Resultados := 'R';         -- Estimacion en Cuentas de Resultados
SET SI_DivideEPRC   := 'S';         -- SI Divide en la EPRC en Principal(Capital) e Interes
SET NO_DivideEPRC   := 'N';         -- NO Divide en la EPRC en Principal(Capital) e Interes
SET NO_EPRCAdicional    := 'N';     -- NO Realiza EPRC Adicional por el Interes Vencido
SET SI_EPRCAdicional    := 'S';     -- SI Realiza EPRC Adicional por el Interes Vencido
SET Var_TotalAdeudo     := 'T';     -- Total Adedudo (Comisiones,Moratorios, Intereses, Capital)

SET Con_CapVigenteSup		:= 110;		-- Concepto Contable: Capital Vigente Suspendido
SET Con_CapAtrasadoSup		:= 111;		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
SET Con_CapVencidoSup		:= 112;		-- Concepto Contable: Capital Vencido Suspendido
SET Con_CapVenNoExSup		:= 113;		-- Concepto Contable: Capital Vencido no Exigible Suspendido

SET Con_IntDevenSup			:= 114;		-- Concepto Contable Interes Devengado Ssupencion
SET Con_IntAtrasadoSup		:= 115;		-- Concepto Contable: Interes Atrasado Suspendido
SET Con_IntVencidoSup		:= 116;		-- Concepto Contable: Interes Vencido
SET Con_CtaOrdIntSup		:= 119;		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
SET Con_CorIntOrdSup		:= 120;		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado

SET Con_MoraDevenSup		:= 117;		-- Concepto Contable: Interes Moratorio Devengado Suspendido
SET Con_MoraVencidoSup		:= 118;		-- Concepto Contable: Interes Moratorio Vencido Suspendido
SET	Con_CtaOrdMorSup		:= 121;		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
SET	Con_CorIntMorSup		:= 122;		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido
SET	Con_CueOrdNotaCargo		:= 136;		-- Concepto Contable: Cta. Ord. Nota de Cargo
SET	Con_CorOrdNotaCargo		:= 137;		-- Concepto Contable: Corr. Cta. Ord. Nota de Cargo
SET Con_NotRecNotaCargo		:= 133;		-- Nota de Cargo Pago No Reconocido
SET Tip_MovComGarDisLinCred		:= 57;
SET Tip_MovIVAComGarDisLinCred	:= 58;

SET Con_CarCtaOrdenDeuAgro		:= 138;
SET Con_CarCtaOrdenCorAgro		:= 139;
SET Con_CarComGarDisLinCred 	:= 143;
SET Con_CarIVAComGarDisLinCred	:= 145;
SET Con_SI						:= 'S';
SET Con_NO						:= 'N';
SET Con_PtePrinNotaCargo	:= 000;		-- Ingresos Nota de Cargo


SET Estatus_Suspendido		:= 'S';		-- Estatus Suspendido
SET Cons_Si					:= 'S';
SET Cons_No					:= 'N';
SET Modo_Pago				:= 'C';
SET OrigenCargoCta			:= 'C';
SET Ref_Condona				:= 'CONDONACION CARTERA';
SET Var_Total				:= 0.00;
SET Con_PermCondonarCapVig	:= 'PermCondonarCapVig';

SET Num_Reg := 0;
SET Auxiliar := 0;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	   SET Par_NumErr  = 999;
	   SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				  'Disculpe las molestias que esto le ocasiona. Ref: SP-CREQUITASPRO');
	   SET Var_Control := 'sqlException' ;

	END;

	SELECT FechaSistema, TipoContaMora INTO Var_FechaSistema, Var_TipoContaMora
	 FROM PARAMETROSSIS
	WHERE EmpresaID = Par_EmpresaID;
	SET Par_NumErr  := Entero_Cero;
	SET Par_EmpresaID := IFNULL(Par_EmpresaID, 1);

	SET Var_PagoPerdCentRedond 	:= FNPARAMGENERALES('PagoPerdCentRedond');
	SET Var_PagoMontoMaxPerd 	:= FNPARAMGENERALES('PagoMontoMaxPerd');
	SET Var_CuentaContablePerd 	:= FNPARAMGENERALES('CuentaContablePerd');
	SET Var_PermCondonarCapVig 	:= FNPARAMGENERALES(Con_PermCondonarCapVig);
	SET Var_PagoComFaltaPagAnt  := FNPARAMGENERALES('PagoComFaltPagAntOtrasComis');

	SET Var_Total := (Par_MontoComisiones +   Par_MontoMoratorios +    Par_MontoInteres    + Par_MontoCapital + Par_MontoNotasCargo) ;

    IF( Var_PagoPerdCentRedond =Cadena_Vacia ) THEN
		SET Var_PagoPerdCentRedond := Cons_No;
    END IF;

	IF(Var_PagoPerdCentRedond=Cons_No) THEN
    SET Tol_DifPago := Var_PagoMontoMaxPerd;
    END IF;


	IF(Var_Total = Entero_Cero) THEN
		SET Par_NumErr      := 001;
		SET Par_ErrMen      := 'Debe indicar al menos un concepto  con monto a condonar';
		SET Par_Consecutivo := 0;
		LEAVE ManejoErrores;
	END IF;

	SET Var_PermCondonarCapVig := IFNULL(Var_PermCondonarCapVig, Cons_No);

	IF (Var_PermCondonarCapVig = Cons_Si) THEN

		INSERT INTO TMP_QUITASCONDONACIONES(
			AmortizacionID,			EmpresaID,				MonedaID,				Estatus,					SucursalOrigen,
			ProductoCreditoID,		Clasificacion,			SaldoCapVigente,		SaldoCapAtrasa,				SaldoCapVencido,
			SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresPro,			SaldoIntNoConta,
			SaldoMoratorios,		SaldoComFaltaPa,		SaldoOtrasComis,		SaldoInteresVen,			SubClasifID,
			SaldoMoraVencido,		SaldoMoraCarVen,		SaldoNotCargoRev,		SaldoNotCargoSinIVA,		SaldoNotCargoConIVA,
			SaldoComServGar,		Aud_NumTransaccion)
		SELECT
			AmortizacionID,			Cre.EmpresaID,			Cre.MonedaID,			Cre.Estatus,				Cli.SucursalOrigen,
			Cre.ProductoCreditoID,	Des.Clasificacion,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasa,			Amo.SaldoCapVencido,
			Amo.SaldoCapVenNExi,	Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,	Amo.SaldoInteresPro,		Amo.SaldoIntNoConta,
			Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,	Amo.SaldoOtrasComis,	Amo.SaldoInteresVen,		Des.SubClasifID,
			Amo.SaldoMoraVencido,	Amo.SaldoMoraCarVen,	Amo.SaldoNotCargoRev,	Amo.SaldoNotCargoSinIVA,	Amo.SaldoNotCargoConIVA,
			Amo.SaldoComServGar,	Aud_NumTransaccion
		FROM AMORTICREDITO Amo
		INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE Cre.CreditoID = Par_CreditoID
		  AND (Amo.Estatus = Estatus_Vigente OR Amo.Estatus = Estatus_Atraso OR Amo.Estatus = Estatus_Vencida)
		  AND (Cre.Estatus = Estatus_Vigente OR Cre.Estatus = Estatus_Vencida OR Cre.Estatus = Estatus_Suspendido)
		ORDER BY Amo.FechaInicio;
	ELSE

		INSERT INTO TMP_QUITASCONDONACIONES(
			AmortizacionID,			EmpresaID,				MonedaID,				Estatus,					SucursalOrigen,
			ProductoCreditoID,		Clasificacion,			SaldoCapVigente,		SaldoCapAtrasa,				SaldoCapVencido,
			SaldoCapVenNExi,		SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresPro,			SaldoIntNoConta,
			SaldoMoratorios,		SaldoComFaltaPa,		SaldoOtrasComis,		SaldoInteresVen,			SubClasifID,
			SaldoMoraVencido,		SaldoMoraCarVen,		SaldoNotCargoRev,		SaldoNotCargoSinIVA,		SaldoNotCargoConIVA,
			SaldoComServGar,		Aud_NumTransaccion)
		SELECT
			AmortizacionID,			Cre.EmpresaID,			Cre.MonedaID,			Cre.Estatus,				Cli.SucursalOrigen,
			Cre.ProductoCreditoID,	Des.Clasificacion,		Amo.SaldoCapVigente,	Amo.SaldoCapAtrasa,			Amo.SaldoCapVencido,
			Amo.SaldoCapVenNExi,	Amo.SaldoInteresOrd,	Amo.SaldoInteresAtr,	Amo.SaldoInteresPro,		Amo.SaldoIntNoConta,
			Amo.SaldoMoratorios,	Amo.SaldoComFaltaPa,	Amo.SaldoOtrasComis,	Amo.SaldoInteresVen,		Des.SubClasifID,
			Amo.SaldoMoraVencido,	Amo.SaldoMoraCarVen,	Amo.SaldoNotCargoRev,	Amo.SaldoNotCargoSinIVA,	Amo.SaldoNotCargoConIVA,
			Amo.SaldoComServGar,	Aud_NumTransaccion
		FROM AMORTICREDITO Amo
		INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
		INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE Cre.CreditoID = Par_CreditoID
		  AND Amo.FechaInicio <= Var_FechaSistema
		  AND (Amo.Estatus = Estatus_Vigente OR Amo.Estatus = Estatus_Atraso OR Amo.Estatus = Estatus_Vencida)
		  AND (Cre.Estatus = Estatus_Vigente OR Cre.Estatus = Estatus_Vencida OR Cre.Estatus = Estatus_Suspendido)
		ORDER BY Amo.FechaInicio;
	END IF;

SELECT RegContaEPRC, DivideEPRCCapitaInteres, EPRCAdicional INTO Var_RegContaEPRC, Var_DivideEPRC, Var_EPRCAdicional
	FROM PARAMSRESERVCASTIG
	WHERE EmpresaID = Par_EmpresaID;

SET Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
SET Var_DivideEPRC  := IFNULL(Var_DivideEPRC, NO_DivideEPRC);
SET Var_TipoContaMora := IFNULL(Var_TipoContaMora, Mora_CtaOrden);
SET Var_EPRCAdicional   := IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);

CALL DIASFESTIVOSCAL(
	Var_FechaSistema,   Entero_Cero,        Var_FechaSistema,   Var_EsHabil,        Par_EmpresaID,
	Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
	Aud_NumTransaccion);

SET Par_FechaRegistro   := Var_FechaSistema;

	SELECT  NumAmortizacion, Estatus, ClienteID ,	SucursalID
	INTO Var_NumAmorti, Var_EstCredito, Var_ClienteID,	Var_SucursalID
	FROM CREDITOS
	WHERE CreditoID = Par_CreditoID;

	SELECT PagaIVA
	INTO Var_PagaIVA
	FROM CLIENTES
	WHERE ClienteID = Var_ClienteID;

	SET Var_PagaIVA	:= IFNULL(Var_PagaIVA, Con_NO);
	IF( Var_PagaIVA = Con_SI ) THEN
		SELECT IVA
		INTO Var_IVASucursal
		FROM SUCURSALES
		WHERE SucursalID = Var_SucursalID;

		SET Var_IVASucursal := IFNULL(Var_IVASucursal, Entero_Cero);
	END IF;

SET Var_NumAmorti   := IFNULL(Var_NumAmorti, Entero_Cero);
SET Var_EstCredito  := IFNULL(Var_EstCredito, Cadena_Vacia);

IF(Var_EstCredito = Cadena_Vacia) THEN
	SET Par_NumErr      := 002;
	SET Par_ErrMen      := 'El Credito no Existe.';
	SET Par_Consecutivo := 0;
	LEAVE ManejoErrores;
END IF;

    -- Contamos la cantidad de amortizaciones Vencidas solo para creditos suspendidos.
    IF(Var_EstCredito = Estatus_Suspendido) THEN   -- CS tkt 13463
        SELECT COUNT(AmortizacionID)
          INTO Var_CantAmoVenSusp
          FROM AMORTICREDITO
          WHERE CreditoID = Par_CreditoID
          AND Estatus = Estatus_Vencida;
    END IF;
    SET Var_CantAmoVenSusp := IFNULL(Var_CantAmoVenSusp, Entero_Cero);

	-- Alta del Registro de la Quita o Condonacion
	CALL CREQUITASALT(	Par_CreditoID,			Par_UsuarioID,			Par_PuestoID,			Par_FechaRegistro,
						Par_MontoComisiones,	Par_PorceComisiones,	Par_MontoMoratorios,	Par_PorceMoratorios,
						Par_MontoInteres,		Par_PorceInteres,		Par_MontoCapital,		Par_PorceCapital,
						Par_MontoNotasCargo,	Par_PorceNotasCargo,	SalidaNO,				Par_NumErr,
						Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

	IF (Par_NumErr > Entero_Cero ) THEN
		LEAVE ManejoErrores;
	END IF;

    -- Alta de la Poliza Contable
    IF (Par_AltaPoliza = AltaPoliza_SI) THEN
        CALL MAESTROPOLIZASALT(
            Par_Poliza,     Par_EmpresaID,  Par_FechaRegistro,  Pol_Automatica,     Con_Condona,
            Ref_Condona,    SalidaNO,       Par_NumErr,         Par_ErrMen,         Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP, Aud_ProgramaID,    Aud_Sucursal,   Aud_NumTransaccion);

        IF (Par_NumErr > Entero_Cero ) THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SET Var_SaldoCondCom    := Par_MontoComisiones;
    SET Var_SaldoCondMora   := Par_MontoMoratorios;
    SET Var_SaldoCondIntere := Par_MontoInteres;
    SET Var_SaldoCondCap    := Par_MontoCapital;
    SET Var_SaldoCondNotaCargo    := Par_MontoNotasCargo;
    SET Var_MontoCondonar   := Entero_Cero;

    -- Inicializacion
    SET Par_Consecutivo     := 1;
    SET Par_NumErr          := Entero_Cero;
    SET Par_ErrMen          := Cadena_Vacia;

    SET Num_Reg := (SELECT COUNT(AmortizacionID) FROM TMP_QUITASCONDONACIONES);
    SET Num_Reg := IFNULL(Num_Reg,Entero_Cero);

    SET Auxiliar := 0;

    WHILE  Auxiliar < Num_Reg  DO

            SELECT  TMP.AmortizacionID,     TMP.EmpresaID,          TMP.MonedaID,           TMP.Estatus,
                    TMP.SucursalOrigen,     TMP.ProductoCreditoID,  TMP.Clasificacion,      TMP.SaldoCapVigente,
                    TMP.SaldoCapAtrasa,     TMP.SaldoCapVencido,    TMP.SaldoCapVenNExi,    TMP.SaldoInteresOrd,
                    TMP.SaldoInteresAtr,                            TMP.SaldoInteresPro,    TMP.SaldoIntNoConta,
                    TMP.SaldoMoratorios,    TMP.SaldoComFaltaPa,    TMP.SaldoOtrasComis,    TMP.SaldoInteresVen,
                    TMP.SubClasifID,        TMP.SaldoMoraVencido,   TMP.SaldoMoraCarVen,	TMP.SaldoNotCargoRev,
                    TMP.SaldoNotCargoSinIVA,TMP.SaldoNotCargoConIVA,TMP.SaldoComServGar
            INTO
                    Var_AmortizacionID,     Var_EmpresaID,          Var_MonedaID,           Var_CreEstatus,
                    Var_SucursalOrigen,     Var_ProdCreditoID,      Var_ClasifCre,          Var_SaldoCapVigente,
                    Var_SaldoCapAtrasa,     Var_SaldoCapVencido,    Var_SaldoCapVenNExi,    Var_SaldoInteresOrd,
                    Var_SaldoInteresAtr,                            Var_SaldoInteresPro,    Var_SaldoIntNoConta,
                    Var_SaldoMoratorios,    Var_SaldoComFaltaPa,    Var_SaldoOtrasComis,    Var_SaldoInterVenc,
                    Var_SubClasifID,        Var_SaldoMoraVencid,    Var_SaldoMoraCarVen,	Var_SaldoNotCargoRev,
                    Var_SaldoNotCargoSinIVA,Var_SaldoNotCargoConIVA,Var_SaldoComServGar
            FROM TMP_QUITASCONDONACIONES TMP WHERE TMP.Aud_NumTransaccion = Aud_NumTransaccion LIMIT Auxiliar,1;

            SET Var_MontoCondonar   := Entero_Cero;
            SET Par_NumErr          := Entero_Cero;
            SET Par_ErrMen          := Cadena_Vacia;
            SET Var_SaldoMoraVencid := IFNULL(Var_SaldoMoraVencid, Entero_Cero);
            SET Var_SaldoMoraCarVen := IFNULL(Var_SaldoMoraCarVen, Entero_Cero);
            SET Var_SaldoNotCargoRev := IFNULL(Var_SaldoNotCargoRev, Entero_Cero);
            SET Var_SaldoNotCargoSinIVA := IFNULL(Var_SaldoNotCargoSinIVA, Entero_Cero);
            SET Var_SaldoNotCargoConIVA := IFNULL(Var_SaldoNotCargoConIVA, Entero_Cero);

            -- ---------------------------------------------------------------------------
            -- TODO: Si ya no hay Saldo en Ningun Rubro de Condonacion, entonces Salimos
            -- ---------------------------------------------------------------------------
            -- ---------------------------------------------------------------------------
			-- ======================= INICIO DE CONDONACION DE NOTAS CARGOS ================
			-- ==============================================================================
			-- Realizamos la condonacion del concepto de notas de cargo con IVA
			IF ( Var_SaldoNotCargoConIVA > Entero_Cero AND Var_SaldoCondNotaCargo > Entero_Cero) THEN
				IF (Var_SaldoNotCargoConIVA > Var_SaldoCondNotaCargo) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondNotaCargo;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoNotCargoConIVA;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	= Mov_NotaCargoConIVA;	-- Movimiento credito 53
				SET Mov_AboConta	= Con_CorOrdNotaCargo;	-- No Concepto: 137
				SET Mov_CarConta	= Con_CueOrdNotaCargo;	-- No Concepto: 136

				-- Se realiza el abono  a la cuenta correlativa orden por nota de cargo
				CALL  CONTACREDITOSPRO (Par_CreditoID,			Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
										Par_FechaRegistro,		Var_MontoCondonar,		Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
										Var_SubClasifID,		Var_SucursalOrigen,		Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
										Entero_Cero,			Par_Poliza,				AltaPolCre_SI,		AltaMovCre_SI,		Mov_AboConta,
										Mov_AboOpera,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,			SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
										Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr > Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				-- Realizamos el movimiento de cargo a la cuenta orden por nota de cargo
				CALL  CONTACREDITOSPRO( Par_CreditoID,			Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
										Par_FechaRegistro,		Var_MontoCondonar,		Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
										Var_SubClasifID,		Var_SucursalOrigen,		Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
										Entero_Cero,			Par_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,		Mov_CarConta,
										Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,			SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
										Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				SET Var_SaldoCondNotaCargo	:= Var_SaldoCondNotaCargo - Var_MontoCondonar;
				SET Par_Consecutivo		:= Par_Consecutivo + 1;

				UPDATE AMORTICREDITO
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
			END IF;

			-- Realizamos la condonacion del concepto de notas de cargo sin IVA
			IF ( Var_SaldoNotCargoSinIVA > Entero_Cero AND Var_SaldoCondNotaCargo > Entero_Cero) THEN

				IF (Var_SaldoNotCargoSinIVA > Var_SaldoCondNotaCargo) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondNotaCargo;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoNotCargoSinIVA;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	= Mov_NotaCargoSinIVA;	-- Movimiento credito 54
				SET Mov_AboConta	= Con_CorOrdNotaCargo;	-- No Concepto: 137
				SET Mov_CarConta	= Con_CueOrdNotaCargo;	-- No Concepto: 136

				-- Se realiza el abono  a la cuenta correlativa orden por nota de cargo
				CALL  CONTACREDITOSPRO (Par_CreditoID,			Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
										Par_FechaRegistro,		Var_MontoCondonar,		Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
										Var_SubClasifID,		Var_SucursalOrigen,		Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
										Entero_Cero,			Par_Poliza,				AltaPolCre_SI,		AltaMovCre_SI,		Mov_AboConta,
										Mov_AboOpera,			Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,			SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
										Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr > Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				-- Realizamos el movimiento de cargo a la cuenta orden por nota de cargo
				CALL  CONTACREDITOSPRO( Par_CreditoID,			Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
										Par_FechaRegistro,		Var_MontoCondonar,		Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
										Var_SubClasifID,		Var_SucursalOrigen,		Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
										Entero_Cero,			Par_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,		Mov_CarConta,
										Entero_Cero,			Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,			SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
										Par_EmpresaID,			Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr > Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_SaldoCondNotaCargo	:= Var_SaldoCondNotaCargo - Var_MontoCondonar;
				SET Par_Consecutivo		:= Par_Consecutivo + 1;

				UPDATE AMORTICREDITO
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
			END IF;

			-- Realizamos la condonacion del concepto de notas cargo no reconocido
			IF ( Var_SaldoNotCargoRev > Entero_Cero AND Var_SaldoCondNotaCargo > Entero_Cero) THEN

				IF ((Var_SaldoNotCargoRev ) > Var_SaldoCondNotaCargo) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondNotaCargo;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoNotCargoRev;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_NotaCargoNoRecon;	-- Tipo de movimiento del credito 55
				SET Mov_AboConta	:= Con_NotRecNotaCargo;		-- No Concepto: 133

				SET Mov_CarConta	:= Con_PtePrinNotaCargo; -- No Concepto: 000

				CALL CONTACREDITOSPRO (	Par_CreditoID,		Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
										Par_FechaRegistro,	Var_MontoCondonar,		Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
										Var_SubClasifID,	Var_SucursalOrigen,		Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
										Entero_Cero,		Par_Poliza,				AltaPolCre_SI,		AltaMovCre_SI,		Mov_AboConta,
										Mov_AboOpera,		Nat_Abono,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,		SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
										Par_EmpresaID,		Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr > Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				CALL CONTACREDITOSPRO (	Par_CreditoID,		Var_AmortizacionID,		Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
										Par_FechaRegistro,	Var_MontoCondonar,		Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
										Var_SubClasifID,	Var_SucursalOrigen,		Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
										Entero_Cero,		Par_Poliza,				AltaPolCre_SI,		AltaMovCre_NO,		Mov_CarConta,
										Entero_Cero,		Nat_Cargo,				AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
										Cadena_Vacia,		SalidaNO,				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
										Par_EmpresaID,		Cadena_Vacia,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				SET Var_SaldoCondNotaCargo	:= Var_SaldoCondNotaCargo - Var_MontoCondonar;
				SET Par_Consecutivo		:= Par_Consecutivo + 1;

				UPDATE AMORTICREDITO
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
			END IF;
			-- ======================== FIN DE CONDONACION DE NOTAS CARGOS ==================
			-- ==============================================================================

			IF( Var_SaldoComServGar > Entero_Cero AND Var_SaldoCondCom > Entero_Cero ) THEN

				IF( Var_SaldoComServGar > Var_SaldoCondCom ) THEN
					SET Var_MontoCondonar := Var_SaldoCondCom;
				ELSE
					SET Var_MontoCondonar := Var_SaldoComServGar;
				END IF;

				SET Mov_AboOpera := Tip_MovComGarDisLinCred;
				SET Mov_AboConta := Con_CarCtaOrdenDeuAgro;
				SET Mov_CarConta := Con_CarCtaOrdenCorAgro;

				-- Cargo de Movimiento Operativo de la comision
				CALL CONTACREDITOSPRO (
					Par_CreditoID,		Var_AmortizacionID,	Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
					Par_FechaRegistro,	Var_MontoCondonar,	Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
					Var_SubClasifID,	Var_SucursalOrigen,	Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
					Entero_Cero,		Par_Poliza,			AltaPolCre_SI,		AltaMovCre_SI,		Mov_AboConta,
					Mov_AboOpera,		Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
					Cadena_Vacia, 		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
					Par_EmpresaID,		Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- Abono de Movimiento Operativo de la comision
				CALL CONTACREDITOSPRO (
					Par_CreditoID,		Var_AmortizacionID,	Entero_Cero,		Entero_Cero,		Par_FechaRegistro,
					Par_FechaRegistro,	Var_MontoCondonar,	Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,
					Var_SubClasifID,	Var_SucursalOrigen,	Ref_Condona,		Par_PuestoID,		AltaPoliza_NO,
					Entero_Cero,		Par_Poliza,			AltaPolCre_SI,		AltaMovCre_NO,		Mov_CarConta,
					Entero_Cero,		Nat_Cargo,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
					Cadena_Vacia, 		SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
					Par_EmpresaID,		Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				IF( Var_PagaIVA = Con_SI ) THEN
					SET Var_IVAComisionPago := ROUND((Var_MontoCondonar * Var_IVASucursal), 2);
					SET Var_IVAComisionPago := IFNULL(Var_IVAComisionPago,Entero_Cero);
				END IF;

				-- Se resta el monto pagado por concepto de IVA si paga para el credito y la amortizacion
				UPDATE AMORTICREDITO SET
					SaldoIVAComSerGar  = IFNULL(SaldoIVAComSerGar, Entero_Cero) - Var_IVAComisionPago,
					NumTransaccion	  = Aud_NumTransaccion
				WHERE AmortizacionID = Var_AmortizacionID
				  AND CreditoID = Par_CreditoID;

				-- Se resta el monto pagado por concepto de IVA si paga para el credito y la amortizacion
				UPDATE CREDITOS SET
					SaldoIVAComSerGar  = IFNULL(SaldoIVAComSerGar, Entero_Cero) - Var_IVAComisionPago
				WHERE CreditoID = Par_CreditoID;

				SET Var_SaldoCondCom := Var_SaldoCondCom - Var_MontoCondonar;
				SET Par_Consecutivo  := Par_Consecutivo + 1;
			END IF;



			IF (Var_PagoComFaltaPagAnt = Cons_Si) THEN -- ctomas Tkt 15722 Valida si se realiza el pago de comision por falta de pago antes que otras comisiones
				-- ---------------------------------------------------------------------------
				--  Condonacion de Comision por Falta de Pago
				-- ---------------------------------------------------------------------------
				IF ((Var_SaldoComFaltaPa) > Entero_Cero AND Var_SaldoCondCom > Entero_Cero) THEN

					IF ((Var_SaldoComFaltaPa ) > Var_SaldoCondCom) THEN
						SET Var_MontoCondonar   := Var_SaldoCondCom;
					ELSE
						SET Var_MontoCondonar   := Var_SaldoComFaltaPa;
					END IF;

					-- Registro Contable
					SET Mov_AboOpera    := Mov_ComFalPago;
					SET Mov_AboConta    := Con_CueOrdComFP; -- No Concepto: 15
					SET Mov_CarConta    := Con_CorOrdComFP; -- No Concepto: 16

					CALL  CONTACREDITOSPRO (
						Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
						Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
						Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
						Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
						Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);

					IF (Par_NumErr > Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
						Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
						Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
						Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
						Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
						Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);

					IF (Par_NumErr > Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_SaldoCondCom    := Var_SaldoCondCom - Var_MontoCondonar;
					SET Par_Consecutivo     := Par_Consecutivo + 1;

					UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;
				END IF;
			END IF;

            --  Condonacion de Otros Accesorios
            -- ---------------------------------------------------------------------------
            IF ( Var_SaldoOtrasComis > Entero_Cero AND Var_SaldoCondCom > Entero_Cero) THEN
                IF (( Var_SaldoOtrasComis) > Var_SaldoCondCom) THEN
                    SET Var_MontoCondonar   := Var_SaldoCondCom;
                ELSE
                    SET Var_MontoCondonar   := Var_SaldoOtrasComis;
                END IF;

                CALL `CONDONACREOTRASCOMISPRO`(
                    Par_CreditoID,      Var_AmortizacionID, Par_FechaRegistro,      Par_FechaRegistro,      Var_MontoCondonar,
                    Entero_Cero,        Var_MonedaID,       Var_ProdCreditoID,      Var_ClasifCre,          Var_SubClasifID,
                    Var_SucursalOrigen, Ref_Condona,        Par_Poliza,             SalidaNO,               Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,          Cadena_Vacia,           Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;

                SET Var_SaldoCondCom    := Var_SaldoCondCom - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

            END IF;

			IF (Var_PagoComFaltaPagAnt <> Cons_Si) THEN -- CTOMAS Tkt 15722
				-- ---------------------------------------------------------------------------
				--  Condonacion de Comision por Falta de Pago
				-- ---------------------------------------------------------------------------
				IF ((Var_SaldoComFaltaPa) > Entero_Cero AND Var_SaldoCondCom > Entero_Cero) THEN

					IF ((Var_SaldoComFaltaPa ) > Var_SaldoCondCom) THEN
						SET Var_MontoCondonar   := Var_SaldoCondCom;
					ELSE
						SET Var_MontoCondonar   := Var_SaldoComFaltaPa;
					END IF;

					-- Registro Contable
					SET Mov_AboOpera    := Mov_ComFalPago;
					SET Mov_AboConta    := Con_CueOrdComFP; -- No Concepto: 15
					SET Mov_CarConta    := Con_CorOrdComFP; -- No Concepto: 16

					CALL  CONTACREDITOSPRO (
						Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
						Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
						Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
						Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
						Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
						Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);

					IF (Par_NumErr > Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL  CONTACREDITOSPRO (
						Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
						Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
						Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
						Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
						Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
						Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
						Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
						Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
						Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
						Aud_Sucursal,       Aud_NumTransaccion);

					IF (Par_NumErr > Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_SaldoCondCom    := Var_SaldoCondCom - Var_MontoCondonar;
					SET Par_Consecutivo     := Par_Consecutivo + 1;

					UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;
				END IF;
			END IF;

			--  Condonacion de Moratorios - "Ordinarios"
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoMoratorios > Entero_Cero AND Var_SaldoCondMora > Entero_Cero) THEN

				IF (Var_SaldoMoratorios > Var_SaldoCondMora) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondMora;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoMoratorios;
				END IF;

				SET Mov_AboOpera	:= Mov_IntMorato;

				-- Registro Contable
				-- Verifica como estan Contabilizados los Moratorios. En Cuentas de Orden
				IF(Var_TipoContaMora = Mora_CtaOrden) THEN

					IF (Var_CreEstatus = Estatus_Suspendido) THEN
						SET Mov_AboConta	:= Con_CtaOrdMorSup;	-- No Concepto: 121
						SET Mov_CarConta	:= Con_CorIntMorSup;	-- No Concepto: 122
					END IF;

					IF (Var_CreEstatus != Estatus_Suspendido) THEN
						SET Mov_AboConta	:= Con_CueOrdMora;	-- No Concepto: 13
						SET Mov_CarConta	:= Con_CorOrdMora;	-- No Concepto: 14
					END IF;

                    CALL  CONTACREDITOSPRO (
                        Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                        Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                        Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                        Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                        Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                        Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                        Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr > Entero_Cero ) THEN
                        LEAVE ManejoErrores;
                    END IF;

                    CALL  CONTACREDITOSPRO (
                        Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                        Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                        Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                        Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                        Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                        Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr > Entero_Cero ) THEN
                        LEAVE ManejoErrores;
                    END IF;

                ELSE    -- Los Moratorios se devengan y contabilizan en Cuenta de Ingresos.

                    -- Entonces se Condonan vs Cuenta de Estimacion-Gastos (EPRC)

                    SET Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
                    SET Var_DivideEPRC  := IFNULL(Var_DivideEPRC, NO_DivideEPRC);
                    SET Var_TipoContaMora := IFNULL(Var_TipoContaMora, Mora_CtaOrden);

					IF (Var_CreEstatus = Estatus_Suspendido) THEN
						SET Mov_AboConta	:= Con_MoraDevenSup;	-- No Concepto: 117
					END IF;

					IF (Var_CreEstatus != Estatus_Suspendido) THEN
						SET Mov_AboConta	:= Con_MoraDeven;	-- No Concepto: 33
					END IF;

                    CALL  CONTACREDITOSPRO (
                        Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                        Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                        Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                        Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                        Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                        Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                        Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr > Entero_Cero ) THEN
                        LEAVE ManejoErrores;
                    END IF;


                    -- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
                    -- A la EPRC derivada de la Calificacion de Cartera
                    IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
                        -- Verificamos si Divide la Estimacion en Capital e Interes
                        IF(Var_DivideEPRC = NO_DivideEPRC) THEN
                            -- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
                            IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                                SET Mov_CarConta    := Con_ResultEPRC;  -- No Concepto: 18
                            ELSE
                                SET Mov_CarConta    := Con_PtePrinci;   -- No Concepto: 38
                            END IF;
                        ELSE
                            -- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
                            IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                                SET Mov_CarConta    := Con_ResIntere;   -- No Concepto: 37
                            ELSE
                                SET Mov_CarConta    := Con_PteIntere;   -- No Concepto: 39
                            END IF;

                        END IF;

                    ELSE -- Estimacion Adicional por la Reserva del Interes Vencido

                        -- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
                        IF(Var_RegContaEPRC = EPRC_Resultados) THEN
                            SET Mov_CarConta    := Con_ResAdiEPRC;  -- No Concepto: 51
                        ELSE
                            SET Mov_CarConta    := Con_PteAdiEPRC;  -- No Concepto: 50
                        END IF;
                    END IF;

                    CALL  CONTACREDITOSPRO (
                        Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                        Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                        Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                        Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                        Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                        Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                    IF (Par_NumErr > Entero_Cero ) THEN
                        LEAVE ManejoErrores;
                    END IF;

                END IF;

                SET Var_SaldoCondMora   := Var_SaldoCondMora - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

                UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Moratorios de Cartera Vencida, Cuentas de Orden
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoMoraCarVen > Entero_Cero AND Var_SaldoCondMora > Entero_Cero) THEN

				IF (Var_SaldoMoraCarVen > Var_SaldoCondMora) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondMora;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoMoraCarVen;
				END IF;

				SET Mov_AboOpera	:= Mov_IntMorCarVen;

				-- Registro Contable
				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CtaOrdMorSup;	-- No Concepto: 121
					SET Mov_CarConta	:= Con_CorIntMorSup;	-- No Concepto: 122
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CueOrdMora;	-- No Concepto: 13
					SET Mov_CarConta	:= Con_CorOrdMora;	-- No Concepto: 14
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondMora   := Var_SaldoCondMora - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

                UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Interes Moratorio Vencido.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoMoraVencid > Entero_Cero AND Var_SaldoCondMora > Entero_Cero) THEN

				IF (Var_SaldoMoraVencid > Var_SaldoCondMora) THEN
					SET Var_MontoCondonar   := Var_SaldoCondMora;
				ELSE
					SET Var_MontoCondonar   := Var_SaldoMoraVencid;
				END IF;

				-- Dado que el Saldo del Moratorio Vencido, fue estimado al 100%, al momento de hacer el traspaso a Cartera Vencida
				-- En su condonacion se Cancela de la Cuenta de Estimacion - Balance

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_IntMorVencid;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_MoraVencidoSup;	-- No Concepto: 118
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntMoraVenc;	-- No Concepto: 34
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                -- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
                -- A la EPRC derivada de la Calificacion de Cartera
                IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
                    -- Verificamos si Divide la Estimacion en Capital e Interes
                    IF(Var_DivideEPRC = NO_DivideEPRC) THEN
                        SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
                    ELSE
                        SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
                    END IF;
                ELSE
                    SET Mov_CarConta    := Con_BalAdiEPRC;  -- No Concepto: 49
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondMora   := Var_SaldoCondMora - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Interes Vencido.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoInterVenc > Entero_Cero AND Var_SaldoCondIntere > Entero_Cero) THEN

				IF (Var_SaldoInterVenc > Var_SaldoCondIntere) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondIntere;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoInterVenc;
				END IF;

				-- Dado que el Saldo del Interes Vencido, fue estimado al 100%, al momento de hacer el traspaso a Cartera Vencida
				-- En su condonacin se Cancela de la Cuenta de Estimacion - Balance

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_IntVencido;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntVencidoSup;	-- No Concepto: 116
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntVencido;	-- No Concepto: 21
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                -- Verifica si la Estimacion del Interes Vencido lo lleva en cuenta diferenciadas
                -- A la EPRC derivada de la Calificacion de Cartera
                IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN
                    -- Verificamos si Divide la Estimacion en Capital e Interes
                    IF(Var_DivideEPRC = NO_DivideEPRC) THEN
                        SET Mov_CarConta    := Con_Balance;     -- No Concepto: 17
                    ELSE
                        SET Mov_CarConta    := Con_BalIntere;   -- No Concepto: 36
                    END IF;
                ELSE
                    SET Mov_CarConta    := Con_BalAdiEPRC;  -- No Concepto: 49
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondIntere := Var_SaldoCondIntere - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Interes Atrasado.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoInteresAtr > Entero_Cero AND Var_SaldoCondIntere > Entero_Cero) THEN

				IF (Var_SaldoInteresAtr > Var_SaldoCondIntere) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondIntere;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoInteresAtr;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_IntAtraso;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntAtrasadoSup;	-- No Concepto: 115
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntAtrasado;	-- No Concepto: 20
				END IF;

				SET Mov_CarConta	:= Con_EgreCondona;	-- No Concepto: 24

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,            Par_FechaRegistro,
                    Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,       Var_ProdCreditoID,      Var_ClasifCre,
                    Var_SubClasifID,    Var_SucursalOrigen, Ref_Condona,        Par_PuestoID,           AltaPoliza_NO,
                    Entero_Cero,        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,          Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,           Cadena_Vacia,
                    Cadena_Vacia,       SalidaNO,           Par_NumErr,         Par_ErrMen,             Par_Consecutivo,
                    Par_EmpresaID,      Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
                    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondIntere := Var_SaldoCondIntere - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Interes Calculado no Contabilizado
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoIntNoConta > Entero_Cero AND Var_SaldoCondIntere > Entero_Cero) THEN

				IF (Var_SaldoIntNoConta > Var_SaldoCondIntere) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondIntere;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoIntNoConta;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_IntNoConta;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CtaOrdIntSup;	-- No Concepto: 119
					SET Mov_CarConta	:= Con_CorIntOrdSup;	-- No Concepto: 120
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CueOrdInte;	-- No Concepto: 11
					SET Mov_CarConta	:= Con_CorOrdInte;	-- No Concepto: 12
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                   Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondIntere   := Var_SaldoCondIntere - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;
				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Interes Provisionado.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoInteresPro > Entero_Cero AND Var_SaldoCondIntere > Entero_Cero) THEN

				IF (Var_SaldoInteresPro > Var_SaldoCondIntere) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondIntere;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoInteresPro;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_IntProvis;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntDevenSup;	-- No Concepto: 114
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_IntDevenga;	-- No Concepto: 19
				END IF;

				SET Mov_CarConta	:= Con_EgreCondona;	-- No Concepto: 24

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondIntere := Var_SaldoCondIntere - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

                UPDATE AMORTICREDITO SET
                    Interes = Interes -  Var_MontoCondonar,
                    NumTransaccion = Aud_NumTransaccion
                WHERE CreditoID = Par_CreditoID
                  AND AmortizacionID = Var_AmortizacionID;

            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Capital Vencido.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoCapVencido > Entero_Cero AND Var_SaldoCondCap > Entero_Cero) THEN

				IF (Var_SaldoCapVencido > Var_SaldoCondCap) THEN
					SET Var_MontoCondonar   := Var_SaldoCondCap;
				ELSE
					SET Var_MontoCondonar   := Var_SaldoCapVencido;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_CapVencido;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CapVencidoSup;	-- No Concepto: 112
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CapVencido;	-- No Concepto: 3
				END IF;

				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET Mov_CarConta	:= Con_ResultEPRC;	-- No Concepto: 18
				ELSE
					SET Mov_CarConta	:= Con_PtePrinci;	-- No Concepto: 38
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondCap    := Var_SaldoCondCap - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Capital Atrasado.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoCapAtrasa > Entero_Cero AND Var_SaldoCondCap > Entero_Cero) THEN

				IF (Var_SaldoCapAtrasa > Var_SaldoCondCap) THEN
					SET Var_MontoCondonar   := Var_SaldoCondCap;
				ELSE
					SET Var_MontoCondonar   := Var_SaldoCapAtrasa;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_CapAtrasado;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta		:= Con_CapAtrasadoSup;	-- No Concepto: 111
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CapAtrasado;		-- No Concepto: 2
				END IF;

				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET Mov_CarConta	:= Con_ResultEPRC;	-- No Concepto: 18
				ELSE
					SET Mov_CarConta	:= Con_PtePrinci;	-- No Concepto: 38
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                SET Var_SaldoCondCap    := Var_SaldoCondCap - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

				UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Capital Vencido no Exigible.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoCapVenNExi > Entero_Cero AND Var_SaldoCondCap > Entero_Cero) THEN

				IF (Var_SaldoCapVenNExi > Var_SaldoCondCap) THEN
					SET Var_MontoCondonar	:= Var_SaldoCondCap;
				ELSE
					SET Var_MontoCondonar	:= Var_SaldoCapVenNExi;
				END IF;

				 -- Registro Contable
				SET Mov_AboOpera	:= Mov_CapVNE;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta		:= Con_CapVenNoExSup;	-- No Concepto: 113
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta		:= Con_CapVNE;			-- No Concepto: 4
				END IF;

				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET Mov_CarConta	:= Con_ResultEPRC;	-- No Concepto: 18
				ELSE
					 SET Mov_CarConta	:= Con_PtePrinci;	-- No Concepto: 38
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;
                SET Var_SaldoCondCap    := Var_SaldoCondCap - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

                UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
            END IF;

			-- ---------------------------------------------------------------------------
			--  Condonacion de Capital Vigente u Ordinario.
			-- ---------------------------------------------------------------------------
			IF (Var_SaldoCapVigente > Entero_Cero AND Var_SaldoCondCap > Entero_Cero) THEN

				IF (Var_SaldoCapVigente > Var_SaldoCondCap) THEN
					SET Var_MontoCondonar   := Var_SaldoCondCap;
				ELSE
					SET Var_MontoCondonar   := Var_SaldoCapVigente;
				END IF;

				-- Registro Contable
				SET Mov_AboOpera	:= Mov_CapVigente;

				IF (Var_CreEstatus = Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CapVigenteSup;	-- No Concepto: 110
				END IF;

				IF (Var_CreEstatus != Estatus_Suspendido) THEN
					SET Mov_AboConta	:= Con_CapVigente;  -- No Concepto: 1
				END IF;

				-- Verificamos si Registra la Estimacion en Gasto-Resultados o Cuenta Puente
				IF(Var_RegContaEPRC = EPRC_Resultados) THEN
					SET Mov_CarConta	:= Con_ResultEPRC;	-- No Concepto: 18
				ELSE
					SET Mov_CarConta	:= Con_PtePrinci;	-- No Concepto: 38
				END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
                    Mov_AboOpera,       Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;

                CALL  CONTACREDITOSPRO (
                    Par_CreditoID,      Var_AmortizacionID, Entero_Cero,        Entero_Cero,
                    Par_FechaRegistro,  Par_FechaRegistro,  Var_MontoCondonar,  Var_MonedaID,
                    Var_ProdCreditoID,  Var_ClasifCre,      Var_SubClasifID,    Var_SucursalOrigen,
                    Ref_Condona,        Par_PuestoID,       AltaPoliza_NO,      Entero_Cero,
                    Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,
                    Cadena_Vacia,       Cadena_Vacia,       SalidaNO,           Par_NumErr,
                    Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF (Par_NumErr > Entero_Cero ) THEN
                    LEAVE ManejoErrores;
                END IF;
                SET Var_SaldoCondCap    := Var_SaldoCondCap - Var_MontoCondonar;
                SET Par_Consecutivo     := Par_Consecutivo + 1;

                UPDATE AMORTICREDITO Tem
				SET NumTransaccion = Aud_NumTransaccion
					WHERE AmortizacionID = Var_AmortizacionID
						AND CreditoID = Par_CreditoID;
			END IF;
		SET Auxiliar := Auxiliar+1;

	END WHILE;

	-- Si hubo Errores en el Cursor Previo, entonces Salimos
	IF (Par_NumErr <> Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	IF Var_PagoPerdCentRedond = Cons_Si THEN
		call PAGCREAJUSTEPERDPRO(
			Par_CreditoID,		Entero_Cero,		Var_ClienteID,		Var_FechaSistema,		Var_FechaSistema,
			Var_MonedaID,		Var_ProdCreditoID,	Var_ClasifCre,		Var_SubClasifID,		Var_SucursalOrigen,
			Par_Poliza,			OrigenCargoCta,		Cons_No,			Par_NumErr,				Par_ErrMen,
			Par_Consecutivo,	Par_EmpresaID,      Modo_Pago,			Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Num_Reg != Entero_Cero) THEN
-- ---------------------------------------------------------------------------
-- Revisamos Si Despues de las Condonaciones, si ya no debe capital, marcamos la Amortizacion como Pagada
-- --------------------------------------------------------------------------
	UPDATE AMORTICREDITO SET
	Estatus     = Estatus_Pagado,
	FechaLiquida    = Var_FechaSistema
	WHERE (
		  SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
		  SaldoIntNoConta + SaldoMoratorios + SaldoComFaltaPa + SaldoOtrasComis + SaldoComServGar +
		  SaldoMoraVencido + SaldoMoraCarVen + SaldoNotCargoRev + SaldoNotCargoSinIVA + SaldoNotCargoConIVA) <= Tol_DifPago
	AND CreditoID       = Par_CreditoID
	AND FechaInicio  < Var_FechaSistema -- Fecha de la condonacion
	AND Capital= Entero_Cero -- capital original de la cuota
	AND Estatus     != Estatus_Pagado;


	UPDATE AMORTICREDITO SET
	Estatus     = Estatus_Pagado,
	FechaLiquida    = Var_FechaSistema
	WHERE (
		  SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
		  SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
		  SaldoIntNoConta + SaldoMoratorios + SaldoComFaltaPa + SaldoOtrasComis + SaldoComServGar +
		  SaldoMoraVencido + SaldoMoraCarVen + SaldoNotCargoRev + SaldoNotCargoSinIVA + SaldoNotCargoConIVA ) <= Tol_DifPago
	AND CreditoID       = Par_CreditoID
	AND Capital > Entero_Cero   -- capital original de la cuota
	AND Estatus     != Estatus_Pagado;


SELECT COUNT(AmortizacionID) INTO Var_NumAmoPag
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoID
	  AND Estatus       = Estatus_Pagado;

	SET Var_NumAmoPag := IFNULL(Var_NumAmoPag, Entero_Cero);

IF (Var_NumAmorti = Var_NumAmoPag) THEN
	UPDATE CREDITOS SET
		Estatus         = Estatus_Pagado,
		FechTerminacion = Var_FechaSistema,

		Usuario         = Aud_Usuario,
		FechaActual     = Aud_FechaActual,
		DireccionIP     = Aud_DireccionIP,
		ProgramaID      = Aud_ProgramaID,
		Sucursal        = Aud_Sucursal,
		NumTransaccion  = Aud_NumTransaccion

		WHERE CreditoID = Par_CreditoID;

ELSEIF (Var_EstCredito = Estatus_Vencida OR Var_CantAmoVenSusp > Entero_Cero) THEN


	SELECT  COUNT(AmortizacionID) INTO Var_NumAmoExi
		FROM AMORTICREDITO
		WHERE CreditoID     = Par_CreditoID
		  AND Estatus           != Estatus_Pagado
		  AND FechaExigible < Var_FechaSistema;

	SET Var_NumAmoExi := IFNULL(Var_NumAmoExi, Entero_Cero);

	IF (Var_NumAmoExi = Entero_Cero) THEN
		CALL REGULARIZACREDPRO (
			Par_CreditoID,      Var_FechaSistema,   AltaPoliza_NO,      Par_Poliza,     Par_EmpresaID,
			SalidaNO,           Par_NumErr,         Par_ErrMen,         Cadena_Vacia,   Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);
			IF(Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
	END IF;

	END IF;
ELSE
	SET Par_NumErr      := 002;
	SET Par_ErrMen      := 'No Se Pudo Realizar la Condonacion';
	SET Par_Consecutivo := 0;
	LEAVE ManejoErrores;
END IF;

  -- Marcar cuotas como pagadas en la tabla real
	IF EXISTS(SELECT * FROM AMORTCRENOMINAREAL WHERE CreditoID = Par_CreditoID)THEN
		UPDATE AMORTCRENOMINAREAL amo
			INNER JOIN AMORTICREDITO a ON amo.AmortizacionID = a.AmortizacionID AND a.CreditoID = Par_CreditoID  SET
				amo.Estatus         = Estatus_Pagado,

				amo.Usuario         = Aud_Usuario,
				amo.FechaActual     = Aud_FechaActual,
				amo.DireccionIP     = Aud_DireccionIP,
				amo.ProgramaID      = Aud_ProgramaID,
				amo.Sucursal        = Aud_Sucursal,
				amo.NumTransaccion  = Aud_NumTransaccion
		WHERE amo.CreditoID = Par_CreditoID
		AND a.Estatus = Estatus_Pagado
		AND amo.NumTransaccion = Aud_NumTransaccion;

	END IF;

DELETE FROM TMP_QUITASCONDONACIONES  WHERE Aud_NumTransaccion = Aud_NumTransaccion;

SET Par_NumErr := 0;
SET Par_ErrMen := "Condonacion Realizada Exitosamente";

END ManejoErrores;  -- End del Handler de Errores

IF(Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
			Par_ErrMen AS ErrMen,
			'creditoID' AS control,
			Par_CreditoID AS consecutivo;
END IF;

END TerminaStore$$
