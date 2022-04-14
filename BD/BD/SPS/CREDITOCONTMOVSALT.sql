-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOCONTMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOCONTMOVSALT`;DELIMITER $$

CREATE PROCEDURE `CREDITOCONTMOVSALT`(
# =======================================================================
# --- SP para dar de alta los movimientos de los creditos contingentes--
# =======================================================================
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

	Par_Salida            	CHAR(1),
	OUT	Par_NumErr			INT(11),
	OUT	Par_ErrMen			VARCHAR(400),

	OUT	Par_Consecutivo		BIGINT,
	Par_ModoPago			CHAR(1),
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Fecha           DATE;
	DECLARE Mov_Cantidad    DECIMAL(12,4);
	DECLARE Var_CreStatus   CHAR(1);
	DECLARE Var_AcumProv    DECIMAL(12,4);
	DECLARE Var_ClienteID   INT;
	DECLARE Var_Control		VARCHAR(100);				-- Variable de control
	DECLARE	Var_Consecutivo	VARCHAR(20);				-- Variable consecutivo

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Float_Cero		FLOAT;
	DECLARE	EstatusActivo	CHAR(1);
	DECLARE	Nat_Cargo		CHAR(1);
	DECLARE	Nat_Abono		CHAR(1);
	DECLARE	Cre_Vigente		CHAR(1);
	DECLARE	Cre_Vencido		CHAR(1);
	DECLARE	Cre_Castigado	CHAR(1);
	DECLARE	Mov_CapOrd 		INT;
	DECLARE	Mov_CapAtr 		INT;
	DECLARE	Mov_CapVen 		INT;
	DECLARE	Mov_CapVNE 		INT;
	DECLARE	Mov_IntOrd 		INT;
	DECLARE	Mov_IntAtr 		INT;
	DECLARE	Mov_IntVen 		INT;
	DECLARE	Mov_IntPro 		INT;
	DECLARE	Mov_IntCalNoCon	INT;
	DECLARE	Mov_IntMor 		INT;
	DECLARE	Mov_IVAInt 		INT;
	DECLARE	Mov_IVAMor 		INT;
	DECLARE	Mov_IVAFalPag 	INT;
	DECLARE	Mov_IVAComApe 	INT;
	DECLARE	Mov_ComFalPag 	INT;
	DECLARE	Mov_ComApeCre 	INT;
	DECLARE Mov_ComLiqAnt       INT;
	DECLARE Mov_IVAComLiqAnt    INT;
	DECLARE Mov_IntMoratoVen	INT;
	DECLARE Mov_IntMoraCarVen	INT;
	DECLARE	Pro_GenInt		VARCHAR(50);
	DECLARE	Pro_PagCre		VARCHAR(50);
	DECLARE	Pro_Bonifi		VARCHAR(50);
	DECLARE	Des_PagoCred	VARCHAR(50);
	DECLARE	Salida_NO       CHAR(1);
	DECLARE	Salida_SI		CHAR(1);

	-- Asignacion de constates
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
	SET Mov_IntMoratoVen	:= 16;			-- Tipo de Movimiento: Interes Moratorio Vencido
	SET Mov_IntMoraCarVen	:= 17;          -- Tipo de Movimiento: Interes Moratorio de Cartera Vencida
	SET Salida_NO           := 'N';
	SET Pro_GenInt          := 'GENERAINTERECREPRO';
	SET Pro_PagCre          := 'PAGOCREDITOCONTPRO';
	SET Pro_Bonifi          := 'BONIFICACION';
	SET Des_PagoCred        := 'PAGO DE CREDITO CONTINGENTE';
	SET Salida_SI			:= 'S';

	ManejoErrores: BEGIN
		/*DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOCONTMOVSALT');
			SET Var_Control := 'SQLEXCEPTION' ;
			SET Var_Consecutivo := Cadena_Vacia;
		END;*/

		IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 001;
			SET Par_ErrMen 			:= CONCAT('El Numero de Credito esta vacio.');
			SET Var_Control 		:= 'creditoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus, ClienteID  INTO Var_CreStatus, Var_ClienteID
			FROM CREDITOSCONT
				WHERE CreditoID = Par_CreditoID;

		SET Var_CreStatus := IFNULL(Var_CreStatus, Cadena_Vacia);

		IF Var_CreStatus= Cadena_Vacia THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= CONCAT('El Credito no Existe.');
			SET Var_Control 	:= 'creditoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Aud_ProgramaID != "CLIENTESCANCELAPRO")THEN
			IF (Var_CreStatus != Cre_Vigente AND Var_CreStatus != Cre_Vencido  AND Var_CreStatus != Cre_Castigado ) THEN
					SET Par_NumErr 		:= 003;
					SET Par_ErrMen 		:= CONCAT('Estatus del Credito Incorrecto.');
					SET Var_Control 	:= 'creditoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Transaccion, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 		:= 004;
			SET Par_ErrMen 		:= CONCAT('El Numero de Movimiento esta Vacio.');
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo := '0';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr 		:= 005;
			SET Par_ErrMen 		:= CONCAT('La Fecha Op. esta Vacia.');
			SET Var_Control 	:= 'fecha' ;
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr 		:= 006;
			SET Par_ErrMen 		:= CONCAT('La Fecha de la Aplicacion del Movimiento esta Vacia.');
			SET Var_Control 	:= 'fecha' ;
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 007;
			SET Par_ErrMen 		:= CONCAT('La Naturaleza del Movimiento esta Vacia.');
			SET Var_Control 	:= 'natMovimiento' ;
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			IF(Par_NatMovimiento<>Nat_Abono)THEN
				SET Par_NumErr 		:= 008;
				SET Par_ErrMen 		:= CONCAT('La Naturaleza del Movimiento no es Correcta.');
				SET Var_Control 	:= 'natMovimiento' ;
				SET Var_Consecutivo := Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NatMovimiento<>Nat_Abono)THEN
			IF(Par_NatMovimiento<>Nat_Cargo)THEN
				SET Par_NumErr 		:= 009;
				SET Par_ErrMen 		:= CONCAT('La Naturaleza del Movimiento no es Correcta.');
				SET Var_Control 	:= 'natMovimiento' ;
				SET Var_Consecutivo := Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Cantidad, Float_Cero)) <= Float_Cero THEN
			SET Par_NumErr 		:= 010;
			SET Par_ErrMen 		:= CONCAT('Cantidad del Movimiento de Credito Incorrecta.');
			SET Var_Control 	:= 'cantidad' ;
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 011;
			SET Par_ErrMen 		:= CONCAT('La Descripcion del Movimiento esta Vacia.');
			SET Var_Control 	:= 'descripcion' ;
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 012;
			SET Par_ErrMen 		:= CONCAT('La Referencia esta Vacia.');
			SET Var_Control 	:= 'referencia' ;
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoMovCreID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 		:= 013;
			SET Par_ErrMen 		:= CONCAT('El Tipo de Movimiento esta Vacio.');
			SET Var_Control 	:= 'tipoMovCreID' ;
			SET Var_Consecutivo := '0';
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT AmortizacionID
							FROM AMORTICREDITOCONT
								WHERE CreditoID 		= Par_CreditoID
									AND AmortizacionID	= Par_AmortiCreID)) THEN
			SET Par_NumErr 		:= 014;
			SET Par_ErrMen 		:= CONCAT('La Amortizacion no Existe.');
			SET Var_Control 	:= 'amortizacionID' ;
			SET Var_Consecutivo := '0';
			LEAVE ManejoErrores;
		END IF;

		SET Mov_Cantidad = Par_Cantidad;

		IF (Par_NatMovimiento = Nat_Abono) THEN
			SET Mov_Cantidad := Mov_Cantidad * -1;
		END IF;

		IF (Par_TipoMovCreID = Mov_IntOrd) THEN
			UPDATE CREDITOSCONT SET
				SaldoInterOrdin	= SaldoInterOrdin + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoInteresOrd	= SaldoInterOrdin + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_CapOrd) THEN
			UPDATE CREDITOSCONT SET
				SaldoCapVigent	= SaldoCapVigent + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_CapAtr) THEN
			UPDATE CREDITOSCONT SET
				SaldoCapAtrasad	= SaldoCapAtrasad + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoCapAtrasa	= SaldoCapAtrasa + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_CapVen) THEN
			UPDATE CREDITOSCONT SET
				SaldoCapVencido	= SaldoCapVencido + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoCapVencido	= SaldoCapVencido + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_CapVNE) THEN
			UPDATE CREDITOSCONT SET
				SaldCapVenNoExi	= SaldCapVenNoExi + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoCapVenNExi	= SaldoCapVenNExi + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntAtr) THEN
			UPDATE CREDITOSCONT SET
				SaldoInterAtras	= SaldoInterAtras + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoInteresAtr	= SaldoInteresAtr + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntVen) THEN
			UPDATE CREDITOSCONT SET
				SaldoInterVenc	= SaldoInterVenc + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoInteresVen	= SaldoInteresVen + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntPro) THEN

			IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
				SET Var_AcumProv := Mov_Cantidad;
			ELSE
				SET Var_AcumProv := Entero_Cero;
			END IF;

			UPDATE CREDITOSCONT SET
				SaldoInterProvi	= SaldoInterProvi + Mov_Cantidad,
				ProvisionAcum		= ProvisionAcum + Var_AcumProv
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoInteresPro	= SaldoInteresPro + Mov_Cantidad,
				ProvisionAcum		= ProvisionAcum + Var_AcumProv
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntCalNoCon) THEN

			IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
				SET Var_AcumProv := Mov_Cantidad;
			ELSE
				SET Var_AcumProv := Entero_Cero;
			END IF;

			UPDATE CREDITOSCONT SET
				SaldoIntNoConta	= SaldoIntNoConta + Mov_Cantidad,
				ProvisionAcum		= ProvisionAcum + Var_AcumProv
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoIntNoConta	= SaldoIntNoConta + Mov_Cantidad,
				ProvisionAcum		= ProvisionAcum + Var_AcumProv
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntMor) THEN
			UPDATE CREDITOSCONT SET
				SaldoMoratorios	= SaldoMoratorios + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoMoratorios	= SaldoMoratorios + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntMoratoVen) THEN

			UPDATE CREDITOSCONT SET
				SaldoMoraVencido	= SaldoMoraVencido + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoMoraVencido	= SaldoMoraVencido + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IntMoraCarVen) THEN

			UPDATE CREDITOSCONT SET
				SaldoMoraCarVen	= SaldoMoraCarVen + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoMoraCarVen	= SaldoMoraCarVen + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IVAInt) THEN
			UPDATE CREDITOSCONT SET
				SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IVAMor) THEN
			UPDATE CREDITOSCONT SET
				SaldoIVAMorator	= SaldoIVAMorator + Par_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoIVAMorato	= SaldoIVAMorato + Par_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IVAFalPag) THEN
			UPDATE CREDITOSCONT SET
				SalIVAComFalPag	= SalIVAComFalPag + Par_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoIVAComFalP	= SaldoIVAComFalP + Par_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_IVAComApe OR Par_TipoMovCreID = Mov_IVAComLiqAnt) THEN
			UPDATE CREDITOSCONT SET
				SaldoIVAComisi	= SaldoIVAComisi + Par_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoIVAComisi	= SaldoIVAComisi + Par_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_ComFalPag) THEN
			UPDATE CREDITOSCONT SET
				SaldComFaltPago	= SaldComFaltPago + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoComFaltaPa	= SaldoComFaltaPa + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		  ELSEIF (Par_TipoMovCreID = Mov_ComApeCre OR Par_TipoMovCreID = Mov_ComLiqAnt) THEN
			UPDATE CREDITOSCONT SET
				SaldoOtrasComis	= SaldoOtrasComis + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID;

			UPDATE AMORTICREDITOCONT SET
				SaldoOtrasComis	= SaldoOtrasComis + Mov_Cantidad
				WHERE CreditoID 	   = Par_CreditoID
				  AND AmortizacionID = Par_AmortiCreID;

		END IF;

		INSERT CREDITOSCONTMOVS(
			CreditoID, 			AmortiCreID, 		Transaccion, 		FechaOperacion, 		FechaAplicacion,
			TipoMovCreID, 			NatMovimiento, 		MonedaID, 			Cantidad,				Descripcion,
			Referencia, 			PolizaID,			EmpresaID, 			Usuario, 				FechaActual,
			DireccionIP, 			ProgramaID, 		Sucursal, 			NumTransaccion)
		VALUES(
			Par_CreditoID,			Par_AmortiCreID,	Par_Transaccion,	Par_FechaOperacion,		Par_FechaAplicacion,
			Par_TipoMovCreID,		Par_NatMovimiento,	Par_MonedaID,		Par_Cantidad,			Par_Descripcion,
			Par_Referencia,			Par_Poliza,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_Descripcion = Des_PagoCred AND Aud_ProgramaID = Pro_PagCre) THEN
		    CALL DETALLEPAGCRECONTPRO(
		        Par_AmortiCreID,    Par_CreditoID,      Par_FechaOperacion, Par_Transaccion,    Var_ClienteID,
		        Par_Cantidad,       Par_TipoMovCreID,   Salida_NO,          Par_NumErr,      	Par_ErrMen,
		        Par_ModoPago,		Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
		        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

		    IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Movimiento de Credito Agregado Exitosamente.');
		SET Var_Control	:= 'cuentaAhoID' ;
        SET Par_Consecutivo := Entero_Cero;
		SET Var_Consecutivo := CONCAT(Par_Consecutivo);

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$