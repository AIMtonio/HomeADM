-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGCRECONTAULTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGCRECONTAULTPRO`;
DELIMITER $$

CREATE PROCEDURE `PREPAGCRECONTAULTPRO`(


    Par_CreditoID       BIGINT(12),
    Par_CuentaContable  VARCHAR(25),
    Par_MontoPagar      DECIMAL(14,2),
    Par_MonedaID        INT(11),
    Par_EmpresaID       INT(11),

    Par_PagarIVA        CHAR(1),
INOUT Var_MontoIVAInt   DECIMAL(12,2),
    Par_Salida          CHAR(1),
    Par_AltaEncPoliza   CHAR(1),
    Par_AltaDetPoliza   CHAR(1),

	OUT Par_MontoPago   DECIMAL(12,2),
	INOUT Var_Poliza    BIGINT,
	Par_OrigenPago		CHAR(1),			# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	INOUT Par_NumErr    INT(11),
	OUT Par_ErrMen      VARCHAR(400),
	OUT Par_Consecutivo BIGINT,

    Par_Respaldar       CHAR(1),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),

    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_FechaSistema    DATE;
DECLARE Var_FecAplicacion   DATE;
DECLARE Var_DiasCredito     INT;
DECLARE Var_SucCliente      INT;
DECLARE Var_ClienteID       BIGINT;
DECLARE Var_ProdCreID       INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_CliPagIVA       CHAR(1);
DECLARE Var_IVAIntOrd       CHAR(1);
DECLARE Var_CreTasa         DECIMAL(12,4);
DECLARE Var_MonedaID        INT;
DECLARE Var_SubClasifID     INT;

DECLARE Var_CreditoID       BIGINT(12);
DECLARE Var_AmortizacionID  INT;
DECLARE Var_SalCapitales	DECIMAL(14,2);
DECLARE Var_SaldoCapVigente DECIMAL(14,2);
DECLARE Var_SaldoCapVenNExi DECIMAL(14,2);
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmoEstatus      CHAR(1);
DECLARE Var_ProvisionAcum   DECIMAL(14,4);

DECLARE Var_IVASucurs       DECIMAL(8, 4);
DECLARE Var_ValIVAIntOr     DECIMAL(12,2);
DECLARE Var_TotDeuda        DECIMAL(14,2);
DECLARE Var_NumAtrasos      INT;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_CreditoStr      VARCHAR(20);
DECLARE Var_SaldoPago       DECIMAL(14,2);
DECLARE Var_CantidPagar     DECIMAL(14,2);
DECLARE Var_SaldoCapita     DECIMAL(14,2);
DECLARE Var_CalInteresID    INT;
DECLARE Var_Dias            INT;
DECLARE Var_TotCapital      DECIMAL(14,2);
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_MaxAmoCapita    INT;


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12, 2);
DECLARE SiPagaIVA       CHAR(1);
DECLARE SalidaSI        CHAR(1);
DECLARE SalidaNO        CHAR(1);
DECLARE Esta_Pagado     CHAR(1);
DECLARE Esta_Activo     CHAR(1);
DECLARE Esta_Vencido    CHAR(1);
DECLARE Esta_Vigente    CHAR(1);

DECLARE NO_EsGrupal     CHAR(1);
DECLARE AltaPoliza_SI   CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE Pol_Automatica  CHAR(1);
DECLARE Mon_MinPago     DECIMAL(12,2);
DECLARE Tol_DifPago     DECIMAL(10,4);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Aho_PagoCred    CHAR(4);
DECLARE Con_AhoCapital  INT;
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE Tasa_Fija       INT;
DECLARE SI_Respaldar    CHAR(1);

DECLARE Coc_PagoCred    INT;
DECLARE Ref_PagAnti     VARCHAR(50);
DECLARE Con_PagoCred    VARCHAR(50);
DECLARE TipoActInteres	INT(11);

DECLARE CURSORAMORTI CURSOR FOR
    SELECT  Amo.CreditoID,      Amo.AmortizacionID, Amo.SaldoCapVigente,    Amo.    SaldoCapVenNExi,
            Cre.MonedaID,       Amo.FechaInicio,    Amo.FechaVencim,        Amo.FechaExigible,
            Amo.Estatus
        FROM AMORTICREDITO Amo,
              CREDITOS   Cre
        WHERE Amo.CreditoID   = Cre.CreditoID
          AND Cre.CreditoID   = Par_CreditoID
          AND (Cre.Estatus    = Esta_Vigente
            OR Cre.Estatus    = Esta_Vencido)
          AND Amo.Estatus     = Esta_Vigente
        AND Amo.FechaExigible > Var_FechaSistema
        ORDER BY FechaExigible DESC;


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET SiPagaIVA       := 'S';
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Esta_Pagado     := 'P';
SET Esta_Activo     := 'A';
SET Esta_Vencido    := 'B';
SET Esta_Vigente    := 'V';

SET NO_EsGrupal     := 'N';
SET AltaPoliza_SI   := 'S';
SET AltaPoliza_NO   := 'N';
SET Pol_Automatica  := 'A';
SET Mon_MinPago     := 0.01;
SET Tol_DifPago     := 0.02;
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Aho_PagoCred    := '101';
SET Con_AhoCapital  := 1;
SET AltaMovAho_SI   := 'S';
SET Tasa_Fija       := 1;
SET SI_Respaldar    := 'S';
SET TipoActInteres	:= 1;

SET Coc_PagoCred    := 54;
SET Ref_PagAnti     := 'PAGO ANTICIPADO CREDITO';
SET Con_PagoCred    := 'PAGO DE CREDITO';
SET Aud_ProgramaID  := 'PAGOCREDITOPRO';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PREPAGCRECONTAULTPRO');
		END;
	SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_DiasCredito		:= (SELECT DiasCredito	FROM PARAMETROSSIS);

    SET Var_ClienteID		:= (SELECT Cre.ClienteID			FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
    SET Var_EstatusCre		:= (SELECT Cre.Estatus				FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
    SET Var_ProdCreID		:= (SELECT Cre.ProductoCreditoID	FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
    SET Var_CreTasa			:= (SELECT Cre.TasaFija 			FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
    SET Var_MonedaID		:= (SELECT Cre.MonedaID 			FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
    SET Var_CalInteresID	:= (SELECT Cre.CalcInteresID 		FROM CREDITOS Cre WHERE Cre.CreditoID = Par_CreditoID);
    SET Var_SucCliente		:= (SELECT Cli.SucursalOrigen	FROM CLIENTES Cli WHERE Cli.ClienteID = Var_ClienteID);
    SET Var_CliPagIVA		:= (SELECT Cli.PagaIVA			FROM CLIENTES Cli	WHERE Cli.ClienteID = Var_ClienteID);
    SET Var_IVAIntOrd		:= (SELECT Pro.CobraIVAInteres	FROM PRODUCTOSCREDITO Pro WHERE Pro.ProducCreditoID = Var_ProdCreID);
    SET Var_ClasifCre		:= (SELECT Des.Clasificacion
									FROM	DESTINOSCREDITO Des,
											CREDITOS Cre
									WHERE Cre.CreditoID         = Par_CreditoID
									  AND Cre.DestinoCreID      = Des.DestinoCreID);
    SET Var_SubClasifID		:= (SELECT Des.SubClasifID
									FROM	DESTINOSCREDITO Des,
											CREDITOS Cre
									WHERE Cre.CreditoID         = Par_CreditoID
									  AND Cre.DestinoCreID      = Des.DestinoCreID);
    SET Var_TotDeuda		:= FUNCIONTOTDEUDACRE(Par_CreditoID);

	SET Var_SucCliente  := IFNULL(Var_SucCliente,Entero_Cero);
	SET Var_ClienteID   := IFNULL(Var_ClienteID,Entero_Cero);
	SET Var_ProdCreID   := IFNULL(Var_ProdCreID,Entero_Cero);
	SET Var_ClasifCre   := IFNULL(Var_ClasifCre,Cadena_Vacia);
	SET Var_EstatusCre  := IFNULL(Var_EstatusCre,Cadena_Vacia);
	SET Var_CliPagIVA   := IFNULL(Var_CliPagIVA,SiPagaIVA);
	SET Var_IVAIntOrd   := IFNULL(Var_IVAIntOrd,SiPagaIVA);
	SET Var_CreTasa     := IFNULL(Var_CreTasa,Entero_Cero);
	SET Var_MonedaID    := IFNULL(Var_MonedaID,Entero_Cero);
	SET Var_SubClasifID := IFNULL(Var_SubClasifID,Entero_Cero);
	SET Var_TotDeuda    := IFNULL(Var_TotDeuda,Entero_Cero);

	SET Var_IVASucurs	:= (SELECT IVA FROM SUCURSALES WHERE SucursalID    = Var_SucCliente);
	SET Var_IVASucurs   := IFNULL(Var_IVASucurs, Decimal_Cero);
	SET Var_ValIVAIntOr := Entero_Cero;
	SET Par_NumErr  	:= Entero_Cero;
	SET Par_ErrMen 		:= 'PrePago de Credito Aplicado Exitosamente.';


	IF (Var_CliPagIVA = SiPagaIVA) THEN
		IF (Var_IVAIntOrd = SiPagaIVA) THEN
			SET Var_ValIVAIntOr  := Var_IVASucurs;
		END IF;
	END IF;

	IF(Par_MontoPagar >= Var_TotDeuda) THEN
		SET Par_NumErr      := 1;
		SET Par_ErrMen      := 'Para Liquidar el Total del Adeudo, Por Favor Seleccione la Opcion Finiquito' ;
		LEAVE ManejoErrores;
	END IF;

	SET Var_NumAtrasos	:= (SELECT COUNT(AmortizacionID)
								FROM AMORTICREDITO
								WHERE CreditoID = Par_CreditoID
								  AND FechaExigible <= Var_FechaSistema
								  AND Estatus != Esta_Pagado);

	SET Var_NumAtrasos := IFNULL(Var_NumAtrasos, Entero_Cero);

	IF(Var_NumAtrasos > Entero_Cero) THEN
		SET Par_NumErr      := 2;
		SET Par_ErrMen      := 'Antes de Realizar un PrePago, Por Favor realice el Pago de lo Exigible y en Atraso.' ;
		LEAVE ManejoErrores;
	END IF;

	CALL DIASFESTIVOSCAL(
		Var_FechaSistema,   Entero_Cero,        Var_FecAplicacion,  Var_EsHabil,    Par_EmpresaID,
		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

	IF(Var_EstatusCre = Cadena_Vacia ) THEN
		SET Par_NumErr      := 3;
		SET Par_ErrMen      := 'El Credito no Existe';
		LEAVE ManejoErrores;
	END IF;

	IF(Var_EstatusCre != Esta_Vigente AND
	   Var_EstatusCre != Esta_Vencido ) THEN
		SET Par_NumErr      := 4;
		SET Par_ErrMen      := 'Estatus del Credito Incorrecto';
		LEAVE ManejoErrores;

	END IF;

	IF(Par_Respaldar = SI_Respaldar) THEN
		CALL RESPAGCREDITOPRO(
			Par_CreditoID,  Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
	END IF;

	IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
		CALL MAESTROPOLIZAALT(
			Var_Poliza,     Par_EmpresaID,  Var_FecAplicacion,  Pol_Automatica,     Coc_PagoCred,
			Con_PagoCred,   SalidaNO,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);
	END IF;

	SET Var_SaldoPago       := Par_MontoPagar;
	SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR(15));

	OPEN CURSORAMORTI;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		CICLO:LOOP

		FETCH CURSORAMORTI INTO
			Var_CreditoID,      Var_AmortizacionID,     Var_SaldoCapVigente,    Var_SaldoCapVenNExi,    Var_MonedaID,
			Var_FechaInicio,    Var_FechaVencim,        Var_FechaExigible,      Var_AmoEstatus;

		SET Var_CantidPagar     := Decimal_Cero;

		IF(Var_SaldoPago    <= Decimal_Cero) THEN
			LEAVE CICLO;
		END IF;

		SET Var_SalCapitales := (Var_SaldoCapVigente + Var_SaldoCapVenNExi);

		IF (Var_SaldoCapVigente >= Mon_MinPago) THEN

			IF(Var_SaldoPago    >= Var_SaldoCapVigente) THEN
				SET Var_CantidPagar := Var_SaldoCapVigente;
			ELSE
				SET Var_CantidPagar := Var_SaldoPago;
			END IF;

			CALL PAGCRECAPVIGPRO (
				Var_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,        Var_FechaVencim,        Entero_Cero,
				Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,      Var_CantidPagar,        Decimal_Cero,
				Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,          Var_SubClasifID,        Var_SucCliente,
				Con_PagoCred,       Par_CuentaContable,     Var_Poliza,             Var_SalCapitales,		Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,    	Par_EmpresaID,          Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
				Aud_NumTransaccion);


			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago   := Var_SaldoPago - Var_CantidPagar;

			IF(Var_SaldoPago    <= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;


		SET Var_SaldoCapVenNExi := IFNULL(Var_SaldoCapVenNExi, Decimal_Cero);
		IF (Var_SaldoCapVenNExi >= Mon_MinPago) THEN

			IF(Var_SaldoPago    >= Var_SaldoCapVenNExi) THEN
				SET Var_CantidPagar := Var_SaldoCapVenNExi;
			ELSE
				SET Var_CantidPagar := Var_SaldoPago;
			END IF;

			CALL PAGCRECAPVNEPRO (
				Var_CreditoID,      Var_AmortizacionID,     Var_FechaInicio,        Var_FechaVencim,        Entero_Cero,
				Var_ClienteID,      Var_FechaSistema,       Var_FecAplicacion,      Var_CantidPagar,        Decimal_Cero,
				Var_MonedaID,       Var_ProdCreID,          Var_ClasifCre,          Var_SubClasifID,        Var_SucCliente,
				Con_PagoCred,       Par_CuentaContable,     Var_Poliza,             Var_SalCapitales,		Par_OrigenPago,
				Par_NumErr,			Par_ErrMen,				Par_Consecutivo,    	Par_EmpresaID,          Cadena_Vacia,
				Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,         Aud_Sucursal,
				Aud_NumTransaccion);


			UPDATE AMORTICREDITO Tem
					SET NumTransaccion = Aud_NumTransaccion
						WHERE AmortizacionID = Var_AmortizacionID
							AND CreditoID = Par_CreditoID;

			SET Var_SaldoPago := Var_SaldoPago - Var_CantidPagar;

			IF(Var_SaldoPago <= Decimal_Cero) THEN
				LEAVE CICLO;
			END IF;

		END IF;

		END LOOP CICLO;
	END;
	CLOSE CURSORAMORTI;

	SET Par_MontoPago    := Par_MontoPagar - Var_SaldoPago;

	IF (Par_MontoPago <= Decimal_Cero) THEN
		SET Par_NumErr      := 10;
		SET Par_ErrMen      := 'El Credito no Presenta Adeudos.PrePago';
		LEAVE ManejoErrores;
	ELSE

		UPDATE AMORTICREDITO Amo SET
			Estatus      = Esta_Pagado,
			FechaLiquida = Var_FechaSistema
			WHERE (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
				  SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
				  SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
				  SaldoComFaltaPa + SaldoComServGar + SaldoOtrasComis ) <= Tol_DifPago
			  AND Amo.CreditoID     = Par_CreditoID
			AND FechaExigible > Var_FechaSistema
			  AND Estatus   != Esta_Pagado
			AND Amo.NumTransaccion = Aud_NumTransaccion;

		SET Var_MaxAmoCapita := (SELECT MAX(AmortizacionID)
									FROM AMORTICREDITO Amo
									WHERE CreditoID     = Par_CreditoID
									  AND Estatus   != Esta_Pagado
									  AND ( SaldoCapVigente + SaldoCapAtrasa +
											SaldoCapVencido + SaldoCapVenNExi ) > Entero_Cero);
		SET Var_MaxAmoCapita    := IFNULL(Var_MaxAmoCapita, Entero_Cero);

		UPDATE AMORTICREDITO Amo SET
			Estatus      = Esta_Pagado,
			FechaLiquida = Var_FechaSistema
			WHERE CreditoID     = Par_CreditoID
			AND (SaldoCapVigente + SaldoCapAtrasa + SaldoCapVencido + SaldoCapVenNExi +
				   SaldoInteresOrd + SaldoInteresAtr + SaldoInteresVen + SaldoInteresPro +
				   SaldoIntNoConta + SaldoMoratorios + SaldoMoraVencido + SaldoMoraCarVen +
				   SaldoComFaltaPa + SaldoComServGar + SaldoOtrasComis ) = Entero_Cero
			  AND Estatus   != Esta_Pagado
			AND AmortizacionID > Var_MaxAmoCapita;

	END IF;


	CALL AMORTICREDITOACT(
		Par_CreditoID,		TipoActInteres,    	SalidaNO,			Par_NumErr, 		Par_ErrMen,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP, 	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion);

	IF(Par_NumErr != Entero_Cero)THEN
		LEAVE ManejoErrores;
	END IF;

	IF(Par_Respaldar = SI_Respaldar) THEN
		CALL RESPAGCREDITOALT(
			Aud_NumTransaccion, Entero_Cero,        Par_CreditoID,      Par_MontoPagar,     Par_NumErr,
			Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen 	:= 'PrePago de Credito Aplicado Exitosamente.';

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Poliza AS control,
            Aud_NumTransaccion AS consecutivo;
END IF;

END TerminaStore$$