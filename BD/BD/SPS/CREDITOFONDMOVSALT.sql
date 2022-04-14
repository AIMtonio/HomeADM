-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDMOVSALT`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDMOVSALT`(
	Par_CreditoFondeoID		BIGINT(20),		/* ID del credito de fondeo */
	Par_AmortizacionID		INT(4),
	Par_Transaccion			BIGINT(20),
	Par_FechaOperacion		DATE,
	Par_FechaAplicacion		DATE,

	Par_TipoMovFondeoID		INT(4),
	Par_NatMovimiento		CHAR(1),
	Par_MonedaID			INT(11),
	Par_Cantidad			DECIMAL(14,4),
	Par_Descripcion			VARCHAR(100),

	Par_Referencia			VARCHAR(50),
	Par_Salida		      	CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)	)
TerminaStore: BEGIN

/* DECLARACION DE CONSTANTES */
DECLARE	Cadena_Vacia		CHAR(1);		/* Cadena vacia	*/
DECLARE	Fecha_Vacia			DATE;			/* Fecha Vacia*/
DECLARE	Entero_Cero			INT;			/* Entero Cero */
DECLARE	Decimal_Cero		DECIMAL(12,2);	/* Decimal Cero */
DECLARE	Nat_Cargo			CHAR(1);		/* Naturaleza Cargo */

DECLARE	Nat_Abono			CHAR(1);		/* Naturaleza Abono */
DECLARE	Est_Vigente			CHAR(1);		/* Estatus Vigente */
DECLARE	Salida_SI			CHAR(1);		/* Valor para devolver una Salida */
DECLARE	Salida_NO			CHAR(1);		/* Valor para no devolver una Salida */
DECLARE	Mov_CapVig			INT(4);			/* Movimiento de Capital Vigente tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_CapExi 			INT(4);			/* Movimiento de Capital Exigible tabla - TIPOSMOVSFONDEO */
DECLARE	Mov_IntOrd 			INT(4);			/* Movimiento de Interes Ordinario  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_IVAInt 			INT(4);			/* Movimiento de IVA de Interes tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_IntAtr 			INT(4);			/* Movimiento de Interes Atrasado  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_IntMor			INT(4);			/* Movimiento de Interes Moratorio  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_IVAMor			INT(4);			/* Movimiento de IVA de Interes Moratorio  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_ComFalPag		INT(4);			/* Movimiento de Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_IVAFalPag 		INT(4);			/* Movimiento de IVA por Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
DECLARE	Mov_Reten	 		INT(4);			/* Movimiento de RETENCION; tabla - TIPOSMOVSFONDEO*/
DECLARE	Pro_GenInt			VARCHAR(50);	/* Corresponde con el nombre del programa que genera interes */
DECLARE	Pro_PagCre			VARCHAR(50);	/* Corresponde con el nombre del programa que realiza el pago de credito pasivo */
DECLARE Pro_PrepagoCre		VARCHAR(50);	-- Corresponde al nombre del programa que realiza el prepago de credito pasivo
DECLARE	Des_PagoCred		VARCHAR(50);


/* DECLARACION DE VARIABLES */
DECLARE	Var_Estatus 		CHAR(1);		/* Estatus del credito pasivo*/
DECLARE	Var_AcumProv 		DECIMAL(12,4);
DECLARE	Mov_Cantidad 		DECIMAL(14,4);

/* ASIGNACION DE CONSTANTES */
SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.00;
SET	Nat_Cargo			:= 'C';

SET	Nat_Abono			:= 'A';
SET	Est_Vigente			:= 'N';
SET	Salida_SI			:= 'S';				/* Valor para devolver una Salida */
SET	Salida_NO			:= 'N';				/* Valor para no devolver una Salida */
SET	Mov_CapVig 			:= 1;				/* Movimiento de Capital Vigente tabla - TIPOSMOVSFONDEO*/
SET	Mov_CapExi 			:= 2;				/* Movimiento de Capital Exigible tabla - TIPOSMOVSFONDEO */
SET	Mov_IntOrd 			:= 10;				/* Movimiento de Interes Ordinario  tabla - TIPOSMOVSFONDEO*/
SET	Mov_IntAtr 			:= 11;				/* Movimiento de Interes Atrasado  tabla - TIPOSMOVSFONDEO*/
SET	Mov_IntMor 			:= 15;				/* Movimiento de Interes Moratorio  tabla - TIPOSMOVSFONDEO*/
SET	Mov_IVAMor 			:= 21;				/* Movimiento de IVA de Interes Moratorio  tabla - TIPOSMOVSFONDEO*/
SET	Mov_ComFalPag 		:= 40;				/* Movimiento de Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
SET Mov_IVAFalPag 		:= 22;				/* Movimiento de IVA por Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
SET Mov_IVAInt          := 20;				/* Movimiento de IVA de Interes tabla - TIPOSMOVSFONDEO*/
SET Mov_Reten			:= 30;				/* Movimiento de RETENCION; tabla - TIPOSMOVSFONDEO*/
SET	Pro_GenInt			:= 'GENINTPROCREPASPRO';	/* Corresponde con el nombre del programa que genera interes */
SET	Pro_PagCre			:= 'PAGOCREDITOFONPRO';		/* Corresponde con el nombre del programa que realiza el pago de credito pasivo */
SET Pro_PrepagoCre		:= 'PREPAGOPASIVOSIGCPRO';	-- Corresponde al nombre del programa que realiza el prepago de credito pasivo.
SET Des_PagoCred        := 'PAGO DE CREDITO PASIVO';

