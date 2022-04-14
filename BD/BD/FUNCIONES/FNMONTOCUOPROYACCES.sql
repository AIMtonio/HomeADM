-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNMONTOCUOPROYACCES
DELIMITER ;
DROP FUNCTION IF EXISTS `FNMONTOCUOPROYACCES`;
DELIMITER $$

CREATE FUNCTION `FNMONTOCUOPROYACCES`(
/** ========================================================
 ** -- FUNCION QUE CALCULA EL MONTO E IVA DE LOS ACCESORISO ------
 ** -- SE OCUPA EN EL PROCESO DE PREPAGO DE PROYECCION -----
 ** -- DE CUOTAS COMPLETAS ---------------
 ** ======================================================== */
	Par_CreditoID		BIGINT(12),	    -- Credito ID
	Par_AmorInicial 	INT(11),		-- Amortizacion ID Inicial
    Par_AmorFinal    	INT(11),		-- Amortizacion ID Final
	Par_TipoProceso 	CHAR(1)	        -- Tipo de Proceso M: Monto  I: IVA
) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_MontoAccesorio 	DECIMAL(14,2);
DECLARE Var_SucCredito      INT(11);			-- Variable Sucursal del Cliente
DECLARE Var_ValIVAGen 	    DECIMAL(12,2);      -- Variable Valor IVA de Interes Ord

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
    SELECT SUM(ROUND(MontoCuota - MontoPAgado,2))
    INTO Var_MontoAccesorio
	FROM  DETALLEACCESORIOS
	WHERE CreditoID = Par_CreditoID
	 AND AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal;

END IF;

IF(Par_TipoProceso = Proces_IVA)THEN
    SELECT  (SUM(MontoCuota) - SUM(MontoPAgado) ) * Var_ValIVAGen
    INTO Var_MontoAccesorio
	FROM  DETALLEACCESORIOS
	WHERE CreditoID = Par_CreditoID
	 AND AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal
    AND CobraIVA = Cons_Si AND TipoFormaCobro = Var_Financiamiento;

END IF;

IF(Par_TipoProceso = Proces_Int)THEN
	SELECT		SUM(ROUND(MontoIntCuota - MontoIntPagado, 2))
		INTO	Var_MontoAccesorio
		FROM 	DETALLEACCESORIOS
		WHERE	CreditoID = Par_CreditoID
		  AND	AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal;

END IF;

IF(Par_TipoProceso = Proces_IvaInt)THEN
	SELECT		(SUM(MontoIntCuota) - SUM(MontoIntPagado) ) * Var_ValIVAGen
		INTO	Var_MontoAccesorio
		FROM 	DETALLEACCESORIOS
		WHERE	CreditoID = Par_CreditoID
		  AND	AmortizacionID BETWEEN Par_AmorInicial AND Par_AmorFinal
		  AND	CobraIVAInteres = Cons_Si AND TipoFormaCobro = Var_Financiamiento;

END IF;

RETURN Var_MontoAccesorio;
END$$