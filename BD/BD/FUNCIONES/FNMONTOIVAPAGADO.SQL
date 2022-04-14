-- Funcion FNMONTOIVAPAGADO

DELIMITER ;

DROP FUNCTION IF EXISTS FNMONTOIVAPAGADO;

DELIMITER $$

CREATE FUNCTION FNMONTOIVAPAGADO(
-- FUNCION QUE CONSULTA EL MONTO DE IVA PAGADO EN UN PAGO DE CREDITO
	Par_CreditoID			BIGINT(20),				-- Identificador de un Credito
	Par_AmortizacionID		INT(11),				-- Identificador de una amortizacion
	Par_FechaPago			DATE,					-- Fecha en la que se realizo el pago
	Par_Transaccion			BIGINT(20),				-- Numero de transaccion del pago de credito
	Par_NumCon				TINYINT UNSIGNED		-- Numero de consulta
) RETURNS DECIMAL(14,2)
	DETERMINISTIC
BEGIN

-- Declaracion de constantes
DECLARE Entero_Cero			INT(11);				-- Entero Cero
DECLARE Entero_Uno			INT(11);				-- Entero Uno
DECLARE Fecha_Vacia			DATE;					-- Fecha Vacia
DECLARE Cadena_Vacia		CHAR(1);				-- Cadena vacia
DECLARE Var_CadenaSi		CHAR(1);				-- Cadena Si
DECLARE Var_CadenaNo		CHAR(1);				-- Cadena No

DECLARE Var_TipoMovIvaInt	INT(11);				-- Tipo de movimiento por iva de interes
DECLARE Var_TipoMovIvaMor	INT(11);				-- Tipo de movimiento por iva de moratorio
DECLARE Var_NatAbono		CHAR(1);				-- Naturaleza Abono
DECLARE Var_ConIvaIntOrd	TINYINT UNSIGNED;		-- Consulta de iva de interes ordinario pagado
DECLARE Var_ConIvaMorato	TINYINT UNSIGNED;		-- Consulta de iva de moratorio

-- Declaracion de variables
DECLARE Var_Monto			DECIMAL(14,2);			-- Monto a devolver

-- Asignacion de constantes
SET Entero_Cero				:= 0;					-- Entero Cero
SET Entero_Uno				:= 1;					-- Entero Uno
SET Cadena_Vacia			:= '';					-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
SET Var_CadenaSi			:= 'S';					-- Cadena Si
SET Var_CadenaNo			:= 'N';					-- Cadena No

SET Var_TipoMovIvaInt		:= 20;					-- Tipo de movimiento por iva de interes
SET Var_TipoMovIvaMor		:= 21;					-- Tipo de movimiento por iva de moratorio
SET Var_NatAbono			:= 'A';					-- Naturaleza Abono
SET Var_ConIvaIntOrd		:= 1;					-- Consulta de iva de interes ordinario pagado
SET Var_ConIvaMorato		:= 2;					-- Consulta de iva de moratorio

SET Par_CreditoID		:= IFNULL(Par_CreditoID, Entero_Cero);
SET Par_AmortizacionID	:= IFNULL(Par_AmortizacionID, Entero_Cero);
SET Par_FechaPago		:= IFNULL(Par_FechaPago, Fecha_Vacia);
SET Par_Transaccion		:= IFNULL(Par_Transaccion, Entero_Cero);
SET Par_NumCon			:= IFNULL(Par_NumCon, Entero_Cero);

DELETE FROM TMPFNMONTOIVAPAGADO
	WHERE CreditoID = Par_CreditoID
	  AND AmortizacionID = Par_AmortizacionID
	  AND NumTransaccion = Par_Transaccion;

IF (Par_NumCon = Var_ConIvaIntOrd) THEN

	INSERT INTO TMPFNMONTOIVAPAGADO (	CreditoID,	AmortizacionID,	TipoMovCreID,	NatMovimiento,	Monto,		NumTransaccion	)
							SELECT		CreditoID,	AmortiCreID,	TipoMovCreID,	NatMovimiento,	Cantidad,	Transaccion
								FROM	CREDITOSMOVS
								WHERE	CreditoID = Par_CreditoID
								  AND	FechaOperacion = Par_FechaPago;

	SELECT		ROUND(SUM(ROUND(Monto, 2)), 2)
		INTO	Var_Monto
		FROM	TMPFNMONTOIVAPAGADO
		WHERE	CreditoID = Par_CreditoID
		  AND	AmortizacionID = Par_AmortizacionID
		  AND	TipoMovCreID = Var_TipoMovIvaInt
		  AND	NumTransaccion = Par_Transaccion
		  AND	NatMovimiento = Var_NatAbono;

END IF;

IF (Par_NumCon = Var_ConIvaMorato) THEN

	INSERT INTO TMPFNMONTOIVAPAGADO (	CreditoID,	AmortizacionID,	TipoMovCreID,	NatMovimiento,	Monto,		NumTransaccion	)
							SELECT		CreditoID,	AmortiCreID,	TipoMovCreID,	NatMovimiento,	Cantidad,	Transaccion
								FROM	CREDITOSMOVS
								WHERE	CreditoID = Par_CreditoID
								  AND	FechaOperacion = Par_FechaPago;

	SELECT		ROUND(SUM(ROUND(Monto, 2)), 2)
		INTO	Var_Monto
		FROM	TMPFNMONTOIVAPAGADO
		WHERE	CreditoID = Par_CreditoID
		  AND	AmortizacionID = Par_AmortizacionID
		  AND	TipoMovCreID = Var_TipoMovIvaMor
		  AND	NumTransaccion = Par_Transaccion
		  AND	NatMovimiento = Var_NatAbono;

END IF;

SET Var_Monto	:= IFNULL(Var_Monto, Entero_Cero);

DELETE FROM TMPFNMONTOIVAPAGADO
	WHERE CreditoID = Par_CreditoID
	  AND AmortizacionID = Par_AmortizacionID
	  AND NumTransaccion = Par_Transaccion;

RETURN Var_Monto;

END$$