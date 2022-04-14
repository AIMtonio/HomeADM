-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECASTIGOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECASTIGOPRO`;
DELIMITER $$

CREATE PROCEDURE `CRECASTIGOPRO`(

    Par_CreditoID           BIGINT(12),
    INOUT Par_PolizaID      BIGINT(20),
    Par_MotivoCastigoID     INT(11),
    Par_Observaciones       VARCHAR(500),
    Par_TipoCastigo         CHAR(1),
    Par_TipoCobranza        INT,
    Par_AltaEncPoliza       CHAR(1),
    Par_Salida              CHAR(1),
    Par_EmpresaID           INT,
    OUT Par_NumErr          INT(11),
    OUT Par_ErrMen          VARCHAR(400),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


DECLARE Var_CreditoID           BIGINT(12);
DECLARE Var_AmortizacionID      INT(4);
DECLARE Var_SaldoCapVigente     DECIMAL(12,2);
DECLARE Var_SaldoCapAtrasa      DECIMAL(12,2);
DECLARE Var_SaldoCapVencido     DECIMAL(12,2);
DECLARE Var_SaldoCapVenNExi     DECIMAL(12,2);
DECLARE Var_SaldoInteresOrd     DECIMAL(12,4);
DECLARE Var_SaldoInteresAtr     DECIMAL(12,4);
DECLARE Var_SaldoInteresVen     DECIMAL(12,4);
DECLARE Var_SaldoInteresPro     DECIMAL(12,4);
DECLARE Var_SaldoIntNoConta     DECIMAL(12,4);
DECLARE Var_SaldoMoratorios     DECIMAL(12,2);
DECLARE Var_SaldoComFaltaPa     DECIMAL(12,2);
DECLARE Var_SaldoComServGar     DECIMAL(12,2);

DECLARE Var_SaldoOtrasComis     DECIMAL(12,2);
DECLARE Var_FechaInicio         DATE;
DECLARE Var_FechaVencim         DATE;
DECLARE Var_FechaExigible       DATE;
DECLARE Var_AmoEstatus          CHAR(1);
DECLARE Var_SalMoraVencido      DECIMAL(12,2);
DECLARE Var_SalMoraCarVen       DECIMAL(12,2);
DECLARE Var_SaldoNotCargoRev    DECIMAL(12,2);
DECLARE Var_SaldoNotCargoSinIVA DECIMAL(12,2);
DECLARE Var_SaldoNotCargoConIVA DECIMAL(12,2);
DECLARE Var_SaldoTotalNotCargo  DECIMAL(12,2);
DECLARE Var_CastigoNotCargo     DECIMAL(12,2);
DECLARE Var_CastNotCargoRev     DECIMAL(12,2);
DECLARE Var_CastNotCargoSinIVA  DECIMAL(12,2);
DECLARE Var_CastNotCargoConIVA  DECIMAL(12,2);

DECLARE Var_ReservCan       DECIMAL(14,2);
DECLARE Var_ResAnterior     DECIMAL(14,2);
DECLARE Var_ResCapital      DECIMAL(14,2);
DECLARE Var_ResInteres      DECIMAL(14,2);
DECLARE Var_FecAntRes       DATE;
DECLARE Var_MonReservar     DECIMAL(14,2);
DECLARE Var_MonLibReser     DECIMAL(14,2);
DECLARE Var_MonResCapita    DECIMAL(14,2);
DECLARE Var_MonResIntere    DECIMAL(14,2);
DECLARE Mov_AboConta        INT;
DECLARE Mov_CarConta        INT;
DECLARE Var_FechaSistema    DATE;
DECLARE Var_FecApl          DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_SucCliente      INT;
DECLARE Var_MonedaID        INT(11);
DECLARE Var_ProdCreID       INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_SubClasifID     INT;
DECLARE Var_CastigoCap      DECIMAL(14,2);
DECLARE Var_CastigoInt      DECIMAL(14,2);
DECLARE Var_CasIntMora      DECIMAL(14,2);
DECLARE Var_CasAccesor      DECIMAL(14,2);
DECLARE Var_CasMoraVenc     DECIMAL(14,2);
DECLARE Var_CasInteVenc     DECIMAL(14,2);

DECLARE Par_Consecutivo     BIGINT;
DECLARE Var_CreEstatus      CHAR(1);
DECLARE Var_SucursalCred    INT;
DECLARE Var_RegContaEPRC    CHAR(1);
DECLARE Var_DivideEPRC      CHAR(1);
DECLARE Var_TotalCastigo    DECIMAL(14,2);
DECLARE Var_TipoContaMora   CHAR(1);
DECLARE Var_ConIntereCarVen CHAR(1);
DECLARE Var_CondMoraCarVen  CHAR(1);
DECLARE Var_ConAccesorios   CHAR(1);
DECLARE Var_DivideCastigo   CHAR(1);
DECLARE Var_EPRCAdicional   CHAR(1);
DECLARE Var_TotIntVenc      DECIMAL(14,2);
DECLARE Var_FecPrimAtraso   DATE;
DECLARE Var_FecUltPagoCap   DATE;
DECLARE Var_FecUltPagoInt   DATE;
DECLARE Var_MonUltPagoCap   DECIMAL(14,2);
DECLARE Var_MonUltPagoInt   DECIMAL(14,2);
DECLARE Var_UltNumTransac   BIGINT;
DECLARE Var_UltAmortizacionID   INT;
DECLARE Var_TranCastigo     BIGINT;
DECLARE Var_LineaCreditoID  BIGINT(20);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12, 2);
DECLARE Decimal_Cien        DECIMAL(12, 2);

DECLARE Esta_Activo         CHAR(1);
DECLARE Esta_Cancelado      CHAR(1);
DECLARE Esta_Inactivo       CHAR(1);
DECLARE Esta_Vencido        CHAR(1);
DECLARE Esta_Vigente        CHAR(1);
DECLARE Esta_Castigado      CHAR(1);
DECLARE Esta_Pagado         CHAR(1);
DECLARE Esta_Atrasado       CHAR(1);
DECLARE Estatus_Pagado      CHAR(1);

DECLARE Par_SalidaNO        CHAR(1);
DECLARE Par_SalidaSI        CHAR(1);
DECLARE AltaPoliza_SI       CHAR(1);
DECLARE AltaPoliza_NO       CHAR(1);
DECLARE AltaPolCre_NO       CHAR(1);
DECLARE AltaPolCre_SI       CHAR(1);
DECLARE AltaMovAho_SI       CHAR(1);
DECLARE AltaMovAho_NO       CHAR(1);
DECLARE AltaMovCre_SI       CHAR(1);
DECLARE AltaMovCre_NO       CHAR(1);
DECLARE Con_EstBalance      INT;
DECLARE Con_EstResultados   INT;
DECLARE Con_EstBalanceInt   INT;
DECLARE Con_EstResultaInt   INT;
DECLARE Con_CtaPtePrinc     INT;
DECLARE Con_CtaPteIntere    INT;
DECLARE Con_CtaOrdCom       INT;
DECLARE Con_CorComFal       INT;
DECLARE Con_IngresoMora     INT;
DECLARE Con_IngMoraCarVen   INT;
DECLARE Con_CtaOrdMor       INT;
DECLARE Con_CorIntMor       INT;
DECLARE Con_MoraVencido     INT;
DECLARE Con_CtaOrdInt       INT;
DECLARE Con_CorIntOrd       INT;
DECLARE Con_IngInteCarVen   INT;
DECLARE Con_IntProvis       INT;
DECLARE Con_IntVencido      INT;
DECLARE Con_IntAtrasado     INT;
DECLARE Con_CapVigente      INT;
DECLARE Con_CapAtrasado     INT;
DECLARE Con_CapVencido      INT;
DECLARE Con_CapVenNoExi     INT;
DECLARE Con_OrdCastigo      INT;
DECLARE Con_CorCastigo      INT;
DECLARE Con_OrdCasInt       INT;
DECLARE Con_CorCasInt       INT;
DECLARE Con_OrdCasMora      INT;
DECLARE Con_CorCasMora      INT;
DECLARE Con_OrdCasComi      INT;
DECLARE Con_CorCasComi      INT;
DECLARE Con_BalAdiEPRC      INT;
DECLARE Con_PteAdiEPRC      INT;
DECLARE Con_ResAdiEPRC      INT;

DECLARE Con_CtaOrdNoC       INT;
DECLARE Con_CtaCorNoC       INT;

DECLARE Si_AplicaConta      CHAR(1);
DECLARE Pol_Automatica      CHAR(1);
DECLARE Con_CastigoCar      INT;
DECLARE Con_IngComisi       INT;

DECLARE Mov_ComFalPag       INT;
DECLARE Mov_Moratorio       INT;
DECLARE Mov_MoraVencido     INT;
DECLARE Mov_MoraCarVen      INT;
DECLARE Con_MoraVigente     INT;
DECLARE Mov_IntNoConta      INT;
DECLARE Mov_IntProvis       INT;
DECLARE Mov_IntVencido      INT;
DECLARE Mov_IntAtrasado     INT;
DECLARE Mov_CapVigente      INT;
DECLARE Mov_CapAtrasado     INT;
DECLARE Mov_CapVencido      INT;
DECLARE Mov_CapVenNoExi     INT;
DECLARE Nat_Cargo           CHAR(1);
DECLARE Nat_Abono           CHAR(1);
DECLARE EPRC_Resultados     CHAR(1);
DECLARE SI_DivideEPRC       CHAR(1);
DECLARE NO_DivideEPRC       CHAR(1);
DECLARE Mora_CueOrden       CHAR(1);
DECLARE SI_Condona          CHAR(1);
DECLARE No_DivideCastigo    CHAR(1);
DECLARE NO_EPRCAdicional    CHAR(1);
DECLARE SI_EPRCAdicional    CHAR(1);
DECLARE Mon_MinPago         DECIMAL(12,2);
DECLARE Des_Castigo         VARCHAR(100);
DECLARE Var_NumError        INT(11);
DECLARE CastPagVertical     CHAR(1);
DECLARE EstatuSuspendido	CHAR(1);		-- Estatus Suspendido Del credito

DECLARE Con_CapVigenteSup	INT(11);		-- Concepto Contable: Capital Vigente Suspendido
DECLARE Con_CapAtrasadoSup	INT(11);		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
DECLARE Con_CapVencidoSup	INT(11);		-- Concepto Contable: Capital Vencido Suspendido
DECLARE Con_CapVenNoExSup	INT(11);		-- Concepto Contable: Capital Vencido no Exigible Suspendido

DECLARE Con_MoraDevenSup	INT(11);		-- Concepto Contable: Interes Moratorio Devengado Suspendido
DECLARE Con_MoraVencidoSup	INT(11);		-- Concepto Contable: Interes Moratorio Vencido Suspendido
DECLARE	Con_CtaOrdMorSup	INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
DECLARE	Con_CorIntMorSup	INT(11);		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido

DECLARE Con_IntDevenSup		INT(11);		-- Concepto Contable Interes Devengado Supencion
DECLARE Con_IntAtrasadoSup	INT(11);		-- Concepto Contable: Interes Atrasado Suspendido
DECLARE Con_IntVencidoSup	INT(11);		-- Concepto Contable: Interes Vencido Suspendido
DECLARE Con_CtaOrdIntSup	INT(11);		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
DECLARE Con_CorIntOrdSup	INT(11);		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado

DECLARE Tip_MovComGarDisLinCred     INT(11);    -- Tipo Movimiento Credito Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Tip_MovIVAComGarDisLinCred  INT(11);    -- Tipo Movimiento Credito IVA Comision por Garantia por Disposicion de Linea Credito Agro

DECLARE Con_CarCtaOrdenDeuAgro      INT(11);    -- Concepto Cuenta Ordenante Deudor Agro
DECLARE Con_CarCtaOrdenCorAgro      INT(11);    -- Concepto Cuenta Ordenante Corte Agro
DECLARE Con_CarComGarDisLinCred     INT(11);    -- Concepto Cartera Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Con_CarIVAComGarDisLinCred  INT(11);    -- Concepto Cartera IVA Comision por Garantia por Disposicion de Linea Credito Agro
DECLARE Act_Bloqueo             INT(11);        -- Numero de Actualizacion por Bloqueo

DECLARE CURSORAMORTI CURSOR FOR
    SELECT  Amo.CreditoID,          Amo.AmortizacionID,     Amo.SaldoCapVigente,      Amo.SaldoCapAtrasa,     Amo.SaldoCapVencido,
            Amo.SaldoCapVenNExi,    Amo.SaldoInteresOrd,    Amo.SaldoInteresAtr,      Amo.SaldoInteresVen,    Amo.SaldoInteresPro,
            Amo.SaldoIntNoConta,    Amo.SaldoMoratorios,    Amo.SaldoComFaltaPa,      Amo.SaldoComServGar,    Amo.SaldoOtrasComis,
            Cre.MonedaID,           Amo.FechaInicio,        Amo.FechaVencim,          Amo.FechaExigible,      Amo.Estatus,
            Amo.SaldoMoraVencido,   Amo.SaldoMoraCarVen,    Amo.SaldoNotCargoRev,     Amo.SaldoNotCargoSinIVA,Amo.SaldoNotCargoConIVA
        FROM AMORTICREDITO Amo
        INNER JOIN CREDITOS Cre ON Amo.CreditoID = Cre.CreditoID
        WHERE Cre.CreditoID = Par_CreditoID
          AND (Cre.Estatus = Esta_Vigente OR Cre.Estatus = Esta_Vencido OR Cre.Estatus = EstatuSuspendido)
          AND (Amo.Estatus = Esta_Vigente OR Amo.Estatus = Esta_Vencido OR Amo.Estatus = Esta_Activo)
        ORDER BY FechaExigible;


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
SET Con_EstBalanceInt   := 36;
SET Con_EstResultaInt   := 37;
SET Con_CtaPtePrinc     := 38;
SET Con_CtaPteIntere    := 39;
SET Con_CtaOrdCom       := 15;
SET Con_CorComFal       := 16;
SET Con_IngresoMora     := 6;
SET Con_IngMoraCarVen   := 35;
SET Con_CtaOrdMor       := 13;
SET Con_CorIntMor       := 14;
SET Con_MoraVencido     := 34;
SET Con_MoraVigente     := 33;
SET Con_CtaOrdInt       := 11;
SET Con_CorIntOrd       := 12;
SET Con_IngInteCarVen   := 32;
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
SET Con_IngComisi       := 7;
SET Con_OrdCasInt       := 40;
SET Con_CorCasInt       := 41;
SET Con_OrdCasMora      := 42;
SET Con_CorCasMora      := 43;
SET Con_OrdCasComi      := 44;
SET Con_CorCasComi      := 45;
SET Con_BalAdiEPRC      := 49;
SET Con_PteAdiEPRC      := 50;
SET Con_ResAdiEPRC      := 51;

SET Mov_ComFalPag       := 40;
SET Mov_Moratorio       := 15;
SET Mov_MoraVencido     := 16;
SET Mov_MoraCarVen      := 17;
SET Mov_IntNoConta      := 13;
SET Mov_IntProvis       := 14;
SET Mov_IntVencido      := 12;
SET Mov_IntAtrasado     := 11;
SET Mov_CapVigente      := 1;
SET Mov_CapAtrasado     := 2;
SET Mov_CapVencido      := 3;
SET Mov_CapVenNoExi     := 4;
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET EPRC_Resultados     := 'R';
SET SI_DivideEPRC       := 'S';
SET NO_DivideEPRC       := 'N';
SET Mora_CueOrden       := 'C';
SET SI_Condona          := 'S';
SET No_DivideCastigo    := 'N';
SET NO_EPRCAdicional    := 'N';
SET SI_EPRCAdicional    := 'S';
SET CastPagVertical     := 'V';
SET Estatus_Pagado      := 'P';

SET Mon_MinPago         := 0.01;
SET Des_Castigo         := 'CASTIGO DE CARTERA';
SET EstatuSuspendido	= 'S';		-- Estatus Suspendido Del credito

SET Con_CapVigenteSup	:= 110;		-- Concepto Contable: Capital Vigente Suspendido
SET Con_CapAtrasadoSup	:= 111;		-- Tipo de Movimiento de Credito: Capital Atrasado Suspendido
SET Con_CapVencidoSup	:= 112;		-- Concepto Contable: Capital Vencido Suspendido
SET Con_CapVenNoExSup	:= 113;		-- Concepto Contable: Capital Vencido no Exigible Suspendido
SET Con_IntDevenSup		:= 114;		-- Concepto Contable Interes Devengado Ssupencion
SET Con_IntAtrasadoSup	:= 115;		-- Concepto Contable: Interes Atrasado Suspendido
SET Con_IntVencidoSup	:= 116;		-- Concepto Contable: Interes Vencido
SET Con_CtaOrdIntSup	:= 119;		-- Concepto Contable: Cuenta de Orden de Interes Nota:Interes no contabilizado
SET Con_CorIntOrdSup	:= 120;		-- Concepto Contable: Cuenta de Orden Correlativa de Interes: Nota:Interes no contabilizado
SET Con_MoraDevenSup	:= 117;		-- Concepto Contable: Interes Moratorio Devengado Suspendido
SET Con_MoraVencidoSup	:= 118;		-- Concepto Contable: Interes Moratorio Vencido Suspendido
SET	Con_CtaOrdMorSup	:= 121;		-- Concepto Contable: Cuenta de Orden de Interes Moratorio Suspendido
SET	Con_CorIntMorSup	:= 122;		-- Concepto Contable: Correlativa Cuenta de Orden de Interes Moratorio Suspendido
SET Tip_MovComGarDisLinCred     := 57;
SET Tip_MovIVAComGarDisLinCred  := 58;

SET Con_CarCtaOrdenDeuAgro      := 138;
SET Con_CarCtaOrdenCorAgro      := 139;
SET Con_CarComGarDisLinCred     := 143;
SET Con_CarIVAComGarDisLinCred  := 145;
SET Act_Bloqueo                 := 2;


SET Var_ResAnterior     := Entero_Cero;
SET Var_ResInteres      := Entero_Cero;
SET Var_ResCapital      := Entero_Cero;
SET Var_MonReservar     := Entero_Cero;
SET Var_MonResCapita    := Entero_Cero;
SET Var_MonResIntere    := Entero_Cero;
SET Var_ReservCan       := Entero_Cero;
SET Var_CastigoCap      := Entero_Cero;
SET Var_CastigoInt      := Entero_Cero;
SET Var_CasIntMora      := Entero_Cero;
SET Var_CasAccesor      := Entero_Cero;
SET Var_CasMoraVenc     := Entero_Cero;
SET Var_CasInteVenc     := Entero_Cero;
SET Var_CastigoNotCargo := Entero_Cero;
SET Var_CastNotCargoRev     := Entero_Cero;
SET Var_CastNotCargoSinIVA  := Entero_Cero;
SET Var_CastNotCargoConIVA  := Entero_Cero;

SET Var_TotalCastigo    := Entero_Cero;

SET Par_NumErr      := 000;
SET Par_ErrMen      := Cadena_Vacia;
SET Par_EmpresaID   := IFNULL(Par_EmpresaID, 1);

ManejoErrores : BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                            'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECASTIGOPRO');
            END;

DELETE FROM TMPCRECASTIGO
WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion;

SELECT FechaSistema, TipoContaMora INTO Var_FechaSistema, Var_TipoContaMora
    FROM PARAMETROSSIS
        WHERE EmpresaID = Par_EmpresaID;

SELECT RegContaEPRC, DivideEPRCCapitaInteres, CondonaIntereCarVen, CondonaMoratoCarVen, CondonaAccesorios,
       DivideCastigo, EPRCAdicional INTO
        Var_RegContaEPRC, Var_DivideEPRC, Var_ConIntereCarVen, Var_CondMoraCarVen, Var_ConAccesorios,
        Var_DivideCastigo, Var_EPRCAdicional
    FROM PARAMSRESERVCASTIG
    WHERE EmpresaID = Par_EmpresaID;

SET Var_RegContaEPRC := IFNULL(Var_RegContaEPRC, EPRC_Resultados);
SET Var_DivideEPRC  := IFNULL(Var_DivideEPRC, NO_DivideEPRC);
SET Var_TipoContaMora := IFNULL(Var_TipoContaMora, Mora_CueOrden);
SET Var_ConIntereCarVen := IFNULL(Var_ConIntereCarVen, SI_Condona);
SET Var_CondMoraCarVen  := IFNULL(Var_CondMoraCarVen, SI_Condona);
SET Var_ConAccesorios   := IFNULL(Var_ConAccesorios, SI_Condona);
SET Var_DivideCastigo   := IFNULL(Var_DivideCastigo, No_DivideCastigo);
SET Var_EPRCAdicional   := IFNULL(Var_EPRCAdicional, NO_EPRCAdicional);

SELECT  Cli.SucursalOrigen,     Cre.MonedaID,   Pro.ProducCreditoID,    Des.Clasificacion,  Des.SubClasifID,
        Cre.Estatus,            Cre.SucursalID,     Cre.LineaCreditoID
        INTO
        Var_SucCliente,         Var_MonedaID,   Var_ProdCreID,      Var_ClasifCre,  Var_SubClasifID,
        Var_CreEstatus,         Var_SucursalCred,   Var_LineaCreditoID
    FROM CREDITOS Cre
    INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
    INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
    INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
    WHERE Cre.CreditoID = Par_CreditoID;



IF(Par_TipoCastigo != CastPagVertical)THEN
    CALL CRECASTIGOSVAL(Par_CreditoID,      Par_SalidaNO,               Par_NumErr,             Par_ErrMen,
                        Par_EmpresaID,      Aud_Usuario,                Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

    SET Var_NumError    := CONVERT(Par_NumErr, UNSIGNED);
    IF(Var_NumError != Entero_Cero) THEN
        SET Par_NumErr  := '001';
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

    SET Var_ResCapital := IFNULL(Var_ResCapital, Entero_Cero);
    SET Var_ResInteres := IFNULL(Var_ResInteres, Entero_Cero);

    SET Var_ResAnterior := Var_ResCapital + Var_ResInteres;
END IF;

IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
CALL MAESTROPOLIZASALT(
    Par_PolizaID,       Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_CastigoCar,
    Des_Castigo,        Par_SalidaNO,       Par_NumErr,     Par_ErrMen,         Aud_Usuario,
    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
END IF;

OPEN CURSORAMORTI;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    CICLO:LOOP

    FETCH CURSORAMORTI INTO
        Var_CreditoID,          Var_AmortizacionID ,    Var_SaldoCapVigente,      Var_SaldoCapAtrasa,       Var_SaldoCapVencido,
        Var_SaldoCapVenNExi,    Var_SaldoInteresOrd,    Var_SaldoInteresAtr,      Var_SaldoInteresVen,      Var_SaldoInteresPro,
        Var_SaldoIntNoConta,    Var_SaldoMoratorios,    Var_SaldoComFaltaPa,      Var_SaldoComServGar,      Var_SaldoOtrasComis,
        Var_MonedaID,           Var_FechaInicio,        Var_FechaVencim,          Var_FechaExigible,        Var_AmoEstatus,
        Var_SalMoraVencido,     Var_SalMoraCarVen,      Var_SaldoNotCargoRev,     Var_SaldoNotCargoSinIVA,  Var_SaldoNotCargoConIVA;


  SET Var_SaldoCapVigente     := IFNULL(Var_SaldoCapVigente, Entero_Cero);
  SET Var_SaldoCapAtrasa      := IFNULL(Var_SaldoCapAtrasa,  Entero_Cero);
  SET Var_SaldoCapVencido     := IFNULL(Var_SaldoCapVencido, Entero_Cero);
  SET Var_SaldoCapVenNExi     := IFNULL(Var_SaldoCapVenNExi, Entero_Cero);
  SET Var_SaldoInteresOrd     := IFNULL(Var_SaldoInteresOrd, Entero_Cero);
  SET Var_SaldoInteresAtr     := IFNULL(Var_SaldoInteresAtr, Entero_Cero);
  SET Var_SaldoInteresVen     := IFNULL(Var_SaldoInteresVen, Entero_Cero);
  SET Var_SaldoInteresPro     := IFNULL(Var_SaldoInteresPro, Entero_Cero);
  SET Var_SaldoIntNoConta     := IFNULL(Var_SaldoIntNoConta, Entero_Cero);
  SET Var_SaldoMoratorios     := IFNULL(Var_SaldoMoratorios, Entero_Cero);
  SET Var_SaldoComFaltaPa     := IFNULL(Var_SaldoComFaltaPa, Entero_Cero);
  SET Var_SaldoComServGar     := IFNULL(Var_SaldoComServGar, Entero_Cero);
  SET Var_SaldoOtrasComis     := IFNULL(Var_SaldoOtrasComis, Entero_Cero);
  SET Var_SalMoraVencido      := IFNULL(Var_SalMoraVencido, Entero_Cero);
  SET Var_SalMoraCarVen       := IFNULL(Var_SalMoraCarVen, Entero_Cero);
  SET Var_SaldoNotCargoRev    := IFNULL(Var_SaldoNotCargoRev, Entero_Cero);
  SET Var_SaldoNotCargoSinIVA := IFNULL(Var_SaldoNotCargoSinIVA, Entero_Cero);
  SET Var_SaldoNotCargoConIVA := IFNULL(Var_SaldoNotCargoConIVA, Entero_Cero);



  SET Var_CastigoCap  := Var_CastigoCap + Var_SaldoCapVigente + Var_SaldoCapAtrasa +
                         Var_SaldoCapVencido + Var_SaldoCapVenNExi;

  SET Var_CastigoInt  := Var_CastigoInt + Var_SaldoInteresAtr + Var_SaldoInteresVen +
                         Var_SaldoInteresPro + Var_SaldoIntNoConta;

  SET Var_CasIntMora  := Var_CasIntMora + Var_SaldoMoratorios + Var_SalMoraVencido + Var_SalMoraCarVen;
  SET Var_CasAccesor  := Var_CasAccesor + Var_SaldoComFaltaPa + Var_SaldoComServGar + Var_SaldoOtrasComis;

  SET Var_CasMoraVenc := Var_CasMoraVenc + Var_SalMoraVencido;
  SET Var_CasInteVenc := Var_CasInteVenc + Var_SaldoInteresVen;

  IF (Var_CreEstatus = Esta_Vencido) THEN

      SET Var_MonResCapita := Var_MonResCapita +
                              (Var_SaldoCapVigente + Var_SaldoCapAtrasa + Var_SaldoCapVencido + Var_SaldoCapVenNExi);

      SET Var_CasInteVenc := Var_CasInteVenc + Var_SaldoInteresPro;

  ELSE
      SET Var_MonResCapita := Var_MonResCapita +
                              (Var_SaldoCapVigente + Var_SaldoCapAtrasa + Var_SaldoCapVencido + Var_SaldoCapVenNExi);

      SET Var_MonResIntere := Var_MonResIntere + (Var_SaldoInteresAtr  + Var_SaldoInteresPro);

  END IF;

    IF( Var_SaldoComServGar >= Mon_MinPago ) THEN

        CALL CONTACREDITOPRO (
            Par_CreditoID,              Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,                 Var_SaldoComServGar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,            Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,                Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CarCtaOrdenDeuAgro,
            Tip_MovComGarDisLinCred,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,               Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
            Cadena_Vacia,               Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Var_SucursalCred,           Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        CALL CONTACREDITOPRO (
            Par_CreditoID,              Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,                 Var_SaldoComServGar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,            Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,                Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_CarCtaOrdenCorAgro,
            Tip_MovComGarDisLinCred,    Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,               Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
            Cadena_Vacia,               Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
            Var_SucursalCred,           Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;

  IF (Var_SaldoComFaltaPa >= Mon_MinPago) THEN
    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoComFaltaPa,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CtaOrdCom,
        Mov_ComFalPag,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoComFaltaPa,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_CorComFal,
        Mov_ComFalPag,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    IF(Var_ConAccesorios != SI_Condona) THEN
        SET Var_MonResIntere := Var_MonResIntere + Var_SaldoComFaltaPa;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_SaldoComFaltaPa,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_IngComisi,
            Mov_ComFalPag,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;
  END IF;

  IF (Var_SalMoraVencido >= Mon_MinPago) THEN
    IF(Var_CreEstatus = EstatuSuspendido) THEN
		  SET Mov_AboConta	:= Con_MoraVencidoSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_MoraVencido;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SalMoraVencido,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_MoraVencido,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Var_SaldoMoratorios >= Mon_MinPago) THEN
    IF(Var_TipoContaMora = Mora_CueOrden) THEN
      IF(Var_CreEstatus = EstatuSuspendido) THEN
        SET Mov_AboConta	:= Con_CtaOrdMorSup;
				SET Mov_CarConta	:= Con_CorIntMorSup;
			END IF;

			IF(Var_CreEstatus != EstatuSuspendido) THEN
				SET Mov_AboConta	:= Con_CtaOrdMor;
				SET Mov_CarConta	:= Con_CorIntMor;
			END IF;

      CALL  CONTACREDITOPRO (
          Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
          Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
          Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
          Cadena_Vacia,       /*Par_SalidaNO,*/
          Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
          Aud_NumTransaccion);

      IF (Par_NumErr <> Entero_Cero)THEN
          LEAVE ManejoErrores;
      END IF;

      CALL  CONTACREDITOPRO (
          Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
          Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
          Mov_Moratorio,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
          Cadena_Vacia,       /*Par_SalidaNO,*/
          Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
          Aud_NumTransaccion);

      IF (Par_NumErr <> Entero_Cero)THEN
          LEAVE ManejoErrores;
      END IF;


      IF(Var_CondMoraCarVen != SI_Condona) THEN
          SET Var_MonResIntere := Var_MonResIntere + Var_SaldoMoratorios;

          CALL  CONTACREDITOPRO (
              Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
              Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
              Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
              Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_IngresoMora,
              Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
              Cadena_Vacia,       /*Par_SalidaNO,*/
              Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
              Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
              Aud_NumTransaccion);

          IF (Par_NumErr <> Entero_Cero)THEN
              LEAVE ManejoErrores;
          END IF;
      END IF;
    ELSE
      SET Var_MonResIntere := Var_MonResIntere + Var_SaldoMoratorios;

			IF(Var_CreEstatus = EstatuSuspendido) THEN
				SET Mov_AboConta	:= Con_MoraDevenSup;
			END IF;

			IF(Var_CreEstatus != EstatuSuspendido) THEN
				SET Mov_AboConta	:= Con_MoraVigente;
			END IF;

      CALL  CONTACREDITOPRO (
          Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
          Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
          Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
          Cadena_Vacia,       /*Par_SalidaNO,*/
          Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
          Aud_NumTransaccion);

      IF (Par_NumErr <> Entero_Cero)THEN
          LEAVE ManejoErrores;
      END IF;
    END IF;
  END IF;


  IF (Var_SalMoraCarVen >= Mon_MinPago) THEN

		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CtaOrdMorSup;
			SET Mov_CarConta	:= Con_CorIntMorSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CtaOrdMor;
			SET Mov_CarConta	:= Con_CorIntMor;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SalMoraCarVen,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_MoraCarVen,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SalMoraCarVen,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Mov_MoraCarVen,     Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    IF(Var_CondMoraCarVen != SI_Condona) THEN
        SET Var_MonResIntere := Var_MonResIntere + Var_SalMoraCarVen;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_SalMoraCarVen,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_IngMoraCarVen,
            Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;
  END IF;


  IF (Var_SaldoIntNoConta >= Mon_MinPago) THEN

		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CtaOrdIntSup;
			SET Mov_CarConta	:= Con_CorIntOrdSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CtaOrdInt;
			SET Mov_CarConta	:= Con_CorIntOrd;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_IntNoConta,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Mov_IntNoConta,     Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    IF(Var_ConIntereCarVen != SI_Condona) THEN
        SET Var_MonResIntere := Var_MonResIntere + Var_SaldoIntNoConta;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_IngInteCarVen,
            Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;
  END IF;

  IF (Var_SaldoInteresPro >= Mon_MinPago) THEN
		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_IntDevenSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_IntProvis;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoInteresPro,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_IntProvis,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Var_SaldoInteresVen >= Mon_MinPago) THEN
		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_IntVencidoSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_IntVencido;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoInteresVen,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_IntVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;


  IF (Var_SaldoInteresAtr >= Mon_MinPago) THEN
		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_IntAtrasadoSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_IntAtrasado;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoInteresAtr,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_IntAtrasado,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Var_SaldoCapVigente >= Mon_MinPago) THEN
  	IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapVigenteSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapVigente;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoCapVigente,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_CapVigente,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Var_SaldoCapAtrasa >= Mon_MinPago) THEN

		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapAtrasadoSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapAtrasado;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoCapAtrasa,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_CapAtrasado,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Var_SaldoCapVencido >= Mon_MinPago) THEN
		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapVencidoSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapVencido;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoCapVencido,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_CapVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;

  IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN
		IF(Var_CreEstatus = EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapVenNoExSup;
		END IF;

		IF(Var_CreEstatus != EstatuSuspendido) THEN
			SET Mov_AboConta	:= Con_CapVenNoExi;
		END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoCapVenNExi,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Mov_AboConta,
        Mov_CapVenNoExi,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;

  -- SE AGREGA SECCION PARA NOTAS DE CARGO **************************************************************************************
  SET Var_SaldoTotalNotCargo := Var_SaldoNotCargoSinIVA+Var_SaldoNotCargoConIVA + Var_SaldoNotCargoRev;
  SET Var_CastNotCargoRev    := Var_CastNotCargoRev + Var_SaldoNotCargoRev;
  SET Var_CastNotCargoSinIVA := Var_CastNotCargoSinIVA + Var_SaldoNotCargoSinIVA;
  SET Var_CastNotCargoConIVA := Var_CastNotCargoConIVA + Var_SaldoNotCargoConIVA;
  SET Var_CastigoNotCargo    := Var_CastigoNotCargo + Var_SaldoTotalNotCargo;
  IF ( Var_SaldoTotalNotCargo >= Mon_MinPago) THEN
    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoTotalNotCargo, Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CtaOrdNoC,
        Mov_ComFalPag,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);
    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_SaldoTotalNotCargo, Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_CtaCorNoC,
        Mov_ComFalPag,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);
    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;-- TERMINA SECCION DE NOTAS DE CARGO **************************************************************************************
  END LOOP CICLO;
END;
CLOSE CURSORAMORTI;


SET Var_ReservCan   := Var_MonResCapita + Var_MonResIntere;
SET Var_MonReservar := Var_MonResCapita + Var_MonResIntere;

IF(Var_DivideEPRC = NO_DivideEPRC) THEN
  IF(Var_MonReservar > Var_ResAnterior) THEN
    SET Var_MonReservar := (Var_MonReservar - Var_ResAnterior);

    SET Mov_AboConta    := Con_EstBalance;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
        Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
        SET Mov_CarConta    := Con_EstResultados;
    ELSE
        SET Mov_CarConta    := Con_CtaPtePrinc;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
        Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Var_SucursalCred,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

  ELSE
    SET Var_MonLibReser := (Var_ResAnterior - Var_MonReservar);

    SET Mov_AboConta    := Con_EstResultados;

    IF(Var_MonLibReser > Entero_Cero) THEN
      SET Mov_CarConta    := Con_EstBalance;
      IF(Var_RegContaEPRC = EPRC_Resultados) THEN
          SET Mov_AboConta    := Con_EstResultados;
      ELSE
          SET Mov_AboConta    := Con_CtaPtePrinc;
      END IF;


      CALL  CONTACREDITOPRO (
          Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
          Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
          Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
          Cadena_Vacia,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
          Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
          Var_SucursalCred,   Aud_NumTransaccion);

      IF (Par_NumErr <> Entero_Cero)THEN
          LEAVE ManejoErrores;
      END IF;


      CALL  CONTACREDITOPRO (
          Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
          Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
          Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
          Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
          Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
          Cadena_Vacia,       /*Par_SalidaNO,*/
          Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
          Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
          Aud_NumTransaccion);

      IF (Par_NumErr <> Entero_Cero)THEN
          LEAVE ManejoErrores;
      END IF;

    END IF;
  END IF;
ELSE -- si no es NO_DivideEPRC
  IF(Var_MonResCapita > Var_ResCapital) THEN
    SET Var_MonReservar := (Var_MonResCapita - Var_ResCapital);
    SET Mov_AboConta    := Con_EstBalance;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
        Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
        SET Mov_CarConta    := Con_EstResultados;
    ELSE
        SET Mov_CarConta    := Con_CtaPtePrinc;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  ELSE -- SI Var_MonResCapita NO ES MAYOR Var_ResCapital

    SET Var_MonLibReser := (Var_ResCapital- Var_MonResCapita);

    SET Mov_AboConta    := Con_EstResultados;

    IF(Var_MonLibReser > Entero_Cero) THEN

      SET Mov_CarConta    := Con_EstBalance;


    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
        SET Mov_AboConta    := Con_EstResultados;
    ELSE
        SET Mov_AboConta    := Con_CtaPtePrinc;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
        Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
  END IF;
END IF;


IF(Var_MonResIntere > Var_ResInteres) THEN
    SET Var_MonReservar := (Var_MonResIntere - Var_ResInteres);

    SET Mov_AboConta    := Con_EstBalanceInt;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
        Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
        SET Mov_CarConta    := Con_EstResultaInt;
    ELSE
        SET Mov_CarConta    := Con_CtaPteIntere;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
ELSE
  SET Var_MonLibReser := (Var_ResInteres - Var_MonResIntere);
  IF(Var_MonLibReser > Entero_Cero) THEN
    SET Mov_CarConta    := Con_EstBalanceInt;

    IF(Var_RegContaEPRC = EPRC_Resultados) THEN
        SET Mov_AboConta    := Con_EstResultaInt;
    ELSE
        SET Mov_AboConta    := Con_CtaPteIntere;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_AboConta,
        Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;


    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_MonLibReser,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Mov_CarConta,
        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

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




SELECT  IFNULL(MIN(FechaExigible), Fecha_Vacia)
        INTO Var_FecPrimAtraso
        FROM AMORTICREDITO Amo
        WHERE Amo.CreditoID = Var_CreditoID
          AND (Amo.Estatus != Esta_Pagado
           OR  (    Amo.Estatus = Esta_Pagado
               AND  Amo.NumTransaccion  = Var_TranCastigo ) )
          AND Amo.FechaExigible <= Var_FechaSistema;





INSERT INTO TMPCRECASTIGO
    (TMPCRECASTIGOID,  CreditoID,  AmortizacionID, MontoPago, FechaPago,
    Exigible, FecUltPagCompleto, TransaccionID,
    EmpresaID, Usuario, FechaActual, DireccionIP, ProgramaID, Sucursal, NumTransaccion)
SELECT
    NULL,   Var_CreditoID,  Det.AmortizacionID, SUM(Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen),
    MAX(Det.FechaPago), MAX(Amo.Capital),   Fecha_Vacia,    MAX(Det.NumTransaccion),
    Par_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion
FROM DETALLEPAGCRE Det,
    AMORTICREDITO Amo
WHERE Det.CreditoID  = Var_CreditoID
    AND Det.FechaPago <= Var_FechaSistema
    AND (Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen) > Entero_Cero
    AND Det.CreditoID = Amo.CreditoID
    AND Det.AmortizacionID = Amo.AmortizacionID
GROUP BY Det.AmortizacionID;

UPDATE TMPCRECASTIGO Tem SET
    Tem.FecUltPagCompleto = Tem.FechaPago
    WHERE MontoPago >= Exigible
    AND CreditoID = Par_CreditoID
    AND NumTransaccion = Aud_NumTransaccion;

SELECT  IFNULL(MAX(Det.FecUltPagCompleto), Fecha_Vacia) INTO Var_FecUltPagoCap
    FROM TMPCRECASTIGO Det
    WHERE Det.CreditoID = Par_CreditoID
    AND Det.NumTransaccion = Aud_NumTransaccion;

IF(Var_FecUltPagoCap != Fecha_Vacia) THEN

    SELECT  MAX(Tem.TransaccionID), MAX(Tem.AmortizacionID) INTO Var_UltNumTransac, Var_UltAmortizacionID
        FROM TMPCRECASTIGO Tem
        WHERE Tem.FecUltPagCompleto = Var_FecUltPagoCap
        AND Tem.CreditoID = Par_CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;


    SET Var_UltNumTransac := IFNULL(Var_UltNumTransac, Entero_Cero);
    SET Var_UltAmortizacionID := IFNULL(Var_UltAmortizacionID, Entero_Cero);

    SELECT  Det.MontoPago INTO Var_MonUltPagoCap
        FROM TMPCRECASTIGO Det
        WHERE Det.CreditoID = Par_CreditoID
          AND Det.FecUltPagCompleto = Var_FecUltPagoCap
          AND Det.TransaccionID = Var_UltNumTransac
          AND Det.AmortizacionID = Var_UltAmortizacionID
          AND Det.NumTransaccion = Aud_NumTransaccion;

END IF;

SET Var_MonUltPagoCap := IFNULL(Var_MonUltPagoCap,Entero_Cero);

SET Var_UltNumTransac   = Entero_Cero;
SET Var_UltAmortizacionID = Entero_Cero;

DELETE FROM TMPCRECASTIGO
WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion;

INSERT INTO TMPCRECASTIGO
    (TMPCRECASTIGOID,  CreditoID,  AmortizacionID, MontoPago, FechaPago,
    Exigible, FecUltPagCompleto, TransaccionID,
    EmpresaID, Usuario, FechaActual, DireccionIP, ProgramaID, Sucursal, NumTransaccion)
SELECT
    NULL,   Var_CreditoID,  Det.AmortizacionID, SUM(Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen),
    MAX(Det.FechaPago), MAX(Amo.Capital),   Fecha_Vacia,    MAX(Det.NumTransaccion),
    Par_EmpresaID, Aud_Usuario, Aud_FechaActual, Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion
FROM DETALLEPAGCRE Det,
    AMORTICREDITO Amo
WHERE Det.CreditoID  = Var_CreditoID
    AND Det.FechaPago <= Var_FechaSistema
    AND (Det.MontoCapAtr + Det.MontoCapOrd + Det.MontoCapVen) > Entero_Cero
    AND Det.CreditoID = Amo.CreditoID
    AND Det.AmortizacionID = Amo.AmortizacionID
GROUP BY Det.AmortizacionID;


UPDATE TMPCRECASTIGO Tem SET
    Tem.FecUltPagCompleto = Tem.FechaPago
    WHERE MontoPago >= Exigible
    AND CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion;

SELECT  IFNULL(MAX(Det.FecUltPagCompleto), Fecha_Vacia) INTO Var_FecUltPagoInt
    FROM TMPCRECASTIGO Det
    WHERE Det.CreditoID = Par_CreditoID AND Det.NumTransaccion = Aud_NumTransaccion;

IF(Var_FecUltPagoInt != Fecha_Vacia) THEN

    SELECT  MAX(Tem.TransaccionID), MAX(Tem.AmortizacionID) INTO Var_UltNumTransac, Var_UltAmortizacionID
        FROM TMPCRECASTIGO Tem
        WHERE Tem.FecUltPagCompleto = Var_FecUltPagoInt
        AND Tem.CreditoID = Par_CreditoID
        AND Tem.NumTransaccion = Aud_NumTransaccion;


    SET Var_UltNumTransac := IFNULL(Var_UltNumTransac, Entero_Cero);
    SET Var_UltAmortizacionID := IFNULL(Var_UltAmortizacionID, Entero_Cero);

    SELECT  Det.MontoPago INTO Var_MonUltPagoInt
        FROM TMPCRECASTIGO Det
        WHERE Det.CreditoID = Par_CreditoID
          AND Det.FecUltPagCompleto = Var_FecUltPagoInt
          AND Det.TransaccionID = Var_UltNumTransac
          AND Det.AmortizacionID = Var_UltAmortizacionID
          AND Det.NumTransaccion = Aud_NumTransaccion;

END IF;

SET Var_MonUltPagoInt := IFNULL(Var_MonUltPagoInt,Entero_Cero);



UPDATE AMORTICREDITO SET
    Estatus     = Esta_Pagado,
    FechaLiquida    = Var_FechaSistema

    WHERE CreditoID     = Par_CreditoID
      AND Estatus   != Esta_Pagado;

UPDATE CREDITOS SET
    Estatus         = Esta_Castigado,
    FechTerminacion = Var_FechaSistema,

    Usuario     = Aud_Usuario,
    FechaActual = Aud_FechaActual,
    DireccionIP = Aud_DireccionIP,
    ProgramaID  = Aud_ProgramaID,
    Sucursal    = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

    WHERE CreditoID = Par_CreditoID;

-- Se valida que el credito tiene una linea de crédito y se realiza el proceso de bloqueo
SET Var_LineaCreditoID := IFNULL(Var_LineaCreditoID, Entero_Cero);
IF( Var_LineaCreditoID > Entero_Cero ) THEN

    CALL LINEASCREDITOACT(
        Var_LineaCreditoID, Entero_Cero,        Var_FechaSistema,   Aud_Usuario,    Des_Castigo,
        Entero_Cero,        Cadena_Vacia,       Act_Bloqueo,
        Par_SalidaNO,       Par_NumErr,         Par_ErrMen,         Par_EmpresaID,  Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
END IF;

SET Aud_FechaActual := CURRENT_TIMESTAMP();
SET Var_TotalCastigo    := Var_CastigoCap + Var_CastigoInt + Var_CasIntMora + Var_CasAccesor+ Var_CastigoNotCargo;


INSERT INTO CRECASTIGOS (
    CreditoID,          Fecha,                CapitalCastigado,         InteresCastigado,         TotalCastigo,
    MonRecuperado,      EstatusCredito,       MotivoCastigoID,          Observaciones,            IntMoraCastigado,
    AccesorioCastigado, SaldoCapital,         SaldoInteres,             SaldoMoratorio,           SaldoAccesorios,
    FecPrimAtraso,      FecUltPagoCap,        FecUltPagoInt,            MonUltPagoCap,            MonUltPagoInt,
    TipoCobranza,       SaldoNotCargoRev,     SaldoNotCargoSinIVA,      SaldoNotCargoConIVA,      EmpresaID,
    Usuario,            FechaActual,          DireccionIP,              ProgramaID,               Sucursal,
    NumTransaccion)
VALUES(
    Par_CreditoID,      Var_FechaSistema,     Var_CastigoCap,           Var_CastigoInt,           Var_TotalCastigo,
    Entero_Cero,        Var_CreEstatus,       Par_MotivoCastigoID,      Par_Observaciones,        Var_CasIntMora,
    Var_CasAccesor,     Var_CastigoCap,       Var_CastigoInt,           Var_CasIntMora,           Var_CasAccesor,
    Var_FecPrimAtraso,  Var_FecUltPagoCap,    Var_FecUltPagoInt,        Var_MonUltPagoCap,        Var_MonUltPagoInt,
    Par_TipoCobranza,   Var_CastNotCargoRev,  Var_CastNotCargoSinIVA,   Var_CastNotCargoConIVA,  Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,      Aud_DireccionIP,          Aud_ProgramaID,           Aud_Sucursal,
    Aud_NumTransaccion  );

-- Marcar cuotas como castigadas en la tabla real
IF EXISTS(SELECT * FROM AMORTCRENOMINAREAL WHERE CreditoID = Par_CreditoID)THEN
    UPDATE AMORTCRENOMINAREAL amo
        INNER JOIN AMORTICREDITO a ON amo.AmortizacionID = a.AmortizacionID AND a.CreditoID = Par_CreditoID  SET
            amo.Estatus         = Esta_Castigado,

            amo.Usuario         = Aud_Usuario,
            amo.FechaActual     = Aud_FechaActual,
            amo.DireccionIP     = Aud_DireccionIP,
            amo.ProgramaID      = Aud_ProgramaID,
            amo.Sucursal        = Aud_Sucursal,
            amo.NumTransaccion  = Aud_NumTransaccion
    WHERE amo.CreditoID = Par_CreditoID
    AND a.Estatus <> Estatus_Pagado;
END IF;


IF(Var_ReservCan > Entero_Cero) THEN




    IF(Var_DivideEPRC = NO_DivideEPRC) THEN


        SET Var_ReservCan := Var_ReservCan + IFNULL(Var_CasMoraVenc, Entero_Cero)  +
                                             IFNULL(Var_CasInteVenc, Entero_Cero);

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_ReservCan,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalance,
            Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

    ELSE



        IF(Var_EPRCAdicional = NO_EPRCAdicional) THEN

            CALL  CONTACREDITOPRO (
                Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
                Var_FecApl,         Var_MonResCapita,   Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
                Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalance,
                Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,       /*Par_SalidaNO,*/
                Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
                Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            SET Var_MonResIntere := Var_MonResIntere + IFNULL(Var_CasMoraVenc, Entero_Cero)  +
                                                       IFNULL(Var_CasInteVenc, Entero_Cero);

            CALL  CONTACREDITOPRO (
                Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
                Var_FecApl,         Var_MonResIntere,   Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
                Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalanceInt,
                Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,       /*Par_SalidaNO,*/
                Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
                Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

        ELSE

            CALL  CONTACREDITOPRO (
                Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
                Var_FecApl,         Var_MonResCapita,   Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
                Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalance,
                Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,       /*Par_SalidaNO,*/
                Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
                Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            CALL  CONTACREDITOPRO (
                Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
                Var_FecApl,         Var_MonResIntere,   Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
                Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
                Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_EstBalanceInt,
                Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
                Cadena_Vacia,       /*Par_SalidaNO,*/
                Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
                Aud_NumTransaccion);

            IF (Par_NumErr <> Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;


            SET Var_TotIntVenc = IFNULL(Var_CasMoraVenc, Entero_Cero) + IFNULL(Var_CasInteVenc, Entero_Cero);
            IF(Var_TotIntVenc > Entero_Cero) THEN
                CALL  CONTACREDITOPRO (
                    Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
                    Var_FecApl,         Var_TotIntVenc,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
                    Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
                    Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_BalAdiEPRC,
                    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
                    Cadena_Vacia,       /*Par_SalidaNO,*/
                    Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
                    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
                    Aud_NumTransaccion);

                IF (Par_NumErr <> Entero_Cero)THEN
                    LEAVE ManejoErrores;
                END IF;
            END IF;
        END IF;

    END IF;
END IF;


IF(Var_DivideCastigo = No_DivideCastigo) THEN

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_TotalCastigo,   Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_CorCastigo,
        Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
        Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

    CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
        Var_FecApl,         Var_TotalCastigo,   Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_OrdCastigo,
        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
		Cadena_Vacia,       /*Par_SalidaNO,*/
        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;

ELSE


    IF(Var_CastigoCap > Entero_Cero) THEN
        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CastigoCap,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_CorCastigo,
            Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CastigoCap,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_OrdCastigo,
            Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;


    IF(Var_CastigoInt > Entero_Cero) THEN
        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CastigoInt,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_CorCasInt,
            Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CastigoInt,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_OrdCasInt,
            Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;


    IF(Var_CasIntMora > Entero_Cero) THEN
        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CasIntMora,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_CorCasMora,
            Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CasIntMora,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_OrdCasMora,
            Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;


    IF(Var_CasAccesor > Entero_Cero) THEN
        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CasAccesor,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_CorCasComi,
            Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        CALL  CONTACREDITOPRO (
            Par_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
            Var_FecApl,         Var_CasAccesor,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
            Var_SubClasifID,    Var_SucCliente,     Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_OrdCasComi,
            Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
            Cadena_Vacia,       /*Par_SalidaNO,*/
            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
            Aud_NumTransaccion);

        IF (Par_NumErr <> Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;
    END IF;

END IF;

SET Par_NumErr      := '000';
SET Par_ErrMen      := CONCAT('Credito Castigado Exitosamente: ',CONVERT(Par_CreditoID,CHAR));

DELETE FROM TMPCRECASTIGO
WHERE CreditoID = Par_CreditoID AND NumTransaccion = Aud_NumTransaccion;

END ManejoErrores;

IF (Par_Salida = Par_SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           'creditoID' AS control,
           Par_PolizaID AS consecutivo;
END IF;

END TerminaStore$$
