-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOMOVSSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWFONDEOMOVSSALT`;
DELIMITER $$

CREATE PROCEDURE `CRWFONDEOMOVSSALT`(
	/* SP DE ALTA DE MOVIMIENTOS DE INVERSION */
	Par_SolFondeoID			BIGINT(20),			-- ID DEL FONDEO
	Par_AmortizacionID		INT(4),				-- ID DE LA AMORTIZACION
	Par_Transaccion			BIGINT(20),			-- NUMERO DE TRANSACCION
	Par_FechaOperacion		DATE,				-- FECHA DE OPERACION
	Par_FechaAplicacion		DATE,				-- FECHA DE APLICACION

	Par_TipoMovCRWID		INT(4),				-- TIPO DE MOVIMIENTO ID
	Par_NatMovimiento		CHAR(1),			-- NATURALEZA DE MOVIMIENTO
	Par_MonedaID			INT(11),			-- MONEDA ID
	Par_Cantidad			DECIMAL(14,4),		-- CANTIDAD
	Par_Descripcion			VARCHAR(100),		-- DESCRIPCION

	Par_Referencia			VARCHAR(50),		-- REFERENCIA
	Par_Salida				CHAR(1),			-- PARAMETRO DE SALIDA
	INOUT Par_NumErr		INT(11),			-- NUMERO DE ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR
	INOUT Par_Consecutivo	BIGINT(20),			-- CONSECUTIVO

	Aud_EmpresaID			INT(11),			-- AUDITORIA
	Aud_Usuario				INT(11),			-- AUDITORIA
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA

	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN


DECLARE	Fecha				DATE;
DECLARE	Mov_Cantidad 		DECIMAL(14,4);
DECLARE	Var_Estatus 		CHAR(1);
DECLARE	Var_AcumProv 		DECIMAL(12,4);
DECLARE Var_Control			VARCHAR(50);

DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(12,2);

DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Est_Vigente			CHAR(1);
DECLARE	Est_Vencido			CHAR(1);

DECLARE	Mov_CapOrd 			INT(11);
DECLARE	Mov_CapAtr 			INT(11);

DECLARE	Mov_IntOrd 			INT(11);
DECLARE	Mov_IntMor 			INT(11);
DECLARE	Mov_ComFalPag 		INT(11);

DECLARE	Mov_RetInt 			INT(11);
DECLARE	Mov_RetMor 			INT(11);
DECLARE	Mov_RetFalPag 		INT(11);

DECLARE	Pro_GenInt			VARCHAR(50);
DECLARE	Pro_PagCre			VARCHAR(50);
DECLARE Pro_AplGar      	VARCHAR(50);
DECLARE TipoMovCapCtaOr		INT(4);
DECLARE TipoMovIntCtaOr		INT(4);

DECLARE	Des_PagoInv			VARCHAR(50);
DECLARE Var_NO				CHAR(1);

SET	Cadena_Vacia	:= '';					-- Cadena Vacia
SET	Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
SET	Entero_Cero		:= 0;					-- Entero Cero
SET	Decimal_Cero	:= 0.00;				-- DECIMAL Cero

SET	Nat_Cargo		:= 'C';					-- Naturaleza Cargo
SET	Nat_Abono		:= 'A';					-- Naturaleza Abono

SET	Est_Vigente		:= 'N';					-- Estatus vigente
SET	Est_Vencido		:= 'V';					-- Estatus Vencido

SET	Mov_CapOrd 		:= 1;					-- Tipo de movimiento de Kubo Capital Vigente
SET	Mov_CapAtr 		:= 2;					-- Tipo de movimiento de Kubo Capital Exigible
SET	Mov_IntOrd 		:= 10;					-- Tipo de movimiento de Kubo Interes Ordinario
SET	Mov_IntMor 		:= 15;					-- Tipo de movimiento de Kubo Interes Moratorio
SET	Mov_ComFalPag 	:= 40;					-- Tipo de movimiento de Kubo Comision por Falta de Pago

SET	Mov_RetInt 		:= 50;					-- Tipo de movimiento de Kubo Retencion por Interes
SET	Mov_RetMor 		:= 51;					-- Tipo de movimiento de Kubo Retencion por Moratorios
SET	Mov_RetFalPag 	:= 52;					-- Tipo de movimiento de Kubo Retencion Com. por Falta Pago
SET TipoMovCapCtaOr	:= 3;					-- Tipo de movimiento de kubo Capital en cuenta de Orden corresponde con TIPOSMOVSCRW
SET TipoMovIntCtaOr	:= 16;					-- Tipo de movimiento de kubo Interés en cuenta de Orden corresponde con TIPOSMOVSCRW

SET	Pro_GenInt		:= 'GENERAINTEREINVPRO';
SET	Pro_PagCre		:= 'PAGOCREDITOPRO';
SET Pro_AplGar      := 'INVKUBOCIEDIAPRO';

SET	Des_PagoInv		:= 'PAGO DE INVERSION%';
SET Var_NO			:= 'N';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONDEOMOVSSALT');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	IF(IFNULL(Par_SolFondeoID, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr	:= 01;
		SET Par_ErrMen	:= 'El Numero de Fondeo esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	SELECT	Estatus INTO Var_Estatus
		FROM CRWFONDEO
		WHERE SolFondeoID = Par_SolFondeoID;

	SET Var_Estatus = IFNULL(Var_Estatus, Cadena_Vacia);

	IF (Var_Estatus = Cadena_Vacia) THEN
		SET Par_NumErr	:= 02;
		SET Par_ErrMen	:= 'El Fondeo no Existe.';
		LEAVE ManejoErrores;
	END IF;

	IF (Var_Estatus != Est_Vigente AND Var_Estatus != Est_Vencido) THEN
		SET Par_NumErr	:= 03;
		SET Par_ErrMen	:= 'Estatus del Fondeo Incorrecto.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Transaccion, Entero_Cero))= Entero_Cero THEN
		SET Par_NumErr	:= 04;
		SET Par_ErrMen	:= 'El Numero de Movimiento esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr	:= 05;
		SET Par_ErrMen	:= 'La Fecha Op. esta Vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia THEN
		SET Par_NumErr	:= 06;
		SET Par_ErrMen	:= 'La Fecha Apl. esta Vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr	:= 07;
		SET Par_ErrMen	:= 'La naturaleza del Movimiento esta vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(Par_NatMovimiento<>Nat_Cargo)THEN
		IF(Par_NatMovimiento<>Nat_Abono)THEN
			SET Par_NumErr	:= 08;
			SET Par_ErrMen	:= 'La naturaleza del Movimiento no es correcta.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(Par_NatMovimiento<>Nat_Abono)THEN
		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			SET Par_NumErr	:= 09;
			SET Par_ErrMen	:= 'La naturaleza del Movimiento no es correcta.';
			LEAVE ManejoErrores;
		END IF;
	END IF;

	IF(IFNULL(Par_Cantidad, Decimal_Cero)) <= Decimal_Cero THEN
		SET Par_NumErr	:= 10;
		SET Par_ErrMen	:= 'La Cantidad es Incorrecta.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr	:= 11;
		SET Par_ErrMen	:= 'La Descripcion del Movimiento esta vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
		SET Par_NumErr	:= 12;
		SET Par_ErrMen	:= 'La Referencia esta vacia.';
		LEAVE ManejoErrores;
	END IF;

	IF(IFNULL(Par_TipoMovCRWID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr	:= 13;
		SET Par_ErrMen	:= 'El Tipo de Movimiento esta vacio.';
		LEAVE ManejoErrores;
	END IF;

	IF(NOT EXISTS(SELECT AmortizacionID FROM AMORTICRWFONDEO
					WHERE SolFondeoID 	= Par_SolFondeoID AND AmortizacionID	= Par_AmortizacionID)) THEN
		SET Par_NumErr	:= 14;
		SET Par_ErrMen	:= 'La Amortizacion no existe.';
		LEAVE ManejoErrores;
	END IF;

	SET Mov_Cantidad = Par_Cantidad;

	IF (Par_NatMovimiento = Nat_Abono) THEN
		SET Mov_Cantidad = Mov_Cantidad * -1;
	END IF;

	IF (Par_TipoMovCRWID = Mov_IntOrd) THEN
		IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
			SET Var_AcumProv = Mov_Cantidad;
		ELSE
			SET Var_AcumProv = Entero_Cero;
		END IF;

		UPDATE CRWFONDEO SET
			SaldoInteres		= SaldoInteres + Mov_Cantidad,
			ProvisionAcum		= ProvisionAcum + Var_AcumProv
			WHERE SolFondeoID = Par_SolFondeoID;

		UPDATE AMORTICRWFONDEO SET
			SaldoInteres		= SaldoInteres + Mov_Cantidad,
			ProvisionAcum		= ProvisionAcum + Var_AcumProv
			WHERE SolFondeoID	= Par_SolFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;

	ELSEIF (Par_TipoMovCRWID = Mov_CapOrd) THEN
		UPDATE CRWFONDEO SET
			SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
			WHERE SolFondeoID = Par_SolFondeoID;

		UPDATE AMORTICRWFONDEO SET
			SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
			WHERE SolFondeoID	= Par_SolFondeoID
			  AND AmortizacionID 	= Par_AmortizacionID;

	ELSEIF (Par_TipoMovCRWID = Mov_CapAtr) THEN
		UPDATE CRWFONDEO SET
			SaldoCapExigible	= SaldoCapExigible + Mov_Cantidad
			WHERE SolFondeoID = Par_SolFondeoID;

		UPDATE AMORTICRWFONDEO SET
			SaldoCapExigible	= SaldoCapExigible + Mov_Cantidad
			WHERE SolFondeoID	= Par_SolFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;

	ELSEIF (Par_TipoMovCRWID = Mov_IntMor) THEN
		IF (Par_NatMovimiento = Nat_Abono) THEN
			UPDATE CRWFONDEO SET
				MoratorioPagado	= IFNULL(MoratorioPagado,Decimal_Cero)  + Par_Cantidad,
				SaldoIntMoratorio	= IFNULL(SaldoIntMoratorio, Decimal_Cero) - Par_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				MoratorioPagado		= IFNULL(MoratorioPagado,Decimal_Cero)  + Par_Cantidad,
				SaldoIntMoratorio	=IFNULL(SaldoIntMoratorio, Decimal_Cero) - Par_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;

		ELSEIF(Par_NatMovimiento = Nat_Cargo)THEN
			UPDATE CRWFONDEO SET
				SaldoIntMoratorio	= IFNULL(SaldoIntMoratorio, Decimal_Cero) + Par_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;
			UPDATE AMORTICRWFONDEO SET
				SaldoIntMoratorio	=IFNULL(SaldoIntMoratorio,Decimal_Cero)+ Par_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;
		END IF;
	ELSEIF (Par_TipoMovCRWID = Mov_ComFalPag) THEN

		IF (Par_NatMovimiento = Nat_Abono AND Aud_ProgramaID = Pro_PagCre) THEN
			UPDATE CRWFONDEO SET
				ComFalPagPagada	= ComFalPagPagada + Par_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				ComFalPagPagada	= ComFalPagPagada + Par_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;
		END IF;

	ELSEIF (Par_TipoMovCRWID = Mov_RetInt) THEN

		IF (Par_NatMovimiento = Nat_Cargo AND (Aud_ProgramaID = Pro_PagCre OR Aud_ProgramaID=Pro_AplGar)) THEN
			UPDATE CRWFONDEO SET
				IntOrdRetenido	= IntOrdRetenido + Par_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				IntOrdRetenido	= IntOrdRetenido + Par_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;
		END IF;

	ELSEIF (Par_TipoMovCRWID = Mov_RetMor) THEN

		IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_PagCre) THEN
			UPDATE CRWFONDEO SET
				IntMorRetenido	= IntMorRetenido + Par_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				IntMorRetenido		= IntMorRetenido + Par_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;
		END IF;

	ELSEIF (Par_TipoMovCRWID = Mov_RetFalPag) THEN

		IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_PagCre) THEN
			UPDATE CRWFONDEO SET
				ComFalPagRetenido	= ComFalPagRetenido + Par_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				ComFalPagRetenido	= ComFalPagRetenido + Par_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;
		END IF;
	ELSEIF(Par_TipoMovCRWID = TipoMovCapCtaOr)THEN
			UPDATE CRWFONDEO SET
				SaldoCapCtaOrden	= IFNULL(SaldoCapCtaOrden,Decimal_Cero) + Mov_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				SaldoCapCtaOrden	= IFNULL(SaldoCapCtaOrden,Decimal_Cero) + Mov_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;

	ELSEIF(Par_TipoMovCRWID = TipoMovIntCtaOr)THEN
			UPDATE CRWFONDEO SET
				SaldoIntCtaOrden	= IFNULL(SaldoIntCtaOrden,Decimal_Cero) + Mov_Cantidad
				WHERE SolFondeoID = Par_SolFondeoID;

			UPDATE AMORTICRWFONDEO SET
				SaldoIntCtaOrden	= IFNULL(SaldoIntCtaOrden,Decimal_Cero) + Mov_Cantidad
				WHERE SolFondeoID	= Par_SolFondeoID
				  AND AmortizacionID	= Par_AmortizacionID;

	END IF;

	INSERT CRWFONDEOMOVS(
		SolFondeoID,			AmortizacionID,		Transaccion,		FechaOperacion,			FechaAplicacion,
		TipoMovCRWID,			NatMovimiento,		MonedaID,			Cantidad,				Descripcion,
		Referencia,				EmpresaID,			Usuario,			FechaActual,			DireccionIP,
		ProgramaID,				Sucursal,			NumTransaccion
	)VALUES(
		Par_SolFondeoID,		Par_AmortizacionID,	Par_Transaccion,	Par_FechaOperacion,		Par_FechaAplicacion,
		Par_TipoMovCRWID,		Par_NatMovimiento,	Par_MonedaID,		Par_Cantidad,			Par_Descripcion,
		Par_Referencia,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

	IF(Aud_ProgramaID = Pro_PagCre AND Par_Descripcion LIKE Des_PagoInv) THEN
		CALL CRWDETALLEPAGINVPRO(
			Par_SolFondeoID,	Par_AmortizacionID,	Par_FechaAplicacion,	Par_Transaccion,	Par_Cantidad,
			Par_TipoMovCRWID,	Var_NO,				Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion
		);
	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := 'Proceso Terminado Exitosamente';

END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				'creditoID' 	AS control;
	END IF;

END TerminaStore$$
