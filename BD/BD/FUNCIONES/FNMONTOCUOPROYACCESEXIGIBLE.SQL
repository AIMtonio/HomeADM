-- FNMONTOCUOPROYACCESEXIGIBLE

DELIMITER ;

DROP FUNCTION IF EXISTS `FNMONTOCUOPROYACCESEXIGIBLE`;

DELIMITER $$

CREATE FUNCTION `FNMONTOCUOPROYACCESEXIGIBLE`(
-- FUNCION QUE CALCULA EL MONTO E IVA DE LOS ACCESORIOS EXIGIBLES
-- SE OCUPA EN EL PROCESO DE PREPAGO DE PROYECCION DE CUOTAS COMPLETAS
	Par_CreditoID		BIGINT(12),	    -- Credito ID
	Par_AmorInicial 	INT(11),		-- Amortizacion ID Inicial
    Par_AmorFinal    	INT(11),		-- Amortizacion ID Final
	Par_TipoProceso 	CHAR(1)	        -- Tipo de Proceso M: Monto  I: IVA
) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_Monto 			DECIMAL(14,2);
DECLARE Var_SucCredito      INT(11);			-- Variable Sucursal del Cliente
DECLARE Var_ValIVAGen 	    DECIMAL(12,2);      -- Variable Valor IVA de Interes Ord
DECLARE Var_FechaSistema	DATE;				-- Variable para almacenar la fecha del sistema

-- DECLARACION DE CONSTANTES
DECLARE Entero_Cero     	INT(11);			-- Constante Entero Cero 0
DECLARE Decimal_Cero     	DECIMAL(12,4);		-- Constante Deciaml Cero 0.0
DECLARE Cons_Si             CHAR(1);            -- Constante 'S'
DECLARE Proces_Monto        CHAR(1);            -- Constante 'M' Proceso para sacar el Monto de los Accesorios
DECLARE Proces_IVA          CHAR(1);            -- Constante 'I' Proceso para sacar el IVA de los Accesorios
DECLARE Proces_Int			CHAR(1);			-- Constante 'R' Proceso para sacar el Interes de los Accesorios
DECLARE Proces_IvaInt		CHAR(1);			-- Constante 'M' Proceso para sacar el IVA de Interes de los Accesorios
DECLARE Var_Financiamiento  CHAR(1);            -- Forma de Cobro del Accesorio F: Financiamiento

-- ASIGNACION DE CONSTANTES
SET Entero_Cero         := 0;
SET Decimal_Cero        := 0.0;
SET Cons_Si             := 'S';
SET Proces_Monto        := 'M';
SET Proces_IVA          := 'I';
SET Proces_Int			:= 'R';
SET Proces_IvaInt		:= 'G';
SET Var_Financiamiento  := 'F';


SET Var_SucCredito := (SELECT SucursalID FROM CREDITOS WHERE CreditoID = Par_CreditoID );

SET	Var_ValIVAGen	:= (SELECT IVA
                            FROM SUCURSALES
                                WHERE  SucursalID = Var_SucCredito);
SET Var_ValIVAGen   := IFNULL(Var_ValIVAGen,Decimal_Cero);

IF(Par_TipoProceso = Proces_Monto)THEN

	SELECT		ROUND(SUM(ROUND(DET.MontoCuota, 2) - ROUND(DET.MontoPAgado, 2)), 2)
		INTO	Var_Monto
		FROM	DETALLEACCESORIOS DET
		INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID
									 AND DET.AmortizacionID = AMO.AmortizacionID
									 AND AMO.FechaExigible <= Var_FechaSistema
		WHERE	DET.CreditoID = Par_CreditoID
		  AND	DET.AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal;

END IF;

IF(Par_TipoProceso = Proces_IVA)THEN

	SELECT		ROUND(ROUND(SUM(ROUND(DET.MontoCuota, 2) - ROUND(DET.MontoPAgado, 2)), 2) * Var_ValIVAGen, 2)
		INTO	Var_Monto
		FROM	DETALLEACCESORIOS DET
		INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID
									 AND DET.AmortizacionID = AMO.AmortizacionID
									 AND AMO.FechaExigible <= Var_FechaSistema
		WHERE	DET.CreditoID = Par_CreditoID
		  AND	DET.AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal
		  AND	DET.CobraIVA = Cons_Si AND DET.TipoFormaCobro = Var_Financiamiento;

END IF;

IF(Par_TipoProceso = Proces_Int)THEN

	SELECT		ROUND(ROUND(SUM(ROUND(DET.MontoIntCuota, 2) - ROUND(DET.MontoPAgado, 2)), 2) * Var_ValIVAGen, 2)
		INTO	Var_Monto
		FROM	DETALLEACCESORIOS DET
		INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID
									 AND DET.AmortizacionID = AMO.AmortizacionID
									 AND AMO.FechaExigible <= Var_FechaSistema
		WHERE	DET.CreditoID = Par_CreditoID
		  AND	DET.AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal;

END IF;

IF(Par_TipoProceso = Proces_IvaInt)THEN

	SELECT		ROUND(ROUND(SUM(ROUND(DET.MontoIntCuota, 2) - ROUND(DET.MontoIntPagado, 2)), 2) * Var_ValIVAGen, 2)
		INTO	Var_Monto
		FROM	DETALLEACCESORIOS DET
		INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID
									 AND DET.AmortizacionID = AMO.AmortizacionID
									 AND AMO.FechaExigible <= Var_FechaSistema
		WHERE	DET.CreditoID = Par_CreditoID
		  AND	DET.AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal
		  AND	DET.CobraIVAInteres = Cons_Si AND DET.TipoFormaCobro = Var_Financiamiento;

END IF;

SET Var_Monto	:= IFNULL(Var_Monto, Entero_Cero);

RETURN Var_Monto;

END$$