/* ASIGNACION DE VARIABLES */


IF (IFNULL(Par_CreditoFondeoID, Entero_Cero)= Entero_Cero) THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '001' AS NumErr,
			'El Numero de Credito Pasivo esta vacio.' AS ErrMen,
			'creditoFondeoID' AS control,
			Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 1;
		SET	Par_ErrMen := 'El Numero de Credito Pasivo esta vacio.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

SET Var_Estatus := (SELECT	Estatus
	FROM CREDITOFONDEO
	WHERE CreditoFondeoID = Par_CreditoFondeoID);

SET Var_Estatus = IFNULL(Var_Estatus, Cadena_Vacia);

IF Var_Estatus = Cadena_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '002' AS NumErr,
			   'El Credito Pasivo no Existe.' AS ErrMen,
			   'creditoFondeoID' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 2;
		SET	Par_ErrMen := 'El Credito Pasivo no Existe.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF (Var_Estatus != Est_Vigente) THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '003' AS NumErr,
			   'Estatus del Credito Pasivo Incorrecto.' AS ErrMen,
			   'creditoFondeoID' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 3;
		SET	Par_ErrMen := 'Estatus del Credito Pasivo Incorrecto.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Transaccion, Entero_Cero))= Entero_Cero THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '004' AS NumErr,
			   'El numero de Movimiento esta vacio.' AS ErrMen,
			   'creditoFondeoID' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 4;
		SET	Par_ErrMen := 'El numero de Movimiento esta vacio.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;


