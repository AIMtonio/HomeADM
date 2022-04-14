-- Funcion FNEXIGEDOMICILIACRE

DELIMITER ;

DROP FUNCTION IF EXISTS FNEXIGEDOMICILIACRE;

DELIMITER $$

CREATE FUNCTION `FNEXIGEDOMICILIACRE`(
	-- Funcion para obtener la exigibilidad para la Domiciliacion de Pagos de Creditos que no son de Nomina.
    Par_CreditoID   BIGINT(12)		-- Numero de Credito

) RETURNS DECIMAL(14,2)
    DETERMINISTIC
BEGIN

	-- Declaracion de Variables
	DECLARE Var_FecActual   	DATE;			-- Almacena la Fecha del Sistema
	DECLARE Var_MontoExigible	DECIMAL(14,2);	-- Almacena el Monto Exigible
	DECLARE Var_AmortizacionID	INT(11);		-- Almacena el Numero de Amortizacion
	DECLARE Var_MontoPago 		DECIMAL(14,2);	-- Monto de Pago

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
    DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE	Entero_Tres			INT(11);

	DECLARE	EstatusPagado		CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:= 0;				-- Entero Cero
	SET Decimal_Cero		:= 0.0;				-- Decimal Cero
	SET	Entero_Tres			:= 3;				-- Entero Tres

    SET	EstatusPagado		:= 'P';				-- Estatus Pagado

    -- Asignacion de Variables
    SET Var_MontoPago		:= 0.0;				-- Monto Pago

	-- Se obtiene la Fecha del Sistema
	SELECT FechaSistema INTO Var_FecActual FROM PARAMETROSSIS;

	-- Se obtiene la cuota minima de la amortizacion del credito
	SELECT MIN(AmortizacionID) INTO Var_AmortizacionID
	FROM AMORTICREDITO
	WHERE CreditoID   = Par_CreditoID
	  AND FechaExigible >= Var_FecActual
	  AND Estatus	!= EstatusPagado;

	SET Var_AmortizacionID := IFNULL(Var_AmortizacionID, Entero_Cero);

	IF (Var_AmortizacionID != Entero_Cero) THEN
		-- Se obtiene el Monto del Capital, Interes e Iva de Interes
		SELECT (ROUND(Capital, 2) + ROUND(Interes, 2) + ROUND(IVAInteres, 2))
		INTO Var_MontoExigible
		FROM AMORTICREDITO
		WHERE CreditoID      = Par_CreditoID
		  AND AmortizacionID = Var_AmortizacionID
		  AND Estatus		   != EstatusPagado;

		SET Var_MontoExigible   := IFNULL(Var_MontoExigible, Decimal_Cero);
		SET Var_MontoPago		:= Var_MontoExigible;

	END IF;

	RETURN Var_MontoPago;

END$$