-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMOVSALT`;
DELIMITER $$


CREATE PROCEDURE `CREDITOSMOVSALT`(
/*SP para dar de alta los movimientos de los creditos*/
	Par_CreditoID			BIGINT(12),
	Par_AmortiCreID			INT(4),
	Par_Transaccion			BIGINT(20),
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,

	Par_TipoMovCreID		INT(4),
	Par_NatMovimiento		CHAR(1),
	Par_MonedaID			INT(11),
	Par_Cantidad			DECIMAL(14,4),
	Par_Descripcion			VARCHAR(100),

	Par_Referencia			VARCHAR(50),
	Par_Poliza				BIGINT(20),
	Par_OrigenPago			VARCHAR(2),					-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
OUT	Par_NumErr				INT(11),
OUT	Par_ErrMen				VARCHAR(400),
OUT	Par_Consecutivo			BIGINT,

	Par_ModoPago			CHAR(1),
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Fecha           	DATE;
DECLARE Mov_Cantidad    	DECIMAL(14,4);
DECLARE Var_CreStatus   	CHAR(1);
DECLARE Var_AcumProv    	DECIMAL(14,4);
DECLARE Var_ClienteID   	INT;
DECLARE Par_IntNumErr   	INT;
DECLARE Var_Control 		VARCHAR(50);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT;
DECLARE	Float_Cero			FLOAT;
DECLARE	EstatusActivo		CHAR(1);
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Cre_Vigente			CHAR(1);
DECLARE	Cre_Vencido			CHAR(1);
DECLARE	Cre_Castigado		CHAR(1);
DECLARE Cre_Suspendido		CHAR(1);		-- Constante Estatus Suspendido
DECLARE	Mov_CapOrd 			INT;
DECLARE	Mov_CapAtr 			INT;
DECLARE	Mov_CapVen 			INT;
DECLARE	Mov_CapVNE 			INT;
DECLARE	Mov_IntOrd 			INT;
DECLARE	Mov_IntAtr 			INT;
DECLARE	Mov_IntVen 			INT;
DECLARE	Mov_IntPro 			INT;
DECLARE	Mov_IntCalNoCon		INT;
DECLARE	Mov_IntMor 			INT;
DECLARE	Mov_IVAInt 			INT;
DECLARE	Mov_IVAMor 			INT;
DECLARE	Mov_IVAFalPag 		INT;
DECLARE	Mov_IVAComSevGar 	INT;

DECLARE	Mov_IVAComApe 		INT;
DECLARE	Mov_ComFalPag 		INT;
DECLARE	Mov_ComServGar 		INT;
DECLARE	Mov_ComApeCre 		INT;
DECLARE Mov_ComLiqAnt       INT;
DECLARE Mov_IVAComLiqAnt    INT;
DECLARE Mov_IntMoratoVen	INT;
DECLARE Mov_IntMoraCarVen	INT;
DECLARE Mov_SegCuota		INT;
DECLARE Mov_IVASegCuota		INT;
#COMISION ANUALIDAD
DECLARE Mov_ComAnual		INT;
DECLARE Mov_ComAnualIVA		INT;
DECLARE	Mov_NotaCargoConIVA		INT(11);		-- Movimiento de credito por Nota de Cargo con iva
DECLARE	Mov_NotaCargoSinIVA		INT(11);		-- Movimiento de credito por Nota de Cargo sin iva
DECLARE	Mov_NotaCargoNoRecon	INT(11);		-- Movimiento de credito por Nota de Cargo no reconocido
DECLARE	Mov_IVANotaCargo		INT(11);		-- Movimiento de credito por Nota de Cargo IVA
DECLARE	Mov_ComSerGarantia		INT(11);		-- Movimiento de credito por Comision de Servicio de Garantia
DECLARE	Mov_IVAComSerGarantia	INT(11);		-- Movimiento de credito por IVA Comision de Servicio de Garantia

DECLARE	Pro_GenInt			VARCHAR(50);
DECLARE	Pro_PagCre			VARCHAR(50);
DECLARE	Pro_Bonifi			VARCHAR(50);
DECLARE	Des_PagoCred		VARCHAR(50);
DECLARE	Salida_NO       	CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Float_Cero          := 0.0;
SET EstatusActivo       := 'A';
SET Nat_Cargo           := 'C';
SET Nat_Abono           := 'A';
SET Cre_Vigente         := 'V';
SET Cre_Vencido         := 'B';
SET Cre_Castigado       := 'K';
SET Cre_Suspendido		:= 'S';
SET Mov_CapOrd          := 1;
SET Mov_CapAtr          := 2;
SET Mov_CapVen          := 3;
SET Mov_CapVNE          := 4;
SET Mov_IntOrd          := 10;
SET Mov_IntAtr          := 11;
SET Mov_IntVen          := 12;
SET Mov_IntCalNoCon     := 13;
SET Mov_IntPro          := 14;
SET Mov_IntMor          := 15;
SET Mov_IVAInt          := 20;
SET Mov_IVAMor          := 21;
SET Mov_IVAFalPag       := 22;
SET Mov_IVAComApe       := 23;
SET Mov_IVAComLiqAnt    := 24;          -- IVA Comision por Administracion: Liquidacion Anticipada
SET Mov_ComFalPag       := 40;
SET Mov_ComApeCre       := 41;
SET Mov_ComLiqAnt       := 42;          -- Comision por Administracion: Liquidacion Anticipada
SET Mov_ComServGar      := 43;          -- Comision por Comision de Servicio de Garantia
SET Mov_IVAComSevGar    := 44;          -- IVA Comision por Comision de Servicio de Garantia

SET Mov_IntMoratoVen	:= 16;			-- Tipo de Movimiento: Interes Moratorio Vencido
SET Mov_IntMoraCarVen	:= 17;          -- Tipo de Movimiento: Interes Moratorio de Cartera Vencida
SET Mov_SegCuota		:= 50;			-- Tipo de Movimiento TIPOSMOVSCRE: Seguro por Cuota
SET Mov_IVASegCuota     := 25; 			-- Tipo de Movimiento TIPOSMOVSCRE: IVA Seguro por Cuota
#COMISION ANUALIDAD
SET Mov_ComAnual		:= 51;				-- TIPOSMOVSCRE: 51 Comision por Anualidad
SET Mov_ComAnualIVA		:= 52;				-- TIPOSMOVSCRE: 52 IVA Comision por Anualidad
SET	Mov_NotaCargoConIVA		:= 53;		-- Movimiento de credito por Nota de Cargo con iva
SET	Mov_NotaCargoSinIVA		:= 54;		-- Movimiento de credito por Nota de Cargo sin iva
SET	Mov_NotaCargoNoRecon	:= 55;		-- Movimiento de credito por Nota de Cargo no reconocido
SET	Mov_IVANotaCargo		:= 56;		-- Movimiento de credito por Nota de Cargo IVA
SET	Mov_ComSerGarantia		:= 59;
SET	Mov_IVAComSerGarantia	:= 60;

SET Salida_NO           := 'N';
SET Pro_GenInt          := 'GENERAINTERECREPRO';
SET Pro_PagCre          := 'PAGOCREDITOPRO';
SET Pro_Bonifi          := 'BONIFICACION';
SET Des_PagoCred        := 'PAGO DE CREDITO';
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSMOVSALT');
			SET Var_Control := 'sqlexception';
		END;

IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
	SELECT '001' AS NumErr,
		 'El Numero de Credito esta vacio.' AS ErrMen,
		 'creditoID' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

SELECT Estatus, ClienteID  INTO Var_CreStatus, Var_ClienteID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

SET Var_CreStatus = IFNULL(Var_CreStatus, Cadena_Vacia);

IF Var_CreStatus= Cadena_Vacia THEN
	SELECT '002' AS NumErr,
		   'El Credito no Existe.' AS ErrMen,
		   'creditoID' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(Aud_ProgramaID != "CLIENTESCANCELAPRO")THEN
	IF (Var_CreStatus != Cre_Vigente AND Var_CreStatus != Cre_Vencido  AND Var_CreStatus != Cre_Castigado AND Var_CreStatus != Cre_Suspendido) THEN
		SELECT '003' AS NumErr,
			   'Estatus del Credito Incorrecto.' AS ErrMen,
			   'creditoID' AS control,
				 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;


IF(IFNULL(Par_Transaccion, Entero_Cero))= Entero_Cero THEN
	SELECT '004' AS NumErr,
		   'El numero de Movimiento esta vacio.' AS ErrMen,
		   'creditoID' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;


IF(IFNULL(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia THEN
	SELECT '005' AS NumErr,
		  'La Fecha Op. esta Vacia.' AS ErrMen,
		  'fecha' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia THEN
	SELECT '006' AS NumErr,
		  'La Fecha Apl. esta Vacia.' AS ErrMen,
		  'fecha' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '007' AS NumErr,
		  'La naturaleza del Movimiento esta vacia.' AS ErrMen,
		  'natMovimiento' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(Par_NatMovimiento<>Nat_Cargo)THEN
	IF(Par_NatMovimiento<>Nat_Abono)THEN
		SELECT '008' AS NumErr,
			  'La naturaleza del Movimiento no es correcta.' AS ErrMen,
			  'natMovimiento' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(Par_NatMovimiento<>Nat_Abono)THEN
	IF(Par_NatMovimiento<>Nat_Cargo)THEN
		SELECT '009' AS NumErr,
			  'La naturaleza del Movimiento no es correcta.' AS ErrMen,
			  'natMovimiento' AS control,
			 0 AS consecutivo;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(IFNULL(Par_Cantidad, Float_Cero)) <= Float_Cero THEN
	SELECT '010' AS NumErr,
		   'Cantidad del Movimiento de Credito Incorrecta' AS ErrMen,
		   'cantidad' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;


IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '011' AS NumErr,
		  'La Descripcion del Movimiento esta vacia.' AS ErrMen,
		  'descripcion' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
	SELECT '012' AS NumErr,
		  'La Referencia esta vacia.' AS ErrMen,
		  'referencia' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_TipoMovCreID, Entero_Cero)) = Entero_Cero THEN
	SELECT '013' AS NumErr,
		  'El Tipo de Movimiento esta vacio.' AS ErrMen,
		  'tipoMovCreID' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

IF(NOT EXISTS(SELECT AmortizacionID
		FROM AMORTICREDITO
		WHERE CreditoID 		= Par_CreditoID
		  AND AmortizacionID	= Par_AmortiCreID)) THEN
		SELECT '014' AS NumErr,
			  'La Amortizacion no existe.' AS ErrMen,
			  'amortizacionID' AS control,
			 0 AS consecutivo;
	LEAVE TerminaStore;
END IF;

SET Mov_Cantidad = Par_Cantidad;

IF (Par_NatMovimiento = Nat_Abono) THEN
	SET Mov_Cantidad = Mov_Cantidad * -1;
END IF;



IF (Par_TipoMovCreID = Mov_IntOrd) THEN
	UPDATE CREDITOS SET
		SaldoInterOrdin	= SaldoInterOrdin + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoInteresOrd	= SaldoInterOrdin + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_CapOrd) THEN
	UPDATE CREDITOS SET
		SaldoCapVigent	= SaldoCapVigent + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_CapAtr) THEN
	UPDATE CREDITOS SET
		SaldoCapAtrasad	= SaldoCapAtrasad + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoCapAtrasa	= SaldoCapAtrasa + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_CapVen) THEN
	UPDATE CREDITOS SET
		SaldoCapVencido	= SaldoCapVencido + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoCapVencido	= SaldoCapVencido + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_CapVNE) THEN
	UPDATE CREDITOS SET
		SaldCapVenNoExi	= SaldCapVenNoExi + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoCapVenNExi	= SaldoCapVenNExi + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntAtr) THEN
	UPDATE CREDITOS SET
		SaldoInterAtras	= SaldoInterAtras + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoInteresAtr	= SaldoInteresAtr + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntVen) THEN
	UPDATE CREDITOS SET
		SaldoInterVenc	= SaldoInterVenc + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoInteresVen	= SaldoInteresVen + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntPro) THEN

	IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
		SET Var_AcumProv = Mov_Cantidad;
	ELSE
		SET Var_AcumProv = Entero_Cero;
	END IF;

	UPDATE CREDITOS SET
		SaldoInterProvi	= SaldoInterProvi + Mov_Cantidad,
		ProvisionAcum		= ProvisionAcum + Var_AcumProv
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoInteresPro	=   SaldoInteresPro + Mov_Cantidad,
		ProvisionAcum		= ProvisionAcum + Var_AcumProv
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntCalNoCon) THEN

	IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
		SET Var_AcumProv = Mov_Cantidad;
	ELSE
		SET Var_AcumProv = Entero_Cero;
	END IF;

	UPDATE CREDITOS SET
		SaldoIntNoConta	= SaldoIntNoConta + Mov_Cantidad,
		ProvisionAcum		= ProvisionAcum + Var_AcumProv
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoIntNoConta	= SaldoIntNoConta + Mov_Cantidad,
		ProvisionAcum		= ProvisionAcum + Var_AcumProv
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntMor) THEN
	UPDATE CREDITOS SET
		SaldoMoratorios	= SaldoMoratorios + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoMoratorios	= SaldoMoratorios + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntMoratoVen) THEN

	UPDATE CREDITOS SET
		SaldoMoraVencido	= SaldoMoraVencido + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoMoraVencido	= SaldoMoraVencido + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IntMoraCarVen) THEN

	UPDATE CREDITOS SET
		SaldoMoraCarVen	= SaldoMoraCarVen + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoMoraCarVen	= SaldoMoraCarVen + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IVAInt) THEN
	UPDATE CREDITOS SET
		SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IVAMor) THEN
	UPDATE CREDITOS SET
		SaldoIVAMorator	= SaldoIVAMorator + Par_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoIVAMorato	= SaldoIVAMorato + Par_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IVAFalPag) THEN
	UPDATE CREDITOS SET
		SalIVAComFalPag	= SalIVAComFalPag + Par_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoIVAComFalP	= SaldoIVAComFalP + Par_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IVAComSevGar) THEN
	UPDATE CREDITOS SET
		SaldoIVAComSerGar	= SaldoIVAComSerGar + Par_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoIVAComSerGar	= SaldoIVAComSerGar + Par_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IVAComApe OR Par_TipoMovCreID = Mov_IVAComLiqAnt) THEN
	UPDATE CREDITOS SET
		SaldoIVAComisi	= SaldoIVAComisi + Par_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoIVAComisi	= SaldoIVAComisi + Par_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_ComFalPag) THEN
	UPDATE CREDITOS SET
		SaldComFaltPago	= SaldComFaltPago + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoComFaltaPa	= SaldoComFaltaPa + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_ComServGar) THEN
	UPDATE CREDITOS SET
		SaldoComServGar	= SaldoComServGar + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoComServGar	= SaldoComServGar + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_ComApeCre OR Par_TipoMovCreID = Mov_ComLiqAnt) THEN
	UPDATE CREDITOS SET
		SaldoOtrasComis	= SaldoOtrasComis + Mov_Cantidad
		WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoOtrasComis	= SaldoOtrasComis + Mov_Cantidad
		WHERE CreditoID 	   = Par_CreditoID
		  AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_SegCuota) THEN
	UPDATE AMORTICREDITO SET
		SaldoSeguroCuota = SaldoSeguroCuota + Mov_Cantidad
        WHERE CreditoID  = Par_CreditoID
			AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_IVASegCuota) THEN
	UPDATE AMORTICREDITO SET
		SaldoIVASeguroCuota = SaldoIVASeguroCuota + Mov_Cantidad
        WHERE CreditoID = Par_CreditoID
			AND AmortizacionID = Par_AmortiCreID;
ELSEIF (Par_TipoMovCreID = Mov_ComAnual) THEN/*COMISION ANUAL*/
	UPDATE AMORTICREDITO SET
		SaldoComisionAnual = SaldoComisionAnual + Mov_Cantidad
        WHERE CreditoID  = Par_CreditoID
			AND AmortizacionID = Par_AmortiCreID;
ELSEIF (Par_TipoMovCreID = Mov_ComAnualIVA) THEN/*COMISION ANUAL*/
	UPDATE AMORTICREDITO SET
		SaldoComisionAnualIVA = SaldoComisionAnualIVA + Mov_Cantidad
        WHERE CreditoID  = Par_CreditoID
			AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_NotaCargoConIVA) THEN -- Nota cargo con IVA
	UPDATE CREDITOS SET
		SaldoNotCargoConIVA = SaldoNotCargoConIVA + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoNotCargoConIVA = SaldoNotCargoConIVA + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID
	AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_NotaCargoSinIVA) THEN -- Nota Cargo sin IVA
	UPDATE CREDITOS SET
		SaldoNotCargoSinIVA = SaldoNotCargoSinIVA + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoNotCargoSinIVA = SaldoNotCargoSinIVA + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID
	AND AmortizacionID = Par_AmortiCreID;

ELSEIF (Par_TipoMovCreID = Mov_NotaCargoNoRecon) THEN -- Nota cargo no reconocido
	UPDATE CREDITOS SET
		SaldoNotCargoRev = SaldoNotCargoRev + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID;

	UPDATE AMORTICREDITO SET
		SaldoNotCargoRev = SaldoNotCargoRev + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID
	AND AmortizacionID = Par_AmortiCreID;

ELSEIF ( Par_TipoMovCreID = Mov_ComSerGarantia ) THEN

	-- comision por Servicio de Garantia
	UPDATE AMORTICREDITO SET
		SaldoComServGar = IFNULL(SaldoComServGar, Entero_Cero) + Mov_Cantidad
	WHERE CreditoID = Par_CreditoID
	  AND AmortizacionID = Par_AmortiCreID;

	UPDATE CREDITOS SET
		SaldoComServGar 	= IFNULL(SaldoComServGar, Entero_Cero) + Mov_Cantidad,
		MontoPagComGarantia = MontoPagComGarantia +
							  CASE WHEN (Par_NatMovimiento = Nat_Cargo)
										THEN Mov_Cantidad
										ELSE Entero_Cero
							  END,
		MontoCobComGarantia = IFNULL(MontoCobComGarantia, Entero_Cero) +
							  CASE WHEN (Par_NatMovimiento = Nat_Abono)
										THEN Mov_Cantidad
										ELSE Entero_Cero
							  END
	WHERE CreditoID = Par_CreditoID;

ELSEIF ( Par_TipoMovCreID = Mov_IVAComSerGarantia ) THEN

	-- IVA de comision por Servicio de Garantia
	UPDATE AMORTICREDITO SET
		SaldoIVAComSerGar = IFNULL(SaldoIVAComSerGar, Entero_Cero) + Mov_Cantidad
	WHERE CreditoID  = Par_CreditoID
	  AND AmortizacionID = Par_AmortiCreID;

	UPDATE CREDITOS SET
		SaldoIVAComSerGar = IFNULL(SaldoIVAComSerGar, Entero_Cero) + Mov_Cantidad,
		MontoPagComGarantia = MontoPagComGarantia +
							  CASE WHEN (Par_NatMovimiento = Nat_Cargo)
										THEN Mov_Cantidad
										ELSE Entero_Cero
							  END,
		MontoCobComGarantia = IFNULL(MontoCobComGarantia, Entero_Cero) +
							  CASE WHEN (Par_NatMovimiento = Nat_Abono)
										THEN Mov_Cantidad
										ELSE Entero_Cero
							  END
	WHERE CreditoID = Par_CreditoID;

IF (Par_NatMovimiento = Nat_Abono) THEN
	SET Mov_Cantidad = Mov_Cantidad * -1;
END IF;

END IF;

INSERT CREDITOSMOVS (
	CreditoID,			AmortiCreID,		Transaccion,		FechaOperacion,		FechaAplicacion,
	TipoMovCreID,		NatMovimiento,		MonedaID,			Cantidad,			Descripcion,
	Referencia,			PolizaID,			EmpresaID,			Usuario,			FechaActual,
	DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
VALUES(
	Par_CreditoID,		Par_AmortiCreID,	Par_Transaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
	Par_TipoMovCreID,	Par_NatMovimiento,	Par_MonedaID,		Par_Cantidad,		Par_Descripcion,
	Par_Referencia,		Par_Poliza,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);


IF (Par_Descripcion = Des_PagoCred AND Aud_ProgramaID = Pro_PagCre) THEN
	CALL DETALLEPAGCREPRO(
		Par_AmortiCreID,	Par_CreditoID,		Par_FechaOperacion,		Par_Transaccion,	Var_ClienteID,
		Par_Cantidad,		Par_TipoMovCreID,	Par_OrigenPago,			Salida_NO,			Par_IntNumErr,
		Par_ErrMen,			Par_ModoPago,		Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
END IF;
END ManejoErrores;
END TerminaStore$$