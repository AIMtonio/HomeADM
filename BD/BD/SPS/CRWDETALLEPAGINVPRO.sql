-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWDETALLEPAGINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRWDETALLEPAGINVPRO`;
DELIMITER $$


CREATE PROCEDURE `CRWDETALLEPAGINVPRO`(
	Par_FondeoCrwID       	BIGINT(20),
    Par_AmortizacionID  	INT(4),
    Par_FechaPago       	DATE,
    Par_Transaccion     	BIGINT(20),
    Par_MontoPago       	DECIMAL(12,2),

    Par_TipoMovCrwID   		INT(4),
	Par_Salida 				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
    Par_EmpresaID       	INT(11),

    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),

    Aud_NumTransaccion  	BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE	Var_CreditoID		BIGINT(12);
DECLARE	Var_MontoIntProv	DECIMAL(12,2);
DECLARE Var_MontoCapVig		DECIMAL(12,2);
DECLARE Var_MontoCapExi		DECIMAL(12,2);
DECLARE	Var_MontoMora		DECIMAL(12,2);
DECLARE	Var_MontoComFal		DECIMAL(12,2);
DECLARE	Var_MontoISRInt		DECIMAL(12,2);
DECLARE	Var_MontoRetMora	DECIMAL(12,2);
DECLARE	Var_MontoRetComFal	DECIMAL(12,2);
DECLARE	Var_MontoCapCO		DECIMAL(12,2);
DECLARE	Var_MontoIntCO		DECIMAL(12,2);
DECLARE	Var_TipoPago		TINYINT UNSIGNED;

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT;
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE	Salida_SI 			CHAR(1);
DECLARE MovCrwCapVig		INT;
DECLARE MovCrwCapEx		INT;
DECLARE	MovCrwCapCO		INT;
DECLARE MovCrwIntOrd		INT;
DECLARE MovCrwIntCO		INT;
DECLARE MovCrwIntMor		INT;
DECLARE MovCrwComFP		INT;
DECLARE MovCrwISRInt		INT;
DECLARE MovCrwISRMora		INT;
DECLARE MovCrwISRComFP		INT;
DECLARE	TipoPrepago			TINYINT UNSIGNED;

/*Seteo de Constantes*/
SET Cadena_Vacia    		:= '';			-- Cadena Vacia
SET Entero_Cero     		:= 0;			-- Entero Cero
SET Decimal_Cero    		:= 0.00;		-- DECIMAL Cero
SET Salida_SI       		:= 'S';			-- Salida en Pantalla SI
SET MovCrwCapVig			:= 1;			-- Movimiento Capital vigente
SET MovCrwCapEx			:= 2;			-- Movimiento Capital Exigible
SET	MovCrwCapCO			:= 3;			-- Movimiento capital cuentas de orden
SET MovCrwIntOrd			:= 10;			-- Movimiento interes ordinario
SET MovCrwIntCO			:= 16;			-- Movimiento interes en cuentas de orden
SET MovCrwIntMor			:= 15;			-- Movimiento interes Moratorio
SET MovCrwComFP			:= 40;			-- Movimiento Comision por Falta de Pago
SET MovCrwISRInt			:= 50;			-- Movimiento ISR Interes
SET MovCrwISRMora			:= 51;			-- Movimiento ISR Moratorios
SET MovCrwISRComFP			:= 52;			-- Movimiento ISR Comision por Falta de Pago
SET	TipoPrepago				:= 2;

/*Inicializacion*/
SET Par_NumErr  			:= Entero_Cero;
SET Par_ErrMen  			:= Cadena_Vacia;
SET Aud_FechaActual 		:= NOW(); 		-- Seteamos la fecha actual
SET	Var_MontoIntProv		:= Decimal_Cero;
SET	Var_MontoCapVig			:= Decimal_Cero;
SET	Var_MontoCapExi			:= Decimal_Cero;
SET	Var_MontoMora			:= Decimal_Cero;
SET	Var_MontoComFal			:= Decimal_Cero;
SET	Var_MontoRetMora		:= Decimal_Cero;
SET	Var_MontoCapCO			:= Decimal_Cero;
SET	Var_MontoIntCO			:= Decimal_Cero;
SET	Var_MontoISRInt			:= Decimal_Cero;
SET	Var_MontoRetComFal		:= Decimal_Cero;

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-CRWDETALLEPAGINVPRO");
        END;

    SET Var_CreditoID 	:= (SELECT CreditoID FROM CRWFONDEO WHERE SolFondeoID = Par_FondeoCrwID);
    SET	Var_CreditoID	:= IFNULL(Var_CreditoID, Decimal_Cero);

	SET	Var_TipoPago :=	(SELECT TipoPago FROM CRWPAGOCRERESUMEN
							WHERE CreditoID = Var_CreditoID
								AND Transaccion = Par_Transaccion AND FechaPago = Par_FechaPago);
	SET Var_TipoPago := IFNULL(Var_TipoPago, Entero_Cero);

	IF(Par_TipoMovCrwID 	 = MovCrwIntOrd) THEN
		SET	Var_MontoIntProv  	:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwISRInt)THEN
		SET	Var_MontoISRInt  	:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwCapVig) THEN
		SET	Var_MontoCapVig		:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwCapEx) THEN
		SET Var_MontoCapExi		:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwIntMor) THEN
		SET Var_MontoMora		:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwISRMora) THEN
		SET	Var_MontoRetMora	:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwComFP) THEN
		SET	Var_MontoComFal		:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwISRComFP) THEN
		SET	Var_MontoRetComFal	:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwIntCO) THEN
		SET	Var_MontoIntCO		:= Par_MontoPago;
	ELSEIF(Par_TipoMovCrwID = MovCrwCapCO) THEN
		SET	Var_MontoCapCO		:= Par_MontoPago;
	END IF;

	IF NOT EXISTS(SELECT Transaccion FROM CRWDETALLEPAGINV
				WHERE SolFondeoID = Par_FondeoCrwID AND AmortizacionID = Par_AmortizacionID
					AND Transaccion = Par_Transaccion AND Fecha = Par_FechaPago) THEN

		INSERT INTO CRWDETALLEPAGINV(
			SolFondeoID,	AmortizacionID,		Transaccion,		CreditoID,		Fecha,
			MontoTotal,		CapitalVigente,		CapitalExigible,	CapitalCO,		Interes,
			InteresCO,		InteresMoratorio,	ComFaltaPago,		ISRInt,			ISRMoratorio,
			ISRComision,	TipoPago,			NumInversiones,		NumInvPagadas,	NumInvAPagar,
			EmpresaID,		Usuario,			FechaActual,		DireccionIP,	ProgramaID,
			Sucursal,		NumTransaccion
		)VALUES(
			Par_FondeoCrwID,	Par_AmortizacionID,	Par_Transaccion,	Var_CreditoID,		Par_FechaPago,
			Par_MontoPago,		Var_MontoCapVig,	Var_MontoCapExi,	Var_MontoCapCO,		Var_MontoIntProv,
			Var_MontoIntCO,		Var_MontoMora,		Var_MontoComFal,	Var_MontoISRInt,	Var_MontoRetMora,
			Var_MontoRetComFal,	Var_TipoPago,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
			Par_EmpresaID, 		Aud_Usuario,		Aud_FechaACtual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		);
	ELSE

		UPDATE CRWDETALLEPAGINV
			SET MontoTotal 		 = (MontoTotal 		+ Par_MontoPago),	CapitalVigente 	= (CapitalVigente 	+ Var_MontoCapVig),
				CapitalExigible	 = (CapitalExigible + Var_MontoCapExi),	CapitalCO 		= (CapitalCO 		+ Var_MontoCapCO),
				Interes 		 = (Interes 		+ Var_MontoIntProv),InteresCO 		= (InteresCO 		+ Var_MontoIntCO),
				InteresMoratorio = (InteresMoratorio+ Var_MontoMora),	ComFaltaPago 	= (ComFaltaPago 	+ Var_MontoComFal),
				ISRInt			 = (ISRInt 			+ Var_MontoISRInt),	ISRMoratorio 	= (ISRMoratorio 	+ Var_MontoRetMora),
				ISRComision 	 = (ISRComision 	+ Var_MontoRetComFal),
				EmpresaID   = Par_EmpresaID, 	Usuario 	= Aud_Usuario, 		FechaActual = Aud_FechaActual,
				DireccionIP = Aud_DireccionIP,	ProgramaID 	= Aud_ProgramaID,	Sucursal 	= Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion
			WHERE SolFondeoID = Par_FondeoCrwID AND AmortizacionID = Par_AmortizacionID
					AND Transaccion = Aud_NumTransaccion AND Fecha = Par_FechaPago;
	END IF;
END;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen;
ELSE
	SET Par_NumErr	:= 0;
    SET Par_ErrMen 	:= 'RESPALDO DE PAGO EXITOSO';
END IF;

END TerminaStore$$