IF(IFNULL(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '005' AS NumErr,
			  'La Fecha Op. esta Vacia.' AS ErrMen,
			  'fecha' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 5;
		SET	Par_ErrMen := 'La Fecha Op. esta Vacia.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '006' AS NumErr,
			  'La Fecha Apl. esta Vacia.' AS ErrMen,
			  'fecha' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 6;
		SET	Par_ErrMen := 'La Fecha Apl. esta Vacia.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '007' AS NumErr,
			  'La naturaleza del Movimiento esta vacia.' AS ErrMen,
			  'natMovimiento' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 7;
		SET	Par_ErrMen := 'La naturaleza del Movimiento esta vacia.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(Par_NatMovimiento<>Nat_Cargo)THEN
	IF(Par_NatMovimiento<>Nat_Abono)THEN
		IF (Par_Salida = Salida_SI) THEN
			SELECT '008' AS NumErr,
				  'La naturaleza del Movimiento no es correcta.' AS ErrMen,
				  'natMovimiento' AS control,
					Entero_Cero AS consecutivo;
		ELSE
			SET	Par_NumErr := 8;
			SET	Par_ErrMen := 'La naturaleza del Movimiento no es correcta.';
			SET	Par_Consecutivo := Entero_Cero;
		END IF;
		LEAVE TerminaStore;
	END IF;
END IF;

IF(IFNULL(Par_Cantidad, Decimal_Cero)) <= Decimal_Cero THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '010' AS NumErr,
			   'La Cantidad es Incorrecta.' AS ErrMen,
			   'cantidad' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 10;
		SET	Par_ErrMen := 'La Cantidad es Incorrecta.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '011' AS NumErr,
			  'La Descripcion del Movimiento esta vacia.' AS ErrMen,
			  'descripcion' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 11;
		SET	Par_ErrMen := 'La Descripcion del Movimiento esta vacia.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '012' AS NumErr,
			  'La Referencia esta vacia.' AS ErrMen,
			  'referencia' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 12;
		SET	Par_ErrMen := 'La Referencia esta vacia.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(IFNULL(Par_TipoMovFondeoID, Entero_Cero)) = Entero_Cero THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '013' AS NumErr,
			  'El Tipo de Movimiento esta vacio.' AS ErrMen,
			  'tipoMovCreID' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 14;
		SET	Par_ErrMen := 'El Tipo de Movimiento esta vacio.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;

IF(NOT EXISTS(SELECT AmortizacionID
				FROM AMORTIZAFONDEO
				WHERE CreditoFondeoID 	= Par_CreditoFondeoID
				  AND AmortizacionID	= Par_AmortizacionID)) THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT '014' AS NumErr,
			  'La Amortizacion no existe.' AS ErrMen,
			  'amortizacionID' AS control,
				Entero_Cero AS consecutivo;
	ELSE
		SET	Par_NumErr := 14;
		SET	Par_ErrMen := 'El Tipo de Movimiento esta vacio.';
		SET	Par_Consecutivo := Entero_Cero;
	END IF;
	LEAVE TerminaStore;
END IF;


SET Mov_Cantidad = Par_Cantidad;

IF (Par_NatMovimiento = Nat_Abono) THEN
	SET Mov_Cantidad = Mov_Cantidad * -1;
END IF;

/* Si el tipo de movimiento es interes ordinario o provisionado. */
IF (Par_TipoMovFondeoID = Mov_IntOrd) THEN
	/* si el tipo de movimiento es un cargo y el programa es GENERAINTEREFONPRO, entonces acumula provision */
	IF (Par_NatMovimiento = Nat_Cargo AND Aud_ProgramaID = Pro_GenInt) THEN
		SET Var_AcumProv = Mov_Cantidad;
	ELSE
		SET Var_AcumProv = Entero_Cero;
	END IF;

	UPDATE CREDITOFONDEO SET /* se actualizan los saldos del credito de fondeo */
		SaldoInteresPro			= SaldoInteresPro + Mov_Cantidad,
		ProvisionAcum			= ProvisionAcum + Var_AcumProv
		WHERE CreditoFondeoID	= Par_CreditoFondeoID;

	UPDATE AMORTIZAFONDEO SET /* se actualizan los saldos de la amortizacion de fondeo */
		SaldoInteresPro			= SaldoInteresPro + Mov_Cantidad,
		ProvisionAcum			= ProvisionAcum + Var_AcumProv
		WHERE CreditoFondeoID	= Par_CreditoFondeoID
		  AND AmortizacionID	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_CapVig) THEN /* si el tipo de movimiento es Capital Vigente */
	UPDATE CREDITOFONDEO SET /* se actualizan los saldos del credito de fondeo */
		SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
		WHERE CreditoFondeoID = Par_CreditoFondeoID;

	UPDATE AMORTIZAFONDEO SET /* se actualizan los saldos de la amortizacion de fondeo */
		SaldoCapVigente	= SaldoCapVigente + Mov_Cantidad
		WHERE CreditoFondeoID	= Par_CreditoFondeoID
		  AND AmortizacionID 	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_CapExi) THEN  /* si el tipo de movimiento es Capital Exigible  o atrasado  */
	UPDATE CREDITOFONDEO SET /* se actualizan los saldos del credito de fondeo */
		SaldoCapAtrasad			= SaldoCapAtrasad + Mov_Cantidad
		WHERE CreditoFondeoID 	= Par_CreditoFondeoID;

	UPDATE AMORTIZAFONDEO SET /* se actualizan los saldos de la amortizacion de fondeo */
		SaldoCapAtrasad			= SaldoCapAtrasad + Mov_Cantidad
		WHERE CreditoFondeoID	= Par_CreditoFondeoID
		  AND AmortizacionID	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_IntAtr) THEN  /* si el tipo de movimiento es Interes en Atraso */
	UPDATE CREDITOS SET /* se actualizan los saldos del credito de fondeo */
		SaldoInteresAtra	= SaldoInteresAtra + Mov_Cantidad
		WHERE CreditoID 	= Par_CreditoID;

	UPDATE AMORTICREDITO SET /* se actualizan los saldos de la amortizacion de fondeo */
		SaldoInteresAtra	= SaldoInteresAtra + Mov_Cantidad
		WHERE CreditoID 	= Par_CreditoID
		 AND AmortizacionID	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_IntMor) THEN  /* si el tipo de movimiento es Interes Moratorio */
	/* si la naturaleza es un abono y es un pago de credito se actualizan los saldos moratorios */

		UPDATE CREDITOFONDEO SET /* se actualizan los saldos del credito de fondeo */
			SaldoMoratorios	= SaldoMoratorios + Mov_Cantidad
			WHERE CreditoFondeoID = Par_CreditoFondeoID;

		UPDATE AMORTIZAFONDEO SET /* se actualizan los saldos de la amortizacion de fondeo */
			SaldoMoratorios	= SaldoMoratorios + Mov_Cantidad
			WHERE CreditoFondeoID	= Par_CreditoFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_ComFalPag) THEN  /* si el tipo de movimiento es Comision por Falta de Pago*/
	/* Si el tipo de movimiento es un abono y es un pago de credito se actualiza la comision por falta de pago */

	UPDATE CREDITOFONDEO SET /* se actualiza la columna del credito pasivo */
		SaldoComFaltaPa	= SaldoComFaltaPa + Mov_Cantidad
		WHERE CreditoFondeoID = Par_CreditoFondeoID;

	UPDATE AMORTIZAFONDEO SET /* se actualiza la columna de las amortizaciones de credito */
		SaldoComFaltaPa	= SaldoComFaltaPa + Mov_Cantidad
		WHERE CreditoFondeoID	= Par_CreditoFondeoID
		  AND AmortizacionID	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_IVAInt) THEN /* si el tipo de movimiento es iva de interes*/
	UPDATE CREDITOFONDEO SET
		SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
			WHERE CreditoFondeoID = Par_CreditoFondeoID;

	UPDATE AMORTIZAFONDEO SET
		SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
			WHERE CreditoFondeoID	= Par_CreditoFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;


ELSEIF (Par_TipoMovFondeoID = Mov_IVAMor) THEN /* si el tipo de movimiento es iva de interes mOratorio*/
	UPDATE CREDITOFONDEO SET/* se actualiza la columna del credito pasivo */
		SaldoIVAMora	= SaldoIVAMora + Par_Cantidad
			WHERE CreditoFondeoID = Par_CreditoFondeoID;

	UPDATE AMORTIZAFONDEO SET
		SaldoIVAMora	= SaldoIVAMora + Par_Cantidad
			WHERE CreditoFondeoID	= Par_CreditoFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;

ELSEIF (Par_TipoMovFondeoID = Mov_IVAFalPag) THEN /* si el tipo de movimiento es iva Comision por Falta de Pago*/
	UPDATE CREDITOFONDEO SET/* se actualiza la columna del credito pasivo */
		SaldoIVAComFalP	= SaldoIVAComFalP + Par_Cantidad
			WHERE CreditoFondeoID = Par_CreditoFondeoID;
	UPDATE AMORTIZAFONDEO SET
		SaldoIVAComFalP	= SaldoIVAComFalP + Par_Cantidad
			WHERE CreditoFondeoID	= Par_CreditoFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;

/*MOVIMIENTO DE RETENCION */
ELSEIF (Par_TipoMovFondeoID = Mov_Reten) THEN /* si el tipo de movimiento es por retencion*/
	UPDATE CREDITOFONDEO SET/* se actualiza la columna del credito pasivo */
		SaldoRetencion	= IFNULL(SaldoRetencion,0) + Par_Cantidad
			WHERE CreditoFondeoID = Par_CreditoFondeoID;
	UPDATE AMORTIZAFONDEO SET
		SaldoRetencion	= IFNULL(SaldoRetencion,0) + Par_Cantidad
			WHERE CreditoFondeoID	= Par_CreditoFondeoID
			  AND AmortizacionID	= Par_AmortizacionID;

END IF;

/* Se insertar Los movimientos del Credito de fondeo */
INSERT INTO CREDITOFONDMOVS (
	CreditoFondeoID,		AmortizacionID,			Transaccion,		FechaOperacion,		FechaAplicacion,
	TipoMovFonID,			NatMovimiento,			MonedaID,			Cantidad,			Descripcion,
	Referencia,				EmpresaID,				Usuario,			FechaActual,		DireccionIP,
	ProgramaID,				Sucursal,				NumTransaccion)
VALUES(
	Par_CreditoFondeoID,	Par_AmortizacionID,		Par_Transaccion,	Par_FechaOperacion,	Par_FechaAplicacion,
	Par_TipoMovFondeoID,	Par_NatMovimiento,		Par_MonedaID,		Par_Cantidad,		Par_Descripcion,
	Par_Referencia,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);


IF (Par_Descripcion = Des_PagoCred AND (Aud_ProgramaID = Pro_PagCre OR Aud_ProgramaID = Pro_PrepagoCre)) THEN
	CALL DETALLEPAGFONPRO(
		Par_AmortizacionID,		Par_CreditoFondeoID,		Par_FechaOperacion,	Par_Transaccion,	Par_Cantidad,
		Par_TipoMovFondeoID,	Salida_NO,					Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);
END IF;


SET Par_NumErr := 0;
SET Par_ErrMen := 'Movimientos Insertados correctamente ';

END TerminaStore$$